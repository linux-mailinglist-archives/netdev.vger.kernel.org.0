Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8DE36ACFB9
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 22:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjCFVDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 16:03:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjCFVDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 16:03:39 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB262A142;
        Mon,  6 Mar 2023 13:03:38 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id c4so6785509pfl.0;
        Mon, 06 Mar 2023 13:03:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678136617;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ALke21ayoQkWY0L22vxziMX8UvumG0KlzaxKt2xuq7E=;
        b=dq1qws33eSzUQoMWKQoVhDGX7FvLjEo4RJynQpgas1xOWMEd1p5JJwMdSTftqVrVoO
         YqUxqdYeFOnDUjFsPc69Y80LlIaZAoJS+uQyicJfbjsEDXKhM4vpIycXl7TGzqKYTrly
         AEpCx1JH4ItL05QVjBydjKA+RYz5s8ECS5+PL0FOlho8mZ98FkgOoDEujhE2kbbn6+RY
         iDnEu2NisN8hGQLOjgmHhjkgG/VRaFL2SkwGWBYTBdqAqQZrbbTj7bTxu67L7Y2+m2Uw
         PhBoA36LccFDg22jWzepasIJO8T+H7Igx6H6PBRZvMSvJlbUm8OubJLt/Bdo+PngMHrb
         pNVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678136617;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ALke21ayoQkWY0L22vxziMX8UvumG0KlzaxKt2xuq7E=;
        b=fLAeqHgCeWE/a/FoSNNRdVTnmeYs/8kuZzjphNETtgoEDe2AjE5LnWb61SjfqsDkVl
         Gsl9eJonBEoEOgOfud38YUiioDuBPLcNGgJd3Zb/YcW8EvlQbIMrDE90edq/9BwSDbUc
         P7MfYoa8ZX+aB4zGNPWh0M+4C44IYIihEsOPLzGPY/OKn4odM1trzrHRYQ71heqZL5m8
         O88x1pED9XbAwyq7NErF6wADlngG6W4+CYRWKWjUfVF5mFbcy9qjzy/s6j6Nj13AEJxb
         idfV90gE665Equi1tVb7bnI+cwcjE3iSEnKyoo99mNP42iQOLs0q7aMSfkGE8kCbD0ke
         X+jA==
X-Gm-Message-State: AO0yUKXfSh9hvylG0sqG64ZO6a7Oq48RLdQOjm7lxOikwRlXhIEAnRDO
        yhIHsT2dtZpFGNE5+ZVKZQU=
X-Google-Smtp-Source: AK7set/wQNs82KbKZiuvxKV3IY2LzYna1mzKV3W6SMibkAz9nHPaBMj4JtAhVESg1r781eAwAXcDkw==
X-Received: by 2002:a05:6a00:2d28:b0:5a8:4ae7:25d5 with SMTP id fa40-20020a056a002d2800b005a84ae725d5mr18172405pfb.8.1678136617624;
        Mon, 06 Mar 2023 13:03:37 -0800 (PST)
Received: from vernon-pc.. ([49.67.2.142])
        by smtp.gmail.com with ESMTPSA id 3-20020aa79143000000b005810c4286d6sm6706760pfi.0.2023.03.06.13.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 13:03:37 -0800 (PST)
From:   Vernon Yang <vernon2gm@gmail.com>
To:     torvalds@linux-foundation.org, tytso@mit.edu, Jason@zx2c4.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        yury.norov@gmail.com, andriy.shevchenko@linux.intel.com,
        linux@rasmusvillemoes.dk, james.smart@broadcom.com,
        dick.kennedy@broadcom.com
Cc:     linux-kernel@vger.kernel.org, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
        Vernon Yang <vernon2gm@gmail.com>
Subject: [PATCH v2 0/4] fix call cpumask_next() if no further cpus set
Date:   Tue,  7 Mar 2023 05:03:08 +0800
Message-Id: <20230306210312.2614988-1-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I updated the Linux kernel to commit fe15c26ee26e ("Linux 6.3-rc1")
and found that when the system boots to systemd ranom initialization,
panic, as follows:

[    3.607299] BUG: unable to handle page fault for address: 000000000001cc43
[    3.607558] #PF: supervisor read access in kernel mode
[    3.607704] #PF: error_code(0x0000) - not-present page
[    3.607704] PGD 0 P4D 0
[    3.607704] Oops: 0000 [#1] PREEMPT SMP NOPTI
[    3.607704] CPU: 1 PID: 1 Comm: systemd Not tainted 6.3.0-rc1 #50
[    3.607704] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
[    3.607704] RIP: 0010:_raw_spin_lock+0x12/0x30
[    3.607704] Code: 84 00 00 00 00 00 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 65 ff 05 dd de 1e 7e 31 c0 ba 01 00 00 00 <f0> 0f b1 17 75 05 c3 cc cc cc cc 89 c6 e9 9c 00 00 00 6
[    3.607704] RSP: 0018:ffffc90000013d50 EFLAGS: 00000002
[    3.607704] RAX: 0000000000000000 RBX: 0000000000000040 RCX: 0000000000000002
[    3.607704] RDX: 0000000000000001 RSI: 0000000000000246 RDI: 000000000001cc43
[    3.607704] RBP: ffffc90000013dc8 R08: 00000000d6fbd601 R09: 0000000065abc912
[    3.607704] R10: 00000000ba93b167 R11: 000000007bb5d0bf R12: 000000000001cc43
[    3.607704] R13: 000000000001cc43 R14: 0000000000000003 R15: 0000000000000003
[    3.607704] FS:  00007fbd4911b400(0000) GS:ffff88807dd00000(0000) knlGS:0000000000000000
[    3.607704] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.607704] CR2: 000000000001cc43 CR3: 0000000003b42000 CR4: 00000000000006e0
[    3.607704] Call Trace:
[    3.607704]  <TASK>
[    3.607704]  add_timer_on+0x80/0x130
[    3.607704]  try_to_generate_entropy+0x246/0x270
[    3.607704]  ? do_filp_open+0xb1/0x160
[    3.607704]  ? __pfx_entropy_timer+0x10/0x10
[    3.607704]  ? inode_security+0x1d/0x60
[    3.607704]  urandom_read_iter+0x23/0x90
[    3.607704]  vfs_read+0x203/0x2d0
[    3.607704]  ksys_read+0x5e/0xe0
[    3.607704]  do_syscall_64+0x3f/0x90
[    3.607704]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[    3.607704] RIP: 0033:0x7fbd49a25992
[    3.607704] Code: c0 e9 b2 fe ff ff 50 48 8d 3d fa b2 0c 00 e8 c5 1d 02 00 0f 1f 44 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 0f 05 <48> 3d 00 f0 ff ff 77 56 c3 0f 1f 44 00 00 48 83 ec 28 4
[    3.607704] RSP: 002b:00007ffea3fe8318 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[    3.607704] RAX: ffffffffffffffda RBX: 0000000000000010 RCX: 00007fbd49a25992
[    3.607704] RDX: 0000000000000010 RSI: 00007ffea3fe83a0 RDI: 000000000000000c
[    3.607704] RBP: 000000000000000c R08: 3983c6a57a866072 R09: c736ebfbeb917d7e
[    3.607704] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[    3.607704] R13: 0000000000000001 R14: 00007ffea3fe83a0 R15: 00005609e5454ea8
[    3.607704]  </TASK>
[    3.607704] Modules linked in:
[    3.607704] CR2: 000000000001cc43
[    3.607704] ---[ end trace 0000000000000000 ]---
[    3.607704] RIP: 0010:_raw_spin_lock+0x12/0x30
[    3.607704] Code: 84 00 00 00 00 00 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 65 ff 05 dd de 1e 7e 31 c0 ba 01 00 00 00 <f0> 0f b1 17 75 05 c3 cc cc cc cc 89 c6 e9 9c 00 00 00 6
[    3.607704] RSP: 0018:ffffc90000013d50 EFLAGS: 00000002
[    3.607704] RAX: 0000000000000000 RBX: 0000000000000040 RCX: 0000000000000002
[    3.607704] RDX: 0000000000000001 RSI: 0000000000000246 RDI: 000000000001cc43
[    3.607704] RBP: ffffc90000013dc8 R08: 00000000d6fbd601 R09: 0000000065abc912
[    3.607704] R10: 00000000ba93b167 R11: 000000007bb5d0bf R12: 000000000001cc43
[    3.607704] R13: 000000000001cc43 R14: 0000000000000003 R15: 0000000000000003
[    3.607704] FS:  00007fbd4911b400(0000) GS:ffff88807dd00000(0000) knlGS:0000000000000000
[    3.607704] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.607704] CR2: 000000000001cc43 CR3: 0000000003b42000 CR4: 00000000000006e0
[    3.607704] note: systemd[1] exited with irqs disabled
[    3.618556] note: systemd[1] exited with preempt_count 2
[    3.618991] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
[    3.619797] Kernel Offset: disabled
[    3.619798] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009 ]---


Analysis add_timer_on() found that the parameter cpu is equal to 64, which
feels strange, because qemu only specifies two CPUs, continues to look up,
and finds that the parameter cpu is obtained by
try_to_generate_entropy() -> cpumask_next().

Then use git bisect to find the bug, and find that it was introduced by
commit 596ff4a09b89 ("cpumask: re-introduce constant-sized cpumask optimizations"),
carefully analyzing the cpumask_next() modification record, I found that
nr_cpumask_bits modified to small_cpumask_bits, and when NR_CPUS <= BITS_PER_LONG,
small_cpumask_bits is a macro and before nr_cpumask_bits is a variable-sized.

look for find_next_bit() If no bits are set, returns @size, I seem to
understand the cause of the problem.

I fixed this bug by make `if (cpu == nr_cpumask_bits)` to `if (cpu >= nr_cpu_ids)`

At the same time I think about this situation, maybe there are the same errors
elsewhere, check it, sure enough, there are, quite a few.

The patch "random:xxx" has been verified, it is valid, the other three fixes
have not been verified, because I do not have an environment, but they
principle are same, so also submitted at the same time, if someone helps to
verify, thanks you very much.

If there is anything error, please tell me, thanks.


v2 changes:
 - remove patch 5
 - make nr_cpumask_bits to nr_cpu_ids
 - add helper function to get next present cpu for lpfc_cpu_affinity_check
 - update commit comment

v1: https://lore.kernel.org/all/20230306160651.2016767-1-vernon2gm@gmail.com/

Vernon Yang (4):
  random: fix try_to_generate_entropy() if no further cpus set
  wireguard: fix wg_cpumask_choose_online() if no further cpus set
  scsi: lpfc: fix lpfc_cpu_affinity_check() if no further cpus set
  scsi: lpfc: fix lpfc_nvmet_setup_io_context() if no further cpus set

 drivers/char/random.c            |  2 +-
 drivers/net/wireguard/queueing.h |  2 +-
 drivers/scsi/lpfc/lpfc_init.c    | 43 +++++++++++++++-----------------
 drivers/scsi/lpfc/lpfc_nvmet.c   |  2 +-
 4 files changed, 23 insertions(+), 26 deletions(-)

--
2.34.1

