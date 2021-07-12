Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B8C3C4081
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 02:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbhGLAig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 20:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232090AbhGLAiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 20:38:23 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5849AC0613DD;
        Sun, 11 Jul 2021 17:35:35 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id s18so1184645pgq.3;
        Sun, 11 Jul 2021 17:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B0unYZuIjXroRmLeSdEAWvOsYYAcsr17oWsLSXDQ15w=;
        b=YH6QeaxEeMovxNg/MDaDzsL3I+L57mXEUwztNZX8OnzgEZhXzP241cBepJ5EeQ55Xs
         zsOCh7tMinRD+QNaddog6ArwHMRPUDW85nyjJ3llkDWg6nr/5MTSVhSdJf5VdevLlc8Q
         tVEZhpDEvW8Z0n1w831cYhNSeiZoYUjyPLegsNluVnL9gKxsLFiK3Kml+Rlzy7drm2ED
         AIMeL9rSLxWuEAG0lLLCKIo2rvevYxo85u0zqmFqWBG5KCswDxitv2TfRbOLdxTIyTPa
         fROJ5/VsyZ601lue5ruv6s+prHsS31oNg2VcAqCnmL3l/p4jkMF0AUANVNjJIp8eGcVS
         +c7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B0unYZuIjXroRmLeSdEAWvOsYYAcsr17oWsLSXDQ15w=;
        b=UjL04q2ec318qtZhnkUbjGZXH6v9+EHy6otBrCovQCAJ7Vvo3I2BhGEz5VhHSIQ6Of
         koyBBqNeo391tmh+gx1Vi51vwxQX2rftHQCc8UzcVYtZqVcJww/u9CSj+peRvVQ22cEc
         tH6e1rSwQhHuotNAHVpyQVgxXWEAJthOi2CGMCHtfYnFVl8Z7YGBiyfobvgl7nWHjD5l
         ESdA4yZg26ZFQQRK6DnuyWYCqDs3zdDio+wZJl9XQVsTamlRBT+uT9pB6T3SFKzsl4MH
         RcAfW34+Rj/mrG3dBGW3zUy8jUcoruTtrY5pfOVtbaoh5E4f741l0Wz01tPrNGdjM0rH
         VIDA==
X-Gm-Message-State: AOAM532nI/90/nEsl5IT+XV5XvMdr1mlb5DFz9ab6t0/WC4J3sDFfVWL
        ay6p3P63Qvw70DBpAKO591Q=
X-Google-Smtp-Source: ABdhPJxU1giKJp7HNS+yHRwlhR1DVja/yTEMojfwjkOXVlVXRYZ8+yh+rfP5cXpXdwqgcMhcOalWOQ==
X-Received: by 2002:aa7:8d01:0:b029:311:47d0:f169 with SMTP id j1-20020aa78d010000b029031147d0f169mr36795986pfe.78.1626050134450;
        Sun, 11 Jul 2021 17:35:34 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:4039:6c0e:1168:cc74])
        by smtp.gmail.com with ESMTPSA id c24sm15588447pgj.11.2021.07.11.17.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 17:35:34 -0700 (PDT)
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
Subject: [RFC PATCH bpf-next v1 06/14] MIPS: eBPF: fix JIT static analysis hang with bounded loops
Date:   Sun, 11 Jul 2021 17:34:52 -0700
Message-Id: <c802f35b32b863e87c99322a1ee51913f7d7b01f.1625970384.git.Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625970383.git.Tony.Ambardar@gmail.com>
References: <cover.1625970383.git.Tony.Ambardar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support for bounded loops allowed the verifier to output backward jumps
such as BPF_JMP_A(-4). These trap the JIT's static analysis in a loop,
resulting in a system hang and eventual RCU stall.

Fix by updating reg_val_propagate_range() to skip backward jumps when in
fallthrough mode and if the jump target has been visited already.

Trigger the bug using the test_verifier test "bounded loop that jumps out
rather than in".

Fixes: 2589726d12a1 ("bpf: introduce bounded loops")
Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
---
 arch/mips/net/ebpf_jit.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/mips/net/ebpf_jit.c b/arch/mips/net/ebpf_jit.c
index e60a089ee3b3..4f641dcb2031 100644
--- a/arch/mips/net/ebpf_jit.c
+++ b/arch/mips/net/ebpf_jit.c
@@ -1690,6 +1690,10 @@ static int reg_val_propagate_range(struct jit_ctx *ctx, u64 initial_rvt,
 				rvt[prog->len] = exit_rvt;
 				return idx;
 			case BPF_JA:
+			{
+				int tgt = idx + 1 + insn->off;
+				bool visited = (rvt[tgt] & RVT_FALL_THROUGH);
+
 				rvt[idx] |= RVT_DONE;
 				/*
 				 * Verifier dead code patching can use
@@ -1699,8 +1703,16 @@ static int reg_val_propagate_range(struct jit_ctx *ctx, u64 initial_rvt,
 				 */
 				if (insn->off == -1)
 					break;
+				/*
+				 * Bounded loops cause the same issues in
+				 * fallthrough mode; follow only if jump
+				 * target is unvisited to mitigate.
+				 */
+				if (insn->off < 0 && !follow_taken && visited)
+					break;
 				idx += insn->off;
 				break;
+			}
 			case BPF_JEQ:
 			case BPF_JGT:
 			case BPF_JGE:
-- 
2.25.1

