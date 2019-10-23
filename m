Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAA35E22CA
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 20:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404278AbfJWSzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 14:55:43 -0400
Received: from mail-vk1-f176.google.com ([209.85.221.176]:33870 "EHLO
        mail-vk1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388827AbfJWSzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 14:55:43 -0400
Received: by mail-vk1-f176.google.com with SMTP id d126so4693237vkb.1
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 11:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9EqzpExtl/ux5Yo0ZcFqJ17tBhof++1guV50lUMfMe0=;
        b=l9aAh92A2/mSYl16vLQ0jNWS3av3tWBf41rVZC8YRdvXpUJe/CjePlkLVb55HCjIQF
         CfNdo7/r5GDVhyPR6NzO340huqb0BYYNwKPuuqzJnz3U7fK9MKaxPBfpG+flYK0pI/ay
         e6KYjPlDrtX1glpxLU5KHhtoRDnEImzpDJm7KfhOuKB0bvtjKM5mVb7pe3KSAAps8wcF
         SDb8Yg7uWuIo1QPbss9yQSEl9EsKWcoWeb0h6Hii79v9XsApBjkTIYNOKAG+dGetBNZ2
         XKB7TLuQOB7MakkFou19/h3ECg09RnaviJqIPBYSmoqWEHPAJhSXOIhVV9TffWoUafHI
         VLjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9EqzpExtl/ux5Yo0ZcFqJ17tBhof++1guV50lUMfMe0=;
        b=jRmQUwItLeWD9YLhH/Cv2Ac+80bxdrEXkXDGG11qNRZtk/9arBo05OBtw6OgIM4k2J
         9MZBB/UW2lLVAaDZbbPcIugTDf7vu4IZHubWN/rotJLcxQevL3HMTZQG0kkteFA9QOW0
         rocJtGzAlpcGdcoQOvGELkoQc6KOnay99KyynEXBGhgE8GMSjscE2dDc8gZm6CC8QKqU
         kUYENeJUaHyRtBWMR5XjqlTDrVH4ZgSaCEftgoQozN3W5337SkLZORLn2bU4sVd70Krd
         63zAz3jz+Q3FkXtHq7VvTq2RtfiMOzV13Vgz+84SiTDTCUx3JmGoPcDKb33iQP7SWxd2
         wSVw==
X-Gm-Message-State: APjAAAWTkBvPmm3hUQmLyAB0DJTXAStf2YXRQSGxlOZlvwJVE6yYH2+I
        F0h5QB27gswvaiPplfcr8WuZb14jY6Ppyx3fs+CDOA==
X-Google-Smtp-Source: APXvYqz52nNYU6nNJBCmTywfg7HpxODG0WFftuoooH5REXbg13zSx79+taFDZ4FCi0mxHyS+VsuHUBIf49aWeeqQ2DA=
X-Received: by 2002:a1f:5846:: with SMTP id m67mr6402553vkb.13.1571856941905;
 Wed, 23 Oct 2019 11:55:41 -0700 (PDT)
MIME-Version: 1.0
References: <20191022231051.30770-1-xiyou.wangcong@gmail.com>
 <20191022231051.30770-4-xiyou.wangcong@gmail.com> <CANn89i+Y+fMqPbT-YyKcbQOH96+D=U8K4wnNgFkGYtjStKPrEQ@mail.gmail.com>
 <CAM_iQpWxDN7Wm_ar7cStiMnhmmy7RK=BG5k4zwD+K6kbgfPEKw@mail.gmail.com>
 <CANn89i+Q5ucKuEAt6rotf2xwappiMgRwL0Cgmvvnk5adYb-o0w@mail.gmail.com>
 <CAM_iQpWah2M2tG=+eRS86VtjknTiBC42DSwdHB8USpXgRsfWjw@mail.gmail.com>
 <CANn89iKNAg9gwe-ZLSoknwG6-XS44aRZrEv4pDeiON50uXv-0A@mail.gmail.com> <CAM_iQpUyMjdDO9gbrzqS3f3A2LW9dFJRuZfcm=EsJwDAdZdMxA@mail.gmail.com>
In-Reply-To: <CAM_iQpUyMjdDO9gbrzqS3f3A2LW9dFJRuZfcm=EsJwDAdZdMxA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 23 Oct 2019 11:55:30 -0700
Message-ID: <CANn89iKN5TiSYaZEwmUHKMXv+Rg1onNOZDOkNRHNKKpPbo2eaw@mail.gmail.com>
Subject: Re: [Patch net-next 3/3] tcp: decouple TLP timer from RTO timer
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 11:30 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Wed, Oct 23, 2019 at 11:14 AM Eric Dumazet <edumazet@google.com> wrote:
> > > In case you misunderstand, the CPU profiling I used is captured
> > > during 256 parallel TCP_STREAM.
> >
> > When I asked you the workload, you gave me TCP_RR output, not TCP_STREAM :/
> >
> > "A single netperf TCP_RR could _also_ confirm the improvement:"
>
> I guess you didn't understand what "also" mean? The improvement
> can be measured with both TCP_STREAM and TCP_RR, only the
> CPU profiling is done with TCP_STREAM.
>

Except that I could not measure any gain with TCP_RR, which is expected,
since TCP_RR will not use RTO and TLP at the same time.

If you found that we were setting both RTO and TLP when sending 1-byte message,
we need to fix the stack, instead of working around it.

> BTW, I just tested an unpatched kernel on a machine with 64 CPU's,
> turning on/off TLP makes no difference there, so this is likely related
> to the number of CPU's or hardware configurations. This explains
> why you can't reproduce it on your side, so far I can only reproduce
> it on one particular hardware platform too, but it is real.
>

I have hosts with 112 cpus, I can try on them, but it will take some time.
