Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5858746A209
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 18:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234165AbhLFRIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 12:08:21 -0500
Received: from mail-eopbgr70042.outbound.protection.outlook.com ([40.107.7.42]:53123
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348589AbhLFRCB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 12:02:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E6HroFz/Hy0Q5TquAS+wFQtbXYwh8FX0SkwYYsbzYVrLgzNOfhbDAldoot6kMNS0a7DkqKDx7IzjG3Q9+jc1t0LwctQO9agax97L8/fmWcKK7ZxtRjmzHchxZdE9iwARlaZ2v6hkrJVQoebiig6Q7uPjW9dn6qf6T5ZKiyXPCfNv+ihq9ZK//Wrwo+155NO2bDUQbu8XaBcrRrxgz9B67AIB+VPYKhVg0aOj2kgnyJcbuWfOwmB7HA+RfGggMVk9gW+6A3k6DcyrojMic681NAOySEs2wEdO3qKFAmmAX7hJa19fAG5tKyn0TYy0za8jC+IV4+7/Tvsfu3ZvwCWBbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4JE9lZ0EbVsJUFbEdNt4MjxHX3u9QdoJioeEpMB5PY4=;
 b=FgDRXUDg8YjkMpQGcdjsnoouC0irKWQu4UioQrnWavYIvx7I2PifzPywETtWLN0LAOBJdOtBoeHaw6YFIy+RtOk1NXdBd0jcIpDRYPgFTT/AugKYEJ6QU7aFLgYKcMjmtz4fB8p0GT4Vve4lTLpvS0iSYklpyuLM+iojRs1uQWfRGO0uTYiJ5uH2NlTVvasAERw67kuSgUcKjZQMvDml8nJQum3ehbKP3cGG1eC8h9louhvKDC5oHI2je9+clZVNnDWlBzIMC3j/q6NWvBMeUuYUlof2a81YkkbIx8CGscnAHvUZbrjM0yVLid+z4K5fn8IRtbfiXcGC8YeBfPNAaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4JE9lZ0EbVsJUFbEdNt4MjxHX3u9QdoJioeEpMB5PY4=;
 b=JXD/vD2V07V7kxt8TeX599GfonfERPKkS7LzfkUwvGK5tXJgu9Dtpq7SkF6O4X3ayk/2mR11okpI6RdrEIDRblaJUGKIoXlhawLrOCTtocMpEcd5pRgIubDfnPRQ3laIpbiXntcvTnF2E17tfVXuMGwJVB+GImv9wOF5O5By5Ag=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4912.eurprd04.prod.outlook.com (2603:10a6:803:5b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Mon, 6 Dec
 2021 16:58:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.022; Mon, 6 Dec 2021
 16:58:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH v3 net-next 09/12] net: dsa: export bridging offload helpers to drivers
Date:   Mon,  6 Dec 2021 18:57:55 +0200
Message-Id: <20211206165758.1553882-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211206165758.1553882-1-vladimir.oltean@nxp.com>
References: <20211206165758.1553882-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM4PR0501CA0062.eurprd05.prod.outlook.com
 (2603:10a6:200:68::30) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM4PR0501CA0062.eurprd05.prod.outlook.com (2603:10a6:200:68::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Mon, 6 Dec 2021 16:58:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83afa2b3-fe6c-4d81-d05e-08d9b8d9a172
X-MS-TrafficTypeDiagnostic: VI1PR04MB4912:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB49128DCF77214F153FD812F9E06D9@VI1PR04MB4912.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ts/4ccQWnn3K3m0QZMpY+6YYTR3w8z/NA/36dy5k2XeC2Loj6YXuXqvKi5q/ETKlxjCxXt2cR9m4wuSWUVWD8unTH5330GDUjncQD7VeFFyonL1T5E/D+2vdPEvoXoSoMgPDL9Z83tHdGE3jFI1wZkEwvSJPvW/2U35XplXzMW7svzuNP0fKRx9DJkC5zwNzHkMoKHa2MwmKnIYzFKaB1e9Fxd24CxbTZK7cHz7bwW3zMl3Ke0a+3qzstucatVmqf3VusTec9dDiZ96pWP8VIYZDjHD7dF16NfDkZcynviVRKfu04qV+hcwh7wFvx5z9I/6YcCc3/k1kqKqz7zsMCObZborQw8mfGPRhZUjfymlAlZY0R91Djigp3/+tIliF70cDuz6J9gKPBNyXhqgwjRuFFwxgdoA92eh5QiJcedRA7lD9K4xf8YPTLbbhKSTZBPOKcpnAWgy1vgozv021SBKRWxcdVn/ZjLRnc+LfFFyo3/7HdWOUbqPq6S4cz+LiQ8MpQD5W2gK9gTfcedDlR7TVZU9UhwAyT+sfwV1C24XrwTmr15xK23OPneTPv4CMaS88v4xZQKYp9H4231kMs6NvLO0ZMKcENo7Vn825YxCdlQ63IK/G63xPDfnEhmc+i3/DZ9sjLFxASVbiYpkwAC1O88L6C64XkNx44BtnC9xwvRWKK4oES5pXPpX4EofWTkWf8lXrJCcltnqwiAJ0hQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(66476007)(6506007)(1076003)(54906003)(66946007)(4326008)(6666004)(5660300002)(7416002)(508600001)(316002)(66574015)(52116002)(6512007)(83380400001)(86362001)(2616005)(36756003)(26005)(6916009)(38350700002)(186003)(6486002)(2906002)(38100700002)(44832011)(8676002)(8936002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TU1qK1Q4TW81TDArc0grelhqSGZDcW9kYmZDc3o0VnBJOWRiQ093dDY3VjZo?=
 =?utf-8?B?QVEwYkVTV3oxRmdwbDB5SXkzRmo2UFI4WGtoR3JkYXpETjcvaExCNWFlOGNC?=
 =?utf-8?B?MmZncDZnZ0ZMYkxETTFuYUsvUjN4czgrNnNVa0tFTEJDMmducVBSWlBGS1A3?=
 =?utf-8?B?Wk9IK3ovYXRJVlBDb0hEU0hYanNqZ3JSY2gxa1BIVWFqYWVYSmI5VFRCRmYv?=
 =?utf-8?B?NlRSRUlsamFzdndoaWZVK0M4QzJTT3Bxa3M2U1EwdWtWWmNjUW1DK0lheEYx?=
 =?utf-8?B?L1dPdWlKU3FqdlgxT3U0UkJySXZLNjFMdWpBbnhobTlQZUJ3cUNhdnROcE5u?=
 =?utf-8?B?MkJ2Y3plcmROT2Ftcm13UEpZNXkwSU0wUFI4YUI2Rk5VdnpabWJqSVlyeXJl?=
 =?utf-8?B?cXpRYnljbEsrVlEvMGJVeHRCWnh4dlVUWjkrOVBNUDVhY0VSQ1U0SGNZNzBD?=
 =?utf-8?B?QjE2dlQzUG9MQTNwR1p1eERESTVBSmRmeEYxYU9pMWtmdFBsYlJCenppN2Zo?=
 =?utf-8?B?MlFzRGVYRTZWOUJXMTAxbk1vZ3UxZmI2eVZ1aE9wQmxpZGdwMm02NlFnUDdE?=
 =?utf-8?B?ZVFlbmJkb3VqTW5KMFRaU3JEcFlCK29EcXN0T2xaMlZTWDJkVDFvQ0IrN0JM?=
 =?utf-8?B?TFpnUXpVOUZkRmJQbFFwdXo5MzZWUVRzUTlPQkpnWGtVbnExUWFTRldGdHZI?=
 =?utf-8?B?aGN1bGVDV2hSZjBLc3R5ZW9JVDJxcjNCRXNzMFVsZUY1WWdTeWNzclZJS0pU?=
 =?utf-8?B?QS9idm9EY2FlUnhpV285T3pYM3ordzZpZXVGNUtXdk9iVDFtNk9FS1BMRlFk?=
 =?utf-8?B?OHB1eVlKaXNTTGtLdElBSjFYWnN5WDFNQkRGYVAyTCtZTm5YOVpERlhhMFRB?=
 =?utf-8?B?Nyt6WHh2anhFeXBaaTdJYkVWdE1zcDhyUnpvSkVzQ3YxMndGb0ltd1hYN1FT?=
 =?utf-8?B?aEZNUWhsTzY4b3R5T2pJdW1adk1CcFVXQ3c3S3phQzQ0NGFYdmZmSTFCOUJI?=
 =?utf-8?B?bjZDQ3VlK29nS1UwYjlJY3RRaXBscHhqbHo4WVVtbG53cEpKWWU3a1k5WVha?=
 =?utf-8?B?UGw4bXZsQVdLYjFLaStTa05zcTAwRkUvOFhxL05sM0JzQmx6aml5eVJraDdF?=
 =?utf-8?B?a2dJTndtdU1zOHdhcjd6MEMvdk1sVE9oYmdKMmZOemlJK2JoNEg4REpNdXRi?=
 =?utf-8?B?N3BBQk5DUzczOHhlcFNCQlpRdUNKRUttVStSQk5BY3o1ZmNiSll1UFlCMFRt?=
 =?utf-8?B?UWdWc2JoSDZDMEQ4ZlpWa0xaRDhraStLSTFLNFlsQnlacWswVG1hUTdPSE9l?=
 =?utf-8?B?RC9HeE1tbkV1cWYzTmNZTDFJMGgvTkJSV2dhOTdMVXVkNkFvbDQ2eldlMzAw?=
 =?utf-8?B?dXF5Ni83OU5GRjRYSWV1ZDB4RHRoZERLL2JoVC8wMHZDVVF0aHJDSFJKVDYv?=
 =?utf-8?B?S3ZLMlJ3WER5aGZBcndQeWJsZFVzb0xJRUNWUHZuc21Yb2MrcFhaRzFTeEhh?=
 =?utf-8?B?T3hFY3laRkVSeXVMQVNsZHdVNkpsRGtuNDAwajFSeXc1dDR5M2tsUHFqT1Zt?=
 =?utf-8?B?ZTNXQ1NXWE9yNDRKNkVZOERSZi9wdjJkQnE2R0JTbG5jQTBWcTNNK2FiTmpP?=
 =?utf-8?B?YTl4VmxMclNsTUtHQXNRZlYyQjlWakVMbTk2Yjd6NkJqMERuU2dwcnVmbGtQ?=
 =?utf-8?B?b2s2d3RHeTBPY2ltWWpydWhOdGlnbThGenpXdzRkOExYOC8wQzFaOTdRRmlM?=
 =?utf-8?B?WmJDNDJ2L2xRK0NXMzgyL0xPaW1IQVAyMFo3THZncTRwWXRwZVdpQzVQZUJP?=
 =?utf-8?B?aHErOGJLSmtTSnNqcWNzS3ZGUm5idWg1QTk1ZEgveWlPZy9zTzVGTFc4bjdQ?=
 =?utf-8?B?NCsrZU5tNHJpRjFrTFdSREFYOHY2am1kNGVKdWdoNmtPaWh1MDYxZkp3c0oz?=
 =?utf-8?B?VU1rWHhXOFl5RldPQm1XSncvVDhHNC9aMjNFbE11ZHdlODY4UUFsa1NKRmVG?=
 =?utf-8?B?YTZMOWU4eHV0RUpEQjdmc2NRZ0VuMXdzRC9vZXBOeGo4ak42TnZBODdiYnNI?=
 =?utf-8?B?WnBXdWpURjQ0YnZUZmIzd3NzcER3RmNld3VrcnZGamQ1ODFKaWhPM1VpL1gz?=
 =?utf-8?B?bU9MblJ0ajdjb0daWjU3bVJEWEtwdVhwbmRjbDJsa3dCY0RuUlBPYWJqS1Z6?=
 =?utf-8?Q?x/TpALW1fg+eCpu8kUsIGeQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83afa2b3-fe6c-4d81-d05e-08d9b8d9a172
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 16:58:30.6799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dh5sI1p7au13//hc8aJ6wuV/ViYLS7cFPD3gPM63j/phQXu1f6S8PTcC+4VpsIwsjQ2/EISJ/Z/9L5qG6qNBcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4912
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the static inline helpers from net/dsa/dsa_priv.h to
include/net/dsa.h, so that drivers can call functions such as
dsa_port_offloads_bridge_dev(), which will be necessary after the
transition to a more complex bridge structure.

More functions than are needed right now are being moved, but this is
done for uniformity.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
v2->v3: split from larger change "net: dsa: keep the bridge_dev and
        bridge_num as part of the same structure"

 include/net/dsa.h  | 43 +++++++++++++++++++++++++++++++++++++++++++
 net/dsa/dsa_priv.h | 43 -------------------------------------------
 2 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 18bce0383267..899e13d56fc2 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -620,6 +620,49 @@ static inline bool dsa_port_bridge_same(const struct dsa_port *a,
 	return (!br_a || !br_b) ? false : (br_a == br_b);
 }
 
+static inline bool dsa_port_offloads_bridge_port(struct dsa_port *dp,
+						 const struct net_device *dev)
+{
+	return dsa_port_to_bridge_port(dp) == dev;
+}
+
+static inline bool
+dsa_port_offloads_bridge_dev(struct dsa_port *dp,
+			     const struct net_device *bridge_dev)
+{
+	/* DSA ports connected to a bridge, and event was emitted
+	 * for the bridge.
+	 */
+	return dsa_port_bridge_dev_get(dp) == bridge_dev;
+}
+
+/* Returns true if any port of this tree offloads the given net_device */
+static inline bool dsa_tree_offloads_bridge_port(struct dsa_switch_tree *dst,
+						 const struct net_device *dev)
+{
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dsa_port_offloads_bridge_port(dp, dev))
+			return true;
+
+	return false;
+}
+
+/* Returns true if any port of this tree offloads the given bridge */
+static inline bool
+dsa_tree_offloads_bridge_dev(struct dsa_switch_tree *dst,
+			     const struct net_device *bridge_dev)
+{
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dsa_port_offloads_bridge_dev(dp, bridge_dev))
+			return true;
+
+	return false;
+}
+
 typedef int dsa_fdb_dump_cb_t(const unsigned char *addr, u16 vid,
 			      bool is_static, void *data);
 struct dsa_switch_ops {
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 33fef1be62a3..b4f9df4e38b2 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -266,49 +266,6 @@ void dsa_port_hsr_leave(struct dsa_port *dp, struct net_device *hsr);
 int dsa_port_tag_8021q_vlan_add(struct dsa_port *dp, u16 vid, bool broadcast);
 void dsa_port_tag_8021q_vlan_del(struct dsa_port *dp, u16 vid, bool broadcast);
 
-static inline bool dsa_port_offloads_bridge_port(struct dsa_port *dp,
-						 const struct net_device *dev)
-{
-	return dsa_port_to_bridge_port(dp) == dev;
-}
-
-static inline bool
-dsa_port_offloads_bridge_dev(struct dsa_port *dp,
-			     const struct net_device *bridge_dev)
-{
-	/* DSA ports connected to a bridge, and event was emitted
-	 * for the bridge.
-	 */
-	return dsa_port_bridge_dev_get(dp) == bridge_dev;
-}
-
-/* Returns true if any port of this tree offloads the given net_device */
-static inline bool dsa_tree_offloads_bridge_port(struct dsa_switch_tree *dst,
-						 const struct net_device *dev)
-{
-	struct dsa_port *dp;
-
-	list_for_each_entry(dp, &dst->ports, list)
-		if (dsa_port_offloads_bridge_port(dp, dev))
-			return true;
-
-	return false;
-}
-
-/* Returns true if any port of this tree offloads the given bridge */
-static inline bool
-dsa_tree_offloads_bridge_dev(struct dsa_switch_tree *dst,
-			     const struct net_device *bridge_dev)
-{
-	struct dsa_port *dp;
-
-	list_for_each_entry(dp, &dst->ports, list)
-		if (dsa_port_offloads_bridge_dev(dp, bridge_dev))
-			return true;
-
-	return false;
-}
-
 /* slave.c */
 extern const struct dsa_device_ops notag_netdev_ops;
 extern struct notifier_block dsa_slave_switchdev_notifier;
-- 
2.25.1

