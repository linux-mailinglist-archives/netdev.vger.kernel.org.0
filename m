Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C26F6786D2
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 20:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbjAWTuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 14:50:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbjAWTuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 14:50:15 -0500
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1102D177
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 11:50:12 -0800 (PST)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-5018be4ae8eso124768657b3.4
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 11:50:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uJSouYTSlTsClYMrbWv6vV2Vkh1i/wXfUmaCq6/8/+o=;
        b=DeRRvuou6WBSvS+g7c9Ud9GqIhnvmWH1F4IxUF3LGfXoXyShBCtpYTlveJlf4V/yJr
         eDE7p8GWY1X48gOmwT4t1Xv42dyUYmGjUeXago9ag5cUYJO9RrUtpMtMVz8WeU32aMb5
         xHTMTJZOgCb/mq/xGkao68PaEBzDZ4YBmIGQivSXUqEbuO5AAq+0zgxs5uQjyesPkNTx
         uab1v25lff7VKfIHNiCjuzymVgUxmArifpOSHDdIodrII2I/NCEZJKxsleXpRphAmFm9
         Ia3rjzQwXadCIK9QnhScfTypwH0ciOrqznoTnK4nMCjtDCcVT+2ZrnY40dmCfBvbm8Rc
         +9VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uJSouYTSlTsClYMrbWv6vV2Vkh1i/wXfUmaCq6/8/+o=;
        b=UyEzMzMaIOQyPsGD1Ro1SNL6mBMki1UoWNbeljocLCMNKKTkTyUJszyfOdwv9N/vkd
         /YkRtNUndK1BB402GVfmm5fZhCCn8I1TCHjhGbnmUX9shcpYiB81qBW8CU2vz/FmOyS3
         c084DiYG/0WKh2yatj8qULwPu+62wrxbwy4EKQl6JKdPKCYW6gPKVWA+Mi5TCvsDxI9i
         lWy+tERCaHgj7x9SENJXtXguhEshSf/BkXk9e/OFO5JYNu+CD56k5ywLUWFyEI+BFeoj
         q3f9dhihHnHWb6HwAmxoC7vhmpIUHaMdLBQlemD3iD0mIiq1fdb8V1P04DcaAp0n/JeU
         0IOQ==
X-Gm-Message-State: AFqh2kruQkyn/qFQbAybZhRT/d45Em8YJPH/gCeAUMzryt90XnYNZpw8
        39SGNKLYAVKzS/xzzYZDT2rJ+Bku+FR3kkiWyI7/EA==
X-Google-Smtp-Source: AMrXdXt5P5i+Ckyn2N+A8Ni9vV7F2sl2Q3ZFYbG6Lfu0rGQO67OwcZNPFuwyQJRrRSXafnw/9+pyQIiWpfz8y5CJ4fY=
X-Received: by 2002:a0d:c983:0:b0:39f:ddab:af27 with SMTP id
 l125-20020a0dc983000000b0039fddabaf27mr2789731ywd.17.1674503411674; Mon, 23
 Jan 2023 11:50:11 -0800 (PST)
MIME-Version: 1.0
References: <4538d7d2-0d43-16b7-9f80-77355f08cc61@huawei.com>
 <CAM0EoM=rqF8K997AmC0VDncJ9LeA0PJku2BL96iiatAOiv1-vw@mail.gmail.com>
 <CAM0EoM=VwZWzz1n_y8bj3y44NKBmhnmn+HUHtHwBb5qcCqETfg@mail.gmail.com>
 <CADW8OBvNcMCogJsMJkVXw70PL3oGU9s1a16DOK+xqdnCfgQzvg@mail.gmail.com>
 <Y8fSmFD2dNtBpbwK@dcaratti.users.ipa.redhat.com> <CAM0EoMmhHns_bY-JsXvrUkRhqu3xTDaRNk+cP-x=O_848R0W3Q@mail.gmail.com>
 <Y8gXmjlFPZdcoSzW@dcaratti.users.ipa.redhat.com> <CAM0EoMkrfFqjfUbEK5dSmTMj8sseO=w4SJsp=8mLDpMcER5eug@mail.gmail.com>
 <Y8lxDBaULPzZMIS1@dcaratti.users.ipa.redhat.com>
In-Reply-To: <Y8lxDBaULPzZMIS1@dcaratti.users.ipa.redhat.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Mon, 23 Jan 2023 14:50:00 -0500
Message-ID: <CAM0EoMmwFoAtniCY0WaM6T-9MWoAAyk+MmYTO12hyuOGD4wpSA@mail.gmail.com>
Subject: Re: Question: Patch:("net: sched: cbq: dont intepret cls results when
 asked to drop") may be not bug for branch LTS 5.10
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Kyle Zeng <zengyhkyle@gmail.com>,
        shaozhengchao <shaozhengchao@huawei.com>,
        David Miller <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
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

On Thu, Jan 19, 2023 at 11:34 AM Davide Caratti <dcaratti@redhat.com> wrote:
>
> On Wed, Jan 18, 2023 at 12:00:57PM -0500, Jamal Hadi Salim wrote:
>
> > On Wed, Jan 18, 2023 at 11:00 AM Davide Caratti <dcaratti@redhat.com> wrote:
>
> [...]
>
> > > With HTB, CBQ, DRR, HFSC, QFQ and ATM it's possible that the TC classifier
> > > selects a traffic class for a given packet and writes that pointer in 'res.class'.
> >
> > It's their choice of how to implement.
>
> [...]
>
> > If all goes well, it is a good pointer.
>
> Oh, probably now I see - the assignment in .bind_class() does the magic.
>
> [...]
>
> > > well, the implementation of "goto_chain" actually abuses tcf_result:
> > > since it's going to pass the packet to another classifier, it
> > > temporarily stores a handle to the next filter in the tcf_result -
> > > instead of passing it through the stack. That is not a problem, unless
> > > a packet hits the max_reclassify_loop and a CBQ qdisc that dereferences
> > > 'res.class' even with a packet drop :)
> > >
> >
> > The rule is tcf_results should be returning the results and execution
> > state to the caller. The goto_chain maybe ok in this case.
>
> it looks ok because the chain is another classifier that re-writes tcf_result
> with its own res.class + res.classid. Maybe we should assess what happens
> when no classifier matches the packet after a goto_chain (i.e. let's check
> if res.class still keeps a pointer to struct tcf_proto). However, tcf_classify()
> returns -1 (TC_ACT_UNSPECT) in this case: CBQ and other qdiscs already
> ignore tcf_result here.
>

Yes.

> > BTW, I did create a patch initially when this issue surfaced but we
> > needed to get something to net first. See attached. The proper way to
> > do this is to have the small surgery that returns the errcode instead
> > of verdict code and store TC_ACT_XXX in tcf_result (in place of errcode).
>
> my 2 cents: I really would like to see a different skb drop reason for these
> packets (currently they are accounted as SKB_DROP_REASON_QDISC_DROP like
> regular qdisc drops [1][2]).
>

I should make it clear, that is not the patch that needs to move
forward; it was just
a quick experiment.
I think we can add a lot more fine grained details on the result such
as what you
described above.
I am pre-occupied elsewhere but will get it to it probably by coming weekend..

cheers,
jamal
