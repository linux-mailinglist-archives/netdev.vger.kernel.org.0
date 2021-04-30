Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B800C36FFED
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 19:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbhD3RuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 13:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbhD3RuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 13:50:16 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849EAC06174A
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 10:49:27 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id 82so84201111yby.7
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 10:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NwULoddl2W1avRI/bwV1nfRI/lrm9nyXsEsJe+4Haxs=;
        b=WTXLYE8VdsduGRfmWfYf2UgL1wAuR38GL6hqUo0gNCORV+4G+BuKTQtVgf/YMI8TDE
         l44gQcQHVaA0NwwCXYJkYrKAIktkDamdOtC9/sG5mC2EF4ljsXiXP/107dgZcq8uK9Ss
         pI5gd2oE9ZxIAfeWvFiEF4ZVQaJjbyHxYXqQ8x9a72nMHA/57hDTkIuWIfXXvcC/p6Bq
         egICd+xZ/h/lpeZlZGARHhzdzYle+avLsW6CTP5RPSD07i1SEK/zHDaXtuUZS7xSmton
         vOwYlEEt4AkJf0KOUvqo/sNVhckoE9UvFRFkdmLUAj+UixSNspp3uv98O+9tLAmgSTuU
         ZLUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NwULoddl2W1avRI/bwV1nfRI/lrm9nyXsEsJe+4Haxs=;
        b=ZtGMBKV0+vg+YxEy4/Ysm8BXJQ5BCrRtzMBnYJdMU7fgxRBoEivvAtKA00BrjS+DUj
         aSym0d8S7RMDXjfTccJwZWLOJ6lC1aJqqEudQvTK0GzrnW9RUSchBLim55R9k2w+AYPE
         GpIswqVdZSFVlSxAqibdIXHoFkBmrpiKwn8J45dv1NmofmXxCvJWcLPf832n0LkEhmiN
         MmdxSGZ18YjvKsAcskaE9OYnRpVNZ5e5Dc7x8jDZempyXyEoeDCXID0Q+7qAiM0U3jGk
         NxMgKxixbCZvUV3sAE4o9eWTa6+gZ4rLOn2tX+PO12G+CkZp5I5sSGpF92V1iS1wYkrF
         dqiA==
X-Gm-Message-State: AOAM532vdJEcCA/Gx+NV51w296u5xRb1hXQgPx9rwEDXuIaiQ6VUpgOF
        sWgfka8D+pNpP/SDCVZnNyJzO2xkiA4YifSfiroNcA==
X-Google-Smtp-Source: ABdhPJx+0kA7Dl+H65J30rEdX6G5J2EhDrClkZ9jOt/e2AFWtv8hAoVgs6537Tn2RXEam/ffydggFasIXJnPxadZ3sk=
X-Received: by 2002:a25:c681:: with SMTP id k123mr8881365ybf.303.1619804966352;
 Fri, 30 Apr 2021 10:49:26 -0700 (PDT)
MIME-Version: 1.0
References: <d840ddcf-07a6-a838-abf8-b1d85446138e@bluematt.me>
 <CANn89i+L2DuD2+EMHzwZ=qYYKo1A9gw=nTTmh20GV_o9ADxe2Q@mail.gmail.com>
 <0cb19f7e-a9b3-58f8-6119-0736010f1326@bluematt.me> <20210428141319.GA7645@1wt.eu>
 <055d0512-216c-9661-9dd4-007c46049265@bluematt.me> <CANn89iKfGhNYJVpj4T2MLkomkwPsYWyOof+COVvNFsfVfb7CRQ@mail.gmail.com>
 <64829c98-e4eb-6725-0fee-dc3c6681506f@bluematt.me> <1baf048d-18e8-3e0c-feee-a01b381b0168@bluematt.me>
 <CANn89iKJDUQuXBueuZWdi17LgFW3yb4LUsH3hzY08+ytJ9QgeA@mail.gmail.com> <c8ad9235-5436-8418-69a9-6c525fd254a4@bluematt.me>
In-Reply-To: <c8ad9235-5436-8418-69a9-6c525fd254a4@bluematt.me>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 30 Apr 2021 19:49:14 +0200
Message-ID: <CANn89iKJmbr_otzWrC19q5A_gGVRjMKso46=vT6=B9vUC5kgqA@mail.gmail.com>
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

On Fri, Apr 30, 2021 at 7:42 PM Matt Corallo
<netdev-list@mattcorallo.com> wrote:
>
>
>
> On 4/30/21 13:09, Eric Dumazet wrote:
> > On Fri, Apr 30, 2021 at 5:52 PM Matt Corallo
> > <netdev-list@mattcorallo.com> wrote:
> >>
> >> Following up - is there a way forward here?
> >>
> >
> > Tune the sysctls to meet your goals ?
> >
> > I did the needed work so that you can absolutely decide to use 256GB
> > of ram per host for frags if you want.
> > (Although I have not tested with crazy values like that, maybe some
> > kind of bottleneck will be hit)
>
> Again, this is not a solution universally because this issue appears when transiting a Linux router. This isn't only
> about end-hosts (or I wouldn't have even bothered with any of this). Sometimes packets flow over a Linux router that you
> don't have control over, which is true in my case.
>
> >> I think the current ease of hitting the black-hole-ing behavior is unacceptable (and often not something that can be
> >> changed even with the sysctl knobs due to intermediate hosts), and am happy to do some work to fix it.
> >>
> >> Someone mentioned in a previous thread randomly evicting fragments instead of dropping all new fragments when we reach
> >> saturation, which may be an option. We could also do something in between 1s and 30s, preserving behavior for hosts
> >> which see fragments delivered out-of-order by seconds while still reducing the ease of accidentally just black-holing
> >> all fragments entirely in more standard internet access deployments.
> >>
> >
> > Give me one implementation, I will give you a DDOS program to defeat it.
> > linux code is public, attackers will simply change their attacks.
> >
> > There is no generic solution, they are all bad.
> >
> > If you evict randomly, it will also fail. So why bother ?
>
> This was never about DDoS attacks - as noted several times this is about it being trivial to have all your fragments
> blackholed for 30 seconds at a time just because you have some normal run-of-the-mill packet loss.

Again, it will be trivial to have a use case where valid fragments are dropped.

Random can be considered as the worst strategy in some cases.

Queue management can tail drop, head drop, random drop, there is no
magical choice.

>
> I agree with you wholeheartedly that there isn't a solution to the DDoS attack issue, I'm not trying to address it. On
> the other hand, in the face of no attacks or otherwise malicious behavior, I'd expect Linux to not exhibit the complete
> blackholing of fragments that it does today.

Your expectations are unfortunately not something that linux can
satisfy _automatically_,
you have to tweak sysctls to tune _your_ workload.
