Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D183D5557
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 10:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbhGZHiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 03:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232876AbhGZHiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 03:38:09 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96C8C06179B
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 01:18:36 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id da26so9471609edb.1
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 01:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pe63UuYeIyMU5x24QHHmiSesESIJt/GDpBcNT8fOBl8=;
        b=F6T8Uz6hzhiXRRAV4usgHT6lK2GMu9oUQ3rnD/dLnwYxOy1qGADhsOMoPdYDQ7CEr1
         uUc+vmZGwjoQeSZqJ4AW1aTpnx7Dv/oDL8JdsTdekA5nUXHXBMoIB7YzEX56U29QcBHL
         PFw4fHLf0Jj3awd+HTBUY7HbTchdUGUM8eg5Up7yFef+9sqZ0oVTDuNzuf5VGkPTjXTa
         SS78bA15b0nnmbAQ1V9fTCFkSDWPPIBvz6/i3O+0rjYjejfUVfd5WuTNfVJcPpCsSPTK
         J3wcty5T/t/1p7vBk2pn5y+JFcQxx9aIfTLWG0IN84W9TFAkXmDO5V8OuIeg878nsmYa
         IaXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pe63UuYeIyMU5x24QHHmiSesESIJt/GDpBcNT8fOBl8=;
        b=PIYM5ZMKupEuK810JKlgPBhw7jBAe0d03fzdsKrmzgorhEpMo7daY4fJ5m+xG02LnH
         v67IqLiFrpasFqKgQx/sQMBYxaXTr3I4HzKMAmYL+Yb0wlglJv+LV8IqlGIsFgY322T5
         jlEORA8K8qqRLws2IyzFROIQfcgJ0Wr9eQrB29YkhpfReuw1Q6+kWnsgLQbN4l0rOXvh
         iVaWYX07fNNd9RpLTWOUX76uZxH3snv+sXhB8tKlPGSpNdu83wImxqTykLa3T3U8p5CA
         WWDQxIzZhczk7/JjOyS79Bj1kadsx6fmAeXl3HxTmBMTaD6kMa6yREjP9scKrp1/Uwm5
         wOcw==
X-Gm-Message-State: AOAM533sgK7Q4VDx9/kDLR2GLtMjcz4HgngCkTc3MeKyM2nrH8xdmw16
        1tpY06SaeC6FVAsFX1Nh+WWRWA==
X-Google-Smtp-Source: ABdhPJxsj7TUeD/MhCb0dnq093f+QC5sb6m1zkiAn20HJylcLFJSYXJAIO0KBKlyIya4KFdhodTL2A==
X-Received: by 2002:a05:6402:40cf:: with SMTP id z15mr20996166edb.175.1627287515330;
        Mon, 26 Jul 2021 01:18:35 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id q9sm13937539ejf.70.2021.07.26.01.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 01:18:35 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        Tony.Ambardar@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [RFC PATCH 07/14] bpf/tests: add more ALU64 BPF_MUL tests
Date:   Mon, 26 Jul 2021 10:17:31 +0200
Message-Id: <20210726081738.1833704-8-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210726081738.1833704-1-johan.almbladh@anyfinetworks.com>
References: <20210726081738.1833704-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds BPF_MUL tests for 64x32 and 64x64 multiply. Mainly
testing 32-bit JITs that implement ALU64 operations with two 32-bit
CPU registers per operand.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index b930fa35b9ef..eb61088a674f 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -3051,6 +3051,31 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, 2147483647 } },
 	},
+	{
+		"ALU64_MUL_X: 64x64 multiply, low word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x0fedcba987654321LL),
+			BPF_LD_IMM64(R1, 0x123456789abcdef0LL),
+			BPF_ALU64_REG(BPF_MUL, R0, R1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0xe5618cf0 } }
+	},
+	{
+		"ALU64_MUL_X: 64x64 multiply, high word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x0fedcba987654321LL),
+			BPF_LD_IMM64(R1, 0x123456789abcdef0LL),
+			BPF_ALU64_REG(BPF_MUL, R0, R1),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x2236d88f } }
+	},
 	/* BPF_ALU | BPF_MUL | BPF_K */
 	{
 		"ALU_MUL_K: 2 * 3 = 6",
@@ -3161,6 +3186,29 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, 0x1 } },
 	},
+	{
+		"ALU64_MUL_K: 64x32 multiply, low word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
+			BPF_ALU64_IMM(BPF_MUL, R0, 0x12345678),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0xe242d208 } }
+	},
+	{
+		"ALU64_MUL_K: 64x32 multiply, high word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
+			BPF_ALU64_IMM(BPF_MUL, R0, 0x12345678),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0xc28f5c28 } }
+	},
 	/* BPF_ALU | BPF_DIV | BPF_X */
 	{
 		"ALU_DIV_X: 6 / 2 = 3",
-- 
2.25.1

