Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23D6E5E9401
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 17:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbiIYPig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 11:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiIYPif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 11:38:35 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57992B277
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 08:38:33 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-127dca21a7dso6428140fac.12
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 08:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=wfXjfC3EWDHrGpRS+gvNWNFBXSYDvNyjD9tP1zSNKUE=;
        b=UtyLh8+aOqStQY7SBVSBT+Uf+D2PRI7ataCPEexqTFnfTTENH5JBMJH8Y1GZ/topyh
         24kidwYQ9ipGVn3EMO4cHQv+IzzhoOXONnv/1M1fe9Vcw8yVxxoNFl4mVrZfGE9XDEvZ
         bzaAiDcGRwUEcnihUmHIY1Aik81f499Hoow9cVxHJpS6X+5hraLfS9qMX0MCmBIdAan5
         IiaacyAPWnFfdjPp6ggdSqE+0C6dzAbEDAv7jzz16h1yI0mr95ZMLJ8JOnUcSsKnfP2j
         PplY6lHK6kSnXcKdXbhltwE8ZznmqR3AEFM049xT6ecfJVLBG0oUISklQKx2yG6qFHNm
         WY3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=wfXjfC3EWDHrGpRS+gvNWNFBXSYDvNyjD9tP1zSNKUE=;
        b=eZBXI/nFCEV0OtLiTQIky6iU/W7Megcaq6sEG9R7LzLMsOEPum93BI9YBh6W+fsm7Q
         IayqEqMSoqocbrTeb/l6vqBK1dlqH5uCngGWGHM3PmUzcjKl4jbsswvwhxGt546W9CmL
         Xd7B6TZimRdSJ9+6PrU+eKBqCpWWFEFuhTpu8m9yBpr5/YGKI60RZV/CybYhAI4AaceM
         2MUK5cT6UHU8iX1ztCTopxg0SzEt6I8aaxtYnKbq2oJaQFQHzY1ADKKpLdacmXAE1eHa
         QouLKcxoHeVcqKYytFQN7WRq6H4J1D4M2qY83WhFkprLmBbDJEnijgELOOOixJ1MxpdO
         8UOg==
X-Gm-Message-State: ACrzQf1yg+aL7kU9S7+ab3rWe/lDfE0SzCNbLOvPoAyaRDG2TX9w7EVj
        +UmMewJ/T6U2PEiUSvqAoS9uKoViuvvmT3gGd2sdCQ==
X-Google-Smtp-Source: AMsMyM5+NiH0xu5KeDnC76FZrQG9ewq7BGmaz5h3jl0S0ZsfvzHsKe4c9DYHBrEIXuXc2oxcFOhONGtiE5UaJyOJ2Vc=
X-Received: by 2002:a05:6870:1490:b0:126:e07:2a4a with SMTP id
 k16-20020a056870149000b001260e072a4amr9788924oab.2.1664120312476; Sun, 25 Sep
 2022 08:38:32 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000a96c0b05e97f0444@google.com>
In-Reply-To: <000000000000a96c0b05e97f0444@google.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Sun, 25 Sep 2022 11:38:21 -0400
Message-ID: <CAM0EoMnJ=STtk5BnZ9oJtnkXY2Q+Px2cKa4gowFRGpp40UNKww@mail.gmail.com>
Subject: Re: [syzbot] WARNING in u32_change
To:     syzbot <syzbot+a2c4601efc75848ba321@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Is there a way to tell the boat "looking into it?"

cheers,
jamal

On Sun, Sep 25, 2022 at 7:50 AM syzbot
<syzbot+a2c4601efc75848ba321@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    483fed3b5dc8 Add linux-next specific files for 20220921
> git tree:       linux-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=16becbd5080000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=849cb9f70f15b1ba
> dashboard link: https://syzkaller.appspot.com/bug?extid=a2c4601efc75848ba321
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13bc196f080000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=152b15f8880000
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/1cb3f4618323/disk-483fed3b.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/cc02cb30b495/vmlinux-483fed3b.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+a2c4601efc75848ba321@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> memcpy: detected field-spanning write (size 80) of single field "&n->sel" at net/sched/cls_u32.c:1043 (size 16)
> WARNING: CPU: 0 PID: 3608 at net/sched/cls_u32.c:1043 u32_change+0x2962/0x3250 net/sched/cls_u32.c:1043
> Modules linked in:
> CPU: 0 PID: 3608 Comm: syz-executor971 Not tainted 6.0.0-rc6-next-20220921-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/16/2022
> RIP: 0010:u32_change+0x2962/0x3250 net/sched/cls_u32.c:1043
> Code: f4 df 14 fa 48 8b b5 78 fe ff ff b9 10 00 00 00 48 c7 c2 20 f7 f5 8a 48 c7 c7 a0 f6 f5 8a c6 05 55 b3 63 06 01 e8 db d6 df 01 <0f> 0b e9 73 f3 ff ff e8 c2 df 14 fa 48 c7 c7 00 fc f5 8a e8 66 ed
> RSP: 0018:ffffc90003d7f300 EFLAGS: 00010282
> RAX: 0000000000000000 RBX: ffffc90003d7f618 RCX: 0000000000000000
> RDX: ffff8880235f1d40 RSI: ffffffff81620348 RDI: fffff520007afe52
> RBP: ffffc90003d7f4a0 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000080000000 R11: 203a7970636d656d R12: ffff888021d420e0
> R13: ffffc90003d7f5b8 R14: ffff888021d43c30 R15: ffff888021d42000
> FS:  0000555555f71300(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000000064a110 CR3: 000000002824c000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  tc_new_tfilter+0x938/0x2190 net/sched/cls_api.c:2146
>  rtnetlink_rcv_msg+0x955/0xca0 net/core/rtnetlink.c:6082
>  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2540
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
>  sock_sendmsg_nosec net/socket.c:714 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:734
>  ____sys_sendmsg+0x712/0x8c0 net/socket.c:2482
>  ___sys_sendmsg+0x110/0x1b0 net/socket.c:2536
>  __sys_sendmsg+0xf3/0x1c0 net/socket.c:2565
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f97a4bf4e69
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffdcaf10028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f97a4bf4e69
> RDX: 0000000000000000 RSI: 0000000020000340 RDI: 0000000000000006
> RBP: 00007f97a4bb9010 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f97a4bb90a0
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
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
