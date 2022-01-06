Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C3448694D
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 19:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242483AbiAFSAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 13:00:05 -0500
Received: from mail-dm6nam11on2114.outbound.protection.outlook.com ([40.107.223.114]:35552
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242477AbiAFSAD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 13:00:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fxU+lUpLEHvXuClLBhScv9iQAV0ymSvhvQBUFfFD8npkbW6vzqmYq+yASS/h7i7LXZUvRAHIBbgeACqanjjqML9BTmZvATal0vVdVAXEbGlKZOB1KzUFYxTdCexgdlIqE/lWQEpPoJwYzwidle3A7eaOhApkVlTj+oHBxCQsDpy8NFYW4sJlNm1ik0a3RUGRswMyWJNKvwaV+MA9921zpDSgTVYueQtHkiTTujQhTqC9piTxIX7LLyh7V/poOY/k/C7Mg5TpRJnRFL5QLIoBFn+c1Vn9VXQ6HhNvpamu5B9TBzcWgRQ+cvgFVj3R6mPjit0Pgd5isczaY538kJDzMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QFA7YvpAeI7P+lsNcsB4Np3h3++4UjTIvINX4yPr+H8=;
 b=CK4F9LQbl71e2nSrxuFcq4lYBWuVsDntEavyLy8SWQvB57CNFellAdcyZNusAt5FpNFuWu1SAWnfE8+9KYX+lffCvWCuR7CpCknbqFWpjAsF8UxIHvYBbw76SZwr4LJs+l6lhkXC8Xj8WItkq4RohLha0hIHyq96JYSyuddOzMdirGkCMtw/786QN/AhrKW3TCru92QgOWh8Zo79WXkRs7pn8dWfsZwH3JZhMlzRkPCfgM8iNCZOIEpbYshSp7VFGP/EpaH41ZxPpqZI/HRrOlE1tIqv6CqpyGzX2tkL5wyFByUPo9rh03HiuZmLRmdLNJi1bHUgiYUBkdS5kV0Zdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QFA7YvpAeI7P+lsNcsB4Np3h3++4UjTIvINX4yPr+H8=;
 b=g5ZDXErHKBdf6O6t6vKnI/oKpvvj9WJZFZhamgiTqk9CZHPw84ueiVc+RsZUhE211G3ceC4NGp9LriE8+Ri0oZxg3ldW5z8T5DW9TuACcm9RthePHmyd8f/GprOPlqOxZX21rmRfBfVCwzYqClMEudyhHLmCobjx5rp8kmfAH8Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4801.namprd10.prod.outlook.com
 (2603:10b6:303:96::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.10; Thu, 6 Jan
 2022 17:59:59 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4844.017; Thu, 6 Jan 2022
 17:59:59 +0000
Date:   Thu, 6 Jan 2022 09:59:53 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        katie.morris@in-advantage.com, UNGLinuxDriver@microchip.com
Subject: Re: ocelot-pcs - qsgmii planning
Message-ID: <20220106175953.GA352354@euler>
References: <20220106095003.GA253016@euler>
 <20220106104837.clp2t6wxus7o72ny@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106104837.clp2t6wxus7o72ny@skbuf>
X-ClientProxiedBy: CO2PR04CA0094.namprd04.prod.outlook.com
 (2603:10b6:104:6::20) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 757554a4-593f-4efa-b14e-08d9d13e5ae0
X-MS-TrafficTypeDiagnostic: CO1PR10MB4801:EE_
X-Microsoft-Antispam-PRVS: <CO1PR10MB480110503F8CB3C9178CC721A44C9@CO1PR10MB4801.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TpwRTnEQdOWNml/8Bb6EutvmLvd/yWCO4llK7HM4gF3vZhQFwVM4OmDzeBmg84R0hx9y9LSOtBLTm36rLD71QPMeQMEBDbkvTKq71yr5sSRqqQE5LkN61g7g4OqsEJnd4voez5Gd0pb86rVGXjmAhBs1vhU8JKmAWLCNwwg1M3IsWCWRaVmOr68pGeiqWzmzIvRhrchwLqO7XDGghm43APtPG2q7TWCxCg+IVbyRAIctBBpNIqfvxVrmkP+8PNBm0sSVnVdIyDyZ+j/4Yiel5v3tyAr0MtqsT7WhtiMPFQnIEmuSk7MQvTfh53nIOwfR77Ow3nRYShGA2pIF9SFIXPKF+V5Ph8V5caN47q+bh+CXppkmPWcbXngY212s8mwpTzQvEdaT84XRULqycXWkrLLnb3ry/duiZfe+kZYN4WjJeCaXdxlu29vrHGBTFitN6J6HEVoPMhxEnLr6PsEWcRe+psOP9bIOfMeL2q79Hal/aD9Tz6jOlqP7HmOy20sLaLcFbR/n8PAMSWnN044ueBnuaa/pqEukE57UT/8vKkIbb/EsGx1zU25gHxh6z5cOBme3foBKyyS4t+kEb6hkL5tq3GNCriXLCLdyIXMHcH1e8M7Yuj+mInKv9Eu+91EW4zWr3P3qdiSEh4AJkgQN2M8Y3eedWe0BhAyySucBYDppQKOCsYG1GuONkeMs6plFaN1GNEMg0eL4lKhHsyuP4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(396003)(39830400003)(42606007)(136003)(376002)(346002)(366004)(33716001)(44832011)(8676002)(8936002)(508600001)(9686003)(6512007)(316002)(6506007)(52116002)(6666004)(6486002)(66556008)(6916009)(38350700002)(4326008)(2906002)(38100700002)(1076003)(66946007)(83380400001)(186003)(86362001)(5660300002)(66476007)(33656002)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ywvmG9bwDsXXPX2tIbyjNu5fCIIzWsNUjZjqiSfPKY8PHl4zkZZcZpLovAiC?=
 =?us-ascii?Q?KY7APLsCewjOilBxnBNSPfOvWTpOHrsarndg62nV2L57/ypKoBAU6yt6s7Y9?=
 =?us-ascii?Q?Wtv3Py4qywqWc2+5dGMwg9a+5O5PpQFj4kCCyTgiPrM68HhiybK9UpXMMDdm?=
 =?us-ascii?Q?FGUDisQHtGYiI5MEXhZYR8lDAIDpFz6stl3d7Nbm0rYgL5+IPFDX/E4pTkfO?=
 =?us-ascii?Q?dNIdaFZ3e2PEOg0XaD56NWJ1jCv5rFtTVCUBDHEj5tek7X/sxQ21Kr7siPX6?=
 =?us-ascii?Q?mKxdZb26UcPT9uuPMBA1kpnkiMTlGcwvkic3ji0U3cnZvnpZDIw9FWksqgCs?=
 =?us-ascii?Q?7tw11mTyIW60SiknSz4Ri398dkVavUJ+14RnZRK4IOI0UHaFuQTwnf/XKTPL?=
 =?us-ascii?Q?1ZH9fb7OrZULvuyMobIVGfpX0ux5XhLrDmkixqpOG0b47LaI3pw7+FLnxdhC?=
 =?us-ascii?Q?5CnlhDVolPHEjt7SMUEMJjElO2uAvVeAqD0nw8m5mVROQKuq0mdeixAKlFJi?=
 =?us-ascii?Q?wKeElKmeFIr5U1vrl5OTzhkeZEECFQJOy54jjjIu4CI4qxA8fJoRpGDu/s/B?=
 =?us-ascii?Q?XjI8D7aQGgf7dGrCl3EQzEyPJm+zyq5shxEc2xQ26quJPTRp1Sv+cs41PGnN?=
 =?us-ascii?Q?pcVIbNVssw/Dol8hgTZaZaE+Vs0h2GEh/7BqLzhbZRi419GqyDGntonusTMw?=
 =?us-ascii?Q?jo4uayS+9/7wWI3G8iYTShx257fNexNyFi1hNhNgooZcbyLDYrLHgpojwnsK?=
 =?us-ascii?Q?Wcp+FIZoqQmvU1QunBumrZBe0gF/NtXgynvu2y9ixu46wsgp8zl73qwHS5Mg?=
 =?us-ascii?Q?ZH+iUPiDhf0g8kCAudh/zhdu0vduzanO4uhWqHXh2VnFAxEaeQrMLNDjH/iQ?=
 =?us-ascii?Q?lyH2LyfDRcsAJboJO9HWOVEMZQgzAdfU8QeYscZKApc1RnAesUNIw4Pknq+v?=
 =?us-ascii?Q?CNOjSTPCEUFzh+dnckodVPtFUcdBzkRbN2w62DcirgGphvYyXm9kiSfdLy50?=
 =?us-ascii?Q?wiK9Kql0yaH4xawAD5wpRTnCU7npDaWH22mrq3+8aPMZrMIBx8izdsPaiKzA?=
 =?us-ascii?Q?r7S4zuauoj5w3MNgRsP7f2s625dqqPaLHdw7ZAwuLGEYQ6S4rtfGZ7QLrmLD?=
 =?us-ascii?Q?rOojNHtmU5vIwlMS2EY1TSpoWgIr8h5BUH41/VCZsdQkPIuu1/XOc8uq17Nd?=
 =?us-ascii?Q?JUnqpUxFRP/nqd7ZxyfKY9bV4+aSkUT2u0Ub/owVMHr53tm5YFRO8O5Qy0hv?=
 =?us-ascii?Q?TEX2IhGNsMygbdYhoiorwslwll8sx78znZ30wewyitssnKsqObqCsecvEx8l?=
 =?us-ascii?Q?p8l/bRUVbCmSKvdfTFjRIbfLmE1rjUAvGfVbME7EYKRlpjEG2bXSNg8g/PtF?=
 =?us-ascii?Q?DRoNK5lBeZtA2TeyrJyKOxGpbl4WCPE0fGDa1ZgeYbGdEDy8KqWYzZ+ppW0p?=
 =?us-ascii?Q?azzER1lQ0uqgo7XHY9aA0j5sVyIQ/q6o7mu+ZnYVpISf4eYvP1o1Bdh9Ff6U?=
 =?us-ascii?Q?mTRBKGXNHaKh6UYEAh7PKGOI3o0bJCqoLigP+3Es2wbufMWDyJhvA7/rpgFp?=
 =?us-ascii?Q?4zuH1tq009mepihy01ux/8QWLo5wFul12YAA/HISr8KkfgpMvXw7UkKSLk8k?=
 =?us-ascii?Q?SuwX/9YWxG3ZUBiBYYMd102m6S/a3qdnbkrvWzNP8ON4AS+tHr/wDjWDfelY?=
 =?us-ascii?Q?LWjhsg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 757554a4-593f-4efa-b14e-08d9d13e5ae0
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 17:59:59.6394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JilIPdMNPcP7cfZLr3FD7uH810d85N6jQLmab7lUijkSE5BTSibbGg3J69w4Jq4kNmY6rnNfgE3txVY5lwepdLCEXc9gK53EyI32xV3CPBo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4801
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Thu, Jan 06, 2022 at 12:48:37PM +0200, Vladimir Oltean wrote:
> Hi Colin,
> 
> I'm sorry, but I have no direct experience with the SERDES and PCS of
> the Ocelot switches, since those blocks were completely replaced from
> the NXP instantiations I'm playing with.

I realized that might be the case as I was writing this email. Thank you
for still helping.

> 
> On Thu, Jan 06, 2022 at 01:50:03AM -0800, Colin Foster wrote:
> > Hi Alexandre, Vladimir, and those with interest of Ocelot chips,
> > 
> > I'm starting this thread to just touch base before I dive into any PCS
> > changes for Ocelot. I've appreciated all your guidance, and the only
> > time I felt I've been led astray is when Alexandre told me it should be
> > easy :-)
> > 
> > I'm at the point where I'm starting to integrate the additional 4 copper
> > ports of the VSC7512 reference board. They are 4 ports connected through
> > a QSGMII bus, to a VSC8514 phy.
> > 
> > The 8514 driver seems to be getting invoked, and running just fine.
> > Also, I was able to slightly modify (hack*)
> > drivers/phy/mscc/phy-ocelot-serdes.c to work with my in-development
> > ocelot-mfd. I believe that is what I need to configure the HSIO
> > registers.
> 
> And are you also getting a reference to it and calling it, like the
> ocelot driver does here?
> 
> 	err = phy_set_mode_ext(serdes, PHY_MODE_ETHERNET, phy_mode);
> 
> Could we see that portion of the code in the felix driver?

Oh, no I'm not. That's probably the hint that I need. I see that happens
in VSC7514 probe before calling ocelot_port_init, unlike felix. Alright,
there's some work for me to do! Thanks :)

> 
> > 
> > (*the device_is_mfd info I was using falls apart with the
> > HSIO/syscon/mfd implementation here, sadly. A new probe function would
> > easily clean that up, but it is more for me to think about... I digress)
> > 
> > I'm using these device tree settings:
> > 
> >     port@4 {
> >         reg = <4>;
> >         label = "swp4";
> >         status = "okay";
> >         phy-handle = <&sw_phy4>;
> >         phy-mode = "qsgmii";
> >         phys = <&serdes 4 SERDES6G(0)>;
> >     };
> >     port@5 {
> >         reg = <5>;
> >         label = "swp5";
> >         status = "okay";
> >         phy-handle = <&sw_phy5>;
> >         phy-mode = "qsgmii";
> >         phys = <&serdes 5 SERDES6G(0)>;
> >     };
> > ...
> >     serdes: serdes {
> >         compatible = "mscc,vsc7514-serdes";
> >         #phy-cells = <2>;
> >     };
> >     mdio1: mdio1 {
> >         compatible = "mscc,ocelot-miim",
> >         pinctrl-names = "default";
> >         pinctrl-0 = <&miim1>;
> >         #address-cells = <1>;
> >         #size-cells = <0>;
> > 
> >         sw_phy4: ethernet-phy@4 {
> >             reg = <0x4>;
> >         };
> >     };
> > 
> > [    3.886787] libphy: ocelot_ext MDIO bus: probed
> > [    5.345891] ocelot-ext-switch ocelot-ext-switch: PHY [ocelot-ext-switch-mii:00] driver [Generic PHY] (irq=POLL)
> > [    5.357341] ocelot-ext-switch ocelot-ext-switch: configuring for phy/internal link mode
> > [    5.372525] ocelot-ext-switch ocelot-ext-switch swp1 (uninitialized): PHY [ocelot-ext-switch-mii:01] driver [Generic PHY] (irq=POLL)
> > [    5.388865] ocelot-ext-switch ocelot-ext-switch swp2 (uninitialized): PHY [ocelot-ext-switch-mii:02] driver [Generic PHY] (irq=POLL)
> > [    5.405086] ocelot-ext-switch ocelot-ext-switch swp3 (uninitialized): PHY [ocelot-ext-switch-mii:03] driver [Generic PHY] (irq=POLL)
> > [    6.291876] ocelot-ext-switch ocelot-ext-switch swp4 (uninitialized): PHY [ocelot-miim1-mii:04] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
> > [    6.471891] ocelot-ext-switch ocelot-ext-switch swp5 (uninitialized): PHY [ocelot-miim1-mii:05] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
> > [    6.651895] ocelot-ext-switch ocelot-ext-switch swp6 (uninitialized): PHY [ocelot-miim1-mii:06] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
> > [    6.831879] ocelot-ext-switch ocelot-ext-switch swp7 (uninitialized): PHY [ocelot-miim1-mii:07] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
> > 
> > 
> > It seems like that, along with everything in vsc7514_phylink_mac_config,
> > should be everything I need for operation of the four ports through the
> > 8512. I've added OCELOT_QUIRK_SGMII_PORTS_MUST_BE_UP - but I'm not sure
> > that's a quirk I need. Plus the only behavior it currently adds is once
> > the port is up, it never comes back down.
> 
> Correct. I noticed that the code was structured to do this when I
> converted it to phylink, but I don't know if it's needed either. I just
> named that behavior as OCELOT_QUIRK_QSGMII_PORTS_MUST_BE_UP and made it
> optional.

I'll report my findings.

> 
> > The current behavior I'm seeing is links and rates get detected, packets
> > appear to be getting transmitted (ethtool stats) but they aren't, and
> > nothing is received on either end.
> 
> could you also check ethtool --phy-statistics swp4 on both ends?

phy_cu_media_link_disconnect increments as expected. No activity on
phy_cu_media_crc_good_count. I feel like it probably isn't worth digging
too much into this until I fix the phy_set_mode_ext.

> 
> > Is there something I'm missing with the device tree? Or is this the
> > purpose of the PCS driver I'm looking into? I'm getting a feeling that
> > my configuration is correct, and that I need to add SerDes support for
> > these ports in phylink_mac_config... I noticed that there's the "SGMII
> > only for now" comment, and when I look at the reference application for
> > the 7512 there's a comment "external phy uses QSGMII interface" that
> > appears to set the SGMII_MODE_ENA bit to 0.
> 
> SGMII_MODE_ENA in PCS1G_MODE_CFG refers to the selection between Cisco
> SGMII/QSGMII vs IEEE 802.3 fiber modes. Different autonegotiation code
> words being transmitted. It's correct to leave it the way it is. It's
> curious that the reference application suggests to set it to 0 for QSGMII.
> I suppose that if in-band autoneg isn't enabled in PCS1G_ANEG_CFG, it
> doesn't really matter what kind of autoneg is used.
> 
> For SGMII vs QSGMII, the serdes_set_mode() function in
> phy-ocelot-serdes.c should set HSIO_HW_CFG_QSGMII_ENA where appropriate.

I agree. I think you've answered my most important question, which is
whether there's an obvious issue in my Device Tree / understanding. A
blunder there can lead to significant loss of time making this work the
wrong way. Shuffling datasheets, reference apps, register dumps...

> 
> > Thank you as always for your time,
> > 
> > Colin Foster.
> 
> What bootloader do you use? Do you have VSC8514 PHY initialization of
> any sort in the bootloader?

U-Boot (now you know my secret next project...) that is basically the
default configuration of BeagleBone. Definitely no VSC8514 knowledge by
way of SPI > 7512 > MDIO(1) > 8514.
