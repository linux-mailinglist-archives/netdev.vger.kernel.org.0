Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0C26974F3
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 04:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232832AbjBODgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 22:36:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjBODgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 22:36:42 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2052.outbound.protection.outlook.com [40.107.93.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6692FE06A;
        Tue, 14 Feb 2023 19:36:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ck6kl4b5PgTN24Cq4SX0jmGyqs0QcSzC3HOhQqFD8miwlUoroShclqNtKNguICi48htkNwWJZK3l13l2u5YryxZLGYGZx4DOUlg12IEwa26f1RPgwuPR4tKjbc840mZQBNnaK/gqugHh0J9xK+QLoJtN9akTisoAz2/kM9tmHvVzYI6RWcnpHP+S+4n8c0RgNXXV9fS1bjQSEnDQPBFe3Zcohcks1ceWCTIzAm4ZvRD2tNu2MAs5dn4XhWFNOQjB93JaedFc+8gpUtegGO9eNKn5XFvEwyyXqe3m5YYSjIESv7U549LZ4eY7mOyYWbfkLcLLX7i/8BxepQQadXeyqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xd09vR7Pi4VFZ5VCu9sMWBV7ZUnwEo7FZJIA5tAnQb0=;
 b=eDtHvuX0IZ1atJIdXxzthUumUnsyZkQEJw8OZPFkc+L9sf/1F52SdwJSHGV3dxEdlAnZ0u9Tov8wO3Gp+kIg/F5nRFCGu7CRzsy8WpGT6zw/KowWndmqknNp9BnbzYffYkvYNJqfOtHidksa/71kWCtmQ8Lc2MPfOGawCmqLfz8IHMx+8dlb4vXHhpFMsHjEJ2O7XVeTdoTPHCk36yDyKflWMTbGde8srGe9R8mXX4x5eCKwbKGtjW+PUb6V6FvAeWSv6iM90lmdmAWt9idZqIrTHkmNxXcVGZys4XmodvZ7AWtSiGwQlNTousWAp6o07SGOuSSvWX6hPw/AebzYGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xd09vR7Pi4VFZ5VCu9sMWBV7ZUnwEo7FZJIA5tAnQb0=;
 b=praW5YfA10guqUAGJ4rPxWOvhOU3zkqQMuIDK4HOVWjSzd13tyPKTw/33SlvXppg5j4vuexc6SlYKy/alUE9UXAYk8pEb+UaVLBfjfrGEBcK5jZIydX4gdShTT61tqPrlk54lWwp/4yY1OC7O0aEQthXIcaKfAkGJvdd6AAmYUU5lQDfys2b7ssvoeHEebI2VHHhlBY5jOY7ErapTK0aJZg41+OP5a8LoV8ZF5+WFgDnPBm5G6Wp3XCVfP1ROqLCRP1MKREuCh+wQzaRVoq8I+JFk2A1kMgtJuk0qCASofdqt3v3DrSzO2VjuvvGPGDhmnpkTo/NSagwS53VezQR2w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3840.namprd12.prod.outlook.com (2603:10b6:208:16f::23)
 by SA0PR12MB7089.namprd12.prod.outlook.com (2603:10b6:806:2d5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Wed, 15 Feb
 2023 03:36:39 +0000
Received: from MN2PR12MB3840.namprd12.prod.outlook.com
 ([fe80::169e:fc9f:20ca:265a]) by MN2PR12MB3840.namprd12.prod.outlook.com
 ([fe80::169e:fc9f:20ca:265a%6]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 03:36:39 +0000
Message-ID: <231a227d-dda6-fe15-e39a-68aee72a1d59@nvidia.com>
Date:   Wed, 15 Feb 2023 11:36:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH net-next v1 3/3] net/mlx5e: TC, Add support for VxLAN GBP
 encap/decap flows offload
Content-Language: en-US
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, roopa@nvidia.com,
        eng.alaamohamedsoliman.am@gmail.com, bigeasy@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roi Dayan <roid@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20230214134137.225999-1-gavinl@nvidia.com>
 <20230214134137.225999-4-gavinl@nvidia.com>
 <711630a2-b810-f8b0-2dcf-1eb7056ecf1d@intel.com>
From:   Gavin Li <gavinl@nvidia.com>
In-Reply-To: <711630a2-b810-f8b0-2dcf-1eb7056ecf1d@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0006.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::14) To MN2PR12MB3840.namprd12.prod.outlook.com
 (2603:10b6:208:16f::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3840:EE_|SA0PR12MB7089:EE_
X-MS-Office365-Filtering-Correlation-Id: c3e0a74f-0e95-4d85-56c9-08db0f05d876
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ERVQ3i47OLS84ZcPtVF3g2lngcJg64UuF8WQd2EVn78L1rG4hhhMh78NruB5w6vo0kVQzTn7bLkKEdAxJ/bXF1gwTls+NiUUq9j0XRbguri/pU7fbBQsSoASwL2hDbqTNGKnGPXG81afSmmbay/rKkqhSGxFq882mtZWPCUqBCJ5KKgsTemyibzjNngJiFLhwZQPekIbnfQmWL02aEyOiGyyT5twvz0jJT1KVpSXWuMFM3kPzl7/lwHuyOB/Kex5ex1wEsNo/5FSPWw1Omtp1rb/TOCecqykpQJ6ycFDaQ3TduPqTcS6HhaKPSVk7QvJuI9ajymFoHRl8RX6S/8DQ/Zdbbqj3YHgrha1mpjqJkrRwounZA62mdKn1aPc8fjHl8hb/yEnnzHeJZxGvQvFYWLDvoq+sKj6sn/2CTKzr/0TY94ALDeeifwyT102bl/giZ6Od+AKxpFFbs+BDaTjqe7ly8V1Ky+Hk85Vs45jWpA6kCmaVOiPgmhN56NzYdWIeUu9nVat45StcNHxF0IjZN5JGNwu6uUQQ8FEXMMvkoysn0e3pMhiS/zlBtkRkw3Q1MT9huKcIf4RcN7iAfSVgniRNTYNL3gWTnTznT3bXL3H2Pyf86cogbnRe280JUf6rk/glQCK0LpM0kHDJZMJuwl3hMLjha1aTby/HsZdljKAHC8zOEsoYgZmd57kBbbWWWzsTRFlo4p0W12RzUXFKty+7ddZgdIUQiZyug8h+vQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3840.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(366004)(39860400002)(346002)(136003)(451199018)(8936002)(31686004)(2906002)(5660300002)(66476007)(66556008)(4326008)(66946007)(8676002)(6916009)(41300700001)(316002)(54906003)(478600001)(36756003)(6666004)(107886003)(6486002)(2616005)(6506007)(186003)(26005)(53546011)(6512007)(86362001)(83380400001)(31696002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MmFWaUpja3RSNjNLRDZBN3BoZlVYK1g5V25UbjFUMFFaYlNicC9iYndVU0d4?=
 =?utf-8?B?NFpjN1hmZXQvZVVkWWx5bW40S050NS9tTEI2Rmg1MW53Z093NWtRb2wwRWNu?=
 =?utf-8?B?NWZBcUJUQ0RBUlVReWlXWDRVVHVuY3BFazRvNkxya2VtQlhtSzFySTZwOGIw?=
 =?utf-8?B?NFdiSkVoTjJQZXMyckN3Y0ViQnZKQW1ZY0t1b3lqMEVvUllGM0NXbzNINFdv?=
 =?utf-8?B?azFIRUhNUENveGcwRFNPNEplRXBGNEsrTjBjYkZwN1N3b3VzVEVRdWo1MFVN?=
 =?utf-8?B?V05rMG4yckpvWTBhNEdBbmRvbUZCZURqek5Kam9HK09oc3JwTVNIUmNCcXRs?=
 =?utf-8?B?M1l2eThvOC9kY2NHTlRiRFdNdWlXeVlXQjFkbERkSzYxUFdOU3NNZ0hKekwz?=
 =?utf-8?B?Y3N3OXlnRjBrREcyZTFnMDJmb0c1SE01WTJQSE1kTDhMeEl4R1ZqaWZ5NUlh?=
 =?utf-8?B?Z0tLLzJYb3ZCL3JGWXVsMTRaQisybW9yTWNUSDJNZ0xrSXlpUVBydTUwaEdX?=
 =?utf-8?B?NzBmYlJVelJwZ2lyWGNCUWxNT0srQ3BWMXhjeVVHYTQ1SEFaanJ0MzZaUTI0?=
 =?utf-8?B?aTdLTWdPTmk3RjRDWVRKaWkyWm1RTlg5SWhhYzVSL0ZsWlJYOUUrbkt1N0Ni?=
 =?utf-8?B?eE1TUkh0ZU1RZEhEZXBRQVZzb28rVll1QktrNThTdW5uVlBmblJtbDRDRmxn?=
 =?utf-8?B?RjFVZnNDRy9GMCs3SlZTTzREcEo1RVp1T1h6SkdXalZOdFZodER4MHlvbzNk?=
 =?utf-8?B?azZvVDFheFZtTExUSi9pWnM5Y0RZT0N6QzhpUnpZQ3orZktKanZwd0oyZ1A2?=
 =?utf-8?B?WFVET2VpOFdrL3ZYdmNsMXR3dlUybUl4dzlwdFNtd3pVSjNSZk51QzFpR0Zv?=
 =?utf-8?B?V1FiNUd4cE5WcXRJQ24yRjArSjVOMU5YODFJeVU5OGt6V2VHQ2Q1MHVIMDFI?=
 =?utf-8?B?QnFXUDZoa0x3N2dEN3MxTi9RVldlQVZ2MXpjdlR1eThEN3NwRzh1Um9ZWVVQ?=
 =?utf-8?B?Wit0R010OTVzYTZFaklQYytxczQ1bjJBdlNnNVIvQUxkZUpJcmt3NUZJNFpJ?=
 =?utf-8?B?QUNpcGRuRnVGWG0wZnRoUUxUbUdYRG1sUHhBMnVUSTNqTW5waUUwLy81OFhm?=
 =?utf-8?B?V0F1YkZCWXBsSXJRV09BTzUxYnJZUXV0S3lNQ296L0VyUHkxcXgrZWVPVTJG?=
 =?utf-8?B?SWpjaTdyRFlCL1FpV3FqbjZWN24xNXgyU1ZGMnZLRmtGK2trakJleE9yaktU?=
 =?utf-8?B?ZVRxTkdhZW1jV2dETHM0bmFxUUFsd0tOd1hQSkRYaS9jTjNNcXVvd0tTUVpx?=
 =?utf-8?B?YW1TcWRJcE9DNHo4MWYwZy9IWVBCTDhxS3BGV2VYUERFU281ZjNVVFhyLy9h?=
 =?utf-8?B?dGFJZytYQ2QwOFZ6V1Jab3RXZXJXcGFPd3V3WFlZNzIzcDdRUFNVWUhnNFJj?=
 =?utf-8?B?ZkRVeEEwUEZzRldzNGUyMmVIR1Jscjk3MS8ySlNoYUZGOWg3NGIxcGltVytT?=
 =?utf-8?B?Rkg2U0dWRkRkWGEyTHNOcVAzN2NYS2l6UmF1T3A5aldXTjVVc01xYU9vbE9P?=
 =?utf-8?B?K091SWYxdFQ0NXJ4dHB4dnhvRFpBZUdodVNkVXRocjVJTElKYVlnQ0F3c0FN?=
 =?utf-8?B?UUU5b21FSGtQcC95alBjS0ZYNkZTbTQ1Ync0Q2Z4Y3MwK1NNbVI5ejdQZFdC?=
 =?utf-8?B?N05GalduamYwR1NPZEhOTllVMEx0VXdwQnluYkk3VWppL1hBL2FIUERldERx?=
 =?utf-8?B?Vk5aNkdaTVZmVytYYWpyNlplYTR2WVY2Ym95cFZ2TFphTy9HamRlYWpGTXBG?=
 =?utf-8?B?eUFlcloxU1ZucFRDcFErMXJKTEpLWFNHdGJiRnM4Q1VEWEgyRmpJNE1ZUFlX?=
 =?utf-8?B?VFJQU2h5L3NJazdFV0M4UFZPYnBHeGdaWHRLQmxvcTczWEJTMUtXeEtiZGMz?=
 =?utf-8?B?SzZpM1ZiNDNRRVBvUUFYbXBlTHUwZDQwY3ZCeHJ2aXQ1SStJQkNmdWFBejAz?=
 =?utf-8?B?VG14SUNpYlhVU2h6eHBqZ0tNaDEvRHptaGZQbnlEVU13My8vYVUrT1pCNGZO?=
 =?utf-8?B?NitpUzlQSTBSdkVDUlAveDRHWithRXlRK1Jwb2NYbU8rWlJsRjRHYVh3MUFt?=
 =?utf-8?Q?jANh6Gf0GHFCelAF+Q8B6ltyj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3e0a74f-0e95-4d85-56c9-08db0f05d876
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3840.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 03:36:38.8006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yV2u+Xsz7nkpkl+b9kJkuTiIMCwI6d7/wYjLgzJ45SRvFnvFxGeFrBj6zGmNDJMXqyskQm+1mMqIWuByiDO/iA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7089
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/14/2023 11:26 PM, Alexander Lobakin wrote:
> External email: Use caution opening links or attachments
>
>
> From: Gavin Li <gavinl@nvidia.com>
> Date: Tue, 14 Feb 2023 15:41:37 +0200
>
>> Add HW offloading support for TC flows with VxLAN GBP encap/decap.
>>
>> Example of encap rule:
>> tc filter add dev eth0 protocol ip ingress flower \
>>      action tunnel_key set id 42 vxlan_opts 512 \
>>      action mirred egress redirect dev vxlan1
>>
>> Example of decap rule:
>> tc filter add dev vxlan1 protocol ip ingress flower \
>>      enc_key_id 42 enc_dst_port 4789 vxlan_opts 1024 \
>>      action tunnel_key unset action mirred egress redirect dev eth0
>>
>> Change-Id: I48f61d02201bf3f79dcbe5d0f022f7bb27ed630f
>> Signed-off-by: Gavin Li <gavinl@nvidia.com>
>> Reviewed-by: Roi Dayan <roid@nvidia.com>
>> Reviewed-by: Maor Dickman <maord@nvidia.com>
>> Acked-by: Saeed Mahameed <saeedm@nvidia.com>
>> ---
>>   .../mellanox/mlx5/core/en/tc_tun_vxlan.c      | 85 ++++++++++++++++++-
>>   include/linux/mlx5/device.h                   |  6 ++
>>   include/linux/mlx5/mlx5_ifc.h                 | 13 ++-
>>   3 files changed, 100 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
>> index 1f62c702b625..444512ca9e0d 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
>> @@ -1,6 +1,7 @@
>>   // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
>>   /* Copyright (c) 2018 Mellanox Technologies. */
>>
>> +#include <net/ip_tunnels.h>
>>   #include <net/vxlan.h>
>>   #include "lib/vxlan.h"
>>   #include "en/tc_tun.h"
>> @@ -86,9 +87,11 @@ static int mlx5e_gen_ip_tunnel_header_vxlan(char buf[],
>>        const struct ip_tunnel_key *tun_key = &e->tun_info->key;
>>        __be32 tun_id = tunnel_id_to_key32(tun_key->tun_id);
>>        struct udphdr *udp = (struct udphdr *)(buf);
>> +     const struct vxlan_metadata *md;
>>        struct vxlanhdr *vxh;
>>
>> -     if (tun_key->tun_flags & TUNNEL_VXLAN_OPT)
>> +     if (tun_key->tun_flags & TUNNEL_VXLAN_OPT &&
> A separate pair of braces is preferred around bitops.
>
>> +         e->tun_info->options_len != sizeof(*md))
>>                return -EOPNOTSUPP;
>>        vxh = (struct vxlanhdr *)((char *)udp + sizeof(struct udphdr));
>>        *ip_proto = IPPROTO_UDP;
>> @@ -96,6 +99,70 @@ static int mlx5e_gen_ip_tunnel_header_vxlan(char buf[],
>>        udp->dest = tun_key->tp_dst;
>>        vxh->vx_flags = VXLAN_HF_VNI;
>>        vxh->vx_vni = vxlan_vni_field(tun_id);
>> +     if (tun_key->tun_flags & TUNNEL_VXLAN_OPT) {
>> +             md = ip_tunnel_info_opts((struct ip_tunnel_info *)e->tun_info);
>> +             vxlan_build_gbp_hdr(vxh, tun_key->tun_flags,
>> +                                 (struct vxlan_metadata *)md);
> Maybe constify both ip_tunnel_info_opts() and vxlan_build_gbp_hdr()
> arguments instead of working around by casting away?
ACK. Sorry for the confusion---I misunderstood the comment.
>
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static int mlx5e_tc_tun_parse_vxlan_gbp_option(struct mlx5e_priv *priv,
>> +                                            struct mlx5_flow_spec *spec,
>> +                                            struct flow_cls_offload *f)
>> +{
>> +     struct flow_rule *rule = flow_cls_offload_flow_rule(f);
>> +     struct netlink_ext_ack *extack = f->common.extack;
>> +     struct flow_match_enc_opts enc_opts;
>> +     void *misc5_c, *misc5_v;
>> +     u32 *gbp, *gbp_mask;
>> +
>> +     flow_rule_match_enc_opts(rule, &enc_opts);
>> +
>> +     if (memchr_inv(&enc_opts.mask->data, 0, sizeof(enc_opts.mask->data)) &&
>> +         !MLX5_CAP_ESW_FT_FIELD_SUPPORT_2(priv->mdev, tunnel_header_0_1)) {
>> +             NL_SET_ERR_MSG_MOD(extack,
>> +                                "Matching on VxLAN GBP is not supported");
>> +             netdev_warn(priv->netdev,
>> +                         "Matching on VxLAN GBP is not supported\n");
>> +             return -EOPNOTSUPP;
>> +     }
>> +
>> +     if (enc_opts.key->dst_opt_type != TUNNEL_VXLAN_OPT) {
>> +             NL_SET_ERR_MSG_MOD(extack,
>> +                                "Wrong VxLAN option type: not GBP");
> Fits into one line I believe.
>
>> +             netdev_warn(priv->netdev,
>> +                         "Wrong VxLAN option type: not GBP\n");
>> +             return -EOPNOTSUPP;
>> +     }
>> +
>> +     if (enc_opts.key->len != sizeof(*gbp) ||
>> +         enc_opts.mask->len != sizeof(*gbp_mask)) {
>> +             NL_SET_ERR_MSG_MOD(extack,
>> +                                "VxLAN GBP option/mask len is not 32 bits");
>> +             netdev_warn(priv->netdev,
>> +                         "VxLAN GBP option/mask len is not 32 bits\n");
>> +             return -EINVAL;
>> +     }
>> +
>> +     gbp = (u32 *)&enc_opts.key->data[0];
>> +     gbp_mask = (u32 *)&enc_opts.mask->data[0];
>> +
>> +     if (*gbp_mask & ~VXLAN_GBP_MASK) {
>> +             NL_SET_ERR_MSG_MOD(extack,
>> +                                "Wrong VxLAN GBP mask");
> You can use new NL_SET_ERR_MSG_FMT_MOD() here to print @gbp_mask to the
> user, as you do it next line.
>
>> +             netdev_warn(priv->netdev,
>> +                         "Wrong VxLAN GBP mask(0x%08X)\n", *gbp_mask);
>> +             return -EINVAL;
>> +     }
>> +
>> +     misc5_c = MLX5_ADDR_OF(fte_match_param, spec->match_criteria, misc_parameters_5);
>> +     misc5_v = MLX5_ADDR_OF(fte_match_param, spec->match_value, misc_parameters_5);
>> +     MLX5_SET(fte_match_set_misc5, misc5_c, tunnel_header_0, *gbp_mask);
>> +     MLX5_SET(fte_match_set_misc5, misc5_v, tunnel_header_0, *gbp);
>> +
>> +     spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_5;
>>
>>        return 0;
>>   }
> Thanks,
> Olek
