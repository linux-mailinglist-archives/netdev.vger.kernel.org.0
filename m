Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D224127DC08
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 00:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729111AbgI2W3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 18:29:07 -0400
Received: from mail-eopbgr130081.outbound.protection.outlook.com ([40.107.13.81]:6339
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728041AbgI2W3F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 18:29:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KzA5EDCvZ7tWyA8DUdjfZGoRqmi3pC6D+zHoW5MQKmcUemTbtzONZt3ibNFIAIei0kBq+IBxXQugHJNr0FEDqlFcHG7O8Cn9Gu2Rp6Bk3+EythEaZNEkgONiRetE2XVA7DgcySmiZAeyvT+uMBIzzEZoPuexeH1iDrEW624uNpmBpZK6B4NCoErk4uyoL9N9Fo53SWuFO966wKOfFenG5t4U5lC1pQU6lAcNhHpaxJ8p3pCGllw7ylD+gfizBAYp7uyqTd16iVKkrWmphsFYbX0bkEg6Hmc4ff049iGR60vdtGkB2GiryhmiuGXSVBE610K3J2vV7rT2R73HSTcUXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HQYh6a0XJ/LryXyYBk6ogsbppucJcGhl3i5rStd9Bj0=;
 b=efwP/jtD8oh0jpDlVEWjVGnQVkUK4OA1f5PLQT4myHnl1qCTtro+mwOZpI2Ddw1OVTqNBjqXZQI1F7rvSrQK7kfryzy2C0dEXh8WGF6H0WAe8TA2WdnXY+yCcqurkN+KJbESfqIUGwJxgtB/+yvjuH3IZ/DIh9zK+TIUjAWGuG4Ruw0jV78BE/R8nnJNXDrowmcvi5dScRh26sdFof2tRy1Wjuz7sXHVSQYlBDyY3CX5ttoSQeEO4ePpd3mZOvNF0i1CWLmOAgYePFdjFeW0L+RBCBZsPN8kxjOsvFku/YDmboYK9/30bstZeCedQtgBlKWVVi3g1XVRqYqvmPhoEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HQYh6a0XJ/LryXyYBk6ogsbppucJcGhl3i5rStd9Bj0=;
 b=CnV1oFvOFS+zpFkR4jgVXGlFdHovR0zX3Y2OTOZcKhiFTlu9x9oxyfGUIAjQ5rVrEfAXnToo68N3TBN9oHzrrR8kSo9NtJGgnf3eMpLYqHF1AZzu0gfY6Py2P1iWgxRjNx9MlQYQut/3DqMNyZR3ypzX7BvbJWzVBOb2KmJaVhU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2797.eurprd04.prod.outlook.com (2603:10a6:800:ad::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25; Tue, 29 Sep
 2020 22:28:19 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 22:28:19 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 13/13] net: mscc: ocelot: look up the filters in flower_stats() and flower_destroy()
Date:   Wed, 30 Sep 2020 01:27:33 +0300
Message-Id: <20200929222733.770926-14-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929222733.770926-1-vladimir.oltean@nxp.com>
References: <20200929222733.770926-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: AM0PR06CA0126.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::31) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by AM0PR06CA0126.eurprd06.prod.outlook.com (2603:10a6:208:ab::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 22:28:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 80eacfde-fbfe-4df6-4d92-08d864c6f60c
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2797:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2797848A9038D253077BE5FAE0320@VI1PR0402MB2797.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bnRQPaS0V/mmiglUJN1UFYPy6JRQv5VdzeUhN7kxDt5cE9G1rtzJClOjxj26djU45VwHaZBNiCmHCfScd94sAG0vy0cODQoCM3G1b/BfDjzY0m+pxH/7Go78zd9va+hAPNRtydjgYqEljXvDZpQyIb8FCG13ni/hV27Xlln3BGAVGX9HfDQs+6gZOAfdatFRlqMX6PtqWq0WB1dBCvVUBmRriQOmUqUUg3fIEy0vxBfVK8nzV5Alih3RWG5cEM/pHfOMsLqSg0bgvBIkGUMsKTHlLj4nyaLpS5kCt8ZxyamX37jWrVcGnDnI7Ygl3P0WaYqeGpbjQEpwk1LWBpLGy1gxBP3HSJuAg2TY3VsykKya6VqsLdMJ/QmroWa13eNvgQlg+eyLwJzaomPiywZJlf+EK8MchTv4CgGJCgPY9HQCAJxUepaONMXxWZGNneoT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(8936002)(956004)(478600001)(1076003)(66946007)(69590400008)(6916009)(86362001)(66476007)(6486002)(316002)(83380400001)(2616005)(66556008)(6512007)(36756003)(44832011)(16526019)(2906002)(186003)(6666004)(52116002)(26005)(4326008)(6506007)(8676002)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: p/wNaKVZeJnu/rnFh2kFMfiiw6x82hNhjT8cGV/OFAFoT2qQL44fo41imGkMUteQZ39H6DGmH4bWIbEJLgOkzGdHUcL+3yBfQdsVwhMyUiCHsUE/Efi69z9moVyii+ut8KZiZUQZkFnaIhS62hrFG4EQj3VWabmdAcfXO3mZGf2VNSzaIqAJcmCjFHba3Rp2+Fs0C9czwqo5XjHfnZvqL3+j3DXdAQZ2t4/gnQ+tb0fCDiPiwtmw6ZvwuUZFJ8LppxNN4dWltAxjkwXlJ+0YORZ1U67XgAew3Vi/W7DNrsVXFY9cracDqtKW610eDx6BnEKcTTzoDa40R/geya8o8eY/1xZ4uEgmPAOXNMmjRQQ4RZcR1L/PfE2Vt3iJRvvNeBX9v58bHuXJcK2gheXnOhZp+ALU1cSyQ0DQmMuhm8Uq8dkSz1TJTnpMOkqgcR/xJxnq+ofnjAU6ym/EFG4fljjr3BLILc3b9DndAM9FBCnldOfqzyAamdzDA077sj33wgUQhfXryoPrdQkG1+FVSAyZJlWtTlNdTySNjFKlSpIF9JaF8XSB8ilaWN51j1gJ81Z38YVzgQFLk6Kt0kzcIyuHE/1nlJBbmniEwJsTMtD0IQUO+nIKemLCKdboc0LtFO++4xZ5DQB8vKgFcl4XnQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80eacfde-fbfe-4df6-4d92-08d864c6f60c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 22:28:16.9477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VcZjOBx+Dw+hWWJrGYxfjUvfc4J7SkxxUI23DHJ6JeR3N45DQlyMjmcPwLfO2dWUb8MsBQWaUDIxXZrcovwySQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2797
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently a new filter is created, containing just enough correct
information to be able to call ocelot_vcap_block_find_filter_by_index()
on it.

This will be limiting us in the future, when we'll have more metadata
associated with a filter, which will matter in the stats() and destroy()
callbacks, and which we can't make up on the spot. For example, we'll
start "offloading" some dummy tc filter entries for the TCAM skeleton,
but we won't actually be adding them to the hardware, or to block->rules.
So, it makes sense to avoid deleting those rules too. That's the kind of
thing which is difficult to determine unless we look up the real filter.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes since RFC v2:
None.

Changes since RFC v1:
None.

 drivers/net/ethernet/mscc/ocelot_flower.c | 23 ++++++++++++++---------
 drivers/net/ethernet/mscc/ocelot_vcap.c   |  8 ++++----
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index ae51ec76b9b1..0988bc9aaac5 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -234,28 +234,33 @@ EXPORT_SYMBOL_GPL(ocelot_cls_flower_replace);
 int ocelot_cls_flower_destroy(struct ocelot *ocelot, int port,
 			      struct flow_cls_offload *f, bool ingress)
 {
-	struct ocelot_vcap_filter filter;
+	struct ocelot_vcap_block *block = &ocelot->block;
+	struct ocelot_vcap_filter *filter;
 
-	filter.prio = f->common.prio;
-	filter.id = f->cookie;
+	filter = ocelot_vcap_block_find_filter_by_id(block, f->cookie);
+	if (!filter)
+		return 0;
 
-	return ocelot_vcap_filter_del(ocelot, &filter);
+	return ocelot_vcap_filter_del(ocelot, filter);
 }
 EXPORT_SYMBOL_GPL(ocelot_cls_flower_destroy);
 
 int ocelot_cls_flower_stats(struct ocelot *ocelot, int port,
 			    struct flow_cls_offload *f, bool ingress)
 {
-	struct ocelot_vcap_filter filter;
+	struct ocelot_vcap_block *block = &ocelot->block;
+	struct ocelot_vcap_filter *filter;
 	int ret;
 
-	filter.prio = f->common.prio;
-	filter.id = f->cookie;
-	ret = ocelot_vcap_filter_stats_update(ocelot, &filter);
+	filter = ocelot_vcap_block_find_filter_by_id(block, f->cookie);
+	if (!filter)
+		return 0;
+
+	ret = ocelot_vcap_filter_stats_update(ocelot, filter);
 	if (ret)
 		return ret;
 
-	flow_stats_update(&f->stats, 0x0, filter.stats.pkts, 0, 0x0,
+	flow_stats_update(&f->stats, 0x0, filter->stats.pkts, 0, 0x0,
 			  FLOW_ACTION_HW_STATS_IMMEDIATE);
 	return 0;
 }
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index aa6f6a770199..75eca3457e6e 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -994,7 +994,7 @@ int ocelot_vcap_filter_stats_update(struct ocelot *ocelot,
 				    struct ocelot_vcap_filter *filter)
 {
 	struct ocelot_vcap_block *block = &ocelot->block;
-	struct ocelot_vcap_filter *tmp;
+	struct ocelot_vcap_filter tmp;
 	int index;
 
 	index = ocelot_vcap_block_get_filter_index(block, filter);
@@ -1004,9 +1004,9 @@ int ocelot_vcap_filter_stats_update(struct ocelot *ocelot,
 	vcap_entry_get(ocelot, filter, index);
 
 	/* After we get the result we need to clear the counters */
-	tmp = ocelot_vcap_block_find_filter_by_index(block, index);
-	tmp->stats.pkts = 0;
-	is2_entry_set(ocelot, index, tmp);
+	tmp = *filter;
+	tmp.stats.pkts = 0;
+	is2_entry_set(ocelot, index, &tmp);
 
 	return 0;
 }
-- 
2.25.1

