Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 396F4551294
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 10:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239237AbiFTIXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 04:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239911AbiFTIXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 04:23:33 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CA2F0105;
        Mon, 20 Jun 2022 01:23:30 -0700 (PDT)
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9BxaeR8LrBiO65OAA--.25988S2;
        Mon, 20 Jun 2022 16:23:24 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Pavel Machek <pavel@ucw.cz>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2] libbpf: Include linux/log2.h to use is_power_of_2()
Date:   Mon, 20 Jun 2022 16:23:24 +0800
Message-Id: <1655713404-7133-1-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
X-CM-TRANSID: AQAAf9BxaeR8LrBiO65OAA--.25988S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ZFyrZFWDuFWUGF43KrWUCFg_yoW8tw4DpF
        4DCr18Gr1rWr15ZFyDuF1F93y5K3W7WFW7KFy7GryjvwnIqFsrXr1qyFnI9r13W395Ww15
        ArWY9ryUZr1UX3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkab7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwV
        C2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
        0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Gr0_Cr
        1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkIecxEwVAFwVW8ZwCF04k2
        0xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI
        8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41l
        IxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIx
        AIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvE
        x4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07bwYFZUUUUU=
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

is_power_of_2() is already defined in tools/include/linux/log2.h [1],
so no need to define it again in tools/lib/bpf/libbpf_internal.h, so
just include linux/log2.h directly.

[1] https://lore.kernel.org/bpf/20220619171248.GC3362@bug/

Suggested-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 tools/lib/bpf/libbpf.c          | 2 +-
 tools/lib/bpf/libbpf_internal.h | 6 +-----
 tools/lib/bpf/linker.c          | 2 +-
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 49e359c..5252e51 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5131,7 +5131,7 @@ static size_t adjust_ringbuf_sz(size_t sz)
 	 * a power-of-2 multiple of kernel's page size. If user diligently
 	 * satisified these conditions, pass the size through.
 	 */
-	if ((sz % page_sz) == 0 && is_pow_of_2(sz / page_sz))
+	if ((sz % page_sz) == 0 && is_power_of_2(sz / page_sz))
 		return sz;
 
 	/* Otherwise find closest (page_sz * power_of_2) product bigger than
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index a1ad145..021946a 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -13,6 +13,7 @@
 #include <limits.h>
 #include <errno.h>
 #include <linux/err.h>
+#include <linux/log2.h>
 #include <fcntl.h>
 #include <unistd.h>
 #include "libbpf_legacy.h"
@@ -582,9 +583,4 @@ struct bpf_link * usdt_manager_attach_usdt(struct usdt_manager *man,
 					   const char *usdt_provider, const char *usdt_name,
 					   __u64 usdt_cookie);
 
-static inline bool is_pow_of_2(size_t x)
-{
-	return x && (x & (x - 1)) == 0;
-}
-
 #endif /* __LIBBPF_LIBBPF_INTERNAL_H */
diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index 4ac02c2..b2edb5f 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -719,7 +719,7 @@ static int linker_sanity_check_elf(struct src_obj *obj)
 			return -EINVAL;
 		}
 
-		if (sec->shdr->sh_addralign && !is_pow_of_2(sec->shdr->sh_addralign))
+		if (sec->shdr->sh_addralign && !is_power_of_2(sec->shdr->sh_addralign))
 			return -EINVAL;
 		if (sec->shdr->sh_addralign != sec->data->d_align)
 			return -EINVAL;
-- 
2.1.0

