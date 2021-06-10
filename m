Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2540A3A2A13
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 13:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbhFJLVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 07:21:50 -0400
Received: from mail-dm6nam08on2088.outbound.protection.outlook.com ([40.107.102.88]:47264
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229935AbhFJLVr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 07:21:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A8+7h+4tamMrENca01tVmMWXRMy/R46UySSMYykFcKrvlHDHQ6q0hccmYY8YqyB20gbW444Exl3dhUy3CCtnyqe1yATwsd4GxuEul7n+yFGwSwBFhgDMUPceXTYyz+MYr2qex5lnhvTk8Jw+1E6G+ex7nVB6O0f+lw5/e36+iAmuYiBjRnj5xesOvgoO+gDDNYjqLLKVh5jsGfKKbYKfTsUFtd14SfE5tMof3t0dOiSA6cDhXXP+yXYzCxXp1YdHJYUpy3gOy1vaOME+f5/T0lLNFE8Iz8PUnFTFZ9Jf4yY+aLjUFDUNkB03yzRGI9unDDnGlSdsCdg+rFxJSm5cuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Il8OOfxUKuFDbPXInV2iepLTntl+kWvLkXcjau5mJFo=;
 b=OPeEQSJI5dxfuZsd06MCo6Nkfc1CTtlTNWQaABbn8rC2/xPW+7r0EyO3lFAWqqAnljaVcCkwYqfqQaq64fTWqvyU2spMEeftVIt83alCNIIw54vhr8VvkPzsoCw75UEa6FhJy9HSySvpNdXvq9mU7izndglta4OSuR6Z3z2Qudu5ISnswXmHTxVwhlKs2VL3P4AriUhuwuEn0mnCK7mDwne1ELki3CeLs3374kH8fAeujZmpQ4hEJP8ANJOYw82raLOUfWXPJs6U5fIQY3n2zV/KMCeQeWz0tW5GiJteKaJZSFZcDd+QgXUxfOsg0fu8CSQ6ZF4Fpm6saFy540J9BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Il8OOfxUKuFDbPXInV2iepLTntl+kWvLkXcjau5mJFo=;
 b=GiFuXgIh+7LlVVL/ywuHw7GQEbjnn9CbIOV47YlknKx2YWeYAV0suB86iONN/9sZVwBi7RAV7dF747cGn7pFOZ5oUuGnfG1FepBhasUhr2nQAq4SiPmdM1o9+e9pgRK7VEjdYGo91xMW6rI5CGLWW9tGyTKmf5JhJrmT8y3fSke0nhsMv692LBeuUBIuliTJrIiQicbuuBWxwxktH+smdjEQgy8IeAKxdmUuT23PzyPMdDzRaWg8bc/Nl8jD8uV+fIAEEf/C/MpGLYHtJC9j0QauWpkz4Wq9GDsJDyCw2H8wdhEoNcNOx5s4qXvjPsEa0ykIljwrUL3Iy4MInpIUbA==
Received: from BN9PR03CA0510.namprd03.prod.outlook.com (2603:10b6:408:130::35)
 by CO6PR12MB5489.namprd12.prod.outlook.com (2603:10b6:303:139::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Thu, 10 Jun
 2021 11:19:49 +0000
Received: from BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:130:cafe::19) by BN9PR03CA0510.outlook.office365.com
 (2603:10b6:408:130::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend
 Transport; Thu, 10 Jun 2021 11:19:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT046.mail.protection.outlook.com (10.13.177.127) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Thu, 10 Jun 2021 11:19:49 +0000
Received: from [172.27.0.10] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Jun
 2021 11:19:41 +0000
Subject: Re: [PATCH net 3/3] sch_cake: Fix out of bounds when parsing TCP
 options
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        Florian Westphal <fw@strlen.de>
CC:     Young Xiao <92siuyang@gmail.com>, <netdev@vger.kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Patrick McHardy <kaber@trash.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Peter Krystad <peter.krystad@linux.intel.com>
References: <20210609142212.3096691-1-maximmi@nvidia.com>
 <20210609142212.3096691-4-maximmi@nvidia.com> <87h7i6n1us.fsf@toke.dk>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
Message-ID: <cddbb9c5-58d2-64c4-f77b-9991ec977dc3@nvidia.com>
Date:   Thu, 10 Jun 2021 14:19:38 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87h7i6n1us.fsf@toke.dk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6bf39e73-9b3b-4b65-1756-08d92c01a931
X-MS-TrafficTypeDiagnostic: CO6PR12MB5489:
X-Microsoft-Antispam-PRVS: <CO6PR12MB5489E52D586165576FB6E991DC359@CO6PR12MB5489.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aRj6UBiREgg+JWjyGkxfAXEWn5n/cer0YkXL8M1g1+DS36hJRQREci92iOkWA9YgrF/6NHfJg7QDMBBnn/E4yrsyzJNjNdezj1Ef+enBYq5r1TWtlYLVoJ6f0n4X0F8G9K77S+Yrl3/84YC8kI1ivhMjhU2ooKiCwcUd3Xsz+iY0VIswyLX9Ew/Skmk8W8vIjov4gKGmOt0Gavkom+zIXSxOVTvC+guMT3DZxtNGvsCtkDaGMPxYVQ9u2wO+/AYXGAQpoOK+ZFJEFE8SQX396jpT0wE8upPXeNq69kcqulhIasWhemG69FvmWFQ9NacE5t5VfTJDbVjp1HvTEUOgDXF1GAttDMht+QvafJyX95X/6684rwYLK3U2ZqcNJU0K8x02hpuBSKNUFZpW/21zcMAxguRGr39cL2G7yycbTsZ2Q3CQwSQR+lvNjO5s+aFh4Hf1DSnG2R130pbRt7h4l3LVlPN8qwejpM/LhGBrma8UeB3YDh46chVES/RArx5JT4rneuTsA5L3+JQUPD29vCCaYGF2SZli/4uV9gElr0x9SWnvPK0nG4GeNqmZiRDX9BR6bNGnbovxUIiBlLM2p7QzzV22kjdCBh9vxn67FrmmYryAQsOdjEU8ujY6wVd6QCrJ8KKQ2ir/gBrF+CP2rhxv8BDUk/AZABPrIt97+vPVNhHUsvgOVhAH6zJU/hUQ
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(39860400002)(376002)(46966006)(36840700001)(4326008)(16526019)(8676002)(186003)(8936002)(26005)(82740400003)(336012)(70206006)(7416002)(83380400001)(426003)(31696002)(2616005)(356005)(31686004)(47076005)(5660300002)(16576012)(6666004)(110136005)(316002)(2906002)(54906003)(86362001)(82310400003)(36860700001)(7636003)(478600001)(53546011)(36756003)(36906005)(70586007)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 11:19:49.2933
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bf39e73-9b3b-4b65-1756-08d92c01a931
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5489
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-06-10 00:51, Toke Høiland-Jørgensen wrote:
> Maxim Mikityanskiy <maximmi@nvidia.com> writes:
> 
>> The TCP option parser in cake qdisc (cake_get_tcpopt and
>> cake_tcph_may_drop) could read one byte out of bounds. When the length
>> is 1, the execution flow gets into the loop, reads one byte of the
>> opcode, and if the opcode is neither TCPOPT_EOL nor TCPOPT_NOP, it reads
>> one more byte, which exceeds the length of 1.
>>
>> This fix is inspired by commit 9609dad263f8 ("ipv4: tcp_input: fix stack
>> out of bounds when parsing TCP options.").
>>
>> Cc: Young Xiao <92siuyang@gmail.com>
>> Fixes: 8b7138814f29 ("sch_cake: Add optional ACK filter")
>> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> 
> Thanks for fixing this!
> 
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
> 

Could you also review whether Florian's comment on patch 1 is relevant 
to this patch too? I have concerns about cake_get_tcphdr, which returns 
`skb_header_pointer(skb, offset, min(__tcp_hdrlen(tcph), bufsize), 
buf)`. Although I don't see a way for it to get out of bounds (it will 
read garbage instead of TCP header in the worst case), such code doesn't 
look robust.

It's not possible for it to get out of bounds, because there is a call 
to skb_header_pointer above with sizeof(_tcph), which ensures that the 
SKB has at least 20 bytes after the beginning of the TCP header, which 
means that the second skb_header_pointer will either point to SKB (where 
we have at least 20 bytes) or to buf (which is allocated by the caller, 
so the caller shouldn't overflow its own buffer).

On the other hand, parsing garbage doesn't look like a valid behavior 
compared to dropping/ignoring/whatever-cake-does-with-bad-packets, so we 
may want to handle it, for example:

          return skb_header_pointer(skb, offset,
-                                  min(__tcp_hdrlen(tcph), bufsize), buf);
+                                  min(max(sizeof(struct tcphdr), 
__tcp_hdrlen(tcph)), bufsize), buf);

What do you think? Or did I just miss some early check for doff?

(I realize it's egress path and the packets produced by the system 
itself are unlikely to have bad doff, but it's not impossible, for 
example, with AF_PACKET, BPF hooks in tc, etc.)
