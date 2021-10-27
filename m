Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D6A43C119
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 06:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbhJ0EDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 00:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbhJ0EDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 00:03:22 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0C0C061570;
        Tue, 26 Oct 2021 21:00:56 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id p14so1694061wrd.10;
        Tue, 26 Oct 2021 21:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QN3bf7EVZjj8Vxa8U2qiACtkoDk0b3oTVtNvD0IyMH4=;
        b=HWLWW4l20+LV43dd+SCqqo1mtL+3nFtbC1FkZkIzamaSoscyWCCbOeHV8FIkZjTGSH
         WIoXB657CPLqod3Xww+KqB2mSo1ExHFuuHk+nsf02zsowBUuGyeewTQ4UkrAr21mlHHC
         VGAalJ+srCTBtLCZz0rT3axveE4uwuy7vVexJzAi2wIjvvVGLvMMQfylyGwwCmoEzRx+
         hgpAy4JENK2BRlf1drneij6jaMdnl4TQt99JkMvMfzLVJzc3bpVSSizAnfkvxGOwy4F0
         HLLwnvfw7WGoG7WsqU3A0lYHGnS9IvclFVS4dTNUaR3/7OAFuD/sk+HNB2K6zRed6b9r
         tM8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QN3bf7EVZjj8Vxa8U2qiACtkoDk0b3oTVtNvD0IyMH4=;
        b=BwvXRu3qhhC9npQeRVDSZnedKlwOkqJh9fx7ZVC9423UGJizfU4TK8tMRIfck50Lns
         fK9JImLWqHsDl5hJwEo2fb5DzNsl8wAeZiCQgKXmIrjXQw8X9Ax3jouLxGUnW+MkxBJP
         OJvAFyAYz7T8kpeHH4phOh6ZlByyBF1ilVJTJZip3UtN7YBWxnEIkPh5MtSrs7GBwpwz
         JicZPu3FjDc5mzL2nNheT7REViVzKiw6UA7d5YPBEq9T0EVJAl+r0vY3CDFjK+3xnDb5
         +OoZzWFc0Vhv2QElzr3N8H5Qj71vhlOc8/7zPFNLW0/LsO1j3cww5ecoiURelVsWcLbA
         15eQ==
X-Gm-Message-State: AOAM533KSam1uVgc9TCtYtxzIGYKYH6O4lK2517/6e/btQYkjIhyGXEE
        RJRr880xw7p5az29LQye54OtuFIMX7glUjbyRCq8OUL3N40=
X-Google-Smtp-Source: ABdhPJxylx58M2viUX0dmWWA78axLMA9EdwJZrO1tL224jGqQimMIkpuVlZQYzS+PovKD9KIW18rejj4mfW0tfajSIM=
X-Received: by 2002:a5d:4210:: with SMTP id n16mr22644326wrq.426.1635307255199;
 Tue, 26 Oct 2021 21:00:55 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1634884487.git.lucien.xin@gmail.com> <53026dedd66beeaf18a4570437c4e6c9e760bb90.1634884487.git.lucien.xin@gmail.com>
 <CAFqZXNs89yGcoXumNwavLRQpYutfnLY-SM2qrHbvpjJxVtiniw@mail.gmail.com>
 <CADvbK_djVKxjfRaLS0EZRY2mkzWXTMnwvbe-b7cK-T3BR8jzKQ@mail.gmail.com>
 <CAFqZXNsnEwPcEXB-4O983bxGj5BfZVMB6sor7nZVkT-=uiZ2mw@mail.gmail.com>
 <CADvbK_eE9VhB2cWzHSk_LNm_VemEt9vm=FMMVYzo5eVH=zEhKw@mail.gmail.com>
 <CAHC9VhTfVmcLOG3NfgQ3Tjpe769XzPntG24fejzSCvnZt_XZ9A@mail.gmail.com>
 <CADvbK_dwLCOvS8YzFXcXoDF6F69_sc7voPbxn5Ov4ygBR_5FXw@mail.gmail.com> <CAHC9VhREfztHQ8mqA_WM6NF=jKf0fTFTSRp_D5XhOVxckckwzw@mail.gmail.com>
In-Reply-To: <CAHC9VhREfztHQ8mqA_WM6NF=jKf0fTFTSRp_D5XhOVxckckwzw@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 27 Oct 2021 12:00:43 +0800
Message-ID: <CADvbK_c0CosUo4mMrSYQs_AA2KbB4MdnX5aS0zS0pJBOJV2vUA@mail.gmail.com>
Subject: Re: [PATCH net 4/4] security: implement sctp_assoc_established hook
 in selinux
To:     Paul Moore <paul@paul-moore.com>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        James Morris <jmorris@namei.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Richard Haines <richard_c_haines@btinternet.com>,
        SElinux list <selinux@vger.kernel.org>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 4:30 AM Paul Moore <paul@paul-moore.com> wrote:
>
> On Tue, Oct 26, 2021 at 12:47 AM Xin Long <lucien.xin@gmail.com> wrote:
> > On Tue, Oct 26, 2021 at 5:51 AM Paul Moore <paul@paul-moore.com> wrote:
> > > On Mon, Oct 25, 2021 at 10:11 AM Xin Long <lucien.xin@gmail.com> wrote:
> > > > On Mon, Oct 25, 2021 at 8:08 PM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> > > >> On Mon, Oct 25, 2021 at 12:51 PM Xin Long <lucien.xin@gmail.com> wrote:
> > > >> > On Mon, Oct 25, 2021 at 4:17 PM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> > > >> > > On Fri, Oct 22, 2021 at 8:36 AM Xin Long <lucien.xin@gmail.com> wrote:
> > > >> > > > Different from selinux_inet_conn_established(), it also gives the
> > > >> > > > secid to asoc->peer_secid in selinux_sctp_assoc_established(),
> > > >> > > > as one UDP-type socket may have more than one asocs.
> > > >> > > >
> > > >> > > > Note that peer_secid in asoc will save the peer secid for this
> > > >> > > > asoc connection, and peer_sid in sksec will just keep the peer
> > > >> > > > secid for the latest connection. So the right use should be do
> > > >> > > > peeloff for UDP-type socket if there will be multiple asocs in
> > > >> > > > one socket, so that the peeloff socket has the right label for
> > > >> > > > its asoc.
> > > >> > >
> > > >> > > Hm... this sounds like something we should also try to fix (if
> > > >> > > possible). In access control we can't trust userspace to do the right
> > > >> > > thing - receiving from multiple peers on one SOCK_SEQPACKET socket
> > > >> > > shouldn't cause checking against the wrong peer_sid. But that can be
> > > >> > > addressed separately. (And maybe it's even already accounted for
> > > >> > > somehow - I didn't yet look at the code closely.)
> > >
> > > There are a couple of things we need to worry about here: the
> > > per-packet access controls (e.g. can this packet be received by this
> > > socket?) and the userspace peer label queries (e.g. SO_GETPEERSEC and
> > > IP_CMSG_PASSSEC).
> > >
> > > The per-packet access controls work by checking the individual
> > > packet's security label against the corresponding sock label on the
> > > system (sk->sk_security->sid).  Because of this it is important that
> > > the sock's label is correct.  For unconnected sockets this is fairly
> > > straightforward as it follows the usual inherit-from-parent[1]
> > > behavior we see in other areas of SELinux.  For connected stream
> > > sockets this can be a bit more complicated.  However, since we are
> > > only discussing the client side things aren't too bad with the
> > > behavior essentially the same, inherit-from-parent, with the only
> > > interesting piece worth noting being the sksec->peer_sid
> > > (sk->sk_security->peer_sid) that we record from the packet passed to
> > > the LSM/SELinux hook (using selinux_skb_peerlbl_sid()).  The
> > > sksec->peer_sid is recorded primarily so that the kernel can correctly
> > > respond to SO_GETPEERSEC requests from userspace; it shouldn't be used
> > > in any access control decisions.
> >
> > Hi, Paul
> >
> > Understand now, the issue reported seems caused by when
> > doing peel-off the peel-off socket gets the uninitialised sid
> > from 'ep' on the client, though it should be "asoc".
>
> Hi Xin Long,
>
> Yes, that is my understanding.  I got the impression from the thread
> that there was some confusion about the different labels and what they
> were used for in SELinux, I was trying to provide some background in
> the text above.  If you are already familiar with how things should
> work you can disregard it :)
>
> > > In the case of SCTP, I would expect things to behave similarly: the
> > > sksec->peer_sid should match the packet label of the traffic which
> > > acknowledged/accepted the new connection, e.g. the other end of the
> > > connected socket.  You will have to forgive me some of the details,
> > > it's been a while since I last looked at the SCTP bits, but I would
> > > expect that if a client created a new connection and/or spun-off a new
> > > socket the new socket's sksec->peer_sid would have the same property,
> > > it would represent the security label of the other end of the
> > > connection/association.
> >
> > In SCTP, a socket doesn't represent a peer connection, it's more an
> > object binding some addresses and receiving incoming connecting
> > request, then creates 'asoc' to represent the connection, so asoc->
> > peer_secid represents the security label of the other end of the
> > connection/association.
>
> As mentioned previously the asoc->peer_secid *should* be the security
> label of the remote end, so I think we are okay here.  My concern
> remains the asoc->secid label as I don't believe it is being set to
> the correct value (more on that below).
>
> > After doing peel-off, it makes one asoc 'bind' to one new socket,
> > and this socket is used for userspace to control this asoc (conection),
> > so naturally we set sksec->peer_sid to asoc->secid for access control
> > in socket.
>
> The sksec->peer_sid represents the security label of the remote end so
> it should be set to the asoc->peer_secid and *not* the asoc->secid
Right, sorry,  it was a copy-paste error, it should've been "asoc->peer_secid".

> value.  Yes, they are presently the same value in your patches, but I
> believe that is a mistake; I believe the asoc->secid value should be
> set to that of the parent (see the prior inherit-from-parent
> discussion) which in this case would likely be either the parent
> association or the client process, I'm not entirely clear on which is
Yes, I think that's what the current patch does in
selinux_sctp_assoc_established().

> correct in the SCTP case.  The initial SCTP client association would
> need to take it's label from the parent process so perhaps that is the
> right answer for all SCTP client associations[2].
>
> [1] I would expect server side associations to follow the more
> complicated selinux_conn_sid() labeling, just as we do for TCP/stream
> connections today.
Yes, selinux_conn_sid() is currently called in selinux_sctp_assoc_request()
for the server side.

>
> [2] I'm guessing the client associations might also want to follow the
> setsockcreatecon(3) behavior, see selinux_sockcreate_sid() for more
> info.
OK, I think we are on the same page now, I will post v2.

Thanks!

>
> --
> paul moore
> www.paul-moore.com
