Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFC63C3BA6
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 12:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbhGKLB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 07:01:58 -0400
Received: from mail-bn8nam12on2057.outbound.protection.outlook.com ([40.107.237.57]:48185
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231183AbhGKLB6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Jul 2021 07:01:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AA4coL8Kfoca1Az9U2CF2sGSP4Mo0Wnp+s8eHBeG4LdDAsRhpM4DdMoXxjmwqtnWJ2n4sRcDXW3wd1hJlvdirqUCGS5GYO+QWpXLk5wg3m89MB7z20YuwDYDUvNIkm2yVkfkcMPbNZO6+QTTzG9KgCUtwWLyYf1rMga2x4y8+exG/YPf721bX3adcU5jHyjSjOP86nev48j5XAy8CX+DQVRRsqvtaBlHF+jFH3VRwMaklHenZoICH21ajgXJsgwfHiDVva2FqCdWwYf9VFbdwSY+KWgBwU2dzXNRWKIwlFS5NIUdhlBaMysqNxIq5bN7NC8tI57G5OarmSTIpP8M9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bqYyFHicXWT/lNshL/ITrsTtfI7O3sxsLNYHJrSwWLc=;
 b=Gv2wn/1NKePcMND5g6x0ISwiMXWOt6BWBmrU/qk7yE9d8wcCILqGB4fb31mu5RsO61B0Z2wsOB0bfDFnBhNIgfMc36rkIqeL6cDw4v4OVmP43DpU/w1My0Md/rRoZSS204AGYSgDLDTqPTFy7TDA9uBlZel6H72syfEGQq1cJwADLiUi/83+cGSkRPERJEz4afb0VopEmdDCCt0HNXWwmN5UPtsnSU3bL9nYcbdzymxz0sJcop4aIAnwW1SDNX33TBWyelz6r4mYRhnqxQ7BjRgIiU2/WhI/JlDZ7DJo8qhF9bm2K1o+8BwSP+XdANDr2q9F/b5gkAm9mXFPrTIC2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bqYyFHicXWT/lNshL/ITrsTtfI7O3sxsLNYHJrSwWLc=;
 b=mpiPW8mLVjnpklzib45FT1VEEYbs1FDlVD5e9X3kLFblx61E5v3XBplasz4ibJa9bD3K/xK/5lrc1an6sq0r1mlFg2SROsduPpuRLLJ3c0hrsZI5SVMNJ4oyGsFYWPxrAesW/18eRgLWScbN6SM8g0nWZ4GwO+Obp1G6lgZXDhNtrT9wPnliWWFxtrrUlrX25DyQubVqXrD4VTfu/bm58ZRWpj6m97IGV8KogGTaZg8Lf6XdWGkRFuzGc7sUJ4XgrUSCKdez5r1jg9VoUMcj1OgVUwbCSLi1oOpdth3IFWo6owmWBackNgp/1W3DiM1N1n+F0rEtBqDz3xiAvGCNXA==
Received: from BN9PR03CA0473.namprd03.prod.outlook.com (2603:10b6:408:139::28)
 by DM5PR12MB1707.namprd12.prod.outlook.com (2603:10b6:3:108::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Sun, 11 Jul
 2021 10:59:10 +0000
Received: from BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:139:cafe::36) by BN9PR03CA0473.outlook.office365.com
 (2603:10b6:408:139::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend
 Transport; Sun, 11 Jul 2021 10:59:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT039.mail.protection.outlook.com (10.13.177.169) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Sun, 11 Jul 2021 10:59:10 +0000
Received: from [172.27.15.179] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 11 Jul
 2021 10:59:06 +0000
Subject: Re: [PATCHv5 iproute2] ip route: ignore ENOENT during save if
 RT_TABLE_MAIN is being dumped
To:     <patchwork-bot+netdevbpf@kernel.org>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
CC:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>, <avagin@gmail.com>,
        <alexander@mihalicyn.com>
References: <20210707122201.14618-1-alexander.mikhalitsyn@virtuozzo.com>
 <162566940335.13544.6152983012879947638.git-patchwork-notify@kernel.org>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <fe6efc85-17d3-0fb9-4f61-db5b72bce8e7@nvidia.com>
Date:   Sun, 11 Jul 2021 13:59:04 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <162566940335.13544.6152983012879947638.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c8ea2cf-c1ee-4ddf-153f-08d9445ae957
X-MS-TrafficTypeDiagnostic: DM5PR12MB1707:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1707314BBB88A6E517DBF44EB8169@DM5PR12MB1707.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sBq7qA519f9cybBC9frHSrsZp1yksrqwbrXZmupaddcIXYvmJ3fcnf09ZbP1Tyz9Xa8mZcXJy1ZmllqkqaKKnkD/CBy00OEkEfKgK7p8oCSZ5hAn23igxaX6j0aQQxdEnChxY2aO5/VKo8aKzjBbkJ5JbFqgY1JArNmiJkEpsbYKlupWJXlkaSQdcs268qDYf4lsI7yBt+Y+CNYoB6m+kjf9uquLMTsp80yrgKEXtvaaml7givOunHk0s2PNnls/vKsAkfznUXSb2BQxQauF4ecDIf3Xer0tOOkuZsmKklMOnCLQMiBf/sV6kRXOoSXFoykWW4oJbgnUWGTVPsKfVAWqZ/v2XHEx6/Cdn5oiuT3GF0L6kYP5Sc5yZNS7iM92oayWTVFVBw3WxGyiPqCe7/hyH8fvS7GPohokCjz43HKjBr6jaqtHFnYWcuQsPEIhS83lW570/+TYQrU7DFWyxmcmRcFLdSoBa/Kdwod3R+6Gf1chfJl5UqYEE7ZbBsosR6vqvZtVc0n+p4sVq+LHOW36SSdaSaCKevTJN2l5PwiIJGHbT36Wb8DuZw2+GL0CsSJWu1be3IX0FFpi1t8Oou/dy31IGOXVdyQJqFpBxw4indCBxx3u6j8Q6Uln/o+J4fe2AlsYupVKg7iJH0ZWqEtFNxgjgVrno/nM0FAFPDNyO0Q3XP2w9c8D1wpFAuV58/8J2KKMODgZOrvye+OJzjQfJEDwLO/KMwuOnXPkHWRyarZt2mE1TUJz7G33oKeL6K5xrZPBD1v1Ze9iI23vUTt933ZvRKB//8Wk7xrP7ChI95RnOvdrHaaz152eax47l5BUJzmkfT/2SboNmBxL9q+zpni74O0UXWTZpiZUkXg=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(376002)(396003)(36840700001)(46966006)(16576012)(7636003)(966005)(110136005)(356005)(316002)(83380400001)(4326008)(82740400003)(31696002)(16526019)(2616005)(2906002)(478600001)(8936002)(336012)(426003)(82310400003)(36906005)(54906003)(8676002)(70586007)(36860700001)(53546011)(70206006)(186003)(5660300002)(47076005)(86362001)(36756003)(26005)(34020700004)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2021 10:59:10.0240
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c8ea2cf-c1ee-4ddf-153f-08d9445ae957
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1707
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-07-07 5:50 PM, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This patch was applied to iproute2/iproute2.git (refs/heads/main):
> 
> On Wed,  7 Jul 2021 15:22:01 +0300 you wrote:
>> We started to use in-kernel filtering feature which allows to get only
>> needed tables (see iproute_dump_filter()). From the kernel side it's
>> implemented in net/ipv4/fib_frontend.c (inet_dump_fib), net/ipv6/ip6_fib.c
>> (inet6_dump_fib). The problem here is that behaviour of "ip route save"
>> was changed after
>> c7e6371bc ("ip route: Add protocol, table id and device to dump request").
>> If filters are used, then kernel returns ENOENT error if requested table
>> is absent, but in newly created net namespace even RT_TABLE_MAIN table
>> doesn't exist. It is really allocated, for instance, after issuing
>> "ip l set lo up".
>>
>> [...]
> 
> Here is the summary with links:
>    - [PATCHv5,iproute2] ip route: ignore ENOENT during save if RT_TABLE_MAIN is being dumped
>      https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=459ce6e3d792
> 
> You are awesome, thank you!
> --
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html
> 
> 


Hi,

I didn't get a chance to check but after this commit the utility ss
is crashing from libnetlink.c

(gdb) bt
#0  0x0000000000000000 in ?? ()
#1  0x0000000000418980 in rtnl_dump_done (a=0x7fffffffdc00, h=0x449c80) 
at libnetlink.c:734
#2  rtnl_dump_filter_l (rth=rth@entry=0x7fffffffdcf0, 
arg=arg@entry=0x7fffffffdc00) at libnetlink.c:893
#3  0x00000000004197a2 in rtnl_dump_filter_nc 
(rth=rth@entry=0x7fffffffdcf0, filter=filter@entry=0x40cdf0 
<show_one_inet_sock>,
     arg1=arg1@entry=0x7fffffffdca0, nc_flags=nc_flags@entry=0) at 
libnetlink.c:957
#4  0x0000000000406dc7 in inet_show_netlink (dump_fp=dump_fp@entry=0x0, 
protocol=protocol@entry=255, f=0x42e900 <current_filter>) at ss.c:3638
#5  0x0000000000404db3 in raw_show (f=0x42e900 <current_filter>) at 
ss.c:3939


if I revert this commit I can run the ss utility ok.

Thanks,
Roi
