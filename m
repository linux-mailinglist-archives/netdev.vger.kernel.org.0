Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E388C4DC0E1
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 09:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbiCQIWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 04:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbiCQIWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 04:22:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB8971680A1
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 01:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647505257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=apHcZiQ7AQHXjSjCW9qiu7kfylkRV2CxCIqXD/cKZaw=;
        b=RHlC4lvoiYBQK7Bm6UNORTQiCKAWOgBFxoUw85RRn7RjqFchOe4ukBin1TsBJXt/aFFx6s
        Lra5oHlKIIdQw2UM9W9qg41BTee1bMYdrRV+J256pOfeTrxz8HkSnUc+VxA4Be8R9aFjzT
        e+xcszEh5eqERXC+6wA3fHciu4J8/D8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-468-kjmDDSjnOTmRpv5JKsbJqA-1; Thu, 17 Mar 2022 04:20:56 -0400
X-MC-Unique: kjmDDSjnOTmRpv5JKsbJqA-1
Received: by mail-wm1-f72.google.com with SMTP id i6-20020a05600c354600b0038be262d9d9so2794483wmq.8
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 01:20:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=apHcZiQ7AQHXjSjCW9qiu7kfylkRV2CxCIqXD/cKZaw=;
        b=t8dKyoZ7+ZfgMAkTC0tGCw4tL+v9EfkAhar1VJk9xw9lfPNpOonINReZQSHpGIckDX
         Bl2sAoJ1Sgi6PYxkQgRzU23GlCeXkIlLmzQdE7Fmj7DgOEscQFvVdBfXsY9BP21Mvqs1
         PaUTsDmf2DFPkUDGrhvgytjwzDLoYzR4vCnk5N+zlneLwtMfvxXDdfoxq6MxUnitB72Q
         yPgzvnlEmWUnL/V4jYkmz+HV6QAh+SX2C1/cyHCjyp7llcWdHwsjVS+Iv6t9bxQp0jyG
         PoMR0bqjwOZ48H+X7CDs1jULyCiL79zYQiHCopWpzDiEqDA8FedegekanKOuRx7Vam8+
         NryQ==
X-Gm-Message-State: AOAM533AJb1mI/jz/Xwg2Xde6j9i/LVO9SutA77UNnZGNl0B7XmuY54v
        T4U4Y/hc42o1yZ70cdbKFcpXXh1bdSaojoFjoAnJNqpxMsSC/skCisApy/zGXVBwCDO4pNpbbW9
        Ce6ya3hMiy3uIGBvS
X-Received: by 2002:a5d:40ca:0:b0:203:e037:cd0e with SMTP id b10-20020a5d40ca000000b00203e037cd0emr2892774wrq.534.1647505255553;
        Thu, 17 Mar 2022 01:20:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxJli7t+bcPWrhBXMZKE3sqfMBsKweJ6JoetyKGmaH4oDoKo5yuVcRb0muA7PRorDLM4On6Ug==
X-Received: by 2002:a5d:40ca:0:b0:203:e037:cd0e with SMTP id b10-20020a5d40ca000000b00203e037cd0emr2892760wrq.534.1647505255249;
        Thu, 17 Mar 2022 01:20:55 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-232-135.dyn.eolo.it. [146.241.232.135])
        by smtp.gmail.com with ESMTPSA id l1-20020a05600c4f0100b00387369f380bsm7740776wmq.41.2022.03.17.01.20.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 01:20:54 -0700 (PDT)
Message-ID: <7d4b0c51460dec351bbbaf9be85c4a25cb6cec4f.camel@redhat.com>
Subject: Re: [net-next v10 1/2] net: sched: use queue_mapping to pick tx
 queue
From:   Paolo Abeni <pabeni@redhat.com>
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
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
Date:   Thu, 17 Mar 2022 09:20:53 +0100
In-Reply-To: <CAMDZJNUO9k8xmrJwrXnj+LVG=bEv5Zwe=YkjOqSBrDS348OQfA@mail.gmail.com>
References: <20220314141508.39952-1-xiangxia.m.yue@gmail.com>
         <20220314141508.39952-2-xiangxia.m.yue@gmail.com>
         <015e903a-f4b4-a905-1cd2-11d10aefec8a@iogearbox.net>
         <CAMDZJNUO9k8xmrJwrXnj+LVG=bEv5Zwe=YkjOqSBrDS348OQfA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-03-15 at 20:48 +0800, Tonghao Zhang wrote:
> On Tue, Mar 15, 2022 at 5:59 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > 
> > On 3/14/22 3:15 PM, xiangxia.m.yue@gmail.com wrote:
> > [...]
> > >   include/linux/netdevice.h |  3 +++
> > >   include/linux/rtnetlink.h |  1 +
> > >   net/core/dev.c            | 31 +++++++++++++++++++++++++++++--
> > >   net/sched/act_skbedit.c   |  6 +++++-
> > >   4 files changed, 38 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > > index 0d994710b335..f33fb2d6712a 100644
> > > --- a/include/linux/netdevice.h
> > > +++ b/include/linux/netdevice.h
> > > @@ -3065,6 +3065,9 @@ struct softnet_data {
> > >       struct {
> > >               u16 recursion;
> > >               u8  more;
> > > +#ifdef CONFIG_NET_EGRESS
> > > +             u8  skip_txqueue;
> > > +#endif
> > >       } xmit;
> > >   #ifdef CONFIG_RPS
> > >       /* input_queue_head should be written by cpu owning this struct,
> > > diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
> > > index 7f970b16da3a..ae2c6a3cec5d 100644
> > > --- a/include/linux/rtnetlink.h
> > > +++ b/include/linux/rtnetlink.h
> > > @@ -100,6 +100,7 @@ void net_dec_ingress_queue(void);
> > >   #ifdef CONFIG_NET_EGRESS
> > >   void net_inc_egress_queue(void);
> > >   void net_dec_egress_queue(void);
> > > +void netdev_xmit_skip_txqueue(bool skip);
> > >   #endif
> > > 
> > >   void rtnetlink_init(void);
> > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > index 75bab5b0dbae..8e83b7099977 100644
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -3908,6 +3908,25 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
> > > 
> > >       return skb;
> > >   }
> > > +
> > > +static struct netdev_queue *
> > > +netdev_tx_queue_mapping(struct net_device *dev, struct sk_buff *skb)
> > > +{
> > > +     int qm = skb_get_queue_mapping(skb);
> > > +
> > > +     return netdev_get_tx_queue(dev, netdev_cap_txqueue(dev, qm));
> > > +}
> > > +
> > > +static bool netdev_xmit_txqueue_skipped(void)
> > > +{
> > > +     return __this_cpu_read(softnet_data.xmit.skip_txqueue);
> > > +}
> > > +
> > > +void netdev_xmit_skip_txqueue(bool skip)
> > > +{
> > > +     __this_cpu_write(softnet_data.xmit.skip_txqueue, skip);
> > > +}
> > > +EXPORT_SYMBOL_GPL(netdev_xmit_skip_txqueue);
> > >   #endif /* CONFIG_NET_EGRESS */
> > > 
> > >   #ifdef CONFIG_XPS
> > > @@ -4078,7 +4097,7 @@ struct netdev_queue *netdev_core_pick_tx(struct net_device *dev,
> > >   static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
> > >   {
> > >       struct net_device *dev = skb->dev;
> > > -     struct netdev_queue *txq;
> > > +     struct netdev_queue *txq = NULL;
> > >       struct Qdisc *q;
> > >       int rc = -ENOMEM;
> > >       bool again = false;
> > > @@ -4106,11 +4125,17 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
> > >                       if (!skb)
> > >                               goto out;
> > >               }
> > > +
> > > +             netdev_xmit_skip_txqueue(false);
> > > +
> > >               nf_skip_egress(skb, true);
> > >               skb = sch_handle_egress(skb, &rc, dev);
> > >               if (!skb)
> > >                       goto out;
> > >               nf_skip_egress(skb, false);
> > > +
> > > +             if (netdev_xmit_txqueue_skipped())
> > > +                     txq = netdev_tx_queue_mapping(dev, skb);
> > >       }
> > >   #endif
> > >       /* If device/qdisc don't need skb->dst, release it right now while
> > > @@ -4121,7 +4146,9 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
> > >       else
> > >               skb_dst_force(skb);
> > > 
> > > -     txq = netdev_core_pick_tx(dev, skb, sb_dev);
> > > +     if (likely(!txq))
> > 
> > nit: Drop likely(). If the feature is used from sch_handle_egress(), then this would always be the case.
> Hi Daniel
> I think in most case, we don't use skbedit queue_mapping in the
> sch_handle_egress() , so I add likely in fast path.
> > > +             txq = netdev_core_pick_tx(dev, skb, sb_dev);
> > > +
> > >       q = rcu_dereference_bh(txq->qdisc);
> > 
> > How will the `netdev_xmit_skip_txqueue(true)` be usable from BPF side (see bpf_convert_ctx_access() ->
> > queue_mapping)?
> Good questions, In other patch, I introduce the
> bpf_netdev_skip_txqueue, so we can use netdev_xmit_skip_txqueue in bpf
> side

@Daniel: are you ok with the above explaination?

Thanks!

Paolo

