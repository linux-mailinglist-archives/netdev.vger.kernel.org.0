Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6373C4242
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 05:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbhGLDwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 23:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233355AbhGLDwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 23:52:01 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F14C0613E8
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 20:49:14 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id k27so2103437edk.9
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 20:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p4z72USoXp4y4tTyIU/pxTOkyABNT80tvUTzg+9jcDs=;
        b=H0x0m31bjt8dBGQNpytW3UeI2tReeADtusGDCcUHsvu/WKwvq0fNf5hN3NVNjSphkA
         FKmxZP024iE0jSZVgcxJDgsH7vyoogA0TaojJvTuDWKV+yY/NiGiJeXIjXJgX1YQ5O7v
         Iwt6Mncf37sx3ja/rTbU7XxJX8ZvmHSI2Xu8y+Uz2jNpklX/Zt8taSvIzEzzRXg2j0pN
         uErBZXxkatA1g+BzLTk0cfbuMKs9ZIz7cg65zvl7DEcumyZcoC1qLwb2ADyqSItieoTI
         uK/ZA6j6KhL7IlEqjyYqho9TOBYisL+dbTiheNJf8z5NgAq4mPWs6z+HfbnNsKzT1050
         epWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p4z72USoXp4y4tTyIU/pxTOkyABNT80tvUTzg+9jcDs=;
        b=lQ2DPwo5e2VuP7l0Y2X5tXdl29S/1npeJbD+TOj4Pmx6khJMuCWkfWlCOEU/eQfAh4
         F+fHQ77tfp51FMieFGptAfWraix2xWm44alx/9in11h5TpRSMjMXe4P0U58NOTdzOzyp
         O3ZGMXyAy3Pqfxf+FBHg9GGBNUMIftczbttWLxMvzDfVbNqfK9c9dYueiT9KoJz27x+r
         ASJoc4CjYjuVBDE1vrPq3LJrCpAW/3hgVSSVgoYGoIshXBTuxezXxRZtZASw0mvMJKC9
         TlmloSUUV+iljezFPeerxb6yww+WIglxSjXuGGKf5fD0EI1XwfZ3lWFpeKCxSdib70Eb
         5Rtw==
X-Gm-Message-State: AOAM530/aUs37y5mVhblFAFREoeW+IB2HbmtdJLuHET9nvdfOl7WZRDP
        w/VMwNs+1ipYh4HtVsDoUxTuF5A/Xzz3xpya1+w=
X-Google-Smtp-Source: ABdhPJw6f22k9Goot+3FOmwK663mSyAAu+VgXkCFJW/mXcj5sEFYPA+VQ1GNVcPFYTD6i0nDzhWkqZGK4NsAQKljEzo=
X-Received: by 2002:a05:6402:2789:: with SMTP id b9mr27349558ede.201.1626061752598;
 Sun, 11 Jul 2021 20:49:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210711190308.8476-1-xiyou.wangcong@gmail.com>
 <CAMDZJNWWq2TGb6-nZRbBNfLevOyD2oSn941Nw_+7q0QzVep_GA@mail.gmail.com>
 <CAM_iQpUmO8S-7cgG=yy2TsNoc9nHpW__-WCfhcfV-_eAf46K7A@mail.gmail.com>
 <CAMDZJNXbwzXrHX1UT+DLsJvbKPh70-OPyrkTV=D05a5Mwcko3w@mail.gmail.com>
 <CAM_iQpUG28PBhXmqQeEzcWq8cNLFH1BzXaZ1FWGu1jqObGfdwg@mail.gmail.com>
 <CAMDZJNV9tbGE0Y1nZgMcp2Z5LU5Cb7YfJ+mS9rVogrin8SGxjQ@mail.gmail.com> <CAM_iQpVAuF0Pq1qmKRWoOvBPPMSaf1seKykEwYvVhm0tRkNo4A@mail.gmail.com>
In-Reply-To: <CAM_iQpVAuF0Pq1qmKRWoOvBPPMSaf1seKykEwYvVhm0tRkNo4A@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Mon, 12 Jul 2021 11:48:36 +0800
Message-ID: <CAMDZJNW5F3MDPYaRhx1o1ifPXQPnW_fdML=ap+Gis2PG9FB9Pg@mail.gmail.com>
Subject: Re: [Patch net-next v2] net_sched: introduce tracepoint trace_qdisc_enqueue()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 11:39 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Sun, Jul 11, 2021 at 8:36 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> >
> > On Mon, Jul 12, 2021 at 11:23 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > Sure, in that case a different packet is dropped, once again you
> > > can trace it with kfree_skb() if you want. What's the problem?
> > It's ok, but we can make it better. Yunsheng Lin may have explained why?
>
> Why it is better to trace dropped packets both in enqueue and in kfree_skb()?
I mean we can use one tracepoint to know what happened in the queue,
not necessary to trace enqueue and  kfree_skb()
If so, we must match when the packet is dropped and what packets. if
we use the return value in trace_qdisc_requeue. It
is easy to know what happened(when, where, what packets were dropped ).

> I fail to see it. You are just asking for duplications. If you do not see it by
> yourself, it means you don't understand or need it at all. ;)
I added the tracepoint in centos 8 4.18 kernel version in our servers
for a long time.
> Thanks.



-- 
Best regards, Tonghao
