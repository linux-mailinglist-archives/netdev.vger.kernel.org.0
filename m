Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF55C3C4085
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 02:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbhGLAim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 20:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232569AbhGLAib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 20:38:31 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A51C0613E5;
        Sun, 11 Jul 2021 17:35:42 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id d9-20020a17090ae289b0290172f971883bso11141301pjz.1;
        Sun, 11 Jul 2021 17:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oB80oYMulhrt43Nc7h4b8WTmJ925bEkBYiIlwoCVavE=;
        b=NxP01KNhkrSiBxyEIGraariMdqCYl7thvxueTtkC4eWIOa++ocF+MOwloKQBLmsPQi
         dC+v+6N2GJ00z7af2/i+ugI5Zy9or7H8OeqtMA92xfLXoQY4ac5KVEuwiogaq5s2nI6x
         wqZwRGppD0niZR8GpdOdLz3qY3GtDNuwqRCSvX80pv1CDBcRczn/DkzjUCM99I6tLpUb
         mNkxgKAqRvKwsR+xUFNEGnVVXspKxmALCroOE+N4l53iJo9//wkpQOsGJsJxtvmfAvUn
         XAfbyJAO3sRwMbLTgRukrDW0kj0byGBXpdZP0FIuD7eYL79p3FbB8MlhHhiwWzj4Bi6A
         LD9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oB80oYMulhrt43Nc7h4b8WTmJ925bEkBYiIlwoCVavE=;
        b=sX+p3ojPqucyYhDD/UJMoRr6Y30bEO8Z10IC5YQ/kZUf9pK57Y60/V0bRmfQiJqAap
         0i4byLTtIwUJXOOmDPJqfNjANw3XWB+QUR7kyqpONaaLaoXRDKpd3o9SRAH4bbgc1FRe
         a+Gm7UygsckZH1+ewlv6e+6cc1eODtUGCEY3qI8E0nRSDSTcxukYQ2n23zZnk14RyVF0
         ErbtOz77Snp5ajOYi0F9WcKrgP/rry34OzK8DwgqBZcQabwgVuSTW+JQb19wg4ju9i3h
         asSmVzomYsHBH/o970oYg3HCxzZbwTqKPin2RyBTekyzuzpuCPexQG0Pmz9GkGffCmgS
         R+9A==
X-Gm-Message-State: AOAM532Jcy8fY8pQLjtH7hID5PQe7ZfsajdR6zMXcHERIO7TlYbZ+ntV
        00H9OnUAYZ+TZNfmFVyiMy4=
X-Google-Smtp-Source: ABdhPJz1KEiQJEmGbn390SxZyaPk+Zi8fa4F2g+2F6GcpkwMNjNRb1jJgBkY3Y49srHXIVRhsJszKw==
X-Received: by 2002:a17:903:300c:b029:129:dd30:2b8a with SMTP id o12-20020a170903300cb0290129dd302b8amr17858041pla.85.1626050142430;
        Sun, 11 Jul 2021 17:35:42 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:4039:6c0e:1168:cc74])
        by smtp.gmail.com with ESMTPSA id c24sm15588447pgj.11.2021.07.11.17.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 17:35:42 -0700 (PDT)
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
        Hassan Naveed <hnaveed@wavecomp.com>,
        David Daney <ddaney@caviumnetworks.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Subject: [RFC PATCH bpf-next v1 13/14] MIPS: uasm: Enable muhu opcode for MIPS R6
Date:   Sun, 11 Jul 2021 17:34:59 -0700
Message-Id: <94f6da32a6990e64c69ccbbd435fcba67d3c7ec6.1625970384.git.Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625970383.git.Tony.Ambardar@gmail.com>
References: <cover.1625970383.git.Tony.Ambardar@gmail.com>
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

