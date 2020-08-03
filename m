Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8461123AAAB
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 18:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbgHCQlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 12:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbgHCQlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 12:41:17 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFB7C06174A;
        Mon,  3 Aug 2020 09:41:17 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id t10so15659162plz.10;
        Mon, 03 Aug 2020 09:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=/CmzZF3LI6CZNjiiOZfYDENkZ36pUP8a9FXslVgZ0Jg=;
        b=RPFpFKwEo8XayRLUJVnugeujkwLFGvZNYMerLDv5K3GV+i3ohgNQkIHu7bKXPQm+9v
         7mxE6EcRIXf7LpcDPkyW0cXirL0ntDyVm0+Azs1VFC6hDfR3CBgKCw/XiJIkaG83vDRx
         js6+NLD9oDwQAgGHWVjiFi05LayUylQrXvdt+mRjrM1ia051bhl1DH8EiRcnDzregrH1
         ZwVlSIH3GXBq+mzN+K/m7dYveTX2DeSae6vEyRHjTDsnJgf4Yj1BNKEjv4FjzTKmrjAN
         Pmp7Jv9y8tK5GLPNCqcGh/NmdpdibOLfzH2OhWf2kXV1J32EMgJmO2NdLKgOJ8oHTFr8
         /bJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/CmzZF3LI6CZNjiiOZfYDENkZ36pUP8a9FXslVgZ0Jg=;
        b=bwacKrdqaNlofRyFywI5CAbH0VM3fGUyS7wLCqnz2g92YjxqCIOsQtE3oiG3/iUQGR
         Y8uyVYXhhCa1t+dcoACjCkFQxBafoP1DGMvOrAGCWcw/yWNs1OoUkQ813Ob/5c3Xwd3L
         UJGu9YpAqvY0kgBHofOqgySZG6hiVM3yUi1LyxB/DEPqC+Q28+iMXbUzEkMYN0ZPOfZT
         VoaBe3ZaZN5VXxb5pkCQfEoAcmS6hcSbjPw0t8IxHeW8RpQDpxM9jvml8rvP8tobfPVh
         pPiP+/di9vPN87FcM/DT+MpnythqbmFJ2iYGubu334+HREgPDxw+qLaNMXQB7xH2ZrZ2
         s5RQ==
X-Gm-Message-State: AOAM531+WWgfGmkX3RTKBxwABkydez9rHzveiHPrSMt5DQrnO3h6BrbS
        SHFF8G3gdJFZqY2Zb/T/TJ4=
X-Google-Smtp-Source: ABdhPJwUUwrL5BfMRhfOVLRiMVlWMIUagdP4nwKlGRgv4RS3gvIipgmkTmQIFDRyvP/AHD+mcC6geA==
X-Received: by 2002:a17:90a:ad4c:: with SMTP id w12mr149700pjv.129.1596472876804;
        Mon, 03 Aug 2020 09:41:16 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id o16sm21440047pfu.188.2020.08.03.09.41.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 09:41:16 -0700 (PDT)
Subject: Re: KMSAN: uninit-value in caif_seqpkt_sendmsg
To:     syzbot <syzbot+09a5d591c1f98cf5efcb@syzkaller.appspotmail.com>,
        alexios.zavras@intel.com, allison@lohutok.net, davem@davemloft.net,
        edumazet@google.com, glider@google.com, gregkh@linuxfoundation.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, swinslow@gmail.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
References: <0000000000007ab98a05abfbb9a7@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <2d5e9990-a976-743d-8717-1193a7a4a498@gmail.com>
Date:   Mon, 3 Aug 2020 09:41:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <0000000000007ab98a05abfbb9a7@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/3/20 9:35 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    8bbbc5cf kmsan: don't compile memmove
> git tree:       https://github.com/google/kmsan.git master
> console output: https://syzkaller.appspot.com/x/log.txt?x=11fbfe09e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=cd0e9a6b0e555cc3
> dashboard link: https://syzkaller.appspot.com/bug?extid=09a5d591c1f98cf5efcb
> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> userspace arch: i386
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=150ef74ee00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=170e2109e00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+09a5d591c1f98cf5efcb@syzkaller.appspotmail.com
> 
> =====================================================
> BUG: KMSAN: uninit-value in caif_seqpkt_sendmsg+0x693/0xf60 net/caif/caif_socket.c:542
> CPU: 1 PID: 11244 Comm: syz-executor620 Not tainted 5.6.0-rc2-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x1c9/0x220 lib/dump_stack.c:118
>  kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
>  __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
>  caif_seqpkt_sendmsg+0x693/0xf60 net/caif/caif_socket.c:542
>  sock_sendmsg_nosec net/socket.c:652 [inline]
>  sock_sendmsg net/socket.c:672 [inline]
>  ____sys_sendmsg+0x12b6/0x1350 net/socket.c:2343
>  ___sys_sendmsg net/socket.c:2397 [inline]
>  __sys_sendmmsg+0x808/0xc90 net/socket.c:2480
>  __compat_sys_sendmmsg net/compat.c:656 [inline]
>  __do_compat_sys_sendmmsg net/compat.c:663 [inline]
>  __se_compat_sys_sendmmsg net/compat.c:660 [inline]
>  __ia32_compat_sys_sendmmsg+0x127/0x180 net/compat.c:660
>  do_syscall_32_irqs_on arch/x86/entry/common.c:339 [inline]
>  do_fast_syscall_32+0x3c7/0x6e0 arch/x86/entry/common.c:410
>  entry_SYSENTER_compat+0x68/0x77 arch/x86/entry/entry_64_compat.S:139
> RIP: 0023:0xf7f79d99
> Code: 90 e8 0b 00 00 00 f3 90 0f ae e8 eb f9 8d 74 26 00 89 3c 24 c3 90 90 90 90 90 90 90 90 90 90 90 90 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
> RSP: 002b:00000000ffbf4d6c EFLAGS: 00000292 ORIG_RAX: 0000000000000159
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000020007600
> RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00000000080bb508
> RBP: 0000000000000012 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> 
> Local variable ----iovstack.i@__sys_sendmmsg created at:
>  ___sys_sendmsg net/socket.c:2388 [inline]
>  __sys_sendmmsg+0x6db/0xc90 net/socket.c:2480
>  ___sys_sendmsg net/socket.c:2388 [inline]
>  __sys_sendmmsg+0x6db/0xc90 net/socket.c:2480
> =====================================================
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

It is not clear why this code tests iov_base instead of len.

diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index 3ad0a1df6712834a7f70b21a78173a02c7cba897..e4540023a9404d44089ff11b8b912fa23d8de69f 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -539,7 +539,7 @@ static int caif_seqpkt_sendmsg(struct socket *sock, struct msghdr *msg,
                goto err;
 
        ret = -EINVAL;
-       if (unlikely(msg->msg_iter.iov->iov_base == NULL))
+       if (unlikely(!len))
                goto err;
        noblock = msg->msg_flags & MSG_DONTWAIT;
 
