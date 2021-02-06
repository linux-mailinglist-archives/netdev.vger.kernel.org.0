Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCE9311BD0
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 08:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhBFHA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 02:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbhBFHAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 02:00:21 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B41EC06174A
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 22:59:41 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id m12so4823511pjs.4
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 22:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IMucpGreYgixC3DWoXEUd++VUB4K148mq98TU2GZGQg=;
        b=OV2wdWKf9qXwJujiZ1EzUk3ZSlb3mgQQxHS6Kk8HKdR91jN8Lf74sTAaEbOgBtkBNN
         RwmgPr/Il+VHCYtoUN2/B5Y706zOfn51Fiub3JFTw/bZiSbfoIAwdgznoB9mBTdXXZ1q
         qHjEfd7aRLfu9Pruc+YoVkoXIv4E9OgTPZTzcdLblzIY+NmZnao5ww2KeVkwLO5Y/Bi7
         bAjHrpF8pAaRRywrYQQ4uUUDKmcxXzC/rLmbFzfJkJ4FXbyRTo26tjJ2pXnESFtpqdju
         UWoG6smf+9v0kqdUduFpEApJVhQc13i0LP5Hedkz9v5tRrTyClRcT+RiO1R8fZY4caAY
         800Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IMucpGreYgixC3DWoXEUd++VUB4K148mq98TU2GZGQg=;
        b=AIDPL3YLcDRDYNXk9JHchnkdqPrmaizWfgdF4n2GOJmPwvEZZP/cU8eZYCVBQywNoT
         x16Jv2B0d7f9PbVcPSgOVdDMxjm6bVmEROnsydEQTjoV5EN636+d1Yg6AMCo95DZnWDr
         /VOEvZPhygg/3DfDR1soXQMwV80si5R0xOzZ/ygK76aovJF3Uq3WmQ6Fhw6go29tQK95
         P3xPh4sJJlEeen50OpacdVdKkBjEwFqm6tK1RkSJ/Ekg5+q1nAMwf8Na7GDwzpmQ/UZB
         2eDKBli34wm2mxy4V8tXjVucQB+fz2ax5r1nLTGcUHLoePGpupybhMcFkuKKEid1LjSz
         sVyw==
X-Gm-Message-State: AOAM533adMio+dhzkMcpu+GE6XJl3nnUNBQots6LEtvaGHLwazWyPqYB
        igzPQW5OcLGh8bIgc/GQRP6G7jL6mOnJI99ALgIUgQ==
X-Google-Smtp-Source: ABdhPJy2rzDn8S1RYi0VeE16OdTP4WbgdX8wtmGL0x+AWEUzyWGa4P6EpazUsiIoLftOOwHook5XT8A1ASZaTxjW2RU=
X-Received: by 2002:a17:902:c24b:b029:e1:8c46:f876 with SMTP id
 11-20020a170902c24bb02900e18c46f876mr7343353plg.15.1612594780662; Fri, 05 Feb
 2021 22:59:40 -0800 (PST)
MIME-Version: 1.0
References: <20210205230127.310521-1-arjunroy.kdev@gmail.com> <5bc63873-67e1-c3bd-116e-7b40a15d7d92@gmail.com>
In-Reply-To: <5bc63873-67e1-c3bd-116e-7b40a15d7d92@gmail.com>
From:   Arjun Roy <arjunroy@google.com>
Date:   Fri, 5 Feb 2021 22:59:29 -0800
Message-ID: <CAOFY-A1NE+975V-3Jp-iD=EgOVhcjyYXEHsGP52owVjc62xr8w@mail.gmail.com>
Subject: Re: [net] tcp: Explicitly mark reserved field in tcp_zerocopy_receive args.
To:     David Ahern <dsahern@gmail.com>
Cc:     Arjun Roy <arjunroy.kdev@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 5, 2021 at 10:57 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 2/5/21 4:01 PM, Arjun Roy wrote:
> > From: Arjun Roy <arjunroy@google.com>
> >
> > Explicitly define reserved field and require it to be 0-valued.
> >
> > Fixes: 7eeba1706eba ("tcp: Add receive timestamp support for receive zerocopy.")
> > Signed-off-by: Arjun Roy <arjunroy@google.com>
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
> > Suggested-by: David Ahern <dsahern@gmail.com>
> > Suggested-by: Leon Romanovsky <leon@kernel.org>
> > Suggested-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> >  include/uapi/linux/tcp.h | 2 +-
> >  net/ipv4/tcp.c           | 2 ++
> >  2 files changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
> > index 42fc5a640df4..8fc09e8638b3 100644
> > --- a/include/uapi/linux/tcp.h
> > +++ b/include/uapi/linux/tcp.h
> > @@ -357,6 +357,6 @@ struct tcp_zerocopy_receive {
> >       __u64 msg_control; /* ancillary data */
> >       __u64 msg_controllen;
> >       __u32 msg_flags;
> > -     /* __u32 hole;  Next we must add >1 u32 otherwise length checks fail. */
> > +     __u32 reserved; /* set to 0 for now */
> >  };
> >  #endif /* _UAPI_LINUX_TCP_H */
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index e1a17c6b473c..97aee57ab9b4 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -4159,6 +4159,8 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
> >               }
> >               if (copy_from_user(&zc, optval, len))
> >                       return -EFAULT;
> > +             if (zc.reserved)
> > +                     return -EOPNOTSUPP;
>
> usually invalid values for uapi return -EINVAL

I'll send out a v2 with that changed then.

-Arjun
