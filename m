Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B319748FE0C
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 17:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbiAPQ4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 11:56:55 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:49554
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232347AbiAPQ4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 11:56:54 -0500
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 76E5F3F1E1
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 16:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1642352213;
        bh=YzugGZRbxx4WYUIaptSHaE2f22Uz7DUDoWT6SRUIgIg=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=CLSDGdyahG3tsnzAfKL+Lh2VVOLOKfZU0PgKFxp/JcyB8lUnNqAeTbJxIAuaH29G5
         Vz0uDJ0cbw2qAfPS5dIAYHl7aeGALjfxTC0B1FT15j5HMmJdzzM9niK41FdEVJq4N+
         u8cYkO/bUErkfgXx3r/h3OINGE8wsLEK835njGXwWdNYQGLcH5ztiEfVcEYM6z0SU2
         cPr988h74ArEaqey2bxhILBXjMH/IH2KY3OhUixCHvQyfTg5nQHqHEW+htUe1wz+Ro
         8qsgpN5NA9d5pg43Ha67XbuWTw5u1q+HuCYzMp2Bd37Wm5Mg8ssb4i1Y/SPx8/Jkz7
         PwX9InYIrMe+Q==
Received: by mail-ed1-f71.google.com with SMTP id ej6-20020a056402368600b00402b6f12c3fso729576edb.8
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 08:56:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YzugGZRbxx4WYUIaptSHaE2f22Uz7DUDoWT6SRUIgIg=;
        b=kjIaaRxTdY859Np03wjO43/ziY6to1JsbzZmT9VwQOnKVi38iqdUqKCXC/MODbCWld
         sI5tO7qa66WpTs7CAs2W7ojhRlK3tmXT/lIKO6ie8k2+adh2XRseDZkntoSTJEivtOOQ
         vio2hdOJRD4ZHxIx99v57Cfe6W9cD833qEwYFZUCZ8XrJCsRWhw2mZeKDxWFU2xMnt7I
         UOmb+jqhhbqpJllyI9ICLQEiK7HWZeg6sepOvd+uuKqK9iGQBKzmh2i5DBFnYOmR2uVf
         UaJBgyHz/s8ZUBm7VqZB/SfqdqQJQYMKhWEkp+60vOp89ub1HpNU6f0BATak43X5sfUd
         Wc0g==
X-Gm-Message-State: AOAM531MB4FvgSzZTVmFnKEGOxTuIqOoZc65dLKKZnhCzhE8JOs2bdRS
        9eNmwbb16fxokMDrP0CF4noGdNq7hG1OrfmsgFa5POcDA5JDdh0mqI+Thb0nCv9yMgCVQ88iOHp
        NghMzFdXeBYY/mlcxBIm4CSxU83O1YUG1Rg==
X-Received: by 2002:a05:6402:34cb:: with SMTP id w11mr16836116edc.158.1642352213115;
        Sun, 16 Jan 2022 08:56:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwSJ9LARJ17NVWSTuoi7uIrWHgrP0FXxPsCQej9gNfc0s7FzzbnbniMV/z0Ky2BUE6atp3z7w==
X-Received: by 2002:a05:6402:34cb:: with SMTP id w11mr16836102edc.158.1642352212839;
        Sun, 16 Jan 2022 08:56:52 -0800 (PST)
Received: from [192.168.0.35] (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id ga37sm3661428ejc.142.2022.01.16.08.56.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Jan 2022 08:56:52 -0800 (PST)
Message-ID: <1a1129d3-38a0-f126-fc63-97708103b140@canonical.com>
Date:   Sun, 16 Jan 2022 17:56:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [syzbot] general protection fault in nfc_alloc_send_skb
Content-Language: en-US
To:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+7f23bcddf626e0593a39@syzkaller.appspotmail.com>
Cc:     nixiaoming@huawei.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        syzkaller-bugs@googlegroups.com
References: <000000000000b5eac805d4d686d4@google.com>
 <20220116114236.2135-1-hdanton@sina.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220116114236.2135-1-hdanton@sina.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/01/2022 12:42, Hillf Danton wrote:
> On Wed, 05 Jan 2022 06:25:31 -0800
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    eec4df26e24e Merge tag 's390-5.16-6' of git://git.kernel.o..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=149771a5b00000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=dc943eeb68074e3
>> dashboard link: https://syzkaller.appspot.com/bug?extid=7f23bcddf626e0593a39
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=133e5e2bb00000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=152e6571b00000
>>
>> The issue was bisected to:
>>
>> commit c33b1cc62ac05c1dbb1cdafe2eb66da01c76ca8d
>> Author: Xiaoming Ni <nixiaoming@huawei.com>
>> Date:   Thu Mar 25 03:51:10 2021 +0000
>>
>>     nfc: fix refcount leak in llcp_sock_bind()
>>
>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16b92ba3b00000
>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=15b92ba3b00000
>> console output: https://syzkaller.appspot.com/x/log.txt?x=11b92ba3b00000
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+7f23bcddf626e0593a39@syzkaller.appspotmail.com
>> Fixes: c33b1cc62ac0 ("nfc: fix refcount leak in llcp_sock_bind()")
>>
>> general protection fault, probably for non-canonical address 0xdffffc00000000c2: 0000 [#1] PREEMPT SMP KASAN
>> KASAN: null-ptr-deref in range [0x0000000000000610-0x0000000000000617]
>> CPU: 1 PID: 7219 Comm: syz-executor408 Not tainted 5.16.0-rc7-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> RIP: 0010:nfc_alloc_send_skb+0x3a/0x190 net/nfc/core.c:722
>> Code: 54 41 89 d4 55 53 48 89 fb 48 8d ab 10 06 00 00 48 83 ec 08 e8 47 53 92 f8 48 89 ea 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 14 01 00 00 48 8d bb 14 06 00
>> RSP: 0018:ffffc9000ca97888 EFLAGS: 00010202
>> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
>> RDX: 00000000000000c2 RSI: ffffffff88e474b9 RDI: 0000000000000000
>> RBP: 0000000000000610 R08: ffffc9000ca97938 R09: 0000000000000880
>> R10: ffffffff88e6031d R11: 000000000000087f R12: 0000000000000000
>> R13: 0000000000000082 R14: ffff88807ca8b000 R15: ffffc9000ca97938
>> FS:  00007f6b81ae2700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00007fff1b2fd960 CR3: 000000007ca3a000 CR4: 00000000003506e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
>>  <TASK>
>>  nfc_llcp_send_ui_frame+0x2c0/0x430 net/nfc/llcp_commands.c:759
>>  llcp_sock_sendmsg+0x2b9/0x3a0 net/nfc/llcp_sock.c:803
>>  sock_sendmsg_nosec net/socket.c:704 [inline]
>>  sock_sendmsg+0xcf/0x120 net/socket.c:724
>>  ____sys_sendmsg+0x331/0x810 net/socket.c:2409
>>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
>>  __sys_sendmmsg+0x195/0x470 net/socket.c:2549
>>  __do_sys_sendmmsg net/socket.c:2578 [inline]
>>  __se_sys_sendmmsg net/socket.c:2575 [inline]
>>  __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2575
>>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>> RIP: 0033:0x7f6b81b51f89
>> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007f6b81ae22f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
>> RAX: ffffffffffffffda RBX: 0000000000000033 RCX: 00007f6b81b51f89
>> RDX: 0000000000000006 RSI: 0000000020004540 RDI: 0000000000000003
>> RBP: 00007f6b81bdb3f8 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000040 R11: 0000000000000246 R12: 00007f6b81bdb3f0
>> R13: 93cb663f6753dadd R14: 4b973dfbaeacdab3 R15: f981dd66eb1318f7
>>  </TASK>
>> Modules linked in:
>> ---[ end trace 570920f865b173be ]---
>> RIP: 0010:nfc_alloc_send_skb+0x3a/0x190 net/nfc/core.c:722
>> Code: 54 41 89 d4 55 53 48 89 fb 48 8d ab 10 06 00 00 48 83 ec 08 e8 47 53 92 f8 48 89 ea 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 14 01 00 00 48 8d bb 14 06 00
>> RSP: 0018:ffffc9000ca97888 EFLAGS: 00010202
>> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
>> RDX: 00000000000000c2 RSI: ffffffff88e474b9 RDI: 0000000000000000
>> RBP: 0000000000000610 R08: ffffc9000ca97938 R09: 0000000000000880
>> R10: ffffffff88e6031d R11: 000000000000087f R12: 0000000000000000
>> R13: 0000000000000082 R14: ffff88807ca8b000 R15: ffffc9000ca97938
>> FS:  00007f6b81ae2700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00007fff1b2fd960 CR3: 000000007ca3a000 CR4: 00000000003506e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> ----------------
>> Code disassembly (best guess):
>>    0:	54                   	push   %rsp
>>    1:	41 89 d4             	mov    %edx,%r12d
>>    4:	55                   	push   %rbp
>>    5:	53                   	push   %rbx
>>    6:	48 89 fb             	mov    %rdi,%rbx
>>    9:	48 8d ab 10 06 00 00 	lea    0x610(%rbx),%rbp
>>   10:	48 83 ec 08          	sub    $0x8,%rsp
>>   14:	e8 47 53 92 f8       	callq  0xf8925360
>>   19:	48 89 ea             	mov    %rbp,%rdx
>>   1c:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
>>   23:	fc ff df
>>   26:	48 c1 ea 03          	shr    $0x3,%rdx
>> * 2a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax <-- trapping instruction
>>   2e:	84 c0                	test   %al,%al
>>   30:	74 08                	je     0x3a
>>   32:	3c 03                	cmp    $0x3,%al
>>   34:	0f 8e 14 01 00 00    	jle    0x14e
>>   3a:	48                   	rex.W
>>   3b:	8d                   	.byte 0x8d
>>   3c:	bb                   	.byte 0xbb
>>   3d:	14 06                	adc    $0x6,%al
>>
>>
>> ---
>> This report is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for more information about syzbot.
>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>
>> syzbot will keep track of this issue. See:
>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
>> syzbot can test patches for this issue, for details see:
>> https://goo.gl/tpsmEJ#testing-patches
> 
> Before sending frame out, check llcp dev bond to llcp sock and bail out in
> case of invalid device.
> 
> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> 
> --- a/net/nfc/llcp_sock.c
> +++ b/net/nfc/llcp_sock.c
> @@ -798,6 +798,10 @@ static int llcp_sock_sendmsg(struct sock
>  			return -EINVAL;
>  		}
>  
> +		if (llcp_sock->dev == NULL) {
> +			release_sock(sk);
> +			return -EBADFD;
> +		}
>  		release_sock(sk);
>  

The patch looks the same as mine, except the test for ->dev is slightly
later. Why sending the same set? My patch was already tested:

2022/01/15 11:54
https://github.com/krzk/linux 0b15d8c51584646c5fcd3a58053f11ac3b5f2cda	OK

2022/01/15 11:51
https://github.com/krzk/linux 2e3adbe9c476cdfdc8da33ab83cf7a25715579f1	OK

2022/01/15 11:46
https://github.com/krzk/linux 6dcaa73089529a86e92d901c5f740b6529531c33	OK

The test for llcp_sock->dev is equal to my test of local, because they
are the same (assigned to NULL or to meaningful value), when accessed
under lock.

Best regards,
Krzysztof
