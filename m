Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32FA160B977
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 22:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233318AbiJXUM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 16:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiJXUMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 16:12:32 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 431A4130D4C
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 11:30:43 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id 63so11974914ybq.4
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 11:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LLNEsEz5cwCzxfoOgQQlXNoKFwyNdz7lRn6byHwRgdQ=;
        b=rhiSHGM2ltPQbvV48B/fwRzMvn3GUABg0Lf6/T31IHa7wxaesWBWpnBRp1VcdEOhkE
         naqNF9yZ/uy+kn26hhB8BhMzyswiXTLtWTtUdbsWQqBxSuGpkZccos6Yo1s8wQwRkJIg
         X5PgqcJRgrWrBKY7ncwzAaF+xJrmUMNV71duU37ZbvkNwgzixzDGLLY74Tb4AEI/PRc2
         bEcbBTzjHLOt2mIR09Dk68W21dKWOfY3aWIl5WP4t+YrsyGSindZ6Lgr3S1hAY7zFn+C
         IjxA+qqJPIE82XJqt7Nna1MX8du0fugPih6dIKGHae9olS1sOjyY+h14fBcPmME4yYap
         5cEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LLNEsEz5cwCzxfoOgQQlXNoKFwyNdz7lRn6byHwRgdQ=;
        b=NwlHTSau4obdzSqZyr31DSE01wIxIgvjCnVyZZu/19oI6wVKQ85R4bikC168lr0MfH
         KXLQJrVFb8jkMBCCbjcO5KC3FLdhis4Ct27pTb4Sb7tHE0AYU6tDwVkvEgqw2v0dGpja
         KaUA5bWd9BuPfDRabR85IxciloB5hPaAppehxZLK3HwK5tRfAAaeJVKGHoyOhmWzHin6
         i67c3rWfBpnsd/Oqr8EPv20+dGJJyopIVCz2L8vFObmadk3d+iRjcnrJZnsmN6Lrb6Bn
         +w98ZTQe3YcloxlOGOzY4Vj83RDx5qRHDHbUCoI/6QJvrhU6cpSt1EydBK1KXxt2KvuT
         hUCQ==
X-Gm-Message-State: ACrzQf33MaOrjZnvqkpzh1db+eS7aysIiDA75xH3FpPzFVR07XkLi7t/
        vxXVnGNf2NCzZ7WkBDlhgtoGDULBJIraUSOVo5soCazgd4s=
X-Google-Smtp-Source: AMsMyM4BEoOKsho4IpaVnAnshabpXcepkayHw0JUL4wJQQe/MgDhDxFmsn2xJU2KmZycpHdG0Y4E6EJEZl4xCCmWYVs=
X-Received: by 2002:a25:7a01:0:b0:6b0:820:dd44 with SMTP id
 v1-20020a257a01000000b006b00820dd44mr27429580ybc.387.1666631090523; Mon, 24
 Oct 2022 10:04:50 -0700 (PDT)
MIME-Version: 1.0
References: <20221021084058.223823-1-shaozhengchao@huawei.com>
 <20221022001308.17778-1-kuniyu@amazon.com> <CAKH8qBtypd=h_+CuzUX3Uy6-fyWWcs8Xt-eFYM2e0H3yZUtUNw@mail.gmail.com>
In-Reply-To: <CAKH8qBtypd=h_+CuzUX3Uy6-fyWWcs8Xt-eFYM2e0H3yZUtUNw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 24 Oct 2022 10:04:39 -0700
Message-ID: <CANn89iJELNC-NcTDT6emGbieeN6t--3b+UYpT3bq4L0K8gXefg@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: fq_codel: fix null-ptr-deref issue in fq_codel_enqueue()
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Kuniyuki Iwashima <kuniyu@amazon.com>, shaozhengchao@huawei.com,
        davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
        weiyongjun1@huawei.com, xiyou.wangcong@gmail.com,
        yuehaibing@huawei.com, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 24, 2022 at 9:54 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> On Fri, Oct 21, 2022 at 5:13 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > +Stanislav, bpf
> >
> > From:   Zhengchao Shao <shaozhengchao@huawei.com>
> > Date:   Fri, 21 Oct 2022 16:40:58 +0800
> > > As [0] see, it will cause null-ptr-deref issue.
> > > The following is the process of triggering the problem:
> > > fq_codel_enqueue()
> > >       ...
> > >       idx = fq_codel_classify()        --->if idx != 0
> > >       flow = &q->flows[idx];
> > >       flow_queue_add(flow, skb);       --->add skb to flow[idex]
> > >       q->backlogs[idx] += qdisc_pkt_len(skb); --->backlogs = 0
> > >       ...
> > >       fq_codel_drop()          --->set sch->limit = 0, always
> > >                                    drop packets
> > >               ...
> > >               idx = i          --->because backlogs in every
> > >                                    flows is 0, so idx = 0
> > >               ...
> > >               flow = &q->flows[idx];   --->get idx=0 flow
> > >               ...
> > >               dequeue_head()
> > >                       skb = flow->head; --->flow->head = NULL
> > >                       flow->head = skb->next; --->cause null-ptr-deref
> > >
> > > So, only need to discard the packets whose len is 0 on dropping path of
> > > enqueue. Then, the correct flow id can be obtained by fq_codel_drop() on
> > > next enqueuing.
> > >
> > > [0]: https://syzkaller.appspot.com/bug?id=0b84da80c2917757915afa89f7738a9d16ec96c5
> >
> > This can be caused by BPF, but there seems to be no consensus yet.
> > https://lore.kernel.org/netdev/CAKH8qBsOMxVaemF0Oy=vE1V0vKO8ORUcVGB5YANS3HdKOhVjjw@mail.gmail.com/
> >
> > """
> > I think the consensus here is that the stack, in general, doesn't
> > expect the packets like this. So there are probably more broken things
> > besides fq_codel. Thus, it's better if we remove the ability to
> > generate them from the bpf side instead of fixing the individual users
> > like fq_codel.
> > """
>
> That shouldn't happen after commit fd1894224407 ("bpf: Don't redirect
> packets with invalid pkt_len"), so not sure why this patch is needed
> at all?

This patch keeps coming, I have already explained it is silly to add such tests.

Most drivers will crash if skb->len == 0 anyway.

>
> > > Fixes: 4b549a2ef4be ("fq_codel: Fair Queue Codel AQM")
> > > Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> > > ---
> > >  net/sched/sch_fq_codel.c | 8 ++++++++
> > >  1 file changed, 8 insertions(+)
> > >
> > > diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
> > > index 99d318b60568..3bbe7f69dfb5 100644
> > > --- a/net/sched/sch_fq_codel.c
> > > +++ b/net/sched/sch_fq_codel.c
> > > @@ -187,6 +187,7 @@ static int fq_codel_enqueue(struct sk_buff *skb, struct Qdisc *sch,
> > >       struct fq_codel_sched_data *q = qdisc_priv(sch);
> > >       unsigned int idx, prev_backlog, prev_qlen;
> > >       struct fq_codel_flow *flow;
> > > +     struct sk_buff *drop_skb;
> >
> > We can move this into the if-block below or remove.
> >
> >
> > >       int ret;
> > >       unsigned int pkt_len;
> > >       bool memory_limited;
> > > @@ -222,6 +223,13 @@ static int fq_codel_enqueue(struct sk_buff *skb, struct Qdisc *sch,
> > >
> > >       /* save this packet length as it might be dropped by fq_codel_drop() */
> > >       pkt_len = qdisc_pkt_len(skb);
> > > +
> > > +     /* drop skb if len = 0, so fq_codel_drop could get the right flow idx*/
> > > +     if (unlikely(!pkt_len)) {
> > > +             drop_skb = dequeue_head(flow);
> > > +             __qdisc_drop(drop_skb, to_free);
> >
> > just            __qdisc_drop(dequeue_head(flow), to_free);
> >
> >
> > > +             return NET_XMIT_SUCCESS;
> > > +     }
> > >       /* fq_codel_drop() is quite expensive, as it performs a linear search
> > >        * in q->backlogs[] to find a fat flow.
> > >        * So instead of dropping a single packet, drop half of its backlog
> > > --
> > > 2.17.1
> >
