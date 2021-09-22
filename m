Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD2C414F14
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 19:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236869AbhIVRaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 13:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236752AbhIVRaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 13:30:23 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24046C061574
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 10:28:53 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id w6so2247832pll.3
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 10:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sipanda-io.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Td9LQq/5ddsw5Az0b/N3PUCURyADaPa4A9s43ZAfiXM=;
        b=bbH4nJCqB+AQ4tq5ov07tUTfjRt1WzysUyB2hhdb+zezkVQhq5dkdgBhwDpEmSkiwS
         jo1nivJBdI5b8EC5zCBfBaC6ot4q69mScZpOCdWt7efUzDPUDtOevY06BEbqEHY0EP11
         NWSQaDZbDIKpwCUjHBonaQadpWJ/dTBNH8eVcxLbzBiXAdQKld9OMXK+mDKHEFTsrzVk
         S+DEVxns5XPGApVYlcLysxnQ/W3yVOA70hVc5yrG76tdgiU/R+Yj1BOCvGMFcJ5HUsRi
         M9SlZA9T2HrBPN1lBf7NXd5PDqsbfkeg83X1MYGkqtfFKzS+COPQ5tEpUOePQsqImXke
         4kpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Td9LQq/5ddsw5Az0b/N3PUCURyADaPa4A9s43ZAfiXM=;
        b=XbKapKMnish4iwbKb8wrIMhX+XOS4tUIk1OG3WLE8gTs8E4MlrF4tASHZuf6dktDaa
         1y2TnQKPCniW2H4KFyciLn0fx1Kk78dX8lCafeJnwdMU7XK7cYl54LlemcDdjl0NOZlo
         x48ZY1+sLMMcs/nZvVrkihBRUaNADMGKv158Mebma1xFXX5jiqvqQ8qE1oXOUua30kGu
         PovZQUjHAjsojTnJvzZ5yfIcsgVbJTE1W38y9C/4QaMxCGh3QJEshDg8R9mteNiBsKvs
         OTwcvlHs0C256Qd7qhl0MVqrrgh2166aV3O0pA1SNsi4wmlcEeXQNHyMo3A5JCsQtQPE
         N2ug==
X-Gm-Message-State: AOAM530JwZN7fNjeIXYYdRMicUdELS3EPcQeQFsqBATeXI7wo3YRAgVU
        5/AzwGuaUp/9m6BOtKChd2UEp/jN/GTybXvVaHs0VA==
X-Google-Smtp-Source: ABdhPJzUDn0dYTT0hqN8hadQH38VhaP0HtTzUVFo5bR0QJBtmr1RxdS7fj1AwkddaV+1KtA9JgYIgC3irGmiIWjq5Zg=
X-Received: by 2002:a17:902:7103:b0:13d:c2d4:f0ef with SMTP id
 a3-20020a170902710300b0013dc2d4f0efmr65681pll.32.1632331732485; Wed, 22 Sep
 2021 10:28:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210916200041.810-1-felipe@expertise.dev> <CAM_iQpUkdz_EjiuPRF_qKBp_ZHok_c8+pr4skCWGs_QTeLWpwA@mail.gmail.com>
 <YUq1Ez1g8nBvA8Ad@nanopsycho> <CAOuuhY8KA99mV7qBHwX79xP31tqtc9EggSNZ-=j4Z+awJUosdQ@mail.gmail.com>
 <20210922154929.GA31100@corigine.com>
In-Reply-To: <20210922154929.GA31100@corigine.com>
From:   Tom Herbert <tom@sipanda.io>
Date:   Wed, 22 Sep 2021 10:28:41 -0700
Message-ID: <CAOuuhY9NPy+cEkBx3B=74A6ef0xfT_YFLASEOB4uvRn=W-tB5A@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 0/2] net:sched: Introduce tc flower2
 classifier based on PANDA parser in kernel
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Felipe Magno de Almeida <felipe@sipanda.io>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Boris Sukholitko <boris.sukholitko@broadcom.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@idosch.org>, paulb@nvidia.com,
        Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 8:49 AM Simon Horman <simon.horman@corigine.com> wrote:
>
> On Wed, Sep 22, 2021 at 07:42:58AM -0700, Tom Herbert wrote:
> > On Tue, Sep 21, 2021 at 9:46 PM Jiri Pirko <jiri@resnulli.us> wrote:
> > >
> > > Wed, Sep 22, 2021 at 06:38:20AM CEST, xiyou.wangcong@gmail.com wrote:
> > > >On Thu, Sep 16, 2021 at 1:02 PM Felipe Magno de Almeida
> > > ><felipe@sipanda.io> wrote:
> > > >>
> > > >> The PANDA parser, introduced in [1], addresses most of these problems
> > > >> and introduces a developer friendly highly maintainable approach to
> > > >> adding extensions to the parser. This RFC patch takes a known consumer
> > > >> of flow dissector - tc flower - and  shows how it could make use of
> > > >> the PANDA Parser by mostly cutnpaste of the flower code. The new
> > > >> classifier is called "flower2". The control semantics of flower are
> > > >> maintained but the flow dissector parser is replaced with a PANDA
> > > >> Parser. The iproute2 patch is sent separately - but you'll notice
> > > >> other than replacing the user space tc commands with "flower2"  the
> > > >> syntax is exactly the same. To illustrate the flexibility of PANDA we
> > > >> show a simple use case of the issues described in [2] when flower
> > > >> consumes PANDA. The PANDA Parser is part of the PANDA programming
> > > >> model for network datapaths, this is described in
> > > >> https://github.com/panda-net/panda.
> > > >
> > > >My only concern is that is there any way to reuse flower code instead
> > > >of duplicating most of them? Especially when you specifically mentioned
> > > >flower2 has the same user-space syntax as flower, this makes code
> > > >reusing more reasonable.
> > >
> > > Exactly. I believe it is wrong to introduce new classifier which would
> > > basically behave exacly the same as flower, only has different parser
> > > implementation under the hood.
> > >
> > > Could you please explore the possibility to replace flow_dissector by
> > > your dissector optionally at first (kernel config for example)? And I'm
> > > not talking only about flower, but about the rest of the flow_dissector
> > > users too.
>
> +1
>
> > Hi Jiri,
> >
> > Yes, the intent is to replace flow dissector with a parser that is
> > more extensible, more manageable and can be accelerated in hardware
> > (good luck trying to HW accelerate flow dissector as is ;-) ). I did a
> > presentation on this topic at the last Netdev conf:
> > https://www.youtube.com/watch?v=zVnmVDSEoXc. FIrst introducing this
> > with a kernel config is a good idea.
>
> Can we drop hyperbole? There are several examples of hardware that
> offload (a subset of) flower. That the current kernel implementation has
> the properties you describe is pretty much irrelevant for current hw
> offload use-cases.

Simon,

"current hw offload use-cases" is the problem; these models offer no
extensibility. For instance, if a new protocol appears or a user wants
to support their own custom protocol in things like tc-flower there is
no feasible way to do this. Unfortunately, as of today it seems, we
are still bound by the marketing department at hardware vendors that
pick and choose the protocols that they think their customers want and
are willing to invest in-- we need to get past this once and for all!
IMO, what we need is a common way to extend the kernel, tc, and other
applications for new protocols and features, but also be able to apply
that method to extend to the hardware which is _offloading_ kernel
functionality which in this case is flow dissector. The technology is
there to do this as programmable NICs for instance are the rage, but
we do need to create common APIs to be able to do that. Note this
isn't just tc, but a whole space of features; for instance, XDP hints
is nice idea for the NIC to provide information about protocols in a
packet, but unless/until there is a way to program the device to pull
out arbitrary information that the user cares about like something
from their custom protocol, then it's very limited utility...

Tom
