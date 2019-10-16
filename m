Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C898D98D6
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 20:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394213AbfJPSDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 14:03:42 -0400
Received: from mail-lf1-f41.google.com ([209.85.167.41]:41038 "EHLO
        mail-lf1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390034AbfJPSDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 14:03:42 -0400
Received: by mail-lf1-f41.google.com with SMTP id r2so18220893lfn.8
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 11:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=AxiBOWwioKNOAlob2YOaqH2vPs3/2WKeZ6AlzDzO3Ww=;
        b=tVc3cNAJCclzWoo3iBCEOhRu2E4JBW8wuhROHsr4Tre2nPuPcuANmoWFMVy9IAAmLi
         lFH7VkaXHH9P97F5nreWNUMcOFNY4AMN3zaaSQ2wM2W6AtFbOYVY8LGtJLPWI89hPJi0
         QFPbnXyFK0eK5yMD7pT32kR5po4rcBFD+99fWEMpPNO0ZykOcWG5yLtBGTMRTSwVN56v
         2xikLtTUK81QhjAIizm/si+ZsR9SG/rWpoS9KuRgKXCnKoqUt75mjCpDFNz0jKLjl5FV
         uFEzOjQluPvbiVXncZdWBwwzifvmQ7s8iCDjYHxDxPope7pyk3Egs5Cecm84MB/Y0Pj1
         TZ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=AxiBOWwioKNOAlob2YOaqH2vPs3/2WKeZ6AlzDzO3Ww=;
        b=IpS/v0El4+6bNuz7vn9r+dGVRmxb6T6i7oBq2eOSxFfJ2pIB0be/ky/nBYHB4rFVTi
         O0jWwra/DqNiQqFtBrTq6CvYCJBirUYBMtdjfZ2DDpOpDEy++J5Z7JWOTjOZKDbcb2Wc
         dmyDKJlE/LdtYfc5+WRh5HNYnAQ0DWEoM6OXU6fpl+jhTim+uLZgmPsayn1pGRh6fj0D
         +AdgjYN0PVTppiODsoH0lkbLJHRQWKmu3vLyPbLSzwPbDB2hbgICjRBoKvBXP8STDdol
         zoMw0PXCPfEGsyT8SaMqflc7htUHo/WnZxXp8zJEU3XMCQaG4bSadoceC3yc14NlKe4X
         sxyw==
X-Gm-Message-State: APjAAAW/7JyLBPn7W5FpuXrb+gF7P/+gBL/ALGvCelIvzcOpwEhEasYz
        GUwx/tAMwvpD7RwZZYI5cVf6/wszhXiOIN9UOmhBtQ==
X-Google-Smtp-Source: APXvYqxjEqUK/3Y3Yt48nURJagxbHHrIDKovPqiIJQHoiHt+SO9AabUnFyGHOpj1JUlvjye3vJDF0C4fcXwDXSVbio4=
X-Received: by 2002:ac2:4566:: with SMTP id k6mr7104996lfm.132.1571249019669;
 Wed, 16 Oct 2019 11:03:39 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 16 Oct 2019 23:33:28 +0530
Message-ID: <CA+G9fYv=OJOwat_KqDBRFRZbTWfgjuFA-X3F5ZuJXJ8yrr1Tyw@mail.gmail.com>
Subject: linux-next: 20191016: remove_proc_entry: removing non-empty directory
 'net/dev_snmp6', leaking at least 'lo'
To:     Linux-Next Mailing List <linux-next@vger.kernel.org>
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linux next 20191016 booting on x86_64, arm and arm64 popping up kernel
warning while booting. Please find full log link and kernel config.

Linux version 5.4.0-rc3-next-20191016 (oe-user@oe-host) (gcc version
7.3.0 (GCC)) #1 SMP Wed Oct 16 05:26:04 UTC 2019

[    4.212923] ------------[ cut here ]------------
[    4.217585] remove_proc_entry: removing non-empty directory
'net/dev_snmp6', leaking at least 'lo'
[    4.226560] WARNING: CPU: 1 PID: 1 at
/usr/src/kernel/fs/proc/generic.c:682 remove_proc_entry+0x17a/0x190
[    4.227544] Modules linked in:
[    4.236693] usb 1-6: new high-speed USB device number 2 using xhci_hcd
[    4.227544] CPU: 1 PID: 1 Comm: swapper/0 Not tainted
5.4.0-rc3-next-20191016 #1
[    4.227544] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.2 05/23/2018
[    4.227544] RIP: 0010:remove_proc_entry+0x17a/0x190
[    4.227544] Code: 00 f0 03 b6 48 c7 c7 20 2e 3b b6 48 0f 45 c2 49
8b 94 24 a8 00 00 00 4c 8b 80 d0 00 00 00 48 8b 92 d0 00 00 00 e8 66
bd d2 ff <0f> 0b e9 71 ff ff ff e8 1a c0 d2 ff 66 2e 0f 1f 84 00 00 00
00 00
[    4.227544] RSP: 0000:ffffa893c0027d90 EFLAGS: 00010282
[    4.227544] RAX: 0000000000000000 RBX: ffff939fecba38b0 RCX: 0000000000000006
[    4.227544] RDX: 000000000000023f RSI: ffff939feea38848 RDI: ffff939feea38000
[    4.227544] RBP: ffffa893c0027dc0 R08: 0000000000000000 R09: 0000000000000000
[    4.227544] R10: 0000000000000000 R11: 0000000000000000 R12: ffff939fecba3800
[    4.227544] R13: ffff939feebea300 R14: ffffffffb6779028 R15: ffffffffb6852818
[    4.227544] FS:  0000000000000000(0000) GS:ffff939fef880000(0000)
knlGS:0000000000000000
[    4.227544] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    4.227544] CR2: 0000000000000000 CR3: 000000021c610001 CR4: 00000000003606e0
[    4.227544] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    4.227544] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    4.227544] Call Trace:
[    4.227544]  ipv6_proc_exit_net+0x33/0x50
[    4.227544]  ops_exit_list.isra.9+0x3b/0x70
[    4.227544]  unregister_pernet_operations+0xd5/0x130
[    4.372356] usb 1-6: New USB device found, idVendor=0781,
idProduct=5567, bcdDevice= 1.27
[    4.227544]  ? af_unix_init+0x53/0x53
[    4.227544]  unregister_pernet_subsys+0x21/0x30
[    4.227544]  ipv6_misc_proc_exit+0x15/0x20
[    4.227544]  inet6_init+0x2e0/0x379
[    4.227544]  do_one_initcall+0x61/0x2ea
[    4.383957] usb 1-6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    4.227544]  ? set_debug_rodata+0x17/0x17
[    4.227544]  ? rcu_read_lock_sched_held+0x4f/0x80
[    4.227544]  kernel_init_freeable+0x1ce/0x261
[    4.392145] usb 1-6: Product: Cruzer Blade
[    4.227544]  ? rest_init+0x250/0x250
[    4.227544]  kernel_init+0xe/0x110
[    4.227544]  ret_from_fork+0x3a/0x50
[    4.399727] usb 1-6: Manufacturer: SanDisk
[    4.227544] irq event stamp: 1259654
[    4.410691] usb 1-6: SerialNumber: 4C530012151025118543
[    4.227544] hardirqs last  enabled at (1259653):
[<ffffffffb4d6f4d8>] console_unlock+0x458/0x5c0
[    4.227544] hardirqs last disabled at (1259654):
[<ffffffffb4c01e3a>] trace_hardirqs_off_thunk+0x1a/0x20
[    4.227544] softirqs last  enabled at (1259650):
[<ffffffffb5e00338>] __do_softirq+0x338/0x43a
[    4.420405] usb-storage 1-6:1.0: USB Mass Storage device detected
[    4.227544] softirqs last disabled at (1259639):
[<ffffffffb4cfe728>] irq_exit+0xb8/0xc0
[    4.227544] ---[ end trace 7d85f17ab93457e2 ]---
[    4.497490] scsi host8: usb-storage 1-6:1.0
#
[    4.523053] NET: Unregistered protocol family 10

Full test log:
https://qa-reports.linaro.org/lkft/linux-next-oe-sanity/build/next-20191016/testrun/968688/log

kernel config:
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/intel-corei7-64/lkft/linux-next/626/config

- Naresh
