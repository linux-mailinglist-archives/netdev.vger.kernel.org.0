Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F05502E255E
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 09:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbgLXIBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 03:01:49 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:36015 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726266AbgLXIBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 03:01:48 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R871e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0UJcXTH5_1608796849;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UJcXTH5_1608796849)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 24 Dec 2020 16:01:05 +0800
From:   YANG LI <abaci-bugfix@linux.alibaba.com>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, natechancellor@gmail.com, ndesaulniers@google.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        YANG LI <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] bpf: fix: symbol 'btf_vmlinux' was not declared.
Date:   Thu, 24 Dec 2020 16:00:48 +0800
Message-Id: <1608796848-49865-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Symbol 'btf_vmlinux' was not declared in the header file and does not 
add extern, so no other file uses it. It's better to add static to it.

Signed-off-by: YANG LI <abaci-bugfix@linux.alibaba.com>
Reported-by: Abaci <abaci@linux.alibaba.com>
---
 kernel/bpf/verifier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 17270b8..535d364 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -244,7 +244,7 @@ struct bpf_call_arg_meta {
 	u32 ret_btf_id;
 };
 
-struct btf *btf_vmlinux;
+static struct btf *btf_vmlinux;
 
 static DEFINE_MUTEX(bpf_verifier_lock);
 
-- 
1.8.3.1

