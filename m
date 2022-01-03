Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F3F483701
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 19:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233666AbiACSgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 13:36:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235842AbiACSgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 13:36:10 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C0DC061785;
        Mon,  3 Jan 2022 10:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=qs5t1JYPABDfY8UHpgPdePHyWxVleAN0r9HqvFjtxPY=; b=LPCFd7r08dh9uh2iLCGerVaKlW
        RT+tRZDnDjZznd7jcy3/FrHNeB79QQ8AnXl2Z2q2g6fTKLdr6CDV0UbdPNaU+3s8YwG3JpM0boQkv
        9DEUvjHAna0NQ1znEbDhTV5Crs/V3S0EecE7SMAG4DEHFp9aRzN+e65SDVC/COd1nc13Ouipud6tC
        danyqcp2RvNOjUp23Rxc8rGboaVATSElZZnUws5mUbep7FrOXhrt8WsfOOc5aXJ6rDCPoK78zquUo
        VI7j9GU+O8Oz2ZAXznaiJyL17KQs4UWHJp/duKNCs2aCakJ90WENPTEoI4D8rKyCuyvnVcV6D5utU
        TI3C1Cow==;
Received: from [2001:4bb8:184:3f95:b8f7:97d6:6b53:b9be] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n4SBf-009qRX-PS; Mon, 03 Jan 2022 18:36:04 +0000
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
Subject: [PATCH 1/6] bpf, docs: Add a setion to explain the basic instruction encoding
Date:   Mon,  3 Jan 2022 19:35:51 +0100
Message-Id: <20220103183556.41040-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220103183556.41040-1-hch@lst.de>
References: <20220103183556.41040-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The eBPF instruction set document does not currently document the basic
instruction encoding.  Add a section to do that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/bpf/instruction-set.rst | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/Documentation/bpf/instruction-set.rst b/Documentation/bpf/instruction-set.rst
index 1af51143ff9f6..80f42984b5942 100644
--- a/Documentation/bpf/instruction-set.rst
+++ b/Documentation/bpf/instruction-set.rst
@@ -19,8 +19,22 @@ The eBPF calling convention is defined as:
 R0 - R5 are scratch registers and eBPF programs needs to spill/fill them if
 necessary across calls.
 
+Instruction encoding
+====================
+
+eBPF uses 64-bit instructions with the following encoding:
+
+ =============  =======  ===============  ====================  ============
+ 32 bits (MSB)  16 bits  4 bits           4 bits                8 bits (LSB)
+ =============  =======  ===============  ====================  ============
+ immediate      offset   source register  destination register  opcode
+ =============  =======  ===============  ====================  ============
+
+Note that most instructions do not use all of the fields.
+Unused fields shall be cleared to zero.
+
 Instruction classes
-===================
+-------------------
 
 The three LSB bits of the 'opcode' field store the instruction class:
 
-- 
2.30.2

