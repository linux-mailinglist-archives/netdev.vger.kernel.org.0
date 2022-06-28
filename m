Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 533AA55EAFD
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 19:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232976AbiF1RZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 13:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232974AbiF1RZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 13:25:34 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2127.outbound.protection.outlook.com [40.107.237.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D3639836;
        Tue, 28 Jun 2022 10:25:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PrSSRalkLn3y6ZA2bwTB/ZoxjoB2wp/kWbA7xOAxmzHjIt47Upd5Xgd359m6kxvazpBkHJJX6bbkxOPtsGdi1EBO7uTMtOoK76OBM5Iu75UM+NB6tBg54pRfZL6J9ItGIAlGuh8BZmI8eSgQcIsGwY8hM2VP0xf1NgvdK9/jYobgiCKKEQjDOseN1EcEIjeyQ6MAX+4mpZe1ZjmV6tR+oE872QGtPtdcoWboKMlPyOibnT/xN7oT7JVmP1kTkZZ6BpVniefog+5uVamBGc/dbXvOA/AZ0sgUq5xdRPPpzg+GfAs1oXvPsRhPsLvsZmbrmqssxRRZxHEqs4+mmvcRzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XerrAoZxG2F/o4A5m3BG3FeOSqaa26n887f1GCfEBCg=;
 b=LpMfcUdLvr/iF3kVrOAz1cUxZh2kPJqoNCUfJEltCD+GNtAgXRa9MUB7tDW+2YPjRtTLDK9Ztgr5c1IeBfMj4SdPT3mjr2YAUnJeZNRWEPO0cZ0rXLmiMsR6kjaKIndyvcuhBoKdI+/hP+mM2tUW8TL8vZ0hFyCtlrHSne5mOT3Ry+ObDEiIU6i++r53+AQegfCNCNvTKIQLymJ8KBwGdVjGZW+gALPrCKAGhGuuuN6ecpuijKLaNB9Ke6Tcq8pstaISY6+Ybu1k3BM+V2ieaizLUCcpi4w4M9kCpvMyefWEln2SQrb3j6o55zQOZ+MxT1Ur+gH8Y5rRIyzVmaVLoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XerrAoZxG2F/o4A5m3BG3FeOSqaa26n887f1GCfEBCg=;
 b=TkEfCQ4vdrXQBFdoW6RcxO/TtnswoaxHKnXQ8riCOLGDygMyyB3FT+GaiEYtZrRiJWP92S18fb7xeD3+XoRaUN5SQBq2Z4BWd9tsrx0gafpPWRCEhXzGNZd1Y72eO/XVPtAaz0h2ycliLmQdrJ9wjAa4TGAtd7Kspirq9QJjGLs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH2PR10MB4263.namprd10.prod.outlook.com
 (2603:10b6:610:a6::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Tue, 28 Jun
 2022 17:25:29 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 17:25:29 +0000
Date:   Tue, 28 Jun 2022 10:25:18 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Arnd Bergmann <arnd@kernel.org>
Subject: Re: [PATCH v11 net-next 1/9] mfd: ocelot: add helper to get regmap
 from a resource
Message-ID: <20220628172518.GA855398@euler>
References: <20220628081709.829811-1-colin.foster@in-advantage.com>
 <20220628081709.829811-2-colin.foster@in-advantage.com>
 <20220628160809.marto7t6k24lneau@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628160809.marto7t6k24lneau@skbuf>
X-ClientProxiedBy: CO2PR05CA0108.namprd05.prod.outlook.com
 (2603:10b6:104:1::34) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: afaaf05c-bd73-43be-40e6-08da592b3258
X-MS-TrafficTypeDiagnostic: CH2PR10MB4263:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gjoXb5PqL6SfnjYDpYlMe4aUoc9qOvXHqDuQln4Up9Efz61OQgpeby9KmDzyddUSG4NaKkHOa49StGWEpmZe8ELbf+Xe9kivYWJE9xrXcwMR9H5c4nY9YS1G/5KBmLf1SoO+mZQwK35BrG5BejSyBW9aMqkWTPYJYMHIGJ+BwUjIIQOg8Jcx1PcoBk7PUyriV+4TwzAy/7sWmoGIQ4FTwRIL4AhcmSe2MNAuH54lu6qF4OBuzx6JKhffmcx0tGRlRbkkqefkYUxrWdhfm1FShGQwcuxxhNjMLdTnVLEhe27g6LJoAonaPW1Bwf8lzVot7Nk1Ai2st1fs+e5yEtFhxu5qQmDRoDQZ/6Oo6tsMZMMqAWFovC7J0Qzp/DtWLRqmgBTEY+FFFcIBN9U5ULy9tDE7I1/Jq9WyRVUaUtiD6PJp19cfuodeI9uAS1wXCXmUBEeJKvYSXXDxln4SgBnBJnhHR22BthnDKU9nHrRteJB/1FLjga7Bk8YQz8ysIp987LUddFkUfcRUVl2kvx+Ucvr60EyvhjFqWZMGvhv6dASo0kqHZXcupQX6/khIM7mkg7daFNXXk0G8oJGKWPD5rAWOIapzFkVWDje62J97+GqMatbqmzMB+HUkUSw35YNv+zSAbg/kAzf0ulFi8Kl1DVT4MgrLFQJv+zgphwxLeAUAi9O0+HvsVwmMMIZ0aXsVVkdL9Hxh1HhejVO3bW4xP9D/nMasdTjppMflftOP2N9qB9lrqYd7iiOlAOE5kOABhKsX3+vLWshYfabUKvphUB1o+5QL1oPJ/1lWpxvK4xI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(376002)(346002)(136003)(39830400003)(396003)(33716001)(44832011)(54906003)(38350700002)(6666004)(6916009)(5660300002)(7416002)(26005)(38100700002)(2906002)(41300700001)(186003)(66946007)(66476007)(1076003)(33656002)(8936002)(8676002)(478600001)(66556008)(6506007)(6512007)(6486002)(9686003)(86362001)(52116002)(4326008)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ax3MLyluLNNdgSptoQNI0RBDNE9N8fqdCLf596gw67FCqQwA1JSZv1Bh4kRW?=
 =?us-ascii?Q?pgWvj4cqttOqcl36aJh5mJvp9WbLIA7jODKGUtdRaH5bFqKx+B408EYevGw7?=
 =?us-ascii?Q?11cFxb5eVKOBks/edsgiRdBv+Ikt0hvwRfijXRxAT6cN7ariTil/9gjGCXjN?=
 =?us-ascii?Q?DNXQe0toe2SjRF/gcKv56Gw+D/sBWM5quunrP97PehRz7lSzaoUWm0uipiH4?=
 =?us-ascii?Q?NvqIRrta3QBZ7Ejdsdv2E4lhSqHzzSoIP8z76OevKR0flfjf9xbbmHjp73/B?=
 =?us-ascii?Q?NsR0Nk+UCgODsjNHS0N1AJxpKYOpRUcJqhFIMHYH0GjBfe4e5bQ1HeYPEQh+?=
 =?us-ascii?Q?5DnLA79BwS4m/egQ+GIe9olXsLdP4FPeGC4GC9/PKHIucOdfZR77MHwGB0fY?=
 =?us-ascii?Q?IU0nc3HponucrhCAa9aH6H+8b7xDqygMYcrZu29RixRWEGtBuJyGXE6OBwwD?=
 =?us-ascii?Q?r/dYB9U3/5oWDYWxmkeLaHMxkiPdO17lhuXlMyarhBvLerM/qckGJbsGhlHk?=
 =?us-ascii?Q?vaAYXJsV1g4EuDkJ0ACiXVZq8WnKgIKNIHKl73Pdpzzwe3umho6WjypBghkk?=
 =?us-ascii?Q?W4B8+nkWuee0Yw4W7dBzrwhWyNGpKFl8ZrXUIRP6LkCgrgMqSj9OP08q5zXG?=
 =?us-ascii?Q?gxC4c3F7vtlu8x2fxVbIdbrXDIOvd3PyruoU/C7idb3E3h5+FJWNUKkHi2rx?=
 =?us-ascii?Q?DkXSNjgVAn0M3DePnYyBQkr/v51pc8GCtZ72o+kqwvfmt3CHYsrqEqG6gV2B?=
 =?us-ascii?Q?CFhCjTI9jQ1rC1kFTXEtyku0mXGlIrIbCQNCBDMQvcgj4r63+WBmvfGIQKCM?=
 =?us-ascii?Q?j2mCWDgLBZl2V2PTVb0i5jOme4TAwcbWO+zOkRMwJx1NK4SMnJEwy/jIfEJ+?=
 =?us-ascii?Q?Qb4gBsGz5UxtoKp0diGML2QOyLdwltdjHbq4uQ9pEPVFYrrn1lsfW9/tolCx?=
 =?us-ascii?Q?eSV32654NbIv58UJXkoKi+BriwJtVGCn1/MvfMAI95+S1Fe7msr4Pdqm7LIB?=
 =?us-ascii?Q?EQznElGvzs2akQLi9pRKfvz/t6AmGKDa3D4v0AlNUBiXrKJ7qxpmFYw0Qvj6?=
 =?us-ascii?Q?uqZ+tjGRCd7EuYwompFBxk9WP/ZC07eS1a+jOj7hd9lWoCA98DxFtxkmRutJ?=
 =?us-ascii?Q?OJkAfCXjz6wDO9arezFKi5P/PDWazNLXv7I2vV1Phiasdg0sZYBRaDvUGZyg?=
 =?us-ascii?Q?iEN3qmPgTDRsDpAd7ySPaJCZFSI8ZfSKaNvtkBiUOZJJmU6LxYZJBPcS7QWd?=
 =?us-ascii?Q?eyzDA4Wk2+w4CCcl2ZibZtWxSsoolz7ZCDSqzc4151jUPQ0yRoY0L7u/ZYgR?=
 =?us-ascii?Q?mYl+RcGmStpiDYV7Gm1iP5QThF/L+FjNLa8cZbNdRPAnbLzahAdLhgFh4YiE?=
 =?us-ascii?Q?OKqY/uEBCfcNHjRWW4eljcaOe6Shc2rKeqIsOVvI6IXUx9DwFG0yljxZxo9d?=
 =?us-ascii?Q?vqLGGRKHTJi/PyUVWKNw9q0WrKFaPVEt13Oqwv+JDnuSwx3YEslJiD8wFnhN?=
 =?us-ascii?Q?Kig2YAObwPycleQW8QfwbIhUob0+Vr9oVqp3JvIMjZafZ41haYlVbtjMMZlj?=
 =?us-ascii?Q?Qr4q+2cWlznrsd0/kFMe28fJIIoNMPZXpd0QE4sVwvS3/hELGKztAost/Rhp?=
 =?us-ascii?Q?7zDa0seoOI3x2hw3Mwiz47Q=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afaaf05c-bd73-43be-40e6-08da592b3258
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 17:25:29.1644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0mtXvhQHLS7KJ9/I4Fg+Kc/0RqfZfzEABcG9i0yjb0ny4vqWClm8RQEUXLCEC0aQlz9WY+g/MBedeUy8fAvWZuIwfmesF3WcjngIqPj4CbQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4263
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Tue, Jun 28, 2022 at 04:08:10PM +0000, Vladimir Oltean wrote:
> On Tue, Jun 28, 2022 at 01:17:01AM -0700, Colin Foster wrote:
> > diff --git a/include/linux/mfd/ocelot.h b/include/linux/mfd/ocelot.h
> > new file mode 100644
> > index 000000000000..5c95e4ee38a6
> > --- /dev/null
> > +++ b/include/linux/mfd/ocelot.h
> > @@ -0,0 +1,27 @@
> > +/* SPDX-License-Identifier: GPL-2.0 OR MIT */
> > +/* Copyright 2022 Innovative Advantage Inc. */
> > +
> > +#include <linux/err.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/regmap.h>
> > +#include <linux/types.h>
> > +
> > +struct resource;
> > +
> > +static inline struct regmap *
> > +ocelot_platform_init_regmap_from_resource(struct platform_device *pdev,
> > +					  unsigned int index,
> > +					  const struct regmap_config *config)
> 
> I think this function name is too long (especially if you're going to
> also introduce ocelot_platform_init_regmap_from_resource_optional),
> and I have the impression that the "platform_init_" part of the name
> doesn't bring too much value. How about ocelot_regmap_from_resource()?

I thought the same thing after your first email. My thought was "how do
I indent that?" :-)

> 
> > +{
> > +	struct resource *res;
> > +	u32 __iomem *regs;
> > +
> > +	regs = devm_platform_get_and_ioremap_resource(pdev, index, &res);
> > +
> > +	if (!res)
> > +		return ERR_PTR(-ENOENT);
> > +	else if (IS_ERR(regs))
> > +		return ERR_CAST(regs);
> > +	else
> > +		return devm_regmap_init_mmio(&pdev->dev, regs, config);
> > +}
> > -- 
> > 2.25.1
> >
> 
> To illustrate what I'm trying to say, these would be the shim
> definitions:
> 
> static inline struct regmap *
> ocelot_regmap_from_resource(struct platform_device *pdev,
> 			    unsigned int index,
> 			    const struct regmap_config *config)
> {
> 	struct resource *res;
> 	void __iomem *regs;
> 
> 	regs = devm_platform_get_and_ioremap_resource(pdev, index, &res);
> 	if (IS_ERR(regs))
> 		return regs;
> 
> 	return devm_regmap_init_mmio(&pdev->dev, regs, config);
> }
> 
> static inline struct regmap *
> ocelot_regmap_from_resource_optional(struct platform_device *pdev,
> 				     unsigned int index,
> 				     const struct regmap_config *config)
> {
> 	struct resource *res;
> 	void __iomem *regs;
> 
> 	res = platform_get_resource(pdev, IORESOURCE_MEM, index);
> 	if (!res)
> 		return NULL;
> 
> 	regs = devm_ioremap_resource(&pdev->dev, r);
> 	if (IS_ERR(regs))
> 		return regs;
> 
> 	return devm_regmap_init_mmio(&pdev->dev, regs, config);
> }
> 
> and these would be the full versions:
> 
> static struct regmap *
> ocelot_regmap_from_mem_resource(struct device *dev, struct resource *res,
> 				const struct regmap_config *config)
> {
> 	void __iomem *regs;
> 
> 	regs = devm_ioremap_resource(dev, r);
> 	if (IS_ERR(regs))
> 		return regs;
> 
> 	return devm_regmap_init_mmio(dev, regs, config);
> }
> 
> static struct regmap *
> ocelot_regmap_from_reg_resource(struct device *dev, struct resource *res,
> 				const struct regmap_config *config)
> {
> 	/* Open question: how to differentiate SPI from I2C resources? */

My expectation is to set something up in drivers/mfd/ocelot-{spi,i2c}.c
and have an if/else / switch. PCIe might actually be our first hardware
spin.

> 	return ocelot_spi_init_regmap(dev->parent, dev, res);
> }
> 
> struct regmap *
> ocelot_regmap_from_resource_optional(struct platform_device *pdev,
> 				     unsigned int index,
> 				     const struct regmap_config *config)
> {
> 	struct device *dev = &pdev->dev;
> 	struct resource *res;
> 
> 	res = platform_get_resource(pdev, IORESOURCE_MEM, index);
> 	if (res)
> 		return ocelot_regmap_from_mem_resource(dev, res, config);
> 
> 	/*
> 	 * Fall back to using IORESOURCE_REG, which is possible in an
> 	 * MFD configuration
> 	 */
> 	res = platform_get_resource(pdev, IORESOURCE_REG, index);
> 	if (res)
> 		return ocelot_regmap_from_reg_resource(dev, res, config);
> 
> 	return NULL;
> }
> 
> struct regmap *
> ocelot_regmap_from_resource(struct platform_device *pdev,
> 			    unsigned int index,
> 			    const struct regmap_config *config)
> {
> 	struct regmap *map;
> 
> 	map = ocelot_regmap_from_resource_optional(pdev, index, config);
> 	return map ? : ERR_PTR(-ENOENT);
> }
> 
> I hope I didn't get something wrong, this is all code written within the
> email client, so it is obviously not compiled/tested....

Yep - I definitely get the point. And thanks for the review.

The other (bigger?) issue is around how this MFD can be loaded as a
module. Right now it is pretty straightforward to say
#if IS_ENABLED(CONFIG_MFD_OCELOT). Theres a level of nuance if
CONFIG_MFD_OCELOT=m while the child devices are compiled in
(CONFIG_PINCTRL_MICROCHIP_SGPIO=y for example). It still feels like this
code belongs somewhere in platform / resource / device / mfd...?

It might be perfectly valid to have multiple SGPIO controllers - one
local and one remote / SPI. But without the CONFIG_MFD_OCELOT module
loaded, I don't think the SGPIO module would work.

This patch set deals with the issue by setting MFD_OCELOT to a boolean -
but in the long run I think a module makes sense. I admittedly haven't
spent enough time researching (bashing my head against the wall) this,
but this seems like a good opportunity to at least express that I'm
expecting to have to deal with this issue soon. I met with Alexandre at
ELC this past week, and he said Arnd (both added to CC) might be a good
resource - but again I'd like to do a little more searching before
throwing it over the wall.
