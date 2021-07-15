Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7573C9727
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 06:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235901AbhGOE1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 00:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbhGOE1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 00:27:22 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851DAC06175F
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 21:24:30 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 62so4732090pgf.1
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 21:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ffn7ehD3wO2JuWKBy0gpI3O+DP3o4Rpv0/eSQCMvr44=;
        b=YJPYdrSQ6X5imofcJTplIPVfBu+KPHZQAVjtZssZomRtdDqSYS4TnMGZTNJgRNajLK
         6k+homhGPIpBZ3tIwad+PhglnFHXbg3b2j53j7tgG30KzuQrUVWB5kJAdv+yNybA5iUw
         vqe4BHxQyF3cxlMX5AglOAVoETtAlp99x4OZhVOQVwE/2DFqDRAZOSv+wWEaVC8mZ7PI
         UTJxPSRHL6sTm7QcZgIZcC7O4P8kv/TsBfZEOhvKKuGHVwtllP0TBb2KgWF/2iiMexV9
         U6LgqOfSyJ8B1yNzBfHp29oihAqX7jghz8fc1YbRS7F2Jrms8Tego79XW/Tja89uiS1r
         u5pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ffn7ehD3wO2JuWKBy0gpI3O+DP3o4Rpv0/eSQCMvr44=;
        b=dXdznE5JlOVXJD3f3hGNo3C6CAnuIZZcC4ogtNDZ8iQqWrP0czopot9VzFCPDKfh8p
         4yapjjudSbG9/5Ns5KwwlOgkFf9JIhM96PiQjAa2ciAbGQNOedyBrilgsqCh8dgt0JLA
         bPMI94inasSRe0i8O+KGa78e8bXkAVp6zcVubPK+hAuLPIhPpLEJz5e+HHdU4tN/aEhb
         tglvUuoVyS3kM1b5s3IH1NddjBoDnhOEJtMqvl1OEkfwLIC+fD4hH8dcVC7N+mZudBhA
         geMPik5KedQjUCugcXULCwjyTOQMbcIp1zGMzi84ROwtHR2ARXQAm4J6eK/sgQ116Ntq
         hgtg==
X-Gm-Message-State: AOAM530X+lQzc8fgdAnSwLYe94iEP6HKU704QWCYPBCQbP4W9VMwYG4P
        1VyBM5XRaeXt7zVnKhmi/cK5JjL9zvagNRF3EBc=
X-Google-Smtp-Source: ABdhPJxHJ7BMHKp8rpZINzCl1ieoEdqMR3yQ8jbUV5Nz2D9vVaQwcfAQxFqqlIqa1oRWTscocYmHEfRwwyBPRU5ky2g=
X-Received: by 2002:a62:ea1a:0:b029:329:a95a:fab with SMTP id
 t26-20020a62ea1a0000b0290329a95a0fabmr2109002pfh.31.1626323070118; Wed, 14
 Jul 2021 21:24:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210711050007.1200-1-xiangxia.m.yue@gmail.com>
 <20210711050007.1200-2-xiangxia.m.yue@gmail.com> <CAM_iQpUtQGDx6yJtY5sxYVd3wNqBSDYAZ4uHZonkFQDrnLo8cQ@mail.gmail.com>
 <CAMDZJNWfRQ_M=6E=jyOSKWMso73nNY1iKw4jyN8JU7NkSyDQcA@mail.gmail.com> <CAMDZJNVg0E3SevntjJVm99RdggSxD_oOX=3EXU1v-sQLgDGvNQ@mail.gmail.com>
In-Reply-To: <CAMDZJNVg0E3SevntjJVm99RdggSxD_oOX=3EXU1v-sQLgDGvNQ@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 14 Jul 2021 21:24:18 -0700
Message-ID: <CAM_iQpXM-xhy_kVNk73235nFvU13jtN=kj7aG+ZuwcbY2V+tHQ@mail.gmail.com>
Subject: Re: [net-next 2/2] qdisc: add tracepoint qdisc:qdisc_requeue for
 requeued SKBs
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 7:07 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> On Mon, Jul 12, 2021 at 12:17 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> >
> > On Mon, Jul 12, 2021 at 11:51 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > On Sat, Jul 10, 2021 at 10:00 PM <xiangxia.m.yue@gmail.com> wrote:
> > > >
> > > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > >
> > > > The main purpose of this tracepoint is to monitor what,
> > > > how many and why packets were requeued. The txq_state can
> > > > be used for determining the reason for packets requeued.
> > >
> > > Hmm, how can I figure out the requeue is caused by
> > > validate_xmit_skb_list() when it returns again==true?
> Hi cong
> Consider this patch again.
> The main purpose of this tracepoint is to monitor what, how many and
> why packets were requeued.
> So should we figure out packets required by validate_xmit_skb_list or
> dev_hard_start_xmit ?
> because we may want to know what packets were requeued and how many.
>
> if we should figure out, we can add more arg for trace, right ?

Figuring out which case is important to determine the cause,
so you have to fix it to make it useful.

Thanks.
