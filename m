Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F1662E9F8
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 01:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235103AbiKRACX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 19:02:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234918AbiKRACK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 19:02:10 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80042.outbound.protection.outlook.com [40.107.8.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D887EBF4
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 16:02:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L0ZLcic4Nx4BHvoLGahKtt7pAys8tZC2RDOQdV7ZNaCljJXNYj9ef5aOL2zBDwujz0IVaFEapgIZ7SXsj52BVDKxJaBJBwALZLFrnKbaDZGCVkq3QhJ8VZCjQmAPUgOvsV2KcJ1WyOcCLlXf8kRl73YiUlZt4tlUK5nq2Gizv1Mw+zcck8ZcfR1clenACiOFCxpmkT7zY2ZLyGpXNaakVK86MGZWra7RULh9MA3tcTAVe65o6XRSLhUfatKlEE+zBEYwJVGG7Omm0AspBWMXFvwgEEi66cfkGOG3Yp54hAZ2RnZbx+BtJAucd3fVWIQG/V93AMb0WCYcmWKiq4J9/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hBkZ2Bwmkcr6JwQWk+d4BMKyOTn03ON4HwMRurIMhA=;
 b=O93gZl8Ekr72PJeuzzXNHzIBcOJLOnO5rjBMmOzSDFUmpaiayOGByItZO8EU7ZupnOgTpnIT9GG/EoUPOFOR0b/MhQ4yP+UU84ca5enKFoapJaxz/kiX6vXICvg3LCqyrT5VV0liHtLpc1UIgFAYUbmEDHVM8XpPn5lAfHDLL9yva31DyXIE5/EUSSHYxrLKAW+hmnz5TMVRL4v5HFDAEAs9coi7JJheTV4IwQ0DQNaOMXPQRfmExwH4sLuxeZGPau7G5+Oj99TrBNWqq611vBeUhx17Ew9+uCpJ6/Mvo4wzP2eW24anXVk3LRR51HRp/xNWYC59jTTfzwXIs9ODeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hBkZ2Bwmkcr6JwQWk+d4BMKyOTn03ON4HwMRurIMhA=;
 b=kQBGGQ4jpif+yhDO26ALW1LK1v4hNnzs5Q2/DpGWwIprWw7AUGnGfwja/Ap+fzyoXIxfEvTlI4M7WdMBawkI23My4Xdn1YsZYHZG5cLWnsB8xJrWHJNtBED7rfOCUmbIkgsTdmjLH/T1ydC7FP94XwaOiZHxH7aZVftTh4L9Qoc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8542.eurprd04.prod.outlook.com (2603:10a6:102:215::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Fri, 18 Nov
 2022 00:02:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.018; Fri, 18 Nov 2022
 00:02:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
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
        Sean Anderson <sean.anderson@seco.com>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
Subject: [PATCH v4 net-next 3/8] net: phy: bcm84881: move the in-band capability check where it belongs
Date:   Fri, 18 Nov 2022 02:01:19 +0200
Message-Id: <20221118000124.2754581-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0006.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::16)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8542:EE_
X-MS-Office365-Filtering-Correlation-Id: 896c20af-2f54-456c-7328-08dac8f8222d
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9vwb3Lk8pgWIrMuNRDD8XaLtydN0RFCHBCJt2/NTvdd1W/OoXo33lGyoqXpZHj8oyHRU10scisMkVSDtj72fHth3TVo79miIafkcYRT7dbzqbH1V95pUVBTxDoGquUSMVxemJfO5CBnMMh1xJACxSuFSQ6IhSXCDNmm3UQOJOvLpHJtcDmG/qRIdOMerqa9ASaFCiOGY51TPs0BB0DD5oVjLtIlJnBJijHfsYnpymdvPJ71/3w0u3S6jqftDCC2OrzSb+UHeMm8KXpmuAzPVCdAraM/6vAc+6bydburmaawQRMkaDogWH4FoTmZJmXnkUEIjkUrGGZw23f9p5Fy2TBCIzfNTbqf/0OrlUrElqobZEENBv6GxujcHy5gxKVTWewhWAIPnn2BEtDjYybzkFiKjdHJe1F4g8qqKLCYvrFCos/poCFM7vPAqiDhNcKY/qa1WS0l8yqsmIIDiIcr9mk/jJSa866e7qD37vkFgR63EDlFkR5PnCEFrkrg4KWXwJLhqjAdgzfOfAodVhZvGdYHypUlzEEvnRrxKDh2UeXmBQLBNMyYxI7/pB6Pjko2/Id3n/JzVpIu/bx62Yt2RM4olAgYNcr27XbCAn7HslvDMr2dSOrmX/D2eKImlJKBx/mjTH+iDOSqTHuevH9YTsXwxEhSH46rjUrbMFHywOtuh+EHqGMqkmoXVO/QmLvN0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(396003)(366004)(39860400002)(376002)(451199015)(478600001)(26005)(41300700001)(6506007)(6666004)(36756003)(8676002)(52116002)(6486002)(4326008)(38100700002)(44832011)(7416002)(8936002)(2616005)(66946007)(66556008)(38350700002)(6512007)(66476007)(186003)(316002)(1076003)(2906002)(54906003)(6916009)(86362001)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J5ntwpxx6mqlKAnMeDp7PyI48vwMqnlalzwonWEg/F56B9H12u9g22ScjcIn?=
 =?us-ascii?Q?018Itb8FAQ3EK6BIAZyAhNgUz8V7u7SqeAmkMF/hjHP+22sn6QjMqBNQPOLA?=
 =?us-ascii?Q?WuzqfNuGk3aJ9KHIZDFtbtz2PUp5mPs+pMe1mQ4SxXi/f3kqsiOguSt3Wv2I?=
 =?us-ascii?Q?/YbLSYg44052pftsgwCTW6Az0ZU1+SPJ9ZwB3jiUAnTWu5Id4LxtVDqmW2YC?=
 =?us-ascii?Q?rm2NQ312Bc6mwxhQFf5/wiTLU5O09ZfNqB6USFXH8ApUUUPIxX+9NEwl1FEo?=
 =?us-ascii?Q?XT5/bZgcb/dIoppy4JqDrapg+5uERUwYoAy0nmrNnOpNH//kV4fe0srM5LNO?=
 =?us-ascii?Q?8H9JUn2B8nBT63kdF/24sw+O9eKkT1do5NeP/s/fZXggfBeeXgV3AbrahWyt?=
 =?us-ascii?Q?FaUqEqbtPfBpoHI1RjW+Dgzz4LQrYauSjquPNgfR+pKt/K5YLCS+xSoPaRRd?=
 =?us-ascii?Q?TUcKkkU1UFJ7FkDHWt7HQdDrDQmNF7PR2XWoeFIPXIc4g3phZId4GhJ+fpY4?=
 =?us-ascii?Q?o2aupTFCgvFJm93xdbvEHyshS+/c2LN8xalzTvq/7VPG2iuD51JjsfUccbYf?=
 =?us-ascii?Q?snE2oEuS/7L/fm/g27HKiO99bFwTdesaY8RppSm7S36RFMh8AWuC2FA2Hit5?=
 =?us-ascii?Q?gh/5q++7ARr/Gc/S4NhggyUfdwNB+6ikgGdjM9Eb9ZQxUgg+EE5uzP1Qto9q?=
 =?us-ascii?Q?8/OdfmfuNKtrDkdaWICunfJCpZYTANf99SgixgvGvwX4GWSTsE54Wve7Vdgj?=
 =?us-ascii?Q?l64tpWqZBZwpVfBYzc1mK1ZIYG3odCyWolhWDQhsrBYWXswHZLP7lml5eTl6?=
 =?us-ascii?Q?gN7oaA2Epebtj01h9/fQldEVKu9bEp8hJ5I+Q6eP3A8ugLS1SmPYOAHlxRfk?=
 =?us-ascii?Q?2U9Xi/J+LunROukjr2gCbYizwMrgBqh8D2Ppw+TXXpefHfzNsHHPomDEOJos?=
 =?us-ascii?Q?ga/vhWjU+yrXkYJTiVFWxPZQ5xxtB73EQUtW6qyMyLSXYgJUhYm8YwJRoM4E?=
 =?us-ascii?Q?X9jPWwoVZJFCd9dEL2+B2YG0XIH6wM2rpSrWsP4EKjrd9mHbii5i/ycuu26k?=
 =?us-ascii?Q?PJRxbpLwU8h+IRGyMMCuLgGcXko7nqzTqlme0rH/7TlRxX6RbHt5U3c7KLE1?=
 =?us-ascii?Q?PkEyOsGSQP++kKJ5ENSoh0Mk+DUng8bwoh4Swih2XyODEBXVrb9ic9+irCIJ?=
 =?us-ascii?Q?9gKZE7nru8ZMONc1L70QYDhITAbjS9TXs3kpKl4nAAnfEeq7Amd/FWnfbOo8?=
 =?us-ascii?Q?idyRA9KyBBXLIcWOKSHP8KZJ10YH0bnmJRquIYqc191hKJEzPz4uCNQhE+EG?=
 =?us-ascii?Q?SiLaO+o5GJSLc6H1Ljgl1WCldTXXrlJabTSWafdylLpGYrbJvZBzhDuXU9f4?=
 =?us-ascii?Q?dpe8TRMNv7b3kCrHnSZC8WPzXWVgFcK1spm2+iPYpAlVu91Z8eslnzIFFHVE?=
 =?us-ascii?Q?3Oc9h2F1v0KGdr/5+KZ1I+z7MZhIKlvmCVftfmJKXsL4OgwWePLVNMxdWPft?=
 =?us-ascii?Q?l3jX887N8hpUoSEIfdtY+1UeP9ZzBsBikns4dNyvDDXhacMg9Z9Zdzrc1BS3?=
 =?us-ascii?Q?ZKaBlZvc3iMJdUUDhgG5idRFBy+fX6+pCkmzKfT1YhrEqOz9jebNdgUVY3Q/?=
 =?us-ascii?Q?OA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 896c20af-2f54-456c-7328-08dac8f8222d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 00:02:07.9069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bBR50/YR+cTYBVoVq5lFCnoxRq0dMfgZdi44LSCPxgWjzpZu53UqI+GmF2vUJgRsZoZ2wJkYMxaXRHb/bkZEUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8542
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that there is a generic interface through which phylink can query
PHY drivers whether they support various forms of in-band autoneg, use
that and delete the special case from phylink.c.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v3->v4:
- since we are now in phylink_sfp_config_phy() rather than
  phylink_sfp_config(), drop "if (phy)" check
- s/inband_aneg/an_inband/

 drivers/net/phy/bcm84881.c | 10 ++++++++++
 drivers/net/phy/phylink.c  | 17 ++---------------
 2 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/net/phy/bcm84881.c b/drivers/net/phy/bcm84881.c
index 9717a1626f3f..ab03acee77ea 100644
--- a/drivers/net/phy/bcm84881.c
+++ b/drivers/net/phy/bcm84881.c
@@ -223,6 +223,15 @@ static int bcm84881_read_status(struct phy_device *phydev)
 	return genphy_c45_read_mdix(phydev);
 }
 
+/* The Broadcom BCM84881 in the Methode DM7052 is unable to provide a SGMII
+ * or 802.3z control word, so inband will not work.
+ */
+static int bcm84881_validate_an_inband(struct phy_device *phydev,
+				       phy_interface_t interface)
+{
+	return PHY_AN_INBAND_OFF;
+}
+
 static struct phy_driver bcm84881_drivers[] = {
 	{
 		.phy_id		= 0xae025150,
@@ -234,6 +243,7 @@ static struct phy_driver bcm84881_drivers[] = {
 		.config_aneg	= bcm84881_config_aneg,
 		.aneg_done	= bcm84881_aneg_done,
 		.read_status	= bcm84881_read_status,
+		.validate_an_inband = bcm84881_validate_an_inband,
 	},
 };
 
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 40b7e730fb33..bf2a5ebfc4f4 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2811,15 +2811,6 @@ int phylink_speed_up(struct phylink *pl)
 }
 EXPORT_SYMBOL_GPL(phylink_speed_up);
 
-/* The Broadcom BCM84881 in the Methode DM7052 is unable to provide a SGMII
- * or 802.3z control word, so inband will not work.
- */
-static bool phylink_phy_no_inband(struct phy_device *phy)
-{
-	return phy->is_c45 &&
-		(phy->c45_ids.device_ids[1] & 0xfffffff0) == 0xae025150;
-}
-
 static void phylink_sfp_attach(void *upstream, struct sfp_bus *bus)
 {
 	struct phylink *pl = upstream;
@@ -2941,14 +2932,10 @@ static int phylink_sfp_config_phy(struct phylink *pl, struct phy_device *phy)
 	 */
 	ret = phy_validate_an_inband(phy, iface);
 	if (ret == PHY_AN_INBAND_UNKNOWN) {
-		if (phylink_phy_no_inband(phy))
-			mode = MLO_AN_PHY;
-		else
-			mode = MLO_AN_INBAND;
+		mode = MLO_AN_INBAND;
 
 		phylink_dbg(pl,
-			    "PHY driver does not report in-band autoneg capability, assuming %s\n",
-			    phylink_autoneg_inband(mode) ? "true" : "false");
+			    "PHY driver does not report in-band autoneg capability, assuming true\n");
 	} else if (ret & PHY_AN_INBAND_ON) {
 		mode = MLO_AN_INBAND;
 	} else {
-- 
2.34.1

