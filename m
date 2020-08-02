Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69650239CF0
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 01:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgHBXBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 19:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbgHBXBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 19:01:09 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C62C06174A;
        Sun,  2 Aug 2020 16:01:09 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ha11so10366787pjb.1;
        Sun, 02 Aug 2020 16:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=uZ5xf5K5F6IXKJ1bHVKUxDYDtmw93bV77H+P4Hdhxpw=;
        b=JRyBHz/Qm/Zn7f5p1TlKPAnZ1NX0e2CS2T2j+yV9XMeXBYATNQj87tOEQ3igINch3z
         peRzkc3stoDtpC33Ej8bVin6JNMFntHB7Da6nz+zmcvcWgA/E/aX5AjYEYBOeDD7Il+9
         AHCRSQUGiWJvfbDW5Xzan4hIfwtTxdpFZKXPL/nIAEeGjx13yLHxy78zOVzyyveny8YT
         X9yabu1w9zIQDmf8X4YuBDzXH1I3PlX7ymQxzrx4V8Kd5RJZolVj6VWUJBrZsWFe30P7
         9KaO/f4cif3fPnpiIFcXMWXKx2a2BJT6CRx4KJ7NMJEpylBsJQvWMgnfdXU1YM/F7UVs
         vK4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uZ5xf5K5F6IXKJ1bHVKUxDYDtmw93bV77H+P4Hdhxpw=;
        b=KjSCZdYA9WRwoXVfSP9MKmSQvpDsz13OYvwjcobdXlv6WkreqMQj5QanKFSMSzl6Uw
         9EbmhgAAWuAfbCER6WY2afyA/yBAvA61vueOyFeejh4EE3QierjkOuzPvQnXiPA6XzOC
         W9v4SIMTfgSAFqV9gOj7i1OeuWQswm4dqxND42rYXK3YS2eetN0oTiaGvy7c6b3kydL4
         z2Pzje1EHBDyjSQStXVbIJ/3uj1CITN5fiEQEMwWHe/dIpxXIsapdxUK5mnKMA8Ut28M
         Q314xshsXm6PP7JPIIzaE7jVufi0gUOQqDxliV9dl3zBOZBoIS3JYOvNo4+w+fHu1TX8
         INZw==
X-Gm-Message-State: AOAM533AAE6fst0R6Nr/HtV3um220dKU+vAXIkacQZvVFFzSXYhdKTow
        RwABOb/CKfnJKUL7gdrERiF8h/s2
X-Google-Smtp-Source: ABdhPJzATiT0H6891gyPi5Ro6fA1TcnURhx7rHO9tb4Bil3XSbt1xCPKLGnTXMcujtcN4Z4fWXUXYg==
X-Received: by 2002:a17:902:64:: with SMTP id 91mr12682813pla.62.1596409268717;
        Sun, 02 Aug 2020 16:01:08 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id 199sm18540220pgc.79.2020.08.02.16.01.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Aug 2020 16:01:07 -0700 (PDT)
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in
 bpf_prog_ADDR
To:     syzbot <syzbot+192a7fbbece55f740074@syzkaller.appspotmail.com>,
        andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
References: <00000000000006209e05abecc711@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <618c205e-c92f-1c3a-94a3-00793f0ad279@gmail.com>
Date:   Sun, 2 Aug 2020 16:01:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <00000000000006209e05abecc711@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/2/20 3:45 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    ac3a0c84 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13234970900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c0cfcf935bcc94d2
> dashboard link: https://syzkaller.appspot.com/bug?extid=192a7fbbece55f740074
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=141541ea900000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+192a7fbbece55f740074@syzkaller.appspotmail.com
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 9176a067 P4D 9176a067 PUD 9176b067 PMD 0 
> Oops: 0000 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 8142 Comm: syz-executor.2 Not tainted 5.8.0-rc7-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:bpf_prog_e48ebe87b99394c4+0x1f/0x590
> Code: cc cc cc cc cc cc cc cc cc cc cc 0f 1f 44 00 00 55 48 89 e5 48 81 ec 00 00 00 00 53 41 55 41 56 41 57 6a 00 31 c0 48 8b 47 28 <48> 8b 40 00 8b 80 00 01 00 00 5b 41 5f 41 5e 41 5d 5b c9 c3 cc cc
> RSP: 0018:ffffc900038a7b00 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: dffffc0000000000 RCX: dffffc0000000000
> RDX: ffff88808cfb0200 RSI: ffffc90000e7e038 RDI: ffffc900038a7ca8
> RBP: ffffc900038a7b28 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: ffffc90000e7e000
> R13: ffffc90000e7e000 R14: 0000000000000001 R15: 0000000000000000
> FS:  00007fda07fef700(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 0000000091769000 CR4: 00000000001406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  bpf_prog_run_xdp include/linux/filter.h:734 [inline]
>  bpf_test_run+0x221/0xc70 net/bpf/test_run.c:47
>  bpf_prog_test_run_xdp+0x2ca/0x510 net/bpf/test_run.c:524
>  bpf_prog_test_run kernel/bpf/syscall.c:2983 [inline]
>  __do_sys_bpf+0x2117/0x4b10 kernel/bpf/syscall.c:4135
>  do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x45cc79
> Code: 2d b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb b5 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007fda07feec78 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 0000000000001740 RCX: 000000000045cc79
> RDX: 0000000000000028 RSI: 0000000020000080 RDI: 000000000000000a
> RBP: 000000000078bfe0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078bfac
> R13: 00007ffc3ef769bf R14: 00007fda07fef9c0 R15: 000000000078bfac
> Modules linked in:
> CR2: 0000000000000000
> ---[ end trace b2d24107e7fdae7d ]---
> RIP: 0010:bpf_prog_e48ebe87b99394c4+0x1f/0x590
> Code: cc cc cc cc cc cc cc cc cc cc cc 0f 1f 44 00 00 55 48 89 e5 48 81 ec 00 00 00 00 53 41 55 41 56 41 57 6a 00 31 c0 48 8b 47 28 <48> 8b 40 00 8b 80 00 01 00 00 5b 41 5f 41 5e 41 5d 5b c9 c3 cc cc
> RSP: 0018:ffffc900038a7b00 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: dffffc0000000000 RCX: dffffc0000000000
> RDX: ffff88808cfb0200 RSI: ffffc90000e7e038 RDI: ffffc900038a7ca8
> RBP: ffffc900038a7b28 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: ffffc90000e7e000
> R13: ffffc90000e7e000 R14: 0000000000000001 R15: 0000000000000000
> FS:  00007fda07fef700(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 0000000091769000 CR4: 00000000001406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 


# https://syzkaller.appspot.com/bug?id=d60883a0b19a778d2bcab55f3f6459467f4a3ea7
# See https://goo.gl/kgGztJ for information about syzkaller reproducers.
#{"threaded":true,"collide":true,"repeat":true,"procs":6,"sandbox":"none","fault_call":-1,"tun":true,"netdev":true,"resetnet":true,"cgroups":true,"binfmt_misc":true,"close_fds":true,"vhci":true,"tmpdir":true,"segv":true}
bpf$PROG_LOAD(0x5, &(0x7f00000ba000)={0x6, 0x4, &(0x7f0000346fc8)=@framed={{}, [@alu={0x8000000201a7f19, 0x0, 0x201a7fa6, 0x0, 0x1, 0x14}]}, &(0x7f0000000040)='syzkaller\x00', 0x1, 0xfb, &(0x7f0000002880)=""/251, 0x0, 0x0, [], 0x0, 0x21}, 0x48)
r0 = bpf$PROG_LOAD(0x5, &(0x7f00002a0fb8)={0x13, 0x4, &(0x7f0000000480)=ANY=[@ANYBLOB="8500000011000000350000000000000085000000230000009500000d000000003c8ea5932cf669ebecab19b3fd50fec5eade4bb02a231016bc5733a4f152b8bdfdfebcfdaf3d5363dd79d50034e58579eda0cfe296"], &(0x7f0000000140)='GPL\x00', 0x4, 0x99, &(0x7f0000000180)=""/153, 0x0, 0x0, [], 0x0, 0x0, 0xffffffffffffffff, 0x8, 0x0, 0x0, 0x10, 0x0, 0xfffffffffffffd0c}, 0x64)
bpf$BPF_PROG_TEST_RUN(0xa, &(0x7f0000000080)={r0, 0x1000000, 0xe, 0x0, &(0x7f00000000c0)="61df712bc884fed5722780b6c2a7", 0x0, 0x8000, 0x0, 0xff9f}, 0x28)


Not clear how a BPF_PROG_TYPE_LWT_SEG6LOCAL ends up using bpf_prog_test_run_xdp() ?


