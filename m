Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB8666E508
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 18:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235338AbjAQRdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 12:33:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235566AbjAQRaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 12:30:18 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852554C6DE;
        Tue, 17 Jan 2023 09:27:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IHmLzc/n1taKkOltt6K4WAfjMpKIHdJgpeXBTa8eU6V4eG3Yclqnzf/tZYhZDaG47GbdGjRxabYFvdkpUXfIeE30n2DQM9DTQjM+e6uh/t0wGZtbjJw+Ws+bI70XvR8OF+H+8elcGSWhhscjkfWylVI/DKjjLy4mXaWnAAszxtnx5lDMuBU3Rbw+e3KM4Nm0axNYV1op0VxITTu8X5x1dz+/ogaqQsA5Tl2n4TKfI7NyRxcakfJ0ODNqy8agULCsN1AwnHByFdU/7adA/PB6y6PiR1LrPOjuYVNWD8qEMylap5dU1x6Ohh4sjHHgILlNUuGoy16/RieXuFUWdsNQeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4x6M4+dekKbcm3sCP84hC06EXeH0mFsqZheJoR+HO+4=;
 b=kTSsLy/Y24KRVVfB6k0gakvsfMc0E1t76PYnV+dpJ6XCjbDz8HuIvNm14lOl2VMNHK8jcVS2SjhsnSIarULaPNpcX7dEuhl/k3hl8NhpIFpF5+HRzsIpRpIAxiIaPa+AYO9sI4JuGtCA/QOZewB4qWLLyHMP//g9CNc/mMxwNu+pC23gYneqahF5CvqK3gyD1g2DfB2+w1F007067i9T+lZQU9r7G2Rpll6NEHtmjN+u0CF3wJM4w9yZFosVXRJQb/G3hPXThTmd897Lnivgre7AEAJ7K8lcfeNkNKk+08qNQ+64xz206wk72L5Jax3alBvZoQ5za+j26P42l+CvLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4x6M4+dekKbcm3sCP84hC06EXeH0mFsqZheJoR+HO+4=;
 b=FrcmMDQWNibYz1YPOlnJMcrPzLB4bqG6NbkSiuDWoWvlcYPAvBseEV6lr/mH58Z1ltZsmsEY5vmYN3ckFy/uCipbnBmIdiNU+PkG2acI/Nr8tdQP/+lQzSxNTm98K63so9hJWiQp1jhVvVaWxLhcyP4844MYzcWnr3St4oKzk9zqNpW2C4J5+QFI8jr72WOYy8dceL31RJdXKjFgMPqIj/9EA45dDgQFibco7G4GL714NuZ6yknA0stVw9CjoSkcKoQiHobDAAO3i6eY0bLuQvoN8pbyU+wNvRrtE8TLBTQj3wB09VsaDOiqUydmePyvp7h/18OvuPC/2bXKB4GZqA==
Received: from MW4PR03CA0141.namprd03.prod.outlook.com (2603:10b6:303:8c::26)
 by PH8PR12MB6699.namprd12.prod.outlook.com (2603:10b6:510:1ce::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.22; Tue, 17 Jan
 2023 17:27:51 +0000
Received: from CO1NAM11FT084.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8c:cafe::99) by MW4PR03CA0141.outlook.office365.com
 (2603:10b6:303:8c::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.19 via Frontend
 Transport; Tue, 17 Jan 2023 17:27:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT084.mail.protection.outlook.com (10.13.174.194) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Tue, 17 Jan 2023 17:27:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 17 Jan
 2023 09:27:39 -0800
Received: from fedora.nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 17 Jan
 2023 09:27:36 -0800
References: <20230113165548.2692720-1-vladbu@nvidia.com>
 <20230113165548.2692720-2-vladbu@nvidia.com>
 <Y8a5AOxlm5XsrYtT@t14s.localdomain>
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
Date:   Tue, 17 Jan 2023 19:25:35 +0200
In-Reply-To: <Y8a5AOxlm5XsrYtT@t14s.localdomain>
Message-ID: <87ilh5cbqx.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT084:EE_|PH8PR12MB6699:EE_
X-MS-Office365-Filtering-Correlation-Id: 364e4af2-2296-41d2-a1d0-08daf8b028da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tqrt2+hXHkR4AsjtVmfDaRb5J4jhERuJopWR8MDC8bAj7lIb+vIsVaProsVvMG+v9Ti1eGJ0XalnS20nu+ZNhigtFTJcRgSgLq/4ZIqXgY03CM84wvxbdLhggi3xsNBFpflAzjJi1cWk1uDFxwiYWTya+KZfCxNhwLxXKEBn8woVGsP5B06cbWokquoiphKnSHbkMzWRvS1S/r8vzoIlqxysALBMd6Ly3x0s9/kH3VgRCSjdaudLKRNqFY77px8QiqQoBUoZwZcZx748Rtbi4EXza032vkYwPNGWmmeu51WHYo3JvygKuYsjf8eE9c+FOQ9J9hC3onk5oH5oyml6dB7+5ZA6nfey1XkegS/dNWRX9dvemEZt2KK6dQ+kcehDK1//kpfvPxtbfsFqT9XU6plDrxoEBQ1rejQyUFG7dnsKdNiojwJ6GdiKbiBx/MP2rCf40p97Q1Gs+iqD/T81TeLbaUisju07QjdXjwVqvkyyEaPljTv4GrOg6h1WvR1XbCrVVxkOU8xeuB7Yp75rI0BJKEzrXi0YCr+Gt8+jpJ7XBYA92m+RzOM//EiXKUYyYnhusv3Q3GgsYOIrOWMPeWIXOue3EWIcoKb8comgeA1WSrVGzX5nTRt8bhUnteNb6ttbXBgR0nCIY8V1tYTEvWID/rYHU3ke/Hw0fvXYO9xVOMKWjR4+7saAlnYXuk6DnU+y31sE+GMaf3cNCXCJNw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(346002)(136003)(451199015)(40470700004)(46966006)(36840700001)(2906002)(70586007)(4326008)(26005)(6916009)(40460700003)(8676002)(70206006)(36756003)(82310400005)(41300700001)(316002)(186003)(356005)(36860700001)(16526019)(83380400001)(2616005)(47076005)(336012)(426003)(86362001)(54906003)(40480700001)(7636003)(7696005)(82740400003)(478600001)(5660300002)(8936002)(7416002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 17:27:50.8758
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 364e4af2-2296-41d2-a1d0-08daf8b028da
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT084.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6699
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcelo,

Thanks for reviewing!

On Tue 17 Jan 2023 at 12:04, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> On Fri, Jan 13, 2023 at 05:55:42PM +0100, Vlad Buslov wrote:
> ...
>>  struct flow_match {
>> @@ -288,6 +289,7 @@ struct flow_action_entry {
>>  		} ct;
>>  		struct {
>>  			unsigned long cookie;
>> +			enum ip_conntrack_info ctinfo;
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
>                                                    ^^^^^^^^^^^
>
>>  	entry->ct_metadata.orig_dir = dir == IP_CT_DIR_ORIGINAL;
>> +	entry->ct_metadata.ctinfo = ctinfo;
>
> tcf_ct_flow_table_restore_skb() is doing:
>         enum ip_conntrack_info ctinfo = cookie & NFCT_INFOMASK;
>
> Not sure if it really needs this duplication then.

Indeed! I wanted to preserve the cookie as opaque integer (similar to TC
filter cookie), but since drivers are already aware about its contents
we can just reuse it for my case and prevent duplication.

>
>>  
>>  	act_ct_labels = entry->ct_metadata.labels;
>>  	ct_labels = nf_ct_labels_find(ct);
>> -- 
>> 2.38.1
>> 

