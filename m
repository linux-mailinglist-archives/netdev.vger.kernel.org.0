Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4995D434BEE
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 15:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbhJTNUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 09:20:55 -0400
Received: from mail-dm6nam11on2081.outbound.protection.outlook.com ([40.107.223.81]:43369
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229570AbhJTNUy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 09:20:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XxIJxfzLrdmLzdWAHV9mIaeRL5AkHbZHuNAIRP8Cjm7uzALp8lokOmrOb9MvFJp8VmhiJXHNmkXfaUAeWxjQyiORaI8syB78bIi0j2PxYfEqRat3hx6N3zYU+Y8mqVW6jS9snfHGfezl2bP/RBVayASSHNgFJFqwPUBdsM6VJ5atnb9/7K0FUfyx4yzMLdr3V6fjyFu0vMXwz2N48y9nxxofzmKvScHDP++XiaXY/Vm5Y3dvz0dRoMkMIGXdo8PCegvuMa68zdUfaU/kQqoBnPnIV8sYD6XpXhpPf+8NIJ6txgZFCiMj/IHc75VTYVUHOkcz0NpkXDSVKGbqsr4Ouw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uPM1nyEFlhesTyS2hRfUUZQAKKaTLHcwi0mH0cZEpCM=;
 b=BtEZlH5iH6FKG58lrg5qrGNX7WVIp7K+uZgwbV1x1EyLnI06uA/H/s2ceBClgGWTQGAiHhbk1sZlVaDOMKST9OLaN/WrQ1gnqQ0QWNEwgvL2A6rUT3LwYAHg+HETPu9LfkQ/Cnj6ZdFto0AY4a3mkdUs6+ArdDL3HhgDFOJ5RauQD5G7+TTQtMEDzL124Yf5nZu0YkP3Z0wzbLBwN1sBTTbCx1fMRxO1qz47sgtyDR/NSEM3mDk8QDYf519LkpeeKHQdsMhjoPC1moiP0OjtrHy9720AWdR3yteGUKgDz6OdTssQJ7WVCMoU+kJFZ3OflZAiQLg7jK6Mg3TOFpD/Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uPM1nyEFlhesTyS2hRfUUZQAKKaTLHcwi0mH0cZEpCM=;
 b=slPS78oJlfyJJlF7UUFYewLGBIcdasJ0YnoRDBbeA23XYNWsy9TUQxAppFbNEQTmOWGYBhdfenQ/+MTtqqCjKX4XvwPQtTncPOzxJ9ghD8EIxJXxc//0VlnlBwseF+ULMocWnrrU/S4JqHxapUmhZYYo4Jtjj7VglK+dVWREp+tQCEJUOMX9TXXua42zHujV8T1A2d09heGUEe0LfgEtIBenOncqiClmzW1XJpgyNLOoA3oNybFU9rFl3gcw9UVOzmekLbKbJ/oORNIZtval4dWnGdAzP2I9yM/Y38BhOt1jRJ8YK7lSS1PgsbNUy0ljA6W07j3w6pa83/PTR7uweQ==
Received: from BN6PR2001CA0042.namprd20.prod.outlook.com
 (2603:10b6:405:16::28) by CY4PR12MB1431.namprd12.prod.outlook.com
 (2603:10b6:903:43::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15; Wed, 20 Oct
 2021 13:18:37 +0000
Received: from BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:16:cafe::74) by BN6PR2001CA0042.outlook.office365.com
 (2603:10b6:405:16::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15 via Frontend
 Transport; Wed, 20 Oct 2021 13:18:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT063.mail.protection.outlook.com (10.13.177.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 13:18:37 +0000
Received: from [172.27.0.234] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 20 Oct
 2021 13:18:28 +0000
Message-ID: <91d47467-93b2-7856-2150-61f75b1aaac4@nvidia.com>
Date:   Wed, 20 Oct 2021 16:18:25 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH bpf-next 07/10] bpf: Add helpers to query conntrack info
Content-Language: en-US
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
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
        Joe Stringer <joe@cilium.io>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Tariq Toukan <tariqt@nvidia.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <clang-built-linux@googlegroups.com>
References: <20211019144655.3483197-1-maximmi@nvidia.com>
 <20211019144655.3483197-8-maximmi@nvidia.com>
 <20211020035622.lgrxnrwfeak2e75a@apollo.localdomain>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <20211020035622.lgrxnrwfeak2e75a@apollo.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee8025a9-db0a-4757-22ed-08d993cc208a
X-MS-TrafficTypeDiagnostic: CY4PR12MB1431:
X-Microsoft-Antispam-PRVS: <CY4PR12MB1431094959A50DBDC09E7F12DCBE9@CY4PR12MB1431.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dRoq9o3/Js745/5xuDZQ/QvVkTTWuNHl/cjdjC+OKuh0Ov1hyE7KuUcRuMozbqjNkB4dCG1LRe2ocFkzzez9pHZuHyQouEQq2NLJMPBpA3XwtfEI9VKU53Sp4Kmywjkmka2H4bekW1oaI5VJCb6DfM0fzTIYqe5/CH7STRAm9u/4520f2VGRgw5fAdncHA1b/t9FF5SrRJJZ5W1jAJoTWx66uJrgr44Q26MO8lGySc31CUTuPJJuAj8PAd6Kbut8k7KXr/jBULUM2TU73+2EErcilJB3QI7Q/JB4NqznInLRaLMwENzlezOUQgkyLvcjz4FotYrGs3KLEGowh8g65iBdL8DBMPSHh6LaP/dV8PINY/IClN3eEJkgnAxf6V5znqlwMl7vQit2sP2QVXEC1wTKK2ufJ2YTFYfggAuQMjjf3aBLQQwTEal9yZIbFbIwa2YN84LVESz31rBhkxbdImDfmI7x4SyG2iXQY21GpVMcF2ksm2H8EBxJk6FCF55hifbF4/f9oaATCjeFlt12d5oXrdp+h08zkGdSXDmnzCLAk+CWhHC9/ZrX+SkiTyUtTkUmMqLm03yx3WJbCZHxdvuETEvJyBgP6npoNtrAIOdeHP080npv4b31ubMyhu/bjG0Twr3AIwUyrVq11yik6Q410SsLkUU7Q9jbCxcu1vub1rccv5JbFK1XuUVZb/huxOzJ0e5C8kVXSuSSuiaNk6y70CQMB/Ob5WTlnVnPFIrSF48hijclZkOxKpUNZHuZOUCW4GeXmA+gyufl2spBWN2v4s9pmaet26aPN24CoyCPY1WCN/BgbJg6B9BWq4yuHoEewXwIqZeAeXQlO+2eETxUaKqRkO+JGqFV8GvFiro=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(31686004)(7636003)(2616005)(54906003)(7416002)(426003)(36860700001)(4326008)(356005)(2906002)(83380400001)(5660300002)(6916009)(47076005)(36756003)(70586007)(508600001)(86362001)(70206006)(16576012)(36906005)(316002)(82310400003)(31696002)(16526019)(26005)(186003)(8676002)(6666004)(4001150100001)(966005)(8936002)(53546011)(336012)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 13:18:37.6452
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ee8025a9-db0a-4757-22ed-08d993cc208a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1431
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-10-20 06:56, Kumar Kartikeya Dwivedi wrote:
> On Tue, Oct 19, 2021 at 08:16:52PM IST, Maxim Mikityanskiy wrote:
>> The new helpers (bpf_ct_lookup_tcp and bpf_ct_lookup_udp) allow to query
>> connection tracking information of TCP and UDP connections based on
>> source and destination IP address and port. The helper returns a pointer
>> to struct nf_conn (if the conntrack entry was found), which needs to be
>> released with bpf_ct_release.
>>
>> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
>> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> 
> The last discussion on this [0] suggested that stable BPF helpers for conntrack
> were not desired, hence the recent series [1] to extend kfunc support to modules
> and base the conntrack work on top of it, which I'm working on now (supporting
> both CT lookup and insert).

If you have conntrack lookup, I can base my solution on top of yours. As 
it supports modules, it's even better. What is the current status of 
your work? When do you plan to submit a series? Please add me to Cc when 
you do.

Thanks for reviewing!

> [0]: https://lore.kernel.org/bpf/CAADnVQJTJzxzig=1vvAUMXELUoOwm2vXq0ahP4mfhBWGsCm9QA@mail.gmail.com
> [1]: https://lore.kernel.org/bpf/CAADnVQKDPG+U-NwoAeNSU5Ef9ZYhhGcgL4wBkFoP-E9h8-XZhw@mail.gmail.com
> 
> --
> Kartikeya
> 

