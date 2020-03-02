Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 293AE1751C4
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 03:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgCBCWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 21:22:36 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37184 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbgCBCWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 21:22:36 -0500
Received: by mail-pf1-f194.google.com with SMTP id p14so4783868pfn.4;
        Sun, 01 Mar 2020 18:22:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=4uaFy22TR9js50Qq2h2sOOpbST6186vMHVNhSpD9BcE=;
        b=aj7UEz5dX90cLSoIlLkwjYyf1iCACNz4yupk3J6sXyeLrvHRLUsxbMTX4P8tjejYHW
         TIQHVcrGXHAH/75ZhHJZJH8bqpnAN0Ry8cLObaUZyplMkWQxIMdeO6kcNMTesg6Cn1+a
         alQ4ozaBUef+UwmUjlcHHTRC8KOeCV1BcGrM0F3OwXbT17/L5e9wA/T+nWn9UArc/1Rh
         xIlla+RlQZ/Zkvbkx7NLBamZrZ/HySbly0njgCBPYrIe41VV6fIA6sALyl7o+XL7YdEb
         ycFifkjq+ACT99p6XswsbP0ZPwxH1FFmSd+7POUyecGltYUHC7Fik37UU9C+r+dwdhyx
         z/2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4uaFy22TR9js50Qq2h2sOOpbST6186vMHVNhSpD9BcE=;
        b=F07u4i+Q9Wr/GM7obl2+3nfNvpMbX635vb0+neA1ah7CjDlma9X869hx3xI5uFO+Yf
         fZaIncf7eVTUYqU/E89kpHlDvrMMWKJ3V29h05/ROZdYVaL33P4tovU69MhPNLlSIsfF
         G8KWvolTpAB7LrEaddrvS8VgdLVI9VINEHGfWoq3cNTogn1uPZ3JwqwYRU7bBBcl9qhD
         Bsi4K7fS//q2kGhnDbvnAfuDXLybDMbCoRpDOR6OCVNFEqNLBLQs9wCxvY81v3Ohj5yR
         jKuLc0MINThI6n5xRNYqrIlNk1vnm5tdDKIlj3vEEwK0MbmquMMlWkDAUVM2O/j73AVA
         QOLA==
X-Gm-Message-State: APjAAAUZXsfiWkYdchiAXpXu7tRULO0aonCSodmwO+DXOYUyQRVK5Dyj
        av8CkPovr8Pi/pXiJOWHGUo=
X-Google-Smtp-Source: APXvYqwHjyoyPvMNunQDsm3u/iTcqtDvEIO+N7HC6dSUPrspIGM42aoRTdst2tYNboB/tox6KwlH6Q==
X-Received: by 2002:a63:dc0d:: with SMTP id s13mr16466210pgg.129.1583115755265;
        Sun, 01 Mar 2020 18:22:35 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id w84sm6672665pfc.95.2020.03.01.18.22.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2020 18:22:34 -0800 (PST)
Subject: Re: WARNING: refcount bug in __sk_destruct
To:     syzbot <syzbot+dd803bc0e8adf0003261@syzkaller.appspotmail.com>,
        andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        hawk@kernel.org, jasowang@redhat.com, jhs@mojatatu.com,
        jiri@resnulli.us, john.fastabend@gmail.com, kafai@fb.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com,
        yhs@fb.com
References: <000000000000a0ed74059fd52b8d@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <17ea3816-7c96-0092-d686-e89fbb4db7d8@gmail.com>
Date:   Sun, 1 Mar 2020 18:22:32 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <000000000000a0ed74059fd52b8d@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/1/20 5:33 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    fd786fb1 net: convert suitable drivers to use phy_do_ioctl..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=14e9726ee00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7f93900a7904130d
> dashboard link: https://syzkaller.appspot.com/bug?extid=dd803bc0e8adf0003261
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12af9369e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10583d76e00000
> 
> The bug was bisected to:
> 
> commit 14215108a1fd7e002c0a1f9faf8fbaf41fdda50d
> Author: Cong Wang <xiyou.wangcong@gmail.com>
> Date:   Thu Feb 21 05:37:42 2019 +0000
> 
>     net_sched: initialize net pointer inside tcf_exts_init()
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=175b66bee00000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=14db66bee00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=10db66bee00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+dd803bc0e8adf0003261@syzkaller.appspotmail.com
> Fixes: 14215108a1fd ("net_sched: initialize net pointer inside tcf_exts_init()")
> 
> RBP: 0000000000000000 R08: 0000000000000002 R09: 00000000bb1414ac
> R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffffff
> R13: 0000000000000009 R14: 0000000000000000 R15: 0000000000000000
> ------------[ cut here ]------------
> refcount_t: underflow; use-after-free.
> WARNING: CPU: 1 PID: 9577 at lib/refcount.c:28 refcount_warn_saturate+0x1dc/0x1f0 lib/refcount.c:28
> Kernel panic - not syncing: panic_on_warn set ...
> CPU: 1 PID: 9577 Comm: syz-executor327 Not tainted 5.5.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x197/0x210 lib/dump_stack.c:118
>  panic+0x2e3/0x75c kernel/panic.c:221
>  __warn.cold+0x2f/0x3e kernel/panic.c:582
>  report_bug+0x289/0x300 lib/bug.c:195
>  fixup_bug arch/x86/kernel/traps.c:174 [inline]
>  fixup_bug arch/x86/kernel/traps.c:169 [inline]
>  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
>  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
>  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
> RIP: 0010:refcount_warn_saturate+0x1dc/0x1f0 lib/refcount.c:28
> Code: e9 d8 fe ff ff 48 89 df e8 c1 f8 16 fe e9 85 fe ff ff e8 a7 77 d8 fd 48 c7 c7 e0 44 71 88 c6 05 9e 86 db 06 01 e8 93 27 a9 fd <0f> 0b e9 ac fe ff ff 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 55 48
> RSP: 0018:ffffc9000c067b00 EFLAGS: 00010282
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff815e5dd6 RDI: fffff5200180cf52
> RBP: ffffc9000c067b10 R08: ffff8880a8630340 R09: ffffed1015d26621
> R10: ffffed1015d26620 R11: ffff8880ae933107 R12: 0000000000000003
> R13: ffff888090256000 R14: ffff8880a7e5c040 R15: ffff8880a7e5c044
>  refcount_sub_and_test include/linux/refcount.h:261 [inline]
>  refcount_dec_and_test include/linux/refcount.h:281 [inline]
>  put_net include/net/net_namespace.h:259 [inline]
>  __sk_destruct+0x6d8/0x7f0 net/core/sock.c:1723
>  sk_destruct+0xd5/0x110 net/core/sock.c:1739
>  __sk_free+0xfb/0x3f0 net/core/sock.c:1750
>  sk_free+0x83/0xb0 net/core/sock.c:1761
>  sock_put include/net/sock.h:1719 [inline]
>  __tun_detach+0xbe0/0x1150 drivers/net/tun.c:728
>  tun_detach drivers/net/tun.c:740 [inline]
>  tun_chr_close+0xe0/0x180 drivers/net/tun.c:3455
>  __fput+0x2ff/0x890 fs/file_table.c:280
>  ____fput+0x16/0x20 fs/file_table.c:313
>  task_work_run+0x145/0x1c0 kernel/task_work.c:113
>  exit_task_work include/linux/task_work.h:22 [inline]
>  do_exit+0xba9/0x2f50 kernel/exit.c:801
>  do_group_exit+0x135/0x360 kernel/exit.c:899
>  __do_sys_exit_group kernel/exit.c:910 [inline]
>  __se_sys_exit_group kernel/exit.c:908 [inline]
>  __x64_sys_exit_group+0x44/0x50 kernel/exit.c:908
>  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x441a48
> Code: Bad RIP value.
> RSP: 002b:00007fffe55809a8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 0000000000441a48
> RDX: 0000000000000001 RSI: 000000000000003c RDI: 0000000000000001
> RBP: 00000000004c8430 R08: 00000000000000e7 R09: ffffffffffffffd0
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
> R13: 00000000006dba80 R14: 0000000000000000 R15: 0000000000000000
> Kernel Offset: disabled
> Rebooting in 86400 seconds..
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 


Hmmm... maybe this patch would fix it ?

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index a972244ab1931a2fd52a41efa4f7a6cd78d8746a..6e258a6c1328e38a757d9711f4116a6672995b8f 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -206,11 +206,12 @@ static inline int tcf_exts_init(struct tcf_exts *exts, struct net *net,
 #ifdef CONFIG_NET_CLS_ACT
        exts->type = 0;
        exts->nr_actions = 0;
-       exts->net = net;
+       exts->net = NULL;
        exts->actions = kcalloc(TCA_ACT_MAX_PRIO, sizeof(struct tc_action *),
                                GFP_KERNEL);
        if (!exts->actions)
                return -ENOMEM;
+       exts->net = net;
 #endif
        exts->action = action;
        exts->police = police;
