Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A453446A200
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 18:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241838AbhLFRIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 12:08:01 -0500
Received: from mail-eopbgr70045.outbound.protection.outlook.com ([40.107.7.45]:64823
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245032AbhLFRBv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 12:01:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oauN69tTURGkXPRMpSGtEIl64aXl/K07VFr/yGVanRb40M9Rr9jxwlK2dSNkeTiIe0pVdzUlvmaIYWYMiroaHuI0RhqF3HwWWPlf7e0H/2LzNVv80KWdu6f8JsWNg9gSx+J1XCjJxy2CC+PH4nmI2HHYWSyuCUB2SMk7HMmvv+DUk1E5vBfk+YQuFRkfvEX7wHea81u0m0hvWCILYq6tZjEIUjVgVD5DiEf32RtBcn32gtE1rZf9DLMD5bR1SZyOap1dhCF7faakT8tVoWGWPd5y3fYSoNDCapz6N3c+y26dz+lN0h3S8t8vxohSqsTEkj3XlmcuZK6HHnQcu8HNEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XMILxoF8oYpDYCXY6SUGyRi3U4ezIWhCWXkE6p8WmW0=;
 b=MqPvx/wz3duu4dgUlm1V2cGVgT5Wd6M+A9e3K5Z4XfbLbH9tvAFnWOxmQfG5kh6cl/4d4mG9AA0PhB922fFwfctRdHydZUYX5VoWUbg62d8cr5P1IOLGHCGSq8Fnt5uLfmawoDhd9AGiJ6gYZlZW0OPV6kR5CyrIpvI1jaQaICekbh9Jeq7GCFmRt/9yObVM+HP25vHtksExTcrzJvunU6RKhfZ1s+jSafAHNvwnCOYA5jl9rM7Pgi8Yt5Z4djbNnKh3us+RgjqBCma27gE7XdqudAoRr2dTNAePeTIlmUV/6AlH7ShoRghnKDcrUtLnSFEHBXlc8GIoDz/mRpqiEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XMILxoF8oYpDYCXY6SUGyRi3U4ezIWhCWXkE6p8WmW0=;
 b=VHtHWPAlv4D+nH+6UdrYEj1TYtNxcYMtysZQYFmTBFtwujtUL4nPYAYh/l61ByPxJKlFQvie99toMTzgcIYO12gwIuMMQYGV4xj0kftlvxIqmLn2nCOgSzkVDCAtCtUmCRKCuVPJZUSi9Ty6+4eYEGGAfn80Fp1410MaCV/WlbE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4912.eurprd04.prod.outlook.com (2603:10a6:803:5b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Mon, 6 Dec
 2021 16:58:19 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.022; Mon, 6 Dec 2021
 16:58:19 +0000
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
Subject: [PATCH v3 net-next 02/12] net: dsa: assign a bridge number even without TX forwarding offload
Date:   Mon,  6 Dec 2021 18:57:48 +0200
Message-Id: <20211206165758.1553882-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211206165758.1553882-1-vladimir.oltean@nxp.com>
References: <20211206165758.1553882-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM4PR0501CA0062.eurprd05.prod.outlook.com
 (2603:10a6:200:68::30) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM4PR0501CA0062.eurprd05.prod.outlook.com (2603:10a6:200:68::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Mon, 6 Dec 2021 16:58:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d629242-a7e2-4307-08b9-08d9b8d99a72
X-MS-TrafficTypeDiagnostic: VI1PR04MB4912:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB491231A6EECC585BBFB956E5E06D9@VI1PR04MB4912.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TcyGGM1VwW0QZV5XHbJGrNjjYfh29KM2U1YhlvE+yE25ybS2Kz1xMYASs4k+M3SBE7OHWoqMVuuXfPN11pvOkXkNkkkr4e8fB/qVxL+8M++oFctL8WCOmdOU+W+3FPcSHo/h80zGI2jmlAKr3gcEe4Pumj3v4bYiH1QstTPJMzeDd4zNel7rn6H/gutIe6PK8+AjuoOhxOBKnseLEcpYLQOlRzfxpvaIWeyCzXlF/HYhRPxnbgelNIEMC+CKFgYyz+J00KqQxB8ruATBVE9afd6oRgtfRW+b6LhzBxlUkt1cn0hkmipSN7e43F8Q30EYXV7OZgZV0nYuhIAXahJZBPaLDS6jPKQjbL5NJiMZ0KWepXYwBgh1EVJmbPMeJ8mDkTE0o8g5Q5cAv+D6pN3E57xyahHTCHQ9TDQdvUST6KWRj50VkIBElkyrW9ySlZers82su4gyg2xuS89P86GuNdmD1bD9SBY4XOO1XI6ho/72FBkQsqHAFWm8SfcKN88Tp9ZAAaV3yE/xuMQrVLsvwc3ptKAc/TQH/Fw45eIwrQMkaDVjeseVVfnEu4MG61ofIhbpCD2MnRpbHsS/MW7undovub9ueF03KAded+Pqluj6lWKWnCNhWCqiyrHsUylPLuwJdCUqD4kVl8mIQ4GK+TlkLxrBEjTKlGe+Jv7NuurZWhN+141jdRZu24+pXVbvLA6s+syYghR/XWUroR7oIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(66476007)(6506007)(1076003)(54906003)(66946007)(4326008)(6666004)(5660300002)(7416002)(508600001)(316002)(66574015)(52116002)(6512007)(83380400001)(86362001)(2616005)(36756003)(26005)(6916009)(38350700002)(186003)(6486002)(2906002)(38100700002)(44832011)(8676002)(8936002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QnJvSGJ5OHhtNjEyaVhaQytBbFErMTZlSFkzV1l4QjJiZlFwMytXdDdZRWpv?=
 =?utf-8?B?Y3RQR2JmbWMvOCtFdWFGL2Q0Vnk4eXpXa3lVMlA5VDBHdmdxU09KNUdJRTls?=
 =?utf-8?B?RDByUFcwZFA1Y0V2U0tQQk9xRUhaMk1jTnBkVGJPN0lMZUtmcWJFV0k1V1hU?=
 =?utf-8?B?YjJrMDlaSnBRVDh2czV4NTN5Sm5OS0JBVGo1V2c0c2c1NkJFM1BjOVRQREM1?=
 =?utf-8?B?U0YzbmNqZjBCWXh6SWEySCtPVksyeTJFS25yREpyS3A5eEhuNnFuT1czUUtX?=
 =?utf-8?B?U2VIMUlPSEtqd0RGZU1jeVE5TXRtQW5XVHVJV0ZKWGxGckkrMEd4MmdDNGFv?=
 =?utf-8?B?dUNQSTZIRWVuNFZIYVBNMk1vK1U5b1owS1Q3N3hVSHk1NG5oczI4S1hMTlVv?=
 =?utf-8?B?VnFTUUEyK1FaZjhZUjZYWFpOWnQybHZpMFdXK05oZ1dWbWJWTlFHTFljdGkx?=
 =?utf-8?B?dUU4Z2hsUksvbGRabGVZSG0wY21xS1lETmkvaEZMQTg2aVhVRWF2ekNXZ2dU?=
 =?utf-8?B?UkNTelkzOEJ2cjFsdUNDaEJBdFJrOCsySUdNdDNXd1NkalJ0Zk16TWdsT21F?=
 =?utf-8?B?RkVVU0w1c0xabU50djJvNXQ0OE5aUXQrV21tQnJsUExXZ0Qwc3J0cDBWWlFy?=
 =?utf-8?B?QW5hcTY5Q2Y2NW1vVVFpK0J4RkhlSm9ocHdIeDVnME5SS0tGNzU3OVJNWWpy?=
 =?utf-8?B?b05JcEkwTEhxQS9RR2dGeWVNNnBUU3NDTjRCd1RQUUxraFJNNGwxa2x0SUpZ?=
 =?utf-8?B?Nm04dEI5SXpJOUJXOUJTMk9wQUxlM3VrUDFYYlpqN3g1N3RXNEF0cXVFQW8v?=
 =?utf-8?B?MldQbFZDTG5ZbnVpZFRpS0l6Q0lUcytNNGgvZ09KMnRZVzZ4VnZwbnhyMUNJ?=
 =?utf-8?B?elpvdjlYRHlkK0FyRHJMcWZvMU9McHQxRTlyTURlZklhTEhaQ1Z1eEZkaGJq?=
 =?utf-8?B?K0Z3UVdNRWtuQkRSQWVRYlpvL1NqN3lDdXRnQlUzZTIzc2dmRXhsOHZDdzlK?=
 =?utf-8?B?TzJoeUxJd2ZWUzFMM1VjUGlJZzRCNFNCN2lIZ2ZPWSswSkdONnQvTXlEUjhN?=
 =?utf-8?B?VXB0QkNTSStvaVN2YzM3TXhwaTAxdjh1TmIvcUJVRmpzaVpaZzUxWVF5STZs?=
 =?utf-8?B?ZjBQRi81Njk0OE9vTzBia1RBRCszSFVtc0dGQnRLdTA5VDNMNXRDMCtzL2Jp?=
 =?utf-8?B?aG4vV0VnZHErV0RhR0R1TVdxYmtoM084cmZadkhZNU56Y1hvOTMyNncwR0tD?=
 =?utf-8?B?QmdaZ0pFeU43eVYzMjVlVDR0eHdTak50M2tvQThiZ2QxU1YxNVd2a3FzM3Ey?=
 =?utf-8?B?RkU1akljTzdNbG5Uc1pmeGxiVTd6ckk2QnlHMnZ0ZVZyVzFSb29yejJtZUFH?=
 =?utf-8?B?TTJiMVd0V1RMWWtobXJrdHJzajQxb29JTmM4MlFUMWNlays1WTF4WStjWTJo?=
 =?utf-8?B?eTViQy8yUmdlcHNvd0pKVG9EekcvNE1lbjBDYTBiU0JGdnRISEZES252dzRu?=
 =?utf-8?B?ODNiQUJ1RjRnZTFFUXBick1Cc3F4R3J4WlJwNHlBUW8vVXpCaTJ2cDBnSUhH?=
 =?utf-8?B?V1YvNmpRZEQrWFhuZnJtSm1aTzYvNEFlWFpwcUN3RzhudUJZN0dUSlhlanJR?=
 =?utf-8?B?L3BtZ1ZPUFowMEYwTFhFSlFtTHFyNWZyRzdlMHJDb2VpYjdPOEE5Ny90bk1x?=
 =?utf-8?B?emZEZHRqOE54VmpjWkxUWlRjQVZtR0VXUGpiV3F5alFPRURJRFJqc3ZwZUlv?=
 =?utf-8?B?a3lSZU5IcXo3Njdxc0tMeXJxVm56QlBWeDl0ZGl3a2NhcVpBS3Q0QlNrVzNG?=
 =?utf-8?B?OTgzejB0a01FQXBFZ2xZazF6OTU2M0JSR0ZLampLeE15dHhaS01uNmhscTZC?=
 =?utf-8?B?VnFEem42OFVtZzJlZ0lFUHY4dnllZmEvYmNMQTJqVHpDQU80NlluWndkUE5p?=
 =?utf-8?B?TFcxMUhZanlCekoycFRmak0vSW9YbFRnUXluTVlDL09OV2FUeVJoUit5ZGRu?=
 =?utf-8?B?dXMvMDROSjRQUXJpeXhMUHdVbUdGbmU5bmlrdG85UkwwbEMrcVZ5V05WYWpo?=
 =?utf-8?B?dy9hTHhRWG9RMkFkaTF6bW5lZUozV213TTU5NGtEVXVGK1M1aVdteXJtV0pG?=
 =?utf-8?B?d0N5Q0RHaUtwdG1uOGJZb0hUdUIwK3VvcktVNXJYcFBlaDdqakxwamJ6cEtq?=
 =?utf-8?Q?KC1G7VOaJO0Pv27IpJbZoWI=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d629242-a7e2-4307-08b9-08d9b8d99a72
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 16:58:18.9620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SXClEF+U8ch8LOFQZXIsrfn8L3DAOBGUnqvyAeIoHeiRLpfmxFGrQ+pej+hHThxszqCmwoTiZRNNARMCxyWgqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4912
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The service where DSA assigns a unique bridge number for each forwarding
domain is useful even for drivers which do not implement the TX
forwarding offload feature.

For example, drivers might use the dp->bridge_num for FDB isolation.

So rename ds->num_fwd_offloading_bridges to ds->max_num_bridges, and
calculate a unique bridge_num for all drivers that set this value.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
v2->v3: none
v1->v2: update the comment in dsa_bridge_num_get() about bridge_num's
        new role as per Alvin's suggestion

 drivers/net/dsa/mv88e6xxx/chip.c       |  4 +-
 drivers/net/dsa/sja1105/sja1105_main.c |  2 +-
 include/net/dsa.h                      | 10 ++--
 net/dsa/dsa2.c                         |  4 +-
 net/dsa/port.c                         | 81 +++++++++++++++++---------
 5 files changed, 66 insertions(+), 35 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index de3401b2c86c..a818df35b239 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3186,8 +3186,8 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 	 * time.
 	 */
 	if (mv88e6xxx_has_pvt(chip))
-		ds->num_fwd_offloading_bridges = MV88E6XXX_MAX_PVT_SWITCHES -
-						 ds->dst->last_switch - 1;
+		ds->max_num_bridges = MV88E6XXX_MAX_PVT_SWITCHES -
+				      ds->dst->last_switch - 1;
 
 	mv88e6xxx_reg_lock(chip);
 
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index c343effe2e96..355b56cf94d8 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -3139,7 +3139,7 @@ static int sja1105_setup(struct dsa_switch *ds)
 	ds->vlan_filtering_is_global = true;
 	ds->untag_bridge_pvid = true;
 	/* tag_8021q has 3 bits for the VBID, and the value 0 is reserved */
-	ds->num_fwd_offloading_bridges = 7;
+	ds->max_num_bridges = 7;
 
 	/* Advertise the 8 egress queues */
 	ds->num_tx_queues = SJA1105_NUM_TC;
diff --git a/include/net/dsa.h b/include/net/dsa.h
index a23cfbaa09d6..00fbd87ae4ff 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -413,12 +413,12 @@ struct dsa_switch {
 	 */
 	unsigned int		num_lag_ids;
 
-	/* Drivers that support bridge forwarding offload should set this to
-	 * the maximum number of bridges spanning the same switch tree (or all
-	 * trees, in the case of cross-tree bridging support) that can be
-	 * offloaded.
+	/* Drivers that support bridge forwarding offload or FDB isolation
+	 * should set this to the maximum number of bridges spanning the same
+	 * switch tree (or all trees, in the case of cross-tree bridging
+	 * support) that can be offloaded.
 	 */
-	unsigned int		num_fwd_offloading_bridges;
+	unsigned int		max_num_bridges;
 
 	size_t num_ports;
 };
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 9606e56710a5..4901cdc264ee 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -152,7 +152,9 @@ unsigned int dsa_bridge_num_get(const struct net_device *bridge_dev, int max)
 	unsigned int bridge_num = dsa_bridge_num_find(bridge_dev);
 
 	if (!bridge_num) {
-		/* First port that offloads TX forwarding for this bridge */
+		/* First port that requests FDB isolation or TX forwarding
+		 * offload for this bridge
+		 */
 		bridge_num = find_next_zero_bit(&dsa_fwd_offloading_bridges,
 						DSA_MAX_NUM_OFFLOADING_BRIDGES,
 						1);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 9a77bd1373e2..199a56faf460 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -271,19 +271,15 @@ static void dsa_port_switchdev_unsync_attrs(struct dsa_port *dp)
 }
 
 static void dsa_port_bridge_tx_fwd_unoffload(struct dsa_port *dp,
-					     struct net_device *bridge_dev)
+					     struct net_device *bridge_dev,
+					     unsigned int bridge_num)
 {
-	unsigned int bridge_num = dp->bridge_num;
 	struct dsa_switch *ds = dp->ds;
 
 	/* No bridge TX forwarding offload => do nothing */
-	if (!ds->ops->port_bridge_tx_fwd_unoffload || !dp->bridge_num)
+	if (!ds->ops->port_bridge_tx_fwd_unoffload || !bridge_num)
 		return;
 
-	dp->bridge_num = 0;
-
-	dsa_bridge_num_put(bridge_dev, bridge_num);
-
 	/* Notify the chips only once the offload has been deactivated, so
 	 * that they can update their configuration accordingly.
 	 */
@@ -292,31 +288,60 @@ static void dsa_port_bridge_tx_fwd_unoffload(struct dsa_port *dp,
 }
 
 static bool dsa_port_bridge_tx_fwd_offload(struct dsa_port *dp,
-					   struct net_device *bridge_dev)
+					   struct net_device *bridge_dev,
+					   unsigned int bridge_num)
 {
 	struct dsa_switch *ds = dp->ds;
-	unsigned int bridge_num;
 	int err;
 
-	if (!ds->ops->port_bridge_tx_fwd_offload)
-		return false;
-
-	bridge_num = dsa_bridge_num_get(bridge_dev,
-					ds->num_fwd_offloading_bridges);
-	if (!bridge_num)
+	/* FDB isolation is required for TX forwarding offload */
+	if (!ds->ops->port_bridge_tx_fwd_offload || !bridge_num)
 		return false;
 
-	dp->bridge_num = bridge_num;
-
 	/* Notify the driver */
 	err = ds->ops->port_bridge_tx_fwd_offload(ds, dp->index, bridge_dev,
 						  bridge_num);
-	if (err) {
-		dsa_port_bridge_tx_fwd_unoffload(dp, bridge_dev);
-		return false;
+
+	return err ? false : true;
+}
+
+static int dsa_port_bridge_create(struct dsa_port *dp,
+				  struct net_device *br,
+				  struct netlink_ext_ack *extack)
+{
+	struct dsa_switch *ds = dp->ds;
+	unsigned int bridge_num;
+
+	dp->bridge_dev = br;
+
+	if (!ds->max_num_bridges)
+		return 0;
+
+	bridge_num = dsa_bridge_num_get(br, ds->max_num_bridges);
+	if (!bridge_num) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Range of offloadable bridges exceeded");
+		return -EOPNOTSUPP;
 	}
 
-	return true;
+	dp->bridge_num = bridge_num;
+
+	return 0;
+}
+
+static void dsa_port_bridge_destroy(struct dsa_port *dp,
+				    const struct net_device *br)
+{
+	struct dsa_switch *ds = dp->ds;
+
+	dp->bridge_dev = NULL;
+
+	if (ds->max_num_bridges) {
+		int bridge_num = dp->bridge_num;
+
+		dp->bridge_num = 0;
+		dsa_bridge_num_put(br, bridge_num);
+	}
 }
 
 int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
@@ -336,7 +361,9 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 	/* Here the interface is already bridged. Reflect the current
 	 * configuration so that drivers can program their chips accordingly.
 	 */
-	dp->bridge_dev = br;
+	err = dsa_port_bridge_create(dp, br, extack);
+	if (err)
+		return err;
 
 	brport_dev = dsa_port_to_bridge_port(dp);
 
@@ -344,7 +371,8 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 	if (err)
 		goto out_rollback;
 
-	tx_fwd_offload = dsa_port_bridge_tx_fwd_offload(dp, br);
+	tx_fwd_offload = dsa_port_bridge_tx_fwd_offload(dp, br,
+							dp->bridge_num);
 
 	err = switchdev_bridge_port_offload(brport_dev, dev, dp,
 					    &dsa_slave_switchdev_notifier,
@@ -366,7 +394,7 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 out_rollback_unbridge:
 	dsa_broadcast(DSA_NOTIFIER_BRIDGE_LEAVE, &info);
 out_rollback:
-	dp->bridge_dev = NULL;
+	dsa_port_bridge_destroy(dp, br);
 	return err;
 }
 
@@ -393,14 +421,15 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 		.port = dp->index,
 		.br = br,
 	};
+	int bridge_num = dp->bridge_num;
 	int err;
 
 	/* Here the port is already unbridged. Reflect the current configuration
 	 * so that drivers can program their chips accordingly.
 	 */
-	dp->bridge_dev = NULL;
+	dsa_port_bridge_destroy(dp, br);
 
-	dsa_port_bridge_tx_fwd_unoffload(dp, br);
+	dsa_port_bridge_tx_fwd_unoffload(dp, br, bridge_num);
 
 	err = dsa_broadcast(DSA_NOTIFIER_BRIDGE_LEAVE, &info);
 	if (err)
-- 
2.25.1

