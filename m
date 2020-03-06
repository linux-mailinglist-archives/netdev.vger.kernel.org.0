Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 616E617BE2B
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 14:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgCFNWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 08:22:31 -0500
Received: from mail-eopbgr40072.outbound.protection.outlook.com ([40.107.4.72]:17930
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726650AbgCFNWb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 08:22:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dQAws/TW1fI9Nv8SwWV/qEG7OcDPbIbLvgwz/sxEZkJzfysA+GMTPBiktN3Pt0/sQxK5ETCv7ChblgjTaXA7xS59E9zQ/8jVeObLDsUzL3IiV67QgsH46tK6hsyxtLp9vcXk62XfaJOtqUxUNMcEQgSAMKa5z7AI4bGehqkN8CzDAX8dZoRCH/g5wxgxI4veuz2Km+5LT/VMmamtwbKeVcci8KV89GWThonevTvhBAmy77Pw4PPS+w7886Sqj4k/D3jYkPF0RkDoRcuwOZNd+R2s41yZd3sW5z5rYoTPUBT1/AGoEIDOVahFCkqSk8LlCY/X/8iWmqHsBFUKDBK2uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=brptLEkYqOpqt4n5tPyLBe9bFQ4VAiS7lH3bP0ZyC50=;
 b=J0tySSoVDDB73mmRSyMw0wRArjO3Jnj15PVgAiTvEi7DbK6N1kpdQOCfQDcorMfQQ5TPOuZ2DQo+PKsKzHsqv6suQpYzU7SfriV6b0ZzurwJKYV+44zsBnNKXxd2fUTnp1Mo3ByTbUkLEktOwrfS62Kgs3NjXbEQCSloLj574HERLuex04D+OC927/tbnYfpMUr+SpGT91TmaV/DnyySwOw5var4eR0TO/TvEiM8z+Zl4CPptdnc+ZTV/Xfyd0PKzg6ImTxDuA+LhzCVGkTRERfLJkdmdT9N8zJqi06Ym7lg89ZrRo04OQ7WSEMydmVhmnjoVkPzeyvbngWS9YVTlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=brptLEkYqOpqt4n5tPyLBe9bFQ4VAiS7lH3bP0ZyC50=;
 b=tw+KN4uzEDWyjNeBRmC75+ZG3g/yqezJqXMTUe9ZITu3tXRS9l4ESLo8/0bCFC+cM+JZvDIopBYjzX1NQS9fJqXi8+9HD4/yhNqWIuwumDilHjeSGpEN5dHRNV6Uj8mv1lO8q5NViKKzJRKZ55FJ+TNB2xqg6hb3ZQg58yqsxEo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (20.177.36.78) by
 AM6PR05MB4502.eurprd05.prod.outlook.com (52.135.163.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.16; Fri, 6 Mar 2020 13:22:25 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4%7]) with mapi id 15.20.2772.019; Fri, 6 Mar 2020
 13:22:25 +0000
Subject: Re: [PATCH net-next ct-offload 02/13] net/sched: act_ct: Instantiate
 flow table entry actions
To:     Edward Cree <ecree@solarflare.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1583422468-8456-1-git-send-email-paulb@mellanox.com>
 <1583422468-8456-3-git-send-email-paulb@mellanox.com>
 <ce72a853-a416-4162-5ffb-c719c98fb7cc@solarflare.com>
From:   Paul Blakey <paulb@mellanox.com>
Message-ID: <8f58e2b3-c1f6-4c75-6662-8f356f3b4838@mellanox.com>
Date:   Fri, 6 Mar 2020 15:22:01 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <ce72a853-a416-4162-5ffb-c719c98fb7cc@solarflare.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-ClientProxiedBy: PR0P264CA0104.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:19::20) To AM6PR05MB5096.eurprd05.prod.outlook.com
 (2603:10a6:20b:11::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.50.105] (5.29.240.93) by PR0P264CA0104.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Fri, 6 Mar 2020 13:22:24 +0000
X-Originating-IP: [5.29.240.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 22f4ea6f-97fb-452e-7dba-08d7c1d1693f
X-MS-TrafficTypeDiagnostic: AM6PR05MB4502:|AM6PR05MB4502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB4502294FE22E5A527F80086ECFE30@AM6PR05MB4502.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0334223192
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(346002)(396003)(136003)(39860400002)(189003)(199004)(81166006)(81156014)(8936002)(36756003)(16526019)(30864003)(31696002)(956004)(53546011)(6486002)(6636002)(52116002)(31686004)(2616005)(86362001)(5660300002)(478600001)(66556008)(6666004)(8676002)(16576012)(110136005)(26005)(66946007)(316002)(186003)(2906002)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4502;H:AM6PR05MB5096.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lw7n0WvTQStHZT/Sfych205VI7NJ0jGuZrQlODttg8n6nuwXNc8+6FteU8l0kjaHeZNj03/UKs9PXsy4ngXyN2+W9Pvhx0ONljIatKC1A/97VZZOjS9UVl2kHKTgt/9mOkQaLZRkwOLsc0rQnPA1TfW9ZAjNO72YWzazhiTE7DQ07ZpYdxfA6/Aj/64MFl8E5gNTiArWxmT2E4KjWJXlXSk00NtCN34ZEGMvDGT58VzqP+3Gk6alkEzTIkVaBXuyGe/zmGSVU64/5DWvgdGs3H5kXNIpSdZHXUnOQ1DRvaqmI96EiednLGklbkf6lXnxP+iiF/e05gfQzZd9RZdOmQaVMZUoKT3qSp2aw8g5qHnlEGqeycozdS6G8Kiids8Ea6sqRT9pwwLkhahGc4VEZddMT8P8X76OHg14kwJ7aJ1ZN6gfbBBeTV9LSkUJZAb8
X-MS-Exchange-AntiSpam-MessageData: DcxE6pX3DxULNOEsA51OKS9pfcKp0AQzuLBliUwPaX+R+H46D+pgHCuFIpydxCTPIkXUG1mLDvPQOgFVJL7svtac++apHBrWEjKSbJzR3yyrJKpkzAmdsOU1FV2gtScwvMkLTVfStjVMVKOoODPnSA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22f4ea6f-97fb-452e-7dba-08d7c1d1693f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2020 13:22:25.7207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RgcSCyuGsnVQP9HQEoXt5b61ty23RqrIq6jPFZgn0YLLO6/YrLhNqNPbfPU3kCmFVh3H5VlwthUvyjTzyNglag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4502
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 06/03/2020 13:35, Edward Cree wrote:
> On 05/03/2020 15:34, Paul Blakey wrote:
>> NF flow table API associate 5-tuple rule with an action list by calling
>> the flow table type action() CB to fill the rule's actions.
>>
>> In action CB of act_ct, populate the ct offload entry actions with a new
>> ct_metadata action. Initialize the ct_metadata with the ct mark, label and
>> zone information. If ct nat was performed, then also append the relevant
>> packet mangle actions (e.g. ipv4/ipv6/tcp/udp header rewrites).
> On one hand, the mangle actions are what's already there and they're general
>  enough to cover this.  But on the other hand, an explicit NAT flow_action
>  would mean drivers didn't have to grovel through the mangles to figure out
>  that NAT is what they're doing, in the case of HW that supports NAT but not
>  arbitrary pedit mangles.  On the gripping hand, if the 'NAT recogniser' can
>  be wrapped up in a library function that drivers can use, that would
>  probably be OK too.
>
>> Drivers that offload the ft entries may match on the 5-tuple and perform
>> the action list.
>>
>> Signed-off-by: Paul Blakey <paulb@mellanox.com>
>> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
>> ---<snip>> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
>> index 23eba61..0773456 100644
>> --- a/net/sched/act_ct.c
>> +++ b/net/sched/act_ct.c
>> @@ -55,7 +55,199 @@ struct tcf_ct_flow_table {
>>  	.automatic_shrinking = true,
>>  };
>>  
>> +static inline struct flow_action_entry *
>> +tcf_ct_flow_table_flow_action_get_next(struct flow_action *flow_action)
>> +{
>> +	int i = flow_action->num_entries++;
>> +
>> +	return &flow_action->entries[i];
>> +}
>> +
>> +static void
>> +tcf_ct_flow_table_add_action_nat_ipv4(const struct nf_conntrack_tuple *tuple,
>> +				      struct nf_conntrack_tuple target,
>> +				      struct flow_action *action)
> This function could do with a comment explaining what it's doing.  On
>  first reading I wondered whether those memcmp() were meant to be
>  !memcmp().  (Though that could also just mean I need more caffeine.)
Sure I'll add one.
>> +{
>> +	struct flow_action_entry *entry;
>> +
>> +	if (memcmp(&target.src.u3, &tuple->src.u3, sizeof(target.src.u3))) {
>> +		entry = tcf_ct_flow_table_flow_action_get_next(action);
>> +		entry->id = FLOW_ACTION_MANGLE;
>> +		entry->mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_IP4;
>> +		entry->mangle.mask = ~(0xFFFFFFFF);
> These parens are unnecessary.
> In fact, mask is a u32, so '0' would be equivalent, though I can see a
>  documentational argument for keeping the ~0xffffffff spelling.
Yes its this way because mangles masks are weird for some reason. ill remove the ().
>
>> +		entry->mangle.offset = offsetof(struct iphdr, saddr);
>> +		entry->mangle.val = htonl(target.src.u3.ip);
> AFAICT u3.ip is defined as __be32, so this htonl() is incorrect (did
>  sparse not warn about it?).  It would rather be ntohl(), but in any
>  case normal kernel practice is be32_to_cpu().
Will do.
>
>> +	} else if (memcmp(&target.dst.u3, &tuple->dst.u3,
>> +			  sizeof(target.dst.u3))) {
> There have been mutterings from OVS about doing both SNAT and DNAT in a
>  single rule.  I'm not sure if anything got merged, but it might be
>  worth at least checking that the branches aren't both true, rather than
>  having an elseif that skips the dst check if the src changed.
right, it is possible as the recent changes to act ct allows the same,ill change this to an if.
>
>> +		entry = tcf_ct_flow_table_flow_action_get_next(action);
>> +		entry->id = FLOW_ACTION_MANGLE;
>> +		entry->mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_IP4;
>> +		entry->mangle.mask = ~(0xFFFFFFFF);
>> +		entry->mangle.offset = offsetof(struct iphdr, daddr);
>> +		entry->mangle.val = htonl(target.dst.u3.ip);
>> +	}
>> +}
>> +
>> +static void
>> +tcf_ct_flow_table_add_action_nat_ipv6(const struct nf_conntrack_tuple *tuple,
>> +				      struct nf_conntrack_tuple target,
>> +				      struct flow_action *action)
>> +{
>> +	struct flow_action_entry *entry;
>> +	union nf_inet_addr *addr;
>> +	u32 next_offset = 0;
>> +	int i;
>> +
>> +	if (memcmp(&target.src.u3, &tuple->src.u3, sizeof(target.src.u3))) {
>> +		addr = &target.src.u3;
>> +		next_offset = offsetof(struct iphdr, saddr);
> Instead of setting parameters for the function tail (which rules out the
>  both-src-and-dst case), you could factor out the 'make the entries' loop
>  and just call it from here.

right now its needed with src and dst

>
>> +	} else if (memcmp(&target.dst.u3, &tuple->dst.u3,
>> +			  sizeof(target.dst.u3))) {
>> +		addr = &target.dst.u3;
>> +		next_offset = offsetof(struct iphdr, daddr);
>> +	} else {
>> +		return;
>> +	}
>> +
>> +	for (i = 0; i < sizeof(struct in6_addr) / sizeof(u32); i++) {
>> +		entry = tcf_ct_flow_table_flow_action_get_next(action);
>> +		entry->id = FLOW_ACTION_MANGLE;
>> +		entry->mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_IP6;
>> +		entry->mangle.mask = ~(0xFFFFFFFF);
>> +		entry->mangle.val = htonl(addr->ip6[i]);
>> +		entry->mangle.offset = next_offset;
> You don't need to perform strength reduction, the compiler is smart
>  enough to do that itself.  Just using 'offset + i * sizeof(u32)' here
>  would be clearer imho.
>  
Not my intention :) but will do.
>> +
>> +		next_offset += sizeof(u32);
>> +	}
>> +}
>> +
>> +static void
>> +tcf_ct_flow_table_add_action_nat_tcp(const struct nf_conntrack_tuple *tuple,
>> +				     struct nf_conntrack_tuple target,
>> +				     struct flow_action *action)
>> +{
>> +	struct flow_action_entry *entry;
>> +
>> +	if (target.src.u.tcp.port != tuple->src.u.tcp.port) {
>> +		entry = tcf_ct_flow_table_flow_action_get_next(action);
>> +		entry->id = FLOW_ACTION_MANGLE;
>> +		entry->mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_TCP;
>> +		entry->mangle.mask = ~(0xFFFF);
> More unnecessary parens.
will remove the all .
>
>> +		entry->mangle.offset = offsetof(struct tcphdr, source);
>> +		entry->mangle.val = htons(target.src.u.tcp.port);
>> +	} else if (target.dst.u.tcp.port != tuple->dst.u.tcp.port) {
>> +		entry = tcf_ct_flow_table_flow_action_get_next(action);
>> +		entry->id = FLOW_ACTION_MANGLE;
>> +		entry->mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_TCP;
>> +		entry->mangle.mask = ~(0xFFFF);
>> +		entry->mangle.offset = offsetof(struct tcphdr, dest);
>> +		entry->mangle.val = htons(target.dst.u.tcp.port);
>> +	}
>> +}
>> +
>> +static void
>> +tcf_ct_flow_table_add_action_nat_udp(const struct nf_conntrack_tuple *tuple,
>> +				     struct nf_conntrack_tuple target,
>> +				     struct flow_action *action)
>> +{
>> +	struct flow_action_entry *entry;
>> +
>> +	if (target.src.u.udp.port != tuple->src.u.udp.port) {
>> +		entry = tcf_ct_flow_table_flow_action_get_next(action);
>> +		entry->id = FLOW_ACTION_MANGLE;
>> +		entry->mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_UDP;
>> +		entry->mangle.mask = ~(0xFFFF);
>> +		entry->mangle.offset = offsetof(struct udphdr, source);
>> +		entry->mangle.val = htons(target.src.u.udp.port);
>> +	} else if (target.dst.u.udp.port != tuple->dst.u.udp.port) {
>> +		entry = tcf_ct_flow_table_flow_action_get_next(action);
>> +		entry->id = FLOW_ACTION_MANGLE;
>> +		entry->mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_UDP;
>> +		entry->mangle.mask = ~(0xFFFF);
>> +		entry->mangle.offset = offsetof(struct udphdr, dest);
>> +		entry->mangle.val = htons(target.dst.u.udp.port);
>> +	}
>> +}
> This is all very boilerplatey; I wonder if factoring it into some
>  preprocessor [ab]use would improve matters.  Pro: less risk of a
>  src/dst or udp/tcp typo hiding in there.  Con: have to read macros.

like ADD_MANGLE_ENTRY(action, htype,....,val)...

		entry = tcf_ct_flow_table_flow_action_get_next(action);
		entry->id = FLOW_ACTION_MANGLE;
		entry->mangle.htype = htype;
		entry->mangle.mask = mask;
		entry->mangle.offset = offset;
		entry->mangle.val = val;
?
then im for it.

>
>> +
>> +static void tcf_ct_flow_table_add_action_meta(struct nf_conn *ct,
>> +					      enum ip_conntrack_dir dir,
>> +					      struct flow_action *action)
>> +{
>> +	struct nf_conn_labels *ct_labels;
>> +	struct flow_action_entry *entry;
>> +	u32 *act_ct_labels;
>> +
>> +	entry = tcf_ct_flow_table_flow_action_get_next(action);
>> +	entry->id = FLOW_ACTION_CT_METADATA;
>> +	entry->ct_metadata.zone = nf_ct_zone(ct)->id;
> I'm not quite sure what the zone is doing in the action.  Surely it's
>  a property of the match.  Or does this set a ct_zone for a potential
>  *second* conntrack lookup?

this is part of the metadata that driver should mark the with, as it can be matched against in following hardware tables/rules. consider this set of offloaded rules:

tc filter add ...... chain 0 flower ct_state -trk action ct zone 5 goto chain 1

tc filter add ...... chain 0 flower ct_state -trk action ct zone 3 goto chain 1

tc filter add ...... chain 1 flower ct_state  +trk+new action ct zone 3 commit pipe  action mirred redirect dev1

tc filter add ...... chain 1 flower ct_state  +trk+new action ct zone 5 commit pipe  action mirred redirect dev2

tc filter add ...... chain 1 flower ct_state  +trk+est ct_zone 3 action mirred redirect dev1

tc filter add ...... chain 1 flower ct_state  +trk+est ct_zone 5 action mirred redirect dev2


so both offloaded +est rules match on packet metadata zone field to figure out the output port,

this is what this action tell hardware to do, mark the packet with this zone, so it can be matched against.


>> +#if IS_ENABLED(CONFIG_NF_CONNTRACK_MARK)
>> +	entry->ct_metadata.mark = ct->mark;
>> +#endif
>> +
>> +	act_ct_labels = entry->ct_metadata.labels;
>> +	ct_labels = nf_ct_labels_find(ct);
>> +	if (ct_labels)
>> +		memcpy(act_ct_labels, ct_labels->bits, NF_CT_LABELS_MAX_SIZE);
>> +	else
>> +		memset(act_ct_labels, 0, NF_CT_LABELS_MAX_SIZE);
>> +}
>> +
>> +static void tcf_ct_flow_table_add_action_nat(struct net *net,
>> +					     struct nf_conn *ct,
>> +					     enum ip_conntrack_dir dir,
>> +					     struct flow_action *action)
>> +{
>> +	const struct nf_conntrack_tuple *tuple = &ct->tuplehash[dir].tuple;
>> +	struct nf_conntrack_tuple target;
>> +
>> +	nf_ct_invert_tuple(&target, &ct->tuplehash[!dir].tuple);
>> +
>> +	tuple->src.l3num == NFPROTO_IPV4 ?
>> +		tcf_ct_flow_table_add_action_nat_ipv4(tuple, target, action) :
>> +		tcf_ct_flow_table_add_action_nat_ipv6(tuple, target, action);
> I don't think this kind of ternary [ab]use is kernel style.  Also it
>  doesn't let you check for the "not IPV6 either" case.
> I'd suggest a switch statement.  (And this whole tree of functions
>  should be able to return EOPNOTSUPPs for such "can't happen" / "we
>  are confused" cases, rather than being void.)
we check the proto support earlier. i can change this to a switch and  move the check here.
>
>> +
>> +	nf_ct_protonum(ct) == IPPROTO_TCP ?
>> +		tcf_ct_flow_table_add_action_nat_tcp(tuple, target, action) :
>> +		tcf_ct_flow_table_add_action_nat_udp(tuple, target, action);
>> +}
>> +
>> +static int tcf_ct_flow_table_fill_actions(struct net *net,
>> +					  const struct flow_offload *flow,
>> +					  enum flow_offload_tuple_dir tdir,
>> +					  struct nf_flow_rule *flow_rule)
>> +{
>> +	struct flow_action *action = &flow_rule->rule->action;
>> +	const struct nf_conntrack_tuple *tuple;
>> +	struct nf_conn *ct = flow->ct;
>> +	enum ip_conntrack_dir dir;
>> +
>> +	switch (tdir) {
>> +	case FLOW_OFFLOAD_DIR_ORIGINAL:
>> +		dir = IP_CT_DIR_ORIGINAL;
>> +		break;
>> +	case FLOW_OFFLOAD_DIR_REPLY:
>> +		dir = IP_CT_DIR_REPLY;
>> +		break;
>> +	default:
>> +		return -EOPNOTSUPP;
>> +	}
>> +
>> +	tuple = &ct->tuplehash[dir].tuple;
>> +	if (tuple->src.l3num != NFPROTO_IPV4 &&
>> +	    tuple->src.l3num != NFPROTO_IPV6)
>> +		return -EOPNOTSUPP;
> Ah, is the proto check here rather than in
>  tcf_ct_flow_table_add_action_nat() to ensure that you don't
>  write *any* flow_action_entries in the unsupported case?  In
>  that case maybe the real answer is to add a way to roll back
>  entry additions.
> Since tcf_ct_flow_table_flow_action_get_next() doesn't appear
>  to do any allocation (or bounds-checking of num_entries!) it
>  seems all that would be needed is to save the old num_entries,
>  and restore it on failure exit.
>
> -ed

ill add the bounds check so there is reason for this functions to fail :)

and memset the new entries on fail.

thanks for the review.

Paul.

>
>> +
>> +	if (nf_ct_protonum(ct) != IPPROTO_TCP &&
>> +	    nf_ct_protonum(ct) != IPPROTO_UDP)
>> +		return -EOPNOTSUPP;
>> +
>> +	tcf_ct_flow_table_add_action_meta(ct, dir, action);
>> +	tcf_ct_flow_table_add_action_nat(net, ct, dir, action);
>> +	return 0;
>> +}
>> +
>>  static struct nf_flowtable_type flowtable_ct = {
>> +	.action		= tcf_ct_flow_table_fill_actions,
>>  	.owner		= THIS_MODULE,
>>  };
>>  
>>
