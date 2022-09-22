Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B49D5E59E1
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 06:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbiIVECZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 00:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiIVECT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 00:02:19 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2093.outbound.protection.outlook.com [40.107.94.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4DD8ABF1B;
        Wed, 21 Sep 2022 21:01:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DEom0gi1xsxgWQoHCmAwZclEO51Ni9zU2aOort7prwM1ivXY/Zx9jPPHDuKIzJaxC3l7pjx0zuHJHfRjLBsKB5llP0DqmtoUKzcjdxtxJo6TwH5e/eoPdB1L4y5nloqJIJYOQc8JS7w0C4W54sHoovqWBHbVQ72KDj03XpQJvi5XOqGbpnGa3a2hJ/PZpVVaJ/+OEqsgoN8Op8cfIPVuDIVU6vE9qWlj0Y4XuECXveWOex8AMdUVBwruDeTP6W9OE85C9ZVtI8sElWdRMP4LsxP7QeE2DKQrViWoGaHffHPYCHSXxXpjyW9T4ea7e1oHBu7R2epkz/0QK8jb4cJnDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ONGQW62+yNyoZT3WnR5IAKDU5JdjQ2yDFLrDWUVUYLQ=;
 b=DPd8f519570vtrqHe2phjf8MAv53csPpoz9Sz9kP4b52Wa9ILe7r5m1ZwoRtBW5pTxnpWA2NagPxVoIfPHw9btFczO0DscaVH3sMAaSEsPaSytayYFd0MTrwuNDfpAiWgSPpEHyyqQPpiWvM0917CC3wYtvKTJWUq/dXrdvMFidO2ulWCG3VVe0WdsSaoZz6Q62GQYEpmJl+jeXl2HtpGXmbzUMEgz1kbBjKjGKuea0dSPmZ/saLPdtblKeTdhw+PnHxZmaG33tPsyqjGZ/nNNwjDoL/nTv6NCj7XpeguVYYMBhzOkd4BGuFYVg6uw23nCmRztsau2ihaAqk9x5uOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ONGQW62+yNyoZT3WnR5IAKDU5JdjQ2yDFLrDWUVUYLQ=;
 b=VoUp0Vy/qVR/s0GHCj7c6ts9G8xnPs2S65gr8t0pQKAiXZBtRNAu4WNYZXYvWkFxvo6umOAG57PDYxvDbKVMvnBvPfU542Q4okTB1CU0hvszSuJR+eRjI5c9AImODxoDvY1TmSkpbSaazNQTEPKlqokcAjS/mB4R2DPqW3yATNM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by BN0PR10MB5158.namprd10.prod.outlook.com (2603:10b6:408:120::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Thu, 22 Sep
 2022 04:01:27 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::b594:405e:50f0:468e]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::b594:405e:50f0:468e%5]) with mapi id 15.20.5654.014; Thu, 22 Sep 2022
 04:01:27 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 06/14] net: dsa: felix: add configurable device quirks
Date:   Wed, 21 Sep 2022 21:00:54 -0700
Message-Id: <20220922040102.1554459-7-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922040102.1554459-1-colin.foster@in-advantage.com>
References: <20220922040102.1554459-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::22) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2345:EE_|BN0PR10MB5158:EE_
X-MS-Office365-Filtering-Correlation-Id: 15fd9cb1-acc8-44ea-191c-08da9c4f1f58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JVq4meG3R4XwgL8ZmRW3H7kdhUYyK9p+FLuuM9IBE5SFII2MiIP6VNvUq7qMAN5FgiJI3ySvAhIYuswMHJEK4TgS3bKc91EyZi9utKKw1mDnZVVIwR3fV930vfPxpujymSqkAppf1w0LEZSlJHmJVZKHiHf7sVjcdspx4Qp09m77sWuxavrpA3lGrMcLJAtuuKH4ZTfvjbpzkCfPWX3oDjNuttQPn8/3RmTXtkBnMOMliX2EKyxRbP67tTVRVjIIvOCvWf8+N7DKeeW6lWnBmNIG51FW0+kUYcrOZZUJXA+i+FhD2tw+VbcEhVx8IKzOhcj84LuIL3vGdYG6ORAubxUc0v1HoEock1MKU5qdrEkCTGj8fkYrJaHbFhxP24lsyCpADvUjj63AYH3fgk0qu3Hs5LgLD8U7kaY9uW/O4sREeK8OIaF9azGv6fl8sqwaV/6jG65RptTTan2C+WaOakg4Onx7C61bEvC3W2ANg3Q8u/ya6eyHQX3w+LDaN/+9kRrOakNF8iWDWYHS+O2Mp28yGvKD9RyuO3fvixqjhveSapGXUm3rvkziYhhA7eOZtagxbHS7wv/Ye5hBmIv4W0GI2WTxCuQ4vZ6d+/Tq078ku0zY7n7X0F7evia0nwBh3xCwp+UPjGxSHfrIkZkVWwj3Ek/9C3eg4KFZNAX+qbz/Y5690b4PD0vdUmyvdpNSCLZOLEH0OZXXcTj4ixlccN9UjaTQqod9iiV7CeyeAqXxDBSN8D6RUl+UCm/AAf21
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39840400004)(366004)(136003)(346002)(451199015)(6666004)(36756003)(41300700001)(8936002)(44832011)(26005)(6512007)(7416002)(6506007)(5660300002)(316002)(478600001)(54906003)(6486002)(38100700002)(8676002)(66476007)(66556008)(38350700002)(4326008)(66946007)(83380400001)(52116002)(1076003)(186003)(2616005)(86362001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mgh2e1qTvAujyAiu2Gcbmhm3id5UTeeo3FFCFQ3Xp9gFvEx5SyyUb6t/GV5l?=
 =?us-ascii?Q?j524Au4nAUJyp1Mq+xPaLk1a2vcxsb5GkMzm4awH22cMBGxxOVQ1EQzrqNiv?=
 =?us-ascii?Q?mUdJCnryz8vKveSS8acsOKcRL72cNHMrvueBojIkuj1UXs0ETLOI/zTeyIXy?=
 =?us-ascii?Q?CtBNl77/kEgET0erckmGkerZEtvifu9pQ850IR1PmFT//cduzc/rCHMp4B3Q?=
 =?us-ascii?Q?gauLlWhq0R6/jyBEO4K3hRf95nwyhtwqsoFGXndPzpd2HCtR5tkFdgJddiVP?=
 =?us-ascii?Q?m+9HSAj/asacCcSewVpvUGQT0CHJScBorqMj0EH/kT6mGs+UsA7e/9WQ3+BU?=
 =?us-ascii?Q?PhMT9ODwMU1ybDQ3rbpFEXfdvFCGfhQLvnU9C+hqCsMnGX/R9NcE747PtnIk?=
 =?us-ascii?Q?DBTHkhVleWPLh2R+vmCX4fMk3AahKUkJY9iGq6t8lkDoALG/XZJSxZUfJ5x+?=
 =?us-ascii?Q?EUBy3TQKhSdEMdgi2xt/yPOPizZi/0i2dfflGjGakUvbV+hPqdhVf6iCzVOt?=
 =?us-ascii?Q?HsAUdoQpeMtbG5Llhnv5Vsx3qUmxPE4hjfBTscxUHuqHQqGPaRD9iJ55uiSz?=
 =?us-ascii?Q?TVFV4fKzN1FuqnhYCEtZH5H2YKTwBwGwuUCvgX3A0jfo2gvw6C86rwWmnR0p?=
 =?us-ascii?Q?OFX3USieZgaLoqBVuyaACsXFTbC2PsK2mu553iat873qcB5pYVd1QLpJvjEA?=
 =?us-ascii?Q?1VLxHX/t0zC0hbFKFWhuyz7jwL8eJQI96J3jCB3K79FtJyyKWgb7OrPy00oB?=
 =?us-ascii?Q?nNv7T4hs0L/+6EBk7hJFJpHD5VRmTTMK1pYwDigu8BSUE2gO2shdkgKGMLOr?=
 =?us-ascii?Q?hrZFjHuaKEIHmIGyyjEQap0eIcR9quDMdneidQPQxAwVOAKrjW69pPwZ82Cb?=
 =?us-ascii?Q?DwhAMV1J1x9oW6HPNxJF98VGC11CLXngtOELMz9MFlnegjpBwtWIBIY36zlN?=
 =?us-ascii?Q?yK03TAbjLEH/M4ADk4dd5raFxAWsAZ8BIFN/lQVcJeuVVa6n1nDcbSXe8Qzc?=
 =?us-ascii?Q?WflXW+cMcphDz65sQPEV5xTgSfsY22h2UT9tdaiWG9RPRXwXXHQRde3eHVgE?=
 =?us-ascii?Q?YCmJJSrwEulBKRZNk2izBWNQYq60imgX48806U1CRxS1UjGmGHaNEVYLUkch?=
 =?us-ascii?Q?sLSUiUkyym37ckal4IceZX+GHD4htnMheZTOYPNFWp6SaNY1qlOIaM1XyTQL?=
 =?us-ascii?Q?J1VgsSrx45flNr4Lz05UoxNBmr/R/lCA6qBmOtSDh5CIQkVTFLBbUOtSFdAY?=
 =?us-ascii?Q?8S76eF4mcJyvtfkRNXUEn/nb8SffSXyFUQhl5iENbXUd5PsvpI2YV8/OauJe?=
 =?us-ascii?Q?bWQ3oGTEBhznATUtOmr/2RKrgObipz4SpZ3vJiB52NzX8BX6cVdl9lSaHSdt?=
 =?us-ascii?Q?WC2mPDun6/QujqEeGv5VR6MzsuKMeSYTdyecnwXMgG7ZBZii/t3h0DByBKCV?=
 =?us-ascii?Q?jrBD3t730B6zLBEN204XUHqTCetjt6AD9fFw9EByyZpuIQJrJrjjuiScGxWV?=
 =?us-ascii?Q?x7ujKp5Ku8s7Q5Zmj6BArxIbSmwvtwgua5h3GETNMRQ6UCU9JJW9bTavHlTI?=
 =?us-ascii?Q?vhCFFU66HO2czjR0sVav9IYQjKG68jFg3MaMptSOtI8EVLrb2Hl80/nAJGcx?=
 =?us-ascii?Q?tQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15fd9cb1-acc8-44ea-191c-08da9c4f1f58
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 04:01:27.2781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iN9x2nxNAcEuMdbdXc6RO1juCg4OsgDkiksJqXIRyPsE5aypIVi8piioINZB6TJ36tv3hV1g7S8JCasXeQpNAFGt4x7qLay0TaAz3WG76dk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5158
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The define FELIX_MAC_QUIRKS was used directly in the felix.c shared driver.
Other devices (VSC7512 for example) don't require the same quirks, so they
need to be configured on a per-device basis.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---

v2
    * No changes

v1 from previous RFC:
    * No changes

---
 drivers/net/dsa/ocelot/felix.c           | 7 +++++--
 drivers/net/dsa/ocelot/felix.h           | 1 +
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 1 +
 drivers/net/dsa/ocelot/seville_vsc9953.c | 1 +
 4 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index d2a9d292160c..07c2f1b6913d 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1082,9 +1082,12 @@ static void felix_phylink_mac_link_down(struct dsa_switch *ds, int port,
 					phy_interface_t interface)
 {
 	struct ocelot *ocelot = ds->priv;
+	struct felix *felix;
+
+	felix = ocelot_to_felix(ocelot);
 
 	ocelot_phylink_mac_link_down(ocelot, port, link_an_mode, interface,
-				     FELIX_MAC_QUIRKS);
+				     felix->info->quirks);
 }
 
 static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
@@ -1099,7 +1102,7 @@ static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
 
 	ocelot_phylink_mac_link_up(ocelot, port, phydev, link_an_mode,
 				   interface, speed, duplex, tx_pause, rx_pause,
-				   FELIX_MAC_QUIRKS);
+				   felix->info->quirks);
 
 	if (felix->info->port_sched_speed_set)
 		felix->info->port_sched_speed_set(ocelot, port, speed);
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index e4fd5eef57a0..f94a445c2542 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -33,6 +33,7 @@ struct felix_info {
 	u16				vcap_pol_base2;
 	u16				vcap_pol_max2;
 	const struct ptp_clock_info	*ptp_caps;
+	unsigned long			quirks;
 
 	/* Some Ocelot switches are integrated into the SoC without the
 	 * extraction IRQ line connected to the ARM GIC. By enabling this
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 459288d6222c..4adb109c2e77 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -2605,6 +2605,7 @@ static const struct felix_info felix_info_vsc9959 = {
 	.num_mact_rows		= 2048,
 	.num_ports		= VSC9959_NUM_PORTS,
 	.num_tx_queues		= OCELOT_NUM_TC,
+	.quirks			= FELIX_MAC_QUIRKS,
 	.quirk_no_xtr_irq	= true,
 	.ptp_caps		= &vsc9959_ptp_caps,
 	.mdio_bus_alloc		= vsc9959_mdio_bus_alloc,
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 3ce1cd1a8d4a..ba71e5fa5921 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1071,6 +1071,7 @@ static const struct felix_info seville_info_vsc9953 = {
 	.vcap_pol_max		= VSC9953_VCAP_POLICER_MAX,
 	.vcap_pol_base2		= VSC9953_VCAP_POLICER_BASE2,
 	.vcap_pol_max2		= VSC9953_VCAP_POLICER_MAX2,
+	.quirks			= FELIX_MAC_QUIRKS,
 	.num_mact_rows		= 2048,
 	.num_ports		= VSC9953_NUM_PORTS,
 	.num_tx_queues		= OCELOT_NUM_TC,
-- 
2.25.1

