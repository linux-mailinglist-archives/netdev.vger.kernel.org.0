Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 558F612DE10
	for <lists+netdev@lfdr.de>; Wed,  1 Jan 2020 08:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725809AbgAAHbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jan 2020 02:31:22 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54370 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgAAHbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jan 2020 02:31:22 -0500
Received: by mail-wm1-f65.google.com with SMTP id b19so3139387wmj.4
        for <netdev@vger.kernel.org>; Tue, 31 Dec 2019 23:31:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ETrZwtJWoVfOO6eG9wlxcB3tBdCydfQiewnKoNM2eSY=;
        b=owASbA+AO0X0S5eORJNbGNspDROqB+Y+iawKCfkody8FsJ+v0cCbhr8WlZ2t1FPM+1
         nQzEAOPERfZ5Gfg6aZIvPMB6vGiyMCm0RW1UeOh0YCwPblA7PpIyEPfS0wFAOTvzQ3Sp
         JOYvkvJBLztjyr28p98UUSL9E8WXwmW4Hr/euKPwf3e9vUFSU/Hfuxx4vYSd0quOd0bY
         oGbCbYxcqVoUs5kPmvITcrFiwqb8Irobs5BNXdcxnRACQuLen3OlIVgkwMarsJmsWMlx
         2l++mEBeT+isUO8z6OF5nCbkQqTQqTL0YIc+tdydOxDNasr9IbB+pkyghD9STrK/jX3M
         MSuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ETrZwtJWoVfOO6eG9wlxcB3tBdCydfQiewnKoNM2eSY=;
        b=GnNdK3i7I4m1tqK0PWU9PAljhoTs1nAqaKeXiRpK5SERrVwxUGcnUf5C7EIfKG37iN
         Xl7Pjv2w5a2VePluk4SXu2+rkAAMPAK5zvw+dQ3i7szmJY/VyabOmWtfqXcsBRvyYk6B
         6jVLMD9lMqgqwDLacUCQbUILuVXhOZrpcfe7xc0oj/rYGctvoYTlYADrDGBpdJSrTNS+
         2K1GyBQ6wpLb0JLnK/YZuSQQI678XbSdzVhMm7+sKiskNpfPxuFF+ct36GB2USAlnWER
         3hkJ3P3SWO+ho0SVmaAqb9XinBTxYyJrf7N8Y1WYRieT5wFqjNofvWmcqKiwHrNpAfuR
         c4lQ==
X-Gm-Message-State: APjAAAUkum+/ttNSp3MSEkGVeFVBzVbNbOmMey4rtmEPdKxkWppEoec+
        JiK+IicsyWdCE/w8nx5X7VJQhFx4KbCwYNJzzeQhaSHd
X-Google-Smtp-Source: APXvYqzNpMOpBx+Y07ABUJbFp8cN8na+4wk0M3a7ftXLRpVnWxmOZpY8pHDenfmFamPSb0UB7f/6jtZ0TI61eGcZ5BA=
X-Received: by 2002:a7b:c450:: with SMTP id l16mr8013613wmi.31.1577860586810;
 Tue, 31 Dec 2019 22:36:26 -0800 (PST)
MIME-Version: 1.0
References: <20191231112316.2788-1-gautamramk@gmail.com> <20191231112316.2788-2-gautamramk@gmail.com>
 <20191231090418.56adedc1@hermes.lan>
In-Reply-To: <20191231090418.56adedc1@hermes.lan>
From:   Leslie Monis <lesliemonis@gmail.com>
Date:   Wed, 1 Jan 2020 12:05:50 +0530
Message-ID: <CAHv+uoHxFfELR3oJFpvgzEBGP01b_9qB5o7=PVLPdk-ZbfS8sw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/2] net: sched: pie: refactor code
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Gautam Ramakrishnan <gautamramk@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dave Taht <dave.taht@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "Sachin D . Patil" <sdp.sachin@gmail.com>,
        "V . Saicharan" <vsaicharan1998@gmail.com>,
        Mohit Bhasi <mohitbhasi1998@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 31, 2019 at 10:34 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Tue, 31 Dec 2019 16:53:15 +0530
> gautamramk@gmail.com wrote:
>
> > From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>
> >
> > This patch is a precursor for the addition of the Flow Queue Proportional
> > Integral Controller Enhanced (FQ-PIE) qdisc. The patch removes functions
> > and structures common to both PIE and FQ-PIE and moves it to the
> > header file pie.h
> >
> > Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
> > Signed-off-by: Sachin D. Patil <sdp.sachin@gmail.com>
> > Signed-off-by: V. Saicharan <vsaicharan1998@gmail.com>
> > Signed-off-by: Mohit Bhasi <mohitbhasi1998@gmail.com>
> > Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
> > Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
> > ---
> >  include/net/pie.h   | 400 ++++++++++++++++++++++++++++++++++++++++++++
> >  net/sched/sch_pie.c | 386 ++----------------------------------------
> >  2 files changed, 415 insertions(+), 371 deletions(-)
> >  create mode 100644 include/net/pie.h
> >
> > diff --git a/include/net/pie.h b/include/net/pie.h
>
>
> Adding lots of static functions in a header file is not the way
> to get code reuse in Linux kernel. It looks like you just did
> large copy/paste from existing sch_pie.c to new header file.
>
> You can use reuse data structures and small 'static inline' functions in a header file.
> But putting code like drop_early in a header file is not best
> practice.
>
> You need to create a real kernel API for this kind of thing
> by making a helper module which is reused by multiple places.

Hi Stephen,

Thanks for the feedback.

We did initially think of using EXPORT_SYMBOL to reuse large
functions like drop_early. However, we wanted to keep our
changes consistent with the existing Codel/FQ-Codel
implementation, and so we decided to move the functions
common to sch_pie.c and sch_fq_pie.c (the module we wish to
add) to pie.h, as done by codel and fq_codel.

Since you mentioned that this is not best practice, we're thinking
of simply exporting the required symbols from sch_pie.c and not
making an external helper module. We'll then create a module
dependency for sch_fq_pie.c on sch_pie.c. We'll still add
the pie.h header file to keep structures and small inline functions.

Would you recommend we go ahead with this?

Thanks,
Leslie
