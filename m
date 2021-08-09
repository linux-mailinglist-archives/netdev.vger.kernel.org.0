Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFD93E4EBE
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 23:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236095AbhHIVw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 17:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232193AbhHIVwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 17:52:53 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3659CC0613D3;
        Mon,  9 Aug 2021 14:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=KaMCWRlr/ASepwlmVfaesE6d3p8eFAZJ8++WT6RE5fg=; b=SviCN2OLkJcomgD3WQoDogkksR
        1QAh3HMIWThmPcVoPw/JHjFwp89kxrilMJsj3qqmDaT9Q/d6G3tTxYQ1DcnkNCvLZLC2oGohfohWU
        kadHOpjzrHRwz26VBMnqMUoACoAXM5zpor6/cLettkTxtxGe7/lIESm1Kswckrevmh9+rrsi48QOx
        4/G3SPp8gi9YgUcPTEqruV5i4lImc747nanKfqRm3JHD7AFoza3U0JQ9Nituqg+QkkMPaTrHi7TeE
        6It1rxqi5Y5P+l8MLHNtrLTpH2FuYLTUJfW0kvKySubV5+iPYEam7PVwOuh082JxlUX9w5gkALDGP
        luNK3qMw==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDDCB-00224L-0W; Mon, 09 Aug 2021 21:52:31 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org
Subject: [PATCH] bpf: core: fix kernel-doc notation
Date:   Mon,  9 Aug 2021 14:52:29 -0700
Message-Id: <20210809215229.7556-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix kernel-doc warnings in kernel/bpf/core.c (found by
scripts/kernel-doc and W=1 builds).

Correct a function name in a comment and add return descriptions
for 2 functions.

Fixes these kernel-doc warnings:

kernel/bpf/core.c:1372: warning: expecting prototype for __bpf_prog_run(). Prototype was for ___bpf_prog_run() instead
kernel/bpf/core.c:1372: warning: No description found for return value of '___bpf_prog_run'
kernel/bpf/core.c:1883: warning: No description found for return value of 'bpf_prog_select_runtime'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: bpf@vger.kernel.org
---
 kernel/bpf/core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- linux-next-20210806.orig/kernel/bpf/core.c
+++ linux-next-20210806/kernel/bpf/core.c
@@ -1362,11 +1362,13 @@ u64 __weak bpf_probe_read_kernel(void *d
 }
 
 /**
- *	__bpf_prog_run - run eBPF program on a given context
+ *	___bpf_prog_run - run eBPF program on a given context
  *	@regs: is the array of MAX_BPF_EXT_REG eBPF pseudo-registers
  *	@insn: is the array of eBPF instructions
  *
  * Decode and execute eBPF instructions.
+ *
+ * Return: whatever value is in %BPF_R0 at program exit
  */
 static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
 {
@@ -1878,6 +1880,9 @@ static void bpf_prog_select_func(struct
  *
  * Try to JIT eBPF program, if JIT is not available, use interpreter.
  * The BPF program will be executed via BPF_PROG_RUN() macro.
+ *
+ * Return: the &fp argument along with &err set to 0 for success or
+ * a negative errno code on failure
  */
 struct bpf_prog *bpf_prog_select_runtime(struct bpf_prog *fp, int *err)
 {
