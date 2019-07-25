Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6A174330
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 04:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728168AbfGYCTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 22:19:31 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:41448 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbfGYCTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 22:19:30 -0400
Received: by mail-qk1-f193.google.com with SMTP id v22so35324409qkj.8;
        Wed, 24 Jul 2019 19:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9G4+pN2cxWowXbZZyCIC7KTWC6wMDbOZ0AlFZhGnUI8=;
        b=fWVsY04dwPKolHRiQDFH3qM6nyxzQm1Uu1thVE8OmyVh3qcrhyXGCxfJvuuHvpJ7+i
         n3wXIPBdBn+zA/RZht+CGigyJLoLFS1ARPeBpgk5j+Y0WncXQMMDKYfKmzAz8balnoxC
         rR+1ykTPoI8r5N2AZ3bW18e4P6qHvGPVcaoVLxwC01XDX2HV5fFOx5YekJGmE4LWYK7j
         RfiKQs3w2PQ+1z+ZvwCxLlPqgFteTwi9WmLIZUZ55Iqd1nVmyxxteSp6pK5dq2N6r8aj
         jfNBXNjCbgkIKR+0RLQyKxbZUKm/47KWDwaamODB4/E/G+Ga1FY1sd3hDDe2ji7XJgT6
         Phsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9G4+pN2cxWowXbZZyCIC7KTWC6wMDbOZ0AlFZhGnUI8=;
        b=muX+iYwH8suTfqCcZPzfh6eyWm2mLPSsojqtUrNDS7ho0y6s95/Hl7kKo8dd+Niy14
         DgknbEu7bklwMdZ9CEmLmG171FlJ4kPIjAOw0+da3KoUfmMbSlvCQQd3DjqSe8JAFSjL
         8POw9tgfwdKqVqvxyrZUs37jcfpWXamtI0xORonO8yLBj9yiGZc0WQePa1lU+M8x2cgV
         oUDWKU47kihT6emOVg7iIhNtOxU+wPz23YFaNZ5X44LIvwEtfjZQGi4vzBDCW34p25Gv
         E84gM1EqXIvAczPTK1pB+f9hQHc75LQ7Rs7lkdCrWk4ZiEcyrLV5BEkGE0xTMIAO5V7z
         K3KQ==
X-Gm-Message-State: APjAAAUvyga7R1MTivxO5quNV920zWQFqpf31QckBW2fvlv8zH6tOaVB
        RIXiQuts2TJoRBSYCeO6DEc=
X-Google-Smtp-Source: APXvYqwL6wLU8rld29cLRXAxZ3QTezr3U/j6A7GSc8wLZl/k5wE+5nLp+KnUGqQlKiObUg+x+MJmUA==
X-Received: by 2002:a37:48d0:: with SMTP id v199mr55559570qka.318.1564021169541;
        Wed, 24 Jul 2019 19:19:29 -0700 (PDT)
Received: from localhost.localdomain ([168.181.49.45])
        by smtp.gmail.com with ESMTPSA id h1sm23916466qkh.101.2019.07.24.19.19.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 19:19:28 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id C3555C0AAD; Wed, 24 Jul 2019 23:19:25 -0300 (-03)
Date:   Wed, 24 Jul 2019 23:19:25 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     Neil Horman <nhorman@tuxdriver.com>,
        Hillf Danton <hdanton@sina.com>, linux-sctp@vger.kernel.org,
        network dev <netdev@vger.kernel.org>,
        syzkaller <syzkaller@googlegroups.com>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzbot <syzbot+6ad9c3bd0a218a2ab41d@syzkaller.appspotmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH] net: sctp: fix memory leak in sctp_send_reset_streams
Message-ID: <20190725021925.GI6204@localhost.localdomain>
References: <20190602034429.6888-1-hdanton@sina.com>
 <20190602105133.GA16948@hmswarspite.think-freely.org>
 <CADvbK_dUDjK3UAF49uo+DZv+QiuEsaMmZeqDwBJ0suRwu4yXJw@mail.gmail.com>
 <CADvbK_ddFyO2iz-QS3bHevHN7Q29VUS4joK3Kxam3Y4tEqHFKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_ddFyO2iz-QS3bHevHN7Q29VUS4joK3Kxam3Y4tEqHFKA@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 03:56:40PM +0800, Xin Long wrote:
> On Sun, Jun 2, 2019 at 9:36 PM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > On Sun, Jun 2, 2019 at 6:52 PM Neil Horman <nhorman@tuxdriver.com> wrote:
> > >
> > > On Sun, Jun 02, 2019 at 11:44:29AM +0800, Hillf Danton wrote:
> > > >
> > > > syzbot found the following crash on:
> > > >
> > > > HEAD commit:    036e3431 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
> > > > git tree:       upstream
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=153cff12a00000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=8f0f63a62bb5b13c
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=6ad9c3bd0a218a2ab41d
> > > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12561c86a00000
> > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15b76fd8a00000
> > > >
> > > > executing program
> > > > executing program
> > > > executing program
> > > > executing program
> > > > executing program
> > > > BUG: memory leak
> > > > unreferenced object 0xffff888123894820 (size 32):
> > > >   comm "syz-executor045", pid 7267, jiffies 4294943559 (age 13.660s)
> > > >   hex dump (first 32 bytes):
> > > >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > > >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > > >   backtrace:
> > > >     [<00000000c7e71c69>] kmemleak_alloc_recursive
> > > > include/linux/kmemleak.h:55 [inline]
> > > >     [<00000000c7e71c69>] slab_post_alloc_hook mm/slab.h:439 [inline]
> > > >     [<00000000c7e71c69>] slab_alloc mm/slab.c:3326 [inline]
> > > >     [<00000000c7e71c69>] __do_kmalloc mm/slab.c:3658 [inline]
> > > >     [<00000000c7e71c69>] __kmalloc+0x161/0x2c0 mm/slab.c:3669
> > > >     [<000000003250ed8e>] kmalloc_array include/linux/slab.h:670 [inline]
> > > >     [<000000003250ed8e>] kcalloc include/linux/slab.h:681 [inline]
> > > >     [<000000003250ed8e>] sctp_send_reset_streams+0x1ab/0x5a0 net/sctp/stream.c:302
> > > >     [<00000000cd899c6e>] sctp_setsockopt_reset_streams net/sctp/socket.c:4314 [inline]
> > > >     [<00000000cd899c6e>] sctp_setsockopt net/sctp/socket.c:4765 [inline]
> > > >     [<00000000cd899c6e>] sctp_setsockopt+0xc23/0x2bf0 net/sctp/socket.c:4608
> > > >     [<00000000ff3a21a2>] sock_common_setsockopt+0x38/0x50 net/core/sock.c:3130
> > > >     [<000000009eb87ae7>] __sys_setsockopt+0x98/0x120 net/socket.c:2078
> > > >     [<00000000e0ede6ca>] __do_sys_setsockopt net/socket.c:2089 [inline]
> > > >     [<00000000e0ede6ca>] __se_sys_setsockopt net/socket.c:2086 [inline]
> > > >     [<00000000e0ede6ca>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2086
> > > >     [<00000000c61155f5>] do_syscall_64+0x76/0x1a0 arch/x86/entry/common.c:301
> > > >     [<00000000e540958c>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > >
> > > >
> > > > It was introduced in commit d570a59c5b5f ("sctp: only allow the out stream
> > > > reset when the stream outq is empty"), in orde to check stream outqs before
> > > > sending SCTP_STRRESET_IN_PROGRESS back to the peer of the stream. EAGAIN is
> > > > returned, however, without the nstr_list slab released, if any outq is found
> > > > to be non empty.
> > > >
> > > > Freeing the slab in question before bailing out fixes it.
> > > >
> > > > Fixes: d570a59c5b5f ("sctp: only allow the out stream reset when the stream outq is empty")
> > > > Reported-by: syzbot <syzbot+6ad9c3bd0a218a2ab41d@syzkaller.appspotmail.com>
> > > > Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > > > Tested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > > > Cc: Xin Long <lucien.xin@gmail.com>
> > > > Cc: Neil Horman <nhorman@tuxdriver.com>
> > > > Cc: Vlad Yasevich <vyasevich@gmail.com>
> > > > Cc: Eric Dumazet <edumazet@google.com>
> > > > Signed-off-by: Hillf Danton <hdanton@sina.com>
> > > > ---
> > > > net/sctp/stream.c | 1 +
> > > > 1 file changed, 1 insertion(+)
> > > >
> > > > diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> > > > index 93ed078..d3e2f03 100644
> > > > --- a/net/sctp/stream.c
> > > > +++ b/net/sctp/stream.c
> > > > @@ -310,6 +310,7 @@ int sctp_send_reset_streams(struct sctp_association *asoc,
> > > >
> > > >       if (out && !sctp_stream_outq_is_empty(stream, str_nums, nstr_list)) {
> > > >               retval = -EAGAIN;
> > > > +             kfree(nstr_list);
> > > >               goto out;
> > > >       }
> > > >
> > > > --
> > > >
> > > >
> > > Acked-by: Neil Horman <nhorman@tuxdriver.com>
> > Reviewed-by: Xin Long <lucien.xin@gmail.com>
> This fix is not applied, pls resend it with:
> to = network dev <netdev@vger.kernel.org>
> cc = davem@davemloft.net
> to = linux-sctp@vger.kernel.org
> cc = Neil Horman <nhorman@tuxdriver.com>
> cc = Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Good catch, thanks Xin. I don't know what happened but I never got
this patch via netdev@, just the direct delivery. If it didn't reach
netdev@, that explains it.

  Marcelo
