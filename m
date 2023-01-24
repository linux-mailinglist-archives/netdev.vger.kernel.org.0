Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2DD7679044
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 06:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbjAXFqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 00:46:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232967AbjAXFqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 00:46:33 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on20607.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8d::607])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C0FE3BD8D;
        Mon, 23 Jan 2023 21:46:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AjVytcuDJkM/FLk3R8BjbHpvTcr7TGho/0IVTECkIQV7ws4n5jkzi0QArse93uAxRASpSMj+muQ1YpjhpTNkuOzVi/Zm7zPDCWATItTCDw1wFEGbPURqJgHDnSd0Rc+FN0poclOjqdOit7wBP/M25ddWmto6a/KmJUHwhc/pmHepWiWjvrpFsvxWiO8mFY3hNsTbjJtgvSQHOgPBHVZFO704w820TyDx6jgcFraq/qOYau41uNm2PyYaPh/YVOyJCRwz7dHjy2+/BTy3ACmLKQUNYqgwNs2CDUVHl51sR7IgrKF1hKSkl5rnBZi7hfPQbeN9jMukENhxS7FPZLCsVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0W0p5nkXQyU1aX2kot2Ea5g7JV+lHiVX0c1iGBFb/bs=;
 b=OEgH1/4ExlDB1ARjKQQZlzDPJ5XLoJhcwkWk7U7lWF9NKXSElVLozOyvFx8X28kCePcut4zphfJOvCmNq6trkwixvINvM3ipIHQZRbWRCAA5kzWUXX2/lLfR2L5IwUFlWDwrvqijm37eBAOr94FSiixahzuGKrBdkLjLgseersArWWEYHgyTafL7hNMLMFNJ+zDs2TalDPEoKlMactVcDbFZ4Lw13Ao3PjBT5cYEOZQHNJZyHvI6Z1pPF6DL8pGde62y8nvUbNrcYV0N3ZYQbKJx7Z8Pcvgj90ANN3a3WKiW6B8hK8T+48o2vjDhfPXjNzXHYfG0NA5nJiTgr3EYbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0W0p5nkXQyU1aX2kot2Ea5g7JV+lHiVX0c1iGBFb/bs=;
 b=RjSfZx+dfCzyTOWStKMBo05C3rq/ufLUyctmeYXAYJItlL2INf+LVq9u6BKViV5Q3L6REIxgjzJczv8zHROXTFliHUucL1VYy9lXD8V7A3cZwr3xjyhETc+bpnfPZt9dqD+NtE3sYCijNGZ3XwQlckkcjObSr0E3MXvYVBSnfw+iATTAlNpIX427NYo764b9230nPCtuXSN/xx+4vP2i2RDvRZnQzkh6Tq3o/IWibw7jrKzAca07SqadlRMfegDPNx4ijtPbh9EzUdwUUMsLgFsJGdFfqloCfkSs5t/nR/hEkTXlgR0vxjGQUTeil6EJJb2ayQKhAX6x+uPAo6supw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by PH7PR12MB7793.namprd12.prod.outlook.com (2603:10b6:510:270::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 05:45:38 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::465a:6564:6198:2f4e]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::465a:6564:6198:2f4e%4]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 05:45:38 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     linux-mm@kvack.org, cgroups@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jgg@nvidia.com, jhubbard@nvidia.com,
        tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com,
        mkoutny@suse.com, daniel@ffwll.ch,
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
Subject: [RFC PATCH 11/19] xdp: convert to use vm_account
Date:   Tue, 24 Jan 2023 16:42:40 +1100
Message-Id: <a046a01293b0aa31592fb6dea1839009f037a49d.1674538665.git-series.apopple@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SYBPR01CA0058.ausprd01.prod.outlook.com
 (2603:10c6:10:2::22) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|PH7PR12MB7793:EE_
X-MS-Office365-Filtering-Correlation-Id: cf49a282-9822-42ab-b0c7-08dafdce382a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: swlTuo9A26qSmZr/qtf5eeHLVNj1itmA/M8Xyd8AkfRqZUC0/zMPXU6/b50hqyh+VxqX0Z+l9ce2YK04WGI6LfXNmwW7KHPD8RMvsCksOp4emgSGy8VbTAMzvG/Rchbbn2aRUlsBcDxX5Ag2T6XPdihZje97ykN8m5j79DVnDlq8ZdStbNt82GR6C0v8oXN2VwkSpPKEZeH/WP5Vo6b2B0h5ggzaOjutL+hMaCOwuLja9i3GaYayqcnN1gaIsWitahQt60lTFS5qoO6kxqKFnaeZiAxlhHHxH+Yc7NZDnFWpRDZBS4b/yEVRqEbKJ9Hyvi88iOI6fDMwssiX5ybXU+Ojl4HVkiIhIovvpX7HElo3reRfPF6zt9ioQIOL8dm8yhBWhduokLVvAtiuHy2e8/VEQqEcv4IKnmoniSZH1SMcoaPlMdrMwySKma+iCjNApb8TnfLzMA+IpZTugVxSaHbFF5kbKKHL1fRKBzeWC2aljnDYHSjWp8+i1Ajo52nFATl/YRxJ3LJyITbp8QVUleqEGQq1tCxZTtnH+FS8SZ4NEe8gMQFRo894bJ3hSPVMzDEW6V5C+oR6ZQFu2cdvJZFy+yvGgvbV4PxHY51YMSmlypnPV3BMKYaTs0aKJliSWcMFX7sW7h+kE8xbg1ebsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(451199015)(36756003)(316002)(4326008)(66556008)(66476007)(8676002)(86362001)(66946007)(186003)(54906003)(26005)(6512007)(6506007)(6666004)(83380400001)(6486002)(478600001)(2616005)(7416002)(66574015)(5660300002)(8936002)(41300700001)(2906002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NmRuaHVtdVNMYUhOdGN4L0c5bFFkRTlQc2x0MWVJYUhzMzljazR1QkdlZnJ2?=
 =?utf-8?B?cFB6Wld5OVRNL09EWVUreWIrMG0vT2tWaVRCZnVIOWFLc01ib01PQUx3ZVNY?=
 =?utf-8?B?cnBCdERhUlN0U3JlUkZOMEZDc1ZOYnl4cDBRZHJIWmF4VDJHVG5yajBmNlNI?=
 =?utf-8?B?Z1lraDhoV3NyU0VOeXV0V2p5eXJsVzZBS1NidFBhODFIZlJtNUFSekpTRFpO?=
 =?utf-8?B?VDF6NE94alJDbWdVakxpNlZySUFaR3F4VElnb0l2ZHkwTTNYY1k2cUVINE5Z?=
 =?utf-8?B?VGZhM3ZBTitUbXkxZ3FpM2xmUXZJMjF2UUhsZzRzUDh5Ukgzb3dzRG53dVVM?=
 =?utf-8?B?NE1GZ29hbExWcEVYdWpQSDZYb0ZzZzFDL1k1ZDdlaFNGQlNxeEk2cXNBckVr?=
 =?utf-8?B?YjhsRXBRTndBWStDb2pzZ0FJRzluejVLMXlKSktvbDBVcHIvYVlsd2xBT0Fj?=
 =?utf-8?B?TnJZMllwNE0weFpHTEI3RU5kOUNWRVd6b3VrNVFJSmptcGRFVytrVmdGZWI4?=
 =?utf-8?B?RXV4ZXlzOGxIYnI1bDVkZGd0L3ZHV2xEdnBocjU0cjJ4ZGRhdDBzbWNCWkxs?=
 =?utf-8?B?dlptTG9sdkFNM0Y3ZTlVcHhhVjFrbTdpTDl1dDU0V041ZDlYcERjSFNJSHNy?=
 =?utf-8?B?K1oxbWxhNVAwMkExaWMwNWV3d0JUWlVIU1QxQlJpRFhLMCt4c2IrRWtFQnl6?=
 =?utf-8?B?YnZiYkFjL3JmUmdGbFQ1dUdjS0tIZHg3N3Bnc3pTS0Z2V21nV0hYZ0FrWDhz?=
 =?utf-8?B?dEVSUytxWTQ5cWtsWC9HWXhOUU54R25PVUo2cWRoSTVSVHNxcXo5ekJidWFj?=
 =?utf-8?B?K0ZZMUsrZTRxM3pTcUN0SXpQUjhGanRIdzFPcEFaRllTem1Ya3NrazNvT1Jx?=
 =?utf-8?B?ZWpoVjFtLy82cXpvRGRoZklaNENmVjVXTkFGNDF3NEtEalRYd1VwcDh2NDVt?=
 =?utf-8?B?WlJsYmNqMHZmSjFGNkpsd3ZOT0VWZTl1YVQwWnRYQkNjaFBOZmR0MU9VdmJ4?=
 =?utf-8?B?cmlRT0hNOXF1TlBXSFdJOE9BdE4vNkNFVjA1NkRlSkxnVWlhR09MdnJBL1BU?=
 =?utf-8?B?Nlh6NXhFVHlyY0o0OEx0dVY3WUdzR1hGcFl3cFZEMytIczBWUjBqTDRHV3VX?=
 =?utf-8?B?RXcreEs1M3hiSzd3cGExbkQ0QTgrOExOOEtpZzB3RVdkRE5SSTQ5MVFsUDNF?=
 =?utf-8?B?Qi9mSFBuaTVISFFKYmh5Y2F1YlErcy9HVk1qbVg5dGhxOGh6aGRwcDlTTS82?=
 =?utf-8?B?MnNnc3hUd0RpdW9qaHRMYlNTUk52ak5DLzJyZldoOVNSd09xY0YwdnNkYmpM?=
 =?utf-8?B?dWtveUV3Z1d4OXc3SDdhSkZYQlRldzNRYVNTbm50VFIwMmMveW1aSmhOMWhZ?=
 =?utf-8?B?RUtGaCtKaDFIV3A5SGZHN2twK1U3NXdYalhLazArUjh5SzNPd3M0U2NWSlh0?=
 =?utf-8?B?VzZ0RnBwbkxqSTZQUFRlcmVFU2pVRXQzSWxFTzJUaWpQK1loRWw2QkFXZXl5?=
 =?utf-8?B?SHlnYmkyRGh6RlhVbVJTZitMNHRFcElXam5FRzlackxObTZDWGI3YkxvTFZx?=
 =?utf-8?B?L09kZHBDYlNHNEhIaCtWZGFUekViY2FQNzJENVJoZzhGTUFiM0JyTTdkT2RT?=
 =?utf-8?B?eit2a2VkRlN2dHZVNUZVYUEwNGNJcGxzQlAzWGxBb1BNaStuMlZhTXJiL0JL?=
 =?utf-8?B?cEZLMURMZlYvbnI1L0xyMmVDMElqNlMvYVV6bWFIVWRqUVJ0cjlVUkhEV25X?=
 =?utf-8?B?YnRTQjhhcjZwbXFrRU42OGRwdUpJeWJmL1pOV3FwSFBYOHcrbXlSQ292a2tn?=
 =?utf-8?B?NWpRVTFwNnJLUkRBNjlvdUl4QWwxc0VqWk5Pd212UG1HejJDRUJVZmFGdVZ0?=
 =?utf-8?B?WGdmOTZUVWMxSUZwdEcybTN5MlRZUXVnVjJEMnF4NFNtSXl2d1hseGljMVJK?=
 =?utf-8?B?YnJER1czcTlnMmNPV21lc1J1UThRcmU0Z2tlNnFtU2tOeSt2c2gxYUc4QU1z?=
 =?utf-8?B?U29HUldVS3dlMHlmZDdSOWJJY3B4OWtrZUl0eG5RVWFrdGNaNTI1N0VFOUVZ?=
 =?utf-8?B?T3hPSjJBZVJuN3lXd3g2c2ZNdTZ5MzdQTTh3UlRsc2VrN2srUURubEh0ZlYr?=
 =?utf-8?Q?OjYtpF9Y468O3E+Kns8WSuqfk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf49a282-9822-42ab-b0c7-08dafdce382a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 05:45:37.9539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1MgMqsKhCJCMsd1D6jWU+xFhtwWJjLx86tJ/pq0DbRkuJbSEVsgnbOZqTlFxEOTRc/Ba/GHQ+wqCB5zpRuCObw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7793
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 include/net/xdp_sock.h |  2 +-
 net/xdp/xdp_umem.c     | 38 +++++++++++++-------------------------
 2 files changed, 14 insertions(+), 26 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 3057e1a..b0d3c16 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -25,7 +25,7 @@ struct xdp_umem {
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
