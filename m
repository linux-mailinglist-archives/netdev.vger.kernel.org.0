Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8BC5BEF5B
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 23:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbiITVsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 17:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbiITVsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 17:48:09 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7130166125
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 14:48:08 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id y9so2138167ily.11
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 14:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=LRv5VJicOfG2hhzbnXB1qlfq4+645lDnY09x1h1deok=;
        b=eWpU+sFRITLcZgbCZkhcb5/6WQaCoZg2b8A5IJolrc/HzY4mnw+t+6BjDL6Da+0od1
         mj0RKqSa3tTk00tu5XR3tR8iq3Xao0j3ChxJQmv96F4IerYrF4nAX1/VpVzwpVLYUbJ2
         pISOROlbsRyvuz2PY1TsfeRVPHf1weeDAYAxWUijMjQ2secBVOPYop7xiW4yHcgWYmcj
         8xzkzqbYwPiw5l9DhLQinNOZYRW3BPZiifPq2UBmtqxTvDQzgQiEFtX0EpfvWcIZ5umE
         IJvFc1JANup0j9NfUk++fsjkMQb3SGlb+uyf1FIOlryj7uGjJsJSV06MCPLVXQMg37GE
         l8zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=LRv5VJicOfG2hhzbnXB1qlfq4+645lDnY09x1h1deok=;
        b=JItVMydgsKKqxRV3t61DjxxqTIIMdxic1TsKy6g3e26LcORSYw5ddRjH2ebF74C1YW
         LgKDmdVceZ5+MZp7/6vRFunBP4kNBzEwwKqYFYUroBJphy9DjHqR5q2RPVVnKX5eQK7x
         /Kp5qLdXKvMYy4gsNdlgzEJLBt571D7Z2bea9fzG3qV8R4mTcZilfxrtYYvKJKrM6hdl
         pku30Y6lXg+tSckVq4z5hrwWrvWcbwzGlSBL6gS9GgkHKYrvDKOjocmNksj93DS46L6e
         2DnKM7xT7OQnE9P7pukY2NnkB4HtNcosSMqj8Yg6O4x/eZ8mIi4rsPCRqCmEMg+uT5OA
         KsCQ==
X-Gm-Message-State: ACrzQf1+P5GtuJwBsVPY7W0kff5HROmlK7VjnUw7Cr4jhSN8WndQnQue
        bFau3VswLUWZPeoYoSGH3TgiV8RO/KivnbSxhGoucA==
X-Google-Smtp-Source: AMsMyM74sIwLWX/cPM5KCUsSxUvMUa6agvDykwQZxg/YcNH6iSj2af4Ep00uC74mSv0XOv4qRvkZ4+Kg8fUEtmlMXBw=
X-Received: by 2002:a05:6e02:19ce:b0:2f1:68a6:3bec with SMTP id
 r14-20020a056e0219ce00b002f168a63becmr10967993ill.78.1663710487631; Tue, 20
 Sep 2022 14:48:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220920083621.18219c3d@hermes.local> <20220920194825.31820-1-prohr@google.com>
In-Reply-To: <20220920194825.31820-1-prohr@google.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Tue, 20 Sep 2022 14:47:54 -0700
Message-ID: <CANP3RGewDp-ofCi72zskEZ2VjXotQR+C=aiVSt1=a=cL9Xd1=Q@mail.gmail.com>
Subject: Re: [PATCH v2] tun: support not enabling carrier in TUNSETIFF
To:     Patrick Rohr <prohr@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>, Lorenzo Colitti <lorenzo@google.com>,
        Jason Wang <jasowang@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
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

On Tue, Sep 20, 2022 at 12:48 PM Patrick Rohr <prohr@google.com> wrote:
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
> Signed-off-by: Patrick Rohr <prohr@google.com>
> Cc: Maciej =C5=BBenczykowski <maze@google.com>
> Cc: Lorenzo Colitti <lorenzo@google.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Stephen Hemminger <stephen@networkplumber.org>
> Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
>  drivers/net/tun.c           | 9 ++++++---
>  include/uapi/linux/if_tun.h | 2 ++
>  2 files changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 259b2b84b2b3..db736b944016 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -2828,7 +2828,10 @@ static int tun_set_iff(struct net *net, struct fil=
e *file, struct ifreq *ifr)
>                 rcu_assign_pointer(tfile->tun, tun);
>         }
>
> -       netif_carrier_on(tun->dev);
> +       if (ifr->ifr_flags & IFF_NO_CARRIER)
> +               netif_carrier_off(tun->dev);
> +       else
> +               netif_carrier_on(tun->dev);
>
>         /* Make sure persistent devices do not get stuck in
>          * xoff state.
> @@ -3056,8 +3059,8 @@ static long __tun_chr_ioctl(struct file *file, unsi=
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
> index 2ec07de1d73b..b6d7b868f290 100644
> --- a/include/uapi/linux/if_tun.h
> +++ b/include/uapi/linux/if_tun.h
> @@ -67,6 +67,8 @@
>  #define IFF_TAP                0x0002
>  #define IFF_NAPI       0x0010
>  #define IFF_NAPI_FRAGS 0x0020
> +/* Used in TUNSETIFF to bring up tun/tap without carrier */
> +#define IFF_NO_CARRIER 0x0040
>  #define IFF_NO_PI      0x1000
>  /* This flag has no real effect */
>  #define IFF_ONE_QUEUE  0x2000
> --
> 2.37.3.968.ga6b4b080e4-goog

Reviewed-by: Maciej =C5=BBenczykowski <maze@google.com>

Ideally we'd get this into LTS trees as well, but I'm failing to think
of an appropriate Fixes tag to make that automatically just happen...
since this isn't really a fix per-say...

So I guess we'll have to either request stable@ to pull it into LTS,
or manually cherrypick into all Android Common Kernel trees (4.14+ I
guess).

Additionally, we talked this over in person, and it appears that
storing the IFF_NO_CARRIER in tun->ifr.ifr_flags is a non-issue,
because this field is only ever used from tun_net_init() where it gets
masked out anyway.
That said, the existence of the tun->ifr field seems like unnecessary
complexity and we should probably refactor this out afterwards.
