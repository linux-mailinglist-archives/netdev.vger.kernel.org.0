Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9EAA697488
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 03:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbjBOCu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 21:50:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjBOCu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 21:50:28 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2051.outbound.protection.outlook.com [40.107.94.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFFE731E39;
        Tue, 14 Feb 2023 18:50:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ro9VYV89PpuO5VgOZy3WTnOXHzKH2qgt4qRMyACncRA+G6yOttH+JE4RyvjQknKQAJvmoi/kGoy+8x+iFmpdsnuBs4XZLDyR96TQKf+7c9gA8awIWwtJ8eADpVjbyJ1wNJUZQuobym3tn4iyobzBdLqtJxtlMFYB+t1wJImaX+/lVffaU6mgLytrVLWc6GqBXDwqec/GxL0n9YNWHR9PVEvMFdXRsgvyWt1+qt9QDh0rTeHBHbEoj7mhOq0QwfxAVLaTGUC7itKGF+siMY5nbDZVsZOWQCGl1ejsBIMiGzrv6E7J8EpVIOIE/G8XyPwRwbgJ7w0Cxl9I9eIwKmMmMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NeK7klew3OacU0uP5tTv6IFAiT9Ob2zX7fUvZ611ruc=;
 b=g0MX8uzjVyxTv/7TneSTngVBGKaE4DYXSZp3gvt3Lcv0Qqs/UfG3sSraRvp+QEF41EbX/JA2wxWDvqlJfBr0Yn5ksM3r35WLS6JEfAkd/ApYCOszMVb0wqf2drUcev6wPhxPPAFYNlvsCHf23qzbyEhArQ98y8ImXxwXN1781aUEBQaAQNHC+aEh/6KisC3r4YG/tmuAwZu4zOZe26l9x/Lc/bmkjRv2SfbL39TOFH/S1Bj5eH4KBm02EGZ763+O4GEDK7BYgMtOyuA6qVsI3LnXJOIWa58toaohvN05CxOsTHXpDytRZoYaPd5FUpgG2P+bkXIuJxdNWTKvYjlPjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NeK7klew3OacU0uP5tTv6IFAiT9Ob2zX7fUvZ611ruc=;
 b=n6LYGVHHb6LBThRfXbFUnhleKcyXkW0oHj4jT2tL02pYf85ewLH41P5UIIjXwsMxX2VqlVafBUkQsdQT60QhNx7DTt/GbwjNmrpovul/qFN7wSJq4+f7YnX9RosQyMFGDmGqJIHdxvZjGKDaTUf7I0QGWfCiA5nTLlcvngiELB5Yfy6slTZFKVaNLUHvCB0QaKmbcRhH6GY3fug1eReOZmWDftFb4yJ9Y/2S/rXOBrVh1e0xCKHzCNjPlIcsgQk9geg95yLNzHzm1d3+2TfwrxOfFxwtHyCSqumlv6hzbRp5lsUasRwO8sXzFRPaMe4S83+XDAwLBe+tFgLKwCTKZw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3840.namprd12.prod.outlook.com (2603:10b6:208:16f::23)
 by PH7PR12MB6489.namprd12.prod.outlook.com (2603:10b6:510:1f7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 02:50:24 +0000
Received: from MN2PR12MB3840.namprd12.prod.outlook.com
 ([fe80::169e:fc9f:20ca:265a]) by MN2PR12MB3840.namprd12.prod.outlook.com
 ([fe80::169e:fc9f:20ca:265a%6]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 02:50:24 +0000
Message-ID: <7537ee48-c92a-a7df-b876-9a14ce2d34c6@nvidia.com>
Date:   Wed, 15 Feb 2023 10:50:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH net-next v1 3/3] net/mlx5e: TC, Add support for VxLAN GBP
 encap/decap flows offload
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
Content-Language: en-US
From:   Gavin Li <gavinl@nvidia.com>
In-Reply-To: <711630a2-b810-f8b0-2dcf-1eb7056ecf1d@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGBP274CA0019.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::31)
 To MN2PR12MB3840.namprd12.prod.outlook.com (2603:10b6:208:16f::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3840:EE_|PH7PR12MB6489:EE_
X-MS-Office365-Filtering-Correlation-Id: 454809a3-619c-45ef-6b77-08db0eff6256
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8p+Z20N/Zk++/ufe3KBye2k1al9bDns1pFRRLEjM2MqnPu21TGgoFcV3VsCitVQPAtRKtewqEvjiiJagcicr0xxtShoWqIdvZe3TK6j0VzZk0hSveww/sdO1DLxC2TYtZxH+EP4KxmEikmVm1c4/8p1JpagoBrgrpUFBx7i85ZKT/UsGDKuykNYBdfDKONfTinqj14srE2ARmyn/2Xadq/+qjeuejGeNii+35PSpaXNTaGe5VVC3KLGpcYJgGfKaI98o1AOa/WCmtrPR6KX+XbDqqiWKACYJLwXqbcq+VaXAEaCz4w/2iOgbU/8cOxAdg03aN2kpWwYAyQ8xIW6H0yau8C1mXRjNstqF7829ZEX2Fp9+eKz6Cs4BI+qJ8HpVQyotfqBqtDu88NTGM4b1IP+s/sQ9SHphlewZJGzKyTTE3znpoFjXvyvLIsA94YaUt+LR2Sjb9Yb0b1/z5PNlvutZp17mrewPpmXfCpFtF7A0leRfhFoXHTlF5zXq45L5LJbok0vTNn9U1yY/9WhkWD5y7rSMzC6h8HxKSX3bhQYzfLi9dIxHS7rX7jgfbU+LaUlcaNWhC1zzso4BJaksGI3sOJsfpsUbWY1IOjDvXJUZzpOBvdBbI/HYqaH/GysMWVjPKmX8uWBkecSOR/db1NK+reWPNRTdMusVoRiTESmexH00/j08xRL86JCAQON/+W1ctbKqT1iF2dkmPfXssm4ZuHW0q2fzoV2/WD3DRbg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3840.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(396003)(346002)(136003)(39860400002)(376002)(451199018)(26005)(186003)(6506007)(6512007)(53546011)(2616005)(66946007)(4326008)(41300700001)(66476007)(8676002)(86362001)(66556008)(6916009)(31696002)(5660300002)(8936002)(2906002)(38100700002)(478600001)(6486002)(107886003)(6666004)(36756003)(83380400001)(316002)(54906003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZGNGQ1BTc2pBczVkNGdmWG1mSlNUZmFkQ09uMVY4N1lXWnBiY1NqUHc5alhX?=
 =?utf-8?B?SER4SENpZFh5ZkpKNURMcU9QM1EyMlRYZ2M4S0ZpQ05IYkYzbThXWDV5MUpy?=
 =?utf-8?B?QTlRVTZZRWFMMElBb2UySzZTN2d6MmJOdHFtalQ1Zm9XeU01UDRhcFZmUW8x?=
 =?utf-8?B?K2lwTWNwUys3U3NTRUFIRnZDSFl3VWJlN3VFajd5bGFSTnRMOWhNL1g2M1Nx?=
 =?utf-8?B?a1hOYVI1aGJJRGdFZGt2aTNtcTRtc1U0ckQ4NTE1WFhnWSthWTA1TXE2clln?=
 =?utf-8?B?cWxFOGc2V2VUZEpDbmdHbnQweW9HWjRkR2xJYnZQZFNmRk9GVmtZeFNMSHFP?=
 =?utf-8?B?TmluRWR2d1pmVmVNc3F1SWVjVzE1OEY5WCt2dXJGUlQreFVmMW9sSnNDaVE5?=
 =?utf-8?B?QSt6UThaTG05SW1hdU15aHZDTzVCcm9kVTFISnh5Qktwb1JITTFZanZEUzMz?=
 =?utf-8?B?T25SYU5FOEdGQVpXWDdRQTlnUjBpQ1U5eDVMcFk1emRkT1J4UVdJNUhQTGgz?=
 =?utf-8?B?OGZuOGFja2liRDBMYWFTenBuWitrcTlNVlBEMEMzQnRyL1JuQkVneEJEMmZC?=
 =?utf-8?B?T3hXM2ltQmVHUXQ5S1VYWU5mWlJzNVV6M2Rkd0Q0RllvRHhieTNmTjRNOEN0?=
 =?utf-8?B?aUIrSWdtbk03L0tJaC9hRUdMb00wM29rTXhEblU2Tk4xeUVxV1NHb01NMG5X?=
 =?utf-8?B?M0dWSUVpSE9QRWNKQW9uTzJuYXA3bGpLbmdoSUhRaytuOFBpc3E4YnJ1YWUr?=
 =?utf-8?B?TTdudHM3bFNmRW1BWG4rZk9kWUdVUFVUSGc3MTc3WTRUdHVTV1NCMnorQTAz?=
 =?utf-8?B?K25XMDdlcExYUFgrOXVTazREcmFHc3RPeDlRNU1JQ3U2d1gzUXZST05wQW5N?=
 =?utf-8?B?WDArODBMZmZzK093TWhEWkdDR0JGZHk0YzVpTWlrK2dWb2pNSUUzVVhkVlZK?=
 =?utf-8?B?aFQ4eXV0VHBkb0E2eEVlazVhMDBPcGtFTjlZcnBQSDVXeEFNemJuVHpzNzlR?=
 =?utf-8?B?WlU3OWp3UHh5Y0RqNG5ETGlsUThHL0EwcXhhYUYzeWFWaXJseWhIaWF2SDJr?=
 =?utf-8?B?cTY0MmJabTQwR2o2ZWZsMXF2VExaRDAwbmlnc3NVM3lMNndyczlwS2gvcG9a?=
 =?utf-8?B?TTFCUm9WRnp4ckxZbGIzemtLamhnQnpXNTY1V1pKd2RrM0JFVldzck9NWnlI?=
 =?utf-8?B?WlN6am8xYmxnVWZnSC96UUxNOGg1d0VzRytVNzBXckF4N2VCVlB3SEQyQ2Ni?=
 =?utf-8?B?VUlZeXBLTkNRWVpQSTkyQzU0QUFwa1FpTXRRMmtidDlML0U0MlAwSEljMVhh?=
 =?utf-8?B?UTMrS2xlVFFZV1ZnVlAzdDFXVm1BMlFvckVTbDdIRkZXbm5Ga21DaFdYS1RZ?=
 =?utf-8?B?V0pOcFNWUWkwem52N0pyYkM2Q2ZIMkV4SWxITmx5c2hrdUlqSUoyL05INVp2?=
 =?utf-8?B?STZiUk80RllSSzgzT0ppZlJHTVdwSm9xMno0K0NvYkdMNXRMSFdxa0g4TFp0?=
 =?utf-8?B?M2N3bCtpRThHb1VxcHRJeWx4TEJwV2haNGVKT2ZmMFV0NkRUSnFrdUFsNjhE?=
 =?utf-8?B?bS9zdmJLS0kydVVNeHFKaVJRN2hVZjFVVTFLRWkxdHRPK2hZejF4Y3dPczR4?=
 =?utf-8?B?dWR4M1RYbmlvZCtVLy9Ea1NVT1gxZnFBb2pVeEJFdTRBS053NHQ1RFVHRC9L?=
 =?utf-8?B?dzJ6eG1Wc1NabHlEKzFxWVBIZVorTENvbUhzeUhjYVNwSGNQdEEveWpLcE9J?=
 =?utf-8?B?U3c2UmpIZjFFSnhVL0Rmc3FnOGRxOWFQb0dUYUsyT1dtN0I2Y2VoQ3J6RlVi?=
 =?utf-8?B?TEZvUnhnano1dU5tMlF3OXdyQk1ENlBzeU1Va0JUeEdVUUx4Zi9scmFIRkta?=
 =?utf-8?B?Q2loRUY0dkY0b203NW5RSkF4a1ZxWlI4amduUmFOVmJRckxXN01HaXZXVTFQ?=
 =?utf-8?B?SDB0cXllSWZ3VVpIWDg3UEJpSjBQSG5nOSt4a1g3QXZlb011QmNpQUVtZ3I3?=
 =?utf-8?B?eWRGbm5YNnQwTm5HbDRXZzZPUEhEbjkwNmJPZWtHdmsyeEZFZFpUTklhY202?=
 =?utf-8?B?NmFCempaTyswTi92dnJ2Wm45cjRpYXNVV2NFdG82T3BTWGxIVXlSTFRaQ3Vw?=
 =?utf-8?Q?xv7k=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 454809a3-619c-45ef-6b77-08db0eff6256
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3840.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 02:50:23.6087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Mm/FAf0WEm0GjbkOKg+VkJHH7luecmSG6qVeL50jpboLM3ZwgKrBahFqxyFNsEowFD8OY7cZb1oUnD2pVfrtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6489
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
ACK
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
The reason to cast it is a WA to use ip_tunnel_info_opts which takes 
non-const arg while

e->tun_info here is a const one.

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
ACK
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
ACK
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
