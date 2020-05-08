Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127DD1CB502
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 18:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgEHQcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 12:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726767AbgEHQcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 12:32:09 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688DFC061A0C
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 09:32:09 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id h26so1898176lfg.6
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 09:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+chJwT9WOsYaCIfHDXL7LdOBvpGtCOGdtDOQ6Xwe5qM=;
        b=dOqcUoOz0+wGOjYc2mjQlxFLuEMWdU8GlxZJvJ7sqJW6u56dKqsVCD2YySZAbTqm3G
         l+uEzTkW+4i8Wxc4vHi1u1vQ5/LI1ZeKr/0m24OWc9q0JDcy+ZIvyFh9fCUo4ZzcVR6/
         WbMML4Kj0rsD4oayo4Vvf4NPmSHjX6dJcKialHTe6cEZGS2RXdyrrwFG/qv29cLJ+CYM
         IvlSYCdRqOTt06S2cfqoP6AoulqJ2IEMciPQgqVjdM2mpGa+2C6+3mrGf5kk0X0rH8cZ
         16xYUg6jpuP5Hxx2CDqYP10ehRHDGfgpIeiaS/iXXqp9lFyuVyQA1VChRzLyOSEeNzaF
         MzqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+chJwT9WOsYaCIfHDXL7LdOBvpGtCOGdtDOQ6Xwe5qM=;
        b=TzIOIsMNWN3jhlX7scieBfsStOZpOQDFyRDBqkS2QKuTZXaZiW16GWzojn/GrdCjE+
         8HqE4w8oHBooMfOOF/CW/zlJc2nio+R6ZPkO8Er3U1sWQsLIXj12HFumpZxX8Rk1tjD+
         DSkg9DkI0rLlimuWZwpC2ssergy01wlZgwuAOnZd8ZhDS7OdVqU96DLSjio0rs8QcK2v
         zi0tHkyp2J8SFKjORLfUfKidSCN9z7lcxrdcqG968bLGySH8Tt2PSn0RINGRAT/d/XQ3
         bWmJjO2ZZf7eha6ptkkqcwSM9z5TK9pF4nKaGiRfOI0L7tJFi3Wp0yAcD10Khxvm0UW7
         Gp8A==
X-Gm-Message-State: AOAM531qTApeYW+qxqpg5q4I62rGp6fkvgHs7xkuaAKhtgAsmFMEfYUH
        aSSlqhJLQU9DF1W5wQT31sc0oqC3mjaiIGy3yHxwuDuD
X-Google-Smtp-Source: ABdhPJz2KPE3os8OikKA4HP+YvI8Rk+mw/dfwoK+OoW7Fgc+/UEhJKxPVRuRoqU2UXUZigScjZxr2EDGAeRMK6xC0wQ=
X-Received: by 2002:ac2:5215:: with SMTP id a21mr2414917lfl.13.1588955527500;
 Fri, 08 May 2020 09:32:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200508143414.42022-1-edumazet@google.com>
In-Reply-To: <20200508143414.42022-1-edumazet@google.com>
From:   Wei Wang <weiwan@google.com>
Date:   Fri, 8 May 2020 09:31:55 -0700
Message-ID: <CAEA6p_DvwnM+sFqmDN04_QSMz8qHPZJb-PbG0C4WP=Zg0BU2Kw@mail.gmail.com>
Subject: Re: [PATCH net-next] ipv6: use DST_NOCOUNT in ip6_rt_pcpu_alloc()
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Ahern <dsahern@kernel.org>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 8, 2020 at 7:34 AM Eric Dumazet <edumazet@google.com> wrote:
>
> We currently have to adjust ipv6 route gc_thresh/max_size depending
> on number of cpus on a server, this makes very little sense.
>
> If the kernels sets /proc/sys/net/ipv6/route/gc_thresh to 1024
> and /proc/sys/net/ipv6/route/max_size to 4096, then we better
> not track the percpu dst that our implementation uses.
>
> Only routes not added (directly or indirectly) by the admin
> should be tracked and limited.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Wei Wang <weiwan@google.com>
> Cc: Maciej =C5=BBenczykowski <maze@google.com>
> ---


Acked-by: Wei Wang <weiwan@google.com>

>
>  net/ipv6/route.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index a9072dba00f4fb0b61bce1fc0f44a3a81ba702fa..4292653af533bb641ae8571ff=
fe45b39327d0380 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -1377,7 +1377,7 @@ static struct rt6_info *ip6_rt_pcpu_alloc(const str=
uct fib6_result *res)
>
>         rcu_read_lock();
>         dev =3D ip6_rt_get_dev_rcu(res);
> -       pcpu_rt =3D ip6_dst_alloc(dev_net(dev), dev, flags);
> +       pcpu_rt =3D ip6_dst_alloc(dev_net(dev), dev, flags | DST_NOCOUNT)=
;
>         rcu_read_unlock();
>         if (!pcpu_rt) {
>                 fib6_info_release(f6i);
> --
> 2.26.2.645.ge9eca65c58-goog
>
