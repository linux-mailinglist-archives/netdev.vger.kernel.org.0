Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4215C5F3E6E
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 10:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbiJDIdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 04:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbiJDIds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 04:33:48 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880D03F1E7
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 01:33:44 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 10so20122617lfy.5
        for <netdev@vger.kernel.org>; Tue, 04 Oct 2022 01:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=+8hVM6HR++8q936TONWT6d0jevmukWGXODV759VzDRA=;
        b=jLctIR4y518R/nQR2YaufShK6n8oyJY46XHnZ7WMrXocoXNnxJpLyZsmxCxx2PHRI5
         yGxbJIoALZfofky45QkuJX65NNa8IgQpOf3RY5eYgDjiAns1pvtopl9xGa4hmd/kvtpN
         OikhrcF9PMLUhVCuEGxwBas1b1CaV2axNm1XG8HYYIf3fqDsAKmEe55LxUrC0bxr5jDU
         Yr2J+1rFCwZIbD2Ec9svp+6iNzxhafan8emjvd2KCZqskK3hmlig0I6uqnEdbIF8FHjg
         G8b+VHpmQeMfkJ+fxj5agNj89sF5pk651wbfqk2bPhQp4NszypGJmeEJBtWoGAnhCOZl
         ++ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=+8hVM6HR++8q936TONWT6d0jevmukWGXODV759VzDRA=;
        b=PevX5aKfEKk/ySzxEip9/hbszpqmtNbFtzf2XQGLhyvJDXiSC+8ALJTXT8/sldUOFs
         1mtsJvsPQtx5FcHNMYn8DDc5CJMBwolOJg7A3OyOOWDXbPPYDCcqfuakjJxh1cYAXVKu
         6zR8GS4D+w+25ecgywi60dm2Qey1F0gxYYeJtqI7z2mAqHOmW/olNdcQpGpMtfpJymEL
         LFN6bqjzalrfMBHSRNM0tJeqeiMEn9VXJKyasXLTeBJUn78UaKnR5ePtjV9dKH+zhTaP
         Wa1X2+qi1/dpfWJakAqyWEC0uvj74Wb5EpReIyWeK5LgKqRdLg4CbGtmtXd6geJep0Ek
         spqQ==
X-Gm-Message-State: ACrzQf2Fp3p95K8yvbJucU3gjIC+50WANKd24DvNtN8SK/3okmxUOFly
        PucbhTuF8T4/pAv4y5Ny1g/wERZ+jSHrUp8go/lXqw==
X-Google-Smtp-Source: AMsMyM4nJnedZCUC0dWs7ejaV1sHLAZYvqt1NKxmzsE0sN7ddq/eUSSYEli5hLEoMARNaI8TZ+nPZknBqs15WzZAFb0=
X-Received: by 2002:a19:f70f:0:b0:4a2:391d:71c2 with SMTP id
 z15-20020a19f70f000000b004a2391d71c2mr3706163lfe.376.1664872422413; Tue, 04
 Oct 2022 01:33:42 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000a793cc05ea313b87@google.com>
In-Reply-To: <000000000000a793cc05ea313b87@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 4 Oct 2022 10:33:30 +0200
Message-ID: <CACT4Y+a8b-knajrXWs8OnF1ijCansRxEicU=YJz6PRk-JuSKvg@mail.gmail.com>
Subject: Re: [syzbot] upstream boot error: WARNING in netlink_ack
To:     syzbot <syzbot+3a080099974c271cd7e9@syzkaller.appspotmail.com>
Cc:     bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        fw@strlen.de, harshit.m.mogalapalli@oracle.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        Kees Cook <keescook@chromium.org>,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Oct 2022 at 10:27, syzbot
<syzbot+3a080099974c271cd7e9@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    725737e7c21d Merge tag 'statx-dioalign-for-linus' of git:/..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=10257034880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=486af5e221f55835
> dashboard link: https://syzkaller.appspot.com/bug?extid=3a080099974c271cd7e9
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+3a080099974c271cd7e9@syzkaller.appspotmail.com

+linux-hardening

> ------------[ cut here ]------------
> memcpy: detected field-spanning write (size 28) of single field "&errmsg->msg" at net/netlink/af_netlink.c:2447 (size 16)
> WARNING: CPU: 3 PID: 3351 at net/netlink/af_netlink.c:2447 netlink_ack+0x8ac/0xb10 net/netlink/af_netlink.c:2447
> Modules linked in:
> CPU: 3 PID: 3351 Comm: dhcpcd Not tainted 6.0.0-syzkaller-00593-g725737e7c21d #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
> RIP: 0010:netlink_ack+0x8ac/0xb10 net/netlink/af_netlink.c:2447
> Code: fa ff ff e8 36 c3 e5 f9 b9 10 00 00 00 4c 89 ee 48 c7 c2 20 3f fb 8a 48 c7 c7 80 3f fb 8a c6 05 e8 98 34 06 01 e8 26 77 a6 01 <0f> 0b e9 3a fa ff ff 41 be 00 01 00 00 41 bd 14 00 00 00 e9 ea fd
> RSP: 0018:ffffc900220e7758 EFLAGS: 00010282
> RAX: 0000000000000000 RBX: ffff88801a798a80 RCX: 0000000000000000
> RDX: ffff8880151c0180 RSI: ffffffff81611cb8 RDI: fffff5200441cedd
> RBP: ffff88801ed850c0 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000080000000 R11: 0000000000000000 R12: 0000000000000000
> R13: 000000000000001c R14: ffff88801ec8e400 R15: ffff88801ec8e414
> FS:  00007faef0af8740(0000) GS:ffff88802cb00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fff6adbe000 CR3: 0000000027683000 CR4: 0000000000150ee0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  netlink_rcv_skb+0x33d/0x420 net/netlink/af_netlink.c:2507
>  genl_rcv+0x24/0x40 net/netlink/genetlink.c:803
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
> RIP: 0033:0x7faef0bf0163
> Code: 64 89 02 48 c7 c0 ff ff ff ff eb b7 66 2e 0f 1f 84 00 00 00 00 00 90 64 8b 04 25 18 00 00 00 85 c0 75 14 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 55 c3 0f 1f 40 00 48 83 ec 28 89 54 24 1c 48
> RSP: 002b:00007fff6adbdc48 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007faef0bf0163
> RDX: 0000000000000000 RSI: 00007fff6adbdc90 RDI: 0000000000000010
> RBP: 00007fff6adc1ed8 R08: 0000000000000000 R09: 0000000000000000
> R10: 00007faef0c6ffc0 R11: 0000000000000246 R12: 0000000000000010
> R13: 00007fff6adc1cf0 R14: 0000000000000000 R15: 000055e5ebce0290
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
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000a793cc05ea313b87%40google.com.
