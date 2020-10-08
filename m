Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85FA1287D33
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 22:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730462AbgJHUc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 16:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgJHUc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 16:32:27 -0400
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A85FC0613D2
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 13:32:27 -0700 (PDT)
Received: by mail-vk1-xa31.google.com with SMTP id l23so571952vkm.1
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 13:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VdAcJeFgVToEY9pT6Lize6/WNs7Rm8Ru5oXG52nT+gc=;
        b=FqSlDGpA+4qW4CsF+DMsJAdTjsVCD6qnvRKGzw2zFy8GY4b1uchr5xEK6EGyjQLOjt
         PhexLpfFrX1WdmdU29mjv3PC5D913sEPrMbeKwu8tBtnFNPQnuUfcCEtCwRI7OHmvkO3
         /YoLUTKj5Xgh77aN+a650MxfLyF4x5r2XlojxmodvJWOYpO5yITftxaz3p9DoDLPImIW
         M4bsmcF/Lxb6vrEjZT5R+jtLdZaMioR+zfCE8B60tZ9zLxE9wNnzCtMrgA4tSDr0K1eJ
         h2bJ3E2md2VHMZeOgEFlCA7DGTXKLKX3Ed/kvZKGmcOFiFCnekbpBG35Fk/KHn+H2koK
         yEbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VdAcJeFgVToEY9pT6Lize6/WNs7Rm8Ru5oXG52nT+gc=;
        b=d9YoyrX65LpcbAyDU2rcUkQzGLgjo4hQzfMzsNaqqnLFYfO7sAo0NcwIBI21F953pl
         JIGm/V+q+nVMUZf//1VHp0Q3j099XJnEIMHcjS/KRyQoM9N3ENp6w033CMAXDg1CYR1G
         u7IcPUoIrBioTY10lIIh1wpPNqDrjtaBEeD1WM1Pk5f7VJjcXkAsO51RDo0Z3b+812Ux
         vOUUsBfsSE+dLcV2YqlZTQq5dFGEs9cf6SJ5TPmrd7lTJIqTu54P+BD5hwyfQmy3d87X
         LkKkSBpShDJb1SKjpHoMtnTvXa8jUHnrTAwTfRVzhavseup+VXF7wD9cKjcX4Hhtg+2I
         qGhQ==
X-Gm-Message-State: AOAM533BTfblEocubCXK+sdlEPJMZKxtEC/Mz8ThPFNQ2L8iF6hzIB+N
        kNmLvSHYGmwMGcVXQ8AtqrewFOEkep4=
X-Google-Smtp-Source: ABdhPJz9DtusYdDCzunsJYaH0i8C06mHOjzVmzkG0gUZfYD6OCaXLxy9sZ68nCm1vBE6zuyPR2DCXg==
X-Received: by 2002:a1f:b24d:: with SMTP id b74mr2255921vkf.2.1602189145741;
        Thu, 08 Oct 2020 13:32:25 -0700 (PDT)
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com. [209.85.217.53])
        by smtp.gmail.com with ESMTPSA id t6sm842568vke.28.2020.10.08.13.32.24
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 13:32:24 -0700 (PDT)
Received: by mail-vs1-f53.google.com with SMTP id 5so3794736vsu.5
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 13:32:24 -0700 (PDT)
X-Received: by 2002:a67:d84:: with SMTP id 126mr5928479vsn.51.1602189143799;
 Thu, 08 Oct 2020 13:32:23 -0700 (PDT)
MIME-Version: 1.0
References: <20201008012154.11149-1-xiyou.wangcong@gmail.com>
 <CA+FuTSeMYFh3tY9cJN6h02E+r3BST=w74+pD=zraLXsmJTLZXA@mail.gmail.com>
 <CAM_iQpWCR84sD6dZBforgt4cg-Jya91D6EynDo2y2sC7vi-vMg@mail.gmail.com>
 <CA+FuTSdKa1Q36ONbsGOMqXDCUiiDNsA6rkqyrzB+eXJj=MyRKA@mail.gmail.com>
 <CAJht_ENnmYRh-RomBodJE0HoFzaLQhD+DKEu2WWST+B43JxWcQ@mail.gmail.com>
 <CA+FuTSdWYDs5u+3VzpTA1-Xs1OiVzv8QiKGTH4GUYrvXFfGT_A@mail.gmail.com> <CAJht_ENMFY_HwaJDjvxZbQgcDv7btC+bU6gzdjyddY-JS=a6Lg@mail.gmail.com>
In-Reply-To: <CAJht_ENMFY_HwaJDjvxZbQgcDv7btC+bU6gzdjyddY-JS=a6Lg@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 8 Oct 2020 16:31:48 -0400
X-Gmail-Original-Message-ID: <CA+FuTScizeZC-ndVvXj4VyArth2gnxoh3kTSoe5awGoiFXtkBA@mail.gmail.com>
Message-ID: <CA+FuTScizeZC-ndVvXj4VyArth2gnxoh3kTSoe5awGoiFXtkBA@mail.gmail.com>
Subject: Re: [Patch net] ip_gre: set dev->hard_header_len properly
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 8, 2020 at 4:11 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Thu, Oct 8, 2020 at 12:20 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Thu, Oct 8, 2020 at 3:17 PM Xie He <xie.he.0141@gmail.com> wrote:
> > >
> > > However, there's something I don't understand in the GRE code. The
> > > ipgre_header function only creates an IP header (20 bytes) + a GRE
> > > base header (4 bytes), but pushes and returns "t->hlen +
> > > sizeof(*iph)". What is t->hlen?
> >
> > GRE is variable length depending on flags:
> >
> >         tunnel->tun_hlen = gre_calc_hlen(tunnel->parms.o_flags);
> >
> >
> > > It seems to me it is the sum of
> > > t->tun_hlen and t->encap_hlen. What are these two?
>
> OK. I understand that t->tun_hlen is the GRE header length. What is
> t->encap_hlen?

I've looked at that closely either.

Appears to be to account for additional FOU/GUE encap:

"
commit 56328486539ddd07cbaafec7a542a2c8a3043623
Author: Tom Herbert <therbert@google.com>
Date:   Wed Sep 17 12:25:58 2014 -0700
    net: Changes to ip_tunnel to support foo-over-udp encapsulation

    This patch changes IP tunnel to support (secondary) encapsulation,
    Foo-over-UDP. Changes include:

    1) Adding tun_hlen as the tunnel header length, encap_hlen as the
       encapsulation header length, and hlen becomes the grand total
       of these.
    2) Added common netlink define to support FOU encapsulation.
    3) Routines to perform FOU encapsulation.

    Signed-off-by: Tom Herbert <therbert@google.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>
"
