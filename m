Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6A42925F6
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 12:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbgJSKkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 06:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbgJSKks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 06:40:48 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87AF2C0613CE;
        Mon, 19 Oct 2020 03:40:48 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id j7so6725182wrt.9;
        Mon, 19 Oct 2020 03:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sUaflMVkedr8DIApnUtMT1/sTLYEEaR9p9QBwdFLhTs=;
        b=PuL+eCadXLBoqlSPKdHaNloptopOyGVACeMdFaTXg5PTFVD5M7m/48ADhG9Mcok2Pi
         5c+79HZlvYRgzJjl4D9jrUsiY9Xc4Wlr5IpTo6kuiIzXn0nPI6+JY3AfL1v+9D628kB9
         K08JSaCG0SB9VhMkak6kF8MMchYwVQ8fUYnp84X+sH6JIdIWvIBdr0kgxvecsBVq6RxM
         fnLy/9jDctavYPJJIUHUQ5ZK++hwscX6wFevnIEbk2p9MAg6q6Z9MZkDFx/X05+MQYdg
         SfxAPX84GBq4LI6ol5sm1ULxxf5lUU6FV8sAAHlSi9sFgxQFKP7qo47y5ArhTLDJWMub
         1Gug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sUaflMVkedr8DIApnUtMT1/sTLYEEaR9p9QBwdFLhTs=;
        b=UCG7SMqLcMZHYqmeWSghZwWwVXLXydAQgONltqNgSxIgCWAZCvG5ZZtCnHCcNw4PKz
         FYtohZUZye1BiN9Yw6w5TXL82LeGIIdFJPukEcw08eastTiZkfEyBynV7ZIl4dy0apLG
         bkrxxDhoWWhgIOVLQDaVEUqbu0tPJ0oaAFidpiR9UB4gsxwp6gRG34vhK3WBVTjst7Eu
         ZLy5+fRQvmYmm99FLBNz/WZRAdl4ayYiDlND9iLQYJs4jv9lrtBeka9hVYlNOeDMhAv5
         WnKzX9Cg6/nPA4+tC53W7lKFIrz0ndG8fI/68dCsx7VGzmlCOIyxmwxWfCEIS2Bajw2a
         7TOg==
X-Gm-Message-State: AOAM531QADRLwHHHLhQvQRfT152N8dpr/5k32aHs8WbbxpQmie7qKX7m
        MQnmEz+5AQpNpMwLENrc7/OsmDRgTOnyS0IcfH4=
X-Google-Smtp-Source: ABdhPJzCJRNylweSezZEozygOcd5rdzb6RbCQ3CYhfUFr6iOFwrQ2I5oZTGd7uNwAl4aWc/ymIMBlPOcAwWjNFO/z1k=
X-Received: by 2002:adf:e881:: with SMTP id d1mr18904845wrm.395.1603104046710;
 Mon, 19 Oct 2020 03:40:46 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1602574012.git.lucien.xin@gmail.com> <afbaca39fa40eba694bd63c200050a49d8c8df81.1602574012.git.lucien.xin@gmail.com>
 <20201015174252.GB11030@localhost.localdomain> <CADvbK_eMOPQfB2URNshOizSe9_j0dpbA47TVWSwctziFas3GaQ@mail.gmail.com>
In-Reply-To: <CADvbK_eMOPQfB2URNshOizSe9_j0dpbA47TVWSwctziFas3GaQ@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 19 Oct 2020 18:40:35 +0800
Message-ID: <CADvbK_dzZaH+6_+2g_ak+AL_RSv1O3cDdVOKiAb3WGm+=6F9gQ@mail.gmail.com>
Subject: Re: [PATCHv3 net-next 16/16] sctp: enable udp tunneling socks
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        davem <davem@davemloft.net>, Guillaume Nault <gnault@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 3:08 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Fri, Oct 16, 2020 at 1:42 AM Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> >
> > Actually..
> >
> > On Tue, Oct 13, 2020 at 03:27:41PM +0800, Xin Long wrote:
> > ...
> > > Also add sysctl udp_port to allow changing the listening
> > > sock's port by users.
> > ...
> > > ---
> > >  net/sctp/protocol.c |  5 +++++
> > >  net/sctp/sysctl.c   | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  2 files changed, 55 insertions(+)
> >
> > Xin, sorry for not noticing this earlier, but we need a documentation
> > update here for this new sysctl. This is important. Please add its
> > entry in ip-sysctl.rst.
> no problem, I will add it.
>
> >
> > >
> > > diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
> > > index be002b7..79fb4b5 100644
> > > --- a/net/sctp/protocol.c
> > > +++ b/net/sctp/protocol.c
> > > @@ -1469,6 +1469,10 @@ static int __net_init sctp_ctrlsock_init(struct net *net)
> > >       if (status)
> > >               pr_err("Failed to initialize the SCTP control sock\n");
> > >
> > > +     status = sctp_udp_sock_start(net);
> > > +     if (status)
> > > +             pr_err("Failed to initialize the SCTP udp tunneling sock\n");
> >                                                       ^^^ upper case please.
> > Nit. There are other occurrences of this.
> You mean we can remove this log, as it's been handled well in
> sctp_udp_sock_start()?
This one is actually OK :D
I've updated 'udp' with 'UDP' for all code annotations in this patchset.

will post v4.

Thanks.


>
> >
> > > +
> > >       return status;
> > ...
> > > +     ret = proc_dointvec(&tbl, write, buffer, lenp, ppos);
> > > +     if (write && ret == 0) {
> > > +             struct sock *sk = net->sctp.ctl_sock;
> > > +
> > > +             if (new_value > max || new_value < min)
> > > +                     return -EINVAL;
> > > +
> > > +             net->sctp.udp_port = new_value;
> > > +             sctp_udp_sock_stop(net);
> >
> > So, if it would be disabling the encapsulation, it shouldn't be
> > calling _start() then, right? Like
> >
> >                 if (new_value)
> >                         ret = sctp_udp_sock_start(net);
> >
> > Otherwise _start() here will call ..._bind() with port 0, which then
> > will be a random one.
> right, somehow I thought it wouldn't bind with port 0.
>
> Thanks.
> >
> > > +             ret = sctp_udp_sock_start(net);
> > > +             if (ret)
> > > +                     net->sctp.udp_port = 0;
> > > +
> > > +             /* Update the value in the control socket */
> > > +             lock_sock(sk);
> > > +             sctp_sk(sk)->udp_port = htons(net->sctp.udp_port);
> > > +             release_sock(sk);
> > > +     }
> > > +
> > > +     return ret;
> > > +}
> > > +
> > >  int sctp_sysctl_net_register(struct net *net)
> > >  {
> > >       struct ctl_table *table;
> > > --
> > > 2.1.0
> > >
