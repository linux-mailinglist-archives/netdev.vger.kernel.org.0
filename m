Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2BC04B8A5D
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 14:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234591AbiBPNh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 08:37:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233331AbiBPNh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 08:37:26 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE451BA33B
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 05:37:13 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id qx21so4614318ejb.13
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 05:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CxHxv/2iRZNoyRzsSJ9Zk8ar2zvgdPCb0pRBC0imRzY=;
        b=Jq6yJ2q/5WPljx8YpCeSgSlE98tHzaXbwNuleVG9nDY+ErugBebC4YR9QrPa060Pbt
         n1/lHo1UCS2TaRO8BZ9UObyHW06gq1x1B1sR74yQgWSlqmJnmtm8khHh3Ts2E1Q3hEbl
         ti9qlEh6wnaaJAHwziY695BqmWS+oeZKvptRWMXpCv/Sg4aAhm34YezUrUC8y/EodMMz
         x7eQfzxK66j59Bk3Fqh4eBPKCxbOW2kcI9oMdkY6mx5VJ3nrGKTZGBHvYhL0mcsTNGMC
         Zci/sG5BUejTzKGfVBAfUHZABsuGLXoIdeZHxc8BahE4msVqDRLkwiZhgM5WvzViKcH8
         Yp0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CxHxv/2iRZNoyRzsSJ9Zk8ar2zvgdPCb0pRBC0imRzY=;
        b=YPhbivYZfxwd6f0wc0ukd0AuDWcK2/568NJ34DIiQ+ZWz4fhfeaPlzAlqQCuF26YhG
         jDLRYDfwey2C1inMydHzm/DeWU5Bf6Xnqxn1lPlTD9MUu+KbCuTamuy1HVIwMs3ZF+PR
         h7LPuKcprzHEmdsI2mfxEOakiL3waZNrnMnMPKCsvOSaenQJ7C6PyBtFjLj4a2ENPYxK
         5C8vRwihLYYuYKH1PhsGFaIn3kirkPXJId+AtMJr+0QP4aQBDQ9mAP/xaSlOYB2Ttvko
         MuTT7uDhg1l/MbdHvA8IIgiDFgAHIpymnBu0t/Pmj2NA1kvA1OrWyustj865/ZIlgKRm
         xpww==
X-Gm-Message-State: AOAM533sBoJ7kCzhaLPP8T1mWOz7nHHFC2fkpW1KLqH3QoA9dWTnbYGZ
        Ln32JiKdAOysoxmVt+Jeevl+q3jBhr1NGE0SqUo=
X-Google-Smtp-Source: ABdhPJxOH33PxX26WfpGsJNSB6J8L0BhGnzhFX1gb6tfYTMeh/qnehnsMb1WnbgLs1YPBaDowchVrsn7cSLM4h3l114=
X-Received: by 2002:a17:906:35da:b0:6b8:9f07:f15d with SMTP id
 p26-20020a17090635da00b006b89f07f15dmr2313887ejb.552.1645018632486; Wed, 16
 Feb 2022 05:37:12 -0800 (PST)
MIME-Version: 1.0
References: <20220126143206.23023-1-xiangxia.m.yue@gmail.com>
 <20220126143206.23023-3-xiangxia.m.yue@gmail.com> <0b486c4e-0af5-d142-44e5-ed81aa0b98c2@mojatatu.com>
 <CAMDZJNVB4FDgv+xrTw2cZisEy2VNn1Dv9RodEhEAsd5H6qwkRA@mail.gmail.com> <4e556aff-0295-52d1-0274-a0381b585fbb@mojatatu.com>
In-Reply-To: <4e556aff-0295-52d1-0274-a0381b585fbb@mojatatu.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Wed, 16 Feb 2022 21:36:35 +0800
Message-ID: <CAMDZJNXbxstEvFoF=ZRD_PwH6HQc17LEn0tSvFTJvKB9aoW6Aw@mail.gmail.com>
Subject: Re: [net-next v8 2/2] net: sched: support hash/classid/cpuid
 selecting tx queue
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 8:17 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> On 2022-02-14 20:40, Tonghao Zhang wrote:
> > On Tue, Feb 15, 2022 at 8:22 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> >>
> >> On 2022-01-26 09:32, xiangxia.m.yue@gmail.com wrote:
> >>> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >>>
>
> >
> >> So while i dont agree that ebpf is the solution for reasons i mentioned
> >> earlier - after looking at the details think iam confused by this change
> >> and maybe i didnt fully understand the use case.
> >>
> >> What is the driver that would work  with this?
> >> You said earlier packets are coming out of some pods and then heading to
> >> the wire and you are looking to balance and isolate between bulk and
> >> latency  sensitive traffic - how are any of these metadatum useful for
> >> that? skb->priority seems more natural for that.
>
> Quote from your other email:
>
>  > In our production env, we use the ixgbe, i40e and mlx nic which
>  > support multi tx queue.
>
> Please bear with me.
> The part i was wondering about is how these drivers would use queue
> mapping to select their hardware queues.
Hi
For mlx5e, mlx5e_xmit() use the skb_get_queue_mapping() to pick tx queue.
For ixgbe, __ixgbe_xmit_frame() use the skb_get_queue_mapping() to
pick tx queue.
For i40e, i40e_lan_xmit_frame() use the skb->queue_mapping

we can set the skb->queue_mapping in skbedit.
> Maybe you meant the software queue (in the qdiscs?) - But even then
Yes, more importantly, we take care of software tx queue which may use
the fifo or htb/fq qdisc.
> how does queue mapping map select which queue is to be used.
we select the tx queue in clsact and we will not invoke the
netdev_core_pick_tx() to pick the tx queue and then
we can use qdisc of this tx queue to do tc policy(fifo/fq/htb qdisc
enqueue/dequeue ...)

> > Hi
> > I try to explain. there are two tx-queue range, e.g. A(Q0-Qn), B(Qn+1-Qm).
> > A is used for latency sensitive traffic. B is used for bulk sensitive
> > traffic. A may be shared by Pods/Containers which key is
> > high throughput. B may be shared by Pods/Containers which key is low
> > latency. So we can do the balance in range A for latency sensitive
> > traffic.
>
> So far makes sense. I am not sure if you get better performance but
> thats unrelated to this discussion. Just trying to understand your
> setup  first in order to understand the use case. IIUC:
> You have packets coming out of the pods and hitting the host stack
> where you are applying these rules on egress qdisc of one of these
> ixgbe, i40e and mlx nics, correct?
> And that egress qdisc then ends up selecting a queue based on queue
> mapping?
>
> Can you paste a more complete example of a sample setup on some egress
> port including what the classifier would be looking at?
Hi

  +----+      +----+      +----+     +----+
  | P1 |      | P2 |      | PN |     | PM |
  +----+      +----+      +----+     +----+
    |           |           |           |
    +-----------+-----------+-----------+
                       |
                       | clsact/skbedit
                       |      MQ
                       v
    +-----------+-----------+-----------+
    | q0        | q1        | qn        | qm
    v           v           v           v
  HTB/FQ      HTB/FQ  ...  FIFO        FIFO

NETDEV=eth0
tc qdisc add dev $NETDEV clsact
tc filter add dev $NETDEV egress protocol ip prio 1 flower skip_hw
src_ip 192.168.122.100 action skbedit queue_mapping hash-type skbhash
n m

The packets from pod(P1) which ip is 192.168.122.100, will use the txqueue n ~m.
P1 is the pod of latency sensitive traffic. so P1 use the fifo qdisc.

tc filter add dev $NETDEV egress protocol ip prio 1 flower skip_hw
src_ip 192.168.122.200 action skbedit queue_mapping hash-type skbhash
0 1

The packets from pod(P2) which ip is 192.168.122.200, will use the txqueue 0 ~1.
P2 is the pod of bulk sensitive traffic. so P2 use the htb qdisc to
limit its network rate, because we don't hope P2 use all bandwidth to
affect P1.

> Your diagram was unclear how the load balancing was going to be
> achieved using the qdiscs (or was it the hardware?).
Firstly, in clsact hook, we select one tx queue from qn to qm for P1,
and use the qdisc of this tx queue, for example FIFO.
in underlay driver, because the we set the skb->queue_mapping in
skbedit, so the hw tx queue from qn to qm will be select too.
any way, in clsact hook, we can use the skbedit queue_mapping to
select software tx queue and hw tx queue.

For doing balance, we can use the skbhash/cpuid/cgroup classid to
select tx queue from qn to qm for P1.
tc filter add dev $NETDEV egress protocol ip prio 1 flower skip_hw
src_ip 192.168.122.100 action skbedit queue_mapping hash-type cpuid n
m
tc filter add dev $NETDEV egress protocol ip prio 1 flower skip_hw
src_ip 192.168.122.100 action skbedit queue_mapping hash-type classid
n m

Why we want to do the balance, because we don't want pin the packets
from Pod to one tx queue. (in k8s the pods are created or destroy
frequently, and the number of Pods > tx queue number).
sharing the tx queue equally is more important.

> > So we can use the skb->hash or CPUID or classid to classify the
> > packets in range A or B. The balance policies are used for different
> > use case.
> > For skb->hash, the packets from Pods/Containers will share the range.
> > Should to know that one Pod/Container may use the multi TCP/UDP flows.
> > That flows share the tx queue range.
> > For CPUID, while Pod/Container use the multi flows, pod pinned on one
> > CPU will use one tx-queue in range A or B.
> > For CLASSID, the Pod may contain the multi containters.
> >
> > skb->priority may be used by applications. we can't require
> > application developer to change them.
>
> It can also be set by skbedit.
> Note also: Other than user specifying via setsockopt and skbedit,
> DSCP/TOS/COS are all translated into skb->priority. Most of those
> L3/L2 fields are intended to map to either bulk or latency sensitive
> traffic.
> More importantly:
>  From s/w level - most if not _all_ classful qdiscs look at skb->priority
> to decide where to enqueue.
>  From h/w level - skb->priority is typically mapped to qos hardware level
> (example 802.1q).
> Infact skb->priority could be translated by qdisc layer into
> classid if you set the 32 bit value to be the major:minor number for
> a specific configured classid.
>
> cheers,
> jamal



-- 
Best regards, Tonghao
