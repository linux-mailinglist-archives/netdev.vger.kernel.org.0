Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67180669D97
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 17:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjAMQXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 11:23:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbjAMQXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 11:23:04 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3836282FA1;
        Fri, 13 Jan 2023 08:17:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a0Dx+rNfZANFn9r8KMVFAKM/bN/0Shdbpgj0WPPDS4p1WIQDdBYUglSr8YIXICdoSiKWIcX8jcRo74ZNijmZt7jz7UKzElrYxJ3ofZA54Bvo9yjzvU5B1QHkF5jaAVFVUm9AJs4XZK5XeqdF1Ub8n8EaloVZfaWCfHgepji5bRXhA86B3TzcP/SNTbCj5Nn+i2wH0KSZEUrPldTkbhRRDL9HUUuOWNji/ZcsrlP+Gizrx4vlfP11PXDCMiZGfaUC8pEDTCZzJD2mbNyLO0097VwtCKLMK4zyaS197t3kXHKe0W9Qk7s+Fe+HGIGEP8LB+3cS1v4CNOJCYbjRUk1PVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1j71EpxK4BnlovmwaU7LhilO61nIzRbIciR5ytVKevw=;
 b=EBRWpJelJQU2mpTpTb25jugbkBI4ebQqIQ4T6g7RG9NzPpm9uW7kC12DHBab0iE1Jg7WYo1VwmUuNNvSm+Q9DyskwpJmrkzaB66jGszQiE13Z/yAEoKoMOVzSAZI4372b4ktxrgDsJ7xf4Iui/1wBdRUZt3r06G/903p9D3yKmfUP2hgfp2w5aqLCHqEDIuBv3/2ESoF92OL6GGpqaJ3tQqZYmHD7j2B3Z0uUPrFXhUsvwwTBH/smI5H9YpbKVPicTY5Enbi+xD/jR5gg1O/MfXR31qBULPZd2ysL8JOzk2YGEe+73yQd0fzRWGmSIjWwToiNJ+mbbykfu/3wgCnjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1j71EpxK4BnlovmwaU7LhilO61nIzRbIciR5ytVKevw=;
 b=FRlgQRaGaABNCRf3F0W0sbaWa/4CLIX4yq0DFsVkvTUR640h82GcE55RrVaLf+5m2fmktYVF4ANCYYGsaPSUEOFBJlv8xLKoV/Dcr0cUbwUaU9JmWaU8zL4TZzAOoGFDAtZoWcC08wVLSm4/PbbpVu74AD0G/Tu9+VGqAS244LyXxfhy+Wl1zcVZ2CbjclGBDc+ivCZALR/X/3J+793gr5VWlqIBVbMMvqkB5k24/62dqPjF31RnK8/7XpQdTzOSFfF1Bp4pg7QGgktBhmuTdCk/SWEfVJNQEiPhQoDYLRk5tC9PGAZ8dNY6BkLZLx1tiPdvNwxt4ehn8tfP4BPOKg==
Received: from BN0PR02CA0028.namprd02.prod.outlook.com (2603:10b6:408:e4::33)
 by DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.19; Fri, 13 Jan
 2023 16:17:34 +0000
Received: from BL02EPF000108EA.namprd05.prod.outlook.com
 (2603:10b6:408:e4:cafe::60) by BN0PR02CA0028.outlook.office365.com
 (2603:10b6:408:e4::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.14 via Frontend
 Transport; Fri, 13 Jan 2023 16:17:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF000108EA.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.11 via Frontend Transport; Fri, 13 Jan 2023 16:17:33 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 08:17:18 -0800
Received: from fedora.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 08:17:14 -0800
References: <20230110133023.2366381-1-vladbu@nvidia.com>
 <20230110133023.2366381-2-vladbu@nvidia.com>
 <Y8EghrLt1rtcYSv/@corigine.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>, <ozsh@nvidia.com>,
        <marcelo.leitner@gmail.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        <oss-drivers@corigine.com>
Subject: Re: [PATCH net-next v1 1/7] net: flow_offload: provision conntrack
 info in ct_metadata
Date:   Fri, 13 Jan 2023 18:15:55 +0200
In-Reply-To: <Y8EghrLt1rtcYSv/@corigine.com>
Message-ID: <875yda4dfc.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108EA:EE_|DM4PR12MB5070:EE_
X-MS-Office365-Filtering-Correlation-Id: 5666007a-1619-4fc3-668f-08daf581ad9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YEt4yX0XsvSo34Hbda6CZyMrcFBp+KA66vYpiq2lMXfdIeDdYzg0jCVp9Fg0psMYlTP2xGId0xBlW6j0mlHQ48deLaS0pz02cdtBOs/JMcbUEcwiH/nLbe/XQ0N/9Yj4JUAMIbGv6CoWZ9mQY9AjTqnuify6bmtbKWflFFgInEqo9zSjjYnQ+zVikv3PMmjws1b0kXnwRPSdhPG1FXkkBedHioElglHIZDrity6CI+KQgAlMydse5NB2btwJG2r4c2Fd7MrwoBulpEIgcBA3BFPJmgOYl+wOinjpal5OQIk9vs4MwZp7b+BVa23c1WfJl09Aanp4tf4/sx8v4bOLmw7Lvr7NL7Eia0vRP4/Ene2emDulBIfigDtGtFIXXjsqvIq/B4OQUjk+JnmOFCYJCUqGpvHdUZjV0sWFCP6quDlxOja1S7sMoF+nC2sYYK04upB74C2KJ6YWrYRMhUS8AhDASd/VnB/nVXQ6bttm4TA+4IBswOTbtovRIPJR0Un6/cd0Ch/YbOw+EBGaujvHMyRGX5vyX1rm47x0q6tCM+h6cRcP5Z/4zPV30IripRjSJbC+GEPeluSSMX+mN+eeDxboj8n33qTMal3+egRWPuA/Q6ri7x4Nuij97MIgV+1BgiGrGZdjawHEgueyZ4XUUttmxZ2l9L6B1Yx43sHROgLbiAE/PFDhdcs42Tdch8us
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(376002)(346002)(39860400002)(451199015)(46966006)(40470700004)(36840700001)(8936002)(6666004)(8676002)(70206006)(41300700001)(70586007)(6916009)(4326008)(54906003)(316002)(82310400005)(2616005)(36756003)(2906002)(7416002)(40460700003)(5660300002)(36860700001)(40480700001)(86362001)(26005)(7696005)(82740400003)(478600001)(16526019)(356005)(186003)(7636003)(336012)(47076005)(426003)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 16:17:33.6609
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5666007a-1619-4fc3-668f-08daf581ad9c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108EA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5070
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 13 Jan 2023 at 10:12, Simon Horman <simon.horman@corigine.com> wrote:
> + Baowen Zheng, oss-drivers@corigine.com
>
> On Tue, Jan 10, 2023 at 02:30:17PM +0100, Vlad Buslov wrote:
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
>
> ...
>
>> diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
>> index f693119541d5..2c550a1792b7 100644
>> --- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
>> +++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
>> @@ -1964,6 +1964,23 @@ int nfp_fl_ct_stats(struct flow_cls_offload *flow,
>>  	return 0;
>>  }
>>  
>> +static bool
>> +nfp_fl_ct_offload_supported(struct flow_cls_offload *flow)
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
>
> Hi Vlad,
>
> Some feedback from Baowen Zheng, who asked me to pass it on here:
>
>   It is confusing that after FLOW_ACTION_CT_METADATA check, this functoin
>   will return false, that is -EOPNOTSUPP.
>
>   Since this function is only used to check nft table, It seems better to
>   change its name to nfp_fl_ct_offload_nft_supported(). This would make things
>   clearer and may avoid it being used in the wrong way.

Thanks for the suggestions! I will change the naming and send V2.

