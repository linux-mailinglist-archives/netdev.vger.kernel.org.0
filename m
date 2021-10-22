Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9275437B2F
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 18:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbhJVQ6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 12:58:39 -0400
Received: from mail-sn1anam02on2062.outbound.protection.outlook.com ([40.107.96.62]:34926
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233413AbhJVQ6i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 12:58:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nTSfAd5jfQe81Pwpj2ZcbPcpCQ/7vWHgvUGhbSg5yc8fG6bUNi/tTnIFPuT+7mjdWAcwLJwl/OPEYM1RINt8iaZ2B8p4EfkOAPdMdsGqGTzzaMFntXKZCLNJEWZewe5QyVsl3gpAPrZCig2TvD1/Pvs6fUwqidE0/1P6fvaMm3NH5esSqCJ/sR41BhIBlHZe3iU6NfA7k7rarGNAzBVaomkpffIm+AOgVncJKGd8LxvlGbh0FduxdyyVBmTOz0hsEKU2rJWXci357Dc4g2cj4XQS/sj7Z8vnwPCwgQpHBlKPAwPMZivz1RvhDij239s+ciMilzQLsTP/HdyVjsnJVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wdPVH0zRaJCLsKEtzYc8xoWEooc9kW9V2xlsPZZT0bI=;
 b=Bs9CrrPGAFrCEG1TnHe9hdAo9TPINuSgWnIfGJO8xOAvT+7u8qHddDAfpYw+tBiKw5ZmPk7vf0YAofV36p/XeZnKG0BhhwLU2Hmstf03gqNhyFVqPa+QG7LQGBGqrxHYObYe9KCAjuLNZBdp5cI7ldTr7brFfrbhVb1C6BXD+pfbN2pGdZppHSQSz1xjyHlEfnX0xGjx18oJqogotIoDRu5lj3xMPOP0l3bLQRikz7PPL0BDTpGxRAFibozQN8X6frP5vNzU5FR7zRyihO4ctPtRIBAKy2+5oVpMVMIF5023K1p1vIWp+ht3/H0fhMNIsdi4vpxzFOaJhnLLy5IlyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wdPVH0zRaJCLsKEtzYc8xoWEooc9kW9V2xlsPZZT0bI=;
 b=hYxQe93ltWu7bIWbCs+2JoTGae1dIK4fNkxCYcLbXiUurLm10EMq2BN4XUn5y5FGAgNPZSDwGXHVinlBlckhnp5dRt9CEaNix+a1O+N4rv8LmFRnXSePwj4AdYka5sE7IObhqWuVwJjJZHMJ2avmeHQBrVXpMVT1sqP+r2o/1MguADVf147YuhDjkMQLhWErRaHaIkwm2SiwIqbmBP5UNWJ7HuPhE422kDdimOfsZc3yvOM3mb5ryWm+x9zHf5JO/rvHCsvn1Jd2jFcalDxl40mi0Wn9qNBOoJOVzqxesJMZiecUSdVNZeFzcu3miygEnNQfIPZcFNfV6gWNqZq7Cg==
Received: from MW4P220CA0008.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::13)
 by SA0PR12MB4397.namprd12.prod.outlook.com (2603:10b6:806:93::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 16:56:19 +0000
Received: from CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:115:cafe::c6) by MW4P220CA0008.outlook.office365.com
 (2603:10b6:303:115::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend
 Transport; Fri, 22 Oct 2021 16:56:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT017.mail.protection.outlook.com (10.13.175.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Fri, 22 Oct 2021 16:56:18 +0000
Received: from [172.27.0.234] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 22 Oct
 2021 16:56:09 +0000
Message-ID: <533129a4-7f4e-e7a6-407c-f15b6acbb0e2@nvidia.com>
Date:   Fri, 22 Oct 2021 19:56:06 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH bpf-next 09/10] bpf: Add a helper to issue timestamp
 cookies in XDP
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        "Lorenz Bauer" <lmb@cloudflare.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Brendan Jackman <jackmanb@google.com>,
        Florent Revest <revest@chromium.org>,
        Joe Stringer <joe@cilium.io>, Tariq Toukan <tariqt@nvidia.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        <clang-built-linux@googlegroups.com>
References: <20211019144655.3483197-1-maximmi@nvidia.com>
 <20211019144655.3483197-10-maximmi@nvidia.com>
 <CACAyw9_MT-+n_b1pLYrU+m6OicgRcndEBiOwb5Kc1w0CANd_9A@mail.gmail.com>
 <87y26nekoc.fsf@toke.dk>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <87y26nekoc.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f7bc98e-8656-416f-159b-08d9957cde61
X-MS-TrafficTypeDiagnostic: SA0PR12MB4397:
X-Microsoft-Antispam-PRVS: <SA0PR12MB439772C321F64F784FD73919DC809@SA0PR12MB4397.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WMeWS9/0Li6T+7UGc3awXQu5cofrYd9xt9zCDV0H01+n01ijn5jQrUiimluGgeoaMu7vWbXAj+fBWpkQ/Kipku7/GkXNweXIUsZ+vvI5gzWDoWoifH2ejPHbwZ2cwu6gOgOHVHajxOpCuoThqjDnV1kqPB7zKXdHPFlHGDaYf/f+UIJ0b/KJzCtqZpzKdHrM2tYZjM9MqJFHzOGvfE23L/+BXSRQDs4H89YLJqWaPROCmL9bsRzKm2JSPRVFFDYSXQaPOw+xHFgvcz0DXj/gsvErRUids/afjqr75u8Y3bB26shlMyw7JgzZRN31PSw5xTbbQHV8B96SKdatz2x4Bk+AQRttGa6FKcuOslkriTwUzQRx5Kiv8u+xVRZBnkXsZ04Hh1tf8WlKMvKHLwpAToqmH3mqa9t1minxc0fZ0CgsFec7eZW9FQhqWTBGyzlecUUJ5ITFAPnnpogFmxJCOe8zb1XI8ePh7WI4/LwtiXOnI+f1cB1pU+5Yjf5sRzyiKcve9/rd0ZAGxM8tXZjf0C3kbC68iIBl6Jlvb7eEiRWkqd6llmIJq+0ccb+PUPWNAks0D/61HU3+nDGuSH1gVenysKawhKsOqFBXkHKjKrkDZscI6rsDZdMGd2ku7OdXXf9kEhIvWL0KD9jcgfLs+6HVZLp4o6Td02Qg3JJ7HVWl10Y2nSYbZ6pK35MdTgfJpCEMroP/5lFLGW+M15kyHlwEd2DmNP9c5qGXMrdEurg=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(8676002)(82310400003)(53546011)(36756003)(36860700001)(8936002)(70206006)(4326008)(186003)(16576012)(36906005)(426003)(356005)(83380400001)(316002)(16526019)(86362001)(508600001)(2616005)(26005)(70586007)(7416002)(47076005)(2906002)(54906003)(7636003)(6666004)(31686004)(4001150100001)(31696002)(5660300002)(4744005)(336012)(110136005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 16:56:18.7914
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f7bc98e-8656-416f-159b-08d9957cde61
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4397
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-10-20 19:16, Toke Høiland-Jørgensen wrote:
> Lorenz Bauer <lmb@cloudflare.com> writes:
> 
>>> +bool cookie_init_timestamp_raw(struct tcphdr *th, __be32 *tsval, __be32 *tsecr)
>>
>> I'm probably missing context, Is there something in this function that
>> means you can't implement it in BPF?
> 
> I was about to reply with some other comments but upon closer inspection
> I ended up at the same conclusion: this helper doesn't seem to be needed
> at all?

tcp_time_stamp_raw() uses ktime_get_ns(), while bpf_ktime_get_ns() uses 
ktime_get_mono_fast_ns(). Is it fine to use ktime_get_mono_fast_ns() 
instead of ktime_get_ns()? I'm a bit worried about this note in 
Documentation/core-api/timekeeping.rst:

 > most drivers should never call them,
 > since the time is allowed to jump under certain conditions.
