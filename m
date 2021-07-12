Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADDD3C434A
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 06:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhGLEsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 00:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229466AbhGLEsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 00:48:41 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F812C0613DD
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 21:45:53 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 62so17033819pgf.1
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 21:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3NA5Md/qc4Cw3DTbBYO3fo588asxlOkzmJV+jUdXIrg=;
        b=NrTOXL222I7tdOBueOEFHvjj6KHLNexaU0S7o8anXU5AU5p8lWNpWTLToJ1D4QctMJ
         hpewmCMew68Cby88bNo8u+xEjmFH5NKDSlg3AUPUR3g5aKZ/3J9rSygV5hVadv92g99e
         fXExEukoj2v4yiqFWDGEX76HaBPDnRVorZeh9pYJE/JqAaXecMqLcuK6NKZHPRc4PP07
         lecyKrzSATLkWKLqEEa8a+H9Z2IKV6K9TiLOloPzA9/FXky4la8xX/afkEKHhkxTbGRD
         vSahPZEE7WHxD3XWksKMcp2yfXlGS2EB+PLRba01S8mN8HDVPjkTFCr4oHRRoLAHl6wj
         40Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3NA5Md/qc4Cw3DTbBYO3fo588asxlOkzmJV+jUdXIrg=;
        b=W2VzIXunxFcmOUwj/bOfK/0NqyaO58YXgLdABLzoWJAtVpiAHcyR1Vc43Cnp7kq/5m
         BQLxStyrBnquMIKq9AZCrU1Wf1FziGED7f4FMHm9qt9MlrN9EZdFCdtfyBYEN4gw2nfB
         VJ1RrIqzGLb/hVX6kHcV9DaZXt1PDHEqb2m+A5Z4ZQYlbijXnI2RpxYRVrtoVvCE4Q2U
         kEul98f1J5UcnWYrND9NWsCXvhassk3RSVH6TNeg+2uhYgDBjIrgLuWgK7xt7XrGryIT
         tuTfTdc3lUhOPMJSOXWaO5waHeRjy6StzTJRBWljYNYhI69LYeGJQSS+aZDPihbV1/uG
         PwgQ==
X-Gm-Message-State: AOAM533+PDiyrueXN7dMLZojR4tCDs91K6A6sx5mFpSP79TTVtHY21wh
        IwpDYifKKCfjN3gslD8eAhy0I4J58vUOaXHehJo=
X-Google-Smtp-Source: ABdhPJxnF3SEY6CI0ULjJZ0BcoWbuGyI0EbzwwjkpyymdQzehaL8s9EW5bKBoXKqdO4XVez9gDY0JkqU8tZhx4aU+ZA=
X-Received: by 2002:a65:4b8d:: with SMTP id t13mr49077950pgq.18.1626065152585;
 Sun, 11 Jul 2021 21:45:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210711190308.8476-1-xiyou.wangcong@gmail.com>
 <CAMDZJNWWq2TGb6-nZRbBNfLevOyD2oSn941Nw_+7q0QzVep_GA@mail.gmail.com>
 <CAM_iQpUmO8S-7cgG=yy2TsNoc9nHpW__-WCfhcfV-_eAf46K7A@mail.gmail.com>
 <CAMDZJNXbwzXrHX1UT+DLsJvbKPh70-OPyrkTV=D05a5Mwcko3w@mail.gmail.com>
 <CAM_iQpUG28PBhXmqQeEzcWq8cNLFH1BzXaZ1FWGu1jqObGfdwg@mail.gmail.com>
 <CAMDZJNV9tbGE0Y1nZgMcp2Z5LU5Cb7YfJ+mS9rVogrin8SGxjQ@mail.gmail.com>
 <CAM_iQpVAuF0Pq1qmKRWoOvBPPMSaf1seKykEwYvVhm0tRkNo4A@mail.gmail.com>
 <CAMDZJNW5F3MDPYaRhx1o1ifPXQPnW_fdML=ap+Gis2PG9FB9Pg@mail.gmail.com>
 <CAM_iQpWHvY1h-xdUxWk+PhQcMRqSmnDpzxvBLXKh1mARYzQfmg@mail.gmail.com>
 <CAMDZJNUMXFYJ9_UdWnv8j74fJZ4T6psdxMvbmRBzTAJuZBeQAA@mail.gmail.com>
 <CAM_iQpXhC6Jj+KE-L8UTyasTgVDyLDPS4rbXau2MVzwH41N-7g@mail.gmail.com> <CAMDZJNXzPum_1_GkW+w28QgVhcMvq3rz=OOEE5XbdDfTYvCTAw@mail.gmail.com>
In-Reply-To: <CAMDZJNXzPum_1_GkW+w28QgVhcMvq3rz=OOEE5XbdDfTYvCTAw@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 11 Jul 2021 21:45:41 -0700
Message-ID: <CAM_iQpUJcL23=iZQqMwiiFNnDP12oWk+CVHUe5BYZ812z31DCQ@mail.gmail.com>
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

On Sun, Jul 11, 2021 at 9:41 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> On Mon, Jul 12, 2021 at 12:20 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Sun, Jul 11, 2021 at 9:12 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > >
> > > On Mon, Jul 12, 2021 at 12:02 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > >
> > > > On Sun, Jul 11, 2021 at 8:49 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > > > >
> > > > > On Mon, Jul 12, 2021 at 11:39 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > > >
> > > > > > On Sun, Jul 11, 2021 at 8:36 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > > > > > >
> > > > > > > On Mon, Jul 12, 2021 at 11:23 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > > > > > Sure, in that case a different packet is dropped, once again you
> > > > > > > > can trace it with kfree_skb() if you want. What's the problem?
> > > > > > > It's ok, but we can make it better. Yunsheng Lin may have explained why?
> > > > > >
> > > > > > Why it is better to trace dropped packets both in enqueue and in kfree_skb()?
> > > > > I mean we can use one tracepoint to know what happened in the queue,
> > > > > not necessary to trace enqueue and  kfree_skb()
> > > >
> > > > This is wrong, packets can be dropped for other reasons too, tracing
> > > no matter where the packet is dropped, we should allow user to know
> > > whether dropped in the enqueue.  and the
> > > what the return value.
> >
> > Again you can know it by kfree_skb(). And you can not avoid
> > kfree_skb() no matter how you change enqueue. So, I don't see your
> No, If I know what value returned for specified qdisc , I can know
> what happened, not necessarily kfree_skb()

This is wrong. You have to trace dropped packets because you
need to know when to delete the key (skb address) from the hashtable
you use to calculate the latency. You save the key on enqueue and
remove it on both dequeue and kfree_skb, the only difference is you
only need to calculate the timestamp difference for the former.

Thanks.
