Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0471B265229
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgIJVI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgIJVHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 17:07:52 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77975C061573;
        Thu, 10 Sep 2020 14:07:52 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id f18so5473592pfa.10;
        Thu, 10 Sep 2020 14:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Li0nSbFdz+mC8RxoTVun9cvaUm8qgoK6MsIzH+38R3k=;
        b=Ai11IEn3h4Xt+T9ffcUkHU+kkaykAv/kILQu8/Z8FY1WqSniTbyVBCnwUp3rQKOlo0
         EgqUbCF4+pWHU8e3Td0WqI215nOfB7YNPaLf/4lHgM6mQcBJHfSP1mz7cI4KLI4RyEjP
         /rqVgueX4UKU7lrR6snDLpSA2Q+SlnHDZo3fby5V20hA42M+4oSgBEQO/Q+kjxhYCxCe
         fncaKXDQmhfqdaXUJvr7ao8yT0nlucHs1qfMs4jqVepjTwePWgaNwY6ffIK2/KW5hLQA
         hXMMTq+6dAm7I/Dlx6Mr0CMs/NCG87mITKJfZW3bw+KJjuBA1qj6uJOqbOx7jaePcxdo
         lVTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Li0nSbFdz+mC8RxoTVun9cvaUm8qgoK6MsIzH+38R3k=;
        b=ZhyCU+AtnSq6XnkYq02vRj2Va1NlOouAqS7zX3+bJ39bQop/Ois6lsWeF2zJK7xnqn
         c21WHbJRmmBYFQEemF2A/Eprw07IvZNA56D3hl5TEe7eFpODDjha9F8xeVp5D8ZYuLK4
         RoZ3/lBnXpgjAYiZOGF6XL1CQ5cW4/2os1qpk0B0TunwklFieXi5oNnlp0UoIFgCeXDM
         1Oo6Z3IKhNtR3BOVOFgoH/K+0KkqOCibL9DCqWtXS3oN9iwShgZL+WdheAUV5MOBbldl
         GCBBebg4GVxO561foQDk0xVOZH6D0XzZfIFUm84k+OuRTPz2Bh/xSa9NLCPqqw/bAgk/
         qVqA==
X-Gm-Message-State: AOAM533Guu13ggaWupTLPUYQl2QANbnJmP6V1OowTizgfN6g/f5Ph2iZ
        UMtgFJhC3b82RbaX3ir6NFM=
X-Google-Smtp-Source: ABdhPJwFSjYOfpYq2rhihinFKuvAuIMZshJtCpVBe+dFyMykRxvaNxrYHAtXApgbXopQWYCIZKz6gw==
X-Received: by 2002:a63:500e:: with SMTP id e14mr6019051pgb.36.1599772071871;
        Thu, 10 Sep 2020 14:07:51 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id a10sm6779410pfn.219.2020.09.10.14.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 14:07:51 -0700 (PDT)
Date:   Thu, 10 Sep 2020 14:07:43 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Kehuan Feng <kehuan.feng@gmail.com>,
        Hillf Danton <hdanton@sina.com>,
        Jike Song <albcamus@gmail.com>, Josh Hunt <johunt@akamai.com>,
        Jonas Bonn <jonas.bonn@netrounds.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Message-ID: <5f5a959fbe236_c295820892@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpVqdVc5_LkhO4Qie7Ff+XXRTcpiptZsEVNh=o9E0GkcRQ@mail.gmail.com>
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
 <20200623134259.8197-1-mzhivich@akamai.com>
 <1849b74f-163c-8cfa-baa5-f653159fefd4@akamai.com>
 <CAM_iQpX1+dHB0kJF8gRfuDeAb9TsA9mB9H_Og8n8Hr19+EMLJA@mail.gmail.com>
 <CAM_iQpWjQiG-zVs+e-V=8LvTFbRwgC4y4eoGERjezfAT0Fmm8g@mail.gmail.com>
 <7fd86d97-6785-0b5f-1e95-92bc1da9df35@netrounds.com>
 <500b4843cb7c425ea5449fe199095edd5f7feb0c.camel@redhat.com>
 <25ca46e4-a8c1-1c88-d6a9-603289ff44c3@akamai.com>
 <CANE52Ki8rZGDPLZkxY--RPeEG+0=wFeyCD6KKkeG1WREUwramw@mail.gmail.com>
 <20200822032800.16296-1-hdanton@sina.com>
 <CACS=qqKhsu6waaXndO5tQL_gC9TztuUQpqQigJA2Ac0y12czMQ@mail.gmail.com>
 <20200825032312.11776-1-hdanton@sina.com>
 <CACS=qqK-5g-QM_vczjY+A=3fi3gChei4cAkKweZ4Sn2L537DQA@mail.gmail.com>
 <20200825162329.11292-1-hdanton@sina.com>
 <CACS=qqKgiwdCR_5+z-vkZ0X8DfzOPD7_ooJ_imeBnx+X1zw2qg@mail.gmail.com>
 <CACS=qqKptAQQGiMoCs1Zgs9S4ZppHhasy1AK4df2NxnCDR+vCw@mail.gmail.com>
 <5f46032e.1c69fb81.9880c.7a6cSMTPIN_ADDED_MISSING@mx.google.com>
 <CACS=qq+Yw734DWhETNAULyBZiy_zyjuzzOL-NO30AB7fd2vUOQ@mail.gmail.com>
 <20200827125747.5816-1-hdanton@sina.com>
 <CACS=qq+a0H=e8yLFu95aE7Hr0bQ9ytCBBn2rFx82oJnPpkBpvg@mail.gmail.com>
 <CAM_iQpV-JMURzFApp-Zhxs3QN9j=Zdf6yqwOP=E42ERDHxe6Hw@mail.gmail.com>
 <dd73f551d1fc89e457ffabd106cbf0bf401b747b.camel@redhat.com>
 <CAM_iQpXZMeAGkq_=rG6KEabFNykszpRU_Hnv65Qk7yesvbRDrw@mail.gmail.com>
 <5f51cbad3cc2_3eceb208fc@john-XPS-13-9370.notmuch>
 <CAM_iQpVqdVc5_LkhO4Qie7Ff+XXRTcpiptZsEVNh=o9E0GkcRQ@mail.gmail.com>
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Thu, Sep 3, 2020 at 10:08 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > Maybe this would unlock us,
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 7df6c9617321..9b09429103f1 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -3749,7 +3749,7 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
> >
> >         if (q->flags & TCQ_F_NOLOCK) {
> >                 rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
> > -               qdisc_run(q);
> > +               __qdisc_run(q);
> >
> >                 if (unlikely(to_free))
> >                         kfree_skb_list(to_free);
> >
> >
> > Per other thread we also need the state deactivated check added
> > back.
> 
> I guess no, because pfifo_dequeue() seems to require q->seqlock,
> according to comments in qdisc_run(), so we can not just get rid of
> qdisc_run_begin()/qdisc_run_end() here.
> 
> Thanks.

Seems we would have to revert this as well then,

 commit 021a17ed796b62383f7623f4fea73787abddad77
 Author: Paolo Abeni <pabeni@redhat.com>
 Date:   Tue May 15 16:24:37 2018 +0200

    pfifo_fast: drop unneeded additional lock on dequeue
    
    After the previous patch, for NOLOCK qdiscs, q->seqlock is
    always held when the dequeue() is invoked, we can drop
    any additional locking to protect such operation.

Then I think it should be safe. Back when I was working on the ptr
ring implementation I opted not to do a case without the spinlock
because the performance benefit was minimal in the benchmarks I
was looking at. I assumed at some point it would be worth going
back to it, but just changing those to the __ptr_ring* cases is
not safe without a lock. I remember having a discussion with Tsirkin
about the details, but would have to go through the mail servers
to find it.

FWIW the initial perf looked like this, (https://lwn.net/Articles/698135/)

nolock pfifo_fast
1:  1417597 1407479 1418913 1439601 
2:  1882009 1867799 1864374 1855950
4:  1806736 1804261 1803697 1806994
8:  1354318 1358686 1353145 1356645
12: 1331928 1333079 1333476 1335544

locked pfifo_fast
1:  1471479 1469142 1458825 1456788 
2:  1746231 1749490 1753176 1753780
4:  1119626 1120515 1121478 1119220
8:  1001471  999308 1000318 1000776
12:  989269  992122  991590  986581

As you can see measurable improvement on many cores. But, actually
worse if you have enough nic queues to map 1:1 with cores.

nolock mq
1:    1417768  1438712  1449092  1426775
2:    2644099  2634961  2628939  2712867
4:    4866133  4862802  4863396  4867423
8:    9422061  9464986  9457825  9467619
12:  13854470 13213735 13664498 13213292  

locked mq
1:   1448374  1444208  1437459  1437088 
2:   2687963  2679221  2651059  2691630
4:   5153884  4684153  5091728  4635261
8:   9292395  9625869  9681835  9711651
12: 13553918 13682410 14084055 13946138

So only better if you have more cores than hardware queues
which was the case on some of the devices we had at the time.

Thanks,
John
