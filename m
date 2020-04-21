Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219D91B2DF0
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 19:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729227AbgDURPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 13:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725990AbgDURPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 13:15:46 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86FDDC061A41;
        Tue, 21 Apr 2020 10:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=54xzidtAZ1caXXUPrQ+HOqcH88Gl+MonhQ1PtQKRFcA=; b=eB8U2U0pXnE8/mjgH+TP8fRPiD
        a/zvg/N3g2pxMpdNCEvrNcv2l0shmS1zyjMiP1o7Z10JdDKkhJYw2jtZNZq7bKP91IqhmAccGXEmv
        LsdncbfO/JMIOAyjJoXYJoFnyiQrSWH5WI0k1cKmIa4USXm5KFifUQiABrrpYIAHHe3x2DBpQNH0s
        mh5AkcXqsOJ/wcXNgSzdfx7Z5KyLLqykAeTRAaJXW6W2H2kX78guezT80Fh84sH4CeY3w0Uuz2gCb
        WXMfvDQTFv9eoQ0GWC1CslOkl0dfBfuxM7k86phIgcsTHI2BgsGa5ul1XskubFY0dSRtpr8bCjtm1
        eQsCym9g==;
Received: from [2001:4bb8:191:e12c:c70:4a89:bc61:3] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jQwUp-0006aT-Ei; Tue, 21 Apr 2020 17:15:43 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH 1/5] bpf-cgroup: remove unused exports
Date:   Tue, 21 Apr 2020 19:15:35 +0200
Message-Id: <20200421171539.288622-2-hch@lst.de>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200421171539.288622-1-hch@lst.de>
References: <20200421171539.288622-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Except for a few of the networking hooks called from modular ipv4 or
ipv6 code, all of hooks are just called from guaranteed to be built-in
code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 kernel/bpf/cgroup.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index cb305e71e7de..929d9a7263da 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1054,7 +1054,6 @@ int __cgroup_bpf_check_dev_permission(short dev_type, u32 major, u32 minor,
 
 	return !allow;
 }
-EXPORT_SYMBOL(__cgroup_bpf_check_dev_permission);
 
 static const struct bpf_func_proto *
 cgroup_base_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
@@ -1221,7 +1220,6 @@ int __cgroup_bpf_run_filter_sysctl(struct ctl_table_header *head,
 
 	return ret == 1 ? 0 : -EPERM;
 }
-EXPORT_SYMBOL(__cgroup_bpf_run_filter_sysctl);
 
 #ifdef CONFIG_NET
 static bool __cgroup_bpf_prog_array_is_empty(struct cgroup *cgrp,
@@ -1326,7 +1324,6 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 		sockopt_free_buf(&ctx);
 	return ret;
 }
-EXPORT_SYMBOL(__cgroup_bpf_run_filter_setsockopt);
 
 int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 				       int optname, char __user *optval,
@@ -1413,7 +1410,6 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 	sockopt_free_buf(&ctx);
 	return ret;
 }
-EXPORT_SYMBOL(__cgroup_bpf_run_filter_getsockopt);
 #endif
 
 static ssize_t sysctl_cpy_dir(const struct ctl_dir *dir, char **bufp,
-- 
2.26.1

