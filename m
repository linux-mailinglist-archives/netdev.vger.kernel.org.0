Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAAF538789D
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 14:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349000AbhERMXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 08:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243125AbhERMXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 08:23:06 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B24C061573;
        Tue, 18 May 2021 05:21:48 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id 10so7276349pfl.1;
        Tue, 18 May 2021 05:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=/ayvpNqF8OiVfxrAHqM3hBkI+xKgT2+iX8aSziO+eP0=;
        b=HAM4i2GAr+S9gWCKojPp0IDBiM+f3EiPYtRq80fAJgWcTB9IIdIBzNa2slTvZwHwxp
         UNdZsRIvyf2zszhPwQt/Asr8CG1HDO2Bu+Y4l4gsCUT4nIeJQPqs3LStlsJu2OfrvMzD
         DobsWgv3wU0Hg7JciYjqccNGiJIYH9SovtJaI32pNhD6keQVDbUHBUXSRqQPBn+ZaLjg
         /CaOZKoT1j8Lr5kC/cp+8RSIm55uEtSvQC6ahRgnTvD7Qcw/fTBthXVeaYI1qWboyrH2
         dFGShWZozTMfWxSztHBj/J9hpLBpvHjSjrl5EpUtMatJehrE8ram8wYlQZA16znDgJA/
         N2sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/ayvpNqF8OiVfxrAHqM3hBkI+xKgT2+iX8aSziO+eP0=;
        b=NljdERHdw718tquZh4SCSIz+HQXn+5odVPaletLWDM5SG3OlyOX818SNe6TL0rSqaH
         /07FxPsA2y58thhXhJ/ngQLpAxGxnb2G/94I9MdpOCeZ5Hssd4ZKYarIZrGsKMGAsb7I
         MqiiIuKJBA7zYLDAgQDzRIjfLlS7xHcQsg6sqMokCdu3ovrzGpLpYhvGfzWJ1jXyKmsw
         gvXLsK+lusLrTYOVj4MtzaKH/GTQZVrLLJTr5+0Jlxv/zGYoh/t92ti3xLXMSwXwog0O
         RvlY/wgKBmIjfDr3OAVsIyBVo9R1no90xf5LJ4ZrBD8n2CZfQ3D2Wed1l7+j4F1oGcpN
         BAag==
X-Gm-Message-State: AOAM532Hc5RB7s0L/XZPskQb/FzQ5SW/VvZdFm++eoeqkR+kaFTPRYHw
        oYSLT/kB8C+bxoSwSLNEA8M=
X-Google-Smtp-Source: ABdhPJwuPDnV+MLRz0CZWlvIfIZjPfqomWJIhbhBjVlnpCmOLHZzKsdvv76YYy0mbLLruwBMcB1JTg==
X-Received: by 2002:a65:60cc:: with SMTP id r12mr4896569pgv.164.1621340507962;
        Tue, 18 May 2021 05:21:47 -0700 (PDT)
Received: from bj10046pcu.spreadtrum.com ([117.18.48.102])
        by smtp.gmail.com with ESMTPSA id r28sm8937476pgm.53.2021.05.18.05.21.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 05:21:47 -0700 (PDT)
From:   Haidong Yao <yaohaidong369@gmail.com>
To:     Orson Zhai <orsonzhai@gmail.com>
Cc:     Chunyan Zhang <zhang.lyra@gmail.com>,
        Chunyan Zhang <Chunyan.Zhang@unisoc.com>,
        Orson Zhai <Orson.Zhai@unisoc.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, stable@vger.kernel.org,
        Haidong Yao <haidong.yao@unisoc.com>
Subject: [PATCH] ovl: useing ovl_revert_creds() instead of revert_creds(),
Date:   Tue, 18 May 2021 20:21:38 +0800
Message-Id: <20210518122138.22914-1-yaohaidong369@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haidong Yao <haidong.yao@unisoc.com>

After execution adb remout,happened crash.

Fixes: 292f902a40c1 ("ovl: check permission to open real file")

This fixes the warning below.

[  241.778266]c2 [T31619] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000004
[  241.796757]c2 [T31619] Mem abort info:
[  241.800475]c2 [T31619]   ESR = 0x96000005
[  241.804457]c2 [T31619]   EC = 0x25: DABT (current EL), IL = 32 bits
[  241.810686]c2 [T31619]   SET = 0, FnV = 0
[  241.814666]c2 [T31619]   EA = 0, S1PTW = 0
[  241.818733]c2 [T31619] Data abort info:
[  241.822542]c2 [T31619]   ISV = 0, ISS = 0x00000005
[  241.827302]c2 [T31619]   CM = 0, WnR = 0
[  241.831198]c2 [T31619] user pgtable: 4k pages, 39-bit VAs, pgdp=000000017709f000
[  241.838552]c2 [T31619] [0000000000000004] pgd=0000000000000000, pud=0000000000000000
[  241.846255]c2 [T31619] Internal error: Oops: 96000005 [#1] PREEMPT SMP
[  241.852746]c2 [T31619] sprd-sysdump: dump_die_cb save pregs_die_g ok .
[  242.021424]c2 [T31619] CPU: 2 PID: 31619 Comm: ylog.opentcpdum Tainted: G S      WC O      5.4.114-g23ed6b182f28-ab19500 #2
[  242.032496]c2 [T31619] Hardware name: Spreadtrum UMS512-1H10 SoC (DT)
[  242.038901]c2 [T31619] pstate: 20400085 (nzCv daIf +PAN -UAO)
[  242.044620]c2 [T31619] pc : bpf_get_current_uid_gid+0x1c/0x34
[  242.050331]c2 [T31619] lr : bpf_prog_4f08a086bc7e64fb_tracepoint_sche+0x5a0/0x2000
[  242.057852]c2 [T31619] sp : ffffffc018fab4e0
[  242.062093]c2 [T31619] x29: ffffffc018fab4e0 x28: 0000000005de0e82
[  242.068323]c2 [T31619] x27: ffffffc01008ee04 x26: 0000000000000000
[  242.074554]c2 [T31619] x25: ffffffc018fab640 x24: ffffffc000000000
[  242.080785]c2 [T31619] x23: ffffffc0121cf868 x22: 000000383e0d5d53
[  242.087015]c2 [T31619] x21: 0000000000000005 x20: 0000000000000007
[  242.093246]c2 [T31619] x19: fffffffebf93cac0 x18: ffffffc016d7d0a0
[  242.099477]c2 [T31619] x17: 0000007f477affdc x16: 0000000000002c26
[  242.105707]c2 [T31619] x15: 000000000000007f x14: 000000000000007f
[  242.111938]c2 [T31619] x13: 000000000001af6a x12: 0000000026762762
[  242.118169]c2 [T31619] x11: 001a39dd8df5aa00 x10: ffffffc010093398
[  242.124400]c2 [T31619] x9 : ffffffc0121bd018 x8 : 0000000000000000
[  242.130630]c2 [T31619] x7 : ffffff80c45c0110 x6 : ffffffc0123b9dc6
[  242.136862]c2 [T31619] x5 : ffffffc012399000 x4 : 0000000000000004
[  242.143093]c2 [T31619] x3 : ffffff80f3412d00 x2 : ffffff80d5395a00
[  242.149322]c2 [T31619] x1 : ffffffc018fab628 x0 : ffffff80c45c0110
[  242.155554]c2 [T31619] Call trace:
[  242.158931]c2 [T31619]  bpf_get_current_uid_gid+0x1c/0x34
[  242.164295]c2 [T31619]  bpf_prog_4f08a086bc7e64fb_tracepoint_sche+0x5a0/0x2000
[  242.171480]c2 [T31619]  trace_call_bpf+0x1b0/0x3d4
[  242.176240]c2 [T31619]  perf_trace_sched_switch+0x1a8/0x204
[  242.181779]c2 [T31619]  __schedule+0x828/0x9ac
[  242.186190]c2 [T31619]  preempt_schedule_common+0x17c/0x2bc
[  242.191730]c2 [T31619]  vprintk_emit+0x738/0x7c8
[  242.196316]c2 [T31619]  vprintk_func+0x238/0x274
[  242.200901]c2 [T31619]  printk+0x64/0x90
[  242.204799]c2 [T31619]  die_kernel_fault+0x4c/0x80
[  242.209556]c2 [T31619]  __do_kernel_fault+0x24c/0x268
[  242.214574]c2 [T31619]  do_page_fault+0xa4/0x744
[  242.219160]c2 [T31619]  do_translation_fault+0x60/0x80
[  242.224267]c2 [T31619]  do_mem_abort+0x68/0xfc
[  242.228681]c2 [T31619]  el1_da+0x1c/0xc0
[  242.232576]c2 [T31619]  cap_vm_enough_memory+0x20/0x84
[  242.237681]c2 [T31619]  insert_vm_struct+0xf4/0x3cc
[  242.242527]c2 [T31619]  bprm_mm_init+0x188/0x2ac
[  242.247113]c2 [T31619]  __do_execve_file+0x3f8/0x904
[  242.252045]c2 [T31619]  __arm64_sys_execve+0x50/0x64
[  242.256979]c2 [T31619]  el0_svc_common+0xc0/0x22c
[  242.261652]c2 [T31619]  el0_svc_handler+0x2c/0x3c
[  242.266323]c2 [T31619]  el0_svc+0x8/0xc
[  242.270137]c2 [T31619] Code: d503201f d5384108 b40000c8 f943a508 (f8404100)
[  242.277143]c2 [T31619] ---[ end trace d2bf18208d1aac17 ]---

Signed-off-by: Haidong Yao <haidong.yao@unisoc.com>
---
 fs/overlayfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 4d53d3b7e5fe..d9bc658f22ee 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -60,7 +60,7 @@ static struct file *ovl_open_realfile(const struct file *file,
 		realfile = open_with_fake_path(&file->f_path, flags, realinode,
 					       current_cred());
 	}
-	revert_creds(old_cred);
+	ovl_revert_creds(inode->i_sb, old_cred);
 
 	pr_debug("open(%p[%pD2/%c], 0%o) -> (%p, 0%o)\n",
 		 file, file, ovl_whatisit(inode, realinode), file->f_flags,
-- 
2.17.1

