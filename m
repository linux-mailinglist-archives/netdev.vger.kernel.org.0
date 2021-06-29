Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605003B7520
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 17:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234700AbhF2P3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 11:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234549AbhF2P3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 11:29:34 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00FBEC061760
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 08:27:07 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id v5so21239945ilo.5
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 08:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZOdjLs8ivc4gPCE6OIzakj7IFst+Z5OjHiyUTGkaTSA=;
        b=WSdmAmYuF6Mav02YqusyHzAUtRBmBjc6gOFQFEap86r9IMCmeDJIZgORI70AX4zQxu
         xAcoaZKUv69I2xmuZCvk13jYMg0GG1q6uImi392mIr8eiGPg05wWWGDkOoUNno6WghsC
         v0DEqGa6tHrlePQVf9HAbLcNJj+uc2a961DlfL5npNiss9hL7lpXHvCo1/QOl109/rgV
         CigsMLXof89E3ZeqXmQs7IEIvvoUrAOgTgIK9wY9Zaq0u878pRjYr5ek5zU/NRlwEA3/
         PDQRbK55EuDkqVZFPnzzVYe3gYorbcfK5LLVe6N/TUc5be5IUgv+Aux2HeKmkFeO9sVg
         uWhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZOdjLs8ivc4gPCE6OIzakj7IFst+Z5OjHiyUTGkaTSA=;
        b=r7erYA3h4tbWlA1Z9i4ys2Bjvn13WdBfOdnmGTgFJB9nWSW/HlLFrilks8ZrFBmlF7
         QdvwDwZnGnY5UvRmKWIUqbSjD5gkBh8p7B+Z2l7VkV6YlbFffMM9nNNTKJhDV2F5qvq+
         VTPtkpti8SuFgm3IM1SdbUMwnNXnylQkKyz1rkXQsMRztmm0DPMcPI5eXHfAZaRKVQow
         vixTa8bdDERP6y081EZlGKgyy2nCnkoIgbWqcXu/CsPDk91OS/mt9O1Gkzm+COq4eb2n
         bK99BTYZhBFVpTCV4f2IkLXfYX9NV5/67dhmLKjyCS3SK7JkyMTQ+RDEcSTqQgU8DRP0
         3hkw==
X-Gm-Message-State: AOAM531oXCJHfNoY8x8h/Rbea5GF3Jh84ZM4yIk44P56FOVs9L3uf1wt
        CJsA4F9THElax1VuDufcTTSu8ifNz+bTMBA4hJ0=
X-Google-Smtp-Source: ABdhPJx7q+rwmgpygCYk5U22CgKHiszk4psdzUWzyvCftkOJQNMraYZQIZ7BQcTcLZ0ZsQfp/3gxsTsql4TrE3+OtPI=
X-Received: by 2002:a92:d245:: with SMTP id v5mr21241554ilg.287.1624980426404;
 Tue, 29 Jun 2021 08:27:06 -0700 (PDT)
MIME-Version: 1.0
References: <532A8EEC-59FD-42F2-8568-4C649677B4B0@itu.dk> <877diekybt.fsf@toke.dk>
 <B28935AB-6078-4258-8E7C-14E11D1AD57F@itu.dk> <87wnqeji2n.fsf@toke.dk> <B95D6635-02AE-4912-B521-2BECEE16927E@itu.dk>
In-Reply-To: <B95D6635-02AE-4912-B521-2BECEE16927E@itu.dk>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Tue, 29 Jun 2021 08:26:54 -0700
Message-ID: <CAA93jw6aky0KOW3cxoJMP8vVChD_CUejOWTVcQj5o=u_UH0qoA@mail.gmail.com>
Subject: Re: [PATCH v2] net: sched: Add support for packet bursting.
To:     Niclas Hedam <nhed@itu.dk>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thx for bringing me in. I don't really have an opinion as to the value
of this patchset, but I do have an opinion on the slot functionality.

The slot functionality was my first attempt at properly emulating wifi
behaviors in netem, and although it does capture how aggregation
behaves in 802.11n, which was VERY important - it falls down miserably
on later standards and on more than one station being present due to
the half duplex nature of wifi, and the ingress and egress queues
being tightly coupled.

Used extremely carefully (along with the packet trace models also now
in netem), you *can* get closer to an emulation of how one or two wifi
stations actually behave in normal and tightly coupled systems with
tcp-friendly protocols, but I often wish I'd *never* released the code
as any result you get from it for tcp behaviors over denser wifi
networks is extremely misleading. (although, still better than
anything else out there in terms of emulating aggregation properly!).

Us not having been (since) able to gain access to low level firmwares
for wifi 6 (though the openwifi project is promising), has made it
really difficult to actually implement the real fixes for wifi (and
starlink) that we have as an outgrowth of the make-wifi-fast project.
In particular, merely getting a "txop is nearly done" interrupt would
make a huge difference if only we could find a chipset to leverage.

We are still forced to construct a two txop standing queue which can
really hurt wifi
performance on every chipset we have tried to improve. Dang it.

To quote from the codel paper:

"The standing queue, resulting from a mismatch between the window and
pipe size, is the essence of bufferbloat. It creates large delays but
no improvement in throughput. It is not a phenomenon treated by
queuing or traffic theory, which, unfortunately, results in it being
almost universally misclassified as congestion (a completely different
and much rarer pathology). These theories usually assume Poisson
arrival processes, which are, by definition, uncorrelated. The
arrivals of a closed-loop, reliable transport process such as TCP are
completely correlated, resulting in an arrival and departure rate
equality that theorists have dismissed as unnatural and wildly
improbable. Since normal cures for congestion such as usage limits or
usage-based billing have no effect on bufferbloat but annoy customers
and discourage network use, addressing the real problem would be
prudent."  - https://queue.acm.org/detail.cfm?id=3D2209336







On Mon, Jun 28, 2021 at 6:24 AM Niclas Hedam <nhed@itu.dk> wrote:
>
> Thanks for the valuable thoughts, Toke.
>
> The patch started with me being tasked to try and mitigate timing attacks=
 caused by network latencies.
> I scouted over the current network stack and didn't find anything that fu=
lly matched my use-case.
> While I now understand that you can actually leverage the slots functiona=
lity for this, I would still opt for a new interface and implementation.
>
> I have not done any CPU benchmarks on the slots system, so I'm not approa=
ching this from the practical performance side per se.
> Instead, I argue for seperation with reference to the Seperation of Conce=
rn design principle. The slots functionality is not built/designed to cater=
 security guarantees, and my patch is not built to cater duty cycles, etc.
> If we opt to merge these two functionalities or discard mine, we have to =
implement some guarantee that the slots functionality won't become signific=
antly slower or complex, which in my opinion is less maintainable than two =
similar systems. Also, this patch is very limited in lines of code, so main=
taining it is pretty trivial.
>
> I do agree, however, that we should define what would happen if you enabl=
e both systems at the same time.
>
> @Dave: Any thoughts on this?
>
> > On 28 Jun 2021, at 14:21, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat=
.com> wrote:
> >
> > Niclas Hedam <nhed@itu.dk> writes:
> >
> >>>> From 71843907bdb9cdc4e24358f0c16a8778f2762dc7 Mon Sep 17 00:00:00 20=
01
> >>>> From: Niclas Hedam <nhed@itu.dk>
> >>>> Date: Fri, 25 Jun 2021 13:37:18 +0200
> >>>> Subject: [PATCH] net: sched: Add support for packet bursting.
> >>>
> >>> Something went wrong with the formatting here.
> >>
> >> I'll resubmit with fixed formatting. My bad.
> >>
> >>>>
> >>>> This commit implements packet bursting in the NetEm scheduler.
> >>>> This allows system administrators to hold back outgoing
> >>>> packets and release them at a multiple of a time quantum.
> >>>> This feature can be used to prevent timing attacks caused
> >>>> by network latency.
> >>>
> >>> How is this bursting feature different from the existing slot-based
> >>> mechanism?
> >>
> >> It is similar, but the reason for separating it is the audience that t=
hey are catering.
> >> The slots seems to be focused on networking constraints and duty cycle=
s.
> >> My contribution and mechanism is mitigating timing attacks. The
> >> complexity of slots are mostly unwanted in this context as we want as
> >> few CPU cycles as possible.
> >
> > (Adding Dave who wrote the slots code)
> >
> > But you're still duplicating functionality, then? This has a cost in
> > terms of maintainability and interactions (what happens if someone turn=
s
> > on both slots and bursting, for instance)?
> >
> > If the concern is CPU cost (got benchmarks to back that up?), why not
> > improve the existing mechanism so it can be used for your use case as
> > well?
> >
> > -Toke
>


--
Latest Podcast:
https://www.linkedin.com/feed/update/urn:li:activity:6791014284936785920/

Dave T=C3=A4ht CTO, TekLibre, LLC
