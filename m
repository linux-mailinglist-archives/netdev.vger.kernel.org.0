Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 205711D325E
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 16:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbgENONO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 10:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbgENONO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 10:13:14 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54061C061A0C;
        Thu, 14 May 2020 07:13:14 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id s69so4305051pjb.4;
        Thu, 14 May 2020 07:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=F8OLBVYMAmZx/Mrska94+gIHzANrKtt3D3l55r2EGPA=;
        b=DIMhVlrPR0FokHpSpzYfTkavpWg1/Q3UAsvOb1m5LOdFK7Rdp5KKbk0O+Gxk1QidNp
         0sdQqAUKbB5V3YIhVhQC3If5Vd6zOpTPsFZ8/35PcVv+yzY8YycYG4UCVkDrbKMYYPxb
         FmIx/m9OQhQP6lEUIavEYcwsy/Cejt3RNHCEj0gqpTeDdg5ZQCA4Yo9GAla9S6BaOF4b
         R41ejLtIJ68d1qgMVluM/ciaVj/TU33uFeFz4aD07C5znEp/kNSbogfVx6VnHH0NVrg1
         TGTKFXlR8535dJpCyMlrRVXjdvfRyYnrwMmg9YLMgrkL++PIvAl4QkuSeQEQqj03NrcT
         81jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=F8OLBVYMAmZx/Mrska94+gIHzANrKtt3D3l55r2EGPA=;
        b=EiCW9J3Eu7MydKkQyfjmdagxwlufd60N/AGcrw54GPnZrm3WmTQfMCcSh7/nZHOAu/
         t9KrStg04z1PE2wru0pXDHL/Z8MMtK9hk+VX7B+gOgyTgXI+LEP04HoeM+/c3bUUZQuK
         2BQhDeXjSkb6zX+6hDAlbCumivQsaZG2SC+6FNvtnW6NJ9SKwgsYGugRQ/XuzyYfQfUZ
         lhrj9pjCFVrGGpr7+Fg8ynibW3ghPWeSi4fmuHDL+Hjw823stW38v3SaEDc6c0AB3YRf
         lL8JIZ9XU585TXuFnLaPEBvTaG5bHTVHAhj4biJDiyBjzF9qbKoCAcRZm5rLh1bYkd6j
         6U7Q==
X-Gm-Message-State: AOAM531kRyZKPC40hCTd68kkQbVQkpjc2GVZLusRB9DeEE/66HTgNBvb
        hGx/r03OQ+ddRzDbDgjL/g==
X-Google-Smtp-Source: ABdhPJxb0XsNEvxm2H2xUtnO78G+pvHnr6i5loNwjG205UtJJiYyWkzG1kNwO9Y9/9Fg9yQL9B8qGw==
X-Received: by 2002:a17:902:aa44:: with SMTP id c4mr4204675plr.302.1589465593873;
        Thu, 14 May 2020 07:13:13 -0700 (PDT)
Received: from madhuparna-HP-Notebook ([2402:3a80:13bf:a95e:89fb:f860:f992:54ab])
        by smtp.gmail.com with ESMTPSA id l3sm1925041pjb.39.2020.05.14.07.13.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 14 May 2020 07:13:13 -0700 (PDT)
From:   Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
X-Google-Original-From: Madhuparna Bhowmik <change_this_user_name@gmail.com>
Date:   Thu, 14 May 2020 19:43:05 +0530
To:     Qian Cai <cai@lca.pw>
Cc:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        Amol Grover <frextrite@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>, allison@lohutok.net,
        ap420073@gmail.com, David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot <syzbot+bb82cafc737c002d11ca@syzkaller.appspotmail.com>
Subject: Re: linux-next boot error: WARNING: suspicious RCU usage in
 bpq_device_event
Message-ID: <20200514141305.GA16145@madhuparna-HP-Notebook>
References: <000000000000785a6905a59a1e4a@google.com>
 <A19DAE77-5DCD-460A-88E5-437450CBD50B@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A19DAE77-5DCD-460A-88E5-437450CBD50B@lca.pw>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 08:24:54AM -0400, Qian Cai wrote:
> 
> 
> > On May 14, 2020, at 7:37 AM, syzbot <syzbot+bb82cafc737c002d11ca@syzkaller.appspotmail.com> wrote:
> > 
> > Hello,
> > 
> > syzbot found the following crash on:
> > 
> > HEAD commit:    c9529331 Add linux-next specific files for 20200514
> > git tree:       linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=17119f48100000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=404a80e135048067
> > dashboard link: https://syzkaller.appspot.com/bug?extid=bb82cafc737c002d11ca
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > 
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+bb82cafc737c002d11ca@syzkaller.appspotmail.com
> > 
> > =============================
> > WARNING: suspicious RCU usage
> > 5.7.0-rc5-next-20200514-syzkaller #0 Not tainted
> > -----------------------------
> > drivers/net/hamradio/bpqether.c:149 RCU-list traversed in non-reader section!!
> 
> How about teaching the bot to always CC Madhuparna and Amol for those RCU-list bug reports?
>
Thank you for forwarding this warning.

Regards,
Madhuparna
> > 
> > other info that might help us debug this:
> > 
> > 
> > rcu_scheduler_active = 2, debug_locks = 1
> > 1 lock held by ip/3967:
> > #0: ffffffff8a7bad88 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
> > #0: ffffffff8a7bad88 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5458
> > 
> > stack backtrace:
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > Call Trace:
> > __dump_stack lib/dump_stack.c:77 [inline]
> > dump_stack+0x18f/0x20d lib/dump_stack.c:118
> > bpq_get_ax25_dev drivers/net/hamradio/bpqether.c:149 [inline]
> > bpq_device_event+0x796/0x8ee drivers/net/hamradio/bpqether.c:538
> > notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
> > call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
> > call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
> > call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
> > call_netdevice_notifiers net/core/dev.c:2042 [inline]
> > __dev_notify_flags+0x121/0x2c0 net/core/dev.c:8279
> > dev_change_flags+0x100/0x160 net/core/dev.c:8317
> > do_setlink+0xa1c/0x35d0 net/core/rtnetlink.c:2605
> > __rtnl_newlink+0xad0/0x1590 net/core/rtnetlink.c:3273
> > rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3398
> > rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5461
> > netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
> > netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
> > netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
> > netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
> > sock_sendmsg_nosec net/socket.c:652 [inline]
> > sock_sendmsg+0xcf/0x120 net/socket.c:672
> > ____sys_sendmsg+0x6e6/0x810 net/socket.c:2352
> > ___sys_sendmsg+0x100/0x170 net/socket.c:2406
> > __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
> > do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
> > entry_SYSCALL_64_after_hwframe+0x49/0xb3
> > RIP: 0033:0x7f76dcdfcdc7
> > Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb cd 66 0f 1f 44 00 00 8b 05 4a 49 2b 00 85 c0 75 2e 48 63 ff 48 63 d2 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 8b 15 a1 f0 2a 00 f7 d8 64 89 02 48
> > RSP: 002b:00007ffd45eccf28 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> > RAX: ffffffffffffffda RBX: 000000005ebd27cd RCX: 00007f76dcdfcdc7
> > RDX: 0000000000000000 RSI: 00007ffd45eccf70 RDI: 0000000000000003
> > RBP: 00007ffd45eccf70 R08: 0000000000001000 R09: fefefeff77686d74
> > R10: 00000000000005e9 R11: 0000000000000246 R12: 00007ffd45eccfb0
> > R13: 0000561a2ddea3c0 R14: 00007ffd45ed5030 R15: 0000000000000000
> > ip (3967) used greatest stack depth: 23144 bytes left
> > 
> > 
> > ---
> > This bug is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > 
> > syzbot will keep track of this bug report. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
