Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69BF3C406C
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 02:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232441AbhGLAi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 20:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbhGLAiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 20:38:20 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD346C0613E5;
        Sun, 11 Jul 2021 17:35:32 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id j199so14757453pfd.7;
        Sun, 11 Jul 2021 17:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rbuIp1F5x+tOiZk7AWK2VpM3BgvTmXRq6ziDa20X64M=;
        b=qaFCBPwxWK1kfUGYKxNlk76YwLxzZZIq0eUWqFER6NhghR6f8waNuy6PVGnKeY4Gfb
         NdyhRnDqzTDoBVHBhROGBxLDOoRzgrl7/XjJQEygaQPZ9d1Mgkc0dYkiDB4VybbhdNLA
         XWbTGbEO4jodA8R9NXFE/BcXSxAfUw2rzaN8Xc7kAu9d8lTcoKrdD6SCX79z35Y9KXwa
         2EfAXXFSBQM71dBbISjhIpiwii5En6qmX5okaoKsZdAOsrV6qZcGMPlcFwEAoAp8r3jA
         f0/qlBHWFb5vHecriO+iXKGjL6blgwpv/edMFuohJACXUCEUBFNu5HDRDGxo1iZDUqMV
         uK6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rbuIp1F5x+tOiZk7AWK2VpM3BgvTmXRq6ziDa20X64M=;
        b=gWctw0bIC5TBCCD+MlBfkb9xZZqXbxXb6Dc6MSuSj+MTSk+LP6T+cMmX1N6kvSDlAy
         kHAd4n3mFqZHBP4ojkJObghW+hf3zIrj5rOR/5Kv/ORzOenHdDUEJlbQW2nCP4nyRYM0
         6SGDtB2EWvdSHSt88xxQbqtwU525ulfqqhnilo370RHMfXu/rB4twgYYPu3jFSVreXle
         0+G4yfehqyiwEW2V7B8PAvEMSnX+F25gBqWCAl3runUKmtJKCcOS+37otdZuCZWZN/Im
         XSEHyim059sIw7EK2J5ruaJXgwl6Ijn4cYRFrPI625xEk2A6Piiv74qqWHWrROwrWaae
         UuLw==
X-Gm-Message-State: AOAM5322fJz+rYeTebhnHW3jHBS06hm47akJICbe4sGrwjWfW300wgkI
        onJE8AGilMgd8zdWTvgRyTc=
X-Google-Smtp-Source: ABdhPJzJbyShIsw7/h4jB/HBczHcq5fPPi4talLuofAWQCtnBVUSRW907GLIqS2Z2wvoAxla4pXCgw==
X-Received: by 2002:a63:5144:: with SMTP id r4mr51042008pgl.223.1626050132292;
        Sun, 11 Jul 2021 17:35:32 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:4039:6c0e:1168:cc74])
        by smtp.gmail.com with ESMTPSA id c24sm15588447pgj.11.2021.07.11.17.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 17:35:32 -0700 (PDT)
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
Subject: [RFC PATCH bpf-next v1 04/14] MIPS: eBPF: support BPF_JMP32 in JIT static analysis
Date:   Sun, 11 Jul 2021 17:34:50 -0700
Message-Id: <e9c2f39a9260229e9853460a74f6e3388842fef8.1625970384.git.Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625970383.git.Tony.Ambardar@gmail.com>
References: <cover.1625970383.git.Tony.Ambardar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While the MIPS64 JIT rejects programs with JMP32 insns, it still performs
initial static analysis. Add support in reg_val_propagate_range() for
BPF_JMP32, fixing kernel log WARNINGs ("Unhandled BPF_JMP case") seen
during JIT testing. Handle code BPF_JMP32 the same as BPF_JMP.

Fixes: 092ed0968bb6 ("bpf: verifier support JMP32")
Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
---
 arch/mips/net/ebpf_jit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/net/ebpf_jit.c b/arch/mips/net/ebpf_jit.c
index 67b45d502435..ad0e54a842fc 100644
--- a/arch/mips/net/ebpf_jit.c
+++ b/arch/mips/net/ebpf_jit.c
@@ -1683,6 +1683,7 @@ static int reg_val_propagate_range(struct jit_ctx *ctx, u64 initial_rvt,
 			rvt[idx] |= RVT_DONE;
 			break;
 		case BPF_JMP:
+		case BPF_JMP32:
 			switch (BPF_OP(insn->code)) {
 			case BPF_EXIT:
 				rvt[idx] = RVT_DONE | exit_rvt;
-- 
2.25.1

