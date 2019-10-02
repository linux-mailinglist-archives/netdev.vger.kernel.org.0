Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40248C9014
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 19:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbfJBRlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 13:41:32 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:38758 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727721AbfJBRlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 13:41:32 -0400
Received: by mail-qk1-f196.google.com with SMTP id u186so15886653qkc.5;
        Wed, 02 Oct 2019 10:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ysmix4wKj1MqsCf9WGSvJMtRxTF2C8zZ7MRUttE+wwM=;
        b=n+zQ8q1I4NVcilXdjFHxdaSUN1bCKJp7eBTnMHw8eQrKle0d0Js0RjUwR9eRFNKdZl
         Rc40S2TMhJD7u99vsD8akByu4rIoK8MeysBNf1V10kNouTPTzVibQekL0grRUOKcRR4q
         Lcz72UUlS708XZuZFkLBJOJ38a/KfbLEboiqlaw0L29GviR2jbnWghFjdV/IFwO3LTX4
         shjX2CHgqcNVnm1IhcjILUHL1OX/xJD1pe9lB3Cjl6wcqJshBAfoQ2tX5hlDk6zJ1IIN
         h6fEIksyANAV1r80HYuhgNZueTFA08wr+zNaKnHAMcCZj3gxpyU7VcI4FwRTp9MqxeDY
         ABvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ysmix4wKj1MqsCf9WGSvJMtRxTF2C8zZ7MRUttE+wwM=;
        b=HseDyYAWCEzGNfr7ktdos2+3V+0w6ka+kfbfHuGmNkvHBMxlJNx6PIfZQeRZBeTNrM
         fLSR7laGKoC6vEaAtsHHSPvAkGz8dEWzTb+ALvmyA4Vh4/DImBUCCJaE18B/TibsZAIj
         +/O8NU6q8BKjCL/ZPdd9J+fZF7RWLqPB+mtguFPCYW5qTVSlklVWDfeevq/Ka4j1O1UD
         BHjL0z5g8VYKmcAAUKpD4hw45xOOcNuWBfnohIj1WfhlpfcxXtusOJ9yCzaWxB+G7x31
         G+JDsSLwvgmklQdM50E1UP4FyYSfgaNISK2UwVLPqhEjFN0k7yEHok3t27eH1iKVwuQU
         4mJg==
X-Gm-Message-State: APjAAAWeby8pe1RLGnXc7U1UUzXnCWaQ9JCMcSSQt2m4q0VKQq+jk2hg
        5HpNlgl+Lu168KMK7FTeLdE=
X-Google-Smtp-Source: APXvYqxehrUP/6GIGW+JLRA46b+p7CRzQkHLNRMBQAAC6R+EhU5TCm5wMBZyuiuiiVcoWp2m6vnztg==
X-Received: by 2002:ae9:e902:: with SMTP id x2mr5054860qkf.293.1570038090592;
        Wed, 02 Oct 2019 10:41:30 -0700 (PDT)
Received: from localhost.localdomain ([177.220.172.85])
        by smtp.gmail.com with ESMTPSA id d16sm9381640qkl.7.2019.10.02.10.41.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 10:41:29 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 45B5DC07B9; Wed,  2 Oct 2019 14:41:27 -0300 (-03)
Date:   Wed, 2 Oct 2019 14:41:27 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH net] sctp: set newsk sk_socket before processing
 listening sk backlog
Message-ID: <20191002174127.GL3431@localhost.localdomain>
References: <acd60f4797143dc6e9817b3dce38e1408caf65e5.1569849018.git.lucien.xin@gmail.com>
 <20191002010356.GG3499@localhost.localdomain>
 <CADvbK_ctLG+vnhmWwN=cWmZV7FgZreVRmoU+23PExdk=goF8cQ@mail.gmail.com>
 <20191002125511.GH3499@localhost.localdomain>
 <CADvbK_fD+yuCCUTf41n+3oVwVjLUdT8+-wfwppVL8ZmbJegTWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_fD+yuCCUTf41n+3oVwVjLUdT8+-wfwppVL8ZmbJegTWA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 03, 2019 at 01:26:46AM +0800, Xin Long wrote:
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

No no. If the change doesn't hurt other protocols, we should try that
first.  Otherwise this adds overhead to the network and we could get a
bug report soon on "valid asconf being ignored".

If that doesn't pan out, maybe your initial suggestion is the way out.
More custom code but keeps the expected behavior.

> 
> @@ -3709,6 +3709,9 @@ enum sctp_disposition sctp_sf_do_asconf(struct net *net,
>         struct sctp_addiphdr *hdr;
>         __u32 serial;
> 
> +       if (asoc->base.sk->sk_socket)
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
