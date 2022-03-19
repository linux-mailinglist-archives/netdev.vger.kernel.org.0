Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30B594DE82F
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 14:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243063AbiCSNmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 09:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234728AbiCSNmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 09:42:22 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A532B4A7E;
        Sat, 19 Mar 2022 06:41:01 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id r23so13267289edb.0;
        Sat, 19 Mar 2022 06:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E6YbzIjkOdXeD1dLlMPzr5/Z/QQCz1/q8dIJfg7C4JU=;
        b=Atx78Yh+fx8APppD5Dy3Dgv5zsYGART4jqoXDMTp1LZHpXyPQx2+SBFKyfLDTfXgZq
         CMy6YusbPe4voWDsseFcLOSN/VaQiQ8Nd4yoHTdYuYfH32s6cLezb0JonzO9eDDOe00O
         qSnuEhmVx5Uok0S6QyjQUX2rYn0aaGhWIls9l8hgQjYkn5hLvkMPCpxChzNCU7tMByU/
         xeR/GUZEX93eQxx45fgWXQEPHam56ZHn11AclzCrFFwCcIEbe0sK/V+klWyP5nNVCmi8
         CUT5nD/+41Q945edxgl9/n16kyEkaVIWLCA3F9v1N7X7wne7OAFRO0ZCA+PdIu2oRJVJ
         tVLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E6YbzIjkOdXeD1dLlMPzr5/Z/QQCz1/q8dIJfg7C4JU=;
        b=nqmJCZMtKHdneVKWMNh1/V/FtbaPxOKs+dd8NxTiuuu734t3QNzIWfVyt+/tlWEGWB
         B5YA7s1iQr88CavFtOOWWboZKmHhEmpTXygdcmcjA8piqrM7/aPS2HtyjjzM62EYhxSb
         o4hj+SZWXEAi6KqoR1XW+TsdrPUkYDB4R+n1UQ+Tu3E7Wnlr0kJgoA7AAjSZZ/l8beJC
         UOB23Anb8tggOrqIz23qW/SpqTiPFupk7kAk0TcnImIKerY8ksp94xJlzPFb9vxNMl+d
         FHngOeGxKTSzQJrmBd7jTPPaQWbM0fVE+hCpRdujCsypOw/e8aJAzytk2G1sjEEof71W
         bfNg==
X-Gm-Message-State: AOAM533MAKCJIi9HlomhYxD6y8OCdXwhHBwzN1Jt+6BSRpRgmzs+g4JK
        sicN4j6kg6t50jkkDpoHKieYpT5ajEUHo2pRNrY=
X-Google-Smtp-Source: ABdhPJwGSijWEWwID4d1uhRmDL4PIef6uA+5F0E2SFi0ufpfoVMilUni1w+bjRytvK3w4iS5ZCX3HcxClHggN3owBCQ=
X-Received: by 2002:aa7:d74d:0:b0:418:e883:b4e1 with SMTP id
 a13-20020aa7d74d000000b00418e883b4e1mr14371287eds.56.1647697259399; Sat, 19
 Mar 2022 06:40:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220314141508.39952-1-xiangxia.m.yue@gmail.com>
 <20220314141508.39952-2-xiangxia.m.yue@gmail.com> <015e903a-f4b4-a905-1cd2-11d10aefec8a@iogearbox.net>
 <CAMDZJNUO9k8xmrJwrXnj+LVG=bEv5Zwe=YkjOqSBrDS348OQfA@mail.gmail.com>
 <7d4b0c51460dec351bbbaf9be85c4a25cb6cec4f.camel@redhat.com> <f61e4a34-e7e5-198b-dde6-816654775b21@iogearbox.net>
In-Reply-To: <f61e4a34-e7e5-198b-dde6-816654775b21@iogearbox.net>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Sat, 19 Mar 2022 21:40:23 +0800
Message-ID: <CAMDZJNWaREaM7=CZY=HCvxY0T1uHDsDH3QBwdbstSrNPXrbcdA@mail.gmail.com>
Subject: Re: [net-next v10 1/2] net: sched: use queue_mapping to pick tx queue
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org
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

On Fri, Mar 18, 2022 at 9:36 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 3/17/22 9:20 AM, Paolo Abeni wrote:
> > On Tue, 2022-03-15 at 20:48 +0800, Tonghao Zhang wrote:
> >> On Tue, Mar 15, 2022 at 5:59 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >>> On 3/14/22 3:15 PM, xiangxia.m.yue@gmail.com wrote:
> >>> [...]
> >>>>    include/linux/netdevice.h |  3 +++
> >>>>    include/linux/rtnetlink.h |  1 +
> >>>>    net/core/dev.c            | 31 +++++++++++++++++++++++++++++--
> >>>>    net/sched/act_skbedit.c   |  6 +++++-
> >>>>    4 files changed, 38 insertions(+), 3 deletions(-)
> >>>>
> >>>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> >>>> index 0d994710b335..f33fb2d6712a 100644
> >>>> --- a/include/linux/netdevice.h
> >>>> +++ b/include/linux/netdevice.h
> >>>> @@ -3065,6 +3065,9 @@ struct softnet_data {
> >>>>        struct {
> >>>>                u16 recursion;
> >>>>                u8  more;
> >>>> +#ifdef CONFIG_NET_EGRESS
> >>>> +             u8  skip_txqueue;
> >>>> +#endif
> >>>>        } xmit;
> >>>>    #ifdef CONFIG_RPS
> >>>>        /* input_queue_head should be written by cpu owning this struct,
> >>>> diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
> >>>> index 7f970b16da3a..ae2c6a3cec5d 100644
> >>>> --- a/include/linux/rtnetlink.h
> >>>> +++ b/include/linux/rtnetlink.h
> >>>> @@ -100,6 +100,7 @@ void net_dec_ingress_queue(void);
> >>>>    #ifdef CONFIG_NET_EGRESS
> >>>>    void net_inc_egress_queue(void);
> >>>>    void net_dec_egress_queue(void);
> >>>> +void netdev_xmit_skip_txqueue(bool skip);
> >>>>    #endif
> >>>>
> >>>>    void rtnetlink_init(void);
> >>>> diff --git a/net/core/dev.c b/net/core/dev.c
> >>>> index 75bab5b0dbae..8e83b7099977 100644
> >>>> --- a/net/core/dev.c
> >>>> +++ b/net/core/dev.c
> >>>> @@ -3908,6 +3908,25 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
> >>>>
> >>>>        return skb;
> >>>>    }
> >>>> +
> >>>> +static struct netdev_queue *
> >>>> +netdev_tx_queue_mapping(struct net_device *dev, struct sk_buff *skb)
> >>>> +{
> >>>> +     int qm = skb_get_queue_mapping(skb);
> >>>> +
> >>>> +     return netdev_get_tx_queue(dev, netdev_cap_txqueue(dev, qm));
> >>>> +}
> >>>> +
> >>>> +static bool netdev_xmit_txqueue_skipped(void)
> >>>> +{
> >>>> +     return __this_cpu_read(softnet_data.xmit.skip_txqueue);
> >>>> +}
> >>>> +
> >>>> +void netdev_xmit_skip_txqueue(bool skip)
> >>>> +{
> >>>> +     __this_cpu_write(softnet_data.xmit.skip_txqueue, skip);
> >>>> +}
> >>>> +EXPORT_SYMBOL_GPL(netdev_xmit_skip_txqueue);
> >>>>    #endif /* CONFIG_NET_EGRESS */
> >>>>
> >>>>    #ifdef CONFIG_XPS
> >>>> @@ -4078,7 +4097,7 @@ struct netdev_queue *netdev_core_pick_tx(struct net_device *dev,
> >>>>    static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
> >>>>    {
> >>>>        struct net_device *dev = skb->dev;
> >>>> -     struct netdev_queue *txq;
> >>>> +     struct netdev_queue *txq = NULL;
> >>>>        struct Qdisc *q;
> >>>>        int rc = -ENOMEM;
> >>>>        bool again = false;
> >>>> @@ -4106,11 +4125,17 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
> >>>>                        if (!skb)
> >>>>                                goto out;
> >>>>                }
> >>>> +
> >>>> +             netdev_xmit_skip_txqueue(false);
> >>>> +
> >>>>                nf_skip_egress(skb, true);
> >>>>                skb = sch_handle_egress(skb, &rc, dev);
> >>>>                if (!skb)
> >>>>                        goto out;
> >>>>                nf_skip_egress(skb, false);
> >>>> +
> >>>> +             if (netdev_xmit_txqueue_skipped())
> >>>> +                     txq = netdev_tx_queue_mapping(dev, skb);
> >>>>        }
> >>>>    #endif
> >>>>        /* If device/qdisc don't need skb->dst, release it right now while
> >>>> @@ -4121,7 +4146,9 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
> >>>>        else
> >>>>                skb_dst_force(skb);
> >>>>
> >>>> -     txq = netdev_core_pick_tx(dev, skb, sb_dev);
> >>>> +     if (likely(!txq))
> >>>
> >>> nit: Drop likely(). If the feature is used from sch_handle_egress(), then this would always be the case.
> >> Hi Daniel
> >> I think in most case, we don't use skbedit queue_mapping in the
> >> sch_handle_egress() , so I add likely in fast path.
>
> Yeah, but then let branch predictor do its work ? We can still change and drop the
> likely() once we add support for BPF though..
Hi
if you are ok that introducing the bpf helper shown below, I will drop
likely() in next patch.
>
> >>>> +             txq = netdev_core_pick_tx(dev, skb, sb_dev);
> >>>> +
> >>>>        q = rcu_dereference_bh(txq->qdisc);
> >>>
> >>> How will the `netdev_xmit_skip_txqueue(true)` be usable from BPF side (see bpf_convert_ctx_access() ->
> >>> queue_mapping)?
> >> Good questions, In other patch, I introduce the
> >> bpf_netdev_skip_txqueue, so we can use netdev_xmit_skip_txqueue in bpf
> >> side
>
> Yeah, that bpf_netdev_skip_txqueue() won't fly. It's basically a helper doing quirk for
> an implementation detail (aka calling netdev_xmit_skip_txqueue()). Was hoping you have
> something better we could use along with the context rewrite of __sk_buff's queue_mapping,
Hi Daniel
I review the bpf codes, we introduce a lot helper to change the skb field:
skb_change_proto
skb_change_type
skb_change_tail
skb_pull_data
skb_change_head
skb_ecn_set_ce
skb_cgroup_classid
skb_vlan_push
skb_set_tunnel_key

did you mean that, we introduce bpf_skb_set_queue_mapping  is better
than bpf_netdev_skip_txqueue.
for example:
BPF_CALL_2(bpf_skb_set_queue_mapping, struct sk_buff *, skb, u32, txq)
{
        skb->queue_mapping = txq;
        netdev_xmit_skip_txqueue(true);
        return 0;
};

> but worst case we need to rework a bit for BPF. :/
> Thanks,
> Daniel



-- 
Best regards, Tonghao
