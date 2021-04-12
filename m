Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0764035BC16
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 10:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237299AbhDLI1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 04:27:03 -0400
Received: from mail-bn8nam08on2047.outbound.protection.outlook.com ([40.107.100.47]:39622
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237253AbhDLI1C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 04:27:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QIWCXn6WuRRJ/zDDNY2FBVF0IcyQef/OCwQFkjLLLNbJJwNB3ynRB1/J8cP4VIhpkF//ifGKIITXccIne7g5kDFwMCSb/sj6ZwlbogT1lI0+chKC2aqmiDsEc9psSZXb5pbkPXSlfoB/hBl5ZGX8feLoIe0pQavi1tFKS/N0aSef0BWh5FM8ysvNaJ08jKSTtzFzAzZCKcD+iw3pqlAnGMOuj4SqyucMQ86McTuWv8dNmz0qX86SvQOcUMwL99pRpKfMsLkH3P5Nwu+gS5mUtsa4rb7bL6ZezL1mmdZIcMar4vXMxrlQBLA4mA5gwJaHXvn1DaXve2KgWJ0jojZRUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0IBIiwzes8CyFnoBzv90Jm2u03rs1DNhLTTx2Qr/2+E=;
 b=huCmqByXUNB8VkJjcLOSxF13wb8xHx3kBYSt/j9oNh3e6BI2Ex4cem+sI7sQaQ4JirFKC9G6hzFsLm8/QllsOUyPAneIaEw4QXYwrLW5Et7n7sCS5WVekgBySEr904n9JFTN8iiIKc4hRXrFuXqDF5dTEDRekqF58iILpYWIM9UMhei45Tvlvp2ubj+6IKYkyVA2eoiDaS66N3wC//qLlF4khN9yFW6AVmVXOgK5hcpbK0eKdbFsA/OAflxX6pI51jitYqrv4fW9T0lIT63fBL1YO7RPRL4KkEcQeU4L8LCorVysjdX5WYFFtazR7EeCJ2JuZVC89Qi/aYct2Q5cog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0IBIiwzes8CyFnoBzv90Jm2u03rs1DNhLTTx2Qr/2+E=;
 b=m92Iw3pujtCM1CtzYv0qcr17Y5zMSU0XtUpE+LajKFBQlcNeEBdx0+tsA2bIfwEPBr3+XtM3kmx1/lzcrN5n1h1mneO1Z7Tb39js/+6D3xEtU4GZXp6aNwTT2bVPIM+XQx5SXJv7/pCGENWUiV+53B62E6FV5NNVY5IyRf1LKNon2I//HZwUiQjZ76vnRUnbzpkgweDRRxu5OQnflEY43DRWZAqefi/YkP7x+tgbjQ98qMKghpQPgudi+bqArN28PkI3GrfD7XXSRFCtRfk9LL8JvJGXspGqDKxovPSqBIYkbYG/JyNJ44FwdPssOOOx0s7ylpyJ7mFI2OVMEAQ9Jw==
Received: from DM5PR07CA0130.namprd07.prod.outlook.com (2603:10b6:3:13e::20)
 by CH2PR12MB3832.namprd12.prod.outlook.com (2603:10b6:610:24::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Mon, 12 Apr
 2021 08:26:43 +0000
Received: from DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:13e:cafe::89) by DM5PR07CA0130.outlook.office365.com
 (2603:10b6:3:13e::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend
 Transport; Mon, 12 Apr 2021 08:26:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; netfilter.org; dkim=none (message not signed)
 header.d=none;netfilter.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT048.mail.protection.outlook.com (10.13.173.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 08:26:41 +0000
Received: from [172.27.14.140] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 12 Apr
 2021 08:26:39 +0000
Subject: Re: [PATCH net-next 1/1] netfilter: flowtable: Make sure dst_cache is
 valid before using it
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, Oz Shlomo <ozsh@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20210411081334.1994938-1-roid@nvidia.com>
 <20210411105826.GB21185@salvia>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <3c0b0f60-b7e1-eea3-383b-aba64df8e68e@nvidia.com>
Date:   Mon, 12 Apr 2021 11:26:35 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210411105826.GB21185@salvia>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a11f1ea2-1001-4a84-8df5-08d8fd8cb344
X-MS-TrafficTypeDiagnostic: CH2PR12MB3832:
X-Microsoft-Antispam-PRVS: <CH2PR12MB38322481CE2150F40CEB95D1B8709@CH2PR12MB3832.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k18UhbrvlviFa75FcMhtQ5YrX6oA/DYMJqdtOaxoqz6vWOP1b5h+EEM/59tTAuF6/yILy7IEYf7Sszo0xE2NvmG/KDPTANIvTbzAmy2jXGH1wVQ+gBKWxfmEScO5hkBVM4KOAUrK/VEiw8W3bm0qRAZG/aP6jzPeenNXSnIfPGNSMIr8YP/TlpRqEdfOlaTxv7JceTnNrnRCPnMoOdQIXA7MzVh+Mtf7dhMl7BJuAbZxGl7GueiUsBxDk5i+XHZ7TCImKiv/a+luVy+Z/meMJ/N5LOeq/rr0qQsOlALCkA6MF+zAh3vChXukBxQ+kTCFPqXTvt7OTT4lOH4CEgAUGATZzWESLG07kh1m6Qosq4BNQwts8bsrl6SyvHDKtZit9Qz8xO+hPPwuTfiEReTweHYkIaT7KfNlppurjxZ0uAx9j5cHWCbJGWnA1142PKn9q6afPuM3q6/NGQ7lL3zu1z/DB3zdQ9NlIIZWZlRUYOBhKVsOzvVfMpJlr2VC6IO+Z9miU8fgK2VoG9Q14JQ5VCk8n3XRNTBlcpjC4zfPjGvHvhBu8QR0PSnZLcAos7nrMHhvAUiW8fGSPk9MQ51MZCFuZA9BWWlfMaV6vEaWkdVQAskP7VvreaI8bpdjD8SEHOzfie/wmPGUaC81PqmI0fmlAQssbZqO/9sV5v0HbccdmFZcvyQIdtuqcRM0wOcD
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(396003)(376002)(46966006)(36840700001)(478600001)(6916009)(2616005)(70206006)(36860700001)(53546011)(7636003)(31696002)(36756003)(26005)(31686004)(8936002)(47076005)(16526019)(426003)(82740400003)(16576012)(6666004)(70586007)(82310400003)(54906003)(356005)(336012)(316002)(36906005)(86362001)(5660300002)(2906002)(107886003)(8676002)(4326008)(186003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 08:26:41.6698
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a11f1ea2-1001-4a84-8df5-08d8fd8cb344
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3832
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-04-11 1:58 PM, Pablo Neira Ayuso wrote:
> Hi Roi,
> 
> On Sun, Apr 11, 2021 at 11:13:34AM +0300, Roi Dayan wrote:
>> It could be dst_cache was not set so check it's not null before using
>> it.
> 
> Could you give a try to this fix?
> 
> net/sched/act_ct.c leaves the xmit_type as FLOW_OFFLOAD_XMIT_UNSPEC
> since it does not cache a route.
> 
> Thanks.
> 

what do you mean? FLOW_OFFLOAD_XMIT_UNSPEC doesn't exists so default 0
is set.

do you suggest adding that enum option as 0?

this is the current xmit_type enum

enum flow_offload_xmit_type {
        FLOW_OFFLOAD_XMIT_NEIGH         = 0,
        FLOW_OFFLOAD_XMIT_XFRM,
        FLOW_OFFLOAD_XMIT_DIRECT,
};



>> Fixes: 8b9229d15877 ("netfilter: flowtable: dst_check() from garbage collector path")
>> Signed-off-by: Roi Dayan <roid@nvidia.com>
>> ---
>>   net/netfilter/nf_flow_table_core.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
>> index 76573bae6664..e426077aaed1 100644
>> --- a/net/netfilter/nf_flow_table_core.c
>> +++ b/net/netfilter/nf_flow_table_core.c
>> @@ -410,6 +410,8 @@ static bool flow_offload_stale_dst(struct flow_offload_tuple *tuple)
>>   	if (tuple->xmit_type == FLOW_OFFLOAD_XMIT_NEIGH ||
>>   	    tuple->xmit_type == FLOW_OFFLOAD_XMIT_XFRM) {
>>   		dst = tuple->dst_cache;
>> +		if (!dst)
>> +			return false;
>>   		if (!dst_check(dst, tuple->dst_cookie))
>>   			return true;
>>   	}
>> -- 
>> 2.26.2
>>
