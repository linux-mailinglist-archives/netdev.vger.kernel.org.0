Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB96F1AD64F
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 08:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbgDQGl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 02:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726232AbgDQGlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 02:41:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB08C061A0C;
        Thu, 16 Apr 2020 23:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=/o7UlcR7J0OLMWDDmedYROrKyeeA4yowwB6Tl9ToCVo=; b=gHYxbzscb67CdZTtvE54hU8sIP
        lQ2J0uyjyyd/+K64HuOhJujus+zZsv+8VmWhPc+CrfBqLqz97duGj42273wi1vIlYsdKMRuL62uSS
        J63fXvGTKvrgYApoSf8OPKdBs+YQm5l1Htmm10HOtY2atGECRmjO9GAl2okhZXUrA1nt465GoIH/M
        sotvn3mpz8wHHll5qOJY5eIPGdhH/9pB8VdF5e+G54zRqdURwLoXIFYZcaaNZTt0JUvtIeyRNUxMR
        bQ0y5IWVY4pLx7lBW2OlIIcdb1IL9Mg12VfZxKGVWkkVq/gYKxxv16N8D7wWGF3grKBJkKfiv9vin
        EDOneduA==;
Received: from [2001:4bb8:184:4aa1:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jPKhD-0002hI-Vt; Fri, 17 Apr 2020 06:41:52 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH 1/6] bpf-cgroup: remove unused exports
Date:   Fri, 17 Apr 2020 08:41:41 +0200
Message-Id: <20200417064146.1086644-2-hch@lst.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200417064146.1086644-1-hch@lst.de>
References: <20200417064146.1086644-1-hch@lst.de>
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
2.25.1

