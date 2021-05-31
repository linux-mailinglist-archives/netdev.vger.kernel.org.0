Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E736B395974
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 13:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhEaLLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 07:11:47 -0400
Received: from mail-dm6nam08on2053.outbound.protection.outlook.com ([40.107.102.53]:6587
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230518AbhEaLLp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 07:11:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UTtzXAQM+lMSt2M5oT2uxTx/rHL2crpkKAzCie6f2YoopKpb0lE9z6ygiIF930/g6XfY2Elw0dGH3mv/jEzTRLq60NAi+SgT0pLByUj8WZGLsYPfR8WdL5pnfOz7nqWLujjfRVlCevb+D4261QSrNl9FeGCKJqNoD3jlbmHKZ7n8artwj8Hhw4a1Pm0/uZm+ptVwNzguL8u/KEx2p/IyF7vJsIp1+bx7zDP7NGd12aOjSQOeoHOa15UwAXcjHkTJsuR2lQUYPIdcOh14Dbv7pXrz7TqGaoTduZ0LWWqIee5VzaFFmNOMkfKEqdkq/+zqmSIfOOEY1x5ZyNcjK5HHGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ldr3qPnIyrAbPxQDPyUXICk5zrUyRU9sMmU0UDpDfg0=;
 b=FAHmkGBT7cLK4RrjJEiDSCanornLi+Ntv8BJmuJTl83vWcyom1Z3dJPkFh1H2M4MbEmAZy2H2CtkI+8TB8Wssw2srj2qDtJVU1+xhtyKmxyxijRLLg1WoHWpt/DtzAoKuDm6OFqGUxSs1KGSW110OCEGHY1busVQqmB3MKH0JjLGAZmbayzN1+oNwM1CJKcNclftl9biE8ShXu409KMudPg/9o6XPh9t8C8sdiVZOQ8320sL1jznLGHWEU5Ow3qYXYNOcG+Q8TwbaMdRNmnJ1fK3fBWCjcKjYaHjCg8aIFh4pky5FK3akBQhREWXj0tZv3InPyYm8JUK3P3T80Up7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ldr3qPnIyrAbPxQDPyUXICk5zrUyRU9sMmU0UDpDfg0=;
 b=H/wcRFaaOhi0ydtOsUnSGLNWNnwvNLvygcWEoRlmxzrIcm4o7uKsagTRZ0QRgIKKU2wZ0mMCTUsT0ix3LwcSQ85pJ5ZMf9Dsx9MgaypeKH22YbH60mEnjQdjlJ1udPVRy/cT4CKZ7lW/EdGkJ/1ZhwNCp7fvFE+LLuZDmm/upFSRflxZIWtamG8yzc8pQBZyeKTcVLiI2F8GlkCSsCS5+FxzNl3owBJ2uXCchFoKvS4m7MgBRajjoCgTSMqwn4Xo6qFrvkjnK7b914XKoDJclTTHa9UOMRg3FNXru+ZWjzw4EzwS46n05RQTZUksYF2sdV2Phy42Izg17epL9pobxQ==
Received: from MW4PR03CA0234.namprd03.prod.outlook.com (2603:10b6:303:b9::29)
 by DM6PR12MB3865.namprd12.prod.outlook.com (2603:10b6:5:1c4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Mon, 31 May
 2021 11:10:05 +0000
Received: from CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b9:cafe::28) by MW4PR03CA0234.outlook.office365.com
 (2603:10b6:303:b9::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22 via Frontend
 Transport; Mon, 31 May 2021 11:10:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT019.mail.protection.outlook.com (10.13.175.57) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Mon, 31 May 2021 11:10:04 +0000
Received: from [172.27.12.2] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 31 May
 2021 11:09:59 +0000
Subject: Re: [PATCH net 2/2] net/tls: Fix use-after-free after the TLS device
 goes down and up
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Aviad Yehezkel <aviadye@nvidia.com>,
        "Tariq Toukan" <tariqt@nvidia.com>, <netdev@vger.kernel.org>
References: <20210524121220.1577321-1-maximmi@nvidia.com>
 <20210524121220.1577321-3-maximmi@nvidia.com>
 <20210525103915.05264e8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <afa246d3-acfd-f3be-445c-3beace105c8f@nvidia.com>
 <20210528124421.12a84cb7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
Message-ID: <03669e23-0697-7a96-3d49-202e045cbf48@nvidia.com>
Date:   Mon, 31 May 2021 14:09:56 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210528124421.12a84cb7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16d9acf6-4a9c-454f-2885-08d92424a497
X-MS-TrafficTypeDiagnostic: DM6PR12MB3865:
X-Microsoft-Antispam-PRVS: <DM6PR12MB386564FA27CD543354180773DC3F9@DM6PR12MB3865.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PQFZOUSoyr9ei5oun3+7uCMrKGllnzoLTS3h1bOwyME4qBzv0OdNoV8Sa6vuK3r8p5Hn0fOPOWyhXzV1kDfmAECLV00SHLV6sF1A+U46kO+83k89udProcEwLdGjxf1xZ042tqZmjE1ZemmxCC+TBPx9UbPktX/onLAdefMYetz0GSmTZhYzoaqs9QtFPNV//OoKT3NeJNkaZCNUw6avOvSLmea/gdSG8Ugo6toOyIa/kGhKd6CnUNIlG63RYF3YW3GND2beSeAt5r5pAL9sZ7c9cV44gYUr4htdUwkfomO5GNIHPcE1IPUXdZr0k1bUEDJbGHXgObFcXGmomGQaAXh/+PxGtu/cGv69+bh3KF2IqyA7WVu7HMiZSamTOgTyBeEbU2qDZRXaWva8DN0MwyQkhGH2Bbtkb9R9K8zehFB83pUazlm/Em8ZYvBO2kHQkg6xcjUxbgL7z2REKIP4cH8Pqk/FPgLfJjyEF83xhZ72+IBDcBD+EQZvvmWfVFtjCJTL01Ak59BXCHlVJjjFV/vy9IkOIz8YgcMEnGv7T0AF3UwEUh/r8kMpVln7yibYcj3n2B50ZZDtAGT3RotkOYKEmZzwGFwXkb4lfFpRfwThiLKLA6VG7iQ4d+iDNO+G662BJlNRSplwE4lHRLMVUn74fFea859FsqNkmHafjnxOPyetb5ndsmrXnvZJgxfn
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(376002)(39860400002)(46966006)(36840700001)(6666004)(36906005)(16576012)(316002)(31686004)(36756003)(53546011)(356005)(6916009)(4326008)(70586007)(86362001)(82740400003)(54906003)(2616005)(26005)(5660300002)(8676002)(70206006)(8936002)(82310400003)(336012)(16526019)(186003)(426003)(478600001)(7636003)(47076005)(31696002)(36860700001)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2021 11:10:04.7338
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 16d9acf6-4a9c-454f-2885-08d92424a497
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3865
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-05-28 22:44, Jakub Kicinski wrote:
> On Fri, 28 May 2021 15:40:38 +0300 Maxim Mikityanskiy wrote:
>>>> @@ -961,6 +964,17 @@ int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx,
>>>>    
>>>>    	ctx->sw.decrypted |= is_decrypted;
>>>>    
>>>> +	if (unlikely(test_bit(TLS_RX_DEV_DEGRADED, &tls_ctx->flags))) {
>>>
>>> Why not put the check in tls_device_core_ctrl_rx_resync()?
>>> Would be less code, right?
>>
>> I see what you mean, and I considered this option, but I think my option
>> has better readability and is more future-proof. By doing an early
>> return, I skip all code irrelevant to the degraded mode, and even though
>> changing ctx->resync_nh_reset won't have effect in the degraded mode, it
>> will be easier for readers to understand that this part of code is not
>> relevant. Furthermore, if someone decides to add more code to
>> !is_encrypted branches in the future, there is a chance that the
>> degraded mode will be missed from consideration. With the early return
>> there is not problem, but if I follow your suggestion and do the check
>> only under is_encrypted, a future contributor unfamiliar with this
>> "degraded flow" might fail to add that check where it will be needed.
>>
>> This was the reason I implemented it this way. What do you think?
> 
> In general "someone may miss this in the future" is better served by
> adding a test case than code duplication. But we don't have infra to
> fake-offload TLS so I don't feel strongly. You can keep as is if that's
> your preference.

Yeah, I agree that we would benefit from having unit tests for such 
flows. But as we don't have the needed infrastructure, and you are fine 
with the current implementation, I'll keep it. The only thing I need to 
fix when resubmitting is the unneeded EXPORT_SYMBOL_GPL, right?

Thanks for reviewing.

> 

