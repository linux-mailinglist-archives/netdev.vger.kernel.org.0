Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7E03F40A3
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 19:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbhHVRO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 13:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhHVRO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 13:14:26 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D67C061575;
        Sun, 22 Aug 2021 10:13:45 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a25so5044789ejv.6;
        Sun, 22 Aug 2021 10:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0fmNxroS5SpgAIXhN5w/j2vi67JXUEs6Ajnwb8jCbzo=;
        b=SqYFubdNy8QBGBHenNDL8htKljeVcnImXNjFXwM9DfYKuYq9iYZNMswbUN0Ueb1PiT
         9GeYhl02lF8CvK3HXkBGNFKuvrbr6dtRnY4KDIslThrEp86eHWJVVaNxDxYISsJ8IQ3t
         htotdE+bdiCvvO0IXDg3qBQ6pjThkSGSe8lanZrpXS8C0zSwCPttfx4Rdg/tY1D4RCeO
         ZnR+QcRBz9UDGNqbYh+DmrplghlnornM+69Aucp2QvK24DTfYyxIeY438z2HwAx2S3Y8
         BUqYaiHdvDrHdVhqwEs+X4PrjC/ELByYa5P3WBDvFSlZtdhMi2KXWZAg9ktoEtmxDQvC
         jqdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0fmNxroS5SpgAIXhN5w/j2vi67JXUEs6Ajnwb8jCbzo=;
        b=mKnoMYN1WWSkyxKRA4Xo/K5AFZvWCz3MqRivc2vwjDkgatw4oKI728GJWqat832Gt4
         U42utttaSAhxunHECES12AHlQs9hBvizY3vqniktcoGkuoDj8VdsXpFRZ7A1Ks4SfdEw
         JusCuHwLD3jzX4zRWW5zkBDPZ5JW2UhIoW0tnZUVLc3axXA055LcROA0srNFdz7k1Fh+
         3dpLUD0SnHe8RH22np+kJo1D4JSApB47PV9OflZHAjVoMFmbw2841qH5cnBYg9BiSEPX
         EpX3D3IXE6t3enWiz/9W5stm0rl0Qal/ipH1VzexBqqmbbCIXApwYgtfTj99PRKKRZ6o
         vvaw==
X-Gm-Message-State: AOAM530g83A86/tM/Lg+Ff3JIbIHKgFDoXtwsimYWSH3DPbfm3vRlhfs
        XaepZT+uMklQWiMjySUE+itAm1I260MHp0vG73E=
X-Google-Smtp-Source: ABdhPJwg3J4bTj6c7O9lehMPZo11j1wXhHP3L/sNexMay3wHrut3RXYWHdh7gyx4ag9XeveGHWo78F94tF01aqECTOU=
X-Received: by 2002:a17:906:720e:: with SMTP id m14mr31417254ejk.500.1629652423852;
 Sun, 22 Aug 2021 10:13:43 -0700 (PDT)
MIME-Version: 1.0
References: <ccce7edb-54dd-e6bf-1e84-0ec320d8886c@linux.ibm.com>
 <cover.1628235065.git.vvs@virtuozzo.com> <77f3e358-c75e-b0bf-ca87-6f8297f5593c@virtuozzo.com>
 <CALMXkpaay1y=0tkbnskr4gf-HTMjJJsVryh4Prnej_ws-hJvBg@mail.gmail.com>
 <CALMXkpa4RqwssO2QNKMjk=f8pGWDMtj4gpQbAYWbGDRfN4J6DQ@mail.gmail.com>
 <ff75b068-8165-a45c-0026-8b8f1c745213@virtuozzo.com> <CALMXkpZVkqFDKiCa4yHV0yJ7qEESqzcanu4mrWTNvc9jm=gxcw@mail.gmail.com>
In-Reply-To: <CALMXkpZVkqFDKiCa4yHV0yJ7qEESqzcanu4mrWTNvc9jm=gxcw@mail.gmail.com>
From:   Christoph Paasch <christoph.paasch@gmail.com>
Date:   Sun, 22 Aug 2021 10:13:32 -0700
Message-ID: <CALMXkpYeR+DegQJ7Eec2cx=z8i+Z8Y-Aygftjg08Y2+bQXJZ7Q@mail.gmail.com>
Subject: Re: [PATCH NET v4 3/7] ipv6: use skb_expand_head in ip6_xmit
To:     Vasily Averin <vvs@virtuozzo.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel@openvz.org,
        Julian Wiedmann <jwi@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 22, 2021 at 10:04 AM Christoph Paasch
<christoph.paasch@gmail.com> wrote:
>
> Hello Vasily,
>
> On Fri, Aug 20, 2021 at 11:21 PM Vasily Averin <vvs@virtuozzo.com> wrote:
> >
> > On 8/21/21 1:44 AM, Christoph Paasch wrote:
> > > (resend without html - thanks gmail web-interface...)
> > > On Fri, Aug 20, 2021 at 3:41 PM Christoph Paasch
> > >> AFAICS, this is because pskb_expand_head (called from
> > >> skb_expand_head) is not adjusting skb->truesize when skb->sk is set
> > >> (which I guess is the case in this particular scenario). I'm not
> > >> sure what the proper fix would be though...
> >
> > Could you please elaborate?
> > it seems to me skb_realloc_headroom used before my patch called pskb_expand_head() too
> > and did not adjusted skb->truesize too. Am I missed something perhaps?
> >
> > The only difference in my patch is that skb_clone can be not called,
> > though I do not understand how this can affect skb->truesize.
>
> I *believe* that the difference is that after skb_clone() skb->sk is
> NULL and thus truesize will be adjusted.
>
> I will try to confirm that with some more debugging.

Yes indeed.

Before your patch:
[   19.154039] ip6_xmit before realloc truesize 4864 sk? 000000002ccd6868
[   19.155230] ip6_xmit after realloc truesize 5376 sk? 0000000000000000

skb->sk is not set and thus truesize will be adjusted.


With your change:
[   15.092933] ip6_xmit before realloc truesize 4864 sk? 00000000072930fd
[   15.094131] ip6_xmit after realloc truesize 4864 sk? 00000000072930fd

skb->sk is set and thus truesize is not adjusted.


Christoph

>
>
> Christoph
>
> >
> > Thank you,
> >         Vasily Averin
