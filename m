Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD0B438AED
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 19:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbhJXRVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 13:21:09 -0400
Received: from mail-am6eur05on2062.outbound.protection.outlook.com ([40.107.22.62]:57952
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231684AbhJXRVF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 13:21:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jEyfnjg6234Ok/NpMKH20zqezRksXS3JUklIG2d8Gn+f3eNZ6fxrT/dutCAC1a7bfRAAI0AOfivrzVCvO9byL4eUrAP/RCnnwargpvCTuSQM+xxjYDHe7Ic7NorDNLt5/r1IAOO/AWW/SmR+k3c4/Qzwi1MRm99KNrZCXcn+Cfd/5AWun2Jaj2YctemYtJFkH3yjt/+l0uLYoGLpVCjkEycXTWWpZv4+d/G1Tu3qbpQo5Dpi+3cv+1ZXDvCA9wehl7la9EzKN196MeyU3dlouu0epGR+LRMu44+lp6esHqiGYCrc3tVBLjLkP30hjhuPJXetdY7q4BgjPQa3tnY6bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h7lBnpFYrtc6djAupnyaNsXnaoEAdK35uBV7rqFrUoM=;
 b=UQvOfBezl/MOv13JNplneLPkbgETElUvIr0jnLrXqAgUwo/5fGr6v1OlnQz2ejxRM6AF9mkLHOYMnUKChsZbS7isqy/e2gV7l1vwIBXt4e6YADFekMvlAtlVtCxl6DpCXxtrHn0lqKwmQsb+vMHR+i6B2W/xpITgiuSDgYYvnYkdvZlTMq6H8nGoMKTwba3Xi9dlnrA83dMlCw86R6PB/K6/AnMXW6i0xqTIp5yVlN5K2yoH+HQq1cN7Igo6BzYZBhpCnxdis1nvE7865LM7MOPiOq6HF0oqoL2z+t/xAjZLA43K0UvfId9nwJdfpLNo0PqBydgv3RLDwCI+SeXY+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h7lBnpFYrtc6djAupnyaNsXnaoEAdK35uBV7rqFrUoM=;
 b=Hpg//tX+cug1nEagxCPBvUZebBsU6GevM7I4Z7msxy3wvXry/mGmoqN0RkiFMJq3b5rTicEu9K5ouZZHuLJwp7ItvhYvHlYhhxgUjWsKyNqm2zb60BfBTDAqAdW5ICrQ5jF0N6lblw7qQJx8ObijCI6pEjgG5MMbdsZwVBN5nkU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3552.eurprd04.prod.outlook.com (2603:10a6:803:9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Sun, 24 Oct
 2021 17:18:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Sun, 24 Oct 2021
 17:18:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        John Crispin <john@phrozen.org>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH v5 net-next 06/10] net: dsa: lantiq_gswip: serialize access to the PCE registers
Date:   Sun, 24 Oct 2021 20:17:53 +0300
Message-Id: <20211024171757.3753288-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211024171757.3753288-1-vladimir.oltean@nxp.com>
References: <20211024171757.3753288-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0123.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:85::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM6P193CA0123.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:85::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Sun, 24 Oct 2021 17:18:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff83b70c-b9f4-4398-077b-08d99712506a
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3552:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB35521849E25F036AB48A57DDE0829@VI1PR0402MB3552.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dfoPnra3poGjytfHHMDM0S+eYkGayeLyB55KA4UcDaBs1frX78Feuhf1HV1xmx33MUyGO0bynWFkXUUZj/0f1QVejs8LJbSdKihlp/scPz2XYETLISxE5s3prnA6kpVcPsFJGTCKVoujbiJwdATsxgGK3srPeaVDlEm8TwG49RmBm88aEWgAGIEqwU58IkOeAv647qCUaUdE1gv50MsJ0Eyi7Mr07kAdSoDsrwgZg0VoOrE8ZgRW6wFcuvql50YF4zn+8P7QGjtKK7HPoE51K5CHP8gH0M9HJmi/OnJtSezf1A2r9WAGuxUnvd5WyNcvVgVrQNSJEmZ/eZrpvf6A43WzJDf8Sns2qjN7zh6q5HjUuCx2MQYKBZLkvsgPL689GTMAjHbvspy6ovbj8yXbx62qKXUe+f4eVfjyiIXz3aW/kfZJEximw+Xd/WxMaG1YMWsRQbZYNiQtuEHOTVqGiKr+aANQh1u5Jg50ugo5LFjnrqULtkw+IFrTSEq2YEmZvn06zkA+zh7xhnHPmN6HL1MVTd6snPwVUv/D356eVzTg/UK81g3MXnT8XuTOjXqEjtNWEzDGy/eMyVS5/zEXhHyvs790lD0VgtkHJZXYGHKZd6KToQeme4W30qWDC/Cp3wKxF5YzDkKka8JiKF6lMrTnCWWtJ0bPFWarTa8LSTAXTmYzBLutf0OUnyiqt6K6UGcBn8u5GLtKmiXDk6xaQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(6666004)(316002)(54906003)(6512007)(38350700002)(38100700002)(26005)(2616005)(6486002)(956004)(36756003)(86362001)(7416002)(8936002)(1076003)(186003)(8676002)(508600001)(44832011)(83380400001)(2906002)(66476007)(6506007)(66556008)(52116002)(5660300002)(4326008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?boKksoYeQnGenOgrxFDEujFugWeLK7jTPbh+aBTcuToXSRkN6oamO6J/sVCJ?=
 =?us-ascii?Q?bSp02XI8LrKN1b+0+kMWZqpy62oZ6HeoLjh5a7iyWW3rJ5i9vMDjH+f6D+8d?=
 =?us-ascii?Q?C9QaSNVSV025VPU8boenuVaIDw+Hcgg6sKo1MmyH5ERhvh12bXrErvyDSO2k?=
 =?us-ascii?Q?fDKs6QsgJ+neyB4aYgR1qsqDzHohaPu4CoUOQ9QdJk42vEKJXfEUXiJX16FC?=
 =?us-ascii?Q?YcFP/GLSqzQ4Dl551aEy2nTo1qjzz5HMEKNRlLXmNxPQm6oHNuQAvaY0Vu/x?=
 =?us-ascii?Q?dYxCcpo9hjT+O3sHC+mFQYMTRmm1TbVGhq3tnodxt/9etYSWrUPxmn8JRFmC?=
 =?us-ascii?Q?kVzTFwPmytx9Z5CgQBZzE3nVVWAOmHKpTnnYDY4mTkvLGM/sMX4SLEZnb86H?=
 =?us-ascii?Q?zVPTLimw5a/Nb9AEhRebjAifYf6l2wgA14q0CC1/GJ4M9bNoGlyhWCliJbE1?=
 =?us-ascii?Q?3ANJRrHBYrQ3AiWJG1HLsHVLp8A7tjjghleHZ0rZPGG8yJxp6pnCV4GRZc1U?=
 =?us-ascii?Q?jyewotQKTMe+xxJQDkC6qScXfjcufDGPRy7SEbgDzHtljAlUKSEfro7BFRgD?=
 =?us-ascii?Q?tGihyXOt+wG8dHCKmjrCEC6ICOtP42y20SSVynokAYmuDqb/7xjONu4YbX+7?=
 =?us-ascii?Q?DhH+VCpTzIOOpHU+Gc32Jmo1Ec3qkfBoLyF2d6Qx1zOng3R1jQPuzi4S1Z5z?=
 =?us-ascii?Q?ivDeWEhHK/tw2X0t/Pz/vNDY5x/jnDDgfT56D5VuW7I6MZDVR4pEITVvHL8Q?=
 =?us-ascii?Q?Cvy8l3FRun69pYkiR8WmvZbGM6AohJ+d76OF2MdzZbFSu86srSMmi4vnAhj4?=
 =?us-ascii?Q?1RzN1tflmwNrss5ho3Y2Dx6Qkl6yERpqLg/JqxxVJ9nb5LkemtFAkqxtHaNO?=
 =?us-ascii?Q?NQNCxq42HB2uR5DZxb63ried5OHQOdeCwp7DwxmTJHswhjJkzkHebmUb6Gd9?=
 =?us-ascii?Q?uxgLJiwpEyPIFQn3HGk3YHpV0FD27eFsGzVve2ObYVCsEGetC5e7h7bD1wFK?=
 =?us-ascii?Q?TM7o/LdcHnlvpNMJdVrtDW+v9fAwJ6vBON4J0IsjodzDkJsIm3pmdq4/2XW6?=
 =?us-ascii?Q?VxTBxE3Hg5sCLEEq72/UvptsTbuGZcRqKfSA/2UQC21Ja2qVKLBuGb9dFXHO?=
 =?us-ascii?Q?KdMGHYxEVJ5HPqomdGuDFRogPD2MU3GuWDzeGmq8R2WC9929jXMBbG/uiAni?=
 =?us-ascii?Q?ABaV8d/3IHX6u0Yi500ckNH7mbxEM43LEmcVpGdwu7DFMSS4GSGbp0t1E/Wo?=
 =?us-ascii?Q?MPR81cdzR4Sa0616iEh94Wz+uVs9bU+unrzcYqLxyL+VzUikjCHmZhoPg7YH?=
 =?us-ascii?Q?+J7n+jOkP1LoumjNWmOxO35iXhtP9R5voOR9iwjkS1RWoHjjsN90hf6W0ITD?=
 =?us-ascii?Q?DCHXOK5LGPdQTT1Nzx7c4AdS4kldIf9cPRD6HtLzSvrsYnX1vw88gwlaJom/?=
 =?us-ascii?Q?Hy6dJF47DBw/jtm39k5PoqEX7E/o4brxz14GRblVm4injHj+6CMo2i4TL7tK?=
 =?us-ascii?Q?frYwdx3H0afuF6HCUp4OI4pJgFBMY2RLv0LzB1Yv2u4nY5u9l1G9XM3YN8kX?=
 =?us-ascii?Q?PNsXfEu2q0IB1jU4x8s7OD6WAoAcIPZdq2n/FVhBJf6DBgja8SrnACIL3TlE?=
 =?us-ascii?Q?QrdfyKtLJ+U9afDUbKC0KWY=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff83b70c-b9f4-4398-077b-08d99712506a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2021 17:18:36.5336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EAFVK9jyIB09cpy8QspMsVPNIjXKcLl9AyAo/IbKRr765etlsp4QL1UPpdQyRaywQYj0wgLqyK0RJdJLtEFTeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3552
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The GSWIP switch accesses various bridging layer tables (VLANs, FDBs,
forwarding rules) indirectly through PCE registers. These hardware
accesses are non-atomic, being comprised of several register reads and
writes.

These accesses are currently serialized by the rtnl_lock, but DSA is
changing its driver API and that lock will no longer be held when
calling ->port_fdb_add() and ->port_fdb_del().

So this driver needs to serialize the access to the PCE registers using
its own locking scheme. This patch adds that.

Note that the driver also uses the gswip_pce_load_microcode() function
to load a static configuration for the packet classification engine into
a table using the same registers. It is currently not protected, but
since that configuration is only done from the dsa_switch_ops :: setup
method, there is no risk of it being concurrent with other operations.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
---
v3->v4: call mutex_init
v4->v5: slightly reword the commit message according to Hauke's indications

 drivers/net/dsa/lantiq_gswip.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index dbd4486a173f..1a96df70d1e8 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -276,6 +276,7 @@ struct gswip_priv {
 	int num_gphy_fw;
 	struct gswip_gphy_fw *gphy_fw;
 	u32 port_vlan_filter;
+	struct mutex pce_table_lock;
 };
 
 struct gswip_pce_table_entry {
@@ -523,10 +524,14 @@ static int gswip_pce_table_entry_read(struct gswip_priv *priv,
 	u16 addr_mode = tbl->key_mode ? GSWIP_PCE_TBL_CTRL_OPMOD_KSRD :
 					GSWIP_PCE_TBL_CTRL_OPMOD_ADRD;
 
+	mutex_lock(&priv->pce_table_lock);
+
 	err = gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
 				     GSWIP_PCE_TBL_CTRL_BAS);
-	if (err)
+	if (err) {
+		mutex_unlock(&priv->pce_table_lock);
 		return err;
+	}
 
 	gswip_switch_w(priv, tbl->index, GSWIP_PCE_TBL_ADDR);
 	gswip_switch_mask(priv, GSWIP_PCE_TBL_CTRL_ADDR_MASK |
@@ -536,8 +541,10 @@ static int gswip_pce_table_entry_read(struct gswip_priv *priv,
 
 	err = gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
 				     GSWIP_PCE_TBL_CTRL_BAS);
-	if (err)
+	if (err) {
+		mutex_unlock(&priv->pce_table_lock);
 		return err;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(tbl->key); i++)
 		tbl->key[i] = gswip_switch_r(priv, GSWIP_PCE_TBL_KEY(i));
@@ -553,6 +560,8 @@ static int gswip_pce_table_entry_read(struct gswip_priv *priv,
 	tbl->valid = !!(crtl & GSWIP_PCE_TBL_CTRL_VLD);
 	tbl->gmap = (crtl & GSWIP_PCE_TBL_CTRL_GMAP_MASK) >> 7;
 
+	mutex_unlock(&priv->pce_table_lock);
+
 	return 0;
 }
 
@@ -565,10 +574,14 @@ static int gswip_pce_table_entry_write(struct gswip_priv *priv,
 	u16 addr_mode = tbl->key_mode ? GSWIP_PCE_TBL_CTRL_OPMOD_KSWR :
 					GSWIP_PCE_TBL_CTRL_OPMOD_ADWR;
 
+	mutex_lock(&priv->pce_table_lock);
+
 	err = gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
 				     GSWIP_PCE_TBL_CTRL_BAS);
-	if (err)
+	if (err) {
+		mutex_unlock(&priv->pce_table_lock);
 		return err;
+	}
 
 	gswip_switch_w(priv, tbl->index, GSWIP_PCE_TBL_ADDR);
 	gswip_switch_mask(priv, GSWIP_PCE_TBL_CTRL_ADDR_MASK |
@@ -600,8 +613,12 @@ static int gswip_pce_table_entry_write(struct gswip_priv *priv,
 	crtl |= GSWIP_PCE_TBL_CTRL_BAS;
 	gswip_switch_w(priv, crtl, GSWIP_PCE_TBL_CTRL);
 
-	return gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
-				      GSWIP_PCE_TBL_CTRL_BAS);
+	err = gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
+				     GSWIP_PCE_TBL_CTRL_BAS);
+
+	mutex_unlock(&priv->pce_table_lock);
+
+	return err;
 }
 
 /* Add the LAN port into a bridge with the CPU port by
@@ -2106,6 +2123,7 @@ static int gswip_probe(struct platform_device *pdev)
 	priv->ds->priv = priv;
 	priv->ds->ops = priv->hw_info->ops;
 	priv->dev = dev;
+	mutex_init(&priv->pce_table_lock);
 	version = gswip_switch_r(priv, GSWIP_VERSION);
 
 	np = dev->of_node;
-- 
2.25.1

