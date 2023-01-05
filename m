Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9BB065ECA3
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 14:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbjAENPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 08:15:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232148AbjAENPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 08:15:50 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CED197
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 05:15:48 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id x22so89921765ejs.11
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 05:15:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=8WGVyRhEAn0+TtSP18cnfFmSDtI8CvwxbXiFAMb3+l8=;
        b=fO+NpLNKOGf6gW+JdDIhspBquPZyqThb+mhLqEmYRP1Mcx5skuDb1IQV9ap8g1UXD6
         vTJJmRIn9JOWxf+mZqGIH1WdstfoBtN5lVc5IrBdfOXLM1gg7UoZen+sIMiL6BMF0BOd
         zc2c3QyjVCEbzv4b9KPPcTyXjNLcf+GIZsmbY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8WGVyRhEAn0+TtSP18cnfFmSDtI8CvwxbXiFAMb3+l8=;
        b=rNQ0BGBfHiMDgvyp/RSA3v5pHwCrZe4PE2rAOV+8aXHnWSoD05xsDV4P+P+/X2btSv
         0Y0l+MwipYx8L87PdomNE1x3CV3RYIp23NsLsmJLMpgSYHBMooP5dq4iV5U7CO8qQLnH
         5eRCOT1OyO1BsI9n0l/5bQKu41tVp0MSCu1cffjb2f1MN1En8dwpZ4Sr349lmxPyK+hj
         iT+wDsQRXPct7lD4lKCr0X++0zaTNkZ6rC02gmUYDjyL4YDqyoYnVgYt+kety+UTpW9R
         ljRaImny5scaNAL7Qeacfkee78AfCuP5j6/kkk93n1wA7fC1dOqLqUTMKxdV9PB88OVl
         8zUw==
X-Gm-Message-State: AFqh2kpIfsrMupM0BgV9XiNHdn/a/O/584onARgD+allIMIh/QIp4F+V
        zdQ+50vJlW9GApMkJoQPltsLHw==
X-Google-Smtp-Source: AMrXdXtLWFktvz+MWgGmdL6vSICIed9bmIC9qpu0tXHodMUI377CG4pn47T771pHKChwTZBEElwCsA==
X-Received: by 2002:a17:907:c242:b0:7c4:fc02:46a3 with SMTP id tj2-20020a170907c24200b007c4fc0246a3mr51359635ejc.30.1672924547140;
        Thu, 05 Jan 2023 05:15:47 -0800 (PST)
Received: from cloudflare.com (79.184.146.66.ipv4.supernova.orange.pl. [79.184.146.66])
        by smtp.gmail.com with ESMTPSA id gf26-20020a170906e21a00b007c0b9500129sm16438182ejb.68.2023.01.05.05.15.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 05:15:45 -0800 (PST)
References: <00000000000073b14905ef2e7401@google.com>
 <639034dda7f92_bb36208f5@john.notmuch>
 <CANn89iK2UN1FmdUcH12fv_xiZkv2G+Nskvmq7fG6aA_6VKRf6g@mail.gmail.com>
 <6391a95864c5e_1ec2b208a@john.notmuch>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     syzbot <syzbot+04c21ed96d861dccc5cd@syzkaller.appspotmail.com>,
        bpf@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] BUG: stack guard page was hit in inet6_release
Date:   Thu, 05 Jan 2023 14:07:11 +0100
In-reply-to: <6391a95864c5e_1ec2b208a@john.notmuch>
Message-ID: <87k021m8an.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 08, 2022 at 01:07 AM -08, John Fastabend wrote:
> Eric Dumazet wrote:
>> On Wed, Dec 7, 2022 at 7:38 AM John Fastabend <john.fastabend@gmail.com> wrote:
>> >
>> > syzbot wrote:
>> > > Hello,
>> > >
>> > > syzbot found the following issue on:
>> > >
>> > > HEAD commit:    6a30d3e3491d selftests: net: Use "grep -E" instead of "egr..
>> > > git tree:       net
>> > > console+strace: https://syzkaller.appspot.com/x/log.txt?x=1576b11d880000
>> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=cc4b2e0a8e8a8366
>> > > dashboard link: https://syzkaller.appspot.com/bug?extid=04c21ed96d861dccc5cd
>> > > compiler: gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for
>> > > Debian) 2.35.2
>> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14e1656b880000
>> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1077da23880000
>> > >
>> > > Downloadable assets:
>> > > disk image:
>> > > https://storage.googleapis.com/syzbot-assets/bbee3d5fc908/disk-6a30d3e3.raw.xz
>> > > vmlinux: https://storage.googleapis.com/syzbot-assets/bf9e258de70e/vmlinux-6a30d3e3.xz
>> > > kernel image:
>> > > https://storage.googleapis.com/syzbot-assets/afaa6696b9e0/bzImage-6a30d3e3.xz
>> > >
>> > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> > > Reported-by: syzbot+04c21ed96d861dccc5cd@syzkaller.appspotmail.com
>> > >
>> > > BUG: TASK stack guard page was hit at ffffc90003cd7fa8 (stack is
>> > > ffffc90003cd8000..ffffc90003ce0000)
>> > > stack guard page: 0000 [#1] PREEMPT SMP KASAN
>> > > CPU: 0 PID: 3636 Comm: syz-executor238 Not tainted
>> > > 6.1.0-rc7-syzkaller-00135-g6a30d3e3491d #0
>> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
>> > > Google 10/26/2022
>> > > RIP: 0010:mark_lock.part.0+0x26/0x1910 kernel/locking/lockdep.c:4593
>> > > Code: 00 00 00 00 41 57 41 56 41 55 41 89 d5 48 ba 00 00 00 00 00 fc ff df
>> > > 41 54 49 89 f4 55 53 48 81 ec 38 01 00 00 48 8d 5c 24 38 <48> 89 3c 24 48
>> > > c7 44 24 38 b3 8a b5 41 48 c1 eb 03 48 c7 44 24 40
>> > > RSP: 0018:ffffc90003cd7fb8 EFLAGS: 00010096
>> > > RAX: 0000000000000004 RBX: ffffc90003cd7ff0 RCX: ffffffff8162a7bf
>> > > RDX: dffffc0000000000 RSI: ffff88801f65e238 RDI: ffff88801f65d7c0
>> > > RBP: ffff88801f65e25a R08: 0000000000000000 R09: ffffffff910f4aff
>> > > R10: fffffbfff221e95f R11: 0000000000000000 R12: ffff88801f65e238
>> > > R13: 0000000000000002 R14: 0000000000000000 R15: 0000000000040000
>> > > FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
>> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> > > CR2: ffffc90003cd7fa8 CR3: 000000000c28e000 CR4: 00000000003506f0
>> > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> > > Call Trace:
>> > >  <TASK>
>> > >  mark_lock kernel/locking/lockdep.c:4598 [inline]
>> > >  mark_usage kernel/locking/lockdep.c:4543 [inline]
>> > >  __lock_acquire+0x847/0x56d0 kernel/locking/lockdep.c:5009
>> > >  lock_acquire kernel/locking/lockdep.c:5668 [inline]
>> > >  lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
>> > >  lock_sock_nested+0x3a/0xf0 net/core/sock.c:3447
>> > >  lock_sock include/net/sock.h:1721 [inline]
>> > >  sock_map_close+0x75/0x7b0 net/core/sock_map.c:1610
>> >
>> > I'll take a look likely something recent.
>> 
>> Fact that sock_map_close  can call itself seems risky.
>> We might issue a one time warning and keep the host alive.
>
> Agree seems better to check the condition than loop on close.
> I still need to figure out the bug that got into this state
> though. Thanks.

I know what is happening. We're not restoring sk_prot in the child
socket on clone.

tcp_bpf_clone() callback currently restores sk_prot only if the
listener->sk_prot is &tcp_bpf_prots[*][TCP_BASE]. It should also check
for TCP_BPF_RX/TXRX.

It's a regression that slipped through with c5d2177a72a1 ("bpf, sockmap:
Fix race in ingress receive verdict with redirect to self"). And we're
clearly missing selftest coverage for this scenario.

I can fix that.
