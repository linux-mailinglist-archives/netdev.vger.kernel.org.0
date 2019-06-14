Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC7EB46599
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 19:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbfFNRWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 13:22:09 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38813 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbfFNRWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 13:22:08 -0400
Received: by mail-pf1-f194.google.com with SMTP id a186so1847211pfa.5
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 10:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=t/e2IiNdEGBM08kWrvCsQvxiXl9YupsI7l7WlNhlhIc=;
        b=vSl9Jhac75ZeF3tkDWyObTJha8iQ74SWMHVbNyopZyLPZgqDfB5KxP6be68xUC6jtJ
         TzeHiiLM52sBMdTtQ9/BpwcHR1D3nhZ6kCdvA+z3/PapS3S/P2DLyug/Hod5aa4RaM4J
         A0qTFxNgpGNBN91d6NWYqAaX/FgfHdb5E5pj/Nv83iRPkLoOHvl6Hf3mn1g6gTGBmkAY
         SFS62NoLygznXM7oelwBWCaQFfQMyeqhtOmKaVbFGFnP6+cwuYJc+W7CTgTc81ULJzMs
         L21ZzrtjfC4xR8OD7b8N/SKzs11rOzmNBtEfUS6SqknKuAbouqKcsbs0SzHMUoCQXtS8
         p22Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t/e2IiNdEGBM08kWrvCsQvxiXl9YupsI7l7WlNhlhIc=;
        b=Rlr6o21R8/Ry+1bQHNyVBhJST7sn6mVfpIlaBSjUJTnw2UxyfWIbRjY72xb3ehXekh
         IVeSpxTNWAJ/z7MBGMNqiQf4ueGxR9Gotz1U5cRA0CFeBrbs83h8Kq6XPWvFUKOXsXBg
         NKiA8rLR5IVr1qa0uGBNFnvTWW+W0AULpJGUf4thZ0v5KevSeJMu7vUe+NrZwTLd9Dz2
         ndvTEhKvBkT4XF/z7JCEer30Kyrp6kU2BedzOEoMK4fsGcrGKSjUxfuGRzL8RkTTiquJ
         1tccAAf4RIHBeQ7Iv7EqfbnM2oIGYIpFAkor9Qqtaj/ZbX4JG3BNqElKUQRTx3N1PknW
         1+UA==
X-Gm-Message-State: APjAAAWWeNiIPyWUUuhRvlPqF7/z1RRiq1YAKjCnmAqqCrYjNYrZS38h
        S62WAW1Tcqlb6Lq5FOXZfmk=
X-Google-Smtp-Source: APXvYqz0Pqzi3mvbI97A1PynPZsz68vR1srhk7LN9gB24Z4i00PxT+BGRUy2G3w/QcLSbED7eBgoKg==
X-Received: by 2002:a17:90a:d817:: with SMTP id a23mr11978655pjv.54.1560532927907;
        Fri, 14 Jun 2019 10:22:07 -0700 (PDT)
Received: from [172.27.227.153] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id q1sm1701964pfn.178.2019.06.14.10.22.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 10:22:06 -0700 (PDT)
Subject: Re: [PATCH net-next v3 1/2] net: sched: add mpls manipulation actions
 to TC
To:     John Hurley <john.hurley@netronome.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        dcaratti@redhat.com, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com
References: <1560524330-25721-1-git-send-email-john.hurley@netronome.com>
 <1560524330-25721-2-git-send-email-john.hurley@netronome.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <24000ac2-a8b6-9908-d8a9-67a66f03b26d@gmail.com>
Date:   Fri, 14 Jun 2019 11:22:03 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1560524330-25721-2-git-send-email-john.hurley@netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/14/19 8:58 AM, John Hurley wrote:
> Currently, TC offers the ability to match on the MPLS fields of a packet
> through the use of the flow_dissector_key_mpls struct. However, as yet, TC
> actions do not allow the modification or manipulation of such fields.
> 
> Add a new module that registers TC action ops to allow manipulation of
> MPLS. This includes the ability to push and pop headers as well as modify
> the contents of new or existing headers. A further action to decrement the
> TTL field of an MPLS header is also provided.

you have this limited to a single mpls label. It would be more flexible
to allow push/pop of N-labels (push probably being the most useful).

more below

> diff --git a/include/uapi/linux/tc_act/tc_mpls.h b/include/uapi/linux/tc_act/tc_mpls.h
> new file mode 100644
> index 0000000..6e8907b
> --- /dev/null
> +++ b/include/uapi/linux/tc_act/tc_mpls.h
> @@ -0,0 +1,32 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/* Copyright (C) 2019 Netronome Systems, Inc. */
> +
> +#ifndef __LINUX_TC_MPLS_H
> +#define __LINUX_TC_MPLS_H
> +
> +#include <linux/pkt_cls.h>
> +
> +#define TCA_MPLS_ACT_POP	1
> +#define TCA_MPLS_ACT_PUSH	2
> +#define TCA_MPLS_ACT_MODIFY	3
> +#define TCA_MPLS_ACT_DEC_TTL	4
> +
> +struct tc_mpls {
> +	tc_gen;
> +	int m_action;
> +};
> +
> +enum {
> +	TCA_MPLS_UNSPEC,
> +	TCA_MPLS_TM,
> +	TCA_MPLS_PARMS,
> +	TCA_MPLS_PAD,
> +	TCA_MPLS_PROTO,
> +	TCA_MPLS_LABEL,
> +	TCA_MPLS_TC,
> +	TCA_MPLS_TTL,
> +	__TCA_MPLS_MAX,
> +};
> +#define TCA_MPLS_MAX (__TCA_MPLS_MAX - 1)
> +
> +#endif

Adding comments to those attributes for userspace writers would be very
helpful. See what I did for the nexthop API -
include/uapi/linux/nexthop.h. My goal there was to document that API
enough that someone adding support to a routing suite (e.g., FRR) never
had to ask a question about the API.


> diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
> new file mode 100644
> index 0000000..828a8d9
> --- /dev/null
> +++ b/net/sched/act_mpls.c
...

> +	switch (p->tcfm_action) {
> +	case TCA_MPLS_ACT_POP:
> +		if (unlikely(!eth_p_mpls(skb->protocol)))
> +			goto out;
> +
> +		if (unlikely(skb_ensure_writable(skb, ETH_HLEN + MPLS_HLEN)))
> +			goto drop;
> +
> +		skb_postpull_rcsum(skb, mpls_hdr(skb), MPLS_HLEN);
> +		memmove(skb->data + MPLS_HLEN, skb->data, ETH_HLEN);
> +
> +		__skb_pull(skb, MPLS_HLEN);
> +		skb_reset_mac_header(skb);
> +		skb_set_network_header(skb, ETH_HLEN);
> +
> +		tcf_mpls_set_eth_type(skb, p->tcfm_proto);
> +		skb->protocol = p->tcfm_proto;

This is pop of a single label. It may or may not be the bottom label, so
it seems like this should handle both cases and may depend on the
packet. If it is the bottom label, then letting the user specify next
seems correct but it is not then the protocol needs to stay MPLS.


> +		break;
> +	case TCA_MPLS_ACT_PUSH:
> +		if (unlikely(skb_cow_head(skb, MPLS_HLEN)))
> +			goto drop;
> +
> +		skb_push(skb, MPLS_HLEN);
> +		memmove(skb->data, skb->data + MPLS_HLEN, ETH_HLEN);
> +		skb_reset_mac_header(skb);
> +		skb_set_network_header(skb, ETH_HLEN);
> +
> +		lse = mpls_hdr(skb);
> +		lse->label_stack_entry = 0;
> +		tcf_mpls_mod_lse(lse, p, !eth_p_mpls(skb->protocol));
> +		skb_postpush_rcsum(skb, lse, MPLS_HLEN);
> +
> +		tcf_mpls_set_eth_type(skb, p->tcfm_proto);
> +		skb->protocol = p->tcfm_proto;

similarly here. If you are pushing one or more labels why allow the user
to specify the protocol? It should be set to ETH_P_MPLS_UC.

> +		break;
> +	case TCA_MPLS_ACT_MODIFY:
> +		if (unlikely(!eth_p_mpls(skb->protocol)))
> +			goto out;
> +
> +		if (unlikely(skb_ensure_writable(skb, ETH_HLEN + MPLS_HLEN)))
> +			goto drop;
> +
> +		lse = mpls_hdr(skb);
> +		skb_postpull_rcsum(skb, lse, MPLS_HLEN);
> +		tcf_mpls_mod_lse(lse, p, false);
> +		skb_postpush_rcsum(skb, lse, MPLS_HLEN);
> +		break;
> +	case TCA_MPLS_ACT_DEC_TTL:
> +		if (unlikely(!eth_p_mpls(skb->protocol)))
> +			goto out;
> +
> +		if (unlikely(skb_ensure_writable(skb, ETH_HLEN + MPLS_HLEN)))
> +			goto drop;
> +
> +		lse = mpls_hdr(skb);
> +		temp_lse = be32_to_cpu(lse->label_stack_entry);
> +		ttl = (temp_lse & MPLS_LS_TTL_MASK) >> MPLS_LS_TTL_SHIFT;
> +		if (!--ttl)
> +			goto drop;
> +
> +		temp_lse &= ~MPLS_LS_TTL_MASK;
> +		temp_lse |= ttl << MPLS_LS_TTL_SHIFT;
> +		skb_postpull_rcsum(skb, lse, MPLS_HLEN);
> +		lse->label_stack_entry = cpu_to_be32(temp_lse);
> +		skb_postpush_rcsum(skb, lse, MPLS_HLEN);
> +		break;
> +	default:
> +		WARN_ONCE(1, "Invalid MPLS action\n");
> +	}
> +
> +out:
> +	if (skb_at_tc_ingress(skb))
> +		skb_pull_rcsum(skb, skb->mac_len);
> +
> +	return ret;
> +
> +drop:
> +	qstats_drop_inc(this_cpu_ptr(m->common.cpu_qstats));
> +	return TC_ACT_SHOT;
> +}
> +
> +static int valid_label(const struct nlattr *attr,
> +		       struct netlink_ext_ack *extack)
> +{
> +	const u32 *label = nla_data(attr);
> +
> +	if (!*label || *label & ~MPLS_LABEL_MASK) {
> +		NL_SET_ERR_MSG_MOD(extack, "MPLS label out of range");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct nla_policy mpls_policy[TCA_MPLS_MAX + 1] = {
> +	[TCA_MPLS_PARMS]	= NLA_POLICY_EXACT_LEN(sizeof(struct tc_mpls)),
> +	[TCA_MPLS_PROTO]	= { .type = NLA_U16 },
> +	[TCA_MPLS_LABEL]	= NLA_POLICY_VALIDATE_FN(NLA_U32, valid_label),
> +	[TCA_MPLS_TC]		= NLA_POLICY_RANGE(NLA_U8, 0, 7),
> +	[TCA_MPLS_TTL]		= NLA_POLICY_MIN(NLA_U8, 1),
> +};

Since this is a new policy, set .strict_start_type in the
TCA_MPLS_UNSPEC entry:
   [TCA_MPLS_UNSPEC] = { .strict_start_type = TCA_MPLS_UNSPEC + 1 },


> +
> +static int tcf_mpls_init(struct net *net, struct nlattr *nla,
> +			 struct nlattr *est, struct tc_action **a,
> +			 int ovr, int bind, bool rtnl_held,
> +			 struct tcf_proto *tp, struct netlink_ext_ack *extack)
> +{
> +	struct tc_action_net *tn = net_generic(net, mpls_net_id);
> +	struct nlattr *tb[TCA_MPLS_MAX + 1];
> +	struct tcf_chain *goto_ch = NULL;
> +	struct tcf_mpls_params *p;
> +	struct tc_mpls *parm;
> +	bool exists = false;
> +	struct tcf_mpls *m;
> +	int ret = 0, err;
> +	u8 mpls_ttl = 0;
> +
> +	if (!nla) {
> +		NL_SET_ERR_MSG_MOD(extack, "missing netlink attributes");
> +		return -EINVAL;
> +	}
> +
> +	err = nla_parse_nested(tb, TCA_MPLS_MAX, nla, mpls_policy, extack);
> +	if (err < 0)
> +		return err;
> +
> +	if (!tb[TCA_MPLS_PARMS]) {
> +		NL_SET_ERR_MSG_MOD(extack, "no MPLS params");
> +		return -EINVAL;
> +	}
> +	parm = nla_data(tb[TCA_MPLS_PARMS]);
> +
> +	/* Verify parameters against action type. */
> +	switch (parm->m_action) {
> +	case TCA_MPLS_ACT_POP:
> +		if (!tb[TCA_MPLS_PROTO] ||
> +		    !eth_proto_is_802_3(nla_get_be16(tb[TCA_MPLS_PROTO]))) {
> +			NL_SET_ERR_MSG_MOD(extack, "MPLS POP: invalid proto");

Please spell out the messages:
  Invalid protocol

> +			return -EINVAL;
> +		}
> +		if (tb[TCA_MPLS_LABEL] || tb[TCA_MPLS_TTL] || tb[TCA_MPLS_TC]) {
> +			NL_SET_ERR_MSG_MOD(extack, "MPLS POP: unsupported attrs");

Be more specific with the error message:
    LABEL, TTL and ??? attributes can not be used with pop action.

> +			return -EINVAL;
> +		}
> +		break;
> +	case TCA_MPLS_ACT_DEC_TTL:
> +		if (tb[TCA_MPLS_PROTO] || tb[TCA_MPLS_LABEL] ||
> +		    tb[TCA_MPLS_TTL] || tb[TCA_MPLS_TC]) {
> +			NL_SET_ERR_MSG_MOD(extack, "MPLS DEC TTL: unsupported attrs");

same here and other extack messages here

