Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2BE5EBFC1
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 12:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbiI0K3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 06:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbiI0K3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 06:29:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6B0CDCE1
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 03:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664274547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dlDKMy7dxWgBEJMLioJwVnTICLhgS/dpJDOmmN0Omgo=;
        b=Ssyk0w3BQBT7J0qv7MhowUxoKSWI1eaqVcXDdaneAt4vd9pA0Wk3f40qmNiVmpyWQGIn1A
        DPCq5hOxKGs8IWml/4EUSmt36PFo/KbTYq2tcS5K26ezCvGWMbff5tF7s0l9mMwu2omWoE
        iNBe3MRunFpFDujWillnXgO4YLmn4fQ=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-638-aGph5n80PJiLW8oIpRZVZw-1; Tue, 27 Sep 2022 06:29:06 -0400
X-MC-Unique: aGph5n80PJiLW8oIpRZVZw-1
Received: by mail-qv1-f71.google.com with SMTP id m7-20020a0ce6e7000000b004ad69308f01so5484552qvn.9
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 03:29:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=dlDKMy7dxWgBEJMLioJwVnTICLhgS/dpJDOmmN0Omgo=;
        b=mz7iJp8GfkHH0AbmieZo7h6hmbEA48VLQTK6zZ2JRhBcl4Bu+2VU9VGBvnxssqsfJz
         238/QJSIgTngxu83UHvl7PORL+EnQtx/t7XKXAggUUcPfIb+7w2CQeQDJL6MeHWb1c4c
         aQHbWOgGQDytVyTHeREcZchtd0reAPBJ065EayAxxV1guRTdEQqPcAZwNUrNQS8tv5zo
         rce0z5yHkSxjgpS7FLOwalcNqHiGkuNivTamgiPhEU07+Co1XI3K1VE7NBzKfL2VZa9Y
         nyViWd28vulocy4syK4lcJmRkVrVXDlunEzPTEafJgEbjjhrRt9QX+RkmFrJJb965shK
         Dr9A==
X-Gm-Message-State: ACrzQf320zV26HqKUmOLX1M0OIbSYSRb4MxqIh4hYZAiDKth6RssLeaH
        PVPFKULHApfJWNc0fmY0l4cJAUjZdoFSxmo0oPdwbvJpML5nrGRlRtH0X3Oed1Y5iNPzBWI2oPb
        PFn1IQ6FsJubAxHi5
X-Received: by 2002:a05:620a:201d:b0:6ce:b005:6113 with SMTP id c29-20020a05620a201d00b006ceb0056113mr16765184qka.346.1664274545523;
        Tue, 27 Sep 2022 03:29:05 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7j8NALqdiwiTq4Y82Nd0+4/yGmO56kL+ahpInMElXImD5p0IhdX2DTMB5B1Kn6PCW5+Pg0cw==
X-Received: by 2002:a05:620a:201d:b0:6ce:b005:6113 with SMTP id c29-20020a05620a201d00b006ceb0056113mr16765175qka.346.1664274545270;
        Tue, 27 Sep 2022 03:29:05 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-96.dyn.eolo.it. [146.241.97.96])
        by smtp.gmail.com with ESMTPSA id k9-20020ac80749000000b0031eddc83560sm555374qth.90.2022.09.27.03.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 03:29:04 -0700 (PDT)
Message-ID: <52ae3eb45615c5d68a955e9a22f5f4915edc4e23.camel@redhat.com>
Subject: Re: [PATCH net-next 2/2] net: sched: add helper support in act_ct
From:   Paolo Abeni <pabeni@redhat.com>
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>
Date:   Tue, 27 Sep 2022 12:29:01 +0200
In-Reply-To: <4781b55b0b7498c574ace703a1481e3688e3f18d.1663946157.git.lucien.xin@gmail.com>
References: <cover.1663946157.git.lucien.xin@gmail.com>
         <4781b55b0b7498c574ace703a1481e3688e3f18d.1663946157.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-09-23 at 11:28 -0400, Xin Long wrote:
> This patch is to add helper support in act_ct for OVS actions=ct(alg=xxx)
> offloading, which is corresponding to Commit cae3a2627520 ("openvswitch:
> Allow attaching helpers to ct action") in OVS kernel part.
> 
> The difference is when adding TC actions family and proto cannot be got
> from the filter/match, other than helper name in tb[TCA_CT_HELPER_NAME],
> we also need to send the family in tb[TCA_CT_HELPER_FAMILY] and the
> proto in tb[TCA_CT_HELPER_PROTO] to kernel.
> 
> Note when calling helper->help() in tcf_ct_act(), the packet will be
> dropped if skb's family and proto do not match the helper's.
> 
> Reported-by: Ilya Maximets <i.maximets@ovn.org>

This tag is a bit out of place here, as it should belong to fixes. Do
you mean 'Suggested-by' ?

> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  include/net/tc_act/tc_ct.h        |   1 +
>  include/uapi/linux/tc_act/tc_ct.h |   3 +
>  net/sched/act_ct.c                | 163 +++++++++++++++++++++++++++++-
>  3 files changed, 165 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/tc_act/tc_ct.h b/include/net/tc_act/tc_ct.h
> index 8250d6f0a462..b24ea2d9400b 100644
> --- a/include/net/tc_act/tc_ct.h
> +++ b/include/net/tc_act/tc_ct.h
> @@ -10,6 +10,7 @@
>  #include <net/netfilter/nf_conntrack_labels.h>
>  
>  struct tcf_ct_params {
> +	struct nf_conntrack_helper *helper;
>  	struct nf_conn *tmpl;
>  	u16 zone;
>  
> diff --git a/include/uapi/linux/tc_act/tc_ct.h b/include/uapi/linux/tc_act/tc_ct.h
> index 5fb1d7ac1027..6c5200f0ed38 100644
> --- a/include/uapi/linux/tc_act/tc_ct.h
> +++ b/include/uapi/linux/tc_act/tc_ct.h
> @@ -22,6 +22,9 @@ enum {
>  	TCA_CT_NAT_PORT_MIN,	/* be16 */
>  	TCA_CT_NAT_PORT_MAX,	/* be16 */
>  	TCA_CT_PAD,
> +	TCA_CT_HELPER_NAME,	/* string */
> +	TCA_CT_HELPER_FAMILY,	/* u8 */
> +	TCA_CT_HELPER_PROTO,	/* u8 */
>  	__TCA_CT_MAX
>  };
>  
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index 193a460a9d7f..771cf72ee9e1 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -33,6 +33,7 @@
>  #include <net/netfilter/nf_conntrack_acct.h>
>  #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
>  #include <net/netfilter/nf_conntrack_act_ct.h>
> +#include <net/netfilter/nf_conntrack_seqadj.h>
>  #include <uapi/linux/netfilter/nf_nat.h>
>  
>  static struct workqueue_struct *act_ct_wq;
> @@ -832,6 +833,13 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
>  
>  static void tcf_ct_params_free(struct tcf_ct_params *params)
>  {
> +	if (params->helper) {
> +#if IS_ENABLED(CONFIG_NF_NAT)
> +		if (params->ct_action & TCA_CT_ACT_NAT)
> +			nf_nat_helper_put(params->helper);
> +#endif
> +		nf_conntrack_helper_put(params->helper);
> +	}
>  	if (params->ct_ft)
>  		tcf_ct_flow_table_put(params->ct_ft);
>  	if (params->tmpl)
> @@ -1022,6 +1030,69 @@ static int tcf_ct_act_nat(struct sk_buff *skb,
>  #endif
>  }
>  
> +static int tcf_ct_helper(struct sk_buff *skb, u8 family)
> +{

This is very similar to ovs_ct_helper(), I'm wondering if a common
helper could be factored out?

> +	const struct nf_conntrack_helper *helper;
> +	const struct nf_conn_help *help;
> +	enum ip_conntrack_info ctinfo;
> +	unsigned int protoff;
> +	struct nf_conn *ct;
> +	u8 proto;
> +	int err;
> +
> +	ct = nf_ct_get(skb, &ctinfo);
> +	if (!ct || ctinfo == IP_CT_RELATED_REPLY)
> +		return NF_ACCEPT;
> +
> +	help = nfct_help(ct);
> +	if (!help)
> +		return NF_ACCEPT;
> +
> +	helper = rcu_dereference(help->helper);
> +	if (!helper)
> +		return NF_ACCEPT;
> +
> +	if (helper->tuple.src.l3num != NFPROTO_UNSPEC &&
> +	    helper->tuple.src.l3num != family)
> +		return NF_DROP;
> +
> +	switch (family) {
> +	case NFPROTO_IPV4:
> +		protoff = ip_hdrlen(skb);
> +		proto = ip_hdr(skb)->protocol;
> +		break;
> +	case NFPROTO_IPV6: {
> +		__be16 frag_off;
> +		int ofs;
> +
> +		proto = ipv6_hdr(skb)->nexthdr;
> +		ofs = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &proto, &frag_off);
> +		if (ofs < 0 || (frag_off & htons(~0x7)) != 0) {
> +			pr_debug("proto header not found\n");
> +			return NF_DROP;

Why this is returning NF_DROP while ovs_ct_helper() returns NF_ACCEPT
here?

> +		}
> +		protoff = ofs;
> +		break;
> +	}
> +	default:
> +		WARN_ONCE(1, "helper invoked on non-IP family!");
> +		return NF_DROP;
> +	}
> +
> +	if (helper->tuple.dst.protonum != proto)
> +		return NF_DROP;

I'm wondering if NF_DROP is appropriate here. This should be a 
situation similar to the above one: the current packet does not match
the helper.

Thanks!

Paolo

