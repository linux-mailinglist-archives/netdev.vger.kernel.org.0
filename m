Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC646395071
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 12:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbhE3KiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 06:38:19 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:53239 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhE3KiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 06:38:18 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id 7B9DA200E7BB;
        Sun, 30 May 2021 12:36:38 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 7B9DA200E7BB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1622370998;
        bh=m/KHNSinlacbo5XUcexKVcPfs0rUI8s1lzwLsh4kFZA=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=kdu88FYGS6VpNur609cnnYSrHlLVEl+mNsR+95GbjbV/ovu2KNHfAUgKbisoapK5j
         D8rL4lBINXDjxeETUbsb6sWzTylTvkV6qU4LIw4uwOc+A8YfRrX/g8mwWjWUwUnP0a
         w7lvkz2Z3nc+eiabm+dXdIXIwVgRgnUTvOstWXptlAkH7vEZ9+KiSVH7aypO6TkJlJ
         BLXn8iafhxFa9IVuh1xYgldpwLtZHtUrEy94zHlb0yL7B7X6XoLSetxfaqV64RmgiB
         ddBFWYuXfHvXmFcRqivsSw8CtQsWZkez/BiAHjt45wcuJKWB7pgl80yaW0n1Kj7BmD
         1EgfYHyHmFkaA==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 70E976008D381;
        Sun, 30 May 2021 12:36:38 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id BzmgIA4eQISr; Sun, 30 May 2021 12:36:38 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 59DD26008D34F;
        Sun, 30 May 2021 12:36:38 +0200 (CEST)
Date:   Sun, 30 May 2021 12:36:38 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, tom@herbertland.com
Message-ID: <1678535209.34108899.1622370998279.JavaMail.zimbra@uliege.be>
In-Reply-To: <20210529140555.3536909f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20210527151652.16074-1-justin.iurman@uliege.be> <20210527151652.16074-3-justin.iurman@uliege.be> <20210529140555.3536909f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Subject: Re: [PATCH net-next v4 2/5] ipv6: ioam: Data plane support for
 Pre-allocated Trace
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF88 (Linux)/8.8.15_GA_4026)
Thread-Topic: ipv6: ioam: Data plane support for Pre-allocated Trace
Thread-Index: KMu3rfy/JgmAcDHjEzGJ/hX/Qek2Ug==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

>> A per-interface sysctl ioam6_enabled is provided to process/ignore IOAM
>> headers. Default is ignore (= disabled). Another per-interface sysctl
>> ioam6_id is provided to define the IOAM (unique) identifier of the
>> interface. Default is 0. A per-namespace sysctl ioam6_id is provided to
>> define the IOAM (unique) identifier of the node. Default is 0.
> 
> Last two sentences are repeated.

One describes net.ipv6.conf.XXX.ioam6_id (per interface) and the other describes net.ipv6.ioam6_id (per namespace). It allows for defining an IOAM id to an interface and, also, the node in general.

> Is 0 a valid interface ID? If not why not use id != 0 instead of
> having a separate enabled field?

Mainly for semantic reasons. Indeed, I'd prefer to keep a specific "enable" flag per interface as it sounds more intuitive. But, also because 0 could very well be a "valid" interface id (more like a default value).

>> Documentation is provided at the end of this patchset.
>> 
>> Two relativistic hash tables: one for IOAM namespaces, the other for
>> IOAM schemas. A namespace can only have a single active schema and a
>> schema can only be attached to a single namespace (1:1 relationship).
>> 
>>   [1] https://tools.ietf.org/html/draft-ietf-ippm-ioam-ipv6-options
>>   [2] https://tools.ietf.org/html/draft-ietf-ippm-ioam-data
>>   [3]
>>   https://www.iana.org/assignments/ipv6-parameters/ipv6-parameters.xhtml#ipv6-parameters-2
>> 
>> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
> 
>> +extern struct ioam6_namespace *ioam6_namespace(struct net *net, __be16 id);
>> +extern void ioam6_fill_trace_data(struct sk_buff *skb,
>> +				  struct ioam6_namespace *ns,
>> +				  struct ioam6_trace_hdr *trace);
>> +
>> +extern int ioam6_init(void);
>> +extern void ioam6_exit(void);
> 
> no need for externs in new headers

ACK.

>> +#endif /* _NET_IOAM6_H */
>> diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
>> index bde0b7adb4a3..a0d61a8fcfe1 100644
>> --- a/include/net/netns/ipv6.h
>> +++ b/include/net/netns/ipv6.h
>> @@ -53,6 +53,7 @@ struct netns_sysctl_ipv6 {
>>  	int seg6_flowlabel;
>>  	bool skip_notify_on_dev_down;
>>  	u8 fib_notify_on_flag_change;
>> +	unsigned int ioam6_id;
> 
> Perhaps move it after seg6_flowlabel, better chance next person adding
> a 1 byte type will not create a hole.

+1.

> 
>>  };
>>  
>>  struct netns_ipv6 {
> 
>> @@ -6932,6 +6938,20 @@ static const struct ctl_table addrconf_sysctl[] = {
>>  		.mode		= 0644,
>>  		.proc_handler	= proc_dointvec,
>>  	},
>> +	{
>> +		.procname	= "ioam6_enabled",
>> +		.data		= &ipv6_devconf.ioam6_enabled,
>> +		.maxlen		= sizeof(int),
>> +		.mode		= 0644,
>> +		.proc_handler	= proc_dointvec,
> 
> This one should be constrained to 0/1, right?
> proc_dou8vec_minmax? no need for full u32.
> 

Indeed, +1.

>> +	},
>> +	{
>> +		.procname	= "ioam6_id",
>> +		.data		= &ipv6_devconf.ioam6_id,
>> +		.maxlen		= sizeof(int),
>> +		.mode		= 0644,
>> +		.proc_handler	= proc_dointvec,
> 
> uint?

+1.

> 
>> +	},
>>  	{
>>  		/* sentinel */
>>  	}
>> diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
>> index 2389ff702f51..aec9664ec909 100644
>> --- a/net/ipv6/af_inet6.c
>> +++ b/net/ipv6/af_inet6.c
>> @@ -62,6 +62,7 @@
>>  #include <net/rpl.h>
>>  #include <net/compat.h>
>>  #include <net/xfrm.h>
>> +#include <net/ioam6.h>
>>  
>>  #include <linux/uaccess.h>
>>  #include <linux/mroute6.h>
>> @@ -1191,6 +1192,10 @@ static int __init inet6_init(void)
>>  	if (err)
>>  		goto rpl_fail;
>>  
>> +	err = ioam6_init();
>> +	if (err)
>> +		goto ioam6_fail;
>> +
>>  	err = igmp6_late_init();
>>  	if (err)
>>  		goto igmp6_late_err;
>> @@ -1214,6 +1219,8 @@ static int __init inet6_init(void)
>>  #endif
>>  igmp6_late_err:
>>  	rpl_exit();
>> +ioam6_fail:
>> +	ioam6_exit();
>>  rpl_fail:
> 
> This is out of order, ioam6_fail should now jump to rpl_exit()
> and igmp6_late_err should point at ioam6_exit().
>

Good catch, I mixed it up *facepalm*.

>>  	seg6_exit();
>>  seg6_fail:
> 
>> @@ -929,6 +932,50 @@ static bool ipv6_hop_ra(struct sk_buff *skb, int optoff)
>>  	return false;
>>  }
>>  
>> +/* IOAM */
>> +
>> +static bool ipv6_hop_ioam(struct sk_buff *skb, int optoff)
>> +{
>> +	struct ioam6_trace_hdr *trace;
>> +	struct ioam6_namespace *ns;
>> +	struct ioam6_hdr *hdr;
>> +
>> +	/* Must be 4n-aligned */
>> +	if (optoff & 3)
>> +		goto drop;
>> +
>> +	/* Ignore if IOAM is not enabled on ingress */
>> +	if (!__in6_dev_get(skb->dev)->cnf.ioam6_enabled)
>> +		goto ignore;
>> +
>> +	hdr = (struct ioam6_hdr *)(skb_network_header(skb) + optoff);
>> +
>> +	switch (hdr->type) {
>> +	case IOAM6_TYPE_PREALLOC:
>> +		trace = (struct ioam6_trace_hdr *)((u8 *)hdr + sizeof(*hdr));
>> +		ns = ioam6_namespace(ipv6_skb_net(skb), trace->namespace_id);
> 
> Shouldn't there be validation that the header is not truncated or
> malformed before we start poking into the fields?

ioam6_fill_trace_data is responsible (right after that) for checking the header and making sure the whole thing makes sense before inserting data. But, first, we need to parse the IOAM-Namespace ID to check if it is a known (defined) one or not, and therefore either going deeper or ignoring the option. Anyway, maybe I could add a check on hdr->opt_len and make sure it has at least the length of the required header (what comes after is data).

> 
>> +		/* Ignore if the IOAM namespace is unknown */
>> +		if (!ns)
>> +			goto ignore;
>> +
>> +		if (!skb_valid_dst(skb))
>> +			ip6_route_input(skb);
>> +
>> +		ioam6_fill_trace_data(skb, ns, trace);
>> +		break;
>> +	default:
>> +		break;
>> +	}
>> +
>> +ignore:
>> +	return true;
>> +
>> +drop:
>> +	kfree_skb(skb);
>> +	return false;
>> +}
>> +
> 
>> +void ioam6_fill_trace_data(struct sk_buff *skb,
>> +			   struct ioam6_namespace *ns,
>> +			   struct ioam6_trace_hdr *trace)
>> +{
>> +	u8 sclen = 0;
>> +
>> +	/* Skip if Overflow flag is set OR
>> +	 * if an unknown type (bit 12-21) is set
>> +	 */
>> +	if (trace->overflow ||
>> +	    (trace->type.bit12 | trace->type.bit13 | trace->type.bit14 |
>> +	     trace->type.bit15 | trace->type.bit16 | trace->type.bit17 |
>> +	     trace->type.bit18 | trace->type.bit19 | trace->type.bit20 |
>> +	     trace->type.bit21)) {
>> +		return;
>> +	}
> 
> braces unnecessary

ACK.

> 
>> +
>> +	/* NodeLen does not include Opaque State Snapshot length. We need to
>> +	 * take it into account if the corresponding bit is set (bit 22) and
>> +	 * if the current IOAM namespace has an active schema attached to it
>> +	 */
>> +	if (trace->type.bit22) {
>> +		sclen = sizeof_field(struct ioam6_schema, hdr) / 4;
>> +
>> +		if (ns->schema)
>> +			sclen += ns->schema->len / 4;
>> +	}
>> +
>> +	/* If there is no space remaining, we set the Overflow flag and we
>> +	 * skip without filling the trace
>> +	 */
>> +	if (!trace->remlen || trace->remlen < (trace->nodelen + sclen)) {
> 
> brackets around sum unnecessary

ACK.

> 
>> +		trace->overflow = 1;
>> +		return;
>> +	}
>> +
>> +	__ioam6_fill_trace_data(skb, ns, trace, sclen);
>> +	trace->remlen -= trace->nodelen + sclen;
>> +}
> 
>> diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
>> index d7cf26f730d7..b97aad7b6aca 100644
>> --- a/net/ipv6/sysctl_net_ipv6.c
>> +++ b/net/ipv6/sysctl_net_ipv6.c
>> @@ -196,6 +196,13 @@ static struct ctl_table ipv6_table_template[] = {
>>  		.extra1         = SYSCTL_ZERO,
>>  		.extra2         = &two,
>>  	},
>> +	{
>> +		.procname	= "ioam6_id",
>> +		.data		= &init_net.ipv6.sysctl.ioam6_id,
>> +		.maxlen		= sizeof(int),
>> +		.mode		= 0644,
>> +		.proc_handler	= proc_dointvec
> 
> uint?

+1.
