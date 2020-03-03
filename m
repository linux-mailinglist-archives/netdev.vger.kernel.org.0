Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98DBF177896
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 15:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727576AbgCCOP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 09:15:59 -0500
Received: from mail-eopbgr10070.outbound.protection.outlook.com ([40.107.1.70]:59848
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726536AbgCCOP7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 09:15:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NG//Qm92trcvpeSU8ZCdr0/TJ1/qC0Uzt65yqricFWpA/K2T79QQEo+PM1sLKYfGZBeYzpBxkeHJvCX0HrqfjvS4tGawjTueQDA1XgFFYMAs45SM16yntVqxXxhfs9KvtjSL9fUknSNriDLomZ546TwicLQdpz7hgFncZfhyXX27wkX3KGegTumGpYB9MjHvL2GU0bhNvEqcwmEZeRYLSSRQ3Hk3fz+uv3yFjZiW2zdHZ295jjFF7hG6mtpFg5oUg9Iak6r8datLM4NuoUc9iOwFf0zGw/d83xTrLJU51lNI/8M2HTBztx8h7vG4u9iDb7H0RKeXldmMT+RgZbCrOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2L1G4yLBNJGIJWaiFphHP8PMrRYORFl6b3KssuMsHvs=;
 b=hxPWBvJS1Bdl+/IKNFVIdaBYUKHkqc/gt1sXbAgfagiWjwsJjgGO7Vuqz3CA2SGn4z9/tuuDMIFUUIdc2aFK9GlYT7JND5J5HmbQI5JmwvJK1hvVcwP3lo6y9txbttmSjNurQEIC017v0iBM4qANOPyx2DYmP3Wbb3Mn4Gc1lwmSKhwkt+s18YteNfwq13d8blyQH49m5tODxDzmJy56mCNCJ+Biv+wOSmHQkWWZf4cx8KgmXXIr+k56Un/1b0CCYV97up/PsElqVLkycCxCY4KZE+af6mIV2VY4lLdQ6olvYw5XoblwhgAw5z+E3AquqOJ6ji0xTy+iH/U69cI+jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2L1G4yLBNJGIJWaiFphHP8PMrRYORFl6b3KssuMsHvs=;
 b=XkBlklmNXb7Oc+9tDkfZm6ym0nQh1tResqg8y0kpPwIbcJhPv3V8k65FEWq0GN/rt4aQaAj/C31AJDZrlpymALO3ko90UbiXjogeOTrBz51sur3zG3IsVC2WWAM9RPVNPRW1qJ4eHbNzFUHZKHRtE/r8JYSD08iSdLta3W5m234=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (20.177.36.78) by
 AM6PR05MB6022.eurprd05.prod.outlook.com (20.179.2.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.19; Tue, 3 Mar 2020 14:15:45 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4%7]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 14:15:44 +0000
Subject: Re: [PATCH net-next v3 3/3] net/sched: act_ct: Software offload of
 established flows
From:   Paul Blakey <paulb@mellanox.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1583239973-3728-1-git-send-email-paulb@mellanox.com>
 <1583239973-3728-4-git-send-email-paulb@mellanox.com>
 <3f174fcb-0636-22d2-8d1c-e0e4981aab95@cumulusnetworks.com>
 <5cfe38ec-fd47-1846-fe84-433df3554a1b@mellanox.com>
 <0ecf03a9-a8f2-afd5-d9a2-a222cc1070d3@cumulusnetworks.com>
 <c2680b0e-b4c9-9185-523e-9117e2ae79e8@mellanox.com>
Message-ID: <01e6249b-a2c7-7573-dfc7-3a0873464180@mellanox.com>
Date:   Tue, 3 Mar 2020 16:15:38 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <c2680b0e-b4c9-9185-523e-9117e2ae79e8@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: ZRAP278CA0017.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::27) To AM6PR05MB5096.eurprd05.prod.outlook.com
 (2603:10a6:20b:11::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.223.6.3] (193.47.165.251) by ZRAP278CA0017.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Tue, 3 Mar 2020 14:15:43 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7ad125cb-5293-479c-eff0-08d7bf7d5ce6
X-MS-TrafficTypeDiagnostic: AM6PR05MB6022:|AM6PR05MB6022:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB6022CDD6C583C195A11AE307CFE40@AM6PR05MB6022.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:137;
X-Forefront-PRVS: 03319F6FEF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(199004)(189003)(81166006)(8676002)(66556008)(16526019)(81156014)(36756003)(6636002)(66476007)(26005)(2906002)(31686004)(66946007)(6486002)(53546011)(478600001)(956004)(2616005)(86362001)(5660300002)(52116002)(31696002)(8936002)(186003)(316002)(6666004)(16576012)(110136005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6022;H:AM6PR05MB5096.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rLWW4onXT8ewfHKMSXlBXYHuFIjr2w7TCNGg4EGC7bYRnLYF9oJi+A1mIaTWpSrnXkvwLhxK0rYHu1zzYSAgTxUNO9m63HhF64uIS0hA4GdrBaWD7JK5RmBEU1VPWnNuiVbL/VTFIYrSz9yYXqf5KQF1QJQPsUmx2ts2zgaFyLWkWXm5VgfozEiJIJRqF4BcvGgE0d5y2YO7eTrTsdJngxxzoYuW1B7sQPquut5nZXJZ4GQy6siMQVkTgk10Jay54xedZsyxoozbC22JbAQb0Xbjlu7GT/qUJdraPTnKGPS6q6Z5hk0Oei+dQAIMkS+DTIRfiQQVUbofUaHQa+A2tXbCKHKwYTTxNaIuOxIq77zSvBhWCE6kYkBm3mIUZ/gy+tBe5frLyvlNOyl/gRhKfhWfN9LHdtBVzJjRWvCFS0kTxNQve/5c3qcHoOCyThH4
X-MS-Exchange-AntiSpam-MessageData: C0CFYU1z4GSFCFB/xNgq+Jt4BBJFGNxDlN5RYaP+Mydy3S/TrhbaFa9vmHHUpZKdTxs6zeYrdqmbf26ADXrKn++U6+T/B3Cd2xxdctzvHBJUewVkXlYL1kzOXzrhhZiWXG2fIfUB3u9pTjWtwAUYUQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ad125cb-5293-479c-eff0-08d7bf7d5ce6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2020 14:15:44.8499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3TMpZFnrYIxzcKOWQO0Nog4fGvglP/XYEk8d0J2JWgRlhk4YMxHz6kg6/Sf6IgvvRZWKqG2kHVH6TFESskBz7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6022
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/3/2020 4:03 PM, Paul Blakey wrote:
> On 3/3/2020 3:35 PM, Nikolay Aleksandrov wrote:
>> On 03/03/2020 15:31, Paul Blakey wrote:
>>> On 3/3/2020 3:10 PM, Nikolay Aleksandrov wrote:
>>>> On 03/03/2020 14:52, Paul Blakey wrote:
>>>>> Offload nf conntrack processing by looking up the 5-tuple in the
>>>>> zone's flow table.
>>>>>
>>>>> The nf conntrack module will process the packets until a connection is
>>>>> in established state. Once in established state, the ct state pointer
>>>>> (nf_conn) will be restored on the skb from a successful ft lookup.
>>>>>
>>>>> Signed-off-by: Paul Blakey <paulb@mellanox.com>
>>>>> Acked-by: Jiri Pirko <jiri@mellanox.com>
>>>>> ---
>>>>> Changelog:
>>>>>   v1->v2:
>>>>>    Add !skip_add curly braces
>>>>>    Removed extra setting thoff again
>>>>>    Check tcp proto outside of tcf_ct_flow_table_check_tcp
>>>>>
>>>>>  net/sched/act_ct.c | 160 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>>>>>  1 file changed, 158 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
>>>>> index 6ad0553..2017f8f 100644
>>>>> --- a/net/sched/act_ct.c
>>>>> +++ b/net/sched/act_ct.c
>>>>> @@ -186,6 +186,155 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
>>>>>  	tcf_ct_flow_table_add(ct_ft, ct, tcp);
>>>>>  }
>>>>>  
>>>>> +static bool
>>>>> +tcf_ct_flow_table_fill_tuple_ipv4(struct sk_buff *skb,
>>>>> +				  struct flow_offload_tuple *tuple)
>>>>> +{
>>>>> +	struct flow_ports *ports;
>>>>> +	unsigned int thoff;
>>>>> +	struct iphdr *iph;
>>>>> +
>>>>> +	if (!pskb_may_pull(skb, sizeof(*iph)))
>>>>> +		return false;
>>>>> +
>>>>> +	iph = ip_hdr(skb);
>>>>> +	thoff = iph->ihl * 4;
>>>>> +
>>>>> +	if (ip_is_fragment(iph) ||
>>>>> +	    unlikely(thoff != sizeof(struct iphdr)))
>>>>> +		return false;
>>>>> +
>>>>> +	if (iph->protocol != IPPROTO_TCP &&
>>>>> +	    iph->protocol != IPPROTO_UDP)
>>>>> +		return false;
>>>>> +
>>>>> +	if (iph->ttl <= 1)
>>>>> +		return false;
>>>>> +
>>>>> +	if (!pskb_may_pull(skb, thoff + sizeof(*ports)))
>>>>> +		return false;
>>>>> +
>>>> I think you should reload iph after the pskb_may_pull() call.
>>> Good catch, you're right it might change skb->head.
>>>
>>> Thanks, will send v5.
>>>
>>> Paul.
>>>
>> Actually shouldn't the code be using pskb_network_may_pull(), i.e. pskb_may_pull()
>> with skb_network_offset(skb) + sizeof(network header) ... ?
> you mean pskb_network_may_pull(skb,  thoff + sizeof(ports)) ?
>
> Should act the same as skb is trimmed to network layer by caller (tcf_ct_skb_network_trim())
>
> I can still do this to be more bullet proof, what do you think?

Since  I'm getting the ports in ref to network header, ill do the pull in ref to that as well.


>
>
>>>>> +	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
>>>>> +
>>>>> +	tuple->src_v4.s_addr = iph->saddr;
>>>>> +	tuple->dst_v4.s_addr = iph->daddr;
>>>>> +	tuple->src_port = ports->source;
>>>>> +	tuple->dst_port = ports->dest;
>>>>> +	tuple->l3proto = AF_INET;
>>>>> +	tuple->l4proto = iph->protocol;
>>>>> +
>>>>> +	return true;
>>>>> +}
>>>>> +
>>>>> +static bool
>>>>> +tcf_ct_flow_table_fill_tuple_ipv6(struct sk_buff *skb,
>>>>> +				  struct flow_offload_tuple *tuple)
>>>>> +{
>>>>> +	struct flow_ports *ports;
>>>>> +	struct ipv6hdr *ip6h;
>>>>> +	unsigned int thoff;
>>>>> +
>>>>> +	if (!pskb_may_pull(skb, sizeof(*ip6h)))
>>>>> +		return false;
>>>>> +
>>>>> +	ip6h = ipv6_hdr(skb);
>>>>> +
>>>>> +	if (ip6h->nexthdr != IPPROTO_TCP &&
>>>>> +	    ip6h->nexthdr != IPPROTO_UDP)
>>>>> +		return false;
>>>>> +
>>>>> +	if (ip6h->hop_limit <= 1)
>>>>> +		return false;
>>>>> +
>>>>> +	thoff = sizeof(*ip6h);
>>>>> +	if (!pskb_may_pull(skb, thoff + sizeof(*ports)))
>>>>> +		return false;
>>>> same here
>>>>
>>>>> +
>>>>> +	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
>>>>> +
>>>>> +	tuple->src_v6 = ip6h->saddr;
>>>>> +	tuple->dst_v6 = ip6h->daddr;
>>>>> +	tuple->src_port = ports->source;
>>>>> +	tuple->dst_port = ports->dest;
>>>>> +	tuple->l3proto = AF_INET6;
>>>>> +	tuple->l4proto = ip6h->nexthdr;
>>>>> +
>>>>> +	return true;
>>>>> +}
>>>>> +
>>>>> +static bool tcf_ct_flow_table_check_tcp(struct flow_offload *flow,
>>>>> +					struct sk_buff *skb,
>>>>> +					unsigned int thoff)
>>>>> +{
>>>>> +	struct tcphdr *tcph;
>>>>> +
>>>>> +	if (!pskb_may_pull(skb, thoff + sizeof(*tcph)))
>>>>> +		return false;
>>>>> +
>>>>> +	tcph = (void *)(skb_network_header(skb) + thoff);
>>>>> +	if (unlikely(tcph->fin || tcph->rst)) {
>>>>> +		flow_offload_teardown(flow);
>>>>> +		return false;
>>>>> +	}
>>>>> +
>>>>> +	return true;
>>>>> +}
>>>>> +
>>>>> +static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
>>>>> +				     struct sk_buff *skb,
>>>>> +				     u8 family)
>>>>> +{
>>>>> +	struct nf_flowtable *nf_ft = &p->ct_ft->nf_ft;
>>>>> +	struct flow_offload_tuple_rhash *tuplehash;
>>>>> +	struct flow_offload_tuple tuple = {};
>>>>> +	enum ip_conntrack_info ctinfo;
>>>>> +	struct flow_offload *flow;
>>>>> +	struct nf_conn *ct;
>>>>> +	unsigned int thoff;
>>>>> +	int ip_proto;
>>>>> +	u8 dir;
>>>>> +
>>>>> +	/* Previously seen or loopback */
>>>>> +	ct = nf_ct_get(skb, &ctinfo);
>>>>> +	if ((ct && !nf_ct_is_template(ct)) || ctinfo == IP_CT_UNTRACKED)
>>>>> +		return false;
>>>>> +
>>>>> +	switch (family) {
>>>>> +	case NFPROTO_IPV4:
>>>>> +		if (!tcf_ct_flow_table_fill_tuple_ipv4(skb, &tuple))
>>>>> +			return false;
>>>>> +		break;
>>>>> +	case NFPROTO_IPV6:
>>>>> +		if (!tcf_ct_flow_table_fill_tuple_ipv6(skb, &tuple))
>>>>> +			return false;
>>>>> +		break;
>>>>> +	default:
>>>>> +		return false;
>>>>> +	}
>>>>> +
>>>>> +	tuplehash = flow_offload_lookup(nf_ft, &tuple);
>>>>> +	if (!tuplehash)
>>>>> +		return false;
>>>>> +
>>>>> +	dir = tuplehash->tuple.dir;
>>>>> +	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
>>>>> +	ct = flow->ct;
>>>>> +
>>>>> +	ctinfo = dir == FLOW_OFFLOAD_DIR_ORIGINAL ? IP_CT_ESTABLISHED :
>>>>> +						    IP_CT_ESTABLISHED_REPLY;
>>>>> +
>>>>> +	thoff = ip_hdr(skb)->ihl * 4;
>>>>> +	ip_proto = ip_hdr(skb)->protocol;
>>>>> +	if (ip_proto == IPPROTO_TCP &&
>>>>> +	    !tcf_ct_flow_table_check_tcp(flow, skb, thoff))
>>>>> +		return false;
>>>>> +
>>>>> +	nf_conntrack_get(&ct->ct_general);
>>>>> +	nf_ct_set(skb, ct, ctinfo);
>>>>> +
>>>>> +	return true;
>>>>> +}
>>>>> +
>>>>>  static int tcf_ct_flow_tables_init(void)
>>>>>  {
>>>>>  	return rhashtable_init(&zones_ht, &zones_params);
>>>>> @@ -554,6 +703,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>>>>>  	struct nf_hook_state state;
>>>>>  	int nh_ofs, err, retval;
>>>>>  	struct tcf_ct_params *p;
>>>>> +	bool skip_add = false;
>>>>>  	struct nf_conn *ct;
>>>>>  	u8 family;
>>>>>  
>>>>> @@ -603,6 +753,11 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>>>>>  	 */
>>>>>  	cached = tcf_ct_skb_nfct_cached(net, skb, p->zone, force);
>>>>>  	if (!cached) {
>>>>> +		if (!commit && tcf_ct_flow_table_lookup(p, skb, family)) {
>>>>> +			skip_add = true;
>>>>> +			goto do_nat;
>>>>> +		}
>>>>> +
>>>>>  		/* Associate skb with specified zone. */
>>>>>  		if (tmpl) {
>>>>>  			ct = nf_ct_get(skb, &ctinfo);
>>>>> @@ -620,6 +775,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>>>>>  			goto out_push;
>>>>>  	}
>>>>>  
>>>>> +do_nat:
>>>>>  	ct = nf_ct_get(skb, &ctinfo);
>>>>>  	if (!ct)
>>>>>  		goto out_push;
>>>>> @@ -637,10 +793,10 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>>>>>  		 * even if the connection is already confirmed.
>>>>>  		 */
>>>>>  		nf_conntrack_confirm(skb);
>>>>> +	} else if (!skip_add) {
>>>>> +		tcf_ct_flow_table_process_conn(p->ct_ft, ct, ctinfo);
>>>>>  	}
>>>>>  
>>>>> -	tcf_ct_flow_table_process_conn(p->ct_ft, ct, ctinfo);
>>>>> -
>>>>>  out_push:
>>>>>  	skb_push_rcsum(skb, nh_ofs);
>>>>>  
>>>>>
