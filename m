Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C2827C21D
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 12:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbgI2KMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 06:12:08 -0400
Received: from mail-eopbgr70087.outbound.protection.outlook.com ([40.107.7.87]:9902
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727817AbgI2KMA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 06:12:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MZL6hvxWM+3dTVS2KrHWszklsOeWfy0d3/7OOcZHGor1JKtL3fgehKDv0mPdhc2pWZTq3phPtzpmlHgKpWlMvd72/KQtBJuRv/Wlg5nRxcA658/y8t/Yr7tW7ZRW/zeOreafdx7zWkdS0kM0V4fHdDah8GCaBiWDueKApIXikmxfOqZanHan+EKEVl4PV984JuEM62R2tiuR5DKf23ZtkZL7jyUkbe3DbhmWfO2qDtTpQnlCqn0Md0wvuP8aJWwtckVSzOYbx+zh070SO8Nu5XHnnlf0yIeqQH9KduY6LMqmQtevbNL397kyAfgL3Ygl8BtHXK5Ck2CteSoiCei3ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O6auBC1eVKNxlZMiuSHyraGujtluw2LU9lH9bhemMgE=;
 b=ogC9u4EaXN8vi5WEDkIrgtM7Gto2vyZQPFJxeI9PjXSu3S9ylcuxNs8z06jamW36846uXEqfcvEwB6Fl5UTpGWzCXhIcrWjzFSh0GPe+pZVdA77r82YrPUUqJVIpRvKO9WtZXD8+UI/Vf/u6gjzW1VVNDhXwY741THbx+w5akfl+qEe+kf6kHdAT8h/pYUuazk5XkaDUJ5APDHhGg0JxRQJmC+Y4jv0xhXAHa4fGlh4Lyc/DC+rt6vVFwtd/5Sa2wVaPLca0/EC8LWpRe6vQnp8ppLU4lt+0WWfqCEeO5g1gyYExZAfA6PYa5fyG2IObBvwk8f5q5FahvWrvqNKCFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O6auBC1eVKNxlZMiuSHyraGujtluw2LU9lH9bhemMgE=;
 b=C3hatTO3YpICLavLeO5OfCpdlBGLulpfULhS3eC2ayTR4L8R0swCB+T4iPl2LAilcm3vER4oTG45wi+nNB+k7yuWDUKiC7vP5aCrkfBJwJftMBqayLZZvmUoL4hXDv+745lQXNnPRxGl1HQwFYbapCktAbzOAq8ywp2zjoZCEBk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Tue, 29 Sep
 2020 10:10:53 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 10:10:51 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [RFC PATCH v2 net-next 20/21] net: mscc: ocelot: offload redirect action to VCAP IS2
Date:   Tue, 29 Sep 2020 13:10:15 +0300
Message-Id: <20200929101016.3743530-21-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929101016.3743530-1-vladimir.oltean@nxp.com>
References: <20200929101016.3743530-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: VI1PR08CA0112.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::14) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by VI1PR08CA0112.eurprd08.prod.outlook.com (2603:10a6:800:d4::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 10:10:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ed5b308b-6987-4649-acb2-08d8645ff1bb
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5295D667713414EF97AF3A86E0320@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w2Tno2XoDvXyElqzAPY2Jygj4KiuxuqJRybmlDfoIfS750oCYG0X0yvAHPDmzsKNpEQY8zmfQofUXlmUhJMKft5gnaIYnPKDa0BeOiZ+bh3iTLk6xskMgl3fM9GM4TxBqLQleVDoDHRjScfw9xVjw2falBUtGxFRwiQRW2u888YOoPjUnQBCWmOQdMSF+SkjAFkPQh/FCdOMaNKYxpfWWjE4Lq4VeKiNKEm8nU6lkKD/1hQFU/25fhWDXxsJjQ5tYgi52y+Dw/dcQsKQ+HkH+J4t5srv7Rx+pLW/gSR4q1mz+KIWbVaq30UT7pA/ROknYwjbCVMPE7HQPkTwccd8r889CEGeqLNRUVrnvlMoGix6KVxBaRCVPTfk6JnwcZjtd5j/1UD72oT88KfelHyXdDUdQXbWNyTHBnJML1bgJTU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(346002)(39860400002)(396003)(83380400001)(69590400008)(66946007)(4326008)(8936002)(86362001)(36756003)(1076003)(5660300002)(316002)(6666004)(7416002)(52116002)(2616005)(44832011)(956004)(66556008)(8676002)(6486002)(66476007)(6506007)(478600001)(16526019)(6916009)(186003)(26005)(6512007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /yMIAh/BB+wJVKPLD7WmuhFdGmRNtp7523+A66wqaXDow0ywpgD0qOe9L+pgIWib2VK5YI0SknMckokUBDQI7wPTQ8Y4khHgLo9TwBZOUfgWGfks7FrM7F8Pap3KtyMP4Z5FIac/qlYE2JNfKZMkLcO4PwdP2sjZrWRsZH/Mx0Skyrwvi/ZW+zSV7DALlLSe1y1BGRq6+l1q9H49nkPixsbkfeV+VPujCQpNz0ZJeUEHUbYMFHRKdtncxMKGs94JmZvbD+RH2aks/KwgO6QiHrhzdT9imCpq0vICITO/GkTfCbG+gchum+MaOZEeXXDG4tKLz5F8mBoPZk0lJXiVvuJgBFaK60yd7UGPyxuy8ej+X70QZBonwTSLkBqGvrvQX+hMWTchD9I1UOlO0Av3ElVunki2omv7O8F6RxG96TUbxpTMbZD9JhFqzjP9rHY8e8VcVxcmbXQEU3/1fgTP0aYfwWYCF5dhxTLJ59lCldeHy9W8v8VfeoYYeBpOOAqoLyxmu5Ntwk56Con4/3JM+R07RjF1dPSMC2GeOgZIN/iWgR/PT8jMTDxQt9CWT6fa3qhEZDu6F8Rl29ro9zB1aOOPVVQ19IiU87N3dHmyXAkkwvgeDmfTAh5BGvvh1SohnS6AUgQSOsdL+V42UYOmKg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed5b308b-6987-4649-acb2-08d8645ff1bb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 10:10:51.5483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4fF2GS90IqSjvCRkhr8EPWUTWUzHy1Ln56A0734RPGpSGedAbabiuSwKCYNng7T1up0L8RVWyOiNDqgx7XFCZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
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
Changes in v2:
None.

 drivers/net/ethernet/mscc/ocelot_flower.c | 28 ++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index ca7cb8f2496f..37e753eeab29 100644
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
@@ -596,7 +618,7 @@ static int ocelot_flower_parse(struct ocelot *ocelot, int port, bool ingress,
 	filter->prio = f->common.prio;
 	filter->id = f->cookie;
 
-	ret = ocelot_flower_parse_action(f, ingress, filter);
+	ret = ocelot_flower_parse_action(ocelot, ingress, f, filter);
 	if (ret)
 		return ret;
 
-- 
2.25.1

