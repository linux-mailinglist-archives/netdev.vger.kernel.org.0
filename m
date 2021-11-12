Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0B144DF7D
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 02:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234546AbhKLBFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 20:05:35 -0500
Received: from mail-dm6nam12on2068.outbound.protection.outlook.com ([40.107.243.68]:55435
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234146AbhKLBFe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 20:05:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TGwFA+P4nPmj8J6TXEEgI/LXejopPqgPmfqO4wjfKRTxrWIvmdoF9jbQ09uLlQW3QSzbNPA40bKsr/eUszg/SPBR2baq5FUq6gOJ2HFaoDg8kvfHTASvqQLRQjyeuy+lv0jhO1odr0sFwaNcUqoXN/jE6HROWEJz8UA05UH4RUNvuOzWZWTKdVlZt7JymfHNbo7p7Gp5+szuMxD0iLMD1W/r/dxi4jqyR/3yCEiqqyZuiebuXT/ekLwYoTQVAG+81tvTNC5xCTe5Z+ZbLVMPUVz1CestlXhWngMWEjIi6GoaK7/tlEp2PVqfvJsOtzM22Hm1mtN5QeENZNIHUBZEMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hEvtmyLbFNeKzpPb1R9RadNp8n4qhSPSu9o4LF34fSQ=;
 b=BgJBs03+Vm3GEJRZ93FFfX3MDEiqiV1MUHC1CJnSH0555LsR+lBMeYMv3CEuKwLkMHIzJnZ7C8GSaCIxSCFPm6EPnsdwbJlMKQ5KaKU2Wxfo7UbqkU4C/zVjKVFFSYOOx/MAR6QCZRNJP2nCQyTJeLqr+JkgjOoL0HHoaXzNCnfrdnkhvh3V0DinlazlbbdH1PdoJO6Jfe65riP+SSieJ7kh9Wg6GsUAep49tDaAsTwqqgGJccWr0aNon3Hw1TYq+PeBMIg+AX0tLeTg3li083Rq5JMuBo/qa7/k5ejUwub8hLTqUYE/J7Va5T7CQneGuFY/Lns8yq1ZmImIM7nbHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hEvtmyLbFNeKzpPb1R9RadNp8n4qhSPSu9o4LF34fSQ=;
 b=WeNgRNJP+veOYfJElFgSG5uBbUmBSGu+QUysG2O3B4kODCSd9aEXV8LJ/IdU/HPyf5wpuXki0G6xJt0LfZ5s5ojSgcqeaFp70kedhf3q/9KuULXkZ5TrbfYakz0yPDbbFyMPilcTUWLVfVXxi1D/ONUB6Me2llCUjwbfU7KtZJndSO6P6gIlbJxwf+UlLKe+0JMhdsh9wZR9fYGug//+1i1IMNSh/GjqE9BFCvkZxKMo4cQ3b2Y79jXzeGZUsbTSRJiCTE3j0Mb/V5aTngR/SSxCOZa9KQ6utgo2CzBct/lwfY8AQTqFOThD8OX8xnZNEnt2yzwYGnOL6UU7LvWn5Q==
Received: from MWHPR13CA0046.namprd13.prod.outlook.com (2603:10b6:300:95::32)
 by CY4PR12MB1206.namprd12.prod.outlook.com (2603:10b6:903:3b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Fri, 12 Nov
 2021 01:02:42 +0000
Received: from CO1NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:95:cafe::ea) by MWHPR13CA0046.outlook.office365.com
 (2603:10b6:300:95::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.5 via Frontend
 Transport; Fri, 12 Nov 2021 01:02:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT038.mail.protection.outlook.com (10.13.174.231) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4690.15 via Frontend Transport; Fri, 12 Nov 2021 01:02:41 +0000
Received: from [10.2.56.46] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 12 Nov
 2021 01:02:39 +0000
Subject: Re: [RFC PATCH net-next] rtnetlink: add RTNH_F_REJECT_MASK
To:     David Ahern <dsahern@gmail.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
CC:     <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
        "Stephen Hemminger" <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        "Pavel Tikhomirov" <ptikhomirov@virtuozzo.com>
References: <20211111160240.739294-1-alexander.mikhalitsyn@virtuozzo.com>
 <20211111160240.739294-2-alexander.mikhalitsyn@virtuozzo.com>
 <1f4b9028-8dec-0b14-105a-3425898798c9@gmail.com>
 <CAJqdLrqvNYm1YTA-dgGsrjsPG6efA8nsUCQLKmGXqoDM+dfpRQ@mail.gmail.com>
 <b90e874b-30a7-81bb-a94f-b6cebda87e99@gmail.com>
From:   Roopa Prabhu <roopa@nvidia.com>
Message-ID: <ff405eae-21d9-35f4-1397-b6f9a29a57ff@nvidia.com>
Date:   Thu, 11 Nov 2021 17:02:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b90e874b-30a7-81bb-a94f-b6cebda87e99@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4bf9cd71-fb29-4afa-5989-08d9a5782117
X-MS-TrafficTypeDiagnostic: CY4PR12MB1206:
X-Microsoft-Antispam-PRVS: <CY4PR12MB1206C24BA82F8A76AE263D70CB959@CY4PR12MB1206.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M7nWb96OcAvbG8N2ST+KYgrVpg2vAIhTR4mYRAzSoK8ycKlvM4T60FjMGIFCkft33hXcjSfUzdEdt1yxrtHpOmerVHMIiQ8FQESyJwvZBPHLPbrqfh0MR5lB/9/rg6RLz00q3JpaY2anPxCywFZxvYD9+ktwXzvHCM6DqTpEE711rISxERQUJwYGuu5TVaJhVNU9GJINX+/bzqV7Ox1Ek0pKzGz/8L9OPnVN2fAf6PkJQQvvg3FjYDtlhcriurK6TQ06J2njm8oepQq4G1UUsH15sMlniUqbTvzQbFlFs8hwwKOAGA2DEBoVmIaXqsCrllubZVqzkD1gtCV79WDxyE6WaNWvcrcfxi7B4o8OmUBdkvHwk2NIEnKNy1tahQlWWV0LcI0b2aux/RD+m1R6pJAYMGikjxJFzz7G7HM2SPowxzRrwzEs+m3GWocBjxY7Ntb9QzEbAsqSKWYm97LvdeCu4bqpvA5jNU9YyzYSbbziNjtzVk/YBhLsfkj3XuLoeRLZFubfMfkPGtWz2BG6X4dCkkM95emt3xlSU9xuCLRQQEX+ppzHKoBwpbZ/O0zEK2JLOtam00r+JtaIBBGHiTEhGPyhJOyQxtYOtsQJY+V5hLTuPOdk3Yw+TMJH89qEe437TWXjwE/MitCtg1clzPw+Q+BOczdy5sExlPTru1X7LjLZBEYpKn8BRDAecgqPmA0NavZNWmfyNmh1cIuDxUPx5ozPPIrEhwW/i4w0zNg=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(36906005)(36860700001)(5660300002)(2906002)(16576012)(4326008)(426003)(86362001)(70586007)(2616005)(31696002)(336012)(70206006)(316002)(186003)(26005)(36756003)(508600001)(54906003)(16526019)(82310400003)(110136005)(31686004)(47076005)(8936002)(356005)(7636003)(8676002)(53546011)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2021 01:02:41.7913
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bf9cd71-fb29-4afa-5989-08d9a5782117
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1206
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/11/21 2:19 PM, David Ahern wrote:
> [ cc roopa]
>
> On 11/11/21 12:23 PM, Alexander Mikhalitsyn wrote:
>> On Thu, Nov 11, 2021 at 10:13 PM David Ahern <dsahern@gmail.com> wrote:
>>> On 11/11/21 9:02 AM, Alexander Mikhalitsyn wrote:
>>>> diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
>>>> index 5888492a5257..c15e591e5d25 100644
>>>> --- a/include/uapi/linux/rtnetlink.h
>>>> +++ b/include/uapi/linux/rtnetlink.h
>>>> @@ -417,6 +417,9 @@ struct rtnexthop {
>>>>   #define RTNH_COMPARE_MASK    (RTNH_F_DEAD | RTNH_F_LINKDOWN | \
>>>>                                 RTNH_F_OFFLOAD | RTNH_F_TRAP)
>>>>
>>>> +/* these flags can't be set by the userspace */
>>>> +#define RTNH_F_REJECT_MASK   (RTNH_F_DEAD | RTNH_F_LINKDOWN)
>>>> +
>>>>   /* Macros to handle hexthops */
>>> Userspace can not set any of the flags in RTNH_COMPARE_MASK.
>> Hi David,
>>
>> thanks! So, I have to prepare a patch which fixes current checks for rtnh_flags
>> against RTNH_COMPARE_MASK. So, there is no need to introduce a separate
>> RTNH_F_REJECT_MASK.
>> Am I right?
>>
> Added Roopa to double check if Cumulus relies on this for their switchd.
>
> If that answer is no, then there is no need for a new mask.
>

yes, these flags are already exposed to userspace and we do use it.

We have also considered optimizations where routing daemons set OFFLOAD 
and drivers clear it when offload fails.

I wont be surprised if other open network os distributions are also 
using it.


Thanks for the headsup David.

