Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72C4D28A437
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388682AbgJJWyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730628AbgJJS7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 14:59:13 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9F9C08EC25
        for <netdev@vger.kernel.org>; Sat, 10 Oct 2020 11:58:59 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id o18so12297911ill.2
        for <netdev@vger.kernel.org>; Sat, 10 Oct 2020 11:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0X1Vrx8VV4CbPfQxfPJgztnx23B8al/tgq6eadyhiDQ=;
        b=OdnZe9J6DeiLDdKAn2Nvs/YGzSDSbJIsfrMFqqtAPb6lxri2yEOQsnkMgVll7IysEy
         Xxt8c0DU+lZr9/c7dKt7YeqL43FeXNThi7ubsaNBTruIhV8hUBPL88JlXYb1zbm33TD8
         cEn3U0t4r1i235bD/tpU04p6m8Vn9GI0sE0UDaYtIL62/lwRJwiWXxuOQDqgiqvrvsMw
         MDghFJHllsaBmodD36bOgt0WAvjmfte4Cm8RKM92HlHfekEa4xi+1BqQGpzoEjQ18Wc5
         /QVmRlHsVgQ3wqJyCN0HkzP6VxgghAUpwhUsaQnR80Dpw+h2T7bShUC4ZRTgrqpa4hIi
         Fu/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0X1Vrx8VV4CbPfQxfPJgztnx23B8al/tgq6eadyhiDQ=;
        b=XBnw8iNbSLULqGaIzKK8mknCuT2mP5XNW1eACYs89kVvQWJjNU3FXSHF7QTvh9qvTY
         5p49Qd+5WTmlmoUKAkcikKa14NSbjTKxwfqY6a5IFSlNBE7V/uOENj2QWfBexBUxux1y
         GSSEU+M5wflhaQgtIyX2xozLi4ZWaTxkGknB6TmGZrKV5v7aH+3lzuwXCFNgACDBksNn
         c19zgd+E/8O8MubXYG5S1xGNeYo8sUarPiN54tOb6RAkYgnImCV1W3rbbTulKICK6bug
         OkRMiUq+A82TktUQnZ6wB1dJ4cFtLEoKNJrsc7NpwbxTwk9ZV26Q5o2dh1Pa22bgyo6h
         R5ew==
X-Gm-Message-State: AOAM533oFC5lqZc9MICPylq9bE8rvmal+mVbmhMtqqZsc4U822KOV27K
        RRnR4lFMOe0rp9KRFUCp3dLmUcF8iWYrmxzCSZg=
X-Google-Smtp-Source: ABdhPJy8miJYhJSyynb/nhZcfJecSwUqQflQUWqCU242RwPRJ2y1Mxocz9hCw1UIo4ee71jUGAXvKNGUDWDRv1C+ezA=
X-Received: by 2002:a92:9a04:: with SMTP id t4mr14432805ili.268.1602356338651;
 Sat, 10 Oct 2020 11:58:58 -0700 (PDT)
MIME-Version: 1.0
References: <20201008012154.11149-1-xiyou.wangcong@gmail.com>
 <CA+FuTSeMYFh3tY9cJN6h02E+r3BST=w74+pD=zraLXsmJTLZXA@mail.gmail.com>
 <CAM_iQpWCR84sD6dZBforgt4cg-Jya91D6EynDo2y2sC7vi-vMg@mail.gmail.com>
 <CA+FuTSdKa1Q36ONbsGOMqXDCUiiDNsA6rkqyrzB+eXJj=MyRKA@mail.gmail.com>
 <CAJht_ENnmYRh-RomBodJE0HoFzaLQhD+DKEu2WWST+B43JxWcQ@mail.gmail.com>
 <CA+FuTSdWYDs5u+3VzpTA1-Xs1OiVzv8QiKGTH4GUYrvXFfGT_A@mail.gmail.com>
 <CAJht_ENMFY_HwaJDjvxZbQgcDv7btC+bU6gzdjyddY-JS=a6Lg@mail.gmail.com>
 <CA+FuTScizeZC-ndVvXj4VyArth2gnxoh3kTSoe5awGoiFXtkBA@mail.gmail.com>
 <CAJht_ENmrPbhfPaD5kkiDVWQsvA_LRndPiCMrS9zdje6sVPk=g@mail.gmail.com>
 <CA+FuTSfhDgn-Qej4HOY-kYWSy8pUsnafMk=ozwtYGfS4W2DNuA@mail.gmail.com>
 <CAJht_ENxoAyUOoiHSbFXEZ6Jf2xqfOmYfQ6Sh-hfmTUk-kTrfQ@mail.gmail.com>
 <CAJht_EOMQRKWfwhfqwXB3RYA1h463q43ycNjJmaGZm6RS65QGA@mail.gmail.com>
 <CAM_iQpWRftQkOfgfMACNR_5YZxvzLJH1aMtmZNj7nJH_Wu-NRw@mail.gmail.com>
 <CAJht_ENnYyXbOxtPHD9GHB92U4uonKO_oRZ82g2OR2DaFZ7bBQ@mail.gmail.com>
 <CAJht_EPVyc0uAZc914E3tdgqEc7tDabpAxnBsGrRRFecc+NMwg@mail.gmail.com>
 <CAM_iQpU1hU0Wg9sdTwFAG17Gk4-85+=xvZdQeb3oswhBKtAsPA@mail.gmail.com>
 <CAM_iQpVhrFZ4DWg9btEpS9+s0QX-b=eSkJJWzPr_KUV-TEkrQw@mail.gmail.com> <CAJht_EO99yYQeUPUFR-qvWwrpZQfXToUu6x7LBS+0yhqiYg_XQ@mail.gmail.com>
In-Reply-To: <CAJht_EO99yYQeUPUFR-qvWwrpZQfXToUu6x7LBS+0yhqiYg_XQ@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 10 Oct 2020 11:58:47 -0700
Message-ID: <CAM_iQpX0zjZUDE_iuf4WWXiodwb2UpqyjjQPYrfD0CMXnMSymQ@mail.gmail.com>
Subject: Re: [Patch net] ip_gre: set dev->hard_header_len properly
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 9, 2020 at 8:10 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Fri, Oct 9, 2020 at 6:07 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > Looking a bit deeper, I doubt the ipgre_header_ops->create is necessary,
> > because 1) all other tunnels devices do not have it (ip_tunnel_header_ops
> > only contains ->parse_protocol); 2) GRE headers are pushed in xmit
> > anyway, so at least SOCK_DGRAM does not need it; 3) ipgre_header()
> > creates the GRE header, later ipgre_xmit() pulls it back, then __gre_xmit()
> > builds GRE header again...
>
> Haha, I also don't like ipgre_header_ops->create and want to get rid
> of it. We are thinking the same :)

Great!

>
> From what I see, the flow when sending skbs (when header_ops is used)
> is like this:
>
> 1) First ipgre_header creates the IP header and the GRE base header,
> leaving space for the GRE optional fields and the "encap" header (the
> space for the "encap" header should be left before the GRE header, but
> it is incorrectly left after the GRE header).
>
> 2) Then ipgre_xmit pulls the header created by ipgre_header (but
> leaves the data there). Then it calls __gre_xmit.
>
> 3) __gre_xmit calls gre_build_header. gre_build_header will push back
> the GRE header, read the GRE base header and build the GRE optional
> fields.
>
> 4) Then __gre_xmit calls ip_tunnel_xmit. ip_tunnel_xmit will build the
> "encap" header by calling ip_tunnel_encap.
>
> So what ipgre_header does is actually creating the IP header and the
> GRE header, and leaving some holes for the GRE optional fields and the
> "encap" header to be built later.

Right. For the encap header, I'd guess it is because this is relatively new.

>
> This seems so weird to me. If a user is using an AF_PACKET/RAW socket,
> the user is supposed to do what the header_ops->create function does
> (that is, creating two headers and leaving two holes to be filled in
> later). I think no user would actually do that. That is so weird.

Well, AF_PACKET RAW socket is supposed to construct L2 headers
from the user buffer, and for a tunnel device these headers are indeed its
L2. If users do not want to do this, they can switch to DGRAM anyway.

I know how inconvenient it is to construct a GRE tunnel header, I guess
this is why all other tunnel devices do not provide a header_ops::create.
GRE tunnel is not a special case, this is why I agree on removing its
->create() although it does look like all tunnel devices should let users
construct headers by definition of RAW.

Of course, it may be too late to change this behavior even if we really
want, users may already assume there is always no tunnel header needed
to construct.

Thanks.
