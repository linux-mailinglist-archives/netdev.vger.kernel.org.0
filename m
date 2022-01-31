Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07FE64A4879
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 14:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378878AbiAaNjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 08:39:16 -0500
Received: from mail-bn8nam12on2083.outbound.protection.outlook.com ([40.107.237.83]:32864
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243165AbiAaNjL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 08:39:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fXj3LJLtanLo8mKoF2/vDbYuBvQxW4cDpPHrw+OHDgYyeNZ9vq2CUP/oRSpxNi6m6XA85tAOeAsZ6WW3VjNSrGu9mfdGbUhuG3hMKkmk2Z47Z3JyXcnW2L/kjNFglbSfsIApPR+WemHqgwxHpCs5kcme9sgRDNxSahVNgLRN11Yi949AU/VeeJ/Q1MOT/+tTsIRIMtDVxDvYdp9X2NF2R9FI9//EXjPJB7p/ybBATPBfiVA2c2Tlvtu54ryxL85ua9zXlfr8xKR5ttnUW/r1CceF3qzudI6sDDRl/YI3cUdihHI7IOqmA2x8LN9AhLgrOnfdKy5ZVvZnIbrg0cSn4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C9Uxyklltr/BCkdpnQfYZShXB2tE/LVM8LXF9R8w7hs=;
 b=Wfb02KINtPb/mjB9ysmo0hV3WIhVV9VG7l2EfL2CInNk/dtIivrddIWVYEHd6ZOU7Byak7ZesNjel0M4GSlhQAuBrWDriiWuU6gaGVHZJP0qG5mQvtAkqOMSOXKiMbbioQKh6ZzuPlOTCpeF7JVDS2mffkRqCRWZg/EcbmE0p9L8kpykiEKBALBdku5TWX4w4dihnaFVuaKW9hB5+nVhDsIH8I/XxEhrooA6nzepHNjF6QhG3SIyNCslAEls+3HNWGYxWzilOluR4Zv0+dOWck0L9/jgl538y201K+gtsuTtn2H0iGq7lIXEXsK5eLAl0bDV0ZNm9+ypNT2pZVa67w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=fb.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C9Uxyklltr/BCkdpnQfYZShXB2tE/LVM8LXF9R8w7hs=;
 b=U5PWbY9VNJivV90cgBy3ozOG0324ZKw2YLbN2iaMAER3E+JB1QS3SFzW9igiWhQAf0cvnxKNJLMNBZKWuuF/KcqxlfYG+xSeNjPVS6euBJRPrZ7e27HoehuiYyQbqjtgai/lnA6jw0ZeOIO68CcpD/4dOKOjv99ookxNjtrqHdwdAmnE7ZmGSeAygDs8XapbaTMKl66NF5TYqwf1x3SraBYcajjbRtfGpKSX6lKz9z7fpruM8Ou4M5F7efBFKqRP4ErWHzcBQADqrwv16agAtnncs4hBE7qLkFW5l+9PVcxUBDO/T/Wfcq8vCC9SI2n8jIeg0Q2KdYnI+4AVpTOMzw==
Received: from BN6PR2001CA0016.namprd20.prod.outlook.com
 (2603:10b6:404:b4::26) by BN7PR12MB2674.namprd12.prod.outlook.com
 (2603:10b6:408:29::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Mon, 31 Jan
 2022 13:39:09 +0000
Received: from BN8NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:b4:cafe::a5) by BN6PR2001CA0016.outlook.office365.com
 (2603:10b6:404:b4::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.21 via Frontend
 Transport; Mon, 31 Jan 2022 13:39:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT048.mail.protection.outlook.com (10.13.177.117) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Mon, 31 Jan 2022 13:39:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 31 Jan
 2022 13:39:05 +0000
Received: from [172.27.13.98] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 31 Jan 2022
 05:38:53 -0800
Message-ID: <4465f976-1c75-eb67-78f8-0d92ae8aea4d@nvidia.com>
Date:   Mon, 31 Jan 2022 15:38:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH bpf-next v2 1/3] bpf: Make errors of
 bpf_tcp_check_syncookie distinguishable
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
 <20220124151340.376807-2-maximmi@nvidia.com>
 <61efa8de8babc_274ca20835@john.notmuch>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <61efa8de8babc_274ca20835@john.notmuch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: drhqmail203.nvidia.com (10.126.190.182) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 499e3262-e270-4e92-0c69-08d9e4bf0dc7
X-MS-TrafficTypeDiagnostic: BN7PR12MB2674:EE_
X-Microsoft-Antispam-PRVS: <BN7PR12MB2674CD75B96F7EF8995459C5DC259@BN7PR12MB2674.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xPQv4DdNhPyy8YtxeVv686kcUq/IuGBV0X0gRTOoBnFRGW+KntSH+1hVhV41carQWBIF8gRarg3fpoyRszbhUxTvu56pjPJNMR/60DwRPfKO2E9QRPDXH0WwQ1kwsQdoKn6VIZIYCXHRMhK9d4vIpEQflg/D9npaa2nlmlia49IZ92onncREI5oHZI5LsUSnApPIlLt6iAfGSeiflMpCdLrHZ7ZSjfzETDcGYZ33yr5qcurxcT4Ost1/IiJiEyNAciX/d8Wv1+wm/0Ki7RKhhVR2gmQduO+vI81tH3fuF+YyaxHse4Tca4Q1T50bkCq3fP7CgmWHH8k4NTPi2ca1NXc4sr9e+oQN9/bXOOAPlxWVjeAVMsnBIED/6TugAFuv1hN+SYq3LTmdyzY+uVAs4orM2V/aZQ32DtJlPs62WapsctHUhYraedPwywFJyqg3PSNqoPAh+VizDKJq0vw3PBuKqb0/Jrx4chrLXE1YHxB0dz4GruJHfHfduVevePb7blGW1Yg9Bv0Fr7Bto25qWRgJTGNURt26PTRfuYIRsVydjvJfUETYCVaAUaA70z0eupg9cWgXezP7qZ32Qgr33unFls3uctYpHSsFuoJ/m5E3xGsNvLeQ3aaEPzQrK60KknY5bWM3fQ0nI7zp4cad8eDRhZlLMCXUpbiUjiBbv7vvxS8R0QwLNzLVYX1OZbZ+Mhxh5OUAu5zUZgTapyIiCZ4jpF17RsKSVCB7e/pnHHu8X7GDRJ3lKG8KAkTMzX/d
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(4326008)(47076005)(8936002)(8676002)(83380400001)(26005)(36860700001)(40460700003)(6916009)(508600001)(54906003)(16576012)(31696002)(86362001)(31686004)(36756003)(336012)(426003)(2616005)(186003)(70586007)(70206006)(16526019)(82310400004)(5660300002)(53546011)(316002)(2906002)(7416002)(356005)(81166007)(43740500002)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 13:39:06.9108
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 499e3262-e270-4e92-0c69-08d9e4bf0dc7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2674
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-25 09:38, John Fastabend wrote:
> Maxim Mikityanskiy wrote:
>> bpf_tcp_check_syncookie returns ambiguous error codes in some cases. The
>> list below shows various error conditions and matching error codes:
>>
>> 1. NULL socket: -EINVAL.
>>
>> 2. Invalid packet: -EINVAL, -ENOENT.
>>
>> 3. Bad cookie: -ENOENT.
>>
>> 4. Cookies are not in use: -EINVAL, -ENOENT.
>>
>> 5. Good cookie: 0.
>>
>> As we see, the same error code may correspond to multiple error
>> conditions, making them undistinguishable, and at the same time one
>> error condition may return different codes, although it's typically
>> handled in the same way.
>>
>> This patch reassigns error codes of bpf_tcp_check_syncookie and
>> documents them:
>>
>> 1. Invalid packet or NULL socket: -EINVAL;
>>
>> 2. Bad cookie: -EACCES.
>>
>> 3. Cookies are not in use: -ENOENT.
>>
>> 4. Good cookie: 0.
>>
>> This change allows XDP programs to make smarter decisions based on error
>> code, because different error conditions are now easily distinguishable.
> 
> I'm missing the point here it still looks a bit like shuffling
> around of code. What do you gain, whats the real bug?

Current error codes are useless. If the caller gets a negative value, 
all it knows is that some error happened. I'm making different error 
conditions distinguishable (invalid input, bad cookie, not expecting a 
cookie).

Use cases could be: statistic counters, debugging, logging. For example, 
the kernel counts LINUX_MIB_SYNCOOKIESFAILED, which only includes the 
"bad cookie" case.

Another use case is replying with RST when not expecting a cookie (a new 
ACK packet could just mean that the server was rebooted, and it's good 
to tell the client that the connection is broken), but dropping packets 
under the flood on receiving bad cookies (to avoid wasting resources on 
sending replies).

> Are you
> trying to differentiate between an overflow condition and a valid
> syncookie? But I don't think you said this anywhere.

I'm not sure what you mean by the "overflow condition", but a valid 
syncookie is easily distinguishable from other cases, it's 0.

> At the moment EINVAL tells me somethings wrong with the input or
> configuration, although really any app that cares checked the
> sysctl flag right?

There is no way to check sysctl from XDP. A single program could be 
useful both with and without syncookies, it could determine its behavior 
in runtime, not to say that the sysctl option could change in runtime. 
The workaround you suggested will work in some cases, but other cases 
just won't work (there are no notification events on sysctl changes that 
a userspace application could monitor and pass to the XDP program; it 
would be not immediate anyway).

> ENOENT tells me either recent overflow or cookie is invalid.

And these cases should be distinguished, as I said above.

> If
> there is no '!ack || rst || syn' then I can either learn that
> directly from the program (why would a real program through
> these at the helper), but it also falls into the incorrect
> cookie in some sense.
> 
>>
>> Backward compatibility shouldn't suffer because of these reasons:
>>
>> 1. The specific error codes weren't documented. The behavior that used
>>     to be documented (0 is good cookie, negative values are errors) still
>>     holds. Anyone who relied on implementation details should have
>>     understood the risks.
> 
> I'll disagree, just because a user facing API doesn't document its
> behavior very well doesn't mean users should some how understand the
> risks. Ideally we would have done better with error codes up front,
> but thats old history. If a user complains that this breaks a real
> application it would likely be reason to revert it.
> 
> At least I would remove this from the commit.
> 
>>
>> 2. Two known usecases (classification of ACKs with cookies that initial
>>     new connections, SYN flood protection) take decisions which don't
>>     depend on specific error codes:
>>
>>       Traffic classification:
>>         ACK packet is new, error == 0: classify as NEW.
>>         ACK packet is new, error < 0: classify as INVALID.
>>
>>       SYN flood protection:
>>         ACK packet is new, error == 0: good cookie, XDP_PASS.
>>         ACK packet is new, error < 0: bad cookie, XDP_DROP.
>>
>>     As Lorenz Bauer confirms, their implementation of traffic classifier
>>     won't break, as well as the kernel selftests.
>>
>> 3. It's hard to imagine that old error codes could be used for any
>>     useful decisions.
>>
>> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
>> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
>> ---
>>   include/uapi/linux/bpf.h       | 18 ++++++++++++++++--
>>   net/core/filter.c              |  6 +++---
>>   tools/include/uapi/linux/bpf.h | 18 ++++++++++++++++--
>>   3 files changed, 35 insertions(+), 7 deletions(-)
>>
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 16a7574292a5..4d2d4a09bf25 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -3575,8 +3575,22 @@ union bpf_attr {
>>    * 		*th* points to the start of the TCP header, while *th_len*
>>    * 		contains **sizeof**\ (**struct tcphdr**).
>>    * 	Return
>> - * 		0 if *iph* and *th* are a valid SYN cookie ACK, or a negative
>> - * 		error otherwise.
>> + *		0 if *iph* and *th* are a valid SYN cookie ACK.
>> + *
>> + *		On failure, the returned value is one of the following:
>> + *
>> + *		**-EACCES** if the SYN cookie is not valid.
>> + *
>> + *		**-EINVAL** if the packet or input arguments are invalid.
>> + *
>> + *		**-ENOENT** if SYN cookies are not issued (no SYN flood, or SYN
>> + *		cookies are disabled in sysctl).
>> + *
>> + *		**-EOPNOTSUPP** if the kernel configuration does not enable SYN
>> + *		cookies (CONFIG_SYN_COOKIES is off).
>> + *
>> + *		**-EPROTONOSUPPORT** if the IP version is not 4 or 6 (or 6, but
>> + *		CONFIG_IPV6 is disabled).
>>    *
>>    * long bpf_sysctl_get_name(struct bpf_sysctl *ctx, char *buf, size_t buf_len, u64 flags)
>>    *	Description
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index a06931c27eeb..18559b5828a3 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -6998,10 +6998,10 @@ BPF_CALL_5(bpf_tcp_check_syncookie, struct sock *, sk, void *, iph, u32, iph_len
>>   		return -EINVAL;
>>   
>>   	if (!sock_net(sk)->ipv4.sysctl_tcp_syncookies)
>> -		return -EINVAL;
>> +		return -ENOENT;
> 
> I wouldn't change this.
> 
>>   
>>   	if (!th->ack || th->rst || th->syn)
>> -		return -ENOENT;
>> +		return -EINVAL;
> 
> not sure if this is useful change and it is bpf program visible.
> 
>>   
>>   	if (tcp_synq_no_recent_overflow(sk))
>>   		return -ENOENT;
>> @@ -7032,7 +7032,7 @@ BPF_CALL_5(bpf_tcp_check_syncookie, struct sock *, sk, void *, iph, u32, iph_len
>>   	if (ret > 0)
>>   		return 0;
>>   
>> -	return -ENOENT;
>> +	return -EACCES;
> 
> This one might have a valid argument to differentiate between an
> overflow condition and an invalid cookie. But, curious what do you
> do with this info?
> 
> Thanks,
> John

