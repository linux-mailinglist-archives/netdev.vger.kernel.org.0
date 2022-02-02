Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70AE24A6F9E
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 12:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343734AbiBBLKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 06:10:32 -0500
Received: from mail-bn7nam10on2048.outbound.protection.outlook.com ([40.107.92.48]:32608
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232171AbiBBLKb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Feb 2022 06:10:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fAw0m6JTA9uhtbm1KcGLqKuFeCu3b2uwMytKfiRRrUpempRv1yDiSVNLdg75TPRMXgXbV5Nxca4K0t8vvbGzyqF9YwwYBdC+BFDdvwNXQOPchh91cUxSlKhjHaQaVQ9fw3DhnD3GlmLI6OmcCS76xT1dfN7dWTcACIPLj9rRYkDHTaW5co3v6n0nhxOnbYrB8wN+WEs9YHbooNWqEdN8lpj6sP1j5Kh//Vjj95thGK0Zoh+0eipVa+1tj32Muzd/UumiiaPuUJJ/ZRG2NBelPgweGfwowNHi1WcrXiotXaQCEotjaIeMeTZt+gfy8k+QDnUJ4ZSjZMK3cjJUpyGUrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KNO4bsO9WT6j4yLrwnJPoSbRY/+GY8G0nn75kNBTcCQ=;
 b=Js2dDU28NDCjr8OZH60BEsytkiuyB14UnZ/eUsAcHBXEj0WIxZE2T0KH8LcajszhbAzouI9tu+Nv3oaNe6uGwaUbVqrN4ZlF0hWaX/Bk0CdTJRXn/QdxlWaiBsB7LbGmRFy9CoTm0n2D8et6ASt9XQULj0j9L8idUxbXYQCU/h4Uvx5XucHCgdYn+uSLRKCoYsHrzdlzDKYo998gG7WcK0Xtntvwno9FImMcc8YhLra+Bqb8H2amJ1gupR1iuNwidwJnanF/6U9jjdz7hv64E9fcgUJPNkiQQriGLnGAkGPdBUBgB7tHoxpCpCSDo8wwHkhrlMr2VO+BuGmYacBENw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=fb.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KNO4bsO9WT6j4yLrwnJPoSbRY/+GY8G0nn75kNBTcCQ=;
 b=cAkq7X59wIKr/jM8xmxot2lDnlTOjiBQgU/w5pHfa0N/YGPoogmDC2sPB1fTG6fT7BjMlXstd0Hh6+p1uzsR4q3xudy3JfyDXPvSmE/7cK3V8xBUzNQKUwny6mI7YbtkhGuHp54puSyRageBggK40dzsZRy+y3CVIgRnxwXpU93W30dj6VF+6d6uSRXORsXFtJ37pQNRwqMt/31mHUHGz+4JUm9MY72Wx7Np88Rl3wXcSkuT0ExhDcH6AfZB4xWPXYcwwDmHVC/z3WkXwjgsI4uhyZyfUez4HSkn8YeCYSLrBdkuaH14JVlrU5eRkbGAULB1xhjPTNUmmEvVOGJE8A==
Received: from MWHPR14CA0064.namprd14.prod.outlook.com (2603:10b6:300:81::26)
 by CH0PR12MB5089.namprd12.prod.outlook.com (2603:10b6:610:bc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Wed, 2 Feb
 2022 11:10:28 +0000
Received: from CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:81:cafe::75) by MWHPR14CA0064.outlook.office365.com
 (2603:10b6:300:81::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12 via Frontend
 Transport; Wed, 2 Feb 2022 11:10:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT046.mail.protection.outlook.com (10.13.174.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Wed, 2 Feb 2022 11:10:27 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 2 Feb
 2022 11:10:12 +0000
Received: from [172.27.13.7] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 2 Feb 2022
 03:10:02 -0800
Message-ID: <9cef58de-1f84-5988-92f8-fcdd3c61f689@nvidia.com>
Date:   Wed, 2 Feb 2022 13:09:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH bpf-next v2 2/3] bpf: Add helpers to issue and check SYN
 cookies in XDP
Content-Language: en-US
To:     John Fastabend <john.fastabend@gmail.com>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        "Lorenz Bauer" <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        "Hideaki YOSHIFUJI" <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        "Shuah Khan" <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "Nathan Chancellor" <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Stringer <joe@cilium.io>,
        Florent Revest <revest@chromium.org>,
        <linux-kselftest@vger.kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        "Kumar Kartikeya Dwivedi" <memxor@gmail.com>,
        Florian Westphal <fw@strlen.de>
References: <20220124151340.376807-1-maximmi@nvidia.com>
 <20220124151340.376807-3-maximmi@nvidia.com>
 <61efacc6980f4_274ca2083e@john.notmuch>
 <8f5fecac-ce6e-adc8-305b-a2ee76328bce@nvidia.com>
 <61f850bdf1b23_8597208f8@john.notmuch> <61f852711e15a_92e0208ac@john.notmuch>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <61f852711e15a_92e0208ac@john.notmuch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4871d3c3-9e84-4dcc-932e-08d9e63c9e27
X-MS-TrafficTypeDiagnostic: CH0PR12MB5089:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB5089A11F949DDAC05B541DB5DC279@CH0PR12MB5089.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: llv3SAEQADS4LIHCGy8fZeKjsrSWu6sQehT9w4ktKD/6h6DiERU/J02TEar+uCprEoSMoRZ3UYxyrXeoagBvwdREGNtz3wI25n5N0lh9I8nBAbomxSJNyY91QFOuY4bARapWzZVxnR7WawKrVSfmujuUDGG+KSJaGuWeSQJ98c7ZtgjfJkIMZbzlGhcX6u2e1JiFSBtFDIoCLn/HWfRB49WxVkGf3EpWypBzO3vMD8q/EmHrta5EvbAgRplTvlqyhfhHqUn6H0QfSh7oLqR2C9UiklCVscjPR0GRLjzOwqevHPoOCJ13sjNV4iI1zt/TNj5QHmdb+ZA44wciq90sw+fU9laOZ1SS2xUfUc80/Sim8pqLx//LYqvoHEvHwE5df74QXaTcPUrqwD6jNBXma+lyPYJ/f0FfYWyDkYNFB7x8qqOkLvAnnukOcyqzMgskFJZPB29z6agSZ2likS+tw5dzVjWDSTciIDwBS0AkRzpX4LrAJex3HuI5kLuyGOIMZnRmZNZsVyn1Pk1ZgWZOpPppmdtnQDsktByI/Agg6woo9T4FVDMkriHGwNCIid/iHdJq+q/LvbxE0tQicUGiR3+m/aP35xRVp+N5YiTnc5pp5bP4pkm7i61VF+ozj7wK5cqAkgWQsbZXGzNRNzYLUvIF1QKAmgZf7a8EhsrKoeqSIzypXh69fwozcuCH9yPe+VIWVfJLZesOCCO+cpOwL+LHaE3+QDqHlZzyx2JC2mhxye4vRxXzQ64Rw68bxi8E
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(54906003)(53546011)(47076005)(36860700001)(2616005)(86362001)(31696002)(16526019)(26005)(6916009)(508600001)(31686004)(6666004)(186003)(16576012)(316002)(36756003)(5660300002)(4326008)(426003)(7416002)(356005)(336012)(81166007)(8936002)(8676002)(82310400004)(40460700003)(70206006)(70586007)(83380400001)(2906002)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 11:10:27.4205
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4871d3c3-9e84-4dcc-932e-08d9e63c9e27
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5089
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-31 23:19, John Fastabend wrote:
> John Fastabend wrote:
>> Maxim Mikityanskiy wrote:
>>> On 2022-01-25 09:54, John Fastabend wrote:
>>>> Maxim Mikityanskiy wrote:
>>>>> The new helpers bpf_tcp_raw_{gen,check}_syncookie allow an XDP program
>>>>> to generate SYN cookies in response to TCP SYN packets and to check
>>>>> those cookies upon receiving the first ACK packet (the final packet of
>>>>> the TCP handshake).
>>>>>
>>>>> Unlike bpf_tcp_{gen,check}_syncookie these new helpers don't need a
>>>>> listening socket on the local machine, which allows to use them together
>>>>> with synproxy to accelerate SYN cookie generation.
>>>>>
>>>>> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
>>>>> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
>>>>> ---
>>>>
>>>> [...]
>>>>
>>>>> +
>>>>> +BPF_CALL_4(bpf_tcp_raw_check_syncookie, void *, iph, u32, iph_len,
>>>>> +	   struct tcphdr *, th, u32, th_len)
>>>>> +{
>>>>> +#ifdef CONFIG_SYN_COOKIES
>>>>> +	u32 cookie;
>>>>> +	int ret;
>>>>> +
>>>>> +	if (unlikely(th_len < sizeof(*th)))
>>>>> +		return -EINVAL;
>>>>> +
>>>>> +	if (!th->ack || th->rst || th->syn)
>>>>> +		return -EINVAL;
>>>>> +
>>>>> +	if (unlikely(iph_len < sizeof(struct iphdr)))
>>>>> +		return -EINVAL;
>>>>> +
>>>>> +	cookie = ntohl(th->ack_seq) - 1;
>>>>> +
>>>>> +	/* Both struct iphdr and struct ipv6hdr have the version field at the
>>>>> +	 * same offset so we can cast to the shorter header (struct iphdr).
>>>>> +	 */
>>>>> +	switch (((struct iphdr *)iph)->version) {
>>>>> +	case 4:
>>>>
>>>> Did you consider just exposing __cookie_v4_check() and __cookie_v6_check()?
>>>
>>> No, I didn't, I just implemented it consistently with
>>> bpf_tcp_check_syncookie, but let's consider it.
>>>
>>> I can't just pass a pointer from BPF without passing the size, so I
>>> would need some wrappers around __cookie_v{4,6}_check anyway. The checks
>>> for th_len and iph_len would have to stay in the helpers. The check for
>>> TCP flags (ACK, !RST, !SYN) could be either in the helper or in BPF. The
>>> switch would obviously be gone.
>>
>> I'm not sure you would need the len checks in helper, they provide
>> some guarantees I guess, but the void * is just memory I don't see
>> any checks on its size. It could be the last byte of a value for
>> example?

The verifier makes sure that the packet pointer and the size come 
together in function parameters (see check_arg_pair_ok). It also makes 
sure that the memory region defined by these two parameters is valid, 
i.e. in our case it belongs to packet data.

Now that the helper got a valid memory region, its length is still 
arbitrary. The helper has to check it's big enough to contain a TCP 
header, before trying to access its fields. Hence the checks in the helper.

> I suspect we need to add verifier checks here anyways to ensure we don't
> walk off the end of a value unless something else is ensuring the iph
> is inside a valid memory block.

The verifier ensures that the [iph; iph+iph_len) is valid memory, but 
the helper still has to check that struct iphdr fits into this region. 
Otherwise iph_len could be too small, and the helper would access memory 
outside of the valid region.

>>
>>>
>>> The bottom line is that it would be the same code, but without the
>>> switch, and repeated twice. What benefit do you see in this approach?
>>
>> The only benefit would be to shave some instructions off the program.
>> XDP is about performance so I figure we shouldn't be adding arbitrary
>> stuff here. OTOH you're already jumping into a helper so it might
>> not matter at all.
>>
>>>   From my side, I only see the ability to drop one branch at the expense
>>> of duplicating the code above the switch (th_len and iph_len checks).
>>
>> Just not sure you need the checks either, can you just assume the user
>> gives good data?

No, since the BPF program would be able to trick the kernel into reading 
from an invalid location (see the explanation above).

>>>
>>>> My code at least has already run the code above before it would ever call
>>>> this helper so all the other bits are duplicate.
>>>
>>> Sorry, I didn't quite understand this part. What "your code" are you
>>> referring to?
>>
>> Just that the XDP code I maintain has a if ipv4 {...} else ipv6{...}
>> structure

Same for my code (see the last patch in the series).

Splitting into two helpers would allow to drop the extra switch in the 
helper, however:

1. The code will be duplicated for the checks.

2. It won't be consistent with bpf_tcp_check_syncookie (and all other 
existing helpers - as far as I see, there is no split for IPv4/IPv6).

3. It's easier to misuse, e.g., pass an IPv6 header to the IPv4 helper. 
This point is controversial, since it shouldn't pose any additional 
security threat, but in my opinion, it's better to be foolproof. That 
means, I'd add the IP version check even to the separate helpers, which 
defeats the purpose of separating them.

Given these points, I'd prefer to keep it a single helper. However, if 
you have strong objections, I can split it.

>> in it so could use a v4_check... and v6_check... then call
>> the correct version directly, removing the switch from the helper.
>>
>> Do you think there could be a performance reason to drop out those
>> instructions or is it just hid by the hash itself. Also it seems
>> a bit annoying if user is calling multiple helpers and they keep
>> doing the same checks over and over.
> 
> 

