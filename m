Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22B6C36FF38
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 19:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbhD3RKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 13:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbhD3RKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 13:10:35 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15245C06174A
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 10:09:47 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id i4so46445155ybe.2
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 10:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p8Zgv2QufvsTLwCftN64g7l5JMKSRjB9ceWzTWLm8xs=;
        b=k6+bO3O2mAuqYN6TdWfZfoFGHEVfWjhp0VvKrxpcZlr66ab+zODBMRQu0142uKhRsa
         BNlRQB1JJBrVpquHtoCKVCbHf2rz20ebyF1i93JdBNwnWM8KGMyzEZKJLTwhXYitEbxb
         3fMZlp1IqV+NDoAAtFN7lSCme24NRmjwsVCOqpvZeNz4M7cVxVvUE0eKY4KYDuZ0xgqm
         WxOz1DsWZa5xNmUSM9nWZIT2Q7wugPZ6iDTpsLmOQZI0Oc3qWdhvuQU+pz5WYnAKVJTp
         MQhC1oP5P9uic1dKIXtRjpJh40Jg+TPTaIuuEXtkhhzxjQbaP7nsdijIZ3/SNg54Ldi6
         GLCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p8Zgv2QufvsTLwCftN64g7l5JMKSRjB9ceWzTWLm8xs=;
        b=JwUJ+S3uww2oeKgVyORbkLde23HWidYpccEBmB2qRm/POw7dnlJVYOgi/8/d2oKbf0
         hBo/8lIOWq7TwIfLS3wz1yv35xSZ1QT0d4awbpiP1c5X5jvQ/0p7e+fd8BdHOHDROM1G
         wWkzT95GDpx9a/OynhgBrbsMjoXscirsp7iXpNEn8b78juQTiiGw5f9+6LRjzP19Q6JA
         W2sPVZm5aZb1sdVN+1zPLwS/iAg4ROuEJf7K0iHi0aO7VG6hzo9eh/77KB+pBhDHLszj
         5ArYU5dUE4IbWC1EN/ucpDue1pV4mvSCfD/vWjpsTNqk0ZbL1GulUWGPajgbj+fcNwjS
         e/qQ==
X-Gm-Message-State: AOAM531uiiH5y8RHYMKC2cKUhdq+yAdtfF37+DxDsI50vzVCzx0SsFzn
        dn2qXTzz1i4RVcKlQ6bu2vsuLZYCp6Hw2fBOZjWWlA==
X-Google-Smtp-Source: ABdhPJwp3huqETZPOLFfpsSZyWZhRa5yq3kEABaBuCSyX4MZwnJxm52Uh3K2vsWq5UVNsSQZVEB9V70MlFk8lyDcGJM=
X-Received: by 2002:a25:4641:: with SMTP id t62mr9072475yba.253.1619802585851;
 Fri, 30 Apr 2021 10:09:45 -0700 (PDT)
MIME-Version: 1.0
References: <d840ddcf-07a6-a838-abf8-b1d85446138e@bluematt.me>
 <CANn89i+L2DuD2+EMHzwZ=qYYKo1A9gw=nTTmh20GV_o9ADxe2Q@mail.gmail.com>
 <0cb19f7e-a9b3-58f8-6119-0736010f1326@bluematt.me> <20210428141319.GA7645@1wt.eu>
 <055d0512-216c-9661-9dd4-007c46049265@bluematt.me> <CANn89iKfGhNYJVpj4T2MLkomkwPsYWyOof+COVvNFsfVfb7CRQ@mail.gmail.com>
 <64829c98-e4eb-6725-0fee-dc3c6681506f@bluematt.me> <1baf048d-18e8-3e0c-feee-a01b381b0168@bluematt.me>
In-Reply-To: <1baf048d-18e8-3e0c-feee-a01b381b0168@bluematt.me>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 30 Apr 2021 19:09:34 +0200
Message-ID: <CANn89iKJDUQuXBueuZWdi17LgFW3yb4LUsH3hzY08+ytJ9QgeA@mail.gmail.com>
Subject: Re: [PATCH net-next] Reduce IP_FRAG_TIME fragment-reassembly timeout
 to 1s, from 30s
To:     Matt Corallo <netdev-list@mattcorallo.com>
Cc:     Willy Tarreau <w@1wt.eu>, "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Keyu Man <kman001@ucr.edu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 30, 2021 at 5:52 PM Matt Corallo
<netdev-list@mattcorallo.com> wrote:
>
> Following up - is there a way forward here?
>

Tune the sysctls to meet your goals ?

I did the needed work so that you can absolutely decide to use 256GB
of ram per host for frags if you want.
(Although I have not tested with crazy values like that, maybe some
kind of bottleneck will be hit)

> I think the current ease of hitting the black-hole-ing behavior is unacceptable (and often not something that can be
> changed even with the sysctl knobs due to intermediate hosts), and am happy to do some work to fix it.
>
> Someone mentioned in a previous thread randomly evicting fragments instead of dropping all new fragments when we reach
> saturation, which may be an option. We could also do something in between 1s and 30s, preserving behavior for hosts
> which see fragments delivered out-of-order by seconds while still reducing the ease of accidentally just black-holing
> all fragments entirely in more standard internet access deployments.
>

Give me one implementation, I will give you a DDOS program to defeat it.
linux code is public, attackers will simply change their attacks.

There is no generic solution, they are all bad.

If you evict randomly, it will also fail. So why bother ?


> >
> >
> > On 4/28/21 11:38, Eric Dumazet wrote:
> >> On Wed, Apr 28, 2021 at 4:28 PM Matt Corallo
> >> <netdev-list@mattcorallo.com> wrote:
> >> I have been working in wifi environments (linux conferences) where RTT
> >> could reach 20 sec, and even 30 seconds, and this was in some very
> >> rich cities in the USA.
> >>
> >> Obviously, when a network is under provisioned by 50x factor, you
> >> _need_ more time to complete fragments.
> >
> > Its also a trade-off - if you're in a hugely under-provisioned environment with bufferblot issues you may have some
> > fragments that need more time for reassembly if they've gotten horribly reordered (though just having 20 second RTT
> > doesn't imply that fragments are going to be re-ordered by 20 seconds, more likely you might see a small fraction of
> > it), but you're also likely to have more *lost* fragments, which can trigger the black-holing behavior here.
> >
> > If you have some loss in the flow, its very easy to hit 1Mbps of lost fragments and suddenly instead of just giving more
> > time to reassemble, you're just black-holing instead. I'm not claiming I have the right trade-off here, I'd love more
> > input, but at least in my experience trying to just occasionally send fragments on a pretty standard DOCSIS modem, 30s
> > is way off.
> >
> >> For some reason, the crazy IP reassembly stuff comes every couple of
> >> years, and it is now a FAQ.
> >>
> >> The Internet has changed for the  lucky ones, but some deployments are
> >> using 4Mbps satellite connectivity, shared by hundreds of people.
> >
> > I'd think this is a great example of a case where you precisely *dont* want such a low threshold for dropping all
> > fragments. Note that in my specific deployment (standard DOCSIS), we're talking about the same speed and network as was
> > available ten years ago, this isn't exactly an uncommon or particularly fancy deployment. The real issue is applications
> > which happily send 8MB of fragments within a few seconds and suddenly find themselves completely black-holed for 30
> > seconds, but this isn't going to just go away.
> >
> >> I urge application designers to _not_ rely on doomed frags, even in
> >> controlled networks.
> >
> > I'd love to, but we're talking about a default value for fragment reassembly. At least in my subjective experience here,
> > the conservative 30s time takes things from "more time" to "completely blackhole", which feels like the wrong tradeoff.
> > At the end of the day, you can't expect fragments to work super well, indeed, and you assume some amount of loss, the
> > goal is to minimize the loss you see from them.
> >
> > Even if you have some reordering, you're unlikely to see every fragment reordered (I guess you could imagine a horribly
> > broken qdisc, does such a thing exist in practice?) such that you always need 30s to reassemble. Taking some loss to
> > avoid making it so easy to completely blackhole fragments seems like a reasonable tradeoff.
> >
> > Matt
