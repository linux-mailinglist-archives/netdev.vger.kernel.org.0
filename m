Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0EC68B6CF
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 08:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbjBFHu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 02:50:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbjBFHuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 02:50:51 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2054.outbound.protection.outlook.com [40.107.223.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC921D90C;
        Sun,  5 Feb 2023 23:50:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N9bc9Rni+JvKnGuBzzNjA3HFQdH8BUD73poGipHQPVvXZk8lqhD5m5xluB82xR1ZYPlLFMMcA/XJIRBbC8IXGIDSKNVea+O+Fzii0g30tNJ3O2S4AmzxOEqW3D2Qvuon+MQVlLn7GyTXVSEfFbYsTHlDJuK1Hh6wJkvfzT3p562S43cw8vxf8oasBS4ixhxYXtmK59OEPclkXB8Mi/sY/ZofOuTGX3w5Obb8kh8yf7/SzYGIcxkB4vPovi+3a7nO8oyAqS6w8L7ZCB9708bLY1RCvTO+b/TwDEY7p5mrK76AkDmB4Tv6uTExcL3gYbtjyaIsaeoD4aj9Gzx8TKXt3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CYW4u4ayE2LZHX01iQfnpEcejDU0yOEhVudNlOUAn3Q=;
 b=KxpDdjzItMs7oMHnWxbFIbAiMDe//rfEgzw8Xx4uyE41tMhzwhGMc9WU4LSAvslw0x8f0uk0OFbxX2nv/Sw06BUWw1caobMo/yoVYiRhlH6HGYkzUwLy8g/qM6N5PcvasVmOrSp9ZPccZ9o0vI2mOxly+cvdsvq7uhA5PVZKkIEYzof55ofQxwt412MqxWjBKo3LnWmWsKK+phwGkyLhLdO9KT0UEjmGBGS0Rms7C+fURopd0z3Yi/4TjAmsWJX87X2CdWD8XUJJMxH0EkLPHeqOpe7bwIx5mfbz2gf0xZD1Pr8FLFxprpMCRBMBvIRkxVLTCKLm5rlGTgs8jbSMtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CYW4u4ayE2LZHX01iQfnpEcejDU0yOEhVudNlOUAn3Q=;
 b=LCGOkAUcbw0vOxMEIqkDhbrUyi+Q/QrFLfm8WDWZwttEqb6SGC6ytVojDYGQ3W8mMwzlLiMgJMgSnx7+zNvr2LQEVYWRea3af/eSAGZaYBm8XzYgewKMCKiq4zxplUG3zXxw671Q60xeqaEtCiKb8tpwKOhM5UdGv6OXJ9hczT+M3xm4a21xSkGcU8nGENwG9zuRr0h/SAFp2kCyXV9veXiWao7bXHNqUZXFR9Wzh29VahK6lyIG+GmV2adHPhQQ+mei1crxC3ZXczm/kChnd/igJYJxz3yWKrpKcjzz4EPYAw9JvWxNelIov5X8e2T6DgBJVaiRUgFG7UANPuk7dw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by DS0PR12MB8573.namprd12.prod.outlook.com (2603:10b6:8:162::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Mon, 6 Feb
 2023 07:49:21 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::4bd4:de67:b676:67df]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::4bd4:de67:b676:67df%6]) with mapi id 15.20.6064.032; Mon, 6 Feb 2023
 07:49:20 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     linux-mm@kvack.org, cgroups@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jgg@nvidia.com, jhubbard@nvidia.com,
        tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com,
        mkoutny@suse.com, daniel@ffwll.ch,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alistair Popple <apopple@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Subject: [PATCH 10/19] net: skb: Switch to using vm_account
Date:   Mon,  6 Feb 2023 18:47:47 +1100
Message-Id: <60a51160809d14e3e4a1c681cd71e37ab303adb8.1675669136.git-series.apopple@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY5PR01CA0054.ausprd01.prod.outlook.com
 (2603:10c6:10:1fc::20) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|DS0PR12MB8573:EE_
X-MS-Office365-Filtering-Correlation-Id: 691012f9-8863-4506-9d29-08db0816a82e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xFfTjdXiD80AhU3nEngcc8g/lI3dcbeLVrSsnPMuN+fKt+EWkUDZSnio4VD5lBMIAuch6KJGUCWhOCGe97jmA4HFkA3G84zc7kOnJNo+4MLzmGCFKWZ58ld4u3ICGWJQz7E1OldMsI+Qkp4M0PUdPdY0XQctSnshwjc4Jh+DUFBvgFH+PybQOVEfBxHsKNJeWXOAK/c+8PqVrdvLNe4fb+rKjQWGawqPelgzvC8OcK88/6ZHU/RuMY5A6sb0Y3NTIxR2BENvqGg45YO4MyJgUR5pM5KB2DjSMMGNEh9GkBigxsWeRB/bequ4IIQx/LqXDxn33Oep8MGwlayGJKUN6I2Y+XmHh4tav/jy5WHFLO6H9ONAUem8VosBR63H1yAAZ/gTM+l8YEWVGnkMEN5xFaSklhZuzCwvGCE1hX1xBFWKBTMSWT8xhEji+40hdE7deebHd8hIAx9UGKslTsLOD/ropcmE6fU1gTdHIdjP54TH+bzIs+HNp29TlV+IUKyDgyjs1sld85lCV7/oy9AGHl1i651Vv2m0r3khm+xBwtzUCkLTG+sSEu/7vsvRSDbThcqMQTxrKkNw7uF//O+sdboeot1AKmC2gDR2aGH8JIw0TBdRKPXyoyfU+LbDFM5QjfCZPMny+mzgBEOiEUg7xw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(136003)(39860400002)(366004)(346002)(451199018)(54906003)(316002)(86362001)(6666004)(6486002)(38100700002)(186003)(2616005)(6506007)(26005)(478600001)(6512007)(7416002)(5660300002)(83380400001)(2906002)(36756003)(66946007)(8936002)(4326008)(41300700001)(66476007)(8676002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HfySn4qGwrHdAGcR9NI3HHGKHYCbb8+FZraSoTtJ41bryVQNnyttKxXVHU+3?=
 =?us-ascii?Q?2ojDted1A2fFyVPNEGqoAhxdnAB+J0ZjKD2qn042Bt60Mg4QqsxbSQLaEcj2?=
 =?us-ascii?Q?LoNbEJHvpvOzCXiuNZ17/vUQQkoudgNqoypgvnHU7Jfm+ZKm5YfU7xmaCTkH?=
 =?us-ascii?Q?elHzSnHYcJ/3n2x0SySAStQrusifTU3GZ0mxsYgyCaPn4CDQI/hvZligYWwo?=
 =?us-ascii?Q?hJexh0AjvZ8u/VAOjKburqaoZclhK+QoC/FdYHk9ApNob4C5RPJz21mx/r12?=
 =?us-ascii?Q?JAd7dwc+Ks1QWECAcGxnNSASPbO4JsKFD9ZFwHBOddRWq6FZliqGkqoUYPHU?=
 =?us-ascii?Q?lDNJDrAzr5S/8H0JNp4RuHp4e3plu+7dH5+yAUAIKkiMdyyM1n7f2cDi/iLf?=
 =?us-ascii?Q?+1sTFu/g+71qZ2aWBRFZQFZNlLXqfplApfT/QwF3FzLcKKtMeuflej8h/Pm2?=
 =?us-ascii?Q?wIkMXLFhwbcu/Vj4CeL9wFfUcVmu9JtnnbWI9JkYNglMvP403q+JB8AFkMPp?=
 =?us-ascii?Q?Tjb+YP6Z4c05x1B0fSdz+JvPGIm8kDHfXCbuRqZBdcPQm7joEcghy8YWUbHV?=
 =?us-ascii?Q?A5kHCi+Zhf5l6OJC3J4InvaGpoAHbboDmvMBgxt2Unz8Tqkzbv4FjWDm2qAa?=
 =?us-ascii?Q?jyAM0atSvgpx5nI9Lqv8RI0gsdqyJIVe9Gp290GXZasucrYdOQgEb3WikjEw?=
 =?us-ascii?Q?S+4r2OhyT3L5lU592zbk+kf3H7J1rpojfwZC78FBtDo2kmkVkS8ZgguQBgpY?=
 =?us-ascii?Q?Y0JYTheuAGeO+knzPQBHdHR04gDI+bKsKBaTixeUh7+6D3cdgtxxO0mbZQMP?=
 =?us-ascii?Q?HMpAqXHcNjNYcXk0rFlABhDJ20rD/YSdQ0IPAc7C5iKr9LuLKrKAoKXBNBda?=
 =?us-ascii?Q?a/Z1FgC7PHpWPvCRnd2FudRBU/tAKN768c8Sx9D2+9fLTJukfahYnq0w8kbq?=
 =?us-ascii?Q?wzBAqMIfkNyTMOD+qad00i1nK+FXXa+ZgendkomXTAaVnDVb5NIT3TiA59U6?=
 =?us-ascii?Q?nAFGCtmZeiECIHXVwrz53higNp3ExZo/LD91upJyyru3h5il3StfoSfL9Uf3?=
 =?us-ascii?Q?QbWoMVoMvcK/WvQu93nymozXUrh5Y87oenl1sxFO5JpYGZ4eao2yzaC9lCR3?=
 =?us-ascii?Q?hbaVtwi9EZ6WVvPcE6mkLC/E4xQ8tdTtYKOOnG0feJwuV8FfmWyl/ztSBy/t?=
 =?us-ascii?Q?nOZS0+6Nk2guzAswhZyzCKZKu6rp3/msB3GCceYnlKuxUODxmzf5yyABMDNJ?=
 =?us-ascii?Q?OF6Jsh8fM7d8n7Mo9dWcoyC3dvIatLEYziKUN0oI+7cHcYOPHCPwVdR4Gctl?=
 =?us-ascii?Q?QGQ0XA4Jd4JMInxFGRTXH8gWeo3U1Is8HWkniMwMLTyfVDp/B4puew5UKe5N?=
 =?us-ascii?Q?AgDa4GIoBJHM5mdm8RpoAlnepw3lENFQQpVUCe/92S7MJdj9nkZ/g86a3Ybi?=
 =?us-ascii?Q?VXbzZl1wyioWtBBOHSolbOEpgAs+AOvelqCk+ysmyEeVxY0EuO0hfIYWT1GJ?=
 =?us-ascii?Q?RVt0JVVT+qsqNlxGU0zCCt3d/3SVqQif1nGZo22fUDjJf6eSLJ5lRvVlteDh?=
 =?us-ascii?Q?d6q3gmcaPQrKOTvMdfsP55vduCCcBo5M72Zfy1Hb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 691012f9-8863-4506-9d29-08db0816a82e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 07:49:20.8549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dpb1f26IarNDW8rGdBUOwWkregUlG126Mwd8oOA6dUNXCiRaJC2iJ1ljjSQMDKqz02PWIBAGu0RngiLg8yUHaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8573
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
 include/linux/skbuff.h |  7 +++---
 include/net/sock.h     |  3 +++-
 net/core/skbuff.c      | 47 +++++++++++++++----------------------------
 net/rds/message.c      | 10 ++++++---
 4 files changed, 31 insertions(+), 36 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4c84924..14f29a0 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -37,6 +37,7 @@
 #include <linux/in6.h>
 #include <linux/if_packet.h>
 #include <linux/llist.h>
+#include <linux/vm_account.h>
 #include <net/flow.h>
 #include <net/page_pool.h>
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
@@ -554,7 +555,6 @@ struct ubuf_info_msgzc {
 	};
 
 	struct mmpin {
-		struct user_struct *user;
 		unsigned int num_pg;
 	} mmp;
 };
@@ -563,8 +563,9 @@ struct ubuf_info_msgzc {
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
index dcd72e6..0e756d3 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -63,6 +63,7 @@
 #include <linux/atomic.h>
 #include <linux/refcount.h>
 #include <linux/llist.h>
+#include <linux/vm_account.h>
 #include <net/dst.h>
 #include <net/checksum.h>
 #include <net/tcp_states.h>
@@ -334,6 +335,7 @@ struct sk_filter;
   *	@sk_security: used by security modules
   *	@sk_mark: generic packet mark
   *	@sk_cgrp_data: cgroup data for this cgroup
+  *	@sk_vm_account: data for pinned memory accounting
   *	@sk_memcg: this socket's memory cgroup association
   *	@sk_write_pending: a write to stream socket waits to start
   *	@sk_state_change: callback to indicate change in the state of the sock
@@ -523,6 +525,7 @@ struct sock {
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
index b47e4f0..4595540 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -35,6 +35,7 @@
 #include <linux/export.h>
 #include <linux/skbuff.h>
 #include <linux/list.h>
+#include <linux/vm_account.h>
 #include <linux/errqueue.h>
 
 #include "rds.h"
@@ -99,7 +100,7 @@ static void rds_rm_zerocopy_callback(struct rds_sock *rs,
 	struct list_head *head;
 	unsigned long flags;
 
-	mm_unaccount_pinned_pages(&znotif->z_mmp);
+	mm_unaccount_pinned_pages(&rs->rs_sk.sk_vm_account, &znotif->z_mmp);
 	q = &rs->rs_zcookie_queue;
 	spin_lock_irqsave(&q->lock, flags);
 	head = &q->zcookie_head;
@@ -367,6 +368,7 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
 	int ret = 0;
 	int length = iov_iter_count(from);
 	struct rds_msg_zcopy_info *info;
+	struct vm_account *vm_account = &rm->m_rs->rs_sk.sk_vm_account;
 
 	rm->m_inc.i_hdr.h_len = cpu_to_be32(iov_iter_count(from));
 
@@ -380,7 +382,9 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
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
@@ -399,7 +403,7 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
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
