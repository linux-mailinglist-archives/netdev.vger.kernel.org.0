Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64CB464CAD
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 12:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348925AbhLALgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 06:36:21 -0500
Received: from mail-mw2nam08on2052.outbound.protection.outlook.com ([40.107.101.52]:18880
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348934AbhLALfJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 06:35:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WlC+KgC2H9lrotqN//HZsJLMGCCj9OMMu59HeV/c/48cDow37fB5NYFTKpZTspsVw2COb3HjvX7qtOdcp3g60AhO5XXeQZT48C8OKGHKg+yUvXGm1VhDhOK7dKpv/m4nKKiN7yRYIO2SwZXNcV2pp8qPMtuXj7Af1J2zHk26vtkuCP28j3bmkV2GJFkDkl2Gg3S11ISNvwcZThHDpi4rmvyWGxE6cb14/lWanZRBslzr9UcR0uLPKtEilWufNsouGQcLy6Da82c/uxMQfQv9FQxoufQ1525Q9wBnDzZbptSJh3YlYQR66GkfMO52a4sKe/jG+bY5RTPk3IkV1a/tCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qbz9PpMvfngPbiASnpAbMCkFUc54ji8YgxNIXM4OHOg=;
 b=AzEkOjSI67Gzedtc7EzvDakubU/d107/ucOGgCbteyVB/YfDk8yoM/+bBIG7zfY3GqVspjurWlbPZJ8EtRrwSJ5HFdZCdEbGuZ4bOzH+LlS6Bf15TOLnzORyUtEjw8QAzsA736b4xGj0EEHySWgp5SXsSys2jZUtxZB7bHg8zK5MpWPNwfLG+H0mc0/Ghn3DXvsxlOJqNJ1skSxpToqNNrIa9WONqL5q8CqHmR8TkkuAAvse2NhA9+BENlMHzGG9xbCeXikaUOfJQgLkel9Ry+TgODyrNQuc6sRLx1jK9CAGXL1rT8tBBAhRAOxVBa+cSwyjsszLdGnWhxKsT6dnOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qbz9PpMvfngPbiASnpAbMCkFUc54ji8YgxNIXM4OHOg=;
 b=Qjx6+uPae37GeLFLy3VGzUNAEYkeLdXVSKH0tISK1EmYY5A+gR/PoWLOkzhqFlt9apo+kQjoRiFtPvLaX2Cv9ziaOiiMIYYQaTMVtJcMLkBhDnGeiGT05lvwTdUbJXKbTSoqSASvDBeYjcIo9mVZGlBVaYe/yKhCOLAYyAUvkJUkT5B8s8VLldqM6YizRN+RVsWdqS9aOw9KRs+F72/DM/w9BAC7Pp2XRGNGzEcrhA6wG8jYKXIOOCHwfcyOjBROT9SYuIQQHqjW45A0Ze283jPBY7f0JhzLl+fco4zvAQ534LVCU7w+OJsrN71SekcnPeUGQ9lkhoO3gfrS/Ecw/Q==
Received: from BN9PR03CA0767.namprd03.prod.outlook.com (2603:10b6:408:13a::22)
 by MWHPR12MB1886.namprd12.prod.outlook.com (2603:10b6:300:10f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Wed, 1 Dec
 2021 11:31:47 +0000
Received: from BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13a:cafe::7b) by BN9PR03CA0767.outlook.office365.com
 (2603:10b6:408:13a::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend
 Transport; Wed, 1 Dec 2021 11:31:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT050.mail.protection.outlook.com (10.13.177.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Wed, 1 Dec 2021 11:31:47 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 1 Dec
 2021 11:31:46 +0000
Received: from [172.27.13.35] (172.20.187.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Wed, 1 Dec 2021
 03:31:36 -0800
Message-ID: <6b4b5881-199a-45bf-ade0-7d583ec996e6@nvidia.com>
Date:   Wed, 1 Dec 2021 13:31:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH bpf] bpf: Fix the off-by-two error in range markings
Content-Language: en-US
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        "KP Singh" <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20211130181607.593149-1-maximmi@nvidia.com>
 <3c3512be-91c3-5caf-7e88-155f923404e8@iogearbox.net>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <3c3512be-91c3-5caf-7e88-155f923404e8@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 435b29e7-29c0-4d97-3e8b-08d9b4be28e1
X-MS-TrafficTypeDiagnostic: MWHPR12MB1886:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1886BD5BF64614BEFBDD5E46DC689@MWHPR12MB1886.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZJ/WZjtmdFkNIfQoxBWobj3bEjH87QPH+CGOrm9DJNhJ4Wqaa42ba9Vce+9R7/yfFV9NSstVRVI5xbt/XCLDUu4VK/X/FvUFlRIqMVqlAvNmcRhQ5YN5kTOGvAOyHuCB6icnDBZCdoeGqfrXMlAYyDLhG7EsrKP77vapK/OXct77FVQw7GCs0hYcOxa69kr/tYBywvsN49zFS0jeP63V+pizqMVDh0NnEJAodM+x17E1uozSeSaGKBCd2S8GFn7G0E45laWjE2X31M4LAKjnv6AsB1aRh605fu+KU++J/5eTlZEL9C2S9wzkJJBEOlD6xjMe22NGh7ZLNiDhW684SyOqCXL6HlyPLdNWf/IHkJTxHlv0T1m8WkOY9DU7yhgKs1gjZESgMvO7owryDyzKcTj/1ByRh4Ui+ldl5dpDox9tCcoWadW0mW1CMoXKZdO16iUB/IEUz2pm3ixhol/QLTqgwK73y9V6BA0sndypBemTfwydseYyhhwoK66o1IrNIGQd3Lkqic3abMP+2JCdiBMYFq4TyxgtSaC7LtCuvKQLKe1MuUy7TaXCLniIzg0jWj/Z8aqB2uDB28ZCJB5zZ5X4pn4kWUlOg+dBkEyUxzXPll8lfdO0EgSLwFUeCoFPZKpSbNsamHQbiJKp+3uGzKC/1zOMQezFBPDCzHi7NBpKTNBIKt7bCwji+5WqoQEK5gfjHn/9XuUgFD8wzKCFP4Pb8nbM3ZZp66dOm2oHsesIvmbmQ8uiedvfyrsQhTXfDPN2r8BhRsNyuC57fZFcEocm0MHjNt5yxg15mh5Uf2w=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(4001150100001)(16526019)(186003)(2906002)(8936002)(31696002)(31686004)(2616005)(36756003)(356005)(70586007)(40460700001)(5660300002)(36860700001)(336012)(6666004)(70206006)(6916009)(86362001)(8676002)(7636003)(316002)(47076005)(82310400004)(4326008)(7416002)(54906003)(426003)(508600001)(83380400001)(53546011)(26005)(16576012)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2021 11:31:47.0397
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 435b29e7-29c0-4d97-3e8b-08d9b4be28e1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1886
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-11-30 23:40, Daniel Borkmann wrote:
> On 11/30/21 7:16 PM, Maxim Mikityanskiy wrote:
>> The first commit cited below attempts to fix the off-by-one error that
>> appeared in some comparisons with an open range. Due to this error,
>> arithmetically equivalent pieces of code could get different verdicts
>> from the verifier, for example (pseudocode):
>>
>>    // 1. Passes the verifier:
>>    if (data + 8 > data_end)
>>        return early
>>    read *(u64 *)data, i.e. [data; data+7]
>>
>>    // 2. Rejected by the verifier (should still pass):
>>    if (data + 7 >= data_end)
>>        return early
>>    read *(u64 *)data, i.e. [data; data+7]
>>
>> The attempted fix, however, shifts the range by one in a wrong
>> direction, so the bug not only remains, but also such piece of code
>> starts failing in the verifier:
>>
>>    // 3. Rejected by the verifier, but the check is stricter than in #1.
>>    if (data + 8 >= data_end)
>>        return early
>>    read *(u64 *)data, i.e. [data; data+7]
>>
>> The change performed by that fix converted an off-by-one bug into
>> off-by-two. The second commit cited below added the BPF selftests
>> written to ensure than code chunks like #3 are rejected, however,
>> they should be accepted.
>>
>> This commit fixes the off-by-two error by adjusting new_range in the
>> right direction and fixes the tests by changing the range into the one
>> that should actually fail.
>>
>> Fixes: fb2a311a31d3 ("bpf: fix off by one for range markings with L{T, 
>> E} patterns")
>> Fixes: b37242c773b2 ("bpf: add test cases to bpf selftests to cover 
>> all access tests")
>> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
>> ---
>> After this patch is merged, I'm going to submit another patch to
>> bpf-next, that will add new selftests for this bug.
> 
> Thanks for the fix, pls post the selftests for bpf tree; it's okay to route
> them via bpf so they can go via CI for both trees eventually.

OK, one question though: if I want to cite the commit hash of this patch 
in that patch, shall I want till this one is merged and get the commit 
hash from the bpf tree or should I resubmit them together and just say 
"previous commit"?

Also, I see in patchwork that bpf/vmtest-bpf failed: is it related to my 
patch or is it something known?

Thanks,
Max
