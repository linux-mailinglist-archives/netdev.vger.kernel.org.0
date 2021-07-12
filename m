Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715D23C42B8
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 06:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbhGLEPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 00:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhGLEPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 00:15:39 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C51AC0613DD
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 21:12:50 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id he13so31787277ejc.11
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 21:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+w773fSAbp2IeNQ2T07cIjy6rYxfln7naSunEDB1/w8=;
        b=uKXnKaPSg0hT308pr03uVk6wORV3mjaBV9VoEHM59L4QWyc3dGhVlDf2+KmeLaASTX
         tNTcY3i0GmvHx5s1QCilvyCRLuTTIRqt8wmmirarsgbZ1yJgrIdVuC2Is5VgQUhSRPQG
         darTxP/7mRMIp+B+rUHKGVOaA7/Ga8AFpZDgN4JYzi1im/xNcbiZvNSOZSYyg5McVYcE
         Skvgwz0rLoeNDaZLBHRtBNyzuzlZz1bXKy65Bhn7+uQ96WzWbp45Pn9z61fyaylKMGDw
         Vo8Qv6Wr7qxi7YEDwLXGVy8JO1uo5D41GIGtZUdMMeHinAOLw35k5ncSvOi1RkMQrDsr
         5hQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+w773fSAbp2IeNQ2T07cIjy6rYxfln7naSunEDB1/w8=;
        b=as+PSYj0rI4JibNoLDnzDKSuebaPqEqhQqoD5mkTBnrDrfZ0TEHplyzBHM9ywoTWjy
         XcFw8+y5qb9p+yTGVcigtLKrCDU75aAfeFdJELGGWRDw3uPo3JsU3ESAYxrwSYXJLzrr
         JFklS4gM2VSYIshdvMxarXIOm3Dh+6fk+c27RjaNi+Vdtb5INWKC+3a/+cisQl22UYg2
         kd6r0ZE1shnMbO1YatJh5hdDUivDFjhyuH5gtzI9AaX+3uEFqhvUsGVLs/XFPfxZ2ZTi
         4qfOGSiOnZFwLPYe4SeLC5GV4vb2kiIlx9AQI9OAuvf+I60sK76013b2gDrxRcdAH8nn
         oQ1A==
X-Gm-Message-State: AOAM533Bchi6VuS1lrB0xgZAuEZJmF5rxAomv/ysBxqwXM1N5D1p0/uM
        NUkjVhuC3VTz0UAdZaMfC2ac98vI0Jhamr8w9Jw=
X-Google-Smtp-Source: ABdhPJx65JcMd1dGBdBiF+x8WkzVxzU0Qy+Nhp+crG465qErWO5DQ+A7kzT0AG2Hy53EC2Saiklxn+eIKSEZrjXq3Ug=
X-Received: by 2002:a17:906:eda7:: with SMTP id sa7mr5640056ejb.135.1626063168603;
 Sun, 11 Jul 2021 21:12:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210711190308.8476-1-xiyou.wangcong@gmail.com>
 <CAMDZJNWWq2TGb6-nZRbBNfLevOyD2oSn941Nw_+7q0QzVep_GA@mail.gmail.com>
 <CAM_iQpUmO8S-7cgG=yy2TsNoc9nHpW__-WCfhcfV-_eAf46K7A@mail.gmail.com>
 <CAMDZJNXbwzXrHX1UT+DLsJvbKPh70-OPyrkTV=D05a5Mwcko3w@mail.gmail.com>
 <CAM_iQpUG28PBhXmqQeEzcWq8cNLFH1BzXaZ1FWGu1jqObGfdwg@mail.gmail.com>
 <CAMDZJNV9tbGE0Y1nZgMcp2Z5LU5Cb7YfJ+mS9rVogrin8SGxjQ@mail.gmail.com>
 <CAM_iQpVAuF0Pq1qmKRWoOvBPPMSaf1seKykEwYvVhm0tRkNo4A@mail.gmail.com>
 <CAMDZJNW5F3MDPYaRhx1o1ifPXQPnW_fdML=ap+Gis2PG9FB9Pg@mail.gmail.com> <CAM_iQpWHvY1h-xdUxWk+PhQcMRqSmnDpzxvBLXKh1mARYzQfmg@mail.gmail.com>
In-Reply-To: <CAM_iQpWHvY1h-xdUxWk+PhQcMRqSmnDpzxvBLXKh1mARYzQfmg@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Mon, 12 Jul 2021 12:12:12 +0800
Message-ID: <CAMDZJNUMXFYJ9_UdWnv8j74fJZ4T6psdxMvbmRBzTAJuZBeQAA@mail.gmail.com>
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

On Mon, Jul 12, 2021 at 12:02 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Sun, Jul 11, 2021 at 8:49 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> >
> > On Mon, Jul 12, 2021 at 11:39 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > On Sun, Jul 11, 2021 at 8:36 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > > >
> > > > On Mon, Jul 12, 2021 at 11:23 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > > Sure, in that case a different packet is dropped, once again you
> > > > > can trace it with kfree_skb() if you want. What's the problem?
> > > > It's ok, but we can make it better. Yunsheng Lin may have explained why?
> > >
> > > Why it is better to trace dropped packets both in enqueue and in kfree_skb()?
> > I mean we can use one tracepoint to know what happened in the queue,
> > not necessary to trace enqueue and  kfree_skb()
>
> This is wrong, packets can be dropped for other reasons too, tracing
no matter where the packet is dropped, we should allow user to know
whether dropped in the enqueue.  and the
what the return value.
> enqueue is clearly not sufficient even if you trace it unconditionally.
> For a quick example, codel drops packets at dequeue rather than
> enqueue. ;)
>
> > If so, we must match when the packet is dropped and what packets. if
> > we use the return value in trace_qdisc_requeue. It
> > is easy to know what happened(when, where, what packets were dropped ).
>
> I am afraid you have to watch the dropped packets.
>
> Thanks.



-- 
Best regards, Tonghao
