Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 547D029DCFA
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729337AbgJ2AeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727781AbgJ2AeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 20:34:12 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A0FC0613CF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 17:34:11 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id c129so723037yba.8
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 17:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DjMIeLxlJ+2vXcSVLwM9C/+RQSKAbfMx8kJfVZ867yI=;
        b=IOFNprmyDBPoX5RtVmt0vxWzJiI8zq6f9uem6DNCYKtiN2j9d1tQknOSk0Oq2ZXmYl
         TuyFbmgz6dSwVu/D4BxTKakTpcLn8+30002lPvn+nRSPs9PeYAMjlRWKYVE8xDBnFiaC
         RTL0ibmNk2jyfnv9mF1K4qjgJCfdTU+QSivZwWOJEWq8Wdv0qGox64VecFO/6jvP3u6i
         aNVCAKuSZpgoXJxBZbJYDs15cG3N+UpPtB3xZVXBV/8S+eyu6dTJ/sgWErC/nQfJMoMH
         bWfHz3+GswFUS6lJ2f0zT6J2hwfWqm+PJfzbJPZU8RNxRebGHAgCaovzkt9fzHsDKlzS
         kEHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DjMIeLxlJ+2vXcSVLwM9C/+RQSKAbfMx8kJfVZ867yI=;
        b=udDzICSb4B08njXynq25QHhQ9IxNT7+GEQI/xCpmg28rCIG1KP/HFonFN5QnZ7r48T
         CqT1cg5Ua+eZzaapurHhIxQj3T0IdbUp6+p2r1syQh12+iljQ79xMKVjuiPc/viTvXhl
         Nt41mC/JVPaTJ3dAitZlb1l5zGTcmwXkx6SFmcgcy0lIlWMXlB+/H9zIkgtYNvfRzEjD
         PJVmLrOKXvwsq/vOEPRJxejQSL28K1jpbRipkCaK6TDS9pWRbOA/f2tqFdr5NXvBJfdC
         Z7Qn0PKhSYV4rt+2SwfzMYspGxCkD1RvoFZ0j+3bBx4b2hXWbhBpA86bw/9Z08p4PkQg
         T93w==
X-Gm-Message-State: AOAM533DTHuh7yG8m9EXmJ+1eUhqqorp7NEg2w/iiT60G09wRUIDJD01
        ENVZGwHd5Fv9DwxjPB8uyMUbG1yomm4=
X-Google-Smtp-Source: ABdhPJyIjUWGBOfP+ZGPI1rJL35vV1D0YVshLokYlydeMWjc6vDb/a/cW9EBWuPQ/YQXhGcFvSX+dw==
X-Received: by 2002:ab0:49e7:: with SMTP id f36mr3554772uad.110.1603850062761;
        Tue, 27 Oct 2020 18:54:22 -0700 (PDT)
Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com. [209.85.221.177])
        by smtp.gmail.com with ESMTPSA id n17sm384100uao.7.2020.10.27.18.54.21
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2020 18:54:21 -0700 (PDT)
Received: by mail-vk1-f177.google.com with SMTP id z10so836622vkn.0
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 18:54:21 -0700 (PDT)
X-Received: by 2002:a05:6122:10eb:: with SMTP id m11mr3874392vko.8.1603850060975;
 Tue, 27 Oct 2020 18:54:20 -0700 (PDT)
MIME-Version: 1.0
References: <20201016111156.26927-1-ovov@yandex-team.ru> <CA+FuTSe5szAPV0qDVU1Qa7e-XH6uO4eWELfzykOvpb0CJ0NbUA@mail.gmail.com>
 <0E7BC212-3BBA-4C68-89B9-C6DA956553AD@yandex-team.ru>
In-Reply-To: <0E7BC212-3BBA-4C68-89B9-C6DA956553AD@yandex-team.ru>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 27 Oct 2020 21:53:43 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfNZoONM3TZxpC0ND2AsiNw0K-jgjKMe0FWkS9LVG6yNA@mail.gmail.com>
Message-ID: <CA+FuTSfNZoONM3TZxpC0ND2AsiNw0K-jgjKMe0FWkS9LVG6yNA@mail.gmail.com>
Subject: Re: [PATCH net] ip6_tunnel: set inner ipproto before ip6_tnl_encap.
To:     Alexander Ovechkin <ovov@yandex-team.ru>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        vfedorenko@novek.ru, Network Development <netdev@vger.kernel.org>,
        Tom Herbert <tom@herbertland.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 5:52 PM Alexander Ovechkin <ovov@yandex-team.ru> wrote:
>
> > But it was moved on purpose to avoid setting the inner protocol to IPPROTO_MPLS. That needs to use skb->inner_protocol to further segment.
> And why do we need to avoid setting the inner protocol to IPPROTO_MPLS? Currently skb->inner_protocol is used before call of ip6_tnl_xmit.
> Can you please give example when this patch breaks MPLS segmentation?

mpls_gso_segment calls skb_mac_gso_segment on the inner packet. After
setting skb->protocol based on skb->inner_protocol.

perhaps mpls encap gso and udp tunnel gso simply cannot be enabled
together, because both use skb->inner_(ipproto|protocol) to demultiplex:

  18    163  net/ipv4/udp_offload.c <<skb_udp_tunnel_segment>>
             protocol = skb->inner_protocol;
  19     35  net/mpls/mpls_gso.c <<mpls_gso_segment>>
             skb->protocol = skb->inner_protocol;

   3    168  net/ipv4/udp_offload.c <<skb_udp_tunnel_segment>>
             ops = rcu_dereference(offloads[skb->inner_ipproto]);

Please don't top post, btw.


> > On 16 Oct 2020, at 20:55, Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Fri, Oct 16, 2020 at 7:14 AM Alexander Ovechkin <ovov@yandex-team.ru> wrote:
> >>
> >> ip6_tnl_encap assigns to proto transport protocol which
> >> encapsulates inner packet, but we must pass to set_inner_ipproto
> >> protocol of that inner packet.
> >>
> >> Calling set_inner_ipproto after ip6_tnl_encap might break gso.
> >> For example, in case of encapsulating ipv6 packet in fou6 packet, inner_ipproto
> >> would be set to IPPROTO_UDP instead of IPPROTO_IPV6. This would lead to
> >> incorrect calling sequence of gso functions:
> >> ipv6_gso_segment -> udp6_ufo_fragment -> skb_udp_tunnel_segment -> udp6_ufo_fragment
> >> instead of:
> >> ipv6_gso_segment -> udp6_ufo_fragment -> skb_udp_tunnel_segment -> ip6ip6_gso_segment
> >>
> >> Signed-off-by: Alexander Ovechkin <ovov@yandex-team.ru>
> >
> > Commit 6c11fbf97e69 ("ip6_tunnel: add MPLS transmit support") moved
> > the call from ip6_tnl_encap's caller to inside ip6_tnl_encap.
> >
> > It makes sense that that likely broke this behavior for UDP (L4) tunnels.
> >
> > But it was moved on purpose to avoid setting the inner protocol to
> > IPPROTO_MPLS. That needs to use skb->inner_protocol to further
> > segment.
> >
> > I suspect we need to set this before or after conditionally to avoid
> > breaking that use case.
>
