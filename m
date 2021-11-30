Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA59F46311A
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 11:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233372AbhK3KiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 05:38:07 -0500
Received: from mail-eopbgr80113.outbound.protection.outlook.com ([40.107.8.113]:37185
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233339AbhK3Khw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 05:37:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YNpBDqS/BWDoLzUBWUTvYQ51FlXbimfF0nlPXZuATT90bo84uwibs2kAKVaSDB9yvMle0q93gb745rFdCsK9+uBTxQOHG7uHvlgD29DC7wH8fN2SI/V2kdd3c2ZAvCoOtje9TuWXRDWGf3jWqisCEXYlcl6AmqpGj2PDUUyh3j9jjVGUUcE3KHjgfcMxs1ZQw7iINi8IEFoGGQ6nS1OE9nOOHn3L9z6S+kuFDZ3JEiuQnM+cpz8+yaFiX7t+5gpDBxdOqGeKFpOYFkjpNjrTQApSg6CzDOSxprM8p7FhDa9muizmCcLiZ4FZUoSkI1C4JhkiQY2hOLMvQhhT7kd/eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=whrvTggyq1iOBxg7XuwKqSSKEhFkLDxhwTdlfHTrjME=;
 b=U9wGCdA7TBJUe5x0319f5Oh3+pj6Z8iy12DShaaOdic6fBexhGSNEKUAZpnGhutuYWAPHfNo0o5EMwzb6wanBLRIkrRR1dLQ1JFdBlobjQVZ62Yh6Wq1Lvs2x+aJsYNuIPJv1ZMxcUVXua4tBXVEqol6tX35cJ2ugCoGPTiJZZKrd9s/PiZ3lsqHgamGS9ufA6cItB3KYtOi3/IRSoZjEEGvKH4MUeCWFvGi1HQX1ppFw6Zf5syeRdp4J0qbQW7o7XN8FbBpQLws1N8L92a6erZsu4DFV/R37SMPICdxu0rsnmz6gFYqjHeilq89+QYJTyw85biO8JF56pR5zjtFKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=whrvTggyq1iOBxg7XuwKqSSKEhFkLDxhwTdlfHTrjME=;
 b=ir+Gm6sxAbr4VM7WIenZi24SKD7LTQ11pq39MgJEgQXp4i1yrl+MlpSaq7Fsu64ke0051jtfaZwQ3ajPWc2SG5CgghLOgMjmkChLijISED6ioKbEzBcij1KmGtMDvvBV6TykgRQa0uzgLwdYa8OnJHsTLqfLHd3/lpGbrPlvXLQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by VI1P190MB0064.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:a1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Tue, 30 Nov
 2021 10:34:30 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::e15a:32ff:b93c:d136]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::e15a:32ff:b93c:d136%4]) with mapi id 15.20.4734.024; Tue, 30 Nov 2021
 10:34:30 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Cc:     Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        Serhiy Boiko <serhiy.boiko@marvell.com>
Subject: [PATCH net-next v2 3/3] net: prestera: acl: add rule stats support
Date:   Tue, 30 Nov 2021 12:33:00 +0200
Message-Id: <1638268383-8498-4-git-send-email-volodymyr.mytnyk@plvision.eu>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1638268383-8498-1-git-send-email-volodymyr.mytnyk@plvision.eu>
References: <1638268383-8498-1-git-send-email-volodymyr.mytnyk@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AS8P251CA0008.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:2f2::26) To VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:123::23)
MIME-Version: 1.0
Received: from vmytnykub.x.ow.s (217.20.186.93) by AS8P251CA0008.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:2f2::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4734.21 via Frontend Transport; Tue, 30 Nov 2021 10:34:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a2594dc-64e6-48bd-8c37-08d9b3ecfdd5
X-MS-TrafficTypeDiagnostic: VI1P190MB0064:
X-Microsoft-Antispam-PRVS: <VI1P190MB00643080E70E00C8EEB50D0D8F679@VI1P190MB0064.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sDJnoZFsidZtwKRByOrbfwNA+NgSTzOOTbvyphFb5URaDxmaLhWBxIqZqsfqNdzizAkAi9IEU4KUtCnTYWKNMHBSE78heskGTYnZuyybu0XCpHbzMP3YvhNJObeuQM9ZRdSYHzP8nYOC8NnMgyvMvQDlIIKiaTkA4aI9DNaCCQ0VwkdzCSKzj5tg482RyYqn8LCvUWnFh8ZEA0T96NQYWiv3/Ugn+XVmoRpOIzE+hU8JpECrwLcGE2YlqvxlB30R/q4DN46r1g/P1zIhTlQKDNpjnh67vdKMf6Ukrx3NoS/047+PiVonHyYN1b+PZzBUvO/mQx3jsgtoJ8xqQrJDfhhl1+VjVurH5H0sJfdkuXm5Ggiivln/FrKtmx5D1iseWfHipFs5HHvSxTDf3GJ1ZbalMZz5UOJ7ykNx9FH4Y9DVjx3ZJwLCayfpYyGGmfNP/Jq2+rfdaLVwii0wV9338133fcuFsr0gK8Lrcb5MFT2EjlnGtkU2YPnqRMXmhKINIZ1pu+gcAKoBFidBU8M5DZbtNWhJuPseI19KC+raBvWHP/u5y9m4omvkTtq5zToWUwNgCXziLI2XtfkVibZZvnSFSWUuUCo4PsG0flF5dzL7qh5GihUz8jrlUBjYai9c/whEigmE0R03IRgJAfVJ3aArGUa4+nUrSWo8V8nIWmZgRj9S4UEucM5XC0lFNpiAAuXevugwTlhbKc8NSafnfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(396003)(366004)(39830400003)(186003)(83380400001)(36756003)(38100700002)(6666004)(8936002)(38350700002)(26005)(2906002)(52116002)(316002)(86362001)(44832011)(6916009)(66946007)(6486002)(508600001)(6512007)(8676002)(5660300002)(66476007)(2616005)(4326008)(6506007)(956004)(54906003)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zjXYygEmDXhPdxKl98A/53sTAWN5Z5VDB/vZXslq9xg17TDwukVoksXjUgxv?=
 =?us-ascii?Q?F1shStap7ipHGwG6ZLdOSjrDe3PFPrMEypRQzReEJGTDKHNsNVe3EPDRi5Tb?=
 =?us-ascii?Q?uX6IvSlshW8klxF2gRIT3CfAIsJt/RnPx9ip0mKXffr2dLSLV4KzKPkNqgpK?=
 =?us-ascii?Q?vIPjWdr3ODnVm1vQuKf8FLXAQxlA3QKsrhVADaFNmy+YfRvIs3WBc4Xv0U34?=
 =?us-ascii?Q?IxjyXBY789mGW1IdIeYwHkgLpYUAUHmE1zus1G8ffvHeXpa6Vd+j5+ZquSs2?=
 =?us-ascii?Q?69xVsMBqFBIsxnFPEQYiG8TQbdMduAR6BYPBo5bKhdwp1/t9sSEo7EmrvInA?=
 =?us-ascii?Q?TtqlLPdd/cGdSZjU+YhIr3pMIIc1RizU9YaQV5kwVp4nllaDYo7sEd6XVzgd?=
 =?us-ascii?Q?DxjzODtxgc4Dp3uRzblV47oklobOiiYwS7H178Ox4VARIxOJo4hGBdkzOGRe?=
 =?us-ascii?Q?IjXa/x5M32Qc9T8C2AlqbW9WrKOZWZgfqv1AdXP7/DwwhDmXp1PSBwfuUBZx?=
 =?us-ascii?Q?M0mWUxzflSgUoKwaZMAeJhLE1yVZIKur2LolH3AVOPuB6DutGQzr9Q/vmVHO?=
 =?us-ascii?Q?FZLYsU2L32hbiJdIYj9jb6slx4dPpNXrl/3Iy9SIqg9P/89lZwPH8IM1OAKf?=
 =?us-ascii?Q?IYo1clBxMgPEipZXnngEK83s6qPBbbJe+B6+11qjb+3T9C3SFxptleI62mxk?=
 =?us-ascii?Q?FurwqWHBl/laZqpptPZ3s/bcblY+22IN7Sk+9qu/siCGlyS8KuNGi7l5g29a?=
 =?us-ascii?Q?xfOfqci3jCM8voy1LnVXWCGmFnN6dqM1Ayl8vVYKkuDiUfx+x1sGJGIpEvY+?=
 =?us-ascii?Q?KGv04MTQeIqqmaI0m1/Vi6N4Mr3EF3ZmI4bfsGg6JD3VEAxK1BltxD8FkX/J?=
 =?us-ascii?Q?mzAA5DgWPQeZjc/FNUjgr5zFHj84U6GboWhsG/KkUz9JyDxaovynW+6nVS45?=
 =?us-ascii?Q?nT0UBLz7hJa50oG8vVjPD+NjzaxjYw7mTkMwTw1tXxIQckZIr8kOGP8PS4kt?=
 =?us-ascii?Q?4HbM+0bTlm6rMtNNQbxrdnjGpVgZPSCb8MZedyyMqsrn3k7TZUuMjvlxtXST?=
 =?us-ascii?Q?JfZv/tepcUa1AizTy5OgLZSosUCY4WDr/+UerTCasQsFDJUz61k5ca99D1hR?=
 =?us-ascii?Q?J8PBy22cHPLekuNws8d5Fc0uF9zS6pk4dKUfO5py9ivXglmf1rEFFB+dee9S?=
 =?us-ascii?Q?s3nUjbdekvSsoLVrkBQlmtsG1D6x4As+OZJegAIwBHIGeYYEgd+8w3yGogJW?=
 =?us-ascii?Q?sPpZb0rlKGAse4zkRqJ62rivcOjCsER9I+wMY6pWrKhdNw4toi3YSApg6vKJ?=
 =?us-ascii?Q?i8Bk2Q31oBANf9ir2wD+GbTglOSxF7kfoOVfmmsC/lWWiw7y6FUz3Q+6DXZK?=
 =?us-ascii?Q?i9dR2SBtp36Jyu/vEZOAevMNztQoLqByLu3E4SKM1HIrHWmzw68CJvcS631m?=
 =?us-ascii?Q?syGMOJMrVy9jvdc0KENymzO7AdeUT7Whd2utVzIjzmWjkFSQXx98F4aAkk0w?=
 =?us-ascii?Q?kMXIRO8AxE+dBSeh/iknxtieVNmkb1Vejdx3CPUEjEHqB5DXxdcAkgVhD17C?=
 =?us-ascii?Q?J7EW2ImrDyp8cLuVygTw3ZGPW0NivIz81d9SfSfHQQBv7I3Cl4oNhu6b1hmY?=
 =?us-ascii?Q?8FwOQ9o+l0rJ96tURcmY9lvyPmvvTjFWExoGK47KfKu5sWLHoq0TpNyqroHX?=
 =?us-ascii?Q?lp4xXg=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a2594dc-64e6-48bd-8c37-08d9b3ecfdd5
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2021 10:34:30.3483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G4q1Hj5GFbaFO4Fu3UjbvdKaNlNAvGjFSMTEyEGywymyMLBMEZxobCrCRgSAbqao3U73mok0+YXvK2k8eB7CiYmIS6oHyJu/dy5TK1KlJVw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0064
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Volodymyr Mytnyk <vmytnyk@marvell.com>

Make flower to use counter API to get rule HW statistics.

Co-developed-by: Serhiy Boiko <serhiy.boiko@marvell.com>
Signed-off-by: Serhiy Boiko <serhiy.boiko@marvell.com>
Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
---
 .../net/ethernet/marvell/prestera/prestera_acl.c   | 46 ++++++++++++++++++++--
 .../net/ethernet/marvell/prestera/prestera_acl.h   |  5 +++
 2 files changed, 48 insertions(+), 3 deletions(-)

No changes in V2

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.c b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
index bfa83c5abd16..da0b6525ef9a 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_acl.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
@@ -33,6 +33,10 @@ struct prestera_acl_rule_entry {
 		struct {
 			u8 valid:1;
 		} accept, drop, trap;
+		struct {
+			u32 id;
+			struct prestera_counter_block *block;
+		} counter;
 	};
 };
 
@@ -335,6 +339,10 @@ int prestera_acl_rule_add(struct prestera_switch *sw,
 	rule->re_arg.vtcam_id = ruleset->vtcam_id;
 	rule->re_key.prio = rule->priority;
 
+	/* setup counter */
+	rule->re_arg.count.valid = true;
+	rule->re_arg.count.client = PRESTERA_HW_COUNTER_CLIENT_LOOKUP_0;
+
 	rule->re = prestera_acl_rule_entry_find(sw->acl, &rule->re_key);
 	err = WARN_ON(rule->re) ? -EEXIST : 0;
 	if (err)
@@ -389,9 +397,20 @@ int prestera_acl_rule_get_stats(struct prestera_acl *acl,
 				struct prestera_acl_rule *rule,
 				u64 *packets, u64 *bytes, u64 *last_use)
 {
+	u64 current_packets;
+	u64 current_bytes;
+	int err;
+
+	err = prestera_counter_stats_get(acl->sw->counter,
+					 rule->re->counter.block,
+					 rule->re->counter.id,
+					 &current_packets, &current_bytes);
+	if (err)
+		return err;
+
+	*packets = current_packets;
+	*bytes = current_bytes;
 	*last_use = jiffies;
-	*packets = 0;
-	*bytes = 0;
 
 	return 0;
 }
@@ -437,6 +456,12 @@ static int __prestera_acl_rule_entry2hw_add(struct prestera_switch *sw,
 		act_hw[act_num].id = PRESTERA_ACL_RULE_ACTION_TRAP;
 		act_num++;
 	}
+	/* counter */
+	if (e->counter.block) {
+		act_hw[act_num].id = PRESTERA_ACL_RULE_ACTION_COUNT;
+		act_hw[act_num].count.id = e->counter.id;
+		act_num++;
+	}
 
 	return prestera_hw_vtcam_rule_add(sw, e->vtcam_id, e->key.prio,
 					  e->key.match.key, e->key.match.mask,
@@ -447,7 +472,8 @@ static void
 __prestera_acl_rule_entry_act_destruct(struct prestera_switch *sw,
 				       struct prestera_acl_rule_entry *e)
 {
-	/* destroy action entry */
+	/* counter */
+	prestera_counter_put(sw->counter, e->counter.block, e->counter.id);
 }
 
 void prestera_acl_rule_entry_destroy(struct prestera_acl *acl,
@@ -476,8 +502,22 @@ __prestera_acl_rule_entry_act_construct(struct prestera_switch *sw,
 	e->drop.valid = arg->drop.valid;
 	/* trap */
 	e->trap.valid = arg->trap.valid;
+	/* counter */
+	if (arg->count.valid) {
+		int err;
+
+		err = prestera_counter_get(sw->counter, arg->count.client,
+					   &e->counter.block,
+					   &e->counter.id);
+		if (err)
+			goto err_out;
+	}
 
 	return 0;
+
+err_out:
+	__prestera_acl_rule_entry_act_destruct(sw, e);
+	return -EINVAL;
 }
 
 struct prestera_acl_rule_entry *
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.h b/drivers/net/ethernet/marvell/prestera/prestera_acl.h
index 8bfb7ad7307b..4e6006b4531f 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_acl.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.h
@@ -5,6 +5,7 @@
 #define _PRESTERA_ACL_H_
 
 #include <linux/types.h>
+#include "prestera_counter.h"
 
 #define PRESTERA_ACL_KEYMASK_PCL_ID		0x3FF
 #define PRESTERA_ACL_KEYMASK_PCL_ID_USER			\
@@ -86,6 +87,10 @@ struct prestera_acl_rule_entry_arg {
 		struct {
 			u8 valid:1;
 		} accept, drop, trap;
+		struct {
+			u8 valid:1;
+			u32 client;
+		} count;
 	};
 };
 
-- 
2.7.4

