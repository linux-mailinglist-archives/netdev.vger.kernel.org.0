Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A3233A3FB
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 10:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235039AbhCNJua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 05:50:30 -0400
Received: from mail-mw2nam12on2088.outbound.protection.outlook.com ([40.107.244.88]:6017
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229495AbhCNJu2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Mar 2021 05:50:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q8jo6E3OntLWMHjaqdLAPeJMF7/8zoK6wo03tWZUFTvgZEvpF8/VOyIntTNdjaXFJaslynmeLcb5RMi+rONjBvRLAQDhHigT+3IAXDVEgt7xtlEe+hoFA57MKVewOZjiqG38O2IPf/gpQM3581PGEXULEMmcsNaKzfUMdlNphmAMjI0j/1+ow2Ir+Ijgx+vj18JIgRIQPAJiTZ8MlESsG4Sj+mvi63YAorD9EqQXlRpr8Gxab2JiqLDCgNNbLHS7kSd104AjWtYnyWHFObzZtccZBTE3yktGPEgpY+2fv1kgR+FiuadjbhGx9PEAFha1BajTi5SEf8ErHF8902UOOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EYwUmW0tmMmq/F+TGEep/9YbfmnAvz9zAdiVkju5Ejc=;
 b=Q1IUji76W2QSfhNr4EUadVYgymkYKpdis6aGODJd1sjczKK5Cf1KTASbzz4XjPA4WxNgjmviN0lCk8v8TvXmuF2xCpNhKfLmVEarrOfatP8d4hv7o3S319R8vnGAFg3ALTqzdrRrLPSAem3tlaTsm+4dovmawwpb5ZBUjfhG6i+tymViNvz1p+eNKvYv1WWJYQgsb1hF2NiYoDXO3XiwHAFsFekoK60MU8NLXb4y5fRDe33A8lymwaKJaZdgcAhqNGoIar+VlNU+iLxoxKySu37h8cPqIdInQRiozBMDRB0KDjGBZlntkKcHgrJNArxw5iRJRY9W7/NlNN/DN6WIGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EYwUmW0tmMmq/F+TGEep/9YbfmnAvz9zAdiVkju5Ejc=;
 b=HPyDYmdAPGfVB/eWxr1LzXW4wofWR24K7AdKKLzRuW4qtHq3s5Mjl3HQNgUdTxqNF/wJS1zTzRPlqKsdHdYvhQrmio8lMrPcVZCRv866gCaq4Iy9QW5c7+rLa57ERIG+UTWjd8fcYInAtpaENuRe0GTrqLVNTxHbLORjfcomeZOD2AEoCIUWRr4cR73A4POt1+S/9yBZ5tVBiAzmeI0LO+juluq/RCTQ24FGR3s/ta8NaL42tHEu+yyfiLAMiFwBCLVI68PecZcv/1AQv9ZI4vDgU9IYFFOVdXvKijz0PeMlCF2L/ec65nz5NtZGnbJaSt2cT3GtnYA3YlPjyfzRUw==
Received: from DM5PR06CA0060.namprd06.prod.outlook.com (2603:10b6:3:37::22) by
 DM6PR12MB3273.namprd12.prod.outlook.com (2603:10b6:5:188::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.32; Sun, 14 Mar 2021 09:50:20 +0000
Received: from DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:37:cafe::28) by DM5PR06CA0060.outlook.office365.com
 (2603:10b6:3:37::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend
 Transport; Sun, 14 Mar 2021 09:50:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT055.mail.protection.outlook.com (10.13.173.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Sun, 14 Mar 2021 09:50:19 +0000
Received: from [172.27.15.5] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 14 Mar
 2021 09:50:17 +0000
Subject: Re: [PATCH] net: mellanox: mlx5: fix error return code of
 mlx5e_stats_flower()
To:     Saeed Mahameed <saeed@kernel.org>,
        Jia-Ju Bai <baijiaju1990@gmail.com>, <leon@kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20210306134718.17566-1-baijiaju1990@gmail.com>
 <99807217-c2a3-928f-4c8c-2195f3500594@nvidia.com>
 <1fdf71d7-7a54-0b69-3339-e792dd03b2c8@nvidia.com>
 <3a1a2089-a7fa-2a7c-7040-c0aa62b08960@gmail.com>
 <78a83112-2978-42e9-a90e-c8bee0389fd8@nvidia.com>
 <5e0ba8e23231eb15e6f1dbfa9759b3aa94267193.camel@kernel.org>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <59e7eba0-c26b-6833-8d92-1a4e04ac9e9b@nvidia.com>
Date:   Sun, 14 Mar 2021 11:50:14 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <5e0ba8e23231eb15e6f1dbfa9759b3aa94267193.camel@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa28d26f-7932-45b5-4298-08d8e6ce945b
X-MS-TrafficTypeDiagnostic: DM6PR12MB3273:
X-Microsoft-Antispam-PRVS: <DM6PR12MB327303CA2620352ED13795A8B86D9@DM6PR12MB3273.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jKgK35fUfoMDW5/JupPG+VgQOJrDsijGre4g//WJ35B5tKGMVlRcYlkO07UlQZOA2CH78JsG2QIsoFMLGa3b29xQ+yuf1DWfFHtY0HJ8XseeUZplWFz5KC5L2A+BxQGUFMsViu7Z1lchSZhl0CGwVsqJJRGiGhRTyUEVqyzTEdzc+u2Cse9/ldj2/pXqRcIiIZuEEyUL5ER1D2WDXwr8i4IDUc6CKDBaKuGmzLMDer9Ip9yrFKwtZl10JI5NBNGIyVEnI+rLXUP/4sJkDCMBjqyfdMSJ1BDbVqXCXg/xi1LAd/0w/lbjDkTOuU+tbcNWkKcLt1g7sLYInvT0axrmORzVUidHcDDTD7Py9oFpafaa2GOO4DKWB7HdlDG1bDdgWc0yZ3zA/44RguKHgPYpJr6bA3jwYO8dYFubEiIfVkHKfquuSmWDm0B6WK6BN1a/5ScMsUVr6Y0tb6AExT91W0r8vP9Yxy/7qpnh5t4aZbrnUNh+J8PByQXVXz95Aqq5d1yU8b1hyOq2z6e//bDF0sP1ds9nH6Lc4dWMWni6aS0cBlVbnSGBhiZTUZAuWgst/wrX8skE6mPHqP7ofDC3cIweF7ywCmWRtvwSah6aLZ9u17d9iNbiEb1YMB6a0EkjJAX3HBLGVTJnghged+citlUhPV9jL2i9HEoRzMAtRt2QxidNk3gaZw6/49KGzlxqNxOi2Dumd8Xaam5dQJhBPA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(39860400002)(346002)(36840700001)(46966006)(5660300002)(336012)(82740400003)(110136005)(2906002)(31696002)(54906003)(8936002)(7636003)(8676002)(356005)(6666004)(26005)(70206006)(70586007)(2616005)(36756003)(86362001)(426003)(36906005)(34020700004)(53546011)(36860700001)(82310400003)(186003)(47076005)(83380400001)(16576012)(316002)(31686004)(16526019)(478600001)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2021 09:50:19.8426
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aa28d26f-7932-45b5-4298-08d8e6ce945b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3273
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-03-12 12:47 AM, Saeed Mahameed wrote:
> On Tue, 2021-03-09 at 11:44 +0200, Roi Dayan wrote:
>>
>>
>> On 2021-03-09 10:32 AM, Jia-Ju Bai wrote:
>>>
>>>
>>> On 2021/3/9 16:24, Roi Dayan wrote:
>>>>
>>>>
>>>> On 2021-03-09 10:20 AM, Roi Dayan wrote:
>>>>>
>>>>>
>>>>> On 2021-03-06 3:47 PM, Jia-Ju Bai wrote:
>>>>>> When mlx5e_tc_get_counter() returns NULL to counter or
>>>>>> mlx5_devcom_get_peer_data() returns NULL to peer_esw, no
>>>>>> error return
>>>>>> code of mlx5e_stats_flower() is assigned.
>>>>>> To fix this bug, err is assigned with -EINVAL in these cases.
>>>>>>
>>>>>> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> 
> Hey Jia-Ju, What are the conditions for this robot to raise a flag?
> sometimes it is totally normal to abort a function and return 0.. i am
> just curious to know ?
> 
> 
>>>>>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
>>>>>> ---
>>>>>>    drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 12
>>>>>> +++++++++---
>>>>>>    1 file changed, 9 insertions(+), 3 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>>>>>> b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>>>>>> index 0da69b98f38f..1f2c9da7bd35 100644
>>>>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>>>>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>>>>>> @@ -4380,8 +4380,10 @@ int mlx5e_stats_flower(struct
>>>>>> net_device
>>>>>> *dev, struct mlx5e_priv *priv,
>>>>>>        if (mlx5e_is_offloaded_flow(flow) ||
>>>>>> flow_flag_test(flow, CT)) {
>>>>>>            counter = mlx5e_tc_get_counter(flow);
>>>>>> -        if (!counter)
>>>>>> +        if (!counter) {
>>>>>> +            err = -EINVAL;
>>>>>>                goto errout;
>>>>>> +        }
>>>>>>            mlx5_fc_query_cached(counter, &bytes, &packets,
>>>>>> &lastuse);
>>>>>>        }
>>>>>> @@ -4390,8 +4392,10 @@ int mlx5e_stats_flower(struct
>>>>>> net_device
>>>>>> *dev, struct mlx5e_priv *priv,
>>>>>>         * un-offloaded while the other rule is offloaded.
>>>>>>         */
>>>>>>        peer_esw = mlx5_devcom_get_peer_data(devcom,
>>>>>> MLX5_DEVCOM_ESW_OFFLOADS);
>>>>>> -    if (!peer_esw)
>>>>>> +    if (!peer_esw) {
>>>>>> +        err = -EINVAL;
>>>>>
> 
> This is not an error flow, i am curious what are the thresholds of this
> robot ?
> 
>>>>> note here it's not an error. it could be there is no peer esw
>>>>> so just continue with the stats update.
>>>>>
>>>>>>            goto out;
>>>>>> +    }
>>>>>>        if (flow_flag_test(flow, DUP) &&
>>>>>>            flow_flag_test(flow->peer_flow, OFFLOADED)) {
>>>>>> @@ -4400,8 +4404,10 @@ int mlx5e_stats_flower(struct
>>>>>> net_device
>>>>>> *dev, struct mlx5e_priv *priv,
>>>>>>            u64 lastuse2;
>>>>>>            counter = mlx5e_tc_get_counter(flow->peer_flow);
>>>>>> -        if (!counter)
>>>>>> +        if (!counter) {
>>>>>> +            err = -EINVAL;
>>>>
>>>> this change is problematic. the current goto is to do stats
>>>> update with
>>>> the first counter stats we got but if you now want to return an
>>>> error
>>>> then you probably should not do any update at all.
>>>
>>> Thanks for your reply :)
>>> I am not sure whether an error code should be returned here?
>>> If so, flow_stats_update(...) should not be called here?
>>>
>>>
>>> Best wishes,
>>> Jia-Ju Bai
>>>
>>
>> basically flow and peer_flow should be valid and protected from
>> changes,
>> and counter should be valid.
>> it looks like the check here is more of a sanity check if something
>> goes
>> wrong but shouldn't. you can just let it be, update the stats from
>> the
>> first queried counter.
>>
> 
> Roi, let's consider returning an error code here, we shouldn't be
> silently returning if we are not expecting these errors,
> 
> why would mlx5e_stats_flower() be called if stats are not offloaded ?
> 
> Thanks,
> Saeed.
> 
> 

yes we can return an error if peer counter missing.
I just pointed out we should probably not call flow_stats_update() if
we do return an error.
the other option, as today, is updating the stats with first counter
stats and because of that we didn't return an error.
