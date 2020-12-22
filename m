Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5D4C2E0B1C
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 14:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbgLVNrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 08:47:01 -0500
Received: from mail-eopbgr70073.outbound.protection.outlook.com ([40.107.7.73]:58438
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727052AbgLVNq7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 08:46:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YxmweSQHoala7YVxvj1xzH9ybtkEDE+ZoDHn3h+cCbV/6lnfTTXB+C8qulF62OBkpojsOS3zNOnOajzAvPafcjNaXshWYQe73qKL1N+0xOjBvaFKFlfigv4s84RtNwLHXpJ4IqKKpFjDcDfWFapK3WhA4XR084KOaffBq9HcFhgozXTjayrCQGDI5XhzqVMgzy+VqKK1tPdhr5FZj5KMkq3e7ae9LqhANaI3dMcTP4WDUNC4/3e6G1TISmd7RzfaYGiLM8XSJ+h6IOj/szMRtJYtDtm268c8cCfldOoXiHb3DKl5mtP4l/cqHxXZBDPTWB7eQzC1flM6nHvtMOsStw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0X1okLnuVs7YfM+awOJVzFakVOQCbd7FiDIb++tENZk=;
 b=Fu3UXcY8BgWe5dHkzcGXmqbkHi/yT/ytzKKgdgIzh2Oo6HHF9edz7nbF5ktW9Nbn36YfNkEvBMXgL3AieAElEfxx7bVa1LQC9F1J53QYGiH8m72/Awz53S2vL74zLoaFS5/EWCGggakaM8grJY5rriN30pE7sqhrCat6I47MP0tKmx0bTtWHkYKEgmGJEkLShz/mJZ/km2Vu6wfwrj5+TnBWNCJ8OZxCpoV7Col53uepgtLVV+NAVucEkbPHqu/czY0+vGw6PQN01FmYxGwf8biMNyBbreXWxCjZZSOJsEqVFjqwBpoPqMbFE2+InF2HSkYhrd2kyMPgbeyi6MzQfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0X1okLnuVs7YfM+awOJVzFakVOQCbd7FiDIb++tENZk=;
 b=qcDqavI0x5NfOHMKP3844lEpxePwWUzLNQS9eqpvdDFBwJ53+FBJBaH46+yI82MGAtnM1BbJal03k6cUxCawy/pk8EzMD23GeyzaD7yicBu8HASn9znynnax5BDdgItRRrLE77g4zEki38S2HxEYTGbi3K6Lm8VoHIYmGxlTnfo=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7408.eurprd04.prod.outlook.com (2603:10a6:800:1b3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Tue, 22 Dec
 2020 13:44:56 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3676.033; Tue, 22 Dec 2020
 13:44:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>, Po Liu <po.liu@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [RFC PATCH v2 net-next 03/15] net: mscc: ocelot: store a namespaced VCAP filter ID
Date:   Tue, 22 Dec 2020 15:44:27 +0200
Message-Id: <20201222134439.2478449-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201222134439.2478449-1-vladimir.oltean@nxp.com>
References: <20201222134439.2478449-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0169.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::23) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0169.eurprd08.prod.outlook.com (2603:10a6:800:d1::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.29 via Frontend Transport; Tue, 22 Dec 2020 13:44:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b77496e8-39f3-46dc-aa7d-08d8a67fc4ad
X-MS-TrafficTypeDiagnostic: VE1PR04MB7408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB74081BBA0947120A4E261CB2E0DF0@VE1PR04MB7408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mev2PhVbpkiY2lp228zJDcCB0ydTr7nLaY5u9q9oQ6IuUOhHbebeN9YWmmUjs7FQLid8Tjql5iUXQ70ic38BXd0TZu2lV5HSm707UEClTRohC/50wv4EhJ7hMUC5nOTyJ9ILNiZFL63/UJJCMDtAdO8ExdwIAP6OH2S3iZsT3TaHMwCbzcRy8wL8T5xJrieoPOzFF1hPYNXdyGUiTBGkek4baffsl+4Kl/AB2JnwW35RpPU4YoNXYvNF3CbeUDRIJ2iP43WKuJuVbtIQh+7gFvFtYyd4K1GWXOKkn1ZdhZ0mkrbJV7ZGa7oB1bQL0Z0fWS8O9E5sd+kIwIW/lNoRTX6gPpNK5WocGrG0HeSFyM1w+VRGJK/owvPsCpJIztHwx/uh28a+DC5AogPFwg3LMg4dqXblp1FMZO50LRK1L0F+0fTlCm7Z70SoHdC6EIFe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(69590400010)(8676002)(956004)(186003)(4326008)(36756003)(2616005)(6512007)(498600001)(16526019)(44832011)(2906002)(83380400001)(8936002)(110136005)(54906003)(26005)(6666004)(66476007)(5660300002)(6486002)(86362001)(6506007)(66946007)(1076003)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?U6nWGOXrO/sp3Q/s0H1husznrq5oUcN162wHZ0/A2ZuyBLBjE5aaTJBHvWy5?=
 =?us-ascii?Q?2kRJlA/T9kDeNVxcQHQvF7fI9ACrvLnFgvYbucknK2AUXqdr2aE7SNYZ53/a?=
 =?us-ascii?Q?SDfyEtc+NVXUSosWZXNVByw/v/ypO4E+4vPbSj9jtBco9zkQBT9pa7NI/IJ2?=
 =?us-ascii?Q?RgjrlDg/a6x8XidVSWyawAiMoVvMSKtK7hMZ32XE/5qnnmKsoawBEJbGYU+h?=
 =?us-ascii?Q?mwbuNte4cV9x/f75P9DCTOBMAaP4hGYuYVeUKacJVCm5TFYrp8hS1/zRgOwx?=
 =?us-ascii?Q?UW2O+B2BOkw86UpXaRPukCQQW16b9kKodh81apQnsK8i8sRPbEPVsRvhbA77?=
 =?us-ascii?Q?iyUU6vPDBBF6cKyDtwbfEf4SPdcgB2b7U9BDs002qT0hf5uP4cgTHpCmeTCY?=
 =?us-ascii?Q?KXaYJnV05j0707E37/PTSJiSWnzADlIQCEYo8Rxfxo9+Ommn93p66Aml8iJa?=
 =?us-ascii?Q?izWfX7dQ1aa11kQpAvj+94gcpnjdktoxNQJiNsiUsYdDe8hD4HEAc7s7CLvS?=
 =?us-ascii?Q?4QWEpPnwgwzkg53308P+dpcusfyFV0Fg1DnIW/pkr2TyHSlCcAxmhXYjsHuw?=
 =?us-ascii?Q?R6Uzc8FSFoqrxCr/B77sHG03K89EiNzfp1J4n17fs5KMWm0JHIrasPbMSZ6P?=
 =?us-ascii?Q?x+NQjL+/Rn+VoP4SnApzgicPCm1ZzPm8oe83iCzM9ZZEbpIq6rYumfdRA3r0?=
 =?us-ascii?Q?JK2I45cj8TzJgkizR2r2cmNkJHQtB+IXQn8FIX22UsrodlV4L5gaS+Dokk8G?=
 =?us-ascii?Q?9QHX8IzeGhuBvzql8vME5gVMGsXYn81nY9oks9meSNZMrC+RZBaWWSLsAqq5?=
 =?us-ascii?Q?r4SfapMfa4Wj3Yogm9LnH99FW6QJOmWk1Mm7h21ppkBcD2BWzlYP6ZhgxE4A?=
 =?us-ascii?Q?gTH7bmPsCAr1qUvngqT4sM8/GItPk7XbEj8ZMjUslSPo2elRfuqZpLRPvfc6?=
 =?us-ascii?Q?QDl9DNdch6dcYha0q3UsuyClODDGnHjyXmRFhlvk5Joktd/T/mxJgEPW3ggY?=
 =?us-ascii?Q?zSLZ?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2020 13:44:56.2159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: b77496e8-39f3-46dc-aa7d-08d8a67fc4ad
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h+ldv5sVrjyGK26DU9tc2UAgmr5aAk4QjT535lsNHydX3TX5oVdZWoWhLwE8PnZMq+BoRFfNnIphPpcGKpKoOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We will be adding some private VCAP filters that should not interfere in
any way with the filters added using tc-flower. So we need to allocate
some IDs which will not be used by tc.

Currently ocelot uses an u32 id derived from the flow cookie, which in
itself is an unsigned long. This is a problem in itself, since on 64 bit
systems, sizeof(unsigned long)=8, so the driver is already truncating
these.

Create a struct ocelot_vcap_id which contains the full unsigned long
cookie from tc, as well as a boolean that is supposed to namespace the
filters added by tc with the ones that aren't.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Patch is new.

 drivers/net/ethernet/mscc/ocelot_flower.c |  7 ++++---
 drivers/net/ethernet/mscc/ocelot_vcap.c   | 16 ++++++++++++----
 drivers/net/ethernet/mscc/ocelot_vcap.h   |  3 ++-
 include/soc/mscc/ocelot_vcap.h            |  7 ++++++-
 4 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 729495a1a77e..c3ac026f6aea 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -622,7 +622,8 @@ static int ocelot_flower_parse(struct ocelot *ocelot, int port, bool ingress,
 	int ret;
 
 	filter->prio = f->common.prio;
-	filter->id = f->cookie;
+	filter->id.cookie = f->cookie;
+	filter->id.tc_offload = true;
 
 	ret = ocelot_flower_parse_action(ocelot, port, ingress, f, filter);
 	if (ret)
@@ -717,7 +718,7 @@ int ocelot_cls_flower_destroy(struct ocelot *ocelot, int port,
 
 	block = &ocelot->block[block_id];
 
-	filter = ocelot_vcap_block_find_filter_by_id(block, f->cookie);
+	filter = ocelot_vcap_block_find_filter_by_id(block, f->cookie, true);
 	if (!filter)
 		return 0;
 
@@ -741,7 +742,7 @@ int ocelot_cls_flower_stats(struct ocelot *ocelot, int port,
 
 	block = &ocelot->block[block_id];
 
-	filter = ocelot_vcap_block_find_filter_by_id(block, f->cookie);
+	filter = ocelot_vcap_block_find_filter_by_id(block, f->cookie, true);
 	if (!filter || filter->type == OCELOT_VCAP_FILTER_DUMMY)
 		return 0;
 
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index d8c778ee6f1b..2f588dfdc9a2 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -959,6 +959,12 @@ static void ocelot_vcap_filter_add_to_block(struct ocelot *ocelot,
 	list_add(&filter->list, pos->prev);
 }
 
+static bool ocelot_vcap_filter_equal(const struct ocelot_vcap_filter *a,
+				     const struct ocelot_vcap_filter *b)
+{
+	return !memcmp(&a->id, &b->id, sizeof(struct ocelot_vcap_id));
+}
+
 static int ocelot_vcap_block_get_filter_index(struct ocelot_vcap_block *block,
 					      struct ocelot_vcap_filter *filter)
 {
@@ -966,7 +972,7 @@ static int ocelot_vcap_block_get_filter_index(struct ocelot_vcap_block *block,
 	int index = 0;
 
 	list_for_each_entry(tmp, &block->rules, list) {
-		if (filter->id == tmp->id)
+		if (ocelot_vcap_filter_equal(filter, tmp))
 			return index;
 		index++;
 	}
@@ -991,12 +997,14 @@ ocelot_vcap_block_find_filter_by_index(struct ocelot_vcap_block *block,
 }
 
 struct ocelot_vcap_filter *
-ocelot_vcap_block_find_filter_by_id(struct ocelot_vcap_block *block, int id)
+ocelot_vcap_block_find_filter_by_id(struct ocelot_vcap_block *block, int cookie,
+				    bool tc_offload)
 {
 	struct ocelot_vcap_filter *filter;
 
 	list_for_each_entry(filter, &block->rules, list)
-		if (filter->id == id)
+		if (filter->id.tc_offload == tc_offload &&
+		    filter->id.cookie == cookie)
 			return filter;
 
 	return NULL;
@@ -1160,7 +1168,7 @@ static void ocelot_vcap_block_remove_filter(struct ocelot *ocelot,
 
 	list_for_each_safe(pos, q, &block->rules) {
 		tmp = list_entry(pos, struct ocelot_vcap_filter, list);
-		if (tmp->id == filter->id) {
+		if (ocelot_vcap_filter_equal(filter, tmp)) {
 			if (tmp->block_id == VCAP_IS2 &&
 			    tmp->action.police_ena)
 				ocelot_vcap_policer_del(ocelot, block,
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.h b/drivers/net/ethernet/mscc/ocelot_vcap.h
index cfc8b976d1de..3b0c7916056e 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.h
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.h
@@ -15,7 +15,8 @@
 int ocelot_vcap_filter_stats_update(struct ocelot *ocelot,
 				    struct ocelot_vcap_filter *rule);
 struct ocelot_vcap_filter *
-ocelot_vcap_block_find_filter_by_id(struct ocelot_vcap_block *block, int id);
+ocelot_vcap_block_find_filter_by_id(struct ocelot_vcap_block *block, int id,
+				    bool tc_offload);
 
 void ocelot_detect_vcap_constants(struct ocelot *ocelot);
 int ocelot_vcap_init(struct ocelot *ocelot);
diff --git a/include/soc/mscc/ocelot_vcap.h b/include/soc/mscc/ocelot_vcap.h
index 7f1b82fba63c..76e01c927e17 100644
--- a/include/soc/mscc/ocelot_vcap.h
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -648,6 +648,11 @@ enum ocelot_vcap_filter_type {
 	OCELOT_VCAP_FILTER_OFFLOAD,
 };
 
+struct ocelot_vcap_id {
+	unsigned long cookie;
+	bool tc_offload;
+};
+
 struct ocelot_vcap_filter {
 	struct list_head list;
 
@@ -657,7 +662,7 @@ struct ocelot_vcap_filter {
 	int lookup;
 	u8 pag;
 	u16 prio;
-	u32 id;
+	struct ocelot_vcap_id id;
 
 	struct ocelot_vcap_action action;
 	struct ocelot_vcap_stats stats;
-- 
2.25.1

