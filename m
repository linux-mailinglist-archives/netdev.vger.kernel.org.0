Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF9AFC8FE3
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 19:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbfJBR1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 13:27:34 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37604 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727268AbfJBR1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 13:27:34 -0400
Received: by mail-wr1-f68.google.com with SMTP id i1so20620581wro.4;
        Wed, 02 Oct 2019 10:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ijv1l2lWYsX93Qf6S4JSrh2tUZ46b8gVqurCab6GC/8=;
        b=hQr22FqLR+ObH82XqH4tvqqDC0SyxO64gV5SB0Y0vQdOcU7YFkd7JNK4fO+9A9uR0a
         heyG2/rT1WE69D7mSJAm/y9+Uxqsk4LrNipbfemfGymmH3jKwz4+cYLko7C9yInQqFY0
         cq6qi+JKewd2+lFfupOhHovAX8p1RS++/x+YlWQrCFa/xlPj+36WJ0MdTrLDt0HjM4oP
         Fwp4ZtUvbYMelOfJoi7kSft0s6upM49RCCAMPT7QvgEbY4qaVd8C0wCorfjSPBWOt9pG
         s/6IOF0O0q/CHoZnTD4MG1gHah3idgov47JBWshLO6MArsczyvR9jMwe5V8LybT24Hpj
         obFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ijv1l2lWYsX93Qf6S4JSrh2tUZ46b8gVqurCab6GC/8=;
        b=J7lCaNPtajhVYR9LcupcEtQXEFxCB3mbMu24CwQZf0UyScu8n/Agz+UNC2/H0WQOCF
         DmUokn+Au1gOas9dajpciXzGNFU5doodbbuZwy1p450D6GTnYvgaQAcRXd1EXZqMme0J
         m5xjrMHG0MFv1hZTEUkGN92iB3KlIbTWx7e+R0CMt3KB+eGImLwGKmfUU577Arjtzdrx
         qCnjBjraWGYunV6ucFzwUcTUt2tgtlPxUU/EjTC5guazJ092Qv9vmH1AuhagiH3TB0aP
         SwQjB52UZyR01dSuM6KZzdi8s/Daf6jo4zjaFABgl6koAMI1VWBU2VeOTscZTnD7I3v/
         vVGA==
X-Gm-Message-State: APjAAAWZDdVfKxDYzIs52+nXf87QOLLxlDXDYp2WKoN93DyT+xOkR4EI
        M5VKgKy0E153C50h5KiAxj3jIGuua2nwC/DDF/GhmESU
X-Google-Smtp-Source: APXvYqwLixQUh5PVWuQ9URw3i/PDcx0Ez/LDXSEMMY4YmGUo+/UAY2HNO+kKhZuBj2OAixVi4Y2xdJEoAGL+8iUvOyo=
X-Received: by 2002:a05:6000:14c:: with SMTP id r12mr3611383wrx.303.1570037251164;
 Wed, 02 Oct 2019 10:27:31 -0700 (PDT)
MIME-Version: 1.0
References: <acd60f4797143dc6e9817b3dce38e1408caf65e5.1569849018.git.lucien.xin@gmail.com>
 <20191002010356.GG3499@localhost.localdomain> <CADvbK_ctLG+vnhmWwN=cWmZV7FgZreVRmoU+23PExdk=goF8cQ@mail.gmail.com>
 <20191002125511.GH3499@localhost.localdomain> <CADvbK_fD+yuCCUTf41n+3oVwVjLUdT8+-wfwppVL8ZmbJegTWA@mail.gmail.com>
In-Reply-To: <CADvbK_fD+yuCCUTf41n+3oVwVjLUdT8+-wfwppVL8ZmbJegTWA@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 3 Oct 2019 01:28:02 +0800
Message-ID: <CADvbK_ekmHzvyakk-kXA_5thdjS1MVUtAhDKMN6QdeZsysDF-Q@mail.gmail.com>
Subject: Re: [PATCH net] sctp: set newsk sk_socket before processing listening
 sk backlog
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 3, 2019 at 1:26 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Wed, Oct 2, 2019 at 8:55 PM Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> >
> > On Wed, Oct 02, 2019 at 04:23:52PM +0800, Xin Long wrote:
> > > On Wed, Oct 2, 2019 at 9:04 AM Marcelo Ricardo Leitner
> > > <marcelo.leitner@gmail.com> wrote:
> > > >
> > > > On Mon, Sep 30, 2019 at 09:10:18PM +0800, Xin Long wrote:
> > > > > This patch is to fix a NULL-ptr deref crash in selinux_sctp_bind_connect:
> > > > >
> > > > >   [...] kasan: GPF could be caused by NULL-ptr deref or user memory access
> > > > >   [...] RIP: 0010:selinux_sctp_bind_connect+0x16a/0x230
> > > > >   [...] Call Trace:
> > > > >   [...]  security_sctp_bind_connect+0x58/0x90
> > > > >   [...]  sctp_process_asconf+0xa52/0xfd0 [sctp]
> > > > >   [...]  sctp_sf_do_asconf+0x782/0x980 [sctp]
> > > > >   [...]  sctp_do_sm+0x139/0x520 [sctp]
> > > > >   [...]  sctp_assoc_bh_rcv+0x284/0x5c0 [sctp]
> > > > >   [...]  sctp_backlog_rcv+0x45f/0x880 [sctp]
> > > > >   [...]  __release_sock+0x120/0x370
> > > > >   [...]  release_sock+0x4f/0x180
> > > > >   [...]  sctp_accept+0x3f9/0x5a0 [sctp]
> > > > >   [...]  inet_accept+0xe7/0x6f0
> > > > >
> > > > > It was caused by that the 'newsk' sk_socket was not set before going to
> > > > > security sctp hook when doing accept() on a tcp-type socket:
> > > > >
> > > > >   inet_accept()->
> > > > >     sctp_accept():
> > > > >       lock_sock():
> > > > >           lock listening 'sk'
> > > > >                                           do_softirq():
> > > > >                                             sctp_rcv():  <-- [1]
> > > > >                                                 asconf chunk arrived and
> > > > >                                                 enqueued in 'sk' backlog
> > > > >       sctp_sock_migrate():
> > > > >           set asoc's sk to 'newsk'
> > > > >       release_sock():
> > > > >           sctp_backlog_rcv():
> > > > >             lock 'newsk'
> > > > >             sctp_process_asconf()  <-- [2]
> > > > >             unlock 'newsk'
> > > > >     sock_graft():
> > > > >         set sk_socket  <-- [3]
> > > > >
> > > > > As it shows, at [1] the asconf chunk would be put into the listening 'sk'
> > > > > backlog, as accept() was holding its sock lock. Then at [2] asconf would
> > > > > get processed with 'newsk' as asoc's sk had been set to 'newsk'. However,
> > > > > 'newsk' sk_socket is not set until [3], while selinux_sctp_bind_connect()
> > > > > would deref it, then kernel crashed.
> > > >
> > > > Note that sctp will migrate such incoming chunks from sk to newsk in
> > > > sctp_rcv() if they arrived after the mass-migration performed at
> > > > sctp_sock_migrate().
> > > >
> > > > That said, did you explore changing inet_accept() so that
> > > > sk1->sk_prot->accept() would return sk2 still/already locked?
> > > > That would be enough to block [2] from happening as then it would be
> > > > queued on newsk backlog this time and avoid nearly duplicating
> > > > inet_accept(). (too bad for this chunk, hit 2 backlogs..)
> > > We don't have to bother inet_accept() for it. I had this one below,
> > > and I was just thinking the locks order doesn't look nice. Do you
> > > think this is more acceptable?
> > >
> > > @@ -4963,15 +4963,19 @@ static struct sock *sctp_accept(struct sock
> > > *sk, int flags, int *err, bool kern)
> > >          * asoc to the newsk.
> > >          */
> > >         error = sctp_sock_migrate(sk, newsk, asoc, SCTP_SOCKET_TCP);
> > > -       if (error) {
> > > -               sk_common_release(newsk);
> > > -               newsk = NULL;
> > > +       if (!error) {
> > > +               lock_sock_nested(newsk, SINGLE_DEPTH_NESTING);
> > > +               release_sock(sk);
> >
> > Interesting. It fixes the backlog processing, ok. Question:
> >
> > > +               release_sock(newsk);
> >
> > As newsk is hashed already and unlocked here to be locked again later
> > on inet_accept(), it could receive a packet in between (thus before
> > sock_graft() could have a chance to run), no?
>
> You're right, it explains another call trace happened once in our testing.
>
> The way to changing inet_accept() will also have to change all protocols'
> .accept(). Given that this issue is only triggered in a very small moment,
> can we just silently discard this asconf chunk if sk->sk_socket is NULL?
> and let peer's T4-timer retransmit it.
>
> @@ -3709,6 +3709,9 @@ enum sctp_disposition sctp_sf_do_asconf(struct net *net,
>         struct sctp_addiphdr *hdr;
>         __u32 serial;
>
> +       if (asoc->base.sk->sk_socket)
sorry, if (!asoc->base.sk->sk_socket) ^
> +               return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
> +
>
> Note we can't do this in sctp_process_asconf_param(), as an asconf_ack
> will be sent back.
>
> >
> > > +               *err = error;
> > > +
> > > +               return newsk;
> > >         }
> > >
> > >  out:
> > >         release_sock(sk);
> > >         *err = error;
> > > -       return newsk;
> > > +       return NULL;
> > >  }
> > >
> > > >
> > > > AFAICT TCP code would be fine with such change. Didn't check other
> > > > protocols.
> > > >
> > >
