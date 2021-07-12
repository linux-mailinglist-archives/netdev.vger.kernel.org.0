Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA893C407A
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 02:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbhGLAig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 20:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbhGLAiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 20:38:24 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D69ECC0613E8;
        Sun, 11 Jul 2021 17:35:35 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id h4so16473264pgp.5;
        Sun, 11 Jul 2021 17:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cekwLtOmtUa2BNFyGkn1Zn17oN6dKTP2bypSds/8+bw=;
        b=u4/lYuyqXXO8+vXNvORgveCso7b6Rl7EAbhoMQiCKh7y8pSDz2WfJvM067p3MaMeoq
         sWnDZfwkn/HzMzF9HoLcV+ZdLNK1xsgn5GNuCy5RhveJrs/cryCV5iDyp2xj/LVo2yur
         vXrJZj6A7k0rhcZNK70+Hqaw5VNgmspDD5Xq6UETYC7uwSvQoy0yZvDBhwxfxz/mqStL
         jwuRWHnaMa70T+oSnB62TZbyj83qX2YnhFNhzh9pIYDfdX27GJEv8FYzEcY+0c6wKauL
         ornwOZVLrMdx5wzDZFTVZvNDXiyZeR9Q3qH+HwjH8l+z52DmQRqfqRc1bVNrauk91tIB
         nS2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cekwLtOmtUa2BNFyGkn1Zn17oN6dKTP2bypSds/8+bw=;
        b=HzwPpdRssgw978fu539y55xE/CN4aofH4+WDROTPeae3HLJAcY3ixAVsz84k4CzEXR
         pbJiFqEwfyyuFdhJH25KcyXEM1+aNS5hBZP6uGTLnzl38Lcz3/xy7aorC7uvWf/RiPIo
         BhCnRXKz7L54EYz6maqz7UwXfSQ9kmx5kTjZEbw0YfQ3ZjWiANonL6zZ9u68PrtMBwS2
         TLFbqwAa5gy8NVC6wpEmjtbdQmwdZDhcEmumDCBwfLP6e6edARWFE3hCkIgp++Vkr7Gw
         BR4ppVJIrrkEZLGgzp8/STHBKNZwFXP+571ZTHwi+MKvxb/kRrE32CaP2Zxdcjh22BKw
         xmCw==
X-Gm-Message-State: AOAM5329QpvW+dmtiYa9RLu9zXN8pzan1I8jhbIvL6akri96zSkpf2OX
        nL/dBulToSnO/4WEkG9tYXw=
X-Google-Smtp-Source: ABdhPJwQuaqbTrJMo0sb5ZCTNqRaO05aLENU6w354eWq7EFMYs5+vt5W1/9uxz0BRbATALUu54tVZA==
X-Received: by 2002:aa7:8b07:0:b029:2f7:d38e:ff1 with SMTP id f7-20020aa78b070000b02902f7d38e0ff1mr50576505pfd.72.1626050135398;
        Sun, 11 Jul 2021 17:35:35 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:4039:6c0e:1168:cc74])
        by smtp.gmail.com with ESMTPSA id c24sm15588447pgj.11.2021.07.11.17.35.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 17:35:35 -0700 (PDT)
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
Subject: [RFC PATCH bpf-next v1 07/14] MIPS: eBPF: fix MOD64 insn on R6 ISA
Date:   Sun, 11 Jul 2021 17:34:53 -0700
Message-Id: <fdfdd33463f60cceb3f982aacd2229a1862a17d9.1625970384.git.Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625970383.git.Tony.Ambardar@gmail.com>
References: <cover.1625970383.git.Tony.Ambardar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BPF_ALU64 | BPF_MOD implementation is broken on MIPS64R6 due to use of
a 32-bit "modu" insn, as shown by the test_verifier failures:

  455/p MOD64 overflow, check 1 FAIL retval 0 != 1 (run 1/1)
  456/p MOD64 overflow, check 2 FAIL retval 0 != 1 (run 1/1)

Resolve by using the 64-bit "dmodu" instead.

Fixes: 6c2c8a188868 ("MIPS: eBPF: Provide eBPF support for MIPS64R6")
Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
---
 arch/mips/net/ebpf_jit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/net/ebpf_jit.c b/arch/mips/net/ebpf_jit.c
index 4f641dcb2031..e8c403c6cfa3 100644
--- a/arch/mips/net/ebpf_jit.c
+++ b/arch/mips/net/ebpf_jit.c
@@ -800,7 +800,7 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 			if (bpf_op == BPF_DIV)
 				emit_instr(ctx, ddivu_r6, dst, dst, MIPS_R_AT);
 			else
-				emit_instr(ctx, modu, dst, dst, MIPS_R_AT);
+				emit_instr(ctx, dmodu, dst, dst, MIPS_R_AT);
 			break;
 		}
 		emit_instr(ctx, ddivu, dst, MIPS_R_AT);
@@ -882,7 +882,7 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 					emit_instr(ctx, ddivu_r6,
 							dst, dst, src);
 				else
-					emit_instr(ctx, modu, dst, dst, src);
+					emit_instr(ctx, dmodu, dst, dst, src);
 				break;
 			}
 			emit_instr(ctx, ddivu, dst, src);
-- 
2.25.1

