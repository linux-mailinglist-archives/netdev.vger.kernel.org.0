Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9E14543D95
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 22:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbiFHU2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 16:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiFHU2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 16:28:06 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849D33DB6F1
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 13:28:04 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id 68so20767400vse.11
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 13:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eRmWnTNoQsY7caBqnXLsmKEdLPB1JMF2I1pvfuNnyAc=;
        b=RCTZePffa68fkHqnREdIwOoOSsiK1q9j+/630t/oHQ04FqEKeWdk/VDeIbPLniFb3p
         xJEWucCQStK1Zhl0tTF03VZVZ6o67D0Dz2c7p9ZeeLhWa+cqwHB4f16ZHcb4y/42MTM2
         v7PBsOiImMwNQnZhTtqTTg9FCrl8g03+bJKOwjCDT9V/5U/94EqR7NAmB8Qisd0qjf7E
         zOQfqbmhmEi0M6BE17UV0ckiSIY3AevQ8qyjtlfzV6wJFlwt4fmimKbp/ursxJDu+Yce
         JhbEILx3ddkNhApXXfUU97Ok37I1puRDZ/Tg7xaOWYMepTdBT7YOQGKgstydUZYerno7
         XLdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eRmWnTNoQsY7caBqnXLsmKEdLPB1JMF2I1pvfuNnyAc=;
        b=bmogQZK7iu0FxeewE2SlvW27Y9x4SNmkVUe7qhgwEAmx55p07YErRNR1rWcRMV0hho
         aHuOBcI3oxVlq+wz7x5C4BROKb8gAWl+uVzxEePOOAbf3R5Lo0qZi8RETKEXucZj1H3J
         vK+DHcuJsaiLFzhT/x4N0yECzS18y0cZpzoo2UPFzXB5L4cQhZnrcsyjbNi1L3dB/jDs
         3eAlfRS1zHo/dDNhSS7d0+7TCKz2t6ivY7umK/Q93EExlvuUucM0yLE21+brvQjEV4Qo
         EngioYVvniXZGUtBJzlcD4h4SqPsLjieWeS0+AjrfpaZgqFQ89dE45Oc8YKLn0fJUtsP
         XXJQ==
X-Gm-Message-State: AOAM533S6VT7zBN0Tt0P6oQSXZwgL3f3ns0ecDTEh6o9+Ysk2lJQ70Ev
        xmf9IzC2fTtAuPYSmNH6i06JOHGYK/teRzPxOcY=
X-Google-Smtp-Source: ABdhPJxa3GaMuzJoEauUjN7/LS/lgf9+cTeDIU4NvEgrEQ7+V8yXv6oui1NWHCsm/NEr72o8dsNEc+cUGIPPJV8JeqE=
X-Received: by 2002:a67:df11:0:b0:32c:ba04:cf9a with SMTP id
 s17-20020a67df11000000b0032cba04cf9amr16511295vsk.18.1654720083649; Wed, 08
 Jun 2022 13:28:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220602165101.3188482-1-joannelkoong@gmail.com>
 <4bae9df4-42c1-85c3-d350-119a151d29@linux.intel.com> <CAJnrk1buk-hK3nwyPz+o+wZLDdZTPpBSNniY3sJtgXZtJXOROQ@mail.gmail.com>
 <CAJnrk1bF=TD2b+RaYqH10i6LXkzbzsVHmM=-wR7S2_bHGxMuNw@mail.gmail.com> <e14e34b-2a1c-18b2-7c25-5ad72c5fc8@linux.intel.com>
In-Reply-To: <e14e34b-2a1c-18b2-7c25-5ad72c5fc8@linux.intel.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Wed, 8 Jun 2022 13:27:52 -0700
Message-ID: <CAJnrk1banJ13wqeAa9nqU1vdgFuizvU+fp6svwXRh5=XVS3c+g@mail.gmail.com>
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

On Tue, Jun 7, 2022 at 10:33 AM Mat Martineau
<mathew.j.martineau@linux.intel.com> wrote:
>
> On Mon, 6 Jun 2022, Joanne Koong wrote:
>
> > On Fri, Jun 3, 2022 at 5:38 PM Joanne Koong <joannelkoong@gmail.com> wrote:
> >>
> >> On Fri, Jun 3, 2022 at 11:55 AM Mat Martineau
> >> <mathew.j.martineau@linux.intel.com> wrote:
> >>>
> >>> On Thu, 2 Jun 2022, Joanne Koong wrote:
> >>>
> >>>> As syzbot noted [1], there is an inconsistency in the bhash2 table in the
> >>>> case where a socket's rcv saddr changes after it is binded. (For more
> >>>> details, please see the commit message of the first patch)
> >>>>
> >>>> This patchset fixes that and adds a test that triggers the case where the
> >>>> sk's rcv saddr changes. The subsequent listen() call should succeed.
> >>>>
> >>>> [1] https://lore.kernel.org/netdev/0000000000003f33bc05dfaf44fe@google.com/
> >>>>
> >>>> --
> >>>> v1 -> v2:
> >>>> v1: https://lore.kernel.org/netdev/20220601201434.1710931-1-joannekoong@fb.com/
> >>>> * Mark __inet_bhash2_update_saddr as static
> >>>>
> >>>> Joanne Koong (2):
> >>>>  net: Update bhash2 when socket's rcv saddr changes
> >>>>  selftests/net: Add sk_bind_sendto_listen test
> >>>>
> >>>
> >>> Hi Joanne -
> >>>
> >>> I've been running my own syzkaller instance with v1 of this fix for a
> >>> couple of days. Before this patch, syzkaller would trigger the
> >>> inet_csk_get_port warning a couple of times per hour. After this patch it
> >>> took two days to show the warning:
> >>>
> >>> ------------[ cut here ]------------
> >>>
> >>> WARNING: CPU: 0 PID: 9430 at net/ipv4/inet_connection_sock.c:525
> >>> inet_csk_get_port+0x938/0xe80 net/ipv4/inet_connection_sock.c:525
> >>> Modules linked in:
> >>> CPU: 0 PID: 9430 Comm: syz-executor.5 Not tainted 5.18.0-05016-g433fde5b4119 #3
> >>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> >>> RIP: 0010:inet_csk_get_port+0x938/0xe80 net/ipv4/inet_connection_sock.c:525
> >>> Code: ff 48 89 84 24 b0 00 00 00 48 85 c0 0f 84 6a 01 00 00 e8 2b 0f db fd 48 8b 6c 24 70 c6 04 24 01 e9 fb fb ff ff e8 18 0f db fd <0f> 0b e9 70 f9 ff ff e8 0c 0f db fd 0f 0b e9 28 f9 ff ff e8 00 0f
> >>> RSP: 0018:ffffc90000b5fbc0 EFLAGS: 00010212
> >>> RAX: 00000000000000e7 RBX: ffff88803c410040 RCX: ffffc9000e419000
> >>> RDX: 0000000000040000 RSI: ffffffff836f47e8 RDI: ffff88803c4106e0
> >>> RBP: ffff88810b773840 R08: 0000000000000001 R09: 0000000000000001
> >>> R10: fffffbfff0f64303 R11: 0000000000000001 R12: 0000000000000000
> >>> R13: ffff88810605e2f0 R14: ffffffff88606040 R15: 000000000000c1ff
> >>> FS:  00007fada4d03640(0000) GS:ffff88811ac00000(0000) knlGS:0000000000000000
> >>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >>> CR2: 0000001b32e24000 CR3: 00000001016de001 CR4: 0000000000770ef0
> >>> PKRU: 55555554
> >>> Call Trace:
> >>>   <TASK>
> >>>   inet_csk_listen_start+0x143/0x3d0 net/ipv4/inet_connection_sock.c:1178
> >>>   inet_listen+0x22f/0x650 net/ipv4/af_inet.c:228
> >>>   mptcp_listen+0x205/0x440 net/mptcp/protocol.c:3564
> >>>   __sys_listen+0x189/0x260 net/socket.c:1810
> >>>   __do_sys_listen net/socket.c:1819 [inline]
> >>>   __se_sys_listen net/socket.c:1817 [inline]
> >>>   __x64_sys_listen+0x54/0x80 net/socket.c:1817
> >>>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >>>   do_syscall_64+0x38/0x90 arch/x86/entry/common.c:80
> >>>   entry_SYSCALL_64_after_hwframe+0x46/0xb0
> >>> RIP: 0033:0x7fada558f92d
> >>> Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> >>> RSP: 002b:00007fada4d03028 EFLAGS: 00000246 ORIG_RAX: 0000000000000032
> >>> RAX: ffffffffffffffda RBX: 00007fada56aff60 RCX: 00007fada558f92d
> >>> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
> >>> RBP: 00007fada56000a0 R08: 0000000000000000 R09: 0000000000000000
> >>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> >>> R13: 000000000000000b R14: 00007fada56aff60 R15: 00007fada4ce3000
> >>>   </TASK>
> >>> irq event stamp: 2078
> >>> hardirqs last  enabled at (2092): [<ffffffff812f1be3>] __up_console_sem+0xb3/0xd0 kernel/printk/printk.c:291
> >>> hardirqs last disabled at (2103): [<ffffffff812f1bc8>] __up_console_sem+0x98/0xd0 kernel/printk/printk.c:289
> >>> softirqs last  enabled at (1498): [<ffffffff83807dd4>] lock_sock include/net/sock.h:1691 [inline]
> >>> softirqs last  enabled at (1498): [<ffffffff83807dd4>] inet_listen+0x94/0x650 net/ipv4/af_inet.c:199
> >>> softirqs last disabled at (1500): [<ffffffff836f425c>] spin_lock_bh include/linux/spinlock.h:354 [inline]
> >>> softirqs last disabled at (1500): [<ffffffff836f425c>] inet_csk_get_port+0x3ac/0xe80 net/ipv4/inet_connection_sock.c:483
> >>> ---[ end trace 0000000000000000 ]---
> >>>
> >>>
> >>> In the full log file it does look like syskaller is doing something
> >>> strange since it's calling bind, connect, and listen on the same socket:
> >>>
> >>> r4 = socket$inet_mptcp(0x2, 0x1, 0x106)
> >>> bind$inet(r4, &(0x7f0000000000)={0x2, 0x4e23, @empty}, 0x10)
> >>> connect$inet(r4, &(0x7f0000000040)={0x2, 0x0, @local}, 0x10)
> >>> listen(r4, 0x0)
> >>>
> >>> ...but it is a fuzz tester after all.
> >>>
> >>> I've uploaded the full syzkaller logs to this GitHub issue:
> >>>
> >>> https://github.com/multipath-tcp/mptcp_net-next/issues/279
> >>>
> >>>
> >>> Not sure yet if this is MPTCP-related. I don't think MPTCP
> >>> changes anything with the subflow TCP socket bind hashes.
> >>>
> >> Hi Mat,
> >>
> >> Thanks for bringing this up and for uploading the logs. I will look into this.
> >>>
> > Hi Mat,
> >
> > I am still trying to configure my local environment for mptcp to repro
> > + test the fix to verify that it is correct. I think the fix is to add
> > "inet_bhash2_update_saddr(msk);" to the end of the
> > "mptcp_copy_inaddrs" function in net/mptcp/protocol.c.  Would you be
> > able to run an instance on your local syzkaller environment with this
> > line added to see if that fixes the warning?
>
> Hi Joanne -
>
> I also investigated that function when trying to figure out why this
> warning might be happening in MPTCP.
>
> In MPTCP, the userspace-facing MPTCP socket (msk) doesn't directly bind or
> connect. The msk creates and manages TCP subflow sockets (ssk in
> mptcp_copy_inaddrs()), and passes through bind and connect calls to the
> subflows. The msk depends on the subflow to do the hash updates, since
> those subflow sockets are the ones interacting with the inet layer.
>
> mptcp_copy_inaddrs() copies the already-hashed addresses and ports from
> the ssk to the msk, and we only want the ssk in the hash table.
>
I see, thanks for the explanation, Mat! I will keep investigating.
> --
> Mat Martineau
> Intel
