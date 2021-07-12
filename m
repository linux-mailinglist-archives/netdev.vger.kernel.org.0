Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBBB33C428B
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 06:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbhGLEFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 00:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhGLEFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 00:05:44 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21B6C0613DD
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 21:02:55 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id h1so8460589plf.6
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 21:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZjmdE1p9mXy6K35jxul6c+GHlwlg63B+szxkMUrQdd0=;
        b=R9SveXHZHIqYqYUCnOGyY4lvhyEAqKMKGIqCxUGDKGxWncLEOvKfbZ1m+7e7jSpoc0
         RaHnTi0uw4xyH96rDsKb5giVW2VocEaWyzVESxnlhwMf+q4V/8jydl6U5v6gwVBo3SS6
         ll0oO9sXCaVsdOrBzSm3LOZA3VkPJpt3kw1nEMD3fTbr2D7y+itzqqFKk2ojgMvCnVqU
         jsxun/hnSYqUKRtd468BJxfcfqyUwH11G5zEwLFAH2e6IzNZx202N3FZtESB9SdvBdeS
         JeBv9eKBSUIqsmIiYhzMcZ2MlMV4pO/NRMMNY59vVejfiMiRgfju9QY8BNKjkWsTBIBD
         5JyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZjmdE1p9mXy6K35jxul6c+GHlwlg63B+szxkMUrQdd0=;
        b=ithZbzJJYl2XH6vV/CGzyCnwhqCaTqdCDn7LxLxODxEdlEBVRYJHLKzHEl5QVzJQu5
         p7SeuJghOOVhoff6gtpORRjhpjGYDMNiuHDdaLHXouCLkuYth+LSsjrU+aI68VkKNyZQ
         ij69lAA5yzHuA2LJ0iuc7sKKp+o/tFbsCWqlBqoGMfvzMPs0ZnhSj1S5/74yRFjtSk4s
         fgKFD7oe6zckNiQoIY12v+iyheOQ0klRsGP3LGdtCXF7taz6/ZAqjUc5/wIc7mlSCVfM
         bMQRpRQFXXH5vK0cu8IOQQ/VH0vAt+Grf7AkRrYG/m+oUF/QXx+ShAQr3epCeTbVTuci
         cZBA==
X-Gm-Message-State: AOAM530/kytFWF1gU/qkfHXYxxHVV8S2KaxNWc4MH1NuxJR0fcPCQa97
        N14FVzM0/jhcHL/7FnvDotZboMZxl/RM2JPjLaQ=
X-Google-Smtp-Source: ABdhPJygcV1JG6KyhklpilWYtNU7vHBY17PXa5U1FA+7cve2CfbJC1F86AF9AlmtRzpR0/CKn6oB2o88rtr4R1a+a2Y=
X-Received: by 2002:a17:90a:17c1:: with SMTP id q59mr50819967pja.231.1626062575458;
 Sun, 11 Jul 2021 21:02:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210711190308.8476-1-xiyou.wangcong@gmail.com>
 <CAMDZJNWWq2TGb6-nZRbBNfLevOyD2oSn941Nw_+7q0QzVep_GA@mail.gmail.com>
 <CAM_iQpUmO8S-7cgG=yy2TsNoc9nHpW__-WCfhcfV-_eAf46K7A@mail.gmail.com>
 <CAMDZJNXbwzXrHX1UT+DLsJvbKPh70-OPyrkTV=D05a5Mwcko3w@mail.gmail.com>
 <CAM_iQpUG28PBhXmqQeEzcWq8cNLFH1BzXaZ1FWGu1jqObGfdwg@mail.gmail.com>
 <CAMDZJNV9tbGE0Y1nZgMcp2Z5LU5Cb7YfJ+mS9rVogrin8SGxjQ@mail.gmail.com>
 <CAM_iQpVAuF0Pq1qmKRWoOvBPPMSaf1seKykEwYvVhm0tRkNo4A@mail.gmail.com> <CAMDZJNW5F3MDPYaRhx1o1ifPXQPnW_fdML=ap+Gis2PG9FB9Pg@mail.gmail.com>
In-Reply-To: <CAMDZJNW5F3MDPYaRhx1o1ifPXQPnW_fdML=ap+Gis2PG9FB9Pg@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 11 Jul 2021 21:02:44 -0700
Message-ID: <CAM_iQpWHvY1h-xdUxWk+PhQcMRqSmnDpzxvBLXKh1mARYzQfmg@mail.gmail.com>
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

On Sun, Jul 11, 2021 at 8:49 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> On Mon, Jul 12, 2021 at 11:39 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Sun, Jul 11, 2021 at 8:36 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > >
> > > On Mon, Jul 12, 2021 at 11:23 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > Sure, in that case a different packet is dropped, once again you
> > > > can trace it with kfree_skb() if you want. What's the problem?
> > > It's ok, but we can make it better. Yunsheng Lin may have explained why?
> >
> > Why it is better to trace dropped packets both in enqueue and in kfree_skb()?
> I mean we can use one tracepoint to know what happened in the queue,
> not necessary to trace enqueue and  kfree_skb()

This is wrong, packets can be dropped for other reasons too, tracing
enqueue is clearly not sufficient even if you trace it unconditionally.
For a quick example, codel drops packets at dequeue rather than
enqueue. ;)

> If so, we must match when the packet is dropped and what packets. if
> we use the return value in trace_qdisc_requeue. It
> is easy to know what happened(when, where, what packets were dropped ).

I am afraid you have to watch the dropped packets.

Thanks.
