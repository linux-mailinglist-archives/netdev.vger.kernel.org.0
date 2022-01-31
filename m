Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574614A4870
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 14:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378994AbiAaNiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 08:38:50 -0500
Received: from mail-mw2nam12on2078.outbound.protection.outlook.com ([40.107.244.78]:1728
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1379039AbiAaNir (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 08:38:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V3WEKASzYdrgPHhCaeK5BOXOvKYRwYomY1QgiEn92sLLOH8t1BOS36PBZJkQDbJPsTAqPLr1h8POfNlig3ee0pbb+CBCRMeD/MKdJy0OeOqDIks3cYF0S6+Erd5Ywm1g/mciugR/AiXdgub0S/ZSTG5kx1Gebyvv8+LAPjho/A3VstEmHnqT2cQJOHYPSZfNvcQnIm24xIGpE9CwH3+nPkjNh+LlN1z95tVDJ7sLRAiLIMGCTWSLjsVFINfrqBphOmDAiS5sIo/Q1bsf91o1R8zvi9lQMnuvu6IfHTvOx/Ym02Wjj52oJqeQ55MTAmR5fWeCnha/wgl/m3zUza1wzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EbdsNTZUT3qEHqEywC99UZYxfERZl25jLDii+1zxyQw=;
 b=g9xNG/Qj41xY92b3jYDbqJjoF4nIC3bj1DrumOEhiRji3Oe0DX7zTaVbjyPHMirqyFwaeHCnRt9AKRylocri7y5GfBt8AWRDuM1Yp5saPXKnF6l60m7i74+nIBmURBp7+4jJvdrq0s5sRxjEUZtrlyXNkc20CcCL3oGFeZf5BSQB2NAAn3lwaicA0ZRXZQleo82HXHrFF1EzuQ9WOwufXGXxluwIcQc9ndnaCFW9keKBTWga7jhOdOLk9zdNsG3UmqsKwdBo9FzrPClLLZxQwbV0CM5wPMo8UMu8nePDzk1xb8RFnDh/1dfqTR9QQCgdd7DyoEwUkFMiUXbtdqxKDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=fb.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EbdsNTZUT3qEHqEywC99UZYxfERZl25jLDii+1zxyQw=;
 b=ulkDJjt6nL514e8tYI/l1pfbHBcDYgnnz7sYSBlUr/aGUUWNcleVKj2ctXzaduW2optTxnuEU5V0C4SubYAPtCAvxq7UGjet+XpemjGwaKCdVgRH2tcJ+JlXDdBHoIyQO2KOiKYAdILZdgMVJUGS7IsrA120dDmoNdTmdj6LzynLfMlZwwnAonELO7ZCqLiD1bAyv1bIOUoUYEf+vUsX6RD809D00A4WQOpjxhaB8eNBf5xi9h3fdy+sbgG5f2CmqdNm0ooSFgl4mKsn229WXkYi3fm6kOE2xctQSGpwoveADMGo7TL2x+AS5bw7pmJ0rndOe8Ax/WFckOJRqGaYDQ==
Received: from BN9PR03CA0168.namprd03.prod.outlook.com (2603:10b6:408:f4::23)
 by DM5PR1201MB0057.namprd12.prod.outlook.com (2603:10b6:4:5b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Mon, 31 Jan
 2022 13:38:44 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f4:cafe::94) by BN9PR03CA0168.outlook.office365.com
 (2603:10b6:408:f4::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17 via Frontend
 Transport; Mon, 31 Jan 2022 13:38:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Mon, 31 Jan 2022 13:38:43 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 31 Jan
 2022 13:38:42 +0000
Received: from [172.27.13.98] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 31 Jan 2022
 05:38:32 -0800
Message-ID: <8f5fecac-ce6e-adc8-305b-a2ee76328bce@nvidia.com>
Date:   Mon, 31 Jan 2022 15:38:29 +0200
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
        "Jakub Kicinski" <kuba@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
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
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <61efacc6980f4_274ca2083e@john.notmuch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: drhqmail203.nvidia.com (10.126.190.182) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b671b2e4-721d-48c3-0404-08d9e4befff2
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0057:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB005767078542BFB378CF2DA5DC259@DM5PR1201MB0057.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6zU/EhF3SBboXc6tBS5Q2j8KskDuvw8bGFXhX94Wf+joQz/WGWDverMf4F1bWIllgeVo674mJ4mkMwnBhjBXLy0L2hLdZ+IRGasvVwJGiv6CXEU6uzyXBSzi3rzZP+gWwPKZloLDckSlJ9xdo3qF/pzDw9amwYDVurHrg/oGEbfPsHdjcezhfJkDcBQihHZ6xVVPM+I5khN9gI0fZ3ch8krtQuK9Jf64NKCP/nZRxi45FFwD8KgZvSoYfInDj8awxkffEYUpHCWkQOwogQBXq1AhiBmpfSV4Yy4KMMBmYhYU9NtxL1p86Ql/ycRa/aO3k1AjHrzkdcc2IdM/BeDRWKZAIxuY4ad2b7V3/rHdlyLKO171UZ9Cg29iDyXOozxtC/fNkCJcMQaeqjkBOPCb4XgFeMkyFnHrzH0eoGGzLkk439bw3Efsm7JqdtEErrfwN0ItzqfOwpwqw7wHCUB7gAA9TEASfR05NHNEKvPS/bOHuBVfzwxYX6Rfp8G+3eR+c+H2deDrGYLU4uyPlm+be6ljSoo3+tTs+oRFk3j9iGWgpp3FmB+ivPHWK42xg/s8yrKlufcU+rpRaJQZmteU66m30PSo6sarUVG0BMMlschfUljvpth1EO7XPEwfgZEr9SenTfAFd7E6tJCy5SAZafwXG5M6fJw2awUW4GOkmmNQfGmPj/EIW56KuuF4PXmKWgYhCl3WMrYtTYQM3MjCe5MlC3UTxCCFGVHOa1zZfDQ/V6pG9rrnG+Eq1qdWhl5w
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(53546011)(36756003)(4326008)(8936002)(70586007)(8676002)(47076005)(6666004)(70206006)(16526019)(31686004)(36860700001)(16576012)(186003)(2616005)(336012)(426003)(40460700003)(316002)(26005)(508600001)(81166007)(6916009)(54906003)(86362001)(31696002)(356005)(7416002)(5660300002)(82310400004)(2906002)(36900700001)(43740500002)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 13:38:43.6730
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b671b2e4-721d-48c3-0404-08d9e4befff2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0057
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-25 09:54, John Fastabend wrote:
> Maxim Mikityanskiy wrote:
>> The new helpers bpf_tcp_raw_{gen,check}_syncookie allow an XDP program
>> to generate SYN cookies in response to TCP SYN packets and to check
>> those cookies upon receiving the first ACK packet (the final packet of
>> the TCP handshake).
>>
>> Unlike bpf_tcp_{gen,check}_syncookie these new helpers don't need a
>> listening socket on the local machine, which allows to use them together
>> with synproxy to accelerate SYN cookie generation.
>>
>> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
>> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
>> ---
> 
> [...]
> 
>> +
>> +BPF_CALL_4(bpf_tcp_raw_check_syncookie, void *, iph, u32, iph_len,
>> +	   struct tcphdr *, th, u32, th_len)
>> +{
>> +#ifdef CONFIG_SYN_COOKIES
>> +	u32 cookie;
>> +	int ret;
>> +
>> +	if (unlikely(th_len < sizeof(*th)))
>> +		return -EINVAL;
>> +
>> +	if (!th->ack || th->rst || th->syn)
>> +		return -EINVAL;
>> +
>> +	if (unlikely(iph_len < sizeof(struct iphdr)))
>> +		return -EINVAL;
>> +
>> +	cookie = ntohl(th->ack_seq) - 1;
>> +
>> +	/* Both struct iphdr and struct ipv6hdr have the version field at the
>> +	 * same offset so we can cast to the shorter header (struct iphdr).
>> +	 */
>> +	switch (((struct iphdr *)iph)->version) {
>> +	case 4:
> 
> Did you consider just exposing __cookie_v4_check() and __cookie_v6_check()?

No, I didn't, I just implemented it consistently with 
bpf_tcp_check_syncookie, but let's consider it.

I can't just pass a pointer from BPF without passing the size, so I 
would need some wrappers around __cookie_v{4,6}_check anyway. The checks 
for th_len and iph_len would have to stay in the helpers. The check for 
TCP flags (ACK, !RST, !SYN) could be either in the helper or in BPF. The 
switch would obviously be gone.

The bottom line is that it would be the same code, but without the 
switch, and repeated twice. What benefit do you see in this approach? 
 From my side, I only see the ability to drop one branch at the expense 
of duplicating the code above the switch (th_len and iph_len checks).

> My code at least has already run the code above before it would ever call
> this helper so all the other bits are duplicate.

Sorry, I didn't quite understand this part. What "your code" are you 
referring to?

> The only reason to build
> it this way, as I see it, is either code can call it blindly without doing
> 4/v6 switch. or to make it look and feel like 'tc' world, but its already
> dropped the ok so its a bit different already and ifdef TC/XDP could
> hanlde the different parts.
> 
> 
>> +		ret = __cookie_v4_check((struct iphdr *)iph, th, cookie);
>> +		break;
>> +
>> +#if IS_BUILTIN(CONFIG_IPV6)
>> +	case 6:
>> +		if (unlikely(iph_len < sizeof(struct ipv6hdr)))
>> +			return -EINVAL;
>> +
>> +		ret = __cookie_v6_check((struct ipv6hdr *)iph, th, cookie);
>> +		break;
>> +#endif /* CONFIG_IPV6 */
>> +
>> +	default:
>> +		return -EPROTONOSUPPORT;
>> +	}
>> +
>> +	if (ret > 0)
>> +		return 0;
>> +
>> +	return -EACCES;
>> +#else
>> +	return -EOPNOTSUPP;
>> +#endif
>> +}

