Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3095D381463
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 01:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234456AbhENX6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 19:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbhENX6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 19:58:53 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA131C06174A;
        Fri, 14 May 2021 16:57:40 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id 69so185295plc.5;
        Fri, 14 May 2021 16:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ny0JJSNyYb72XxiD4WufkpR97ipkPoi111ZR0+SVODY=;
        b=BABkgwIOWNZKUkoUzzdrSRG/24KO/xNnO7FdEL0tJr8I/XR6zgmDhiK4EbQnVitKC5
         LkWSYrZLrYyE3uwiCPBKY/KoyXi/tQEllhbpbacbXEcDRq3FYa4J0UWV5ZZY4B1csOw8
         GCpItBessQ5FJ2B2rKu3onkNq+Qb2ZjRdJuKybFvAT0qTtJSFi0UY31RqAbk3699IXLH
         qtN/tw8kkeXo/0/C2gW8/EBFnU9iCdasdFn9IsoT8mQLPfp5Or5tGkMN5yGKNVX0LoH0
         +Wv68lNCYp4bXiNfN6YNvgL0MHN0eEhWRkq5xhnTCmd25haSk3K4grb/kgnEnoRRfHVI
         1muA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ny0JJSNyYb72XxiD4WufkpR97ipkPoi111ZR0+SVODY=;
        b=T4oxfXVTzpPsb/j7q9R5IqubSkD57tzW8pBFpuJhDli38XNc6YPFei02Cp11Dr5OKO
         ZH0VOjCud9/MVFHzZOBK03qgsOtUedD6NGs6dbZsIl9JEFCxav+Y3e826pjxHySkK4ri
         QMGZvJlV7e+XcD0rtPVAvPQXUyNrTjxWoblGvT7QzvVnHhplsAar3KOPPR6GZEhzGyxn
         ansjWtxW4s5cMbzEbVEzd/2rI22bMRZJFAq3f4s7cU8Rv8Pv9XOm4xmhdpkwteKLWNEH
         kVhYaHsTAulRwmrpX4f8UwB4yiLrClpOy6noBJkbyNRIGA0rOSjDNgxfSMR6nPw0vhlW
         WNww==
X-Gm-Message-State: AOAM533N5TXnz5QSagvzLgxEI7S3FWkK6Xy9phPkPu+x4S+DlWnPgqyW
        ENzWBNFxXF2CieVqlu7phEtdWedpt3qdJoGCpW4=
X-Google-Smtp-Source: ABdhPJzqZ3L8hiX7siRw9AwMvxwt8ZVytvT7tOdftd9YZm5SvaQNUtZGRHSEAUlMrpCDqOm+gsezZTb3JFdNupr6Rpc=
X-Received: by 2002:a17:902:c784:b029:ef:b14e:2b0b with SMTP id
 w4-20020a170902c784b02900efb14e2b0bmr6475625pla.64.1621036660409; Fri, 14 May
 2021 16:57:40 -0700 (PDT)
MIME-Version: 1.0
References: <1620959218-17250-1-git-send-email-linyunsheng@huawei.com>
 <1620959218-17250-2-git-send-email-linyunsheng@huawei.com>
 <CAM_iQpXWgYQxf8Ba-D4JQJMPUaR9MBfQFTLFCHWJMVq9PcUWRg@mail.gmail.com> <20210514163923.53f39888@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20210514163923.53f39888@kicinski-fedora-PC1C0HJN>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 14 May 2021 16:57:29 -0700
Message-ID: <CAM_iQpXZNASp7+kA=OoCVbXuReAtOzHnqMn8kFUVfi9_qWe_kw@mail.gmail.com>
Subject: Re: [PATCH net v8 1/3] net: sched: fix packet stuck problem for
 lockless qdisc
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        David Miller <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        "Cong Wang ." <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@openeuler.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>, kpsingh@kernel.org,
        bpf <bpf@vger.kernel.org>, Jonas Bonn <jonas.bonn@netrounds.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        Josh Hunt <johunt@akamai.com>, Jike Song <albcamus@gmail.com>,
        Kehuan Feng <kehuan.feng@gmail.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>, atenart@kernel.org,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Hillf Danton <hdanton@sina.com>, jgross@suse.com,
        JKosina@suse.com, Michal Kubecek <mkubecek@suse.cz>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 4:39 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 14 May 2021 16:36:16 -0700 Cong Wang wrote:
> > > @@ -176,8 +202,15 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
> > >  static inline void qdisc_run_end(struct Qdisc *qdisc)
> > >  {
> > >         write_seqcount_end(&qdisc->running);
> > > -       if (qdisc->flags & TCQ_F_NOLOCK)
> > > +       if (qdisc->flags & TCQ_F_NOLOCK) {
> > >                 spin_unlock(&qdisc->seqlock);
> > > +
> > > +               if (unlikely(test_bit(__QDISC_STATE_MISSED,
> > > +                                     &qdisc->state))) {
> > > +                       clear_bit(__QDISC_STATE_MISSED, &qdisc->state);
> >
> > We have test_and_clear_bit() which is atomic, test_bit()+clear_bit()
> > is not.
>
> It doesn't have to be atomic, right? I asked to split the test because
> test_and_clear is a locked op on x86, test by itself is not.

It depends on whether you expect the code under the true condition
to run once or multiple times, something like:

if (test_bit()) {
  clear_bit();
  // this code may run multiple times
}

With the atomic test_and_clear_bit(), it only runs once:

if (test_and_clear_bit()) {
  // this code runs once
}

This is why __netif_schedule() uses test_and_set_bit() instead of
test_bit()+set_bit().

Thanks.
