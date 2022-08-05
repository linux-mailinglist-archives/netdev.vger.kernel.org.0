Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E215458AF1A
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 19:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241132AbiHERof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 13:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241056AbiHERo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 13:44:26 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2135.outbound.protection.outlook.com [40.107.243.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1244C635;
        Fri,  5 Aug 2022 10:44:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m8NCRwHD/rFsVgs+til7iSswJo92ef4AwV1Jcdxq1i5AEgys5niZz36TzFPUrPdORUxdbIxgATbXa2arxiYWoLYQjxKc9a8wg54ia8Yqjhb1ZeoFadlXCSqVsk0JrNCc7f4rKkaxWc3IKHE/ooltVn4P2kwqgECL2MwSC0gM1R8nxI13h1ksh0S/bpUSzkH8n9axkp7dhqR9t/xybxxKJUg6+dK0eOIeSqBeWP3GKsGl6MdrESpn2nzTSGXfSuMyJCDE7FXSXvsKHRRyR+pp59wtoIt09WQqNPOEbgDy+XDigTdXcn4ZBepeA5vNjgVGKq69pwCFKhQgSOP8X6eWkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QsEtY3GzOtxiszUC4FCHty6GQFLGwk9JugSvAOBQdOo=;
 b=dJQYoIMIBEutVIB7QRs+QsSWQroO8DI2yIcwHpS2pP94re/g47oPo37DMNjYoX9H6IyBNCfKs+wdwbS2qg5vJq1wS9S++2gyL9KXS2HQfBX6vVIVRVb49QFD1wp3yKalz8bVHQkaGso6dC+jUvyPlqwjC17fl6w9RNILTf35Y9G+I/I7e/i/9eSbWYGzZTPFV7izqN9CYxnTkhwBHos0iejm5rWw0zslGjIF67J8HwDH1AJseck18yBgyQ/hhaBSvXIP8ewhpkOHj61US2ciWujy3iO4HhcFFtIwa7iqQLv8QeVBuO2PfEgYreY4Yc2t2JB0TmOwRhw5G/xP43ikRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QsEtY3GzOtxiszUC4FCHty6GQFLGwk9JugSvAOBQdOo=;
 b=XWeSbT0uRcRPKZwY6h45bfFh0pQIs9JS3K/IHrg9hlNrP0y9xNdiAVCWk6Oj/WiFAxPoNAZeynJvseh1W/gIPPUUhYWRCnufmhWS3t9Cvq0XhvcU1vyzAmsKXQn8BEYWZBdhOfxuEiDWobN0vFofvlGyEtU3gCgHYE06AqryTKQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN0PR10MB4997.namprd10.prod.outlook.com
 (2603:10b6:408:12b::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Fri, 5 Aug
 2022 17:44:21 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5482.017; Fri, 5 Aug 2022
 17:44:21 +0000
Date:   Fri, 5 Aug 2022 10:44:16 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        UNGLinuxDriver@microchip.com,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Subject: Re: [PATCH v15 mfd 9/9] mfd: ocelot: add support for the vsc7512
 chip via spi
Message-ID: <Yu1W8DMaP8xlyyr5@euler>
References: <20220803054728.1541104-1-colin.foster@in-advantage.com>
 <20220803054728.1541104-10-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220803054728.1541104-10-colin.foster@in-advantage.com>
X-ClientProxiedBy: BYAPR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::42) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f907d0a-9034-4189-aa4d-08da770a20d9
X-MS-TrafficTypeDiagnostic: BN0PR10MB4997:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AXoWU+PbaMdCK/ulwpRmPm8ti18OTEKqsBORoM3LYXfHtAyqP3gXZWGKKlaLEJ2y8dHO5wt1CvBbMaCAOfLWdPCP8l1cnAuuvy71CHF4UxKGu1ThwXuhtQF2S/q71kmMv6tl+ThBL3K7Bex8WtIe1UWmHmaTLUMjoa3o2i0+t7RV5TbTqA9goLXxx6X9pvDNaDGQjWDoIS9VTdk5Aa3PuRuzdzX0zTAzvAzuhRicTwd0FYqvSpL5kBBJACPBlzLNmB2sgdc7lCex+x9UyeRVLIDKmyK+HIGK5YA5Peeht67+zTfM4AC7zwCdgVRCnQfYh4o+lACfnZLkd6j99TlKmKBTI0HNJtbPRAB1AigjicWtHhAejxeB/cGSxktMz8KgKJf7OLr7gTF5MvIkj8/pWy+062iqkugkZn2NNhdOmfIS/b8LhTTo+S0obTybj7+P1HUWAAHU6fq0LrVZr4BXa1uxopfSUewdHbe/cCH7gt1+OKVIrPzIYxiQjtzC1WjARlA1MWaxJrKy6nDy/N28rZhgkAz2MX3ZiPDUax2ANYlUcqlgK44xN3ITgb63nYGftpH4CfVxZFK7QYFWTrpTfjP5hKEvf8P1TlOMIrmq0zJL0UTDfMYPlqJPRDIiNb1ldK3YllsEK277Qv1pr9UpWo4GL1vqaMYRK9SAl0K+aApiAGtVJ3v/DOus5JDCpT+AS495QgfhtZmXgvn22J15DRrg5Nr2E9O8DpAKpG9evWo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(376002)(346002)(136003)(39830400003)(396003)(366004)(2906002)(38100700002)(107886003)(44832011)(186003)(7416002)(6512007)(86362001)(26005)(9686003)(41300700001)(8936002)(6506007)(66556008)(6666004)(66476007)(4326008)(5660300002)(8676002)(66946007)(33716001)(6486002)(316002)(478600001)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TBftj6kwE6dkczrG2BXuQn/TQ+R0Mm951W2rqmatCP1fCL9adxX19GpBdyw/?=
 =?us-ascii?Q?pNwQ1wNTdqe0JiuOvvYFNU5iS5uW0Jh8K3lHe8z9gDyMKJSQBtMGGcMh1YFH?=
 =?us-ascii?Q?o2EE9SirzHi8P0+/3Oqu8/51A2rq3RfSEfY1f1e4VrE5O7lj4QzebfRp6I07?=
 =?us-ascii?Q?599Xa+isEDGJnZXASrbJ6OahBjMLOL59SECl71nJHsQYvPiwuYlrcqX87z4f?=
 =?us-ascii?Q?ir0Ys+yXUR8vajTllrgcb2NqVZyvLM+Xq9bbqFeOjwmIMA/sOHIpMbCsstms?=
 =?us-ascii?Q?vjaqIczMFOqTzQlZKZDQfykuytCEkdZyLAx1Dd1aJQI0tFBaoqcxXZ0zvXBV?=
 =?us-ascii?Q?g8XRAHV9dPLbBlgTvYyJCwHgLqe4BqWQ2sg8EyJZ1NZenmxKYKwRVQQ8v/co?=
 =?us-ascii?Q?4dMy5+17SEa/rTNfcy/lwJchsceoUy2qMu7tMb7giv4bLq+vFrEYGkkpcDT5?=
 =?us-ascii?Q?7yGeS4vJQVBes/gi6g4e/BEyLcY/pEhAR4kKPMB9XRwGH8tQYB2P4/I8P2Dy?=
 =?us-ascii?Q?UN7eNOTCDuu1sSB9+xhbxPE6PHHE+yO7dncS+wXQiU6zT8fWSPhApggjsxOp?=
 =?us-ascii?Q?AyBMaU14TKqaEEAh8VIBxsCR+DsfL47qSaY8kIk7XH3F/LRcD2zJgDmd0pDi?=
 =?us-ascii?Q?lQ0D8v7tDDGpZrs4EC+jVxG6a2PpuzbDVxn90T5jQ7QoCDVI/ZfbeDJwOZpm?=
 =?us-ascii?Q?jt7x0P6I94rjx2cLZJi3d47R2Uyd+CAeH+eAhBmr2ug4Zy0bd7Qqkt2AUF68?=
 =?us-ascii?Q?Li+1MTFIaKhnW5IrT2aqwYHdrWEqMFv0/TsbEIKwCn/cxWajw1GKFGiBhsvh?=
 =?us-ascii?Q?Z5jR2Y80sCFdQLMXikALHoMqAeW52Z3nb5btAg+0PM1ui7WHJHb6oNRcr0cq?=
 =?us-ascii?Q?j6ajr/7aFvOCzGQIcW542uROhfvPQgme5w8lu6J4M7PKCyme2NdAR4XZcqFP?=
 =?us-ascii?Q?ybAmbyb68Dzb/gTFj41t6mCW6Nw8G8qI4uBia1L5l9Cg9vGM+KlJuUr2GgZL?=
 =?us-ascii?Q?AS1B/2X0btxBaGYAQaouSwIvzXuN1djMB17eAZlQiAr1BcglRP+kOktRPnBb?=
 =?us-ascii?Q?xEZdMHOS6bsY2RyQKvCec4BJKtRVaFd9WHZXBKdVNzlvouNYuGCojX/7VRTd?=
 =?us-ascii?Q?ZGAa0tp7pbpVIlwdp1Gqgvun5OA/Rb41mlaumjS3wf+BHYuUI7hO8KCgLdW+?=
 =?us-ascii?Q?ZGmb1rFMwA89oW5ujWoL7UK+crTgqh88wpFk9DOhp8t0yUXvsNZ765g9bXy4?=
 =?us-ascii?Q?c2Q1LmjiUu3rM0MZNqC1n27kYgUZhx7ZNEZciV+9L9Y5c99zoVgJTwRnCL63?=
 =?us-ascii?Q?YivqMhfgEHut41D51MyDRau3uYewOpW8tDdY3n4OAGMlyjvseG5897SflHtA?=
 =?us-ascii?Q?J2x8XfC1mSAnFYlzfaAWPNpwlAX6t74O1nKXX7FVbMOMNpR7Lq5mExo1GPdj?=
 =?us-ascii?Q?l5THWmXQqwPcinV18mm7wcialxSdE3pkUtzRq/XsS+d9LGOqmSj1p4kyLDzR?=
 =?us-ascii?Q?YN59hP99lVBizzlahjGS20gFzlxa3FsQvxnJJFp7F2oynw/ouRTfypxvJa4f?=
 =?us-ascii?Q?b63k/BdOLB1FkRaUryXinT6DywQjAQNepMHHorD4H+v86icWqqv5IR2wMjhV?=
 =?us-ascii?Q?uA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f907d0a-9034-4189-aa4d-08da770a20d9
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2022 17:44:21.4141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wJip3s6b/P7yw/8U+7QUGPy0M7/bzBu6Kr4Hx8S0p+vQevqNOGcOuaQNFH2PefpNOJUSttqrI+S91zWVeO6r4EN6d/Jd7PBTBJBQYM63GWM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4997
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As I'm going through Andy's suggestions, I came across a couple more
include changes / misses:

On Tue, Aug 02, 2022 at 10:47:28PM -0700, Colin Foster wrote:

...

> diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c

...

> +
> +int ocelot_chip_reset(struct device *dev)

#include <linux/device.h>

> +{
> +	struct ocelot_ddata *ddata = dev_get_drvdata(dev);
> +	int ret, val;
> +
> +	/*
> +	 * Reset the entire chip here to put it into a completely known state.
> +	 * Other drivers may want to reset their own subsystems. The register
> +	 * self-clears, so one write is all that is needed and wait for it to
> +	 * clear.
> +	 */
> +	ret = regmap_write(ddata->gcb_regmap, REG_GCB_SOFT_RST, BIT_SOFT_CHIP_RST);
> +	if (ret)
> +		return ret;
> +
> +	return readx_poll_timeout(ocelot_gcb_chip_rst_status, ddata, val, !val,
> +				  VSC7512_GCB_RST_SLEEP_US, VSC7512_GCB_RST_TIMEOUT_US);

#include <linux/iopoll.h>

> +}
> +EXPORT_SYMBOL_NS(ocelot_chip_reset, MFD_OCELOT);

#include <linux/export.h>

> +
> +static const struct resource vsc7512_miim0_resources[] = {
> +	DEFINE_RES_REG_NAMED(VSC7512_MIIM0_RES_START, VSC7512_MIIM_RES_SIZE, "gcb_miim0"),
> +	DEFINE_RES_REG_NAMED(VSC7512_PHY_RES_START, VSC7512_PHY_RES_SIZE, "gcb_phy"),
> +};

#include <linux/ioport.h>

...

> +++ b/drivers/mfd/ocelot-spi.c

...

> +#include <linux/kconfig.h>

Not needed here - handled entirely in drivers/mfd/ocelot.h now.

...

> +
> +static int ocelot_spi_initialize(struct device *dev)

#include <linux/device.h>

> +{
> +	struct ocelot_ddata *ddata = dev_get_drvdata(dev);
> +	u32 val, check;

#include <linux/types.h>

...

> +
> +	if (check != val)
> +		return -ENODEV;

#include <linux/errno.h>

> +
> +	return 0;
> +}

...

> +
> +struct regmap *ocelot_spi_init_regmap(struct device *dev, const struct resource *res)
> +{
> +	struct regmap_config regmap_config;
> +
> +	memcpy(&regmap_config, &ocelot_spi_regmap_config, sizeof(regmap_config));
> +
> +	regmap_config.name = res->name;
> +	regmap_config.max_register = res->end - res->start;
> +	regmap_config.reg_base = res->start;
> +
> +	return devm_regmap_init(dev, &ocelot_spi_regmap_bus, dev, &regmap_config);
> +}
> +EXPORT_SYMBOL_NS(ocelot_spi_init_regmap, MFD_OCELOT_SPI);

#include <linux/export.h>

...

> +
> +	r = ocelot_spi_init_regmap(dev, &vsc7512_dev_cpuorg_resource);
> +	if (IS_ERR(r))
> +		return PTR_ERR(r);

#include <linux/err.h>

...

> +
> +static const struct spi_device_id ocelot_spi_ids[] = {

#include <linux/mod_devicetable.h>

> +	{ "vsc7512", 0 },
> +	{ }
> +};
> +
> +static const struct of_device_id ocelot_spi_of_match[] = {
> +	{ .compatible = "mscc,vsc7512" },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, ocelot_spi_of_match);
