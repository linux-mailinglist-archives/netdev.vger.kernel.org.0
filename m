Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4146738F24F
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 19:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233328AbhEXRfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 13:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232708AbhEXRfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 13:35:38 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23CBDC061574;
        Mon, 24 May 2021 10:34:09 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id i9so41761860lfe.13;
        Mon, 24 May 2021 10:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=i0TsmB3/zdRH2kK7K+Plvc8NTcuPf+iiWrcQ//Xg9KY=;
        b=H0Ug129o6BKsmtQX7DnHP18bPbcNxarWpMTmDM2z2EArXE1zNaF/LgrzDaSSole4YF
         BWPJey5AmpfbkLbKIevfdvG6TNtcWW5dN+cAn2Qqrm1QwX1LFc2SieyTY5+0awcLoiF4
         OISMFidkR4mTVkf0E/8eOVockX0yEHK3TsQQGyXFvvwYBpxOAopwK/QLlQTC/uPUp6Ue
         uxgoWMV0fktV1AMOEFE/8Njwqxwui3xLC0oPUmzKI2ytDBFJwy6x7tTPgBvwLXSaaIhj
         zdRr1p+Z9B+Bw+RIu1YE3rzqslXqtPi6IFeSDcaaEOAgoWXHB4kItEnGrtws2gIUGWt7
         0CsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=i0TsmB3/zdRH2kK7K+Plvc8NTcuPf+iiWrcQ//Xg9KY=;
        b=gw+9h4oFQ8/aZwLeg9uC9w37HjLk6y/Lrixw8wsE3DnchS8kZtKRhlGUEPUdFs8Ysd
         //ir80uXXPMTfaOexP8qeCZ89KPeihGrzEbgrHU0U+cMlq97ULmdG41ESrUTZKJGqSAK
         AeINQd87ZhL3HCsA9DlbeDCLLpwBqEOQjJkHvWejHTe1fA0mTk5U0rLBTmPnAjXQomyU
         L9vr5FujHnKGY/Ri1ns4K8y1DTd9O4FvKaHrXU0oO/MzlMV3HkyzWQqjdKBU8yWfIsjW
         4/+mT7BtEX/pXCtmc+Z03P12834ONNrUEUAJDHYUkFcG4dt9n4iAsQ5yLxhmI678ALPy
         0yHQ==
X-Gm-Message-State: AOAM530iG+NeISN2nTxYGko7Ej2ybeQ9de0vxN+ifwDiIQ+oqMBQeEXs
        ZPqFMnKScIWt2ReaOnl/ovWdKVRO02GWdzDkTntI14Tz
X-Google-Smtp-Source: ABdhPJyEfY3BPzZVQ3LVEcfeXIi4j7s5u5Xq6H6S3YMqMoI3Rvo1XSoisyRLUb0JBmgZwTNUbODR7+eTGTg6/VwOI8E=
X-Received: by 2002:a05:6512:c21:: with SMTP id z33mr11677256lfu.539.1621877647446;
 Mon, 24 May 2021 10:34:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210520185550.13688-1-alexei.starovoitov@gmail.com>
 <87o8d1zn59.fsf@toke.dk> <CAADnVQL9xKcdCyR+-8irH07Ws7iKHjrE4XNb4OA7BkpBrkkEuA@mail.gmail.com>
In-Reply-To: <CAADnVQL9xKcdCyR+-8irH07Ws7iKHjrE4XNb4OA7BkpBrkkEuA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 24 May 2021 10:33:56 -0700
Message-ID: <CAADnVQL8qw4OYQp+ozJpgPnimNYV7PtShZ-4tqdY7fTBhHf2ww@mail.gmail.com>
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

On Sun, May 23, 2021 at 8:58 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sun, May 23, 2021 at 4:48 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
> >
> > Still wrapping my head around this, but one thing immediately sprang to
> > mind:
> >
> > > + * long bpf_timer_mod(struct bpf_timer *timer, u64 msecs)
> > > + *   Description
> > > + *           Set the timer expiration N msecs from the current time.
> > > + *   Return
> > > + *           zero
> >
> > Could we make this use nanoseconds (and wire it up to hrtimers) instead=
?
> > I would like to eventually be able to use this for pacing out network
> > packets, and msec precision is way too coarse for that...
>
> msecs are used to avoid exposing jiffies to bpf prog, since msec_to_jiffi=
es
> isn't trivial to do in the bpf prog unlike the kernel.
> hrtimer would be great to support as well.
> It could be implemented via flags (which are currently zero only)
> but probably not as a full replacement for jiffies based timers.
> Like array vs hash. bpf_timer can support both.

After reading the hrtimer code I might take the above statement back...
hrtimer looks strictly better than timerwheel and jiffies.
It scales well and there are no concerns with overload,
since sys_nanonsleep and tcp are heavy users.
So I'm thinking to drop jiffies approach and do hrtimer only.
wdyt?
