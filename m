Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B741945A97C
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 18:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237926AbhKWRDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 12:03:20 -0500
Received: from mail-eopbgr60121.outbound.protection.outlook.com ([40.107.6.121]:58175
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238466AbhKWRDO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 12:03:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UvVuJ6fTDswpLZF2ztgM0Ot8UTiLd1+Gu17r3WT+Hxs06aOAlCMcjZVV6Foe8k8KgFWq9SuzUBnIzZY8WeKDVjhfEsPul0yF/W80TwOOvE4wXRvEGmXFGtFteh3Ef8Bf9YLIfSw5sjsCiXQkdQ/Lnof3D/JcINKEVgwg0aXoHOuVYaw+imcCtXAqMFJUeUlQWQaFYNaZPql9h04Yx3oQ+X2JMsgz8wtesnC4OBvFE7qWwZAslK6A7MAhLPaviYvx5hyBguO7JIR4Jden1eteFgaaUMHlK4ONKRYi7jssFNzmnwkPOCmKRVgR9ObK25DoH5qDeDupLFWclSRNJbX4Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nwQxo2Ki0/eqNgOWTaMngYYfpIjwMtXj5cF08J3rvQg=;
 b=YbTeaUPWCyvH0CNKj021dM87sou5wca+nYvhgoVX4FKKDiZFW8y2WuE0ccYORhEDOT/cPbNxcLXAouhAdqX3V9m6nZX35mpcdmv6QnAq5baay90ppP9c8zfzNFXVCJCAAlD/IrgzPqaZMA5QbeZ8YtwLo4yvZ3ZLgPc1CFR6dKvW6h0bAKcL8j4KIqgFH7KfUlB4De77XQej+Z/JDBOoynN6JPIJayjO2lInf7S7nim/yqhFIXWTYKpMMfToxE8LuwUQ2ctymGQ9xX2qrxOURijBNUf9IJou8P6gSGO/wtWx8Px/4+ISFuZuyhFjyAotzw39kJ2hqLQC4wtF0Cx6WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nwQxo2Ki0/eqNgOWTaMngYYfpIjwMtXj5cF08J3rvQg=;
 b=uCSsUdQk7ZtyyXGLwlt/bPtFwXLwnfCdhOr9tSsAMcw00UsRhp6fXXtQX15kEI942jGJ7/q+B8CAorERxo1G44k1NWOQ24fIrwH1TiNcoN1gwMzBrqhsd9nOQ9QZCnDtkWMnW8lxbYN8MpMJ5e6qyq7o523hEhvSyeMwemI1UPw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by VE1P190MB0830.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:1a9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Tue, 23 Nov
 2021 17:00:04 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::e15a:32ff:b93c:d136]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::e15a:32ff:b93c:d136%4]) with mapi id 15.20.4713.026; Tue, 23 Nov 2021
 17:00:04 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Serhiy Boiko <serhiy.boiko@marvell.com>
Subject: [PATCH net-next 3/3] net: prestera: acl: add rule stats support
Date:   Tue, 23 Nov 2021 18:58:02 +0200
Message-Id: <1637686684-2492-4-git-send-email-volodymyr.mytnyk@plvision.eu>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1637686684-2492-1-git-send-email-volodymyr.mytnyk@plvision.eu>
References: <1637686684-2492-1-git-send-email-volodymyr.mytnyk@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AS8PR04CA0203.eurprd04.prod.outlook.com
 (2603:10a6:20b:2f3::28) To VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:123::23)
MIME-Version: 1.0
Received: from vmytnykub.x.ow.s (217.20.186.93) by AS8PR04CA0203.eurprd04.prod.outlook.com (2603:10a6:20b:2f3::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4713.19 via Frontend Transport; Tue, 23 Nov 2021 17:00:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d50097d5-66a2-4539-3f36-08d9aea2b1ef
X-MS-TrafficTypeDiagnostic: VE1P190MB0830:
X-Microsoft-Antispam-PRVS: <VE1P190MB08303C7EEBD3A963831340978F609@VE1P190MB0830.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:374;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mDS8ovu5Tr6qU5LRPtU0qxMCmG+Sp7JNYyzgiuI26vpnV/mfBEEOgqqxVN+aXTCTgehdqpwaA6MugyanmibhmCAD//2wOyHkr4ih+UGRDw3eqr1sn6NBVhfg4h9+XZ86OtecUSe+RyTzdLSYtUGZxuzEoHQyMW57R8aViopp5CY6Tv6MkjqG8mEjwZUFilJdvweMqTftwzplRqd8s41KrQ5o7XyO+hnlnPFx6LWKv8Qpz117RBtSXKGhMCLjEIvjMPhxRotjvD3oCpBKz5x5pLyzRFhdINbur5U6BLBG62hkVCAMrEeR3ohTj5Bvqqg7DA+MF36iKbNfuHBt0cuOSsUrTkPJMYnowciE0Tp3w0Mwm9eB9JKT3taIy1EdgZFdmY/rIMDIpiqMtBwqTKsWCA5gzX0jC2IymoHdWAezeyXPoZ+R+OLg0teYwdTm8+Bqix8Vb2bpzjeHTgfYcHgVKQ3RrlJqpbQygwkCRJhAwo12267EoQFchgQA1Y7aoOSXA2oGJqphucvB10OJJ59+fLqZ4+u76Q6j61J6n5qSL/N4qH75AXTIOBqoQTL4jBPHA3JSYKlAyCiqcgYyfCQv9kE9QrgFpsK9RvIOTq21mwa0dX6+YKTvIs/E8hua6BheZq5Rb3JSc4laM1OQV70eniz5grFUTN/X7kiYs81pAUbi/GgliPztUvJrKUgojMIsfRzyiRVxrjoWK2Z8UwubHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(376002)(39840400004)(366004)(396003)(346002)(36756003)(26005)(956004)(2616005)(83380400001)(66946007)(8936002)(8676002)(6512007)(38350700002)(66556008)(66476007)(52116002)(316002)(186003)(2906002)(6916009)(38100700002)(44832011)(86362001)(54906003)(4326008)(5660300002)(508600001)(6486002)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A5ICtpKamxyZSkDE/MeqmVdSrfdPfkQmPdcQ2OWrf6oJ8IgmrGMuqq14IUZS?=
 =?us-ascii?Q?rZKYXQNWaGJSKoI8NGu8Fl6vqZRKPldCj00mZwj72rAx+MUkQfrQlM7S0SM1?=
 =?us-ascii?Q?6GMdFy2enmuw2659HsZ+qHufXKAg08BBMNMnqPagYmtD4n0p/PYyyMzLMEFo?=
 =?us-ascii?Q?pOd7gexz0bWm/BDD5rhwqssAgQFzm7DOlQ1obMf2XdiU79FSKgOnFJhVl5N6?=
 =?us-ascii?Q?AdXPCGqLEZU+Xlji7ljSll9w3/zHe8Wjg5v7goFp7NWH/rumilsSZcDa5xxp?=
 =?us-ascii?Q?NIBu1vFXCS7VSDR7SY7cigjFeTK/UW37gTFwpYOhzf9DfRaoXj5FnpLt03oT?=
 =?us-ascii?Q?XTCYqstsUQ4XqXP3Uw8Zy1EOIGYfMbn2waI1mJCU/zblqJGbxTq5JLcjdUto?=
 =?us-ascii?Q?wwmOm0R2vMExMxCkWGigtfZhVE1oSZ/HlgNYVoa/aqfyWScEpLSdJ6IRaZ8+?=
 =?us-ascii?Q?+Ej+3LkdKE4HhvQKczLE/TP1nfAuE/fcSwkCTnYJdqVBsG1r8dJEs48/qGDn?=
 =?us-ascii?Q?8ujjzT8nFTTTZxjnevn/2lBqy7LVb6J2CR8arpt5kwjooogXXgth8vvSver0?=
 =?us-ascii?Q?FNCzsEgw2KYzoNURhybRiXFTFQ2SthAHALkjC7RD6HHhjdjcfJbDK/7WOVDX?=
 =?us-ascii?Q?KkJzR3BF0YneNs+BxdTfNRdNoEasfbUZvMBZ9HARZexHxGemYFlQ9gJuQaEB?=
 =?us-ascii?Q?OFsj2G+ewsG5ZEEBXhtN0A7qrbNRGi6tgPuZ/DyrpjqdxLRcnSO1kslycAZF?=
 =?us-ascii?Q?I+6/bzN4AXZvI/h98YoSMChZL82MUZUKW4iY3rm6qrLudiDTbRjvkbr3BxVu?=
 =?us-ascii?Q?ialhrm3J3McE8P1a0lyq2vF2nvBXO2A5+zovuXa/XX/v7hucuXeLxGV2bkHs?=
 =?us-ascii?Q?Or9GaVKGycm3BAILL9TRPlYmtgV6tl9M0NpiQ/2ogtznYHvqYlNjLGyYGGuZ?=
 =?us-ascii?Q?c53GTSHW7/qajKBcSvUqQR8hHnFVGoM8dsDrapoT3+/iDFLm8+DbdtshfpJR?=
 =?us-ascii?Q?XcFTpSyoc1tZ9oGh3EGmWPg8Ps2QeGZP2kM2wrshNpUIqwCLLLRoH+6iCsNJ?=
 =?us-ascii?Q?nj10OhMFfe3Mhj2XtiEAwjWuuhBFjfwCXtqEYcTFZW6oG/8zKb+OPqdkAr2h?=
 =?us-ascii?Q?ryZbCDvs5nuw9MG9aLtbg9AU8OSQLeQ98neWsIzyHZWe5VHV5ycbDqJRw3Nb?=
 =?us-ascii?Q?vBa+Vo/Rbw8l9USjTG3LfMyO7gNn8uxeu79YC6kODSS3W+FVm4ZBQHVzH/s8?=
 =?us-ascii?Q?yWXrY489GAmzvCvVcO5sIzE6MbQ6ziKHBi+u9aJu3OZ5g01FfIqC/QSfOmeh?=
 =?us-ascii?Q?GyAkNG9YSjIwE5uyfldTlfG5gyEoZ2D59w88KQQdPDFXIZ33dQpdAPYXQcg3?=
 =?us-ascii?Q?RU2HXVgnJCyD5uAXKOMt+FkBgZVEz4ZLE0Mx5x7cqK7DOHFxuW5wGzd+iWHT?=
 =?us-ascii?Q?pdC/AURB3AgzRT0UP0w3vcgH/wdhZa2U0yrJ5nYLkmD+CZYzCzthfX8NTJLF?=
 =?us-ascii?Q?pY8OdCny+M4J5zOtMNEp5+8AVj5dsNzmftE0ogNOEezuqcvWVORIo2ykhmmK?=
 =?us-ascii?Q?niK/vSnTI5EOBD1pOY4Cm77Dgt6eevMQcStbNKY4sklDWRCd78QqCmxrIFh3?=
 =?us-ascii?Q?8j+6ea3nK1/QUxb5o+jpeOsY52npQl6Bzpo9gzgxzL36CmeV4yLNeqZOvsaT?=
 =?us-ascii?Q?ClAiOA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: d50097d5-66a2-4539-3f36-08d9aea2b1ef
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2021 17:00:04.4131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ojEVNKeNy+ASMUhd4JUdwsgFXQEin9be8wM/Eez61WpVGMQ6xcHS24kxiTB4y+yux7IjIyX9cR+CUAZ1459T5uAjFu03uqcq5RvfoV/FfQ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1P190MB0830
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

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.c b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
index f0119d72427f..f8eb99967bbb 100644
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
 
@@ -358,6 +362,10 @@ int prestera_acl_rule_add(struct prestera_switch *sw,
 	rule->re_arg.vtcam_id = ruleset->vtcam_id;
 	rule->re_key.prio = rule->priority;
 
+	/* setup counter */
+	rule->re_arg.count.valid = true;
+	rule->re_arg.count.client = PRESTERA_HW_COUNTER_CLIENT_LOOKUP_0;
+
 	rule->re = prestera_acl_rule_entry_find(sw->acl, &rule->re_key);
 	err = WARN_ON(rule->re) ? -EEXIST : 0;
 	if (err)
@@ -412,9 +420,20 @@ int prestera_acl_rule_get_stats(struct prestera_acl *acl,
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
@@ -460,6 +479,12 @@ static int __prestera_acl_rule_entry2hw_add(struct prestera_switch *sw,
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
@@ -470,7 +495,8 @@ static void
 __prestera_acl_rule_entry_act_destruct(struct prestera_switch *sw,
 				       struct prestera_acl_rule_entry *e)
 {
-	/* destroy action entry */
+	/* counter */
+	prestera_counter_put(sw->counter, e->counter.block, e->counter.id);
 }
 
 void prestera_acl_rule_entry_destroy(struct prestera_acl *acl,
@@ -499,8 +525,22 @@ __prestera_acl_rule_entry_act_construct(struct prestera_switch *sw,
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
index a1a99f026b87..f2a46816c003 100644
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

