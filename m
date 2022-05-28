Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0AE4536BE6
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 11:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbiE1J0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 05:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232653AbiE1J0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 05:26:12 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57693B04
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 02:26:11 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id b11so4583141ilr.4
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 02:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VCIqWqwe3+8Dabcqcpj0i9VeYMWqyFkqFHdKoKijX3g=;
        b=WLjZv+ebpwaGX9ZXIueaSKOWv3A26uLA8iuoe6PgvIMrwgItBeQmoGCa4q1l80LgZw
         Rlz1hlAJyTPj8z7vEQaeplFs1Q4qIP+2mHRxiXzLYOaka+fgbSg8po0Mwl3xoSGL5Of3
         jr3HnCw17acXA4eRqwqHpdbm0GOUgXcJdQCZG2zviBg7KUWKY5STnkuYPOTsmYKQcTOi
         ftDOxUB/j4Xj3oY3uYwdzeqRPB6PRrppwhYduldvDBPkcPB3hmTZbyb+RsxNvkBUG21b
         ZxCecEkP9Eo7qs+IkiYBNqUttphnAxl8Qz+9JZqiFND7MLDlO3yq9Sb5xe7dT6IfZktq
         8ulA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VCIqWqwe3+8Dabcqcpj0i9VeYMWqyFkqFHdKoKijX3g=;
        b=DLrZRiBndt1K6d6MpPhrs4aGG51q4jlfaa+lPLh0rU6P5rWFs9tsP5vC4P8zHNeYAp
         rUAwf+dcCsmUwG8gmAJGF066EYXD7XC4nJT5g/VAx1sLBskWIiRi26pnKYMYC0fiMsCR
         dERRGdc3b2CXbmIrcvh0+dEKzC9bW7SGN0rC9VIHCeOtGaM2fjFrV6Nv1ADjMFZw6efH
         uM2UuSH5Q7xPvTswfhuDqRC1w2kW9dgaabTX94a/ggljSNznCb0YqeljV8hu3Q0vyHdq
         1NG8WRTmMubyrNWsu87dJJcO9vxmqW54OZvdtl/6KJkjFwHeUmyslDixUZa3raJ9ahmY
         R8EQ==
X-Gm-Message-State: AOAM53202oO92ghgd/zPnPXlWlWkH9iVpUJ+1xP1ZGpGs2loLLCd55NF
        J94OUme7ZwKGu5ejnwTt+8XtuAfzbv4jT8Hqco2tAyoE/Ly8MW7i
X-Google-Smtp-Source: ABdhPJyXv0nsL3MmGarsyU/G+XdwzUo8s91PukT4hsQuDwz+Ioipof+jlYwXjLXdMTy7dveJEfgizRy1GHLsrSzXZ1U=
X-Received: by 2002:a05:6e02:2186:b0:2d1:b538:f5e3 with SMTP id
 j6-20020a056e02218600b002d1b538f5e3mr14502732ila.22.1653729970524; Sat, 28
 May 2022 02:26:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220518210548.2296546-1-zenczykowski@gmail.com> <20220526065115.GA680067@gauss3.secunet.de>
In-Reply-To: <20220526065115.GA680067@gauss3.secunet.de>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Sat, 28 May 2022 02:25:59 -0700
Message-ID: <CANP3RGdt2aOOK80PLcB-Q2ecz-sjyWuN+Wc8h0Kuo7RdUNGSTA@mail.gmail.com>
Subject: Re: [PATCH] xfrm: do not set IPv4 DF flag when encapsulating IPv6
 frames <= 1280 bytes.
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Lorenzo Colitti <lorenzo@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Lina Wang <lina.wang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_SPF_WL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 25, 2022 at 11:51 PM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> On Wed, May 18, 2022 at 02:05:48PM -0700, Maciej =C5=BBenczykowski wrote:
> > From: Maciej =C5=BBenczykowski <maze@google.com>
> >
> > One may want to have DF set on large packets to support discovering
> > path mtu and limiting the size of generated packets (hence not
> > setting the XFRM_STATE_NOPMTUDISC tunnel flag), while still
> > supporting networks that are incapable of carrying even minimal
> > sized IPv6 frames (post encapsulation).
> >
> > Having IPv4 Don't Frag bit set on encapsulated IPv6 frames that
> > are not larger than the minimum IPv6 mtu of 1280 isn't useful,
> > because the resulting ICMP Fragmentation Required error isn't
> > actionable (even assuming you receive it) because IPv6 will not
> > drop it's path mtu below 1280 anyway.  While the IPv4 stack
> > could prefrag the packets post encap, this requires the ICMP
> > error to be successfully delivered and causes a loss of the
> > original IPv6 frame (thus requiring a retransmit and latency
> > hit).  Luckily with IPv4 if we simply don't set the DF flag,
> > we'll just make further fragmenting the packets some other
> > router's problems.
> >
> > We'll still learn the correct IPv4 path mtu through encapsulation
> > of larger IPv6 frames.
> >
> > I'm still not convinced this patch is entirely sufficient to make
> > everything happy... but I don't see how it could possibly
> > make things worse.
> >
> > See also recent:
> >   4ff2980b6bd2 'xfrm: fix tunnel model fragmentation behavior'
> > and friends
> >
> > Bug: 203183943
> > Cc: Lorenzo Colitti <lorenzo@google.com>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Lina Wang <lina.wang@mediatek.com>
> > Cc: Steffen Klassert <steffen.klassert@secunet.com>
> > Signed-off-by: Maciej Zenczykowski <maze@google.com>
>
> Applied, thanks a lot!

Thanks.

Is this published somewhere, since I'd lack to backport it to Android
Common Kernel 5.10+, but can't find a sha1 (yet?)
