Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9A7468764
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 21:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235547AbhLDUP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 15:15:29 -0500
Received: from mail-eopbgr70074.outbound.protection.outlook.com ([40.107.7.74]:17024
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234221AbhLDUP2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 15:15:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LvVPpRMyUtB/CjdJjUPvcZHnY/ZwoK6nqzaQL8cuwlyIm+T7/MG/4irAXEQUF+26t1pyJPJrf6eBg3yOgXNTmDU9Co7z2tNoZTQxPq30dpdXRjntV11yCbQUgTqxq7KajhyJmiU6H/Hhh4eAtpwWVDDI5bE2QBKROWDDYzuR4Nu+twgXaOyYQTTw1Rc5U4qyravYFRWvIQtjkMTLdFILxbFyF2te8NHFndwVJpA/yiQJvQFeJ9MO6C5Fu9Ohpcepb2250Kk4tgV9Lu6n59gj/sqPp3z8SdZroJfVZ4dySVC03jpl7caD+QqM+b288p9df2Q9wjuoTN0bSm9ISZqFfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W3hwLPos9Sb8TCpxqCOD/RgJQPLwvNDp2+11MfTuvpo=;
 b=VE5TegHZLHBYogN9UKGiDAkSnVfw4iv7dersxmAQUlLX1bkKkL94TrCWSgxHoJeP1fKwKT81ixQPpFi5I8cgY13iNoay3ySf5HHTau2S9j9rbOx2sUv1jYZIYv2RyDxWuLoj43MQqv8949kOrQd4eB6qfFWJ17MrYK0EgHtx6aTDWPbyAvGNS94HuFL03ahpsBPYG+d1PV3acM+vlE2IhsLcLujaChPeLCt+nBOOpo7oJyOJ+ifwEvITO4NFrc8BtX2EwI+GinOCnK0zYNuYmYDtGVVGvllMNQJIPktMSIzrEqcLpWTMxqaT2K7+I0VSF30d/8WYDmcSS0MO0g3AHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3hwLPos9Sb8TCpxqCOD/RgJQPLwvNDp2+11MfTuvpo=;
 b=sMPDV2jNaQTft2oOMad3ytpkq7+BS8dAiFWjyMAThC27zUHaZfrdLPnSr+ZpT8U4hQ+K6+LEnc+BWY8+61jwQDxnbF4kg7riwgLFz+sPvRzSv0DrqRrYPnkSUM06sTySq6kB7NkvXu+Qsp9pvLwUVPSoWBVlFULzV96yMtSaANs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM0PR0402MB3651.eurprd04.prod.outlook.com (2603:10a6:208:5::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Sat, 4 Dec
 2021 20:12:00 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8d61:83aa:b70c:3208]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8d61:83aa:b70c:3208%6]) with mapi id 15.20.4755.020; Sat, 4 Dec 2021
 20:12:00 +0000
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
Subject: [PATCH v2 net-next 2/7] net: dsa: assign a bridge number even without TX forwarding offload
Date:   Sat,  4 Dec 2021 22:11:41 +0200
Message-Id: <20211204201146.4088103-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211204201146.4088103-1-vladimir.oltean@nxp.com>
References: <20211204201146.4088103-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS9P194CA0030.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:20b:46d::26) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AS9P194CA0030.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:46d::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Sat, 4 Dec 2021 20:11:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da586300-c118-4cf1-e412-08d9b762549f
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3651:
X-Microsoft-Antispam-PRVS: <AM0PR0402MB365138B48DC30E1F95242E85E06B9@AM0PR0402MB3651.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mo/ZiYiQ1EZS4XSqF9tykWBzwxykqRAqp3W4HuZDqKx3z0RXYv7hZcmD72HEgXycoGJ2hBlCvHiITJyKd1aQce0UV6j8+1jgw7+9Lu4E57FE7F6maWqt+q9MsLEOxlDNbfAvbkVsuhu7vgKV+jlrrHG1YvA9o6jftQDmRpPPFJgc/yLL4YJ5vXhdqZvX7ZsutX41DgMPOet0fs/DkBwm99NWvjhxHSHNhD44px71pClRAWlOEgAKV3aU84kk/i2xCThIPvMVAqL4uGJVoXP40MPdaKsXZjYXuW5a7RJxxc/Ovm9beS50O6JAqBw5j+pkBzOJVBB+YgfY9jWIvUlmAFfyV+SHnOeYJ3s+AtewoMm9NW0T/tkhVX3BOdangz/V0ZA/lYKFLc6GjI/6Kt9AjO5JDioua/qRMDACjvZaetCklQNZe1hqSoGmDbpS0KQQRlzlNMfgrAjY7vCGT9XkoPim8bDKslrejXhD75Ki49sfzwL74nJ/ZUjg+LrteAOaQEnqaKmcvcUzXrYhlOn0QXwo54STexXBBIa87QK4tMGt9UfupxowbpBH0oVpcEvfsHl77P1UrzLWrB2PVr7xPBKYRpDg/xwAfa+zDggSIj/jIwImrqP69s0FeEPQieSPwhVHextcjz/7ZmMDhie2IW5fs8MOkn88TLruIKDFUnFgbJq1UqXfMwJeL7lcZHbKymz6ZnM7eAesU99cremczw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(8676002)(6506007)(4326008)(6486002)(6666004)(66556008)(8936002)(508600001)(54906003)(2906002)(44832011)(66476007)(316002)(6512007)(86362001)(66946007)(7416002)(52116002)(1076003)(83380400001)(38100700002)(66574015)(6916009)(2616005)(38350700002)(186003)(956004)(26005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MTl4QzI0RmZwWks0OS9zSlBOZnd1RWZZeFYxRlF0VHg3Tk90bEJ4cXZBZ1Zn?=
 =?utf-8?B?alNhaXdHKzFvVE9sajRmYm5yQlhmc1NSTlJ0Tlg0Ym9GVUdPR0xoQm9zLzdH?=
 =?utf-8?B?dlR0SFR4aEZTbmYxbElmaEw4OG5iczNnTlh6YW9FOEgxYjB6Y2JqSGRvQnVo?=
 =?utf-8?B?L1AxOG9ZTVVSYno3bmFYMG1sQkcvVXo5L2hKWGptRS9ZbG9JaUhYanlsdm1i?=
 =?utf-8?B?eUNpaWpVTHBlQUtDTktoQ3dXbncxQlkrbjZoZVVPaDZWUHFKM1Yyd2dRMWMy?=
 =?utf-8?B?L2dSS0N5M2pHUVoyTGpaTGVxN3VBOU9SaFp5cTRFZWZNY2d3K2NtOEt5OEdV?=
 =?utf-8?B?TmVsTWh6N0c1bDBQOGhxZGtwVXdhbk10YVB4cjd3bTVmNmhFNHdlNWppWlJI?=
 =?utf-8?B?TGJOQjlhSnM0RjFuVHNJc29rSGhLbkY1Sjl0K05nTUlBNVJDWno1b3FJRHcr?=
 =?utf-8?B?VDNSVmdBY2tTL0JLUEN1TXh0VzNaeFRIOG5wZTNkdHBqQ1daL1VzY29zMWFi?=
 =?utf-8?B?THN1dlMreXozYUNzRFNFN0ZaV1ozdm1rT2U0dTE2NGVXNk9QNFJXeDZoNDA5?=
 =?utf-8?B?T1Z4MUVpaVZPZERVYytDRitVSUp2R2xKUjEyK3lwZi9tMkxmdFpnd1FqdGlG?=
 =?utf-8?B?OWxFTTkzRHpNUzdBMVQ5YWZOK05veE5qb3JxUmU4VjZkalkyL2FSODl6RmFk?=
 =?utf-8?B?TWRsTGFsWlAyUWhRVDRJOW9JRTBEV3ZnZWZkcEQrWUFjTUNUTmFrejFXQUhR?=
 =?utf-8?B?MTArQmswVitSOFR5YVg5VlhpZWRnanp6UTFMUnI0WnFqRjRTaEJnSDg3ZFRZ?=
 =?utf-8?B?TmlVdXRxZURhZ09MZURXNHlCTjA2U1N4UVM2K29GaXhCTSttTnducitSa2VR?=
 =?utf-8?B?SlJFVUZKU09peEpPejRNYnkrdFhCSVQzOFdGM3Y5UFlVZHJZZzdkcmNTRjBt?=
 =?utf-8?B?VlNKNTJXU1p4eFBpcURSb05qV3pxdlJrWEoyT0szZllvaWhRcFlBT3lscHlQ?=
 =?utf-8?B?Si9VdGFaKy9XSXlSa05SRmlFMlhyNHA4T0FHZmxOK1krYk9SQ25xck81clF4?=
 =?utf-8?B?bVFUOHZyZGZJMHF1RWVBcURrekhWWnh1UHp5UXlNRm9qcUVQVmRhZ2NQdFVN?=
 =?utf-8?B?TXlIWDBRZ01Pa2l1ZStUYVFoOE1CUzVIamY1ZkdYTWdTREdOcHB3V2doZ3NU?=
 =?utf-8?B?ZUora2puNWFlRFpTWmE2RVlTUWxFeUlvby9XdTFRSU84bmUxU2tOZWp6bnlW?=
 =?utf-8?B?Qm42dDVxL0hYRWpYeThkcmxTVjRENzlINVhUb3lnQ0pZMTY5eXByM0lnaDRM?=
 =?utf-8?B?SVA4elQwWlhlOFhRc3dTellMVFFGSytUV2oxOXNCdE5Zbm92T0hubVVXZHQ4?=
 =?utf-8?B?Vk8rUkgvUU03b2RUVHZDNEhXbjdOdVFORFB0SE85eWpNWHVDcEprdHJzV2kw?=
 =?utf-8?B?YmdML2wrdTRDd2dXRS9taDBhNFNhaDF3UXc1TGd2cG1ScU9KUjNoemdCbno3?=
 =?utf-8?B?VHlzQ2xXMjZRT1VFa1IrYktXR1NMTVFjU0RzcndnSkkyYTVhcE9HOHBVNGx1?=
 =?utf-8?B?am4vWlBIQUdva1dQK0pPV2ROeWx1ak9nSTVUVFB2bHdRVEJUbkJHYUIrWW84?=
 =?utf-8?B?MTBJSVNJZisyblJwV1kwK0g4Z3R1aWI1eUtDb1hBbWtEUW51cisxSm5Uakow?=
 =?utf-8?B?N1BTaUU3RzJEM1F3Tm9IcDBIdnBBZkJGZ1JlcXFRTFdiRUZKL1ltNm1RZVdr?=
 =?utf-8?B?aGxuM0dxa0M4VnNxTE5rWm11Ykp2aVEvbSt4aEc0QUs2VUFZN0dkcTFPREpI?=
 =?utf-8?B?dU5qYmE0UzZSTytCSnFZcG1zOVMvVDJCWjNSR2loZUhXNzdRWlFxMUpyUCsy?=
 =?utf-8?B?T1oveUVTbDBRZDVEdENsVFJDVHVoVERPOFBxSzlRNzNGVnIwVmpUeGNjQ1o2?=
 =?utf-8?B?Tm5zTHl3NmJHYUwxWXU5b0VrZUhMME1SaE5NZ2pPSXRVVldqVjd0QlN5MzNE?=
 =?utf-8?B?a0luR3NPczc5Q3hkb3JHdFlTVitQUWJSb2hCNy81QmdGVlZHNjVyeGRIdnFa?=
 =?utf-8?B?VHNQcWl4SnZmMDhGTnlKT1VReW1xcTY3RW0xbHBTRDRjL1lvd1g3SDRjUlJO?=
 =?utf-8?B?cFRWSnUrQzRjRFlkZ3pFTmVFOVJPM3Bram5PVG1JUWdoS2RIZ3dPTVQ0ckl0?=
 =?utf-8?Q?bKQDkyLobVdA5/Pqtrrd9K8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da586300-c118-4cf1-e412-08d9b762549f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2021 20:12:00.5747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ypfzB87E6nHLVVfTGixb5fUYvGwCbfgPO8tQoSM8E0nyNgxIw/XkSm4lAsnWwcCxdWjdifzvIB1vdayPsFFPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3651
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

