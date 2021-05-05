Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 768B2373C3E
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 15:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbhEENVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 09:21:38 -0400
Received: from mail-dm6nam12on2101.outbound.protection.outlook.com ([40.107.243.101]:24264
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229606AbhEENVg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 09:21:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hznLKdA+taozmcb4JT9u0TS/2I6WEeU5YB97QSFwtEEcoFNJeHtRMWJuMNpN6IojGeT9aIdjhkH7WqoAq7aFG5vbGMDO1CV9DtwlWer8kL39Rs8gcHnZSsL8fHzYOAzBz2k/3BmBM6Y+OpV+xeuPPFILaA4k8+PBiirO0kaE5FxsQbdtLgI/Ehg7dU9cWbF6T/cSA4t7PIWbyHDFBE46t0/7O5ziWH/Rno3ohRruQky/mQ3FhDtdIpuhh5yM0cew/BpvIwwQQJ6pVKHLk/QRnxebeIsCmB1nPAmmra4x5591dzDb/BAK2CFmwb9obQ0leC9EENHMYzCLkiuRSrPTXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EII6HDCrFIvxoR6AVBVPhTqDSvkE6ZlrP3ZD2o/X1j0=;
 b=oGxTAlg9vkSgLsjfxDwcd4AnbovvpV3wOrVNh//dfUQleUJEk7/Gr0baL97/sSu3mYyM/ENxyeZodqbK2ga3tq8hrWEKCxzHJTt9R+gJDuFAijAbBd6aF4hU8hpeD7jnRdxzJe5D+FHdnMf0eunBR4bdcfRhZnkW25NH9g8RcarKySY+pCb72xYYz9L27hS9Yt3dvW+tKZnzYX+IgZAVr3XbAU3w7KU2UwGtzO5kKY+kyKXJ5cTVM9fD0w8P+WW+L1lXymUtpH5WtejlTMURvEDpc3nz4/1rpZgp4JJCXIkH1a7kw+OR+/CAqlFXDKUG17lGF/hPQA3ji8ugVNkU+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EII6HDCrFIvxoR6AVBVPhTqDSvkE6ZlrP3ZD2o/X1j0=;
 b=u4k2rEvKSR0k+M0KCYpXljRr29xDBHk5w/RoXgZYvsE7j/uFko03GhQ6izF5etIHgfb2P95OwrtBjTuw9w55Q19WHOhGoHqtSkU9WYPqKBr9Ffk9M2MP8tdKi1PopUMlFNWeH4ajmLfN5qvNhW2zLTbt6XoEywmoqcWodI6FFIU=
Authentication-Results: bootlin.com; dkim=none (message not signed)
 header.d=none;bootlin.com; dmarc=none action=none
 header.from=in-advantage.com;
Received: from MWHSPR01MB355.namprd10.prod.outlook.com (2603:10b6:301:6c::37)
 by MWHPR1001MB2110.namprd10.prod.outlook.com (2603:10b6:301:35::34) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.35; Wed, 5 May
 2021 13:20:36 +0000
Received: from MWHSPR01MB355.namprd10.prod.outlook.com
 ([fe80::c559:f270:c9b5:a928]) by MWHSPR01MB355.namprd10.prod.outlook.com
 ([fe80::c559:f270:c9b5:a928%6]) with mapi id 15.20.4065.039; Wed, 5 May 2021
 13:20:36 +0000
Date:   Wed, 5 May 2021 06:20:29 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "supporter:OCELOT ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:OCELOT ETHERNET SWITCH DRIVER" <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH vN net-next 2/2] net: mscc: ocelot: add support for
 VSC75XX SPI control
Message-ID: <20210505132029.GA1742041@euler>
References: <20210504051130.1207550-1-colin.foster@in-advantage.com>
 <20210504051130.1207550-2-colin.foster@in-advantage.com>
 <YJE+prMCIMiQm26Z@lunn.ch>
 <20210504125942.nx5b6j2cy34qyyhm@skbuf>
 <YJFST3Q13Kp/Eqa1@piout.net>
 <20210504143633.gju4sgjntihndpy6@skbuf>
 <YJFjhH+HmVc/tLDI@piout.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJFjhH+HmVc/tLDI@piout.net>
X-Originating-IP: [67.185.175.147]
X-ClientProxiedBy: MW4PR04CA0347.namprd04.prod.outlook.com
 (2603:10b6:303:8a::22) To MWHSPR01MB355.namprd10.prod.outlook.com
 (2603:10b6:301:6c::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from euler (67.185.175.147) by MW4PR04CA0347.namprd04.prod.outlook.com (2603:10b6:303:8a::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Wed, 5 May 2021 13:20:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2d3b328-8aae-43ac-86ba-08d90fc891c7
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2110:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2110A58FB1C7B1F3B654CCBFA4599@MWHPR1001MB2110.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ibR35cQSPFwJeAeeA7c0yBv0tZY7mH8ZDaM1zZX6wij+ySiB+v7SExECFXtH7DQ3s5SBbUnMVDyAHdoSjRiRXEdDFMiBgpgpkPNTNLhzBUH67ftpsr6snQKxpbeWIv8IerANwRZ3LHeWcoMcpvLrkJKI3O6ztyUWWoUeVCFfYlvqFMATsagJkyBwZJq5HnUXAplNkFHfsgbFdT+q/475AKrztxHe/LXzX5IiLWHFU1y503umOAbj2/Ccy8Pjpys/g5xfSnXsRQuHQv8J3rMnNtXFdkvLCnbpImZAms2guPE9NxyoeSmJ/8k/ZxwgdNZ8bl7a7iBw2Ouy/epBT6pjrj06zG2P1y9r3HJeVeI5i+rs/QRKDCA8o9LxBM4DOwP5aa4iGemNxXRoZvAj4OmBqeY2e9Js0bCy4srxKscPtZpCmaGklBRLlROUeewVB/+KzDiXzP0ehOw6HOK67nKeN3h9moXdPZNTxJLsMM+pyKkpHc3xnCrQWfiRYZXyIIZG+E38fy/jCT9jJEScjqXafVwfLy+rP+1pm+92K+QqVJmB9CP34piQQOR6G8leBeFOq7532it32BpG4A3BiwUc7X8ZOw29V4fGSLYOS9U8s7O+QdChRGnMir11wUzvp2Jnp35aEfOsWwDmrEPfRdDY6UBRumCTezq6AKRuF6fvQWdXWfO1BijuA6/QbUSCtXDjT7GiZORmD+F9QLme4b8HtXaAsSfpbGCuI1a5rJY5RG0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHSPR01MB355.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(376002)(346002)(366004)(396003)(136003)(7416002)(6666004)(8676002)(52116002)(8936002)(6496006)(966005)(38350700002)(66476007)(83380400001)(186003)(66556008)(6916009)(5660300002)(478600001)(1076003)(38100700002)(66946007)(86362001)(33716001)(16526019)(2906002)(33656002)(956004)(55016002)(9576002)(4326008)(316002)(54906003)(26005)(44832011)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?goCOKzw9h4+pA4lgecBrd8R9sLph6FQmYfJInPxlvz7fo6M9ESZZl6rXnozh?=
 =?us-ascii?Q?kf/+Nn0k//U/sJ0E0MBvpMLoKAkCAcit1fXxuIt2Axhk4YHtZzID/5sXv7A8?=
 =?us-ascii?Q?jCoSAo47zw1tytu8gIBLgcbXpGng1qTp9KtWSKe7lvXc1qXujqU1TFoiFBSA?=
 =?us-ascii?Q?iUEXGgIzmyUrqwtKzOV3d7b2A2vy07McgvI7h1uNgqWdM3UGdZ/Kt/HPTDAy?=
 =?us-ascii?Q?NIIDrCPMp3NYmSxJEAfkf4TJKmMRb1/Rsm6f4mz9Rc8ejeqAOIQ/gfkSP86H?=
 =?us-ascii?Q?9yLHhJeOYfetwvbHg6lOk4eeM0bFwhOF0iYG2LCfQ/Yn+yDHZ7yPI5oR2RUi?=
 =?us-ascii?Q?jooDQHOYmL7/zLpDsu10jZZHmCIMTQz+BKa8VJMJwN8wWqbTp+DM5/v3+8YD?=
 =?us-ascii?Q?7sPqxNVpC1VDP0mGjIsqJKgciiIRwRrKoMz1hyIL/vDi1mr5yn2MnQXE1Z88?=
 =?us-ascii?Q?maVZ9bpng4bO2PxP8IBJ95PGP6rgt+rIhTT1wK2x7Bre3ke49zxm0eyC2zUh?=
 =?us-ascii?Q?2Jy2BY+rhiWP7oH3I6W2gkDghMDwKb2WJKypsRM7gZZuxNVKdusBkhACWjr1?=
 =?us-ascii?Q?kevFvZ0lcDYsyJuNwx7als+I6veWjNG5rerIFg1E+XXMJAc7geAIyxegUG6G?=
 =?us-ascii?Q?h+Wjj/qi6EZvOZTKoPxz/e+UelBHCuhYVpYsfgIDozyr99W+P7iiZ6jiU5dv?=
 =?us-ascii?Q?vsZb3i6jY6n2FVzp5yvPVfsRFssaPY24gNfOTCyjj4WR2iH+qDqzCkn1X/5m?=
 =?us-ascii?Q?ze6XJew15Hmnj7eh7d/zhIVTPRZiMA8ltgmJH/1x6X1dpPe6h+eUOMY3ZphQ?=
 =?us-ascii?Q?9H4l93vmNh6e8Vj/tRTynOO75QRahKWqc83ZOpWvi9WuIojV4PydLOJAr+Md?=
 =?us-ascii?Q?uMDWnbv2hcxjJFYNFkj5HH2cuV1cyvzuKPDzLQregxuE17afV7l8egnQZr7D?=
 =?us-ascii?Q?+inx+ortCkSSYOLCF2l8LPuPhtVopE5qZurj6XRSBG/D/A1mvQRDEke3Pjm9?=
 =?us-ascii?Q?5RaR44t8EVQHz6xEyv/CwAQaYinPuKpFe9AQds/nk7FRmwnW7QPQg7yjPjTB?=
 =?us-ascii?Q?hlSl4mXlI+16qR7H2wIyRaxbfIi+3MvS1xE4ShmbkqIvgeGPNZFXXiMorFe4?=
 =?us-ascii?Q?2RMlk5tGGP9OzuwilRtRAghmuTDVkFpo0khgy+KG87V5sK+HBGiueJt3YHaB?=
 =?us-ascii?Q?0axi6j5budeCkb+Y+SWhQdYe4UsymdYgU5dAh+/i/5DbG0w5LVtP5FZ3He7C?=
 =?us-ascii?Q?YdrFhXmgvwXDUG9yUMpgm6ldP0eQDlQVpCdpRwkmf+80pMpnVl3RpvoBIV+P?=
 =?us-ascii?Q?w14Ta80J18//5vcJkef+lMYp?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2d3b328-8aae-43ac-86ba-08d90fc891c7
X-MS-Exchange-CrossTenant-AuthSource: MWHSPR01MB355.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2021 13:20:36.7211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TyTvBrhK5pHXC5M4afTDA8O/D51PueDTjzmAbR+ml0AjUyclzdwqO0i29xiH39X0Rgu9dxlGSp5K4n+KWdAP6j2oQWhm96JqV8RkzumRp68=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2110
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 04, 2021 at 05:08:52PM +0200, Alexandre Belloni wrote:
> 
> 
> On 04/05/2021 14:36:34+0000, Vladimir Oltean wrote:
> > On Tue, May 04, 2021 at 03:55:27PM +0200, Alexandre Belloni wrote:
> > > On 04/05/2021 12:59:43+0000, Vladimir Oltean wrote:
> > > > > > +static void vsc7512_phylink_validate(struct ocelot *ocelot, int port,
> > > > > > +				     unsigned long *supported,
> > > > > > +				     struct phylink_link_state *state)
> > > > > > +{
> > > > > > +	struct ocelot_port *ocelot_port = ocelot->ports[port];
> > > > > > +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = {
> > > > > > +		0,
> > > > > > +	};
> > > > > 
> > > > > This function seems out of place. Why would SPI access change what the
> > > > > ports are capable of doing? Please split this up into more
> > > > > patches. Keep the focus of this patch as being adding SPI support.
> > > > 
> > > > What is going on is that this is just the way in which the drivers are
> > > > structured. Colin is not really "adding SPI support" to any of the
> > > > existing DSA switches that are supported (VSC9953, VSC9959) as much as
> > > > "adding support for a new switch which happens to be controlled over
> > > > SPI" (VSC7512).
> > > 
> > > Note that this should not only be about vsc7512 as the whole ocelot
> > > family (vsc7511, vsc7512, vsc7513 and vsc7514) can be connected over
> > > spi. Also, they can all be used in a DSA configuration, over PCIe, just
> > > like Felix.
> > 
> > I see. From the Linux device driver model's perspective, a SPI driver
> > for VSC7512 is still different than an MMIO driver for the same hardware
> > is, and that is working a bit against us. I don't know much about regmap
> > for SPI, specifically how are the protocol buffers constructed, and if
> > it's easy or not to have a driver-specified hook in which the memory
> > address for the SPI reads and writes is divided by 4. If I understand
> > correctly, that's about the only major difference between a VSC7512
> > driver for SPI vs MMIO, and would allow reusing the same regmaps as e.g.
> > the ones in drivers/net/ethernet/ocelot_vsc7514.c. Avoiding duplication
> > for the rest could be handled with a lot of EXPORT_SYMBOL, although
> > right now, I am not sure that is quite mandated yet. I know that the
> > hardware is capable of a lot more flexibility than what the Linux
> > drivers currently make of, but let's not think of overly complex ways of
> > managing that entire complexity space unless somebody actually needs it.
> > 
> 
> I've been thinking about defining the .reg_read and .reg_write functions
> of the regmap_config to properly abstract accesses and leave the current
> ocelot core as it is.

I considered keeping the regmap definitions from the initial ocelot 
(VSC7514) driver for this. Define a .reg_read and .reg_write to do 
address translation, byte-pad reads, etc. I believe that would require
abandoning devm_regmap_init_spi in favor of a custom implementation.
There were good things I wanted to keep from using init_spi though -
endian checking, possible async capabilities, etc.

drivers/net/dsa/qca8k.c has an example of what I'd start with as far as
defining a custom regmap. It doesn't use SPI, but has custom read /
write functions that could do whatever translation is necessary.

> 
> > As to phylink, I had some old patches converting ocelot to phylink in
> > the blind, but given the fact that I don't have any vsc7514 board and I
> > was relying on Horatiu to test them, those patches didn't land anywhere
> > and would be quite obsolete now.
> > I don't know how similar VSC7512 (Colin's chip) and VSC7514 (the chip
> > supported by the switchdev ocelot) are in terms of hardware interfaces.
> > If the answer is "not very", then this is a bit of a moot point, but if
> > they are, then ocelot might first have to be converted to phylink, and
> > then its symbols exported such that DSA can use them too.
> > 
> 
> VSC7512 and VSC7514 are exactly the same chip. VSC7514 has the MIPS
> CPU enabled.
> 
> > What Colin appears to be doing differently to all other Ocelot/Felix
> > drivers is that he has a single devm_regmap_init_spi() in felix_spi_probe.
> > Whereas everyone else uses a separate devm_regmap_init_mmio() per each
> > memory region, tucked away in ocelot_regmap_init(). I still haven't
> > completely understood why that is, but this is the reason why he needs
> > the "offset" passed to all I/O accessors: since he uses a single regmap,
> > the offset is what accesses one memory region or another in his case.
> > 
> 
> Yes, this is the main pain point. You only have one chip select so from
> the regmap point of view, there is only one region. I'm wondering
> whether we could actually register multiple regmap for a single SPI
> device (and then do the offsetting in .reg_read/.reg_write) which would
> help.

Exactly, this was the main difference. The SPI regmap has no concept of
__iomem, which was a main feature of the underlying ocelot core of
having multiple regmaps. 

So instead of having "offset" in all ocelot accesses, allocate each
regmap in felix_vsc7512_spi.c as part of a struct { u32; regmap; }
during each felix->info->init_regmap call. Use this u32 (or resource, or
whatever it may be) to do the offset in the reg_read / reg_write. That
seems like it should work. This would again require abandoning
devm_regmap_init_spi, which I'm considering more and more...

> 
> 
> -- 
> Alexandre Belloni, co-owner and COO, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com
