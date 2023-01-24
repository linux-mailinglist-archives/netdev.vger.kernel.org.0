Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F37E4679083
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 06:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232609AbjAXF4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 00:56:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjAXF4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 00:56:03 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20600.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D38323DB2;
        Mon, 23 Jan 2023 21:55:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SF076JzFXJT5tBCcFPiNclt6XkNHHaTjgJv2GOGCKrQb9KvUdRwi842dnBINijk3BqqjJZtXlyZjsxwkfhkqC/82FP5TE0tdS5sFmJl1EmUTxSHTJJBeUptZ9w+MciD3sDsg45oEP6QPYrhjrVD0ATo4QQ0g/BKU/2JqcvCn9Dgw6L5rm0cfDgzrxiDivD4KrWDvi4+kce9lU8w7TVg/I40abIpceVVFb9mziRC28P9Am7etrYwvc3Sg0Cr7uyYS/9zOeQyIpEUMUbRtQdZdEVhEjxntUcminDwgYsi9oBoxvXDzQyh+HVEOIa1wfU0IMTyeJgXN01xUFmEEUSJWqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nXKmUiAwwip0H/gynwy5RsgsJUC5caFZfjG6m6383VY=;
 b=K4vUOpPclHN6c2a3PB7LmoTw+TpMR6xlL14QwH0wiP/fs5WXcHX6ZhS5etqkazcBoeAn8cL0fNIm8c7roKQv5A2dKS53t0TeBFWelk14KohoSjGpurLj+zJ2u/RFQvBV66bmTVBQ1GuVxRX/DMIiW7efPPc7iwbijaiRmSsHMskMKyrqL3vmlm54zANwOoGYgFkrO4hV8FfK7C0b3Ks6vdOgMG6yP4qxxLVJBTdb3SmgbzT/CfsSW35M4+6sIPTHLsnzl8Zt8RmDEQOrVzUnCaGrt/Z0l1EwMakjODkb+6qJCEeLPxLh8z0EhRKFe5X1KL8g7UnR0PC2Rs91+LJ89w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nXKmUiAwwip0H/gynwy5RsgsJUC5caFZfjG6m6383VY=;
 b=EyOJEsMdC9Pm2dVyZu8t7V04q7ar/Fng5FR0rXTfQdglnp59DaTP9cs40qJld9Gm1OjXSNecHDL3L2mWGVnKtEz0Y6zx+nMEhgvJFDI5j2J0R5piA2LNtMyLmR7dMAE6/qFxCq1JPagJCvMLOtc+t3iBnnJmKH3jZXZ/Sr5YQ8vuY28QyoHFsJK8y6xxzrl49r1MQMX2wPjeqpbKp7Y2rwX4lCd2/mi2e9KlnlUgvhErN8QPJEaPo2En3y9Hj/vTHUmH1bYEeCKOOZ5lovaVKTB4uHvGrwdKvA96iqPfaJHPSs1KhCRM9T55ZTIpA4k2u26EOn0aM2FRVcR0rUq73g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by PH7PR12MB7793.namprd12.prod.outlook.com (2603:10b6:510:270::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 05:45:27 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::465a:6564:6198:2f4e]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::465a:6564:6198:2f4e%4]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 05:45:27 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     linux-mm@kvack.org, cgroups@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jgg@nvidia.com, jhubbard@nvidia.com,
        tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com,
        mkoutny@suse.com, daniel@ffwll.ch,
        Alistair Popple <apopple@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Subject: [RFC PATCH 10/19] net: skb: Switch to using vm_account
Date:   Tue, 24 Jan 2023 16:42:39 +1100
Message-Id: <9b54eef0b41b678cc5f318bd5ae0917bba5b8e21.1674538665.git-series.apopple@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY5PR01CA0077.ausprd01.prod.outlook.com
 (2603:10c6:10:1f5::7) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|PH7PR12MB7793:EE_
X-MS-Office365-Filtering-Correlation-Id: ee42ee53-a49c-420e-9228-08dafdce3232
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X4FOg3pTqEzrbtNhZV/TzqlzK6iYksRf7X01zRRZJgtB61ceWw5M02H6c2/8AX4X6jpt0Oy4Nkrfv8Um7NxQb5kbBGOymB0H/VIdTWNmS1B1AA3IcGWIBtpzWj54z9cXpY3AgUwarAcf4T6MKlzB6Q18tLs2WDvuYkZFZZONvxIr9UBxVbjx6I77E7SkxdnppQHiP/FTp4CPFvaotoGWKgChqfJ0Dn/WLZSgn5MDDi5BHkardrWyPnobV+mVrr4wrduVNTb1FsvYtCJ8Cw/6zkRW9ofeLBEIDNdbbVjjc42xof3RJVZ9uhKhYcTLevhp4SyXUHJnl8L3ZMw2r3et2SJ0ULyureKIzUJcrj9jojPx16mlxWxsQ9TYeTxJhVbhJ6X+g5lTmg7VoE2ztYpYP02wWatmpBbTK5jBurtPebz6QLs1EcqC5CIkgM7CkA7bPKZWDaEW13RfvgWYeBz/kps5E2Vo/qcz845BwJlT1vsxp3zPXx9O+WNVi9q9/tQaiqSy2QTFQjhBjg7G9XjdRz3nLe1JCO2Q/gP2cQVJ7Z4cukytvsCbRmbjdgITqF4J1knrcs+7EX5YIDgMo12Lyc45QmU4RBPvcpJzNR2kJK/jbzLiKwEEQjzwfjcCGE0WRrhAz3NNjCsRmZOhyuVKhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(451199015)(36756003)(316002)(4326008)(66556008)(66476007)(8676002)(86362001)(66946007)(186003)(26005)(6512007)(6506007)(6666004)(83380400001)(6486002)(478600001)(2616005)(7416002)(5660300002)(8936002)(41300700001)(2906002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K8g3q04AKDRU9iOQM5sWeWNFrDSqaTYGIY8JLNyY5Ch7MRB3P6TSMF5aHbPV?=
 =?us-ascii?Q?/vSwlDtOwyTARzEtSTcZDwUR9obeuANIwT7O0j9TlDKLNN9InYK3HRZOSefK?=
 =?us-ascii?Q?7LMNZve4qAO5wcJ5U+lJWrzM85R1idW4nVOXAHX4LQqlivlJ/02I12HUO76+?=
 =?us-ascii?Q?iVzWDqRtCnbAWWJerEXnhW43w6xst40krfxmG6sWmheGd7aWQDMWMdhUalzo?=
 =?us-ascii?Q?ydlgCZOQBcRV36w8So79YPQZdz6dakoeXAmots5Wh0JqU6jzOaffVr3aZLIs?=
 =?us-ascii?Q?44j4u6J0+lwgM7rw2mn3IUdjWFgbaRMO+PO2WsK2digPnlz02DxAVBKOSaOA?=
 =?us-ascii?Q?RKkc1//jRS2Et+pTRhdZfOeDQaE8lAobOauTI8I18jvr3DOnSw1aaumXxWEo?=
 =?us-ascii?Q?BjtUD0mjiAFtqveLnrdBvdaWZIfAwJKrrl8lFa5h9OD/5H30pkI3Of4aAnHr?=
 =?us-ascii?Q?z+2HLMqFEmmNiz5Vn9raPJ6vc+rgq/+rx7FAiWa/1UFBIT0EEoApLyg2Ex0u?=
 =?us-ascii?Q?QA0SpW4voskDpzGtFQ8vHKV/uVKxdoqempU/Vi2QvOY0oiOW1FiomFUL4nMd?=
 =?us-ascii?Q?IgHe3msfE5zF+DXJNZgNjhUOMIZeVhi4/TIiQK+Ospv4tKTjTs9F/I0+N7GL?=
 =?us-ascii?Q?EuekHBDHi+iOg6iCCNiGq1taZSl+ZXqDE3T2mmElH4U2WY+eCOAy/gKQ1pTV?=
 =?us-ascii?Q?FMcbQeL+NmhdAS00eaVq3NZZL6NXHS3Hh2kLz4wlsf0uBGs4iuMXCvMkVH8M?=
 =?us-ascii?Q?TycwnZNokHNArTZauYowPZpg4G0LMY0eHWXc+p6QtZ5EOdqEBefBpAShRNuU?=
 =?us-ascii?Q?NJJl2tRKb16jeVGYP4M1EMfkzBFxm+HqI50tPJwuU+fJwX5n+9b9d4B0EPQs?=
 =?us-ascii?Q?ucTReSpqkSIo7xm7asiTwGHSNFy4MHasfcvO3jyGfe4QpS9XIOiISNObfOl7?=
 =?us-ascii?Q?VUvC+qp7R1HX8/gpw1SEI/vhosSKID8FJPtwtQLmtv/3CUOzXnRY8EC85cLo?=
 =?us-ascii?Q?0WRV+MLFzYjPV9ch0DEcJkVE2F1gsXOnH1FM+yufAb6555Vpc9evgkkjntjN?=
 =?us-ascii?Q?OhEPuGPXKVwTuPojqiqDZipUJE4yKmG5MvDaCLZOjryUGd2cqRFpifTz1+1v?=
 =?us-ascii?Q?S9a9TrQV9jpx7kbaTiHh0gMxaBrtGPHJT4L9KUh4grOlhwpiWeKZEx50y6s2?=
 =?us-ascii?Q?Hz1yRdpcKO+Ih3BN3wezb06I/mUmW8kK00N5FpdjUHG5V/FRjA/BzI3ZXHE5?=
 =?us-ascii?Q?tEQntDGaRead5oYmHdpNAGPP3b/MeeHfFC+kfHyFB/WiMcDf3TyadxR8/zK0?=
 =?us-ascii?Q?uZCyNmdZVS8HCWqqSoDp0ikce/ZkNj9J/NFrQ38NY59c/vFFlxR4y28CShEr?=
 =?us-ascii?Q?vgGDEc33uatXhOHsPciTw86RfBs5PYJj1Lx8ddSY7kjlszjuVGgeOJTF4Qm7?=
 =?us-ascii?Q?yF3Ufr1ntCW9G1P9NK7xrMVvauoJOjDaeG+9QPKcftj63XLkjJn0+zoOVdWr?=
 =?us-ascii?Q?mn/1vGSsGT9dEsjqmBLpjwOfexQ2nvIPh/AlbAGtD205gmhM95MMMTjbIDqy?=
 =?us-ascii?Q?4KksJOnCIolLjCTyEzpcC7sG2jzLzeqvPDZIJ+hs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee42ee53-a49c-420e-9228-08dafdce3232
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 05:45:27.5330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OtuzUzDD66upC3A63HQzCEWHuh0uxSOe/AI/iKdZI4NmKeNoSjN4u6UaYGvK84y+yktDJCOxf3qaU2IhcgmvOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7793
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch to using vm_account to charge pinned pages. This will allow a
future change to charge the pinned pages to a cgroup to limit the
overall number of pinned pages in the system.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
Cc: rds-devel@oss.oracle.com
---
 include/linux/skbuff.h |  6 ++---
 include/net/sock.h     |  2 ++-
 net/core/skbuff.c      | 47 +++++++++++++++----------------------------
 net/rds/message.c      |  9 +++++---
 4 files changed, 28 insertions(+), 36 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4c84924..c956405 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -554,7 +554,6 @@ struct ubuf_info_msgzc {
 	};
 
 	struct mmpin {
-		struct user_struct *user;
 		unsigned int num_pg;
 	} mmp;
 };
@@ -563,8 +562,9 @@ struct ubuf_info_msgzc {
 #define uarg_to_msgzc(ubuf_ptr)	container_of((ubuf_ptr), struct ubuf_info_msgzc, \
 					     ubuf)
 
-int mm_account_pinned_pages(struct mmpin *mmp, size_t size);
-void mm_unaccount_pinned_pages(struct mmpin *mmp);
+int mm_account_pinned_pages(struct vm_account *vm_account, struct mmpin *mmp,
+			size_t size);
+void mm_unaccount_pinned_pages(struct vm_account *vm_account, struct mmpin *mmp);
 
 /* This data is invariant across clones and lives at
  * the end of the header data, ie. at skb->end.
diff --git a/include/net/sock.h b/include/net/sock.h
index dcd72e6..bc3a868 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -334,6 +334,7 @@ struct sk_filter;
   *	@sk_security: used by security modules
   *	@sk_mark: generic packet mark
   *	@sk_cgrp_data: cgroup data for this cgroup
+  *	@sk_vm_account: data for pinned memory accounting
   *	@sk_memcg: this socket's memory cgroup association
   *	@sk_write_pending: a write to stream socket waits to start
   *	@sk_state_change: callback to indicate change in the state of the sock
@@ -523,6 +524,7 @@ struct sock {
 	void			*sk_security;
 #endif
 	struct sock_cgroup_data	sk_cgrp_data;
+	struct vm_account       sk_vm_account;
 	struct mem_cgroup	*sk_memcg;
 	void			(*sk_state_change)(struct sock *sk);
 	void			(*sk_data_ready)(struct sock *sk);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 4a0eb55..bed3fc9 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1309,42 +1309,25 @@ struct sk_buff *skb_morph(struct sk_buff *dst, struct sk_buff *src)
 }
 EXPORT_SYMBOL_GPL(skb_morph);
 
-int mm_account_pinned_pages(struct mmpin *mmp, size_t size)
+int mm_account_pinned_pages(struct vm_account *vm_account, struct mmpin *mmp,
+			    size_t size)
 {
-	unsigned long max_pg, num_pg, new_pg, old_pg;
-	struct user_struct *user;
-
-	if (capable(CAP_IPC_LOCK) || !size)
-		return 0;
+	unsigned int num_pg;
 
 	num_pg = (size >> PAGE_SHIFT) + 2;	/* worst case */
-	max_pg = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-	user = mmp->user ? : current_user();
+	if (vm_account_pinned(vm_account, num_pg))
+		return -ENOBUFS;
 
-	old_pg = atomic_long_read(&user->locked_vm);
-	do {
-		new_pg = old_pg + num_pg;
-		if (new_pg > max_pg)
-			return -ENOBUFS;
-	} while (!atomic_long_try_cmpxchg(&user->locked_vm, &old_pg, new_pg));
-
-	if (!mmp->user) {
-		mmp->user = get_uid(user);
-		mmp->num_pg = num_pg;
-	} else {
-		mmp->num_pg += num_pg;
-	}
+	mmp->num_pg += num_pg;
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mm_account_pinned_pages);
 
-void mm_unaccount_pinned_pages(struct mmpin *mmp)
+void mm_unaccount_pinned_pages(struct vm_account *vm_account, struct mmpin *mmp)
 {
-	if (mmp->user) {
-		atomic_long_sub(mmp->num_pg, &mmp->user->locked_vm);
-		free_uid(mmp->user);
-	}
+	vm_unaccount_pinned(vm_account, mmp->num_pg);
+	vm_account_release(vm_account);
 }
 EXPORT_SYMBOL_GPL(mm_unaccount_pinned_pages);
 
@@ -1361,9 +1344,12 @@ static struct ubuf_info *msg_zerocopy_alloc(struct sock *sk, size_t size)
 
 	BUILD_BUG_ON(sizeof(*uarg) > sizeof(skb->cb));
 	uarg = (void *)skb->cb;
-	uarg->mmp.user = NULL;
+	uarg->mmp.num_pg = 0;
+	vm_account_init(&sk->sk_vm_account, current,
+			current_user(), VM_ACCOUNT_USER);
 
-	if (mm_account_pinned_pages(&uarg->mmp, size)) {
+	if (mm_account_pinned_pages(&sk->sk_vm_account, &uarg->mmp, size)) {
+		vm_account_release(&sk->sk_vm_account);
 		kfree_skb(skb);
 		return NULL;
 	}
@@ -1416,7 +1402,8 @@ struct ubuf_info *msg_zerocopy_realloc(struct sock *sk, size_t size,
 
 		next = (u32)atomic_read(&sk->sk_zckey);
 		if ((u32)(uarg_zc->id + uarg_zc->len) == next) {
-			if (mm_account_pinned_pages(&uarg_zc->mmp, size))
+			if (mm_account_pinned_pages(&sk->sk_vm_account,
+						    &uarg_zc->mmp, size))
 				return NULL;
 			uarg_zc->len++;
 			uarg_zc->bytelen = bytelen;
@@ -1466,7 +1453,7 @@ static void __msg_zerocopy_callback(struct ubuf_info_msgzc *uarg)
 	u32 lo, hi;
 	u16 len;
 
-	mm_unaccount_pinned_pages(&uarg->mmp);
+	mm_unaccount_pinned_pages(&sk->sk_vm_account, &uarg->mmp);
 
 	/* if !len, there was only 1 call, and it was aborted
 	 * so do not queue a completion notification
diff --git a/net/rds/message.c b/net/rds/message.c
index b47e4f0..2138a70 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -99,7 +99,7 @@ static void rds_rm_zerocopy_callback(struct rds_sock *rs,
 	struct list_head *head;
 	unsigned long flags;
 
-	mm_unaccount_pinned_pages(&znotif->z_mmp);
+	mm_unaccount_pinned_pages(&rs->rs_sk.sk_vm_account, &znotif->z_mmp);
 	q = &rs->rs_zcookie_queue;
 	spin_lock_irqsave(&q->lock, flags);
 	head = &q->zcookie_head;
@@ -367,6 +367,7 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
 	int ret = 0;
 	int length = iov_iter_count(from);
 	struct rds_msg_zcopy_info *info;
+	struct vm_account *vm_account = &rm->m_rs->rs_sk.sk_vm_account;
 
 	rm->m_inc.i_hdr.h_len = cpu_to_be32(iov_iter_count(from));
 
@@ -380,7 +381,9 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
 		return -ENOMEM;
 	INIT_LIST_HEAD(&info->rs_zcookie_next);
 	rm->data.op_mmp_znotifier = &info->znotif;
-	if (mm_account_pinned_pages(&rm->data.op_mmp_znotifier->z_mmp,
+	vm_account_init(vm_account, current, current_user(), VM_ACCOUNT_USER);
+	if (mm_account_pinned_pages(vm_account,
+				    &rm->data.op_mmp_znotifier->z_mmp,
 				    length)) {
 		ret = -ENOMEM;
 		goto err;
@@ -399,7 +402,7 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
 			for (i = 0; i < rm->data.op_nents; i++)
 				put_page(sg_page(&rm->data.op_sg[i]));
 			mmp = &rm->data.op_mmp_znotifier->z_mmp;
-			mm_unaccount_pinned_pages(mmp);
+			mm_unaccount_pinned_pages(vm_account, mmp);
 			ret = -EFAULT;
 			goto err;
 		}
-- 
git-series 0.9.1
