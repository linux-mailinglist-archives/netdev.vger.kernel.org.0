Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8949A173A5D
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 15:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbgB1Owv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 09:52:51 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:45138 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgB1Owv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 09:52:51 -0500
Received: by mail-qk1-f195.google.com with SMTP id z12so3119270qkg.12
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 06:52:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3oCxYOBVlNEeTrXKz4IvQIi6tC335bh3WV4Zx+iMPvY=;
        b=mrNVDVhKxLjtykJtDYrXpjeoMZbtgoFXixYV+MLXcj9jfVWANuaTfD+PrNx8xF//OR
         hcg4Oxv2/2k3T52QwfnqzjgLR84ruvHOG+W+LdFLmP9vPg1GSdWHhAqBvtcqa0c7Ex5V
         7UMbMHIiTQ0A2GjWpVs+l0px35v0zJDuN05P8cJ6UHmBfesAg6Atwoh9sdBFyLuo1LwJ
         wlw0G6uYuD5SdwJD5gVPMqG1s5pOvPtIxqLG3uoryeDcBdU3d3aqV3uPJK/EmOht2GZ7
         Ywq2ihqudtfk9f7Lo9iYkAuEjkYgP/VjgFSOyK2LfQ4GHtom/CjylvN8K/MiimbG7SDa
         kBRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3oCxYOBVlNEeTrXKz4IvQIi6tC335bh3WV4Zx+iMPvY=;
        b=NUkeA6AbjkEP+ferVh0/JC2KceRwbv6QsKj85zKBc1OVoPY9FjKH6LHQCnYGL70Mjl
         codkxxrGZXF/Z3Vpw0vasTv5Nn8hCztiobuTfJN8nf+DQlxDbEf6+YTM7X9qFZhaSYM9
         gwa7e0WwGwSQ/COR4lHLg5KgRjpilY2y1QdFMXIcSJS1px4vQQ5iw7yI8r2nk5MhMv7C
         02d0isYmCMNF29Ec9+0Vgvwg/tyUYV0Yq7Ml2pVqxl95FoHwY9Fj8FnZhUctF+aimIYf
         dSHqGu23yuLjye1UC4BmLW7gZITVaZFBWR4fWp76qLMkF18MdMlZSYh4w1HEhRoUBg0u
         23Uw==
X-Gm-Message-State: APjAAAUZpEdkAdvSTUybVeRCw/eVtRCrO1vt4wfn9UT8T7yPJWzCQvGQ
        UA/dHmxA2KtuOk5mZMJ0vwM=
X-Google-Smtp-Source: APXvYqyCQRYbHjGDvyjJ4v2Z8F+UvlTKpQ4/DCN6uo2JvLeBIj1d8t/Bk4u0GLuiZRlBSdU/iqXUmA==
X-Received: by 2002:a37:e111:: with SMTP id c17mr4723579qkm.182.1582901568974;
        Fri, 28 Feb 2020 06:52:48 -0800 (PST)
Received: from localhost.localdomain ([168.181.48.223])
        by smtp.gmail.com with ESMTPSA id w83sm4607194qkb.83.2020.02.28.06.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 06:52:48 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id C7D7FC4B66; Fri, 28 Feb 2020 11:52:45 -0300 (-03)
Date:   Fri, 28 Feb 2020 11:52:45 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: Re: [PATCH net-next 6/6] net/sched: act_ct: Software offload of
 established flows
Message-ID: <20200228145245.GB2546@localhost.localdomain>
References: <1582458307-17067-1-git-send-email-paulb@mellanox.com>
 <1582458307-17067-7-git-send-email-paulb@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1582458307-17067-7-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 23, 2020 at 01:45:07PM +0200, Paul Blakey wrote:
> Offload nf conntrack processing by looking up the 5-tuple in the
> zone's flow table.
> 
> The nf conntrack module will process the packets until a connection is
> in established state. Once in established state, the ct state pointer
> (nf_conn) will be restored on the skb from a successful ft lookup.
> 
> Signed-off-by: Paul Blakey <paulb@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  net/sched/act_ct.c | 163 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 160 insertions(+), 3 deletions(-)
> 
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index b2bc885..3592e24 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -211,6 +211,157 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
>  	tcf_ct_flow_table_add(ct_ft, ct, tcp);
>  }
>  
> +static bool
> +tcf_ct_flow_table_fill_tuple_ipv4(struct sk_buff *skb,
> +				  struct flow_offload_tuple *tuple)
> +{
> +	struct flow_ports *ports;
> +	unsigned int thoff;
> +	struct iphdr *iph;
> +
> +	if (!pskb_may_pull(skb, sizeof(*iph)))
> +		return false;
> +
> +	iph = ip_hdr(skb);
> +	thoff = iph->ihl * 4;

[A]

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
> +	thoff = iph->ihl * 4;

This is not needed, as already done in [A].

> +	if (!pskb_may_pull(skb, thoff + sizeof(*ports)))
> +		return false;
> +
> +	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
> +
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
> +				  struct flow_offload_tuple *tuple)
> +{
> +	struct flow_ports *ports;
> +	struct ipv6hdr *ip6h;
> +	unsigned int thoff;
> +
> +	if (!pskb_may_pull(skb, sizeof(*ip6h)))
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
> +	if (!pskb_may_pull(skb, thoff + sizeof(*ports)))
> +		return false;
> +
> +	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
> +
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
> +static bool tcf_ct_flow_table_check_tcp(struct flow_offload *flow, int proto,
> +					struct sk_buff *skb,
> +					unsigned int thoff)
> +{
> +	struct tcphdr *tcph;
> +
> +	if (proto != IPPROTO_TCP)
> +		return true;

I suppose this is a way to do additional checks for TCP while allowing
everything, but it does give the feeling that the 'return true' is
wrong and should have been 'return false' instead. The function name
works both ways too, at least to me. :-)

Can we have a comment to make it explicit, or a different construct?
Like, instead of 'return true' here, a 'goto out_ok' and reuse the
last return.


These are all my comments on this series. LGTM otherwise. Thanks!

> +
> +	if (!pskb_may_pull(skb, thoff + sizeof(*tcph)))
> +		return false;
> +
> +	tcph = (void *)(skb_network_header(skb) + thoff);
> +	if (unlikely(tcph->fin || tcph->rst)) {
> +		flow_offload_teardown(flow);
> +		return false;
> +	}
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
> +	struct flow_offload *flow;
> +	struct nf_conn *ct;
> +	unsigned int thoff;
> +	u8 dir;
> +
> +	/* Previously seen or loopback */
> +	ct = nf_ct_get(skb, &ctinfo);
> +	if ((ct && !nf_ct_is_template(ct)) || ctinfo == IP_CT_UNTRACKED)
> +		return false;
> +
> +	switch (family) {
> +	case NFPROTO_IPV4:
> +		if (!tcf_ct_flow_table_fill_tuple_ipv4(skb, &tuple))
> +			return false;
> +		break;
> +	case NFPROTO_IPV6:
> +		if (!tcf_ct_flow_table_fill_tuple_ipv6(skb, &tuple))
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
> +	ctinfo = dir == FLOW_OFFLOAD_DIR_ORIGINAL ? IP_CT_ESTABLISHED :
> +						    IP_CT_ESTABLISHED_REPLY;
> +
> +	thoff = ip_hdr(skb)->ihl * 4;
> +	if (!tcf_ct_flow_table_check_tcp(flow, ip_hdr(skb)->protocol, skb,
> +					 thoff))
> +		return false;
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
> @@ -579,6 +730,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>  	struct nf_hook_state state;
>  	int nh_ofs, err, retval;
>  	struct tcf_ct_params *p;
> +	bool skip_add = false;
>  	struct nf_conn *ct;
>  	u8 family;
>  
> @@ -628,6 +780,11 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
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
> @@ -645,6 +802,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>  			goto out_push;
>  	}
>  
> +do_nat:
>  	ct = nf_ct_get(skb, &ctinfo);
>  	if (!ct)
>  		goto out_push;
> @@ -662,9 +820,8 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>  		 * even if the connection is already confirmed.
>  		 */
>  		nf_conntrack_confirm(skb);
> -	}
> -
> -	tcf_ct_flow_table_process_conn(p->ct_ft, ct, ctinfo);
> +	} else if (!skip_add)
> +		tcf_ct_flow_table_process_conn(p->ct_ft, ct, ctinfo);
>  
>  out_push:
>  	skb_push_rcsum(skb, nh_ofs);
> -- 
> 1.8.3.1
> 
