Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20AE24A486C
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 14:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379038AbiAaNia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 08:38:30 -0500
Received: from mail-bn8nam12on2085.outbound.protection.outlook.com ([40.107.237.85]:44129
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1379019AbiAaNiZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 08:38:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RQg3a33mui7naXDU38HMbjZhmWDwjL7zUp8g/Ff94C3IuoDW+Tm/+5WwpWT0DjkYYuKqHoBa5yDET2KGuABkpTXjW+gzu4v3Vh4FcyfLiyjq7VtlqBYs+7SF2jRQGOUWYiE9/OOapzwLPQt40Iy8EAjd/NDuGxjM3T6r2P+yN8Hv8lv2ZaazGewe+OKygKthMYkkCvZJwVFUkhcXjUU0q2aVV0WNhbFf20JBFNrafbeq2BvRGbIxd5QGLH1PywgAAf6L0DEcaGVLIObX+504Lmvh4b5zhh5xP+xrAIKBRcMONdGuW1b6pZucouVhVfrazsDq2f8w+dZQkCRfaPBDWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HqV1a25X+H/VG7v3n0QJqNLObPWROB6aWp7pmXZG6/s=;
 b=KYExeMQrIh8fFfT5/07bDiJ365iR6aT76ysCfV4IEPEKhPiNLG3U4lNEmTYEVFjrSN4bIEotX4O/8nEQRFSh2uqvOhVT7HpRghsA75nWRton7Sx5O1U3DUiaZyGZDxOk2nLdW3iehgePtUB2hfnbmw4XIjW5fyLQY7lwp+n6IGb+BFTS44h/hjrUKFYNYXJY0mY/OY5T9X2R/2ZvX7cKb/nnNtAfC+6ntWyhXVlJxi7hu0VLMg94x5gxIFhV18M0GMDiv0bgErFsUF2xF6g+2nNuhnYUSxQZUaHdyFKQfI/XwI1X2pLq4t3yf+S52AuAB44LcGajjZ3sc95ZXewgng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HqV1a25X+H/VG7v3n0QJqNLObPWROB6aWp7pmXZG6/s=;
 b=rXJaZ/7mVO4qzGbWX4jOuESAbkf/z6ty+9zscUTVBWbQWbQjEZbJvVB/QDSDgG/u5CY0j4alkWW6kntapE6NEku9tk+R/R6gBZZHnKPWBMe0HolUGFNHNVsM8bOI3dNGzLiGvXr6/xJpiUlHxIOLv/SbKUlBpavkOEesbUFVR0e+WegBmZ1WxkcHDJ5lE2dWAIxQ0bbI16WTQHNA89VhYIVqaYTzG4IGIZqaPFKJaAvfQJ2fYgQU1OLuzUEPL8EgFaRvSAeqPwoz1b95zFN0S3jU/enAgFEhEgo3Iig9h24lam5kH1cuL0QH8r3+0MHpii18Y0eXrLvNzoySZX/EaA==
Received: from BN9PR03CA0623.namprd03.prod.outlook.com (2603:10b6:408:106::28)
 by CH2PR12MB5562.namprd12.prod.outlook.com (2603:10b6:610:67::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Mon, 31 Jan
 2022 13:38:23 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:106:cafe::70) by BN9PR03CA0623.outlook.office365.com
 (2603:10b6:408:106::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15 via Frontend
 Transport; Mon, 31 Jan 2022 13:38:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Mon, 31 Jan 2022 13:38:22 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 31 Jan
 2022 13:38:21 +0000
Received: from [172.27.13.98] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 31 Jan 2022
 05:38:15 -0800
Message-ID: <727ed7f4-c29e-05e1-2d8d-2f1dcdd06002@nvidia.com>
Date:   Mon, 31 Jan 2022 15:38:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH bpf v2 2/4] bpf: Support dual-stack sockets in
 bpf_tcp_check_syncookie
Content-Language: en-US
To:     Lorenz Bauer <lmb@cloudflare.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        "Martin KaFai Lau" <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Eric Dumazet <edumazet@google.com>
References: <20220124151146.376446-1-maximmi@nvidia.com>
 <20220124151146.376446-3-maximmi@nvidia.com>
 <CACAyw9_mA-yBWbU6Sf8hq6P46PfiTpEZYTGSKmNG6ZiFWGz=ZQ@mail.gmail.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <CACAyw9_mA-yBWbU6Sf8hq6P46PfiTpEZYTGSKmNG6ZiFWGz=ZQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: drhqmail203.nvidia.com (10.126.190.182) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 213b4a23-bfd3-4e18-04e4-08d9e4bef371
X-MS-TrafficTypeDiagnostic: CH2PR12MB5562:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB556219C31515821AD87F4159DC259@CH2PR12MB5562.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yRPcez/fUU8BD4IYBmB1ty2iCYLTvLfJprlFfDN4DjbDwkmBB8pnIvdMPC0i7w+f1gKPufMQM2qjhi20eLcO3M2D0+zEK73JBNLjyfqX1OH/+Wkd68JEsgIDQ4/cUiXqAgeQRh8DPUf17pSF4S1xObR1Su9g3KfkiFrm0CoSLMjJT4rrZQ9Mn1Az3A1MxsE05fZz73+MYxGyBNDkFWp3EWuUOhH1nZ28Ej+r1FN/Rre403/DnxVB7tv6SXxqgEnhkqwaWHnAspaDCHZlGVSSNdlAdv8oyTwCQsW0CBfIa+PIAHBharqK3MAdSTZQMJ6k6L49CYSupjNJFQIgab8Pb2GWbB5VyuKGsZdzmWwTiPyxY7amcxY0tT0QYAPeDzkZZckohxhLyE8HsPA+JRyB6RoZv2/6HtFO/wc+llJqLgYXroWGEixx7KBwD9Tsc1MC89ACn41UO0VcQMq4u/zVrcMDcarw5lrTqlVw8pbmx+JQ2fvlWA1bTXFXUS2RPYaEkPq/Ex3C8j+TERfAniAEFyzH6AkcPhLvhb94DnGRTRPXOqE83CqIKw7hetWhLEJxeNegJ4U8sl2XAiCZBN18GMGrWAFwq63ouw1da8ZOEeejoEekQJZrXi2W+eNuS7vsHpN318JLrWHiv6ImRBlne3VQGdBe4XjfYfp9rj7aBbVb9Mq3W/UA2yaFWKBnuvRIJvPDKLN3EEApXOqVGctT5j7n0XX521BFZK9noZdljvKP8HpMkqiz3p0xI3L/IG9U
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(2616005)(8676002)(8936002)(70206006)(70586007)(4326008)(6666004)(6916009)(31686004)(508600001)(54906003)(16576012)(316002)(2906002)(16526019)(186003)(26005)(83380400001)(47076005)(336012)(426003)(81166007)(86362001)(40460700003)(31696002)(82310400004)(36756003)(36860700001)(53546011)(5660300002)(7416002)(356005)(43740500002)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 13:38:22.7106
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 213b4a23-bfd3-4e18-04e4-08d9e4bef371
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5562
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-26 11:49, Lorenz Bauer wrote:
> On Mon, 24 Jan 2022 at 15:13, Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>>
>> bpf_tcp_gen_syncookie looks at the IP version in the IP header and
>> validates the address family of the socket. It supports IPv4 packets in
>> AF_INET6 dual-stack sockets.
>>
>> On the other hand, bpf_tcp_check_syncookie looks only at the address
>> family of the socket, ignoring the real IP version in headers, and
>> validates only the packet size. This implementation has some drawbacks:
>>
>> 1. Packets are not validated properly, allowing a BPF program to trick
>>     bpf_tcp_check_syncookie into handling an IPv6 packet on an IPv4
>>     socket.
>>
>> 2. Dual-stack sockets fail the checks on IPv4 packets. IPv4 clients end
>>     up receiving a SYNACK with the cookie, but the following ACK gets
>>     dropped.
>>
>> This patch fixes these issues by changing the checks in
>> bpf_tcp_check_syncookie to match the ones in bpf_tcp_gen_syncookie. IP
>> version from the header is taken into account, and it is validated
>> properly with address family.
>>
>> Fixes: 399040847084 ("bpf: add helper to check for a valid SYN cookie")
>> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
>> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
>> ---
>>   net/core/filter.c | 17 +++++++++++++----
>>   1 file changed, 13 insertions(+), 4 deletions(-)
>>
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index 05efa691b796..780e635fb52a 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -6774,24 +6774,33 @@ BPF_CALL_5(bpf_tcp_check_syncookie, struct sock *, sk, void *, iph, u32, iph_len
>>          if (!th->ack || th->rst || th->syn)
>>                  return -ENOENT;
>>
>> +       if (unlikely(iph_len < sizeof(struct iphdr)))
>> +               return -EINVAL;
>> +
>>          if (tcp_synq_no_recent_overflow(sk))
>>                  return -ENOENT;
>>
>>          cookie = ntohl(th->ack_seq) - 1;
>>
>> -       switch (sk->sk_family) {
>> -       case AF_INET:
>> -               if (unlikely(iph_len < sizeof(struct iphdr)))
>> +       /* Both struct iphdr and struct ipv6hdr have the version field at the
>> +        * same offset so we can cast to the shorter header (struct iphdr).
>> +        */
>> +       switch (((struct iphdr *)iph)->version) {
>> +       case 4:
>> +               if (sk->sk_family == AF_INET6 && ipv6_only_sock(sk))
>>                          return -EINVAL;
> 
> Wouldn't this allow an arbitrary value for sk->sk_family, since there
> is no further check that sk_family is AF_INET?

It relies on the assumption that sk_family is either AF_INET or 
AF_INET6, when sk_protocol is IPPROTO_TCP (checked above). The same 
assumption is used in bpf_tcp_gen_syncookie. Do you think there are 
cases when it doesn't hold, and we must verify sk_family? If yes, then 
bpf_tcp_gen_syncookie should also be fixed.
