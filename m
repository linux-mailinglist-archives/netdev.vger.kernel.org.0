Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 397289067F
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 19:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbfHPRL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 13:11:26 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:41207 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbfHPRL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 13:11:26 -0400
Received: by mail-lj1-f194.google.com with SMTP id m24so5916927ljg.8;
        Fri, 16 Aug 2019 10:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pomgRJ7Y2sXH2jwOj1STrfBEpF6Npzd1J1w6kjGaA7I=;
        b=V09iSrJB11CPwaVXLTWmkalvCsvviM5lMGdxCHwSKRtgTgQJeiwSyZLj7QS2h2hTv+
         /GyEPYEFyaDR7pTQCCZ/TYAwP0Rp0/I/ZMwbM+L+nSDscRkEL0RXxpG6ox5i4CYHDmm+
         bqHJtwzuTi372tdOLBpnQwgEogGlHK7yqjGU9xfDtpZxuF8HVmDXj5uzgSLks6D50DE7
         bI8W0h62RV9mQm0YtPQsR6HkAATLGVun+5+GwWG8DQFllMwg15YtnUNjjH+h5V6LMnLR
         rWyiQGlB2qfXxJJhcrfDkk82Bsjx839xomcKY0XSbhuPsO29s3b4w+zZBcf2//SoDS7S
         8g5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pomgRJ7Y2sXH2jwOj1STrfBEpF6Npzd1J1w6kjGaA7I=;
        b=CwBiWqJk1eIPKTkAI+vU/ePSkBC4KdK3CggQj1Sq01hpGYFUT1nEI5coMMiQv6tplB
         itBc8Ew7MoP6OfuGT313MiTNaswLGnju4toS8UsRE6OYo+LGuTpC1HmHL4ijwBo1ZCWd
         0p36kD7YmiHxHyj/Tw/0HB2l3/dDfIZ0nzYSbx88ivgs9ICjbnYmz7LLQbQDHggHecXa
         5I16CgU+Si54cqXBri4/a/QzIamlnL0l5B74d80U0Y5oSpOFflddALUcP1qqYhhbiv4K
         wlsAUeD1gWBLDPPCaFvMuefIZiogR8wq435EZpXMp/5WPmAX0m8I7/Pn0k26l0NnioiA
         4vjg==
X-Gm-Message-State: APjAAAWVqUtmMcyDIvY9ClefcFuUYMVLMTjnryxHBpHjEg8iMk+kLrJ8
        rgRi2sP+3mcoGtxXJS48GH64PuHKuAOBT0aJK3jcRcVJ
X-Google-Smtp-Source: APXvYqwCt936J4gdClYGjHqc54971ltTrNCQlDsaH8hkF76+C3mbCJF0xIDmHAPTPe5E7hnUufFw/K1kTu6nM0qDKDw=
X-Received: by 2002:a2e:7818:: with SMTP id t24mr4448140ljc.210.1565975484175;
 Fri, 16 Aug 2019 10:11:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190815143220.4199-1-quentin.monnet@netronome.com>
 <CAADnVQKpPaZ3wJJwSn=JPML9pWzwy_8G9c0H=ToaaxZEJ8isnQ@mail.gmail.com> <10602447-213f-fce5-54c7-7952eb3e8712@netronome.com>
In-Reply-To: <10602447-213f-fce5-54c7-7952eb3e8712@netronome.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 16 Aug 2019 10:11:12 -0700
Message-ID: <CAADnVQLPg8jEsUbKOxzQc5Q1BKrB=urSWiniGwsJhcm=UM7oKA@mail.gmail.com>
Subject: Re: [PATCH bpf 0/6] tools: bpftool: fix printf()-like functions
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 16, 2019 at 9:41 AM Quentin Monnet
<quentin.monnet@netronome.com> wrote:
>
> 2019-08-15 22:08 UTC-0700 ~ Alexei Starovoitov
> <alexei.starovoitov@gmail.com>
> > On Thu, Aug 15, 2019 at 7:32 AM Quentin Monnet
> > <quentin.monnet@netronome.com> wrote:
> >>
> >> Hi,
> >> Because the "__printf()" attributes were used only where the functions are
> >> implemented, and not in header files, the checks have not been enforced on
> >> all the calls to printf()-like functions, and a number of errors slipped in
> >> bpftool over time.
> >>
> >> This set cleans up such errors, and then moves the "__printf()" attributes
> >> to header files, so that the checks are performed at all locations.
> >
> > Applied. Thanks
> >
>
> Thanks Alexei!
>
> I noticed the set was applied to the bpf-next tree, and not bpf. Just
> checking if this is intentional?

Yes. I don't see the _fix_ part in there.
Looks like cleanup to me.
I've also considered to push
commit d34b044038bf ("tools: bpftool: close prog FD before exit on
showing a single program")
to bpf-next as well.
That fd leak didn't feel that necessary to push to bpf tree
and risk merge conflicts... but I pushed it to bpf at the end.
