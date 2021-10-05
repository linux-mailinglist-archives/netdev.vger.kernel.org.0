Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A264220D3
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 10:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbhJEIds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 04:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233460AbhJEIdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 04:33:39 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A660C061755;
        Tue,  5 Oct 2021 01:31:49 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id q201so6452085pgq.12;
        Tue, 05 Oct 2021 01:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6XuRo9+dsLwMOEdoGhGnTKjYpBra+3KZ9lusvAfMqso=;
        b=TGpO7+Hsx23ekJIj0k//9H6Ms7oIBOKCV7BNtfOSpzZ3fgi7kZgQ4unSXlfxuSpP1K
         A87CBuOguCjsaSt7k7CXc/T2yrsT2uwM/RBeRdl2kbjuYEGrvwLXskyL+vHaS/YKDKFM
         Iql5sBSPCXZ4f4+AYkSbgJ82a6/HUS20Nd6r8B0p2o4+J52aEW6lSxKKoa8k3CjQWkhY
         1bvfTciU7O+wwbYX/I7BSBCcfG8VNuhuSxZyobFtpYHDszSzmITqP16lDFqopmzXhlPk
         klyKaoVcRXtAhNdi4OUA6R39srOLsiBaTUjBbpUxc08MuOtxvHngcrYHz3Jcb7qt/8Dz
         DVUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6XuRo9+dsLwMOEdoGhGnTKjYpBra+3KZ9lusvAfMqso=;
        b=RJplqjCsY9VXglpzdKpHVEOaKWOVuwxNo/MwEApMaVyuJo1zDkJeu6iQEBfm8u5E2G
         z4HuNzC3zCLtIVZaWEoL284lBq09Kk/GMYLAkgP1Q5nwagyLWZWw6xnxSxlROICU/sOL
         8UWhDaCcz5XD5dRdPLuyZGg9fEl3YEYr2yMyCHXioGeB/T3mSyesgdbMIWx0rdKnY/RS
         zKeZL11Bzhy939UjK2CyEWygfk8ktS3Z8hJ8vn94uEKwFADWgQBa6sZ8ob3pxllWgdwl
         C7tWlduOaZ8vlfJszdEBLTgaOZX6oLu0GPJ7pJs/g6YUj+hVb8auLP38EEPUk6Rrb+xi
         jcRQ==
X-Gm-Message-State: AOAM532KbXbcvuD1Ylu7VVk8Wmi6HeMOXZ/VGN78qByX/H6jfmB5CkQM
        BmiJvFfuoyGjTJeY7VW1Nmc=
X-Google-Smtp-Source: ABdhPJyLhqxZxibIepJ0YDGhNBSgdPWdkxN8oH95W/evrMgLubNxfcHaUIUoUPFOSQ7ymi8quwwpnQ==
X-Received: by 2002:a63:7543:: with SMTP id f3mr14725608pgn.449.1633422709011;
        Tue, 05 Oct 2021 01:31:49 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:78ba:4bcc:a59a:2284])
        by smtp.gmail.com with ESMTPSA id a15sm4941257pfg.53.2021.10.05.01.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 01:31:48 -0700 (PDT)
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
Subject: [RFC PATCH bpf-next v2 11/16] bpf: allow tailcalls in subprograms for MIPS64/MIPS32
Date:   Tue,  5 Oct 2021 01:26:55 -0700
Message-Id: <77dfea2d224e7545e5e4d3f350721d27e5a77b0d.1633392335.git.Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1633392335.git.Tony.Ambardar@gmail.com>
References: <cover.1625970383.git.Tony.Ambardar@gmail.com> <cover.1633392335.git.Tony.Ambardar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BPF core/verifier is hard-coded to permit mixing bpf2bpf and tail
calls for only x86-64. Change the logic to instead rely on a new weak
function 'bool bpf_jit_supports_subprog_tailcalls(void)', which a capable
JIT backend can override.

Update the x86-64 eBPF JIT to reflect this, and also enable the feature
for the MIPS64/MIPS32 JIT.

Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
---
 arch/mips/net/ebpf_jit.c    | 6 ++++++
 arch/x86/net/bpf_jit_comp.c | 6 ++++++
 include/linux/filter.h      | 1 +
 kernel/bpf/core.c           | 6 ++++++
 kernel/bpf/verifier.c       | 3 ++-
 5 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/mips/net/ebpf_jit.c b/arch/mips/net/ebpf_jit.c
index 7d8ed8bb19ab..501c1d532be6 100644
--- a/arch/mips/net/ebpf_jit.c
+++ b/arch/mips/net/ebpf_jit.c
@@ -2416,3 +2416,9 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 		bpf_jit_binary_free(header);
 	goto out_ctx;
 }
+
+/* Indicate the JIT backend supports mixing bpf2bpf and tailcalls. */
+bool bpf_jit_supports_subprog_tailcalls(void)
+{
+	return true;
+}
diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 3ae729bb2475..2d78588fb5b5 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -2367,3 +2367,9 @@ bool bpf_jit_supports_kfunc_call(void)
 {
 	return true;
 }
+
+/* Indicate the JIT backend supports mixing bpf2bpf and tailcalls. */
+bool bpf_jit_supports_subprog_tailcalls(void)
+{
+	return true;
+}
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 16e5cebea82c..50b50fb271b5 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -933,6 +933,7 @@ u64 __bpf_call_base(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
 struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog);
 void bpf_jit_compile(struct bpf_prog *prog);
 bool bpf_jit_needs_zext(void);
+bool bpf_jit_supports_subprog_tailcalls(void);
 bool bpf_jit_supports_kfunc_call(void);
 bool bpf_helper_changes_pkt_data(void *func);
 
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 189934d2a3f2..c82b48ed0005 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2366,6 +2366,12 @@ bool __weak bpf_jit_needs_zext(void)
 	return false;
 }
 
+/* Return TRUE if the JIT backend supports mixing bpf2bpf and tailcalls. */
+bool __weak bpf_jit_supports_subprog_tailcalls(void)
+{
+	return false;
+}
+
 bool __weak bpf_jit_supports_kfunc_call(void)
 {
 	return false;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6e2ebcb0d66f..267de5428fad 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5144,7 +5144,8 @@ static bool may_update_sockmap(struct bpf_verifier_env *env, int func_id)
 
 static bool allow_tail_call_in_subprogs(struct bpf_verifier_env *env)
 {
-	return env->prog->jit_requested && IS_ENABLED(CONFIG_X86_64);
+	return env->prog->jit_requested &&
+	       bpf_jit_supports_subprog_tailcalls();
 }
 
 static int check_map_func_compatibility(struct bpf_verifier_env *env,
-- 
2.25.1

