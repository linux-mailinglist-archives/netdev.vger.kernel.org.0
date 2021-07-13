Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 608123C684C
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 03:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233834AbhGMCAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 22:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbhGMCAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 22:00:18 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B200C0613DD
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 18:57:28 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id t3so30835862edc.7
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 18:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vqH1suDv7X0f8ty7jQS5HouQPgOsklCg/PI3f7r9ZT0=;
        b=H8aVaC429jbp/YZcxKgdUYx7rFLEDxgOqeLtaBIU4f8TcRoWb4Jq4dxTJw2NJGBegY
         kp6BDD3eqarhE2cFdLEZFhOJXpTyvViqjO8+j2QJ57OeLethp3RF5JNzSZpqhHaCtbrn
         nT7TkNY35gYRzcAWm04CSVp4WAZSOJEYm1t/ILGp7ISb+UG6mRALqkOYpQe2fXtegcrX
         3aUYtwxg4GNS5wj8vh6pqkmZ5Ccn0TJNHnoKOvWbf5QsKWnTv0lHSLbGcLvrMV4m7poh
         dDYC6eMKQKZ/qkD9xrRJ+xD+fPXPBoqffCaryW3z0qK9np5xd+6ZbWeJVpMCiRCabhLF
         Edng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vqH1suDv7X0f8ty7jQS5HouQPgOsklCg/PI3f7r9ZT0=;
        b=QJJ+QS+OeR0Xrzei9BHB/se4h8uQe+j+Fx8QRaA4o6tq35NNINlPJaRCPTUigh8D/l
         a9KvnHiIItW9dHQap1O5KSPXBxuY5rHbWHkOKHHqko881N8wwNFIv9O7PS6Qccao43T8
         31C7J2xsMnJNEU38TVK+S0bhMpQrogGFQezs/0u4m/8AleRzbiqjUMJQcSaq0H4iRkwT
         UQLbbhvGLYkpdVogBx2Yw/2IWVbLdz/eRk5LPv+BhJwRH7JNAoRItkMzh9BpyUAa3S1s
         eiFYL/Wu6OngpHdYrWI4eImnCXRYBVTBIMa+mHNSqZC/mXzOlfiejPfhvFN+kwAuY1I5
         2EEA==
X-Gm-Message-State: AOAM531XFt2KD42gttMWkoS2yAS/sdjRmZVYPuDDEKXNcDvRBXp0TQTc
        3BSFNEs+G0Do9oM2ieF4nRag2DdQaLBoqzA+u9o=
X-Google-Smtp-Source: ABdhPJyxSGIhuyLf0zb0fSQp1oKTaYSp+yCCFJL5aenAnnPApkdVY+TlOGjnUihNyGaygitvEy41JNsrg7fToSTRFsM=
X-Received: by 2002:a05:6402:168f:: with SMTP id a15mr2309731edv.3.1626141447208;
 Mon, 12 Jul 2021 18:57:27 -0700 (PDT)
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
 <CAM_iQpXhC6Jj+KE-L8UTyasTgVDyLDPS4rbXau2MVzwH41N-7g@mail.gmail.com>
 <CAMDZJNXzPum_1_GkW+w28QgVhcMvq3rz=OOEE5XbdDfTYvCTAw@mail.gmail.com> <CAM_iQpUJcL23=iZQqMwiiFNnDP12oWk+CVHUe5BYZ812z31DCQ@mail.gmail.com>
In-Reply-To: <CAM_iQpUJcL23=iZQqMwiiFNnDP12oWk+CVHUe5BYZ812z31DCQ@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 13 Jul 2021 09:56:51 +0800
Message-ID: <CAMDZJNXKvyXUZy53=CDyQ8RNfNK2_0-arxRWn40LoLOZY5F1UQ@mail.gmail.com>
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

On Mon, Jul 12, 2021 at 12:45 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Sun, Jul 11, 2021 at 9:41 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> >
> > On Mon, Jul 12, 2021 at 12:20 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > On Sun, Jul 11, 2021 at 9:12 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > > >
> > > > On Mon, Jul 12, 2021 at 12:02 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > >
> > > > > On Sun, Jul 11, 2021 at 8:49 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > > > > >
> > > > > > On Mon, Jul 12, 2021 at 11:39 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > > > >
> > > > > > > On Sun, Jul 11, 2021 at 8:36 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > > > > > > >
> > > > > > > > On Mon, Jul 12, 2021 at 11:23 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > > > > > > Sure, in that case a different packet is dropped, once again you
> > > > > > > > > can trace it with kfree_skb() if you want. What's the problem?
> > > > > > > > It's ok, but we can make it better. Yunsheng Lin may have explained why?
> > > > > > >
> > > > > > > Why it is better to trace dropped packets both in enqueue and in kfree_skb()?
> > > > > > I mean we can use one tracepoint to know what happened in the queue,
> > > > > > not necessary to trace enqueue and  kfree_skb()
> > > > >
> > > > > This is wrong, packets can be dropped for other reasons too, tracing
> > > > no matter where the packet is dropped, we should allow user to know
> > > > whether dropped in the enqueue.  and the
> > > > what the return value.
> > >
> > > Again you can know it by kfree_skb(). And you can not avoid
> > > kfree_skb() no matter how you change enqueue. So, I don't see your
> > No, If I know what value returned for specified qdisc , I can know
> > what happened, not necessarily kfree_skb()
>
> This is wrong. You have to trace dropped packets because you
> need to know when to delete the key (skb address) from the hashtable
> you use to calculate the latency. You save the key on enqueue and
> remove it on both dequeue and kfree_skb, the only difference is you
No, we can set the timestamp or cb in  skb in enqueue and check them in dequeue.
we may not use the hashtable.
If we use hashtable, we still can check the return value, save them to
hashtable or not.
> only need to calculate the timestamp difference for the former.
>
> Thanks.



-- 
Best regards, Tonghao
