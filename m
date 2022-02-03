Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E684A7EB9
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 05:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349271AbiBCEpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 23:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiBCEpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 23:45:35 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55754C061714
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 20:45:35 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id 124so4618406ybw.6
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 20:45:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xeou+FH+74ou+aJTOHpTFVOr1dchRSfxjy2FcSVoqsM=;
        b=FUHald4sLT6Z9zw8EZSR+9fgEkeo5vFtK9VdZ/SDtDrqjqwVTMiQsx+wIXvg+/PknY
         XW3jN438Rc0MbWeeuhQR02Jh1vFh9WGAnzsKYIztw10c7yqeO+FKXahvc48HD0X8rFPx
         xg5ead8Hxk3WHl6x55xJDo+FGSVZoIk/6/bWIR8IqLpLIcI2rExq70L7C38aTTi0UMSA
         9o3Mu27ydQc/UP7OHn6f0rIw8heEqlzcsmZoOM61F1GdxQwbXuXdkltnfYMQNFKDusil
         LKMaOAyElufwfhEW4vmDqdwCXlVV9Lggnhzdowg0ktdMTYy8DjWaCpl7O0OBYMaAM1HV
         E/FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xeou+FH+74ou+aJTOHpTFVOr1dchRSfxjy2FcSVoqsM=;
        b=NUVGB7kykdI7JVZVCrrOvqdz9s2c99OctCM/4feeULOQcem18Tv9i9j9YxIimekJ+P
         8MLQ2ePSMZEWmlxLmL2ec1eM96HMZ8zLcA5zQ/Ajl9MV8UB2oxvZO2t5VpJYFiJ6FfzH
         zcrJyjzUbUjGv9/hHghMyFyNcTcUAgc0re91/PmJX0VvhhQ8iWf1f83+M9OmdWiyqz4z
         B5yshHx7fY1MXpyLOwtWXdsRemJ5R2uG32efyJ3AjP0xgDmlUDYrMnwjoYTm/GVpibnr
         eItrsyr3oC3GRacRb7w+k6PYS0pZv7cUFt4UbFHEj3+j39FJvIs9rLRQY0/qzbHZR3XI
         4MdQ==
X-Gm-Message-State: AOAM5333/CuInmAXYJbdHEneRyKlLT1sEGmpJu1XtEvDhWhHKlx0CB7u
        tHMsGQG70wJiEJHaRybsj/ofKAzIRiWdNNmCMhm28g==
X-Google-Smtp-Source: ABdhPJzEUtDUXqyNFdWJ/WjB80Vb7OtTk/k0OBSt0fDvCCXyrJAPAi/mhcCxO8VGQrD9sAContSZHdBphiljyk2r8kM=
X-Received: by 2002:a25:3444:: with SMTP id b65mr36007073yba.5.1643863534020;
 Wed, 02 Feb 2022 20:45:34 -0800 (PST)
MIME-Version: 1.0
References: <20220201232715.1585390-1-eric.dumazet@gmail.com> <f160d981-4672-a8d1-a797-eaad75706458@gmail.com>
In-Reply-To: <f160d981-4672-a8d1-a797-eaad75706458@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 2 Feb 2022 20:45:22 -0800
Message-ID: <CANn89iKc1DOdn=0H2O_CPd-d99p=YxDu4VbEQ_-wGhvJ+-MDmA@mail.gmail.com>
Subject: Re: [PATCH iproute2] iplink: add gro_max_size attribute handling
To:     David Ahern <dsahern@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 2, 2022 at 7:55 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 2/1/22 4:27 PM, Eric Dumazet wrote:
> > diff --git a/ip/ipaddress.c b/ip/ipaddress.c
> > index 4109d8bd2c43640bee40656c124ea6393d95a345..583c41a94a8ec964779c1e3a8305be80e43907e7 100644
> > --- a/ip/ipaddress.c
> > +++ b/ip/ipaddress.c
> > @@ -904,6 +904,11 @@ static int print_linkinfo_brief(FILE *fp, const char *name,
> >                                                  ifi->ifi_type,
> >                                                  b1, sizeof(b1)));
> >               }
> > +             if (tb[IFLA_GRO_MAX_SIZE])
> > +                     print_uint(PRINT_ANY,
> > +                                "gro_max_size",
> > +                                "gro_max_size %u ",
> > +                                rta_getattr_u32(tb[IFLA_GRO_MAX_SIZE]));
> >       }
> >
> >       if (filter.family == AF_PACKET) {
>
> gso_max_segs only shows in detail mode; this change prints it only for
> brief mode.

This is a rebase error, I will send a v2.
