Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6D67168929
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 22:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728423AbgBUVV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 16:21:56 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50270 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726707AbgBUVVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 16:21:55 -0500
Received: by mail-wm1-f68.google.com with SMTP id a5so3204914wmb.0
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 13:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kCojeGCbYv0/Jqi1Rd5ewidQhYyqj8mEtyF/C7SM9lk=;
        b=NL6MH+w3h66AF/fbLXBfLwROsxIucUAMI15KKfXzR/bjcLk7MjH1WsJyyFwj9hfSWz
         8/pSnkfVszwgvNdnucLGdGEDJLnEn5UdkBURH4nmqLbce/DZXXTgbKe8dm5aNnhJop+O
         ZKOtZCN2M97yV42SA365i5rERAKLHaQmOwtziZa3kPbZ4fdMINpcuRt3hZ6gYR0V6uOd
         032oVnIO6dQAabLiFwxYRWxbsWU5NCwy/QDSXOAh1s6hlqcVu4uyWtJFSxbDL1ZTEt4x
         1ftLdmMPBJecGa9ShdGOa/MzIeW76Mbyq4lywFEjIcZW0Zt+cvm3OIQBwSARJSKZcn9n
         Rbtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kCojeGCbYv0/Jqi1Rd5ewidQhYyqj8mEtyF/C7SM9lk=;
        b=Bsh2nYhfwGFVrfRvpcs6aO7g+2btC302s0s4oPNG1n/fqvMZsqlaJZfeEn2RJLTQnm
         IjHpa1ERxAew8jr4KuFl98oUNWQdNq/c6LYvKqC9TO3HpoOIAWc2ZAfWFcxF+5FoVxzj
         WnY72dp3Ami+OB0CJ2JFBpDMXJxkDjk4PiWO+hy3F+MjMbxHhwAKQzjuqPARF0rUhRBL
         1TUBjUgWbeQVFenkvYzut6MsGcPnm3ypwqKN7IybqDw628dgXcbKeI0DirVF2Rxjfm/a
         llEvWM2j2/hABG2nC63CwaJn4fx0yf2axyihLPCEkE9qAe/kuum4ynDgTvuuBWRpYQgm
         Z5Uw==
X-Gm-Message-State: APjAAAWYJ/JPw9cys3m/DpGD/1iU0lcPQjOEWRK2l5xvqFFjJbPBCX96
        +pUtWBvEc6kDGslY3cbXIbOjj+tW33/ybkJa10MNAwTjSDE=
X-Google-Smtp-Source: APXvYqxE/EEAuIfMxsuKqyKNpPlbuOrTCH3lN/BG7Y9t6z5GtbVJvPvIoOpIDYg1Q+XjoPAigvlw+UbYmrxJh1kctJQ=
X-Received: by 2002:a1c:541b:: with SMTP id i27mr6113814wmb.137.1582320113195;
 Fri, 21 Feb 2020 13:21:53 -0800 (PST)
MIME-Version: 1.0
References: <20200128025958.43490-1-arjunroy.kdev@gmail.com>
 <20200128025958.43490-3-arjunroy.kdev@gmail.com> <20200212185605.d89c820903b7aa9fbbc060b2@linux-foundation.org>
 <CAOFY-A1o0L_D7Oyi1S=+Ng+2dK35-QHSSUQ9Ct3EA5y-DfWaXA@mail.gmail.com>
In-Reply-To: <CAOFY-A1o0L_D7Oyi1S=+Ng+2dK35-QHSSUQ9Ct3EA5y-DfWaXA@mail.gmail.com>
From:   Arjun Roy <arjunroy@google.com>
Date:   Fri, 21 Feb 2020 13:21:41 -0800
Message-ID: <CAOFY-A0G+NOpi7r=gnrLNsJ-OHYnGKCJ0mJ5PWwH5m7_99bD5w@mail.gmail.com>
Subject: Re: [PATCH resend mm,net-next 3/3] net-zerocopy: Use
 vm_insert_pages() for tcp rcv zerocopy.
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Arjun Roy <arjunroy.kdev@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew, David -

I remain a bit concerned regarding the merge process for this specific
patch (0003, the net/ipv4/tcp.c change) since I have other in-flight
changes for TCP receive zerocopy that I'd like to upstream for
net-next - and would like to avoid weird merge issues.

So perhaps the following could work:

1. Andrew, perhaps we could remove this particular patch (0003, the
net/ipv4/tcp.c change) from mm-next; that way we merge
vm_insert_pages() but not the call-site within TCP, for now.
2. net-next will eventually pick vm_insert_pages() up.
3. I can modify the zerocopy code to use it at that point?

Else I'm concerned a complicated merge situation may result.

What do you all think?

Thanks,
-Arjun

On Sun, Feb 16, 2020 at 6:49 PM Arjun Roy <arjunroy@google.com> wrote:
>
> On Wed, Feb 12, 2020 at 6:56 PM Andrew Morton <akpm@linux-foundation.org>=
 wrote:
> >
> > On Mon, 27 Jan 2020 18:59:58 -0800 Arjun Roy <arjunroy.kdev@gmail.com> =
wrote:
> >
> > > Use vm_insert_pages() for tcp receive zerocopy. Spin lock cycles
> > > (as reported by perf) drop from a couple of percentage points
> > > to a fraction of a percent. This results in a roughly 6% increase in
> > > efficiency, measured roughly as zerocopy receive count divided by CPU
> > > utilization.
> > >
> > > The intention of this patch-set is to reduce atomic ops for
> > > tcp zerocopy receives, which normally hits the same spinlock multiple
> > > times consecutively.
> >
> > For some reason the patch causes this:
> >
> > In file included from ./arch/x86/include/asm/atomic.h:5:0,
> >                  from ./include/linux/atomic.h:7,
> >                  from ./include/linux/crypto.h:15,
> >                  from ./include/crypto/hash.h:11,
> >                  from net/ipv4/tcp.c:246:
> > net/ipv4/tcp.c: In function =E2=80=98do_tcp_getsockopt.isra.29=E2=80=99=
:
> > ./include/linux/compiler.h:225:31: warning: =E2=80=98tp=E2=80=99 may be=
 used uninitialized in this function [-Wmaybe-uninitialized]
> >   case 4: *(volatile __u32 *)p =3D *(__u32 *)res; break;
> >           ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~
> > net/ipv4/tcp.c:1779:19: note: =E2=80=98tp=E2=80=99 was declared here
> >   struct tcp_sock *tp;
> >                    ^~
> >
> > It's a false positive.  gcc-7.2.0
> >
> > : out:
> > :        up_read(&current->mm->mmap_sem);
> > :        if (length) {
> > :                WRITE_ONCE(tp->copied_seq, seq);
> >
> > but `length' is zero here.
> >
> > This suppresses it:
> >
> > --- a/net/ipv4/tcp.c~net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zeroc=
opy-fix
> > +++ a/net/ipv4/tcp.c
> > @@ -1788,6 +1788,8 @@ static int tcp_zerocopy_receive(struct s
> >
> >         sock_rps_record_flow(sk);
> >
> > +       tp =3D tcp_sk(sk);
> > +
> >         down_read(&current->mm->mmap_sem);
> >
> >         ret =3D -EINVAL;
> > @@ -1796,7 +1798,6 @@ static int tcp_zerocopy_receive(struct s
> >                 goto out;
> >         zc->length =3D min_t(unsigned long, zc->length, vma->vm_end - a=
ddress);
> >
> > -       tp =3D tcp_sk(sk);
> >         seq =3D tp->copied_seq;
> >         inq =3D tcp_inq(sk);
> >         zc->length =3D min_t(u32, zc->length, inq);
> >
> > and I guess it's zero-cost.
> >
> >
> > Anyway, I'll sit on this lot for a while, hoping for a davem ack?
>
> Actually, speaking of the ack on the networking side:
>
> I guess this patch set is a bit weird since it requires some
> non-trivial coordination between mm and net-next? Not sure what the
> normal approach is in this case.
>
> -Arjun
