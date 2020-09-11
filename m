Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA3426581B
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 06:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725562AbgIKEUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 00:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgIKEUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 00:20:41 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C0D3C061573;
        Thu, 10 Sep 2020 21:20:41 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id x77so4797954lfa.0;
        Thu, 10 Sep 2020 21:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WCD5sAY3q1xf3zuoTVAQhjlZUF+7j2sllfT56EASGbw=;
        b=LTf5O1CWxtJhz6pajoo09m3m1aMboW7ayu+jhI/0Ca46mPDVbXweRxaTrcm8vTGdQm
         zd2WrWf80sZWkByM8gofNsp3k11gTDDeMhhBj7AE/WsvkA2XI5Ba8NhxTxPAft/FOI8c
         IHHChpCWcBUc8sKb4TMdnvEmVsAj75i5MfM08kAYnuz5miJstt9d0aS5oV3MNP8oJLLW
         MJ0JvzfdvifUYaCMQ7vrvW21lMEd4aTKVmkOovW0/HIjUGM0r5gdeGup3aFfgtJErLTQ
         Hn06t4FlKn1L+PhWaLCFOfEmMfWb/a3qywqZ+KlhFqAt04X5Qd3c9eS2gu8LcHRyOQxn
         AGNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WCD5sAY3q1xf3zuoTVAQhjlZUF+7j2sllfT56EASGbw=;
        b=rlrnWNNnQXtwYedP6OYq56613U6YS9+NzJpdhAa2CnRMQTzmPtKPhI4pCP5SfrK+H3
         n56r1Xq3FvNwvPMKTus+NlHLw/kw8uvcmoqcHE6izg/MTDVZILLbqCXhSIdJXRGfT+nQ
         iftu0UiEfApp3lF+Lol/NiNVTd0jY44UVJTkzrjK/mA/VUai0VIFA0F9tDry5spwoxW3
         4hpYAqxck7jTDEpQN0vzPK3TM/0dASff/ak78j7ZP1uGX6+8du+tn8Yp4wfcNo+1y63p
         FlAjHKE4g1JGbfUObtji0/MLl2O04GfFbTPblvjAbKISLy40SG7DJbwPeBLyTc5L/Jqu
         yTKg==
X-Gm-Message-State: AOAM533AzeExA/2bGHPEaWTO9O0V67U4r3jP6aA4pusDLzUCfvBKGyTM
        wLkpgVOjI/y5ZBTXnFEHty2Hhqm+zY8jjFg0YRg=
X-Google-Smtp-Source: ABdhPJzQGlm4EJ3R2SElL2AvGfMxCaNbtwliG7i2nJLKXCRIS4fRYdp390R/EfwkEZf/ax9HN6hr/t/M97vEumKWEMI=
X-Received: by 2002:a05:6512:2101:: with SMTP id q1mr5586269lfr.157.1599798039600;
 Thu, 10 Sep 2020 21:20:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200910193536.2980613-1-ncardwell.kernel@gmail.com> <20200911032844.wrlgcpoc6fkk2gw4@kafai-mbp>
In-Reply-To: <20200911032844.wrlgcpoc6fkk2gw4@kafai-mbp>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 10 Sep 2020 21:20:28 -0700
Message-ID: <CAADnVQJ8FnZEJ0fnODoRP-kKYsM4wj=H=cRx18DbEhgn=376Tw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 0/5] tcp: increase flexibility of EBPF
 congestion control initialization
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Neal Cardwell <ncardwell.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        bpf <bpf@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 8:28 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Thu, Sep 10, 2020 at 03:35:31PM -0400, Neal Cardwell wrote:
> > From: Neal Cardwell <ncardwell@google.com>
> >
> > This patch series reorganizes TCP congestion control initialization so that if
> > EBPF code called by tcp_init_transfer() sets the congestion control algorithm
> > by calling setsockopt(TCP_CONGESTION) then the TCP stack initializes the
> > congestion control module immediately, instead of having tcp_init_transfer()
> > later initialize the congestion control module.
> >
> > This increases flexibility for the EBPF code that runs at connection
> > establishment time, and simplifies the code.
> >
> > This has the following benefits:
> >
> > (1) This allows CC module customizations made by the EBPF called in
> >     tcp_init_transfer() to persist, and not be wiped out by a later
> >     call to tcp_init_congestion_control() in tcp_init_transfer().
> >
> > (2) Does not flip the order of EBPF and CC init, to avoid causing bugs
> >     for existing code upstream that depends on the current order.
> >
> > (3) Does not cause 2 initializations for for CC in the case where the
> >     EBPF called in tcp_init_transfer() wants to set the CC to a new CC
> >     algorithm.
> >
> > (4) Allows follow-on simplifications to the code in net/core/filter.c
> >     and net/ipv4/tcp_cong.c, which currently both have some complexity
> >     to special-case CC initialization to avoid double CC
> >     initialization if EBPF sets the CC.
> >
> > changes in v2:
> >
> > o rebase onto bpf-next
> >
> > o add another follow-on simplification suggested by Martin KaFai Lau:
> >    "tcp: simplify tcp_set_congestion_control() load=false case"
> >
> > changes in v3:
> >
> > o no change in commits
> >
> > o resent patch series from @gmail.com, since mail from ncardwell@google.com
> >   stopped being accepted at netdev@vger.kernel.org mid-way through processing
> >   the v2 patch series (between patches 2 and 3), confusing patchwork about
> >   which patches belonged to the v2 patch series
> Acked-by: Martin KaFai Lau <kafai@fb.com>

Applied.

Martin, thanks for the review.

Neal, please keep Acks when you resubmit patches without changes in the future.
Also please follow up with a selftests/bpf based on test_progs to
cover new functionality.

Thanks
