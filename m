Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9A3F8272
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 22:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727730AbfKKVqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 16:46:16 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:40674 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727659AbfKKVqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 16:46:08 -0500
Received: by mail-ed1-f68.google.com with SMTP id p59so13165705edp.7
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 13:46:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fwSenrGZTcRkPkhVOsDBxXJSYCxeuktbF/V+szj79Ms=;
        b=TeOnH2egW3B6MH2GzlhiKdrIUM7MZwx2yR9A1wFDZ6F9AXyMfnK7itUKt1LPgOdeT1
         4ucyvq8MKomKldoPcE2iYpS+PppZgPsAgNMD2d3XpG3wzRWWgeV9rjyHsogxbXXp9L0K
         xC15ulplT3QlhIfYo8bVVUakH2vGMU82jCXu5JeKgtEPKtpGhBqi2wqLBvd2Rvm6W6X2
         jfsK553Yfcr959OputrnIp8OKP7uuC+AtHapa1L54CVmY1A642bMROyBVsKObJ80nEtg
         uVxUerGOBa52FTx+lDPt1i/qMh6XobY1InlMA6LvQcrOUdWgm/eZowiXPaG2S3a/kPTQ
         2XTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fwSenrGZTcRkPkhVOsDBxXJSYCxeuktbF/V+szj79Ms=;
        b=MJRlOtYueLh8Q2o0xoGFA1rDY5qCPlOz4bBfnw3e5p3+vG95zOAW0a90uwFmT0W63W
         IOmP8CnSLw5Yum0otFYBAV8B1AWL+btyWYv6yP31VmpkEa9tTk3/2uTirchUzmOgY6bi
         +bbBFNC4PBnBhwjXKfuIBCevt/AOKlGaJPCz6j29UPEHoqWqc5BN1/Qz4cr4UEzS/ggW
         UIDIm8zaFDBjSgYz4ysiHXXOXXbSm3OPiwlRu1KTxqbKSMrB6MvszKwSKam4xBacUpsw
         KcCIu8mbQItyG9IvqFENmWGbUUzF+L8rkMNm+KhX78INxmRUmTxA+daWE9+02DibyoZ6
         Z23A==
X-Gm-Message-State: APjAAAX1kMdftxBrZxdhz1Z6nS+Pzm/CNnxEgegBjpCleXev3C3PbEnF
        PRVoeBGW7kMDiAVISF6dSh2dJFZj0eQCJUL48kM=
X-Google-Smtp-Source: APXvYqxujp6CUsl/v/UCeAVcwZS5s6C+DrJE4vz4UJqgDgGbixpl0BTA98yLRORd2pdiIrWOhsw5334qHGIWrflWloM=
X-Received: by 2002:a05:6402:602:: with SMTP id n2mr29646525edv.23.1573508766557;
 Mon, 11 Nov 2019 13:46:06 -0800 (PST)
MIME-Version: 1.0
References: <5979d1bf0b5521c66f2f6fa31b7e1cbdddd8cea8.1570455278.git.martinvarghesenokia@gmail.com>
 <CA+FuTSc=uTot72dxn7VRfCv59GcfWb32ZM5XU1_GHt3Ci3PL_A@mail.gmail.com>
 <20191017132029.GA9982@martin-VirtualBox> <CA+FuTScS+fm_scnm5qkU4wtV+FAW8XkC4OfwCbLOxuPz1YipNw@mail.gmail.com>
 <20191018082029.GA11876@martin-VirtualBox> <CA+FuTSf2u2yN1KL3vDLv-j9UQGsGo1dwXNVW8w=NCrdt7n8crg@mail.gmail.com>
 <20191107133819.GA10201@martin-VirtualBox> <CAF=yD-JX=juqj2yrpZ6MjksLDqF8JVjTsruu2yVh5aXL6rou5g@mail.gmail.com>
 <20191107161238.GA10727@martin-VirtualBox> <CAF=yD-JeCV-AW2HO9inJt-yePUrBGQ9=M58fYr8f2CDHdNNpaA@mail.gmail.com>
 <20191111160222.GA2765@martin-VirtualBox>
In-Reply-To: <20191111160222.GA2765@martin-VirtualBox>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 11 Nov 2019 16:45:30 -0500
Message-ID: <CAF=yD-KhfRr6Qd8ZMYhKDQ6v=61mTHHXJdhCkMhahULmgcuqDw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, scott.drennan@nokia.com,
        Jiri Benc <jbenc@redhat.com>, martin.varghese@nokia.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 11, 2019 at 11:02 AM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> On Thu, Nov 07, 2019 at 11:35:07AM -0500, Willem de Bruijn wrote:
> > On Thu, Nov 7, 2019 at 11:12 AM Martin Varghese
> > <martinvarghesenokia@gmail.com> wrote:
> > >
> > > On Thu, Nov 07, 2019 at 10:53:47AM -0500, Willem de Bruijn wrote:
> > > > > > I do think that with close scrutiny there is a lot more room for code
> > > > > > deduplication. Just look at the lower half of geneve_rx and
> > > > > > bareudp_udp_encap_recv, for instance. This, too, is identical down to
> > > > > > the comments. Indeed, is it fair to say that geneve was taken as the
> > > > > > basis for this device?
> > > > > >
> > > > > > That said, even just avoiding duplicating those routing functions
> > > > > > would be a good start.
> > > > > >
> > > > > > I'm harping on this because in other examples in the past where a new
> > > > > > device was created by duplicating instead of factoring out code
> > > > > > implementations diverge over time in bad ways due to optimizations,
> > > > > > features and most importantly bugfixes being applied only to one
> > > > > > instance or the other. See for instance tun.c and tap.c.
> > > > > >
> > > > > > Unrelated, an ipv6 socket can receive both ipv4 and ipv6 traffic if
> > > > > > not setting the v6only bit, so does the device need to have separate
> > > > > > sock4 and sock6 members? Both sockets currently lead to the same
> > > > > > bareudp_udp_encap_recv callback function.
> > > > >
> > > > > I was checking this.AF_INET6 allows v6 and v4 mapped v6 address.
> > > > > And it doesnot allow both at the same time.So we need both
> > > > > sockets to support v4 and v6 at the same time.correct ?
> > > >
> > > > bareudp_create_sock currently creates an inet socket listening on
> > > > INADDR_ANY and an inet6 socket listening on in6addr_any with v6only.
> > > > If so, just the latter without v6only should offer the same.
> > >
> > > To receive and ipv4 packet in AF_INET6 packet we need to pass v4 address
> > > in v6 format( v4 mapped v6 address). Is it not ?
> >
> > If the bareudp device binds to a specific port on all local addresses,
> > which I think it's doing judging from what it passes to udp_sock_create
> > (but I may very well be missing something), then in6addr_any alone will
> > suffice to receive both v6 and v4 packets.
>
> Must invokde udp_encap_enable explicitly from baredudp module during setup time.
> Otherwise v4 packets will not land in encap_rcv handler.

The call to setup_udp_tunnel_sock should take care of that. The issue
is probably that in udp_tunnel_encap_enable:

  #if IS_ENABLED(CONFIG_IPV6)
        if (sock->sk->sk_family == PF_INET6)
                ipv6_stub->udpv6_encap_enable();
        else
  #endif
                udp_encap_enable();

does not call udp_encap_enable for IPv6 sockets. Likely because
existing callers like vxlan always pass v6only = 1. Due to dual stack,
PF_INET6 should enable both static keys.
