Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7F03F4298
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 02:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234399AbhHWAcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 20:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbhHWAcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 20:32:17 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917F8C061575;
        Sun, 22 Aug 2021 17:31:35 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id lc21so880629ejc.7;
        Sun, 22 Aug 2021 17:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=jowtOTpjNwqucfYjuJgTUiClzxtr7mn0OII0JVTDIs4=;
        b=sV4cROVbci+qn31l06I0BOL/BjGaS1l9u8CR9wXrVGw9el/mdkBh+WRWUyFI030YuE
         kse5xB/cxs+MUdVH8uVIVHgkJno+uO9k4hufQfbQR1gEZICJupBHiaEA76BeENv2drBl
         m7FBq5K0NekFivSccitH49IWI6ZqQ1ey6DIwMgnUSF2mIVsMNgmSA92QrSICKjSVB9VV
         UigtYNpI7xL+dvQfhAp4gEUQy6uttMDKCpx+A5IqUejlDO/kxC9XHemsDSowrXn4X5oT
         ycQT4zIJaavZUOJpBxNt/fv16BsWBv0k2Ul2R6/HjAggIX3U4lO9wKZKynpyNnXp/zV4
         XetA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=jowtOTpjNwqucfYjuJgTUiClzxtr7mn0OII0JVTDIs4=;
        b=GftcEhEj9JayXONrjjhY4lnPBJNc+9LHVLR+Mzm47UY38kIwMnhqs5J9+3IC/mz2Jq
         8YiqYClRotkUO9ckv+Sytm6Ff9kWl4Mu6Tx2OYJYBn6Ak74ruD2nHjgmO8bgIVVIry1A
         HmTag9PdZFOqelbtuerM0z/Q6VJgd5JELWnKooT8cZLkIIqQ1dwMvAwivLEKcoYGKmTI
         zCr2Hzp0fEhDPlemtPUfyxJtW9K18QzpiELSuJUOeUfiYvuCSf0V1ah0sybqP6KZbeRS
         xS7XGoKzLEIu7F01CT8FxA5ZQ6hGTy74CaNZCbFIZ4CONR9QmU9hLB7FFvhql/rcV8k0
         IcmA==
X-Gm-Message-State: AOAM533RlTc32pPuOAGlEDJs9t7eZGI4TuY1cyhCMYv35BNXkv5RpjYi
        /BZsXvdIYyk6aRkGzQqb6PE=
X-Google-Smtp-Source: ABdhPJxDGc/GUX1m73NPQNXtTRrERjbgD1KmnZNNVG7t8kgUpusl+RxLu6QqCgpLC4d/ItjQPake/A==
X-Received: by 2002:a17:907:a043:: with SMTP id gz3mr10487959ejc.366.1629678694239;
        Sun, 22 Aug 2021 17:31:34 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id cr9sm8090439edb.17.2021.08.22.17.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Aug 2021 17:31:34 -0700 (PDT)
Date:   Mon, 23 Aug 2021 03:31:32 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 3/5] net: dsa: tag_rtl8_4: add realtek 8
 byte protocol 4 tag
Message-ID: <20210823003132.fdafjnci4y56cmnd@skbuf>
References: <20210822193145.1312668-1-alvin@pqrs.dk>
 <20210822193145.1312668-4-alvin@pqrs.dk>
 <20210822221307.mh4bggohdvx2yehy@skbuf>
 <9d6af614-d9f9-6e7b-b6b5-a5f5f0eb8af2@bang-olufsen.dk>
 <20210822232538.pkjsbipmddle5bdt@skbuf>
 <0606e849-5a4e-08c9-fcd1-d4661c10a51c@bang-olufsen.dk>
 <20210822234516.pwlu4wk3s3pfzbmi@skbuf>
 <e92dd0b2-0720-b848-900d-7f383f133111@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e92dd0b2-0720-b848-900d-7f383f133111@bang-olufsen.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 12:28:51AM +0000, Alvin Šipraga wrote:
> On 8/23/21 1:45 AM, Vladimir Oltean wrote:
> > On Sun, Aug 22, 2021 at 11:37:28PM +0000, Alvin Šipraga wrote:
> >>>>>> +	skb->offload_fwd_mark = 1;
> >>>>>
> >>>>> At the very least, please use
> >>>>>
> >>>>> 	dsa_default_offload_fwd_mark(skb);
> >>>>>
> >>>>> which does the right thing when the port is not offloading the bridge.
> >>>>
> >>>> Sure. Can you elaborate on what you mean by "at the very least"? Can it
> >>>> be improved even further?
> >>>
> >>> The elaboration is right below. skb->offload_fwd_mark should be set to
> >>> zero for packets that have been forwarded only to the host (like packets
> >>> that have hit a trapping rule). I guess the switch will denote this
> >>> piece of info through the REASON code.
> >>
> >> Yes, I think it will be communicated in REASON too. I haven't gotten to
> >> deciphering the contents of this field since it has not been needed so
> >> far: the ports are fully isolated and all bridging is done in software.
> >
> > In that case, setting skb->offload_fwd_mark to true is absolutely wrong,
> > since the bridge is told that no software forwarding should be done
> > between ports, as it was already done in hardware (see nbp_switchdev_allowed_egress).
> >
> > I wonder how this has ever worked? Are you completely sure that bridging
> > is done in software?
>
> You are absolutely right, and indeed I checked just now and the bridging
> is not working at all.
>
> Deleting the line (i.e. skb->offload_fwd_mark = 0) restores the expected
> bridging behaviour.
>
> Based on what you have said, do I understand correctly that
> offload_fwd_mark shouldn't be set until bridge hardware offloading has
> been implemented?
>
> Thanks for your detailed review so far.

So back to my initial suggestion:

| At the very least, please use
|
| 	dsa_default_offload_fwd_mark(skb);
|
| which does the right thing when the port is not offloading the bridge.

This way, you won't have to touch this code even after you start
implementing .port_bridge_join and .port_bridge_leave. It deals with
both cases.
