Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2A5466E55B
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 18:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbjAQRzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 12:55:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231730AbjAQRyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 12:54:01 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2077.outbound.protection.outlook.com [40.107.92.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14A44F857;
        Tue, 17 Jan 2023 09:43:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VB2T+fQRQhf8x+OlK1GIwfuz3KVdCVmNL/8A+rT7tYnDd4+MFMfuBZFCXpYizLr8fqtfPXbLmo54CEbb7EqJnCsPMHxMvrog1rlrVULbkM/yEvyyXH2BoyRhJq5Vu2iBVIWaDd5vYHwPxfoWznMlDBdbeGkUbB9zWr5XfCMvd5kupkiStD9UoS4KtB65MQKs06k9esmQ9p/fKBEGKZYIYu0TnqDrICRzWiX8guBafU72m0+cKMkcmRBwBJTS9i3OE7fTzqWvOLVn2uPbPAveGtXRmUpfQpNvh25p0pxd89NBq3RCHKrnwe1YA+3MVAA+ibb4QvXp2+eSXDAudNARbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SO+bj02ZsCrC3web14Lh33QQ5OmYUwMEGVDJNcQjK0w=;
 b=Z7d1NOVlr6h8yyyWIHXjDfkuts8cF4f6XHLgWEtXAVIwspZYjjkPlZzHhQhEdyZhAvz86ysnbtvmZOoGcUCQHcXhI6HwZIX2gJsyzUcIspEOG9bNv5mjiTp4fI27YhJc3CeF8OvHJEo0MpDP4y6DeFYo8I4Egn6xDVjU+p6YCC9LwLEaiQUxXW8B7QyevjK+y9sMebQ96EOBDOL1OBIJdPTI8Llmo41ogqhHPOIW5KjC3F0Mq2sGGz2ULvltAjgQ+kZMhu00/l0E+/k2g7aqxLDZ3jdDRNG/TUPwObQKfYBCxqakh2ilmhngsc9rN3LuniWCeOi9Ifd4UJ0lsU1CKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SO+bj02ZsCrC3web14Lh33QQ5OmYUwMEGVDJNcQjK0w=;
 b=rFEZ6yniAofxXq2oinIGhrgrJui8goZvlw2CdqI+xDGKoYC63VrvI6t9rtGp4/8XqkiuYJWHiQwXJVnlS3hgpyj3HDzIbT+lPQibiMHPGzi69oS8cDDLLM4J0CIyIxyT/fbl5DqMnGKHxf3UhPckXwXxyeG6o6PsOnM/OcBxbW2yL1TxJxrLCh9yb4400jeg6Ugorx4C7kRma0vEKFh/EFGQZe78HHdVisuxlrsOlvzowd32rq8vEXQs6XaS+4sTBi490zFJw+Yy4lbb33EG+YTXWxMqBl/e5MnHk0Vsq9OuG6Txg7F4SzaNqfb7fG4K+wuPH8IW0Lnx5LdTiQ5qQw==
Received: from MW4PR03CA0252.namprd03.prod.outlook.com (2603:10b6:303:b4::17)
 by SJ0PR12MB8168.namprd12.prod.outlook.com (2603:10b6:a03:4e7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 17:43:19 +0000
Received: from CO1NAM11FT112.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b4:cafe::a1) by MW4PR03CA0252.outlook.office365.com
 (2603:10b6:303:b4::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.19 via Frontend
 Transport; Tue, 17 Jan 2023 17:43:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT112.mail.protection.outlook.com (10.13.174.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Tue, 17 Jan 2023 17:43:18 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 17 Jan
 2023 09:43:09 -0800
Received: from fedora.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 17 Jan
 2023 09:43:05 -0800
References: <20230113165548.2692720-1-vladbu@nvidia.com>
 <20230113165548.2692720-7-vladbu@nvidia.com>
 <Y8bBs4668C9r5oTT@t14s.localdomain>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>, <ozsh@nvidia.com>,
        <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v2 6/7] net/sched: act_ct: offload UDP NEW
 connections
Date:   Tue, 17 Jan 2023 19:36:42 +0200
In-Reply-To: <Y8bBs4668C9r5oTT@t14s.localdomain>
Message-ID: <871qntcb14.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT112:EE_|SJ0PR12MB8168:EE_
X-MS-Office365-Filtering-Correlation-Id: c54f31d8-4334-40dc-0b61-08daf8b251dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RLxFwCVjwD7yRl0C1Czy+akZyUojcYHA8pVD0ydKCTl7RQlm4EFzqI55RoBnq0bQkRUZSjN0izaIqptL2n+oNfINByoTYkaKQTOYZg+Exj658A2BBIlZvksxm5JmwcKtrVHNg5QcRH+aQcxrD9WuUqks1aZG+gqPHlzP6G2jxT0C2U5FUdPoYw/F84o2DIiwVKwZ0f3OR9+XWsp7GE4csIYtrPUMaEc/jOdiD3LoAgxESgttixXV/sVdPIkjKvaXmeC2HplmVgOLnwMLPA+mwT7vZ+9ZcbZqAHQu/kuqIkfvR5NUSy1sMi08j5LHmLR5hlR5UBaUqViZY0sLlSJYvALyQl1q/+fYmim7icSXUB/1Jr/6qxMjG4tzWOiNBvykCQ8ddMQyX2h0RsH2xbaFczKsPkTN06z+40ZJFDDu3xxMjT63AaXhjsajg/SG1SL2grNVgQBCsxAHiC17/IemyQVoOU8YKvepL3RCuPZPofVGBDWRUT6nIrLS1xcgYdb4JxKvN4NjuiAONOnDE/mMCO3l7sc43Gs+ovA6m5QQMT8y1B964i7T8e5QEu54Ugx9vqebBqrHrGA9P24KrXHytlZmeTrQd24pHP8PShFdQiIBylkmnx9DtEW5pIS65/5t/7gBL9tP5qX2+wfT/cGGw6TkIgF2+dsicmO9sWAxEA6zAO8UqHWIvEBUIimqgBqv1ka92IK2w5lw/KIPycs/GA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(136003)(346002)(396003)(451199015)(36840700001)(40470700004)(46966006)(41300700001)(2616005)(70586007)(70206006)(47076005)(186003)(4326008)(16526019)(8676002)(426003)(6916009)(82310400005)(36756003)(86362001)(26005)(36860700001)(5660300002)(83380400001)(336012)(82740400003)(8936002)(54906003)(478600001)(7696005)(40480700001)(316002)(2906002)(7416002)(7636003)(6666004)(40460700003)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 17:43:18.6717
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c54f31d8-4334-40dc-0b61-08daf8b251dd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT112.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8168
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 17 Jan 2023 at 12:41, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> On Fri, Jan 13, 2023 at 05:55:47PM +0100, Vlad Buslov wrote:
>> When processing connections allow offloading of UDP connections that don't
>> have IPS_ASSURED_BIT set as unidirectional. When performing table lookup
>
> Hmm. Considering that this is now offloading one direction only
> already, what about skipping this grace period:
>
> In nf_conntrack_udp_packet(), it does:
>
>         /* If we've seen traffic both ways, this is some kind of UDP
>          * stream. Set Assured.
>          */
>         if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
> 		...
>                 /* Still active after two seconds? Extend timeout. */
>                 if (time_after(jiffies, ct->proto.udp.stream_ts)) {
>                         extra = timeouts[UDP_CT_REPLIED];
>                         stream = true;
>                 }
> 		...
>                 /* Also, more likely to be important, and not a probe */
>                 if (stream && !test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
>                         nf_conntrack_event_cache(IPCT_ASSURED, ct);
>
> Maybe the patch should be relying on IPS_SEEN_REPLY_BIT instead of
> ASSURED for UDP? Just a thought here, but I'm not seeing why not.

The issue with this is that if we offload both directions early, then
conntrack state machine will not receive any more packets and,
consecutively, will never change the flow state to assured. I guess that
could be mitigated somehow by periodically checking the hw stats and
transitioning the flow to assured based on them, but as I said in
previous email we don't want to over-complicate this series even more.
Also, offloading to hardware isn't free and costs both memory and CPU,
so it is not like offloading as early as possible is strictly beneficial
for all cases...

>
>> for reply packets check the current connection status: If UDP
>> unidirectional connection became assured also promote the corresponding
>> flow table entry to bidirectional and set the 'update' bit, else just set
>> the 'update' bit since reply directional traffic will most likely cause
>> connection status to become 'established' which requires updating the
>> offload state.
>> 
>> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
>> ---
>>  net/sched/act_ct.c | 48 ++++++++++++++++++++++++++++++++++------------
>>  1 file changed, 36 insertions(+), 12 deletions(-)
>> 
>> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
>> index bfddb462d2bc..563cbdd8341c 100644
>> --- a/net/sched/act_ct.c
>> +++ b/net/sched/act_ct.c
>> @@ -369,7 +369,7 @@ static void tcf_ct_flow_tc_ifidx(struct flow_offload *entry,
>>  
>>  static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
>>  				  struct nf_conn *ct,
>> -				  bool tcp)
>> +				  bool tcp, bool bidirectional)
>>  {
>>  	struct nf_conn_act_ct_ext *act_ct_ext;
>>  	struct flow_offload *entry;
>> @@ -388,6 +388,8 @@ static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
>>  		ct->proto.tcp.seen[0].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
>>  		ct->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
>>  	}
>> +	if (bidirectional)
>> +		__set_bit(NF_FLOW_HW_BIDIRECTIONAL, &entry->flags);
>>  
>>  	act_ct_ext = nf_conn_act_ct_ext_find(ct);
>>  	if (act_ct_ext) {
>> @@ -411,26 +413,34 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
>>  					   struct nf_conn *ct,
>>  					   enum ip_conntrack_info ctinfo)
>>  {
>> -	bool tcp = false;
>> -
>> -	if ((ctinfo != IP_CT_ESTABLISHED && ctinfo != IP_CT_ESTABLISHED_REPLY) ||
>> -	    !test_bit(IPS_ASSURED_BIT, &ct->status))
>> -		return;
>> +	bool tcp = false, bidirectional = true;
>>  
>>  	switch (nf_ct_protonum(ct)) {
>>  	case IPPROTO_TCP:
>> -		tcp = true;
>> -		if (ct->proto.tcp.state != TCP_CONNTRACK_ESTABLISHED)
>> +		if ((ctinfo != IP_CT_ESTABLISHED &&
>> +		     ctinfo != IP_CT_ESTABLISHED_REPLY) ||
>> +		    !test_bit(IPS_ASSURED_BIT, &ct->status) ||
>> +		    ct->proto.tcp.state != TCP_CONNTRACK_ESTABLISHED)
>>  			return;
>> +
>> +		tcp = true;
>>  		break;
>>  	case IPPROTO_UDP:
>> +		if (!nf_ct_is_confirmed(ct))
>> +			return;
>> +		if (!test_bit(IPS_ASSURED_BIT, &ct->status))
>> +			bidirectional = false;
>>  		break;
>>  #ifdef CONFIG_NF_CT_PROTO_GRE
>>  	case IPPROTO_GRE: {
>>  		struct nf_conntrack_tuple *tuple;
>>  
>> -		if (ct->status & IPS_NAT_MASK)
>> +		if ((ctinfo != IP_CT_ESTABLISHED &&
>> +		     ctinfo != IP_CT_ESTABLISHED_REPLY) ||
>> +		    !test_bit(IPS_ASSURED_BIT, &ct->status) ||
>> +		    ct->status & IPS_NAT_MASK)
>>  			return;
>> +
>>  		tuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
>>  		/* No support for GRE v1 */
>>  		if (tuple->src.u.gre.key || tuple->dst.u.gre.key)
>> @@ -446,7 +456,7 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
>>  	    ct->status & IPS_SEQ_ADJUST)
>>  		return;
>>  
>> -	tcf_ct_flow_table_add(ct_ft, ct, tcp);
>> +	tcf_ct_flow_table_add(ct_ft, ct, tcp, bidirectional);
>>  }
>>  
>>  static bool
>> @@ -625,13 +635,27 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
>>  	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
>>  	ct = flow->ct;
>>  
>> +	if (dir == FLOW_OFFLOAD_DIR_REPLY &&
>> +	    !test_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags)) {
>> +		/* Only offload reply direction after connection became
>> +		 * assured.
>> +		 */
>> +		if (test_bit(IPS_ASSURED_BIT, &ct->status))
>> +			set_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags);
>> +		set_bit(NF_FLOW_HW_UPDATE, &flow->flags);
>> +		return false;
>> +	}
>> +
>>  	if (tcph && (unlikely(tcph->fin || tcph->rst))) {
>>  		flow_offload_teardown(flow);
>>  		return false;
>>  	}
>>  
>> -	ctinfo = dir == FLOW_OFFLOAD_DIR_ORIGINAL ? IP_CT_ESTABLISHED :
>> -						    IP_CT_ESTABLISHED_REPLY;
>> +	if (dir == FLOW_OFFLOAD_DIR_ORIGINAL)
>> +		ctinfo = test_bit(IPS_SEEN_REPLY_BIT, &ct->status) ?
>> +			IP_CT_ESTABLISHED : IP_CT_NEW;
>> +	else
>> +		ctinfo = IP_CT_ESTABLISHED_REPLY;
>>  
>>  	flow_offload_refresh(nf_ft, flow);
>>  	nf_conntrack_get(&ct->ct_general);
>> -- 
>> 2.38.1
>> 

