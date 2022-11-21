Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED05632D23
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 20:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbiKUTo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 14:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231481AbiKUToz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 14:44:55 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on0622.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::622])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A893CC78C8
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:44:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aEd+ukwkfUv8kxJgy0pd0iBIwnvcXDD+ogQNxvT4Phrolidan2ZosVBnZXmQYQsyHPtP2JZj66NE/gKFpRgbFAdxvebqoMAEPDKW+Olnz3myo32cTheBdC8+RclAZ97e11vA9XYubFNTOZDLoKK2DITkQbRA8SnOk9E+OnYNv3AN60MbxRV2sqK+m4sWw4uEL/tSzSZOpYPvc6Gc0vDuHKmna7H5gox65UBA8oNttn5vJ2YcEuXc4EufMwmEWu+OsK572IE+I5eZp7FAvzz+zHDJxFyPxNmpF9siNOkwg9SCtT2uVwyPyAn2UCNOYeJ0y3CusBbmHXItzjuiN/WP5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MD+fCBzmxvzNw3WDzlbgxVkx1Rw0E5LszIO4dWMKw24=;
 b=CbELn0VofwcmJn8hdqmVHUottvPq0Fdcld3pJm8e6xTXmUvqEe36mGO2LJO5l42eT6+RGjg/SClJKBASWia0X7QjaAhsSY6tJ5p4PWXQTFQf+qfL5GrF7M4M4n+f/18HVE59lKyJvtUNUSNNdrf2UcJrJktbtnPA6Ggamm+tzi2Cr7aw8cqXCbLu0QGw1zadjKTgda9wctkWh09JrketSJelYYj5wTHT4xjlMtv6GA2otL9qNOMqD69oH4RIvhTu/oTKH8Pb3tXMNvhJmWU9jiT75lT/Tkg6askj9tuFlDLq0VyDaWBhTA4VySMS3AX/9sWVMEAxAju0W3QqdUqDdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MD+fCBzmxvzNw3WDzlbgxVkx1Rw0E5LszIO4dWMKw24=;
 b=P3tALrR1sGFgKELuxGz9UGSqpX9uYC3E2SJ+xk/Ywrj1oKPvVwZ2Hw6LSAOWIppE1LzF7vJlb3CsiNGMRd4ExSrq1HKh7dU7VECgd5N64SBxd+smRxHc5ldmmBn2baxpAyGqYZSW02ptBOA1cCwOsT2sYFwG8V9eOKL7OfMddnU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8773.eurprd04.prod.outlook.com (2603:10a6:10:2e0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Mon, 21 Nov
 2022 19:44:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 19:44:48 +0000
Date:   Mon, 21 Nov 2022 21:44:44 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
Subject: Re: [PATCH v4 net-next 0/8] Let phylink manage in-band AN for the PHY
Message-ID: <20221121194444.ran2bec6fhfk72lt@skbuf>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
 <c1b102aa-1597-0552-641b-56a811a2520e@seco.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1b102aa-1597-0552-641b-56a811a2520e@seco.com>
X-ClientProxiedBy: AS4P190CA0041.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU2PR04MB8773:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ac0d8fc-5912-4307-1ebf-08dacbf8d93f
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2TWLdtQLBjKDO6RmCMzJpFK4pLE4pGTyzEGG2KV1M0bij2bQZY0DtAbViMDB7ljwfd81EhkVjlMIEWCZmxeuKPEw1rwnumK2tPuUi0e666Dv1DRzfcXXduSRHJ6Zhla5/Pgnlf8OB0d3fUtoTcoWb1LaImv2UHYLFE5/diu3B8aqmhRjIMeUsElkK2E3en0yBivV52gkkzggps0SpS7Wmk4fNvLkT7bQq2lE7/8PqakdV0PqlrEjkG3lBfGP0pogpw5tZ828LuuNe2GBdYqNAMvrJETZteo7XrGBAR/gaWZ0AcZsLDHrU+a4ZQzbBfFjI7fMzcP4GwzjYEjNFL1pytekRwhqkLTdVafw+/0JwV06gELENNcHkXLfDpOWkiabgE9W+rX5TS47aCNa1dogRx4X261ifTUZYrV4bEy+SQQrP8kjJYFfY8bpIRqe+PzaIc3qBXQhlnQKgHlSw5eDWsMlBiBgtrAv2/SLWU+u7MFgiyPozgdGRe/dq2qzvqCs0oGG/UqDxUmxFcLlxWELkNqRFYCrjOfv14wV8NZhITyFBlHesnEWxs3X5EX+uibCO/JdsEt64/oFFtKmaiokhFHYMp/5XCvfPmgRxOBKfSAtGubJl7worvzVi4SJYPmzB0+sLK1Ii5Wkn/gTC+WPKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(136003)(396003)(39860400002)(376002)(346002)(451199015)(6666004)(478600001)(6486002)(66946007)(26005)(66476007)(66556008)(19627235002)(6512007)(9686003)(41300700001)(186003)(316002)(1076003)(54906003)(6916009)(53546011)(44832011)(6506007)(5660300002)(7416002)(8676002)(4326008)(83380400001)(2906002)(33716001)(86362001)(8936002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bHK0eG+dniM3N1ZdCiVf4hO4VaLdtzVPOPkelIo686BfmYUR+hgSpCYNDquj?=
 =?us-ascii?Q?7u9/Rcu99x+39vRPAqFe2pFvmcbXjba+KkFYso9b9Fs9JGUeWUkNmunbhiNQ?=
 =?us-ascii?Q?YRgCuF2chCQZQINSEifJJpyWfH8OZJg9HC0VSFzswGSgysTE4ZRBGdlgUC6O?=
 =?us-ascii?Q?0mEvmd9NTtgEg50ONDVYkFqjUNiUKEkRjgXCot4f2ql9b7RaZ95doffOnKfu?=
 =?us-ascii?Q?xAzGlAZjHT3yHZSE21FVDhxhFjXXEsmP5OedQQ/mJKCsQ/AbjtoPecQ/Ax0B?=
 =?us-ascii?Q?7C3Ep5+oPw8XeGQ6B8cBINl2ReiZkYx8L87mgaCeXNh3TcuxhRxTAZZNDo/i?=
 =?us-ascii?Q?MmpixhsfkY50Bu4HZCqyTB2TAWFrsSg/gbSzSt84I1CgUEKDRSe6Aco83qQ5?=
 =?us-ascii?Q?dKMHDSJMsjkzJ2WKf7fRKdcEK1SNc/lfjt7tfs4TM7rX1mtdoYb796G46Wru?=
 =?us-ascii?Q?J6QixWwjOcEM9aF0Cg3hhJKXwS/scAWHrpESQaYqftLF895S6AD5FbDdIITw?=
 =?us-ascii?Q?HGO779NmpwDIcTzP3Kd1LfRw/TtT/S/MsjbYBr2BvO+Uj2lfPQcXSKIBht0N?=
 =?us-ascii?Q?O0ZOPeWJLRNK4O6OULv3lI4DO65k6FcjzOHtFRM3wYIMzN26AbKdIYLprlNs?=
 =?us-ascii?Q?udy3UDdFlMYk9DXbFyvpt67VjJo78SqGkj136KRD737e64JoURnNu7JGkX7n?=
 =?us-ascii?Q?4UcNWhbbP7YYDULEQX8HwmBTLAKcxGVGQ+fpPnni6Cgy4bnJ2l7ahG8FhnWX?=
 =?us-ascii?Q?bapdimk25iFLKgWp9SCSBskCLVFC0DsV5ylwMW2M0eKbnVy494nVZBc4NEup?=
 =?us-ascii?Q?OXoio8csrl1N/Hy4GoErweI3o6HxJU4+JpNCk3QrxI2irwc/CS0jtXFmWbF3?=
 =?us-ascii?Q?7k+/zUDxyg2f/HadcuL5ILR5dcazwKosojdYbGgLogyXscZRC83kfrSDvfZe?=
 =?us-ascii?Q?EtA5Vj5fKXYMZh1CocspzL5pDnKUYsZ6lECAVHwSrutReDfwqgieyBdB6a9A?=
 =?us-ascii?Q?KTi4qcdfZ4ZNLPXWONDkEla07VPnjwmI17s/XtRW3B+7jxsHbVYj2C6t16QT?=
 =?us-ascii?Q?X4QdOxPYixSdUEI9vxSPWC3z2CJ7Ax8lnzHmqZt+M6e5z7+RWjOiSBWNbw94?=
 =?us-ascii?Q?oSkOn17RXCd/aTf+TWA4F95Heg3QtrwG9SyvPrBnjFV2idbP32jrEnvyYuYb?=
 =?us-ascii?Q?tYarlShmIDJTq2PqgipaFfVH11vrK/FCu/0fCAHrktEGsUveW5/FWntE0Ld9?=
 =?us-ascii?Q?gXJ0tHV4uhsmmfvoUnyBlKh0bqRODpCkEpUgZSc6BpFkOVNHCAHja9RKPTrT?=
 =?us-ascii?Q?JmG4fUFD+a6pupnUOjWP9Xo/3i6TGRSnDeVCwij2gB71roWRwkU3Pbzkw7kG?=
 =?us-ascii?Q?QiTGPVhEwYpRXj6kP3ZL0cuo+y2HFbZ3lwXN2kxJ9vxnawEBAllr/1SGcTU0?=
 =?us-ascii?Q?4V7xFkloH7An3sgc3YMsTf6g9P48Migvc/NB0WZNWMm1lA1Q3FNFJ19L/LAH?=
 =?us-ascii?Q?DORm/oujZ2e6KPWqsKZ8C88gGP7cH4eknna7gwZq8U+clfaw+h7xc6ZxA6UF?=
 =?us-ascii?Q?Y66ArzpZhfaaBrpaswHd81IP8PqAkYPJp6G4w2X5+egNd/M6m6oqqplA+ZAQ?=
 =?us-ascii?Q?1Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ac0d8fc-5912-4307-1ebf-08dacbf8d93f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 19:44:48.5029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c5sHoNJV1nTY0eLOm6KoJaGNJZFhRBN8SUUoFqTcKFeLtEMTPo08Hgn0LPoMlGHzsw7MRa8mdfdwYpL32vz2ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8773
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SPF_PERMERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sean,

On Mon, Nov 21, 2022 at 01:38:31PM -0500, Sean Anderson wrote:
> On 11/17/22 19:01, Vladimir Oltean wrote:
> > Compared to other solutions
> > ~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > 
> > Sean Anderson, in commit 5d93cfcf7360 ("net: dpaa: Convert to phylink"),
> > sets phylink_config :: ovr_an_inband to true. This doesn't quite solve
> > all problems, because we don't *know* that the PHY is set for in-band
> > autoneg. For example with the VSC8514, it all depends on what the
> > bootloader has/has not done. This solution eliminates the bootloader
> > dependency by actually programming in-band autoneg in the VSC8514 PHY.
> 
> I tested this on an LS1046ARDB. Unfortunately, although the links came
> up, the SGMII interfaces could not transfer data:
> 
> # dmesg | grep net6
> [    3.846249] fsl_dpaa_mac 1aea000.ethernet net6: renamed from eth3
> [    5.047334] fsl_dpaa_mac 1aea000.ethernet net6: PHY driver does not report in-band autoneg capability, assuming false
> [    5.073739] fsl_dpaa_mac 1aea000.ethernet net6: PHY [0x0000000001afc000:04] driver [RTL8211F Gigabit Ethernet] (irq=POLL)
> [    5.073749] fsl_dpaa_mac 1aea000.ethernet net6: phy: sgmii setting supported 0,00000000,00000000,000062ea advertising 0,00000000,00000000,000062ea
> [    5.073798] fsl_dpaa_mac 1aea000.ethernet net6: configuring for phy/sgmii link mode
> [    5.073803] fsl_dpaa_mac 1aea000.ethernet net6: major config sgmii
> [    5.075369] fsl_dpaa_mac 1aea000.ethernet net6: phylink_mac_config: mode=phy/sgmii/Unknown/Unknown/none adv=0,00000000,00000000,00000000 pause=00 link=0 an=0
> [    5.102308] fsl_dpaa_mac 1aea000.ethernet net6: phy link down sgmii/Unknown/Unknown/none/off
> [    9.186216] fsl_dpaa_mac 1aea000.ethernet net6: phy link up sgmii/1Gbps/Full/none/rx/tx
> [    9.186261] fsl_dpaa_mac 1aea000.ethernet net6: Link is Up - 1Gbps/Full - flow control rx/tx
> 
> I believe this is the same issue I ran into before. This is why I
> defaulted to in-band.

Thanks for testing. Somehow it did not come to me that this kind of
issue might happen when converting a driver that used to use ovr_an_inband
such as dpaa1, but ok, here we are.

The problem, of course, is that the Realtek PHY driver does not report
what the hardware supports, and we're back to trusting the device tree.

I don't think there were that many more PHYs used on NXP evaluation
boards than the Realteks, but of course there are also customer boards
to consider. Considering past history, it might be safer in terms of
regressions to use ovr_an_inband, but eventually, getting regression
reports in is going to make more PHY drivers report their capabilities,
which will improve the situation.

Anyways, we can still keep dpaa1 unconverted for now, and maybe convert
it for the next release cycle.

I also thought of a way of logically combining ovr_an_inband with
sync_an_inband (like say that ovr_an_inband is a "soft" override, and it
only takes place if syncing is not possible), but I'm not sure if that
isn't in fact overkill.

Could you please test the patch below? I only compile-tested it:

-----------------------------[ cut here ]-----------------------------
From 025f8dedf10defa6d5fd10b4e3dd2a505fdbd313 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Mon, 21 Nov 2022 21:34:20 +0200
Subject: [PATCH] net: phy: realtek: validate SGMII in-band autoneg for
 RTL8211FS

Sean Anderson reports that the RTL8211FS on the NXP LS1046A-RDB has
in-band autoneg enabled, and this needs to be detectable by phylink if
the dpaa1 driver is going to use the sync_an_inband mechanism rather
than forcing in-band on via ovr_an_inband.

Reading through the datasheet, it seems like the SGMII Auto-Negotiation
Advertising Register bit 11 (En_Select Link Info) might be responsible
with this.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/phy/realtek.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 3d99fd6664d7..53e7c1a10ab4 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -24,6 +24,10 @@
 
 #define RTL821x_INSR				0x13
 
+#define RTL8211FS_SGMII_ANARSEL			0x14
+
+#define RTL8211FS_SGMII_ANARSEL_EN		BIT(11)
+
 #define RTL821x_EXT_PAGE_SELECT			0x1e
 #define RTL821x_PAGE_SELECT			0x1f
 
@@ -849,6 +853,30 @@ static irqreturn_t rtl9000a_handle_interrupt(struct phy_device *phydev)
 	return IRQ_HANDLED;
 }
 
+/* RTL8211F and RTL8211FS seem to have the same PHY ID. We really only mean to
+ * run this for the S model which supports SGMII, so report unknown for
+ * everything else.
+ */
+static int rtl8211fs_validate_an_inband(struct phy_device *phydev,
+					phy_interface_t interface)
+{
+	int ret;
+
+	if (interface != PHY_INTERFACE_MODE_SGMII)
+		return PHY_AN_INBAND_UNKNOWN;
+
+	ret = phy_read_paged(phydev, 0xd08, RTL8211FS_SGMII_ANARSEL);
+	if (ret < 0)
+		return ret;
+
+	phydev_err(phydev, "%s: SGMII_ANARSEL 0x%x\n", __func__, ret);
+
+	if (ret & RTL8211FS_SGMII_ANARSEL_EN)
+		return PHY_AN_INBAND_ON;
+
+	return PHY_AN_INBAND_OFF;
+}
+
 static struct phy_driver realtek_drvs[] = {
 	{
 		PHY_ID_MATCH_EXACT(0x00008201),
@@ -931,6 +959,7 @@ static struct phy_driver realtek_drvs[] = {
 		.resume		= rtl821x_resume,
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
+		.validate_an_inband = rtl8211fs_validate_an_inband,
 	}, {
 		PHY_ID_MATCH_EXACT(RTL_8211FVD_PHYID),
 		.name		= "RTL8211F-VD Gigabit Ethernet",
-- 
2.34.1

-----------------------------[ cut here ]-----------------------------
