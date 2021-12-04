Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C7746876D
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 21:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347630AbhLDUTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 15:19:06 -0500
Received: from mail-eopbgr70074.outbound.protection.outlook.com ([40.107.7.74]:17024
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233330AbhLDUP1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 15:15:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HsG8rmxkAYMGstgaep65dj6DzwugR0ovH0VMVcw88h6b4GUULQBDF4T3cmrr3Fm83MPqsTW9uHNyAUmYtvqxxyuNTS5XOfUiTGWOb39R+f0obg/Lzc9GG+dChZdjwxG1vbQBcY/KwPHV/D+4wQMdgIU7OQccGH9JkZV/it4E8qiAIZA4/MNdCjN9KW+ScFc34vr5QxQX9b/x7MlOcPPqiXHSoJgafVyLhkaJuxTMDfwlGAUUbvYnu8CPbaVV++2MHaamkTDfYNNNqiDzZRlTRFFQfQMMEdhHdSewXCoDToA99ZH6YCpZqPhJWuhF3sZDiku4YGqWPu552l+t/eD9ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1kNQLnHuU7jhA/d9iiZJedTqlQnfcTEXwPNn5hO9Eo4=;
 b=W5nxw85UdkIjumUZxJEo6C7sqMYAERlc/KvuoevgJHoaBlojsbP5nZIjc9PE/pjjgLcrPtf5NI0aJNku4nxdHG7apaLrSLgbff/XT1OBB3y2CCJsyL4nVcoHMDPgo3Nz4N8+hw1YMdU+HzBg3ODtufGuoyV9wWK7dvoErMQAi/84r1B1mTl/NhQy1zT5/e+d0ETKDO9g09b9FGttSEX3b5UQQhwf1rZTU0YiN4AUWflt0WMtBiWQYoZxDE3dcJFVQUKJbtJQ1DHoRaIm79Jfpx7/f0NcTvBsGPe/IqlCyKNtwj69cNhxWLDQl8s1k37qlg1HhvG0FUpQmbD8l5vC5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1kNQLnHuU7jhA/d9iiZJedTqlQnfcTEXwPNn5hO9Eo4=;
 b=ksqx6twKcslPvgQ9wsbSqxMIPlkq7WAALSL8z2jpoCLKZ3CXW1gxOfUhVC7zpHCjIGcgAdWEFnkQIObfS/vy7kMb9qVUBwxH+tgmy+WGMPux1DugqJYUHZyUjZy2xWlpGPCcrQUesyNGc0dBrMP6Per+WCt+gRp5E5jRyx7Ic9M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM0PR0402MB3651.eurprd04.prod.outlook.com (2603:10a6:208:5::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Sat, 4 Dec
 2021 20:11:59 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8d61:83aa:b70c:3208]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8d61:83aa:b70c:3208%6]) with mapi id 15.20.4755.020; Sat, 4 Dec 2021
 20:11:59 +0000
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
Subject: [PATCH v2 net-next 1/7] net: dsa: make dp->bridge_num one-based
Date:   Sat,  4 Dec 2021 22:11:40 +0200
Message-Id: <20211204201146.4088103-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211204201146.4088103-1-vladimir.oltean@nxp.com>
References: <20211204201146.4088103-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS9P194CA0030.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:20b:46d::26) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AS9P194CA0030.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:46d::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Sat, 4 Dec 2021 20:11:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d896e199-f6c9-4b9e-0ea3-08d9b76253f9
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3651:
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3651715AA82324C12B421EEAE06B9@AM0PR0402MB3651.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kB2YCODEActm9gvnNoThm1ovg9nFBnuKnEVl3piEkRLSjwZPwLOnFYJMoy0hyoyB8btGIDB0Ry1O9nAuWek8A2m/vlITGpaBf/boYEOaTG2FlGHMAtUeOgbhzKCLUpYLXbnBgbeIEqToe1IT7Gthc6yR+6ZmO36HImJZRPpEaaf9LOXf6aTZJospPkzPBqMVlF5yvqUsMXNAwOoq63tJSAzr73nUSwnEAzgtJQq+jqVCWUjLWtrVZh+UzjpZWUh+sVEttfxhGPDgmMPQOixGZX3w3uRvPCLUeB7Q6g3agQA2foUaoV7UzecuxnBk6pa8od0ynuZPtGWer0u3FC4Jb64gJSvkePOF+kMQyLX+C/Rg4Kw49JISqA3GMKJHB3t3yQuoT2jwUs470o/XsDSHrvRmwfVvQTQqCS9EEcsEoFrpmxHuynvLJTZ2h/ix4m2odJdooqzRq7B1gTSAKGYg2mWqSBhVRcdHfWZ7uuij4HRNPczaMXBxacE8vXQfbpd2CIhpHsAzLnvQVjqF1OI085VZlWCGqdD+ATVVel+fI0gVm0doIEuULMQjzE3c0bYuTa5+lmj/gOhzbZ63796Lewkk0pNVh0o7ShPgpYc4Lq33dhpq4F+x7Km0EoINAPxtW0R5yJNxSF5zUFTliGDHF+o5Xs9XZKz9ScvtNvgBE0hu05lud4PQzxYOv4OHHg4hsydOUoiQy5U2a4R8brOnNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(8676002)(6506007)(4326008)(6486002)(6666004)(66556008)(8936002)(508600001)(54906003)(2906002)(44832011)(66476007)(316002)(6512007)(86362001)(66946007)(7416002)(52116002)(1076003)(83380400001)(38100700002)(6916009)(2616005)(38350700002)(186003)(956004)(26005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d25YNnZqNFFCbFNBTjh5bEt3S0NCTEIyMC9zTG5LUDgxbE5xRXlQNjRhVGRo?=
 =?utf-8?B?U3FYVnpPU3Z3L2plOUM5eGNqS3EyaWg4Vy9aazhLM0t4Z2xNKzN1SllGRFpJ?=
 =?utf-8?B?S3BjQWdmeUtvNnVzeDhiNktYNURWRTBTV3JzN3NoSXo3bC9JZzA1OFVaNG1o?=
 =?utf-8?B?bDc5NUU5RDhKWXowQng1bG5KbUZOMmRiSTFFblpKQXB5ZXlZQ09Da3J4U0FG?=
 =?utf-8?B?M1lBdFNIbkd6TEdnajFGclFRSHlzRUF2R0JKTTQ0T3lxYis0S2M4U2doWjRQ?=
 =?utf-8?B?cndNSytyNkhkZUJHelh6WGFWR0RFUE0wOVRMeUFra2Y0a3R0RVE4SnozeStJ?=
 =?utf-8?B?dVZBZ2hYbmFqR3B3b0JXbE0vQ0ZpTmlrMVVuSExIaHhqek9vUEY5Y0F0ZFFS?=
 =?utf-8?B?SEZDa3g4Y3J1NGRuU203ak96ZTBld2N2b3JXUk1EVjVtSTFFN3oyWWpvRTU2?=
 =?utf-8?B?YnczS1Q2K2pLWVRVcVk0azhjUllnUTUvanlGQmNxN2R3ZXJOcVNRdnoxMVJD?=
 =?utf-8?B?UkVsaG13SFc5U285bjhocFRrSm43RzFNckpPTHFvSmFueDhlelIwUlduaDM0?=
 =?utf-8?B?ck1zUlJIVEFaS2lTRjJNT3pQZ2tLYmRjanp3ZGRmYXV5bzBLQXJ4Z3pWOC9N?=
 =?utf-8?B?b0xIdFY5bzZLR3EyemlMVndieDhBOXJhVmRzc0RmV0cxRWJNN3djMEp5NXBx?=
 =?utf-8?B?dlVqUWk3Ulc3dnY0cWEvVTNsK2VicDJEZ3Z0ZlFwUFRSdW1WV3ZLSkF2QXhi?=
 =?utf-8?B?V1BBZHFybE8reEFtM2RiR01oNU0zUnI4eFZjT1dGUHd6ZXBTSHNLY2hYOEUz?=
 =?utf-8?B?TkN6bzhpSkhDSCt5QnVFWTZabG5TemtrbE16cTE2MTdzNVA3MXprSU0yN3RW?=
 =?utf-8?B?a0ZmTjI2Z09mWkpLWXR0TlRmV1ZvRUgycmJnSkkwbVNjSUVQZlFjU21iOHln?=
 =?utf-8?B?NERiTVpHemdoNUtKYVhQb2JIQnJJWWRFNkcrZDdTcDRVZU1iUE9vRkZrYkla?=
 =?utf-8?B?Ky9jdGdrc05sTzVIU3NCamJRY3dLaHA1OEFPQkRlS1hDeHhLcHJ3Z1hWTzBy?=
 =?utf-8?B?V1c0cjRuUGpCUDFXaHA2Q2YrVlFVbTBnSS9LaEV6UTdHYnpleGFMdk9iV2F3?=
 =?utf-8?B?TWZmbVBpVjZlZWFKckJXNUV0R01EYVhsZnFWTkEyRktaQ0xKL3gxTE1VUmtY?=
 =?utf-8?B?aFRsYm5aMkp2QkFFQ0hXbzh1K0NtRFE3alRQVlcwL3FMZk0vWGpCTkEvVm8v?=
 =?utf-8?B?cFZFd2kvajZlM0NmUFltcGhNZkdMc2hlYlMySnRNSzdlNUdITmNNcGJNNTZs?=
 =?utf-8?B?VFlCMkpoYmptWkVsb2ZjV1Z2L3Nqa3FKM2lZUVFIQjc5ZGZ6NnBmL2ZiNVFW?=
 =?utf-8?B?SFFHVnlPcVU3V3hGaGpzS1VLQ3pDcC9taDRmTXVycndkODNQanRZOEtxelJR?=
 =?utf-8?B?RjFiRCt0T2dlRVJSeUorYW1mMS8xclNEMXpSRG1TcUtNQm1tREZNU2JBNTdm?=
 =?utf-8?B?ZzNDWVlaYndHR1ArUjFKTDdmQ0V4OVJyZEtJVlh0eWxseHp3WDllV3d5QWlW?=
 =?utf-8?B?WjViWDZ3MURWWU1UenNJNEdYOHVMZkhkekFKN25QcnJ1SXgrSGJndmIvT0Z3?=
 =?utf-8?B?SktZMGloMWt1QTk1MmFVaStKZXBxeGlPNWRTcnlSQnNndlpGTW1FS1dkK2tZ?=
 =?utf-8?B?YmRTcldxeHAzaGxoZmViZTNYMUpKK3NwVmNRbjRDS1g0ZkdOejJtVkUzVHFB?=
 =?utf-8?B?Z1lRZzVjRVdnT1BBMXBOUmRBUGt5NmNPbUVrVm5IcjhOa0JQZU1MQzl1WHRi?=
 =?utf-8?B?aHhXTnZtekU1K254MXVRbml1dUF1QkVISjY3VlhBR09Oamd6UjZTS1ROU2hi?=
 =?utf-8?B?RTJmOVV0N0xHZGt2M1JYclRwT3VYamlvZEtJWVRuMkU0RlB1eStaQkFTRDc2?=
 =?utf-8?B?QU94OENReHBPK05vb29RaWZHeHdHQzJKTzdLRG5YZlZ2Z05xdlZ1S3Q3VElD?=
 =?utf-8?B?T2ZrcWw2cHBYK2h6VmdCMGhvVXEva1ByeWowZXY0VThPWHk1alZ2K2xaR3Mx?=
 =?utf-8?B?dlpKV2Y4ZG8yQXlSdWtZc3IxQ1gzaVl5SjZ4RXRCTTZNaUo5ZVhhQktMSlRQ?=
 =?utf-8?B?cHBtWUM1YndUS0lzZm9TeDF3L1p5bHJmZGxCdm55YzlWVnRQOFgxZ0hPRTEr?=
 =?utf-8?Q?tjFyj8Rh7EuHsXhSWOe4w1I=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d896e199-f6c9-4b9e-0ea3-08d9b76253f9
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2021 20:11:59.4604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bgizRLcbifqn50P2ZxLKdf12VAHkHDO/DKNIUS8iqgt2XgefOqIionnvazMko0uqN1DpdUE6U7fki78HscpTSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3651
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have seen too many bugs already due to the fact that we must encode an
invalid dp->bridge_num as a negative value, because the natural tendency
is to check that invalid value using (!dp->bridge_num). Latest example
can be seen in commit 1bec0f05062c ("net: dsa: fix bridge_num not
getting cleared after ports leaving the bridge").

Convert the existing users to assume that dp->bridge_num == 0 is the
encoding for invalid, and valid bridge numbers start from 1.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
v1->v2: none

 drivers/net/dsa/mv88e6xxx/chip.c | 12 ++++++------
 include/linux/dsa/8021q.h        |  6 +++---
 include/net/dsa.h                |  6 +++---
 net/dsa/dsa2.c                   | 24 ++++++++++++------------
 net/dsa/dsa_priv.h               |  5 +++--
 net/dsa/port.c                   | 11 ++++++-----
 net/dsa/tag_8021q.c              | 12 +++++++-----
 net/dsa/tag_dsa.c                |  2 +-
 8 files changed, 41 insertions(+), 37 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index f00cbf5753b9..de3401b2c86c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1250,10 +1250,10 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 	/* dev is a virtual bridge */
 	} else {
 		list_for_each_entry(dp, &dst->ports, list) {
-			if (dp->bridge_num < 0)
+			if (!dp->bridge_num)
 				continue;
 
-			if (dp->bridge_num + 1 + dst->last_switch != dev)
+			if (dp->bridge_num + dst->last_switch != dev)
 				continue;
 
 			br = dp->bridge_dev;
@@ -2527,9 +2527,9 @@ static void mv88e6xxx_crosschip_bridge_leave(struct dsa_switch *ds,
  * physical switches, so start from beyond that range.
  */
 static int mv88e6xxx_map_virtual_bridge_to_pvt(struct dsa_switch *ds,
-					       int bridge_num)
+					       unsigned int bridge_num)
 {
-	u8 dev = bridge_num + ds->dst->last_switch + 1;
+	u8 dev = bridge_num + ds->dst->last_switch;
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
@@ -2542,14 +2542,14 @@ static int mv88e6xxx_map_virtual_bridge_to_pvt(struct dsa_switch *ds,
 
 static int mv88e6xxx_bridge_tx_fwd_offload(struct dsa_switch *ds, int port,
 					   struct net_device *br,
-					   int bridge_num)
+					   unsigned int bridge_num)
 {
 	return mv88e6xxx_map_virtual_bridge_to_pvt(ds, bridge_num);
 }
 
 static void mv88e6xxx_bridge_tx_fwd_unoffload(struct dsa_switch *ds, int port,
 					      struct net_device *br,
-					      int bridge_num)
+					      unsigned int bridge_num)
 {
 	int err;
 
diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index 254b165f2b44..0af4371fbebb 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -38,13 +38,13 @@ void dsa_8021q_rcv(struct sk_buff *skb, int *source_port, int *switch_id);
 
 int dsa_tag_8021q_bridge_tx_fwd_offload(struct dsa_switch *ds, int port,
 					struct net_device *br,
-					int bridge_num);
+					unsigned int bridge_num);
 
 void dsa_tag_8021q_bridge_tx_fwd_unoffload(struct dsa_switch *ds, int port,
 					   struct net_device *br,
-					   int bridge_num);
+					   unsigned int bridge_num);
 
-u16 dsa_8021q_bridge_tx_fwd_offload_vid(int bridge_num);
+u16 dsa_8021q_bridge_tx_fwd_offload_vid(unsigned int bridge_num);
 
 u16 dsa_tag_8021q_tx_vid(const struct dsa_port *dp);
 
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 8ca9d50cbbc2..a23cfbaa09d6 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -257,7 +257,7 @@ struct dsa_port {
 	bool			learning;
 	u8			stp_state;
 	struct net_device	*bridge_dev;
-	int			bridge_num;
+	unsigned int		bridge_num;
 	struct devlink_port	devlink_port;
 	bool			devlink_port_setup;
 	struct phylink		*pl;
@@ -754,11 +754,11 @@ struct dsa_switch_ops {
 	/* Called right after .port_bridge_join() */
 	int	(*port_bridge_tx_fwd_offload)(struct dsa_switch *ds, int port,
 					      struct net_device *bridge,
-					      int bridge_num);
+					      unsigned int bridge_num);
 	/* Called right before .port_bridge_leave() */
 	void	(*port_bridge_tx_fwd_unoffload)(struct dsa_switch *ds, int port,
 						struct net_device *bridge,
-						int bridge_num);
+						unsigned int bridge_num);
 	void	(*port_stp_state_set)(struct dsa_switch *ds, int port,
 				      u8 state);
 	void	(*port_fast_age)(struct dsa_switch *ds, int port);
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 826957b6442b..9606e56710a5 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -141,23 +141,23 @@ static int dsa_bridge_num_find(const struct net_device *bridge_dev)
 	 */
 	list_for_each_entry(dst, &dsa_tree_list, list)
 		list_for_each_entry(dp, &dst->ports, list)
-			if (dp->bridge_dev == bridge_dev &&
-			    dp->bridge_num != -1)
+			if (dp->bridge_dev == bridge_dev && dp->bridge_num)
 				return dp->bridge_num;
 
-	return -1;
+	return 0;
 }
 
-int dsa_bridge_num_get(const struct net_device *bridge_dev, int max)
+unsigned int dsa_bridge_num_get(const struct net_device *bridge_dev, int max)
 {
-	int bridge_num = dsa_bridge_num_find(bridge_dev);
+	unsigned int bridge_num = dsa_bridge_num_find(bridge_dev);
 
-	if (bridge_num < 0) {
+	if (!bridge_num) {
 		/* First port that offloads TX forwarding for this bridge */
-		bridge_num = find_first_zero_bit(&dsa_fwd_offloading_bridges,
-						 DSA_MAX_NUM_OFFLOADING_BRIDGES);
+		bridge_num = find_next_zero_bit(&dsa_fwd_offloading_bridges,
+						DSA_MAX_NUM_OFFLOADING_BRIDGES,
+						1);
 		if (bridge_num >= max)
-			return -1;
+			return 0;
 
 		set_bit(bridge_num, &dsa_fwd_offloading_bridges);
 	}
@@ -165,12 +165,13 @@ int dsa_bridge_num_get(const struct net_device *bridge_dev, int max)
 	return bridge_num;
 }
 
-void dsa_bridge_num_put(const struct net_device *bridge_dev, int bridge_num)
+void dsa_bridge_num_put(const struct net_device *bridge_dev,
+			unsigned int bridge_num)
 {
 	/* Check if the bridge is still in use, otherwise it is time
 	 * to clean it up so we can reuse this bridge_num later.
 	 */
-	if (dsa_bridge_num_find(bridge_dev) < 0)
+	if (!dsa_bridge_num_find(bridge_dev))
 		clear_bit(bridge_num, &dsa_fwd_offloading_bridges);
 }
 
@@ -1184,7 +1185,6 @@ static struct dsa_port *dsa_port_touch(struct dsa_switch *ds, int index)
 
 	dp->ds = ds;
 	dp->index = index;
-	dp->bridge_num = -1;
 
 	INIT_LIST_HEAD(&dp->list);
 	list_add_tail(&dp->list, &dst->ports);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 3fb2c37c9b88..70c4a5b36a8b 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -546,8 +546,9 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 			      struct net_device *master,
 			      const struct dsa_device_ops *tag_ops,
 			      const struct dsa_device_ops *old_tag_ops);
-int dsa_bridge_num_get(const struct net_device *bridge_dev, int max);
-void dsa_bridge_num_put(const struct net_device *bridge_dev, int bridge_num);
+unsigned int dsa_bridge_num_get(const struct net_device *bridge_dev, int max);
+void dsa_bridge_num_put(const struct net_device *bridge_dev,
+			unsigned int bridge_num);
 
 /* tag_8021q.c */
 int dsa_tag_8021q_bridge_join(struct dsa_switch *ds,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 6d5ebe61280b..9a77bd1373e2 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -273,14 +273,14 @@ static void dsa_port_switchdev_unsync_attrs(struct dsa_port *dp)
 static void dsa_port_bridge_tx_fwd_unoffload(struct dsa_port *dp,
 					     struct net_device *bridge_dev)
 {
-	int bridge_num = dp->bridge_num;
+	unsigned int bridge_num = dp->bridge_num;
 	struct dsa_switch *ds = dp->ds;
 
 	/* No bridge TX forwarding offload => do nothing */
-	if (!ds->ops->port_bridge_tx_fwd_unoffload || dp->bridge_num == -1)
+	if (!ds->ops->port_bridge_tx_fwd_unoffload || !dp->bridge_num)
 		return;
 
-	dp->bridge_num = -1;
+	dp->bridge_num = 0;
 
 	dsa_bridge_num_put(bridge_dev, bridge_num);
 
@@ -295,14 +295,15 @@ static bool dsa_port_bridge_tx_fwd_offload(struct dsa_port *dp,
 					   struct net_device *bridge_dev)
 {
 	struct dsa_switch *ds = dp->ds;
-	int bridge_num, err;
+	unsigned int bridge_num;
+	int err;
 
 	if (!ds->ops->port_bridge_tx_fwd_offload)
 		return false;
 
 	bridge_num = dsa_bridge_num_get(bridge_dev,
 					ds->num_fwd_offloading_bridges);
-	if (bridge_num < 0)
+	if (!bridge_num)
 		return false;
 
 	dp->bridge_num = bridge_num;
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 72cac2c0af7b..df59f16436a5 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -67,10 +67,12 @@
 #define DSA_8021Q_PORT(x)		(((x) << DSA_8021Q_PORT_SHIFT) & \
 						 DSA_8021Q_PORT_MASK)
 
-u16 dsa_8021q_bridge_tx_fwd_offload_vid(int bridge_num)
+u16 dsa_8021q_bridge_tx_fwd_offload_vid(unsigned int bridge_num)
 {
-	/* The VBID value of 0 is reserved for precise TX */
-	return DSA_8021Q_DIR_TX | DSA_8021Q_VBID(bridge_num + 1);
+	/* The VBID value of 0 is reserved for precise TX, but it is also
+	 * reserved/invalid for the bridge_num, so all is well.
+	 */
+	return DSA_8021Q_DIR_TX | DSA_8021Q_VBID(bridge_num);
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_bridge_tx_fwd_offload_vid);
 
@@ -409,7 +411,7 @@ int dsa_tag_8021q_bridge_leave(struct dsa_switch *ds,
 
 int dsa_tag_8021q_bridge_tx_fwd_offload(struct dsa_switch *ds, int port,
 					struct net_device *br,
-					int bridge_num)
+					unsigned int bridge_num)
 {
 	u16 tx_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge_num);
 
@@ -420,7 +422,7 @@ EXPORT_SYMBOL_GPL(dsa_tag_8021q_bridge_tx_fwd_offload);
 
 void dsa_tag_8021q_bridge_tx_fwd_unoffload(struct dsa_switch *ds, int port,
 					   struct net_device *br,
-					   int bridge_num)
+					   unsigned int bridge_num)
 {
 	u16 tx_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge_num);
 
diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index b3da4b2ea11c..a7d70ae7cc97 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -140,7 +140,7 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 		 * packets on behalf of a virtual switch device with an index
 		 * past the physical switches.
 		 */
-		tag_dev = dst->last_switch + 1 + dp->bridge_num;
+		tag_dev = dst->last_switch + dp->bridge_num;
 		tag_port = 0;
 	} else {
 		cmd = DSA_CMD_FROM_CPU;
-- 
2.25.1

