Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B16417EDEA
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 02:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbgCJBSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 21:18:09 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:34126 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgCJBSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 21:18:09 -0400
Received: by mail-lf1-f68.google.com with SMTP id i19so3509328lfl.1
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 18:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FuSHcTl/LJwmryJYR7WTLZwx4uKjjF3R3sc0lof/IP0=;
        b=lJ4J1CR3gWdmf5tGS7aBtvvUxwJ35iDvPDMYB0o8gk+CuQsVx7JvCiHRA8US9B1bbP
         /IHdok77bvVppyRvhAKbQOVlQYskkhsCCr2zlt68viHYdwaa08buJI5YdPxcTYFedQ0N
         +PgwvLNEuOYViCRIO0ztiMCZnIxZyZ1iGHfA4R+gF3/TK+T+dPxYrfHJeKJb2n4I1g27
         j4WPKUqnzsgU6PVHdz+yz78tkqkoZoQET2SfOUzluKt/hWcjDWfViuImX27rEPTVND/z
         urECtjvZ+Yu7qOO5fiAFgs5HkDnbxfmDRjQ4+C+s3tPqYHEaaS1u5iPhvNFsk98D9HlG
         52Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FuSHcTl/LJwmryJYR7WTLZwx4uKjjF3R3sc0lof/IP0=;
        b=Bbl9k1eaDLCF5X7OBLIZkQuy/8skcYbYEmixydg5lNWMdAbhdtb+f9WtM2IP4vg7hN
         67h2PU5NIetKAUdB9UhGVB7Ee06N9G5mtDtCm6PX1VQZThimLmzKWJQMNiqObS4o4Y6K
         l5namYMWnU73sGnnoDdRoz9FDWH0h/9xK7S3RlZVHu/6p4kNBl4OKoIYGPVuCDbnYc1A
         l66HgGTa/7vq69URx+/B6eJKGFCR7x3vZvCPih10IRLCJ0Dq8iNGTzHFKn6H8pq0Pslr
         bY84XUon9D3oAZf/hDhX5fY7LOCnIAfOy2w9SGB7zLL+IHNqfZPOpVIjpk6y5BOKqajm
         yqDQ==
X-Gm-Message-State: ANhLgQ3GMFwDR2waVe0AZ4L+mVYUXZey6xpiZZtr08xyCAOyDA7NcZ0A
        oY5Tzw1oQkHaXpG82qlPDKdg7c40T4kbIlg/nXU=
X-Google-Smtp-Source: ADFU+vsGMY6i6Q+Wsns1c2K+wwDKVFCAitbBfyobiWr0s+ampHQ9D0ObEaO6zj08gpGA4umTcuqzdSR4F2c7WuSD1EY=
X-Received: by 2002:a19:cbc3:: with SMTP id b186mr7712842lfg.182.1583803086966;
 Mon, 09 Mar 2020 18:18:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200308011930.6923-1-ap420073@gmail.com> <20200309060304.GA16103@martin-VirtualBox>
In-Reply-To: <20200309060304.GA16103@martin-VirtualBox>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Tue, 10 Mar 2020 10:17:55 +0900
Message-ID: <CAMArcTWMWy-AMeu_obOAGthVky98mKDsfKzkZiq7pHU=K50nAg@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] bareudp: remove unnecessary
 udp_encap_enable() in bareudp_socket_create()
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Mar 2020 at 15:03, Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>

Hi Martin,
Thanek you for the review!

> On Sun, Mar 08, 2020 at 01:19:30AM +0000, Taehee Yoo wrote:
> > In the current code, udp_encap_enable() is called in
> > bareudp_socket_create().
> > But, setup_udp_tunnel_sock() internally calls udp_encap_enable().
> > So, udp_encap_enable() is unnecessary.
> >
> > Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> > ---
> >  drivers/net/bareudp.c | 3 ---
> >  1 file changed, 3 deletions(-)
> >
> > diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
> > index c9d0d68467f7..71a2f480f70e 100644
> > --- a/drivers/net/bareudp.c
> > +++ b/drivers/net/bareudp.c
> > @@ -250,9 +250,6 @@ static int bareudp_socket_create(struct bareudp_dev *bareudp, __be16 port)
> >       tunnel_cfg.encap_destroy = NULL;
> >       setup_udp_tunnel_sock(bareudp->net, sock, &tunnel_cfg);
> >
> > -     if (sock->sk->sk_family == AF_INET6)
> > -             udp_encap_enable();
> > -
> udp_encap_enable is not called for V6 sockets so we need to have the above lines of code

This patch is already merged into net-next.
So, you could send a revert patch.

In addition, I'm not familiar with the socket API.
So I'm a little bit curious about why you didn't create
separated ipv4 and ipv6 sockets?
Vxlan, geneve, etc create separated ipv4, ipv6 UDP socket.
In the bareudp modules, it creates a single socket and it tries to call
both udp_encap_enable() and udpv6_encap_enable.
Is there any special reason or both two ways are actually the same things?

Thank you so much!
Taehee Yoo
