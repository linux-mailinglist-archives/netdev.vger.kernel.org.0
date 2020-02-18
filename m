Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0182162084
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 06:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgBRFn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 00:43:27 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:56028 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgBRFn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 00:43:27 -0500
Received: by mail-pj1-f65.google.com with SMTP id d5so512171pjz.5;
        Mon, 17 Feb 2020 21:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=WEpfeOp5vZhDYg4OxZGgpOVUu6OTNleZynBaicYdCeM=;
        b=KAo7jbuPiacrEd6LJdarm48YnC0xplHogBHcaipVbzri/Gf5EslQOdJtcB9sPEn1tc
         FCNw02PIEUpK2GqA5mvEOtVcNYM8eouQSqpH/mqfne0DV+I1mlxYO9X08MDWY7VJf5I5
         Poea88dwhMk4kfK9VKZB64vhEQjAN8XFHkYpE8hSA61Ap93DWrc4cg840jhgCHyQbgtT
         l0YCysWVj616uMKRAYtcltUMf2RhH06BupNjlXZIwZvs0FLoWFDkZUqBBNd/UeCLjDBw
         CVNdVyc2fthpNPqqbBy/zbaEFPLAD28JUusn4Mo+VO7LrP8toj+7w//y2xltkySs2vQj
         AGhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WEpfeOp5vZhDYg4OxZGgpOVUu6OTNleZynBaicYdCeM=;
        b=GRQnHTtqdZJFbeIiF4QIiOmdm7bh+24zg+5MSm5bKWyNzC+qA/Fi2SGAVZ4O0U8ms+
         qvqoxlS8Ay/8Ypu2HHC8J/pNDgv338sGWmcyM31P1ZZ9/HnXbMtqs4MKKjBNNb9VliX8
         r9iPwGo4rU4M/Yrq+3OtYlYk4oF55oh4Xz1XN2Ict9Q7u3eEX59LXMUiUuyG6bLAOr49
         o9nqNECWUOJdeLui0L6eWeYm7G5Lak7kZKYRw9cIQdCm3YGMTCbItk3Ixcac2GAIFqtb
         uifv8E4tdHxb9SzcMGcKRWgD+OnCBKSdbz0Bl4Rze/yhztC6geEZih5rCzm1mF4pGhgk
         G4MQ==
X-Gm-Message-State: APjAAAUIKmG0Sq630nR1XSiymqPWa3ak3MHpsMLLDNZtl1GoIL/2NXwN
        19dXzissJTbgh7ByX5Wzxh0=
X-Google-Smtp-Source: APXvYqxgoCOWtjTsIGW4bU5shwQO55FQSXikBaj4lrwMfTVwCeCN3H9Ietu8EChSfkmoDUEW3CJwOQ==
X-Received: by 2002:a17:90a:3745:: with SMTP id u63mr594668pjb.123.1582004606378;
        Mon, 17 Feb 2020 21:43:26 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id l29sm2658748pgb.86.2020.02.17.21.43.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 21:43:25 -0800 (PST)
Subject: Re: general protection fault in l2cap_sock_getsockopt
To:     syzbot <syzbot+6446a589a5ca34dd6e8b@syzkaller.appspotmail.com>,
        davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
References: <0000000000007838f1059ed1cea5@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <1a4385eb-ddae-5411-786d-e818f91dbb7c@gmail.com>
Date:   Mon, 17 Feb 2020 21:43:24 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <0000000000007838f1059ed1cea5@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/17/20 8:07 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    c25a951c Add linux-next specific files for 20200217
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=171b1a29e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c727d8fc485ff049
> dashboard link: https://syzkaller.appspot.com/bug?extid=6446a589a5ca34dd6e8b
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10465579e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16dabb11e00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+6446a589a5ca34dd6e8b@syzkaller.appspotmail.com
> 
> general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 0 PID: 9844 Comm: syz-executor679 Not tainted 5.6.0-rc2-next-20200217-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:l2cap_sock_getsockopt+0x7d3/0x1200 net/bluetooth/l2cap_sock.c:613
> Code: 00 00 00 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 a0 09 00 00 48 b8 00 00 00 00 00 fc ff df 49 8b 1f 48 89 da 48 c1 ea 03 <80> 3c 02 00 0f 85 75 09 00 00 48 8b 3b e8 cb be f6 ff be 67 02 00
> RSP: 0018:ffffc900062f7d20 EFLAGS: 00010246
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff87253e8c
> RDX: 0000000000000000 RSI: ffffffff87253f44 RDI: 0000000000000001
> RBP: ffffc900062f7e00 R08: ffff88808a5001c0 R09: fffffbfff16a3f80
> R10: fffffbfff16a3f7f R11: ffffffff8b51fbff R12: 0000000000000000
> R13: 1ffff92000c5efa7 R14: ffff8880a9a79000 R15: ffff8880a1d92000
> FS:  0000000001ccd880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000140 CR3: 0000000097113000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  __sys_getsockopt+0x16d/0x310 net/socket.c:2175
>  __do_sys_getsockopt net/socket.c:2190 [inline]
>  __se_sys_getsockopt net/socket.c:2187 [inline]
>  __x64_sys_getsockopt+0xbe/0x150 net/socket.c:2187
>  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x440149
> Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ffcb256f088 EFLAGS: 00000246 ORIG_RAX: 0000000000000037
> RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440149
> RDX: 000000000000000e RSI: 0000000000000112 RDI: 0000000000000003
> RBP: 00000000006ca018 R08: 0000000020000140 R09: 00000000004002c8
> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004019d0
> R13: 0000000000401a60 R14: 0000000000000000 R15: 0000000000000000
> Modules linked in:
> ---[ end trace 63f0b6416dbaab7d ]---
> RIP: 0010:l2cap_sock_getsockopt+0x7d3/0x1200 net/bluetooth/l2cap_sock.c:613
> Code: 00 00 00 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 a0 09 00 00 48 b8 00 00 00 00 00 fc ff df 49 8b 1f 48 89 da 48 c1 ea 03 <80> 3c 02 00 0f 85 75 09 00 00 48 8b 3b e8 cb be f6 ff be 67 02 00
> RSP: 0018:ffffc900062f7d20 EFLAGS: 00010246
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff87253e8c
> RDX: 0000000000000000 RSI: ffffffff87253f44 RDI: 0000000000000001
> RBP: ffffc900062f7e00 R08: ffff88808a5001c0 R09: fffffbfff16a3f80
> R10: fffffbfff16a3f7f R11: ffffffff8b51fbff R12: 0000000000000000
> R13: 1ffff92000c5efa7 R14: ffff8880a9a79000 R15: ffff8880a1d92000
> FS:  0000000001ccd880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000140 CR3: 0000000097113000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 

Probably caused by commit eab2404ba798a8efda2a970f44071c3406d94e57
Author: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Date:   Fri Feb 14 10:08:57 2020 -0800

    Bluetooth: Add BT_PHY socket option

