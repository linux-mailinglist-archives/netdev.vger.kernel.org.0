Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81CE04B8BB9
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 15:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235154AbiBPOoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 09:44:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232255AbiBPOob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 09:44:31 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2137.outbound.protection.outlook.com [40.107.20.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF62F6E7A3;
        Wed, 16 Feb 2022 06:44:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d7nir+KeJEoaqGw1+IvFeRBHOHdJVnUOAtAyuHQfy09HAxv+z9RYN5a65ATOAAvRTgVysafhrG8IZpmuLJ680Oxvb7OdpCEXega8IuQzGqLFnLqtFsS/RwviDbuolQ2vJuA3IKRLyptU9b9KFaqth1kcG+9B0iiL2dnq5M4eq4n40kFb6WU2vEjU4b7v04tevxrO17PeK0R0MHl6VBycSzZ4euI8BK4GaQ/mYAKUM/V6B4rN5XHHrL+5WKuAcj83gEGTrDKdN+LZnDdBohRbyxdkA1UyXSa+i2UfbdqVukfRmcRl4UI1JQAFQw5UNX0MT8D5xVoPQfJSy4xwl1KEwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sd7u3KWTIEgWtCJPz/jS4t742HdUcM44Gt5/ATBgeLM=;
 b=fz5mExt4BrSYGR+mXGKUbcylp0KgE31MUB7j439bcnZtcCzwNgHDBILrQNr5ow+39Pf3TFD086jCEIVGpRp+aHuZ9TdNE7o+NTylWeqzDsOKjctdCC8LmQw/19CdqVEslEQRiRxtkRVj/X5S799M2+QWAUsC2wcRj3Q7iXm9/28gq6BJbMe616xaRpKeeUiIwVc1Fjox9Oq/t95cIITWGo3+JZtCn6W9LV19RoCWmU6BZJWoz5fRZxTKcuuToLyWNBghI2noCMNK1L66L2+K0bymhw8GY2GCKl6J82hVJNH8OE58+VNVn1qUCruyG+3wS11etdxTqqS5zciG5nCYpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sd7u3KWTIEgWtCJPz/jS4t742HdUcM44Gt5/ATBgeLM=;
 b=rQGSQXW4p85qg+HKKDEmAsjWBbxn/U1B7KukfNcQWBI5X8L7iFgOVtJL3PprsaKT7TLOnb0bRJjDKOJnBJA5+cV+5sPK1WxxV6mcmuhFRBIFXjbDJ6hLDUbmnRFT2mbVqWUo0rNA+mUTVEhgYKc5yH5e9/QvnPRsFX4GcZszo9w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by VI1P190MB0496.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:3a::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Wed, 16 Feb
 2022 14:44:17 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::f16c:7fde:c692:f911]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::f16c:7fde:c692:f911%5]) with mapi id 15.20.4975.019; Wed, 16 Feb 2022
 14:44:16 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: prestera: flower: fix destroy tmpl in chain
Date:   Wed, 16 Feb 2022 16:43:44 +0200
Message-Id: <1645022624-2010-1-git-send-email-volodymyr.mytnyk@plvision.eu>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0023.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::7) To VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:123::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c327926c-a238-4abf-f9d8-08d9f15ace4a
X-MS-TrafficTypeDiagnostic: VI1P190MB0496:EE_
X-Microsoft-Antispam-PRVS: <VI1P190MB0496C53A60C56F3633DE7D448F359@VI1P190MB0496.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:298;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GC5mgrtzFsbV7HJCHYwmsNYiK1pMZzOfBhWOsyg5wsk86oLQpwWy7KpTNM1OXhpBpMVsHuWNA4ZwJhJqsIkomwpoxK11n1F6Ntg3r+Y8a6InwNnTOvgPQnRfrnUrG/4AQknSm00agLPJmiGhU0EoysVILmyur9QoVIHoFI2T6fFkZqK9ylQiwStz3z4LEuRd0NQsjXFplnQUKMM2cJYHZwY2dHdg5JpI5MoE6wlUgSEzLw1nNbLWhLfa4pzV0fsZ39416iY0pJabcGLY4gQgOxFLBah+wMW+LLivVGw6BLhr91GEJh5ujwcj34CJZmxJz+M4u6hHV1wF684n+14xRsAppe28UrCy1QBgf7wSsXus9PZAN25WRpnFP0ianXqqZMBVGltAjbcDB5ZUsLug1YyVFMFWbEFtjHuwT11rrLdgvJuNwrkgO9WRacykI9+mN2+QsPeTxDsFEL9L3EsIbrybZDX3N97Y8fHyiC6W9wicElN1NDWwli8+iF1dTD5DTfHw8Jkh9rZFXFCr2WB6YP4w1581iQTftgakOR1j9v+txm4LeJRcnuIkFqOu7Qp7fKi3PUkOIuz/zmKHRyfa52rrrIGyTLb/XveuyKSYoCSq85XJJPq98jQd19i8yeIiDJmdNCBrx2Xxv+pcPlMS+ANNBxFIH5mC5u25WwhEHkWeB0BseC7w9cqjGMwWqiPP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(366004)(396003)(39830400003)(136003)(376002)(346002)(44832011)(86362001)(36756003)(54906003)(66946007)(66476007)(2616005)(8676002)(66556008)(8936002)(6486002)(4326008)(508600001)(186003)(2906002)(26005)(5660300002)(38100700002)(38350700002)(6506007)(6666004)(6512007)(316002)(83380400001)(6916009)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6+oJ9qUyPyRledV1Z0/Dwy5Y8UufxRBHIFAFMRLmvgu5fTmlFJrFI+OqkWUY?=
 =?us-ascii?Q?Gi3s/V+8zMT9FDbrPJVdOo2tBykP/1bdjVkeyl3iUlCcHjEoc/eRedQEXnn9?=
 =?us-ascii?Q?GO23rl02lPwBWwwc8y8ix/WUG7bzJPpq7OnNSCP1zgEOxlO0TM/g2elpeZU7?=
 =?us-ascii?Q?dH6JH9QNPsiE5+xsjqmTV7F4In4IymGNYAWdY6PIRNNpBXr3gWCNezQSk6SB?=
 =?us-ascii?Q?zJ5rn8mm/p205ovdG3rz0o7oy7UI5xKnTbxe/YgeukfNlgiiDR+jMJKz7xb6?=
 =?us-ascii?Q?J+7CcazWlRGwdCUS/VmK/aJYZywkmGOy+SrEX0yvhCQiA97NY2o49C716nBG?=
 =?us-ascii?Q?uBfiXG+nPrF/1tvbClTCKfdAE5JJ9psONCfiPsuPbWFXe0bModADJ3QVflsd?=
 =?us-ascii?Q?yyZb0+MZBKALeSIUAvbdPCNisVhYpx6jVebp/3HUYXDvXCP1TgfPXcIDGb+a?=
 =?us-ascii?Q?J9lBmmBmE8ecmuNk45K09urG+QZuLq6+NvN1WAjJCq1wR7OS2Du7p4w+nKcs?=
 =?us-ascii?Q?ArMKah6xuGjW4jipEZiIBmKjB106qj75TPQ/X0PVu3dCmnPojISFZVoBOVZf?=
 =?us-ascii?Q?qwCUG40XZZ+RgOUQ1+try2XGtHp9IfWVua04n9MgQEVnQ6qC3ahvv3iOBnF3?=
 =?us-ascii?Q?nIqMhAjX8ryMCZW1FsOfGHA48UP2ac7bmZ+mFEvsPj9USdTuLQj+CDEjCw9A?=
 =?us-ascii?Q?6vWeuRFCcm6xUBlIUTe/PXxCPPTR+jxXFnw1ZeqpbeNk89k52Q10Xfl/sM4n?=
 =?us-ascii?Q?WC18dC9qAADAl7N3qq+ZOURt+r4q2YXyEqYB+gZRtX6cwxuHvXt03fp0/HJ6?=
 =?us-ascii?Q?UYG8xO1VGbLlwK0LvDwe+cKbiKgGw7xlKLBrUhcjk00aTjhaSPxQpzycugGX?=
 =?us-ascii?Q?MJy0uyUHVrW88n4qdGdruxYVTtjnMCJHXKpvmkstJQu1fk04M6vYiAKVOgSQ?=
 =?us-ascii?Q?qQSLjfF2G9kX06Ybo9hGww0NZ+cOiEY5jBc09PW8c7lhSQDLz9hXwNyQWsjr?=
 =?us-ascii?Q?JncqnTUrglXj0aypINyoY8t5CDEKooSTgN8LNa1r/K8oRazUHOeNIa0d4cQ0?=
 =?us-ascii?Q?cbgU4scNHeSQ/z3EtabCA5kXD7RLlrUivS1kjS8guKym4XO7lCt/Te17nZiT?=
 =?us-ascii?Q?t1dxrHEu1ZljVltC6LTK0JA3n4j7hsyPunrXpLY3rX5zDML1wJ1NPKnhx4i/?=
 =?us-ascii?Q?qN0H3WTRWlmII+QLsIFSMIGOAW0sVlplQl+WcBX+oDqZMVwIa9Yfdf2UatnW?=
 =?us-ascii?Q?Nq+YQfUXrPSqS1pkKGVoK62BeCt0iiW0G1J1utrtnD21ROglU6ubT7IswemF?=
 =?us-ascii?Q?GQChUE1+PPZjzZA4oveJcJeQd26BZ0W06cgkz1h7SIXScMkQBbTi8rnnUGJy?=
 =?us-ascii?Q?qbgoM+QB3hmHyiFNkG4FrxwfHjhtOGlMWRUvGWx+7U2TGl17SyVi5MUE1Ngb?=
 =?us-ascii?Q?xMRmslqZ/OBDFWcKWpAZCOEVJxcasvEA42yQHQOq4+CIZ2/YzeQXa4BySdV0?=
 =?us-ascii?Q?NI7+F7g1vdKXa+HpwcHAPObgrUEeE7rSv2rpes4Lz1D/sYDJA+Z7dS++BrJ3?=
 =?us-ascii?Q?Y4JqJbd2olBwYTfdX5bOZZea35/UmIWeGny03oBwTeWyiQoVQoZEqoWXsyYZ?=
 =?us-ascii?Q?pV/lbGbMckbjMZDHu/sFOSvWkzMpQphN/h8rpciIo2OXENFAhAccWK5+nH0m?=
 =?us-ascii?Q?eWxXmQ=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: c327926c-a238-4abf-f9d8-08d9f15ace4a
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 14:44:16.5492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: orcVCPC+xhJUZ4AHTp+MRBS2ILy2rY+pY9FyAV7QVaTT79fKTNSoXe/Rghkw6l646dVDovQsNyyb/Eb8grvEew27kr3TZBSeTAFOn0DN9tc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0496
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Volodymyr Mytnyk <vmytnyk@marvell.com>

Fix flower destroy template callback to release template
only for specific tc chain instead of all chain tempaltes.

The issue was intruduced by previous commit that introduced
multi-chain support.

Fixes: fa5d824ce5dd ("net: prestera: acl: add multi-chain support offload")

Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
---
 .../ethernet/marvell/prestera/prestera_flower.c    | 24 ++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flower.c b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
index 580fb986496a..9587707e3148 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flower.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
@@ -12,6 +12,14 @@ struct prestera_flower_template {
 	u32 chain_index;
 };
 
+static void
+prestera_flower_template_free(struct prestera_flower_template *template)
+{
+	prestera_acl_ruleset_put(template->ruleset);
+	list_del(&template->list);
+	kfree(template);
+}
+
 void prestera_flower_template_cleanup(struct prestera_flow_block *block)
 {
 	struct prestera_flower_template *template;
@@ -20,9 +28,7 @@ void prestera_flower_template_cleanup(struct prestera_flow_block *block)
 	/* put the reference to all rulesets kept in tmpl create */
 	list_for_each_safe(pos, n, &block->template_list) {
 		template = list_entry(pos, typeof(*template), list);
-		prestera_acl_ruleset_put(template->ruleset);
-		list_del(&template->list);
-		kfree(template);
+		prestera_flower_template_free(template);
 	}
 }
 
@@ -423,7 +429,17 @@ int prestera_flower_tmplt_create(struct prestera_flow_block *block,
 void prestera_flower_tmplt_destroy(struct prestera_flow_block *block,
 				   struct flow_cls_offload *f)
 {
-	prestera_flower_template_cleanup(block);
+	struct prestera_flower_template *template;
+	struct list_head *pos, *n;
+
+	list_for_each_safe(pos, n, &block->template_list) {
+		template = list_entry(pos, typeof(*template), list);
+		if (template->chain_index == f->common.chain_index) {
+			/* put the reference to the ruleset kept in create */
+			prestera_flower_template_free(template);
+			return;
+		}
+	}
 }
 
 int prestera_flower_stats(struct prestera_flow_block *block,
-- 
2.7.4

