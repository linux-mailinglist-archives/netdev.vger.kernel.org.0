Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAE945EC731
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 17:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbiI0PFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 11:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231926AbiI0PFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 11:05:08 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995DA4A822
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 08:05:00 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-1318443dbdfso2276572fac.3
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 08:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=4MrVbxtRCiMH3zoesusZRq3iC5K3//wizKjYRHtIfO0=;
        b=QZ76X3p+pJ6WamI5Xcufw8RaNGnupytCtanhc0rIuLwCKR1mqg1etubqe06dDB4DG8
         m1gzvSOWu5K1wdqcFLb9SZ2uDutvAR3f7CawO0yf6elIsXvY5Kx6WhKKgt+9rYkqO6xr
         YoatoovJpULxAWgcNDrIZjuipdDBIURUCVwwARAZmMIY56W3fTtCqKu5W+cBCEZnmmmM
         62yX6pASa/kJhxH7Ih88KJOZH8two+C9xHYvq6AE9o4y90nWThhQ4XpjOvt936naWfXR
         7aN3XO74T6sM8OuVqXd0SdEM5CDNe9mPQ5PzCK8BS3LV2hfhU8MEYWD54dJFEJIGo6aU
         ildA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=4MrVbxtRCiMH3zoesusZRq3iC5K3//wizKjYRHtIfO0=;
        b=3vuvLjq5RvdVw9up4dP94R6rc/Tmiurpfp9YITaLZE4CVjaw5UfgHI3xGfO3lsO6AU
         mG3CxDFsuDR/ICuGs8iS+8SUDNVrBOZZGRHTZ1K4XwR0ucd4YGQm8kYQOvLVzab3ZnQm
         YpxuOTnmGmNRkuf8aLNnXNSIlcnKb8HJHkMAmVemVNG/48NPn/x49EtL5gSaxniOtnGf
         5B4YbCfpLGsQ8OtlNYb8FJmGCJQZ8g9B8On4H6NJlfYZwHPiGEyfoWtIe2HRhmuBl8z7
         7OVBYTTWhGBNGoh1MN7cIb29o8tTdXp2/GyKhZRbu9XumhU64e1ZqRzeahrdbclbCG4A
         FWyw==
X-Gm-Message-State: ACrzQf1EO0kPvaHj21FwabPy/GWOD3WCt/jtlsz0bFpZRGhEH+2IAw5P
        NL5VDcYahRWI8arDrWGr4Wg1ooJPeKfs0ts/JDo=
X-Google-Smtp-Source: AMsMyM61FRg5tUkAGaOwxV6V/VPYkncbAsVA6Ut/7gP7nE0eIL7mardknTRu2FJec1go8oJMnx395xlYp5u5QCo/NMU=
X-Received: by 2002:a05:6870:523:b0:131:2d50:e09c with SMTP id
 j35-20020a056870052300b001312d50e09cmr2544895oao.129.1664291100157; Tue, 27
 Sep 2022 08:05:00 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1663946157.git.lucien.xin@gmail.com> <4781b55b0b7498c574ace703a1481e3688e3f18d.1663946157.git.lucien.xin@gmail.com>
 <52ae3eb45615c5d68a955e9a22f5f4915edc4e23.camel@redhat.com>
In-Reply-To: <52ae3eb45615c5d68a955e9a22f5f4915edc4e23.camel@redhat.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 27 Sep 2022 11:04:18 -0400
Message-ID: <CADvbK_eJk_mRp7V4n1JTa5p3FhvqNUK5+yoocQeYskM7z0ioNA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: sched: add helper support in act_ct
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>
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

On Tue, Sep 27, 2022 at 6:29 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Fri, 2022-09-23 at 11:28 -0400, Xin Long wrote:
> > This patch is to add helper support in act_ct for OVS actions=ct(alg=xxx)
> > offloading, which is corresponding to Commit cae3a2627520 ("openvswitch:
> > Allow attaching helpers to ct action") in OVS kernel part.
> >
> > The difference is when adding TC actions family and proto cannot be got
> > from the filter/match, other than helper name in tb[TCA_CT_HELPER_NAME],
> > we also need to send the family in tb[TCA_CT_HELPER_FAMILY] and the
> > proto in tb[TCA_CT_HELPER_PROTO] to kernel.
> >
> > Note when calling helper->help() in tcf_ct_act(), the packet will be
> > dropped if skb's family and proto do not match the helper's.
> >
> > Reported-by: Ilya Maximets <i.maximets@ovn.org>
>
> This tag is a bit out of place here, as it should belong to fixes. Do
> you mean 'Suggested-by' ?
This one was reported as an OVS bug, but from TC side, it's a feature.
I will remove it.

>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  include/net/tc_act/tc_ct.h        |   1 +
> >  include/uapi/linux/tc_act/tc_ct.h |   3 +
> >  net/sched/act_ct.c                | 163 +++++++++++++++++++++++++++++-
> >  3 files changed, 165 insertions(+), 2 deletions(-)
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
> > index 193a460a9d7f..771cf72ee9e1 100644
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
> > @@ -832,6 +833,13 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
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
> >       if (params->ct_ft)
> >               tcf_ct_flow_table_put(params->ct_ft);
> >       if (params->tmpl)
> > @@ -1022,6 +1030,69 @@ static int tcf_ct_act_nat(struct sk_buff *skb,
> >  #endif
> >  }
> >
> > +static int tcf_ct_helper(struct sk_buff *skb, u8 family)
> > +{
>
> This is very similar to ovs_ct_helper(), I'm wondering if a common
> helper could be factored out?
I wanted to, but these are two modules, I don't expect one depends another.
Although this is for OVS offloading, but it can still be used independently.
maybe I should move this function to nf_conntrack_helper.c in netfilter?

>
> > +     const struct nf_conntrack_helper *helper;
> > +     const struct nf_conn_help *help;
> > +     enum ip_conntrack_info ctinfo;
> > +     unsigned int protoff;
> > +     struct nf_conn *ct;
> > +     u8 proto;
> > +     int err;
> > +
> > +     ct = nf_ct_get(skb, &ctinfo);
> > +     if (!ct || ctinfo == IP_CT_RELATED_REPLY)
> > +             return NF_ACCEPT;
> > +
> > +     help = nfct_help(ct);
> > +     if (!help)
> > +             return NF_ACCEPT;
> > +
> > +     helper = rcu_dereference(help->helper);
> > +     if (!helper)
> > +             return NF_ACCEPT;
> > +
> > +     if (helper->tuple.src.l3num != NFPROTO_UNSPEC &&
> > +         helper->tuple.src.l3num != family)
> > +             return NF_DROP;
> > +
> > +     switch (family) {
> > +     case NFPROTO_IPV4:
> > +             protoff = ip_hdrlen(skb);
> > +             proto = ip_hdr(skb)->protocol;
> > +             break;
> > +     case NFPROTO_IPV6: {
> > +             __be16 frag_off;
> > +             int ofs;
> > +
> > +             proto = ipv6_hdr(skb)->nexthdr;
> > +             ofs = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &proto, &frag_off);
> > +             if (ofs < 0 || (frag_off & htons(~0x7)) != 0) {
> > +                     pr_debug("proto header not found\n");
> > +                     return NF_DROP;
>
> Why this is returning NF_DROP while ovs_ct_helper() returns NF_ACCEPT
> here?
>
> > +             }
> > +             protoff = ofs;
> > +             break;
> > +     }
> > +     default:
> > +             WARN_ONCE(1, "helper invoked on non-IP family!");
> > +             return NF_DROP;
> > +     }
> > +
> > +     if (helper->tuple.dst.protonum != proto)
> > +             return NF_DROP;
>
> I'm wondering if NF_DROP is appropriate here. This should be a
> situation similar to the above one: the current packet does not match
> the helper.
I was thinking the packets arriving here should be matched with the helper's,
this would force users do a right configuration on flower or other match. But
this might be too harsh and will change to NF_ACCEPT.

Thanks!

>
> Thanks!
>
> Paolo
>
