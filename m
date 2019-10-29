Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB951E8C0D
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 16:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390090AbfJ2Pn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 11:43:29 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33983 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389902AbfJ2Pn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 11:43:28 -0400
Received: by mail-pg1-f194.google.com with SMTP id e4so5569000pgs.1;
        Tue, 29 Oct 2019 08:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xmVlNmzBbyTwx/IxkGsqdEPQpOfewWkcmkNfJI6xuFY=;
        b=BVpF0bZN8Ak/inmLo0ckzoUgQlrkN4VYtAOIBGP+txOA6OT4Poa+bSzUV0kUKBiDaF
         oJi9srOM3nOy8o/WoiiKBqRuDGL//Ws80oWf8G52pzkENR7P6io1slcFDY7+klf8AZ7d
         90UPYCs3tg+nbBDBicLoSAni3I1cj8IrKV2HKYT8PZL8oEp4y9kv+Om/1P+qJjWGIaTX
         x0f+JaiKsuC6MC70ibOtNl6hTGES+PXoYM4BssGvGA8m6NGyW5m4rxgh96lSOGW7jbgU
         QqGRWkEjLK56N/pZ//mDIXus0wj0DL/YS/Gm1bBOfMS7qpK12ECWE3PsbxWBH12HEP8w
         Qh/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xmVlNmzBbyTwx/IxkGsqdEPQpOfewWkcmkNfJI6xuFY=;
        b=Kpld1MqP9PBvp36C8FJQYkCTUbQGXWvrji6ydvef6i057OwhIy53MUCszcRicdzCet
         BVQMFwW5xFLvalxwsrjB9S7zjKvSbz8HijZeM6+p4Ii/YYW3dK2bH5UyaAmFGmDSFsyo
         DHFN0/8um7T03J89r1DpNkyeGcGVhurULu1lKM3IAn2Wh+ywITEdBomL5uGCCy8Px4DG
         LWDevdUJaKq+6Eht4f+Se86lX5Mg5dHkQ12M7YwPsuas5BRkMp/4FHOQV8QTssp4+LbL
         G7nV2Qs9BE1TPIU+inwPL0c5WSsdZny9s9ztqys77WW+yPSDdyRAQ/0Mng9u7A8nW0Id
         4QsQ==
X-Gm-Message-State: APjAAAV0FV6bdVQN2uuPcbNPcAuDDbuCsApXPNrslzaFkYyZsWNae8LC
        cTuKsbLWya5jXtBNEVWAw9BEIwUbL8HCCw==
X-Google-Smtp-Source: APXvYqyM5W5C0xbj43qQRNVhDEhwINVpdhTh7XUNzl4LXK74Fbm1nViB32VljwAf/PU63S5TOj9y6A==
X-Received: by 2002:a17:90a:9201:: with SMTP id m1mr7631347pjo.74.1572363807348;
        Tue, 29 Oct 2019 08:43:27 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id z7sm14304032pfr.165.2019.10.29.08.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 08:43:26 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, jakub.kicinski@netronome.com, toke@redhat.com
Subject: [PATCH bpf] bpf: change size to u64 for bpf_map_{area_alloc,charge_init}()
Date:   Tue, 29 Oct 2019 16:43:07 +0100
Message-Id: <20191029154307.23053-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The functions bpf_map_area_alloc() and bpf_map_charge_init() prior
this commit passed the size parameter as size_t. In this commit this
is changed to u64.

All users of these functions avoid size_t overflows on 32-bit systems,
by explicitly using u64 when calculating the allocation size and
memory charge cost. However, since the result was narrowed by the
size_t when passing size and cost to the functions, the overflow
handling was in vain.

Instead of changing all call sites to size_t and handle overflow at
the call site, the parameter is changed to u64 and checked in the
functions above.

Fixes: d407bd25a204 ("bpf: don't trigger OOM killer under pressure with map alloc")
Fixes: c85d69135a91 ("bpf: move memory size checks to bpf_map_charge_init()")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/linux/bpf.h  | 4 ++--
 kernel/bpf/syscall.c | 7 +++++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 5b9d22338606..3bf3835d0e86 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -656,11 +656,11 @@ void bpf_map_put_with_uref(struct bpf_map *map);
 void bpf_map_put(struct bpf_map *map);
 int bpf_map_charge_memlock(struct bpf_map *map, u32 pages);
 void bpf_map_uncharge_memlock(struct bpf_map *map, u32 pages);
-int bpf_map_charge_init(struct bpf_map_memory *mem, size_t size);
+int bpf_map_charge_init(struct bpf_map_memory *mem, u64 size);
 void bpf_map_charge_finish(struct bpf_map_memory *mem);
 void bpf_map_charge_move(struct bpf_map_memory *dst,
 			 struct bpf_map_memory *src);
-void *bpf_map_area_alloc(size_t size, int numa_node);
+void *bpf_map_area_alloc(u64 size, int numa_node);
 void bpf_map_area_free(void *base);
 void bpf_map_init_from_attr(struct bpf_map *map, union bpf_attr *attr);
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 0937719b87e2..ace1cfaa24b6 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -126,7 +126,7 @@ static struct bpf_map *find_and_alloc_map(union bpf_attr *attr)
 	return map;
 }
 
-void *bpf_map_area_alloc(size_t size, int numa_node)
+void *bpf_map_area_alloc(u64 size, int numa_node)
 {
 	/* We really just want to fail instead of triggering OOM killer
 	 * under memory pressure, therefore we set __GFP_NORETRY to kmalloc,
@@ -141,6 +141,9 @@ void *bpf_map_area_alloc(size_t size, int numa_node)
 	const gfp_t flags = __GFP_NOWARN | __GFP_ZERO;
 	void *area;
 
+	if (size >= SIZE_MAX)
+		return NULL;
+
 	if (size <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER)) {
 		area = kmalloc_node(size, GFP_USER | __GFP_NORETRY | flags,
 				    numa_node);
@@ -197,7 +200,7 @@ static void bpf_uncharge_memlock(struct user_struct *user, u32 pages)
 		atomic_long_sub(pages, &user->locked_vm);
 }
 
-int bpf_map_charge_init(struct bpf_map_memory *mem, size_t size)
+int bpf_map_charge_init(struct bpf_map_memory *mem, u64 size)
 {
 	u32 pages = round_up(size, PAGE_SIZE) >> PAGE_SHIFT;
 	struct user_struct *user;
-- 
2.20.1

