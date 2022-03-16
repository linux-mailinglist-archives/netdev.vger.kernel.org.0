Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D66B4DA6EA
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 01:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352821AbiCPAeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 20:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238380AbiCPAeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 20:34:20 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2063.outbound.protection.outlook.com [40.107.244.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422BC25EBA
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 17:33:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lz2iQXWcjWySE5D3sjxK8HaerCwLhJdjvzibtojD5A1qOtKnIoC2tNza268j6xVwfn/sfVXEpjH05xABWblIKngAt9Ww/icQ9aMZmr9lCARgmtOHxeP48wAamhYdSfXqqcjsjCU8ZF8yzxK3SbQYoVNmA3/dL98CKQJu+hZYS4F4E5520zTrJcRV5idl4n16T8B/t+FTMPSnT97gvM6wyZABqeFLT8AiHUBEj2dp0YxQ8KlZd+9yCRqY0/Zi0mHPg96ZpRQ5kC4ANwca9bzJeNCzHAz3m6W8W3jEVaHWxayyZ0eq1/Pu6fFBDqQ3a3dgJ6GrNSMyIe1d8X24i6Q33g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nJ5TAXeW5p3giyL8Wz1HEpaZKo749v3UvjiVp4AaGls=;
 b=IEkm13vQnBogsG6ft0g1k+GsFhsdqHE/tFSN32WlpTPiiJrKNXsVUrhB6vz+8pdLmTsEKqHZAVrVV2DGhUjmTpBX1vUJqs5NJ+CwTrl7Jo67+hc3mFI40Rex3h2CosW0ejmdvjYIfYSiUi4Z6S93ZbD4ao+hKBjCBXfaSBRiX1COMtujwNDn4D/Sj6Thn9mxyThZ1eECa+h7PdfmI+fRJSUHtRfC1erWyObdUKmKnuRu+1WXsEPME0W2e3S9B6mWqRNgiB8vXo7FIxiOjk7+qbdlvvt0fiABBvMpvrPqOxkd+8iAZDPDeC78nkjC9xr0dgAMRyWx5IE0Zt+d8qx2WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nJ5TAXeW5p3giyL8Wz1HEpaZKo749v3UvjiVp4AaGls=;
 b=re3pN6YDqJj9elUUJS2yvWqbCvQZN7s0gRoAZYxhq+wvfwUiQjZ7RyZ94bUyFfSzB7GcTiIOCjRr+3wY+QbUHq/QgFkB7hOkm/+sGoVDDcRm43mOOW/fQVS327f3xtqmedYTekePpwQXeqrCTrVG20cY57VuEaY35akSn8qksBeVz15c3z0FwxNKzGnCr6LkM+DijNOBE/f8f8DlYVMvZ/JXiiPRRZZ8/RddlKN1KNa3rHtbazQf2e+78/1CIfKeURrO+368xla+Gt+1aklh9w7jVAzVuENmkhHV7v5weeyKAnBc6Ip0XCQtprBjd9SM+LFn2RnJ68OdkG1xkZARuw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24)
 by CY4PR1201MB0006.namprd12.prod.outlook.com (2603:10b6:903:d3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26; Wed, 16 Mar
 2022 00:33:00 +0000
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::e037:47db:2c40:722c]) by SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::e037:47db:2c40:722c%5]) with mapi id 15.20.5061.028; Wed, 16 Mar 2022
 00:33:00 +0000
Message-ID: <377ae473-a908-6dc3-c658-ca2b81d364e0@nvidia.com>
Date:   Tue, 15 Mar 2022 17:32:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next] net: geneve: support IPv4/IPv6 as inner protocol
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, shmulik.ladkani@gmail.com,
        netdev@vger.kernel.org
References: <20220315185603.160778-1-eyal.birger@gmail.com>
 <5218b1e8-ee36-f708-00a3-79738b8f7ac4@nvidia.com>
 <CAHsH6Gvj5CVZUVw7-EDrTYzs5vSae3TmFQeRJYuA9wycmVhfOg@mail.gmail.com>
From:   Roopa Prabhu <roopa@nvidia.com>
In-Reply-To: <CAHsH6Gvj5CVZUVw7-EDrTYzs5vSae3TmFQeRJYuA9wycmVhfOg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0056.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::31) To SJ0PR12MB5504.namprd12.prod.outlook.com
 (2603:10b6:a03:3ad::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bceab047-6b91-422d-65b4-08da06e4865d
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0006:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0006B1F3209FEC3BB48E9B39CB119@CY4PR1201MB0006.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pMMni5fB6JdzbM0HVnpi0SxMYjL5RYBxjlBELqeg60AXafLeG5DUY7WibfxXAshtqLXTB3+tRtAMLId3CF5jxquOEab+YQ5xaMVJPtKXx12P0IvADhbMMuHzSc4ueHpUgmmwDFHonOu8Ep5i3lYh0IGyLrX2oXgUeD8D/mPb0BDByHtmsaJ0P81hznmv+6896e5KYyWvERAnHkzJR628A16AfKtK6JJxJHgfdqVoqJVhn7auaD5OhYpYFSHpa40AY2xIYwzt31p4cv/1ozjuMEbVMvkMdq1yOAuDb6UeLfokj3undnBP3D5XAC51ATduzj1Ryuj9+C7reiOHUheSqmHGpDeIzmHNdLyUTkGxHXXJCFs9FaUhgNi0hDWVlZkN8+xfDBVRdKuxNyCRawO05fMzoRJmNK+mw2WtcVxU3V/jRBor7K7i6ARqCPv5KzwWT2CqXcze2p5MSYePrqeFB6lh3qp72hrd+fLirhnZ8sEoFdnyrxkLaS9A5KTXmgKDC0naFnlA+/mA8YL0tdA9X5XyHDraBEtfExcgSVFV8d4P4R50TcMKtHnnTgkAn1f9k56n51vyIiwgpsewe8/igCavRJ0Sk2Js/4aMIYAzSietf8je/J2iHOppTfU28J4FZXLjJmsHFrlJi4iY8wozIFhdfPbM5UHhuiM7+qzvR4nPltMtK1DaGVILxk8zj9Z4zxWrlXkHZpPGWtiXHS1ZOpE96AWRidaRLtmRSnOcUIUT18Jl0iCj15KkC5+xBlDZycrYSPXtLrSPaVHH89hdtyOYn6DMRUkQmDvQtZgeR4SqMxHOvn5ypFHmijKnUEFk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5504.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(4326008)(66556008)(66476007)(6916009)(66946007)(316002)(508600001)(966005)(6486002)(38100700002)(86362001)(36756003)(31696002)(31686004)(2906002)(53546011)(45080400002)(26005)(186003)(2616005)(6506007)(6666004)(6512007)(8936002)(5660300002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZlBGWVVZM0lsN0RqNzAzcTJmdlRsN0lGSXlvdnU4RnlXUDlmTDk5cWVNZU9R?=
 =?utf-8?B?NTFxZDMxOHo4Qm8yOFNGUEIwbUo0OVNFM1pXNTZxQ3RiS0lmN1dHcUlEZ1pH?=
 =?utf-8?B?K2pwOTg3dXN0ZS9uRkhYQmxQWTZRS1pXYzFJbFd4RXRrVjFoQjVkU2ZpMGt5?=
 =?utf-8?B?YkxxOFhyQUFLTHNHYlIxWThKWGVITEZ5SERCaXA0cnc5TlREUjE4VlR0QzUz?=
 =?utf-8?B?OXh5L2xnL28yTnNGMWd0WWlCUjl1Q2tnUUFmQUJLSjdkekFSWk03SzZ6MGhZ?=
 =?utf-8?B?b2phN1lSQWoycXFRaVNOKytQOFhvVFc5T1drV2ZlUVZWa0Nra25sSWlEcnNI?=
 =?utf-8?B?YnNuNlNrY2EvRWI3aDhBN2xFblBVSm5JbFlvckFWdEZJbkFlZ0t2NVBEREhC?=
 =?utf-8?B?UTBmVnBiT0ZBeDFhZHdHaDNNdGFsU2tqcW1ReVZacm9VVUtWdGR1N3NMcEl1?=
 =?utf-8?B?WkNjb3ArTUJEOGVISW0wTHdhNWZ3S0p3ajZQU0NhaHU1S20xRkJFNlRvaXpB?=
 =?utf-8?B?bkVsMncvQ3VHRTJEWndrajdYR3pZUkRrY0FZZkJLTjJQcUQ5THJlakpSYVZ5?=
 =?utf-8?B?enlXVElMYUpYRVF0VmNqRnRiWUVxc3dqbk5qSkRMOEtuZVB4U096cnN6akhz?=
 =?utf-8?B?S2dlWTFialZGS1ZXcUt4aWVQVi81YkZvc2VXYjY1c3N3ZkJ0NEU4WDd2UXFW?=
 =?utf-8?B?NFk0MFl2YU1yNFFsTGlMeXcxRkZDNU80QmFnVkxwL3BnMVp3S3pCcWg2Qk10?=
 =?utf-8?B?SGovT2Q3N2dKTi8yT3FWb3NnMmFWV3JvUGJ2UGN0MnorYU1BMVVVOWdybHN0?=
 =?utf-8?B?cmE4RWEwSnVSTHo1RFVjamlUbGRZRDZwVzlaSHZla2o0THpheFBOeUZDZjFu?=
 =?utf-8?B?VzQvb3kwQjErVjV4NGMyK0haNE1RZmIzQ1BSaFBIUEI1SmVZWStZMVhKQ25l?=
 =?utf-8?B?bVEwM2RQWC9wbUJlNGpFcXZxUExVZ2hvZXZpQWRtY2hMWEZVUzk5NzIyUlgx?=
 =?utf-8?B?bXZ1bDZ0NTMvMlFuSHhzeG9FQnB5UUNFN1N5VnN3aVY3MmVUWUZtT1hXOHhN?=
 =?utf-8?B?M0RYRFZZdU9GYjAydncrbmwyVGU1dit3UlY3NDVIMlZlY2JwcHNRMTdndU1K?=
 =?utf-8?B?b2NmdC9ha05QQUxhSkNKRzFYcktka3hvY0pRcHhXVDlMV0dVTytnbVc2TkFQ?=
 =?utf-8?B?WFJaL003MVVKeFcrZ0RmMHVkcWVROFlTRHBkVk4vQXhwSnRLNmkzUVl4UjEr?=
 =?utf-8?B?aGlwbVBuei9rMFc1aDF6cHRrdEJiUUZFM0RsTkE5U1JKSFE4emFoK0ErNm4z?=
 =?utf-8?B?dGFiM2hjVVdqeHg4T2tMa09sQm1aSjEyTFJTVzFTMDdRVFNoYVB0dEhseUtB?=
 =?utf-8?B?bkE1dXZCcHNCdmVEb3lvY2ltT09MZ1FSN05HZlRySm9tbkFlY3VBNzZ6b1kz?=
 =?utf-8?B?bHFyUVNETmIxa0VNeVFacDhIRTZNT2M0VW1KZlpNYVBaSGpUdEx1TmNkWHRx?=
 =?utf-8?B?YkRjOWNhZmdHZFZROUJFYVBzdk9scEVxTHNZWXhXRjE0ZndKVFdFMFhSVlow?=
 =?utf-8?B?TEYrMmszZ0hOWG85dkFyblZ2SzdjQkhVUjd5VEZ2WXhnMVFLOXVzbzNNRjFt?=
 =?utf-8?B?ZjlXallSVis0em1hNFF5RGFNV1l5RVRHcVpHaFR2bHpSS2N1MFhhVHJ1ZXBi?=
 =?utf-8?B?Qi8zcTB3R2xCeitTNVFDeEl4MkhNTmJIc0dId3kvVWswVTR3ZDhmalBwdG9L?=
 =?utf-8?B?bXdsbzFGUzFVc05xWWhCTnV5M0xQK0xPdmxIWFlIR2hJRndPV3hHTFpzcVdz?=
 =?utf-8?B?Ym5Qek54T1FBU1RMZU9mZmxCYllaVXkvSndUdUFIY01HMFphMm5RUmoyQ1do?=
 =?utf-8?B?dEMwenBHNHVvczZDMEh6amQ4TDV5SVZGOTk2YndFTmtnbzNMVklPd3BxWWdn?=
 =?utf-8?Q?rH0TlTvwfaMObU9PZoBq0VRq0o0umL0T?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bceab047-6b91-422d-65b4-08da06e4865d
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5504.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2022 00:33:00.4654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CpZfn7nLrZSZsTZtOS7ScZDzl9LxBv1g6j2iUj27GfslNTNeFU3fgnsIQGaeqwKkqlLzxYfN/T7WgniguJgQlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0006
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/15/22 13:22, Eyal Birger wrote:
> Hi Roopa,
>
> On Tue, Mar 15, 2022 at 9:57 PM Roopa Prabhu <roopa@nvidia.com> wrote:
>>
>> On 3/15/22 11:56, Eyal Birger wrote:
>>> This patch adds support for encapsulating IPv4/IPv6 within GENEVE.
>>>
>>> In order use this, a new IFLA_GENEVE_TUN flag needs to be provided at
>>> device creation. This property cannot be changed for the time being.
>>>
>>> In case IP traffic is received on a non-tun device the drop count is
>>> increased.
>>>
>>> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
>>> ---
>>>    drivers/net/geneve.c         | 79 +++++++++++++++++++++++++++---------
>>>    include/uapi/linux/if_link.h |  1 +
>>>    2 files changed, 61 insertions(+), 19 deletions(-)
>>>
>>> diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
>>> index a895ff756093..37305ec26250 100644
>>> --- a/drivers/net/geneve.c
>>> +++ b/drivers/net/geneve.c
>>> @@ -56,6 +56,7 @@ struct geneve_config {
>>>        bool                    use_udp6_rx_checksums;
>>>        bool                    ttl_inherit;
>>>        enum ifla_geneve_df     df;
>>> +     bool                    tun;
>>>    };
>>>
>>>    /* Pseudo network device */
>>> @@ -251,17 +252,24 @@ static void geneve_rx(struct geneve_dev *geneve, struct geneve_sock *gs,
>>>                }
>>>        }
>>>
>>> -     skb_reset_mac_header(skb);
>>> -     skb->protocol = eth_type_trans(skb, geneve->dev);
>>> -     skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
>>> -
>>>        if (tun_dst)
>>>                skb_dst_set(skb, &tun_dst->dst);
>>>
>>> -     /* Ignore packet loops (and multicast echo) */
>>> -     if (ether_addr_equal(eth_hdr(skb)->h_source, geneve->dev->dev_addr)) {
>>> -             geneve->dev->stats.rx_errors++;
>>> -             goto drop;
>>> +     if (gnvh->proto_type == htons(ETH_P_TEB)) {
>>> +             skb_reset_mac_header(skb);
>>> +             skb->protocol = eth_type_trans(skb, geneve->dev);
>>> +             skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
>>> +
>>> +             /* Ignore packet loops (and multicast echo) */
>>> +             if (ether_addr_equal(eth_hdr(skb)->h_source,
>>> +                                  geneve->dev->dev_addr)) {
>>> +                     geneve->dev->stats.rx_errors++;
>>> +                     goto drop;
>>> +             }
>>> +     } else {
>>> +             skb_reset_mac_header(skb);
>>> +             skb->dev = geneve->dev;
>>> +             skb->pkt_type = PACKET_HOST;
>>>        }
>>>
>>>        oiph = skb_network_header(skb);
>>> @@ -345,6 +353,7 @@ static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
>>>        struct genevehdr *geneveh;
>>>        struct geneve_dev *geneve;
>>>        struct geneve_sock *gs;
>>> +     __be16 inner_proto;
>>>        int opts_len;
>>>
>>>        /* Need UDP and Geneve header to be present */
>>> @@ -356,8 +365,13 @@ static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
>>>        if (unlikely(geneveh->ver != GENEVE_VER))
>>>                goto drop;
>>>
>>> -     if (unlikely(geneveh->proto_type != htons(ETH_P_TEB)))
>>> +     inner_proto = geneveh->proto_type;
>>> +
>>> +     if (unlikely((inner_proto != htons(ETH_P_TEB) &&
>>> +                   inner_proto != htons(ETH_P_IP) &&
>>> +                   inner_proto != htons(ETH_P_IPV6)))) {
>>>                goto drop;
>>> +     }
>>>
>>
>> unnecessary braces
> Will fix.
>
>>>        gs = rcu_dereference_sk_user_data(sk);
>>>        if (!gs)
>>> @@ -367,9 +381,13 @@ static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
>>>        if (!geneve)
>>>                goto drop;
>>>
>>> +     if (unlikely((!geneve->cfg.tun && inner_proto != htons(ETH_P_TEB)))) {
>>> +             geneve->dev->stats.rx_dropped++;
>>> +             goto drop;
>>> +     }
>> Does this change current default behavior ?.
>>
>> its unclear to be what the current behavior is for a non ETH_P_TEB packet
> Currently non ETH_P_TEB packets are silently dropped.
> I figured that if the driver supported other ethertypes it would make
> sense to increase the count in such case, to assist in debugging wrong
> configurations.
>
> I can remove this if it's better to keep the current behavior.

yes, agree. counting is better.


>>
>>> +
>>>        opts_len = geneveh->opt_len * 4;
>>> -     if (iptunnel_pull_header(skb, GENEVE_BASE_HLEN + opts_len,
>>> -                              htons(ETH_P_TEB),
>>> +     if (iptunnel_pull_header(skb, GENEVE_BASE_HLEN + opts_len, inner_proto,
>>>                                 !net_eq(geneve->net, dev_net(geneve->dev)))) {
>>>                geneve->dev->stats.rx_dropped++;
>>>                goto drop;
>>> @@ -717,7 +735,8 @@ static int geneve_stop(struct net_device *dev)
>>>    }
>>>
>>>    static void geneve_build_header(struct genevehdr *geneveh,
>>> -                             const struct ip_tunnel_info *info)
>>> +                             const struct ip_tunnel_info *info,
>>> +                             __be16 inner_proto)
>>>    {
>>>        geneveh->ver = GENEVE_VER;
>>>        geneveh->opt_len = info->options_len / 4;
>>> @@ -725,7 +744,7 @@ static void geneve_build_header(struct genevehdr *geneveh,
>>>        geneveh->critical = !!(info->key.tun_flags & TUNNEL_CRIT_OPT);
>>>        geneveh->rsvd1 = 0;
>>>        tunnel_id_to_vni(info->key.tun_id, geneveh->vni);
>>> -     geneveh->proto_type = htons(ETH_P_TEB);
>>> +     geneveh->proto_type = inner_proto;
>>>        geneveh->rsvd2 = 0;
>>>
>>>        if (info->key.tun_flags & TUNNEL_GENEVE_OPT)
>>> @@ -734,8 +753,9 @@ static void geneve_build_header(struct genevehdr *geneveh,
>>>
>>>    static int geneve_build_skb(struct dst_entry *dst, struct sk_buff *skb,
>>>                            const struct ip_tunnel_info *info,
>>> -                         bool xnet, int ip_hdr_len)
>>> +                         bool xnet, int ip_hdr_len, bool tun)
>>>    {
>>> +     __be16 inner_proto = tun ? skb->protocol : htons(ETH_P_TEB);
>>>        bool udp_sum = !!(info->key.tun_flags & TUNNEL_CSUM);
>>>        struct genevehdr *gnvh;
>>>        int min_headroom;
>>> @@ -755,8 +775,8 @@ static int geneve_build_skb(struct dst_entry *dst, struct sk_buff *skb,
>>>                goto free_dst;
>>>
>>>        gnvh = __skb_push(skb, sizeof(*gnvh) + info->options_len);
>>> -     geneve_build_header(gnvh, info);
>>> -     skb_set_inner_protocol(skb, htons(ETH_P_TEB));
>>> +     geneve_build_header(gnvh, info, inner_proto);
>>> +     skb_set_inner_protocol(skb, inner_proto);
>>>        return 0;
>>>
>>>    free_dst:
>>> @@ -959,7 +979,8 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
>>>                }
>>>        }
>>>
>>> -     err = geneve_build_skb(&rt->dst, skb, info, xnet, sizeof(struct iphdr));
>>> +     err = geneve_build_skb(&rt->dst, skb, info, xnet, sizeof(struct iphdr),
>>> +                            geneve->cfg.tun);
>>>        if (unlikely(err))
>>>                return err;
>>>
>>> @@ -1038,7 +1059,8 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
>>>                        ttl = key->ttl;
>>>                ttl = ttl ? : ip6_dst_hoplimit(dst);
>>>        }
>>> -     err = geneve_build_skb(dst, skb, info, xnet, sizeof(struct ipv6hdr));
>>> +     err = geneve_build_skb(dst, skb, info, xnet, sizeof(struct ipv6hdr),
>>> +                            geneve->cfg.tun);
>>>        if (unlikely(err))
>>>                return err;
>>>
>>> @@ -1388,6 +1410,14 @@ static int geneve_configure(struct net *net, struct net_device *dev,
>>>        dst_cache_reset(&geneve->cfg.info.dst_cache);
>>>        memcpy(&geneve->cfg, cfg, sizeof(*cfg));
>>>
>>> +     if (geneve->cfg.tun) {
>>> +             dev->header_ops = NULL;
>>> +             dev->type = ARPHRD_NONE;
>>> +             dev->hard_header_len = 0;
>>> +             dev->addr_len = 0;
>>> +             dev->flags = IFF_NOARP;
>>> +     }
>>> +
>>>        err = register_netdevice(dev);
>>>        if (err)
>>>                return err;
>>> @@ -1561,10 +1591,18 @@ static int geneve_nl2info(struct nlattr *tb[], struct nlattr *data[],
>>>    #endif
>>>        }
>>>
>>> +     if (data[IFLA_GENEVE_TUN]) {
>>> +             if (changelink) {
>>> +                     attrtype = IFLA_GENEVE_TUN;
>>> +                     goto change_notsup;
>>> +             }
>>> +             cfg->tun = true;
>>> +     }
>>> +
>>>        return 0;
>>>    change_notsup:
>>>        NL_SET_ERR_MSG_ATTR(extack, data[attrtype],
>>> -                         "Changing VNI, Port, endpoint IP address family, external, and UDP checksum attributes are not supported");
>>> +                         "Changing VNI, Port, endpoint IP address family, external, tun, and UDP checksum attributes are not supported");
>>>        return -EOPNOTSUPP;
>>>    }
>>>
>>> @@ -1799,6 +1837,9 @@ static int geneve_fill_info(struct sk_buff *skb, const struct net_device *dev)
>>>        if (nla_put_u8(skb, IFLA_GENEVE_TTL_INHERIT, ttl_inherit))
>>>                goto nla_put_failure;
>>>
>>> +     if (geneve->cfg.tun && nla_put_flag(skb, IFLA_GENEVE_TUN))
>>> +             goto nla_put_failure;
>>> +
>>>        return 0;
>>>
>>>    nla_put_failure:
>>> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
>>> index bd24c7dc10a2..198aefa2c513 100644
>>> --- a/include/uapi/linux/if_link.h
>>> +++ b/include/uapi/linux/if_link.h
>>> @@ -842,6 +842,7 @@ enum {
>>>        IFLA_GENEVE_LABEL,
>>>        IFLA_GENEVE_TTL_INHERIT,
>>>        IFLA_GENEVE_DF,
>>> +     IFLA_GENEVE_TUN,
>> geneve is itself called a tunnel, i wonder if a different name for the
>> flag would be more appropriate.
> I tried to find a reference to something similar, so went with something like
> the tun vs. tap distinction. I was also concerned about the possible
> confusion, but it felt clearer than something like L3_INNER_PROTO_MODE.
>
> I'd happily replace it with a better suggestion.

o ok, makes sense. I can't think of anything other than simply 
IFLA_GENEVE_INNER_PROTO

(maybe others have better suggestions)


>
>> what is the use case for this ?. is there a RFC reference ?
> I stumbled upon this configuration when trying to receive packets from an
> AWS "Gateway Load Balancer" which sends IP packets encapsulated in GENEVE [1].
>
> But to my understanding the RFC allows this so it doesn't seem something
> specific to AWS.

that makes me wonder if we need a knob atall and if this should be 
allowed by default.

wonder how other network vendor standard geneve implementations behave 
by default.


>
> Thanks for the review!
>
> Eyal.
>
> [1] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Faws.amazon.com%2Fblogs%2Fnetworking-and-content-delivery%2Fintegrate-your-custom-logic-or-appliance-with-aws-gateway-load-balancer%2F&amp;data=04%7C01%7Croopa%40nvidia.com%7C223c13c616ef430a487f08da06c19610%7C43083d15727340c1b7db39efd9ccc17a%7C0%7C0%7C637829725767772379%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=ZQTDrFJ8LLn5SdN6h%2B5NECxwlD9PAGV2KzpVUV%2B1chc%3D&amp;reserved=0

Thanks for the details.


