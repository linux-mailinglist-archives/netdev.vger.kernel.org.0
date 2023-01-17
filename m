Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0482B66E7BF
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 21:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbjAQUhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 15:37:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235361AbjAQUf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 15:35:28 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2047.outbound.protection.outlook.com [40.107.94.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B57A674FE;
        Tue, 17 Jan 2023 11:19:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dg97DySksov1sQhuRhoIi/Dvuo2ac5r/tMoE/DOnWMHGBMyUJkR9WK4JEUkOOkBfiHsrvz+EL86qmL39h81j8rfkS9gzPovRNvZUstL5sqFU7D/3bTFHfyH6VM4awkXtOmwF0mcjXCCnN/xBQEL45mN1QA9P7uIswltINnHZBj7o0a/x3J56S5ngu0yEarJsvxKmN2nT/0y26uUce3Zu9BcN/+p5L3+iBYdL1zGfpFZJUMndMvyZp2ssxcd2Gmghv2BoorIfXSBRM2DkTdpmuSGA+1lFnIWIwFuSMzV43hnTBZ+xOwi7peoZc/p7yOxO1tZIg1Wp5cgMrb66A4vHpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zJzolTW5M+wbB5XMtRZ5VrvGKaYwbyoV1sFlJHRv9dE=;
 b=enJrLa99CXqqspYI2DR8+2nIeAL0r3f0hsi+tH63X4EDU4CNa48ezrG/o0eC7e8zJdzHiYgBtupifk+mYXw3X7IZYtaMbqzGjuDSyeFafq7o0ozsOUC/tfUtqAiEGQhLGwtOndn3flSEV5EadrQK+ftbJH/c5hg+BRl4UtXP69xLf13dftXIr7Ny80LG7/t3OH2yGwc0AEvqzIhX7DLmb1WD7fc/3LaB34NWNuEPbIixfm/hXKi4J+7FgyQFOa2i5Bxxw6leqEId8hvp7ryHsRDeeCr1KvqGVlmcRkwJTAVW0MoZnAs4LF3B47dE0GWYUKkzt+7U9WPvk0M4AN9axA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zJzolTW5M+wbB5XMtRZ5VrvGKaYwbyoV1sFlJHRv9dE=;
 b=DhAJk9XqfNjsy3asd4laBer4QU7GjZpECqxZ0kejPyHMB8O88MjaKQ9y++t7YQAFKeOY+xRVMNyZvAYT5xHXn+v9i9V/VHkaa9cd9HE8sgIcGQG7F6OLJlnTG2NG3kubg5/92OPFDL+r+Dyi1iDMsaZWuPVev+s5QHjqUm0DjkJIJouVThh9ztE//vWLe+CZk4TDpPjRdMl43h9DxSvchcDK3oCytgY+KeWbccDaxe5U50t8l17MZttI9/rQ3zb6ZczLb/0QcUyrrh3jgyZWnjynU2In2xmLRRgVNYpcW1PzFw6M3PTmX+w019eRebkHy8uG8fjBHQoZNqN5CLWnWw==
Received: from DS7PR03CA0030.namprd03.prod.outlook.com (2603:10b6:5:3b8::35)
 by IA1PR12MB7760.namprd12.prod.outlook.com (2603:10b6:208:422::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 19:19:07 +0000
Received: from DM6NAM11FT106.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b8:cafe::ae) by DS7PR03CA0030.outlook.office365.com
 (2603:10b6:5:3b8::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.19 via Frontend
 Transport; Tue, 17 Jan 2023 19:19:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT106.mail.protection.outlook.com (10.13.172.229) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Tue, 17 Jan 2023 19:19:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 17 Jan
 2023 11:18:57 -0800
Received: from fedora.nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 17 Jan
 2023 11:18:54 -0800
References: <20230113165548.2692720-1-vladbu@nvidia.com>
 <20230113165548.2692720-7-vladbu@nvidia.com>
 <Y8bBs4668C9r5oTT@t14s.localdomain> <871qntcb14.fsf@nvidia.com>
 <Y8bhMMvqylw+TbZv@t14s.localdomain>
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
Date:   Tue, 17 Jan 2023 21:12:26 +0200
In-Reply-To: <Y8bhMMvqylw+TbZv@t14s.localdomain>
Message-ID: <87sfg9as10.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT106:EE_|IA1PR12MB7760:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c28c42e-e948-44ea-1f38-08daf8bfb3fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wtli9SJr/FpplHpTYiW1J858i02ST4WpG3KuTiMBV63LwORGypvlSs2DysSNkNHuKfErQDyN/jMPAh9daLDibbiHr+/dIOT8CzMqKjihsfCVP2sewFAh0sHVlDeMxQMEA7Aehms7T7f5N16n60IKeC6Yrewn1tGt2uq62U0p4/UqpDs/2Yu+3tZOfKzykokrC1oYFi2fspGYJtBHoAYCLeikmfKruX0v03knT8QoBITMmo/1Hc5q8OzEBvm0RlfBLGcqCHTm8jrhNifMLVMzFTLFlXREs/23I2rmfXOfzYeSjutPykxH8xa5d2WCy/P90DrEWvllaKBbZtl4K+SgHHT12g2lftY+P6O0yXEazIqXzGKjbWnJFFdXoLBFywYlcwl4NtPrKsKhE1JxyYuysazF0hTBmAvUbYbPPvM3xfVRKl40HPfG4O8oNlusMwfKzqrwACh6F5LhLwBsgWbg/WrP8r41NMFv90zlpKTpFsDFHtmXLPhcGCPTrk+rnw0U3TYCibKVou05PWKItM9i1TYqMtcOmJ+MfMR2mv3gM1AtDB3vlVlnN2HQeEce71J2NqL2LWWcR0uJPWG3/057y4hFdGvaifUwyAJDHDqOORX0sUYSc9YBZJmuBBXPY9PCW4wFnqbqW3tvC1wMiqwUQV61aKfPaEjqKxGV+0vUR7FiUdvQdN2IcxklYLhefkrY9BhoaLf/VTD2NTxZNRlGtg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(396003)(346002)(451199015)(40470700004)(36840700001)(46966006)(36756003)(356005)(86362001)(6916009)(2906002)(8676002)(8936002)(70586007)(70206006)(7416002)(4326008)(36860700001)(82740400003)(83380400001)(7636003)(5660300002)(40460700003)(7696005)(316002)(54906003)(41300700001)(6666004)(40480700001)(478600001)(82310400005)(2616005)(426003)(336012)(16526019)(47076005)(26005)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 19:19:06.6649
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c28c42e-e948-44ea-1f38-08daf8bfb3fb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT106.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7760
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 17 Jan 2023 at 14:56, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> On Tue, Jan 17, 2023 at 07:36:42PM +0200, Vlad Buslov wrote:
>> 
>> On Tue 17 Jan 2023 at 12:41, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
>> > On Fri, Jan 13, 2023 at 05:55:47PM +0100, Vlad Buslov wrote:
>> >> When processing connections allow offloading of UDP connections that don't
>> >> have IPS_ASSURED_BIT set as unidirectional. When performing table lookup
>> >
>> > Hmm. Considering that this is now offloading one direction only
>> > already, what about skipping this grace period:
>> >
>> > In nf_conntrack_udp_packet(), it does:
>> >
>> >         /* If we've seen traffic both ways, this is some kind of UDP
>> >          * stream. Set Assured.
>> >          */
>> >         if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
>> > 		...
>> >                 /* Still active after two seconds? Extend timeout. */
>> >                 if (time_after(jiffies, ct->proto.udp.stream_ts)) {
>> >                         extra = timeouts[UDP_CT_REPLIED];
>> >                         stream = true;
>> >                 }
>> > 		...
>> >                 /* Also, more likely to be important, and not a probe */
>> >                 if (stream && !test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
>> >                         nf_conntrack_event_cache(IPCT_ASSURED, ct);
>> >
>> > Maybe the patch should be relying on IPS_SEEN_REPLY_BIT instead of
>> > ASSURED for UDP? Just a thought here, but I'm not seeing why not.
>> 
>> The issue with this is that if we offload both directions early, then
>> conntrack state machine will not receive any more packets and,
>> consecutively, will never change the flow state to assured. I guess that
>
> I'm missing how it would offload each direction independently.
> Wouldn't CT state machine see the 1st reply, because it is not
> offloaded yet, and match it to the original direction?

What I meant is that if both directions are offloaded as soon as
IPS_SEEN_REPLY_BIT is set, then nf_conntrack_udp_packet() will not be
called for that connection anymore and would never be able to transition
the connection to assured state. But main thing is, as I said in the
previous reply, that we don't need to offload such connection ATM. It
could be done in a follow-up if there is a use-case for it, maybe even
made somehow configurable (with BPF! :)), so it could be dynamically
controlled.

>
>> could be mitigated somehow by periodically checking the hw stats and
>> transitioning the flow to assured based on them, but as I said in
>> previous email we don't want to over-complicate this series even more.
>> Also, offloading to hardware isn't free and costs both memory and CPU,
>> so it is not like offloading as early as possible is strictly beneficial
>> for all cases...
>
> Yup.
>
>> 
>> >
>> >> for reply packets check the current connection status: If UDP
>> >> unidirectional connection became assured also promote the corresponding
>> >> flow table entry to bidirectional and set the 'update' bit, else just set
>> >> the 'update' bit since reply directional traffic will most likely cause
>> >> connection status to become 'established' which requires updating the
>> >> offload state.
>> >> 
>> >> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
>> >> ---
>> >>  net/sched/act_ct.c | 48 ++++++++++++++++++++++++++++++++++------------
>> >>  1 file changed, 36 insertions(+), 12 deletions(-)
>> >> 
>> >> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
>> >> index bfddb462d2bc..563cbdd8341c 100644
>> >> --- a/net/sched/act_ct.c
>> >> +++ b/net/sched/act_ct.c
>> >> @@ -369,7 +369,7 @@ static void tcf_ct_flow_tc_ifidx(struct flow_offload *entry,
>> >>  
>> >>  static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
>> >>  				  struct nf_conn *ct,
>> >> -				  bool tcp)
>> >> +				  bool tcp, bool bidirectional)
>> >>  {
>> >>  	struct nf_conn_act_ct_ext *act_ct_ext;
>> >>  	struct flow_offload *entry;
>> >> @@ -388,6 +388,8 @@ static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
>> >>  		ct->proto.tcp.seen[0].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
>> >>  		ct->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
>> >>  	}
>> >> +	if (bidirectional)
>> >> +		__set_bit(NF_FLOW_HW_BIDIRECTIONAL, &entry->flags);
>> >>  
>> >>  	act_ct_ext = nf_conn_act_ct_ext_find(ct);
>> >>  	if (act_ct_ext) {
>> >> @@ -411,26 +413,34 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
>> >>  					   struct nf_conn *ct,
>> >>  					   enum ip_conntrack_info ctinfo)
>> >>  {
>> >> -	bool tcp = false;
>> >> -
>> >> -	if ((ctinfo != IP_CT_ESTABLISHED && ctinfo != IP_CT_ESTABLISHED_REPLY) ||
>> >> -	    !test_bit(IPS_ASSURED_BIT, &ct->status))
>> >> -		return;
>> >> +	bool tcp = false, bidirectional = true;
>> >>  
>> >>  	switch (nf_ct_protonum(ct)) {
>> >>  	case IPPROTO_TCP:
>> >> -		tcp = true;
>> >> -		if (ct->proto.tcp.state != TCP_CONNTRACK_ESTABLISHED)
>> >> +		if ((ctinfo != IP_CT_ESTABLISHED &&
>> >> +		     ctinfo != IP_CT_ESTABLISHED_REPLY) ||
>> >> +		    !test_bit(IPS_ASSURED_BIT, &ct->status) ||
>> >> +		    ct->proto.tcp.state != TCP_CONNTRACK_ESTABLISHED)
>> >>  			return;
>> >> +
>> >> +		tcp = true;
>> >>  		break;
>> >>  	case IPPROTO_UDP:
>> >> +		if (!nf_ct_is_confirmed(ct))
>> >> +			return;
>> >> +		if (!test_bit(IPS_ASSURED_BIT, &ct->status))
>> >> +			bidirectional = false;
>> >>  		break;
>> >>  #ifdef CONFIG_NF_CT_PROTO_GRE
>> >>  	case IPPROTO_GRE: {
>> >>  		struct nf_conntrack_tuple *tuple;
>> >>  
>> >> -		if (ct->status & IPS_NAT_MASK)
>> >> +		if ((ctinfo != IP_CT_ESTABLISHED &&
>> >> +		     ctinfo != IP_CT_ESTABLISHED_REPLY) ||
>> >> +		    !test_bit(IPS_ASSURED_BIT, &ct->status) ||
>> >> +		    ct->status & IPS_NAT_MASK)
>> >>  			return;
>> >> +
>> >>  		tuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
>> >>  		/* No support for GRE v1 */
>> >>  		if (tuple->src.u.gre.key || tuple->dst.u.gre.key)
>> >> @@ -446,7 +456,7 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
>> >>  	    ct->status & IPS_SEQ_ADJUST)
>> >>  		return;
>> >>  
>> >> -	tcf_ct_flow_table_add(ct_ft, ct, tcp);
>> >> +	tcf_ct_flow_table_add(ct_ft, ct, tcp, bidirectional);
>> >>  }
>> >>  
>> >>  static bool
>> >> @@ -625,13 +635,27 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
>> >>  	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
>> >>  	ct = flow->ct;
>> >>  
>> >> +	if (dir == FLOW_OFFLOAD_DIR_REPLY &&
>> >> +	    !test_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags)) {
>> >> +		/* Only offload reply direction after connection became
>> >> +		 * assured.
>> >> +		 */
>> >> +		if (test_bit(IPS_ASSURED_BIT, &ct->status))
>> >> +			set_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags);
>> >> +		set_bit(NF_FLOW_HW_UPDATE, &flow->flags);
>> >> +		return false;
>> >> +	}
>> >> +
>> >>  	if (tcph && (unlikely(tcph->fin || tcph->rst))) {
>> >>  		flow_offload_teardown(flow);
>> >>  		return false;
>> >>  	}
>> >>  
>> >> -	ctinfo = dir == FLOW_OFFLOAD_DIR_ORIGINAL ? IP_CT_ESTABLISHED :
>> >> -						    IP_CT_ESTABLISHED_REPLY;
>> >> +	if (dir == FLOW_OFFLOAD_DIR_ORIGINAL)
>> >> +		ctinfo = test_bit(IPS_SEEN_REPLY_BIT, &ct->status) ?
>> >> +			IP_CT_ESTABLISHED : IP_CT_NEW;
>> >> +	else
>> >> +		ctinfo = IP_CT_ESTABLISHED_REPLY;
>> >>  
>> >>  	flow_offload_refresh(nf_ft, flow);
>> >>  	nf_conntrack_get(&ct->ct_general);
>> >> -- 
>> >> 2.38.1
>> >> 
>> 

