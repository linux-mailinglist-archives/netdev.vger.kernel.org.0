Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 668A517F145
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 08:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgCJHwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 03:52:34 -0400
Received: from mail-eopbgr130081.outbound.protection.outlook.com ([40.107.13.81]:14946
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726202AbgCJHwd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 03:52:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MTozBZzooIvK4qdOjE0s2UR5Qjq1jxgK0ofptKfajEym4nsiAVGH+/a+CkZWoZEVgd3TV7zB1kvnX3agODxZiF6QuNeLMp/FlmLowq3UuaGQ4o+HvMNO/nf/tvLuwH4MRcceSoi+Im+21TUczlq53H3ztD1eXGYowb6juca2XlMrfkvo0Z+WTDHhrSsJm8vPyyEMmDsVQFeuuZ4xscZyGbAienIB1jHZpxJwOIhL9FKGhfaSelbiHrJk7xNbGE6DNvO6D9NDBLflL3kFudK0QWQUE3WxIELPl43TPyjDvrCv/j04XhFjdd3bLfYuPSTY6TeuJv/5g3MXxHe9Hc6Axw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hi8EiVbvstVzuuFVGbOdAZb7OUqi77lOjMWydSBqTfE=;
 b=jol5HQfDWKWB/V2HwXUAQWxVI6fJ62t9KpBJzHDdyL+L6yYoOttJSNb5SpNfau61vbtgyT4fp3dxrJsmewKApghyiyND/n4kdyD8Zy9JCYBrAnS5rXW0/NbxvzFanSgyfUUGNK/Zc2SxyUcSXBLqb0R/GEop0LaYUKP7Q/z/0J5IbgMtgIXn4quF4W20pdq+nTU314ov8ieNOhYKZwepQb/5qcaKBHEMItggHinQuLW8r+IOgSRsZpbplqe6jycjpkc5UL7s3iACbipIUK3vmWVU31PdDYr52DpP2SktdK812yHhTSlnWoOSV/X+uUs6uOukxs/NhOcSwRu/77Rvaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hi8EiVbvstVzuuFVGbOdAZb7OUqi77lOjMWydSBqTfE=;
 b=WNaOKP4QREXQquY4VIqnDA+DV27f6Xa3TZzRrEnbAEuOdaSnMiIbBaFpNV443m2s/6j3sDpXYxr5W79H8rjy5CY48ePVha/KIi0VEtHmoQwlrDWuksBhu4Mn5DwhhszUqFEGRJscoWAcLnIbHCVxD/vzmo1bvP/Zr+/7cdN7mmE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (20.177.36.78) by
 AM6PR05MB5427.eurprd05.prod.outlook.com (20.177.118.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Tue, 10 Mar 2020 07:52:28 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4%7]) with mapi id 15.20.2772.019; Tue, 10 Mar 2020
 07:52:28 +0000
Subject: Re: [PATCH net-next ct-offload v2 02/13] net/sched: act_ct:
 Instantiate flow table entry actions
To:     Edward Cree <ecree@solarflare.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1583676662-15180-1-git-send-email-paulb@mellanox.com>
 <1583676662-15180-3-git-send-email-paulb@mellanox.com>
 <5dde483c-be42-644c-30b5-add308b4f69d@solarflare.com>
From:   Paul Blakey <paulb@mellanox.com>
Message-ID: <53a410d3-92a6-37b4-f59a-e5081fe1604e@mellanox.com>
Date:   Tue, 10 Mar 2020 09:52:24 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
In-Reply-To: <5dde483c-be42-644c-30b5-add308b4f69d@solarflare.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: ZR0P278CA0035.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::22) To AM6PR05MB5096.eurprd05.prod.outlook.com
 (2603:10a6:20b:11::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.223.6.3] (193.47.165.251) by ZR0P278CA0035.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Tue, 10 Mar 2020 07:52:26 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 43d17eb4-39cc-4696-f8c3-08d7c4c7faac
X-MS-TrafficTypeDiagnostic: AM6PR05MB5427:|AM6PR05MB5427:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB54276979D617E54E0FF0B144CFFF0@AM6PR05MB5427.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39850400004)(376002)(346002)(136003)(396003)(189003)(199004)(6486002)(316002)(5660300002)(16576012)(31686004)(2616005)(186003)(36756003)(26005)(6636002)(956004)(16526019)(2906002)(52116002)(86362001)(53546011)(66556008)(66476007)(66946007)(31696002)(8936002)(81156014)(110136005)(478600001)(8676002)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5427;H:AM6PR05MB5096.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u3x6NCfmfdpr3zmfupPTh1YF/C6hJtq3X6gHy0WpF9MNhS2P4FDAq0KCTC381D2gwV3RzTe31Op3EYAyBoyEy9p/Av7Jpc4YkjjQnP7b4veUg25SkVG76DvU4YLowsw6riMFmSu/bWhSI1bHCtIR5AjEEeXG5xUXQE0EGqdTPTzDItY0+MU8pdBjSj4keN3O96WocTjGzQBrMGVrCJXkfFF+7o98afcSVR/P0L+EmrWp8whB9ZWGvxR75utPB83GssxyRws9ZTcpsqMq0ECarLBs2L8gFFMdo1hLuFr4/W3/WbrBC/uSK/lsBEh4gjJg5V2bwbJSv2nyLX+Fxb6NTav3QAXQqRYZ3Mw9hU8c/JnqbhivWOf+j9FufQLEYC9usu7vJk1uJ99d2piGthiau2UPU0prKs/rZ3LPBcR/tkpfAVdTxclCoJvYLY2Rhkmx
X-MS-Exchange-AntiSpam-MessageData: Qfzd0RqGjd6TFJ/i1ZQuhhq1H+HXqyXqjz0izHaJftDOfPaS8kQj/Q3v9ljo8zdxJjXDE7t0rViiNxYf4RQ+OKmPqRnHdt3DVA0+EDxIjdfK5y70fwMVKazOJP8vG6KTqUdKjAq/DsVXpuArRtTn8w==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43d17eb4-39cc-4696-f8c3-08d7c4c7faac
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 07:52:28.2158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gCGMj3Az34jgwBTDDFJQ1euoSYQ0klWHOONqroCtti7yCkhgVahixi+i9SVz9FI2a0dfG39jgzA/4vmxuQCG7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5427
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/9/2020 7:36 PM, Edward Cree wrote:
> On 08/03/2020 14:10, Paul Blakey wrote:
>> NF flow table API associate 5-tuple rule with an action list by calling
>> the flow table type action() CB to fill the rule's actions.
>>
>> In action CB of act_ct, populate the ct offload entry actions with a new
>> ct_metadata action. Initialize the ct_metadata with the ct mark, label and
>> zone information. If ct nat was performed, then also append the relevant
>> packet mangle actions (e.g. ipv4/ipv6/tcp/udp header rewrites).
>>
>> Drivers that offload the ft entries may match on the 5-tuple and perform
>> the action list.
>>
>> Signed-off-by: Paul Blakey <paulb@mellanox.com>
>> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
>> ---
>> Changelog:
>>    v1->v2:
>>      Remove zone from metadata
>>      Add add mangle helper func (removes the unneccasry () and correct the mask there)
>>      Remove "abuse" of ? operator and use switch case
>>      Check protocol and ports in relevant function and return err
>>      On error restore action entries (on the topic, validaiting num of action isn't available)
>>      Add comment expalining nat
>>      Remove Inlinie from tcf_ct_flow_table_flow_action_get_next
>>      Refactor tcf_ct_flow_table_add_action_nat_ipv6 with helper
>>      On nats, allow both src and dst mangles
>>
>>  include/net/flow_offload.h            |   5 +
>>  include/net/netfilter/nf_flow_table.h |  23 ++++
>>  net/netfilter/nf_flow_table_offload.c |  23 ----
>>  net/sched/act_ct.c                    | 208 ++++++++++++++++++++++++++++++++++
>>  4 files changed, 236 insertions(+), 23 deletions(-)
>>
>> <snip>
>> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
>> index 23eba61..d57e7969 100644
>> --- a/net/sched/act_ct.c
>> +++ b/net/sched/act_ct.c
>> @@ -55,7 +55,215 @@ struct tcf_ct_flow_table {
>>  	.automatic_shrinking = true,
>>  };
>>  
>> +static struct flow_action_entry *
>> +tcf_ct_flow_table_flow_action_get_next(struct flow_action *flow_action)
>> +{
>> +	int i = flow_action->num_entries++;
>> +
>> +	return &flow_action->entries[i];
>> +}
>> +
>> +static void tcf_ct_add_mangle_action(struct flow_action *action,
>> +				     enum flow_action_mangle_base htype,
>> +				     u32 offset,
>> +				     u32 mask,
>> +				     u32 val)
>> +{
>> +	struct flow_action_entry *entry;
>> +
>> +	entry = tcf_ct_flow_table_flow_action_get_next(action);
>> +	entry->id = FLOW_ACTION_MANGLE;
>> +	entry->mangle.htype = htype;
>> +	entry->mangle.mask = ~mask;
>> +	entry->mangle.offset = offset;
>> +	entry->mangle.val = val;
>> +}
>> +
>> +static void
>> +tcf_ct_flow_table_add_action_nat_ipv4(const struct nf_conntrack_tuple *tuple,
>> +				      struct nf_conntrack_tuple target,
>> +				      struct flow_action *action)
>> +{
>> +	if (memcmp(&target.src.u3, &tuple->src.u3, sizeof(target.src.u3)))
>> +		tcf_ct_add_mangle_action(action, FLOW_ACT_MANGLE_HDR_TYPE_IP4,
>> +					 offsetof(struct iphdr, saddr),
>> +					 0xFFFFFF,
> Why is this mask only 24 bits?
>
>> +					 be32_to_cpu(target.src.u3.ip));
>> +	if (memcmp(&target.dst.u3, &tuple->dst.u3, sizeof(target.dst.u3)))
>> +		tcf_ct_add_mangle_action(action, FLOW_ACT_MANGLE_HDR_TYPE_IP4,
>> +					 offsetof(struct iphdr, daddr),
>> +					 0xFFFFFF,
>> +					 be32_to_cpu(target.dst.u3.ip));
>> +}
>> +
>> +static void
>> +tcf_ct_add_ipv6_addr_mangle_action(struct flow_action *action,
>> +				   union nf_inet_addr *addr,
>> +				   u32 offset)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < sizeof(struct in6_addr) / sizeof(u32); i++)
>> +		tcf_ct_add_mangle_action(action, FLOW_ACT_MANGLE_HDR_TYPE_IP6,
>> +					 i * sizeof(u32) + offset,
>> +					 0xFFFFFF, be32_to_cpu(addr->ip6[i]));
> Again, looks like this is meant to be 0xffffffff.
will fix.
>
>> +}
>> +
>> +static void
>> +tcf_ct_flow_table_add_action_nat_ipv6(const struct nf_conntrack_tuple *tuple,
>> +				      struct nf_conntrack_tuple target,
>> +				      struct flow_action *action)
>> +{
>> +	if (memcmp(&target.src.u3, &tuple->src.u3, sizeof(target.src.u3)))
>> +		tcf_ct_add_ipv6_addr_mangle_action(action, &target.src.u3,
>> +						   offsetof(struct ipv6hdr,
>> +							    saddr));
>> +	if (memcmp(&target.dst.u3, &tuple->dst.u3, sizeof(target.dst.u3)))
>> +		tcf_ct_add_ipv6_addr_mangle_action(action, &target.dst.u3,
>> +						   offsetof(struct ipv6hdr,
>> +							    daddr));
>> +}
>> +
>> +static void
>> +tcf_ct_flow_table_add_action_nat_tcp(const struct nf_conntrack_tuple *tuple,
>> +				     struct nf_conntrack_tuple target,
>> +				     struct flow_action *action)
>> +{
>> +	__be16 target_src = target.src.u.tcp.port;
>> +	__be16 target_dst = target.dst.u.tcp.port;
>> +
>> +	if (target_src != tuple->src.u.tcp.port)
>> +		tcf_ct_add_mangle_action(action, FLOW_ACT_MANGLE_HDR_TYPE_TCP,
>> +					 offsetof(struct tcphdr, source),
>> +					 0xFFFF, htons(target_src));
> htons() on a __be16 is wrong — did you run this through sparse?
> (htons takes a u16 and returns a __be16: "host to network short".)
> Either ntohs() or, canonically, be16_to_cpu().
yes will do.
>> +	if (target_dst != tuple->dst.u.tcp.port)
>> +		tcf_ct_add_mangle_action(action, FLOW_ACT_MANGLE_HDR_TYPE_TCP,
>> +					 offsetof(struct tcphdr, dest),
>> +					 0xFFFF, htons(target_dst));
>> +}
>> +
>> +static void
>> +tcf_ct_flow_table_add_action_nat_udp(const struct nf_conntrack_tuple *tuple,
>> +				     struct nf_conntrack_tuple target,
>> +				     struct flow_action *action)
>> +{
>> +	__be16 target_src = target.src.u.udp.port;
>> +	__be16 target_dst = target.dst.u.udp.port;
>> +
>> +	if (target_src != tuple->src.u.udp.port)
>> +		tcf_ct_add_mangle_action(action, FLOW_ACT_MANGLE_HDR_TYPE_TCP,
>> +					 offsetof(struct udphdr, source),
>> +					 0xFFFF, htons(target_src));
>> +	if (target_dst != tuple->dst.u.udp.port)
>> +		tcf_ct_add_mangle_action(action, FLOW_ACT_MANGLE_HDR_TYPE_TCP,
>> +					 offsetof(struct udphdr, dest),
>> +					 0xFFFF, htons(target_dst));
>> +}
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
>> +static int tcf_ct_flow_table_add_action_nat(struct net *net,
>> +					    struct nf_conn *ct,
>> +					    enum ip_conntrack_dir dir,
>> +					    struct flow_action *action)
>> +{
>> +	const struct nf_conntrack_tuple *tuple = &ct->tuplehash[dir].tuple;
>> +	struct nf_conntrack_tuple target;
>> +
>> +	nf_ct_invert_tuple(&target, &ct->tuplehash[!dir].tuple);
>> +
>> +	/* The following helper functions check if the inverted reverse tuple
>> +	 * is different then the current dir tuple - meaning nat for ports
>> +	 * and/or ip is needed, and add the relevant mangle actions.
>> +	 */
> Probably better to put this comment above the helpers, ratherthan the
>  calls to them, so that people reading the source linearly see the comment
>  before the memcmp()s.
yes thanks.
> -ed
>> +
>> +	switch (tuple->src.l3num) {
>> +	case NFPROTO_IPV4:
>> +		tcf_ct_flow_table_add_action_nat_ipv4(tuple, target,
>> +						      action);
>> +		break;
>> +	case NFPROTO_IPV6:
>> +		tcf_ct_flow_table_add_action_nat_ipv6(tuple, target,
>> +						      action);
>> +		break;
>> +	default:
>> +		return -EOPNOTSUPP;
>> +	}
>> +
>> +	switch (nf_ct_protonum(ct)) {
>> +	case IPPROTO_TCP:
>> +		tcf_ct_flow_table_add_action_nat_tcp(tuple, target, action);
>> +		break;
>> +	case IPPROTO_UDP:
>> +		tcf_ct_flow_table_add_action_nat_udp(tuple, target, action);
>> +		break;
>> +	default:
>> +		return -EOPNOTSUPP;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int tcf_ct_flow_table_fill_actions(struct net *net,
>> +					  const struct flow_offload *flow,
>> +					  enum flow_offload_tuple_dir tdir,
>> +					  struct nf_flow_rule *flow_rule)
>> +{
>> +	struct flow_action *action = &flow_rule->rule->action;
>> +	int num_entries = action->num_entries;
>> +	struct nf_conn *ct = flow->ct;
>> +	enum ip_conntrack_dir dir;
>> +	int i, err;
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
>> +	err = tcf_ct_flow_table_add_action_nat(net, ct, dir, action);
>> +	if (err)
>> +		goto err_nat;
>> +
>> +	tcf_ct_flow_table_add_action_meta(ct, dir, action);
>> +	return 0;
>> +
>> +err_nat:
>> +	/* Clear filled actions */
>> +	for (i = num_entries; i < action->num_entries; i++)
>> +		memset(&action->entries[i], 0, sizeof(action->entries[i]));
>> +	action->num_entries = num_entries;
>> +
>> +	return err;
>> +}
>> +
>>  static struct nf_flowtable_type flowtable_ct = {
>> +	.action		= tcf_ct_flow_table_fill_actions,
>>  	.owner		= THIS_MODULE,
>>  };
>>  
