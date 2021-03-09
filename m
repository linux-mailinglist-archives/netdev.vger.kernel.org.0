Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A05FC332079
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 09:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhCIIZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 03:25:10 -0500
Received: from mail-bn8nam12on2056.outbound.protection.outlook.com ([40.107.237.56]:63168
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229767AbhCIIYw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 03:24:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JCoxXK6yLL39nk4P7zZy6Dmtf1njdY0pKVsxlAhmtuy3P5IX2hhX+lUmqM0jqPBcYvCKExTs6GDw9QcycxMWfU179tjMH9iaJm6yaJyxiNGpOhesyyXMtLBt5zqURPpfSgiyn3xr3bB8O1iabPdGicMCC2QKSeGMEnmn1ox9S+sr36dB0OGcfD4TwZ5/o7X7aAwcL4vmzry0UEJ+3BmrX25yLQUbOdvU2GnyCkj7mun9cXFZ7mQDF3P7AmDjMx0VrAH8CP7xUhSyJYMX82xppFeoEirsJ50AtvtXSkSj7TxiM4IUoK0avPjVBCa34fjfC1Z7Ac/E1vqwO9+DBUi8Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r2MyeHfuDKzRXDy5KqqWBXVetpr6bsyULLhIwUaBa78=;
 b=HttAlegb/AlOAf0Y0/Ue3C0I+os2BphvnFfDqa51und1UzxsNRTGdxlrWOxYnGYuDiPk+uylBiz/LfG2NuvHcrVCCZ7jeqVdsUxQdqtCXR741of1PPM2HUyT55Yq35kydJRuiA9/jMS1N02AapOg3+hVXlrrBfYHkcclCgy7gw/6MN2EE5xecL3GBm2mJcQRuQOduS9AMHQbbW+h08JXYakUiqBuzFJ67CQcD4utiED23Yg8bIGTZF6O/7Kua5CTrP/N/ivYP0PGSPg3WFg/WqwMKWSVApn3rC+WxBLnhuhlWwOY2heQP2HVXeEQBfhz5cU7NQL+JipLRYVhqA3Xjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r2MyeHfuDKzRXDy5KqqWBXVetpr6bsyULLhIwUaBa78=;
 b=VMvQZrUl5Ri4SfBbzihHVIusieGbyjwf3SJOdFnByzCt/TEmUdaILiVL/xT92ZJGTKpG5iRQA/O1PeMiksW/vYhJTXA+NQZhoRMFMUnLL5QRgtaeRawtikN0iDRHe4w7CRsk2q4sgUej04b7oUucln7ZavHoJFUoAFWrESsA2isWE7FbhIltZ/uEs6yAP50a05uyXB2Zj70nrbJ+E0Ddf99x1FVzEXhtMJjD5WkFAP5qoEvPyV094GslAgP7OnVOZOiSOo7zvDjeyeLg0OGSn2d7Zc6hTGz9pT89jJ+Dl8hKyk5h/VMose9B60N7Qa4jU/Is5B65xBvS5W7gJtTkcw==
Received: from MWHPR14CA0055.namprd14.prod.outlook.com (2603:10b6:300:81::17)
 by BYAPR12MB3477.namprd12.prod.outlook.com (2603:10b6:a03:ac::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Tue, 9 Mar
 2021 08:24:50 +0000
Received: from CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:81:cafe::59) by MWHPR14CA0055.outlook.office365.com
 (2603:10b6:300:81::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Tue, 9 Mar 2021 08:24:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT051.mail.protection.outlook.com (10.13.174.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 08:24:49 +0000
Received: from [172.27.14.184] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Mar
 2021 08:24:46 +0000
Subject: Re: [PATCH] net: mellanox: mlx5: fix error return code of
 mlx5e_stats_flower()
From:   Roi Dayan <roid@nvidia.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>, <saeedm@nvidia.com>,
        <leon@kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20210306134718.17566-1-baijiaju1990@gmail.com>
 <99807217-c2a3-928f-4c8c-2195f3500594@nvidia.com>
Message-ID: <1fdf71d7-7a54-0b69-3339-e792dd03b2c8@nvidia.com>
Date:   Tue, 9 Mar 2021 10:24:45 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <99807217-c2a3-928f-4c8c-2195f3500594@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa327291-2188-4448-108d-08d8e2d4ce9a
X-MS-TrafficTypeDiagnostic: BYAPR12MB3477:
X-Microsoft-Antispam-PRVS: <BYAPR12MB347711FCFE276B8BFF1EECFEB8929@BYAPR12MB3477.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nDWCHneZGWFRv0dySqG8qRTx18b7EHY3zGtEdQm0Ea7sYSr3D9iuDasb0LlBFhuIYoO8QdZkh9NjUYbF17z8B6N0xrcVAIYhnBq2beQER8ybQ+z22rfAYZ5Cv9lEY0sX2/UnRYTErrFaJwQ2hibf+Pf06Vt26/cR3k55NlrbiYx38lfsLHOxQPHNkWjJPXwfUi6oUzirO6tuZbFjIF9HA6BZHj7eLARv6wJINNPu1wv3GoB4OJYlUKkgvlYDIcNVlZ+l4qRVjcHItYGwnEpk5iJNzJLaYZEVAZQV4tAdkfI9Cz4u7rjknPFCw3sQKjIQKjxTkUQsiR2I2+nb6ZAL7PjlyOuU//xJnd+xCh6SLq0UBULk/HCidTOB8JYhl1Jzb99oaf1+tl+FrrPKETqyN78HWptlsBZOHCZ818GwonZfNhZ5uZS+Zpvq0mIwY+70syI/+hoS/5N52tXazdzdDEI/6jbZ1X2wuo273JZuGuwU5UishRjNVROh/b9umv2NSfrAZWzuDADlYm7dTCLZxEO+pRWE8y+FjNbWaoOq7qslgvFLEEA/o5mdNIPyB8UVT/cJVvstM22dweXC1LSAz8wP9vT9mdoATLbChd6dcxT0STpaaFnM8blko8YUEAAads6TxISINSeHVIqXOG7GlLnclPLPrGekDKm38Y6+rnzEf7kIyekBEjVm+FZUTTX/Z+hKd+IAntNgXDDf7sTdLQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(136003)(376002)(36840700001)(46966006)(82740400003)(16576012)(26005)(8936002)(47076005)(8676002)(426003)(316002)(70586007)(36756003)(31686004)(7636003)(478600001)(2906002)(70206006)(356005)(336012)(36860700001)(186003)(34020700004)(16526019)(86362001)(4326008)(82310400003)(54906003)(2616005)(110136005)(53546011)(31696002)(5660300002)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 08:24:49.8963
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fa327291-2188-4448-108d-08d8e2d4ce9a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3477
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-03-09 10:20 AM, Roi Dayan wrote:
> 
> 
> On 2021-03-06 3:47 PM, Jia-Ju Bai wrote:
>> When mlx5e_tc_get_counter() returns NULL to counter or
>> mlx5_devcom_get_peer_data() returns NULL to peer_esw, no error return
>> code of mlx5e_stats_flower() is assigned.
>> To fix this bug, err is assigned with -EINVAL in these cases.
>>
>> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
>> ---
>>   drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 12 +++++++++---
>>   1 file changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c 
>> b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> index 0da69b98f38f..1f2c9da7bd35 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> @@ -4380,8 +4380,10 @@ int mlx5e_stats_flower(struct net_device *dev, 
>> struct mlx5e_priv *priv,
>>       if (mlx5e_is_offloaded_flow(flow) || flow_flag_test(flow, CT)) {
>>           counter = mlx5e_tc_get_counter(flow);
>> -        if (!counter)
>> +        if (!counter) {
>> +            err = -EINVAL;
>>               goto errout;
>> +        }
>>           mlx5_fc_query_cached(counter, &bytes, &packets, &lastuse);
>>       }
>> @@ -4390,8 +4392,10 @@ int mlx5e_stats_flower(struct net_device *dev, 
>> struct mlx5e_priv *priv,
>>        * un-offloaded while the other rule is offloaded.
>>        */
>>       peer_esw = mlx5_devcom_get_peer_data(devcom, 
>> MLX5_DEVCOM_ESW_OFFLOADS);
>> -    if (!peer_esw)
>> +    if (!peer_esw) {
>> +        err = -EINVAL;
> 
> note here it's not an error. it could be there is no peer esw
> so just continue with the stats update.
> 
>>           goto out;
>> +    }
>>       if (flow_flag_test(flow, DUP) &&
>>           flow_flag_test(flow->peer_flow, OFFLOADED)) {
>> @@ -4400,8 +4404,10 @@ int mlx5e_stats_flower(struct net_device *dev, 
>> struct mlx5e_priv *priv,
>>           u64 lastuse2;
>>           counter = mlx5e_tc_get_counter(flow->peer_flow);
>> -        if (!counter)
>> +        if (!counter) {
>> +            err = -EINVAL;

this change is problematic. the current goto is to do stats update with
the first counter stats we got but if you now want to return an error
then you probably should not do any update at all.

>>               goto no_peer_counter;
>> +        }
>>           mlx5_fc_query_cached(counter, &bytes2, &packets2, &lastuse2);
>>           bytes += bytes2;
>>
> 
> 
