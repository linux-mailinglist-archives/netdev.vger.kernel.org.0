Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2E36ACF6B
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 21:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjCFUru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 15:47:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjCFUrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 15:47:49 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F61474C6;
        Mon,  6 Mar 2023 12:47:48 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id x7so4746661pff.7;
        Mon, 06 Mar 2023 12:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678135668;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ALke21ayoQkWY0L22vxziMX8UvumG0KlzaxKt2xuq7E=;
        b=ntqeBMJE+2KzrXXZgbWzhr0Cs5mwVyjz9WEv+fwDz7I0d/Kisfi3gdXTR8dZmWPOHg
         Bg2iC4uzuD8N1fjYyRw8OPSDxFz2Ia9O3ZdWEulNn9gZO4rWchCPAI6FrHKirOT0UbNP
         M3/chfOG23anLSOaS4522bB3mIc3BARm4nDMhoYS6DtFQB4fJMW/MUekkTLRf8gkcwQ1
         GG65uF486vXuoztzCI3Sr+NlwA4WxVW2rmQRG2JKMS4e+rl9nptp51XE+cqQgFd1S4mW
         4d2Wu5tWwtkyWHivshX2qW6TZaDjJ+VDzTXIprDzDBC73iDZooDOkPQ01TUUt/GP23bS
         TjNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678135668;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ALke21ayoQkWY0L22vxziMX8UvumG0KlzaxKt2xuq7E=;
        b=TDkt2ESFkVMwe0xaxG03I5b9gwCcxseaqDmmVpkYoq+XFj5xcPcD3Ecl7ATVGYJ1F+
         yf4p5Kc25bSwPHSPRGMKnfojM/8XJmDW/cyDPzcbF8kmtJ6T1A0gKoJ3Q/wIdbXAw7cW
         PcLuof/ozXad60qQmESryfWveMlfkhY/cFNhjhkufCUDShF1vPbZ1xPxTtj+F3+G1Xhr
         sTkhlIGGBdIBFaEABD0kZ5K5qhiB1oVQ4B0tGZgS2XP/2zOb3Kg5W50y2IElgg8xcSWM
         WC/yAZWEm//1MB33bMFJI/expM3eIpItLvYT54eU99whg6eLlDdyOtuh2OMRcBibINOS
         DkxA==
X-Gm-Message-State: AO0yUKURHXHZVYMJy+C48AXi1vw4JoTRl9fRHCt/mn9RLiaNfP8k4oRn
        Ad7wQwfzMgnBmjuNvD3eBEE=
X-Google-Smtp-Source: AK7set/vvzPOz842V1YJga2q6Rb32rCIQIrdkYcTyGocjiDpTJ9F1F+BtR58Iur1o3jEVURHfCkBYw==
X-Received: by 2002:aa7:9ed0:0:b0:5a9:c0f3:a0cd with SMTP id r16-20020aa79ed0000000b005a9c0f3a0cdmr11531612pfq.33.1678135667684;
        Mon, 06 Mar 2023 12:47:47 -0800 (PST)
Received: from vernon-pc.. ([49.67.2.142])
        by smtp.gmail.com with ESMTPSA id e23-20020aa78c57000000b005a75d85c0c7sm6699772pfd.51.2023.03.06.12.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 12:47:47 -0800 (PST)
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
Date:   Tue,  7 Mar 2023 04:47:19 +0800
Message-Id: <20230306204723.2584724-1-vernon2gm@gmail.com>
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

