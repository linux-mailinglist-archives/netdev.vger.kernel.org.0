Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58B59636C6F
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 22:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238459AbiKWVf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 16:35:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238437AbiKWVf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 16:35:27 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E304A4168
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 13:35:26 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id v82so2690224oib.4
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 13:35:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fXwgY2spYuqai1ymOeRcV5Ev59gskpR6r8u8n2LwX4E=;
        b=iWxzkJe/04pNAIEg8Z8q/BQEo8UoKOkeYZuRKbhsgRl1XUem0lIVEyzgLebZlsxqtk
         XzMM8o70sSqBVJF9S9/2JVz55+9kNRkykJc/swNq0wgNA1lSnKbAFp1djR4/geo26Gu2
         MAlve0aHq+o2PxN4nC888DEkud5fnfWMEGwtWKyMomyvyvw22OEv88IGZU7ZR7kmoLL4
         IOjMd6DdV6Gg5o5sdE0rpwJwLtNuWkqr8smcn2Isqat+2cAMULdof3V90qh6hRE5fqsb
         22fjHo7T9sS30pdvl1qa8fdDLIIvG1hjC7WnQCEDnL31dkxaUXrK/G3FSTjxkt28c6Du
         XNQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fXwgY2spYuqai1ymOeRcV5Ev59gskpR6r8u8n2LwX4E=;
        b=ZI5s8y8xLOyvnQS10i410FOY1DYUiF9orPNrT94eNfeOveSWjetupVdLmdE/M4Sb3Z
         VtnSFSW5LPY5lTqc9LD7d567gu0kEDZtCRepNurfRgCcqi6q1wgrsphy3rlRkvb+Mim1
         WYK5pyB0PPIy0xdalyQ/GlratItdtsGTjIzwR7lv2JUdSY/U6TYZFYsmuqXeRjHYqVAH
         s/KCZKjymFmtWE/cJhIdqt7SkzxIPC6UUgfnknpMkHrbFsCUUzvmf0x77ddCKEGaa2nM
         2QGFxoQJBMBjUsPjjn4NPb+i3znK6eAEtR8TDszLu5zcGlgvX7uHdlCPA5jC8fKVaqEz
         4xaw==
X-Gm-Message-State: ANoB5pnn972sZoiw+WKTToYdpeqhhS9lG6F3ogGOgNuUv941LhSlGWs4
        YrhITTh3h2ANU8WwK8YSSJWbxF5BknHA6A053RY=
X-Google-Smtp-Source: AA0mqf4wdeKb5LaUp0BGD38j2W0WyabN5WTbGkR3DBN8GFo8tsIUWgjNvvkmfVtxOPQK1JT3nD+5IADsnw9mFhSSyHo=
X-Received: by 2002:aca:2801:0:b0:35a:13f4:d875 with SMTP id
 1-20020aca2801000000b0035a13f4d875mr17587915oix.190.1669239325390; Wed, 23
 Nov 2022 13:35:25 -0800 (PST)
MIME-Version: 1.0
References: <cover.1669138256.git.lucien.xin@gmail.com> <bf19487f4dfc8cd91a4395672d9905b10917128d.1669138256.git.lucien.xin@gmail.com>
 <Y343wyO20XUvwuvg@t14s.localdomain> <20221123151335.ssrnv7jfrdugmcgg@t14s.localdomain>
 <CADvbK_eYRZxaNreBmvXmAQzH+JLbiK-9UhKqzH2CM2sHt1bvQQ@mail.gmail.com>
 <Y35q4NVXC2D4mgPc@t14s.localdomain> <CADvbK_e+tgefsiB1N-7CHUR35P-sDfaOqRVp281VhrQO2ot_hQ@mail.gmail.com>
 <Y35xs4Saj8coBmUH@t14s.localdomain> <CADvbK_c9WpRSaqNkC5MrK9=xXGSE+or-R6=hSwCyeSqm7GO-nw@mail.gmail.com>
 <Y36Oy1gT2KwQH07Y@t14s.localdomain>
In-Reply-To: <Y36Oy1gT2KwQH07Y@t14s.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 23 Nov 2022 16:34:45 -0500
Message-ID: <CADvbK_f1VFE-g0bBdOvyAnnO09QsMt+00b8LxnZ_k=2pBmShkA@mail.gmail.com>
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

On Wed, Nov 23, 2022 at 4:21 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Wed, Nov 23, 2022 at 02:55:05PM -0500, Xin Long wrote:
> > On Wed, Nov 23, 2022 at 2:17 PM Marcelo Ricardo Leitner
> > <marcelo.leitner@gmail.com> wrote:
> > >
> > > On Wed, Nov 23, 2022 at 01:54:41PM -0500, Xin Long wrote:
> > > > On Wed, Nov 23, 2022 at 1:48 PM Marcelo Ricardo Leitner
> > > > <marcelo.leitner@gmail.com> wrote:
> > > > >
> > > > > On Wed, Nov 23, 2022 at 12:31:38PM -0500, Xin Long wrote:
> > > > > > On Wed, Nov 23, 2022 at 10:13 AM Marcelo Ricardo Leitner
> > > > > > <marcelo.leitner@gmail.com> wrote:
> > > > > > >
> > > > > > > On Wed, Nov 23, 2022 at 12:09:55PM -0300, Marcelo Ricardo Leitner wrote:
> > > > > > > > On Tue, Nov 22, 2022 at 12:32:21PM -0500, Xin Long wrote:
> > > > > > > > > +int nf_ct_nat(struct sk_buff *skb, struct nf_conn *ct,
> > > > > > > > > +         enum ip_conntrack_info ctinfo, int *action,
> > > > > > > > > +         const struct nf_nat_range2 *range, bool commit)
> > > > > > > > > +{
> > > > > > > > > +   enum nf_nat_manip_type maniptype;
> > > > > > > > > +   int err, ct_action = *action;
> > > > > > > > > +
> > > > > > > > > +   *action = 0;
> > > > > > > > > +
> > > > > > > > > +   /* Add NAT extension if not confirmed yet. */
> > > > > > > > > +   if (!nf_ct_is_confirmed(ct) && !nf_ct_nat_ext_add(ct))
> > > > > > > > > +           return NF_ACCEPT;   /* Can't NAT. */
> > > > > > > > > +
> > > > > > > > > +   if (ctinfo != IP_CT_NEW && (ct->status & IPS_NAT_MASK) &&
> > > > > > > > > +       (ctinfo != IP_CT_RELATED || commit)) {
> > > > > > > > > +           /* NAT an established or related connection like before. */
> > > > > > > > > +           if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY)
> > > > > > > > > +                   /* This is the REPLY direction for a connection
> > > > > > > > > +                    * for which NAT was applied in the forward
> > > > > > > > > +                    * direction.  Do the reverse NAT.
> > > > > > > > > +                    */
> > > > > > > > > +                   maniptype = ct->status & IPS_SRC_NAT
> > > > > > > > > +                           ? NF_NAT_MANIP_DST : NF_NAT_MANIP_SRC;
> > > > > > > > > +           else
> > > > > > > > > +                   maniptype = ct->status & IPS_SRC_NAT
> > > > > > > > > +                           ? NF_NAT_MANIP_SRC : NF_NAT_MANIP_DST;
> > > > > > > > > +   } else if (ct_action & (1 << NF_NAT_MANIP_SRC)) {
> > > > > > > > > +           maniptype = NF_NAT_MANIP_SRC;
> > > > > > > > > +   } else if (ct_action & (1 << NF_NAT_MANIP_DST)) {
> > > > > > > > > +           maniptype = NF_NAT_MANIP_DST;
> > > > > > > > > +   } else {
> > > > > > > > > +           return NF_ACCEPT;
> > > > > > > > > +   }
> > > > > > > > > +
> > > > > > > > > +   err = nf_ct_nat_execute(skb, ct, ctinfo, action, range, maniptype);
> > > > > > > > > +   if (err == NF_ACCEPT && ct->status & IPS_DST_NAT) {
> > > > > > > > > +           if (ct->status & IPS_SRC_NAT) {
> > > > > > > > > +                   if (maniptype == NF_NAT_MANIP_SRC)
> > > > > > > > > +                           maniptype = NF_NAT_MANIP_DST;
> > > > > > > > > +                   else
> > > > > > > > > +                           maniptype = NF_NAT_MANIP_SRC;
> > > > > > > > > +
> > > > > > > > > +                   err = nf_ct_nat_execute(skb, ct, ctinfo, action, range,
> > > > > > > > > +                                           maniptype);
> > > > > > > > > +           } else if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL) {
> > > > > > > > > +                   err = nf_ct_nat_execute(skb, ct, ctinfo, action, NULL,
> > > > > > > > > +                                           NF_NAT_MANIP_SRC);
> > > > > > > > > +           }
> > > > > > > > > +   }
> > > > > > > > > +   return err;
> > > > > > > > > +}
> > > > > > > > > +EXPORT_SYMBOL_GPL(nf_ct_nat);
> > > > > > > > > diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
> > > > > > > > > index cc643a556ea1..d03c75165663 100644
> > > > > > > > > --- a/net/openvswitch/conntrack.c
> > > > > > > > > +++ b/net/openvswitch/conntrack.c
> > > > > > > > > @@ -726,144 +726,27 @@ static void ovs_nat_update_key(struct sw_flow_key *key,
> > > > > > > > >     }
> > > > > > > > >  }
> > > > > > > > >
> > > > > > > > > -/* Modelled after nf_nat_ipv[46]_fn().
> > > > > > > > > - * range is only used for new, uninitialized NAT state.
> > > > > > > > > - * Returns either NF_ACCEPT or NF_DROP.
> > > > > > > > > - */
> > > > > > > > > -static int ovs_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
> > > > > > > > > -                         enum ip_conntrack_info ctinfo,
> > > > > > > > > -                         const struct nf_nat_range2 *range,
> > > > > > > > > -                         enum nf_nat_manip_type maniptype, struct sw_flow_key *key)
> > > > > > > > > -{
> > > > > > > > > -   int hooknum, err = NF_ACCEPT;
> > > > > > > > > -
> > > > > > > > > -   /* See HOOK2MANIP(). */
> > > > > > > > > -   if (maniptype == NF_NAT_MANIP_SRC)
> > > > > > > > > -           hooknum = NF_INET_LOCAL_IN; /* Source NAT */
> > > > > > > > > -   else
> > > > > > > > > -           hooknum = NF_INET_LOCAL_OUT; /* Destination NAT */
> > > > > > > > > -
> > > > > > > > > -   switch (ctinfo) {
> > > > > > > > > -   case IP_CT_RELATED:
> > > > > > > > > -   case IP_CT_RELATED_REPLY:
> > > > > > > > > -           if (IS_ENABLED(CONFIG_NF_NAT) &&
> > > > > > > > > -               skb->protocol == htons(ETH_P_IP) &&
> > > > > > > > > -               ip_hdr(skb)->protocol == IPPROTO_ICMP) {
> > > > > > > > > -                   if (!nf_nat_icmp_reply_translation(skb, ct, ctinfo,
> > > > > > > > > -                                                      hooknum))
> > > > > > > > > -                           err = NF_DROP;
> > > > > > > > > -                   goto out;
> > > > > > > > > -           } else if (IS_ENABLED(CONFIG_IPV6) &&
> > > > > > > > > -                      skb->protocol == htons(ETH_P_IPV6)) {
> > > > > > > > > -                   __be16 frag_off;
> > > > > > > > > -                   u8 nexthdr = ipv6_hdr(skb)->nexthdr;
> > > > > > > > > -                   int hdrlen = ipv6_skip_exthdr(skb,
> > > > > > > > > -                                                 sizeof(struct ipv6hdr),
> > > > > > > > > -                                                 &nexthdr, &frag_off);
> > > > > > > > > -
> > > > > > > > > -                   if (hdrlen >= 0 && nexthdr == IPPROTO_ICMPV6) {
> > > > > > > > > -                           if (!nf_nat_icmpv6_reply_translation(skb, ct,
> > > > > > > > > -                                                                ctinfo,
> > > > > > > > > -                                                                hooknum,
> > > > > > > > > -                                                                hdrlen))
> > > > > > > > > -                                   err = NF_DROP;
> > > > > > > > > -                           goto out;
> > > > > > > > > -                   }
> > > > > > > > > -           }
> > > > > > > > > -           /* Non-ICMP, fall thru to initialize if needed. */
> > > > > > > > > -           fallthrough;
> > > > > > > > > -   case IP_CT_NEW:
> > > > > > > > > -           /* Seen it before?  This can happen for loopback, retrans,
> > > > > > > > > -            * or local packets.
> > > > > > > > > -            */
> > > > > > > > > -           if (!nf_nat_initialized(ct, maniptype)) {
> > > > > > > > > -                   /* Initialize according to the NAT action. */
> > > > > > > > > -                   err = (range && range->flags & NF_NAT_RANGE_MAP_IPS)
> > > > > > > > > -                           /* Action is set up to establish a new
> > > > > > > > > -                            * mapping.
> > > > > > > > > -                            */
> > > > > > > > > -                           ? nf_nat_setup_info(ct, range, maniptype)
> > > > > > > > > -                           : nf_nat_alloc_null_binding(ct, hooknum);
> > > > > > > > > -                   if (err != NF_ACCEPT)
> > > > > > > > > -                           goto out;
> > > > > > > > > -           }
> > > > > > > > > -           break;
> > > > > > > > > -
> > > > > > > > > -   case IP_CT_ESTABLISHED:
> > > > > > > > > -   case IP_CT_ESTABLISHED_REPLY:
> > > > > > > > > -           break;
> > > > > > > > > -
> > > > > > > > > -   default:
> > > > > > > > > -           err = NF_DROP;
> > > > > > > > > -           goto out;
> > > > > > > > > -   }
> > > > > > > > > -
> > > > > > > > > -   err = nf_nat_packet(ct, ctinfo, hooknum, skb);
> > > > > > > > > -out:
> > > > > > > > > -   /* Update the flow key if NAT successful. */
> > > > > > > > > -   if (err == NF_ACCEPT)
> > > > > > > > > -           ovs_nat_update_key(key, skb, maniptype);
> > > > > > > > > -
> > > > > > > > > -   return err;
> > > > > > > > > -}
> > > > > > > > > -
> > > > > > > > >  /* Returns NF_DROP if the packet should be dropped, NF_ACCEPT otherwise. */
> > > > > > > > >  static int ovs_ct_nat(struct net *net, struct sw_flow_key *key,
> > > > > > > > >                   const struct ovs_conntrack_info *info,
> > > > > > > > >                   struct sk_buff *skb, struct nf_conn *ct,
> > > > > > > > >                   enum ip_conntrack_info ctinfo)
> > > > > > > > >  {
> > > > > > > > > -   enum nf_nat_manip_type maniptype;
> > > > > > > > > -   int err;
> > > > > > > > > +   int err, action = 0;
> > > > > > > > >
> > > > > > > > >     if (!(info->nat & OVS_CT_NAT))
> > > > > > > > >             return NF_ACCEPT;
> > > > > > > > > +   if (info->nat & OVS_CT_SRC_NAT)
> > > > > > > > > +           action |= (1 << NF_NAT_MANIP_SRC);
> > > > > > > > > +   if (info->nat & OVS_CT_DST_NAT)
> > > > > > > > > +           action |= (1 << NF_NAT_MANIP_DST);
> > > > > > > >
> > > > > > > > I'm wondering why this dance at this level with supporting multiple
> > > > > > > > MANIPs while actually only one can be used at a time.
> > > > > > > >
> > > > > > > > act_ct will reject an action using both:
> > > > > > > >         if ((p->ct_action & TCA_CT_ACT_NAT_SRC) &&
> > > > > > > >             (p->ct_action & TCA_CT_ACT_NAT_DST)) {
> > > > > > > >                 NL_SET_ERR_MSG_MOD(extack, "dnat and snat can't be enabled at the same time");
> > > > > > > >                 return -EOPNOTSUPP;
> > > > > > > >
> > > > > > > > I couldn't find this kind of check in ovs code right now (didn't look much, I
> > > > > > > > confess :)), but even the code here was already doing:
> > > > > > > >
> > > > > > > > -     } else if (info->nat & OVS_CT_SRC_NAT) {
> > > > > > > > -             maniptype = NF_NAT_MANIP_SRC;
> > > > > > > > -     } else if (info->nat & OVS_CT_DST_NAT) {
> > > > > > > > -             maniptype = NF_NAT_MANIP_DST;
> > > > > > > >
> > > > > > > > And in case of tuple conflict, maniptype will be forcibly updated in
> > > > > > > > [*] below.
> > > > > > >
> > > > > > > Ahh.. just found why.. in case of typle conflict, nf_ct_nat() now may
> > > > > > > set both.
> > > > > > Right.
> > > > > > BTW. The tuple conflict processing actually has provided the
> > > > > > code to do full nat (snat and dnat at the same time), which I
> > > > > > think is more efficient than doing full nat in two zones. All
> > > > > > we have to do is adjust a few lines of code for that.
> > > > >
> > > > > In this part, yes. But it needs some surgery all around for full
> > > > > support. The code in ovs kernel for using only one type starts here:
> > > > >
> > > > > static int parse_nat(const struct nlattr *attr,
> > > > >                      struct ovs_conntrack_info *info, bool log)
> > > > > {
> > > > > ...
> > > > >                 switch (type) {
> > > > >                 case OVS_NAT_ATTR_SRC:
> > > > >                 case OVS_NAT_ATTR_DST:
> > > > >                         if (info->nat) {
> > > > >                                 OVS_NLERR(log, "Only one type of NAT may be specified");
> > > > >                                 return -ERANGE;
> > > > >                         }
> > > > > ...
> > > > > }
> > > > >
> > > > > So vswitchd also doesn't support it. And then tc, iproute and drivers
> > > > > that offload it as well. Not sure if it has impacts on openflow too.
> > > > >
> > > > not in one single action, but two actions:
> > >
> > > Oh.
> > >
> > > >
> > > > "table=1, in_port=veth1,tcp,tcp_dst=2121,ct_state=+trk+new
> > > > actions=ct(nat(dst=7.7.16.3)),ct(commit, nat(src=7.7.16.1),
> > > > alg=ftp),veth2"
> > > >
> > > > as long as it allows the 1st one doesn't commit, which is a simple
> > > > check in parse_nat().
> > > > I tested it, TC already supports it. I'm not sure about drivers, but I
> > >
> > > There's an outstanding issue with act_ct that it may reuse an old
> > > CT cache. Fixing it could (I'm not sure) impact this use case:
> > >
> > > https://bugzilla.redhat.com/show_bug.cgi?id=2099220
> > > same issue in ovs was fixed in
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2061ecfdf2350994e5b61c43e50e98a7a70e95ee
> > >
> > > (please don't ask me who would NAT and then overwrite IP addresses and
> > > then NAT it again :D)
> > I thought only traditional NAT would change IP, I'm too naive.
> >
> > nftables names this as "stateless NAT."
> > With two CTs in the same zone for full nat is more close to the
> > netfilter's NAT processing (the same CT goes from prerouting to
> > postrouting).
> > Now I'm wondering how nftables handles the stateful NAT and stateless
> > NAT at the same time.
>
> Me too.
>
> >
> > >
> > > > think it should be, as with two actions.
> > >
> > > mlx5 at least currently doesn't support it. Good that tc already
> > > supports it, then. Maybe drivers can get up to speed later on.
> > So because mlx5 currently only supports one ct action in one tc rule
> > or something?
>
> Not sure what you meant here?
Sorry. that might be a silly question, I don't know much about TC
HW offload, and just curious why such a rule can not be offloaded
in mlx5 driver:

"actions=ct(nat(dst=7.7.16.3)),ct(commit, nat(src=7.7.16.1)),veth2"

it doesn't support any tc NAT or just does not support tc full NAT HW offload?

Thanks.
