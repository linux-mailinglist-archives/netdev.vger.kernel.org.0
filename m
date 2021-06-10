Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF1553A2504
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 09:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbhFJHHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 03:07:38 -0400
Received: from mail-dm6nam10on2046.outbound.protection.outlook.com ([40.107.93.46]:39617
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229935AbhFJHHg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 03:07:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dnWMbRcZNZgxb65rzOvgcV7JKGRi24OZwIWtFy4bETyFAXXc5yngIaKWDB1AypoT8MDNp7P2FhArGDHsydOaqtK4fDFJU7NJesySm3LuWwqayc5nZbsFF/tUC7GrDFEXwbaZNBrmSq5l9cKcv3a7ZZjVPvwFSNQw9A5bTLgq8mloPruhoLppvl0suEqO8xemO5WKLUoZ71IOGCt279wmw51qD/AwroNhEWA0+GuMH6+VQQJk0H46iX5JefrEphv3aYQRCKo7PuXuT9L42VJQLmbs3wpPGse1ozZQ6Gu5YQcKGKlVC0mn90qI1bEBm1ZApzwVphlYGc5Ys4OJRa1AIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4/OMHgtNS8kwx0nOtwSSV60pShc8PCfRZmCHdz0kYDA=;
 b=ImhQDish93rWvPIOV+TEBk9GpjR5LtQT2/lxLBh/Ex17uorPrTxNajrCB/tVP4y2YY9vYpF6GPLgYnlZZ1ktt3W9UORKmh00REULmVab2JMxCcqZVPc6JRwufX0FsFqyn0AfWEkY1Fy58HH4iz5P/yZFgGkuNKDjCdl7kc4e3tu+Ze2Zu9OtWOmc4WIp2jZ8k4BKTMdYwiFcQs2Mmk6oMBzLADWD7Gw06UMM1Z9uuFmGvgWluha4SnG/SHEOBaNSooxPtZMQ2o9p3k6j+ShC+p50YcOMY45iQLs+9GWfV8iA1yKJDzVDUiBKGSQSdPDeb51Lc8SUYFbf0t/0Drb8dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4/OMHgtNS8kwx0nOtwSSV60pShc8PCfRZmCHdz0kYDA=;
 b=td6w5CFXwLnkbZZPl3KPuGDckEMjd9FxFHrOY3QOH83Pzz2GJZ4Gob036jdtbt+/ab0RZaAU0EH6ADBn/K0LZO+zdyZM2utvqIA+3fVHd74O/UUdDs8fnTNVII6XmartNhXCqBc2YQ0l6N0uG25ffJrwoCUfhe7/S04yYc2CuVEanG1+lmBjvAsuoYRBTf9AW14erV6ZgKP64TQGAzoeYBqo0q8YNFF9GS0E+6IzEGGCTbqRJF60otuxH94iqPnUD/CLfLqVcK+XnXrXDAntQH1TatzLn2fJJjX4BslrP+S6g14bn1QTXAJDZ/mCm2M8hE4lGDmhT5m+WwTF79T7ew==
Received: from DS7PR03CA0200.namprd03.prod.outlook.com (2603:10b6:5:3b6::25)
 by CH2PR12MB4023.namprd12.prod.outlook.com (2603:10b6:610:14::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Thu, 10 Jun
 2021 07:05:40 +0000
Received: from DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b6:cafe::fe) by DS7PR03CA0200.outlook.office365.com
 (2603:10b6:5:3b6::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend
 Transport; Thu, 10 Jun 2021 07:05:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; netfilter.org; dkim=none (message not signed)
 header.d=none;netfilter.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT064.mail.protection.outlook.com (10.13.172.234) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Thu, 10 Jun 2021 07:05:39 +0000
Received: from [172.27.14.78] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Jun
 2021 07:05:32 +0000
Subject: Re: [PATCH net 1/3] netfilter: synproxy: Fix out of bounds when
 parsing TCP options
To:     Florian Westphal <fw@strlen.de>
CC:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Patrick McHardy <kaber@trash.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Peter Krystad <peter.krystad@linux.intel.com>,
        Young Xiao <92siuyang@gmail.com>, <netdev@vger.kernel.org>
References: <20210609142212.3096691-1-maximmi@nvidia.com>
 <20210609142212.3096691-2-maximmi@nvidia.com>
 <20210609145115.GL20020@breakpoint.cc>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
Message-ID: <4ec99ea3-6ab1-eee4-be60-992cf2f9cd45@nvidia.com>
Date:   Thu, 10 Jun 2021 10:05:29 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210609145115.GL20020@breakpoint.cc>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 159eba39-36a7-4624-05b4-08d92bde2797
X-MS-TrafficTypeDiagnostic: CH2PR12MB4023:
X-Microsoft-Antispam-PRVS: <CH2PR12MB40236C9C8C50349935F633F0DC359@CH2PR12MB4023.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lBFpNLF+dbHuVSKHR3c6VLPhPZutHk9Zv3EELbUF0XA/FznWnPJVqOB5A8bCZctsFFolNxrradV5/BGZqhlLiHIWi3TW/bMz7k5Sw0psGgURAKVAh+SYmpXnKwkt8sY28aJyl+IlB/88HphOi+g02ec1TAan8QWNELYlNXbJThlSXtZvivqXl2obWsqKNPf1KvgzddwegBhB2wmdf9LXT0lCiaSdnnI2rg3mCe+c1YYb1aIFBho7EwIUrK4BGp1gaJsNctEhr/aiIuC3rY3lOJ9JHyMJo6m1TGi7QoVIDVt3T0tle4CEYft4RIhATqioSCjRU0MCpv6+TPFNIcEPUo8UccPWacwPtTonD3Zx7Yun1JdC5pzgX8eI4fa1zImk3EmO3D7qE05xcAtLfjAkUYU/EMavbO3Nin9CNJVYj8snZc3f0aOWZP8JSCZYYA+9gNzeq7moXC6WXJvy/8rS8vpSEhIpHmRr7XNj2l1WomEa7LwhIV+9G8CFHRe+MNDOHgqxIykD4yeYFGxrSXfaRnb9nSBBFcYz8myDBrCKX5VFxzE4upkXLBhePuqgXw5usgMpkky0tPayZoMbKUEG8I2lAF4iWd5PVoDnFTa/wKYMti5UjbezUyRSaY1zpNU2Iu3FBrdK2i9OrwvdL1Qe5+KxYMRU5CHaZIKg1v80RQLyuiKpAyVI8Yr3OlwD23z7
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(396003)(346002)(46966006)(36840700001)(54906003)(2616005)(2906002)(8676002)(36860700001)(4326008)(356005)(426003)(8936002)(47076005)(7416002)(86362001)(336012)(82310400003)(31686004)(83380400001)(16526019)(7636003)(6916009)(6666004)(70586007)(53546011)(70206006)(82740400003)(26005)(478600001)(186003)(316002)(31696002)(5660300002)(36756003)(16576012)(36906005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 07:05:39.5499
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 159eba39-36a7-4624-05b4-08d92bde2797
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4023
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-06-09 17:51, Florian Westphal wrote:
> Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>> The TCP option parser in synproxy (synproxy_parse_options) could read
>> one byte out of bounds. When the length is 1, the execution flow gets
>> into the loop, reads one byte of the opcode, and if the opcode is
>> neither TCPOPT_EOL nor TCPOPT_NOP, it reads one more byte, which exceeds
>> the length of 1.
>>
>> This fix is inspired by commit 9609dad263f8 ("ipv4: tcp_input: fix stack
>> out of bounds when parsing TCP options.").
>>
>> Cc: Young Xiao <92siuyang@gmail.com>
>> Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
>> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
>> ---
>>   net/netfilter/nf_synproxy_core.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
>> index b100c04a0e43..621eb5ef9727 100644
>> --- a/net/netfilter/nf_synproxy_core.c
>> +++ b/net/netfilter/nf_synproxy_core.c
>> @@ -47,6 +47,8 @@ synproxy_parse_options(const struct sk_buff *skb, unsigned int doff,
>>   			length--;
>>   			continue;
>>   		default:
>> +			if (length < 2)
>> +				return true;
> 
> Would you mind a v2 that also rejects bogus th->doff value when
> computing the length?

Could you elaborate? The length is a signed int calculated as `(th->doff 
* 4) - sizeof(*th)`. Invalid doff values (0..4) lead to negative length, 
so we never enter the loop. Or are you concerned of passing a negative 
length to skb_header_pointer?

> 
> Thanks.
> 

