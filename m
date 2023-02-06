Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B915E68B6C0
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 08:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjBFHuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 02:50:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjBFHuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 02:50:01 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20603.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::603])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED691DB8C;
        Sun,  5 Feb 2023 23:49:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fl0haf409z2GVuUVMTZhi74sVRNd/3eb3P+XKkXnOrz/OZay6AtJ+tlwc1aZhLVpArLa9aEv6XGmL2kHSNcMwyt+TG95tPddfsQYKjHPpki8hvX5nJHMI0SRWQYk0HYIDl5tVq2yKNTTzFGyKmXlNODVjuVz3+ObltL36ZyQhmXQczcaOjDCKjQVydnMHlzEj2nvm3uI5RnIBPEt2D0K+h5xC2bentbNI4CCphhWtQ7112FIsdxQ46MSgEEm3o0iWmd686aof8ngHzfeS8AZGhrqRY1O6c6/a3xfqhNSFJmqJc0mDM9wOw7LxQl+tiuVNqm+r+LdC4dWCQvdxm2fgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ekaPX/00S+h70lFxojvYEzzxngZqMCIdq9dGbDFXgv0=;
 b=BK3OS8gOFEMksJ5VUhjDVC+0VX9SjWKxeKdwBquaqec5ZUx+y7/efgn3BS28Mi6oLOk2KIaEIVrUPXZAhhHJfgOfVbX/hD/pRcWU2zYSIJ5QPgy5Xxd/z1cErKhbtrsLj1glJD+iXd3A0qzkdg9O3XP6yuwMSXCjG7aex+pvBBmYoN8uNFy7e7E0uiOOiUXyoXF08vTnxNOOOopxH5JjpmMk/iHeAdUjuMOW59ncl57U7wTY488D0sGHJx/I5CiPjTWyV1tdIg16qzENQOyS0HVAGHSZS10ISckpLfVCWUQrNDMIs9OXYIJ2htnCq4xqmpC9Axlm8bs93hRI5gblsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ekaPX/00S+h70lFxojvYEzzxngZqMCIdq9dGbDFXgv0=;
 b=dNyGq21XS2lvzTJSJQWV2Dx2hCd50LZlN6ntem5wh+6FJ/wf25TDeGen5qzV/Ru+sSrrRfFfbT2vX0LXlq9OCiuFpBI7KMGEUOyWR6fOXlmu1oVxm+MKYfKxOSs17oG9LlGjoGhF9kxJWb4vSXo/L+2bzdrveRZ7QGe/9BJ6D1ZOXD71dpYeFa9kyJfAUNPBXvBBiuKAoTkCB9TNSundH10vtOke9XV5FGVFHq9TfBBSkuNyXy595aiL5Go9zAK6DAFviaAhBZGTVTWhHUbjkI3iI5WmEX/SU1onOp1pJvG/7mW5f5AdV9KcXE4gbAW5baCMauVktp/tKI5dQecLUQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by DS0PR12MB8573.namprd12.prod.outlook.com (2603:10b6:8:162::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Mon, 6 Feb
 2023 07:49:27 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::4bd4:de67:b676:67df]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::4bd4:de67:b676:67df%6]) with mapi id 15.20.6064.032; Mon, 6 Feb 2023
 07:49:27 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     linux-mm@kvack.org, cgroups@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jgg@nvidia.com, jhubbard@nvidia.com,
        tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com,
        mkoutny@suse.com, daniel@ffwll.ch,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alistair Popple <apopple@nvidia.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 11/19] xdp: convert to use vm_account
Date:   Mon,  6 Feb 2023 18:47:48 +1100
Message-Id: <f3b11743f170f4750efa58eba61843563a4b7926.1675669136.git-series.apopple@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SYAPR01CA0006.ausprd01.prod.outlook.com (2603:10c6:1::18)
 To BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|DS0PR12MB8573:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e499f2e-8b0b-4fff-206e-08db0816ac13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U/Hb5bUvPgq/8Bo/zhdDbA4PUQM4ddPIcEFNo7CVj8XX4kbiyc/wkH3Kp1WtHKJMiUG5tR1bYnYSI76gmFHStENAOhqNWW3CXT7bQp6RTqgIEtBpq2hsclqS4KNds1lKhU9c+UnZfOlsJMqDte4FbavG2LRznoGOMIVDtpg9TUojH0btY4kRvyAKcl8enew/vHUNWuEPfUx700I1hHO6teXAPLBXayByqXmuvl1AfcSNaVhLiqbOM+vREwqQEFDAEkqQfTZ7/7U/i6CzV/zDWLKrSZOnahP/PmyinY/kap4pNBnXyi+BCkzGfDfIdDW0XlFcqhSrSubdBDMw5kwQoOhB57LDCDevnsz1+B/xtgk56PDdP4Mxs6Q/o4Zkodw6uThm6TaB6wsN06uBi68F3vUs3Drq40ujckInxTegARQVlbHQ/LegvaWh43lulz+YE7Wy9n9lT6FvIWL7OoYadIzAPPnORUJJRRo1IGAcmzWVfYOQsLyELfGfdSlToN6X7uM46Z9LFTtLL9PFLYnYg2nvm9VJ2p0M/q69vpOc0O6qq4KhQxyvT71NJIC6t9VAQi4aFIfaqIkwVxqiOLYEEhRBpVDR3TkDb7hEJLkVzruSCx69/o0TIZzAbciD9oMN39mkfXEOyrH7vdOChdS+hQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(136003)(39860400002)(366004)(346002)(451199018)(54906003)(316002)(86362001)(6666004)(6486002)(38100700002)(186003)(2616005)(6506007)(26005)(478600001)(6512007)(7416002)(5660300002)(83380400001)(66574015)(2906002)(36756003)(66946007)(8936002)(4326008)(41300700001)(66476007)(8676002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RDd1eHNyTlNkNGdkanhqWFIzOUV2K2ZCVXY4OHhJZEcrL3Z3NmhRRjREZGlM?=
 =?utf-8?B?NWkwTjFTV2FQU3R5eUhqcmxqeGt4eE41UGhWd2lhcklod24xUFlmaE5zazRF?=
 =?utf-8?B?czZ2eGI5cXZ6MDhOQlJBaWJQQWdvSDVvWXROTGc1L1U4RHB3cTZNcWovOWNQ?=
 =?utf-8?B?M0F0aTZLMkt3VUIxOXg4ZUNmSU5ZOXVEREo1UWo3OVRjcTNVVGRWM1YwWTB5?=
 =?utf-8?B?aS93R0grUTAyTzM4ZDZVeXd0TmI3cVhhSDBLMi9pWjgzc3U2aHdPV2lGYU5s?=
 =?utf-8?B?OEZIUmpBci9pNkdvY0RYblRPMWMyejNQSHo0SDZtY2FOcDczcmxGamNWc2JE?=
 =?utf-8?B?alRxYWVxSS90dkhjTDFFTzRtMi9ReW5jcEEvNG01Lyt0enh0RW9vb01WTnJP?=
 =?utf-8?B?U2JUK1YrOGlVR3E3UC8rc3N3M1o1RE9QeEFwZ3lJNXZ1d1RSbkNBWmhPSURs?=
 =?utf-8?B?SmZIb2NQMnZsS1RtOEVLa1V0cFFvVFJBbWNMT2IyLzFtWmVRNGMzbVc2dWVl?=
 =?utf-8?B?UzBTMFl6anI3RVIxRndGRDRjcFFQekIrMEYvMjNnYVNqeHVrZzJTUDV0R0cx?=
 =?utf-8?B?MXJ2OTUyeUhaRUc4OFlNZE12ek5QdkwrSERYS1VESzI2dW5wcDZCby9aYkZu?=
 =?utf-8?B?bVlGK0dXTmtoVnRRUlQwRU9adGZDNm9qcXBtd0REYzJmWDFhUVhJd1BaVGQx?=
 =?utf-8?B?VmVnVTBpdmRIeWR3cUlObmpsM2FUSSt2VVFaZWZ4ZFZpdVk5SUdLS1JBZllu?=
 =?utf-8?B?Y0hkcktYY01UVGJrckZRT25PWjViNy8yRzJveUhlcnpvNkUrRUZGVW03UzZm?=
 =?utf-8?B?bTBGNkhOTGN0MWZmQVdiT09CV2JSeVBoL0p0WGdJazNTWFJ0QXJJenE0Zjlq?=
 =?utf-8?B?c0s1R0NaTmhBWUozQmtCL3MwWFdRZVdjS0QyNXZOaXlMOTFQdUJVVmlKcVFX?=
 =?utf-8?B?dG1YNWtGUjB5SlVwVVpBV053K2thS1IxQXEwNmZwK1NZRjJsMkg5R1J6ajM5?=
 =?utf-8?B?bWFPYXNRUktud1JPRHpSSmxuK1Z6SXpFcVRNZHAvcDdDd0c2SFNWbGpGdTFD?=
 =?utf-8?B?STlTbGxvSmc4elptVXlBYmhKeHNraGJRYjVzYTRNdGFyMnU2RzFxN09yLzZU?=
 =?utf-8?B?QU5neDlySldpeDU5UWZzdkVYbUNIQ21sd3NXYXh6T2ZleHd6SnE2bmwrY0VF?=
 =?utf-8?B?SEoxYkFtVmNheDJGSnM4SFBnWGczcjlza3RTMU5WQlgzTDZNazdGTkViUmE3?=
 =?utf-8?B?M1pTSFdMOGVRT0FFVU5tTVlNcjdJb2s0Wm0xamE5Uk1qMFVvUmZrUFYwUDQz?=
 =?utf-8?B?REdSUytWVVllMHVkMjgyL3RUK0VPMFV5SUVwZzhPVEdYUDVhazl4NURJRGg1?=
 =?utf-8?B?cU83bDJSMHo1WjF3bzNUek1xUHRIWDd1SjZQM2tlMkswR1U5ZHg1bWVhNjZZ?=
 =?utf-8?B?REpLYjBXQzJjV0V2VmxIRDJ4U0IzZTE5Mk4vOURYMU1MOGJJVzRFdG1DNytm?=
 =?utf-8?B?YjkzS055bllSV2MyWFJSSm5ieXQzM3plZEZZU3k0ZXVZY1lBREJyTnBJcXJl?=
 =?utf-8?B?UnQ1ODRnc0w5ZlZoeEFZbUFrMkYzSWYzOHFIODM2d3Z2V0duNlhobGRCQUdC?=
 =?utf-8?B?b2ZGQ1JISlNhTUx6VERoS015YUp3OGc0cFpoTmE3eHo0SkF4Um15c2Fxb1Jn?=
 =?utf-8?B?VkxsSmRaSEgwSi9PYzNod2wyQXcyb0hsbzhXWWdxdHpHSjhvUFNiRHNvRU9U?=
 =?utf-8?B?ekRSOTlSSVZyZzBTYlZhNVI2VWRXSmZkdlNuUGphcHRsQUxqSGtKYWNoMzBJ?=
 =?utf-8?B?RjUwNG0zeVdxN0F6STZ0UHhYb2k0T3ZvV2ZGV2txU1RIdHNubzQzZXJOLy9W?=
 =?utf-8?B?U3VsYkhxK3Z6L1NvaHMzRXRWTW9GVEpGdEpEWVUycW5PRmdwMGpicGNMV2ZO?=
 =?utf-8?B?MjdxUkJNTFdrRE9uU2xBUGtjNlM5RE01TmFTeTYwTnJXaXhPSDY3Z3VIbm1B?=
 =?utf-8?B?RkhBUmZWZkFwcUQ3M0RDRm1PN09Pb2FESFZiR0t4ZGJCNGUvcVk0ejRIa2hk?=
 =?utf-8?B?eXpOV29SL3hwV2t4SEM3bTlmcFBxRkZxZXJRbmhQVWVadzgwZy9oZjZ3Z0dJ?=
 =?utf-8?Q?6cCAygo0RZv6icGB6AIAhNoyY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e499f2e-8b0b-4fff-206e-08db0816ac13
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 07:49:27.3700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XJm4eb5u09y5J03JJHgvgQg5AfLScdpIxX+UezKBxSPaIYMXVvTqX7hlUQm5cMjyyZJZmClUqbaQCKoadT1diw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8573
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch to using the new vm_account struct to charge pinned pages and
enforce the rlimit. This will allow a future change to also charge a
cgroup for limiting the number of pinned pages.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: "Björn Töpel" <bjorn@kernel.org>
Cc: Magnus Karlsson <magnus.karlsson@intel.com>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: Jonathan Lemon <jonathan.lemon@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: netdev@vger.kernel.org
Cc: bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 include/net/xdp_sock.h |  3 ++-
 net/xdp/xdp_umem.c     | 38 +++++++++++++-------------------------
 2 files changed, 15 insertions(+), 26 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 3057e1a..9a21054 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -12,6 +12,7 @@
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/mm.h>
+#include <linux/vm_account.h>
 #include <net/sock.h>
 
 struct net_device;
@@ -25,7 +26,7 @@ struct xdp_umem {
 	u32 chunk_size;
 	u32 chunks;
 	u32 npgs;
-	struct user_struct *user;
+	struct vm_account vm_account;
 	refcount_t users;
 	u8 flags;
 	bool zc;
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 4681e8e..4b5fb2f 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -29,12 +29,10 @@ static void xdp_umem_unpin_pages(struct xdp_umem *umem)
 	umem->pgs = NULL;
 }
 
-static void xdp_umem_unaccount_pages(struct xdp_umem *umem)
+static void xdp_umem_unaccount_pages(struct xdp_umem *umem, u32 npgs)
 {
-	if (umem->user) {
-		atomic_long_sub(umem->npgs, &umem->user->locked_vm);
-		free_uid(umem->user);
-	}
+	vm_unaccount_pinned(&umem->vm_account, npgs);
+	vm_account_release(&umem->vm_account);
 }
 
 static void xdp_umem_addr_unmap(struct xdp_umem *umem)
@@ -54,13 +52,15 @@ static int xdp_umem_addr_map(struct xdp_umem *umem, struct page **pages,
 
 static void xdp_umem_release(struct xdp_umem *umem)
 {
+	u32 npgs = umem->npgs;
+
 	umem->zc = false;
 	ida_free(&umem_ida, umem->id);
 
 	xdp_umem_addr_unmap(umem);
 	xdp_umem_unpin_pages(umem);
 
-	xdp_umem_unaccount_pages(umem);
+	xdp_umem_unaccount_pages(umem, npgs);
 	kfree(umem);
 }
 
@@ -127,24 +127,13 @@ static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
 
 static int xdp_umem_account_pages(struct xdp_umem *umem)
 {
-	unsigned long lock_limit, new_npgs, old_npgs;
-
-	if (capable(CAP_IPC_LOCK))
-		return 0;
-
-	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-	umem->user = get_uid(current_user());
+	vm_account_init(&umem->vm_account, current,
+			current_user(), VM_ACCOUNT_USER);
+	if (vm_account_pinned(&umem->vm_account, umem->npgs)) {
+		vm_account_release(&umem->vm_account);
+		return -ENOBUFS;
+	}
 
-	do {
-		old_npgs = atomic_long_read(&umem->user->locked_vm);
-		new_npgs = old_npgs + umem->npgs;
-		if (new_npgs > lock_limit) {
-			free_uid(umem->user);
-			umem->user = NULL;
-			return -ENOBUFS;
-		}
-	} while (atomic_long_cmpxchg(&umem->user->locked_vm, old_npgs,
-				     new_npgs) != old_npgs);
 	return 0;
 }
 
@@ -204,7 +193,6 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	umem->chunks = chunks;
 	umem->npgs = (u32)npgs;
 	umem->pgs = NULL;
-	umem->user = NULL;
 	umem->flags = mr->flags;
 
 	INIT_LIST_HEAD(&umem->xsk_dma_list);
@@ -227,7 +215,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 out_unpin:
 	xdp_umem_unpin_pages(umem);
 out_account:
-	xdp_umem_unaccount_pages(umem);
+	xdp_umem_unaccount_pages(umem, npgs);
 	return err;
 }
 
-- 
git-series 0.9.1
