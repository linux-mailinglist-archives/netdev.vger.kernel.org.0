Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34ABA4CE7EC
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 01:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbiCFA3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 19:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiCFA3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 19:29:53 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2127.outbound.protection.outlook.com [40.107.93.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400E12459D;
        Sat,  5 Mar 2022 16:29:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TnRYSna/i0pnLnk92ugNZLjMD6s5D9facXWlRQF1p2hCskti7euc4bYR8pPl716NNRtWuY3dtHePyzSx6XbvxBYPIDDfmMPGmjlDT3gUFAEZ/tWf+Gw6W0xXRAzANGNsogjVPRlOp1Y+bwkcc42lhGAur1FH4T4JcIbPO4C2UPrDSzRAY9/vIOJu6/+2poh4kki2+wAnVjQWqnCJuDyKVnQ8B/766vVRsKJ72TKWnYX4PpQyABn8RN7lTD2L8sAxLZ2b9HhV3Ur60EbBz4aQZMZelhjzJb6CMQ06mpamwvbVJUVaGCdGriFJJtN1R3an/InN7N/ruHH7ccLlEnHC4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FhZbgUXrpsH01q7NUhQXi2PBoN3ptSigtbiTQjS2ghk=;
 b=QRQRbpK5PCLCGRGzMnqmKZ0KNTMLw684oLfjCGOz5TLkaKIsnBREXzkV7F5diumYoH5ZITZDR+j5Z1hgzWHonmV7MKmBQd1L/zZmZZtWK1ib3btW6Pxr1V9X1yPPbCHGX2QwRfKt1NNKVWirIm05YgAWy7MQ302Kq8sDf+EkPjfPh+V9Ms7b74wcvlMH425qH4ELUNuQdcJOAYiclHG7QVLBVfXFNFy+6BWLFmem042k3hZamy8BJJ38aiATVgHexBrjto1cXZavx0oWNASYyIIgw33Ynf4nvsdSBrDXFg2CTsyNFUKKXbO/8g4Ekoe2XDkxoswi2ObTXqRSdLJT9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FhZbgUXrpsH01q7NUhQXi2PBoN3ptSigtbiTQjS2ghk=;
 b=vL9RBN8UawXyxf6ID66j4ddepGgByUNSKjTSi3cjh4dBIxblhx+XrIHxa+7+KOuNgsERswoZ2bVrv2dC6PHmDCiOlOU6QhRzoXUSMmUfEVRDLwutiMGLkBrQ7W8sWCK/lczqN4U9ayYdnmVyO2dSS1h/sxWxoe8HWK08AzlmyvQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CY4PR10MB1895.namprd10.prod.outlook.com
 (2603:10b6:903:123::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.19; Sun, 6 Mar
 2022 00:28:57 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5%6]) with mapi id 15.20.5038.026; Sun, 6 Mar 2022
 00:28:57 +0000
Date:   Sat, 5 Mar 2022 16:28:49 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        "katie.morris@in-advantage.com" <katie.morris@in-advantage.com>
Subject: Re: [RFC v6 net-next 9/9] net: dsa: ocelot: add external ocelot
 switch control
Message-ID: <20220306002849.GA1354623@euler>
References: <20220129220221.2823127-1-colin.foster@in-advantage.com>
 <20220129220221.2823127-10-colin.foster@in-advantage.com>
 <20220131185043.tbp6uhpcsvyoeglp@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131185043.tbp6uhpcsvyoeglp@skbuf>
X-ClientProxiedBy: MWHPR22CA0061.namprd22.prod.outlook.com
 (2603:10b6:300:12a::23) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca7f3bf9-30aa-45d9-92e9-08d9ff084d16
X-MS-TrafficTypeDiagnostic: CY4PR10MB1895:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB18953A9C59D7971ADB93DE19A4079@CY4PR10MB1895.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2dfRZPPlFH5xjbxeNOI+gyWD2lYeoVrQLe4h3MR+36jnx0Of/LelWvsB90h7b9rLxgvc1qfyphvrzUe0lZH+q+2yyXF9N/iCD7/xMNxesYACWvpMqPlQWgSEYA1BnibXvmX+jl7fAou9wz8t2yrSnWkr1U5zoRZLspzfx9nPywDfFuhtoBwM74fX0tvpF2PljwmTH3DAAxkWqrFkSqJzF/3Mtra/ShBuFSn7tyAgm/EOLOm6zNnoYQKHP7Qyi43DEeBdLNGi90zBdvcNRZoNku+z8tn2yHGvvn/eOWZ/9+Ko8UJVydeUZE6kM+q3oXdorFk1tMA5pYGD5sJ7mKruGTUyAYmOqJYI5n3KyedP8R/jahIaAystaULwd+f2TuaqSmNozOa6TlnJa1I/FtXJ/yzSZ9Rjj8haDuutK09ndfZQBCacz7nyr8vdXS5Gz3B6KkiKvkQ9WEFGuYZDqicNsJpE/3uTKJFBzYRo39tVmD4BolpumhNzeUVvDed+TtA7U6dK286KJOTQ4m+X0V25KXFqieBDwbksxGI2WVbtNG7K3XhewTweVcjZSQt2FyRG1o+XaJ85Lfl30lkm/WnFztm2vn7tRA5dmkYrRC/vWb/EvV4HIVoiwJOCOTPpScg9+EB2yE6DV7ga3d989cePwyv5d0m0QQm6C4h1JMpN7iVp0uW6XfjxtptI5A6RU8Pi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(39830400003)(376002)(42606007)(396003)(346002)(136003)(366004)(83380400001)(52116002)(9686003)(6666004)(6512007)(6506007)(7416002)(26005)(33656002)(186003)(508600001)(1076003)(107886003)(5660300002)(44832011)(8936002)(86362001)(6486002)(66476007)(30864003)(4326008)(8676002)(66556008)(66946007)(2906002)(6916009)(38100700002)(38350700002)(316002)(33716001)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DtetsmKqhPoXNNEgYYU6hrVZbZBPsBlDMAAY1HF9yvl1QYkb4FNwYgGPynaV?=
 =?us-ascii?Q?hZ4we3hDWIMxwFaibTzuw8n7ceGqb8XCVbisGRabZ7lLWB/wL4s5Mty9k5UM?=
 =?us-ascii?Q?C1yna3myaNnnpdnjauky1VyCYXrO/OSTEn88zFZ7ZTHKVftEuAyszn6QZHsL?=
 =?us-ascii?Q?MGbp6qG8Vc8VYcoG16rp+4ncnI+88FVuHf+tK86O93PzQBPq+XMWFEqFGR4l?=
 =?us-ascii?Q?b/w7ksHs1I0tnR+sbq9MPFX/Z0bj3bP24XdZiE+xSONwW625WSPrpxY74+ck?=
 =?us-ascii?Q?O1W/GqSTUw7x90ffZtu/rzPYavjzvFUh1ssTnNOLMqw3iMMTubOrX+Yd0693?=
 =?us-ascii?Q?fOkgn8tLdV1KFLMFMIPJmUk2aDwIdNJE3r3M+81EDUSjD1mFRiV61R9IoCgy?=
 =?us-ascii?Q?QLv8hE3j+8nT0XHJjqwkD58E65hEUcw5payuqknGmSWM7v3vFMPRJJL/ILha?=
 =?us-ascii?Q?LesMCZhb1GgVC0nDi/l3BQzpcxzkqDWlpO48D8JtafykUs/auYUJvON/5DL9?=
 =?us-ascii?Q?ad5OC9RXOGJG2y0hCCiX6AUag3g9hvDCYQwpzQUbxb6NAMe9xS6gZBVrT3Ic?=
 =?us-ascii?Q?tXBb35tdcIloKtLLxZDT+rrFpW/OkexdtPcQcma+76kLSJnLXRJ1C+ubH6Ba?=
 =?us-ascii?Q?GgtzSqS7ThA/GD9NaikFuH08ExnNl2r4pOBPRSNtPHRl3nxlpRA6fOb/S7a8?=
 =?us-ascii?Q?y/19miToJ0rJXOMdq1W+DEAyJ/79zfSS5ZW19PAawpW5l86oVBzNToy72pvh?=
 =?us-ascii?Q?FXl2+dTUR3qrcWfUGCCB31ViOsLuD84zEiUgMTgszO38pHwilz8oFQ2oLPuo?=
 =?us-ascii?Q?E2zmLmVEIk76Wq/tJ7LQOAzF/r4NCIGeW4byk4VBtTWtCqwB8sKtuRqMeFQt?=
 =?us-ascii?Q?2o9cgSGyKvAHlbNOhdf7JZ0sa5Pas1FgLJI7YqX+i8MlPcK9F/suNj5ydnxb?=
 =?us-ascii?Q?phFVTfDulhEyhQtnez272GtobV7OSLY7VB3HcK5ZSuDsyx3oqr5PvUbURDag?=
 =?us-ascii?Q?ohLVL7VzYRtSiQKW0yqm7sHHypREJIR7AV7eQFPXY+18Innn3GtWaeK6k59d?=
 =?us-ascii?Q?cCyODLc7KjzLJg0DSz3GwaQ5Y7iIodHlYyLXP5Yv3fEiEsnptqyA/bG2SOET?=
 =?us-ascii?Q?h+sqq+LNg1KFsvXcsIusYzXRKNNfNZ02rokvhMDXZ+jBsn8v5WkPuCgA02qt?=
 =?us-ascii?Q?UKsa+HHcokrUQBC+eBXAxe1HvWesSuMKjnmSa30nSS5gu43wGmf64ytDJnTg?=
 =?us-ascii?Q?070uALHIbMN1iCBp85U4ifIaYRGKmwqXh2WIIpyqLnQ4rTD0E4M7WlOeeXFp?=
 =?us-ascii?Q?HjwHDVgTvmNpGZZcl5oxpbCLLo2dGTWnjZZtl56tDOl/KjEPGzn65GHd7ZcA?=
 =?us-ascii?Q?hRGeQHgQpwmwhXnzmi9f+Es6ajZQixhkBPxFV5kyvhivDvb2csy299wdtsBo?=
 =?us-ascii?Q?yR+pSbXhkzttqLCKVF0mPn8772ti+KyoPaLu7qVaVwC+EYe9BLNK/p4gkyJr?=
 =?us-ascii?Q?Jfp9OC66YLqLejQpP55PshMJlN2vtpfbS2ZR2eZviZYoxvCL9NGXMp7wY+iR?=
 =?us-ascii?Q?TFQJhHSGJjwAjWXCjGHUxmWU1Rc4sHvyfHa/IGXWnkB6h6RRBJq0fD1JoFHd?=
 =?us-ascii?Q?aY/nJl+1ZgkHeNv/sJ4PqoQY9HYEJMmlYVEz5M1mu+W2kGwz4+vrAceivqWs?=
 =?us-ascii?Q?Lzz4gw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca7f3bf9-30aa-45d9-92e9-08d9ff084d16
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2022 00:28:57.3094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w5D+qPPDe1yFZrQ4Si+wMcqVd33tFM2Tgl/BOHtcQ3VU6H9BiBKS9ToD0ZmdxlxJBevYHufWy5ofLACJNVyzPgIEB0Ebi4BCW0BZ8f6w+gw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1895
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

My apologies for the delay. As I mentioned in another thread, I went
through the "MFD" updates before getting to these. A couple questions
that might be helpful before I go to the next RFC.

On Mon, Jan 31, 2022 at 06:50:44PM +0000, Vladimir Oltean wrote:
> On Sat, Jan 29, 2022 at 02:02:21PM -0800, Colin Foster wrote:
> > Add control of an external VSC7512 chip by way of the ocelot-mfd interface.
> > 
> > Currently the four copper phy ports are fully functional. Communication to
> > external phys is also functional, but the SGMII / QSGMII interfaces are
> > currently non-functional.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> >  drivers/mfd/ocelot-core.c           |   4 +
> >  drivers/net/dsa/ocelot/Kconfig      |  14 +
> >  drivers/net/dsa/ocelot/Makefile     |   5 +
> >  drivers/net/dsa/ocelot/ocelot_ext.c | 681 ++++++++++++++++++++++++++++
> >  include/soc/mscc/ocelot.h           |   2 +
> >  5 files changed, 706 insertions(+)
> >  create mode 100644 drivers/net/dsa/ocelot/ocelot_ext.c
> > 
> > diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
> > index 590489481b8c..17a77d618e92 100644
> > --- a/drivers/mfd/ocelot-core.c
> > +++ b/drivers/mfd/ocelot-core.c
> > @@ -122,6 +122,10 @@ static const struct mfd_cell vsc7512_devs[] = {
> >  		.num_resources = ARRAY_SIZE(vsc7512_miim1_resources),
> >  		.resources = vsc7512_miim1_resources,
> >  	},
> > +	{
> > +		.name = "ocelot-ext-switch",
> > +		.of_compatible = "mscc,vsc7512-ext-switch",
> > +	},
> >  };
> >  
> >  int ocelot_core_init(struct ocelot_core *core)
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
> > index 000000000000..6fdff016673e
> > --- /dev/null
> > +++ b/drivers/net/dsa/ocelot/ocelot_ext.c
> 
> How about ocelot_vsc7512.c for a name?

I'm not crazy about "ocelot_ext" either... but I intend for this to
support VSC7511, 7512, 7513, and 7514. I'm using 7512 as my starting
point, but 7511 will be in quick succession, so I don't think
ocelot_vsc7512 is appropriate.

I'll update everything that is 7512-specific to be appropriately named.
Addresses, features, etc. As you suggest below, there's some function
names that are still around with the vsc7512 name that I'm changing to
the more generic "ocelot_ext" version.

[ ... ]
> > +static struct ocelot_ext_data *felix_to_ocelot_ext(struct felix *felix)
> > +{
> > +	return container_of(felix, struct ocelot_ext_data, felix);
> > +}
> > +
> > +static struct ocelot_ext_data *ocelot_to_ocelot_ext(struct ocelot *ocelot)
> > +{
> > +	struct felix *felix = ocelot_to_felix(ocelot);
> > +
> > +	return felix_to_ocelot_ext(felix);
> > +}
> 
> I wouldn't mind a "ds_to_felix()" helper, but as mentioned, it would be
> good if you could use struct felix instead of introducing yet one more
> container.
> 

Currently the ocelot_ext struct is unused, and will be removed from v7,
along with these container conversions. I'll keep this in mind if I end
up needing to expand things in the future.

When these were written it was clear that "Felix" had no business
dragging around info about "ocelot_spi," so these conversions seemed
necessary. Now that SPI has been completely removed from this DSA
section, things are a lot cleaner.

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
> > +	struct felix *felix = ocelot_to_felix(ocelot);
> > +	struct device *dev = ocelot->dev;
> > +	struct device_node *mdio_node;
> > +	int retries = 100;
> > +	int err, val;
> > +
> > +	ocelot_ext_reset_phys(ocelot);
> > +
> > +	mdio_node = of_get_child_by_name(dev->of_node, "mdio");
> 
>  * Return: A node pointer if found, with refcount incremented, use
>  * of_node_put() on it when done.
> 
> There's no "of_node_put()" below.
> 
> > +	if (!mdio_node)
> > +		dev_info(ocelot->dev,
> > +			 "mdio children not found in device tree\n");
> > +
> > +	err = of_mdiobus_register(felix->imdio, mdio_node);
> > +	if (err) {
> > +		dev_err(ocelot->dev, "error registering MDIO bus\n");
> > +		return err;
> > +	}
> > +
> > +	felix->ds->slave_mii_bus = felix->imdio;
> 
> A bit surprised to see MDIO bus registration in ocelot_ops :: reset and
> not in felix_info :: mdio_bus_alloc.

These are both good catches. Thanks! This one in particular was a relic
of the initial spi_device design - no communication could have been
performed at all until after the bus was getting initailized... which
was in reset at the time.

Now it is in the MFD core initialization.

This brings up a question that I think you were getting at when MFD was
first discussed for this driver:

Should Felix know anything about the chip's internal MDIO bus? Or should
the internal bus be a separate entry in the MFD?

Currently my DT is structured as:

&spi0 {
        ocelot-chip@0 {
                compatible = "mscc,vsc7512_mfd_spi";
                ethernet-switch@0 {
                        compatible = "mscc,vsc7512-ext-switch";
                        ports {
                        };

                        /* Internal MDIO port here */
                        mdio {
                        };
                };
                /* External MDIO port here */
                mdio1: mdio1 {
                        compatible = "mscc,ocelot-miim";
                };
                /* Additional peripherals here - pinctrl, sgpio, hsio... */
                gpio: pinctrl@0 {
                        compatible = "mscc,ocelot-pinctrl"
                };
                ...
        };
};


Should it instead be:

&spi0 {
        ocelot-chip@0 {
                compatible = "mscc,vsc7512_mfd_spi";
                ethernet-switch@0 {
                        compatible = "mscc,vsc7512-ext-switch";
                        ports {
                        };
                };
                /* Internal MDIO port here */
                mdio0: mdio0 {
                        compatible = "mscc,ocelot-miim"
                };
                /* External MDIO port here */
                mdio1: mdio1 {
                        compatible = "mscc,ocelot-miim";
                };
                /* Additional peripherals here - pinctrl, sgpio, hsio... */
                gpio: pinctrl@0 {
                        compatible = "mscc,ocelot-pinctrl"
                };
                ...
        };
};

That way I could get rid of mdio_bus_alloc entirely. (I just tried it
and it didn't "just work" but I'll do a little debugging)

The more I think about it the more I think this is the correct path to
go down.

[ ... ]
> > +		return err;
> > +
> > +	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
> > +	if (err)
> > +		return err;
> > +
> > +	do {
> > +		msleep(1);
> > +		regmap_field_read(ocelot->regfields[SYS_RESET_CFG_MEM_INIT],
> > +				  &val);
> > +	} while (val && --retries);
> > +
> > +	if (!retries)
> > +		return -ETIMEDOUT;
> > +
> > +	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
> > +
> > +	return err;
> 
> "err = ...; return err" can be turned into "return ..." if it weren't
> for error handling. But you need to handle errors.

With this error handling during a reset... these errors get handled in
the main ocelot switch library by way of ocelot->ops->reset().

I can add additional dev_err messages on all these calls if that would
be useful.

[ ... ]
> > +static void vsc7512_mdio_bus_free(struct ocelot *ocelot)
> > +{
> > +	struct felix *felix = ocelot_to_felix(ocelot);
> > +
> > +	if (felix->imdio)
> 
> I don't think the conditional is warranted here? Did you notice a call
> path where you were called while felix->imdio was NULL?
> 

You're right. It was probably necessary for me to get off the ground,
but not anymore. Removed.

[ ... ]
> > +static int ocelot_ext_probe(struct platform_device *pdev)
> > +{
> > +	struct ocelot_ext_data *ocelot_ext;
> > +	struct dsa_switch *ds;
> > +	struct ocelot *ocelot;
> > +	struct felix *felix;
> > +	struct device *dev;
> > +	int err;
> > +
> > +	dev = &pdev->dev;
> > +
> > +	ocelot_ext = devm_kzalloc(dev, sizeof(struct ocelot_ext_data),
> > +				  GFP_KERNEL);
> > +
> > +	if (!ocelot_ext)
> 
> Try to omit blank lines between an assignment and the proceeding sanity
> checks. Also, try to stick to either using devres everywhere, or nowhere,
> within the same function at least.

I switched both calls to not use devres and free both of these in remove
now. However... (comments below)

> 
> > +		return -ENOMEM;
> > +
> > +	dev_set_drvdata(dev, ocelot_ext);
> > +
> > +	ocelot_ext->port_modes = vsc7512_port_modes;
> > +	felix = &ocelot_ext->felix;
> > +
> > +	ocelot = &felix->ocelot;
> > +	ocelot->dev = dev;
> > +
> > +	ocelot->num_flooding_pgids = 1;
> > +
> > +	felix->info = &ocelot_ext_info;
> > +
> > +	ds = kzalloc(sizeof(*ds), GFP_KERNEL);
> > +	if (!ds) {
> > +		err = -ENOMEM;
> > +		dev_err(dev, "Failed to allocate DSA switch\n");
> > +		return err;
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
> > +
> > +	if (err) {
> > +		dev_err(dev, "Failed to register DSA switch: %d\n", err);
> > +		goto err_register_ds;
> > +	}
> > +
> > +	return 0;
> > +
> > +err_register_ds:
> > +	kfree(ds);
> > +	return err;
> > +}
> > +
> > +static int ocelot_ext_remove(struct platform_device *pdev)
> > +{
> > +	struct ocelot_ext_data *ocelot_ext;
> > +	struct felix *felix;
> > +
> > +	ocelot_ext = dev_get_drvdata(&pdev->dev);
> > +	felix = &ocelot_ext->felix;
> > +
> > +	dsa_unregister_switch(felix->ds);
> > +
> > +	kfree(felix->ds);
> > +
> > +	devm_kfree(&pdev->dev, ocelot_ext);
> 
> What is the point of devm_kfree?
> 
> > +
> > +	return 0;
> > +}
> > +
> > +const struct of_device_id ocelot_ext_switch_of_match[] = {
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
> 
> Please blindly follow the pattern of every other DSA driver, with a
> ->remove and ->shutdown method that run either one, or the other, by
> checking whether dev_get_drvdata() has been set to NULL by the other one
> or not. And call dsa_switch_shutdown() from ocelot_ext_shutdown() (or
> vsc7512_shutdown, or whatever you decide to call it).

... I assume there's no worry that kfree gets called in each driver's
remove routine but not in their shutdown? I'll read through commit
0650bf52b31f (net: dsa: be compatible with masters which unregister on shutdown)
to get a more thorough understanding of what's going on... but will
blindly follow for now. :-)

> 
> > +};
> > +module_platform_driver(ocelot_ext_switch_driver);
> > +
> > +MODULE_DESCRIPTION("External Ocelot Switch driver");
> > +MODULE_LICENSE("GPL v2");
> > diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> > index 8b8ebede5a01..62cd61d4142e 100644
> > --- a/include/soc/mscc/ocelot.h
> > +++ b/include/soc/mscc/ocelot.h
> > @@ -399,6 +399,8 @@ enum ocelot_reg {
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
