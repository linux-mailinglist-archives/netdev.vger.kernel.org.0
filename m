Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675F12B2F21
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 18:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgKNRhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 12:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgKNRhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 12:37:02 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95DA9C0613D1
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 09:37:02 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id d9so14155123oib.3
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 09:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U+KMAnf2yzBogfaaMLLEijYBYvZtkYlDENcUi/iosyY=;
        b=AT9j+dCBAh6nL0Aw/A7DgEVkcQZfCWbC4rwxazxszxvekaQi946ju0MkeaUqYs5l6L
         DAErJehgky7JWt/ksZELlmCA6bg7GKM/5/Im/DxxdRCv+Ikm4SpLNpu72taHFsT3nTZ1
         MIxoR1RdvLzU2hL8un3HdAw9kKnyLlNiUnjKJUq1izHT2Hbx/t1XKkMOdBxs7SYnjCmi
         6bvID2zWAhF38kuj3cAogKyDLAobzv/jK1oUSw8Z6iLLXzGXOIeYJae8TMUMuUD+jnaW
         9+EmNUfAY9vYJv5QKwr+c1M2j75vMGf2nLMv6Z2Pn66LAUYQFChsgOAGXwGBvO2uPJ+s
         ygCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U+KMAnf2yzBogfaaMLLEijYBYvZtkYlDENcUi/iosyY=;
        b=CwRu+lefgTodwOGfCdfDRlmlW/pejEE47Qq+Smmc3SQx7vGvs4SZr/T5wWCAJz/yoT
         RIZ4TzGL67Cn7UWw/R/PnoDuOcD0/yt3y8XfeiC4P3GHy6JxyvmWKlICWxHxpDtSM2WV
         wTN+BeZaRPYA+E2bpqfuEXvwdjv/5V6Oit2eGpTyZpiv2u8inz7/S5hOc4skLaRqF2Ms
         MhnE4JoPtoXZ5Sv3VbAsM2BPghxuMSGmUgpkxxsL/OrYdLU/VJ7KXUDUrdUgLMB/VXbQ
         F37Th0KOscELAETkIExTfhf604CbNmtHGU1rBtvY5LD70hUmBQeg2EKosUtlWMZ64N23
         TjsQ==
X-Gm-Message-State: AOAM530iG9z/vH1ALY1bCpOmqXttti5N5O2TeGGNkWICJqFV3LXwHEYz
        tb77ns2L1umgNd9uf4E0JP+xaR+wjai3uNmNTYM=
X-Google-Smtp-Source: ABdhPJx4l/xnI61vPJwXyFVe9A2ViGskedEIQxHRl1cpeIsPddww2DYznlo4w0p3BhKh249quzk/FgQMJRaD9C6rs3k=
X-Received: by 2002:aca:bc03:: with SMTP id m3mr5221047oif.35.1605375422023;
 Sat, 14 Nov 2020 09:37:02 -0800 (PST)
MIME-Version: 1.0
References: <CAMeyCbh8vSCnr-9-odi0kg3E8BGCiETOL-jJ650qYQdsY0wxeA@mail.gmail.com>
 <CAMeyCbjuj2Q2riK2yzKXRfCa_mKToqe0uPXKxrjd6zJQWaXxog@mail.gmail.com>
 <3f069322-f22a-a2e8-1498-0a979e02b595@gmail.com> <739b43c5c77448c0ab9e8efadd33dbfb@AcuMS.aculab.com>
 <CAMeyCbj4aVRtVQfzKmHvhUkzh08PqNs2DHS1nobbx0nR4LoXbg@mail.gmail.com>
 <CAMeyCbjOzJw7e3+e-AwnCzRpYWYT5OjFSH=+eEsZcEBrJ4BCYg@mail.gmail.com> <AM8PR04MB7315635D8FFC131B04B25E00FFE50@AM8PR04MB7315.eurprd04.prod.outlook.com>
In-Reply-To: <AM8PR04MB7315635D8FFC131B04B25E00FFE50@AM8PR04MB7315.eurprd04.prod.outlook.com>
From:   Kegl Rohit <keglrohit@gmail.com>
Date:   Sat, 14 Nov 2020 18:36:51 +0100
Message-ID: <CAMeyCbiuFAtqpUTtrPx3Afp_Hc41nZTzq0US7vg5HXwPp6SdFQ@mail.gmail.com>
Subject: Re: [EXT] Re: Fwd: net: fec: rx descriptor ring out of order
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     David Laight <David.Laight@aculab.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 14, 2020 at 2:58 AM Andy Duan <fugang.duan@nxp.com> wrote:
>
> From: Kegl Rohit <keglrohit@gmail.com> Sent: Friday, November 13, 2020 8:21 PM
> > On Fri, Nov 13, 2020 at 8:33 AM Kegl Rohit <keglrohit@gmail.com> wrote:
> > >
> > > > What are the addresses of the ring entries?
> > > > I bet there is something wrong with the cache coherency and/or
> > > > flushing.
> > > >
> > > > So the MAC hardware has done the write but (somewhere) it isn't
> > > > visible to the cpu for ages.
> > >
> > > CMA memory is disabled in our kernel config.
> > > So the descriptors allocated with dma_alloc_coherent() won't be CMA memory.
> > > Could this cause a different caching/flushing behaviour?
> >
> > Yes, after tests I think it is caused by the disabled CMA.
> >
> > @Andy
> > I could find this mail and the attached "i.MX6 dma memory bufferable
> > issue.pptx" in the archive
> > https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fmarc.info
> > %2F%3Fl%3Dlinux-netdev%26m%3D140135147823760&amp;data=04%7C01
> > %7Cfugang.duan%40nxp.com%7C121e73ec66684a125e2a08d887cea578%7C
> > 686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C637408668924362983
> > %7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJ
> > BTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=e7Cm24Ay1Ay52UKtzT
> > BiX9KlhuublndP30vnwxAaugM%3D&amp;reserved=0
> > Was this issue solved in some kernel versions later on?
> > Is CMA still necessary with a 5.4 Kernel?
>
> Yes, CMA is required. Otherwise it requires one patch for L2 cache.

Where can I find the patch / is the patch already mainline?
Is it some development patch or already well tested?
Or would you recommend enabling CMA instead?
Are other components affected apart from the already mentioned
peripherals (ENET, Audio, USB) in the attachment?
