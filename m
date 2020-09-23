Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A82B27500F
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 06:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgIWEqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 00:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbgIWEqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 00:46:34 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54D2C061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 21:46:34 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id t12so19553883ilh.3
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 21:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ulI5qxFqTka4MOw4nshJNvRiW8jBuPa+dt9ToQRATHU=;
        b=JEoBZ8FY8dqPXybezw+QpM1tagoB04gcNP4rZiD3Tdna8B9/IsEfhpGy00NiL2/BYo
         6H1ZM8OC+Mslh+P0NNU7+PzWrYQJe63ZEjYLgULtW6RCKoXVYDWavDLcQ4txFyMbyRbK
         Pf5Wo+CsgmcE8l5gy1dM1q+CmYGzED/wxYINfpH3YOOWW24jaOfFXT8Zkx28aNXxaINJ
         /1sVlyR8xGYXWA7z/z9jRFWp9U5AJtABf7qEjr2mDYeolfFa1ZaN6GK5RT+2WdZ/rhbL
         Wn6DfIpqX3wGS+Q/jlY3st6M4S4yutPqTvpe49HxmXo1ZPozXC6XjGDTDaYStVgSo5mh
         vpHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ulI5qxFqTka4MOw4nshJNvRiW8jBuPa+dt9ToQRATHU=;
        b=RYFJzFaNxlqJarG1xLr4hmUJa/joawH4WoiJnX2LgKV4zz+ko+XQSVlz1EAfPmVnVI
         mA7b1Zz8eVXIuFLJuYgLKGGstomLwBnZVG5Or6ImwMbwASBT5ID4/5xrTfNO8N4do9Iu
         6suMAhU649qfLYg1w22vdRyTFh3XS8VfXFVYDqHWACKbcBvqnzZGiC0UCw7NwMsNuLEw
         Vcggv5eDM5wye528X2HV4qwYfQMz+fo7xG/IcxmZBWUWANDjvXo4RodHr4DpgjrdE037
         faKmdFLhUX4Er4fhR6roWJsc7w0N12ioZh9+UmRkHvJHXfHVpBC3MwDeGwyRQ49PmH0s
         U9cQ==
X-Gm-Message-State: AOAM530DwULTRwGI3qZMNNNcZyAzvbH7OwTKe/T57RdW5435zWXfrsKQ
        LIiBXUO18qwz/fkJM7VqF18A4607Szaf5LmwDFQLX74R82U=
X-Google-Smtp-Source: ABdhPJyc5oqk2HU723FKsR9gAtXF+5pVRSm5TBXQHWJfvu4wbZ9S15SO1DJfv2mudJ/1vRxSBUg0EaEmy6P4dvNJuZo=
X-Received: by 2002:a92:8b0e:: with SMTP id i14mr7264181ild.28.1600836393790;
 Tue, 22 Sep 2020 21:46:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200923044059.3442423-1-zenczykowski@gmail.com>
In-Reply-To: <20200923044059.3442423-1-zenczykowski@gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Tue, 22 Sep 2020 21:46:22 -0700
Message-ID: <CANP3RGcTy5MyAyChUh7pTma60aLcBmOV4kKjh_OnGtBZag-gbg@mail.gmail.com>
Subject: Re: [PATCH] net/ipv4: always honour route mtu during forwarding
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        Sunmeet Gill <sgill@quicinc.com>,
        Vinay Paradkar <vparadka@qti.qualcomm.com>,
        Tyler Wear <twear@quicinc.com>,
        David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 9:41 PM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
>
> From: Maciej =C5=BBenczykowski <maze@google.com>
>
> Documentation/networking/ip-sysctl.txt:46 says:
>   ip_forward_use_pmtu - BOOLEAN
>     By default we don't trust protocol path MTUs while forwarding
>     because they could be easily forged and can lead to unwanted
>     fragmentation by the router.
>     You only need to enable this if you have user-space software
>     which tries to discover path mtus by itself and depends on the
>     kernel honoring this information. This is normally not the case.
>     Default: 0 (disabled)
>     Possible values:
>     0 - disabled
>     1 - enabled
>
> Which makes it pretty clear that setting it to 1 is a potential
> security/safety/DoS issue, and yet it is entirely reasonable to want
> forwarded traffic to honour explicitly administrator configured
> route mtus (instead of defaulting to device mtu).
>
> Indeed, I can't think of a single reason why you wouldn't want to.
> Since you configured a route mtu you probably know better...
>
> It is pretty common to have a higher device mtu to allow receiving
> large (jumbo) frames, while having some routes via that interface
> (potentially including the default route to the internet) specify
> a lower mtu.
>
> Note that ipv6 forwarding uses device mtu unless the route is locked
> (in which case it will use the route mtu).
>
> This approach is not usable for IPv4 where an 'mtu lock' on a route
> also has the side effect of disabling TCP path mtu discovery via
> disabling the IPv4 DF (don't frag) bit on all outgoing frames.
>
> I'm not aware of a way to lock a route from an IPv6 RA, so that also
> potentially seems wrong.
>
> Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
> Cc: Eric Dumazet <maze@google.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Lorenzo Colitti <lorenzo@google.com>
> Cc: Sunmeet Gill (Sunny) <sgill@quicinc.com>
> Cc: Vinay Paradkar <vparadka@qti.qualcomm.com>
> Cc: Tyler Wear <twear@quicinc.com>
> Cc: David Ahern <dsahern@kernel.org>
> ---
>  include/net/ip.h | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/include/net/ip.h b/include/net/ip.h
> index b09c48d862cc..1262011d00b8 100644
> --- a/include/net/ip.h
> +++ b/include/net/ip.h
> @@ -442,6 +442,10 @@ static inline unsigned int ip_dst_mtu_maybe_forward(=
const struct dst_entry *dst,
>             !forwarding)
>                 return dst_mtu(dst);
>
> +       /* 'forwarding =3D true' case should always honour route mtu */
> +       unsigned int mtu =3D dst_metric_raw(dst, RTAX_MTU);
> +       if (mtu) return mtu;
> +
>         return min(READ_ONCE(dst->dev->mtu), IP_MAX_MTU);
>  }
>
> --
> 2.28.0.681.g6f77f65b4e-goog

Eh, what I get for last minute removal of 'if (forwarding) {}' wrapper.
