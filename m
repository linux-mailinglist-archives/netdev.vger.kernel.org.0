Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F484902F6
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 08:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237564AbiAQHgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 02:36:09 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:60934
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232208AbiAQHgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 02:36:08 -0500
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 8FC183F1C9
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 07:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1642404959;
        bh=LzQEUQFhjrXuC3r9u+Skj35mFkTJiuPnDN7KQoYYWN0=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=kzcksVTbjDJauOkH1S262Zm3Lim8v8LN8UrLqClkICuuhOTgSzlw3Aov2wIC4cFLR
         wDYQcXXdz2fxz/xCizjO/UXaFcZtfZ+1kBiksjQH9177SuzWTRbD3z1kmAqrThBOlw
         ccsAagiiIJnnAHyMt2PA9EkyFIk79BJY06j0o9CrmOWFnyRjPbLaLLZvkOS8kWe0gA
         e/geLMDAJq2B1TPG6vAHepHWl6wdYtM7hRSx4WFKEctEzk8X3dwOSgo223KJjGwvUF
         1jKWPOwrb4ITByy4mQPXu/87iAy4Q2kSZCmuV431kSHXTKIYqGQettUkCa7RkFrgdA
         FeHSs1pcZ5w6w==
Received: by mail-ed1-f72.google.com with SMTP id c8-20020a05640227c800b003fdc1684cdeso13436559ede.12
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 23:35:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LzQEUQFhjrXuC3r9u+Skj35mFkTJiuPnDN7KQoYYWN0=;
        b=W+85hYYZahylmknXLFHCTreC8qpwivNDqTkcCQmZ+Xj5szUL3oYDMDLR49Ykg8PdxG
         0Rzl27JH52u6mCwsCA+/4FHIpsxYdhP9wy+xxfJPdZyc5KwaE0JK1xy/2PLhkE8NM2FW
         xyukANo2gi2GnLfIQ2eGMycBC/1QOad5Lv5X0fGWkIsby71JS4tnPWCzV3gp97f5l7Wr
         1W5Cr2l7Mer0xdpZqU1516N7AfjcZV05MrgNayh2WjSbav4rQdpMyjBy5I3DSJ96uTGZ
         S7h+XdaEqMDNKYSzbDujj3anKVHx59PYalwqbf54oU+COBHxGVXsreyRX9LHqsmYXBoU
         ZNOA==
X-Gm-Message-State: AOAM530eBuUTS/6Oe03AzmmrSq65NZUWCKSkJZYAI82nOkpR648rNVcj
        Urr7d8sGetzO4QMPDY/JNQiQ+jWSoyff8/aCpCSiZodMlhuDtMFpPy8HJuyTlNKkQT6TVcfYqPE
        ELCGwAmmlq6bSIDhY+SDvP9iF0slWEifbAQ==
X-Received: by 2002:a05:6402:195:: with SMTP id r21mr19110299edv.174.1642404959052;
        Sun, 16 Jan 2022 23:35:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwtW4aKRa07u+PD8YQUUdOj7Pn5EMPQTCrjLxPt5cNsJh/j5t2paT7FHSCYeLH25QctZWxWbA==
X-Received: by 2002:a05:6402:195:: with SMTP id r21mr19110283edv.174.1642404958877;
        Sun, 16 Jan 2022 23:35:58 -0800 (PST)
Received: from [192.168.0.35] (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id 14sm4091325ejk.215.2022.01.16.23.35.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Jan 2022 23:35:58 -0800 (PST)
Message-ID: <d9691d32-40f5-14ee-027f-e7d431c94084@canonical.com>
Date:   Mon, 17 Jan 2022 08:35:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [syzbot] general protection fault in nfc_alloc_send_skb
Content-Language: en-US
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+7f23bcddf626e0593a39@syzkaller.appspotmail.com>,
        nixiaoming@huawei.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        syzkaller-bugs@googlegroups.com
References: <000000000000b5eac805d4d686d4@google.com>
 <20220116114236.2135-1-hdanton@sina.com>
 <20220117011137.2254-1-hdanton@sina.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220117011137.2254-1-hdanton@sina.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/01/2022 02:11, Hillf Danton wrote:
> On Sun, 16 Jan 2022 17:56:51 +0100 Krzysztof Kozlowski wrote:
>> On 16/01/2022 12:42, Hillf Danton wrote:
>>> On Wed, 05 Jan 2022 06:25:31 -0800
>>>> Hello,
>>>>
>>>> syzbot found the following issue on:
>>>>
>>>> HEAD commit:    eec4df26e24e Merge tag 's390-5.16-6' of git://git.kernel.o..
>>>> git tree:       upstream
>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=149771a5b00000
>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=dc943eeb68074e3
>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=7f23bcddf626e0593a39
>>>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=133e5e2bb00000
>>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=152e6571b00000
>>>>
>>>> The issue was bisected to:
>>>>
>>>> commit c33b1cc62ac05c1dbb1cdafe2eb66da01c76ca8d
>>>> Author: Xiaoming Ni <nixiaoming@huawei.com>
>>>> Date:   Thu Mar 25 03:51:10 2021 +0000
>>>>
>>>>     nfc: fix refcount leak in llcp_sock_bind()
>>>>
>>>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16b92ba3b00000
>>>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=15b92ba3b00000
>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=11b92ba3b00000
>>>>
>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>>> Reported-by: syzbot+7f23bcddf626e0593a39@syzkaller.appspotmail.com
>>>> Fixes: c33b1cc62ac0 ("nfc: fix refcount leak in llcp_sock_bind()")
>>>>
>>>> general protection fault, probably for non-canonical address 0xdffffc00000000c2: 0000 [#1] PREEMPT SMP KASAN
>>>> KASAN: null-ptr-deref in range [0x0000000000000610-0x0000000000000617]
>>>> CPU: 1 PID: 7219 Comm: syz-executor408 Not tainted 5.16.0-rc7-syzkaller #0
>>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>>>> RIP: 0010:nfc_alloc_send_skb+0x3a/0x190 net/nfc/core.c:722
>>>> Code: 54 41 89 d4 55 53 48 89 fb 48 8d ab 10 06 00 00 48 83 ec 08 e8 47 53 92 f8 48 89 ea 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 14 01 00 00 48 8d bb 14 06 00
>>>> RSP: 0018:ffffc9000ca97888 EFLAGS: 00010202
>>>> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
>>>> RDX: 00000000000000c2 RSI: ffffffff88e474b9 RDI: 0000000000000000
>>>> RBP: 0000000000000610 R08: ffffc9000ca97938 R09: 0000000000000880
>>>> R10: ffffffff88e6031d R11: 000000000000087f R12: 0000000000000000
>>>> R13: 0000000000000082 R14: ffff88807ca8b000 R15: ffffc9000ca97938
>>>> FS:  00007f6b81ae2700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
>>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>> CR2: 00007fff1b2fd960 CR3: 000000007ca3a000 CR4: 00000000003506e0
>>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>>> Call Trace:
>>>>  <TASK>
>>>>  nfc_llcp_send_ui_frame+0x2c0/0x430 net/nfc/llcp_commands.c:759
>>>>  llcp_sock_sendmsg+0x2b9/0x3a0 net/nfc/llcp_sock.c:803
>>>>  sock_sendmsg_nosec net/socket.c:704 [inline]
>>>>  sock_sendmsg+0xcf/0x120 net/socket.c:724
>>>>  ____sys_sendmsg+0x331/0x810 net/socket.c:2409
>>>>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
>>>>  __sys_sendmmsg+0x195/0x470 net/socket.c:2549
>>>>  __do_sys_sendmmsg net/socket.c:2578 [inline]
>>>>  __se_sys_sendmmsg net/socket.c:2575 [inline]
>>>>  __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2575
>>>>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>>>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>>>>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>>>> RIP: 0033:0x7f6b81b51f89
>>>> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
>>>> RSP: 002b:00007f6b81ae22f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
>>>> RAX: ffffffffffffffda RBX: 0000000000000033 RCX: 00007f6b81b51f89
>>>> RDX: 0000000000000006 RSI: 0000000020004540 RDI: 0000000000000003
>>>> RBP: 00007f6b81bdb3f8 R08: 0000000000000000 R09: 0000000000000000
>>>> R10: 0000000000000040 R11: 0000000000000246 R12: 00007f6b81bdb3f0
>>>> R13: 93cb663f6753dadd R14: 4b973dfbaeacdab3 R15: f981dd66eb1318f7
>>>>  </TASK>
>>>> Modules linked in:
>>>> ---[ end trace 570920f865b173be ]---
>>>> RIP: 0010:nfc_alloc_send_skb+0x3a/0x190 net/nfc/core.c:722
>>>> Code: 54 41 89 d4 55 53 48 89 fb 48 8d ab 10 06 00 00 48 83 ec 08 e8 47 53 92 f8 48 89 ea 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 14 01 00 00 48 8d bb 14 06 00
>>>> RSP: 0018:ffffc9000ca97888 EFLAGS: 00010202
>>>> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
>>>> RDX: 00000000000000c2 RSI: ffffffff88e474b9 RDI: 0000000000000000
>>>> RBP: 0000000000000610 R08: ffffc9000ca97938 R09: 0000000000000880
>>>> R10: ffffffff88e6031d R11: 000000000000087f R12: 0000000000000000
>>>> R13: 0000000000000082 R14: ffff88807ca8b000 R15: ffffc9000ca97938
>>>> FS:  00007f6b81ae2700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
>>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>> CR2: 00007fff1b2fd960 CR3: 000000007ca3a000 CR4: 00000000003506e0
>>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>>> ----------------
>>>> Code disassembly (best guess):
>>>>    0:	54                   	push   %rsp
>>>>    1:	41 89 d4             	mov    %edx,%r12d
>>>>    4:	55                   	push   %rbp
>>>>    5:	53                   	push   %rbx
>>>>    6:	48 89 fb             	mov    %rdi,%rbx
>>>>    9:	48 8d ab 10 06 00 00 	lea    0x610(%rbx),%rbp
>>>>   10:	48 83 ec 08          	sub    $0x8,%rsp
>>>>   14:	e8 47 53 92 f8       	callq  0xf8925360
>>>>   19:	48 89 ea             	mov    %rbp,%rdx
>>>>   1c:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
>>>>   23:	fc ff df
>>>>   26:	48 c1 ea 03          	shr    $0x3,%rdx
>>>> * 2a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax <-- trapping instruction
>>>>   2e:	84 c0                	test   %al,%al
>>>>   30:	74 08                	je     0x3a
>>>>   32:	3c 03                	cmp    $0x3,%al
>>>>   34:	0f 8e 14 01 00 00    	jle    0x14e
>>>>   3a:	48                   	rex.W
>>>>   3b:	8d                   	.byte 0x8d
>>>>   3c:	bb                   	.byte 0xbb
>>>>   3d:	14 06                	adc    $0x6,%al
>>>>
>>>>
>>>> ---
>>>> This report is generated by a bot. It may contain errors.
>>>> See https://goo.gl/tpsmEJ for more information about syzbot.
>>>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>>>
>>>> syzbot will keep track of this issue. See:
>>>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>>>> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
>>>> syzbot can test patches for this issue, for details see:
>>>> https://goo.gl/tpsmEJ#testing-patches
>>>
>>> Before sending frame out, check llcp dev bond to llcp sock and bail out in
>>> case of invalid device.
>>>
>>> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
>>>
>>> --- a/net/nfc/llcp_sock.c
>>> +++ b/net/nfc/llcp_sock.c
>>> @@ -798,6 +798,10 @@ static int llcp_sock_sendmsg(struct sock
>>>  			return -EINVAL;
>>>  		}
>>>  
>>> +		if (llcp_sock->dev == NULL) {
>>> +			release_sock(sk);
>>> +			return -EBADFD;
>>> +		}
>>>  		release_sock(sk);
>>>  
>>
>> The patch looks the same as mine, except the test for ->dev is slightly
>> later. Why sending the same set?
> 
> Why did you use the words like looks and except here in addition to same?
> I feel free to fix the syzbot report, clear?

It's just confusing to hear that a patch is not working while sending
almost the same one a moment later with Cc to all...

> Did you post your patch with Hillf on the Cc list?
> 
>> My patch was already tested:
> 
> Fine, feel free to show us the tag below you had received.
> 
> Reported-and-tested-by: syzbot+7f23bcddf626e0593a39@syzkaller.appspotmail.com

I got email confirmation from syzbot later, so I mentioned this in a
reply to my patch.


Best regards,
Krzysztof
