Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D515A46A58E
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 20:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348397AbhLFTYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 14:24:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347759AbhLFTYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 14:24:36 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 814DCC061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 11:21:07 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id 133so9034813wme.0
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 11:21:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=17dMvWQJWFrU7HYHq+6U8LXq9UKpalF6hcq4itOn2fA=;
        b=kZIGxNQrSY5J5FA9xwYF5Cbuyv2wTtoNxeh5pZlNumanTnXqd7xeePLVfhVjT1kHO/
         ub9AR2hmCmqHRg2oiFAeoRM+TldtNQOkC8CwW8UYBGY+DNg/55/P5E7sJJy+mGi+CSgB
         px5zdDhFcnfLXxhqU7UZYzPq9o5vdLlHpGY3qCym4qx9b7qVOlb3czFhYw89rhEk1gkG
         GPEs/rj5kdGHaTvypI2DIWGeNagESmUGZdcGbfZJHory9lQ0Y8K1pz3GkJ0TjG5aKPKW
         yEO6+qeOHtmooQOiGvb+O5eE9BfsFiLGiBqQkr4VGAmTDzs3tPSbOEqPVxbMAq+nT4Qx
         5+Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=17dMvWQJWFrU7HYHq+6U8LXq9UKpalF6hcq4itOn2fA=;
        b=WGPlK+FNs5DPxlxPFGqDOHc7CCbVsriZGJHvmNWBe66ka3KRS+0/lp/THAI5dkj5Xh
         c6gaXu36jm1Ln3XriIfDtTmNQYTyIPOMKc7ABksywgi5iE/BlVPtD9rs3CpqPED0QRbK
         zDh0ilO9uTtN2ZK3f+qTA7T6253I7ihRxzbbAXb+5LVIpFABGyOwSbzTBaDmghaWftL5
         fYfMMWSaRFgwWViCyPOqMcUoHZaFcoWMbQ7Swgmu1Mt0bWDgKpVuPuRWEhwtNN1JfEin
         vC1pWbbPh+S+oQ9MErVCh+zhijyNs0U23aQapTjwx2U7TJ+sYicxs2trHGCf1ysaaIDL
         c8gA==
X-Gm-Message-State: AOAM531Mc0zJrOM6S/D/dM6SukxVFI/s3RgCj26Kd0zfoIs7tJr3g8RN
        9FJjsrBeO6ZOCfrlkXvXmSxw5g==
X-Google-Smtp-Source: ABdhPJzUqF3sHYHJXA6kO6W6NE7EZuMoA50/Oi+NTHo45Z52I0AKGQT/OjjeCzWHU4THVRVJVo3PqQ==
X-Received: by 2002:a7b:c256:: with SMTP id b22mr634701wmj.176.1638818466059;
        Mon, 06 Dec 2021 11:21:06 -0800 (PST)
Received: from google.com ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id g16sm311850wmq.20.2021.12.06.11.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 11:21:05 -0800 (PST)
Date:   Mon, 6 Dec 2021 19:21:03 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Xin Long <lucien.xin@gmail.com>,
        syzbot+9276d76e83e3bcde6c99@syzkaller.appspotmail.com,
        davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
        linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        syzkaller-bugs@googlegroups.com,
        Vlad Yasevich <vyasevich@gmail.com>
Subject: Re: KASAN: use-after-free Read in __lock_sock
Message-ID: <Ya5in2ZB8T0ZbrEa@google.com>
References: <000000000000b98a67057ad7158a@google.com>
 <CADvbK_f3CpK=qJFngBGmO3VXFLsJm9=qqZVtxYOeBS8rwE=9Ew@mail.gmail.com>
 <20181122131344.GD31918@localhost.localdomain>
 <CADvbK_f0n64K==prdcM0KzU0S3pbo1oMW3HhE8zMngCUZp3-iQ@mail.gmail.com>
 <20181122143743.GE31918@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20181122143743.GE31918@localhost.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Networking Gurus,

On Thu, 22 Nov 2018, Marcelo Ricardo Leitner wrote:
> On Thu, Nov 22, 2018 at 10:44:16PM +0900, Xin Long wrote:
> > On Thu, Nov 22, 2018 at 10:13 PM Marcelo Ricardo Leitner
> > <marcelo.leitner@gmail.com> wrote:
> > >
> > > On Mon, Nov 19, 2018 at 05:57:33PM +0900, Xin Long wrote:
> > > > On Sat, Nov 17, 2018 at 4:18 PM syzbot
> > > > <syzbot+9276d76e83e3bcde6c99@syzkaller.appspotmail.com> wrote:
> > > > >
> > > > > Hello,
> > > > >
> > > > > syzbot found the following crash on:
> > > > >
> > > > > HEAD commit:    ccda4af0f4b9 Linux 4.20-rc2
> > > > > git tree:       upstream
> > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=156cd53=
3400000
> > > > > kernel config:  https://syzkaller.appspot.com/x/.config?xJ0a89f12=
ca9b0f5
> > > > > dashboard link: https://syzkaller.appspot.com/bug?extid=E2=80=997=
6d76e83e3bcde6c99
> > > > > compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> > > > >
> > > > > Unfortunately, I don't have any reproducer for this crash yet.
> > > > >
> > > > > IMPORTANT: if you fix the bug, please add the following tag to th=
e commit:
> > > > > Reported-by: syzbot+9276d76e83e3bcde6c99@syzkaller.appspotmail.com
> > > > >
> > > > > netlink: 5 bytes leftover after parsing attributes in process
> > > > > `syz-executor5'.
> > > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > > BUG: KASAN: use-after-free in __lock_acquire+0x36d9/0x4c20
> > > > > kernel/locking/lockdep.c:3218
> > > > > Read of size 8 at addr ffff8881d26d60e0 by task syz-executor1/137=
25
> > > > >
> > > > > CPU: 0 PID: 13725 Comm: syz-executor1 Not tainted 4.20.0-rc2+ #333
> > > > > Hardware name: Google Google Compute Engine/Google Compute Engine=
, BIOS
> > > > > Google 01/01/2011
> > > > > Call Trace:
> > > > >   __dump_stack lib/dump_stack.c:77 [inline]
> > > > >   dump_stack+0x244/0x39d lib/dump_stack.c:113
> > > > >   print_address_description.cold.7+0x9/0x1ff mm/kasan/report.c:256
> > > > >   kasan_report_error mm/kasan/report.c:354 [inline]
> > > > >   kasan_report.cold.8+0x242/0x309 mm/kasan/report.c:412
> > > > >   __asan_report_load8_noabort+0x14/0x20 mm/kasan/report.c:433
> > > > >   __lock_acquire+0x36d9/0x4c20 kernel/locking/lockdep.c:3218
> > > > >   lock_acquire+0x1ed/0x520 kernel/locking/lockdep.c:3844
> > > > >   __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
> > > > >   _raw_spin_lock_bh+0x31/0x40 kernel/locking/spinlock.c:168
> > > > >   spin_lock_bh include/linux/spinlock.h:334 [inline]
> > > > >   __lock_sock+0x203/0x350 net/core/sock.c:2253
> > > > >   lock_sock_nested+0xfe/0x120 net/core/sock.c:2774
> > > > >   lock_sock include/net/sock.h:1492 [inline]
> > > > >   sctp_sock_dump+0x122/0xb20 net/sctp/diag.c:324
> > > >
> > > > static int sctp_sock_dump(struct sctp_transport *tsp, void *p)
> > > > {
> > > >         struct sctp_endpoint *ep =3D tsp->asoc->ep;
> > > >         struct sctp_comm_param *commp =3D p;
> > > >         struct sock *sk =3D ep->base.sk; <--- [1]
> > > > ...
> > > >         int err =3D 0;
> > > >
> > > >         lock_sock(sk);  <--- [2]
> > > >
> > > > Between [1] and [2], an asoc peeloff may happen, still thinking
> > > > how to avoid this.
> > >
> > > This race cannot happen more than once for an asoc, so something
> > > like this may be doable:
> > >
> > >         struct sctp_comm_param *commp =3D p;
> > >         struct sctp_endpoint *ep;
> > >         struct sock *sk;
> > > ...
> > >         int err =3D 0;
> > >
> > > again:
> > >         ep =3D tsp->asoc->ep;
> > >         sk =3D ep->base.sk; <---[3]
> > >         lock_sock(sk);  <--- [2]
> > if peel-off happens between [3] and [2], and sk is freed
> > somewhere, it will panic on [2] when trying to get the
> > sk->lock, no?
>=20
> Not sure what protects it, but this construct is also used in BH processi=
ng at
> sctp_rcv():
> ...
>         bh_lock_sock(sk); [4]
>=20
>         if (sk !=3D rcvr->sk) {
>                 /* Our cached sk is different from the rcvr->sk.  This is
>                  * because migrate()/accept() may have moved the associat=
ion
>                  * to a new socket and released all the sockets.  So now =
we
>                  * are holding a lock on the old socket while the user may
>                  * be doing something with the new socket.  Switch our ve=
iw
>                  * of the current sk.
>                  */
>                 bh_unlock_sock(sk);
>                 sk =3D rcvr->sk;
>                 bh_lock_sock(sk);
>         }
> ...
>=20
> If it is not safe, then we have an issue there too.
> And by [4] that copy on sk is pretty old already.
>=20
> >=20
> > >         if (sk !=3D tsp->asoc->ep->base.sk) {
> > >                 /* Asoc was peeloff'd */
> > >                 unlock_sock(sk);
> > >                 goto again;
> > >         }
> > >
> > > Similarly to what we did on cea0cc80a677 ("sctp: use the right sk
> > > after waking up from wait_buf sleep").

I'm currently debugging something similar (the same perhaps) on an
older Stable kernel.  However the same Repro which was found and
authored for a production level mobile phone, doesn't seem to trigger
on an x86_64 qemu instance running Mainline.

That's not to say that Mainline isn't still suffering with this issue
though.  It probably has more to do with the specificity of the Repro
which was designed specifically to trigger on the target device.

Does anyone know if this particular issue was ever patched?

--=20
Lee Jones [=E6=9D=8E=E7=90=BC=E6=96=AF]
Senior Technical Lead - Developer Services
Linaro.org =E2=94=82 Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
