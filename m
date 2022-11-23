Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4398D63674B
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 18:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239100AbiKWRco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 12:32:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239174AbiKWRcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 12:32:20 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9266D9A260
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 09:32:18 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id v81so19743647oie.5
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 09:32:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BWFWWxNzDwqhm8FkIyKor91hXo5Wv61x5JurdSlH9rA=;
        b=MJ+RFqL1QYjeZTgLEvoUW1AuldH6Onc3n+/IbApXVonNq8ibfDnTILLcu95at6wD5/
         l8wKSQRersPp3ut+NUdKiWW5egMbHfQ/MuMqaH5Q23mDJDqtbs+Hc3sBdSZ6oQJJq3/C
         zHOpPG4eb6ON4cduTeTy2pVf6nXAM1a+xaXSNnaz/HmHShdJyTkwB2fNHn+wGSZR/sVJ
         I39+zPHNA89rmx4QkEoaB1VVu7kx98t9f6cflSRSxYb3tDfsw47O/Fp3Bk06JuQQPa3D
         5OAXH07i+CFUyjvuYzNWfj+fIO+murYDdsqP0/0uWb+QAuzMUeRWvkZXL0gmKyFMjxLq
         3cDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BWFWWxNzDwqhm8FkIyKor91hXo5Wv61x5JurdSlH9rA=;
        b=EqOsm+FjSdjAh2q3xD0aA1G9ys81kIM5emQ0uyB3+UsurnhjeB/xnWQnZE/qjPeXAD
         vMtYRVGqZiCEBNpb9ApMgzdAO3V6FkcuxCZaKApfrI1OF2lLXc4jD6BhpBItQYyIT4UF
         OVtf+CztnAlk2DIW5TcDOIxct+FLKoiqNfSdWhbOjyl9hPjIbJ63M7jGM12wcPoG7rBx
         zuoQ/bLM6JdZfDqUnVrbqIPH4nK6PvsS2eFmQRuL0nxiFxH92/qX7zyH9HxAXqQAreEQ
         muuz7sNBwARELe/fLl1ut0B43YQVBrOoZEOsIeZggHAIUKxDpnp35d4PNu9dDkFlVJkY
         u2ag==
X-Gm-Message-State: ANoB5plLn9fgfwi1GdxG2usXsUl+q0uyePJII77a+JWl/9LjLJbxmMwK
        usi3PnBDquk5hm8weHCJnZhlC0Ipi9iU0TE9p3w=
X-Google-Smtp-Source: AA0mqf42Hb+CIOoukGKMxjOTTYPZiujGExoqbHQ0KBOBE1WqAIOo3rZsBCecdNatU18+olZJyEciqqAFFJg0N91y4e0=
X-Received: by 2002:a54:4883:0:b0:35b:7f7e:7b82 with SMTP id
 r3-20020a544883000000b0035b7f7e7b82mr1196924oic.129.1669224737747; Wed, 23
 Nov 2022 09:32:17 -0800 (PST)
MIME-Version: 1.0
References: <cover.1669138256.git.lucien.xin@gmail.com> <bf19487f4dfc8cd91a4395672d9905b10917128d.1669138256.git.lucien.xin@gmail.com>
 <Y343wyO20XUvwuvg@t14s.localdomain> <20221123151335.ssrnv7jfrdugmcgg@t14s.localdomain>
In-Reply-To: <20221123151335.ssrnv7jfrdugmcgg@t14s.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 23 Nov 2022 12:31:38 -0500
Message-ID: <CADvbK_eYRZxaNreBmvXmAQzH+JLbiK-9UhKqzH2CM2sHt1bvQQ@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCHv2 net-next 5/5] net: move the nat function to
 nf_nat_ovs for ovs and tc
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     dev@openvswitch.org, ovs-dev@openvswitch.org,
        Davide Caratti <dcaratti@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        network dev <netdev@vger.kernel.org>,
        Paul Blakey <paulb@nvidia.com>,
        Florian Westphal <fw@strlen.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, kuba@kernel.org,
        Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        Pablo Neira Ayuso <pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 10:13 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Wed, Nov 23, 2022 at 12:09:55PM -0300, Marcelo Ricardo Leitner wrote:
> > On Tue, Nov 22, 2022 at 12:32:21PM -0500, Xin Long wrote:
> > > +int nf_ct_nat(struct sk_buff *skb, struct nf_conn *ct,
> > > +         enum ip_conntrack_info ctinfo, int *action,
> > > +         const struct nf_nat_range2 *range, bool commit)
> > > +{
> > > +   enum nf_nat_manip_type maniptype;
> > > +   int err, ct_action = *action;
> > > +
> > > +   *action = 0;
> > > +
> > > +   /* Add NAT extension if not confirmed yet. */
> > > +   if (!nf_ct_is_confirmed(ct) && !nf_ct_nat_ext_add(ct))
> > > +           return NF_ACCEPT;   /* Can't NAT. */
> > > +
> > > +   if (ctinfo != IP_CT_NEW && (ct->status & IPS_NAT_MASK) &&
> > > +       (ctinfo != IP_CT_RELATED || commit)) {
> > > +           /* NAT an established or related connection like before. */
> > > +           if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY)
> > > +                   /* This is the REPLY direction for a connection
> > > +                    * for which NAT was applied in the forward
> > > +                    * direction.  Do the reverse NAT.
> > > +                    */
> > > +                   maniptype = ct->status & IPS_SRC_NAT
> > > +                           ? NF_NAT_MANIP_DST : NF_NAT_MANIP_SRC;
> > > +           else
> > > +                   maniptype = ct->status & IPS_SRC_NAT
> > > +                           ? NF_NAT_MANIP_SRC : NF_NAT_MANIP_DST;
> > > +   } else if (ct_action & (1 << NF_NAT_MANIP_SRC)) {
> > > +           maniptype = NF_NAT_MANIP_SRC;
> > > +   } else if (ct_action & (1 << NF_NAT_MANIP_DST)) {
> > > +           maniptype = NF_NAT_MANIP_DST;
> > > +   } else {
> > > +           return NF_ACCEPT;
> > > +   }
> > > +
> > > +   err = nf_ct_nat_execute(skb, ct, ctinfo, action, range, maniptype);
> > > +   if (err == NF_ACCEPT && ct->status & IPS_DST_NAT) {
> > > +           if (ct->status & IPS_SRC_NAT) {
> > > +                   if (maniptype == NF_NAT_MANIP_SRC)
> > > +                           maniptype = NF_NAT_MANIP_DST;
> > > +                   else
> > > +                           maniptype = NF_NAT_MANIP_SRC;
> > > +
> > > +                   err = nf_ct_nat_execute(skb, ct, ctinfo, action, range,
> > > +                                           maniptype);
> > > +           } else if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL) {
> > > +                   err = nf_ct_nat_execute(skb, ct, ctinfo, action, NULL,
> > > +                                           NF_NAT_MANIP_SRC);
> > > +           }
> > > +   }
> > > +   return err;
> > > +}
> > > +EXPORT_SYMBOL_GPL(nf_ct_nat);
> > > diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
> > > index cc643a556ea1..d03c75165663 100644
> > > --- a/net/openvswitch/conntrack.c
> > > +++ b/net/openvswitch/conntrack.c
> > > @@ -726,144 +726,27 @@ static void ovs_nat_update_key(struct sw_flow_key *key,
> > >     }
> > >  }
> > >
> > > -/* Modelled after nf_nat_ipv[46]_fn().
> > > - * range is only used for new, uninitialized NAT state.
> > > - * Returns either NF_ACCEPT or NF_DROP.
> > > - */
> > > -static int ovs_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
> > > -                         enum ip_conntrack_info ctinfo,
> > > -                         const struct nf_nat_range2 *range,
> > > -                         enum nf_nat_manip_type maniptype, struct sw_flow_key *key)
> > > -{
> > > -   int hooknum, err = NF_ACCEPT;
> > > -
> > > -   /* See HOOK2MANIP(). */
> > > -   if (maniptype == NF_NAT_MANIP_SRC)
> > > -           hooknum = NF_INET_LOCAL_IN; /* Source NAT */
> > > -   else
> > > -           hooknum = NF_INET_LOCAL_OUT; /* Destination NAT */
> > > -
> > > -   switch (ctinfo) {
> > > -   case IP_CT_RELATED:
> > > -   case IP_CT_RELATED_REPLY:
> > > -           if (IS_ENABLED(CONFIG_NF_NAT) &&
> > > -               skb->protocol == htons(ETH_P_IP) &&
> > > -               ip_hdr(skb)->protocol == IPPROTO_ICMP) {
> > > -                   if (!nf_nat_icmp_reply_translation(skb, ct, ctinfo,
> > > -                                                      hooknum))
> > > -                           err = NF_DROP;
> > > -                   goto out;
> > > -           } else if (IS_ENABLED(CONFIG_IPV6) &&
> > > -                      skb->protocol == htons(ETH_P_IPV6)) {
> > > -                   __be16 frag_off;
> > > -                   u8 nexthdr = ipv6_hdr(skb)->nexthdr;
> > > -                   int hdrlen = ipv6_skip_exthdr(skb,
> > > -                                                 sizeof(struct ipv6hdr),
> > > -                                                 &nexthdr, &frag_off);
> > > -
> > > -                   if (hdrlen >= 0 && nexthdr == IPPROTO_ICMPV6) {
> > > -                           if (!nf_nat_icmpv6_reply_translation(skb, ct,
> > > -                                                                ctinfo,
> > > -                                                                hooknum,
> > > -                                                                hdrlen))
> > > -                                   err = NF_DROP;
> > > -                           goto out;
> > > -                   }
> > > -           }
> > > -           /* Non-ICMP, fall thru to initialize if needed. */
> > > -           fallthrough;
> > > -   case IP_CT_NEW:
> > > -           /* Seen it before?  This can happen for loopback, retrans,
> > > -            * or local packets.
> > > -            */
> > > -           if (!nf_nat_initialized(ct, maniptype)) {
> > > -                   /* Initialize according to the NAT action. */
> > > -                   err = (range && range->flags & NF_NAT_RANGE_MAP_IPS)
> > > -                           /* Action is set up to establish a new
> > > -                            * mapping.
> > > -                            */
> > > -                           ? nf_nat_setup_info(ct, range, maniptype)
> > > -                           : nf_nat_alloc_null_binding(ct, hooknum);
> > > -                   if (err != NF_ACCEPT)
> > > -                           goto out;
> > > -           }
> > > -           break;
> > > -
> > > -   case IP_CT_ESTABLISHED:
> > > -   case IP_CT_ESTABLISHED_REPLY:
> > > -           break;
> > > -
> > > -   default:
> > > -           err = NF_DROP;
> > > -           goto out;
> > > -   }
> > > -
> > > -   err = nf_nat_packet(ct, ctinfo, hooknum, skb);
> > > -out:
> > > -   /* Update the flow key if NAT successful. */
> > > -   if (err == NF_ACCEPT)
> > > -           ovs_nat_update_key(key, skb, maniptype);
> > > -
> > > -   return err;
> > > -}
> > > -
> > >  /* Returns NF_DROP if the packet should be dropped, NF_ACCEPT otherwise. */
> > >  static int ovs_ct_nat(struct net *net, struct sw_flow_key *key,
> > >                   const struct ovs_conntrack_info *info,
> > >                   struct sk_buff *skb, struct nf_conn *ct,
> > >                   enum ip_conntrack_info ctinfo)
> > >  {
> > > -   enum nf_nat_manip_type maniptype;
> > > -   int err;
> > > +   int err, action = 0;
> > >
> > >     if (!(info->nat & OVS_CT_NAT))
> > >             return NF_ACCEPT;
> > > +   if (info->nat & OVS_CT_SRC_NAT)
> > > +           action |= (1 << NF_NAT_MANIP_SRC);
> > > +   if (info->nat & OVS_CT_DST_NAT)
> > > +           action |= (1 << NF_NAT_MANIP_DST);
> >
> > I'm wondering why this dance at this level with supporting multiple
> > MANIPs while actually only one can be used at a time.
> >
> > act_ct will reject an action using both:
> >         if ((p->ct_action & TCA_CT_ACT_NAT_SRC) &&
> >             (p->ct_action & TCA_CT_ACT_NAT_DST)) {
> >                 NL_SET_ERR_MSG_MOD(extack, "dnat and snat can't be enabled at the same time");
> >                 return -EOPNOTSUPP;
> >
> > I couldn't find this kind of check in ovs code right now (didn't look much, I
> > confess :)), but even the code here was already doing:
> >
> > -     } else if (info->nat & OVS_CT_SRC_NAT) {
> > -             maniptype = NF_NAT_MANIP_SRC;
> > -     } else if (info->nat & OVS_CT_DST_NAT) {
> > -             maniptype = NF_NAT_MANIP_DST;
> >
> > And in case of tuple conflict, maniptype will be forcibly updated in
> > [*] below.
>
> Ahh.. just found why.. in case of typle conflict, nf_ct_nat() now may
> set both.
Right.
BTW. The tuple conflict processing actually has provided the
code to do full nat (snat and dnat at the same time), which I
think is more efficient than doing full nat in two zones. All
we have to do is adjust a few lines of code for that.

>
> >
> > Anyhow, if really needed, it would be nice to use BIT(NF_NAT_MANIP_..)
> > instead.
BIT() looks a good one, will use it.
Thanks.

>
> But still this.
>
> >
> > >
> > > -   /* Add NAT extension if not confirmed yet. */
> > > -   if (!nf_ct_is_confirmed(ct) && !nf_ct_nat_ext_add(ct))
> > > -           return NF_ACCEPT;   /* Can't NAT. */
> > > +   err = nf_ct_nat(skb, ct, ctinfo, &action, &info->range, info->commit);
> > >
> > > -   /* Determine NAT type.
> > > -    * Check if the NAT type can be deduced from the tracked connection.
> > > -    * Make sure new expected connections (IP_CT_RELATED) are NATted only
> > > -    * when committing.
> > > -    */
> > > -   if (ctinfo != IP_CT_NEW && ct->status & IPS_NAT_MASK &&
> > > -       (ctinfo != IP_CT_RELATED || info->commit)) {
> > > -           /* NAT an established or related connection like before. */
> > > -           if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY)
> > > -                   /* This is the REPLY direction for a connection
> > > -                    * for which NAT was applied in the forward
> > > -                    * direction.  Do the reverse NAT.
> > > -                    */
> > > -                   maniptype = ct->status & IPS_SRC_NAT
> > > -                           ? NF_NAT_MANIP_DST : NF_NAT_MANIP_SRC;
> > > -           else
> > > -                   maniptype = ct->status & IPS_SRC_NAT
> > > -                           ? NF_NAT_MANIP_SRC : NF_NAT_MANIP_DST;
> > > -   } else if (info->nat & OVS_CT_SRC_NAT) {
> > > -           maniptype = NF_NAT_MANIP_SRC;
> > > -   } else if (info->nat & OVS_CT_DST_NAT) {
> > > -           maniptype = NF_NAT_MANIP_DST;
> > > -   } else {
> > > -           return NF_ACCEPT; /* Connection is not NATed. */
> > > -   }
> > > -   err = ovs_ct_nat_execute(skb, ct, ctinfo, &info->range, maniptype, key);
> > > -
> > > -   if (err == NF_ACCEPT && ct->status & IPS_DST_NAT) {
> > > -           if (ct->status & IPS_SRC_NAT) {
> > > -                   if (maniptype == NF_NAT_MANIP_SRC)
> > > -                           maniptype = NF_NAT_MANIP_DST;
> > > -                   else
> > > -                           maniptype = NF_NAT_MANIP_SRC;
> >
> > [*]
> >
> > > -
> > > -                   err = ovs_ct_nat_execute(skb, ct, ctinfo, &info->range,
> > > -                                            maniptype, key);
> > > -           } else if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL) {
> > > -                   err = ovs_ct_nat_execute(skb, ct, ctinfo, NULL,
> > > -                                            NF_NAT_MANIP_SRC, key);
> > > -           }
> > > -   }
> > > +   if (action & (1 << NF_NAT_MANIP_SRC))
> > > +           ovs_nat_update_key(key, skb, NF_NAT_MANIP_SRC);
> > > +   if (action & (1 << NF_NAT_MANIP_DST))
> > > +           ovs_nat_update_key(key, skb, NF_NAT_MANIP_DST);
> > >
> > >     return err;
> > >  }
> > > diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> > > index c7782c9a6ab6..0c410220239f 100644
> > > --- a/net/sched/act_ct.c
> > > +++ b/net/sched/act_ct.c
> > > @@ -863,90 +863,6 @@ static void tcf_ct_params_free_rcu(struct rcu_head *head)
> > >     tcf_ct_params_free(params);
> > >  }
> > >
> > > -#if IS_ENABLED(CONFIG_NF_NAT)
> > > -/* Modelled after nf_nat_ipv[46]_fn().
> > > - * range is only used for new, uninitialized NAT state.
> > > - * Returns either NF_ACCEPT or NF_DROP.
> > > - */
> > > -static int ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
> > > -                     enum ip_conntrack_info ctinfo,
> > > -                     const struct nf_nat_range2 *range,
> > > -                     enum nf_nat_manip_type maniptype)
> > > -{
> > > -   __be16 proto = skb_protocol(skb, true);
> > > -   int hooknum, err = NF_ACCEPT;
> > > -
> > > -   /* See HOOK2MANIP(). */
> > > -   if (maniptype == NF_NAT_MANIP_SRC)
> > > -           hooknum = NF_INET_LOCAL_IN; /* Source NAT */
> > > -   else
> > > -           hooknum = NF_INET_LOCAL_OUT; /* Destination NAT */
> > > -
> > > -   switch (ctinfo) {
> > > -   case IP_CT_RELATED:
> > > -   case IP_CT_RELATED_REPLY:
> > > -           if (proto == htons(ETH_P_IP) &&
> > > -               ip_hdr(skb)->protocol == IPPROTO_ICMP) {
> > > -                   if (!nf_nat_icmp_reply_translation(skb, ct, ctinfo,
> > > -                                                      hooknum))
> > > -                           err = NF_DROP;
> > > -                   goto out;
> > > -           } else if (IS_ENABLED(CONFIG_IPV6) && proto == htons(ETH_P_IPV6)) {
> > > -                   __be16 frag_off;
> > > -                   u8 nexthdr = ipv6_hdr(skb)->nexthdr;
> > > -                   int hdrlen = ipv6_skip_exthdr(skb,
> > > -                                                 sizeof(struct ipv6hdr),
> > > -                                                 &nexthdr, &frag_off);
> > > -
> > > -                   if (hdrlen >= 0 && nexthdr == IPPROTO_ICMPV6) {
> > > -                           if (!nf_nat_icmpv6_reply_translation(skb, ct,
> > > -                                                                ctinfo,
> > > -                                                                hooknum,
> > > -                                                                hdrlen))
> > > -                                   err = NF_DROP;
> > > -                           goto out;
> > > -                   }
> > > -           }
> > > -           /* Non-ICMP, fall thru to initialize if needed. */
> > > -           fallthrough;
> > > -   case IP_CT_NEW:
> > > -           /* Seen it before?  This can happen for loopback, retrans,
> > > -            * or local packets.
> > > -            */
> > > -           if (!nf_nat_initialized(ct, maniptype)) {
> > > -                   /* Initialize according to the NAT action. */
> > > -                   err = (range && range->flags & NF_NAT_RANGE_MAP_IPS)
> > > -                           /* Action is set up to establish a new
> > > -                            * mapping.
> > > -                            */
> > > -                           ? nf_nat_setup_info(ct, range, maniptype)
> > > -                           : nf_nat_alloc_null_binding(ct, hooknum);
> > > -                   if (err != NF_ACCEPT)
> > > -                           goto out;
> > > -           }
> > > -           break;
> > > -
> > > -   case IP_CT_ESTABLISHED:
> > > -   case IP_CT_ESTABLISHED_REPLY:
> > > -           break;
> > > -
> > > -   default:
> > > -           err = NF_DROP;
> > > -           goto out;
> > > -   }
> > > -
> > > -   err = nf_nat_packet(ct, ctinfo, hooknum, skb);
> > > -out:
> > > -   if (err == NF_ACCEPT) {
> > > -           if (maniptype == NF_NAT_MANIP_SRC)
> > > -                   tc_skb_cb(skb)->post_ct_snat = 1;
> > > -           if (maniptype == NF_NAT_MANIP_DST)
> > > -                   tc_skb_cb(skb)->post_ct_dnat = 1;
> > > -   }
> > > -   return err;
> > > -}
> > > -#endif /* CONFIG_NF_NAT */
> > > -
> > >  static void tcf_ct_act_set_mark(struct nf_conn *ct, u32 mark, u32 mask)
> > >  {
> > >  #if IS_ENABLED(CONFIG_NF_CONNTRACK_MARK)
> > > @@ -986,52 +902,22 @@ static int tcf_ct_act_nat(struct sk_buff *skb,
> > >                       bool commit)
> > >  {
> > >  #if IS_ENABLED(CONFIG_NF_NAT)
> > > -   int err;
> > > -   enum nf_nat_manip_type maniptype;
> > > +   int err, action = 0;
> > >
> > >     if (!(ct_action & TCA_CT_ACT_NAT))
> > >             return NF_ACCEPT;
> > > +   if (ct_action & TCA_CT_ACT_NAT_SRC)
> > > +           action |= (1 << NF_NAT_MANIP_SRC);
> > > +   if (ct_action & TCA_CT_ACT_NAT_DST)
> > > +           action |= (1 << NF_NAT_MANIP_DST);
> > >
> > > -   /* Add NAT extension if not confirmed yet. */
> > > -   if (!nf_ct_is_confirmed(ct) && !nf_ct_nat_ext_add(ct))
> > > -           return NF_ACCEPT;   /* Can't NAT. */
> > > -
> > > -   if (ctinfo != IP_CT_NEW && (ct->status & IPS_NAT_MASK) &&
> > > -       (ctinfo != IP_CT_RELATED || commit)) {
> > > -           /* NAT an established or related connection like before. */
> > > -           if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY)
> > > -                   /* This is the REPLY direction for a connection
> > > -                    * for which NAT was applied in the forward
> > > -                    * direction.  Do the reverse NAT.
> > > -                    */
> > > -                   maniptype = ct->status & IPS_SRC_NAT
> > > -                           ? NF_NAT_MANIP_DST : NF_NAT_MANIP_SRC;
> > > -           else
> > > -                   maniptype = ct->status & IPS_SRC_NAT
> > > -                           ? NF_NAT_MANIP_SRC : NF_NAT_MANIP_DST;
> > > -   } else if (ct_action & TCA_CT_ACT_NAT_SRC) {
> > > -           maniptype = NF_NAT_MANIP_SRC;
> > > -   } else if (ct_action & TCA_CT_ACT_NAT_DST) {
> > > -           maniptype = NF_NAT_MANIP_DST;
> > > -   } else {
> > > -           return NF_ACCEPT;
> > > -   }
> > > +   err = nf_ct_nat(skb, ct, ctinfo, &action, range, commit);
> > > +
> > > +   if (action & (1 << NF_NAT_MANIP_SRC))
> > > +           tc_skb_cb(skb)->post_ct_snat = 1;
> > > +   if (action & (1 << NF_NAT_MANIP_DST))
> > > +           tc_skb_cb(skb)->post_ct_dnat = 1;
> > >
> > > -   err = ct_nat_execute(skb, ct, ctinfo, range, maniptype);
> > > -   if (err == NF_ACCEPT && ct->status & IPS_DST_NAT) {
> > > -           if (ct->status & IPS_SRC_NAT) {
> > > -                   if (maniptype == NF_NAT_MANIP_SRC)
> > > -                           maniptype = NF_NAT_MANIP_DST;
> > > -                   else
> > > -                           maniptype = NF_NAT_MANIP_SRC;
> > > -
> > > -                   err = ct_nat_execute(skb, ct, ctinfo, range,
> > > -                                        maniptype);
> > > -           } else if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL) {
> > > -                   err = ct_nat_execute(skb, ct, ctinfo, NULL,
> > > -                                        NF_NAT_MANIP_SRC);
> > > -           }
> > > -   }
> > >     return err;
> > >  #else
> > >     return NF_ACCEPT;
> > > --
> > > 2.31.1
> > >
> > _______________________________________________
> > dev mailing list
> > dev@openvswitch.org
> > https://mail.openvswitch.org/mailman/listinfo/ovs-dev
> >
