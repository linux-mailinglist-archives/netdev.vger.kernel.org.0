Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A17E539905
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 23:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348242AbiEaVvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 17:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348166AbiEaVvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 17:51:19 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD5E8DDEF;
        Tue, 31 May 2022 14:51:18 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id cx11so163569pjb.1;
        Tue, 31 May 2022 14:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xNiDmxR/YSSyIMHXUqsxokdrXLBmJy7+nVNVk9CH478=;
        b=SXDkFPA+JKI0VDgFGl7eP/63xBwJUxQ4DRbTiGqMZKvYqYY0455rM/9yzue19TIZEB
         1amqlA6bZjndpWvACc7697Qx+tAjTU78/4d/Enmz+UpOG0mfTYay3Vbdl0rkW1N+bRVA
         t8u2RZKu1u7jDALxfWrFgzDd1iwEQUWKM2x7YjW87mtMOw7yZubXRTe7N4lDqCDGAs6v
         9drlSScSynhw/pWSXcQn0eWOQqJPse9mqWXE7UYz9m5GlQIMe3r9IvivWkyy2xJC0710
         qtzjmYkKEv4+vs5+Wnw8SJRTwp0+MXQQhRdHtyauH1EeuqOC53iL2GXLF3/J6nq89LSO
         jMZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xNiDmxR/YSSyIMHXUqsxokdrXLBmJy7+nVNVk9CH478=;
        b=dtxuVV0R+Hhm67XDci2Yngi4M1WNq1mIRxqgQPWCZz9sG5wtyPVNLe/SJX4FP29fnF
         z8nT9OE5txfP9CC4XYtk7Ke+iurL0evZeb13yAE0YHTSJeawVLJmAgkBu1LtntaNsW/p
         +ujmxYsD4W/3xtil1Udb+Rgiq8ofqiKv5y0tDivN7/BfXcgee02hbk4erEuJe4UWJ7os
         tRXs7yQO1X/3VG2MtHr8Rj1+LZjwhEhG6m4r6te3a1GU4flJkyGjAo5v9DOS5/qCLJ3G
         1Xb5sjgWwyeO/nLSsh/OPs/Swq9a4voabGohdPaaxTPOVBoFcdgxKfskcGsG7iEZt+zG
         t5pA==
X-Gm-Message-State: AOAM532Umq5j4lYcSaI+Rtafs/+TC77HMCDAACBiTAo3rHtEpw6WPcgh
        qFVeF7cgHKoh0Wfxby36euU=
X-Google-Smtp-Source: ABdhPJyg8TOK7ejftKI/4vYkb7XlH/dfkuICuN+hEaSblXzb3AJhZ4oz5Oexy2xI5Z/heIVY8+db8w==
X-Received: by 2002:a17:903:2c7:b0:158:2f26:6016 with SMTP id s7-20020a17090302c700b001582f266016mr63256373plk.154.1654033877983;
        Tue, 31 May 2022 14:51:17 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:74f8:d874:7d9d:dabb])
        by smtp.gmail.com with ESMTPSA id v202-20020a6361d3000000b003f60a8d7dadsm1971732pgb.15.2022.05.31.14.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 14:51:17 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        bpf <bpf@vger.kernel.org>, syzbot <syzkaller@googlegroups.com>
Subject: [PATCH bpf] bpf: arm64: clear prog->jited_len along prog->jited
Date:   Tue, 31 May 2022 14:51:13 -0700
Message-Id: <20220531215113.1100754-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

syzbot reported an illegal copy_to_user() attempt
from bpf_prog_get_info_by_fd() [1]

There was no repro yet on this bug, but I think
that commit 0aef499f3172 ("mm/usercopy: Detect vmalloc overruns")
is exposing a prior bug in bpf arm64.

bpf_prog_get_info_by_fd() looks at prog->jited_len
to determine if the JIT image can be copied out to user space.

My theory is that syzbot managed to get a prog where prog->jited_len
has been set to 43, while prog->bpf_func has ben cleared.

It is not clear why copy_to_user(uinsns, NULL, ulen) is triggering
this particular warning.
I thought find_vma_area(NULL) would not find a vm_struct.
As we do not hold vmap_area_lock spinlock, it might be possible
that the found vm_struct was garbage.

[1]
usercopy: Kernel memory exposure attempt detected from vmalloc (offset 792633534417210172, size 43)!
kernel BUG at mm/usercopy.c:101!
Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 PID: 25002 Comm: syz-executor.1 Not tainted 5.18.0-syzkaller-10139-g8291eaafed36 #0
Hardware name: linux,dummy-virt (DT)
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : usercopy_abort+0x90/0x94 mm/usercopy.c:101
lr : usercopy_abort+0x90/0x94 mm/usercopy.c:89
sp : ffff80000b773a20
x29: ffff80000b773a30 x28: faff80000b745000 x27: ffff80000b773b48
x26: 0000000000000000 x25: 000000000000002b x24: 0000000000000000
x23: 00000000000000e0 x22: ffff80000b75db67 x21: 0000000000000001
x20: 000000000000002b x19: ffff80000b75db3c x18: 00000000fffffffd
x17: 2820636f6c6c616d x16: 76206d6f72662064 x15: 6574636574656420
x14: 74706d6574746120 x13: 2129333420657a69 x12: 73202c3237313031
x11: 3237313434333533 x10: 3336323937207465 x9 : 657275736f707865
x8 : ffff80000a30c550 x7 : ffff80000b773830 x6 : ffff80000b773830
x5 : 0000000000000000 x4 : ffff00007fbbaa10 x3 : 0000000000000000
x2 : 0000000000000000 x1 : f7ff000028fc0000 x0 : 0000000000000064
Call trace:
 usercopy_abort+0x90/0x94 mm/usercopy.c:89
 check_heap_object mm/usercopy.c:186 [inline]
 __check_object_size mm/usercopy.c:252 [inline]
 __check_object_size+0x198/0x36c mm/usercopy.c:214
 check_object_size include/linux/thread_info.h:199 [inline]
 check_copy_size include/linux/thread_info.h:235 [inline]
 copy_to_user include/linux/uaccess.h:159 [inline]
 bpf_prog_get_info_by_fd.isra.0+0xf14/0xfdc kernel/bpf/syscall.c:3993
 bpf_obj_get_info_by_fd+0x12c/0x510 kernel/bpf/syscall.c:4253
 __sys_bpf+0x900/0x2150 kernel/bpf/syscall.c:4956
 __do_sys_bpf kernel/bpf/syscall.c:5021 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:5019 [inline]
 __arm64_sys_bpf+0x28/0x40 kernel/bpf/syscall.c:5019
 __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
 invoke_syscall+0x48/0x114 arch/arm64/kernel/syscall.c:52
 el0_svc_common.constprop.0+0x44/0xec arch/arm64/kernel/syscall.c:142
 do_el0_svc+0xa0/0xc0 arch/arm64/kernel/syscall.c:206
 el0_svc+0x44/0xb0 arch/arm64/kernel/entry-common.c:624
 el0t_64_sync_handler+0x1ac/0x1b0 arch/arm64/kernel/entry-common.c:642
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:581
Code: aa0003e3 d00038c0 91248000 97fff65f (d4210000)

Fixes: db496944fdaa ("bpf: arm64: add JIT support for multi-function programs")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 arch/arm64/net/bpf_jit_comp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 8ab4035dea2742b704dc7501b0b2128320899b1e..42f2e9a8616c3095609c182e6f50defdbe862b46 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -1478,6 +1478,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 			bpf_jit_binary_free(header);
 			prog->bpf_func = NULL;
 			prog->jited = 0;
+			prog->jited_len = 0;
 			goto out_off;
 		}
 		bpf_jit_binary_lock_ro(header);
-- 
2.36.1.255.ge46751e96f-goog

