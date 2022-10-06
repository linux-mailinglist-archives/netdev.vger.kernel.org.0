Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86BC45F68C6
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 16:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbiJFOGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 10:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJFOGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 10:06:37 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD395A571C
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 07:06:35 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id q10so2131769oib.5
        for <netdev@vger.kernel.org>; Thu, 06 Oct 2022 07:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/jQkJHffPJAM7ep7LaSBFhLqU8olhaEQ7ia8dU1UcoQ=;
        b=c5ndXtgJu4ckbV7HqvEB4OsD3ZyOEHMoGSwkARbXaSbM7ksoWLJnd1e+1uBig/L7h0
         vIytibCW1E+o42EqTBkWkVym4NpMbg1AG8RR/bi93hwWnSMMKPfu+oJ5+K5S0H8VmuAj
         b/AbIIFZ2Drsk2N+G5qDeKRUvantoEQAY3WYrX6aV/91OxEUUiHDFtM0ZfERjiLuvLJX
         2wv/rmOQS37oMyl+dzkc81RwwKD7TfvSDdtBi7CRjiVWNvllQIXhYOvH0jlXfX9yXoBo
         mGIlftO+4tEDnSvtpngcRga/QNG+DxMkB95a/ggnIh3sfnfb55RHXK/Z9hs8E+L894FJ
         Dr8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/jQkJHffPJAM7ep7LaSBFhLqU8olhaEQ7ia8dU1UcoQ=;
        b=DjQKWi6eNyyV6G9Cmi4I2gaYP7crZUugzunFH3e3zd1Gzbwwc7Tda8oFd/njoncy+Y
         Z25LHxIVEfpTDFKqrYhVhJKk9mr8xYa/Rk5JmJzapbgZGdcJ6m51cCu2j79gGJsanU4/
         U6/jW0tKpEKrgOpI4dBuiuwoHaVRFo8e4Ppp9mA2QI4uKSn2qExccDccbdhTP4M3rZ8V
         oyRCeZysw+Kj6UoVqTBTQ9cpVMINzh8KmRr682eBuH4ACV4qBB3lw4IgmYZPXB9UtG9e
         QHQojULG3ukFPiwDVYJdoe13KAbWxZyZuz0ChNQlnNK0z1gugO9lovibxRSWvn/bdQyS
         w7ew==
X-Gm-Message-State: ACrzQf3YtAWKHdbVPOj4BlsxDx7ELptmR3VHmfe/vOYg+tvrGpbutDGP
        n2AVA0P7PlpZc28WSYvt9sfT9hCcL1682b6IZ/Y=
X-Google-Smtp-Source: AMsMyM4RMp0Vn1BY9OYKRfd1WLmAOLSrvpA8nm+hlcWOfKwQdzoQ4jFg+X27hf4icw3hIPN067ebP70wfaLQS6lZg+8=
X-Received: by 2002:a05:6808:15a2:b0:350:4f5c:1440 with SMTP id
 t34-20020a05680815a200b003504f5c1440mr5057008oiw.129.1665065195089; Thu, 06
 Oct 2022 07:06:35 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1664932669.git.lucien.xin@gmail.com> <bc53ffac4d6be2616d053684fb6670f478b4324b.1664932669.git.lucien.xin@gmail.com>
 <394a97ff1f8adddbab794e0f61221fefddfe9d3f.camel@redhat.com>
In-Reply-To: <394a97ff1f8adddbab794e0f61221fefddfe9d3f.camel@redhat.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 6 Oct 2022 10:05:47 -0400
Message-ID: <CADvbK_fWoAnftF-xpUfKyLx1-xrG-7RO2wAY5fbjKZdsG1RN0Q@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] net: sched: add helper support in act_ct
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        ovs-dev@openvswitch.org, davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>
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

On Thu, Oct 6, 2022 at 5:57 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Tue, 2022-10-04 at 21:19 -0400, Xin Long wrote:
> > This patch is to add helper support in act_ct for OVS actions=ct(alg=xxx)
> > offloading, which is corresponding to Commit cae3a2627520 ("openvswitch:
> > Allow attaching helpers to ct action") in OVS kernel part.
> >
> > The difference is when adding TC actions family and proto cannot be got
> > from the filter/match, other than helper name in tb[TCA_CT_HELPER_NAME],
> > we also need to send the family in tb[TCA_CT_HELPER_FAMILY] and the
> > proto in tb[TCA_CT_HELPER_PROTO] to kernel.
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  include/net/tc_act/tc_ct.h        |   1 +
> >  include/uapi/linux/tc_act/tc_ct.h |   3 +
> >  net/sched/act_ct.c                | 113 ++++++++++++++++++++++++++++--
> >  3 files changed, 112 insertions(+), 5 deletions(-)
> >
> > diff --git a/include/net/tc_act/tc_ct.h b/include/net/tc_act/tc_ct.h
> > index 8250d6f0a462..b24ea2d9400b 100644
> > --- a/include/net/tc_act/tc_ct.h
> > +++ b/include/net/tc_act/tc_ct.h
> > @@ -10,6 +10,7 @@
> >  #include <net/netfilter/nf_conntrack_labels.h>
> >
> >  struct tcf_ct_params {
> > +     struct nf_conntrack_helper *helper;
> >       struct nf_conn *tmpl;
> >       u16 zone;
> >
> > diff --git a/include/uapi/linux/tc_act/tc_ct.h b/include/uapi/linux/tc_act/tc_ct.h
> > index 5fb1d7ac1027..6c5200f0ed38 100644
> > --- a/include/uapi/linux/tc_act/tc_ct.h
> > +++ b/include/uapi/linux/tc_act/tc_ct.h
> > @@ -22,6 +22,9 @@ enum {
> >       TCA_CT_NAT_PORT_MIN,    /* be16 */
> >       TCA_CT_NAT_PORT_MAX,    /* be16 */
> >       TCA_CT_PAD,
> > +     TCA_CT_HELPER_NAME,     /* string */
> > +     TCA_CT_HELPER_FAMILY,   /* u8 */
> > +     TCA_CT_HELPER_PROTO,    /* u8 */
> >       __TCA_CT_MAX
> >  };
> >
> > diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> > index 193a460a9d7f..f237c27079db 100644
> > --- a/net/sched/act_ct.c
> > +++ b/net/sched/act_ct.c
> > @@ -33,6 +33,7 @@
> >  #include <net/netfilter/nf_conntrack_acct.h>
> >  #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
> >  #include <net/netfilter/nf_conntrack_act_ct.h>
> > +#include <net/netfilter/nf_conntrack_seqadj.h>
> >  #include <uapi/linux/netfilter/nf_nat.h>
> >
> >  static struct workqueue_struct *act_ct_wq;
> > @@ -655,7 +656,7 @@ struct tc_ct_action_net {
> >
> >  /* Determine whether skb->_nfct is equal to the result of conntrack lookup. */
> >  static bool tcf_ct_skb_nfct_cached(struct net *net, struct sk_buff *skb,
> > -                                u16 zone_id, bool force)
> > +                                struct tcf_ct_params *p, bool force)
> >  {
> >       enum ip_conntrack_info ctinfo;
> >       struct nf_conn *ct;
> > @@ -665,8 +666,15 @@ static bool tcf_ct_skb_nfct_cached(struct net *net, struct sk_buff *skb,
> >               return false;
> >       if (!net_eq(net, read_pnet(&ct->ct_net)))
> >               goto drop_ct;
> > -     if (nf_ct_zone(ct)->id != zone_id)
> > +     if (nf_ct_zone(ct)->id != p->zone)
> >               goto drop_ct;
> > +     if (p->helper) {
> > +             struct nf_conn_help *help;
> > +
> > +             help = nf_ct_ext_find(ct, NF_CT_EXT_HELPER);
> > +             if (help && rcu_access_pointer(help->helper) != p->helper)
> > +                     goto drop_ct;
> > +     }
> >
> >       /* Force conntrack entry direction. */
> >       if (force && CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL) {
> > @@ -832,6 +840,13 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
> >
> >  static void tcf_ct_params_free(struct tcf_ct_params *params)
> >  {
> > +     if (params->helper) {
> > +#if IS_ENABLED(CONFIG_NF_NAT)
> > +             if (params->ct_action & TCA_CT_ACT_NAT)
> > +                     nf_nat_helper_put(params->helper);
> > +#endif
> > +             nf_conntrack_helper_put(params->helper);
> > +     }
>
> There is exactly the same code chunk in __ovs_ct_free_action(), I guess
> you can extract a common helper here, too.
>
> >       if (params->ct_ft)
> >               tcf_ct_flow_table_put(params->ct_ft);
> >       if (params->tmpl)
> > @@ -1033,6 +1048,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
> >       struct nf_hook_state state;
> >       int nh_ofs, err, retval;
> >       struct tcf_ct_params *p;
> > +     bool add_helper = false;
> >       bool skip_add = false;
> >       bool defrag = false;
> >       struct nf_conn *ct;
> > @@ -1086,7 +1102,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
> >        * actually run the packet through conntrack twice unless it's for a
> >        * different zone.
> >        */
> > -     cached = tcf_ct_skb_nfct_cached(net, skb, p->zone, force);
> > +     cached = tcf_ct_skb_nfct_cached(net, skb, p, force);
> >       if (!cached) {
> >               if (tcf_ct_flow_table_lookup(p, skb, family)) {
> >                       skip_add = true;
> > @@ -1119,6 +1135,22 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
> >       if (err != NF_ACCEPT)
> >               goto drop;
> >
> > +     if (commit && p->helper && !nfct_help(ct)) {
> > +             err = __nf_ct_try_assign_helper(ct, p->tmpl, GFP_ATOMIC);
> > +             if (err)
> > +                     goto drop;
> > +             add_helper = true;
> > +             if (p->ct_action & TCA_CT_ACT_NAT && !nfct_seqadj(ct)) {
> > +                     if (!nfct_seqadj_ext_add(ct))
> > +                             return -EINVAL;
>
> This return looks suspect/wrong. It will confuse the tc action
> mechanism. I guess you shold do
>                                 goto drop;
>
> even here.
You're right, will fix it.

Thanks.
>
> > +             }
> > +     }
> > +
> > +     if (nf_ct_is_confirmed(ct) ? ((!cached && !skip_add) || add_helper) : commit) {
> > +             if (nf_ct_helper(skb, family) != NF_ACCEPT)
> > +                     goto drop;
>
> With the above change, this chunk closely resamble
>
> https://elixir.bootlin.com/linux/latest/source/net/openvswitch/conntrack.c#L1018
> ...
> https://elixir.bootlin.com/linux/latest/source/net/openvswitch/conntrack.c#L1042
>
> opening to an additional common helper;) Not strictly necessary, just
> nice to have :)
>
>
> Thanks!
>
> Paolo
>
