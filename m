Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14333C9031
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 19:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbfJBRs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 13:48:59 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38005 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727737AbfJBRs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 13:48:59 -0400
Received: by mail-qt1-f193.google.com with SMTP id j31so27496840qta.5;
        Wed, 02 Oct 2019 10:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cp3R+VTBVIz7B9NMAOiPgfLAmBefCSqpuqm+aCntVPU=;
        b=WVeg8SYnaQdTxBTq3riXf56J9QpB4UrWJhM83u2mkul44qnwO1fIbYbUlEWV19bjwS
         G/R6qqnfiGbgzkGOTN0q83irjs9CXThavEzqMv/OcxLsdsd/Z4dV8D8+yBEBdZBmJyh3
         fkairqlLvUEYuhu5W9QXQmu90a16n5heTw6kUbViXg/PbZWSRRRbVW8at3OUrl6t0Ki2
         6HacsRXSWmIYJodfKxCiAkge+STgzcMVK0CRSWqc0tfvgJZ/lOyNg0GRh7TUv6nxFHbg
         iLmzmxGLu1Zc5RgYnPOlKqj2Sl4V27knZ4AtDucXfqqTWcoruMMEaUP0VPnK5GYT5cby
         MKvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cp3R+VTBVIz7B9NMAOiPgfLAmBefCSqpuqm+aCntVPU=;
        b=cCb0PnFUI3djcmD3RSITZoioHsrQrnP9ppRPhwV/lSFOC/xeqY3Swhb5CYM3tbk306
         17vSW9eO84UF+Sg0LC3h3H/B3FJ576fjzcvARfKL75wEmr7M3AxOVHVlhw7hnIyEvznV
         BiZsdUZYZDDaNvKFehzNiX0wgkm7GeTAX+VUv8rARUh2IU7kNabtpreWjb22eZbO6NvO
         swgXVd/2/BAWE7/aGN6nrUMoIV0vIyt0yT1xF/6m2mGPZyzH0sC8BR3rXhEP43YTj3dE
         7A1Wx0RtsUCHWBFa3WbsRjFXyljcj+iALCj78DW41XAwW/dVui28XAGUfN/f4HTeTT/e
         v3jQ==
X-Gm-Message-State: APjAAAUaMGysEEvMp6S7ABHxBn4XakPL2fvPAqiFJ+7w38/F4ZbkdzeG
        59sqwGp4SZYnX1SrU7PFTj0=
X-Google-Smtp-Source: APXvYqz+jus6+wBvN46TETy/JSgARs+Tea+f2Hv6wxejgdrtf8gTvD+1h65Kblu3xlfWZcXyBlDChQ==
X-Received: by 2002:a0c:aadb:: with SMTP id g27mr4192739qvb.149.1570038537587;
        Wed, 02 Oct 2019 10:48:57 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:43d:1f86:9ada:9b75:29f5])
        by smtp.gmail.com with ESMTPSA id 62sm10568468qki.130.2019.10.02.10.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 10:48:56 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 6F3EFC07B9; Wed,  2 Oct 2019 14:48:54 -0300 (-03)
Date:   Wed, 2 Oct 2019 14:48:54 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH net] sctp: set newsk sk_socket before processing
 listening sk backlog
Message-ID: <20191002174854.GI3499@localhost.localdomain>
References: <acd60f4797143dc6e9817b3dce38e1408caf65e5.1569849018.git.lucien.xin@gmail.com>
 <20191002010356.GG3499@localhost.localdomain>
 <CADvbK_ctLG+vnhmWwN=cWmZV7FgZreVRmoU+23PExdk=goF8cQ@mail.gmail.com>
 <20191002125511.GH3499@localhost.localdomain>
 <CADvbK_fD+yuCCUTf41n+3oVwVjLUdT8+-wfwppVL8ZmbJegTWA@mail.gmail.com>
 <20191002174127.GL3431@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002174127.GL3431@localhost.localdomain>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 02, 2019 at 02:41:27PM -0300, Marcelo Ricardo Leitner wrote:
> On Thu, Oct 03, 2019 at 01:26:46AM +0800, Xin Long wrote:
> > On Wed, Oct 2, 2019 at 8:55 PM Marcelo Ricardo Leitner
> > <marcelo.leitner@gmail.com> wrote:
> > >
> > > On Wed, Oct 02, 2019 at 04:23:52PM +0800, Xin Long wrote:
> > > > On Wed, Oct 2, 2019 at 9:04 AM Marcelo Ricardo Leitner
> > > > <marcelo.leitner@gmail.com> wrote:
> > > > >
> > > > > On Mon, Sep 30, 2019 at 09:10:18PM +0800, Xin Long wrote:
> > > > > > This patch is to fix a NULL-ptr deref crash in selinux_sctp_bind_connect:
> > > > > >
> > > > > >   [...] kasan: GPF could be caused by NULL-ptr deref or user memory access
> > > > > >   [...] RIP: 0010:selinux_sctp_bind_connect+0x16a/0x230
> > > > > >   [...] Call Trace:
> > > > > >   [...]  security_sctp_bind_connect+0x58/0x90
> > > > > >   [...]  sctp_process_asconf+0xa52/0xfd0 [sctp]
> > > > > >   [...]  sctp_sf_do_asconf+0x782/0x980 [sctp]
> > > > > >   [...]  sctp_do_sm+0x139/0x520 [sctp]
> > > > > >   [...]  sctp_assoc_bh_rcv+0x284/0x5c0 [sctp]
> > > > > >   [...]  sctp_backlog_rcv+0x45f/0x880 [sctp]
> > > > > >   [...]  __release_sock+0x120/0x370
> > > > > >   [...]  release_sock+0x4f/0x180
> > > > > >   [...]  sctp_accept+0x3f9/0x5a0 [sctp]
> > > > > >   [...]  inet_accept+0xe7/0x6f0
> > > > > >
> > > > > > It was caused by that the 'newsk' sk_socket was not set before going to
> > > > > > security sctp hook when doing accept() on a tcp-type socket:
> > > > > >
> > > > > >   inet_accept()->
> > > > > >     sctp_accept():
> > > > > >       lock_sock():
> > > > > >           lock listening 'sk'
> > > > > >                                           do_softirq():
> > > > > >                                             sctp_rcv():  <-- [1]
> > > > > >                                                 asconf chunk arrived and
> > > > > >                                                 enqueued in 'sk' backlog
> > > > > >       sctp_sock_migrate():
> > > > > >           set asoc's sk to 'newsk'
> > > > > >       release_sock():
> > > > > >           sctp_backlog_rcv():
> > > > > >             lock 'newsk'
> > > > > >             sctp_process_asconf()  <-- [2]
> > > > > >             unlock 'newsk'
> > > > > >     sock_graft():
> > > > > >         set sk_socket  <-- [3]
> > > > > >
> > > > > > As it shows, at [1] the asconf chunk would be put into the listening 'sk'
> > > > > > backlog, as accept() was holding its sock lock. Then at [2] asconf would
> > > > > > get processed with 'newsk' as asoc's sk had been set to 'newsk'. However,
> > > > > > 'newsk' sk_socket is not set until [3], while selinux_sctp_bind_connect()
> > > > > > would deref it, then kernel crashed.
> > > > >
> > > > > Note that sctp will migrate such incoming chunks from sk to newsk in
> > > > > sctp_rcv() if they arrived after the mass-migration performed at
> > > > > sctp_sock_migrate().
> > > > >
> > > > > That said, did you explore changing inet_accept() so that
> > > > > sk1->sk_prot->accept() would return sk2 still/already locked?
> > > > > That would be enough to block [2] from happening as then it would be
> > > > > queued on newsk backlog this time and avoid nearly duplicating
> > > > > inet_accept(). (too bad for this chunk, hit 2 backlogs..)
> > > > We don't have to bother inet_accept() for it. I had this one below,
> > > > and I was just thinking the locks order doesn't look nice. Do you
> > > > think this is more acceptable?
> > > >
> > > > @@ -4963,15 +4963,19 @@ static struct sock *sctp_accept(struct sock
> > > > *sk, int flags, int *err, bool kern)
> > > >          * asoc to the newsk.
> > > >          */
> > > >         error = sctp_sock_migrate(sk, newsk, asoc, SCTP_SOCKET_TCP);
> > > > -       if (error) {
> > > > -               sk_common_release(newsk);
> > > > -               newsk = NULL;
> > > > +       if (!error) {
> > > > +               lock_sock_nested(newsk, SINGLE_DEPTH_NESTING);
> > > > +               release_sock(sk);
> > >
> > > Interesting. It fixes the backlog processing, ok. Question:
> > >
> > > > +               release_sock(newsk);
> > >
> > > As newsk is hashed already and unlocked here to be locked again later
> > > on inet_accept(), it could receive a packet in between (thus before
> > > sock_graft() could have a chance to run), no?
> > 
> > You're right, it explains another call trace happened once in our testing.
> > 
> > The way to changing inet_accept() will also have to change all protocols'
> > .accept(). Given that this issue is only triggered in a very small moment,
> > can we just silently discard this asconf chunk if sk->sk_socket is NULL?
> > and let peer's T4-timer retransmit it.
> 
> No no. If the change doesn't hurt other protocols, we should try that
> first.  Otherwise this adds overhead to the network and we could get a
> bug report soon on "valid asconf being ignored".
> 
> If that doesn't pan out, maybe your initial suggestion is the way out.
> More custom code but keeps the expected behavior.
> 
> > 
> > @@ -3709,6 +3709,9 @@ enum sctp_disposition sctp_sf_do_asconf(struct net *net,
> >         struct sctp_addiphdr *hdr;
> >         __u32 serial;
> > 
> > +       if (asoc->base.sk->sk_socket)
> > +               return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);

What if we add this to sctp_backlog_rcv() instead?  As in, do not
process the backlog if so.
And force doing backlog on sctp_rcv() also.
As we are sure that there will be a subsequent lock/unlock and that it
will handle it, this could work.
