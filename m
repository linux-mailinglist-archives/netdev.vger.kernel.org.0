Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E713116FD66
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 12:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbgBZLWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 06:22:07 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36791 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbgBZLWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 06:22:06 -0500
Received: by mail-lf1-f65.google.com with SMTP id f24so1696974lfh.3
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 03:22:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=E0us8VJrNXSY9eXzAIQwp1TcQwVEWEKmFj+MIUCCWAA=;
        b=m51xONnvs2AQWLzIHcggigN9ok322op47/IX0qH0dvg/AZW8vnWixGq2mz2j0Yl7fr
         O4Nr/5exfqxG43rCSZSrIlnIMsQ6K12FB2rv+3le9EoIRJ1hyHL3Z3WrXuRYmhg6gcvk
         ITqGd8cQnSyulaEUqleP1VAoMmuDAeDdXCawI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=E0us8VJrNXSY9eXzAIQwp1TcQwVEWEKmFj+MIUCCWAA=;
        b=apZp4woGNbspULop2PiF9/Syb63xuKg4tDIFXfqErJSpxv0uYGN4yUz5z9CxmmrYky
         GerXwyFCt2vdDnMH7iCAC7yGF0nrEMmJ7HMT3TwvmvfIenPJjrnB4Vafrdt5G+GvQYtA
         92wfyTDjjz8X0XbBpJXto2REXqDZtZbLEajGuVyG9PhAduGSI+xIlPZMnNDUwiXJDhd9
         BYX5NThR0nqqipvy+Y5jDWYTF7KVuVV7d2UTevB95ObfU6kdAauWNpD/dVAlE8DQ/BiC
         wSAf+OndnvAkYNIKS/3Trs4Pk7Nu1dxgOrlVwrPXGsegk9pny+IyFT7/SyXZfyKRyj7Y
         hSDQ==
X-Gm-Message-State: APjAAAVfGL0i+/LRfsvWgMoOakUVIhw+t8p8yF4v8XMj5Bsg4dFOnfeA
        78GN6ClYXNK7F+o+/m5MI1ztEQ==
X-Google-Smtp-Source: APXvYqxBl/nNgswDbREy9kr8rpHjTbAPXUmdviWKswPItyJ7aSrEvsiz9AFu3A9wLAv+j8LevLA+7Q==
X-Received: by 2002:a19:6742:: with SMTP id e2mr2275073lfj.1.1582716123805;
        Wed, 26 Feb 2020 03:22:03 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id u5sm675690ljl.97.2020.02.26.03.22.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 03:22:03 -0800 (PST)
References: <00000000000050bd7c059f61fd8c@google.com> <3f2984d7-f854-2457-8bbe-7e8b1a377d66@gmail.com> <b33cfd8a-4813-4a7e-49ef-ed838e2e2344@gmail.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     syzbot <syzbot+1938db17e275e85dc328@syzkaller.appspotmail.com>,
        andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, kafai@fb.com,
        kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in inet_release
In-reply-to: <b33cfd8a-4813-4a7e-49ef-ed838e2e2344@gmail.com>
Date:   Wed, 26 Feb 2020 12:22:02 +0100
Message-ID: <87eeuhd25h.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 07:23 PM CET, Eric Dumazet wrote:
> On 2/25/20 12:15 AM, Eric Dumazet wrote:
>>
>>
>> On 2/25/20 12:08 AM, syzbot wrote:
>>> Hello,
>>>
>>> syzbot found the following crash on:
>>>
>>> HEAD commit:    54dedb5b Merge tag 'for-linus-5.6-rc3-tag' of git://git.ke..
>>> git tree:       upstream
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=168f7de9e00000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=3e57a6b450fb9883
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=1938db17e275e85dc328
>>> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1681fe09e00000
>>>
>>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>>> Reported-by: syzbot+1938db17e275e85dc328@syzkaller.appspotmail.com
>>>
>>> BUG: kernel NULL pointer dereference, address: 0000000000000000
>>> #PF: supervisor instruction fetch in kernel mode
>>> #PF: error_code(0x0010) - not-present page
>>> PGD a0113067 P4D a0113067 PUD a8771067 PMD 0
>>> Oops: 0010 [#1] PREEMPT SMP KASAN
>>> CPU: 0 PID: 10686 Comm: syz-executor.0 Not tainted 5.6.0-rc2-syzkaller #0
>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>>> RIP: 0010:0x0
>>> Code: Bad RIP value.
>>> RSP: 0018:ffffc9000281fce0 EFLAGS: 00010246
>>> RAX: 1ffffffff15f48ac RBX: ffffffff8afa4560 RCX: dffffc0000000000
>>> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880a69a8f40
>>> RBP: ffffc9000281fd10 R08: ffffffff86ed9b0c R09: ffffed1014d351f5
>>> R10: ffffed1014d351f5 R11: 0000000000000000 R12: ffff8880920d3098
>>> R13: 1ffff1101241a613 R14: ffff8880a69a8f40 R15: 0000000000000000
>>> FS:  00007f2ae75db700(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> CR2: ffffffffffffffd6 CR3: 00000000a3b85000 CR4: 00000000001406f0
>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>> Call Trace:
>>>  inet_release+0x165/0x1c0 net/ipv4/af_inet.c:427
>>>  __sock_release net/socket.c:605 [inline]
>>>  sock_close+0xe1/0x260 net/socket.c:1283
>>>  __fput+0x2e4/0x740 fs/file_table.c:280
>>>  ____fput+0x15/0x20 fs/file_table.c:313
>>>  task_work_run+0x176/0x1b0 kernel/task_work.c:113
>>>  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
>>>  exit_to_usermode_loop arch/x86/entry/common.c:164 [inline]
>>>  prepare_exit_to_usermode+0x480/0x5b0 arch/x86/entry/common.c:195
>>>  syscall_return_slowpath+0x113/0x4a0 arch/x86/entry/common.c:278
>>>  do_syscall_64+0x11f/0x1c0 arch/x86/entry/common.c:304
>>>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>>> RIP: 0033:0x45c429
>>> Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
>>> RSP: 002b:00007f2ae75dac78 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
>>> RAX: 0000000000000000 RBX: 00007f2ae75db6d4 RCX: 000000000045c429
>>> RDX: 0000000000000001 RSI: 000000000000011a RDI: 0000000000000004
>>> RBP: 000000000076bf20 R08: 0000000000000038 R09: 0000000000000000
>>> R10: 0000000020000180 R11: 0000000000000246 R12: 00000000ffffffff
>>> R13: 0000000000000a9d R14: 00000000004ccfb4 R15: 000000000076bf2c
>>> Modules linked in:
>>> CR2: 0000000000000000
>>> ---[ end trace 82567b5207e87bae ]---
>>> RIP: 0010:0x0
>>> Code: Bad RIP value.
>>> RSP: 0018:ffffc9000281fce0 EFLAGS: 00010246
>>> RAX: 1ffffffff15f48ac RBX: ffffffff8afa4560 RCX: dffffc0000000000
>>> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880a69a8f40
>>> RBP: ffffc9000281fd10 R08: ffffffff86ed9b0c R09: ffffed1014d351f5
>>> R10: ffffed1014d351f5 R11: 0000000000000000 R12: ffff8880920d3098
>>> R13: 1ffff1101241a613 R14: ffff8880a69a8f40 R15: 0000000000000000
>>> FS:  00007f2ae75db700(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> CR2: ffffffffffffffd6 CR3: 00000000a3b85000 CR4: 00000000001406f0
>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>>
>>>
>>> ---
>>> This bug is generated by a bot. It may contain errors.
>>> See https://goo.gl/tpsmEJ for more information about syzbot.
>>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>>
>>> syzbot will keep track of this bug report. See:
>>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>>> syzbot can test patches for this bug, for details see:
>>> https://goo.gl/tpsmEJ#testing-patches
>>>
>>
>> Note to ULP maintainers
>>
>> Probably the code for IPV6_ADDRFORM  needs some care if a TCP socket got ULP enabled ?
>>
>
> Maybe simply make sure sk->sk_prot is pristine as in :
>
> diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
> index 79fc012dd2cae44b69057c168037b018775d1f49..a72c5c30bc3a55ca65974c537cd089fa4260a8d0 100644
> --- a/net/ipv6/ipv6_sockglue.c
> +++ b/net/ipv6/ipv6_sockglue.c
> @@ -183,9 +183,14 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
>                                         retv = -EBUSY;
>                                         break;
>                                 }
> -                       } else if (sk->sk_protocol != IPPROTO_TCP)
> +                       } else if (sk->sk_protocol == IPPROTO_TCP) {
> +                               if (sk->sk_prot != &tcpv6_prot) {
> +                                       retv = -EBUSY;
> +                                       break;
> +                               }
> +                       } else {
>                                 break;
> -
> +                       }
>                         if (sk->sk_state != TCP_ESTABLISHED) {
>                                 retv = -ENOTCONN;
>                                 break;

This is a weird one.

Only way I can see that syzbot could have triggered a NULL deref on
sk->sk_prot->close() at net/ipv4/af_inet.c:427 is if we set sk->sk_prot
to a set of kTLS callbacks that were not initialized.

That is:

1) setsockopt(fd, SOL_TCP, TCP_ULP, "tls") builds a set kTLS callbacks
   for AF_INET6 by initializing tls_prots[TLSV6],

2) setsockopt(fd, SOL_IPV6, IPV6_ADDRFORM) changes sk->sk_family to
   AF_INET,

3) setsockopt(fd, SOL_TLS, TLS_TX, ...) sets sk->sk_prot to
   uninitialized &tls_prots[TLSV4] based on sk->sk_family.

But this could not have happened because setsockopt(IPV6_ADDRFORM)
resets sk->sk_prot to &tcp_prot, so tls_setsockopt no longer gets called
and attempt to setsockopt(fd, SOL_TLS, TLS_TX) will fail with
-ENOPROTOOPT.

Also, we hold the sk_lock while setting both IPV6_ADDRFORM and TLX_TX
options.

Nevertheless, failing IPV6_ADDRFORM with -EBUSY when sk_prot is
overwritten sounds like the right thing to do.

It looks like a bug that we are not doing it ATM, the crash report
aside, because after setsockopt(IPV6_ADDRFORM) icsk_ulp_data remains
pointing to a kTLS context, while proto and socket ops get reset to
TCPv4 defaults.
