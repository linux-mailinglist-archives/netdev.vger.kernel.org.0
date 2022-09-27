Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46EDA5EC12D
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 13:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbiI0LZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 07:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbiI0LZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 07:25:31 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6B9DCCD3
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 04:23:42 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id n83so11470382oif.11
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 04:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Ptj4K7elJYJEC7rm4kDcuNdHODe1p7cGdh2w5mcF+qY=;
        b=EszomKr/yjq68/qyms5eY53nhctGp/zrP5YK+lF7uSEuBL61XHu3oCmsrIALWj8CeO
         DnTkQp8cLT1BNnj1bbpbnXzJuygi6En8UhcT3VtG5eT0zOZ8L04g4TnOiqnDi2WLAyix
         pBZSrQ5JQlJplDUBSscKpOrivMI6K+0uUfo0oxiRWrm2RPK4AtUh7btjcpn4/CdMnnc1
         99rCRFpl0IA7yggIE+NJDwjSSb6nb2g8xywyTBpfvGCYZBuMesCeCyRkRSW3VG7Qp+nz
         rqIZXvXLWyo61w1uPdKajcNmkVY9t2fCYzKQaTVCzlFicMdfgCBxJOIjfJM4L33PDuWq
         8u6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Ptj4K7elJYJEC7rm4kDcuNdHODe1p7cGdh2w5mcF+qY=;
        b=UPaagYEACDHcBlPTnEOxUI5xgwHfHiUKxwdxw/7iQFqyY41kPhW5phq5mqXWq0gx3F
         VDseLgU5poDjWTgxSngULxvSLhaflqnPMjSy1V+tvQNdnwj63Z6ch8NeLgILoaRGB3Y1
         JWv5Emx/P3+Bpu5WoncBAd3sSKx+ajB3/5r52TSpOfX26i4jrFP77BWSjGlZBfTsHmnL
         kaCRcCbSHph8wYhj1BRo584hPhumHBXfFsvBjL0IZMkth6JJWozVVpA0LbDhpcssxd2W
         otK5gwXG8rhs/WjreRLlq5ELZ3r0cLR3qLIOgvhgvJUeGmVfiHHgTHTHwy8NppY0qQJu
         Nj3A==
X-Gm-Message-State: ACrzQf2mHaFavP/sLNOODvLGuWa6tEhQJEAMpMsbl5Okxai38KWw2Kni
        OW82MOgMUgyVM+l1SpACPBY13BbjKq2oAUHc7qOJfA==
X-Google-Smtp-Source: AMsMyM5YoZjpacyWWVpadqmKtZIzpELnFYB2CWIdbic/gFcPxN5PH1gXIE8R5MBEJnQi8yzfO5Kr24If6+DYa+iZumg=
X-Received: by 2002:a05:6808:148d:b0:350:7858:63ce with SMTP id
 e13-20020a056808148d00b00350785863cemr1535344oiw.106.1664277821441; Tue, 27
 Sep 2022 04:23:41 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000a96c0b05e97f0444@google.com> <CAM0EoMnJ=STtk5BnZ9oJtnkXY2Q+Px2cKa4gowFRGpp40UNKww@mail.gmail.com>
 <CAM0EoMm9uBQQepMb5bda1vR-Okw-tPp2nnf6TvfA0FzPu_D_2A@mail.gmail.com>
 <CANn89i+4pgJe8M1cjLF6SkqG1Yp6e+5J2xEkMdSChiVYKMC09g@mail.gmail.com>
 <CAM0EoMkLdOUQ3yrBuYsLdZvqniZ_r0VoACzOzKCo1VVzYeyPbw@mail.gmail.com>
 <CAM0EoMmr8trH0EOtOfvTpYiTq1tt7RUamf1u_R0+USOU_gYUVg@mail.gmail.com>
 <CANn89i+6NpmCyGdicmv+BiQqhUZ71TfN+P4=9NGpV4GxOba1Cw@mail.gmail.com> <202209251935.0469930C@keescook>
In-Reply-To: <202209251935.0469930C@keescook>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Tue, 27 Sep 2022 07:23:29 -0400
Message-ID: <CAM0EoMm91Gmt6M7AVqp+OKvTH0Y0vCxQzpLndhwHzE-tke7J3g@mail.gmail.com>
Subject: Re: [syzbot] WARNING in u32_change
To:     Kees Cook <keescook@chromium.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        syzbot <syzbot+a2c4601efc75848ba321@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do you want to submit that patch then?
FWIW, I could not recreate what syzbot saw even after setting
CONFIG_FORTIFY_SOURCE=y

cheers,
jamal

On Sun, Sep 25, 2022 at 10:39 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Sun, Sep 25, 2022 at 10:34:37AM -0700, Eric Dumazet wrote:
> > Sure, please look at:
> >
> > commit 54d9469bc515dc5fcbc20eecbe19cea868b70d68
> > Author: Kees Cook <keescook@chromium.org>
> > Date:   Thu Jun 24 15:39:26 2021 -0700
> >
> >     fortify: Add run-time WARN for cross-field memcpy()
> > [...]
> > Here, we might switch to unsafe_memcpy() instead of memcpy()
>
> I would tend to agree. Something like:
>
> diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
> index 4d27300c287c..21e0e6206ecc 100644
> --- a/net/sched/cls_u32.c
> +++ b/net/sched/cls_u32.c
> @@ -1040,7 +1040,9 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
>         }
>  #endif
>
> -       memcpy(&n->sel, s, sel_size);
> +       unsafe_memcpy(&n->sel, s, sel_size,
> +                     /* A composite flex-array structure destination,
> +                      * which was correctly sized and allocated above. */);
>         RCU_INIT_POINTER(n->ht_up, ht);
>         n->handle = handle;
>         n->fshift = s->hmask ? ffs(ntohl(s->hmask)) - 1 : 0;
>
> This alloc/partial-copy pattern is relatively common in the kernel, so
> I've been considering adding a helper for it. It'd be like kmemdup(),
> but more like kmemdup_offset(), which only the object from a certainly
> point is copied.
>
> --
> Kees Cook
