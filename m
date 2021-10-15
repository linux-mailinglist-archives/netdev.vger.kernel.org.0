Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D615442F26D
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 15:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239439AbhJON3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 09:29:43 -0400
Received: from mail-mw2nam10on2064.outbound.protection.outlook.com ([40.107.94.64]:1537
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239479AbhJON3a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 09:29:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SeIFd7fBmhlkTc7ZqyT+mUcdbivS9nIBZbn9334fe4dy46O6u8MH8Ll8ZrkSJfuCoDHvDpy7/IDVlKTT4zsf9ZVqLqjvScZiIJ0gA1/paIWZn/qsbBvsKdBUviQhN2W3p9yqEf/J02UxgZmQPyrLWN6nmF3y1W1pfmELa+77T2I5aAi84yMInHzWjcoDQXWAwghcZpDU98z3YGQHQkiqAL48q9qN5b0WwD1QPVh7sWWAhoNoeaulSy7sqk2psYnl9LifYOzxk4ZXbQxYxaGbFNlt8r9wovOPyHwyW09LFl1wCtMtyKtCK/W8or18Suv2rqVO1u09lCZroEa2K5d+/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fGO1bd0WTPJghSQvGyjV1Gg/sDfNiXiSEWabPVsB6Qc=;
 b=mV2pM96i72OHEuIBVjQFgyGphR01XVPkjdnIWSOj3oBOvm/hcV0kTrfRPc74lGLWIDi2LfFVhD5aHgE43xpoeYPLULxqXBglxL6Mllz7BSUsB2Q+uyut8G8caG6krOMKyKGx2JKmxeh4cuRxYSxXpAtTD91TFE8/AS5oyNk/x82yXMwxN2A+8y4I+AGsc9zrzlEn5fS5N6a+GUiuGI8Z+6ts/iNQhAMiT90imCHbMG5pF2kBBJQCwxeQ/e0E7/+z/xo19nYGmZNgql6lWatWXG+hEKwvBU52hryKgDp5S5YtW/wC4vNOiqHysx9MUVum/37UfOt1U98U9bkEUWRtdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=iogearbox.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fGO1bd0WTPJghSQvGyjV1Gg/sDfNiXiSEWabPVsB6Qc=;
 b=K5pyBa/TkD6wmGJiHeH1W3CWeZVODw3CmGA/HTl7nwz7expjzu/4b/0QOvBKLrUoheKawL5tkr5NsiiXAM7nkIv7LlMHP87TY9NUtTyU+qS4yAVaBK3YQ+VarTAi2kRRvXoRcLaSP//Q7ewfwYB7JCxWw7EIPpBPMOj7dOLG8QxEFStKNUXK0gTf9JgunMLlJlnF0hq8Dd1mvzZx0xFKZFO/XJ/kXso/IqJeuwINMEeGjbUMhHKp6ruIVFtCQIYlFXZQgXVifHbAcn5FWPS6Cb9FEKy54e4WLzKM+t4QV0S3NhNIMpFGEzCxtm3cxP8QJJDLKRda7mzYnBOghQa7Pg==
Received: from BN1PR10CA0030.namprd10.prod.outlook.com (2603:10b6:408:e0::35)
 by BY5PR12MB3971.namprd12.prod.outlook.com (2603:10b6:a03:1a5::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14; Fri, 15 Oct
 2021 13:27:22 +0000
Received: from BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e0:cafe::b9) by BN1PR10CA0030.outlook.office365.com
 (2603:10b6:408:e0::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend
 Transport; Fri, 15 Oct 2021 13:27:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT049.mail.protection.outlook.com (10.13.177.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Fri, 15 Oct 2021 13:27:21 +0000
Received: from [172.27.0.47] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 15 Oct
 2021 13:27:14 +0000
Message-ID: <132eb082-c646-765b-7b32-8a9943d10d0e@nvidia.com>
Date:   Fri, 15 Oct 2021 16:27:11 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] mlx5: allow larger xsk chunk_size
Content-Language: en-US
To:     Tariq Toukan <ttoukan.linux@gmail.com>,
        Arnd Bergmann <arnd@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Aya Levin <ayal@nvidia.com>,
        "Eran Ben Elisha" <eranbe@nvidia.com>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <llvm@lists.linux.dev>
References: <20211013150232.2942146-1-arnd@kernel.org>
 <328f581e-7f1d-efc3-036c-66e729297e9c@gmail.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <328f581e-7f1d-efc3-036c-66e729297e9c@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92ba2d75-f8e3-47d6-55a4-08d98fdf84b6
X-MS-TrafficTypeDiagnostic: BY5PR12MB3971:
X-Microsoft-Antispam-PRVS: <BY5PR12MB3971BBACE02A0CB56ED52417DCB99@BY5PR12MB3971.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TqVrB7r38/tywaecR2AbhRLAmhN49ANy7minKAmKjEOKzvb4Z6yUuXB5YcLHWEyBiLMYM97pQqR9oK1tPuRPeGfA+OuIJnlE8VTifQm2zT4eCwoO3A9m7ImjlPOIhEQs8Ad7C/A163qzz7dSjJuq3HdoaXBdN0+kvnlkHra3Y59ZI4aWJL8h6Cnus6tgQeR/q7NqBUkYgSL/Wiu5SVyA926rahlpFHnbti5ARLV2hcQOI/MaHxId+GYGe9N873X4eClldL54gYir8/zPuU8OXH+4zXBlyhuGN29fXIUq5DgDjqDSSglB8kSnY5MAOQXWpMIKDg2gWBNOlpKcGD4N7iEfJ/kka7eVqLnOkDmBbOcUFHsyqHoXLfykYDARuDQE3tcTbYlVtTGwy3ZAZ//JIlTSGfDd9vuGcF6ZlrHezgkWavLInLLsEN341ntn+0mWQozucLE/udW0TNutnCpfUhxhVcZQSIo78F3Qr2U8dYyNbTk3r3DgoFmaQCmNZKuhnbRjvik7CjLVB4Ce8i05Y+UmgYIkmtBP1KZaI+kthXkihEJRE1ROgaeVQ4mr9OhxDY6Yn5UriByLLOSvDBftD6maAW64/XPlfKbg2Z7eApFWe2WxDU5ANtljwP0wjnpcHPLzSVXe2TPpg9d1QJfsorVeHmG93kcx0Mmss+6uf+YSvtIkhW26Lj0CC/ggbyZ7zzZUpkgrEXxJWbpmG7q5vHsDuA9XFV466WrlVjlmgc0=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(7636003)(8936002)(31696002)(2906002)(31686004)(336012)(508600001)(2616005)(426003)(86362001)(5660300002)(186003)(26005)(6666004)(8676002)(16526019)(36860700001)(316002)(47076005)(4326008)(16576012)(110136005)(53546011)(36756003)(356005)(70586007)(83380400001)(70206006)(7416002)(54906003)(4001150100001)(82310400003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 13:27:21.4697
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 92ba2d75-f8e3-47d6-55a4-08d98fdf84b6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3971
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-10-14 10:32, Tariq Toukan wrote:
> 
> 
> On 10/13/2021 6:02 PM, Arnd Bergmann wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>>
>> When building with 64KB pages, clang points out that xsk->chunk_size
>> can never be PAGE_SIZE:
>>
>> drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c:19:22: error: 
>> result of comparison of constant 65536 with expression of type 'u16' 
>> (aka 'unsigned short') is always false 
>> [-Werror,-Wtautological-constant-out-of-range-compare]
>>          if (xsk->chunk_size > PAGE_SIZE ||
>>              ~~~~~~~~~~~~~~~ ^ ~~~~~~~~~
>>
>> I'm not familiar with the details of this code, but from a quick look
>> I found that it gets assigned from a 32-bit variable that can be
>> PAGE_SIZE, and that the layout of 'xsk' is not part of an ABI or
>> a hardware structure, so extending the members to 32 bits as well
>> should address both the behavior on 64KB page kernels, and the
>> warning I saw.

This change is not enough to fix the behavior. mlx5e_xsk_is_pool_sane 
checks that chunk_size <= 65535. Your patch just silences the warning, 
but doesn't improve 64 KB page support.

While mlx5e_xsk_is_pool_sane is simply a sanity check, it's not enough 
to remove it to support 64 KB pages. It will need careful review of 
assumptions in data path, because many places use 16-bit values for 
packet size and headroom, and it comes down to the hardware interface 
(see mpwrq_get_cqe_byte_cnt - the hardware passes the incoming packet 
size as a 16-bit value) and hardware limitations.

For example, MLX5_MPWQE_LOG_STRIDE_SZ_MAX is defined to 13 (Tariq, is it 
a hardware limitation or just an arbitrary value?), which means the max 
stride size in striding RQ is 2^13 = 8192, which will make the driver 
fall back to legacy RQ (slower). We also need to check if legacy RQ 
works fine with such large buffers, but so far I didn't find any reason 
why not.

I genuinely think allocating 64 KB per packet is waste of memory, and 
supporting it isn't very useful, as long as it's possible to use smaller 
frame sizes, and given that it would be slower because of lack of 
striding RQ support.

It could be implemented as a feature for net-next, though, but only 
after careful testing and expanding all relevant variables (the hardware 
also uses a few bits as flags, so the max frame size will be smaller 
than 2^32 anyway, but hopefully bigger than 2^16 if there are no other 
limitations).

For net, I suggest to silence the warning in some other way (cast type 
before comparing?)

>>
>> In older versions of this code, using PAGE_SIZE was the only
>> possibility, so this would have never worked on 64KB page kernels,
>> but the patch apparently did not address this case completely.
>>
>> Fixes: 282c0c798f8e ("net/mlx5e: Allow XSK frames smaller than a page")
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>>   drivers/net/ethernet/mellanox/mlx5/core/en/params.h | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h 
>> b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
>> index 879ad46d754e..b4167350b6df 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
>> @@ -7,8 +7,8 @@
>>   #include "en.h"
>>   struct mlx5e_xsk_param {
>> -    u16 headroom;
>> -    u16 chunk_size;
>> +    u32 headroom;
>> +    u32 chunk_size;
> 
> Hi Arnd,
> 
> I agree with your arguments about chunk_size.
> Yet I have mixed feelings about extending the headroom. Predating 
> in-driver code uses u16 for headroom (i.e. [1]), while 
> xsk_pool_get_headroom returns u32.
> 
> [1] drivers/net/ethernet/mellanox/mlx5/core/en/params.c :: 
> mlx5e_get_linear_rq_headroom
> 
> As this patch is a fix, let's keep it minimal, only addressing the issue 
> described in title and description.
> We might want to move headroom to u32 all around the driver in a 
> separate patch to -next.
> 
>>   };
>>   struct mlx5e_lro_param {
>>

