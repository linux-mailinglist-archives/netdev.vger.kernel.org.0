Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEC64220DD
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 10:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233301AbhJEIeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 04:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbhJEIe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 04:34:29 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A1FC061745;
        Tue,  5 Oct 2021 01:32:39 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id g14so16824395pfm.1;
        Tue, 05 Oct 2021 01:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oB80oYMulhrt43Nc7h4b8WTmJ925bEkBYiIlwoCVavE=;
        b=LgU8mqTxrXP9w5FDf88vbtQB9pIkvHyP7Snhffc78rg77kw1jneS0Sy7xl5qFPvSpD
         IEXqLMHsQvmL8Xh0eh5EbfhUgR06klJAs6a4bBHMTpfqktP7HfLTny/NBLAqMwXBGmC5
         t+ROAI14vIpQpsHOH4QDgAz1e3pNCqdtzLM98HdCyrLSlfGmvk5QrmNtH8mccgCzO13I
         Om5erayhNB9sS/ul8EcqUCkw1NwmE6crq4qIWNSIxMWF3ae7w/oFgYfGKwQCkW9oVSsW
         HuMqyE14TgXm7+b9PMCG8kbC7flvvRWJlkYvHBpynpl+IzvK38i6WZLAGq+Rce5vKYuB
         EWug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oB80oYMulhrt43Nc7h4b8WTmJ925bEkBYiIlwoCVavE=;
        b=CIkjmJVk65mWiFnxsfskbvwRAhg1ehLxExzr3xDOy4R/NH9/ZPw/N9uVQs6l7+3tru
         dY9ljidW05fcWvCpvSsN98R2H2mAYrCbNG0x/67emL9EdEz9rOM3phBk2w6zmAomKOvT
         0JcyJ6tNk/BVpxsu2e/QuJl12Tq2162cXT6ubNowkH/rr2oQapUhV39FAq7NC6EkGpVJ
         5k9Pyaj1GV1OxbC86utjfqVaDaFa5Y57IJ0fbyphvtvriTAmqTdfZf13lzsHGjjUyES/
         GOD6dpXJ5AVTne6f82lphhKjWo2N3cMPPyzyazQ5XljwbCvEWzKcaj+vJ50nQAwXLwq7
         nOrg==
X-Gm-Message-State: AOAM5337DhUSYMp+9pH8lHfI9Wn9AVx4HS3yiHpZoRZK5V6f8CqwnH9m
        gtW+ERX8jj2oeH1T/P3lnaE=
X-Google-Smtp-Source: ABdhPJwadmGEPkjSjq1bvQexkQA0RWI7UEAOIDW4pkpcLRXMENbOdsYnuFGNaqU/vrA8TFzFq61suA==
X-Received: by 2002:a05:6a00:98b:b0:44b:df34:c17b with SMTP id u11-20020a056a00098b00b0044bdf34c17bmr29657149pfg.34.1633422758941;
        Tue, 05 Oct 2021 01:32:38 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:78ba:4bcc:a59a:2284])
        by smtp.gmail.com with ESMTPSA id a15sm4941257pfg.53.2021.10.05.01.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 01:32:38 -0700 (PDT)
From:   Tony Ambardar <tony.ambardar@gmail.com>
X-Google-Original-From: Tony Ambardar <Tony.Ambardar@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Burton <paulburton@kernel.org>
Cc:     Tony Ambardar <Tony.Ambardar@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-mips@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Hassan Naveed <hnaveed@wavecomp.com>,
        David Daney <ddaney@caviumnetworks.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Subject: [RFC PATCH bpf-next v2 15/16] MIPS: uasm: Enable muhu opcode for MIPS R6
Date:   Tue,  5 Oct 2021 01:26:59 -0700
Message-Id: <a5746ac3dc8d972d8aa3e8be7142f9449014772b.1633392335.git.Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1633392335.git.Tony.Ambardar@gmail.com>
References: <cover.1625970383.git.Tony.Ambardar@gmail.com> <cover.1633392335.git.Tony.Ambardar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable the 'muhu' instruction, complementing the existing 'mulu', needed
to implement a MIPS32 BPF JIT.

Also fix a typo in the existing definition of 'dmulu'.

Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
---
 arch/mips/include/asm/uasm.h | 1 +
 arch/mips/mm/uasm-mips.c     | 4 +++-
 arch/mips/mm/uasm.c          | 3 ++-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/uasm.h b/arch/mips/include/asm/uasm.h
index f7effca791a5..5efa4e2dc9ab 100644
--- a/arch/mips/include/asm/uasm.h
+++ b/arch/mips/include/asm/uasm.h
@@ -145,6 +145,7 @@ Ip_u1(_mtlo);
 Ip_u3u1u2(_mul);
 Ip_u1u2(_multu);
 Ip_u3u1u2(_mulu);
+Ip_u3u1u2(_muhu);
 Ip_u3u1u2(_nor);
 Ip_u3u1u2(_or);
 Ip_u2u1u3(_ori);
diff --git a/arch/mips/mm/uasm-mips.c b/arch/mips/mm/uasm-mips.c
index 7154a1d99aad..e15c6700cd08 100644
--- a/arch/mips/mm/uasm-mips.c
+++ b/arch/mips/mm/uasm-mips.c
@@ -90,7 +90,7 @@ static const struct insn insn_table[insn_invalid] = {
 				RS | RT | RD},
 	[insn_dmtc0]	= {M(cop0_op, dmtc_op, 0, 0, 0, 0), RT | RD | SET},
 	[insn_dmultu]	= {M(spec_op, 0, 0, 0, 0, dmultu_op), RS | RT},
-	[insn_dmulu]	= {M(spec_op, 0, 0, 0, dmult_dmul_op, dmultu_op),
+	[insn_dmulu]	= {M(spec_op, 0, 0, 0, dmultu_dmulu_op, dmultu_op),
 				RS | RT | RD},
 	[insn_drotr]	= {M(spec_op, 1, 0, 0, 0, dsrl_op), RT | RD | RE},
 	[insn_drotr32]	= {M(spec_op, 1, 0, 0, 0, dsrl32_op), RT | RD | RE},
@@ -150,6 +150,8 @@ static const struct insn insn_table[insn_invalid] = {
 	[insn_mtlo]	= {M(spec_op, 0, 0, 0, 0, mtlo_op), RS},
 	[insn_mulu]	= {M(spec_op, 0, 0, 0, multu_mulu_op, multu_op),
 				RS | RT | RD},
+	[insn_muhu]	= {M(spec_op, 0, 0, 0, multu_muhu_op, multu_op),
+				RS | RT | RD},
 #ifndef CONFIG_CPU_MIPSR6
 	[insn_mul]	= {M(spec2_op, 0, 0, 0, 0, mul_op), RS | RT | RD},
 #else
diff --git a/arch/mips/mm/uasm.c b/arch/mips/mm/uasm.c
index 81dd226d6b6b..125140979d62 100644
--- a/arch/mips/mm/uasm.c
+++ b/arch/mips/mm/uasm.c
@@ -59,7 +59,7 @@ enum opcode {
 	insn_lddir, insn_ldpte, insn_ldx, insn_lh, insn_lhu, insn_ll, insn_lld,
 	insn_lui, insn_lw, insn_lwu, insn_lwx, insn_mfc0, insn_mfhc0, insn_mfhi,
 	insn_mflo, insn_modu, insn_movn, insn_movz, insn_mtc0, insn_mthc0,
-	insn_mthi, insn_mtlo, insn_mul, insn_multu, insn_mulu, insn_nor,
+	insn_mthi, insn_mtlo, insn_mul, insn_multu, insn_mulu, insn_muhu, insn_nor,
 	insn_or, insn_ori, insn_pref, insn_rfe, insn_rotr, insn_sb, insn_sc,
 	insn_scd, insn_seleqz, insn_selnez, insn_sd, insn_sh, insn_sll,
 	insn_sllv, insn_slt, insn_slti, insn_sltiu, insn_sltu, insn_sra,
@@ -344,6 +344,7 @@ I_u1(_mtlo)
 I_u3u1u2(_mul)
 I_u1u2(_multu)
 I_u3u1u2(_mulu)
+I_u3u1u2(_muhu)
 I_u3u1u2(_nor)
 I_u3u1u2(_or)
 I_u2u1u3(_ori)
-- 
2.25.1

