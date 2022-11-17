Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5CB62D03C
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 01:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233802AbiKQAwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 19:52:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234308AbiKQAwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 19:52:17 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0961ECC4
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 16:52:16 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id l127so272892oia.8
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 16:52:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ycrqD8aaAkxixyHjlZOAb1SaJnS7njzbdJspPDv0rMk=;
        b=CztJ9Hu8wlyb11zODiDPzclUDQbjw5UC4x22q8YFfJWzOGlqLm7+JjqYDNEEzWXVv/
         MRKLg4O4wgJQ3KzI8ru6vuIbEX/RSzX+KLa/PoZq4gnrHhWCE/JdNej4JCFS8RsN36g2
         /HIGm/m5bliIIs+JN4m7LmEfwy5/+d7bD/PUaMZhsloI5E57leK0vmT+Z6aVl+RHBGrq
         j7C+pM0RQvxEPmtDnSD/NOZAstmI9QkGdfU9BZn++1yl/7Rk4yOCM4wJqZ3r52iqgVrq
         y+C+6Dg6Fp+XHfgdb6cyPsoGLIn2+BITWQ8hK6aAf2mN85/0lHcFLRhBbkpd0VLa8I9F
         iQ5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ycrqD8aaAkxixyHjlZOAb1SaJnS7njzbdJspPDv0rMk=;
        b=q5jfUJL687XZr8wTriHQ4dTE4PgCN3PzlCeiBBEwC4GG0uHUUrqctDo583TjjDQowL
         dfd241W1A0e9BjmYjpPZoG8uBNSnmOgjwCWFdyvTeDopA0E7k9/KENEdAw5RILiSEoXg
         YH6aWRV9Dsw6uah/+5QjNWyHUMH21Ji4GJRfn8kEfJ1JOBNZYe0ka8Z+1hXzApkcWSDr
         VvGuro+1eEStUyY4BAd2lX+w74DXj3W10WMEp+Qo/BO9KdTs31gPqlNfQVNyqkZ4jYwj
         gBJZ4zcM+hf8MQUqkA8a5s4BIOHKFjF1G17hF3plDrHVfEdr8L2aV8RnkarFcHQf6Lut
         GZGw==
X-Gm-Message-State: ANoB5pmVpkOrjl1PiT56dqN2nZn3UvHn/X6ucylf2RDJE7wZ65rEr9hf
        CV2BkgRiHMHlyA1BpG1wQUWe6tl1jiFwdejiVj21tx9xyNeMzA==
X-Google-Smtp-Source: AA0mqf7Zg/SmJQhhAkQ8mQiV2sjF4jWpXBus8oXLF/mXN7BdVb23fYJzTo/4MNnhBchy32omgwUdkfigGa4yKURvKl0=
X-Received: by 2002:aca:1218:0:b0:350:3cad:642 with SMTP id
 24-20020aca1218000000b003503cad0642mr3013029ois.129.1668646335050; Wed, 16
 Nov 2022 16:52:15 -0800 (PST)
MIME-Version: 1.0
References: <cover.1668527318.git.lucien.xin@gmail.com> <488fbfa082eb8a0ab81622a7c13c26b6fd8a0602.1668527318.git.lucien.xin@gmail.com>
 <Y3VcEiOlB5OG0XFS@salvia>
In-Reply-To: <Y3VcEiOlB5OG0XFS@salvia>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 16 Nov 2022 19:51:40 -0500
Message-ID: <CADvbK_en1btAkbvOBm7+LuN7_G_mkU0==HD-GSTjAjhJPykPdQ@mail.gmail.com>
Subject: Re: [PATCH net-next 5/5] net: move the nat function to nf_nat_core
 for ovs and tc
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Aaron Conole <aconole@redhat.com>
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

On Wed, Nov 16, 2022 at 4:54 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Tue, Nov 15, 2022 at 10:50:57AM -0500, Xin Long wrote:
> > diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> > index e29e4ccb5c5a..1c72b8caa24e 100644
> > --- a/net/netfilter/nf_nat_core.c
> > +++ b/net/netfilter/nf_nat_core.c
> > @@ -784,6 +784,137 @@ nf_nat_inet_fn(void *priv, struct sk_buff *skb,
> >  }
> >  EXPORT_SYMBOL_GPL(nf_nat_inet_fn);
> >
> > +/* Modelled after nf_nat_ipv[46]_fn().
> > + * range is only used for new, uninitialized NAT state.
> > + * Returns either NF_ACCEPT or NF_DROP.
> > + */
> > +static int nf_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
> > +                          enum ip_conntrack_info ctinfo, int *action,
> > +                          const struct nf_nat_range2 *range,
> > +                          enum nf_nat_manip_type maniptype)
> > +{
> > +     __be16 proto = skb_protocol(skb, true);
> > +     int hooknum, err = NF_ACCEPT;
> > +
> > +     /* See HOOK2MANIP(). */
> > +     if (maniptype == NF_NAT_MANIP_SRC)
> > +             hooknum = NF_INET_LOCAL_IN; /* Source NAT */
> > +     else
> > +             hooknum = NF_INET_LOCAL_OUT; /* Destination NAT */
> > +
> > +     switch (ctinfo) {
> > +     case IP_CT_RELATED:
> > +     case IP_CT_RELATED_REPLY:
> > +             if (proto == htons(ETH_P_IP) &&
> > +                 ip_hdr(skb)->protocol == IPPROTO_ICMP) {
> > +                     if (!nf_nat_icmp_reply_translation(skb, ct, ctinfo,
> > +                                                        hooknum))
> > +                             err = NF_DROP;
> > +                     goto out;
> > +             } else if (IS_ENABLED(CONFIG_IPV6) && proto == htons(ETH_P_IPV6)) {
> > +                     __be16 frag_off;
> > +                     u8 nexthdr = ipv6_hdr(skb)->nexthdr;
> > +                     int hdrlen = ipv6_skip_exthdr(skb,
> > +                                                   sizeof(struct ipv6hdr),
> > +                                                   &nexthdr, &frag_off);
> > +
> > +                     if (hdrlen >= 0 && nexthdr == IPPROTO_ICMPV6) {
> > +                             if (!nf_nat_icmpv6_reply_translation(skb, ct,
> > +                                                                  ctinfo,
> > +                                                                  hooknum,
> > +                                                                  hdrlen))
> > +                                     err = NF_DROP;
> > +                             goto out;
> > +                     }
> > +             }
> > +             /* Non-ICMP, fall thru to initialize if needed. */
> > +             fallthrough;
> > +     case IP_CT_NEW:
> > +             /* Seen it before?  This can happen for loopback, retrans,
> > +              * or local packets.
> > +              */
> > +             if (!nf_nat_initialized(ct, maniptype)) {
> > +                     /* Initialize according to the NAT action. */
> > +                     err = (range && range->flags & NF_NAT_RANGE_MAP_IPS)
> > +                             /* Action is set up to establish a new
> > +                              * mapping.
> > +                              */
> > +                             ? nf_nat_setup_info(ct, range, maniptype)
> > +                             : nf_nat_alloc_null_binding(ct, hooknum);
> > +                     if (err != NF_ACCEPT)
> > +                             goto out;
> > +             }
> > +             break;
> > +
> > +     case IP_CT_ESTABLISHED:
> > +     case IP_CT_ESTABLISHED_REPLY:
> > +             break;
> > +
> > +     default:
> > +             err = NF_DROP;
> > +             goto out;
> > +     }
> > +
> > +     err = nf_nat_packet(ct, ctinfo, hooknum, skb);
> > +     if (err == NF_ACCEPT)
> > +             *action |= (1 << maniptype);
> > +out:
> > +     return err;
> > +}
> > +
> > +int nf_ct_nat(struct sk_buff *skb, struct nf_conn *ct,
> > +           enum ip_conntrack_info ctinfo, int *action,
> > +           const struct nf_nat_range2 *range, bool commit)
> > +{
> > +     enum nf_nat_manip_type maniptype;
> > +     int err, ct_action = *action;
> > +
> > +     *action = 0;
> > +
> > +     /* Add NAT extension if not confirmed yet. */
> > +     if (!nf_ct_is_confirmed(ct) && !nf_ct_nat_ext_add(ct))
> > +             return NF_ACCEPT;   /* Can't NAT. */
> > +
> > +     if (ctinfo != IP_CT_NEW && (ct->status & IPS_NAT_MASK) &&
> > +         (ctinfo != IP_CT_RELATED || commit)) {
> > +             /* NAT an established or related connection like before. */
> > +             if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY)
> > +                     /* This is the REPLY direction for a connection
> > +                      * for which NAT was applied in the forward
> > +                      * direction.  Do the reverse NAT.
> > +                      */
> > +                     maniptype = ct->status & IPS_SRC_NAT
> > +                             ? NF_NAT_MANIP_DST : NF_NAT_MANIP_SRC;
> > +             else
> > +                     maniptype = ct->status & IPS_SRC_NAT
> > +                             ? NF_NAT_MANIP_SRC : NF_NAT_MANIP_DST;
> > +     } else if (ct_action & (1 << NF_NAT_MANIP_SRC)) {
> > +             maniptype = NF_NAT_MANIP_SRC;
> > +     } else if (ct_action & (1 << NF_NAT_MANIP_DST)) {
> > +             maniptype = NF_NAT_MANIP_DST;
> > +     } else {
> > +             return NF_ACCEPT;
> > +     }
> > +
> > +     err = nf_ct_nat_execute(skb, ct, ctinfo, action, range, maniptype);
> > +     if (err == NF_ACCEPT && ct->status & IPS_DST_NAT) {
> > +             if (ct->status & IPS_SRC_NAT) {
> > +                     if (maniptype == NF_NAT_MANIP_SRC)
> > +                             maniptype = NF_NAT_MANIP_DST;
> > +                     else
> > +                             maniptype = NF_NAT_MANIP_SRC;
> > +
> > +                     err = nf_ct_nat_execute(skb, ct, ctinfo, action, range,
> > +                                             maniptype);
> > +             } else if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL) {
> > +                     err = nf_ct_nat_execute(skb, ct, ctinfo, action, NULL,
> > +                                             NF_NAT_MANIP_SRC);
> > +             }
> > +     }
> > +     return err;
> > +}
> > +EXPORT_SYMBOL_GPL(nf_ct_nat);
>
> I'd suggest you move this code to nf_nat_ovs.c or such so we remember
> these symbols are used by act_ct.c and ovs.
Good idea, do you think we should also create nf_conntrack_ovs.c
to have nf_ct_helper() and nf_ct_add_helper()?
which were added by:

https://lore.kernel.org/netdev/20221101150031.a6rtrgzwfd7kzknn@t14s.localdomain/T/

thanks.
