Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A044172263
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 16:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729553AbgB0PlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 10:41:03 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:37355 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729482AbgB0PlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 10:41:02 -0500
Received: by mail-qk1-f195.google.com with SMTP id m9so3550319qke.4
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 07:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UcmWvN21kKZ70hUOSa5/kSaL+wAOScFP8hTIhBw94cc=;
        b=HrZuG8TSWbYhikpPJoxBz/fKCVPIQuwuHVyA201FRpmuYx6Ud9t7WNCt0nJ6dlrvyE
         Pk/KVnuZaVvsi+lgx6pKdpBNT99JdBpu/aVhC/tOLfmSVmFFBGZ+J+U44CIfyISj6w4+
         RBsQoRCbYkVn6GST1UcvN34AhM59RC3up+BetUc+UaYUnlk2cUfSsj6zE0P/YXoz4r6w
         jUJcr8ZQZ37zNRVL2wWeP4jerbKHvr/CprSHAvYtt27/P7IeJRLKa4HI/LANFBpMr1B6
         N/n1rRwr+jQdiqSpPbp+nbUUXTVaS2cE/8B5BPS3SmFKkKJxF2yNicOQcjzmlJhAFSW/
         pjYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UcmWvN21kKZ70hUOSa5/kSaL+wAOScFP8hTIhBw94cc=;
        b=r51eYkIA12/FMsFWHA9HQx/V7iWvZw6arQrf+4E4zhzJfM9mF/wugVFf6MdteMiLUY
         JiWArImWUUvWzumJKJIk0WrmmLUngOH39xbuwPdVkmsSH77Bu8NxXuUtsttGPNbC0F0b
         sCUwyFKh/I01NS+NGohn/3BsrKBVjHDaIdtSJnZ4gy9QC04M5TBsoHyPvcLoNIMceGGH
         FrhTGST+P/n10/zowCkOZ71SijeWP7WphAV8WyGxWNCc43moiBNJPtdv7BRM3DMevoda
         yGAe+/dwuMP/GAgdbbgxHrF+nBvST7pGuff4v0Q3geB+lrKaaMALKau87iyfv8zUXwWA
         oEQg==
X-Gm-Message-State: APjAAAVngjOD5NrnQIg/iVxSi9nRzR63FXp+82KoSJVOliErw3ZxiERV
        Ts628pON2ZdL53tdvrJa1h5F8Hi1OgzNt6g/dUi+ww==
X-Google-Smtp-Source: APXvYqyvCcZRyPJXJqpRh+lJbBsXcMCYS+j8CNs54f9MKXADA9C0ZddbN1rC7XyVj5phQQm+xGzC+owGEthT9Uu0wmc=
X-Received: by 2002:a37:4755:: with SMTP id u82mr5889350qka.43.1582818061001;
 Thu, 27 Feb 2020 07:41:01 -0800 (PST)
MIME-Version: 1.0
References: <0000000000005fe204059f4ddf27@google.com> <CAHC9VhRxnY8Zj9OvPcbkc0VkUsJKd7+khAz7MiGGs0SUoegg_g@mail.gmail.com>
In-Reply-To: <CAHC9VhRxnY8Zj9OvPcbkc0VkUsJKd7+khAz7MiGGs0SUoegg_g@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 27 Feb 2020 16:40:49 +0100
Message-ID: <CACT4Y+b0dXffn_5Yk8OPRgNJci6z6gmNQMaDuu-xNgTiwwDj4w@mail.gmail.com>
Subject: Re: kernel panic: audit: rate limit exceeded
To:     Paul Moore <paul@paul-moore.com>
Cc:     syzbot <syzbot+72461ac44b36c98f58e5@syzkaller.appspotmail.com>,
        Eric Paris <eparis@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>, linux-audit@redhat.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, peter.senna@collabora.com,
        romain.perier@collabora.com, stas.yakovlev@gmail.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 11:37 PM Paul Moore <paul@paul-moore.com> wrote:
>
> On Mon, Feb 24, 2020 at 3:08 AM syzbot
> <syzbot+72461ac44b36c98f58e5@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    0c0ddd6a Merge tag 'linux-watchdog-5.6-rc3' of git://www.l..
> > git tree:       net
> > console output: https://syzkaller.appspot.com/x/log.txt?x=12c8a3d9e00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3b8906eb6a7d6028
> > dashboard link: https://syzkaller.appspot.com/bug?extid=72461ac44b36c98f58e5
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14c803ede00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17237de9e00000
> >
> > The bug was bisected to:
> >
> > commit 28b75415ad19fef232d8daab4d5de17d753f0b36
> > Author: Romain Perier <romain.perier@collabora.com>
> > Date:   Wed Aug 23 07:16:51 2017 +0000
> >
> >     wireless: ipw2200: Replace PCI pool old API
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12dbfe09e00000
> > final crash:    https://syzkaller.appspot.com/x/report.txt?x=11dbfe09e00000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=16dbfe09e00000
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+72461ac44b36c98f58e5@syzkaller.appspotmail.com
> > Fixes: 28b75415ad19 ("wireless: ipw2200: Replace PCI pool old API")
> >
> > audit: audit_lost=1 audit_rate_limit=2 audit_backlog_limit=0
> > Kernel panic - not syncing: audit: rate limit exceeded
> > CPU: 1 PID: 10031 Comm: syz-executor626 Not tainted 5.6.0-rc2-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > Call Trace:
> >  __dump_stack lib/dump_stack.c:77 [inline]
> >  dump_stack+0x197/0x210 lib/dump_stack.c:118
> >  panic+0x2e3/0x75c kernel/panic.c:221
> >  audit_panic.cold+0x32/0x32 kernel/audit.c:307
> >  audit_log_lost kernel/audit.c:377 [inline]
> >  audit_log_lost+0x8b/0x180 kernel/audit.c:349
> >  audit_log_end+0x23c/0x2b0 kernel/audit.c:2322
> >  audit_log_config_change+0xcc/0xf0 kernel/audit.c:396
> >  audit_receive_msg+0x2246/0x28b0 kernel/audit.c:1277
> >  audit_receive+0x114/0x230 kernel/audit.c:1513
> >  netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
> >  netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1329
> >  netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1918
> >  sock_sendmsg_nosec net/socket.c:652 [inline]
> >  sock_sendmsg+0xd7/0x130 net/socket.c:672
> >  ____sys_sendmsg+0x753/0x880 net/socket.c:2343
> >  ___sys_sendmsg+0x100/0x170 net/socket.c:2397
> >  __sys_sendmsg+0x105/0x1d0 net/socket.c:2430
> >  __do_sys_sendmsg net/socket.c:2439 [inline]
> >  __se_sys_sendmsg net/socket.c:2437 [inline]
> >  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2437
> >  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
> >  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > RIP: 0033:0x441239
> > Code: e8 fc ab 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 9b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> > RSP: 002b:00007ffd68c9df48 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> > RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441239
> > RDX: 0000000000000000 RSI: 00000000200006c0 RDI: 0000000000000003
> > RBP: 0000000000018b16 R08: 00000000004002c8 R09: 00000000004002c8
> > R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000402060
> > R13: 00000000004020f0 R14: 0000000000000000 R15: 0000000000000000
> > Kernel Offset: disabled
> > Rebooting in 86400 seconds..
>
> Has the syzbot audit related configuration recently changed?  At the
> very least it looks like you want to configure the system so that it
> doesn't panic when an audit record is lost (printk/AUDIT_FAIL_PRINTK
> or silent/AUDIT_FAIL_SILENT are better options); look at the
> auditctl(8) manpage for some more information (hint: look at the "-f"
> option).

That one has more extended discussion of the situation:

#syz dup: kernel panic: audit: backlog limit exceeded
