Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF10C49521B
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 17:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376902AbiATQNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 11:13:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347315AbiATQNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 11:13:37 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E24C061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 08:13:36 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id c6so19260063ybk.3
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 08:13:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T/0UZzEu8+4uD2MTrWoxWZ6gvej8EjUaLRly4YiLAck=;
        b=rtC3rDXDfswI9VKIz/dknsjVwe10yLZEEVx2s/5sa+SyNSo6g3iSxFv2q0F6AjfqKM
         lpc2Vqkg0ik6UjQ0b3egFLTp+pXzANkIxQnyIep2aDwYyjh+BS1U+loUaClgaGM2wni2
         hXx4E+25ETH8t/jzx5iOWzLem4MzWntVJ9e98uK3SGwO5watrGF2mdNfvMdFyw8mW1mt
         zXFbsZ7VBeXBQzsA3m6OwiAAG721jrTvaiy7iTbA7jdpSbknM7muvFm3WScpQVWy0cu6
         b7xCwhom+ACAmoeIOe1Rve0ZuxJtoZ04h5Fb8JEnHDG3RDuzG/gkWp3j51HNev/B7ozm
         lxqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T/0UZzEu8+4uD2MTrWoxWZ6gvej8EjUaLRly4YiLAck=;
        b=6Jt1ZtWNidzj3sZFAuuzJwVkeDFyaptYyUZGrHxz6xc5pmUnetrYpDUwbR0wY8SK7G
         trStj9LQdlBKl+oN+UJQfIGV2wyJzrtZjKqbt+4z3xhDzLGQHck5hVIAfs4rgl3bWhBR
         fpIj3EKhDGmdnPevwaLHd4JvGmaXwCKKt0u/bV3D56S/fjQuz195m8YsphTOiQwrIw2E
         65kFB2pG7btioqqwPnmleZMfTuZ4VWj1rJvXCNUUyl6v6AgkNzstxSIIOlRpMEcyGPIJ
         Xh7w/6nQJZaaSJ6rMZ7xscSdmR8bS5Ie999B9WZvTWTHc9kFCkfZQtoeZBsjB7y0p9jo
         SO6Q==
X-Gm-Message-State: AOAM533sAWc6zdKpB8Mj7eITAfy/7cm66nKWD6ueic+y2i1VVeH9LkHm
        QiLlTk/rFrhXqg3UBiY/eMH9lMWEPhkV7vQrExYW+2uYWN6CJA==
X-Google-Smtp-Source: ABdhPJzzm2koDb4hrZAog+XFkcednZEy4VWoUOIMniQHp16wa7mJb/RY3rbktjiI2YrlojrH8JtI4tQlogQsWGSRvSw=
X-Received: by 2002:a25:a06:: with SMTP id 6mr47190721ybk.5.1642695215739;
 Thu, 20 Jan 2022 08:13:35 -0800 (PST)
MIME-Version: 1.0
References: <20220120123440.9088-1-gal@nvidia.com> <CANn89iK=2cxKC+8AFEu_QbANd1-LU+aUxNOfPvrjVJT5-e0ubA@mail.gmail.com>
 <20220120080530.69cbbcf2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220120080530.69cbbcf2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 20 Jan 2022 08:13:24 -0800
Message-ID: <CANn89iJ79Zt0eOjdr96GE1dtaO-7e-+0wT54Sa7Q-q-2fzsjtg@mail.gmail.com>
Subject: Re: [PATCH net] tcp: Add a stub for sk_defer_free_flush()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 8:05 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 20 Jan 2022 04:39:19 -0800 Eric Dumazet wrote:
> > On Thu, Jan 20, 2022 at 4:34 AM Gal Pressman <gal@nvidia.com> wrote:
> > > When compiling the kernel with CONFIG_INET disabled, the
> > > sk_defer_free_flush() should be defined as a nop.
> > >
> > > This resolves the following compilation error:
> > >   ld: net/core/sock.o: in function `sk_defer_free_flush':
> > >   ./include/net/tcp.h:1378: undefined reference to `__sk_defer_free_flush'
> >
> > Yes, this is one way to fix this, thanks.
>
> Yeah.. isn't it better to move __sk_defer_free_flush and co.
> out of TCP code?

sk->defer_list is currently only fed from tcp_eat_recv_skb(),
I guess we can leave the code, until we have another user than TCP ?
