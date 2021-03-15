Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2562933BF0D
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 15:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237236AbhCOOxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 10:53:30 -0400
Received: from mail-dm6nam12on2072.outbound.protection.outlook.com ([40.107.243.72]:45409
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241694AbhCOOxL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 10:53:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ki+fY/IXvXU6gC9OiGLFRceOsBVTCXFW9vZ+9NdTypuxd9vDl07sqezqhwOKmK73usUUyp6xg2Bjz0OcDxPt+CyiV6EcTnB950GviRvxOrs+PTT4Q4Ru4XgTAMXjb5KxLOmbhTcDM4evIK+hcnn/G4H9uPlOlnqn0w6uaDCVriWqixyC+dqsSm1hirFLI818tOaHVCxJCpJ3DrOHJcGZC7YDjuosSRhmDW4rVxzpXvWHRHbcEl2umAc5eD4f9Oh/9NlVGfTJ4vvZPp47iK7Gl41RXCn/zhsKOF0mjsFPZDHQh1+ZUDjCXLgx7PzkVP6l1tADIRo6ELq6ORIWJxz+rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wJn94qqp/VVDE4J1gTGd2GOifKuCY7EyWkcydTz4ugc=;
 b=lsKaJxxZRPddbSjo6yfVBcY13tnjzSKpQEZ0TcwVhbpfP3v4GDPKDI9nAM4aq1tYLWr/3waALJSfJx/Yg7Dao07L2P1gv8K37CM1ZC3lc6pKAJtpLqPtHf7WYBcpNQ2JDg1cNGAfbky0hSn3u6XAdC/uGQLAurOf/kM186cutcyExMsfPLlVDCM46B00pUgGN5cmJ1A3hsB6WUf8TA3spGa48Dla4wKhmXREr60hV0hWJzsoLwAhtdVOlqqBjBbwDzb/RNr12hhIDpKLmwl4K1JPS/W0r2+B2zCTvCN+yKEpCTpUXRBaqT7uAKQzhU/Oa2ToHq2g9nwtpHNVVY/jDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wJn94qqp/VVDE4J1gTGd2GOifKuCY7EyWkcydTz4ugc=;
 b=AueR/1jIvu+jgjjNiyd6c1GF1FSd+W6sZjitOGEeDy4z1+rCPu6luVk9J1YztJ1ovro+afGi4dGoJrlo/XpAzXdCV7vIM+HMPkz2ASrWTeyQ3BLZ6nJ2yjaW5EhBS+uEU9JMXdOs7mfkSMUtURzuxlGkCxHNo6KZbG0E5MGpwrUNRgJJFknbGWw2//y+Ycj0QYjPoeyGjwGZH2lWeo7RD/uBbeutjuC9crqHhZ/HqdR/83Irtj2Jhl8HTVPx+2HPCu21vJWb8PrbyFKsf2EYYeTapp9lE1AP6boR1xpR6GLEE1m8NaV5gSefJBbz9Rd/5myrCfZ/NxyMrvdCnb4/ug==
Received: from BN7PR02CA0035.namprd02.prod.outlook.com (2603:10b6:408:20::48)
 by DM6PR12MB3131.namprd12.prod.outlook.com (2603:10b6:5:11d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Mon, 15 Mar
 2021 14:53:09 +0000
Received: from BN8NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:20:cafe::36) by BN7PR02CA0035.outlook.office365.com
 (2603:10b6:408:20::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend
 Transport; Mon, 15 Mar 2021 14:53:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT015.mail.protection.outlook.com (10.13.176.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Mon, 15 Mar 2021 14:53:09 +0000
Received: from [172.27.11.76] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Mar
 2021 14:53:05 +0000
Subject: Re: [PATCH net-next v3 15/16] net/mlx5e: take the rtnl lock when
 calling netif_set_xps_queue
To:     Antoine Tenart <atenart@kernel.org>,
        Saeed Mahameed <saeed@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, <alexander.duyck@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>
References: <20210312150444.355207-1-atenart@kernel.org>
 <20210312150444.355207-16-atenart@kernel.org>
 <c6a4224370e57d31b1f28e27e7a7d4e1ab237ec2.camel@kernel.org>
 <161579751342.3996.7266999681235546580@kwain.local>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
Message-ID: <5ae00a7f-2614-cc0f-1e8a-c6d8d19170f9@nvidia.com>
Date:   Mon, 15 Mar 2021 16:53:02 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <161579751342.3996.7266999681235546580@kwain.local>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb97d2c6-6969-4896-4ab9-08d8e7c20ca0
X-MS-TrafficTypeDiagnostic: DM6PR12MB3131:
X-Microsoft-Antispam-PRVS: <DM6PR12MB313195246C0F7D8CAC16CC12DC6C9@DM6PR12MB3131.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ib9McgCxvW2+o71UmNjdv9L4zEaWC6D+QTG8d/oSVOqAhU+z/eKToxDiqiXDV9lxCuRO56MR1O+HzuRjrfGfSU7fRe5E8sKbg0SZ/5/TZ9D8BRJR2BNw3hP6Ekk6FvhHtzP5pWqaO/PHjmiO33XRDR3rF3RVN+aoT8iA5WO1PglzqY1dKY27gVKOmHktq0oEWRmuJFhg03pTfr8E2atH1KLKH3dzRxMC4RRa+4ucpOZkTRdMa7PkszbSnZlTZAQF2WZHgS42BsUYueWOTYfptd7tYLcJ19/UtnghpC93SPtE72bGmmhuoBqr8jAIIuRmX8/Kcl+52X/yfBxOg4RcgxbRyJmHDdhvgtkVgnFkzuJfHepV0OaTqJVM/I7irmKDOpAt3vnSBZsHo4VN4cANh/s4SRcdeUA1POnEc4H6/vg9uVpRZowWDfYIc6ZGct87Aqxy1WP998F2btbRoxHvvMFk9Dq27nENv9x2o0jETE7QTg8CUwhnlS/opMSPjXKj5epO74Hk02SRTorT8VOqFZGDQRysbr8uqX6WvPhPnzvdpHsieSg8qL3rksee2yv2GFVcLykycBMTCb9B1o8Q6u4RM03XSPbheuYcT5Ysym4CRdYc7GP75P2GwiRKHgBLNqKVZGwR+y9Q11+E4wY9FcCy/Omklp5CdSv2KJ0GM3yxpDYCtSuoIyQc38dfGcV8uxSl+tjdJNUow6Gp8Vwizw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(39860400002)(376002)(46966006)(36840700001)(316002)(36860700001)(8936002)(31696002)(86362001)(36906005)(16576012)(70586007)(336012)(16526019)(186003)(478600001)(26005)(6666004)(47076005)(426003)(2906002)(83380400001)(2616005)(4326008)(82310400003)(34020700004)(7636003)(36756003)(5660300002)(82740400003)(110136005)(70206006)(31686004)(53546011)(8676002)(356005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 14:53:09.2839
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fb97d2c6-6969-4896-4ab9-08d8e7c20ca0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3131
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-15 10:38, Antoine Tenart wrote:
> Quoting Saeed Mahameed (2021-03-12 21:54:18)
>> On Fri, 2021-03-12 at 16:04 +0100, Antoine Tenart wrote:
>>> netif_set_xps_queue must be called with the rtnl lock taken, and this
>>> is
>>> now enforced using ASSERT_RTNL(). mlx5e_attach_netdev was taking the
>>> lock conditionally, fix this by taking the rtnl lock all the time.
>>>
>>> Signed-off-by: Antoine Tenart <atenart@kernel.org>
>>> ---
>>>   drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 11 +++--------
>>>   1 file changed, 3 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>>> b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>>> index ec2fcb2a2977..96cba86b9f0d 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>>> @@ -5557,7 +5557,6 @@ static void mlx5e_update_features(struct
>>> net_device *netdev)
>>>   
>>>   int mlx5e_attach_netdev(struct mlx5e_priv *priv)
>>>   {
>>> -       const bool take_rtnl = priv->netdev->reg_state ==
>>> NETREG_REGISTERED;
>>>          const struct mlx5e_profile *profile = priv->profile;
>>>          int max_nch;
>>>          int err;
>>> @@ -5578,15 +5577,11 @@ int mlx5e_attach_netdev(struct mlx5e_priv
>>> *priv)
>>>           * 2. Set our default XPS cpumask.
>>>           * 3. Build the RQT.
>>>           *
>>> -        * rtnl_lock is required by netif_set_real_num_*_queues in case
>>> the
>>> -        * netdev has been registered by this point (if this function
>>> was called
>>> -        * in the reload or resume flow).
>>> +        * rtnl_lock is required by netif_set_xps_queue.
>>>           */
>>
>> There is a reason why it is conditional:
>> we had a bug in the past of double locking here:
>>
>> [ 4255.283960] echo/644 is trying to acquire lock:
>>
>>   [ 4255.285092] ffffffff85101f90 (rtnl_mutex){+..}, at:
>> mlx5e_attach_netdev0xd4/0×3d0 [mlx5_core]
>>
>>   [ 4255.287264]
>>
>>   [ 4255.287264] but task is already holding lock:
>>
>>   [ 4255.288971] ffffffff85101f90 (rtnl_mutex){+..}, at:
>> ipoib_vlan_add0×7c/0×2d0 [ib_ipoib]
>>
>> ipoib_vlan_add is called under rtnl and will eventually call
>> mlx5e_attach_netdev, we don't have much control over this in mlx5
>> driver since the rdma stack provides a per-prepared netdev to attach to
>> our hw. maybe it is time we had a nested rtnl lock ..
> 
> Thanks for the explanation. So as you said, we can't based the locking
> decision only on the driver own state / information...
> 
> What about `take_rtnl = !rtnl_is_locked();`?

It won't work, because the lock may be taken by some other unrelated 
thread. By doing `if (!rtnl_is_locked()) rtnl_lock()` we defeat the 
purpose of the lock, because we will proceed to the critical section 
even if we should wait until some other thread releases the lock.

> Thanks!
> Antoine
> 

