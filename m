Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB95762F3A8
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 12:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiKRLZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 06:25:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiKRLZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 06:25:32 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2062.outbound.protection.outlook.com [40.107.20.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9284E1138
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 03:25:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bzlHkQ6iCi/fBwLMgQDj9Sndl+hz2E5TVYHNCz62cuU4e9B446nrG7J7dMyCa8aAUXKVS5bL4oFSZjxLtTXn1S3N1XXSBjDMOI3MUAZXrZPudwPFqMoXCl5nZtj07L7XicedlUsw979AsbddsUWVDBsvSP/cSFQLRA2FCExu0Nx4E0j8ra+a4TH4prKndO7NJL+mce4M6rvq1o14fIpKhPSZV0HuFUHOeef+he+18hFUqNfUNvVIvlgKygm54bveg4kcezESDRvw/TOyXVqZq8pJ3r+Y3tF5cPbxgZpBtVGgJHJsy6YePnWGgpiaNdDPlf5CNc05DzKn1VJiK+JtCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1XbcmN4eDR73XvcK4SdetWqAcyNWLvBwp/BLyEqrXU0=;
 b=QgvApYRH7mXb+zg3A5GDYmtMtiU80PXA3iWCyhPIdhSPof8O1LJypO1T0tFWCrDK4SLCPdlnj/Dk8gwgv9wdc1wy6bHxChA2EFp88Qi4hcj7m2nOGKKsMYgNAc3EEWj9ToXv9Ox49qDrz4nniRjG/iLu4gnasbgahL6Vdqzs1t8y6laHmrj1vxDn5dKdMtQymA9p/INfvLSRII9hHHSa/s9IUtcXc82P4Qj+NrkRErnr5xUCNuSrKjoBB2hcstqfMKgQaKJrWEtn3CZmasSXMdwB5pzzFJiuBW4IWSxjwy4i10ykGPDbxyhowreKGl8P+kRMqem+uJ1PZoe2bOMSKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1XbcmN4eDR73XvcK4SdetWqAcyNWLvBwp/BLyEqrXU0=;
 b=EDwelXY+qxpU4omUEyMwIg7piOO0kOFZEHlp95axkmFfPV/N0ByoMDSx5x5xFoZDG07H+mC2UbkLmlirNp3Z+Aje9mIx6aOxj+/4TzZPZj4jlCNYDdMRiJP1v3C+pQv1lQWpNAcDidjcUuKzO0B29Iu4mxsujFJcF0M73mvn9xA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9445.eurprd04.prod.outlook.com (2603:10a6:102:2b4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Fri, 18 Nov
 2022 11:25:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.018; Fri, 18 Nov 2022
 11:25:26 +0000
Date:   Fri, 18 Nov 2022 13:25:20 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Sean Anderson <sean.anderson@seco.com>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
Subject: Re: [PATCH v4 net-next 5/8] net: phylink: explicitly configure
 in-band autoneg for on-board PHYs
Message-ID: <20221118112520.d7x5uppz256o4djm@skbuf>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
 <20221118000124.2754581-6-vladimir.oltean@nxp.com>
 <Y3dZ35RBf3z83Ph9@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3dZ35RBf3z83Ph9@shell.armlinux.org.uk>
X-ClientProxiedBy: VI1P193CA0019.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:800:bd::29) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9445:EE_
X-MS-Office365-Filtering-Correlation-Id: 1902192c-08f1-4226-ef2d-08dac9579707
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mNFaGwtuxAHcnfi4CyeLYeKAliASKHvLNz7gcrPD4KVgrRuYU3sWODvE/uajokxhb+G8nBe/eSqVVCQi9/shu51LlH2SyOvJ2wy/NtAejHacmOLnd9fTNul1x6tmFkYO2JFw9UqRgvqLDdXgBQv5SnBd2PqRtKUOdz3UmKseBR9M5iFzJPyQLkulKPerErY8BX7Gmax71NT1plR6ZsmRto/9A34gTWN3IcFAFD+FGPiPZ8tnGyGT56xE6l6UhcsnyGlcK7/KQiCu057jzGMP6gVo70ppgcoRLndpu/SFhmv3cnaeYWnZIeNzj989dtzeqnQno2Sn1A4fYaYJx3LysoH2hMW0CHxRi6KckovYP1MlonNEdOvFdLmiImeDOK74Bx3/IPesIOoDjYbqy9VZzT8IUpOex5aZAYgPP9q54xqCtTSMnbFF0VV/180hnpw+TV3n+Ug0sebHcR7gI6g/Cd/7r6UFjMGSIuDmFBQccGyVueiadAd3AMUkLstiC6s1tk+4NesC2HjghjZt0EJpxggou76Q4D+i93QCAhlu5U0ipe6u92qH1AxhZFDP1t6Jqfm6lSLI5LGRZIZKdu26WrkurtTWrfaD/nB5ma+30rfCl8Uqm3hYG4UjEICwLnP9jAktl3C25b30cGofgRcvKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199015)(5660300002)(7416002)(33716001)(9686003)(26005)(6512007)(44832011)(86362001)(6506007)(6486002)(6666004)(83380400001)(8936002)(2906002)(1076003)(478600001)(186003)(66946007)(316002)(66556008)(38100700002)(8676002)(41300700001)(6916009)(4326008)(66476007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xo1uHqZ3pFpI5RUsdM7hSMSOHdVuwurMBCTYKZGjgxomjjaJLKZi/jH1vn+D?=
 =?us-ascii?Q?d+WZYE68LgrBk9F4MLPL4G0xDNuK4k6qfeWA4vthPtxWJqjOGtcXVZ/JIL9e?=
 =?us-ascii?Q?//DxaErnbLeGFRpvCgowGkzBCkJKoFb7vTzM2geR+ZEsCoUP3jYHL4Ja7ngC?=
 =?us-ascii?Q?s5Moc4/VojggsF3r5wna9NfQvVEmf6GsP6ZTHU6ZsBVHdKV5PKZhL6lRatyn?=
 =?us-ascii?Q?ofsJ5/2pFggTipYmiBozJokGzmS9ubRlbB0tCY7wn8lMu9nSMGKzA0gbKLfQ?=
 =?us-ascii?Q?ob5Be/JCZqB6+DbP2Fl4Mjkbir3wVwRG3vW3ID4qFT/xwt/vdMe9zL0OB4fk?=
 =?us-ascii?Q?fWbXGY21BPOqoyVN2SEP/fqq9GlhKVJFitkwFAhbCDFo38EpiIyl8XfUZyLT?=
 =?us-ascii?Q?3AZqH62vwz/nFHqdAXJQoCX49FM+l0b/XDKBE/J2A6Ba6RSr+r850WsAnump?=
 =?us-ascii?Q?pJ4g/Z+/SFDpUv69rLnyewARv8jPikeMC76reT/cuJFxF8t7vpdoCfT7tqT7?=
 =?us-ascii?Q?BVssrUAjrv9CAqFYNaL/WEg9UYk/D3laX+M4FDHfSfoulKWMAZunBa08R38Q?=
 =?us-ascii?Q?LbJy2EYAn6a7qA6ycDMTE1tdjw32hpmZHNjVXxbWs0PmBXcibYBFN1UBn/OX?=
 =?us-ascii?Q?h/Tznk9zCltSjbmva+k81dh/A6Ss2dAtgRh9Ql+oRGKrHVWNh3rEEDV+TcRe?=
 =?us-ascii?Q?TSs8ubVP515pNPgPpbze67cvUL9eCl+csLC+1937euH9jLRlyozzQ4lLOHDT?=
 =?us-ascii?Q?AavDikBuuoUPu3DCkO8RB74n+1iFsBXISnMxWrX3u4EhAmNZprxxAAfVadLf?=
 =?us-ascii?Q?fHoGFtXn0cjABDLFlBm91DZWvOhJ29vkJw9AHpp6qHwSrAncUheLFLQplBkw?=
 =?us-ascii?Q?YUCsEctVq73JT/hN2JVtYIfjce4T7J3BqSqx7TPH+DigEOJ4dGDtGtCj/sXG?=
 =?us-ascii?Q?mqh6RUWOzPUYeGLLT4+eiUpo25kO9Zw882MZHbfq8zMP0DfH6DWmKHcAJeaG?=
 =?us-ascii?Q?ihO2KozDv5Dmc4DJdDKrsbD9YDmBCGIYhlW8aN535q/AqSYHN7atuTni0p08?=
 =?us-ascii?Q?YTuMaMWhDpW411+Zm/xjTLUe9JuJQMULGFPpcQcAwN+/dKxDzzueSAY54xpf?=
 =?us-ascii?Q?sNkv+nSFGgJmFW+VN69zYJ6en4pLVT5HvPXrFMRYN05gVPl6xFp/+g9JAkma?=
 =?us-ascii?Q?EjhWl9FMjEER95mAEU7Na4EmDaizKE3mySyo/xacXqxao9GNZONe09A9Qp42?=
 =?us-ascii?Q?YHDzsMg8wCZVz+YBTseiRte88fAifUeHv5mZYH3Kv6ubUyMD01KXE2QQDk7Z?=
 =?us-ascii?Q?D6VT7DcO4O27S421oQRKOHNbs8E56P+zozNZK7JVEAey3RjSC3xNc93RP0Y1?=
 =?us-ascii?Q?hpPu8HtQInkBfguF42cCZxjVC7DaRfV1LHoHInr0CmkPxXGpAPBJWuD5BvNY?=
 =?us-ascii?Q?KH8At5t8Rr796sk+467mOi/3KXtV44H3Ujy36FG2h+nwoWWK0IvcVAJd0Ycr?=
 =?us-ascii?Q?Qhz0GjYsLVfMQ+DEyT/EE8xMNdAsQhOfUAVlRFs+M5esY97P09sCsOJVf/4U?=
 =?us-ascii?Q?WFIQrpKZwaSv55ECJgy4kejeaKzm6YgqjWW4QD8QiJTIkQaMPQcEcHiobkEM?=
 =?us-ascii?Q?Qg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1902192c-08f1-4226-ef2d-08dac9579707
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 11:25:26.2219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FG+pmamjxo7rI6P/r4BqbnzFPAGh0Iq7ZSEj7tH3jHRORtd9FILS3jpwKyi7XgvoPO/UFwrXOZ+j0V3v4njAfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9445
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 10:09:35AM +0000, Russell King (Oracle) wrote:
> On Fri, Nov 18, 2022 at 02:01:21AM +0200, Vladimir Oltean wrote:
> > +	if (pl->config->sync_an_inband && !phy_on_sfp(phy)) {
> 
> Hmm, this phy_on_sfp() is new to me, and looking at the git history, I
> really don't think this does what it claims to do. This returns the
> status of phydev->is_on_sfp_module, which is set by this code:
> 
>         phydev->phy_link_change = phy_link_change;
>         if (dev) {
>                 phydev->attached_dev = dev;
>                 dev->phydev = phydev;
> 
>                 if (phydev->sfp_bus_attached)
>                         dev->sfp_bus = phydev->sfp_bus;
>                 else if (dev->sfp_bus)
>                         phydev->is_on_sfp_module = true;
>         }
> 
> ... which is very wrong. "dev" here is the net_device, and a net_device
> will have its sfp_bus member set when there is a SFP cage present,
> which may be behind a off-SFP PHY.
> 
> This means that when a PHY is attached by the network driver in their
> ndo_open, if there is a SFP bus on the interface (such as on the
> Macchiatobin board), the above will set is_on_sfp_module true for the
> on-board PHY even though it is not in the SFP module.
> 
> Essentially, commit b834489bcecc is incorrect, and needs to be fixed
> before use is made of phy_on_sfp() outside of the broadcom driver.

IIUC, you're saying that if there is an SFP cage after an on-board PHY
X (presumably set using phy_sfp_attach()), then PHY X will be declared
as having phydev->is_on_sfp_module = true despite being on-board?

I don't have such a setup to experiment with. Looking at armada-8040-mcbin.dts,
it's these PHYs, right?

&cp0_xmdio {
	status = "okay";

	phy0: ethernet-phy@0 {
		compatible = "ethernet-phy-ieee802.3-c45";
		reg = <0>;
		sfp = <&sfp_eth0>;
	};

	phy8: ethernet-phy@8 {
		compatible = "ethernet-phy-ieee802.3-c45";
		reg = <8>;
		sfp = <&sfp_eth1>;
	};
};

&cp0_eth0 {
	status = "okay";
	/* Network PHY */
	phy = <&phy0>;
	phy-mode = "10gbase-r";
};

&cp1_eth0 {
	status = "okay";
	/* Network PHY */
	phy = <&phy8>;
	phy-mode = "10gbase-r";
};

But in this case, I believe that phy_sfp_attach() will set
phydev->sfp_bus_attached = true, and this will make the code go through
the first "if" branch and not through the "else" (IOW, the code excludes
the on-board PHYs from the logic)? Or are you describing some
timing/ordering issue which makes this not be the case (something like
the sfp_upstream_ops :: attach() of the on-board PHY being called later
than the phy_attach_direct())?

Could you help me better understand why the code will not enter through
the "if" in this case but will enter through the "else"?
