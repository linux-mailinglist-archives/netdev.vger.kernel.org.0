Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B90FD520321
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 19:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239468AbiEIRGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 13:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239344AbiEIRG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 13:06:28 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2133.outbound.protection.outlook.com [40.107.93.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B5B248E2B;
        Mon,  9 May 2022 10:02:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RCzmEeDMm7gpvlMQ2JNvsJK+GLqtQnkpBLM8oHqbEpYZQejEGUM2VJj8arA0seft0YJyG2Qixt/zXVq5bOXSvh5eQmqWcgJV8EBe0E9HZuSqkmPJVYQczjtr93nLtHneCDmzEVBEwa+n/NNxsqdaui7XJHbUl3ZFKtIs36yNwPGj7CGzYS5F2F9ARVpviAnDO9VK0FA1Tg0QdlGQk8jA2YGGZ3qfeTlKYuGlnOp6J+5NCVXVrT4YY4ZZH6nCcm9Y8Jm4XUp0wHSfg2AZcRTkJD4coEhUiNUbN3U/23tCT/jFFcew31emHKQqlNHfr8k6tWMu0SScGRKrDxpxvVdo8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kfhild66LJa9SFeD9hG1ytaY89r7jjlg56ME7MboX+k=;
 b=MAEWJnxtZjXloHzURg9lXldigWlNDwhKRAOzWlhVgF1V68y68Qn5vILvJYyywIBgvyjoW9AfyGVzd6bT28DtVdnuzB3WTlnI6Jp2rF+5UAk1q26muPNp9t0jZ7M1vhK6yNWwvrjiUtz9dcaR27idnQaITge6/lRbY6qucQn4AxMF8MKJU41wq7CmPGtqjVxjbbpxXPeBQzXgD/FDx3g/QdKkny9jTf0MgMM8gMJGuuheSVhP9seAr5nUm4pbNpERU1ZmkleoL++CitjBbS/7BMRjj4bOdma7fLVydn90z6+lvBOk1SBWKxcotyPe7xXwa9dKFs26ChIeufUvo92ecQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kfhild66LJa9SFeD9hG1ytaY89r7jjlg56ME7MboX+k=;
 b=GqUlUykPzi3jAjbwhN2Pe4deFkKgzshDpfV0b9asDv0r4fw4XlvsNDS32OP29W08A7ykyHBfIJBBlN3dBNO3+/Fv26U0rFyh7iWBGlJeHlP9CYfnRRJ2YRGSix1CdsbAkxmKd/NMQHY98iQxOxNGzqY9adcU16TeN56Na4RZwbc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN7PR10MB2642.namprd10.prod.outlook.com
 (2603:10b6:406:c4::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.18; Mon, 9 May
 2022 17:02:30 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5227.020; Mon, 9 May 2022
 17:02:30 +0000
Date:   Mon, 9 May 2022 17:02:34 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [RFC v8 net-next 14/16] net: dsa: ocelot: add external ocelot
 switch control
Message-ID: <20220510000234.GD895@COLIN-DESKTOP1.localdomain>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220508185313.2222956-15-colin.foster@in-advantage.com>
 <20220509162721.jksbziznaxdwgogd@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509162721.jksbziznaxdwgogd@skbuf>
X-ClientProxiedBy: MW4PR03CA0006.namprd03.prod.outlook.com
 (2603:10b6:303:8f::11) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e0925e2-9369-4c1d-30e8-08da31ddb40e
X-MS-TrafficTypeDiagnostic: BN7PR10MB2642:EE_
X-Microsoft-Antispam-PRVS: <BN7PR10MB26425BA1EE93803FF003AD69A4C69@BN7PR10MB2642.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EIwzPk3K6zE72+p4K7+ZNyxL5vxxwmxCZuHFgA8KBZWFTUINFv5kOPyWQq20cxr3oxYfq3FLEsyFgZK2lz9t2Vd5PxS85wF75DCsKi9tuykw4k+jl06vrEDoMJkxkyH/vGm/7Fu+1He2NrZ83HW3gXorL3uMrdOs/LhWxvmGz7FpdVFDhbsL0g5grHl14Z9/w441dSgCntqKZE4xMdb5BoBu6MrwomdPD7+emJUY39Xc01mWUUh0wz+4vQcL1cBCQrMYgTda9qBaYkGI07HF56RFKz0leABecTutT3ClSn5c9idi4CIwtI9szfW6nS3i2cM7xEJUJDtwe0xG7jHZLSwXMCgdADZDIQVSY6KZ0ldQYppj+A/2jjXTkKc6NQ9yMCvI5H8yK5pDH45ICQxrmQbWuMow1y8yV/acXq4pHxiFu8kUmG+Sc847QfPjD3KowCNbuqwKZASaAMVmLuqUW8QMfm2LscLZV118RaRE/TqsXU26kEKIZ31HHNSlVExaVFaHv+nL+mofpjTyzu8H17fDojmr7ED5ZKQtMgT6HbtA9MHNSSjVFrAZ5Ag6RZCPe8QzIKpI/JXKY2YEkUm1BYMOATzXH6RzV1x+6DcVc1gVXkr09joO+jQoFPlHQunStklAnyibH5HnRLgRWcbBVF9lWD7Sn4JOBDw9/Z34r+nW5PV5aCkMJX4EdOkeeZZqgBeDMfX7P9mm8GL3U/uBLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(366004)(396003)(39830400003)(346002)(136003)(8936002)(33656002)(1076003)(316002)(38100700002)(38350700002)(5660300002)(86362001)(7416002)(508600001)(66476007)(54906003)(66556008)(186003)(66946007)(6916009)(30864003)(8676002)(9686003)(26005)(4326008)(6512007)(83380400001)(6486002)(6506007)(44832011)(2906002)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uaEwYLBG5ptGmlPNp1fbSW7uEjeO4n+6s+y9VsZucG/2zKylqOPIKYUDdjqd?=
 =?us-ascii?Q?u0fpTLW/bNM+YAk7GKoiWsDRQnVWxAQcsnexXjCWockjKbvqEl9HxBqy+kM1?=
 =?us-ascii?Q?VvFq7s1+dYg6Zh/aOPJSsq9H6kTUiWDM0pQJvJJ4V6MU/5JR9FxjbPblGo4N?=
 =?us-ascii?Q?rJophKb7SgZyglBqg+6LnDYJe9vit66afB6dExXYHoLgGngiLacJiG6dalm9?=
 =?us-ascii?Q?+O36rZKuBlTvDiZNnohUxSQKAF5wJrllDwQTHubjEvY7GX0lpL0E3wqcBQcD?=
 =?us-ascii?Q?4i1QXDdp2PGdYFtgwvgKjCLsxJU9PvrNJVbyknyOnt6j2blRj9iaNBO7gnNH?=
 =?us-ascii?Q?ugDqKhKvHrKsPiEEpCNgl6ac39hmLJUComi3aAYEhluqTfIfKsfxQix2m/jz?=
 =?us-ascii?Q?pspDlL58f62LMusJykszht9Olzs7dojXhHK1yw/naGyWXaSHjfqS4R0tCUvN?=
 =?us-ascii?Q?TPB9Rr4rkkOIqMb2PRhXVk/fJxudvHv7zuWo50PMFPfU2i9PiHIW9SJB2tnK?=
 =?us-ascii?Q?O/JYCp9w2Lf+Uy0wBI+lXztPdTYFBpavqVkfvMzMuf7uDeJAcnrs+jGt41nj?=
 =?us-ascii?Q?j7JTrZO0tnriFDz4ir9qWWrl2BHjujiW+tPOxtJwEwQkhZlgk6dmEx65XjUU?=
 =?us-ascii?Q?gLYq2U7Vef9Q+wz08vQRf9LmsqiRfNN5tc/Tu37aKVEDxhmz4yte0ustuMFf?=
 =?us-ascii?Q?WdM1Z7X0pdOxopA2KCX8tdaZNW3CWDNv0VQKR0irKv3PMd2hk0Oohma7qWGg?=
 =?us-ascii?Q?5H4YIrqLFf/ET9h+nW3ZPtwiUtB9KbmUIAHEmb20F0UiZfxKTzhjeBS8CCnd?=
 =?us-ascii?Q?UhfqpVCBZI9KGL7S5wybuTXTcaUzpbnz3t/sjMtGtIjPRhn3mzJ00c9keTmj?=
 =?us-ascii?Q?/hCjqBv32pExHoUJ72gkZ6YS2cbEEcyS7wvMM1lMrpIRTzIxRVUVfgqdOuvp?=
 =?us-ascii?Q?3vIAjOy0iKDotlNDs2qXUBpjxf9i9Nx5IE3SiysUT8ch3XNdGv+8jky+qEFH?=
 =?us-ascii?Q?pYaFQ1PcDFiilu2zX0RcCmEjFO18sSh/SfI5KEWgb7Rcwp77QG0dwCAQOaYz?=
 =?us-ascii?Q?6ZBWh20kr0+fIfi7jnMPZ49HmRTUZnQR6jJlbyduFt+YJI1utx+JvQ8nGJMD?=
 =?us-ascii?Q?t+hk9IkUUMyv5tmHszohunNw4rGBkBiHfblARvSY+u1/4zeubCcqhw0h310r?=
 =?us-ascii?Q?1QhqooMgLK7yqCgfvijweYynQrxt6c+3gvMIn22ozdJLUj/WGa41RR9CawIt?=
 =?us-ascii?Q?6MVOV+ZXoKP+tqa228Ci5ZROBRp2YypOLt/inWTeO+MIKQF33qlhWLytJyUm?=
 =?us-ascii?Q?B2pWRjd6DI0ieBs4ojaScarW7OPZ7g0Obqfd2fyacIpHX9LOJ5TXVTIZxCfM?=
 =?us-ascii?Q?PB4Lxaob5uGeDFdq1mpf8Elz7fOFMkohBr6HLeHQlGF5ZXmEHhnKsJRMGe4K?=
 =?us-ascii?Q?ENMKsDQlZdIt5uO5FcBPWDnlkc+x2Muh1lxz1f41jcFPAhCRKS2OQq9pmJlT?=
 =?us-ascii?Q?YXur+nOfRYQ26KuvTXwjNiYXkAIDZXDBHfFlUkPHdpvohYbfMgGbo1jPd+9Q?=
 =?us-ascii?Q?5K1Bu2daU+6xiwJiKPUtoGNnrB81a0AMnab5xC9q4poqGLtngpnmeBUW+Glb?=
 =?us-ascii?Q?XpKxIDo0dDmQdc5uso7jQRqMredjtBLugXCzdjVqBkDpdxnRj1zum35dIIja?=
 =?us-ascii?Q?5ET52130gQWxfv7DDNL2GzB1n/WFTWmuvzHmq9fS2RgDiXSBL2d08S+pY0+t?=
 =?us-ascii?Q?Z8MrxJFKoZc8sqawFT8qK9fibUzSm8MYun6fqQOucun8iHvsv0Il?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e0925e2-9369-4c1d-30e8-08da31ddb40e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 17:02:30.7208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kQnOHDUFJwC4mHcecTfLf9ovuC+LLpZe+uB4mfNVwFdlGcy2bO8hrVxihTBYA5hDtHePYi3hjsE4KhdPGJY8byAtrbJEyEiBuxpWUoLrD3U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2642
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 04:27:22PM +0000, Vladimir Oltean wrote:
> On Sun, May 08, 2022 at 11:53:11AM -0700, Colin Foster wrote:
> > Add control of an external VSC7512 chip by way of the ocelot-mfd interface.
> > 
> > Currently the four copper phy ports are fully functional. Communication to
> > external phys is also functional, but the SGMII / QSGMII interfaces are
> > currently non-functional.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> >  drivers/mfd/ocelot-core.c           |   3 +
> >  drivers/net/dsa/ocelot/Kconfig      |  14 ++
> >  drivers/net/dsa/ocelot/Makefile     |   5 +
> >  drivers/net/dsa/ocelot/ocelot_ext.c | 368 ++++++++++++++++++++++++++++
> >  include/soc/mscc/ocelot.h           |   2 +
> >  5 files changed, 392 insertions(+)
> >  create mode 100644 drivers/net/dsa/ocelot/ocelot_ext.c
> > 
> > diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
> > index 117028f7d845..c582b409a9f3 100644
> > --- a/drivers/mfd/ocelot-core.c
> > +++ b/drivers/mfd/ocelot-core.c
> > @@ -112,6 +112,9 @@ static const struct mfd_cell vsc7512_devs[] = {
> >  		.of_compatible = "mscc,ocelot-miim",
> >  		.num_resources = ARRAY_SIZE(vsc7512_miim1_resources),
> >  		.resources = vsc7512_miim1_resources,
> > +	}, {
> > +		.name = "ocelot-ext-switch",
> > +		.of_compatible = "mscc,vsc7512-ext-switch",
> >  	},
> >  };
> >  
> > diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
> > index 220b0b027b55..f40b2c7171ad 100644
> > --- a/drivers/net/dsa/ocelot/Kconfig
> > +++ b/drivers/net/dsa/ocelot/Kconfig
> > @@ -1,4 +1,18 @@
> >  # SPDX-License-Identifier: GPL-2.0-only
> > +config NET_DSA_MSCC_OCELOT_EXT
> > +	tristate "Ocelot External Ethernet switch support"
> > +	depends on NET_DSA && SPI
> > +	depends on NET_VENDOR_MICROSEMI
> > +	select MDIO_MSCC_MIIM
> > +	select MFD_OCELOT_CORE
> > +	select MSCC_OCELOT_SWITCH_LIB
> > +	select NET_DSA_TAG_OCELOT_8021Q
> > +	select NET_DSA_TAG_OCELOT
> > +	help
> > +	  This driver supports the VSC7511, VSC7512, VSC7513 and VSC7514 chips
> > +	  when controlled through SPI. It can be used with the Microsemi dev
> > +	  boards and an external CPU or custom hardware.
> > +
> >  config NET_DSA_MSCC_FELIX
> >  	tristate "Ocelot / Felix Ethernet switch support"
> >  	depends on NET_DSA && PCI
> > diff --git a/drivers/net/dsa/ocelot/Makefile b/drivers/net/dsa/ocelot/Makefile
> > index f6dd131e7491..d7f3f5a4461c 100644
> > --- a/drivers/net/dsa/ocelot/Makefile
> > +++ b/drivers/net/dsa/ocelot/Makefile
> > @@ -1,11 +1,16 @@
> >  # SPDX-License-Identifier: GPL-2.0-only
> >  obj-$(CONFIG_NET_DSA_MSCC_FELIX) += mscc_felix.o
> > +obj-$(CONFIG_NET_DSA_MSCC_OCELOT_EXT) += mscc_ocelot_ext.o
> >  obj-$(CONFIG_NET_DSA_MSCC_SEVILLE) += mscc_seville.o
> >  
> >  mscc_felix-objs := \
> >  	felix.o \
> >  	felix_vsc9959.o
> >  
> > +mscc_ocelot_ext-objs := \
> > +	felix.o \
> > +	ocelot_ext.o
> > +
> >  mscc_seville-objs := \
> >  	felix.o \
> >  	seville_vsc9953.o
> > diff --git a/drivers/net/dsa/ocelot/ocelot_ext.c b/drivers/net/dsa/ocelot/ocelot_ext.c
> > new file mode 100644
> > index 000000000000..ba924f6b8d12
> > --- /dev/null
> > +++ b/drivers/net/dsa/ocelot/ocelot_ext.c
> > @@ -0,0 +1,368 @@
> > +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> > +/*
> > + * Copyright 2021-2022 Innovative Advantage Inc.
> > + */
> > +
> > +#include <asm/byteorder.h>
> > +#include <linux/iopoll.h>
> > +#include <linux/kconfig.h>
> > +#include <linux/phylink.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/regmap.h>
> > +#include <soc/mscc/ocelot_ana.h>
> > +#include <soc/mscc/ocelot_dev.h>
> > +#include <soc/mscc/ocelot_qsys.h>
> > +#include <soc/mscc/ocelot_vcap.h>
> > +#include <soc/mscc/ocelot_ptp.h>
> > +#include <soc/mscc/ocelot_sys.h>
> > +#include <soc/mscc/ocelot.h>
> > +#include <soc/mscc/vsc7514_regs.h>
> > +#include "felix.h"
> > +
> > +#define VSC7512_NUM_PORTS		11
> > +
> > +static const u32 vsc7512_port_modes[VSC7512_NUM_PORTS] = {
> > +	OCELOT_PORT_MODE_INTERNAL,
> > +	OCELOT_PORT_MODE_INTERNAL,
> > +	OCELOT_PORT_MODE_INTERNAL,
> > +	OCELOT_PORT_MODE_INTERNAL,
> > +	OCELOT_PORT_MODE_SGMII | OCELOT_PORT_MODE_QSGMII,
> > +	OCELOT_PORT_MODE_SGMII | OCELOT_PORT_MODE_QSGMII,
> > +	OCELOT_PORT_MODE_SGMII | OCELOT_PORT_MODE_QSGMII,
> > +	OCELOT_PORT_MODE_SGMII | OCELOT_PORT_MODE_QSGMII,
> > +	OCELOT_PORT_MODE_SGMII | OCELOT_PORT_MODE_QSGMII,
> > +	OCELOT_PORT_MODE_SGMII,
> > +	OCELOT_PORT_MODE_SGMII | OCELOT_PORT_MODE_QSGMII,
> > +};
> > +
> > +static const u32 vsc7512_gcb_regmap[] = {
> > +	REG(GCB_SOFT_RST,			0x0008),
> > +	REG(GCB_MIIM_MII_STATUS,		0x009c),
> > +	REG(GCB_PHY_PHY_CFG,			0x00f0),
> > +	REG(GCB_PHY_PHY_STAT,			0x00f4),
> > +};
> > +
> > +static const u32 *vsc7512_regmap[TARGET_MAX] = {
> > +	[ANA] = vsc7514_ana_regmap,
> > +	[QS] = vsc7514_qs_regmap,
> > +	[QSYS] = vsc7514_qsys_regmap,
> > +	[REW] = vsc7514_rew_regmap,
> > +	[SYS] = vsc7514_sys_regmap,
> > +	[S0] = vsc7514_vcap_regmap,
> > +	[S1] = vsc7514_vcap_regmap,
> > +	[S2] = vsc7514_vcap_regmap,
> > +	[PTP] = vsc7514_ptp_regmap,
> > +	[GCB] = vsc7512_gcb_regmap,
> > +	[DEV_GMII] = vsc7514_dev_gmii_regmap,
> > +};
> > +
> > +static void ocelot_ext_reset_phys(struct ocelot *ocelot)
> > +{
> > +	ocelot_write(ocelot, 0, GCB_PHY_PHY_CFG);
> > +	ocelot_write(ocelot, 0x1ff, GCB_PHY_PHY_CFG);
> > +	mdelay(500);
> > +}
> > +
> > +static int ocelot_ext_reset(struct ocelot *ocelot)
> > +{
> > +	int retries = 100;
> > +	int err, val;
> > +
> > +	ocelot_ext_reset_phys(ocelot);
> > +
> > +	/* Initialize chip memories */
> > +	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
> > +	if (err)
> > +		return err;
> > +
> > +	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_INIT], 1);
> > +	if (err)
> > +		return err;
> > +
> > +	/* MEM_INIT is a self-clearing bit. Wait for it to be clear (should be
> > +	 * 100us) before enabling the switch core
> > +	 */
> > +	do {
> > +		msleep(1);
> > +		err = regmap_field_read(ocelot->regfields[SYS_RESET_CFG_MEM_INIT],
> > +					&val);
> > +		if (err)
> > +			return err;
> > +	} while (val && --retries);
> 
> Can you use readx_poll_timeout() here?

It looks like I can, yes. I'll update.

> 
> > +
> > +	if (!retries)
> > +		return -ETIMEDOUT;
> > +
> > +	return regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
> > +}
> > +
> > +static const struct ocelot_ops ocelot_ext_ops = {
> > +	.reset		= ocelot_ext_reset,
> > +	.wm_enc		= ocelot_wm_enc,
> > +	.wm_dec		= ocelot_wm_dec,
> > +	.wm_stat	= ocelot_wm_stat,
> > +	.port_to_netdev	= felix_port_to_netdev,
> > +	.netdev_to_port	= felix_netdev_to_port,
> > +};
> > +
> > +static const struct resource vsc7512_target_io_res[TARGET_MAX] = {
> > +	[ANA] = {
> > +		.start	= 0x71880000,
> > +		.end	= 0x7188ffff,
> > +		.name	= "ana",
> > +	},
> > +	[QS] = {
> > +		.start	= 0x71080000,
> > +		.end	= 0x710800ff,
> > +		.name	= "qs",
> > +	},
> > +	[QSYS] = {
> > +		.start	= 0x71800000,
> > +		.end	= 0x719fffff,
> > +		.name	= "qsys",
> > +	},
> > +	[REW] = {
> > +		.start	= 0x71030000,
> > +		.end	= 0x7103ffff,
> > +		.name	= "rew",
> > +	},
> > +	[SYS] = {
> > +		.start	= 0x71010000,
> > +		.end	= 0x7101ffff,
> > +		.name	= "sys",
> > +	},
> > +	[S0] = {
> > +		.start	= 0x71040000,
> > +		.end	= 0x710403ff,
> > +		.name	= "s0",
> > +	},
> > +	[S1] = {
> > +		.start	= 0x71050000,
> > +		.end	= 0x710503ff,
> > +		.name	= "s1",
> > +	},
> > +	[S2] = {
> > +		.start	= 0x71060000,
> > +		.end	= 0x710603ff,
> > +		.name	= "s2",
> > +	},
> > +	[GCB] =	{
> > +		.start	= 0x71070000,
> > +		.end	= 0x7107022b,
> > +		.name	= "devcpu_gcb",
> > +	},
> > +};
> > +
> > +static const struct resource vsc7512_port_io_res[] = {
> > +	{
> > +		.start	= 0x711e0000,
> > +		.end	= 0x711effff,
> > +		.name	= "port0",
> > +	},
> > +	{
> > +		.start	= 0x711f0000,
> > +		.end	= 0x711fffff,
> > +		.name	= "port1",
> > +	},
> > +	{
> > +		.start	= 0x71200000,
> > +		.end	= 0x7120ffff,
> > +		.name	= "port2",
> > +	},
> > +	{
> > +		.start	= 0x71210000,
> > +		.end	= 0x7121ffff,
> > +		.name	= "port3",
> > +	},
> > +	{
> > +		.start	= 0x71220000,
> > +		.end	= 0x7122ffff,
> > +		.name	= "port4",
> > +	},
> > +	{
> > +		.start	= 0x71230000,
> > +		.end	= 0x7123ffff,
> > +		.name	= "port5",
> > +	},
> > +	{
> > +		.start	= 0x71240000,
> > +		.end	= 0x7124ffff,
> > +		.name	= "port6",
> > +	},
> > +	{
> > +		.start	= 0x71250000,
> > +		.end	= 0x7125ffff,
> > +		.name	= "port7",
> > +	},
> > +	{
> > +		.start	= 0x71260000,
> > +		.end	= 0x7126ffff,
> > +		.name	= "port8",
> > +	},
> > +	{
> > +		.start	= 0x71270000,
> > +		.end	= 0x7127ffff,
> > +		.name	= "port9",
> > +	},
> > +	{
> > +		.start	= 0x71280000,
> > +		.end	= 0x7128ffff,
> > +		.name	= "port10",
> > +	},
> > +};
> > +
> > +static void ocelot_ext_phylink_validate(struct ocelot *ocelot, int port,
> > +					unsigned long *supported,
> > +					struct phylink_link_state *state)
> > +{
> > +	struct ocelot_port *ocelot_port = ocelot->ports[port];
> > +
> > +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> > +
> > +	if (state->interface != PHY_INTERFACE_MODE_NA &&
> 
> This check is no longer necessary, please look again at the other
> phylink validation functions.
> 
> > +	    state->interface != ocelot_port->phy_mode) {
> 
> Also, I don't see what is the point of providing one phylink validation
> method only to replace it later in the patchset with the generic one.
> Please squash "net: dsa: ocelot: utilize phylink_generic_validate" into
> this.

Yes, that was a poor decision on my part to keep that patch separate. I
should have squashed it, since you already pointed this out last round
and that is exactly what the last commit of this series was addressing.

> 
> > +		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
> > +		return;
> > +	}
> > +
> > +	phylink_set_port_modes(mask);
> > +
> > +	phylink_set(mask, Pause);
> > +	phylink_set(mask, Autoneg);
> > +	phylink_set(mask, Asym_Pause);
> > +	phylink_set(mask, 10baseT_Half);
> > +	phylink_set(mask, 10baseT_Full);
> > +	phylink_set(mask, 100baseT_Half);
> > +	phylink_set(mask, 100baseT_Full);
> > +	phylink_set(mask, 1000baseT_Half);
> > +	phylink_set(mask, 1000baseT_Full);
> > +
> > +	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
> > +	bitmap_and(state->advertising, state->advertising, mask,
> > +		   __ETHTOOL_LINK_MODE_MASK_NBITS);
> > +}
> > +
> > +static struct regmap *ocelot_ext_regmap_init(struct ocelot *ocelot,
> > +					     struct resource *res)
> > +{
> > +	return ocelot_init_regmap_from_resource(ocelot->dev, res);
> > +}
> > +
> > +static const struct felix_info vsc7512_info = {
> > +	.target_io_res			= vsc7512_target_io_res,
> > +	.port_io_res			= vsc7512_port_io_res,
> > +	.regfields			= vsc7514_regfields,
> > +	.map				= vsc7512_regmap,
> > +	.ops				= &ocelot_ext_ops,
> > +	.stats_layout			= vsc7514_stats_layout,
> > +	.vcap				= vsc7514_vcap_props,
> > +	.num_mact_rows			= 1024,
> > +	.num_ports			= VSC7512_NUM_PORTS,
> > +	.num_tx_queues			= OCELOT_NUM_TC,
> > +	.phylink_validate		= ocelot_ext_phylink_validate,
> > +	.port_modes			= vsc7512_port_modes,
> > +	.init_regmap			= ocelot_ext_regmap_init,
> > +};
> > +
> > +static int ocelot_ext_probe(struct platform_device *pdev)
> > +{
> > +	struct dsa_switch *ds;
> > +	struct ocelot *ocelot;
> > +	struct felix *felix;
> > +	struct device *dev;
> > +	int err;
> > +
> > +	dev = &pdev->dev;
> 
> I would prefer if this assignment was part of the variable declaration.
> 
> > +
> > +	felix = kzalloc(sizeof(*felix), GFP_KERNEL);
> > +	if (!felix)
> > +		return -ENOMEM;
> > +
> > +	dev_set_drvdata(dev, felix);
> > +
> > +	ocelot = &felix->ocelot;
> > +	ocelot->dev = dev;
> > +
> > +	ocelot->num_flooding_pgids = 1;
> > +
> > +	felix->info = &vsc7512_info;
> > +
> > +	ds = kzalloc(sizeof(*ds), GFP_KERNEL);
> > +	if (!ds) {
> > +		err = -ENOMEM;
> > +		dev_err(dev, "Failed to allocate DSA switch\n");
> > +		goto err_free_felix;
> > +	}
> > +
> > +	ds->dev = dev;
> > +	ds->num_ports = felix->info->num_ports;
> > +	ds->num_tx_queues = felix->info->num_tx_queues;
> > +
> > +	ds->ops = &felix_switch_ops;
> > +	ds->priv = ocelot;
> > +	felix->ds = ds;
> > +	felix->tag_proto = DSA_TAG_PROTO_OCELOT;
> > +
> > +	err = dsa_register_switch(ds);
> > +	if (err) {
> > +		dev_err(dev, "Failed to register DSA switch: %d\n", err);
> 
> dev_err_probe please (look at the other drivers)
> 
> > +		goto err_free_ds;
> > +	}
> > +
> > +	return 0;
> > +
> > +err_free_ds:
> > +	kfree(ds);
> > +err_free_felix:
> > +	kfree(felix);
> > +	return err;
> > +}
> > +
> > +static int ocelot_ext_remove(struct platform_device *pdev)
> > +{
> > +	struct felix *felix = dev_get_drvdata(&pdev->dev);
> > +
> > +	if (!felix)
> > +		return 0;
> > +
> > +	dsa_unregister_switch(felix->ds);
> > +
> > +	kfree(felix->ds);
> > +	kfree(felix);
> > +
> > +	dev_set_drvdata(&pdev->dev, NULL);
> > +
> > +	return 0;
> > +}
> > +
> > +static void ocelot_ext_shutdown(struct platform_device *pdev)
> > +{
> > +	struct felix *felix = dev_get_drvdata(&pdev->dev);
> > +
> > +	if (!felix)
> > +		return;
> > +
> > +	dsa_switch_shutdown(felix->ds);
> > +
> > +	dev_set_drvdata(&pdev->dev, NULL);
> > +}
> > +
> > +const struct of_device_id ocelot_ext_switch_of_match[] = {
> 
> static
> 
> > +	{ .compatible = "mscc,vsc7512-ext-switch" },
> > +	{ },
> > +};
> > +MODULE_DEVICE_TABLE(of, ocelot_ext_switch_of_match);
> > +
> > +static struct platform_driver ocelot_ext_switch_driver = {
> > +	.driver = {
> > +		.name = "ocelot-ext-switch",
> > +		.of_match_table = of_match_ptr(ocelot_ext_switch_of_match),
> > +	},
> > +	.probe = ocelot_ext_probe,
> > +	.remove = ocelot_ext_remove,
> > +	.shutdown = ocelot_ext_shutdown,
> > +};
> > +module_platform_driver(ocelot_ext_switch_driver);
> > +
> > +MODULE_DESCRIPTION("External Ocelot Switch driver");
> > +MODULE_LICENSE("GPL");
> > diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> > index 61888453f913..ade84e86741e 100644
> > --- a/include/soc/mscc/ocelot.h
> > +++ b/include/soc/mscc/ocelot.h
> > @@ -402,6 +402,8 @@ enum ocelot_reg {
> >  	GCB_MIIM_MII_STATUS,
> >  	GCB_MIIM_MII_CMD,
> >  	GCB_MIIM_MII_DATA,
> > +	GCB_PHY_PHY_CFG,
> > +	GCB_PHY_PHY_STAT,
> >  	DEV_CLOCK_CFG = DEV_GMII << TARGET_OFFSET,
> >  	DEV_PORT_MISC,
> >  	DEV_EVENTS,
> > -- 
> > 2.25.1
> >
