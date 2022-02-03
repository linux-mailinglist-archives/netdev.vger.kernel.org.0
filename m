Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B754E4A8FB8
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 22:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354656AbiBCVUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 16:20:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354664AbiBCVUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 16:20:46 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60D3C06173E
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 13:20:45 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id z199so4939348iof.10
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 13:20:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=UETRfPh6Wqht0/YhIX8NetSXGnpaHUGlAB3aQZ/aOxY=;
        b=OHVHCqax4u2Km7CnFwU2ykPQB3WWJ3+wDEc6u+lpBFuF2b9nhOTKThkj4cYe56dchD
         b8NvB3icfUqfrsDcnpQGfhKTWpEN3Gabxgvp4klkmKB5dUl3Zl6PcFGBZmOHgZTKcifI
         /z16bd4rKGd9ue/J7qUrc1gtsMaX1ujOtW0B6xDWn5ywMfw9Bgk0EMyZNdD8+0qxzjul
         RivdzXirTrrQ+dNVkB+IoKyCONSovlEwDCaVq/PpRR2GCrFINoaOI42aTUw0iIbrHkNA
         p72cmsdqKOsmCEPNPT7j6ZSMSww4fRl4f8c60SscYg/9iOa+BTo2qNVaHJk9DXuVebBW
         DF5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UETRfPh6Wqht0/YhIX8NetSXGnpaHUGlAB3aQZ/aOxY=;
        b=aOIDw4Hp9LgYmZMH80U6F13CoJxy33KdyMrGVGH+Z/rQf/k9XTSwIwXB5+odayN7rJ
         eDS1YJJbvk+MWryVl3PKvWC2NG0/FfajSyki5kReoXwlr/zzTOs1TvPsouU4mQvjcL5y
         DP0SUK4wA491Y0bhCxnPAXap2XMj7y2bwZFWFyI0hqLwklytGKghhMlxapD+L/+IyLpt
         K0MLfWYgHAYZ8fxPnBs1svnHH0FhoyexF9dTTJmEmw4XRxbGlqLoSCsIlEKucBrURI7W
         0gVZy4Qdd/pn+zv9Et0sq2ke1LfcSReIzq6bd/vkMOr/DObwUys4wXukEinJauZenKOi
         Dvmw==
X-Gm-Message-State: AOAM531JLVQ0PRGzeGUH0SiWfziyRGbqb3OrX67noEAe5dPSmDdeFNk9
        o8iZgMylKYEAQ6mKDwtWjDclfA==
X-Google-Smtp-Source: ABdhPJz6PrX3QvS+M/jEJz6sqfvGlbg88F5EDkuwsyj/dxzoXr+dbILY7vReO4+yIDuq6Yz+1NN/XQ==
X-Received: by 2002:a05:6638:25d4:: with SMTP id u20mr7173825jat.189.1643923245044;
        Thu, 03 Feb 2022 13:20:45 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id w5sm7805ilu.83.2022.02.03.13.20.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 13:20:44 -0800 (PST)
Subject: Re: [syzbot] general protection fault in submit_bio_checks
To:     syzbot <syzbot+2b3f18414c37b42dcc94@syzkaller.appspotmail.com>,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com,
        Christoph Hellwig <hch@lst.de>
References: <0000000000008c32e305d6d8e802@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fe92753c-f46b-8df0-78cf-226a4a2662ba@kernel.dk>
Date:   Thu, 3 Feb 2022 14:20:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0000000000008c32e305d6d8e802@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/30/22 9:06 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    b605fdc54c2b Add linux-next specific files for 20220128
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=150084b8700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=da5090473475f3ca
> dashboard link: https://syzkaller.appspot.com/bug?extid=2b3f18414c37b42dcc94
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+2b3f18414c37b42dcc94@syzkaller.appspotmail.com
> 
> general protection fault, probably for non-canonical address 0xdffffc000000002f: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000178-0x000000000000017f]
> CPU: 1 PID: 3642 Comm: syz-executor.5 Not tainted 5.17.0-rc1-next-20220128-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:blk_throtl_bio block/blk-throttle.h:175 [inline]
> RIP: 0010:submit_bio_checks+0x7c0/0x1bf0 block/blk-core.c:765
> Code: 08 3c 03 0f 8e 4a 11 00 00 48 b8 00 00 00 00 00 fc ff df 44 8b 6d 10 41 83 e5 01 4a 8d bc 2b 7c 01 00 00 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 09 11 00 00
> RSP: 0018:ffffc900028cf680 EFLAGS: 00010203
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 000000000000002f RSI: ffffffff83d5f41e RDI: 000000000000017d
> RBP: ffff88801e8be500 R08: ffffffff8a241580 R09: 0000000000000000
> R10: ffffffff83d5f410 R11: 0000000000000000 R12: 0000000000000000
> R13: 0000000000000001 R14: 00000000fffffffe R15: ffff88801ad9a4cc
> FS:  0000555556299400(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fed92bd5ec9 CR3: 000000003b65d000 CR4: 00000000003526e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  __submit_bio+0xaf/0x360 block/blk-core.c:802
>  __submit_bio_noacct_mq block/blk-core.c:881 [inline]
>  submit_bio_noacct block/blk-core.c:907 [inline]
>  submit_bio_noacct+0x6c9/0x8a0 block/blk-core.c:896
>  submit_bio block/blk-core.c:968 [inline]
>  submit_bio+0x1ea/0x430 block/blk-core.c:926
>  write_dev_flush fs/btrfs/disk-io.c:4243 [inline]
>  barrier_all_devices fs/btrfs/disk-io.c:4293 [inline]
>  write_all_supers+0x3038/0x4440 fs/btrfs/disk-io.c:4388
>  btrfs_commit_transaction+0x1be3/0x3180 fs/btrfs/transaction.c:2362
>  btrfs_commit_super+0xc1/0x100 fs/btrfs/disk-io.c:4562
>  close_ctree+0x314/0xccc fs/btrfs/disk-io.c:4671
>  generic_shutdown_super+0x14c/0x400 fs/super.c:462
>  kill_anon_super+0x36/0x60 fs/super.c:1056
>  btrfs_kill_super+0x38/0x50 fs/btrfs/super.c:2365
>  deactivate_locked_super+0x94/0x160 fs/super.c:332
>  deactivate_super+0xad/0xd0 fs/super.c:363
>  cleanup_mnt+0x3a2/0x540 fs/namespace.c:1159
>  task_work_run+0xdd/0x1a0 kernel/task_work.c:164
>  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
>  exit_to_user_mode_prepare+0x27e/0x290 kernel/entry/common.c:207
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
>  syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
>  do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7fe814b274c7
> Code: ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48

Christoph, looks like an issue with replacing bio_set_dev() with just
assigning bio->bi_bdev in bio_reset(). The latter does not associate the
blkcg, for example, which is what is causing this oops.

-- 
Jens Axboe

