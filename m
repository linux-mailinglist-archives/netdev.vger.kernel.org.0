Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27FC346A1FF
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 18:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242090AbhLFRIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 12:08:00 -0500
Received: from mail-eopbgr70045.outbound.protection.outlook.com ([40.107.7.45]:64823
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348535AbhLFRBu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 12:01:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hfK2XlJawDo3i7AUpjMwICWeSSgOsR0/pstbdPAIHVKInPeuQSOHIPOs6kXWpfPnkB8THinLBETJzJJqh0AmjsisBE9oU7O9IsuyzPu5CPPZJvxJM6QCV2ssVxHFe5P4uW+Axr9SX57QkRRLtGNopfY/M9JwJaZo5EGg0ND0GyAXBZEkD1It8EBDaL2XPBxdR9JV8PlWCKMJV0WpucLWZI6lyTNjxPLWOoWRY/trB+Ae8fZftzsaXmMmaXW5hUTVfJ3wowThQ9Fr47FIhSvz/4y6LySyrehYhgs4K7BeabviwIFf1JtrbZjbGcaXrUHDo+FYiVQId2Ggy4EBkk2gwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JkN+yNW07pG9QoJULsXW87c1DhnMfBWo+T2wUHLSdMA=;
 b=bz2nXBRXYJwS3nnFIaC3zmzJbNxCTxdOGqVgKZNFdoUwW5Gyofo2/HiW3MZsF9+sFa1xAtmVS+wjf69MOHcZ080Ny7EQWdZKNbs0aqxiTbEXbHmh1ouJ6yhQzPV2eii6fq/GIxmJ9K9VhQpRsRK5Xv44byhXSFtJuQN/MTjqe3lNQh7+ZFErAf8LrAI/A+ryEhFwHcfmuWlsBYSJvFMxu3NbNxmDJ9UXFOQ7TUqskt7e63eEkd0Vv+bSQ/j3sToHzyUnmmShDqiu3VbYWDVyVP5mRlpibNXUYgTnQK9zGQPVj6TevhpsJiLeljzbvtom2IcVI2PLOVhWs5Wc8LKnPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JkN+yNW07pG9QoJULsXW87c1DhnMfBWo+T2wUHLSdMA=;
 b=LYvj/hP486YlmOlJ06wxrx00blB8//qjJ/3PvYO1j06tby/ADQZB/XXrdo9jG8qzKZ920hH1C7KJRWqdny6K7iWnqGhf4Hzti8UVNR8FhiUdKok+LhIQsXY7+EDATR9DvJYMijc8T/6Uc38FNkOiOs8Gez+uAZiQeO92qePcJo0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4912.eurprd04.prod.outlook.com (2603:10a6:803:5b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Mon, 6 Dec
 2021 16:58:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.022; Mon, 6 Dec 2021
 16:58:17 +0000
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
Subject: [PATCH v3 net-next 01/12] net: dsa: make dp->bridge_num one-based
Date:   Mon,  6 Dec 2021 18:57:47 +0200
Message-Id: <20211206165758.1553882-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211206165758.1553882-1-vladimir.oltean@nxp.com>
References: <20211206165758.1553882-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM4PR0501CA0062.eurprd05.prod.outlook.com
 (2603:10a6:200:68::30) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM4PR0501CA0062.eurprd05.prod.outlook.com (2603:10a6:200:68::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Mon, 6 Dec 2021 16:58:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2acab943-e303-45bc-b65e-08d9b8d99977
X-MS-TrafficTypeDiagnostic: VI1PR04MB4912:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB4912021EE303900406CAD7ADE06D9@VI1PR04MB4912.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VblMH3RaR3gA4djDapnQrp/hRvc6atlgxGLp1NgZsolnGNHgVEjUPt/sOHVtsvivYyWjT6mdjAiZLUOu3fzkrJxIznylLB9w3EFtDCv6b9zdLRuR2BNgwoarmfHV2AMUQXtPtaOAsILYlIzWTGDL4XjkDNnS3DFWr0Yt0bi8K3BZHtRANZD49BwvZ2H7bksUtcKI9y5BHskOYETL6K8yMt8Y1sXDJj3/1q2Mk7mVnIOMyBBNIO1lUe5ykTxp3CVlybmUwLzkt76zIBpln9hImbb0r1CmlWBsKFsIfZIA1DUUGWNyxNcMiRmYHola2bDecDRp8XkyFXLgx+T+1lMLSlVhSEegNAeoITBhn8cnd7Flid6pEw3jGtWtbQIp8TBkfi6HE011NrMuAFO3dNYP4IckuREtzKymQUWbkO0rKD3PeK9C3ugopRGEey2FEFYYa+suNNMS1FENZz6OzabhPeqvKVaXgHzIMvvkcmGYaBu709otjAqS+7IcK+0lUOxg7CqH8hbehdczjD0Mc8Sdd1E1YF70uKOX1nW3XfPjURu9X5jNrBEG+8XBxGA9L8I7UuENtVnSvsyE9GFSALgBZT+2qWwkjeDc6MfXi2Il95nRvOGCuPhALlLpBlAcyi/2R4RNVulMDly8UzGdsBzs7mhv4219yJwtQhfw6fMpCbjwiX3AUBC0KLUyszuN307sSpx9/Jq9ePFiQZPryW/DrQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(66476007)(6506007)(1076003)(54906003)(66946007)(4326008)(6666004)(5660300002)(7416002)(508600001)(316002)(52116002)(6512007)(83380400001)(86362001)(2616005)(36756003)(26005)(6916009)(38350700002)(186003)(6486002)(2906002)(38100700002)(44832011)(8676002)(8936002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eVlHcGVHdmN0eUVwWEVZZTA1emRyRnYrWjR5a3kwLzY4ZGtYNjZydXpQU1d1?=
 =?utf-8?B?SmxibUlMYm1vOWpkbWptbUcvRFRNblhVNU5vcFNXTjNIaVJoaFpJdXh0b1ds?=
 =?utf-8?B?cTg0d3ZIeFpDaFYwTm8rczMxdk1sNHlteHl4OVkrRGhSYkxmeXZ5c2ltbmxa?=
 =?utf-8?B?TkJLelBlOGluanZISFFRQytRbWt6MUx0bG1rQiszK3RGdE1OVGoxWkpFeTVL?=
 =?utf-8?B?YUgzc0I2VnZnVzFXQThlRmI2c2ZjL3JEeU85RDk4UjVvWS9wMVB3L1F0a0Fw?=
 =?utf-8?B?bWgwbkJaV2tkM3hxMGJuT1habitER0l1OE95WE9pTTFqRjlYVUZQNzJ4TDRE?=
 =?utf-8?B?UFpIVnVRS0drRXUzZVdxQW9xemU0VldQMUdIQUpoaUdFdmZUaVQ2YkJ5Qnpp?=
 =?utf-8?B?ZzZzUDE1ZVpsNUxNYmtFbFcydUlNVjM3a1BqRFlYVzZ3Tm9DSFVaVGpBZTAy?=
 =?utf-8?B?dTB6bktweVdyM2NFcEszbUZnZ0xiS0RSWVh0Nk00d0xnU3RUb3dZYWpjcW9F?=
 =?utf-8?B?ZEREUytTTk1hRkZWT0R2Smd3V1lTRHM0dXVKT1RJcUNzb2IvMkNEa2NPajlN?=
 =?utf-8?B?YjFpQ1JvV1M5ck04S0NQOS9Ic2FyMlQzbkhneUJ3SFEraFdxQXhRU1ByVjR5?=
 =?utf-8?B?cVdwUmFCdUZBa3RuUkF3RitwY1JIZFQvMWU4VjVjbWk2TC9ENW1xTldicy90?=
 =?utf-8?B?aHBuOHdDcmxGUDE3bkNmdm43NzJhTHRjdEZMMTUxQ0VCbGRGdzMzUnl4a1hP?=
 =?utf-8?B?MnBFeVBEUHNja3FCWG1OL00xcHM3Y0c3MWs1OUpsVGV0YzFKdzVNcFphYUQ5?=
 =?utf-8?B?Lzc3eWprUFhDTVMzY3pjTU5tOXg2Nit6L1FRMTZIenQ2ZVAzT1ZndUdNbmFL?=
 =?utf-8?B?dmFlWDVXZ1B3MlQ2bWFnVGFqSGE5bVJIcFIxbHBXSjdwQkRYbk41TUxlcTd4?=
 =?utf-8?B?RDJvZlNCRTZvQnZPc0dLRWh4V3dMdXdPVUxBME9DS1FwZ0Q4T2c5aW1HK0Fo?=
 =?utf-8?B?blBSN3VaY2ZUZzllNWVGcEFNREgxVlNtbDRIMXhWTlk3UFZaNTNBYVk5dG9h?=
 =?utf-8?B?ajhhL1ExSmRIQkRRQk92ZkVzYjRnM2p4cDVLWUc0UkxPWFJHTS9uTGZwUXUy?=
 =?utf-8?B?WXErVkpDdjk0SjQrVzRYUEhlazFLVDZ3R2xyM1FTQTJNV1drYmVPNWRDTGRo?=
 =?utf-8?B?bktsV2JFdS8xUG9iOFZmTWVhZWZjZENFdU1RZHpEek96Rmt4YzM5aEVib0Vo?=
 =?utf-8?B?a1R2d1RKNGVPQzRqSmZRc203OUV4UUw5cmdXM3BTb29Hc3pIRm5HM3FxYUxF?=
 =?utf-8?B?dDQ1Z2d5RVBQK3FLRzIwYmhLQ2ttTnVZWVFYa1JKeWVyc0d3WXhaK1dINWhO?=
 =?utf-8?B?REh3NHliU29GQVdiVEZreDVoeXlCU2wvV2lYbFJueTdnL1BpVUdSSzdNNlFX?=
 =?utf-8?B?Q1JKcDRQWGNMMjBza2ljSCtrR1VBYUVkaFllMzBxT1ZucHpEVEZuQzdiNE04?=
 =?utf-8?B?eEwzY3phejVydXo4bWtOWUtVb1BGNFRkQytCcStEQ2l1UDQvT2JFRkN2THp5?=
 =?utf-8?B?Yy9WaUUvOVczRjVXeDFEWUJkMzc2aXE0T1pwNlV6OHZJdFJNMUZhcmRZeEty?=
 =?utf-8?B?a3F1a2F4VVd3d1hoUFdkQUEyaHNUQnF3MmJDajNrV3dYM3F6QTRsTkIzc25J?=
 =?utf-8?B?OEI5UU56c2NjNWFHRzVBUjBxZ0ROeThMYTdpQ282NjBQVVl0SW4zL0NJUjlu?=
 =?utf-8?B?UGRjdjY4WEd6YTVxRDk0QmZad2IrL0dZNUpINzNhWEJFa0JsMnZQMmV2VFdN?=
 =?utf-8?B?SE43Z2NrQlNQdVk2VUgwREp3ZUNwc2VUL0lkVmNocStJd01DVWlQdzFCTmpF?=
 =?utf-8?B?QlVvMmxuek1aaThlMFNGeExZdjRXNXRlUnBnUzBYaUY5bmZzZytGRGNwbVpx?=
 =?utf-8?B?Y1ZFUmRQYmJKVXN5cDN4NW1UZTlDdldFRWcwL3I0NlhveGJBb2E5Uklvaldh?=
 =?utf-8?B?Uk1iSHhGNE1Wa05IanBqclVFbFRSemVXSUdyakFpT3lXd2ExMlUwMHZTUDVa?=
 =?utf-8?B?Z3NQSXJzZTVuc0M0ZkdEamt0dkpkZFNKQjQ4MkFCOTZsMExZNkRMQkNobll3?=
 =?utf-8?B?SVozV3dGVW5tNEVxa0ppdkpVai95ZmF6WFEvUFBIdEhsSHd2OHBqVGUwRUxY?=
 =?utf-8?Q?FXxoqB2J7Pw1i5AzyeeKByE=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2acab943-e303-45bc-b65e-08d9b8d99977
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 16:58:17.3528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TgfcuxTAkaPMwxaqrvxlQSQUg334NgX56NQDRAc01RTgsiziQ2cFAn5N+Tvgmj3S/i2oSnLZQ4qm97bvGwaOJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4912
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
v1->v3: none

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

