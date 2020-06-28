Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1ECD20C76E
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 12:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgF1Kqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 06:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbgF1Kqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 06:46:30 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C663C061794
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 03:46:30 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id q90so6040309pjh.3
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 03:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TTtXa32uJyWj3FRcxIy4EyMjKYs5SGNE53PC4IscXDE=;
        b=jOulqLsVlrSWBX+LT1abjIINRCsX/cnP1J7x71HAzH4RQh1LbA26mGKdjTYlzEuE66
         LRjwsaONRcYMhDptwHb8IDkOl0DRcpGcq7B8Sn5ZiKueMqAnaxCjHR1g6v+bqF0agYYN
         o8gV0Sl4X9LYHf+XtkPII832oOzQltEuq8w1422UU/7kZf5T7SO/OB0CMZUgODXeYze7
         Ma4iM7vAFfox2wL5l8DELr3nPu97fFH6MYV32hh1lDHqGznOCFs6Qgk2cE4uH0gWANAf
         3RL/E2ImJugwvJbU2GvLbHXc7M2E9jZ7HW3ha7+hiDP2m0eWliXQ6TnEijyz0DmTnyVc
         bIgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TTtXa32uJyWj3FRcxIy4EyMjKYs5SGNE53PC4IscXDE=;
        b=S3YCsiBps9Ea6FcywZvwBJpVWC80EKYz6sBk08Z0+ii79IA+mWdX/TOGMl/xVmwd5w
         t3uvT3CFbn1w7tqZZxYdL80L3eQy1QgoXiTyhIGFnwSi3W9p7hAIPB8H5WVRwS2jvIu/
         ytOmf0GP5/fFqBPZtPNMO8feBtECQ3MFTca+0l+/gNoaU2iYTCVj346kwrCmjHSoSuea
         2EzMIMXSlEemXvboFpZB9ElJWrOFIsPje/QYqTPGRMLrzDu9OB5KIQdEHrbrc0rBOWor
         RTIH+H50gOtM7oFeI+ll6vTTvIGysd7ZKA8dOzpgpflgNP/DhBAguoCF0Tu3vGOxEf2V
         wjhQ==
X-Gm-Message-State: AOAM530D6pPy1wuxlaYhsN3H5rGlldx7VxMr8aYLA4uOfDEprWUF2xud
        93OsojK/I4VFUU/HNJnuw1pC9Flt8w==
X-Google-Smtp-Source: ABdhPJySkC8UYu4uVLtRsEZKAK0N9fXaRefUcuzqmHHs2lLB4Wvq6N7U3XM0KIROl6KaHS9zGFVTyg==
X-Received: by 2002:a17:90a:2dcb:: with SMTP id q11mr5157690pjm.135.1593341189484;
        Sun, 28 Jun 2020 03:46:29 -0700 (PDT)
Received: from Mani-XPS-13-9360 ([2409:4072:59f:de4a:a853:58c7:2fe6:68c8])
        by smtp.gmail.com with ESMTPSA id j8sm2416598pfd.145.2020.06.28.03.46.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 28 Jun 2020 03:46:28 -0700 (PDT)
Date:   Sun, 28 Jun 2020 16:16:23 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     bjorn.andersson@linaro.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: slab-out-of-bounds Read in qrtr_endpoint_post
Message-ID: <20200628104623.GA3357@Mani-XPS-13-9360>
References: <000000000000f728fc05a90ce9c9@google.com>
 <000000000000e817ba05a91711b0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000e817ba05a91711b0@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bjorn,

On Sat, Jun 27, 2020 at 01:57:13PM -0700, syzbot wrote:
> syzbot has found a reproducer for the following crash on:
> 
> HEAD commit:    1590a2e1 Merge tag 'acpi-5.8-rc3' of git://git.kernel.org/..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=14b2b503100000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=bf3aec367b9ab569
> dashboard link: https://syzkaller.appspot.com/bug?extid=b8fe393f999a291a9ea6
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> userspace arch: i386
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=109e6b55100000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13671a3d100000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+b8fe393f999a291a9ea6@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in qrtr_endpoint_post+0xeeb/0x1010 net/qrtr/qrtr.c:462
> Read of size 2 at addr ffff88809de50c48 by task syz-executor531/6806
> 
> CPU: 0 PID: 6806 Comm: syz-executor531 Not tainted 5.8.0-rc2-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x18f/0x20d lib/dump_stack.c:118
>  print_address_description.constprop.0.cold+0xae/0x436 mm/kasan/report.c:383
>  __kasan_report mm/kasan/report.c:513 [inline]
>  kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
>  qrtr_endpoint_post+0xeeb/0x1010 net/qrtr/qrtr.c:462
>  qrtr_tun_write_iter+0xf5/0x180 net/qrtr/tun.c:92

Hmm. Is this due to the fact that we are not checking the length of the
kbuf allocated in qrtr_tun_write_iter()? The length derived from
'iov_iter_count(from)' gets used directly and that might be causing the
out of bound access error here.

Thanks,
Mani

>  call_write_iter include/linux/fs.h:1907 [inline]
>  do_iter_readv_writev+0x567/0x780 fs/read_write.c:694
>  do_iter_write+0x188/0x5f0 fs/read_write.c:999
>  compat_writev+0x1ea/0x390 fs/read_write.c:1352
>  do_compat_pwritev64+0x180/0x1b0 fs/read_write.c:1401
>  do_syscall_32_irqs_on+0x3f/0x60 arch/x86/entry/common.c:403
>  __do_fast_syscall_32 arch/x86/entry/common.c:448 [inline]
>  do_fast_syscall_32+0x7f/0x120 arch/x86/entry/common.c:474
>  entry_SYSENTER_compat+0x6d/0x7c arch/x86/entry/entry_64_compat.S:138
> RIP: 0023:0xf7f8f569
> Code: Bad RIP value.
> RSP: 002b:00000000ffda5ffc EFLAGS: 00000292 ORIG_RAX: 000000000000014e
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000020000440
> RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00000000080bb528
> RBP: 0000000000000012 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> 
> Allocated by task 6806:
>  save_stack+0x1b/0x40 mm/kasan/common.c:48
>  set_track mm/kasan/common.c:56 [inline]
>  __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:494
>  __do_kmalloc mm/slab.c:3656 [inline]
>  __kmalloc+0x17a/0x340 mm/slab.c:3665
>  kmalloc include/linux/slab.h:560 [inline]
>  kzalloc include/linux/slab.h:669 [inline]
>  qrtr_tun_write_iter+0x8a/0x180 net/qrtr/tun.c:83
>  call_write_iter include/linux/fs.h:1907 [inline]
>  do_iter_readv_writev+0x567/0x780 fs/read_write.c:694
>  do_iter_write+0x188/0x5f0 fs/read_write.c:999
>  compat_writev+0x1ea/0x390 fs/read_write.c:1352
>  do_compat_pwritev64+0x180/0x1b0 fs/read_write.c:1401
>  do_syscall_32_irqs_on+0x3f/0x60 arch/x86/entry/common.c:403
>  __do_fast_syscall_32 arch/x86/entry/common.c:448 [inline]
>  do_fast_syscall_32+0x7f/0x120 arch/x86/entry/common.c:474
>  entry_SYSENTER_compat+0x6d/0x7c arch/x86/entry/entry_64_compat.S:138
> 
> Freed by task 1:
>  save_stack+0x1b/0x40 mm/kasan/common.c:48
>  set_track mm/kasan/common.c:56 [inline]
>  kasan_set_free_info mm/kasan/common.c:316 [inline]
>  __kasan_slab_free+0xf5/0x140 mm/kasan/common.c:455
>  __cache_free mm/slab.c:3426 [inline]
>  kfree+0x103/0x2c0 mm/slab.c:3757
>  tomoyo_path_perm+0x234/0x3f0 security/tomoyo/file.c:842
>  security_inode_getattr+0xcf/0x140 security/security.c:1278
>  vfs_getattr fs/stat.c:121 [inline]
>  vfs_statx+0x170/0x390 fs/stat.c:206
>  vfs_lstat include/linux/fs.h:3301 [inline]
>  __do_sys_newlstat+0x91/0x110 fs/stat.c:374
>  do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> The buggy address belongs to the object at ffff88809de50c40
>  which belongs to the cache kmalloc-32 of size 32
> The buggy address is located 8 bytes inside of
>  32-byte region [ffff88809de50c40, ffff88809de50c60)
> The buggy address belongs to the page:
> page:ffffea0002779400 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88809de50fc1
> flags: 0xfffe0000000200(slab)
> raw: 00fffe0000000200 ffffea000277e008 ffffea0002761c88 ffff8880aa0001c0
> raw: ffff88809de50fc1 ffff88809de50000 000000010000003f 0000000000000000
> page dumped because: kasan: bad access detected
> 
> Memory state around the buggy address:
>  ffff88809de50b00: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
>  ffff88809de50b80: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
> >ffff88809de50c00: fb fb fb fb fc fc fc fc 04 fc fc fc fc fc fc fc
>                                               ^
>  ffff88809de50c80: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
>  ffff88809de50d00: fb fb fb fb fc fc fc fc 00 01 fc fc fc fc fc fc
> ==================================================================
> 
