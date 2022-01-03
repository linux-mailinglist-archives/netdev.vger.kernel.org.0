Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92AF6483711
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 19:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235814AbiACSg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 13:36:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235811AbiACSgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 13:36:17 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA8AC061784;
        Mon,  3 Jan 2022 10:36:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=budVXNBVPihdySFLw09Mck8of6+GoN4AceRFnzdYfvE=; b=R+P34GJCnHZqHiggcv0j5uXpww
        Jbf/SSP6SQROuncqB/ajpqBkPlYR/Yx6E45Xfe/KgH9tvBjTraMDBLJwn7pdXJonXqQ8/cTs9u8YI
        hPcr7JY6kRxVEX5SGGPxViliIMfZXm4DVf8QJL2iPhHxvu6ik/ky6dmmUKuw0js1xTkX7BktUfE/e
        xFtLyraAO2T/yRwvmGKcpzfHP495cRlxTQ2O6077uRGqUk7B8CT+IV+/wygJepY+Dbu2BVZ+dvS4J
        /d+ZJaZDtqwCRpvOy5k/NboLdH5MCsv7PYAoaa/6mvFBpD75x+fejDY3GS+g5+ICyUUzcjKoNSKQu
        xqPjPpCw==;
Received: from [2001:4bb8:184:3f95:b8f7:97d6:6b53:b9be] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n4SBn-009qSl-Te; Mon, 03 Jan 2022 18:36:12 +0000
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
Subject: [PATCH 4/6] bpf, docs: Fully document the ALU opcodes
Date:   Mon,  3 Jan 2022 19:35:54 +0100
Message-Id: <20220103183556.41040-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220103183556.41040-1-hch@lst.de>
References: <20220103183556.41040-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add pseudo-code to document all the different BPF_ALU / BPF_ALU64
opcodes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/bpf/instruction-set.rst | 30 +++++++++++++--------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/Documentation/bpf/instruction-set.rst b/Documentation/bpf/instruction-set.rst
index 2987cbb07f7f6..efba4d1931853 100644
--- a/Documentation/bpf/instruction-set.rst
+++ b/Documentation/bpf/instruction-set.rst
@@ -82,24 +82,24 @@ BPF_ALU uses 32-bit wide operands while BPF_ALU64 uses 64-bit wide operands for
 otherwise identical operations.
 The code field encodes the operation as below:
 
-  ========  =====  =========================
+  ========  =====  ==========================
   code      value  description
-  ========  =====  =========================
-  BPF_ADD   0x00
-  BPF_SUB   0x10
-  BPF_MUL   0x20
-  BPF_DIV   0x30
-  BPF_OR    0x40
-  BPF_AND   0x50
-  BPF_LSH   0x60
-  BPF_RSH   0x70
-  BPF_NEG   0x80
-  BPF_MOD   0x90
-  BPF_XOR   0xa0
-  BPF_MOV   0xb0   mov reg to reg
+  ========  =====  ==========================
+  BPF_ADD   0x00   dst += src
+  BPF_SUB   0x10   dst -= src
+  BPF_MUL   0x20   dst \*= src
+  BPF_DIV   0x30   dst /= src
+  BPF_OR    0x40   dst \|= src
+  BPF_AND   0x50   dst &= src
+  BPF_LSH   0x60   dst <<= src
+  BPF_RSH   0x70   dst >>= src
+  BPF_NEG   0x80   dst = ~src
+  BPF_MOD   0x90   dst %= src
+  BPF_XOR   0xa0   dst ^= src
+  BPF_MOV   0xb0   dst = src
   BPF_ARSH  0xc0   sign extending shift right
   BPF_END   0xd0   endianness conversion
-  ========  =====  =========================
+  ========  =====  ==========================
 
 BPF_ADD | BPF_X | BPF_ALU means::
 
-- 
2.30.2

