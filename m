Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5E6866E794
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 21:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbjAQURP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 15:17:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234182AbjAQUNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 15:13:32 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628CB5A379
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 11:07:17 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id e130so5793610yba.7
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 11:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rg4n1ogTNZE8zVKA0GkLNQ+skmhg6w21j7gfbPPbUB4=;
        b=5166G40t5E5W+pVoLzCHWg87dtBpAP3Q2bMd62jTo3RnmRakI2Zjr62IEwDqZV7flJ
         exyCaB1eHy5p7otrygNdG2o1H2yMvjs8BgYAtvlFMmj/AjBGG2O1bKXlPczVd0Ibaitb
         9sWvByrpPjrwr4c/BoLfhH7J6g5oyarBPgbQMmNZcYjx83a4OCIQi8AyR4ISguVOXdY5
         N0dsI4zC/Kp2bnCFmA0+oZeyUueTXXnnA+E9tr8bNpjf24IO1dgzkkvHE43KOLOm79lV
         LikINohZJf6RSUMo/joUQPMiOO/JduiPb0Mta9Psr/vS8wn+zC9USAqVrQtABNHDqofS
         P7uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rg4n1ogTNZE8zVKA0GkLNQ+skmhg6w21j7gfbPPbUB4=;
        b=rsHaTQVjb0IGe47HaWLQxrPm8/vABmGVa+mtPibxdSk5C98nkm284jvNixpv6lLQUN
         /+PzeA6XC8i7WkrNZzFpp7uJetWSnW5/VUFWFy9NGRTJPSxyRvbIgYs9QfvzDkuZurAl
         gPQ//YbmsKvORfDcAyyqkcWXNahsmfM+wrsy3Ji2EgfJRUwKaLUd7Y90YaKvvtMlalNa
         rajAZmUiRtiiAecqukWYxTxQpZuQ4eXkSGOW/8qUBnDRtDou5pVElYlReMrMf6Fi6sB3
         F0bGALQtF6S95X6oRYaKpLSCW5y4LJuS78NYfsdTEWMQO3YGzkxWtjaoNEmY+KSApQCl
         m5LA==
X-Gm-Message-State: AFqh2kq80uKImAZWABGloJRPDqaKxIckmN9AODKq9mEIm0F9rNYqhauB
        Jc+FmpGL8WLFCPzH5b+qLViU74eoGoBfcSCvdzKykw==
X-Google-Smtp-Source: AMrXdXt39kBNGNeA4D9WGitcsDjUst90MOmbA4M8YzMJyUICPCBkzWTbMpG/cLlfIHc5i+y9tyPbviGpgvC9rG+Ogtw=
X-Received: by 2002:a25:6642:0:b0:7c5:fcf5:b529 with SMTP id
 z2-20020a256642000000b007c5fcf5b529mr628607ybm.517.1673982436613; Tue, 17 Jan
 2023 11:07:16 -0800 (PST)
MIME-Version: 1.0
References: <4538d7d2-0d43-16b7-9f80-77355f08cc61@huawei.com> <CAM0EoM=rqF8K997AmC0VDncJ9LeA0PJku2BL96iiatAOiv1-vw@mail.gmail.com>
In-Reply-To: <CAM0EoM=rqF8K997AmC0VDncJ9LeA0PJku2BL96iiatAOiv1-vw@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Tue, 17 Jan 2023 14:07:05 -0500
Message-ID: <CAM0EoM=VwZWzz1n_y8bj3y44NKBmhnmn+HUHtHwBb5qcCqETfg@mail.gmail.com>
Subject: Re: Question: Patch:("net: sched: cbq: dont intepret cls results when
 asked to drop") may be not bug for branch LTS 5.10
To:     shaozhengchao <shaozhengchao@huawei.com>
Cc:     zengyhkyle@gmail.com, David Miller <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Cc netdev

On Tue, Jan 17, 2023 at 10:06 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> Trimmed Cc (+Davide).
>
> I am not sure i followed what you are saying because i dont see the
> relationship between the
> two commits. Did that patch(9410c9409d3e) cause a problem?
> How do you reproduce the issue that is caused by this patch that you are seeing?
>
> One of the challenges we have built over time is consumers of classification and
> action execution may not be fully conserving the semantics of the return code.
> The return code is a "verdict" on what happened; a safer approach is to get the
> return code to be either an error/success code. But that seems to be a
> separate issue.
>
> cheers,
> jamal
>
> On Mon, Jan 16, 2023 at 3:28 AM shaozhengchao <shaozhengchao@huawei.com> wrote:
> >
> > When I analyzed the following LTS 5.10 patch, I had a small question:
> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.10.y&id=b2c917e510e5ddbc7896329c87d20036c8b82952
> >
> > As described in this patch, res is obtained through the tcf_classify()
> > interface. If result is TC_ACT_SHOT, res may be an abnormal value.
> > Accessing class in res will cause abnormal access.
> >
> > For LTS version 5.10, if tcf_classify() is to return a positive value,
> > the classify hook function to the filter must be called, and the hook
> > function returns a positive number. Observe the classify function of
> > each filter. Generally, res is initialized in four scenarios.
> > 1. res is assigned a value by res in the private member of each filter.
> > Generally, kzalloc is used to assign initial values to res of various
> > filters. Therefore, class in res is initialized to 0. Then use the
> > tcf_bind_filter() interface to assign values to members in res.
> > Therefore, value of class is assigned. For example, cls_basic.
> > 2. The classify function of the filter directly assigns a value to the
> > class of res, for example, cls_cgroup.
> > 3. The filter classify function references tp and assigns a value to
> > res, for example, cls_u32.
> > 4. The change function of the filter references fh and assigns a value
> > to class in res, for example, cls_rsvp.
> >
> > This Mainline problem is caused by commit:3aa260559455 (" net/sched:
> > store the last executed chain also for clsact egress") and
> > commit:9410c9409d3e ("net: sched: Introduce ingress classification
> > function"). I don't know if my analysis is correct, please help correct,
> > thank you very much.
> >
> > Zhengchao Shao
