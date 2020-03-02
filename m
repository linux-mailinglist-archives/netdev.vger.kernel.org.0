Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B23011751D8
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 03:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgCBCih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 21:38:37 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37378 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbgCBCih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 21:38:37 -0500
Received: by mail-pl1-f193.google.com with SMTP id q4so3586829pls.4;
        Sun, 01 Mar 2020 18:38:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=76UPx8PO1yDf21f1bpvCPBtQfv8opVuP9cyhAIXZPN4=;
        b=d2icevVL5n8Rszs3afbUWa4nIfFKHQDZIpuuLbXYCh2PARjByaMXOPtNGVoO6t5Y6R
         1+lRqDQ8TkSp7ZNvWKOiM5rAAKDPmugS48cqU3osbDHAXP3lowO4CUkfhMJghB9NBqFD
         fuQxKkCMeIzbd5hcnlmJSKnO1YZBt2GKcOi3HB6+OMwXHbvVaa1boGn88KXttZsZkjjg
         SgYpw8nLXkPfLmH+F3jKzd69+X9t9IQktr+IT8AvXxYYVJhuV9TRulvBH9IFpJxYiTpH
         8KrpHcqBDIR/iyqGkka8/PjvlzQmVdFyjOUEFN7OsREMfGaI07S1xvOA687lOe8bBnfu
         G50g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=76UPx8PO1yDf21f1bpvCPBtQfv8opVuP9cyhAIXZPN4=;
        b=Iw+nN4BgYpQhw+KSSLx1pb/GQX9ObSC4KG+LqgAUUgo0f5wdERf73oXS3Of6UpM/FL
         bWuYUWCHxN1cMdrEPPaTKLUWOtmRDklY3KYbMn7pA09Qlwe7YtC74M5DN1x3wkJFeKKe
         CHRo+RpUKhAHcoxs/ALopBtfil2xTzM9SLXOup9gAut749Rk1AtScrux0NZjvJm5ALAj
         qpPzJ1BMggEbp8DrO47PUOBfa5z78omsVMYDRXYvOSjlw7mShK8MVbpsUV4bm76av6Qv
         FVQNjBp00cqtrsKSQyuswPvwFH4psUXRlBHk+gdyLRjomHOHQSMuLl+OpdU1yjHIc0hc
         VJ7Q==
X-Gm-Message-State: APjAAAXTWP/ESLbrTezaFNaoNGepCbz40Vkk866SklfE6Fwa6wxrKwI5
        X14k7osdZvYlZ/uBSK+iHAo=
X-Google-Smtp-Source: APXvYqxEq7LCSP4YcW4jzkAfBBhd+4BiWQAUOnULdHd0Q9D+ETYJmuJUKzPAQh/yaWTEHWYIKB2yWA==
X-Received: by 2002:a17:90a:bf81:: with SMTP id d1mr18475086pjs.21.1583116714398;
        Sun, 01 Mar 2020 18:38:34 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id g14sm14288206pfo.154.2020.03.01.18.38.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2020 18:38:33 -0800 (PST)
Subject: Re: WARNING: refcount bug in __sk_destruct
From:   Eric Dumazet <eric.dumazet@gmail.com>
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
 <17ea3816-7c96-0092-d686-e89fbb4db7d8@gmail.com>
Message-ID: <44fae4d8-5d9f-9ac4-8b3d-51b67e10d32d@gmail.com>
Date:   Sun, 1 Mar 2020 18:38:31 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <17ea3816-7c96-0092-d686-e89fbb4db7d8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/1/20 6:22 PM, Eric Dumazet wrote:
> 
> 
> On 3/1/20 5:33 PM, syzbot wrote:
>> Hello,
>>
>> syzbot found the following crash on:
>>
>> HEAD commit:    fd786fb1 net: convert suitable drivers to use phy_do_ioctl..
>> git tree:       net-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=14e9726ee00000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=7f93900a7904130d
>> dashboard link: https://syzkaller.appspot.com/bug?extid=dd803bc0e8adf0003261
>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12af9369e00000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10583d76e00000
>>
>> The bug was bisected to:
>>
>> commit 14215108a1fd7e002c0a1f9faf8fbaf41fdda50d
>> Author: Cong Wang <xiyou.wangcong@gmail.com>
>> Date:   Thu Feb 21 05:37:42 2019 +0000
>>
>>     net_sched: initialize net pointer inside tcf_exts_init()
>>
>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=175b66bee00000
>> final crash:    https://syzkaller.appspot.com/x/report.txt?x=14db66bee00000
>> console output: https://syzkaller.appspot.com/x/log.txt?x=10db66bee00000
>>
>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> Reported-by: syzbot+dd803bc0e8adf0003261@syzkaller.appspotmail.com
>> Fixes: 14215108a1fd ("net_sched: initialize net pointer inside tcf_exts_init()")
>>
>> RBP: 0000000000000000 R08: 0000000000000002 R09: 00000000bb1414ac
>> R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffffff
>> R13: 0000000000000009 R14: 0000000000000000 R15: 0000000000000000
>> ------------[ cut here ]------------
>> refcount_t: underflow; use-after-free.
>> WARNING: CPU: 1 PID: 9577 at lib/refcount.c:28 refcount_warn_saturate+0x1dc/0x1f0 lib/refcount.c:28
>> Kernel panic - not syncing: panic_on_warn set ...
>> CPU: 1 PID: 9577 Comm: syz-executor327 Not tainted 5.5.0-rc6-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> Call Trace:
>>  __dump_stack lib/dump_stack.c:77 [inline]
>>  dump_stack+0x197/0x210 lib/dump_stack.c:118
>>  panic+0x2e3/0x75c kernel/panic.c:221
>>  __warn.cold+0x2f/0x3e kernel/panic.c:582
>>  report_bug+0x289/0x300 lib/bug.c:195
>>  fixup_bug arch/x86/kernel/traps.c:174 [inline]
>>  fixup_bug arch/x86/kernel/traps.c:169 [inline]
>>  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
>>  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
>>  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
>> RIP: 0010:refcount_warn_saturate+0x1dc/0x1f0 lib/refcount.c:28
>> Code: e9 d8 fe ff ff 48 89 df e8 c1 f8 16 fe e9 85 fe ff ff e8 a7 77 d8 fd 48 c7 c7 e0 44 71 88 c6 05 9e 86 db 06 01 e8 93 27 a9 fd <0f> 0b e9 ac fe ff ff 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 55 48
>> RSP: 0018:ffffc9000c067b00 EFLAGS: 00010282
>> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
>> RDX: 0000000000000000 RSI: ffffffff815e5dd6 RDI: fffff5200180cf52
>> RBP: ffffc9000c067b10 R08: ffff8880a8630340 R09: ffffed1015d26621
>> R10: ffffed1015d26620 R11: ffff8880ae933107 R12: 0000000000000003
>> R13: ffff888090256000 R14: ffff8880a7e5c040 R15: ffff8880a7e5c044
>>  refcount_sub_and_test include/linux/refcount.h:261 [inline]
>>  refcount_dec_and_test include/linux/refcount.h:281 [inline]
>>  put_net include/net/net_namespace.h:259 [inline]
>>  __sk_destruct+0x6d8/0x7f0 net/core/sock.c:1723
>>  sk_destruct+0xd5/0x110 net/core/sock.c:1739
>>  __sk_free+0xfb/0x3f0 net/core/sock.c:1750
>>  sk_free+0x83/0xb0 net/core/sock.c:1761
>>  sock_put include/net/sock.h:1719 [inline]
>>  __tun_detach+0xbe0/0x1150 drivers/net/tun.c:728
>>  tun_detach drivers/net/tun.c:740 [inline]
>>  tun_chr_close+0xe0/0x180 drivers/net/tun.c:3455
>>  __fput+0x2ff/0x890 fs/file_table.c:280
>>  ____fput+0x16/0x20 fs/file_table.c:313
>>  task_work_run+0x145/0x1c0 kernel/task_work.c:113
>>  exit_task_work include/linux/task_work.h:22 [inline]
>>  do_exit+0xba9/0x2f50 kernel/exit.c:801
>>  do_group_exit+0x135/0x360 kernel/exit.c:899
>>  __do_sys_exit_group kernel/exit.c:910 [inline]
>>  __se_sys_exit_group kernel/exit.c:908 [inline]
>>  __x64_sys_exit_group+0x44/0x50 kernel/exit.c:908
>>  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
>>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> RIP: 0033:0x441a48
>> Code: Bad RIP value.
>> RSP: 002b:00007fffe55809a8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
>> RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 0000000000441a48
>> RDX: 0000000000000001 RSI: 000000000000003c RDI: 0000000000000001
>> RBP: 00000000004c8430 R08: 00000000000000e7 R09: ffffffffffffffd0
>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
>> R13: 00000000006dba80 R14: 0000000000000000 R15: 0000000000000000
>> Kernel Offset: disabled
>> Rebooting in 86400 seconds..
>>
>>
>> ---
>> This bug is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for more information about syzbot.
>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>
>> syzbot will keep track of this bug report. See:
>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
>> syzbot can test patches for this bug, for details see:
>> https://goo.gl/tpsmEJ#testing-patches
>>
> 
> 
> Hmmm... maybe this patch would fix it ?
> 
> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
> index a972244ab1931a2fd52a41efa4f7a6cd78d8746a..6e258a6c1328e38a757d9711f4116a6672995b8f 100644
> --- a/include/net/pkt_cls.h
> +++ b/include/net/pkt_cls.h
> @@ -206,11 +206,12 @@ static inline int tcf_exts_init(struct tcf_exts *exts, struct net *net,
>  #ifdef CONFIG_NET_CLS_ACT
>         exts->type = 0;
>         exts->nr_actions = 0;
> -       exts->net = net;
> +       exts->net = NULL;
>         exts->actions = kcalloc(TCA_ACT_MAX_PRIO, sizeof(struct tc_action *),
>                                 GFP_KERNEL);
>         if (!exts->actions)
>                 return -ENOMEM;
> +       exts->net = net;
>  #endif
>         exts->action = action;
>         exts->police = police;
> 

Hmm no.

Instead, make sure cls_u32 gets a reference so that calls
to u32_destroy_key(new, false); do not end up decrementing netns refcount.


diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index e15ff335953deef36e55901d8f4ce34e15ed676f..587d71def49157680cf54f84558c4f4e5dad37f1 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -898,6 +898,7 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
                new = u32_init_knode(net, tp, n);
                if (!new)
                        return -ENOMEM;
+               tcf_exts_get_net(&new->exts);
 
                err = u32_set_parms(net, tp, base, new, tb,
                                    tca[TCA_RATE], ovr, extack);
@@ -918,7 +919,6 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 
                u32_replace_knode(tp, tp_c, new);
                tcf_unbind_filter(tp, &n->res);
-               tcf_exts_get_net(&n->exts);
                tcf_queue_work(&n->rwork, u32_delete_key_work);
                return 0;
        }


