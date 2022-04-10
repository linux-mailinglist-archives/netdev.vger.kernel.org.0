Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D114FADE7
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 14:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241660AbiDJMmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 08:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239170AbiDJMmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 08:42:32 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8829145044
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 05:40:21 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id 14so9560150ily.11
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 05:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g0XalX9gJfYJbM5cvVQcjErRfEOrDFoPU1kLlaoR50U=;
        b=IJn0rVb8e5vBH3PBmMAxEqZXoBtE/OVttTFZxvc3yDk7VAwTo52UBA4xJm5HEFvFTs
         0SqGacQmmsUAKcPuqs60stjCCKp7EC+gk9GEjlSqslgyMFOznleZrJJ03mHsosNFsxjc
         JUtgypWWaZ7X0Tmp3zq0CF39Dm7vQ7f9IbrvLjl4KjvuITtE9ORbAlQgVDLgWRyNCEdo
         feJk0/Hc6iuukVAyisIQIVwtc2FxNS6fF/6MUHkhvv28xSg5Ahvpx+pITxJtZVmN3l2X
         CYC9TtVBWxGulqlTBpzSoBQI6Mcs5k8afB9F+JsEMI8NDbgUdZOgAsw/rwA0tMq8OpcP
         sBtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g0XalX9gJfYJbM5cvVQcjErRfEOrDFoPU1kLlaoR50U=;
        b=2Krg/XYA6mLUN/XOgvcvDzrJ9X4+7LtGCSI5MJfxxsdMcOlrChSo5xmEu9da0LKU6H
         kBEORLf+savbM8v6OxahVeXOnyEAKT4HvkJacugVIfZbd0FNVcdvF8ybymtQ0inj0SIv
         Eu5gNn6Fq9UgfjtSzYUciTKN9JzAXEFLukqODQ1cMYYJnojtU+bur31gUD6wkRWdLmmW
         s/l6G3F9uL1ZAeRwUF7UAEtO7xzb4AToEUqOFvxYnpPTOynFBsvIELk59v2JwDPgVks9
         MXswa7orNzY4yMlJ3tRMMjaQPPdFdkRwRKhJLO8NBryCSjxL1hoYzJ2vF8YkwHmHn0BO
         Rl2g==
X-Gm-Message-State: AOAM532mqkb2njho+Rrz6gdH/3oHhHXNqxPNGruLeZHRJXGr2Q3+P/9a
        YtjzrpzAZaQ+3INlIPK0T/jhLqUNy7b0+BGtnqPizV6znSvBs1jv
X-Google-Smtp-Source: ABdhPJweZ428zoHtvWde5yMkDkK4NISBjlERIA5Zx7Ydwd8w0hpNWtRFlTWix7w2uny8t8ctfpuVb2foGPZGWPvwM1A=
X-Received: by 2002:a92:1e09:0:b0:2c6:304e:61fa with SMTP id
 e9-20020a921e09000000b002c6304e61famr12607903ile.211.1649594420962; Sun, 10
 Apr 2022 05:40:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220403175544.26556-1-gerhard@engleder-embedded.com>
 <20220403175544.26556-3-gerhard@engleder-embedded.com> <20220410064751.GB212299@hoboy.vegasvil.org>
In-Reply-To: <20220410064751.GB212299@hoboy.vegasvil.org>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Sun, 10 Apr 2022 14:40:10 +0200
Message-ID: <CANr-f5zrwe6Dea9B3OshtN39mia-U2q0Kw7x6fHYqTaORs0mFw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/5] ptp: Request cycles for TX timestamp
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, yangbo.lu@nxp.com,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mlichvar@redhat.com,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > The free running cycle counter of physical clocks called cycles shall be
> > used for hardware timestamps to enable synchronisation.
> >
> > Introduce new flag SKBTX_HW_TSTAMP_USE_CYCLES, which signals driver to
> > provide a TX timestamp based on cycles if cycles are supported.
> >
> > Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> > ---
> >  include/linux/skbuff.h |  3 +++
> >  net/core/skbuff.c      |  2 ++
> >  net/socket.c           | 11 ++++++++++-
> >  3 files changed, 15 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 3a30cae8b0a5..aeb3ed4d6cf8 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -578,6 +578,9 @@ enum {
> >       /* device driver is going to provide hardware time stamp */
> >       SKBTX_IN_PROGRESS = 1 << 2,
> >
> > +     /* generate hardware time stamp based on cycles if supported */
> > +     SKBTX_HW_TSTAMP_USE_CYCLES = 1 << 3,
> > +
> >       /* generate wifi status information (where possible) */
> >       SKBTX_WIFI_STATUS = 1 << 4,
> >
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 10bde7c6db44..c0f8f1341c3f 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -4847,6 +4847,8 @@ void __skb_tstamp_tx(struct sk_buff *orig_skb,
> >               skb_shinfo(skb)->tx_flags |= skb_shinfo(orig_skb)->tx_flags &
> >                                            SKBTX_ANY_TSTAMP;
> >               skb_shinfo(skb)->tskey = skb_shinfo(orig_skb)->tskey;
> > +     } else {
> > +             skb_shinfo(skb)->tx_flags &= ~SKBTX_HW_TSTAMP_USE_CYCLES;
>
> Why is this needed?

It prevents that SKBTX_HW_TSTAMP_USE_CYCLES is set due to the call of
skb_clone(),
when the timestamp is delivered back to the socket. It lowers the flag
usage, but it is not
absolutely needed. I could remove that code.

Thank you!

Gerhard
