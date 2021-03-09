Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4C1332249
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 10:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhCIJpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 04:45:03 -0500
Received: from mail-dm6nam12on2061.outbound.protection.outlook.com ([40.107.243.61]:6368
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229656AbhCIJpA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 04:45:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kOw9ZzolP2FgDynQJxHxmuxXREhivZNs82UMmROpWBBJu43Y8ay5BZ9jd26LGP/FkCuAlbrQB/JxNTWpbG1tXbpGHzPehsO8MCKqvB/iYjwxYr/bcLP29UqmNVg8Q62iayj7qChowmqKHyFuP+QKrp3SSYsWALmObBB5u8BTFg4aFPxV3Qk3JJPksLythgO6Fv11vGhwjS+8d2XEUBxpP0cA5DDW0eYmM8HQFnZ77cteLyczfWOiBUWxvoeWacNFheUSTpFusgQIOifw5V47q5DITxETpfMoog++1sHPKnvdQWcBHGnlaO/u15VOxnaQMOeME0rP1zhG2cdYhDsVYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Al7EO1jjfuC+Cz2BryhjZzx5G2AiaZ8NL0+wXoXhcJo=;
 b=EHHQfYj+020ifGvzpHTKNsqoloK8/z8CqnUv8sB5XGGJYIUp65Kz4siGM9Kr2W4GiNyNG5AFKREmJasKYutx9Beoh9ulPwBDVoCA4ZHK0IEDCopowys4vnSx7JqB6OCWgEjLwaG0owGCDGS9fOG9iqjnbhVaCXtByo7cIZJuKaCI9skgstk9VzeByE2q3aRd7T8P4KwHCztk0tdGAw46suAVrv9x76bWTYvOf0IWdX7lzCPzElTXAObmXTarH3f4z44tNXS7ZQp+EhvQX4rCyCxRo49T7WpoZHecBdFVDDjWu9Fzd7UkRyMQV9pE0q39E9CsS28qcs7QfQZp55z8Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Al7EO1jjfuC+Cz2BryhjZzx5G2AiaZ8NL0+wXoXhcJo=;
 b=UpczcK0G84rRuA+I+CxX+5R47p75ACMfoLCdEt2IuGm2EBUsz7gPB1Ifag92T6b7CWrOOX09PD+zXVJxaGY9nfDOpyITDBp6hX+SFG6qzsTGK4cRFr3HSub5LRDt7IMFYROMYnSFI89mTwfIEi+zv2kIRbGEkn2bDmrhVIM29v2iL56y6gi9A/3CrvtU6XbgtjW8o288QD9CD0p+YgZElz++shaZMrBRZm+68Tk1DrIsWaI7PBswrz1BMZv5GW8bQSXYqAdfOondVWU8Esp31XSSLk6P/1u/t7pJCbYN2cs1EWScjRK8If9oAs+dR+5NkZPJwFDujY3YmhVstEDXMw==
Received: from BN9PR03CA0910.namprd03.prod.outlook.com (2603:10b6:408:107::15)
 by MN2PR12MB3616.namprd12.prod.outlook.com (2603:10b6:208:cc::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Tue, 9 Mar
 2021 09:44:53 +0000
Received: from BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:107:cafe::a6) by BN9PR03CA0910.outlook.office365.com
 (2603:10b6:408:107::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Tue, 9 Mar 2021 09:44:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT030.mail.protection.outlook.com (10.13.177.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 09:44:52 +0000
Received: from [172.27.14.184] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Mar
 2021 09:44:48 +0000
Subject: Re: [PATCH] net: mellanox: mlx5: fix error return code of
 mlx5e_stats_flower()
To:     Jia-Ju Bai <baijiaju1990@gmail.com>, <saeedm@nvidia.com>,
        <leon@kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20210306134718.17566-1-baijiaju1990@gmail.com>
 <99807217-c2a3-928f-4c8c-2195f3500594@nvidia.com>
 <1fdf71d7-7a54-0b69-3339-e792dd03b2c8@nvidia.com>
 <3a1a2089-a7fa-2a7c-7040-c0aa62b08960@gmail.com>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <78a83112-2978-42e9-a90e-c8bee0389fd8@nvidia.com>
Date:   Tue, 9 Mar 2021 11:44:46 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <3a1a2089-a7fa-2a7c-7040-c0aa62b08960@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc3ea62a-427d-4ef5-b2c2-08d8e2dffd00
X-MS-TrafficTypeDiagnostic: MN2PR12MB3616:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3616FBE999C47C7CD8AAAD0CB8929@MN2PR12MB3616.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QsEbc6z6SkJqOV89H6iD9prncjzSgrxBu5C8rjcv/JpVrILk1xb1tJ0PiV37S0Es6/B6dyltWfbJU9Xxwo8pvQU1/MhbLsARBP95npx/iXvyPCNG5UQ3HYJ39UjOraBfsF0qlmFmat+YrEOA+Yuc8CWo6wnmPTdp06A4DssNvmkEsvpSJo5k/knPNZZ9xuBE3MMdDTpi+nRUmeD+O1HLsWZNEzbjGf/ZorRqW1Ue2J5krmohRJ32Cincbs+6Q3pCxRwqdl+07TsgLeNKv6P+8p7GEQ7UyLETpC2cdKfLm+IG3kkEWF9DpO6wlBve+osPliMlD+TjOZ0KaTsEJorJbxiM3PgoI2RdaTQFfBP0Mw+PHT1II2juFpeRbKpCMbZjPjC4G16F1KrjrEc9sgandO3TmewFnpZX7rJGoeEdZRxJ0iX5/3E7mIbN180BRc5tv25EqJfrIzY4/fPVM2tBYShEbw6qStOl0ZvHXQ3sXj4x6AFEUVUFmBy/0jjDht42mxOk1n5JOjXqRg5jHWiOPcC4vtahBT5fPJg1tYBYUjai4vptYeAoYV/IOE4jcs75P+T9maio9InJWtUAtbmL+hKXscwDj9/9fgF0MR12k5dHixxHIuf9loTogqG7mT1HQDTG56igT+XJoO7xg5CI7cTpdGJrkxXnG2nK4IEx0ogPXTetRBzQBT6K7nD/j9u6p8KvxgvZsPXkdQdJpJ02Yw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(136003)(346002)(36840700001)(46966006)(86362001)(31686004)(53546011)(83380400001)(8676002)(7636003)(26005)(36860700001)(186003)(16526019)(70206006)(34020700004)(70586007)(8936002)(316002)(82310400003)(4326008)(336012)(47076005)(2616005)(426003)(36756003)(54906003)(82740400003)(2906002)(110136005)(356005)(16576012)(5660300002)(478600001)(31696002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 09:44:52.1581
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc3ea62a-427d-4ef5-b2c2-08d8e2dffd00
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3616
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-03-09 10:32 AM, Jia-Ju Bai wrote:
> 
> 
> On 2021/3/9 16:24, Roi Dayan wrote:
>>
>>
>> On 2021-03-09 10:20 AM, Roi Dayan wrote:
>>>
>>>
>>> On 2021-03-06 3:47 PM, Jia-Ju Bai wrote:
>>>> When mlx5e_tc_get_counter() returns NULL to counter or
>>>> mlx5_devcom_get_peer_data() returns NULL to peer_esw, no error return
>>>> code of mlx5e_stats_flower() is assigned.
>>>> To fix this bug, err is assigned with -EINVAL in these cases.
>>>>
>>>> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
>>>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
>>>> ---
>>>>   drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 12 +++++++++---
>>>>   1 file changed, 9 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c 
>>>> b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>>>> index 0da69b98f38f..1f2c9da7bd35 100644
>>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>>>> @@ -4380,8 +4380,10 @@ int mlx5e_stats_flower(struct net_device 
>>>> *dev, struct mlx5e_priv *priv,
>>>>       if (mlx5e_is_offloaded_flow(flow) || flow_flag_test(flow, CT)) {
>>>>           counter = mlx5e_tc_get_counter(flow);
>>>> -        if (!counter)
>>>> +        if (!counter) {
>>>> +            err = -EINVAL;
>>>>               goto errout;
>>>> +        }
>>>>           mlx5_fc_query_cached(counter, &bytes, &packets, &lastuse);
>>>>       }
>>>> @@ -4390,8 +4392,10 @@ int mlx5e_stats_flower(struct net_device 
>>>> *dev, struct mlx5e_priv *priv,
>>>>        * un-offloaded while the other rule is offloaded.
>>>>        */
>>>>       peer_esw = mlx5_devcom_get_peer_data(devcom, 
>>>> MLX5_DEVCOM_ESW_OFFLOADS);
>>>> -    if (!peer_esw)
>>>> +    if (!peer_esw) {
>>>> +        err = -EINVAL;
>>>
>>> note here it's not an error. it could be there is no peer esw
>>> so just continue with the stats update.
>>>
>>>>           goto out;
>>>> +    }
>>>>       if (flow_flag_test(flow, DUP) &&
>>>>           flow_flag_test(flow->peer_flow, OFFLOADED)) {
>>>> @@ -4400,8 +4404,10 @@ int mlx5e_stats_flower(struct net_device 
>>>> *dev, struct mlx5e_priv *priv,
>>>>           u64 lastuse2;
>>>>           counter = mlx5e_tc_get_counter(flow->peer_flow);
>>>> -        if (!counter)
>>>> +        if (!counter) {
>>>> +            err = -EINVAL;
>>
>> this change is problematic. the current goto is to do stats update with
>> the first counter stats we got but if you now want to return an error
>> then you probably should not do any update at all.
> 
> Thanks for your reply :)
> I am not sure whether an error code should be returned here?
> If so, flow_stats_update(...) should not be called here?
> 
> 
> Best wishes,
> Jia-Ju Bai
> 

basically flow and peer_flow should be valid and protected from changes,
and counter should be valid.
it looks like the check here is more of a sanity check if something goes
wrong but shouldn't. you can just let it be, update the stats from the
first queried counter.


>>
>>>>               goto no_peer_counter;
>>>> +        }
>>>>           mlx5_fc_query_cached(counter, &bytes2, &packets2, &lastuse2);
>>>>           bytes += bytes2;
>>>>
>>>
>>>
> 
