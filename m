Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1854483714
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 19:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235725AbiACSgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 13:36:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235861AbiACSgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 13:36:19 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732DBC061799;
        Mon,  3 Jan 2022 10:36:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=YothgiYWmU2Bn16pVq6rc9tCxo9MCVxckYP/8PpXRT0=; b=BygqRBDY8OUsgOVKOeQ4iiDbkp
        k5Vg261sr2p70bvs9PSFAJzKEyhe9S+6LYxApLj1/ANP5lUPBUQcqOCAD7Tk/5xJWsPK79zcKtHb1
        ZCCcgNDVXhLRMXAm4XogxokTfRRUfyhTE1pNGqwY6NB8Kh0li4dXLIy3jOIzvIvCkqIz0t0ukHu1+
        XJe1rFOhvZ0CxOowWI6b3lfQMNMu7quTyMFMKvkZ5wFfcwsx51yZC80LjW1ea+fBNNYKjBR+F99nb
        IKsBQhMfAxcyCF/zqLHBbiW9BxOuKlMEhu6PZ4k1GcRHDbZBN7lTMzKzTLi3h5BQmUIEjB5zhAleo
        drbVfKqw==;
Received: from [2001:4bb8:184:3f95:b8f7:97d6:6b53:b9be] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n4SBq-009qTm-MG; Mon, 03 Jan 2022 18:36:15 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 5/6] bpf, docs: Fully document the JMP opcodes
Date:   Mon,  3 Jan 2022 19:35:55 +0100
Message-Id: <20220103183556.41040-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220103183556.41040-1-hch@lst.de>
References: <20220103183556.41040-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add pseudo-code to document all the different BPF_JMP / BPF_JMP64
opcodes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/bpf/instruction-set.rst | 34 +++++++++++++--------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/Documentation/bpf/instruction-set.rst b/Documentation/bpf/instruction-set.rst
index efba4d1931853..88e8d6a9195cd 100644
--- a/Documentation/bpf/instruction-set.rst
+++ b/Documentation/bpf/instruction-set.rst
@@ -125,24 +125,24 @@ BPF_JMP32 uses 32-bit wide operands while BPF_JMP uses 64-bit wide operands for
 otherwise identical operations.
 The code field encodes the operation as below:
 
-  ========  =====  =========================
-  code      value  description
-  ========  =====  =========================
-  BPF_JA    0x00   BPF_JMP only
-  BPF_JEQ   0x10
-  BPF_JGT   0x20
-  BPF_JGE   0x30
-  BPF_JSET  0x40
-  BPF_JNE   0x50   jump '!='
-  BPF_JSGT  0x60   signed '>'
-  BPF_JSGE  0x70   signed '>='
+  ========  =====  =========================  ============
+  code      value  description                notes
+  ========  =====  =========================  ============
+  BPF_JA    0x00   PC += off                  BPF_JMP only
+  BPF_JEQ   0x10   PC += off if dst == src
+  BPF_JGT   0x20   PC += off if dst > src     unsigned
+  BPF_JGE   0x30   PC += off if dst >= src    unsigned
+  BPF_JSET  0x40   PC += off if dst & src
+  BPF_JNE   0x50   PC += off if dst != src
+  BPF_JSGT  0x60   PC += off if dst > src     signed
+  BPF_JSGE  0x70   PC += off if dst >= src    signed
   BPF_CALL  0x80   function call
-  BPF_EXIT  0x90   function return
-  BPF_JLT   0xa0   unsigned '<'
-  BPF_JLE   0xb0   unsigned '<='
-  BPF_JSLT  0xc0   signed '<'
-  BPF_JSLE  0xd0   signed '<='
-  ========  =====  =========================
+  BPF_EXIT  0x90   function / program return  BPF_JMP only
+  BPF_JLT   0xa0   PC += off if dst < src     unsigned
+  BPF_JLE   0xb0   PC += off if dst <= src    unsigned
+  BPF_JSLT  0xc0   PC += off if dst < src     signed
+  BPF_JSLE  0xd0   PC += off if dst <= src    signed
+  ========  =====  =========================  ============
 
 The eBPF program needs to store the return value into register R0 before doing a
 BPF_EXIT.
-- 
2.30.2

