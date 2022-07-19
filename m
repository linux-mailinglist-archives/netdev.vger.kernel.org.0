Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 656FB57A5B9
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 19:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238041AbiGSRtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 13:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238254AbiGSRtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 13:49:13 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2126.outbound.protection.outlook.com [40.107.92.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4BB54AC7;
        Tue, 19 Jul 2022 10:49:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=muANlnVVu1K6OmzgtFBnTS5uSMiK4e1Fi1Acb0f4nSNb9UKoP3tRWTOV1KQ9/RUMbtU9Gcbqhu1o+oJlqkTSruOcHRtOct4vn3kCEJSkkgNhmnDlPFrhFern9/5kE1DUUBkcgPvIPlb/UBXY+Qy+1fuJ1+d3twudn94Dt4FEFUEOFMUe/tOTKnb/697QqpHnG5+DMYHIvYYXpnuL5cAj9CASwjqzKfL5WyOfV0uDbe2YvV69gu6pmtxWf9JVFsOSyg76Lu5Z9+eMZoYDnPfkjwN3CM8/QzNOXtYNpiSH0pIQu0oVDAYdEUPMRwaFLEoGaBPgzZ6CcxSoxQVEZGQ0Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MOOdx8i7OJZEpkAmlQX6dRyv1uptdBTzGeWQSNeBhYA=;
 b=KgPr6dIj+uOVoTezI9kDMmuIGcv1i332hEW4CYEwyDJMHHNM/bjSNc3Uz1lIWvUfDYU6GRtPr19VPb9Aq0rP+P6xJzWPzzrTPaC+LjTpJV6niHLqt1zI0qiVICMAALCnwR2pRynF+k1c/8hjXpUdPiXT2cjAEz7KZSFqa9nsxi9RMCA2bkqqvRU3mScnGLppgn/ajC9zA9ujfjIe/z0sLIayD64VBnbmMpCSzQF/miDT9KfPRwYgBrHYduqAkjNsCsjew0am0MroA3/3ASNi/s2NMA8ex8oKU589yjo8g+ILysqoKstO4IIDx0TA4cUozDkxKu1DzlFhINS57ChAOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MOOdx8i7OJZEpkAmlQX6dRyv1uptdBTzGeWQSNeBhYA=;
 b=BIQGTonxE4uQ2zzpBlmvut6Z6/ajYFbbfwLZJriiNQ2Cs3Gik13qST5eHxHZ4TnMy9VoMRd0pcDpRHbOjowrseeidD9M7S3C4cg5aS0wioMDE/KNCRyta/B1X1YkjJf+WifI83kEM48CNwiE9EKKNynD9CLhmnWKv4f7vcFdsbQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN0PR10MB4982.namprd10.prod.outlook.com
 (2603:10b6:408:12c::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Tue, 19 Jul
 2022 17:49:08 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7451:2903:45de:3912]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7451:2903:45de:3912%7]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 17:49:08 +0000
Date:   Tue, 19 Jul 2022 10:49:03 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
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
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        katie.morris@in-advantage.com
Subject: Re: [PATCH v13 net-next 9/9] mfd: ocelot: add support for the
 vsc7512 chip via spi
Message-ID: <Ytbuj6qfUj1NOitS@euler>
References: <20220705204743.3224692-1-colin.foster@in-advantage.com>
 <20220705204743.3224692-10-colin.foster@in-advantage.com>
 <YtVrtOHy3lAeKCRH@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YtVrtOHy3lAeKCRH@google.com>
X-ClientProxiedBy: SJ0PR05CA0096.namprd05.prod.outlook.com
 (2603:10b6:a03:334::11) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 397b0d79-35bb-4d03-f385-08da69aefad4
X-MS-TrafficTypeDiagnostic: BN0PR10MB4982:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v/cM2ONAVSB+XhsBCSphIyzGHq53YaN6nKpA4fBE3CzlFYrHzFi0s3z0WY+yUGq3pRXozKSFvXMOv90VFCCZOCRGmqZi4xsgfb/HrivJLtxCKWQvq9uCl0ovkz9BxBifEBBTCSkrlgcoNZpm0CNMoBIxn0IukGdC9nd/bseE7dcq8tIsjrtATN3ehfCROmyjk0tiV1qEUoBLV470a37LkLk0R877/LDED1yHEyQKf+s/ZEGPY04KSStP2OZIm5gYjwyIrFSKyUTHFculmCpAnBMPECgiQKk9CL04nVQb43mfzREX17xTVYgCuyioIbrJIePbvZ4Zk7iidBZnaYrVOPhDfcnLux/FK2LJn6nrSXhAA7lrKEToQaA+ghdRfYncoWGQiVyHg5AhHroL8zpZe8rP65fSXfk+cKqfqMerVlkId7JV+ByydFkVLx7vxlD1O429e+n1PucOwCncMgxMWUbQt+guGejZYxwLkghlUJebpFe9NdfC0x0lErEY2XarM8l8LYbJb9aV/ljfwu2wQNy1K6HOqtJwKNpWln9ETln14tsoaybrtblLSJP+Rb08m0RXhrMo5kwvwlKm9abc8JJWSNBt7Y8AIqkD69VOF+2rjWpiKIyxBlgIk1Nc8sTIovBLhsYGK3nZvwoLKlfiEMnE5f8wYqbVIfYBgTxLk/ZRJdAPiK5SDsMGrgkRBMhEE/bf4AgIcmXuDvqxUtz6QlKSmFOugzoOUXn281t6cOjyyq5Ztt5Jtfh+enZGPlcdm4NZAs41teeADXMw0n40WQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39830400003)(396003)(376002)(366004)(136003)(346002)(86362001)(66476007)(38100700002)(66556008)(54906003)(316002)(66946007)(8676002)(2906002)(4326008)(6916009)(30864003)(8936002)(186003)(107886003)(5660300002)(33716001)(7416002)(9686003)(6486002)(966005)(478600001)(6512007)(83380400001)(26005)(6666004)(41300700001)(6506007)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RmhZSk1KTDVxQUpEemxlZEc4bkIraDVCNGJWK1R2MEs3NkRIbVRNQVo2Y25a?=
 =?utf-8?B?ajZCcm1vNXEyTHkrQmp6dTZrN0F5c1FSVGh4V0I4QlJaUnhjQnNJU2hFckJT?=
 =?utf-8?B?dHA4SjYrb1lKWS80ZklCWU5XTTIxM0hjM1dzMnNEVmw4LzRaTUNvMVEzRmh3?=
 =?utf-8?B?Y3N3VWsrNU4vWXhmQVJZVGE3ekhnamRBOUd6ai93TUFuTm1aVjA4UGpwTTg4?=
 =?utf-8?B?UUNwNFJPWDNIMGdjWjh2aXRQSjlvdjdST2drNDdSWXpTKzIwa0dBQjI4d0dR?=
 =?utf-8?B?dG5zNUh6YVBCRmk0cXpVR1gyOXlXWUZZRG1Td2pkb0hnRHVKUlAxRlpDdXV4?=
 =?utf-8?B?R1h0U0VCZkQraEYrY3JzdkhCK1hOL1dOVjZuaWFQZVNjWlRkL0lJRFVBQnYx?=
 =?utf-8?B?bUZjaEYxRGpzZTVQMjJQUGN3N25xMkRleTlmNzBEOGRJdHJKZEoydHUvaCtv?=
 =?utf-8?B?TmlqandpeGFxQUhidDFNdVR6ZlMyTWhVRXg2RjQ1OFFsTW1xdTdTV3B3Wkp3?=
 =?utf-8?B?NktuaHFNeHV1K2ZjWUtMbE5jVXFnVHBkNjB1Z3YzOXFuaWFuSE96YzJqV3Zu?=
 =?utf-8?B?TUxCUkxGb28vbXhvamQ0STNzVE1mUDc5Z2VyQk5mQmJOdlZ6MTYwcmtPRkJt?=
 =?utf-8?B?b1Z3OGlhRjdBMk9XZUdXSWE1UkFCb2ZjeUYzbXZYL3BDQmJPTkc4MzBkOVdj?=
 =?utf-8?B?RnVTM0xOOW0waHd5OE9tYmpTdkUwazJkanhPd1pveFB6WTFvamJEclduVUZE?=
 =?utf-8?B?eFJwK1VmSHlvbmlmYVZtamN4OXpJTnhrN284Q0lmYXdZMG5jaTl5cU1BYlNs?=
 =?utf-8?B?UUtPODZYV1FkNS9XMjlYV2pWcy9ON0hLVkQ2KzNVQjlUUVlkeEZuMVVlQStx?=
 =?utf-8?B?eU5oMkpwK0pCUkZ6VEFnVGc3NUkyVC8zQTZnVFhGTUNLN3JGQ0VYNEN6TnJO?=
 =?utf-8?B?b2dGbWpRamZibnZJMGZNbGdWeTRTRHlDNGVUeWp6MlpyYmJYc1pUaEdtT2xz?=
 =?utf-8?B?WWJvVHpqaFY3NzhZbHdvVklrYTVKYXRrajNUNEZIY2hGVURNelFnUUlaOFdh?=
 =?utf-8?B?c0NmSVJUT05IRVJVYk9zdXUyMTRIOVdoUUwvVHZZaUdxNFZRcFdlUCt0S0pZ?=
 =?utf-8?B?RXRJcktRaXQ1ZlRUNllRK1h6U3ZWMjVxWmYxZmxOTFFQdnFZb2lUMTV1elhW?=
 =?utf-8?B?Vjh1eUhWZFhVbmRoMEdTMUN0b2xMTHYwMitjNlozWGxaRXYrUlBsSGNzcUMx?=
 =?utf-8?B?UGt6bEF2R3p1TnZxMk1aMGhxR2F6dUZhNCs5d08zNVl1S2ZyVi9HUTkra2Jr?=
 =?utf-8?B?ZldSR2NyV3kvUjFNR2oxbFUxajZMVTZ4SjQxN0tIRVNncDV3WnRMUStMS214?=
 =?utf-8?B?MXRVbHhXN3V6MjNVYjdDN1czejhmL2ZEYUQ0YzQ2UlgwUmIvQlB5bkFKMGpR?=
 =?utf-8?B?bitIK0tVTnNYQjlJdUtxWXBGWm5nNitydjhVSmtCYkw1RU9RL2h0MkFLQXNI?=
 =?utf-8?B?RDBzQkVQN2xuVTEzTnYybVBrWWgzQ1d4V29FSjQwOUUyZzd5MmM5NWtGSkE2?=
 =?utf-8?B?OHUxNmxEVHdmUFY2NXpEb1pDaDhsYnZFYU5iSUsrbTN1Q012bkVHWlBIZWt5?=
 =?utf-8?B?NGpwLzdXUzZmQktGcVlWcXRpMU1nRW05eS82MjJhUG9CYmxYdlY2aUFJSVZW?=
 =?utf-8?B?a25tWEhQcFdHMWpNYnRXNGNxK2ZQUkErSUNxMy9VdkI3OEZWSEhGczRhVWkr?=
 =?utf-8?B?alg3N0Nxd1pTcGl1OGFMRTJyYjAxSlk2YWlFSHF5T1J5TU1HUUFFSER2dXM3?=
 =?utf-8?B?UlNjYTcxUnlpdTNXU2N3MGdLQUVwQUc2UFJYUW9EUjVhUER2UUxXc1ZPVXR2?=
 =?utf-8?B?YnY1S0FDR1ZPYmNGUkRNOGdtV1kvck1nZjFiTVhBdHRkVUlHckFGT3lScWZH?=
 =?utf-8?B?aEJPR2VrRmNxQmo0bzJKQlhkQlQ4WTRpTWJhb1JaSlVGYkc2NkRxc3BGUHNF?=
 =?utf-8?B?bW9HbVJ5NXZqMGphVldxSlZwamVocUZuOXBxbzFvb1VienpBNHM4Mi80NUd5?=
 =?utf-8?B?eXkyckRwNzY4UDRoZ3NBeWJlWUtPY29YRlM2U0VuKzUxQlkrT0lMZzFUbGps?=
 =?utf-8?B?YmRZTzBxU1M1UHJCMXBYNm5SMHdzTVAxVXRHNWZJejBDMk96dHF0bGNQSlB6?=
 =?utf-8?B?UVE9PQ==?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 397b0d79-35bb-4d03-f385-08da69aefad4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 17:49:08.3113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FUsaNOn8pBPCGmA1YLbanZ5QeNloMz7lMfSW3wGoW+P0ZJV9+EluY5Kn+WntbPilBeAhq4HBAxGT2utgJeVEraq0upWZGLjkgfJ7AjJh6N4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4982
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 03:18:28PM +0100, Lee Jones wrote:
> On Tue, 05 Jul 2022, Colin Foster wrote:
> 
> > +MODULE_IMPORT_NS(MFD_OCELOT_SPI);
> > diff --git a/drivers/mfd/ocelot-spi.c b/drivers/mfd/ocelot-spi.c
> > new file mode 100644
> > index 000000000000..0c1c5215c706
> > --- /dev/null
> > +++ b/drivers/mfd/ocelot-spi.c
> > @@ -0,0 +1,317 @@
> > +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> > +/*
> > + * SPI core driver for the Ocelot chip family.
> > + *
> > + * This driver will handle everything necessary to allow for communication over
> > + * SPI to the VSC7511, VSC7512, VSC7513 and VSC7514 chips. The main functions
> > + * are to prepare the chip's SPI interface for a specific bus speed, and a host
> > + * processor's endianness. This will create and distribute regmaps for any
> > + * children.
> > + *
> > + * Copyright 2021, 2022 Innovative Advantage Inc.
> > + *
> > + * Author: Colin Foster <colin.foster@in-advantage.com>
> > + */
> > +
> > +#include <linux/ioport.h>
> > +#include <linux/kconfig.h>
> > +#include <linux/module.h>
> > +#include <linux/regmap.h>
> > +#include <linux/spi/spi.h>
> > +
> > +#include <asm/byteorder.h>
> > +
> > +#include "ocelot.h"
> > +
> > +#define REG_DEV_CPUORG_IF_CTRL		0x0000
> > +#define REG_DEV_CPUORG_IF_CFGSTAT	0x0004
> > +
> > +#define CFGSTAT_IF_NUM_VCORE		(0 << 24)
> > +#define CFGSTAT_IF_NUM_VRAP		(1 << 24)
> > +#define CFGSTAT_IF_NUM_SI		(2 << 24)
> > +#define CFGSTAT_IF_NUM_MIIM		(3 << 24)
> > +
> > +#define VSC7512_DEVCPU_ORG_RES_START	0x71000000
> > +#define VSC7512_DEVCPU_ORG_RES_SIZE	0x38
> > +
> > +#define VSC7512_CHIP_REGS_RES_START	0x71070000
> > +#define VSC7512_CHIP_REGS_RES_SIZE	0x14
> > +
> > +struct spi_device;
> 
> Why not just #include?

I mis-understood this to mean drivers/mfd/ocelot-spi.c when it meant
drivers/mfd/ocelot.h. Thanks.

https://patchwork.kernel.org/project/netdevbpf/patch/20220701192609.3970317-10-colin.foster@in-advantage.com/#24921057

"""
You missed a lot of forward declarations that are used in this file.

Like

struct spi_device;
"""


> > +static int ocelot_spi_regmap_bus_read(void *context,
> > +				      const void *reg, size_t reg_size,
> > +				      void *val, size_t val_size)
> > +{
> > +	struct ocelot_ddata *ddata = context;
> > +	struct spi_transfer tx, padding, rx;
> > +	struct spi_device *spi = ddata->spi;
> > +	struct spi_message msg;
> > +
> > +	spi = ddata->spi;
> 
> Drop this line.

Yes - and actually since I'm removing ddata->spi altogether it'll become
to_spi_device(ddata->dev)  (obviously without the double-assignment that
you're pointing out here)

> 
> > +	spi_message_init(&msg);
> > +
> > +	memset(&tx, 0, sizeof(tx));
> > +
> > +	tx.tx_buf = reg;
> > +	tx.len = reg_size;
> > +
> > +	spi_message_add_tail(&tx, &msg);
> > +
> > +	if (ddata->spi_padding_bytes) {
> > +		memset(&padding, 0, sizeof(padding));
> > +
> > +		padding.len = ddata->spi_padding_bytes;
> > +		padding.tx_buf = ddata->dummy_buf;
> > +		padding.dummy_data = 1;
> > +
> > +		spi_message_add_tail(&padding, &msg);
> > +	}
> > +
> > +	memset(&rx, 0, sizeof(rx));
> > +	rx.rx_buf = val;
> > +	rx.len = val_size;
> > +
> > +	spi_message_add_tail(&rx, &msg);
> > +
> > +	return spi_sync(spi, &msg);
> > +}
> > +
> > +static int ocelot_spi_regmap_bus_write(void *context, const void *data,
> > +				       size_t count)
> > +{
> > +	struct ocelot_ddata *ddata = context;
> > +	struct spi_device *spi = ddata->spi;

As above, I'm changing to to_spi_device(ddata->dev)

> > +
> > +	return spi_write(spi, data, count);
> > +}
> > +
> > +static const struct regmap_bus ocelot_spi_regmap_bus = {
> > +	.write = ocelot_spi_regmap_bus_write,
> > +	.read = ocelot_spi_regmap_bus_read,
> > +};
> > +
> > +struct regmap *
> > +ocelot_spi_init_regmap(struct device *dev, const struct resource *res)
> 
> One line, along with all the others.
> 
> > +{
> > +	struct ocelot_ddata *ddata = dev_get_drvdata(dev);
> > +	struct regmap_config regmap_config;
> > +
> > +	memcpy(&regmap_config, &ocelot_spi_regmap_config,
> > +	       sizeof(regmap_config));
> > +
> > +	regmap_config.name = res->name;
> > +	regmap_config.max_register = res->end - res->start;
> > +	regmap_config.reg_base = res->start;
> > +
> > +	return devm_regmap_init(dev, &ocelot_spi_regmap_bus, ddata,
> > +				&regmap_config);
> > +}
> > +EXPORT_SYMBOL_NS(ocelot_spi_init_regmap, MFD_OCELOT_SPI);
> > +
> > +static int ocelot_spi_probe(struct spi_device *spi)
> > +{
> > +	struct device *dev = &spi->dev;
> > +	struct ocelot_ddata *ddata;
> > +	struct regmap *r;
> > +	int err;
> > +
> > +	ddata = devm_kzalloc(dev, sizeof(*ddata), GFP_KERNEL);
> > +	if (!ddata)
> > +		return -ENOMEM;
> > +
> > +	ddata->dev = dev;
> 
> How are you fetching ddata if you don't already have 'dev'?

I don't think I fully understand this question...


Are you saying ddata doesn't need a dev instance? So instead of:

devm_regmap_init(dev, &bus, ddata, &regmap_config);

It could be:

devm_regmap_init(dev, &bus, dev, &regmap_config);


In that case, the context into ocelot_spi_regmap_bus_{read,write} would
be dev, instead of ddata.

Then I get ddata from device via:

static int ocelot_spi_regmap_bus_write(void *context,...)
{
    struct device *dev = context;
    struct ocelot_ddata *ddata = dev_get_drvdata(dev);
    struct spi_device *spi = to_spi_device(dev);

    /* ddata isn't actually needed for bus_write, just making a point */
    ...
}


I haven't tested this yet, but I think this is what you're suggesting.
So now I've removed both spi and dev from the ddata struct (as I mention
below). Cool.

> 
> > +	dev_set_drvdata(dev, ddata);
> 
> This should use the spi_* variant.

Agreed.

> 
> > +	if (spi->max_speed_hz <= 500000) {
> > +		ddata->spi_padding_bytes = 0;
> > +	} else {
> > +		/*
> > +		 * Calculation taken from the manual for IF_CFGSTAT:IF_CFG.
> > +		 * Register access time is 1us, so we need to configure and send
> > +		 * out enough padding bytes between the read request and data
> > +		 * transmission that lasts at least 1 microsecond.
> > +		 */
> > +		ddata->spi_padding_bytes = 1 +
> > +			(spi->max_speed_hz / 1000000 + 2) / 8;
> > +
> > +		ddata->dummy_buf = devm_kzalloc(dev, ddata->spi_padding_bytes,
> > +						GFP_KERNEL);
> > +		if (!ddata->dummy_buf)
> > +			return -ENOMEM;
> > +	}
> > +
> > +	ddata->spi = spi;
> 
> If you have 'spi' you definitely do not need 'dev'.
> 
> You can derive one from the other.

Good point. As I implied above, I'm dropping "spi" from the ddata struct
and will recover spi from to_spi_device(dev)

That does some nice things like removes "struct spi_device" from
drivers/mfd/ocelot.h

> > +	spi->bits_per_word = 8;
> > +
> > +	err = spi_setup(spi);
> > +	if (err < 0)
> > +		return dev_err_probe(&spi->dev, err,
> > +				     "Error performing SPI setup\n");
> > +
> > +	r = ocelot_spi_init_regmap(dev, &vsc7512_dev_cpuorg_resource);
> > +	if (IS_ERR(r))
> > +		return PTR_ERR(r);
> > +
> > +	ddata->cpuorg_regmap = r;
> > +
> > +	r = ocelot_spi_init_regmap(dev, &vsc7512_gcb_resource);
> > +	if (IS_ERR(r))
> > +		return PTR_ERR(r);
> > +
> > +	ddata->gcb_regmap = r;
> > +
> > +	/*
> > +	 * The chip must be set up for SPI before it gets initialized and reset.
> > +	 * This must be done before calling init, and after a chip reset is
> > +	 * performed.
> > +	 */
> > +	err = ocelot_spi_initialize(dev);
> > +	if (err)
> > +		return dev_err_probe(dev, err, "Error initializing SPI bus\n");
> > +
> > +	err = ocelot_chip_reset(dev);
> > +	if (err)
> > +		return dev_err_probe(dev, err, "Error resetting device\n");
> > +
> > +	/*
> > +	 * A chip reset will clear the SPI configuration, so it needs to be done
> > +	 * again before we can access any registers
> > +	 */
> > +	err = ocelot_spi_initialize(dev);
> > +	if (err)
> > +		return dev_err_probe(dev, err,
> > +				     "Error initializing SPI bus after reset\n");
> > +
> > +	err = ocelot_core_init(dev);
> > +	if (err < 0)
> > +		return dev_err_probe(dev, err,
> > +				     "Error initializing Ocelot core\n");
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct spi_device_id ocelot_spi_ids[] = {
> > +	{ "vsc7512", 0 },
> > +	{ }
> > +};
> > +
> > +static const struct of_device_id ocelot_spi_of_match[] = {
> > +	{ .compatible = "mscc,vsc7512" },
> > +	{ }
> > +};
> > +MODULE_DEVICE_TABLE(of, ocelot_spi_of_match);
> > +
> > +static struct spi_driver ocelot_spi_driver = {
> > +	.driver = {
> > +		.name = "ocelot-soc",
> > +		.of_match_table = ocelot_spi_of_match,
> > +	},
> > +	.id_table = ocelot_spi_ids,
> > +	.probe = ocelot_spi_probe,
> > +};
> > +module_spi_driver(ocelot_spi_driver);
> > +
> > +MODULE_DESCRIPTION("SPI Controlled Ocelot Chip Driver");
> > +MODULE_AUTHOR("Colin Foster <colin.foster@in-advantage.com>");
> > +MODULE_LICENSE("Dual MIT/GPL");
> > +MODULE_IMPORT_NS(MFD_OCELOT);
> > diff --git a/drivers/mfd/ocelot.h b/drivers/mfd/ocelot.h
> > new file mode 100644
> > index 000000000000..c86bd6990a3c
> > --- /dev/null
> > +++ b/drivers/mfd/ocelot.h
> > @@ -0,0 +1,34 @@
> > +/* SPDX-License-Identifier: GPL-2.0 OR MIT */
> > +/* Copyright 2021, 2022 Innovative Advantage Inc. */
> > +
> > +#include <asm/byteorder.h>
> > +
> > +struct device;
> > +struct spi_device;
> > +struct regmap;
> > +struct resource;
> > +
> > +struct ocelot_ddata {
> > +	struct device *dev;
> > +	struct regmap *gcb_regmap;
> > +	struct regmap *cpuorg_regmap;
> > +	int spi_padding_bytes;
> > +	struct spi_device *spi;
> > +	void *dummy_buf;
> > +};
> 
> This looks like it deserves a doc header.

Will do!

> 
> > +int ocelot_chip_reset(struct device *dev);
> > +int ocelot_core_init(struct device *dev);
> > +
> > +/* SPI-specific routines that won't be necessary for other interfaces */
> > +struct regmap *ocelot_spi_init_regmap(struct device *dev,
> > +				      const struct resource *res);
> > +
> > +#define OCELOT_SPI_BYTE_ORDER_LE 0x00000000
> > +#define OCELOT_SPI_BYTE_ORDER_BE 0x81818181
> > +
> > +#ifdef __LITTLE_ENDIAN
> > +#define OCELOT_SPI_BYTE_ORDER OCELOT_SPI_BYTE_ORDER_LE
> > +#else
> > +#define OCELOT_SPI_BYTE_ORDER OCELOT_SPI_BYTE_ORDER_BE
> > +#endif
> 
> -- 
> Lee Jones [李琼斯]
> Principal Technical Lead - Developer Services
> Linaro.org │ Open source software for Arm SoCs
> Follow Linaro: Facebook | Twitter | Blog
