Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0BDC4D9B92
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 13:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348381AbiCOMuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 08:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235032AbiCOMui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 08:50:38 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA7EDF3F;
        Tue, 15 Mar 2022 05:49:25 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id yy13so41070347ejb.2;
        Tue, 15 Mar 2022 05:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bjCWzgjkPYwzh85OUW+uH7uw70JwihDxjLwKVznpDOY=;
        b=C7GmF7/vfK/cSsWVRw6QSO6to9e7iEdNssRm4vydQASo8zwbzSBW6X2AiqW1sR8gJJ
         4CYZc+/+kTF5XwjMgFIZ7Wcevlzdnvf1RmmjtTbaZWUut3NHGRI88g/qKS/8YqsC9S2C
         8DU7o9ubxFm4UjSOcX/Iv4iG3IzgUMERiBQsIZwHUJXs+cqI33fvwLrDgPX0pTtdUamC
         LMLug3LPsfgvYZAGK45I9hu7WmV2acf/0kFk/v5sX9RoYutxqddi2ROofgJlx12x1GYD
         mvZ77Xy6ZWn+2KGxDlS7jzx2sd5jVJz08PBHndjN4hxQVFY3of+lBiIFt1muDBLXcvpT
         EKzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bjCWzgjkPYwzh85OUW+uH7uw70JwihDxjLwKVznpDOY=;
        b=iLi76PrrvEx+95TS8s3aoEKztci87swi+jWD1Qo7zsVTWF9PsOKbOkKG/Ah1HbMD54
         ttEfoCwI2dAvTtY/GYc00OasHjxEOSclrjxKyell4olGaIPcBH0yan7nj3CpOuazXBkP
         uLHoYOLQnLpNcpzgaWTMMIlPafLujMRp1F9u6eSirMfEE7CWPG38OMW7wgT+DUikNM+z
         qWjlT7gH8f/Z6nz5a5smZSEzM8KYFAVHeZvwkKjCvDKmDBtZebYWHJDQeBCZ0ql4Tfwe
         rNJTPFDzPQ/75hbkahojiwZMblRB+y5L8MHhrLxCl5E3O6Ya84aT7b0U5+XiCv3EiYaC
         WvOg==
X-Gm-Message-State: AOAM5322agWS66OzzrDxhDS8rUfusIGE1e674UvO5H2bg8qltSh0B0yl
        KBFOCBUao949MhW6t1tqveBoHs6rbNr066qbx2g=
X-Google-Smtp-Source: ABdhPJxAXCf/XfIEyIOUFRpHe+FDwDE8ywwIK3ZYr6lmbH0jVjkcZsmUPV9jWbdFXLTrH1SUDLWpgs3T/8+y3ZaguOI=
X-Received: by 2002:a17:906:1e94:b0:6b9:6fcc:53fd with SMTP id
 e20-20020a1709061e9400b006b96fcc53fdmr22207474ejj.450.1647348563788; Tue, 15
 Mar 2022 05:49:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220314141508.39952-1-xiangxia.m.yue@gmail.com>
 <20220314141508.39952-2-xiangxia.m.yue@gmail.com> <015e903a-f4b4-a905-1cd2-11d10aefec8a@iogearbox.net>
In-Reply-To: <015e903a-f4b4-a905-1cd2-11d10aefec8a@iogearbox.net>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 15 Mar 2022 20:48:47 +0800
Message-ID: <CAMDZJNUO9k8xmrJwrXnj+LVG=bEv5Zwe=YkjOqSBrDS348OQfA@mail.gmail.com>
Subject: Re: [net-next v10 1/2] net: sched: use queue_mapping to pick tx queue
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
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

On Tue, Mar 15, 2022 at 5:59 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 3/14/22 3:15 PM, xiangxia.m.yue@gmail.com wrote:
> [...]
> >   include/linux/netdevice.h |  3 +++
> >   include/linux/rtnetlink.h |  1 +
> >   net/core/dev.c            | 31 +++++++++++++++++++++++++++++--
> >   net/sched/act_skbedit.c   |  6 +++++-
> >   4 files changed, 38 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 0d994710b335..f33fb2d6712a 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -3065,6 +3065,9 @@ struct softnet_data {
> >       struct {
> >               u16 recursion;
> >               u8  more;
> > +#ifdef CONFIG_NET_EGRESS
> > +             u8  skip_txqueue;
> > +#endif
> >       } xmit;
> >   #ifdef CONFIG_RPS
> >       /* input_queue_head should be written by cpu owning this struct,
> > diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
> > index 7f970b16da3a..ae2c6a3cec5d 100644
> > --- a/include/linux/rtnetlink.h
> > +++ b/include/linux/rtnetlink.h
> > @@ -100,6 +100,7 @@ void net_dec_ingress_queue(void);
> >   #ifdef CONFIG_NET_EGRESS
> >   void net_inc_egress_queue(void);
> >   void net_dec_egress_queue(void);
> > +void netdev_xmit_skip_txqueue(bool skip);
> >   #endif
> >
> >   void rtnetlink_init(void);
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 75bab5b0dbae..8e83b7099977 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -3908,6 +3908,25 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
> >
> >       return skb;
> >   }
> > +
> > +static struct netdev_queue *
> > +netdev_tx_queue_mapping(struct net_device *dev, struct sk_buff *skb)
> > +{
> > +     int qm = skb_get_queue_mapping(skb);
> > +
> > +     return netdev_get_tx_queue(dev, netdev_cap_txqueue(dev, qm));
> > +}
> > +
> > +static bool netdev_xmit_txqueue_skipped(void)
> > +{
> > +     return __this_cpu_read(softnet_data.xmit.skip_txqueue);
> > +}
> > +
> > +void netdev_xmit_skip_txqueue(bool skip)
> > +{
> > +     __this_cpu_write(softnet_data.xmit.skip_txqueue, skip);
> > +}
> > +EXPORT_SYMBOL_GPL(netdev_xmit_skip_txqueue);
> >   #endif /* CONFIG_NET_EGRESS */
> >
> >   #ifdef CONFIG_XPS
> > @@ -4078,7 +4097,7 @@ struct netdev_queue *netdev_core_pick_tx(struct net_device *dev,
> >   static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
> >   {
> >       struct net_device *dev = skb->dev;
> > -     struct netdev_queue *txq;
> > +     struct netdev_queue *txq = NULL;
> >       struct Qdisc *q;
> >       int rc = -ENOMEM;
> >       bool again = false;
> > @@ -4106,11 +4125,17 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
> >                       if (!skb)
> >                               goto out;
> >               }
> > +
> > +             netdev_xmit_skip_txqueue(false);
> > +
> >               nf_skip_egress(skb, true);
> >               skb = sch_handle_egress(skb, &rc, dev);
> >               if (!skb)
> >                       goto out;
> >               nf_skip_egress(skb, false);
> > +
> > +             if (netdev_xmit_txqueue_skipped())
> > +                     txq = netdev_tx_queue_mapping(dev, skb);
> >       }
> >   #endif
> >       /* If device/qdisc don't need skb->dst, release it right now while
> > @@ -4121,7 +4146,9 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
> >       else
> >               skb_dst_force(skb);
> >
> > -     txq = netdev_core_pick_tx(dev, skb, sb_dev);
> > +     if (likely(!txq))
>
> nit: Drop likely(). If the feature is used from sch_handle_egress(), then this would always be the case.
Hi Daniel
I think in most case, we don't use skbedit queue_mapping in the
sch_handle_egress() , so I add likely in fast path.
> > +             txq = netdev_core_pick_tx(dev, skb, sb_dev);
> > +
> >       q = rcu_dereference_bh(txq->qdisc);
>
> How will the `netdev_xmit_skip_txqueue(true)` be usable from BPF side (see bpf_convert_ctx_access() ->
> queue_mapping)?
Good questions, In other patch, I introduce the
bpf_netdev_skip_txqueue, so we can use netdev_xmit_skip_txqueue in bpf
side

not official patch:(I will post this patch, if ready)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4eebea830613..ef147a1a2d62 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5117,6 +5117,21 @@ union bpf_attr {
  * 0 on success.
  * **-EINVAL** for invalid input
  * **-EOPNOTSUPP** for unsupported delivery_time_type and protocol
+ *
+ * void bpf_netdev_skip_txqueue(u32 skip)
+ * Description
+ * Redirect the packet to another net device of index *ifindex*.
+ * This helper is somewhat similar to **bpf_redirect**\ (), except
+ * that the redirection happens to the *skip*' peer device and
+ * the netns switch takes place from ingress to ingress without
+ * going through the CPU's backlog queue.
+ *
+ * The *skip* argument is reserved and must be 0. The helper is
+ * currently only supported for tc BPF program types at the ingress
+ * hook and for veth device types. The peer device must reside in a
+ * different network namespace.
+ * Return
+ * Nothing. Always succeeds.
  */
 #define __BPF_FUNC_MAPPER(FN) \
  FN(unspec), \
@@ -5312,6 +5327,7 @@ union bpf_attr {
  FN(xdp_store_bytes), \
  FN(copy_from_user_task), \
  FN(skb_set_delivery_time),      \
+ FN(netdev_skip_txqueue), \
  /* */

 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/net/core/filter.c b/net/core/filter.c
index 88767f7da150..5845b4632b6b 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2517,6 +2517,19 @@ static const struct bpf_func_proto
bpf_redirect_peer_proto = {
  .arg2_type      = ARG_ANYTHING,
 };

+BPF_CALL_1(bpf_netdev_skip_txqueue, u32, skip)
+{
+ netdev_xmit_skip_txqueue(!!skip);
+ return 0;
+};
+
+static const struct bpf_func_proto bpf_netdev_skip_txqueue_proto = {
+ .func           = bpf_netdev_skip_txqueue,
+ .gpl_only       = false,
+ .ret_type       = RET_VOID,
+ .arg1_type      = ARG_ANYTHING,
+};
+
 BPF_CALL_4(bpf_redirect_neigh, u32, ifindex, struct bpf_redir_neigh *, params,
     int, plen, u64, flags)
 {
@@ -7721,6 +7734,8 @@ tc_cls_act_func_proto(enum bpf_func_id func_id,
const struct bpf_prog *prog)
  return &bpf_redirect_proto;
  case BPF_FUNC_redirect_neigh:
  return &bpf_redirect_neigh_proto;
+ case BPF_FUNC_netdev_skip_txqueue:
+ return &bpf_netdev_skip_txqueue_proto;
  case BPF_FUNC_redirect_peer:
  return &bpf_redirect_peer_proto;
  case BPF_FUNC_get_route_realm:
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4eebea830613..ef147a1a2d62 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5117,6 +5117,21 @@ union bpf_attr {
  * 0 on success.
  * **-EINVAL** for invalid input
  * **-EOPNOTSUPP** for unsupported delivery_time_type and protocol
+ *
+ * void bpf_netdev_skip_txqueue(u32 skip)
+ * Description
+ * Redirect the packet to another net device of index *ifindex*.
+ * This helper is somewhat similar to **bpf_redirect**\ (), except
+ * that the redirection happens to the *skip*' peer device and
+ * the netns switch takes place from ingress to ingress without
+ * going through the CPU's backlog queue.
+ *
+ * The *skip* argument is reserved and must be 0. The helper is
+ * currently only supported for tc BPF program types at the ingress
+ * hook and for veth device types. The peer device must reside in a
+ * different network namespace.
+ * Return
+ * Nothing. Always succeeds.
  */
 #define __BPF_FUNC_MAPPER(FN) \
  FN(unspec), \
@@ -5312,6 +5327,7 @@ union bpf_attr {
  FN(xdp_store_bytes), \
  FN(copy_from_user_task), \
  FN(skb_set_delivery_time),      \
+ FN(netdev_skip_txqueue), \
  /* */

 /* integer value in 'imm' field of BPF_CALL instruction selects which helper

>
> >       trace_net_dev_queue(skb);
> > diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
> > index ceba11b198bb..d5799b4fc499 100644
> > --- a/net/sched/act_skbedit.c
> > +++ b/net/sched/act_skbedit.c
> > @@ -58,8 +58,12 @@ static int tcf_skbedit_act(struct sk_buff *skb, const struct tc_action *a,
> >               }
> >       }
> >       if (params->flags & SKBEDIT_F_QUEUE_MAPPING &&
> > -         skb->dev->real_num_tx_queues > params->queue_mapping)
> > +         skb->dev->real_num_tx_queues > params->queue_mapping) {
> > +#ifdef CONFIG_NET_EGRESS
> > +             netdev_xmit_skip_txqueue(true);
> > +#endif
> >               skb_set_queue_mapping(skb, params->queue_mapping);
> > +     }
> >       if (params->flags & SKBEDIT_F_MARK) {
> >               skb->mark &= ~params->mask;
> >               skb->mark |= params->mark & params->mask;
> >
>


-- 
Best regards, Tonghao
