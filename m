Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 900953C420E
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 05:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbhGLDmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 23:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhGLDmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 23:42:45 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24EC1C0613DD
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 20:39:57 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id b8-20020a17090a4888b02901725eedd346so9728473pjh.4
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 20:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vQQ0MpPMRz9OBcQJYvRLXO3eD6i5PyGXY2h7PbYlJPY=;
        b=sBi4JVfDYshhacKOBsT8Nwmn9bM2okjeANczytjlcu/vO1C2Ar0P2Xr+7gsGT80Ehe
         tawgKY7EMYPAfC5ppdHGQ3Js+hA6pto+zkskwQ5fj8VM+aYlgWGpAo9L1zgoVIUNE/MB
         fL/MXe51OCCV7UUh3mbZLVp/IxN5AcCD84AoGOedCAIXJWRzkWKokwAxfOZ0KI9Rmxj4
         lXop8YfXWee1R38yHw2l3vpMrMfyWt6eH+cOekk/OeHp65R/+ceDP6LyKfum+8S3tpu8
         eAGdxOby7N+CZNtDE4dVl2uxRP98MfJ8jDr+mE5re1QoaOJV+ZiyBpSKK9o50NV39v9l
         4mXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vQQ0MpPMRz9OBcQJYvRLXO3eD6i5PyGXY2h7PbYlJPY=;
        b=YJkivzknCPV+u+y82Da24BtvvJWmUTtSXVB5leb2dfe2dafHtgKCXrmwYkTaoP/g2w
         9nDmRpd0STSJSClUpnoRo3+q6iCsZRW3dcYdTyOKUVxGXydxPbGNo1euUgLsqIV+cAeu
         E7KHMIw59kmkj4fZs7SsFqeIdr2CHXq75AvIid/jtLCvuOd3mCNSyPMlyYWReQlteXGh
         X+tXzzjIFMy8fTgYUGAVPPNHeAWECmzixi1XYb7Tcfxe10eg70w4A6Qh2E+QIJ5CoOMO
         O9ss8vUgD81toNYDGR3ZY1952dUxNp5CzpYTi2/vzyJyTpCpR0Azcd7pKEWi8TQrvLBT
         cl8g==
X-Gm-Message-State: AOAM530h44XSwjKlEhZvam5b9F4ojETQ6aKBH2MWAri5mLdQjXWMiSr3
        HLSKLGbs5hEvFqLk/XvAErRckkJ+Pw8HZXoYL2o=
X-Google-Smtp-Source: ABdhPJx7hH5tE4zgTPeYmFfuC6Xl4iEoP9u8TCxNgAmo7iIz7ISnNaD65k7kGiIPEYECGcxccuSWhmGsnIO7jckYs80=
X-Received: by 2002:a17:90a:7bc3:: with SMTP id d3mr2644065pjl.145.1626061196757;
 Sun, 11 Jul 2021 20:39:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210711190308.8476-1-xiyou.wangcong@gmail.com>
 <CAMDZJNWWq2TGb6-nZRbBNfLevOyD2oSn941Nw_+7q0QzVep_GA@mail.gmail.com>
 <CAM_iQpUmO8S-7cgG=yy2TsNoc9nHpW__-WCfhcfV-_eAf46K7A@mail.gmail.com>
 <CAMDZJNXbwzXrHX1UT+DLsJvbKPh70-OPyrkTV=D05a5Mwcko3w@mail.gmail.com>
 <CAM_iQpUG28PBhXmqQeEzcWq8cNLFH1BzXaZ1FWGu1jqObGfdwg@mail.gmail.com> <CAMDZJNV9tbGE0Y1nZgMcp2Z5LU5Cb7YfJ+mS9rVogrin8SGxjQ@mail.gmail.com>
In-Reply-To: <CAMDZJNV9tbGE0Y1nZgMcp2Z5LU5Cb7YfJ+mS9rVogrin8SGxjQ@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 11 Jul 2021 20:39:45 -0700
Message-ID: <CAM_iQpVAuF0Pq1qmKRWoOvBPPMSaf1seKykEwYvVhm0tRkNo4A@mail.gmail.com>
Subject: Re: [Patch net-next v2] net_sched: introduce tracepoint trace_qdisc_enqueue()
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 11, 2021 at 8:36 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> On Mon, Jul 12, 2021 at 11:23 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > Sure, in that case a different packet is dropped, once again you
> > can trace it with kfree_skb() if you want. What's the problem?
> It's ok, but we can make it better. Yunsheng Lin may have explained why?

Why it is better to trace dropped packets both in enqueue and in kfree_skb()?
I fail to see it. You are just asking for duplications. If you do not see it by
yourself, it means you don't understand or need it at all. ;)

Thanks.
