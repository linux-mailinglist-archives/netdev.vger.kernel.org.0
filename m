Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A22A13C3BB6
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 13:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbhGKLMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 07:12:07 -0400
Received: from mail-bn8nam11on2085.outbound.protection.outlook.com ([40.107.236.85]:48224
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232600AbhGKLMG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Jul 2021 07:12:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SBYsGYb8KlUDr01iWyLPQ6LiTMs5OPJmUcR9D4Zt2Jzx/eo2x0RGXPKIyiz4QzaPM+Y1WueKONRaa9JI+jCRSSD0cthp3nWB4hl4HF273OQWL182QeAMFn3VAF+/LwuoPJbPK1E+gcUvf3ulh7Dy45mBnLKllKxQhXlNJ0ztgbFnVUGt4GyHDdp4D0K2mXILdS7MDSNCbnkbGbNfyE/0eJD7aucgoxtsDCZX3mB0u/0zsrIJ7nNKgltlGsaHNfmi+fqMw1+EM26NdOwXo5IITJlH1eg69+PwAvKNfQdklVXDGFBw0nAaWzuuCsQla5GJIm7Wb2twH4FaZtZ8r33iCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y/fY9jfJu/CKUPfRuAoEZ3IgCymQFPTm368f6T1Mvbk=;
 b=f4duvwULu16BqA6gMUU9wvyWTWdyATN+YGzR3DEFkJdWOlTXPZUJYMloWiepMfSGHzndddMIAT5EbWHtNhnJkEamQ5/1p0CoI4kd/9nDhvI5Kcpd2e0vjZeSYLd4Fd/d6+JmWMSqBDvAWE28hh5AoR01Kdt7uZChwKV+VVC4MYRr4XHUGsvsZkImQT8bT1jXgc5tbfQ365FXPZ3MulRSbEdH+Xv+fi0Fi1Y0vAaR1tvc1En5v55KjN3kckJpZetuWlP2cnSozBHlhSFEO6N4R8w4LBWbx5VzPCUUOcg3uIxlzkxjZitgPHqB5VJfNXtlAG+mvPC70zILD6tgHabNYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y/fY9jfJu/CKUPfRuAoEZ3IgCymQFPTm368f6T1Mvbk=;
 b=gV1Kz+9vBmwVHSWyAIfadtw2GdX11CjTDYj3STIth/n8BoKhQA+p41c6uQMYwKR628AOsAdEq1Alf6IDvdsCqQoKEagYZGwaqo7rH2JiBwVlJTFH6IsCrCwZTRA6s5GFSUWtPUofXV8cKQa6acfAbyg0PYQg0jNELgtAQ0XmbbIYNrq1IUgZTvRAaSbiolGd+6q08hc+b7REhljHzio3+rlRMkPJN3aUqCZPSgVfJmYJ8lmPAYQe3GS0+TDCzC4Vco3Ah3C5GVt11SXXF7YhAkksy2ic062tRLYWabKW5OcwXD1SrpODqWyCPc7+WLaVj3Zn/bCY+7pNO/DbzAxlkQ==
Received: from BN9PR03CA0631.namprd03.prod.outlook.com (2603:10b6:408:13b::6)
 by MWHPR12MB1791.namprd12.prod.outlook.com (2603:10b6:300:113::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Sun, 11 Jul
 2021 11:09:18 +0000
Received: from BN8NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13b:cafe::d9) by BN9PR03CA0631.outlook.office365.com
 (2603:10b6:408:13b::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend
 Transport; Sun, 11 Jul 2021 11:09:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT053.mail.protection.outlook.com (10.13.177.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Sun, 11 Jul 2021 11:09:17 +0000
Received: from [172.27.15.179] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 11 Jul
 2021 11:09:15 +0000
Subject: Re: [PATCHv5 iproute2] ip route: ignore ENOENT during save if
 RT_TABLE_MAIN is being dumped
From:   Roi Dayan <roid@nvidia.com>
To:     <patchwork-bot+netdevbpf@kernel.org>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
CC:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>, <avagin@gmail.com>,
        <alexander@mihalicyn.com>
References: <20210707122201.14618-1-alexander.mikhalitsyn@virtuozzo.com>
 <162566940335.13544.6152983012879947638.git-patchwork-notify@kernel.org>
 <fe6efc85-17d3-0fb9-4f61-db5b72bce8e7@nvidia.com>
Message-ID: <d08ccca0-e399-4a8f-d8f9-62251959d716@nvidia.com>
Date:   Sun, 11 Jul 2021 14:09:13 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <fe6efc85-17d3-0fb9-4f61-db5b72bce8e7@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d9d2511-22f6-4d18-a440-08d9445c5382
X-MS-TrafficTypeDiagnostic: MWHPR12MB1791:
X-Microsoft-Antispam-PRVS: <MWHPR12MB17911D2BBFA12E73022BBCA5B8169@MWHPR12MB1791.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dtd9tMGsiXcxxkJVlSigx6kr5mVqnhD1TF6o75umSEUhhVxRQqW70mL6MAoaT1GNvmIhkfULm4oxfXkwXbX4qb5YXdY3VkunX3gnIaO9JOsD9Hyl0DS38Egy+F7sNp23SSZwhKzBaZ+nGdyLRFOCG+sVsyrfNeDVaCwO6LgO5CvezpuuANO2UnX/igOf9hyJU6Y05hQdOPokjeqkLC7jhwv6uLc0yxiBf0Ifu3XA7BWbVhRmlOB4yMq23Hk1TT3FQXfMsJtvKeqdNJDMFh5Jy1zaHIPBxJlES6U3RJ5pGAdDLwcDIGCBJzN6TjNAGl6oI1TL8WXL0CiFklEXfo2/SpT4Xjtz3xM+w66V8N5n3A+67dXfYM/J46TSlT6BeAEI9yXrfF9rd3wNsRf5C40IImVt7jX1PAsON2wvF3gqqm3+pFTL0YY80BnlLx5Gys1x1K18L1/UNqcku4I74rLM+8SqQSijjltgMMTySmDXRnZ5wz+AQlSBQbxwvTl4txNMoKmbkvMNnwjm953+s6eZmWqfBGi5CSoXlUQho6XZLoavO0F1SKhc0f6ZSbwv/ayqnf/AY5NTZoUTIQZ669JmjjNFONDUL+pKtO/DY4aGVZ0zxVIxlwkuM/el7KsbkFPmVH43pY+HSCBsHLXvxYaxJ638A3W7CZftraseZOSawXu0cgxY06VYUkks3OhZuPvImu6u/chGbwgsOLJYQPWEsmqXT3dXYGLAplb/ab0dCTSbjMLqKPdSDL+mMBydCqa7VTl+hoMW2Wz9VIkpNbdU1pTRmB1FDxmfXsTFbAfIf7kis6rwWz3YzXkQO1Ua6kBZmYLiejut2kQaYqaoEns8/Wr3pl/N4WtJ4YAdawMKKIs=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(396003)(36840700001)(46966006)(110136005)(426003)(53546011)(47076005)(83380400001)(36860700001)(34020700004)(82740400003)(31696002)(36906005)(70586007)(316002)(54906003)(16576012)(16526019)(2616005)(4326008)(478600001)(186003)(966005)(356005)(2906002)(26005)(82310400003)(86362001)(336012)(31686004)(8676002)(36756003)(5660300002)(70206006)(7636003)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2021 11:09:17.6477
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d9d2511-22f6-4d18-a440-08d9445c5382
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1791
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-07-11 1:59 PM, Roi Dayan wrote:
> 
> 
> On 2021-07-07 5:50 PM, patchwork-bot+netdevbpf@kernel.org wrote:
>> Hello:
>>
>> This patch was applied to iproute2/iproute2.git (refs/heads/main):
>>
>> On Wed,  7 Jul 2021 15:22:01 +0300 you wrote:
>>> We started to use in-kernel filtering feature which allows to get only
>>> needed tables (see iproute_dump_filter()). From the kernel side it's
>>> implemented in net/ipv4/fib_frontend.c (inet_dump_fib), 
>>> net/ipv6/ip6_fib.c
>>> (inet6_dump_fib). The problem here is that behaviour of "ip route save"
>>> was changed after
>>> c7e6371bc ("ip route: Add protocol, table id and device to dump 
>>> request").
>>> If filters are used, then kernel returns ENOENT error if requested table
>>> is absent, but in newly created net namespace even RT_TABLE_MAIN table
>>> doesn't exist. It is really allocated, for instance, after issuing
>>> "ip l set lo up".
>>>
>>> [...]
>>
>> Here is the summary with links:
>>    - [PATCHv5,iproute2] ip route: ignore ENOENT during save if 
>> RT_TABLE_MAIN is being dumped
>>      
>> https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=459ce6e3d792 
>>
>>
>> You are awesome, thank you!
>> -- 
>> Deet-doot-dot, I am a bot.
>> https://korg.docs.kernel.org/patchwork/pwbot.html
>>
>>
> 
> 
> Hi,
> 
> I didn't get a chance to check but after this commit the utility ss
> is crashing from libnetlink.c
> 
> (gdb) bt
> #0  0x0000000000000000 in ?? ()
> #1  0x0000000000418980 in rtnl_dump_done (a=0x7fffffffdc00, h=0x449c80) 
> at libnetlink.c:734
> #2  rtnl_dump_filter_l (rth=rth@entry=0x7fffffffdcf0, 
> arg=arg@entry=0x7fffffffdc00) at libnetlink.c:893
> #3  0x00000000004197a2 in rtnl_dump_filter_nc 
> (rth=rth@entry=0x7fffffffdcf0, filter=filter@entry=0x40cdf0 
> <show_one_inet_sock>,
>      arg1=arg1@entry=0x7fffffffdca0, nc_flags=nc_flags@entry=0) at 
> libnetlink.c:957
> #4  0x0000000000406dc7 in inet_show_netlink (dump_fp=dump_fp@entry=0x0, 
> protocol=protocol@entry=255, f=0x42e900 <current_filter>) at ss.c:3638
> #5  0x0000000000404db3 in raw_show (f=0x42e900 <current_filter>) at 
> ss.c:3939
> 
> 
> if I revert this commit I can run the ss utility ok.
> 
> Thanks,
> Roi

I found for me ss crashed using a->errhndlr but it could be null
in rtnl_dump_done()

I see a second usage of a->errhndlr in rtnl_dump_error()


