Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76A6663693B
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 19:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239368AbiKWSsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 13:48:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239425AbiKWSsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 13:48:06 -0500
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E201B1D9
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 10:48:04 -0800 (PST)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-142faa7a207so9036156fac.13
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 10:48:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4ykeYpQhJRVXHtTaqrU0s3ztKusg+pE75ZgzPQQnQCY=;
        b=WidlDwzc5EpEZT2eP12YdPuEmsGJOu0y6OjbtuFhetU7nLSdn1YSliNfgxY/RFH4Uc
         qGam3NzStE3o1Rv7MRB0Yh8UjUwN7rHhdBePEhE5lmR9UuNMLgR7vHHSYDRmImR/El51
         W3kJf3jwPxPulFg4kJStiYaPWD4EI4eLELBDH0Yy9Jw+nnj42DTtMd8+XcSFR3nTKs7f
         1bqbzd8JsHnG+raySapDgApUfJCGPj0T0t3lLQshCgygD1TGwvxxzn5uzH14rHGWbU7m
         gjXCmfGyDj/KfPaS+HsOom1/laIKjKrdEJp4JmJN5OEbkZtuuC0uWxixPFvpawSbZz/X
         6+mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4ykeYpQhJRVXHtTaqrU0s3ztKusg+pE75ZgzPQQnQCY=;
        b=GH1NI0F1z/rhyMTgYw+PsooIteEjLXtlPKC4T+p9Bpg1IvxTwQf2v1Of7VRYbP9p67
         x6oUlM8yFOKpENVfHia6EifLuy4cAzGP6A6yLTNe5LRlvOoRPRGNQm9c1oTQPvTsjQbg
         H6CctMTwn1tZ/wJk9yFuZJ/h6ICLFe2b0kHMPjm5Iqfaega87044KRV4f/vix0ZUvK6i
         urxP2B4sZj6yscmeTskrarElT4S5+2mgE/LlzpPO6BJCHfOVjAwhiZJU9ypv1X1vtagv
         Lv4EV40XZrRQqeLo2UQNeGz1fWTA74xM3HQgaQs/tW34wPr5LgWEvDT6+XSFlDda7Hps
         At1w==
X-Gm-Message-State: ANoB5pnc/Fbckm5Ph1OSR5w22ue60ZHDuepIRCTcXBsd6ChwK2LG1502
        XBqLFnaEn/tpXEI4uCYfEyBXNRBoIpid362r
X-Google-Smtp-Source: AA0mqf4W3MoOnbi+yZtA27SL+3C7Ix6RLAUg/hmJM7d5veh9zbQF/7cvi43WHYkFNAgY2F12xbG+hw==
X-Received: by 2002:a05:6870:a78c:b0:142:f72a:8d4c with SMTP id x12-20020a056870a78c00b00142f72a8d4cmr5637443oao.109.1669229283829;
        Wed, 23 Nov 2022 10:48:03 -0800 (PST)
Received: from t14s.localdomain ([138.204.24.190])
        by smtp.gmail.com with ESMTPSA id bc10-20020a056808170a00b003458d346a60sm6877105oib.25.2022.11.23.10.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 10:48:03 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 04544459D34; Wed, 23 Nov 2022 15:48:01 -0300 (-03)
Date:   Wed, 23 Nov 2022 15:48:00 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
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
Subject: Re: [ovs-dev] [PATCHv2 net-next 5/5] net: move the nat function to
 nf_nat_ovs for ovs and tc
Message-ID: <Y35q4NVXC2D4mgPc@t14s.localdomain>
References: <cover.1669138256.git.lucien.xin@gmail.com>
 <bf19487f4dfc8cd91a4395672d9905b10917128d.1669138256.git.lucien.xin@gmail.com>
 <Y343wyO20XUvwuvg@t14s.localdomain>
 <20221123151335.ssrnv7jfrdugmcgg@t14s.localdomain>
 <CADvbK_eYRZxaNreBmvXmAQzH+JLbiK-9UhKqzH2CM2sHt1bvQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_eYRZxaNreBmvXmAQzH+JLbiK-9UhKqzH2CM2sHt1bvQQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 12:31:38PM -0500, Xin Long wrote:
> On Wed, Nov 23, 2022 at 10:13 AM Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> >
> > On Wed, Nov 23, 2022 at 12:09:55PM -0300, Marcelo Ricardo Leitner wrote:
> > > On Tue, Nov 22, 2022 at 12:32:21PM -0500, Xin Long wrote:
> > > > +int nf_ct_nat(struct sk_buff *skb, struct nf_conn *ct,
> > > > +         enum ip_conntrack_info ctinfo, int *action,
> > > > +         const struct nf_nat_range2 *range, bool commit)
> > > > +{
> > > > +   enum nf_nat_manip_type maniptype;
> > > > +   int err, ct_action = *action;
> > > > +
> > > > +   *action = 0;
> > > > +
> > > > +   /* Add NAT extension if not confirmed yet. */
> > > > +   if (!nf_ct_is_confirmed(ct) && !nf_ct_nat_ext_add(ct))
> > > > +           return NF_ACCEPT;   /* Can't NAT. */
> > > > +
> > > > +   if (ctinfo != IP_CT_NEW && (ct->status & IPS_NAT_MASK) &&
> > > > +       (ctinfo != IP_CT_RELATED || commit)) {
> > > > +           /* NAT an established or related connection like before. */
> > > > +           if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY)
> > > > +                   /* This is the REPLY direction for a connection
> > > > +                    * for which NAT was applied in the forward
> > > > +                    * direction.  Do the reverse NAT.
> > > > +                    */
> > > > +                   maniptype = ct->status & IPS_SRC_NAT
> > > > +                           ? NF_NAT_MANIP_DST : NF_NAT_MANIP_SRC;
> > > > +           else
> > > > +                   maniptype = ct->status & IPS_SRC_NAT
> > > > +                           ? NF_NAT_MANIP_SRC : NF_NAT_MANIP_DST;
> > > > +   } else if (ct_action & (1 << NF_NAT_MANIP_SRC)) {
> > > > +           maniptype = NF_NAT_MANIP_SRC;
> > > > +   } else if (ct_action & (1 << NF_NAT_MANIP_DST)) {
> > > > +           maniptype = NF_NAT_MANIP_DST;
> > > > +   } else {
> > > > +           return NF_ACCEPT;
> > > > +   }
> > > > +
> > > > +   err = nf_ct_nat_execute(skb, ct, ctinfo, action, range, maniptype);
> > > > +   if (err == NF_ACCEPT && ct->status & IPS_DST_NAT) {
> > > > +           if (ct->status & IPS_SRC_NAT) {
> > > > +                   if (maniptype == NF_NAT_MANIP_SRC)
> > > > +                           maniptype = NF_NAT_MANIP_DST;
> > > > +                   else
> > > > +                           maniptype = NF_NAT_MANIP_SRC;
> > > > +
> > > > +                   err = nf_ct_nat_execute(skb, ct, ctinfo, action, range,
> > > > +                                           maniptype);
> > > > +           } else if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL) {
> > > > +                   err = nf_ct_nat_execute(skb, ct, ctinfo, action, NULL,
> > > > +                                           NF_NAT_MANIP_SRC);
> > > > +           }
> > > > +   }
> > > > +   return err;
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(nf_ct_nat);
> > > > diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
> > > > index cc643a556ea1..d03c75165663 100644
> > > > --- a/net/openvswitch/conntrack.c
> > > > +++ b/net/openvswitch/conntrack.c
> > > > @@ -726,144 +726,27 @@ static void ovs_nat_update_key(struct sw_flow_key *key,
> > > >     }
> > > >  }
> > > >
> > > > -/* Modelled after nf_nat_ipv[46]_fn().
> > > > - * range is only used for new, uninitialized NAT state.
> > > > - * Returns either NF_ACCEPT or NF_DROP.
> > > > - */
> > > > -static int ovs_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
> > > > -                         enum ip_conntrack_info ctinfo,
> > > > -                         const struct nf_nat_range2 *range,
> > > > -                         enum nf_nat_manip_type maniptype, struct sw_flow_key *key)
> > > > -{
> > > > -   int hooknum, err = NF_ACCEPT;
> > > > -
> > > > -   /* See HOOK2MANIP(). */
> > > > -   if (maniptype == NF_NAT_MANIP_SRC)
> > > > -           hooknum = NF_INET_LOCAL_IN; /* Source NAT */
> > > > -   else
> > > > -           hooknum = NF_INET_LOCAL_OUT; /* Destination NAT */
> > > > -
> > > > -   switch (ctinfo) {
> > > > -   case IP_CT_RELATED:
> > > > -   case IP_CT_RELATED_REPLY:
> > > > -           if (IS_ENABLED(CONFIG_NF_NAT) &&
> > > > -               skb->protocol == htons(ETH_P_IP) &&
> > > > -               ip_hdr(skb)->protocol == IPPROTO_ICMP) {
> > > > -                   if (!nf_nat_icmp_reply_translation(skb, ct, ctinfo,
> > > > -                                                      hooknum))
> > > > -                           err = NF_DROP;
> > > > -                   goto out;
> > > > -           } else if (IS_ENABLED(CONFIG_IPV6) &&
> > > > -                      skb->protocol == htons(ETH_P_IPV6)) {
> > > > -                   __be16 frag_off;
> > > > -                   u8 nexthdr = ipv6_hdr(skb)->nexthdr;
> > > > -                   int hdrlen = ipv6_skip_exthdr(skb,
> > > > -                                                 sizeof(struct ipv6hdr),
> > > > -                                                 &nexthdr, &frag_off);
> > > > -
> > > > -                   if (hdrlen >= 0 && nexthdr == IPPROTO_ICMPV6) {
> > > > -                           if (!nf_nat_icmpv6_reply_translation(skb, ct,
> > > > -                                                                ctinfo,
> > > > -                                                                hooknum,
> > > > -                                                                hdrlen))
> > > > -                                   err = NF_DROP;
> > > > -                           goto out;
> > > > -                   }
> > > > -           }
> > > > -           /* Non-ICMP, fall thru to initialize if needed. */
> > > > -           fallthrough;
> > > > -   case IP_CT_NEW:
> > > > -           /* Seen it before?  This can happen for loopback, retrans,
> > > > -            * or local packets.
> > > > -            */
> > > > -           if (!nf_nat_initialized(ct, maniptype)) {
> > > > -                   /* Initialize according to the NAT action. */
> > > > -                   err = (range && range->flags & NF_NAT_RANGE_MAP_IPS)
> > > > -                           /* Action is set up to establish a new
> > > > -                            * mapping.
> > > > -                            */
> > > > -                           ? nf_nat_setup_info(ct, range, maniptype)
> > > > -                           : nf_nat_alloc_null_binding(ct, hooknum);
> > > > -                   if (err != NF_ACCEPT)
> > > > -                           goto out;
> > > > -           }
> > > > -           break;
> > > > -
> > > > -   case IP_CT_ESTABLISHED:
> > > > -   case IP_CT_ESTABLISHED_REPLY:
> > > > -           break;
> > > > -
> > > > -   default:
> > > > -           err = NF_DROP;
> > > > -           goto out;
> > > > -   }
> > > > -
> > > > -   err = nf_nat_packet(ct, ctinfo, hooknum, skb);
> > > > -out:
> > > > -   /* Update the flow key if NAT successful. */
> > > > -   if (err == NF_ACCEPT)
> > > > -           ovs_nat_update_key(key, skb, maniptype);
> > > > -
> > > > -   return err;
> > > > -}
> > > > -
> > > >  /* Returns NF_DROP if the packet should be dropped, NF_ACCEPT otherwise. */
> > > >  static int ovs_ct_nat(struct net *net, struct sw_flow_key *key,
> > > >                   const struct ovs_conntrack_info *info,
> > > >                   struct sk_buff *skb, struct nf_conn *ct,
> > > >                   enum ip_conntrack_info ctinfo)
> > > >  {
> > > > -   enum nf_nat_manip_type maniptype;
> > > > -   int err;
> > > > +   int err, action = 0;
> > > >
> > > >     if (!(info->nat & OVS_CT_NAT))
> > > >             return NF_ACCEPT;
> > > > +   if (info->nat & OVS_CT_SRC_NAT)
> > > > +           action |= (1 << NF_NAT_MANIP_SRC);
> > > > +   if (info->nat & OVS_CT_DST_NAT)
> > > > +           action |= (1 << NF_NAT_MANIP_DST);
> > >
> > > I'm wondering why this dance at this level with supporting multiple
> > > MANIPs while actually only one can be used at a time.
> > >
> > > act_ct will reject an action using both:
> > >         if ((p->ct_action & TCA_CT_ACT_NAT_SRC) &&
> > >             (p->ct_action & TCA_CT_ACT_NAT_DST)) {
> > >                 NL_SET_ERR_MSG_MOD(extack, "dnat and snat can't be enabled at the same time");
> > >                 return -EOPNOTSUPP;
> > >
> > > I couldn't find this kind of check in ovs code right now (didn't look much, I
> > > confess :)), but even the code here was already doing:
> > >
> > > -     } else if (info->nat & OVS_CT_SRC_NAT) {
> > > -             maniptype = NF_NAT_MANIP_SRC;
> > > -     } else if (info->nat & OVS_CT_DST_NAT) {
> > > -             maniptype = NF_NAT_MANIP_DST;
> > >
> > > And in case of tuple conflict, maniptype will be forcibly updated in
> > > [*] below.
> >
> > Ahh.. just found why.. in case of typle conflict, nf_ct_nat() now may
> > set both.
> Right.
> BTW. The tuple conflict processing actually has provided the
> code to do full nat (snat and dnat at the same time), which I
> think is more efficient than doing full nat in two zones. All
> we have to do is adjust a few lines of code for that.

In this part, yes. But it needs some surgery all around for full
support. The code in ovs kernel for using only one type starts here:

static int parse_nat(const struct nlattr *attr,
                     struct ovs_conntrack_info *info, bool log)
{
...
                switch (type) {
                case OVS_NAT_ATTR_SRC:
                case OVS_NAT_ATTR_DST:
                        if (info->nat) {
                                OVS_NLERR(log, "Only one type of NAT may be specified");
                                return -ERANGE;
                        }
...
}

So vswitchd also doesn't support it. And then tc, iproute and drivers
that offload it as well. Not sure if it has impacts on openflow too.

