Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2488E29D515
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 22:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729178AbgJ1V6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:58:36 -0400
Received: from mail-eopbgr20116.outbound.protection.outlook.com ([40.107.2.116]:41838
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729179AbgJ1V6c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 17:58:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hViElynBdIPkUw4E4vlURLM/F1lpLxE4wpkwbCEYDFbcf5Skk3qHP5faBhCx90OrD+qJYHUZNOdZ8BnQe3IgBPlxkO/EhSrokWMmdNfr0bElsinEnqtkmHNpjywuMmGSsbHwfAIOiDT+jCKMV/HAWxjOGXHDsTl3fcraoGO6kE09QXRT2omnNz/dupuYwRtmuPs0a3kDTuBoTecCuqrxpmh1MA2srNxGBKl/YgOUAtp6vFeqbpM5Lu9asbyZDhZFaLfd/pNAPF0RWxoVO8mUwFddxkrHRV3BipehQgzh/qd5Zwcmp8xyU+BknhkDRcl2a1A6nkyBOx1/xJw/oW21JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XqNKp0VROUxMGEsx6A8InVip5EKzu3qEPpgjBWgQd2Y=;
 b=YA/dfDvfEKEfI2Arl7jlKg3L3Dn/9nssjwHvO+ttl6x5pYchYfTyFawfWMnzNn73cL3zeXTELuRXogRcxnZdpreszUJO2UXirPL0fJ1GAId0X4O3Hwm6/pRSd9TuLfdoErpyVkiXOurdsYpeMSPvHHlxz/jkfCbEYoUgD+myYx7813UvJdSHDw/b0LtZ3tH2ddBS4m/MsTABoHYl3kneUsIdqMC8WPJ64P0bvCJgXM16UN7dCxd8e/PNUnoJhmspwXhAQwtJq4C+beRxNZXXGDPgfp9TC3JsqHEOY21dDxiQ4v1nwy0vGklZ60IWl74G235ytCl2j5qxkOkCA8vhLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XqNKp0VROUxMGEsx6A8InVip5EKzu3qEPpgjBWgQd2Y=;
 b=fCGB/QXRQehtrR1Q6xR0e6zmo5LhO7etPDVv4W/4KxehnN4Anyf/jkC44ggBN7UAO4Qo829Tq7cNmHu/CAQKaSNvWxZ0BBM7GiR5X9e1ZakjQ2qUS0O5slfDrhEebLYDVkkcXaMO+YaJmFHxNXRrulTuyEQlNrRUWPUXzdngv6k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=dektech.com.au;
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com (2603:10a6:802:61::21)
 by VI1PR05MB6144.eurprd05.prod.outlook.com (2603:10a6:803:e8::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.24; Wed, 28 Oct
 2020 03:27:27 +0000
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::2df9:3c91:ae8f:812c]) by VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::2df9:3c91:ae8f:812c%7]) with mapi id 15.20.3477.028; Wed, 28 Oct 2020
 03:27:27 +0000
From:   Hoang Huu Le <hoang.h.le@dektech.com.au>
To:     netdev@vger.kernel.org
Cc:     Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>
Subject: [net-next] tipc: remove dead code in tipc_net and relatives
Date:   Wed, 28 Oct 2020 10:27:12 +0700
Message-Id: <20201028032712.31009-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [14.161.14.188]
X-ClientProxiedBy: SG2PR04CA0177.apcprd04.prod.outlook.com
 (2603:1096:4:14::15) To VI1PR05MB4605.eurprd05.prod.outlook.com
 (2603:10a6:802:61::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (14.161.14.188) by SG2PR04CA0177.apcprd04.prod.outlook.com (2603:1096:4:14::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Wed, 28 Oct 2020 03:27:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87c6448f-6259-48c4-f691-08d87af16484
X-MS-TrafficTypeDiagnostic: VI1PR05MB6144:
X-Microsoft-Antispam-PRVS: <VI1PR05MB614448D071F3830445BD37A3F1170@VI1PR05MB6144.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:126;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J8vCQQJJkgBi6LT7ILXMCyIgbADDxP4bHP4zfeKwLViOUIS+bo2M2O19lP4e3tA7+kbz5QCUYMIurph85mQ0mMT3zY4NgGefUEOxHMdtLyVE3ow21oZd7pEiX403+VtCbzEayLlvatnrfVG0MC/QTP9AJ4w59nrwILgerVQY3dzU2WgeUqXhSRB7MvX03omSXC/Ea3aEyiSoPv+TR+PDWtmb75yH22fgWg9Fzrk78XuqW29oF3UVCslW7clsgvWBP2MnWztoDuneWykgrdFDXa+e7fRj8NUdJXhjCwhXZACQ8BaFVj4DUVZnF11uFdk9fgoZIJudEbXmyUd5o1cjnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4605.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(366004)(136003)(39840400004)(1076003)(4326008)(86362001)(2906002)(54906003)(316002)(36756003)(6666004)(478600001)(7696005)(52116002)(66556008)(66946007)(66476007)(83380400001)(8936002)(5660300002)(55016002)(103116003)(6916009)(16526019)(8676002)(186003)(26005)(956004)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: ef1nrbcefFedLuYcI5LffUOGQpNVbOKB7aboYy32SyOtHoJkEQxTSYJpaDzHDdVeC8uo13UAtt6hw0IxiOMNh0dM7xlw19T8tL+5Onc9HDcLrEXnZlAEsJcDxIbhjRnO2OUmIadfknHT9If5cReJbii/xWfbRqzNY0FMC1+5ItQ3nEOlVQUkblZHhFiQhc9sYCw6Hu6W9G3svmWwELGJ1iHAoeP6y8twbiGRq8IdsIDPa3umzrG2ueip6u1TFmSeZYoS1dZZrnFLdiB7lNlFT0lZKdJaPZubXhLRJs26mtM38CzVpmnbj/+3qvD7Pw29DT8BcZpljqzgnuRxZjI95VxnpGTG5WxGotsiZ02GNZnVndr7W3Fd6VprYhlPkWNUhB6a3PFBmmFWx6BdznQSfe5tPOKWnm3x2gw5N/3y4Mnv1PxpyYdtJ0huAy4aLwo++cUBf3vDjOnsRSwuHyL0XZzMfwFLCS8nvA9eT9l0cLPVjEyV7ok5psSAK1EHOy7Vunq8Rs7NMkH6Iz1Hb62Xv8EhdwvajkzmPlQSgq3ZlvFKZFFreoo/cGIl3h+H+l/eBP8qTI3Je0SzRIT5g0jx3n1lBvUOTOyh77k875Cr23IKxHjDlTqkY3F0hdB8Nt/U8G9JaWQzdAxuehvRiwWLTg==
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 87c6448f-6259-48c4-f691-08d87af16484
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4605.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2020 03:27:26.9505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vX4JkaKG6yA8AkiceWvzZAvcDeh/KB5HLppFEKshEK/EyuKFic1Xg3/mNoedYX76bEIN9Htl1nYVPaPe5N9KUCmmN9UjN+QFN+3kM93cvLU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6144
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dist_queue is no longer used since commit 37922ea4a310
("tipc: permit overlapping service ranges in name table")

Acked-by: Jon Maloy <jmaloy@redhat.com>
Acked-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: Hoang Huu Le <hoang.h.le@dektech.com.au>
---
 net/tipc/core.c       |  2 --
 net/tipc/core.h       |  3 ---
 net/tipc/name_distr.c | 19 -------------------
 3 files changed, 24 deletions(-)

diff --git a/net/tipc/core.c b/net/tipc/core.c
index c2ff42900b53..5cc1f0307215 100644
--- a/net/tipc/core.c
+++ b/net/tipc/core.c
@@ -81,8 +81,6 @@ static int __net_init tipc_init_net(struct net *net)
 	if (err)
 		goto out_nametbl;
 
-	INIT_LIST_HEAD(&tn->dist_queue);
-
 	err = tipc_bcast_init(net);
 	if (err)
 		goto out_bclink;
diff --git a/net/tipc/core.h b/net/tipc/core.h
index 1d57a4d3b05e..df34dcdd0607 100644
--- a/net/tipc/core.h
+++ b/net/tipc/core.h
@@ -132,9 +132,6 @@ struct tipc_net {
 	spinlock_t nametbl_lock;
 	struct name_table *nametbl;
 
-	/* Name dist queue */
-	struct list_head dist_queue;
-
 	/* Topology subscription server */
 	struct tipc_topsrv *topsrv;
 	atomic_t subscription_count;
diff --git a/net/tipc/name_distr.c b/net/tipc/name_distr.c
index fe4edce459ad..4cd90d5c84c8 100644
--- a/net/tipc/name_distr.c
+++ b/net/tipc/name_distr.c
@@ -244,24 +244,6 @@ static void tipc_publ_purge(struct net *net, struct publication *publ, u32 addr)
 		kfree_rcu(p, rcu);
 }
 
-/**
- * tipc_dist_queue_purge - remove deferred updates from a node that went down
- */
-static void tipc_dist_queue_purge(struct net *net, u32 addr)
-{
-	struct tipc_net *tn = net_generic(net, tipc_net_id);
-	struct distr_queue_item *e, *tmp;
-
-	spin_lock_bh(&tn->nametbl_lock);
-	list_for_each_entry_safe(e, tmp, &tn->dist_queue, next) {
-		if (e->node != addr)
-			continue;
-		list_del(&e->next);
-		kfree(e);
-	}
-	spin_unlock_bh(&tn->nametbl_lock);
-}
-
 void tipc_publ_notify(struct net *net, struct list_head *nsub_list,
 		      u32 addr, u16 capabilities)
 {
@@ -272,7 +254,6 @@ void tipc_publ_notify(struct net *net, struct list_head *nsub_list,
 
 	list_for_each_entry_safe(publ, tmp, nsub_list, binding_node)
 		tipc_publ_purge(net, publ, addr);
-	tipc_dist_queue_purge(net, addr);
 	spin_lock_bh(&tn->nametbl_lock);
 	if (!(capabilities & TIPC_NAMED_BCAST))
 		nt->rc_dests--;
-- 
2.25.1

