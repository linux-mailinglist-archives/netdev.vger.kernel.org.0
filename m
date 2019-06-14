Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9DAE46CDA
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 01:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfFNXXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 19:23:05 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:43799 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbfFNXXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 19:23:05 -0400
Received: by mail-io1-f66.google.com with SMTP id k20so9236890ios.10
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 16:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DYMK8wHGkj2kqRwsTVcMCPNfmENUfoecH+f5liSbbAY=;
        b=d9SWSXIDY4yrSH277dC4d/oK6as20RUEsdhCdzjZMQlUbSR380qyYsye7ua/2rCVoe
         oUAq409j1hQ3C25h+hpxNtfkw9CpSUpZUtuqNeCpimpxb8/xybYUlT02CLy5xuk/DFJ+
         P96c8RGb8Lr/amsJARiHW6tSTbPtnUwkGQHK/LGiN6IwF+po7aROxKHee0daDKEnJBJJ
         ClwPQGUcN0nLFKqEZvVmJfy8MjGHpWDN46wpj5oq3D90INBAP7xmnEmeIi2wiyqqdAfc
         Xc0YqGPvOqsP4ZqFDRBl/jXn4M2u9ermF1LQgODxk3UcDV8ckM12Puv6R9rD9jty0no0
         Bm8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DYMK8wHGkj2kqRwsTVcMCPNfmENUfoecH+f5liSbbAY=;
        b=C8IHbeHs0e5PyFDhooImLayOLVHz1K8wHBO/2mxoJRIo1oCaANl1W1a2NUHDC2b1W6
         fW5nGN5FOB2OZPOYYpocqloJcFh7bLMqcGKiTOHtrzRvcjOPUn/X+Fy03M4hJ4lzjfg7
         N2CuBoQTpDY4Zbmkj0glcHwUOM2nUUHpygbDrj1H8Von8vJA8YsG+0LxdNjyPWefiJte
         YANdp50bGoQmeIIWEYUkzbxURlX0c6ZyQypB4l4zzy2QzK4WNdgjrnR3LFXn7Ql8eL7I
         7dgsroStvLsfXUDqhgLF7KLBL5KVX2/SCKXclYKY/jx6J008HJIRrvkApDENMwmNz4sE
         zq7w==
X-Gm-Message-State: APjAAAWTjtUs7qFXGhuDTET4mTpqWQh0TxUYWSjH32vY/mRdNMr6H3fW
        uOpt/vJ/uoPKUx/JxUskSKFdIe1yhhHil7owBMAdPwX06Fs=
X-Google-Smtp-Source: APXvYqyRlop/QDByO/cP2aA2VcYGb3DqDoEtCFG675ipS2lNhZ8PgJELZkCxsIfbTZWnmmQCqMZ+EEnly+DZsqI4Itg=
X-Received: by 2002:a02:77d6:: with SMTP id g205mr38323778jac.13.1560554584183;
 Fri, 14 Jun 2019 16:23:04 -0700 (PDT)
MIME-Version: 1.0
References: <1560524330-25721-1-git-send-email-john.hurley@netronome.com>
 <1560524330-25721-2-git-send-email-john.hurley@netronome.com> <24000ac2-a8b6-9908-d8a9-67a66f03b26d@gmail.com>
In-Reply-To: <24000ac2-a8b6-9908-d8a9-67a66f03b26d@gmail.com>
From:   John Hurley <john.hurley@netronome.com>
Date:   Sat, 15 Jun 2019 00:22:52 +0100
Message-ID: <CAK+XE=nTcd+oB=UCe-gHMs7XNtS1w8GUWMwxgGQFtzp5CRz+LA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 1/2] net: sched: add mpls manipulation actions
 to TC
To:     David Ahern <dsahern@gmail.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 6:22 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 6/14/19 8:58 AM, John Hurley wrote:
> > Currently, TC offers the ability to match on the MPLS fields of a packet
> > through the use of the flow_dissector_key_mpls struct. However, as yet, TC
> > actions do not allow the modification or manipulation of such fields.
> >
> > Add a new module that registers TC action ops to allow manipulation of
> > MPLS. This includes the ability to push and pop headers as well as modify
> > the contents of new or existing headers. A further action to decrement the
> > TTL field of an MPLS header is also provided.
>
> you have this limited to a single mpls label. It would be more flexible
> to allow push/pop of N-labels (push probably being the most useful).
>

Hi David.
Multiple push and pop actions can be done by piping them together.
E.g. for a flower filter that pushes 2 labels to an IP packet you can do:

tc filter add dev eth0 protocol ip parent ffff: \
        flower \
        action mpls push protocol mpls_mc label 10 \
        action mpls push protocol mpls_mc label 20 \
        action mirred egress redirect dev eth1


> more below
>
> > diff --git a/include/uapi/linux/tc_act/tc_mpls.h b/include/uapi/linux/tc_act/tc_mpls.h
> > new file mode 100644
> > index 0000000..6e8907b
> > --- /dev/null
> > +++ b/include/uapi/linux/tc_act/tc_mpls.h
> > @@ -0,0 +1,32 @@
> > +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> > +/* Copyright (C) 2019 Netronome Systems, Inc. */
> > +
> > +#ifndef __LINUX_TC_MPLS_H
> > +#define __LINUX_TC_MPLS_H
> > +
> > +#include <linux/pkt_cls.h>
> > +
> > +#define TCA_MPLS_ACT_POP     1
> > +#define TCA_MPLS_ACT_PUSH    2
> > +#define TCA_MPLS_ACT_MODIFY  3
> > +#define TCA_MPLS_ACT_DEC_TTL 4
> > +
> > +struct tc_mpls {
> > +     tc_gen;
> > +     int m_action;
> > +};
> > +
> > +enum {
> > +     TCA_MPLS_UNSPEC,
> > +     TCA_MPLS_TM,
> > +     TCA_MPLS_PARMS,
> > +     TCA_MPLS_PAD,
> > +     TCA_MPLS_PROTO,
> > +     TCA_MPLS_LABEL,
> > +     TCA_MPLS_TC,
> > +     TCA_MPLS_TTL,
> > +     __TCA_MPLS_MAX,
> > +};
> > +#define TCA_MPLS_MAX (__TCA_MPLS_MAX - 1)
> > +
> > +#endif
>
> Adding comments to those attributes for userspace writers would be very
> helpful. See what I did for the nexthop API -
> include/uapi/linux/nexthop.h. My goal there was to document that API
> enough that someone adding support to a routing suite (e.g., FRR) never
> had to ask a question about the API.
>

nice example.
I can add similar

>
> > diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
> > new file mode 100644
> > index 0000000..828a8d9
> > --- /dev/null
> > +++ b/net/sched/act_mpls.c
> ...
>
> > +     switch (p->tcfm_action) {
> > +     case TCA_MPLS_ACT_POP:
> > +             if (unlikely(!eth_p_mpls(skb->protocol)))
> > +                     goto out;
> > +
> > +             if (unlikely(skb_ensure_writable(skb, ETH_HLEN + MPLS_HLEN)))
> > +                     goto drop;
> > +
> > +             skb_postpull_rcsum(skb, mpls_hdr(skb), MPLS_HLEN);
> > +             memmove(skb->data + MPLS_HLEN, skb->data, ETH_HLEN);
> > +
> > +             __skb_pull(skb, MPLS_HLEN);
> > +             skb_reset_mac_header(skb);
> > +             skb_set_network_header(skb, ETH_HLEN);
> > +
> > +             tcf_mpls_set_eth_type(skb, p->tcfm_proto);
> > +             skb->protocol = p->tcfm_proto;
>
> This is pop of a single label. It may or may not be the bottom label, so
> it seems like this should handle both cases and may depend on the
> packet. If it is the bottom label, then letting the user specify next
> seems correct but it is not then the protocol needs to stay MPLS.
>

Yes, the user is expected to indicate the next protocol after the pop
even if another mpls label is next.
We're trying to cater for supporting mpls_uc and mpls_mc ethtypes.
So you could in theory pop the top mpls unicast header and set the
next to multicast.
We expect the user to know what the next header is so enforce that
they give that information.
Do you agree with this or should we add more checks around the BoS bit?

>
> > +             break;
> > +     case TCA_MPLS_ACT_PUSH:
> > +             if (unlikely(skb_cow_head(skb, MPLS_HLEN)))
> > +                     goto drop;
> > +
> > +             skb_push(skb, MPLS_HLEN);
> > +             memmove(skb->data, skb->data + MPLS_HLEN, ETH_HLEN);
> > +             skb_reset_mac_header(skb);
> > +             skb_set_network_header(skb, ETH_HLEN);
> > +
> > +             lse = mpls_hdr(skb);
> > +             lse->label_stack_entry = 0;
> > +             tcf_mpls_mod_lse(lse, p, !eth_p_mpls(skb->protocol));
> > +             skb_postpush_rcsum(skb, lse, MPLS_HLEN);
> > +
> > +             tcf_mpls_set_eth_type(skb, p->tcfm_proto);
> > +             skb->protocol = p->tcfm_proto;
>
> similarly here. If you are pushing one or more labels why allow the user
> to specify the protocol? It should be set to ETH_P_MPLS_UC.
>

Again, this caters for setting ETH_P_MPLS_MC.
For push, the setting of an ethtype is not enforced and UC is used as
the default.

> > +             break;
> > +     case TCA_MPLS_ACT_MODIFY:
> > +             if (unlikely(!eth_p_mpls(skb->protocol)))
> > +                     goto out;
> > +
> > +             if (unlikely(skb_ensure_writable(skb, ETH_HLEN + MPLS_HLEN)))
> > +                     goto drop;
> > +
> > +             lse = mpls_hdr(skb);
> > +             skb_postpull_rcsum(skb, lse, MPLS_HLEN);
> > +             tcf_mpls_mod_lse(lse, p, false);
> > +             skb_postpush_rcsum(skb, lse, MPLS_HLEN);
> > +             break;
> > +     case TCA_MPLS_ACT_DEC_TTL:
> > +             if (unlikely(!eth_p_mpls(skb->protocol)))
> > +                     goto out;
> > +
> > +             if (unlikely(skb_ensure_writable(skb, ETH_HLEN + MPLS_HLEN)))
> > +                     goto drop;
> > +
> > +             lse = mpls_hdr(skb);
> > +             temp_lse = be32_to_cpu(lse->label_stack_entry);
> > +             ttl = (temp_lse & MPLS_LS_TTL_MASK) >> MPLS_LS_TTL_SHIFT;
> > +             if (!--ttl)
> > +                     goto drop;
> > +
> > +             temp_lse &= ~MPLS_LS_TTL_MASK;
> > +             temp_lse |= ttl << MPLS_LS_TTL_SHIFT;
> > +             skb_postpull_rcsum(skb, lse, MPLS_HLEN);
> > +             lse->label_stack_entry = cpu_to_be32(temp_lse);
> > +             skb_postpush_rcsum(skb, lse, MPLS_HLEN);
> > +             break;
> > +     default:
> > +             WARN_ONCE(1, "Invalid MPLS action\n");
> > +     }
> > +
> > +out:
> > +     if (skb_at_tc_ingress(skb))
> > +             skb_pull_rcsum(skb, skb->mac_len);
> > +
> > +     return ret;
> > +
> > +drop:
> > +     qstats_drop_inc(this_cpu_ptr(m->common.cpu_qstats));
> > +     return TC_ACT_SHOT;
> > +}
> > +
> > +static int valid_label(const struct nlattr *attr,
> > +                    struct netlink_ext_ack *extack)
> > +{
> > +     const u32 *label = nla_data(attr);
> > +
> > +     if (!*label || *label & ~MPLS_LABEL_MASK) {
> > +             NL_SET_ERR_MSG_MOD(extack, "MPLS label out of range");
> > +             return -EINVAL;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static const struct nla_policy mpls_policy[TCA_MPLS_MAX + 1] = {
> > +     [TCA_MPLS_PARMS]        = NLA_POLICY_EXACT_LEN(sizeof(struct tc_mpls)),
> > +     [TCA_MPLS_PROTO]        = { .type = NLA_U16 },
> > +     [TCA_MPLS_LABEL]        = NLA_POLICY_VALIDATE_FN(NLA_U32, valid_label),
> > +     [TCA_MPLS_TC]           = NLA_POLICY_RANGE(NLA_U8, 0, 7),
> > +     [TCA_MPLS_TTL]          = NLA_POLICY_MIN(NLA_U8, 1),
> > +};
>
> Since this is a new policy, set .strict_start_type in the
> TCA_MPLS_UNSPEC entry:
>    [TCA_MPLS_UNSPEC] = { .strict_start_type = TCA_MPLS_UNSPEC + 1 },
>

ack

>
> > +
> > +static int tcf_mpls_init(struct net *net, struct nlattr *nla,
> > +                      struct nlattr *est, struct tc_action **a,
> > +                      int ovr, int bind, bool rtnl_held,
> > +                      struct tcf_proto *tp, struct netlink_ext_ack *extack)
> > +{
> > +     struct tc_action_net *tn = net_generic(net, mpls_net_id);
> > +     struct nlattr *tb[TCA_MPLS_MAX + 1];
> > +     struct tcf_chain *goto_ch = NULL;
> > +     struct tcf_mpls_params *p;
> > +     struct tc_mpls *parm;
> > +     bool exists = false;
> > +     struct tcf_mpls *m;
> > +     int ret = 0, err;
> > +     u8 mpls_ttl = 0;
> > +
> > +     if (!nla) {
> > +             NL_SET_ERR_MSG_MOD(extack, "missing netlink attributes");
> > +             return -EINVAL;
> > +     }
> > +
> > +     err = nla_parse_nested(tb, TCA_MPLS_MAX, nla, mpls_policy, extack);
> > +     if (err < 0)
> > +             return err;
> > +
> > +     if (!tb[TCA_MPLS_PARMS]) {
> > +             NL_SET_ERR_MSG_MOD(extack, "no MPLS params");
> > +             return -EINVAL;
> > +     }
> > +     parm = nla_data(tb[TCA_MPLS_PARMS]);
> > +
> > +     /* Verify parameters against action type. */
> > +     switch (parm->m_action) {
> > +     case TCA_MPLS_ACT_POP:
> > +             if (!tb[TCA_MPLS_PROTO] ||
> > +                 !eth_proto_is_802_3(nla_get_be16(tb[TCA_MPLS_PROTO]))) {
> > +                     NL_SET_ERR_MSG_MOD(extack, "MPLS POP: invalid proto");
>
> Please spell out the messages:
>   Invalid protocol
>
> > +                     return -EINVAL;
> > +             }
> > +             if (tb[TCA_MPLS_LABEL] || tb[TCA_MPLS_TTL] || tb[TCA_MPLS_TC]) {
> > +                     NL_SET_ERR_MSG_MOD(extack, "MPLS POP: unsupported attrs");
>
> Be more specific with the error message:
>     LABEL, TTL and ??? attributes can not be used with pop action.
>
> > +                     return -EINVAL;
> > +             }
> > +             break;
> > +     case TCA_MPLS_ACT_DEC_TTL:
> > +             if (tb[TCA_MPLS_PROTO] || tb[TCA_MPLS_LABEL] ||
> > +                 tb[TCA_MPLS_TTL] || tb[TCA_MPLS_TC]) {
> > +                     NL_SET_ERR_MSG_MOD(extack, "MPLS DEC TTL: unsupported attrs");
>
> same here and other extack messages here

ack to the extack comments.
Let me sort.
Thanks for input!

>
