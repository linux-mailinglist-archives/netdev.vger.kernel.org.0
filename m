Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1E8A14A76B
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 16:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729654AbgA0Ple (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 10:41:34 -0500
Received: from mail-yw1-f46.google.com ([209.85.161.46]:42885 "EHLO
        mail-yw1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729536AbgA0Ple (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 10:41:34 -0500
Received: by mail-yw1-f46.google.com with SMTP id b81so2710341ywe.9
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 07:41:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YDRS4NAt8vd1pqf0SAl2NO1AqofC2JgvebZS5AXriZI=;
        b=I79dfZqTt5NUdrojUxikbobi0WnbXUXJfkMJq+dZapdFkYrGAQEqa/jksCL4VRxEux
         sAMkLtDpAZKE487BJx0sFm5PyXBkhRlfBLEMMEVU8EPt+TX0WHgvOVkwp+3kFE8r3fHa
         kPP0gEz17wlrxF/aJi6omb0hmsEnyv0kqz1wepjcDI4F6iKGJPZkQJ2sRuN/CM4OGAMN
         GyxnXXCqszPmA1NYCIjTQ42nAEWyBK6/a48OJEqLv8ZZzUYRKwep4jv2HCo6+WgkWDCo
         EWiFGFTKMPm/Vs03xbmMNavTUeF37K6TLaNEpSXQowC6yVXkIYLKo4vAXyVwuosIojgL
         i/Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YDRS4NAt8vd1pqf0SAl2NO1AqofC2JgvebZS5AXriZI=;
        b=WTU1Kg9c6Jnwr5VniDcYM5XUOuMH9Rno2j3WMr92ISAYyVljF3RyJgAAo21MxqROoH
         mX0lMZb/EBzyhP1kQ+t4Dy8owq7/K7OCUKAnuiZ5u0sorS/yn8W+B0aLynKDFGSfsAvX
         l70rI+kH2MPIQeIDaEtcqnZkQCNLZqenzoQsivQbgDNyT6v7Bghauo81qd1gQ+PIFVdM
         xeTvEI+FemBoCuGKRxUFbOLmuBNm9fL4b02+z3KAoLOkGH8Uv6d8I1zfncXYjoZxiIGs
         7mG0DQ1EbKlboip2z/zeH+2N+ftKA8aZDvSpCBqZPnvlB50O6KBPilmJUjhyT/GGnvi0
         AVbQ==
X-Gm-Message-State: APjAAAVBwu+4wo90MHKnbVhGF4+Hvtz4AFuefNORrZRxpSwvhrGpymCe
        AVd0OgcA9ag++XcHFBGG1sYWsvtB
X-Google-Smtp-Source: APXvYqxE3VfwaCM8UcMoEGeVC+Aoca92fIUdGQvAyq5KEfoO5R0oa1yQnKdZoa6i2AgmOV9bi1kRyA==
X-Received: by 2002:a0d:dd13:: with SMTP id g19mr12348364ywe.129.1580139693185;
        Mon, 27 Jan 2020 07:41:33 -0800 (PST)
Received: from mail-yw1-f47.google.com (mail-yw1-f47.google.com. [209.85.161.47])
        by smtp.gmail.com with ESMTPSA id n1sm6770103ywe.78.2020.01.27.07.41.32
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2020 07:41:32 -0800 (PST)
Received: by mail-yw1-f47.google.com with SMTP id v126so4891248ywc.10
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 07:41:32 -0800 (PST)
X-Received: by 2002:a0d:dfc5:: with SMTP id i188mr12847001ywe.172.1580139691691;
 Mon, 27 Jan 2020 07:41:31 -0800 (PST)
MIME-Version: 1.0
References: <20200127152411.15914-1-Jason@zx2c4.com>
In-Reply-To: <20200127152411.15914-1-Jason@zx2c4.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 27 Jan 2020 10:40:55 -0500
X-Gmail-Original-Message-ID: <CA+FuTSecc8ZzNL+8RvYUj4n_iTWCy4-vV46eCWtsHenT9u96QQ@mail.gmail.com>
Message-ID: <CA+FuTSecc8ZzNL+8RvYUj4n_iTWCy4-vV46eCWtsHenT9u96QQ@mail.gmail.com>
Subject: Re: [RFC] net: add gro frag support to udp tunnel api
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 27, 2020 at 10:25 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Steffen,
>
> This is very much a "RFC", in that the code here is fodder for
> discussion more than something I'm seriously proposing at the moment.
> I'm writing to you specifically because I recall us having discussed
> something like this a while ago and you being interested.
>
> WireGuard would benefit from getting lists of SKBs all together in a
> bunch on the receive side. At the moment, encap_rcv splits them apart
> one by one before giving them to the API. This patch proposes a way to
> opt-in to receiving them before they've been split. The solution
> involves adding an encap_type flag that enables calling the encap_rcv
> function earlier before the skbs have been split apart.
>
> I worry that it's not this straight forward, however, because of this
> function below called, "udp_unexpected_gso". It looks like there's a
> fast path for the case when it doesn't need to be split apart, and that
> if it is already split apart, that's expected, whereas splitting it
> apart would be "unexpected." I'm not too familiar with this code. Do you
> know off hand why this would be unexpected?

This is for delivery to local sockets.

UDP GRO packets need to be split back up before delivery, unless the
socket has set socket option UDP_GRO.

This is checked in the GRO layer by checking udp_sk(sk)->gro_enabled.

There is a race condition between this check and the packet arriving
at the socket. Hence the unexpected.

Note that UDP GSO can take two forms, the fraglist approach by Steffen
or the earlier implementation that builds a single skb with frags.

>  static int udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
>  {
> +       int (*encap_rcv_gro)(struct sock *sk, struct sk_buff *skb);
>         struct sk_buff *next, *segs;
>         int ret;
>
> +       if (static_branch_unlikely(&udp_encap_needed_key) &&
> +           up->encap_type & UDP_ENCAP_SUPPORT_GRO_FRAGS &&
> +           (encap_rcv_gro = READ_ONCE(up->encap_rcv))) {
> +               //XXX: deal with checksum?
> +               ret = encap_rcv(sk, skb);
> +               if (ret <= 0) //XXX: deal with incrementing udp error stats?
> +                       return -ret;
> +       }

I think it'll be sufficient to just set optionally
udp_sk(sk)->gro_enabled on encap sockets and let it takes the default
path, below?

> +
>         if (likely(!udp_unexpected_gso(sk, skb)))
>                 return udp_queue_rcv_one_skb(sk, skb);
>
> --
> 2.24.1
>
