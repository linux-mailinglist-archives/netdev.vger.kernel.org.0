Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA19A434BE6
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 15:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbhJTNTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 09:19:11 -0400
Received: from mail-mw2nam08on2063.outbound.protection.outlook.com ([40.107.101.63]:34944
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229570AbhJTNTK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 09:19:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=McSLMA6Kuemz0vOQCWsTK1V6n4TNNQdmp5PuA7BgTlG4L7gksgwSiT7wQz0F9uBnyt2gn05cbYP1+xDGm7pH3dWZ1vecG3cMkqIyvUtijbnZNC79nzcBvIzRiyoOAtc9+wzQtUe4gGq4ToiDeDe2nc6gV+n3pz9dzg8no/C599P/7oVWlICBjB76paG5kOq0zjcCFQRE2L1a/Lm8bgXFQcaY/zABAzQ67SMVZCNMFaaa6geSwa+xtk63KxIF9mqwGnskZo7Mx0mBF9herhNK9kC2jNniykROnuEuD1Ccx3SWU5leTTvgEVeg0AP0piCiWg9dHVjqyUMrrNp4y6UDQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aedsBFPY/af84sZ7cmSgusDuEEjOQtOAENIbNgnIds4=;
 b=dkxj0zFnTBe0QtoBZ9dk2x+gTyyLJnOk5Kmtnko+OCHNtT8s9gswS4PYxkax5cD8EDCTQ/pM41xYvGVGLqlhhdRa+ATBed1SFUZuayeOPuup+qEkE/0rJw53mHd4L1lPj9BwPD+S1AQasU53fkQBdfu65rKrSgI4gqS3fTsL15mDFI0fky3Fol7GUPo1rzaXl7x4n/yK3eM8mQc5797AF4p/L+8CeBb+uA0o/loegHzKKt5TZyQKQf9Y2J1FdB+raKDKF9JkqErLi2SjxTPuiNyZxee40kCWABcFdFUx4L5XND/xK6eUpixhuocqrWPfmsg0a6OS8rTusgDb9KFRqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aedsBFPY/af84sZ7cmSgusDuEEjOQtOAENIbNgnIds4=;
 b=t6//6+Uin4BgTYOd1XqqzYR6EHMy/8GCZEqI3wAGUw7l6Klif0TJ0dIoMCHfNNIGglqOhlT7sATSXLpk0QA0hSmVdWX4XeYgqy4SJ+JQwgR7ESMmNvnkmWVFKd7N8W0bR3vnijV7D2Ll2NqCU6p3fC31+d+q6TDaVd8+wFl1NtgbtSWzA2vOuLhrRYSLjzxKyZKrAjB7sOuwr1M104UE9MMaoFUt3wsslJ72l2AAJz1ZnGVcuzQ+L7ReeNW1+P9mUHVtfo5v+1J/35LuSbcf9kyi5HtIKvdkvjHolREvFNiACSwt7Wwe00EyZ3FSjvuUT1/uCY9Z4VAB3G3AecEgbw==
Received: from BN9PR03CA0436.namprd03.prod.outlook.com (2603:10b6:408:113::21)
 by MWHPR12MB1406.namprd12.prod.outlook.com (2603:10b6:300:14::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Wed, 20 Oct
 2021 13:16:54 +0000
Received: from BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:113:cafe::5e) by BN9PR03CA0436.outlook.office365.com
 (2603:10b6:408:113::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend
 Transport; Wed, 20 Oct 2021 13:16:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT011.mail.protection.outlook.com (10.13.176.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 13:16:54 +0000
Received: from [172.27.0.234] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 20 Oct
 2021 13:16:37 +0000
Message-ID: <73133203-ccb7-f538-7b02-3c4bd991e54d@nvidia.com>
Date:   Wed, 20 Oct 2021 16:16:32 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH bpf-next 04/10] bpf: Make errors of
 bpf_tcp_check_syncookie distinguishable
Content-Language: en-US
To:     John Fastabend <john.fastabend@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Hideaki YOSHIFUJI" <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Brendan Jackman" <jackmanb@google.com>,
        Florent Revest <revest@chromium.org>,
        "Joe Stringer" <joe@cilium.io>, Lorenz Bauer <lmb@cloudflare.com>,
        Tariq Toukan <tariqt@nvidia.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <clang-built-linux@googlegroups.com>
References: <20211019144655.3483197-1-maximmi@nvidia.com>
 <20211019144655.3483197-5-maximmi@nvidia.com>
 <616f8cd0a0c6c_340c7208ae@john-XPS-13-9370.notmuch>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <616f8cd0a0c6c_340c7208ae@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95aa3be5-e225-4387-3aca-08d993cbe2de
X-MS-TrafficTypeDiagnostic: MWHPR12MB1406:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1406D640A2664D6595ABF34DDCBE9@MWHPR12MB1406.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9JW6uH2OQjgF7ZjDYl0lfpTEyekAWzuruEXPbe+IPTCRS9oBL7r2Nw5TXbcw0KhG3cJFD9LDmAfxmECpfM1X5xz/8TqacL+8qYbS1hd9AH+WMFPKKN6TCFwrBWOQ8jNj0Ef8bXveRY7UiSf/Secse4BCEtZWaZi41bpFFKxIcGZD+SOZVQCy7mdab6fvuOdANCs7bjTN0401SFvWlOsqnlqGgnqR1cnFoqBfk1NqfTnyA69gt9U575gzY70IWsuJdK6nq7FRNXoLxXiGRj0DM5UxBX9ZK5F9mWztqSja0QdTwRuz7zhfqYE1BF1J2fbV8cZ18fZXGSYL1iL8qPdlApFN1e+d89VMOe9EG4qWwJM8j8FoSRJIZ6RDbN+374QWq7FyPxugWJlgeNXuCgdXOAK6AQRHEeyhzpM+COVk7+GOAx+adVm5AD1fiqctg4i0QA2jPKfH6UqYg+HrxsKWq7owAJVHyLmQQZ4/r4HwzukEQJH+TNNcPJH0jobgLW37Yf1vJfQiocosab0dNZYVy7ZjXCTOatxrRnYbnPTNRMB7nZJHBZ8jW5I+xXmTxAOYWfREdCm2Tm4JgjpxjfjgLc53WtsEAdrfn7LyL9G+XfmkSZ8S+sHQKCuu3X97ccuy0omA8EXV5I7O+0AT0YRxprTuN0PNQeTs2bW3XFOtv2KU7XAGmLGX1+3Sfu/uITgR7cg5KwEtqGMjCUiioAsIWgHjctAV/o6Rr84JJkKfeyY=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(2906002)(8936002)(7636003)(6666004)(8676002)(5660300002)(86362001)(4001150100001)(316002)(31696002)(70586007)(36756003)(31686004)(2616005)(426003)(7416002)(6916009)(356005)(4326008)(82310400003)(16576012)(36860700001)(54906003)(336012)(47076005)(53546011)(508600001)(16526019)(26005)(186003)(70206006)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 13:16:54.1126
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95aa3be5-e225-4387-3aca-08d993cbe2de
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1406
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-10-20 06:28, John Fastabend wrote:
> Maxim Mikityanskiy wrote:
>> bpf_tcp_check_syncookie returns errors when SYN cookie generation is
>> disabled (EINVAL) or when no cookies were recently generated (ENOENT).
>> The same error codes are used for other kinds of errors: invalid
>> parameters (EINVAL), invalid packet (EINVAL, ENOENT), bad cookie
>> (ENOENT). Such an overlap makes it impossible for a BPF program to
>> distinguish different cases that may require different handling.
> 
> I'm not sure we can change these errors now. They are embedded in
> the helper API. I think a BPF program could uncover the meaning
> of the error anyways with some error path handling?
> 
> Anyways even if we do change these most of us who run programs
> on multiple kernel versions would not be able to rely on them
> being one way or the other easily.

The thing is, the error codes aren't really documented:

  * 0 if *iph* and *th* are a valid SYN cookie ACK, or a negative
  * error otherwise.

My patch doesn't break this assumption.

Practically speaking, there are two use cases of bpf_tcp_check_syncookie 
that I know about: traffic classification (find NEW ACK packets with the 
right cookie) and SYN flood protection.

For traffic classification, it's not important what error code we get. 
The logic for ACK packets is as follows:

1. Connection established => ESTABLISHED. Otherwise,

2. bpf_tcp_check_syncookie returns 0 => NEW. Otherwise,

3. INVALID (regardless of the specific error code).

My patch doesn't break this use case.

>>
>> For a BPF program that accelerates generating and checking SYN cookies,
>> typical logic looks like this (with current error codes annotated):
>>
>> 1. Drop invalid packets (EINVAL, ENOENT).
>>
>> 2. Drop packets with bad cookies (ENOENT).
>>
>> 3. Pass packets with good cookies (0).
>>
>> 4. Pass all packets when cookies are not in use (EINVAL, ENOENT).

Now that I'm reflecting on it again, it would make more sense to drop 
packets in case 4: it's a new packet, it's an ACK, and we don't expect 
any cookies.

>> The last point also matches the behavior of cookie_v4_check and
>> cookie_v6_check that skip all checks if cookie generation is disabled or
>> no cookies were recently generated. Overlapping error codes, however,
>> make it impossible to distinguish case 4 from cases 1 and 2.

If so, we don't strictly need to distinguish case 4 from 1 and 2. The 
logic for ACK packets is similar:

1. Connection established => XDP_PASS. Otherwise,

2. bpf_tcp_check_syncookie returns 0 => XDP_PASS. Otherwise,

3. XDP_DROP.

So, on one hand, it looks like both use cases can be implemented without 
this patch. On the other hand, changing error codes to more meaningful 
shouldn't break existing programs and can have its benefits, for 
example, in debugging or in statistic counting.

>> The original commit message of commit 399040847084 ("bpf: add helper to
>> check for a valid SYN cookie") mentions another use case, though:
>> traffic classification, where it's important to distinguish new
>> connections from existing ones, and case 4 should be distinguishable
>> from case 3.
>>
>> To match the requirements of both use cases, this patch reassigns error
>> codes of bpf_tcp_check_syncookie and adds missing documentation:
>>
>> 1. EINVAL: Invalid packets.
>>
>> 2. EACCES: Packets with bad cookies.
>>
>> 3. 0: Packets with good cookies.
>>
>> 4. ENOENT: Cookies are not in use.
>>
>> This way all four cases are easily distinguishable.
>>
>> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
>> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> 
> At very leasst this would need a fixes tag and should be backported
> as a bug. Then we at least have a chance stable and LTS kernels
> report the same thing.

That's a good idea.

> [...]
> 
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>   
> I'll take a stab at how a program can learn the error cause today.
> 
> BPF_CALL_5(bpf_tcp_check_syncookie, struct sock *, sk, void *, iph, u32, iph_len,
> 	   struct tcphdr *, th, u32, th_len)
> {
> #ifdef CONFIG_SYN_COOKIES
> 	u32 cookie;
> 	int ret;
> 
> // BPF program should know it pass bad values and can check
> 	if (unlikely(!sk || th_len < sizeof(*th)))
> 		return -EINVAL;
> 
> // sk_protocol and sk_state are exposed in sk and can be read directly
> 	/* sk_listener() allows TCP_NEW_SYN_RECV, which makes no sense here. */
> 	if (sk->sk_protocol != IPPROTO_TCP || sk->sk_state != TCP_LISTEN)
> 		return -EINVAL;
> 
> // This is a user space knob right? I think this is a misconfig user can
> // check before loading a program with check_syncookie?

bpf_tcp_check_syncookie was initially introduced for the classification 
use case, to be able to classify new ACK packets with the right cookie 
as NEW. The XDP program classifies traffic regardless of whether SYN 
cookies are enabled. If we need to check the sysctl in userspace, it 
means we need two XDP programs (or additional trickery passing this 
value through a map).

> 	if (!sock_net(sk)->ipv4.sysctl_tcp_syncookies)
> 		return -EINVAL;
> 
> // We have th pointer can't we just check?

Yes, most of the checks can be repeated in BPF, but it's obvious it's 
slower to do all the checks twice.

> 	if (!th->ack || th->rst || th->syn)
> 		return -ENOENT;
> 
> 	if (tcp_synq_no_recent_overflow(sk))
> 		return -ENOENT;

This specific check can't be done in BPF.

> 
> 	cookie = ntohl(th->ack_seq) - 1;
> 
> 	switch (sk->sk_family) {
> 	case AF_INET:
> // misconfiguration but can be checked.
> 		if (unlikely(iph_len < sizeof(struct iphdr)))
> 			return -EINVAL;
> 
> 		ret = __cookie_v4_check((struct iphdr *)iph, th, cookie);
> 		break;
> 
> #if IS_BUILTIN(CONFIG_IPV6)
> 	case AF_INET6:
> // misconfiguration can check as well
> 		if (unlikely(iph_len < sizeof(struct ipv6hdr)))
> 			return -EINVAL;
> 
> 		ret = __cookie_v6_check((struct ipv6hdr *)iph, th, cookie);
> 		break;
> #endif /* CONFIG_IPV6 */
> 
> 	default:
> 		return -EPROTONOSUPPORT;
> 	}
> 
> 	if (ret > 0)
> 		return 0;
> 
> 	return -ENOENT;
> #else
> 	return -ENOTSUPP;
> #endif
> }
> 
> 
> So I guess my point is we have all the fields we could write a bit
> of BPF to find the error cause if necessary. Might be better than
> dealing with changing the error code and having to deal with the
> differences in kernels. I do see how it would have been better
> to get errors correct on the first patch though :/
> 
> By the way I haven't got to the next set of patches with the
> actual features, but why not push everything above this patch
> as fixes in its own series. Then the fixes can get going why
> we review the feature.

OK, I'll respin the fixes separately, while the discussion on the 
approach to expose conntrack is going on.

Thanks for reviewing!

> 
> Thanks,
> John
> 

