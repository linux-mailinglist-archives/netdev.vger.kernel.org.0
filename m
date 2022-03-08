Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D59234D0D86
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 02:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344260AbiCHBcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 20:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234504AbiCHBcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 20:32:05 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2130.outbound.protection.outlook.com [40.107.223.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2B138BD6;
        Mon,  7 Mar 2022 17:31:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hwDEK4lVsEoVEt3OwQqSdISr+e/S8Z+SGqEYynrCnxPNBbDulslJQ4+tCKbgC8u3KTEfVEUAYxWCEJT2j3RmZIm8k9MFpzXoUki9jsWIabzhIe96B45cf2n7+l+nxVTBGyFGYXeICd62DdY600ngmizrAaEzj+M040SGz2Ikc2MqQDq2epJh2SqmtcZJOaYkF5n8NATfRFq/Qdsb4lMb2EH0RdZSffCD8iQGT5uNX/7Aa3uNFO4ldOs8JrRrCnfJqdU6oKW5I52kxnQUtqfc1j3W/xzrurDweyGoNXRwLxC2pk9Ve3ZSiz5COU95xt4cgBpOLLu6+Cs+AAtlFsN8lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x6eodwWK0Yw9sW73ZIXPms/JtHdT3t/IV1IknG1qP0Y=;
 b=eAWhHBlzB7jf1Okw//bVHCBYG59EJvb8KjMl1GEBZE3enaj/IgTLOqb7SEuwUH1yi31YgWwBVxc7UVQvjWAcZgbxK+U1f+t9wLsOKDgupoGZ6WQ4gYJi0bO+VkRCrlnCssEqxOsDp0LvSmoCrQYiK0SWQyGpiq1RVbyoieGV76ctH7P+zTyArgX6osfQEDmuVLPsp3n3deXvptCzIwLbM/HPeB5/t0R+UDlk44bChTa7I4wbSh8Jmx9CimRC6gsOZKTWRwc/emFra7RnW+n5Vn5h2daMfZUTSvQOlRdmGofyY5YcCwHZf8tMglkmynDjvR9SMUdvvNBCeb6Ljmxehg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x6eodwWK0Yw9sW73ZIXPms/JtHdT3t/IV1IknG1qP0Y=;
 b=pElpEXnM+1IQAtMuZhlBiozWst+UFlR8x0DGOFLk6BUyUWdhJYD+9V6LL3NT86NblO4puW17V2+2vQtZN+V9qNBaR1ZCCG3gt0oib+FxHet0G8JW7ayNsPOCD81ctAifLNEom0ZxEX1tjrQZ1Sl25KmCze8E7pqoREpJ9eXH/Mc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN0PR10MB5365.namprd10.prod.outlook.com
 (2603:10b6:408:117::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 01:31:05 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5%6]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 01:31:05 +0000
Date:   Mon, 7 Mar 2022 17:31:15 -0800
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
Message-ID: <20220308013115.GA22396@COLIN-DESKTOP1.localdomain>
References: <20220129220221.2823127-1-colin.foster@in-advantage.com>
 <20220129220221.2823127-10-colin.foster@in-advantage.com>
 <20220131185043.tbp6uhpcsvyoeglp@skbuf>
 <20220306002849.GA1354623@euler>
 <20220307215137.bpsq3c2cczflzvro@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220307215137.bpsq3c2cczflzvro@skbuf>
X-ClientProxiedBy: MW4P222CA0028.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::33) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71986566-80bb-403a-bd52-08da00a34f08
X-MS-TrafficTypeDiagnostic: BN0PR10MB5365:EE_
X-Microsoft-Antispam-PRVS: <BN0PR10MB53656434BF280C7C653885F1A4099@BN0PR10MB5365.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 96V0exx8J/eVyoqnNE6Eku4Bf1HOS1Okf1bXRDR6Op1d+X721Cn9B+czK3yDyGGVGzi95LetqlaCnI6PwIEzKOxw4ZD4KigDB765EOfRgdCOqPlJ3YJn74Hmf5Ii1DLN0kbw2xcGy/9NZ3gSCau0fmDDUyYTZYHoOJ5jYfURJCghzdXEC99MEliWZb7di62XHyb1s/Hg5gh9HVZw2wXYRAYGI+bshP3C68beOPjuAhiHm7+JA5hDZPnGLuO6TAo2/6WE/H00cRZmmASDuNi+VrB9J+hWcSp4AiBbYPEulzXllCd0zhOdliIvqpijpsP2wwLkWzjcSopdt3KpjeCVx5SrbsrotBmdgKvZet9Wn7NfwKg+qGBk5xBp9w+Qp5RvsUJf1n7fFci/T78CE/E5cCd6SjWxKKvnVaOa4KFMGtWx8heFKnoGECBt2/AmR9p+pNeGqvFBN+EKhtPVGRp5NcRdyITzw2kJmqkltTrIArELhnrkLVJOC6qVaF0NHjn6cspj6iQX5VeekmbUN5V3tC8hzGjjbCZI16syMduJI8G2uKZoRo6kL7S9WYLFUHzKdpyhEhT0DIemsksspjV66GJa/NIuWVvGwCcE9wTn8xl/bpvEhZkoiGUMlypGNaWt9rjOIkrqqIot4aDPe+evjQi4niOh99NSWWWoC5ijNofFftzOZTbuAvd8AOCWtj99iM+2I1ife3VnR28p1Myx7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(376002)(136003)(366004)(42606007)(346002)(396003)(26005)(6486002)(83380400001)(186003)(6916009)(316002)(1076003)(8936002)(7416002)(107886003)(54906003)(508600001)(66946007)(4326008)(8676002)(66556008)(66476007)(33656002)(9686003)(6512007)(86362001)(38100700002)(38350700002)(30864003)(44832011)(5660300002)(6666004)(2906002)(6506007)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GOaJZ5Y+IkpZQ5XP9IEjAKVXfl0hpMzbOMnqsyd/ncgnOH/gNAQWHNAcW/vW?=
 =?us-ascii?Q?EN1PyaG8vXjf7hQ66lK4DE4SruAC2HVARSNbBssG75tCdMEH8wZoLc/E8M7N?=
 =?us-ascii?Q?CLsHRioj1tblNYmf29k7njUoWvex+xre/Gy/pF+ZaRFDiHgzM7cAwgtx7Hdg?=
 =?us-ascii?Q?gd3ytq6l+dcVwRGH5eG1cfkyym3ufPRFNL2BR0OojkTSguCLC/xyA/8Bc5tm?=
 =?us-ascii?Q?aX+AQ9C9UnvYbIy0dcN8GQeHJRXVCdoggZoZ4TCN4N7JwLzJCwR/mPcUNh+k?=
 =?us-ascii?Q?9YXpFvrqjWX7oUaOIWGz4nVUYZ5yyeEzvAguc8JjkvnA33VWQKPT4BlX5w45?=
 =?us-ascii?Q?VYRPwFyMPPbJzecNhjhGdeUq9n65QAXfe4OagtkPrD3S5gNQDlmsZ06VZBUW?=
 =?us-ascii?Q?VhZCQ8tGE9qgEJIG+hCQ+f6Awm2Db1eKftT77+SVKbUzoKx14sYpEKbHkUFj?=
 =?us-ascii?Q?yjqrHU+bag3YOTQ6pTYHNTOT50SjjR9boZUYqCgFG0i+dyG5szq9TXIRst1H?=
 =?us-ascii?Q?Vsk7gQhD5DSA6T7aU6baGcsiDPcBAAPWxXeQEaspcPhbc19lenGvOB5EYzYE?=
 =?us-ascii?Q?UuRi1C1DemYj1FURQm/lA06olydiQbmL/6loFgifdHdREU78zJcD64++TZ3U?=
 =?us-ascii?Q?qUcWzhifH/of7UGdd8O6pwf4pUzXDMDe+59f+/AytfZjum7+Sao9aF4nsSPU?=
 =?us-ascii?Q?4lAzRQ2akGkbdWlzmHWj36C7JeerDnb/0pDel5RWrFIEyvMIc5GCL5OWQB/s?=
 =?us-ascii?Q?nFpDXcsuBMv5cQQSA4gH4QMSKMkYSmZbYTdkLBfK6EFznpv4lYcEqb9AKH5O?=
 =?us-ascii?Q?qJEeuY5Q5IwispMd4ETByxhrsingdwpnHafsu52u0B6AF7Y+qEZ16OW0SW5m?=
 =?us-ascii?Q?iiIVDRLAEDsuOeJbB7Lmju9rvETpxVifc4dgpi3/ZBeEPV7YhVKRziy4xZKr?=
 =?us-ascii?Q?DoOloY0o6uydKOaws/AievUNyfdzA2gvDHVCCbfG2C2zv6x7/rv6DOvfh6EJ?=
 =?us-ascii?Q?IBVLh5t20BLV0ahNcqiUGtqu23xwC81rUdzO8h0YjHfBatT2XKCobnjkQC+P?=
 =?us-ascii?Q?TUvGsUexBUVWDA2v4+4vwNrbt4PXx7OHcD7tURH1FLShhaG6WG0D81DR599G?=
 =?us-ascii?Q?ktqzYi33qERx0o0K1GtVMPJ3ULTptC9++BZGJrWizLfau7+feLg377edtSWs?=
 =?us-ascii?Q?Pi/9Zm3ksFBlTuzztxxJij25p38FT37uLj/zqjgZ9i2ut9MLYxfSZNHy/jnx?=
 =?us-ascii?Q?JKyX3CXgPhv1ivDRrjdyOnaMXxvPkdLfUi+5v6/k0gRPfHYkGgjYhOo26JDs?=
 =?us-ascii?Q?90yX4SD9wQ/bOYN8wsVFor2UQiCU4IG7vnZmb8jqcIkO2ONAbh/MCKYCfcWF?=
 =?us-ascii?Q?XEtB725opvQc/YsKSj/qqeBg+/2TKzyierjPWGp1c3c3hKXmTAzNUgqV+VbS?=
 =?us-ascii?Q?Oa1lI/NqNkvcRSX5o38H5yRgPzmKTF5rIJg6WECnCI19287hLIbXthsxi8Iy?=
 =?us-ascii?Q?9mTM3rxUIjLo+MK3Z2EHa0Awb3hNJ6zUordTE3dusNP+Y6p1XOEX3xo++2VX?=
 =?us-ascii?Q?FELWaxi4gU+OR5I+Qm1pMQlWGVxzOyGkMn2ZCYYpbgmSkODQ8F9BheGWx9pm?=
 =?us-ascii?Q?+FZ0n3hhHO3UOcxJU43RjHipGbEGLX1qnDzUxTCMfixYlmiREvF/C+jSoxX+?=
 =?us-ascii?Q?cSYTGg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71986566-80bb-403a-bd52-08da00a34f08
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 01:31:04.9174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tLJMyW8HN+WGtAS+Zd+wCBg62kx/DVFoKDIlP+7oH2qNYdZ02DPbjXMDL+tuC+YOIgEGfBLGWqLSv4F8/koykIgMlQfpmgo2gln5qaOX2u0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5365
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Mon, Mar 07, 2022 at 09:51:38PM +0000, Vladimir Oltean wrote:
> On Sat, Mar 05, 2022 at 04:28:49PM -0800, Colin Foster wrote:
> > Hi Vladimir,
> > 
> > My apologies for the delay. As I mentioned in another thread, I went
> > through the "MFD" updates before getting to these. A couple questions
> > that might be helpful before I go to the next RFC.
> > 
> > On Mon, Jan 31, 2022 at 06:50:44PM +0000, Vladimir Oltean wrote:
> > > On Sat, Jan 29, 2022 at 02:02:21PM -0800, Colin Foster wrote:
> > > > Add control of an external VSC7512 chip by way of the ocelot-mfd interface.
> > > > 
> > > > Currently the four copper phy ports are fully functional. Communication to
> > > > external phys is also functional, but the SGMII / QSGMII interfaces are
> > > > currently non-functional.
> > > > 
> > > > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > > > ---
> > > >  drivers/mfd/ocelot-core.c           |   4 +
> > > >  drivers/net/dsa/ocelot/Kconfig      |  14 +
> > > >  drivers/net/dsa/ocelot/Makefile     |   5 +
> > > >  drivers/net/dsa/ocelot/ocelot_ext.c | 681 ++++++++++++++++++++++++++++
> > > >  include/soc/mscc/ocelot.h           |   2 +
> > > >  5 files changed, 706 insertions(+)
> > > >  create mode 100644 drivers/net/dsa/ocelot/ocelot_ext.c
> > > > 
> > > > diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
> > > > index 590489481b8c..17a77d618e92 100644
> > > > --- a/drivers/mfd/ocelot-core.c
> > > > +++ b/drivers/mfd/ocelot-core.c
> > > > @@ -122,6 +122,10 @@ static const struct mfd_cell vsc7512_devs[] = {
> > > >  		.num_resources = ARRAY_SIZE(vsc7512_miim1_resources),
> > > >  		.resources = vsc7512_miim1_resources,
> > > >  	},
> > > > +	{
> > > > +		.name = "ocelot-ext-switch",
> > > > +		.of_compatible = "mscc,vsc7512-ext-switch",
> > > > +	},
> > > >  };
> > > >  
> > > >  int ocelot_core_init(struct ocelot_core *core)
> > > > diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
> > > > index 220b0b027b55..f40b2c7171ad 100644
> > > > --- a/drivers/net/dsa/ocelot/Kconfig
> > > > +++ b/drivers/net/dsa/ocelot/Kconfig
> > > > @@ -1,4 +1,18 @@
> > > >  # SPDX-License-Identifier: GPL-2.0-only
> > > > +config NET_DSA_MSCC_OCELOT_EXT
> > > > +	tristate "Ocelot External Ethernet switch support"
> > > > +	depends on NET_DSA && SPI
> > > > +	depends on NET_VENDOR_MICROSEMI
> > > > +	select MDIO_MSCC_MIIM
> > > > +	select MFD_OCELOT_CORE
> > > > +	select MSCC_OCELOT_SWITCH_LIB
> > > > +	select NET_DSA_TAG_OCELOT_8021Q
> > > > +	select NET_DSA_TAG_OCELOT
> > > > +	help
> > > > +	  This driver supports the VSC7511, VSC7512, VSC7513 and VSC7514 chips
> > > > +	  when controlled through SPI. It can be used with the Microsemi dev
> > > > +	  boards and an external CPU or custom hardware.
> > > > +
> > > >  config NET_DSA_MSCC_FELIX
> > > >  	tristate "Ocelot / Felix Ethernet switch support"
> > > >  	depends on NET_DSA && PCI
> > > > diff --git a/drivers/net/dsa/ocelot/Makefile b/drivers/net/dsa/ocelot/Makefile
> > > > index f6dd131e7491..d7f3f5a4461c 100644
> > > > --- a/drivers/net/dsa/ocelot/Makefile
> > > > +++ b/drivers/net/dsa/ocelot/Makefile
> > > > @@ -1,11 +1,16 @@
> > > >  # SPDX-License-Identifier: GPL-2.0-only
> > > >  obj-$(CONFIG_NET_DSA_MSCC_FELIX) += mscc_felix.o
> > > > +obj-$(CONFIG_NET_DSA_MSCC_OCELOT_EXT) += mscc_ocelot_ext.o
> > > >  obj-$(CONFIG_NET_DSA_MSCC_SEVILLE) += mscc_seville.o
> > > >  
> > > >  mscc_felix-objs := \
> > > >  	felix.o \
> > > >  	felix_vsc9959.o
> > > >  
> > > > +mscc_ocelot_ext-objs := \
> > > > +	felix.o \
> > > > +	ocelot_ext.o
> > > > +
> > > >  mscc_seville-objs := \
> > > >  	felix.o \
> > > >  	seville_vsc9953.o
> > > > diff --git a/drivers/net/dsa/ocelot/ocelot_ext.c b/drivers/net/dsa/ocelot/ocelot_ext.c
> > > > new file mode 100644
> > > > index 000000000000..6fdff016673e
> > > > --- /dev/null
> > > > +++ b/drivers/net/dsa/ocelot/ocelot_ext.c
> > > 
> > > How about ocelot_vsc7512.c for a name?
> > 
> > I'm not crazy about "ocelot_ext" either... but I intend for this to
> > support VSC7511, 7512, 7513, and 7514. I'm using 7512 as my starting
> > point, but 7511 will be in quick succession, so I don't think
> > ocelot_vsc7512 is appropriate.
> > 
> > I'll update everything that is 7512-specific to be appropriately named.
> > Addresses, features, etc. As you suggest below, there's some function
> > names that are still around with the vsc7512 name that I'm changing to
> > the more generic "ocelot_ext" version.
> > 
> > [ ... ]
> > > > +static struct ocelot_ext_data *felix_to_ocelot_ext(struct felix *felix)
> > > > +{
> > > > +	return container_of(felix, struct ocelot_ext_data, felix);
> > > > +}
> > > > +
> > > > +static struct ocelot_ext_data *ocelot_to_ocelot_ext(struct ocelot *ocelot)
> > > > +{
> > > > +	struct felix *felix = ocelot_to_felix(ocelot);
> > > > +
> > > > +	return felix_to_ocelot_ext(felix);
> > > > +}
> > > 
> > > I wouldn't mind a "ds_to_felix()" helper, but as mentioned, it would be
> > > good if you could use struct felix instead of introducing yet one more
> > > container.
> > > 
> > 
> > Currently the ocelot_ext struct is unused, and will be removed from v7,
> > along with these container conversions. I'll keep this in mind if I end
> > up needing to expand things in the future.
> > 
> > When these were written it was clear that "Felix" had no business
> > dragging around info about "ocelot_spi," so these conversions seemed
> > necessary. Now that SPI has been completely removed from this DSA
> > section, things are a lot cleaner.
> > 
> > > > +
> > > > +static void ocelot_ext_reset_phys(struct ocelot *ocelot)
> > > > +{
> > > > +	ocelot_write(ocelot, 0, GCB_PHY_PHY_CFG);
> > > > +	ocelot_write(ocelot, 0x1ff, GCB_PHY_PHY_CFG);
> > > > +	mdelay(500);
> > > > +}
> > > > +
> > > > +static int ocelot_ext_reset(struct ocelot *ocelot)
> > > > +{
> > > > +	struct felix *felix = ocelot_to_felix(ocelot);
> > > > +	struct device *dev = ocelot->dev;
> > > > +	struct device_node *mdio_node;
> > > > +	int retries = 100;
> > > > +	int err, val;
> > > > +
> > > > +	ocelot_ext_reset_phys(ocelot);
> > > > +
> > > > +	mdio_node = of_get_child_by_name(dev->of_node, "mdio");
> > > 
> > >  * Return: A node pointer if found, with refcount incremented, use
> > >  * of_node_put() on it when done.
> > > 
> > > There's no "of_node_put()" below.
> > > 
> > > > +	if (!mdio_node)
> > > > +		dev_info(ocelot->dev,
> > > > +			 "mdio children not found in device tree\n");
> > > > +
> > > > +	err = of_mdiobus_register(felix->imdio, mdio_node);
> > > > +	if (err) {
> > > > +		dev_err(ocelot->dev, "error registering MDIO bus\n");
> > > > +		return err;
> > > > +	}
> > > > +
> > > > +	felix->ds->slave_mii_bus = felix->imdio;
> > > 
> > > A bit surprised to see MDIO bus registration in ocelot_ops :: reset and
> > > not in felix_info :: mdio_bus_alloc.
> > 
> > These are both good catches. Thanks! This one in particular was a relic
> > of the initial spi_device design - no communication could have been
> > performed at all until after the bus was getting initailized... which
> > was in reset at the time.
> > 
> > Now it is in the MFD core initialization.
> > 
> > This brings up a question that I think you were getting at when MFD was
> > first discussed for this driver:
> > 
> > Should Felix know anything about the chip's internal MDIO bus? Or should
> > the internal bus be a separate entry in the MFD?
> > 
> > Currently my DT is structured as:
> > 
> > &spi0 {
> >         ocelot-chip@0 {
> >                 compatible = "mscc,vsc7512_mfd_spi";
> >                 ethernet-switch@0 {
> >                         compatible = "mscc,vsc7512-ext-switch";
> >                         ports {
> >                         };
> > 
> >                         /* Internal MDIO port here */
> >                         mdio {
> >                         };
> >                 };
> >                 /* External MDIO port here */
> >                 mdio1: mdio1 {
> >                         compatible = "mscc,ocelot-miim";
> >                 };
> >                 /* Additional peripherals here - pinctrl, sgpio, hsio... */
> >                 gpio: pinctrl@0 {
> >                         compatible = "mscc,ocelot-pinctrl"
> >                 };
> >                 ...
> >         };
> > };
> > 
> > 
> > Should it instead be:
> > 
> > &spi0 {
> >         ocelot-chip@0 {
> >                 compatible = "mscc,vsc7512_mfd_spi";
> >                 ethernet-switch@0 {
> >                         compatible = "mscc,vsc7512-ext-switch";
> >                         ports {
> >                         };
> >                 };
> >                 /* Internal MDIO port here */
> >                 mdio0: mdio0 {
> >                         compatible = "mscc,ocelot-miim"
> >                 };
> >                 /* External MDIO port here */
> >                 mdio1: mdio1 {
> >                         compatible = "mscc,ocelot-miim";
> >                 };
> >                 /* Additional peripherals here - pinctrl, sgpio, hsio... */
> >                 gpio: pinctrl@0 {
> >                         compatible = "mscc,ocelot-pinctrl"
> >                 };
> >                 ...
> >         };
> > };
> > 
> > That way I could get rid of mdio_bus_alloc entirely. (I just tried it
> > and it didn't "just work" but I'll do a little debugging)
> > 
> > The more I think about it the more I think this is the correct path to
> > go down.
> 
> As I've mentioned in the past, on NXP switches (felix/seville), there
> was a different justification. There, the internal MDIO bus is used to
> access the SGMII PCS, not any internal PHY as in the ocelot-ext case.
> As opposed to the 'phy-handle' that describes the relationship between a
> MAC and its (internal) PHY, no such equivalent 'pcs-handle' property
> exists in a standardized form. So I wanted to avoid a dependency on OF
> where the drivers would not learn any actual information from it.
> 
> It is also possible to have a non-OF based connection to the internal
> PHY, but that has some limitations, because DSA has a lot of legacy in
> this area. 'Non OF-based' means that there is a port which lacks both
> 'phy-handle' and 'fixed-link'. We have said that a user port with such
> an OF node should be interpreted as having an internal PHY located on
> the ds->slave_mii_bus at a PHY address equal to the port index.
> Whereas the same conditions (no 'phy-handle', no 'fixed-link') on a CPU
> port mean that the port is a fixed-link that operates at the largest
> supported link speed.

I see. And there was a comment a while back... I believe it was
Alexandre suggested there was some of consideration in the design to
support the non-OF-based cases. I hope I'm getting a better idea of the
big picture... one piece at a time.

> 
> Since you have a PHY on the CPU port, I'd tend to avoid any ambiguity
> and explicitly specify the 'phy-handle', 'fixed-link' properties in the
> device tree.

Yes, you suggested this early on. Thank you for guiding me down the
right path.

> 
> What I'm not completely sure about is whether you really have 2 MDIO
> buses. I don't have a VSC7512, and I haven't checked the datasheet
> (traveling right now) but this would be surprising to me.
> Anyway, if you do, then at least try to match the $nodename pattern from
> Documentation/devicetree/bindings/net/mdio.yaml. I don't think "mdio0"
> matches "^mdio(@.*)?".

Safe travels!

I was really surprised about the two MDIO buses as well. My coworker
pointed this out to me right before I decided to start looking into the
external phys and probably saved me a week of datasheet shuffling / scope
probing. Especially since the MDIO bus 2 addresses are pin-strapped to 
start at 4, seemingly to not overlap the internal MDIO addresses 0-3.

And the two MDIO buses also exist in
arch/mips/boot/dts/mscc/ocelot.dtsi, so I know I'm not crazy.

I'll update the node names in my tree per your suggestion. I figured
there'd be no desire for me sharing a .dtsi for my boot-pin-modified dev
board configuration. Maybe I'm wrong, and sharing the relevant portions
in cover letters is not the right thing to do.

> 
> > [ ... ]
> > > > +		return err;
> > > > +
> > > > +	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
> > > > +	if (err)
> > > > +		return err;
> > > > +
> > > > +	do {
> > > > +		msleep(1);
> > > > +		regmap_field_read(ocelot->regfields[SYS_RESET_CFG_MEM_INIT],
> > > > +				  &val);
> > > > +	} while (val && --retries);
> > > > +
> > > > +	if (!retries)
> > > > +		return -ETIMEDOUT;
> > > > +
> > > > +	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
> > > > +
> > > > +	return err;
> > > 
> > > "err = ...; return err" can be turned into "return ..." if it weren't
> > > for error handling. But you need to handle errors.
> > 
> > With this error handling during a reset... these errors get handled in
> > the main ocelot switch library by way of ocelot->ops->reset().
> > 
> > I can add additional dev_err messages on all these calls if that would
> > be useful.
> 
> Please interpret this in context. Your ocelot_ext_reset() function calls
> of_mdiobus_register(), then does other work which may fail, then returns
> that error code while leaving the MDIO bus dangling. When I said "you
> need to handle errors" I meant "you need to unwind whatever work is done
> in the function in the case of an error". If you are going to remove the
> of_mdiobus_register(), there is probably not much left.

Thanks for explaining this. Understood.

> 
> > [ ... ]
> > > > +static void vsc7512_mdio_bus_free(struct ocelot *ocelot)
> > > > +{
> > > > +	struct felix *felix = ocelot_to_felix(ocelot);
> > > > +
> > > > +	if (felix->imdio)
> > > 
> > > I don't think the conditional is warranted here? Did you notice a call
> > > path where you were called while felix->imdio was NULL?
> > > 
> > 
> > You're right. It was probably necessary for me to get off the ground,
> > but not anymore. Removed.
> > 
> > [ ... ]
> > > > +static int ocelot_ext_probe(struct platform_device *pdev)
> > > > +{
> > > > +	struct ocelot_ext_data *ocelot_ext;
> > > > +	struct dsa_switch *ds;
> > > > +	struct ocelot *ocelot;
> > > > +	struct felix *felix;
> > > > +	struct device *dev;
> > > > +	int err;
> > > > +
> > > > +	dev = &pdev->dev;
> > > > +
> > > > +	ocelot_ext = devm_kzalloc(dev, sizeof(struct ocelot_ext_data),
> > > > +				  GFP_KERNEL);
> > > > +
> > > > +	if (!ocelot_ext)
> > > 
> > > Try to omit blank lines between an assignment and the proceeding sanity
> > > checks. Also, try to stick to either using devres everywhere, or nowhere,
> > > within the same function at least.
> > 
> > I switched both calls to not use devres and free both of these in remove
> > now. However... (comments below)
> > 
> > > 
> > > > +		return -ENOMEM;
> > > > +
> > > > +	dev_set_drvdata(dev, ocelot_ext);
> > > > +
> > > > +	ocelot_ext->port_modes = vsc7512_port_modes;
> > > > +	felix = &ocelot_ext->felix;
> > > > +
> > > > +	ocelot = &felix->ocelot;
> > > > +	ocelot->dev = dev;
> > > > +
> > > > +	ocelot->num_flooding_pgids = 1;
> > > > +
> > > > +	felix->info = &ocelot_ext_info;
> > > > +
> > > > +	ds = kzalloc(sizeof(*ds), GFP_KERNEL);
> > > > +	if (!ds) {
> > > > +		err = -ENOMEM;
> > > > +		dev_err(dev, "Failed to allocate DSA switch\n");
> > > > +		return err;
> > > > +	}
> > > > +
> > > > +	ds->dev = dev;
> > > > +	ds->num_ports = felix->info->num_ports;
> > > > +	ds->num_tx_queues = felix->info->num_tx_queues;
> > > > +
> > > > +	ds->ops = &felix_switch_ops;
> > > > +	ds->priv = ocelot;
> > > > +	felix->ds = ds;
> > > > +	felix->tag_proto = DSA_TAG_PROTO_OCELOT;
> > > > +
> > > > +	err = dsa_register_switch(ds);
> > > > +
> > > > +	if (err) {
> > > > +		dev_err(dev, "Failed to register DSA switch: %d\n", err);
> > > > +		goto err_register_ds;
> > > > +	}
> > > > +
> > > > +	return 0;
> > > > +
> > > > +err_register_ds:
> > > > +	kfree(ds);
> > > > +	return err;
> > > > +}
> > > > +
> > > > +static int ocelot_ext_remove(struct platform_device *pdev)
> > > > +{
> > > > +	struct ocelot_ext_data *ocelot_ext;
> > > > +	struct felix *felix;
> > > > +
> > > > +	ocelot_ext = dev_get_drvdata(&pdev->dev);
> > > > +	felix = &ocelot_ext->felix;
> > > > +
> > > > +	dsa_unregister_switch(felix->ds);
> > > > +
> > > > +	kfree(felix->ds);
> > > > +
> > > > +	devm_kfree(&pdev->dev, ocelot_ext);
> > > 
> > > What is the point of devm_kfree?
> > > 
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +const struct of_device_id ocelot_ext_switch_of_match[] = {
> > > > +	{ .compatible = "mscc,vsc7512-ext-switch" },
> > > > +	{ },
> > > > +};
> > > > +MODULE_DEVICE_TABLE(of, ocelot_ext_switch_of_match);
> > > > +
> > > > +static struct platform_driver ocelot_ext_switch_driver = {
> > > > +	.driver = {
> > > > +		.name = "ocelot-ext-switch",
> > > > +		.of_match_table = of_match_ptr(ocelot_ext_switch_of_match),
> > > > +	},
> > > > +	.probe = ocelot_ext_probe,
> > > > +	.remove = ocelot_ext_remove,
> > > 
> > > Please blindly follow the pattern of every other DSA driver, with a
> > > ->remove and ->shutdown method that run either one, or the other, by
> > > checking whether dev_get_drvdata() has been set to NULL by the other one
> > > or not. And call dsa_switch_shutdown() from ocelot_ext_shutdown() (or
> > > vsc7512_shutdown, or whatever you decide to call it).
> > 
> > ... I assume there's no worry that kfree gets called in each driver's
> > remove routine but not in their shutdown? I'll read through commit
> > 0650bf52b31f (net: dsa: be compatible with masters which unregister on shutdown)
> > to get a more thorough understanding of what's going on... but will
> > blindly follow for now. :-)
> 
> The remove method is called when you unbind the driver from the
> device. The shutdown method is called when you reboot. The latter can be
> leaky w.r.t. memory allocation.

Interesting concept. Makes sense though. Thanks again for explaining!

> 
> My request here was to provide a shutdown method implementation, and
> hook it in the same way as other DSA drivers do.
> 
> > > 
> > > > +};
> > > > +module_platform_driver(ocelot_ext_switch_driver);
> > > > +
> > > > +MODULE_DESCRIPTION("External Ocelot Switch driver");
> > > > +MODULE_LICENSE("GPL v2");
> > > > diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> > > > index 8b8ebede5a01..62cd61d4142e 100644
> > > > --- a/include/soc/mscc/ocelot.h
> > > > +++ b/include/soc/mscc/ocelot.h
> > > > @@ -399,6 +399,8 @@ enum ocelot_reg {
> > > >  	GCB_MIIM_MII_STATUS,
> > > >  	GCB_MIIM_MII_CMD,
> > > >  	GCB_MIIM_MII_DATA,
> > > > +	GCB_PHY_PHY_CFG,
> > > > +	GCB_PHY_PHY_STAT,
> > > >  	DEV_CLOCK_CFG = DEV_GMII << TARGET_OFFSET,
> > > >  	DEV_PORT_MISC,
> > > >  	DEV_EVENTS,
> > > > -- 
> > > > 2.25.1
> > > >
