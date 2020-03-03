Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 671AD177C6A
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 17:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730461AbgCCQvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 11:51:32 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45471 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729156AbgCCQvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 11:51:31 -0500
Received: by mail-qt1-f196.google.com with SMTP id a4so3299270qto.12
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 08:51:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FQplH7IAsN6PJdvMHxtvC3h5hvryow4/juclK2mHKo4=;
        b=dvR4rSX4wD+95oav2Ff8QooSVqZWaZlYGlf4waqD5vzAaBt8UD/tBbR9PNnvDr2EK6
         exKA9ygzBmP3pteCWVmrPhGqUQXKz1lZ2A15MIBGyoEh4ShTguuZl/wvWCjoVXbWvWr0
         cC1nTqdxiMQKWW/JGYl6sLx0sOdOYjzJG4c0W0p6r7Wti6rstQYprXzjCIPOULSmJB9Q
         Lp44QfevdugwXxhV9+/FCyHSRNt9TwjKuvhZ3X7H7PqcJmYSDNXo+eTArSAAl4AGlRDX
         gf7lZ9zD26vxHSfdJ+3BYu85bpvlWA/4tn92fEnSQZsFWYK9glXGH1HQV8uHvGLGqVNi
         lghg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FQplH7IAsN6PJdvMHxtvC3h5hvryow4/juclK2mHKo4=;
        b=VUYJhfJcyiR1t0ktT6hJM0VEVFHNNKGufREuJLrMgM8iYksSid+n3EW9PPl3dMTnnD
         iuzpSSuVIR1BYIHR8e0ACRASzPD7CxVpCtJKoy8zUOlaaFsw3tGuyl+wW/eu9nKaqJjL
         T2h4mrthIJDvrE09vUIDzZVzEaFJnPrdwjWRJpThdSuuV+gLwpE0c+8Ci2d+RUPY/sdG
         XbEtWqpoeQkCn8lcTwS4yXXdCcJB4fwIJk6cpk+VeALKSuPQ4xO/vFNQqr3AuwSlbwCr
         L6C0pljBsTttVFRZVmG6VqHE5rSdkLoU/8WF0a5qRqARzCy0MkTotWPOfSDzD3YZcV1/
         m+ZA==
X-Gm-Message-State: ANhLgQ3WztXXsgqdOUHy7kzO2gGI7h4qGvrixjhaa3NKoIX6+Bwzkpgp
        RVioz8ZLbUKMBc2GGgRn64wryQT03ag=
X-Google-Smtp-Source: ADFU+vszz3rvRcCl1kppKGu1PIzCb4lKMy912mYb9l7c0YHYBitLOQzkt/WKN9v2m16LY8jfbvoRNg==
X-Received: by 2002:ac8:3283:: with SMTP id z3mr5296518qta.123.1583254288416;
        Tue, 03 Mar 2020 08:51:28 -0800 (PST)
Received: from localhost.localdomain ([177.220.172.122])
        by smtp.gmail.com with ESMTPSA id i28sm13041193qtc.57.2020.03.03.08.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 08:51:27 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 7E2F1C5B52; Tue,  3 Mar 2020 13:51:25 -0300 (-03)
Date:   Tue, 3 Mar 2020 13:51:25 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: Re: [PATCH net-next v6 3/3] net/sched: act_ct: Software offload of
 established flows
Message-ID: <20200303165125.GE2546@localhost.localdomain>
References: <1583251072-10396-1-git-send-email-paulb@mellanox.com>
 <1583251072-10396-4-git-send-email-paulb@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1583251072-10396-4-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 03, 2020 at 05:57:52PM +0200, Paul Blakey wrote:
> Offload nf conntrack processing by looking up the 5-tuple in the
> zone's flow table.
> 
> The nf conntrack module will process the packets until a connection is
> in established state. Once in established state, the ct state pointer
> (nf_conn) will be restored on the skb from a successful ft lookup.
> 
> Signed-off-by: Paul Blakey <paulb@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
> Changelog:
>   v5->v6:
>    Refactor tcp fin/rst check, get tcp header inside filler, and test in caller
>    Pull tcp with ports instead of two pulls
>   v4->v5:
>    Re-read ip/ip6 header after pulling as skb ptrs may change
>    Use pskb_network_may_pull instaed of pskb_may_pull
>   v1->v2:
>    Add !skip_add curly braces
>    Removed extra setting thoff again
>    Check tcp proto outside of tcf_ct_flow_table_check_tcp
> 
>  net/sched/act_ct.c | 152 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 150 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index 2ab38431..23eba61 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -186,6 +186,147 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
>  	tcf_ct_flow_table_add(ct_ft, ct, tcp);
>  }
>  
> +static bool
> +tcf_ct_flow_table_fill_tuple_ipv4(struct sk_buff *skb,
> +				  struct flow_offload_tuple *tuple,
> +				  struct tcphdr **tcph)
> +{
> +	struct flow_ports *ports;
> +	unsigned int thoff;
> +	struct iphdr *iph;
> +
> +	if (!pskb_network_may_pull(skb, sizeof(*iph)))
> +		return false;
> +
> +	iph = ip_hdr(skb);
> +	thoff = iph->ihl * 4;
> +
> +	if (ip_is_fragment(iph) ||
> +	    unlikely(thoff != sizeof(struct iphdr)))
> +		return false;
> +
> +	if (iph->protocol != IPPROTO_TCP &&
> +	    iph->protocol != IPPROTO_UDP)
> +		return false;
> +
> +	if (iph->ttl <= 1)
> +		return false;
> +
> +	if (!pskb_network_may_pull(skb, iph->protocol == IPPROTO_TCP ?
> +					thoff + sizeof(struct tcphdr) :
> +					thoff + sizeof(*ports)))
> +		return false;
> +
> +	iph = ip_hdr(skb);
> +	if (iph->protocol == IPPROTO_TCP)
> +		*tcph = (void *)(skb_network_header(skb) + thoff);
> +
> +	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
> +	tuple->src_v4.s_addr = iph->saddr;
> +	tuple->dst_v4.s_addr = iph->daddr;
> +	tuple->src_port = ports->source;
> +	tuple->dst_port = ports->dest;
> +	tuple->l3proto = AF_INET;
> +	tuple->l4proto = iph->protocol;
> +
> +	return true;
> +}
> +
> +static bool
> +tcf_ct_flow_table_fill_tuple_ipv6(struct sk_buff *skb,
> +				  struct flow_offload_tuple *tuple,
> +				  struct tcphdr **tcph)
> +{
> +	struct flow_ports *ports;
> +	struct ipv6hdr *ip6h;
> +	unsigned int thoff;
> +
> +	if (!pskb_network_may_pull(skb, sizeof(*ip6h)))
> +		return false;
> +
> +	ip6h = ipv6_hdr(skb);
> +
> +	if (ip6h->nexthdr != IPPROTO_TCP &&
> +	    ip6h->nexthdr != IPPROTO_UDP)
> +		return false;
> +
> +	if (ip6h->hop_limit <= 1)
> +		return false;
> +
> +	thoff = sizeof(*ip6h);
> +	if (!pskb_network_may_pull(skb, ip6h->nexthdr == IPPROTO_TCP ?
> +					thoff + sizeof(struct tcphdr) :
> +					thoff + sizeof(*ports)))
> +		return false;
> +
> +	ip6h = ipv6_hdr(skb);
> +	if (ip6h->nexthdr == IPPROTO_TCP)
> +		*tcph = (void *)(skb_network_header(skb) + thoff);
> +
> +	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
> +	tuple->src_v6 = ip6h->saddr;
> +	tuple->dst_v6 = ip6h->daddr;
> +	tuple->src_port = ports->source;
> +	tuple->dst_port = ports->dest;
> +	tuple->l3proto = AF_INET6;
> +	tuple->l4proto = ip6h->nexthdr;
> +
> +	return true;
> +}
> +
> +static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
> +				     struct sk_buff *skb,
> +				     u8 family)
> +{
> +	struct nf_flowtable *nf_ft = &p->ct_ft->nf_ft;
> +	struct flow_offload_tuple_rhash *tuplehash;
> +	struct flow_offload_tuple tuple = {};
> +	enum ip_conntrack_info ctinfo;
> +	struct tcphdr *tcph = NULL;
> +	struct flow_offload *flow;
> +	struct nf_conn *ct;
> +	u8 dir;
> +
> +	/* Previously seen or loopback */
> +	ct = nf_ct_get(skb, &ctinfo);
> +	if ((ct && !nf_ct_is_template(ct)) || ctinfo == IP_CT_UNTRACKED)
> +		return false;
> +
> +	switch (family) {
> +	case NFPROTO_IPV4:
> +		if (!tcf_ct_flow_table_fill_tuple_ipv4(skb, &tuple, &tcph))
> +			return false;
> +		break;
> +	case NFPROTO_IPV6:
> +		if (!tcf_ct_flow_table_fill_tuple_ipv6(skb, &tuple, &tcph))
> +			return false;
> +		break;
> +	default:
> +		return false;
> +	}
> +
> +	tuplehash = flow_offload_lookup(nf_ft, &tuple);
> +	if (!tuplehash)
> +		return false;
> +
> +	dir = tuplehash->tuple.dir;
> +	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
> +	ct = flow->ct;
> +
> +	if (tcph && (unlikely(tcph->fin || tcph->rst))) {
> +		flow_offload_teardown(flow);
> +		return false;
> +	}
> +
> +	ctinfo = dir == FLOW_OFFLOAD_DIR_ORIGINAL ? IP_CT_ESTABLISHED :
> +						    IP_CT_ESTABLISHED_REPLY;
> +
> +	nf_conntrack_get(&ct->ct_general);
> +	nf_ct_set(skb, ct, ctinfo);
> +
> +	return true;
> +}
> +
>  static int tcf_ct_flow_tables_init(void)
>  {
>  	return rhashtable_init(&zones_ht, &zones_params);
> @@ -554,6 +695,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>  	struct nf_hook_state state;
>  	int nh_ofs, err, retval;
>  	struct tcf_ct_params *p;
> +	bool skip_add = false;
>  	struct nf_conn *ct;
>  	u8 family;
>  
> @@ -603,6 +745,11 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>  	 */
>  	cached = tcf_ct_skb_nfct_cached(net, skb, p->zone, force);
>  	if (!cached) {
> +		if (!commit && tcf_ct_flow_table_lookup(p, skb, family)) {
> +			skip_add = true;
> +			goto do_nat;
> +		}
> +
>  		/* Associate skb with specified zone. */
>  		if (tmpl) {
>  			ct = nf_ct_get(skb, &ctinfo);
> @@ -620,6 +767,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>  			goto out_push;
>  	}
>  
> +do_nat:
>  	ct = nf_ct_get(skb, &ctinfo);
>  	if (!ct)
>  		goto out_push;
> @@ -637,10 +785,10 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>  		 * even if the connection is already confirmed.
>  		 */
>  		nf_conntrack_confirm(skb);
> +	} else if (!skip_add) {
> +		tcf_ct_flow_table_process_conn(p->ct_ft, ct, ctinfo);
>  	}
>  
> -	tcf_ct_flow_table_process_conn(p->ct_ft, ct, ctinfo);
> -
>  out_push:
>  	skb_push_rcsum(skb, nh_ofs);
>  
> -- 
> 1.8.3.1
> 
