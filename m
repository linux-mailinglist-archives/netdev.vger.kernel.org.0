Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E687D66E541
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 18:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjAQRtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 12:49:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232629AbjAQRqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 12:46:19 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2073.outbound.protection.outlook.com [40.107.102.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0106458652;
        Tue, 17 Jan 2023 09:36:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xe2W//yb2O5LZ45sYHuyfi2XGMh1yN9C2acsGqLzlsnn25SdT08IWJvEfg73PFPE1U+IEwj/f51XWnH8St5H/hqrOnrNvG/Z94DuZpG0zIcqPjJ8Uuq7QYkBcbbEpjmH0CyhXOT8q04Jcr+27CAJ3oTJvXVxOgg83Hv93yn8wcHTxtEyybBCuW59se2FZrJdHLTzjcFgeoPavM9CFGfkrIWCQiq5vi6mOPAhe63Z1uXKotcBxuVRqM6wxaUsFx2QlKE75SyiYesq0CEHljI/fNrNQS5TfHizl55BRI5GfHmNGYFvLX+bxPy1UtN2nIASCSv6FEm+SPuk0XwQG3XJ2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3wTNsMpQj40o4MHKXrCJ/Wg+lS1jMmeHmuhFZs+4Wtk=;
 b=NtQgdH3APw7CYHI9G1DtkCEQkVFR64svA/Pf5DCtz91cIOYH6WtQhOHhTXtyZM0K8WoHc7ieEXdNkgHfUqxHcmheEjUL27DtJ6tpQN4ol+grov6VQ+AaBw0X7E2AWtTCO9TA8zQXfL7iySECP5Bl/AHqscR01lp1aVfxep5PLN8yU1pqj4zRtyuf+ZLPOAsZI8LcWxE9ipHQz8CS3uJ02WPGVIfSOCl4MKj8STfRsYOB385ef1lDU6UvRBc90HBfSeKKIIL3mcKozKHrcC6Wk51rA3KqVrtueUl8v5DDgvJM+1U3rVRLR6AWdBru76vpX/eZ7MGpYxYpqZrVJeI6aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3wTNsMpQj40o4MHKXrCJ/Wg+lS1jMmeHmuhFZs+4Wtk=;
 b=HxA+fzGkemhRxksWmet3Jc6sHMu/HeD3gSlUiqIsYRueTrVLbCuqLu3khJ5qIM6xh/6f9/hiXImA8XrXhd9j20u6//hIb46VdJNbd1xsz/QmMOj0+k89XeVXQrkd87nilsEDdkjt6pgUHnKsoHomOmQd+YwxqObwFAb0R4IIQZc6Fa+Jcdze8p8a5UtU+N9Fbo1QGP5BnBott4Lfqipv7H0Q8iy0rGqygqCSdazmHYfgbwz7Q+RfAWoVdeBaQNQJSOv4POB7K3XPSGdeId8+FtY5T8jxLyFzURsjeOfsToCrurR8SLRRS0HaxwqvEJQ6JVRBP9RDvg+MCi5pIqSrYg==
Received: from BN9PR03CA0331.namprd03.prod.outlook.com (2603:10b6:408:f6::6)
 by BL3PR12MB6569.namprd12.prod.outlook.com (2603:10b6:208:38c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Tue, 17 Jan
 2023 17:36:26 +0000
Received: from BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::a) by BN9PR03CA0331.outlook.office365.com
 (2603:10b6:408:f6::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.19 via Frontend
 Transport; Tue, 17 Jan 2023 17:36:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT021.mail.protection.outlook.com (10.13.177.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Tue, 17 Jan 2023 17:36:26 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 17 Jan
 2023 09:36:17 -0800
Received: from fedora.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 17 Jan
 2023 09:36:13 -0800
References: <20230113165548.2692720-1-vladbu@nvidia.com>
 <20230113165548.2692720-5-vladbu@nvidia.com>
 <Y8a+qBjcr7KuPf+e@t14s.localdomain>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>, <ozsh@nvidia.com>,
        <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v2 4/7] netfilter: flowtable: allow updating
 offloaded rules asynchronously
Date:   Tue, 17 Jan 2023 19:33:31 +0200
In-Reply-To: <Y8a+qBjcr7KuPf+e@t14s.localdomain>
Message-ID: <875yd5cbcl.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT021:EE_|BL3PR12MB6569:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e505e6b-5445-41ab-bbad-08daf8b15c08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NCkf1EbHUS5DJGx8gNhG6khoKw1YK3yNuqgo6PSYehvBJtlsWDTQip81QFNeZ6EAL/rYaFxFRCBaP4CDuz80/0BG6OMnUFpkborpgfq4C7bWKFTiQ2dyHyL2geq8vZ8Db8fuxsWurFJV7FFyy7INYbpfBCb3UZBXj1UnmSCX/m21Xgecs2oQaI7JyadKm5gggNHYrmq+JBv1kAeG4Q/TsydIg8pJVbmj2nOeEnx/4IDQ5/Uz/5A3lzV6eregHunT5IYKyCN2vMK0Dubj8Dfq41uBt6VWL5b8VzfnLUo9BGymO6BYE/MYNisccLj9IjqaNtsjoJTIEi3TYIHDWj2aJ1pfa2ovG46xw9j8Wch9U6kk6MAa4+ZnKmc4E0mXmSBIg2mSSxUrIdD/zg+mvODLPZ5SRTYspdDEULX/PuIJeaUz6RxysmLrOXolTwvVPBZ/Nk69hIAL14Y5+qKxGMcf1mO6ylriK0KtvBOaeVluljRPGBwfyWhdf1ae98via3J2vOlSXKMK085FpS7q41LnsGfmYwdGmar5PKWbPHh5iL5EcqdIb5CEoP2QK4453kJ6MCLekRoFrl6gbaB7k4lNt0rQ7QSp1qUnuO4tWIRQPo6QMU62VrozAdmY/9lJsKt5vfnOT3b2RpggWTKB05xptF1OKmvJuBzwISls6phVNIzT+tRUFbq8rEuglp0OSTWTehFr/gLoc6VaKGWmrVfddQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(39860400002)(136003)(376002)(451199015)(40470700004)(36840700001)(46966006)(83380400001)(82310400005)(40460700003)(54906003)(16526019)(7696005)(36756003)(478600001)(40480700001)(186003)(7636003)(356005)(36860700001)(2616005)(47076005)(82740400003)(86362001)(336012)(426003)(41300700001)(2906002)(26005)(6666004)(70206006)(8936002)(70586007)(6916009)(8676002)(4326008)(7416002)(316002)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 17:36:26.1447
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e505e6b-5445-41ab-bbad-08daf8b15c08
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6569
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 17 Jan 2023 at 12:28, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> On Fri, Jan 13, 2023 at 05:55:45PM +0100, Vlad Buslov wrote:
>> Following patches in series need to update flowtable rule several times
>> during its lifetime in order to synchronize hardware offload with actual ct
>> status. However, reusing existing 'refresh' logic in act_ct would cause
>> data path to potentially schedule significant amount of spurious tasks in
>> 'add' workqueue since it is executed per-packet. Instead, introduce a new
>> flow 'update' flag and use it to schedule async flow refresh in flowtable
>> gc which will only be executed once per gc iteration.
>> 
>> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
>> ---
>>  include/net/netfilter/nf_flow_table.h |  3 ++-
>>  net/netfilter/nf_flow_table_core.c    | 20 +++++++++++++++-----
>>  net/netfilter/nf_flow_table_offload.c |  5 +++--
>>  3 files changed, 20 insertions(+), 8 deletions(-)
>> 
>> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
>> index 88ab98ab41d9..e396424e2e68 100644
>> --- a/include/net/netfilter/nf_flow_table.h
>> +++ b/include/net/netfilter/nf_flow_table.h
>> @@ -165,6 +165,7 @@ enum nf_flow_flags {
>>  	NF_FLOW_HW_DEAD,
>>  	NF_FLOW_HW_PENDING,
>>  	NF_FLOW_HW_BIDIRECTIONAL,
>> +	NF_FLOW_HW_UPDATE,
>>  };
>>  
>>  enum flow_offload_type {
>> @@ -300,7 +301,7 @@ unsigned int nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
>>  #define MODULE_ALIAS_NF_FLOWTABLE(family)	\
>>  	MODULE_ALIAS("nf-flowtable-" __stringify(family))
>>  
>> -void nf_flow_offload_add(struct nf_flowtable *flowtable,
>> +bool nf_flow_offload_add(struct nf_flowtable *flowtable,
>>  			 struct flow_offload *flow);
>>  void nf_flow_offload_del(struct nf_flowtable *flowtable,
>>  			 struct flow_offload *flow);
>> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
>> index 04bd0ed4d2ae..5b495e768655 100644
>> --- a/net/netfilter/nf_flow_table_core.c
>> +++ b/net/netfilter/nf_flow_table_core.c
>> @@ -316,21 +316,28 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
>>  }
>>  EXPORT_SYMBOL_GPL(flow_offload_add);
>>  
>> +static bool __flow_offload_refresh(struct nf_flowtable *flow_table,
>> +				   struct flow_offload *flow)
>> +{
>> +	if (likely(!nf_flowtable_hw_offload(flow_table)))
>> +		return true;
>> +
>> +	return nf_flow_offload_add(flow_table, flow);
>> +}
>> +
>>  void flow_offload_refresh(struct nf_flowtable *flow_table,
>>  			  struct flow_offload *flow)
>>  {
>>  	u32 timeout;
>>  
>>  	timeout = nf_flowtable_time_stamp + flow_offload_get_timeout(flow);
>> -	if (timeout - READ_ONCE(flow->timeout) > HZ)
>> +	if (timeout - READ_ONCE(flow->timeout) > HZ &&
>> +	    !test_bit(NF_FLOW_HW_UPDATE, &flow->flags))
>>  		WRITE_ONCE(flow->timeout, timeout);
>>  	else
>>  		return;
>>  
>> -	if (likely(!nf_flowtable_hw_offload(flow_table)))
>> -		return;
>> -
>> -	nf_flow_offload_add(flow_table, flow);
>> +	__flow_offload_refresh(flow_table, flow);
>>  }
>>  EXPORT_SYMBOL_GPL(flow_offload_refresh);
>>  
>> @@ -435,6 +442,9 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
>>  		} else {
>>  			flow_offload_del(flow_table, flow);
>>  		}
>> +	} else if (test_and_clear_bit(NF_FLOW_HW_UPDATE, &flow->flags)) {
>> +		if (!__flow_offload_refresh(flow_table, flow))
>> +			set_bit(NF_FLOW_HW_UPDATE, &flow->flags);
>>  	} else if (test_bit(NF_FLOW_HW, &flow->flags)) {
>>  		nf_flow_offload_stats(flow_table, flow);
>
> AFAICT even after this patchset it is possible to have both flags set
> at the same time.
> With that, this would cause the stats to skip a beat.
> This would be better:
>
> - 	} else if (test_bit(NF_FLOW_HW, &flow->flags)) {
> - 		nf_flow_offload_stats(flow_table, flow);
> +	} else {
> +		if (test_and_clear_bit(NF_FLOW_HW_UPDATE, &flow->flags))
> +			if (!__flow_offload_refresh(flow_table, flow))
> +				set_bit(NF_FLOW_HW_UPDATE, &flow->flags);
> +	 	if (test_bit(NF_FLOW_HW, &flow->flags))
> + 			nf_flow_offload_stats(flow_table, flow);
>  	}
>
> But a flow cannot have 2 pending actions at a time.

Yes. And timeouts are quite generous so there is IMO no problem in
skipping one iteration. It is not like this wq is high priority and we
can guarantee any exact update interval here anyway.

> Then maybe an update to nf_flow_offload_tuple() to make it handle the
> stats implicitly?

I considered this, but didn't want to over-complicate this series which
is tricky enough as it is.

>
>>  	}
>> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
>> index 8b852f10fab4..103b2ca8d123 100644
>> --- a/net/netfilter/nf_flow_table_offload.c
>> +++ b/net/netfilter/nf_flow_table_offload.c
>> @@ -1036,16 +1036,17 @@ nf_flow_offload_work_alloc(struct nf_flowtable *flowtable,
>>  }
>>  
>>  
>> -void nf_flow_offload_add(struct nf_flowtable *flowtable,
>> +bool nf_flow_offload_add(struct nf_flowtable *flowtable,
>>  			 struct flow_offload *flow)
>>  {
>>  	struct flow_offload_work *offload;
>>  
>>  	offload = nf_flow_offload_work_alloc(flowtable, flow, FLOW_CLS_REPLACE);
>>  	if (!offload)
>> -		return;
>> +		return false;
>>  
>>  	flow_offload_queue_work(offload);
>> +	return true;
>>  }
>>  
>>  void nf_flow_offload_del(struct nf_flowtable *flowtable,
>> -- 
>> 2.38.1
>> 

