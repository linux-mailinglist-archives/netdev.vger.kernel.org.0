Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0098E38DBBD
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 17:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbhEWQAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 12:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbhEWQAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 12:00:13 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA856C061574;
        Sun, 23 May 2021 08:58:45 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id s25so30224683ljo.11;
        Sun, 23 May 2021 08:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oJfOL4jgQvwZZnmyB0vc7B8VulLXtFtfhhTh+z5Afbk=;
        b=j4cOAYFODN57ON6QKvzV+NTYsYNm5nx1AZ//ukVBIS35+SL//crAkiwBBTlPrR8sds
         EuZatLGb3YuIuBPX8Kf8OcgwlBOU1c1xfnsY3Ur0NRD6p3gtVCJphoGXpRIKsv4jtisi
         691XYkHu67uJ3Uz9C22meiAIkdu/Kwi1IFkINUDNgODz7bMp5RYo9cmzQ3vPj7H0Kuz7
         kX+tcsOss2RS45n86ZM7m2IRVmkYHolSgvEfAFSIBPVBpq5GWI9021OF1XHZ/Tqc3BC+
         bxuKE39mfEajAjvs5Z0w3QX4W7456sxJfaDndMVkPFKWGk9lY/zxP9qmvMwapw5eovWj
         hLTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oJfOL4jgQvwZZnmyB0vc7B8VulLXtFtfhhTh+z5Afbk=;
        b=W79r2XJY7vG/ssP1k0/jUgRacVV3fbm1CPWBkIUmWy1ln6gQ+ThP9sWaNwrjtL0yIG
         m96yQlzwsg67g7K1Ub9t3zXpIJN5L3pzAOPtqwrjlvfrozDLbSMLmH1DU55iXbqMeYYn
         JXJgxzV0wjyjIOjbEwpA1/bAMjLb4rTofgz/3ByQOdCVJvMECOeVmmPU6McIEDKgBiC1
         KkCWfVoo6Oatf3qJgZnUaG9ZpYgBiMkeH0uwshw+02coXrvTsqjz4VovuUHmq3o9uPmC
         guGxeHNsfp2my7omcZb+AKH+HOiA6RN0ljXTPbLNM63iftYRqHRKjXj5vMvdv4JGPM8u
         uc7w==
X-Gm-Message-State: AOAM532AGWMlfEW2F2TcbNg3lvGle4+HpPsJtCy9bFGJsDLyRfTH2q5g
        qcqwSOnQC07mpcFWTyQheo95UtyReGSuwb6qFu65u78M
X-Google-Smtp-Source: ABdhPJws8VqhT0FGENFVXTh0aCBgBvYH0c8Qj6Dhq37na2KjcIGT92l5bbcmjREnlzlhS8LuECKG44iaurOuBplBr8g=
X-Received: by 2002:a2e:575d:: with SMTP id r29mr13442811ljd.32.1621785524263;
 Sun, 23 May 2021 08:58:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210520185550.13688-1-alexei.starovoitov@gmail.com> <87o8d1zn59.fsf@toke.dk>
In-Reply-To: <87o8d1zn59.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 23 May 2021 08:58:33 -0700
Message-ID: <CAADnVQL9xKcdCyR+-8irH07Ws7iKHjrE4XNb4OA7BkpBrkkEuA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next] bpf: Introduce bpf_timer
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 23, 2021 at 4:48 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Still wrapping my head around this, but one thing immediately sprang to
> mind:
>
> > + * long bpf_timer_mod(struct bpf_timer *timer, u64 msecs)
> > + *   Description
> > + *           Set the timer expiration N msecs from the current time.
> > + *   Return
> > + *           zero
>
> Could we make this use nanoseconds (and wire it up to hrtimers) instead?
> I would like to eventually be able to use this for pacing out network
> packets, and msec precision is way too coarse for that...

msecs are used to avoid exposing jiffies to bpf prog, since msec_to_jiffies
isn't trivial to do in the bpf prog unlike the kernel.
hrtimer would be great to support as well.
It could be implemented via flags (which are currently zero only)
but probably not as a full replacement for jiffies based timers.
Like array vs hash. bpf_timer can support both.
