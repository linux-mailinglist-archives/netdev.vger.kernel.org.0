Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1480290B02
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 19:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390202AbgJPR4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 13:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389903AbgJPR4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 13:56:24 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53E8C061755
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 10:56:22 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id w25so1897478vsk.9
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 10:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SaoQ+PY8WdgXWfG4Tr/QI8n9nsnA3ZBVl2uXb5YE3hI=;
        b=fW3rcEBw042PWje7Uf+WZJBUg03pPhUNaGNaK8oOaFY+BZCuelxigvg/JiEl2cHQzn
         FLTq1lh8GwQaG9Do6SzDtaB6pF67cLDkdzeYGxaxN2pPfElAgpGweOrNfY7Da+fROUwb
         i7sD0bwYVpnAPeBFxWCOrUlNYglfbh6ljJgh9TaiW3MFMvU89uTz+eiGuklBHR/k7GTf
         Vf5xfAU7NAdixsSGLQcWZwQmT44J3BUX/RhJ8jMHkRvWvMImfvSW6kY7jqHzxYpG0aEh
         9N3NN9PJ6u/h04Dh/xCTodofcPMjzHujzTxOETr8T25l0LvA27zcOEE6BAR2y8n8R2Bp
         RqMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SaoQ+PY8WdgXWfG4Tr/QI8n9nsnA3ZBVl2uXb5YE3hI=;
        b=fwe6fIqAp96/PAARDveT44Qa1SDItOfRQbvmBHeLNnnjxxEtbp/aJs7KFy86Ew5zOv
         QKNc8OAQNCM/WoRDRIVLIV9K9faWgXoWXCp8D0YoWkGLxuQOg1hRiggc/PkFJMIGixOR
         Jn2E9zY/f6BAKcC7JLeMIpx8BVeMxcH7Hpsb9/6bcM/55cauf/3upfK7Omg7sKWxC4+K
         n9REPjE6W8zHdMaeKZyTYQJmHERjn0XPG7oAgWo4ubfFKflKHDtQXloEEr/2YnCSvvPM
         djuhJiYt5DKYqvWZ9pz/gJh0b+utgHMjRR3nRCZNcLaJxohCkAeZnY7p5Tmh7N9POA38
         1TaA==
X-Gm-Message-State: AOAM533RdgkW6rzc77H+KA9lrplSgh/JY8A34B7LC/ggwBGSZzahBKHt
        027vxQGA7QSbNB8QKzwpmgWztB17N1E=
X-Google-Smtp-Source: ABdhPJxJhmpc1AnrgA3R95DXrX4c40QREtYbUotqQMo/4QRhZgxChFay6DWOjOVN3utHtThhwT+xJA==
X-Received: by 2002:a05:6102:208e:: with SMTP id h14mr3272796vsr.42.1602870981660;
        Fri, 16 Oct 2020 10:56:21 -0700 (PDT)
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com. [209.85.217.54])
        by smtp.gmail.com with ESMTPSA id a64sm433738vkh.3.2020.10.16.10.56.20
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2020 10:56:20 -0700 (PDT)
Received: by mail-vs1-f54.google.com with SMTP id p25so1912414vsq.4
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 10:56:20 -0700 (PDT)
X-Received: by 2002:a67:d84:: with SMTP id 126mr2931254vsn.51.1602870980343;
 Fri, 16 Oct 2020 10:56:20 -0700 (PDT)
MIME-Version: 1.0
References: <20201016111156.26927-1-ovov@yandex-team.ru>
In-Reply-To: <20201016111156.26927-1-ovov@yandex-team.ru>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 16 Oct 2020 13:55:43 -0400
X-Gmail-Original-Message-ID: <CA+FuTSe5szAPV0qDVU1Qa7e-XH6uO4eWELfzykOvpb0CJ0NbUA@mail.gmail.com>
Message-ID: <CA+FuTSe5szAPV0qDVU1Qa7e-XH6uO4eWELfzykOvpb0CJ0NbUA@mail.gmail.com>
Subject: Re: [PATCH net] ip6_tunnel: set inner ipproto before ip6_tnl_encap.
To:     Alexander Ovechkin <ovov@yandex-team.ru>
Cc:     Network Development <netdev@vger.kernel.org>, vfedorenko@novek.ru
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 7:14 AM Alexander Ovechkin <ovov@yandex-team.ru> wrote:
>
> ip6_tnl_encap assigns to proto transport protocol which
> encapsulates inner packet, but we must pass to set_inner_ipproto
> protocol of that inner packet.
>
> Calling set_inner_ipproto after ip6_tnl_encap might break gso.
> For example, in case of encapsulating ipv6 packet in fou6 packet, inner_ipproto
> would be set to IPPROTO_UDP instead of IPPROTO_IPV6. This would lead to
> incorrect calling sequence of gso functions:
> ipv6_gso_segment -> udp6_ufo_fragment -> skb_udp_tunnel_segment -> udp6_ufo_fragment
> instead of:
> ipv6_gso_segment -> udp6_ufo_fragment -> skb_udp_tunnel_segment -> ip6ip6_gso_segment
>
> Signed-off-by: Alexander Ovechkin <ovov@yandex-team.ru>

Commit 6c11fbf97e69 ("ip6_tunnel: add MPLS transmit support") moved
the call from ip6_tnl_encap's caller to inside ip6_tnl_encap.

It makes sense that that likely broke this behavior for UDP (L4) tunnels.

But it was moved on purpose to avoid setting the inner protocol to
IPPROTO_MPLS. That needs to use skb->inner_protocol to further
segment.

I suspect we need to set this before or after conditionally to avoid
breaking that use case.
