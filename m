Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA8F366E517
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 18:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbjAQRi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 12:38:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235419AbjAQReb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 12:34:31 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B70DC4900C;
        Tue, 17 Jan 2023 09:31:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kj61nb3jEREMbrQJtH93USjVE81cH2OSMNGCFFQjAONlBStMdl032AT1DcrOjME7n2oqnR2WR1BQEuHiRhFEluGC6t/FGw/bR/smvYYIET5rAp9fLxyMVaiBrAoXI61VfZWsDsG4UspupPwdAQZKNdwyuxz1PTqyjTJlTuncW2825ByABGsZhc8UYrOH4Vm3LwoTw2A8DEW/SmwjUbePrGzhuIzvAoMRmxe2wSUWtF3Mrgokcei2vee5WZkZbXtjyxf/uqXmzERTHPhsMoZWuM0CLr1Rw/6H7jAIgymslBrjql+8I+697V6kNFVh3D2jTD4c//uK/tcOd/Jd9OdnUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=20Hwt6TALUZrWw7iHid6Hpe4SqodkSHerxP9rIRw+hY=;
 b=ai5DP+551OkZ74arfCpp0qGOR1BdpT7gXhUC2WX6VQbydLl//kSKcdHlo8HNbXxLfxinRwMDcbD2veqZKivkP4XE7okmre4WRy7iw8v/1suGh2JrNZj6Wqk9lxNXXLT5PghK2lA2A9DuTw6WkZD7ebd9uqy86bAcTpIw3D7oDvopZCuULDkbbS4pLRtNATMgxn4WOceRiofTbBCfcwMpQMo+/ux5nDYLjZ8zzf3XGNmuTJRpgV1DLwqq3okd1RXYXD993hfQFTxwfMI44bC0Ksm4HKZJmnbVms6I6RO7uBfcKobtZX3Hw/2SqWBv5OOlYgozAW93R2SxOvj0EE0mCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=20Hwt6TALUZrWw7iHid6Hpe4SqodkSHerxP9rIRw+hY=;
 b=Tw+uHmuzmqLzrHFhMRzOo12NmDE4Inw2xMtR9t5nvJWD8safuVRxUdSQamYjLfdNANQsFAJ4vDdQzwExabrdgPEWa4t+FHwh4mG+ZXUBp0rGILSwAKzd+mqM48aLEeoRFdYzdWpRlnSRjySun3zYL3Qs/LKULC7K5HzbYgBYJ0pnON5RuwKHCP5yq1RWikAhqXCEAIjqDiLkOZogWWpbQ/VnVcowTkYl34Nlt/7MpGXL4Bf3RD+B8wtNi+CJjfDehJBDx1B0XDfHvyMUM01mf8VBkYzaQgJKw8vyDqpwvnlRzKvzxvFduHHZjH6YJLymHUpZXuA+vyxtvWtRtQpmwA==
Received: from BN9PR03CA0145.namprd03.prod.outlook.com (2603:10b6:408:fe::30)
 by MN0PR12MB5932.namprd12.prod.outlook.com (2603:10b6:208:37f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.22; Tue, 17 Jan
 2023 17:31:38 +0000
Received: from BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::29) by BN9PR03CA0145.outlook.office365.com
 (2603:10b6:408:fe::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.19 via Frontend
 Transport; Tue, 17 Jan 2023 17:31:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT005.mail.protection.outlook.com (10.13.176.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Tue, 17 Jan 2023 17:31:38 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 17 Jan
 2023 09:31:22 -0800
Received: from fedora.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 17 Jan
 2023 09:31:19 -0800
References: <20230113165548.2692720-1-vladbu@nvidia.com>
 <20230113165548.2692720-2-vladbu@nvidia.com>
 <Y8a5AOxlm5XsrYtT@t14s.localdomain> <Y8a6JCG6iUFTr1Q1@t14s.localdomain>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>, <ozsh@nvidia.com>,
        <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v2 1/7] net: flow_offload: provision conntrack
 info in ct_metadata
Date:   Tue, 17 Jan 2023 19:28:09 +0200
In-Reply-To: <Y8a6JCG6iUFTr1Q1@t14s.localdomain>
Message-ID: <87edrtcbks.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT005:EE_|MN0PR12MB5932:EE_
X-MS-Office365-Filtering-Correlation-Id: a52055fa-892a-411a-9de8-08daf8b0b065
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2QpTLZwIKsFJKv/bKT9RbBcyWlgeTEfjKbcNmwLyLDh8aJRmJiFmO2L3c9MiGIr0kjPvTyav6eGVExt08l5obKPN+9bKHJ32r9AqeeN2MRQC9P408CHZmuhQdtcn0I0pjeT41IgTFVinnefzMUmQMZXLwzMDjvnIumkDSi9ufp6+4KTAKscUcwojtRKifWTODPHdT6nPxDlGVkhWyaaV7iphykJbPXPBQm8Jm3RcLfQJAujYlFgGsQnwbpEqGyD9FI80c7t3ID1PrfC19yoQbJE892A8/LtLb15uftQs/dK5GTX0s6tbmRIHbivSe0A3Z35QFFOHHGwoazET5UfIZWjjzvY9HhCP/Q5SZXPvnxkGvPM4w9b15I7naf/FlSL4awkqrqQYM1jcMp1wCAeOpumgzKb/X9pOKrbJxZpNkXGvSuyvEx/AtFNqvDnu7teszvHYBxzK9REznohFDbuyLJMMS896zKTjF0urTQj/O445YQYbthL/IMaDcQl9R1VdiOZI1gwVLT4q/01rjgzyglr8X29YV32+GRjJS4Wn8oED/PMww0dBKY9SkLBI4YfV/lwUTOpogxitaUFonxDYeToMOX8yMlnwKNP0rjRJhCQYIrjQg34zCnqUp+9iFACZicXlvEx5T+KqosEJfllwyUWOgLZ16zdrds3GMbq6jbSnd+Pc8dg77DG6zfxwnQ62tn64mssoyQgffuiIxpNpfQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(346002)(136003)(451199015)(46966006)(36840700001)(40470700004)(54906003)(316002)(41300700001)(4326008)(336012)(26005)(70206006)(8676002)(70586007)(6916009)(36756003)(86362001)(83380400001)(82310400005)(47076005)(36860700001)(40480700001)(82740400003)(6666004)(478600001)(356005)(7636003)(7696005)(2616005)(186003)(16526019)(426003)(40460700003)(2906002)(8936002)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 17:31:38.1697
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a52055fa-892a-411a-9de8-08daf8b0b065
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5932
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 17 Jan 2023 at 12:09, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> On Tue, Jan 17, 2023 at 12:04:32PM -0300, Marcelo Ricardo Leitner wrote:
>> On Fri, Jan 13, 2023 at 05:55:42PM +0100, Vlad Buslov wrote:
>> ...
>> >  struct flow_match {
>> > @@ -288,6 +289,7 @@ struct flow_action_entry {
>> >  		} ct;
>> >  		struct {
>> >  			unsigned long cookie;
>> > +			enum ip_conntrack_info ctinfo;
>> >  			u32 mark;
>> >  			u32 labels[4];
>> >  			bool orig_dir;
>> > diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
>> > index 0ca2bb8ed026..515577f913a3 100644
>> > --- a/net/sched/act_ct.c
>> > +++ b/net/sched/act_ct.c
>> > @@ -187,6 +187,7 @@ static void tcf_ct_flow_table_add_action_meta(struct nf_conn *ct,
>> >  	/* aligns with the CT reference on the SKB nf_ct_set */
>> >  	entry->ct_metadata.cookie = (unsigned long)ct | ctinfo;
>>                                                    ^^^^^^^^^^^
>
> Hmm. Thought that just came up and still need to dig into, but wanted
> to share/ask already. Would it be a problem to update the cookie later
> on then, to reflect the new ctinfo?

Not sure I'm following, but every time the flow changes state it is
updated in the driver since new metadata is generated by calling
tcf_ct_flow_table_fill_actions() from nf_flow_offload_rule_alloc().

>
>> 
>> >  	entry->ct_metadata.orig_dir = dir == IP_CT_DIR_ORIGINAL;
>> > +	entry->ct_metadata.ctinfo = ctinfo;
>> 
>> tcf_ct_flow_table_restore_skb() is doing:
>>         enum ip_conntrack_info ctinfo = cookie & NFCT_INFOMASK;
>> 
>> Not sure if it really needs this duplication then.
>> 
>> >  
>> >  	act_ct_labels = entry->ct_metadata.labels;
>> >  	ct_labels = nf_ct_labels_find(ct);
>> > -- 
>> > 2.38.1
>> > 

