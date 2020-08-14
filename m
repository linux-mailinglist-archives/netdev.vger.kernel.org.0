Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2FA2446DF
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 11:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgHNJR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 05:17:29 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:55184 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726012AbgHNJR3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Aug 2020 05:17:29 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 439A98782C52AFCEDB9D;
        Fri, 14 Aug 2020 17:17:26 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Fri, 14 Aug 2020
 17:17:18 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <andriin@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <hawk@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linmiaohe@huawei.com>
Subject: [PATCH] bpf: Convert to use the preferred fallthrough macro
Date:   Fri, 14 Aug 2020 05:16:15 -0400
Message-ID: <20200814091615.21821-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.175]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the uses of fallthrough comments to fallthrough macro.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 kernel/bpf/cgroup.c   | 2 +-
 kernel/bpf/cpumap.c   | 2 +-
 kernel/bpf/syscall.c  | 2 +-
 kernel/bpf/verifier.c | 6 +++---
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 83ff127ef7ae..e21de4f1754c 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1794,7 +1794,7 @@ static bool cg_sockopt_is_valid_access(int off, int size,
 			return prog->expected_attach_type ==
 				BPF_CGROUP_GETSOCKOPT;
 		case offsetof(struct bpf_sockopt, optname):
-			/* fallthrough */
+			fallthrough;
 		case offsetof(struct bpf_sockopt, level):
 			if (size != size_default)
 				return false;
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index f1c46529929b..6386b7bb98f2 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -279,7 +279,7 @@ static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_map_entry *rcpu,
 			break;
 		default:
 			bpf_warn_invalid_xdp_action(act);
-			/* fallthrough */
+			fallthrough;
 		case XDP_DROP:
 			xdp_return_frame(xdpf);
 			stats->drop++;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 86299a292214..1bf960aa615c 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2029,7 +2029,7 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
 	case BPF_PROG_TYPE_EXT:
 		if (expected_attach_type)
 			return -EINVAL;
-		/* fallthrough */
+		fallthrough;
 	default:
 		return 0;
 	}
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ef938f17b944..1e7f34663f86 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2639,7 +2639,7 @@ static bool may_access_direct_pkt_data(struct bpf_verifier_env *env,
 	case BPF_PROG_TYPE_CGROUP_SKB:
 		if (t == BPF_WRITE)
 			return false;
-		/* fallthrough */
+		fallthrough;
 
 	/* Program types with direct read + write access go here! */
 	case BPF_PROG_TYPE_SCHED_CLS:
@@ -5236,7 +5236,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 				off_reg == dst_reg ? dst : src);
 			return -EACCES;
 		}
-		/* fall-through */
+		fallthrough;
 	default:
 		break;
 	}
@@ -10988,7 +10988,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 	default:
 		if (!prog_extension)
 			return -EINVAL;
-		/* fallthrough */
+		fallthrough;
 	case BPF_MODIFY_RETURN:
 	case BPF_LSM_MAC:
 	case BPF_TRACE_FENTRY:
-- 
2.19.1

