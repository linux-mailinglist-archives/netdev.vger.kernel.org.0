Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 936FF62869F
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 18:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238160AbiKNRH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 12:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238153AbiKNRH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 12:07:56 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2062.outbound.protection.outlook.com [40.107.20.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59482D745
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 09:07:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mJv1FfApzWSKGfp/ck0Cbo/k1DkGII+/JkVR73WNIwSAP5r/+79ERfxBzxG/wGumVpG3qY45uzi4NhSz5J+v6Vvya3rSszCvEAqJBWIckPdwTW8TnjAa+SZwT3kh7H+2z4qoDIPLk0GBWqRDJS4AnQMsxOXYO5Ud9O2mpNI++37RBH2wK5uWs0gGIDmh0y1OaK9XdmiOXIAlw0AP13FW5CO7mvq9ZD/Dbfk3POKj+y0GsmLmWXKlIhoK03fmQnyXFODV0lzFIOSGnOKNLirQBshBsIJdcPekSH0IA5nJYbErxcY3qu3CAqgowUygMFITRYYD7hxJ1sMtkLzcb5dsaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GKSp09r6XgfGa5r+gyUYV+LOu3+PvtytgInxgY3iq7s=;
 b=fESD8MU6uBqkT6E6BI6Ge0tIAyY60RTfrq+LfGcZb7QuAu2fvm9krCo5ufvQV/EhkBbv5ovvxi/cl/vrWSssyWzLif0rZrbA+mYE5QoFCy5codj8ONVk12SsLSmT3gsCZCn/Kzt6Cgtuh2tmuwqDNYP+yI57AB5GUi+rlnJLJszEoAc1NDwfg8MF3SanWG/Ow94pGelH4HELVHu8norA9p2GoiYQxPtPpDkHFoV+dgzh+WIFDPhvaH5obIXPkaP9tEVmrl1yHMjkcg/bVRuDdvt3K+FczCaq+pWpI/KRztX+VJ3OKWl2H2sRJMdhtT4W049KqNwBxLjb5gOl3swBLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GKSp09r6XgfGa5r+gyUYV+LOu3+PvtytgInxgY3iq7s=;
 b=AVVAtwLq3cvujkn+N9NzJK+fz61REDBIghBSeTbml4cLBr0BiBuNStngh1+OaTVqhKOB9aRhMwjXffk74O8qSRBr4T9KhgNB9OSXeHKK7E7UVjgxnkk2gIW08yQZbbPOMTxKWFMUcrpQz8JGWWq6iEl3V+yc/GXWo61bDQxvffM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9280.eurprd04.prod.outlook.com (2603:10a6:102:2b6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Mon, 14 Nov
 2022 17:07:53 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 17:07:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH v2 net-next 1/4] net: phy: aquantia: add AQR112 and AQR412 PHY IDs
Date:   Mon, 14 Nov 2022 19:07:27 +0200
Message-Id: <20221114170730.2189282-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221114170730.2189282-1-vladimir.oltean@nxp.com>
References: <20221114170730.2189282-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P191CA0007.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9280:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a4e9289-1d55-4959-1b28-08dac662c44a
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1nMZqWZGK1mx2OkGfqBRgX2ANlwa5bxhaAWm5Zgwi4N7GWLcJkZh0MB/pbUtEkieTQHiVzbjW2CkRvjx0XvZGG374eIWCqvBTxpmKSYtNJw8txO2Vhu1juKim5rOi3ECGpUzmvTwO8pgPdJ446v+Ysvk4Hvcw357vvXDg4BsXHwacJrcPIRKARNHI8uQz/zGGgDSB8FRwX/lvV+0pwYt8IVv9de6C/TtI7DK7iAmF0IqgrbfZ7TiN8HwXWfe5AnLNG2Ax13XlEfnHUgnUsCxBFG1hzt5XBntyIzLPqeBqM/Aw6tNpnbkjUUF41klI2XyM81LXYorXXX0TDHeZODQ0b9L+AnqhLamdq1sBVeZWPQqK/LwjwPy0mg64SFJX/gMMKq7JU6B21scXR2vLqPypTaUmLMMad5gKsW1w9KcCQB7PcNm193kdnmlzXewquU2IsFknPbt/Hmk03BQwDgCiBy18jGnFZxVO23pooingqI+5Rv+JpcBkjqL7/QlftJcbTfLLhud0H8smX/s6BnSjIU19LGLl4cppBETSdZU/14FA7mDQJANdTgzbUFivTPPVyjESemA8rrrH0jGGrfViR7sI8JRzF+mS0bmLU4z2X9Zay2HS1FpTfT0DuApI9qwwVUZAYG7kjVhIA/b7iIU6BaABQH8i2dv99ns/HVHcysXLSL1VUAC+CirOwvezW64NEg5xx/TP+kXVDvtHD4+No9ImxzJq+Ez+AyrfBWP/pvlCcl7b1smlgS5xzcqbBE8dfHtHIYbnqpg8SdyUMh16Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(376002)(366004)(346002)(136003)(451199015)(44832011)(36756003)(7416002)(6512007)(5660300002)(26005)(1076003)(6506007)(6666004)(2616005)(86362001)(8936002)(52116002)(478600001)(6486002)(83380400001)(2906002)(186003)(316002)(66946007)(66556008)(41300700001)(66476007)(6916009)(8676002)(4326008)(54906003)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?v5rg66adwuBQ6byQxgKdbaJyJQmnC+1xE6YwsNKfJhlzfI4VhxELUopo9zHn?=
 =?us-ascii?Q?kVmwi0eBJ2pAiBot1HdYsTtzvJaEimJY2QeBpYlJN03p1R+JeeZfyAexrDmx?=
 =?us-ascii?Q?Frq85CcIyFFYWIHDhrRUS8efRObQQsNrwFzNR1jGbO8flhA5ncP5tOdHuBQJ?=
 =?us-ascii?Q?YTzljMzisft4te0/AcG5iNFh9TQRfGTe80gMP8qHGqcdUAFsE/O9FTL4uosk?=
 =?us-ascii?Q?rKrVeooEa5SvE+kaYclRYav+AhrwBCQw+pMbMYqi3YDGE7JQkhN5xzMR+acC?=
 =?us-ascii?Q?hrb1eDonIeYs+FCz2kFOQOGiLKBc0yCnY7uW6L4v5gTzR6x3HDbRsrx38AP9?=
 =?us-ascii?Q?ZaeST8gVUKb+9IbWM1RSHQkm3qOqDAsHv8DkwoCLRAIwGBiDLZFNJpZCAksm?=
 =?us-ascii?Q?ZMRUDFVTLGGFdp/XB/OPDI8uBrm6XmWtqnKnFE+CO9LaV8A4nUJQYuetMhWg?=
 =?us-ascii?Q?x9HATxyjfb7LqmiZPqgsUmI2LkUEHTWHRWDGXHxRth+h7nrk2Od7kAgkxJua?=
 =?us-ascii?Q?91RVw0t6cFKPWv0QVZYlBeY4Aah4DkrkWvSP7v/ZuQEa3+wjGAe/8bbd+85M?=
 =?us-ascii?Q?sLBTnDAisvk6d9rk5Es4Hng42Rb8E3qRaKiVBkJFn95OexZgpNICsscbz5Yb?=
 =?us-ascii?Q?TK+8xA5cqFvaQY4GvuVx0fty/hyj90aMKybprPsTzaC9Qdl7z0oy4a5T4Raj?=
 =?us-ascii?Q?pRBYiZh1xccH5Vx/xQPVQXqu1a8O3d86H+TeWUznjVE1KOZAgyGDjvSznZvd?=
 =?us-ascii?Q?uZaPLIE7GOShv65F2nZQvKAX03odQLWrfk2S9LNmiibaqVpBnsl9QwRA0A5H?=
 =?us-ascii?Q?cIBCeaN7KeG5U9jJNMda2EtQfSn8UH2UrleQ3Yy1VY0RqE5FMUs/jAwnb/T8?=
 =?us-ascii?Q?0GYnKZsgK5BZ8fl5pYejQ4wElVAw7nA5TNTqeY3p2nC0tLbojvWRVgY6A91l?=
 =?us-ascii?Q?etKuHMiBDv34TySsG8yDzXGZTtJJ5yMwXsZ4bO7wq4R7pK4wKLh22nYlUZ7T?=
 =?us-ascii?Q?JyDWlaXYks+t8UjUKW33mUDu6T/Ik6Bfo5XoUYAkft31wf4hGu/5ARCk2XTt?=
 =?us-ascii?Q?qZvgjAOomeZFbMSAvHkwJ4Gltx9gF4gTbYMsJoeP/VQln7rxLeF4y+j6ZDAW?=
 =?us-ascii?Q?0IfljtVVDdpyRHdM6r8VXiUaxCixrN7J7pjhrjEbTGhFfD+7CA7dfN8kgYAo?=
 =?us-ascii?Q?+dJJ800cXMJS8VdhXWUWbyabS+j56YSMkOxl1KOBOCx8UXvZjmaoTk0nuLcX?=
 =?us-ascii?Q?zrKFC4XxxP0mvE3ZonknXoF50xPcHyjqs7iaXZK1b9nlqTEPxwPx1WzdRpXt?=
 =?us-ascii?Q?xXUd5/jg1WBvX/mSeGk7VEAyaFwA2wlouo08cL+qLyH53lsBXsSa8NzwOQry?=
 =?us-ascii?Q?CMovVXugWk07J1V3PErOtUsMWN1CqAxBTqQxXxYo7yxHYCnJpQnW6UIBtKQU?=
 =?us-ascii?Q?gUegCTipYVC1EWpPKOf0/PdroC1XlWYLZN4O2dI0dNNEaayZCUt7yopsT/3A?=
 =?us-ascii?Q?YzcapoYyMZo43j0jzkOtEvXsF0aM+V1V/RNEV7uGnoj3bS5rOA/QqcgIF6/h?=
 =?us-ascii?Q?fKL8liL7QaecqXVaGuI5Dy6Zn4wrHMK37IE1Riycb+PknE3r5Sk9xw7chcvS?=
 =?us-ascii?Q?ng=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a4e9289-1d55-4959-1b28-08dac662c44a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 17:07:53.0506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tw9iFUCE15kWb7IFjJeXC++XggdfdoSoGH0+z4qvUKd6PP90B7NdEyTuEwx1YgecVYtUzRFnb73s+RsvhpoSuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9280
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are Gen3 Aquantia N-BASET PHYs which support 5GBASE-T,
2.5GBASE-T, 1000BASE-T and 100BASE-TX (not 10G); also EEE, Sync-E,
PTP, PoE.

The 112 is a single PHY package, the 412 is a quad PHY package.

The system-side SERDES interface of these PHYs selects its protocol
depending on the negotiated media side link speed. That protocol can be
1000BASE-X, 2500BASE-X, 10GBASE-R, SGMII, USXGMII.

The configuration of which SERDES protocol to use for which link speed
is made by firmware; even though it could be overwritten over MDIO by
Linux, we assume that the firmware provisioning is ok for the board on
which the driver probes.

For cases when the system side runs at a fixed rate, we want phylib/phylink
to detect the PAUSE rate matching ability of these PHYs, so we need to
use the Aquantia rather than the generic C45 driver. This needs
aqr107_read_status() -> aqr107_read_rate() to set phydev->rate_matching,
as well as the aqr107_get_rate_matching() method.

I am a bit unsure about the naming convention in the driver. Since
AQR107 is a Gen2 PHY, I assume all functions prefixed with "aqr107_"
rather than "aqr_" mean Gen2+ features. So I've reused this naming
convention.

I've tested PHY "SGMII" statistics as well as the .link_change_notify
method, which prints:

Aquantia AQR412 mdio_mux-0.4:00: Link partner is Aquantia PHY, FW 4.3, fast-retrain downshift advertised, fast reframe advertised

Tested SERDES protocols are usxgmii and 2500base-x (the latter with
PAUSE rate matching). Tested link modes are 100/1000/2500 Base-T
(with Aquantia link partner and with other link partners). No notable
events observed.

The placement of these PHY IDs in the driver is right before AQR113C,
a Gen4 PHY.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/phy/aquantia_main.c | 40 +++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 47a76df36b74..334a6904ca5a 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -22,6 +22,8 @@
 #define PHY_ID_AQR107	0x03a1b4e0
 #define PHY_ID_AQCS109	0x03a1b5c2
 #define PHY_ID_AQR405	0x03a1b4b0
+#define PHY_ID_AQR112	0x03a1b662
+#define PHY_ID_AQR412	0x03a1b712
 #define PHY_ID_AQR113C	0x31c31c12
 
 #define MDIO_PHYXS_VEND_IF_STATUS		0xe812
@@ -800,6 +802,42 @@ static struct phy_driver aqr_driver[] = {
 	.handle_interrupt = aqr_handle_interrupt,
 	.read_status	= aqr_read_status,
 },
+{
+	PHY_ID_MATCH_MODEL(PHY_ID_AQR112),
+	.name		= "Aquantia AQR112",
+	.probe		= aqr107_probe,
+	.config_aneg    = aqr_config_aneg,
+	.config_intr	= aqr_config_intr,
+	.handle_interrupt = aqr_handle_interrupt,
+	.get_tunable    = aqr107_get_tunable,
+	.set_tunable    = aqr107_set_tunable,
+	.suspend	= aqr107_suspend,
+	.resume		= aqr107_resume,
+	.read_status	= aqr107_read_status,
+	.get_rate_matching = aqr107_get_rate_matching,
+	.get_sset_count = aqr107_get_sset_count,
+	.get_strings	= aqr107_get_strings,
+	.get_stats	= aqr107_get_stats,
+	.link_change_notify = aqr107_link_change_notify,
+},
+{
+	PHY_ID_MATCH_MODEL(PHY_ID_AQR412),
+	.name		= "Aquantia AQR412",
+	.probe		= aqr107_probe,
+	.config_aneg    = aqr_config_aneg,
+	.config_intr	= aqr_config_intr,
+	.handle_interrupt = aqr_handle_interrupt,
+	.get_tunable    = aqr107_get_tunable,
+	.set_tunable    = aqr107_set_tunable,
+	.suspend	= aqr107_suspend,
+	.resume		= aqr107_resume,
+	.read_status	= aqr107_read_status,
+	.get_rate_matching = aqr107_get_rate_matching,
+	.get_sset_count = aqr107_get_sset_count,
+	.get_strings	= aqr107_get_strings,
+	.get_stats	= aqr107_get_stats,
+	.link_change_notify = aqr107_link_change_notify,
+},
 {
 	PHY_ID_MATCH_MODEL(PHY_ID_AQR113C),
 	.name           = "Aquantia AQR113C",
@@ -831,6 +869,8 @@ static struct mdio_device_id __maybe_unused aqr_tbl[] = {
 	{ PHY_ID_MATCH_MODEL(PHY_ID_AQR107) },
 	{ PHY_ID_MATCH_MODEL(PHY_ID_AQCS109) },
 	{ PHY_ID_MATCH_MODEL(PHY_ID_AQR405) },
+	{ PHY_ID_MATCH_MODEL(PHY_ID_AQR112) },
+	{ PHY_ID_MATCH_MODEL(PHY_ID_AQR412) },
 	{ PHY_ID_MATCH_MODEL(PHY_ID_AQR113C) },
 	{ }
 };
-- 
2.34.1

