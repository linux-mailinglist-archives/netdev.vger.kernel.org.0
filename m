Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB96289DEC
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 05:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730795AbgJJDWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 23:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730533AbgJJDKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 23:10:14 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40F5C0613D2
        for <netdev@vger.kernel.org>; Fri,  9 Oct 2020 20:10:13 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id r10so8790722pgb.10
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 20:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DnmiEoCVE3FOWworSeIf6fY0KcSoT2FqH+xdEj47E94=;
        b=p1hBXu33Ek1EQG2Kv4RGIC43hAvpzLCYjr6pesSSuDDAGheP3qz5T4BxPcgsMv5QOw
         FjRByHQPgwgGPIRbVQMSs7qiKIa1uiAGfQLEEhBVnjQu8jBBsDJvrGYTDe/b3NSJy18X
         Ug7YRCC3NG5f9AUUEEyzVLzhw7ShWE78AHnxo/PIjm1cAFrH4T8AR6FkAuhxjMsgd0nx
         qPsE9XJ4AFC1vLYSeEq9h8vNIpjfJipBrOHgxfXkpS3KcFCu/0SDfJHMykgyZNsWf/rH
         HqloF0TJHlLvoDIXiF0cd11TPsVp6bY11jz71pl7R19bWNExLVFW6poBMb73/TvQP+Oe
         pIcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DnmiEoCVE3FOWworSeIf6fY0KcSoT2FqH+xdEj47E94=;
        b=dRAS+x0tFJLf+LoDCSFWqdpDRaq7On/V0PTzqn0TCbcchR8ZSOblYNmU/Pttv+6+k8
         nvFck68bvqYMd1ekz4uA4iocRq4+QXO1P9dr5ggFKLRh9DgPvUOkkL9dda44zPFXIT/g
         nxseBAMKGPQlF7p3Q/YjbxoXBlTVfOhxsCm0Q+eklG5I/dFVjviLEAh5bzyDpYjOC7gk
         W3SbV7qgYekgNvcRKItzOhd8EwxyIuUvxHFpJQKXICgkGZvC7x/tiDjXjk1/7ybBdaO2
         O+TGZoGSJNrLgPDfW+v1PU6JNLt+X9NAY3yzMTiV9+/Z+PZIH+Sv3z7EzzTO01g97b0b
         snmA==
X-Gm-Message-State: AOAM532bS3ME/gVYV5R/4FKg4J/gh/Ziy/v2WsUsVj+95NrP+BdJJMSY
        up5D5vXYGEfpIZI+S/fF0g1B8kXZVqC0mMWbktKn80tXG74=
X-Google-Smtp-Source: ABdhPJyGy61JCGkjmFB/3aj2TykMWPPz/7FF/mUtgyp19HS3zrsigKukc31RbLjai+WJBpvTBsId9AuD6y1qTLpDj2M=
X-Received: by 2002:aa7:96f8:0:b029:152:94c0:7e5 with SMTP id
 i24-20020aa796f80000b029015294c007e5mr14780330pfq.76.1602299413311; Fri, 09
 Oct 2020 20:10:13 -0700 (PDT)
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
 <CAM_iQpU1hU0Wg9sdTwFAG17Gk4-85+=xvZdQeb3oswhBKtAsPA@mail.gmail.com> <CAM_iQpVhrFZ4DWg9btEpS9+s0QX-b=eSkJJWzPr_KUV-TEkrQw@mail.gmail.com>
In-Reply-To: <CAM_iQpVhrFZ4DWg9btEpS9+s0QX-b=eSkJJWzPr_KUV-TEkrQw@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Fri, 9 Oct 2020 20:10:02 -0700
Message-ID: <CAJht_EO99yYQeUPUFR-qvWwrpZQfXToUu6x7LBS+0yhqiYg_XQ@mail.gmail.com>
Subject: Re: [Patch net] ip_gre: set dev->hard_header_len properly
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 9, 2020 at 6:07 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> Looking a bit deeper, I doubt the ipgre_header_ops->create is necessary,
> because 1) all other tunnels devices do not have it (ip_tunnel_header_ops
> only contains ->parse_protocol); 2) GRE headers are pushed in xmit
> anyway, so at least SOCK_DGRAM does not need it; 3) ipgre_header()
> creates the GRE header, later ipgre_xmit() pulls it back, then __gre_xmit()
> builds GRE header again...

Haha, I also don't like ipgre_header_ops->create and want to get rid
of it. We are thinking the same :)

From what I see, the flow when sending skbs (when header_ops is used)
is like this:

1) First ipgre_header creates the IP header and the GRE base header,
leaving space for the GRE optional fields and the "encap" header (the
space for the "encap" header should be left before the GRE header, but
it is incorrectly left after the GRE header).

2) Then ipgre_xmit pulls the header created by ipgre_header (but
leaves the data there). Then it calls __gre_xmit.

3) __gre_xmit calls gre_build_header. gre_build_header will push back
the GRE header, read the GRE base header and build the GRE optional
fields.

4) Then __gre_xmit calls ip_tunnel_xmit. ip_tunnel_xmit will build the
"encap" header by calling ip_tunnel_encap.

So what ipgre_header does is actually creating the IP header and the
GRE header, and leaving some holes for the GRE optional fields and the
"encap" header to be built later.

This seems so weird to me. If a user is using an AF_PACKET/RAW socket,
the user is supposed to do what the header_ops->create function does
(that is, creating two headers and leaving two holes to be filled in
later). I think no user would actually do that. That is so weird.

Also you said, all other tunnel devices didn't have
header_ops->create. I think that is a good argument for getting rid of
header_ops->create, too.

Also, for IP GRE TAP devices (as I understand, these devices are just
like IP GRE devices except it tunnels Ethernet frames instead of
network-layer packets), its header_ops will be Ethernet's
eth_header_ops (ipgre_tap_setup calls ether_setup, which sets up the
Ethernet header_ops). In this case, I think it is logical to keep the
header_ops for IP GRE devices as NULL. So that the header_ops of IP
GRE devices is consistent with that of IP GRE TAP devices.
