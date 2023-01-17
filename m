Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08E8966E566
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 18:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbjAQR4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 12:56:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232179AbjAQRyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 12:54:19 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2044.outbound.protection.outlook.com [40.107.93.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8782ED49;
        Tue, 17 Jan 2023 09:45:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PNSpsRWW9IcCxbnSaXpA0DWUvQjPhn+DSgwHu0ixDotHJUJtQwVmKhrbiQXD31B+hfOF2exgQzjP8mQIlBkGmVeyzidQTu6T5zK9jKMQNSxV8qPmozlggTavgxq4VhOK6/7JQ9l4wcj21t36CQSXGqyYfroOh42DYzcP10DNq2Eq8iQgKlqlYSoho3LGTf8awr7X4u0w79hEXy2CD2iDIpGg68RH+xUc1kcyNd+tDWQ/pfL/DmrQaq/fBusLk8fMQu0HNbSCDwAY9dK9gV2Zruios6VIcLwd2CTdNGhDHe3lxUEqX5wAXef8GsIozqMDkG30YJA32u8z8PGZ3W8N0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z4sdRWZ2mS5H8QnVJBMSTDtLYzeLNB8Vwmqcc7KJnP8=;
 b=HF7BF/PT6DU/j8s7Bye2ZVcscgClhViYkYF2jIRJoiRvWepG7StPTniIib2nVx0Cs2XVUv8jyWVOb7Bm4/689zTwerqIEY8dZmE9bUp56QhD96WeU/w+vPolH125Cmwo+tdljBt0Qzc/cqOzokcdrI3yzbkLygv4MQWEM8qymMl7115D/MtQih+1Vo+Z2QV0WDu8vCCfvdsoEzDdr4cNaRKjVMxaeekjooUUAMHOpFSt0IgEMBm6jLcyyqQ2TSHDNzwPTfTXKeL6C+2tGVdcBuAaRTKIltDcQF8f80LLEojgDH2eCSwO0KGCzSBXcNBZuBkGlhqXf9HgW5LeISs/hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4sdRWZ2mS5H8QnVJBMSTDtLYzeLNB8Vwmqcc7KJnP8=;
 b=ruaB9HEavynNB+CTYw2LB0o4TZF1pftprROaTjLNh4va6f8cWFNHosV3n6te2OaIDEsqwWfZHzFLImfiSSBSfEiJfK1By6eulbrn2sL+jp6l89PreVyzSUnMfVL41n8tua+SxRbmEpviZvZyWrIy5NcwAqUKMSw4YAc1JzJtbvjToM05sjW72jnc8q7JeahqFfJ1ahJJO98liEuiQft40pLtLj7NbaVAHI4Ti8o8wwbyYUxF5zUHDwCvcQjXPxKTrB1oltWHCGMphDSURR7kAU9k1qPzz4D8SnYlwqzFc8sm4mFVUdCAFhIoGL4XuoNV47ji0QQNmAOeq1zHrJWtZg==
Received: from DS7PR06CA0023.namprd06.prod.outlook.com (2603:10b6:8:2a::14) by
 BL3PR12MB6428.namprd12.prod.outlook.com (2603:10b6:208:3b7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Tue, 17 Jan
 2023 17:45:13 +0000
Received: from DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2a:cafe::4d) by DS7PR06CA0023.outlook.office365.com
 (2603:10b6:8:2a::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.19 via Frontend
 Transport; Tue, 17 Jan 2023 17:45:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT068.mail.protection.outlook.com (10.13.173.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Tue, 17 Jan 2023 17:45:13 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 17 Jan
 2023 09:45:02 -0800
Received: from fedora.nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 17 Jan
 2023 09:44:59 -0800
References: <20230113165548.2692720-1-vladbu@nvidia.com>
 <20230113165548.2692720-2-vladbu@nvidia.com> <Y8az5ecHLgE611hJ@salvia>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v2 1/7] net: flow_offload: provision conntrack
 info in ct_metadata
Date:   Tue, 17 Jan 2023 19:43:35 +0200
In-Reply-To: <Y8az5ecHLgE611hJ@salvia>
Message-ID: <87wn5lawdi.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT068:EE_|BL3PR12MB6428:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e387cf6-6ef9-432a-7320-08daf8b2964c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KcvGJzAAw1+lOLxgP/3nAfuUy6jRGmzz4pytm1sf7wDnITQzhoSFC/HxfM9rTMM/LyX9okD7Ewt8cMrScylfTtGDNZGAxFt/6P8NtWhlqvpiMYGUajoUAcpe5wr3N007UvyiK4k4tOYfh3dYtO1FloeuxLb2uHVDe2spVEG04ZdyOIGUVYlboc1pBaDM6VrEA87Wq1uyHoJX4/DEQ36TT1pVO1n72iegktCAXGDZHn3fLUa9PsCk7v46QIYdswbkxSRvebJYxoLH+1Wt9yY1f2x5QdtORYg4K+W9z2PLBSPPC0sNqhxo+Aec08WR5bhD0a0uIwGNuBw2MspGn94vXgYxZ0I3drBafWJGOpu7n/Mit7LhkOmRoS4ypWF97dLqALzjRFB4vNEsb4r5aZnoL469qR13+ksGXEl3vQOuYYtkebvo4YB088lVCuN5kqWKDKsicuYmwh/mubxEHEGjR5MoPPGHvNEgNOpjGDV/zlHVPv+WEULTH6uRVTz511bLN5j+4tCAV7fuiTbimUxzR6wsturIwnDmk2B5dbPkwXIdDeyDqs0Q2Gdi4fidh3xD6fGlaVHDqhrsClQLUoCf6wGbZgrhnIRq72j38aUZ1DhQFYsZTFS/JUpxLhWWjX/PioMpJSyqOCI53w/X2mFd/dURygdrgVsxP464Q63lGxRil56c5IqmsZNC7d5vHRGDq7uVNBOEuwGnrBMpPjYiNg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(346002)(136003)(451199015)(46966006)(36840700001)(40470700004)(36756003)(86362001)(356005)(8676002)(70206006)(2906002)(4326008)(70586007)(5660300002)(6916009)(7416002)(8936002)(36860700001)(82740400003)(83380400001)(7636003)(7696005)(478600001)(54906003)(316002)(6666004)(40460700003)(40480700001)(82310400005)(41300700001)(2616005)(47076005)(26005)(16526019)(186003)(336012)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 17:45:13.4243
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e387cf6-6ef9-432a-7320-08daf8b2964c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6428
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 17 Jan 2023 at 15:42, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Vlad,
>
> On Fri, Jan 13, 2023 at 05:55:42PM +0100, Vlad Buslov wrote:
>> In order to offload connections in other states besides "established" the
>> driver offload callbacks need to have access to connection conntrack info.
>> Extend flow offload intermediate representation data structure
>> flow_action_entry->ct_metadata with new enum ip_conntrack_info field and
>> fill it in tcf_ct_flow_table_add_action_meta() callback.
>> 
>> Reject offloading IP_CT_NEW connections for now by returning an error in
>> relevant driver callbacks based on value of ctinfo. Support for offloading
>> such connections will need to be added to the drivers afterwards.
>> 
>> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
>> ---
>> 
>> Notes:
>>     Changes V1 -> V2:
>>     
>>     - Add missing include that caused compilation errors on certain configs.
>>     
>>     - Change naming in nfp driver as suggested by Simon and Baowen.
>> 
>>  .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |  2 +-
>>  .../ethernet/netronome/nfp/flower/conntrack.c | 20 +++++++++++++++++++
>>  include/net/flow_offload.h                    |  2 ++
>>  net/sched/act_ct.c                            |  1 +
>>  4 files changed, 24 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
>> index 313df8232db7..8cad5cf3305d 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
>> @@ -1077,7 +1077,7 @@ mlx5_tc_ct_block_flow_offload_add(struct mlx5_ct_ft *ft,
>>  	int err;
>>  
>>  	meta_action = mlx5_tc_ct_get_ct_metadata_action(flow_rule);
>> -	if (!meta_action)
>> +	if (!meta_action || meta_action->ct_metadata.ctinfo == IP_CT_NEW)
>>  		return -EOPNOTSUPP;
>>  
>>  	spin_lock_bh(&ct_priv->ht_lock);
>> diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
>> index f693119541d5..f7569584b9d8 100644
>> --- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
>> +++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
>> @@ -1964,6 +1964,23 @@ int nfp_fl_ct_stats(struct flow_cls_offload *flow,
>>  	return 0;
>>  }
>>  
>> +static bool
>> +nfp_fl_ct_offload_nft_supported(struct flow_cls_offload *flow)
>> +{
>> +	struct flow_rule *flow_rule = flow->rule;
>> +	struct flow_action *flow_action =
>> +		&flow_rule->action;
>> +	struct flow_action_entry *act;
>> +	int i;
>> +
>> +	flow_action_for_each(i, act, flow_action) {
>> +		if (act->id == FLOW_ACTION_CT_METADATA)
>> +			return act->ct_metadata.ctinfo != IP_CT_NEW;
>> +	}
>> +
>> +	return false;
>> +}
>> +
>>  static int
>>  nfp_fl_ct_offload_nft_flow(struct nfp_fl_ct_zone_entry *zt, struct flow_cls_offload *flow)
>>  {
>> @@ -1976,6 +1993,9 @@ nfp_fl_ct_offload_nft_flow(struct nfp_fl_ct_zone_entry *zt, struct flow_cls_offl
>>  	extack = flow->common.extack;
>>  	switch (flow->command) {
>>  	case FLOW_CLS_REPLACE:
>> +		if (!nfp_fl_ct_offload_nft_supported(flow))
>> +			return -EOPNOTSUPP;
>> +
>>  		/* Netfilter can request offload multiple times for the same
>>  		 * flow - protect against adding duplicates.
>>  		 */
>> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
>> index 0400a0ac8a29..a6adaffb68fb 100644
>> --- a/include/net/flow_offload.h
>> +++ b/include/net/flow_offload.h
>> @@ -4,6 +4,7 @@
>>  #include <linux/kernel.h>
>>  #include <linux/list.h>
>>  #include <linux/netlink.h>
>> +#include <linux/netfilter/nf_conntrack_common.h>
>>  #include <net/flow_dissector.h>
>>  
>>  struct flow_match {
>> @@ -288,6 +289,7 @@ struct flow_action_entry {
>>  		} ct;
>>  		struct {
>>  			unsigned long cookie;
>> +			enum ip_conntrack_info ctinfo;
>
> Maybe you can use a bool here, only possible states that make sense
> are new and established.

As Marcelo suggested we can just obtain same info from the cookie, so
there is no need for adding either ctinfo or a boolean here.

>
>>  			u32 mark;
>>  			u32 labels[4];
>>  			bool orig_dir;
>> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
>> index 0ca2bb8ed026..515577f913a3 100644
>> --- a/net/sched/act_ct.c
>> +++ b/net/sched/act_ct.c
>> @@ -187,6 +187,7 @@ static void tcf_ct_flow_table_add_action_meta(struct nf_conn *ct,
>>  	/* aligns with the CT reference on the SKB nf_ct_set */
>>  	entry->ct_metadata.cookie = (unsigned long)ct | ctinfo;
>>  	entry->ct_metadata.orig_dir = dir == IP_CT_DIR_ORIGINAL;
>> +	entry->ct_metadata.ctinfo = ctinfo;
>>  
>>  	act_ct_labels = entry->ct_metadata.labels;
>>  	ct_labels = nf_ct_labels_find(ct);
>> -- 
>> 2.38.1
>> 

