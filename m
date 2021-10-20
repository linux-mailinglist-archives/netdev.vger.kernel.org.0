Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8AA434BE4
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 15:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhJTNSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 09:18:43 -0400
Received: from mail-dm6nam10on2052.outbound.protection.outlook.com ([40.107.93.52]:57952
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229570AbhJTNSm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 09:18:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S0q9RCpwHgumLn1Pp7mbo5NNmal4foFioODQdmOwEY+SLAjXvygZcVPJB6isEf07mLCZ0fVLZH28VAqARUMsi+llTm59ZlJkJ7P45bNvdHh35mLZ5OEKCJwggifrUGnzYWzY4lXxWMLPpoTG0wVlvCu9UEjXhbNvOpXe1U5wvoZoqKSxq27LeedOp0+0r3Vmd+5bt/oZlXpOBQaTnrzw9Gx+swJlEVMD71tpez5DzoEFTCTTyJgYUFfSO4RcXHZ56UdG2PiFKIZiX4noGMi7I0e/x7FQ1WK0pOIOv1dgdWJEdqx83WC8i7p5GjGemDV5LyO7qn6xgMYu8QiQlPv6Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=shcyOgnmwOwPiXslZMbXF5q62XuX3Lmi3GEwWXjkuxw=;
 b=fMkYMmnfYRRd28x9KkBwTCNy/gi+052rwuu6jya474X5H9vuhmbAUM1PwmLpzv7Qzwn6bLVQPCtGv2FkomgLqZxlH0gDx1R5fmag/i1VnJJ/+c2UsEe9o8HkwPu+PYxNUi+IrWSairp6Pj6K/FQJksnqlxZ9X7zWIllIEIjqxk+a5zABk/r6yP04YS38BZ9/n3j2xw/D9dfUaiFlXGulXm2iKJrnE2aV9TF/BZcyDfTbzLJgI7aIVYjCDIciQ6dcr/jtynSxFA8sdWduPQpFZP0EoTT0D0Q7QIugnp6wttqh9sWw3HAx/rtDnY34b6n3TMK0XrfLwdWiKrs4gka5uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=shcyOgnmwOwPiXslZMbXF5q62XuX3Lmi3GEwWXjkuxw=;
 b=QWxtA9L21lddwR+aZfhSB2v8MoAQe79VDo088rU7aKB4fUm4JXZXbpSrFYMM1ztSXPCdJhAFcDijQzgTkcNFlEt0AAN1gCw6HOSwYUqW9DT5ZSlgzPu6utNMSqjedvhbVf/vipqQu1WWkW4ghQ3hbv8U0tXVoMhFYY6Ed7J2nq4JZ1pG6TZ1uUZweaNcKSdKe6nTOkLSwRvJGeIerH+nq9QsW/YiMAt1R181D7DFUz5Vt60R9L2QdWO2mwcStY7ILoFKQTmeBrLxUuU1ZKcIRcflJF5cKw8kPTMKPbmTZAlsW8D1DCekWiAMMIPMXj+WxK43NjXXau52jL56ZmBzuw==
Received: from BN9PR03CA0873.namprd03.prod.outlook.com (2603:10b6:408:13c::8)
 by CY4PR12MB1848.namprd12.prod.outlook.com (2603:10b6:903:11d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Wed, 20 Oct
 2021 13:16:26 +0000
Received: from BN8NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13c:cafe::9d) by BN9PR03CA0873.outlook.office365.com
 (2603:10b6:408:13c::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18 via Frontend
 Transport; Wed, 20 Oct 2021 13:16:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT042.mail.protection.outlook.com (10.13.177.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 13:16:25 +0000
Received: from [172.27.0.234] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 20 Oct
 2021 13:16:14 +0000
Message-ID: <6e7a3867-257e-6979-1d86-d6dd7764af2e@nvidia.com>
Date:   Wed, 20 Oct 2021 16:16:10 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH bpf-next 09/10] bpf: Add a helper to issue timestamp
 cookies in XDP
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>
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
 <20211019144655.3483197-10-maximmi@nvidia.com>
 <834e92a4-8a4d-945f-c894-9730ff7d91dc@gmail.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <834e92a4-8a4d-945f-c894-9730ff7d91dc@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5abd14c7-680b-4090-542e-08d993cbd1eb
X-MS-TrafficTypeDiagnostic: CY4PR12MB1848:
X-Microsoft-Antispam-PRVS: <CY4PR12MB18482E82542A1486C68F2096DCBE9@CY4PR12MB1848.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Re+1z/mAdxdsoirj3kgkOuxClumkTZbyTatC0px8oGgS/vXtXx7P6QrChjS+6ESNTfHymZLur4PjNdQTc9BAsO6ZlF93xnVJdJfHGGSPgnV7ww1FbagR88ugbmDmrDzjmg/RNNp1r0SrTtgHe4lQoxtVNyugKU5T1xFYqOCa1PWWKF1+/xWzIpDniAU+nl/CGirRoWVJgQkklTqErVFP+nXwRNAKW4ZXl00/ZvK3EjLpeegp5kMjcRnds94ugY/+Cv37nJADfWSZVeR9RaFaZSWlAUngEsT8tV5RQ3HHd3GHDdebKdRu6GN8Q17xOwUOmPCc+020y9YhkIDt3ClYyqOy1XInOxKPiJcR3nQqO8E0SQrNnrNJk5pD99XEr9OGDsjsEzSAmvO1uFJOlL1sdISmLjiiRQMqsoBBbKI36Y/wohfwTWceT/8QoJRT8jqmWotFUyV948YaanBxd6Z6PUAkJByDMDhaALh8XYY7CSW4fo8CqCuberJHK8r87IZBZ1YQt70ekUn75jFKchFOrOlh7KIzZhVnSaNIJyTa6rOWPMAZt5m1XzyoY/Z1HTj57ZbtR2SH+pdi5tQFnaNHoSolPLnxTl72Kwt0m9kfuevEjZmtd6VzwAjGsftLXxc3QF9UpmHEWbFbJafRNLG9PpLhzqLVDhj+7OIkeHUo+fv+38Za11ZEtsWiIYPZhW7lrTOleF93Qrqz/UzP+H3KRrXrgWcsBtVq2SX55A+ItOc=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(6666004)(4001150100001)(508600001)(54906003)(36860700001)(5660300002)(4326008)(7416002)(2906002)(356005)(36906005)(316002)(16576012)(31686004)(86362001)(186003)(47076005)(7636003)(16526019)(31696002)(8936002)(26005)(53546011)(2616005)(82310400003)(70586007)(70206006)(8676002)(426003)(36756003)(6916009)(336012)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 13:16:25.7151
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5abd14c7-680b-4090-542e-08d993cbd1eb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1848
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-10-19 19:45, Eric Dumazet wrote:
> 
> 
> On 10/19/21 7:46 AM, Maxim Mikityanskiy wrote:
>> The new helper bpf_tcp_raw_gen_tscookie allows an XDP program to
>> generate timestamp cookies (to be used together with SYN cookies) which
>> encode different options set by the client in the SYN packet: SACK
>> support, ECN support, window scale. These options are encoded in lower
>> bits of the timestamp, which will be returned by the client in a
>> subsequent ACK packet. The format is the same used by synproxy.
>>
>> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
>> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
>> ---
>>   include/net/tcp.h              |  1 +
>>   include/uapi/linux/bpf.h       | 27 +++++++++++++++
>>   net/core/filter.c              | 38 +++++++++++++++++++++
>>   net/ipv4/syncookies.c          | 60 ++++++++++++++++++++++++++++++++++
>>   tools/include/uapi/linux/bpf.h | 27 +++++++++++++++
>>   5 files changed, 153 insertions(+)
>>
>> diff --git a/include/net/tcp.h b/include/net/tcp.h
>> index 1cc96a225848..651820bef6a2 100644
>> --- a/include/net/tcp.h
>> +++ b/include/net/tcp.h
>> @@ -564,6 +564,7 @@ u32 __cookie_v4_init_sequence(const struct iphdr *iph, const struct tcphdr *th,
>>   			      u16 *mssp);
>>   __u32 cookie_v4_init_sequence(const struct sk_buff *skb, __u16 *mss);
>>   u64 cookie_init_timestamp(struct request_sock *req, u64 now);
>> +bool cookie_init_timestamp_raw(struct tcphdr *th, __be32 *tsval, __be32 *tsecr);
>>   bool cookie_timestamp_decode(const struct net *net,
>>   			     struct tcp_options_received *opt);
>>   bool cookie_ecn_ok(const struct tcp_options_received *opt,
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index e32f72077250..791790b41874 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -5053,6 +5053,32 @@ union bpf_attr {
>>    *
>>    *		**-EPROTONOSUPPORT** if the IP version is not 4 or 6 (or 6, but
>>    *		CONFIG_IPV6 is disabled).
>> + *
>> + * int bpf_tcp_raw_gen_tscookie(struct tcphdr *th, u32 th_len, __be32 *tsopt, u32 tsopt_len)
>> + *	Description
>> + *		Try to generate a timestamp cookie which encodes some of the
>> + *		flags sent by the client in the SYN packet: SACK support, ECN
>> + *		support, window scale. To be used with SYN cookies.
>> + *
>> + *		*th* points to the start of the TCP header of the client's SYN
>> + *		packet, while *th_len* contains the length of the TCP header (at
>> + *		least **sizeof**\ (**struct tcphdr**)).
>> + *
>> + *		*tsopt* points to the output location where to put the resulting
>> + *		timestamp values: tsval and tsecr, in the format of the TCP
>> + *		timestamp option.
>> + *
>> + *	Return
>> + *		On success, 0.
>> + *
>> + *		On failure, the returned value is one of the following:
>> + *
>> + *		**-EINVAL** if the input arguments are invalid.
>> + *
>> + *		**-ENOENT** if the TCP header doesn't have the timestamp option.
>> + *
>> + *		**-EOPNOTSUPP** if the kernel configuration does not enable SYN
>> + *		cookies (CONFIG_SYN_COOKIES is off).
>>    */
>>   #define __BPF_FUNC_MAPPER(FN)		\
>>   	FN(unspec),			\
>> @@ -5238,6 +5264,7 @@ union bpf_attr {
>>   	FN(ct_release),			\
>>   	FN(tcp_raw_gen_syncookie),	\
>>   	FN(tcp_raw_check_syncookie),	\
>> +	FN(tcp_raw_gen_tscookie),	\
>>   	/* */
>>   
>>   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index 5f03d4a282a0..73fe20ef7442 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -7403,6 +7403,42 @@ static const struct bpf_func_proto bpf_tcp_raw_check_syncookie_proto = {
>>   	.arg4_type	= ARG_CONST_SIZE,
>>   };
>>   
>> +BPF_CALL_4(bpf_tcp_raw_gen_tscookie, struct tcphdr *, th, u32, th_len,
>> +	   __be32 *, tsopt, u32, tsopt_len)
>> +{
>> +	int err;
>> +
>> +#ifdef CONFIG_SYN_COOKIES
>> +	if (tsopt_len != sizeof(u64)) {
>> +		err = -EINVAL;
>> +		goto err_out;
>> +	}
>> +
>> +	if (!cookie_init_timestamp_raw(th, &tsopt[0], &tsopt[1])) {
>> +		err = -ENOENT;
>> +		goto err_out;
>> +	}
>> +
>> +	return 0;
>> +err_out:
>> +#else
>> +	err = -EOPNOTSUPP;
>> +#endif
>> +	memset(tsopt, 0, tsopt_len);
>> +	return err;
>> +}
>> +
>> +static const struct bpf_func_proto bpf_tcp_raw_gen_tscookie_proto = {
>> +	.func		= bpf_tcp_raw_gen_tscookie,
>> +	.gpl_only	= false,
>> +	.pkt_access	= true,
>> +	.ret_type	= RET_INTEGER,
>> +	.arg1_type	= ARG_PTR_TO_MEM,
>> +	.arg2_type	= ARG_CONST_SIZE,
>> +	.arg3_type	= ARG_PTR_TO_UNINIT_MEM,
>> +	.arg4_type	= ARG_CONST_SIZE,
>> +};
>> +
>>   #endif /* CONFIG_INET */
>>   
>>   bool bpf_helper_changes_pkt_data(void *func)
>> @@ -7825,6 +7861,8 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>>   		return &bpf_tcp_raw_gen_syncookie_proto;
>>   	case BPF_FUNC_tcp_raw_check_syncookie:
>>   		return &bpf_tcp_raw_check_syncookie_proto;
>> +	case BPF_FUNC_tcp_raw_gen_tscookie:
>> +		return &bpf_tcp_raw_gen_tscookie_proto;
>>   #endif
>>   	default:
>>   		return bpf_sk_base_func_proto(func_id);
>> diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
>> index 8696dc343ad2..4dd2c7a096eb 100644
>> --- a/net/ipv4/syncookies.c
>> +++ b/net/ipv4/syncookies.c
>> @@ -85,6 +85,66 @@ u64 cookie_init_timestamp(struct request_sock *req, u64 now)
>>   	return (u64)ts * (NSEC_PER_SEC / TCP_TS_HZ);
>>   }
>>   
>> +bool cookie_init_timestamp_raw(struct tcphdr *th, __be32 *tsval, __be32 *tsecr)
>> +{
>> +	int length = (th->doff * 4) - sizeof(*th);
>> +	u8 wscale = TS_OPT_WSCALE_MASK;
>> +	bool option_timestamp = false;
>> +	bool option_sack = false;
>> +	u32 cookie;
>> +	u8 *ptr;
>> +
>> +	ptr = (u8 *)(th + 1);
>> +
>> +	while (length > 0) {
>> +		u8 opcode = *ptr++;
>> +		u8 opsize;
>> +
>> +		if (opcode == TCPOPT_EOL)
>> +			break;
>> +		if (opcode == TCPOPT_NOP) {
>> +			length--;
>> +			continue;
>> +		}
>> +
>> +		if (length < 2)
>> +			break;
>> +		opsize = *ptr++;
>> +		if (opsize < 2)
>> +			break;
>> +		if (opsize > length)
>> +			break;
>> +
>> +		switch (opcode) {
>> +		case TCPOPT_WINDOW:
> 
> You must check osize.
> 
>> +			wscale = min_t(u8, *ptr, TCP_MAX_WSCALE);
>> +			break;
>> +		case TCPOPT_TIMESTAMP:
> 
> You must check opsize.

Ack.

>> +			option_timestamp = true;
>> +			/* Client's tsval becomes our tsecr. */
>> +			*tsecr = cpu_to_be32(get_unaligned_be32(ptr));
> 
> Please avoid useless ntohl/htonl dance (even if compiler probably optimizes this)
> No need to obfuscate :)

No obfuscation intended - I thought I was clearer this way. I can change it.

Thanks for reviewing!

> 
> 			*tsecr = get_unaligned((__be32 *)ptr);
> 
>> +			break;
>> +		case TCPOPT_SACK_PERM:
>> +			option_sack = true;
>> +			break;
>> +		}
>> +
>> +		ptr += opsize - 2;
>> +		length -= opsize;
>> +	}
>> +
>> +	if (!option_timestamp)
>> +		return false;
>> +
>> +	cookie = tcp_time_stamp_raw() & ~TSMASK;
>> +	cookie |= wscale & TS_OPT_WSCALE_MASK;
>> +	if (option_sack)
>> +		cookie |= TS_OPT_SACK;
>> +	if (th->ece && th->cwr)
>> +		cookie |= TS_OPT_ECN;
>> +	*tsval = cpu_to_be32(cookie);
>> +	return true;
>> +}
>>   
>>   static __u32 secure_tcp_syn_cookie(__be32 saddr, __be32 daddr, __be16 sport,
>>   				   __be16 dport, __u32 sseq, __u32 data)
>> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
>> index e32f72077250..791790b41874 100644
>> --- a/tools/include/uapi/linux/bpf.h
>> +++ b/tools/include/uapi/linux/bpf.h
>> @@ -5053,6 +5053,32 @@ union bpf_attr {
>>    *
>>    *		**-EPROTONOSUPPORT** if the IP version is not 4 or 6 (or 6, but
>>    *		CONFIG_IPV6 is disabled).
>> + *
>> + * int bpf_tcp_raw_gen_tscookie(struct tcphdr *th, u32 th_len, __be32 *tsopt, u32 tsopt_len)
>> + *	Description
>> + *		Try to generate a timestamp cookie which encodes some of the
>> + *		flags sent by the client in the SYN packet: SACK support, ECN
>> + *		support, window scale. To be used with SYN cookies.
>> + *
>> + *		*th* points to the start of the TCP header of the client's SYN
>> + *		packet, while *th_len* contains the length of the TCP header (at
>> + *		least **sizeof**\ (**struct tcphdr**)).
>> + *
>> + *		*tsopt* points to the output location where to put the resulting
>> + *		timestamp values: tsval and tsecr, in the format of the TCP
>> + *		timestamp option.
>> + *
>> + *	Return
>> + *		On success, 0.
>> + *
>> + *		On failure, the returned value is one of the following:
>> + *
>> + *		**-EINVAL** if the input arguments are invalid.
>> + *
>> + *		**-ENOENT** if the TCP header doesn't have the timestamp option.
>> + *
>> + *		**-EOPNOTSUPP** if the kernel configuration does not enable SYN
>> + *		cookies (CONFIG_SYN_COOKIES is off).
>>    */
>>   #define __BPF_FUNC_MAPPER(FN)		\
>>   	FN(unspec),			\
>> @@ -5238,6 +5264,7 @@ union bpf_attr {
>>   	FN(ct_release),			\
>>   	FN(tcp_raw_gen_syncookie),	\
>>   	FN(tcp_raw_check_syncookie),	\
>> +	FN(tcp_raw_gen_tscookie),	\
>>   	/* */
>>   
>>   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>>

