Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19C8E6389CA
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 13:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiKYMaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 07:30:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiKYMav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 07:30:51 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2054.outbound.protection.outlook.com [40.107.104.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6274A05B
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 04:30:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mlvdv5hwMRdFI2ZNwFalBRRvhsn3ce6dKUP8h11dhMVEBqsbSdiYGqyf7zzvBr+83TT1ntHSY130AzqV/6pViQG50675UKqIOQXKdHDI2fPPHe9teianx7h8zQacYg/QgICTPbq4E/QojnOPuJIrP7fhR1+MOSPHLTDI9hfPX+cA7QBF70zR66WK3EMeNYUU9eXYI1rMRay4g7dDD6AuQIUlmR2DKlcDbKBdCew+AhQOaNDL5z8ac5uG/2mjABH0d8Qb6kKb7+ZLxcj0iEnPOyvRcDGQs/MNIX9IgQDlpkA2Jr+m8fcgc2XGKcyORqY3OHsLtDmJEq5Z7yq2BWsBmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sFqB/KWxz/yHdjRZCPf8JAcAOEbbDjcnLxMP9EMQ6Wc=;
 b=N7mPr0b1tpniUYnDLEt9zujWetwIPA5Aw8N4k9KNxjSI0IjVrwMV1jfcL8UcT8vpnjaCmKYwg9shxmvDVPUQzWYLb9JQauZbRq4ZwpsQ+rTpvoVxgptTwx6+eBJ/8xZmzIQW2oRvTLC83Cv5/MHEIlrxdO0F70K8ni2nR3kRfMjjUCikx6tU1hVpYvteBVc/8tKi5QrniTy5zrXa9L2jG7LIoy5+Nz9r2/za6tv/gcwm2kX46Y+lsJN+c+8BuPZY7DDIDgPkq8ITygF4tqUvixcZMcJdOXlwrdl7ZLbMuk/OEtgcxTsSFl16BAoTDJXZKDAK3Yey99wiJeB7LLuQXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sFqB/KWxz/yHdjRZCPf8JAcAOEbbDjcnLxMP9EMQ6Wc=;
 b=FYtsljYp7p1jl+qewbRFyGbmexTIcZWBAkWCFBQOvS+/a0L146ApCedmLHfewvThTwxzp+j+VKgJXw9ir6sF5OTcsEN637BI3rzN5F8EEVnKaIE7Jgf0TbTypybDNccwnx18wQNdSare8yTUygjFfclb2fNxCvhqO5EWYqTuhF0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8234.eurprd04.prod.outlook.com (2603:10a6:10:25d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Fri, 25 Nov
 2022 12:30:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Fri, 25 Nov 2022
 12:30:44 +0000
Date:   Fri, 25 Nov 2022 14:30:42 +0200
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
Subject: Re: [PATCH v4 net-next 3/8] net: phy: bcm84881: move the in-band
 capability check where it belongs
Message-ID: <20221125123022.cnqobhnuzyqb5ukw@skbuf>
References: <20221118000124.2754581-4-vladimir.oltean@nxp.com>
 <Y3yYo63kj+ACdkW1@shell.armlinux.org.uk>
 <Y3yvd0uyG2tNeED3@shell.armlinux.org.uk>
 <20221122121122.klqkw4onjxabyi22@skbuf>
 <Y3z/xcbYMQFM5SN4@shell.armlinux.org.uk>
 <20221122175603.soux2q2cxs2wfsun@skbuf>
 <Y30U1tHqLw0SWwo1@shell.armlinux.org.uk>
 <20221122193618.p57qrvhymeegu7cs@skbuf>
 <Y34NK9h86cgYmcoM@shell.armlinux.org.uk>
 <Y34b+7IOaCX401vR@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y34b+7IOaCX401vR@shell.armlinux.org.uk>
X-ClientProxiedBy: VI1P190CA0046.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:1bb::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB9PR04MB8234:EE_
X-MS-Office365-Filtering-Correlation-Id: 837b87e6-43ca-4625-b123-08dacee0dfa3
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: djf8gkV16dENCNC9g6TkhSCgVxmc6FC1UrGzYoows2PY7tu8LDtgOZCgaYv3jWep6l+gckCy4+kCCa1DNPxFyUp3nyVh99rE1KS41zXISRIBWnenhn/AGKw6wl+rybfi+dgHiuW5xLppjekhMMCmSVGpVDN568YI7YkR/359z06uNJCgFu6+1k8mZ56+NUQZxtyKdfuCcf1Q6aI9jYwq9xrZg4JEArDQzfdJcZmpXUX2y01cAgtrTWIctXLd7XDuYG2FtXW20fPpmdri4Y3VLeE6u5/wyBfLkb5dByfAYPf+32dRP6YCpY99IgM8vAOcdxFNHhZ3Cz7xM1TzEMkbiRBtrYg/pUIvwCph0pd2vCHLfzkvj7y6AIotBE/bq5Lw7ZId1QtemFVTGWis2TybtBXsSki3wg4YXYNOYVBpeofhnMIIWh3snzcS5o2AiXCLfvU1ojyvkjZ4vLlQlnEJ8lGqAdafBcWefExBF2QxxvHVUTOKjgwF3JLfMGv3A6stlzZU/DQdRb+nWWZRBOWUS1Or7SkMxrDb/atte7xXquQqx+QQIH5lyQop2hs/NRIpHZcLFZNiSVCOk+Cx92y86kh8Nz2TJEFDQP+n2xWbqKC3bKuAtX60KRaTxjiUg3wrZNagtGYOlTlFKhPX/YpX3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(376002)(366004)(39860400002)(136003)(346002)(451199015)(33716001)(83380400001)(5660300002)(44832011)(1076003)(186003)(2906002)(86362001)(7416002)(8936002)(41300700001)(8676002)(66556008)(6512007)(9686003)(66946007)(66476007)(26005)(4326008)(6506007)(6916009)(316002)(54906003)(38100700002)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WEkEkTOW6l37s0CJCPjYeSD9a9pKcEEUkMcgLE3aTpWCipCK2QHSTYHLuCz0?=
 =?us-ascii?Q?H/KUS1DRyUuEFNVCs2xb31RXAXv3DYWxNM7ghERUzlW36F9vJaH8w6Secdxc?=
 =?us-ascii?Q?trCL7wFO1lLKq53lY7My2qQbG9sHqoGGrwxg5Ty+ywSqzoAcuQKmja5iMSBo?=
 =?us-ascii?Q?bRoUg38JMGxaAkk22kFwT2vprnzbFBnsmjKsKfBCnnRNKCvXeU2gTTwCczsQ?=
 =?us-ascii?Q?pOAsrZK8lxvD5fY7EUP9KZG3sz9hMrwEeSzoLUDARCKM3j2GoF6KpFwbFPWc?=
 =?us-ascii?Q?tevkMbQKjkvRc45PNM8kFMDLTdt0UHlIxdSVlVB4n1i3dqDlB6ekXzdySN7V?=
 =?us-ascii?Q?XAT0XmqMpK6hmp/3Aj5ZZyZFO+CQeBW+19TEzpcRtu6JlFlmliUOchM1qd/K?=
 =?us-ascii?Q?efRUybKSevTz7zdMO20A1fHEnu5XkbufkOXd4rV0iFv4wVt7kR0BsEaqHiHs?=
 =?us-ascii?Q?dXm/ujPfL72o33AOICYfBIfqUpiuFcrxuO7ts+AMT67N/CBRVF9ptsHcoZIj?=
 =?us-ascii?Q?gYz4Qwyh+GxYFktpuv7B34+EJFzUCPTkKiMzz5PdU25q4e2d1juNLONM5YNy?=
 =?us-ascii?Q?AxkPrpe970I2c1Sri60DxMyHaYmlJ7acIUGBkTtlPhVGx6SonixkPgTf/3C0?=
 =?us-ascii?Q?PESZO9j0Rn36rhxSVyX7V7bW/DPV2ca/mXoF9dH6Ac/Fg5bt++P3ZoPKS3Wr?=
 =?us-ascii?Q?3i3ibhj6zRkhIgly73S7YhqylXyLrhKX5+hd2l0hFpUo27sBobsjXtj84AY6?=
 =?us-ascii?Q?hdJoCN6s4bHDvkpnZ3vbW6bGV41EquYvQYEkdS74IawuPDk2kHygsIfxnCiq?=
 =?us-ascii?Q?xamTQlHoR4i2ir6CXgln6mMZquSiwQ3thywAID1tNrIlV20kl3dXU6dxe6nY?=
 =?us-ascii?Q?lAVm/aed/NBpBIu8Em2SufURqLFSEWUZRNf69R5VQr/ohXegyHdH97uUIgW4?=
 =?us-ascii?Q?YfwX/b3W1UG4ug0jIbpuoVoV2zcRE4TOLrVU+dpkm91EimGE38qJFuvZYuBU?=
 =?us-ascii?Q?4Qhi1RwbZJeokHWW6CUkHl1GivnT8kBbdDktZ+TMMUw5vLP6xaeiDFGdCRri?=
 =?us-ascii?Q?Mn+eLGodoReR+5Vd9ZTgfl9O3TM+tZiMNkns4mjTXvrO6uPkYljsjIZfTIpM?=
 =?us-ascii?Q?GhSITSibzZAWT4YVr3G9wey4TYNJF3dWa6xR1ajLLtpSjupYVq55F59DlBhI?=
 =?us-ascii?Q?4/67ftf3Pefgk5vEPU4TGdFLsEb3utOj3h5PQ8/+njH8p3ZKLN+TZy2DO8Lu?=
 =?us-ascii?Q?Og2BJXjgSnaWUFRWHQg2JcdGdVrQWazVxnsEFxE4FdRM61m3DaCv2NPpTklY?=
 =?us-ascii?Q?qsbn3ciLY5MGRTjH4XMtrVOYJLPaREida0/uW4PNcfnaxnO54Yx8fltVuUku?=
 =?us-ascii?Q?9a6+rcBtGVnabW8GBVzhrvOe9C81+IWa6bBfw7Dz06ubMqB5QnWmWH6i2Qut?=
 =?us-ascii?Q?J5Jde10PNo+KTSvxux9Dc2KDQ7mS35wduqj4tKJuWR+XZ50uvkC9eRVAeL7V?=
 =?us-ascii?Q?/EQKpu/ISats3wShLt4K6zizxv7GBb6TXTkBd/dWI4srhGI3fOda78Kg12Qm?=
 =?us-ascii?Q?TmOsMsxKXdYisBLVPTY4MZmR+MFkIZMCzsMNqLJ7AoI8HxEi5U28s4eawdKV?=
 =?us-ascii?Q?vA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 837b87e6-43ca-4625-b123-08dacee0dfa3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 12:30:44.8108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zm3eALRSKYP4J+yqzBCE0wS9GyHXVYTQt3plPKMHRLKmLGpxZx42kWMrKiylBu/fTPx4TLNj43emrON5Izd39Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8234
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Wed, Nov 23, 2022 at 01:11:23PM +0000, Russell King (Oracle) wrote:
> On Wed, Nov 23, 2022 at 12:08:11PM +0000, Russell King (Oracle) wrote:
> > On Tue, Nov 22, 2022 at 09:36:59PM +0200, Vladimir Oltean wrote:
> > > I think we're in agreement, but please let's wait until tomorrow, I need
> > > to take a break for today.
> > 
> > I think we do have a sort of agreement... but lets give this a go. The
> > following should be sufficient for copper SFP modules using the 88E1111
> > PHY. However, I haven't build-tested this patch yet.
> > 
> > Reading through the documentation has brought up some worms in this
> > area. :(
> > 
> > It may be worth printing the fiber page BMCR and extsr at various
> > strategic points in this driver and reporting back if things don't
> > seem to be working right for your modules. In the mean time, I'll try
> > to see how the modules in the Honeycomb appear to be setup at power-up
> > and after the driver has configured the PHY... assuming I left both
> > MicroUSBs connected and the board has a network connection via the
> > main ethernet jack.
> 
> Unfortunately, I don't have a SFP with an 88e1111 plugged in, only the
> bcm84881, so I can't test my patch remotely. However, it builds fine
> when the appropriate TIMEOUT definition is added.

Sorry for the delay. Had to do something else yesterday and the day before.

I tested the patch and it does detect the operating mode of my PHY.

My modules are these:

[    6.465788] sfp sfp-0: module UBNT  UF-RJ45-1G  rev 1.0  sn X20072804742  dc 200617
ethtool -m dpmac7
        Identifier              : 0x03 (SFP)
        Extended identifier     : 0x04 (GBIC/SFP defined by 2-wire interface ID)
        Connector               : 0x00 (unknown or unspecified)
        Transceiver codes       : 0x00 0x00 0x00 0x08 0x00 0x00 0x00 0x00 0x00
        Transceiver type        : Ethernet: 1000BASE-T
        Encoding                : 0x01 (8B/10B)
        BR, Nominal             : 1300MBd
        Rate identifier         : 0x00 (unspecified)
        Length (SMF,km)         : 0km
        Length (SMF)            : 0m
        Length (50um)           : 0m
        Length (62.5um)         : 0m
        Length (Copper)         : 100m
        Length (OM3)            : 0m
        Laser wavelength        : 0nm
        Vendor name             : UBNT
        Vendor OUI              : 00:00:00
        Vendor PN               : UF-RJ45-1G
        Vendor rev              : 1.0
        Option values           : 0x00 0x1a
        Option                  : RX_LOS implemented
        Option                  : TX_FAULT implemented
        Option                  : TX_DISABLE implemented
        BR margin, max          : 0%
        BR margin, min          : 0%
        Vendor SN               : X20072804742
        Date code               : 200617

Here is how the PHY driver does a few things:

[ 3079.596985] fsl_dpaa2_eth dpni.1 dpmac7: configuring for inband/sgmii link mode
[ 3079.689892] fsl_dpaa2_eth dpni.1 dpmac7: PHY driver reported AN inband 0x4 // PHY_AN_INBAND_ON_TIMEOUT
[ 3079.696826] fsl_dpaa2_eth dpni.1 dpmac7: switched to phy/sgmii link mode
[ 3079.779656] Marvell 88E1111 i2c:sfp-0:16: m88e1111_config_init_sgmii: EXT_SR before 0x9088 after 0x9084, fiber page BMCR 0x1140
[ 3079.865386] fsl_dpaa2_eth dpni.1 dpmac7: PHY [i2c:sfp-0:16] driver [Marvell 88E1111] (irq=POLL)

So the default EXT_SR is being changed by the PHY driver from 0x9088 to
0x9084 (MII_M1111_HWCFG_MODE_COPPER_1000X_AN -> MII_M1111_HWCFG_MODE_SGMII_NO_CLK).

I don't know if it's possible to force these modules to operate in
1000BASE-X mode. If you're interested in the results there, please give
me some guidance.

I was curious if the fiber page BMCR has an effect for in-band autoneg,
and at least for SGMII it surely does. If I add this to m88e1111_config_init_sgmii():

	phy_modify_paged(phydev, MII_MARVELL_FIBER_PAGE, MII_BMCR,
			 BMCR_ANENABLE, 0);

(and force an intentional mismatch) then I am able to break the link
with my Lynx PCS.

If my hunch is correct that this also holds true for 1000BASE-X, then
you are also correct that m88e1111_config_init_1000basex() only allows
AN bypass but does not seem to enable in-band AN in itself, if it wasn't
enabled.

The implication here is that maybe we should test for the fiber page
BMCR in both SGMII and 1000BASE-X modes?

Should we call m88e1111_validate_an_inband() also for the Finisar
variant of the 88E1111? What about 88E1112?
