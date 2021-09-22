Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02989414C46
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 16:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236093AbhIVOoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 10:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbhIVOoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 10:44:39 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4922EC061574
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 07:43:09 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id a7so1926940plm.1
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 07:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sipanda-io.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2tgxA/zoqzlaNbHQEOmD22fkaHn15t9/DkGTYCXkf4U=;
        b=U+W7KewmR7t9d4rWt8MFc3gvoMZ18+qBHmkMCN44iFrYLWfESXpfopnFaREgKNAI3u
         54JuNw+GgupwdOU3DH/Pg9GXAmMM3jwNW0K3krhz1X+sIMAPWC2UOd/aeLdctLmDklu+
         /xcZ297pJVMGdijprZ1FEsdmu2gyxsacE4jYQ4M+YrOn3W/cDPxs+tBL/PJWnHL1zatY
         bcg0Dq+OH9VbJD2vLAeV+gcPeH/D8BkFfNTSKNZVWOvYn0sZNo8meyW1Kk/LMO8rVqpF
         TVpc+3JxkhiOqftneJZPRLNxYysiYyVUO65mZK160dEwD57lstBA3MhkfJUmGsWfuRir
         86mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2tgxA/zoqzlaNbHQEOmD22fkaHn15t9/DkGTYCXkf4U=;
        b=RTu8PFyb6Xfn/uiJrqnw92Me7x+R86VLk3GO1WI97SNt20R/CD3sbpDget0cRt1NBV
         +SL7N0EurW+yR6ey6ITQcdOTM00yn2oWUQGzcyaAXrmwRNqFVWFCfck3MeTSsywXvKTY
         xBVsEmMfn8qKHtGlwuSrTKfRxU/Wfgho586RofQR6HuEbWBQQZ6QcY9PDLlHz8wnKVSh
         KzYSjuORaiU2QacjUmyn3WJ4yctP2Vyxp4oluVCcHcgdM1zm3hGKjip3ROjdzn6SkC+u
         vE9hluO5dULDlMCXnoTdNIIStPpkim9qFe1/wvCGt6zF2zyjfPWmB7L4OqGv3PKWGob7
         zlNA==
X-Gm-Message-State: AOAM531rzFZNvsMgO35B6OJEoZoFCRWuJ71SoJrZGWvyE6dHxoVQq1n7
        bmKyFtXd1AKOmTcbZOV+5ZnNNVVH5f43jmVjAusZMw==
X-Google-Smtp-Source: ABdhPJyUuk79qnUDSispfGXSLym7edGeWflDLqwz+p0B7kyNwO1Krq0miw0i7bm8isH+Bz5YGPCEnXi4dlCWiyZPfRU=
X-Received: by 2002:a17:90a:588f:: with SMTP id j15mr11842668pji.177.1632321788626;
 Wed, 22 Sep 2021 07:43:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210916200041.810-1-felipe@expertise.dev> <CAM_iQpUkdz_EjiuPRF_qKBp_ZHok_c8+pr4skCWGs_QTeLWpwA@mail.gmail.com>
 <YUq1Ez1g8nBvA8Ad@nanopsycho>
In-Reply-To: <YUq1Ez1g8nBvA8Ad@nanopsycho>
From:   Tom Herbert <tom@sipanda.io>
Date:   Wed, 22 Sep 2021 07:42:58 -0700
Message-ID: <CAOuuhY8KA99mV7qBHwX79xP31tqtc9EggSNZ-=j4Z+awJUosdQ@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 0/2] net:sched: Introduce tc flower2
 classifier based on PANDA parser in kernel
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
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

On Tue, Sep 21, 2021 at 9:46 PM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Wed, Sep 22, 2021 at 06:38:20AM CEST, xiyou.wangcong@gmail.com wrote:
> >On Thu, Sep 16, 2021 at 1:02 PM Felipe Magno de Almeida
> ><felipe@sipanda.io> wrote:
> >>
> >> The PANDA parser, introduced in [1], addresses most of these problems
> >> and introduces a developer friendly highly maintainable approach to
> >> adding extensions to the parser. This RFC patch takes a known consumer
> >> of flow dissector - tc flower - and  shows how it could make use of
> >> the PANDA Parser by mostly cutnpaste of the flower code. The new
> >> classifier is called "flower2". The control semantics of flower are
> >> maintained but the flow dissector parser is replaced with a PANDA
> >> Parser. The iproute2 patch is sent separately - but you'll notice
> >> other than replacing the user space tc commands with "flower2"  the
> >> syntax is exactly the same. To illustrate the flexibility of PANDA we
> >> show a simple use case of the issues described in [2] when flower
> >> consumes PANDA. The PANDA Parser is part of the PANDA programming
> >> model for network datapaths, this is described in
> >> https://github.com/panda-net/panda.
> >
> >My only concern is that is there any way to reuse flower code instead
> >of duplicating most of them? Especially when you specifically mentioned
> >flower2 has the same user-space syntax as flower, this makes code
> >reusing more reasonable.
>
> Exactly. I believe it is wrong to introduce new classifier which would
> basically behave exacly the same as flower, only has different parser
> implementation under the hood.
>
> Could you please explore the possibility to replace flow_dissector by
> your dissector optionally at first (kernel config for example)? And I'm
> not talking only about flower, but about the rest of the flow_dissector
> users too.
>

Hi Jiri,

Yes, the intent is to replace flow dissector with a parser that is
more extensible, more manageable and can be accelerated in hardware
(good luck trying to HW accelerate flow dissector as is ;-) ). I did a
presentation on this topic at the last Netdev conf:
https://www.youtube.com/watch?v=zVnmVDSEoXc. FIrst introducing this
with a kernel config is a good idea.

Thanks,
Tom

> Thanks!
