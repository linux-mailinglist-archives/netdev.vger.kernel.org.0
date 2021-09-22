Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6FA8414042
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 05:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhIVEBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 00:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhIVEBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 00:01:20 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F85C061574;
        Tue, 21 Sep 2021 20:59:51 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 145so1506679pfz.11;
        Tue, 21 Sep 2021 20:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uYpeDd1DTmTWFtDnEYCn18/wOle1/QG7fBxMGanOIL8=;
        b=Xl1TWoOHKmne1DN07EpX24jNQy7wHAe9jlwDrSukAkhCf3llS2wg8oagBUNUyRmRJj
         5t9j1E25IOUGPqGlbGC5mwuc3V0il0D93CDtNAP1wPtLpssqrhJ4L0gWeFhbKNJV8WB8
         TqE+gyUq/TINAifGc2ngyM23OM95SZob/le6Z1P7jKsGgD6zDp7lJob3/FL2CZ40QeDb
         2qU8hqqChwjwfanitRuj7Y1Myfp/REGedIgrh0Bm/PLQn3dU1jRpqmnqUGB+B0BczkmK
         AdP+isxikt8YeZqXZL2JgBlpabtvB693QUfvSye53QLy2eF23p6m/65rj6NQqMhfqW3+
         Y20Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uYpeDd1DTmTWFtDnEYCn18/wOle1/QG7fBxMGanOIL8=;
        b=KvSlrKRLQPKAlYxgXUw6LnMlqCpt/ZmzMtSkcRkIH94hdIxFjd3VR2jaNukQ84326k
         nG1EyWaJjI9XtoNgNZqIOOIS74mtozhtsi5pyLZe+ccUcWnkQfEj8LzF/QTge3Bsj6VJ
         pjwPZLSYGnrj3Q28pfrK+QGM0qT2mkcwb1VR5RpiFoEgpuONLyaDSNHoPmGZmtcgJTYR
         SGSJssNXsPwoKgIDde39bLw/59HC/HgCgsU3+X48Dxy5trgRJcz4jdEv9idkR4N9NAu6
         lxU93bi+uabTG09Fyv2O5yvS7RRWkTyjTNtbi2nTVVcQOVQBBDbx+v+xuDzUD/y+zDGD
         /7pQ==
X-Gm-Message-State: AOAM530pjar4DrwjP9Fn8kEeIALFZdHA0v0KMp5x1nKF0qYtSBdMA26E
        NhFX8lD4FpTlZ+DbaBrDGKbK5azDyiFRfnfNbBRb9f5W
X-Google-Smtp-Source: ABdhPJydVETSgjSpNOej3jwg2mzWpiuOCpS2T2lVipPMKWZ5/x3sw+fA2xY4+CnI3Ems8mUUXnl4+Ymyt2whaQ1H86Q=
X-Received: by 2002:a63:9a12:: with SMTP id o18mr3094025pge.167.1632283191027;
 Tue, 21 Sep 2021 20:59:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210913231108.19762-1-xiyou.wangcong@gmail.com> <CAADnVQJFbCmzoFM8GGHyLWULSmX75=67Tu0EnTOOoVfH4gE+HA@mail.gmail.com>
In-Reply-To: <CAADnVQJFbCmzoFM8GGHyLWULSmX75=67Tu0EnTOOoVfH4gE+HA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 21 Sep 2021 20:59:40 -0700
Message-ID: <CAM_iQpX2prCpPDmO1U0A_wyJi_LS4wmd9MQiFKiqQT8NfGNNnw@mail.gmail.com>
Subject: Re: [RFC Patch net-next v2] net_sched: introduce eBPF based Qdisc
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 17, 2021 at 11:18 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Sep 13, 2021 at 6:27 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > ---
> > v2: Rebase on latest net-next
> >     Make the code more complete (but still incomplete)
>
> What is the point of v2 when feedback on the first RFC was ignored?

They are not ignored for two reasons:

1) I responded to those reasonable ones in the original thread. Clearly
you missed them.

2) I also responded in changelog, please check the difference, clearly
V2 is much more lengthy than V1.

It becomes clear you ignored mine (either email or changelog), not
vice versa.

Please lead by examples, you are not actually following anything you
ask others to do. Remember the last time I asked you to expand your
changelog for bpf timer? You kept ignoring it. ;)

Thanks.
