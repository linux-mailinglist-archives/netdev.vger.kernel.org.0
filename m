Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C73995BB4D3
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 01:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiIPXyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 19:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiIPXyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 19:54:32 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84E721BF
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 16:54:30 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id a9so12167308ilh.1
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 16:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=vLDV83nrcX4WOatBQ4JfxQ1weDRf6tO3vUZi3Xcqk6s=;
        b=K+Wp0+/XjN4WIzaYgwHTOQcfl/MrhGaqNjFo/cIdiRo9EuNUZfyFODn2FzibD0QenZ
         l7MjU6hhmFMPEhpTS0lJvtte2b6KHKFPUbp6cBwPBgydygCjV/FwTBPwK+OddVgtk5eI
         ydTMMm+PhMSX5kWcQU7asEJ3VOaSyr0X/emFQiaDT+TNHXIZBkDB8oBHa0mqGkas+z7t
         2Ooqhf8H04LQgAvARH84p2MGmGiOCnY3nUOK9/zC+1Ljjp9Ia9V0lqddqyp8vQWEhS4Y
         XvWP9HGySP0ZQGTr/+tpxfkkIcB3Vxy4EkLZo2KWA+irwwmb27CicYDQwK2CSnTmVa06
         herg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=vLDV83nrcX4WOatBQ4JfxQ1weDRf6tO3vUZi3Xcqk6s=;
        b=A+X+v4u1wU77komkf5rKl6DHlCx6nDNyyHYkNDk6sdjymHXj4ZVg8wDuc6G3YaG4xO
         itaLwARluqEgYOrcUlu2HVcduyDfd3yDXMXE+JQDO6QqGXYr88YZaL0qL45geq6QpAFl
         dgITX+Rbq5L5r18pKlTiuC0l0iDtE070ftqgVqZLy1f+yQZrhMZj9y1lHwVDaga3X8M8
         TmK2slOjNM6m8M2FAH145Wg9soJ5dctdkiAAPjjio9n10afViDzIHSkK8/aLjkqg3wfu
         MqCuCIoFTqVJjG95eGEu5dhy8quqSbsoDKUOCS1VZDS7Ls+Tzo77E5CGECS+htSaBDbW
         4k8w==
X-Gm-Message-State: ACrzQf10QC5cmqm4AJFb1kXG3UYJG8EX2nuBHZaLQfbTzdaC4qbnTy3N
        Cf486eT8E83fL9W171ak/fUFLTWlrbknByNudXde9uzUGA9wug==
X-Google-Smtp-Source: AMsMyM4tdr03HhXnfLKK7RPWl9hm3MY6+ez+4ujvmUYaxzDySDMuB7YcZjTPqRM1kuuzuQ8RKtM5lo0y4F1mZzOaQ1M=
X-Received: by 2002:a05:6e02:148a:b0:2f3:4e57:f689 with SMTP id
 n10-20020a056e02148a00b002f34e57f689mr3062007ilk.85.1663372470013; Fri, 16
 Sep 2022 16:54:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220916234552.3388360-1-prohr@google.com>
In-Reply-To: <20220916234552.3388360-1-prohr@google.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Fri, 16 Sep 2022 16:54:17 -0700
Message-ID: <CANP3RGcvHH2WyQ7KtVoJ+LDLPH7kPx4DdxUTkq_8YciLQjBO3Q@mail.gmail.com>
Subject: Re: [PATCH] tun: support not enabling carrier in TUNSETIFF
To:     Patrick Rohr <prohr@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>, Lorenzo Colitti <lorenzo@google.com>,
        Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 16, 2022 at 4:46 PM Patrick Rohr <prohr@google.com> wrote:
>
> This change adds support for not enabling carrier during TUNSETIFF
> interface creation by specifying the IFF_NO_CARRIER flag.
>
> Our tests make heavy use of tun interfaces. In some scenarios, the test
> process creates the interface but another process brings it up after the
> interface is discovered via netlink notification. In that case, it is
> not possible to create a tun/tap interface with carrier off without it
> racing against the bring up. Immediately setting carrier off via
> TUNSETCARRIER is still too late.
>
> Since ifr_flags is only a short, the value for IFF_DETACH_QUEUE is
> reused for IFF_NO_CARRIER. IFF_DETACH_QUEUE has currently no meaning in
> TUNSETIFF.
>
> Signed-off-by: Patrick Rohr <prohr@google.com>
> Cc: Maciej =C5=BBenczykowski <maze@google.com>
> Cc: Lorenzo Colitti <lorenzo@google.com>
> Cc: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/net/tun.c           | 15 ++++++++++++---
>  include/uapi/linux/if_tun.h |  2 ++
>  2 files changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 259b2b84b2b3..502f56095650 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -2709,6 +2709,12 @@ static int tun_set_iff(struct net *net, struct fil=
e *file, struct ifreq *ifr)
>         struct net_device *dev;
>         int err;
>
> +       /* Do not save the IFF_NO_CARRIER flag as it uses the same value =
as
> +        * IFF_DETACH_QUEUE.
> +        */
> +       bool no_carrier =3D ifr->ifr_flags & IFF_NO_CARRIER;
> +       ifr->ifr_flags &=3D ~IFF_NO_CARRIER;
> +
>         if (tfile->detached)
>                 return -EINVAL;
>
> @@ -2828,7 +2834,10 @@ static int tun_set_iff(struct net *net, struct fil=
e *file, struct ifreq *ifr)
>                 rcu_assign_pointer(tfile->tun, tun);
>         }
>
> -       netif_carrier_on(tun->dev);
> +       if (no_carrier)
> +               netif_carrier_off(tun->dev);
> +       else
> +               netif_carrier_on(tun->dev);
>
>         /* Make sure persistent devices do not get stuck in
>          * xoff state.
> @@ -3056,8 +3065,8 @@ static long __tun_chr_ioctl(struct file *file, unsi=
gned int cmd,
>                  * This is needed because we never checked for invalid fl=
ags on
>                  * TUNSETIFF.
>                  */
> -               return put_user(IFF_TUN | IFF_TAP | TUN_FEATURES,
> -                               (unsigned int __user*)argp);
> +               return put_user(IFF_TUN | IFF_TAP | IFF_NO_CARRIER |
> +                               TUN_FEATURES, (unsigned int __user*)argp)=
;
>         } else if (cmd =3D=3D TUNSETQUEUE) {
>                 return tun_set_queue(file, &ifr);
>         } else if (cmd =3D=3D SIOCGSKNS) {
> diff --git a/include/uapi/linux/if_tun.h b/include/uapi/linux/if_tun.h
> index 2ec07de1d73b..12dde91957a5 100644
> --- a/include/uapi/linux/if_tun.h
> +++ b/include/uapi/linux/if_tun.h
> @@ -75,6 +75,8 @@
>  #define IFF_MULTI_QUEUE 0x0100
>  #define IFF_ATTACH_QUEUE 0x0200
>  #define IFF_DETACH_QUEUE 0x0400
> +/* Used in TUNSETIFF to bring up tun/tap without carrier */
> +#define IFF_NO_CARRIER IFF_DETACH_QUEUE
>  /* read-only flag */
>  #define IFF_PERSIST    0x0800
>  #define IFF_NOFILTER   0x1000
> --
> 2.37.3.968.ga6b4b080e4-goog

Reviewed-by: Maciej =C5=BBenczykowski <maze@google.com>
