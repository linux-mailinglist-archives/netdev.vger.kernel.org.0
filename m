Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7D414A4E81
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 19:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355653AbiAaSgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 13:36:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350824AbiAaSgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 13:36:52 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC408C06173D;
        Mon, 31 Jan 2022 10:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=95lu5RkgfPWM9UeysUZM6t6dw8NZZ00goVWEgHCmKMs=; b=ItaWmoz4PbYdOMsLLyDpOaIvQD
        NOdtZXydJYk7c8l3pkbwMpupRF9VISOkdds8ZDspyaS+vsfSvythYgl5mZFrBF29MWj1T532+UQOV
        pwzLy27M5cTsYyVhhvavloPO1YKJuCroorFpuK26xJjwFAvbK4NN/uizmUjIAxb+35cvYEShumIuA
        SIgL5VXp8BhY1aHLcQfDlApWaf8Hx1TNeRJybZTgsdLR30Iaa1MTJXarzPXPzdkogme9+Jr0Yvp0e
        oFtoaz7LtF5ekMqiGVWSlPlvzcpFKhn0s1Vb6oRUEzofREE/w+wm7aiYkmMj2hJR7PADztbxeBmcL
        h8Yi9TDw==;
Received: from [2001:4bb8:191:327d:83ae:cf0e:db3c:eb79] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nEbXj-00AOsE-5Q; Mon, 31 Jan 2022 18:36:47 +0000
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
Subject: [PATCH 2/5] bpf, docs: Better document the regular load and store instructions
Date:   Mon, 31 Jan 2022 19:36:35 +0100
Message-Id: <20220131183638.3934982-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220131183638.3934982-1-hch@lst.de>
References: <20220131183638.3934982-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a separate section and a little intro blurb for the regular load and
store instructions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/bpf/instruction-set.rst | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/Documentation/bpf/instruction-set.rst b/Documentation/bpf/instruction-set.rst
index 87f6ad62633a5..03da885301722 100644
--- a/Documentation/bpf/instruction-set.rst
+++ b/Documentation/bpf/instruction-set.rst
@@ -215,23 +215,30 @@ The mode modifier is one of:
   BPF_IMM        0x00   used for 64-bit mov
   BPF_ABS        0x20   legacy BPF packet access
   BPF_IND        0x40   legacy BPF packet access
-  BPF_MEM        0x60   all normal load and store operations
+  BPF_MEM        0x60   regular load and store operations
   BPF_ATOMIC     0xc0   atomic operations
   =============  =====  ====================================
 
-BPF_MEM | <size> | BPF_STX means::
+
+Regular load and store operations
+---------------------------------
+
+The ``BPF_MEM`` mode modifier is used to encode regular load and store
+instructions that transfer data between a register and memory.
+
+``BPF_MEM | <size> | BPF_STX`` means::
 
   *(size *) (dst_reg + off) = src_reg
 
-BPF_MEM | <size> | BPF_ST means::
+``BPF_MEM | <size> | BPF_ST`` means::
 
   *(size *) (dst_reg + off) = imm32
 
-BPF_MEM | <size> | BPF_LDX means::
+``BPF_MEM | <size> | BPF_LDX`` means::
 
   dst_reg = *(size *) (src_reg + off)
 
-Where size is one of: BPF_B or BPF_H or BPF_W or BPF_DW.
+Where size is one of: ``BPF_B``, ``BPF_H``, ``BPF_W``, or ``BPF_DW``.
 
 Atomic operations
 -----------------
-- 
2.30.2

