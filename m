Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267AD2811EF
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 14:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387822AbgJBMDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 08:03:20 -0400
Received: from mail-eopbgr60074.outbound.protection.outlook.com ([40.107.6.74]:54862
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726017AbgJBMDS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 08:03:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ADXLo+dU18VkSQ5u376arE4I9Uc+unJSQogWotBz2N3Rmz725bQhoDikl6P+yRtOBTJfxuCIj/lVZ2D9T2uGyqP/xLgZwwtK71Z86CpyIqfXnKS027kkAU4rPZMIi9UsBJJk72BT7D7Zg1A9JlTD69bbKRX6SZzlxOf3lu1l9V0RnlZGnov2+7FpWeqH6nrbR0WMkCC5pC2dDpSrdsuMOZ+gRwWykC6yZatnBcL4nAq+W3W+MUCir7ijvhb5WCmarVV8ZnCr6uQqBb50gy679whBKuwogiJAEjJVo+tMrqg6ZMvEaBEKB5r075z6VlxiWBAu7c95VFRdl3fA/ySw+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dM/D80JGQEw/FoRxBtc626jS2ZRD6Z/7x3jXB0nKtdM=;
 b=SGJcq4ne2z1HPA1+lGZuuFnJOZ0ITctuQN2fRG8MZEQ4cVSWdxF2V3BlpmBstj6mIkWfLm6nA9yWdkA62s9h77ZNItPmiqZa8qcdYarWQsQ1muxzZq6S2UqEfMOOy2iQc61JlaX/kAQTBOashONxSA+Ubxpdx2b6wRuZD0NKWfcNtoBO0o7ClCBOaLDDzPRgU15xSjE1pZnoSJVCGdy8QPZRja9JRiiUOTTCVIt3cW3lwe9CTJlafQrA+rZ0mDdk6aZ9/mu7PIEpCktHIUgA00Kf2DjIlPmp2IQU8Ja3UKJQMVhwrkDHpYu/vYoe3FuxV0NXQFDhefe0HkWR56tC/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dM/D80JGQEw/FoRxBtc626jS2ZRD6Z/7x3jXB0nKtdM=;
 b=CN6itHqW3V/uYcTv8JKPtn6iix9hJgNwqr4jsJAki9MdHkgGJmKV/maW6goc5X4GptQBQSSVtdu1IDu5oxG3f+hC3XndcvLDU1H5YzX7P+GTyw4EtUu00/LZJSjoO7qEHkHpQ8g8naZvU+/mUB3YHmgdzogHm6ieeRLyYCAnv30=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3551.eurprd04.prod.outlook.com (2603:10a6:803:a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.21; Fri, 2 Oct
 2020 12:03:12 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.038; Fri, 2 Oct 2020
 12:03:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 8/9] net: mscc: ocelot: offload redirect action to VCAP IS2
Date:   Fri,  2 Oct 2020 15:02:27 +0300
Message-Id: <20201002120228.3451337-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201002120228.3451337-1-vladimir.oltean@nxp.com>
References: <20201002120228.3451337-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: AM3PR07CA0130.eurprd07.prod.outlook.com
 (2603:10a6:207:8::16) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by AM3PR07CA0130.eurprd07.prod.outlook.com (2603:10a6:207:8::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.14 via Frontend Transport; Fri, 2 Oct 2020 12:03:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 01df4c75-649b-4521-3d49-08d866cb22c7
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3551:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3551AFD571F232DABF17D450E0310@VI1PR0402MB3551.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SKFvwaT7Yr2oh7WvOk9TRY4kl13TWmJAhCqZojFvL/tPb/dMXUgiHF2v5FmFl6H55/joAXb2dmTFJ3hGEYDKx1041Cf7OVcUfzFJrkqc/NP0/ZA+ApEdLN7RixsaF9q9tF6idP6YidyFX5sbTKxeeIoJoiu4Jc56TIESEGrbNNO76V89iDUjU/3pRSoq0CHWHLpUTn+pO2V7rw0wBfpHBbha6RfMAug7WCYwVZZn6nUVmvJ0XgE14PCa7jzx9cQojxrEyfsuz+nz+NLpigsd8TbqbPgOU3I4N0SH4BpxmBlJFfv0dQ4DbSoxl/TJ0CBpPMpjw2hCFFMzTMHaLdzYGXxPF3AVciUPAaRcK0cdiUaS6XoNi6F6zKzjSphccu/Flkq9TowqSAHZ/ct/M5wEXhP4loE4ND8ELRExoogpfmanG8l/JZpe/jJpOoRmyHom
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(136003)(376002)(39860400002)(86362001)(186003)(478600001)(4326008)(1076003)(2616005)(16526019)(44832011)(6916009)(8676002)(7416002)(956004)(8936002)(2906002)(5660300002)(316002)(26005)(6506007)(36756003)(52116002)(69590400008)(6512007)(6666004)(66556008)(6486002)(66946007)(66476007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: eokBQtR9A5gBmiWCDR1dlYjcvGjDEwWdAb1abNFDcxO2doUWTK0wK/WZZCo487qmqWEOyAeq7UGzGjN62rKlnU7l2ZRIVu0bI7d87QUEcGaPD+x3VpnrvZ7F9M2IjF3tB19hvvJ/Hwb1o1kPohHuabjBctOxPy70U41bWDJ8zdWARGo9IJ0t1V7RE2zeRKcGS3Tw/O+xm8SkXaRwhwmvWbsxvkIA8qeSoUpUW7F1zc7boNa6jfBN1TebYn+OtAhpgpXcOVtyZ8BHv81SNajVeX82uCOgj6cxrZ6TVm0SzYZNs7pgqGofDUFHEvKEyyXXbrsksePqZDr4tLCJCprU3XZ1lQAXGy7Z4BojvM6Zu88/jp3RdKgST1C5d6pvWv71kY+AaN0tCTjmkBSQu6KUfO396eIEyuy+t27qeGJ61/cplYkVoQNNYem3P+NtvPBmcl33BIsvpUbUKe4O+t2iK3mDkcLPZlEG4TU5Z7DhkCVW44sTqDtG8RPi2A84VlmD8ZlEeCI462TTQtnN/OpnwKJ602fC/B9GQ5MbnzdZN8gSMDU+VYA2NAHrMN67r61+VlFNn2srRkOGW2qWJS/oHof03P3qbFZV4nZEW9sk57FnGUmaNuPU8SACPczmDqScqX8edcQOapyniJ+76zH6bQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01df4c75-649b-4521-3d49-08d866cb22c7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 12:03:12.2850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nbiDkWvi1dEwWqQ4hnY+KrwTMGsJPPIMqOcBx5MFOgFAcg1zfni+SIi71biet9D6cHMRbvtK4y1DvkcdUvbfrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3551
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Via the OCELOT_MASK_MODE_REDIRECT flag put in the IS2 action vector, it
is possible to replace previous forwarding decisions with the port mask
installed in this rule.

I have studied Table 54 "MASK_MODE and PORT_MASK Combinations" from the
VSC7514 documentation and it appears to behave sanely when this rule is
installed in either lookup 0 or 1. Namely, a redirect in lookup 1 will
overwrite the forwarding decision taken by any entry in lookup 0.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes since RFC:
None.

 drivers/net/ethernet/mscc/ocelot_flower.c | 28 ++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index b26a5f8dc62d..0ea6d4f411cb 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -142,14 +142,15 @@ ocelot_find_vcap_filter_that_points_at(struct ocelot *ocelot, int chain)
 	return NULL;
 }
 
-static int ocelot_flower_parse_action(struct flow_cls_offload *f, bool ingress,
+static int ocelot_flower_parse_action(struct ocelot *ocelot, bool ingress,
+				      struct flow_cls_offload *f,
 				      struct ocelot_vcap_filter *filter)
 {
 	struct netlink_ext_ack *extack = f->common.extack;
 	bool allow_missing_goto_target = false;
 	const struct flow_action_entry *a;
 	enum ocelot_tag_tpid_sel tpid;
-	int i, chain;
+	int i, chain, egress_port;
 	u64 rate;
 
 	if (!flow_action_basic_hw_stats_check(&f->rule->action,
@@ -224,6 +225,27 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f, bool ingress,
 			filter->action.pol.burst = a->police.burst;
 			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
 			break;
+		case FLOW_ACTION_REDIRECT:
+			if (filter->block_id != VCAP_IS2) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Redirect action can only be offloaded to VCAP IS2");
+				return -EOPNOTSUPP;
+			}
+			if (filter->goto_target != -1) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Last action must be GOTO");
+				return -EOPNOTSUPP;
+			}
+			egress_port = ocelot->ops->netdev_to_port(a->dev);
+			if (egress_port < 0) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Destination not an ocelot port");
+				return -EOPNOTSUPP;
+			}
+			filter->action.mask_mode = OCELOT_MASK_MODE_REDIRECT;
+			filter->action.port_mask = BIT(egress_port);
+			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
+			break;
 		case FLOW_ACTION_VLAN_POP:
 			if (filter->block_id != VCAP_IS1) {
 				NL_SET_ERR_MSG_MOD(extack,
@@ -579,7 +601,7 @@ static int ocelot_flower_parse(struct ocelot *ocelot, int port, bool ingress,
 	filter->prio = f->common.prio;
 	filter->id = f->cookie;
 
-	ret = ocelot_flower_parse_action(f, ingress, filter);
+	ret = ocelot_flower_parse_action(ocelot, ingress, f, filter);
 	if (ret)
 		return ret;
 
-- 
2.25.1

