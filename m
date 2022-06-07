Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7988E53F2DE
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 02:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233816AbiFGACr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 20:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232617AbiFGACq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 20:02:46 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4180A25F7
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 17:02:44 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id x187so15238585vsb.0
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 17:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2bSfEvaJWCv58c//WlDF+06gMIemODqrXcZgwXMRRvY=;
        b=R4JhZ9mHaMIVA+jEaC/4okAqtlMZCt/n3piuwRGdeFhwTBQWoP5ytunoqOGlzoE9YT
         ENML4lHUAAwwDrAlqgrMfHL5Jko8ZUWHbtvey/Spgjsv4bA07bPX4AkQXGxTEkZ7h2zd
         spwMk2sQsjnbnvUy6C2KrqlAwYxYXjaTPAvzcj2cvylDm8XjjOYuda5AOlIvdq07pK1J
         +kMMqj4RQT75Mw9/nQfJ936rFPp1KkrbMor0O2ld3Ulz7Qgwh9GCH7D7E4GK8dP/72x8
         oJmuqqZAhpPWL9bRReRYEVm5/eaX//nKWl2bBemg8pQiQonGtpS+ZE5RJ8p5nun3MfRg
         F/Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2bSfEvaJWCv58c//WlDF+06gMIemODqrXcZgwXMRRvY=;
        b=y5Xbo545E+Y8pZ2+d35tXifvLmW1AdM+6TvO4MPpDR0PIIU0wAjPWJG9fsNp+RqfIK
         ZVoMvxA6gPZU4geDcQNddL0cRVTjf+YQumSw5Q/4zg+SFi+hQ20Ho9WWWtwpBk2BKiiX
         C9JGW2z04YoHKlJK30GJ/9L38kUoc/MqxDl/xbxqYNLYWPQsJ+zkKtcevq+KrX702RMS
         +hEIpVzcCBctIDqLhN0HAlK1W4xSpSLpXSgvyROauWL4o8c9H4nPe0CJ4sy1b8IG4e8N
         o5pUQ7AXW259veMDZ3eA69P1zdztQAmSpcefzp8GsHqJd1f4eEgR30ven1+JOphZ/k7E
         Y02g==
X-Gm-Message-State: AOAM53133NW1kP+K4XEpKoBdORmKqA1WVESPYedbrAc/rj1dr0n8JWPD
        rdFpRXdnOhZlXuluhZRbNXiwd3+aLLFI7ijLp3w=
X-Google-Smtp-Source: ABdhPJyK/JYmW6vAYR7h97HqKt+k3LMMFwUK4zpvdEgeLI3u9CMLBbFzv5jutMW6tLNvR6XYnGTrAnjlGINC6YwvTrs=
X-Received: by 2002:a67:df11:0:b0:32c:ba04:cf9a with SMTP id
 s17-20020a67df11000000b0032cba04cf9amr11296582vsk.18.1654560163366; Mon, 06
 Jun 2022 17:02:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220602165101.3188482-1-joannelkoong@gmail.com>
 <4bae9df4-42c1-85c3-d350-119a151d29@linux.intel.com> <CAJnrk1buk-hK3nwyPz+o+wZLDdZTPpBSNniY3sJtgXZtJXOROQ@mail.gmail.com>
In-Reply-To: <CAJnrk1buk-hK3nwyPz+o+wZLDdZTPpBSNniY3sJtgXZtJXOROQ@mail.gmail.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Mon, 6 Jun 2022 17:02:32 -0700
Message-ID: <CAJnrk1bF=TD2b+RaYqH10i6LXkzbzsVHmM=-wR7S2_bHGxMuNw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/2] Update bhash2 when socket's rcv saddr changes
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 3, 2022 at 5:38 PM Joanne Koong <joannelkoong@gmail.com> wrote:
>
> On Fri, Jun 3, 2022 at 11:55 AM Mat Martineau
> <mathew.j.martineau@linux.intel.com> wrote:
> >
> > On Thu, 2 Jun 2022, Joanne Koong wrote:
> >
> > > As syzbot noted [1], there is an inconsistency in the bhash2 table in the
> > > case where a socket's rcv saddr changes after it is binded. (For more
> > > details, please see the commit message of the first patch)
> > >
> > > This patchset fixes that and adds a test that triggers the case where the
> > > sk's rcv saddr changes. The subsequent listen() call should succeed.
> > >
> > > [1] https://lore.kernel.org/netdev/0000000000003f33bc05dfaf44fe@google.com/
> > >
> > > --
> > > v1 -> v2:
> > > v1: https://lore.kernel.org/netdev/20220601201434.1710931-1-joannekoong@fb.com/
> > > * Mark __inet_bhash2_update_saddr as static
> > >
> > > Joanne Koong (2):
> > >  net: Update bhash2 when socket's rcv saddr changes
> > >  selftests/net: Add sk_bind_sendto_listen test
> > >
> >
> > Hi Joanne -
> >
> > I've been running my own syzkaller instance with v1 of this fix for a
> > couple of days. Before this patch, syzkaller would trigger the
> > inet_csk_get_port warning a couple of times per hour. After this patch it
> > took two days to show the warning:
> >
> > ------------[ cut here ]------------
> >
> > WARNING: CPU: 0 PID: 9430 at net/ipv4/inet_connection_sock.c:525
> > inet_csk_get_port+0x938/0xe80 net/ipv4/inet_connection_sock.c:525
> > Modules linked in:
> > CPU: 0 PID: 9430 Comm: syz-executor.5 Not tainted 5.18.0-05016-g433fde5b4119 #3
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> > RIP: 0010:inet_csk_get_port+0x938/0xe80 net/ipv4/inet_connection_sock.c:525
> > Code: ff 48 89 84 24 b0 00 00 00 48 85 c0 0f 84 6a 01 00 00 e8 2b 0f db fd 48 8b 6c 24 70 c6 04 24 01 e9 fb fb ff ff e8 18 0f db fd <0f> 0b e9 70 f9 ff ff e8 0c 0f db fd 0f 0b e9 28 f9 ff ff e8 00 0f
> > RSP: 0018:ffffc90000b5fbc0 EFLAGS: 00010212
> > RAX: 00000000000000e7 RBX: ffff88803c410040 RCX: ffffc9000e419000
> > RDX: 0000000000040000 RSI: ffffffff836f47e8 RDI: ffff88803c4106e0
> > RBP: ffff88810b773840 R08: 0000000000000001 R09: 0000000000000001
> > R10: fffffbfff0f64303 R11: 0000000000000001 R12: 0000000000000000
> > R13: ffff88810605e2f0 R14: ffffffff88606040 R15: 000000000000c1ff
> > FS:  00007fada4d03640(0000) GS:ffff88811ac00000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000001b32e24000 CR3: 00000001016de001 CR4: 0000000000770ef0
> > PKRU: 55555554
> > Call Trace:
> >   <TASK>
> >   inet_csk_listen_start+0x143/0x3d0 net/ipv4/inet_connection_sock.c:1178
> >   inet_listen+0x22f/0x650 net/ipv4/af_inet.c:228
> >   mptcp_listen+0x205/0x440 net/mptcp/protocol.c:3564
> >   __sys_listen+0x189/0x260 net/socket.c:1810
> >   __do_sys_listen net/socket.c:1819 [inline]
> >   __se_sys_listen net/socket.c:1817 [inline]
> >   __x64_sys_listen+0x54/0x80 net/socket.c:1817
> >   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >   do_syscall_64+0x38/0x90 arch/x86/entry/common.c:80
> >   entry_SYSCALL_64_after_hwframe+0x46/0xb0
> > RIP: 0033:0x7fada558f92d
> > Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007fada4d03028 EFLAGS: 00000246 ORIG_RAX: 0000000000000032
> > RAX: ffffffffffffffda RBX: 00007fada56aff60 RCX: 00007fada558f92d
> > RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
> > RBP: 00007fada56000a0 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> > R13: 000000000000000b R14: 00007fada56aff60 R15: 00007fada4ce3000
> >   </TASK>
> > irq event stamp: 2078
> > hardirqs last  enabled at (2092): [<ffffffff812f1be3>] __up_console_sem+0xb3/0xd0 kernel/printk/printk.c:291
> > hardirqs last disabled at (2103): [<ffffffff812f1bc8>] __up_console_sem+0x98/0xd0 kernel/printk/printk.c:289
> > softirqs last  enabled at (1498): [<ffffffff83807dd4>] lock_sock include/net/sock.h:1691 [inline]
> > softirqs last  enabled at (1498): [<ffffffff83807dd4>] inet_listen+0x94/0x650 net/ipv4/af_inet.c:199
> > softirqs last disabled at (1500): [<ffffffff836f425c>] spin_lock_bh include/linux/spinlock.h:354 [inline]
> > softirqs last disabled at (1500): [<ffffffff836f425c>] inet_csk_get_port+0x3ac/0xe80 net/ipv4/inet_connection_sock.c:483
> > ---[ end trace 0000000000000000 ]---
> >
> >
> > In the full log file it does look like syskaller is doing something
> > strange since it's calling bind, connect, and listen on the same socket:
> >
> > r4 = socket$inet_mptcp(0x2, 0x1, 0x106)
> > bind$inet(r4, &(0x7f0000000000)={0x2, 0x4e23, @empty}, 0x10)
> > connect$inet(r4, &(0x7f0000000040)={0x2, 0x0, @local}, 0x10)
> > listen(r4, 0x0)
> >
> > ...but it is a fuzz tester after all.
> >
> > I've uploaded the full syzkaller logs to this GitHub issue:
> >
> > https://github.com/multipath-tcp/mptcp_net-next/issues/279
> >
> >
> > Not sure yet if this is MPTCP-related. I don't think MPTCP
> > changes anything with the subflow TCP socket bind hashes.
> >
> Hi Mat,
>
> Thanks for bringing this up and for uploading the logs. I will look into this.
> >
Hi Mat,

I am still trying to configure my local environment for mptcp to repro
+ test the fix to verify that it is correct. I think the fix is to add
"inet_bhash2_update_saddr(msk);" to the end of the
"mptcp_copy_inaddrs" function in net/mptcp/protocol.c.  Would you be
able to run an instance on your local syzkaller environment with this
line added to see if that fixes the warning?

Thanks,
Joanne
> > --
> > Mat Martineau
> > Intel
> >
