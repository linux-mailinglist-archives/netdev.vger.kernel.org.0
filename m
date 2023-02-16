Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C27B698EE5
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 09:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjBPIky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 03:40:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbjBPIkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 03:40:52 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2052.outbound.protection.outlook.com [40.107.220.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69FC330DB;
        Thu, 16 Feb 2023 00:40:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SWFOtjJPU+klyvzl8LIVDJZq+a7WJrETxf257+PsEbM8/8nYqmZ0wW5E/JjqL3XrQDGrScjwgRTleldzahOUctZ4EGlho55OKPlSRLw0nO6nCzfKEXRAYuQguXvXlD014HQJy1xife++ZOKn7UxZGAwRaBO5uFuJEUXzmlVr8vslscKbhiupVUTunTnGFL8cDeSy4H4KzQ542fFHOZBKAOEOFdnpzgoumEFqKamWOH9khy/ngAP8LVIcoIV//SDpIeEPunHLbyDHfm42eLCfto04Ohz223W+N9dKm+oKB+wS3wzFPh63ABB5dHU0FoxLQquYrQ3XFqmwLg3HIvAKZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XAQwqNog32HqqGHIyfvBcFASflZUl26v+V3Ne90UTEo=;
 b=bwliZvoR680wvuR+X1g6LoLMDcdmUJ1KAQXovEFIteEH43cXI5za3i9eVHGURrcprKj8Zar6hJ/C2dz2W48T1H24LY4QaOJEVPX9pvpxdr9x8hjUWPlIt9c1fq8GeKBJABojAgoJieROgEQ82CS2lOQCi4FJTQwJrhvWKhLlaeMG1z9etEVf6i/PvhpJiB2tAF7bXThnIr1CQLrMgZzCX1vDAU27eig6NuXBkOCnY6tgjY4RFaGRbfsLEi9zoaOUOQ0p6l/pAOsoNDmbYCDemtQLlr7XYD6UduC0HOKJOn3yMBprT/p+JEXd0NyY6UjrMzk864f2Hs/ESqoZ1OUeCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XAQwqNog32HqqGHIyfvBcFASflZUl26v+V3Ne90UTEo=;
 b=WlvCqXMJEDwynhxfCHY88/R8JkPue+kfASUYH28zIg5m98/fAeyLt9K5iKoQwJQy7GMbIx9O5kxcEtWznmL2n8tbPTw8ypTYSojfBqVwUKTJR0uf+R7546LEjcQ9RGkies0f2FJgg/PsyE6ReG34dVpy/8SZ32qRhxyk1JLOpfplmUEqOOVmFmb8IHr4POoaw9vMC1jYARP5yxDKQNN01D/WqQv0AKtkmKheS/ktUAw6bGTJYpGCA+u8c7O1FkB2Uy7xWrYD5I6onOUFidYn2iQPG/01esFR6I5Uf7AZcOFgZF/VRunFWmIIc1CRNUzhvru+YtpC20IdVfKNfFbi+w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3835.namprd12.prod.outlook.com (2603:10b6:5:1c7::12)
 by DS0PR12MB8245.namprd12.prod.outlook.com (2603:10b6:8:f2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 08:40:49 +0000
Received: from DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::4963:ee4e:40e9:8a0b]) by DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::4963:ee4e:40e9:8a0b%4]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 08:40:49 +0000
Message-ID: <76b74086-ea65-7bb3-1eb0-391f79d1c615@nvidia.com>
Date:   Thu, 16 Feb 2023 16:40:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH net-next v1 3/3] net/mlx5e: TC, Add support for VxLAN GBP
 encap/decap flows offload
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, roopa@nvidia.com,
        eng.alaamohamedsoliman.am@gmail.com, bigeasy@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roi Dayan <roid@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20230214134137.225999-1-gavinl@nvidia.com>
 <20230214134137.225999-4-gavinl@nvidia.com>
 <711630a2-b810-f8b0-2dcf-1eb7056ecf1d@intel.com>
 <231a227d-dda6-fe15-e39a-68aee72a1d59@nvidia.com>
 <92d83584-2238-f8e8-3ed6-f292223e4061@nvidia.com>
 <dcc5578e-89d1-589f-3175-eb8bcd58f7ec@intel.com>
Content-Language: en-US
From:   Gavin Li <gavinl@nvidia.com>
In-Reply-To: <dcc5578e-89d1-589f-3175-eb8bcd58f7ec@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KL1P15301CA0055.APCP153.PROD.OUTLOOK.COM
 (2603:1096:820:3d::11) To DM6PR12MB3835.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3835:EE_|DS0PR12MB8245:EE_
X-MS-Office365-Filtering-Correlation-Id: 7abd5f2c-133d-4aaa-13a9-08db0ff980c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tSWCCJJ1+I8nEgoT49qVdllk3cLDkNT9msbZsg2SjKYpnW54cODN3CPutFrJEZ6UDV2OI/5/AlS29LeVZzWpi6ysCULWYmZiQY7cdukOXGA+4ywhuAFwsa7JmLwkbEcJktSVd0jtr9jBkhR7DI0hw/h82G7QpEBhLFpBbukrzfxTt1ZoK+NWnAZqk7EzPOyw+Zpaxi67LWYOAoC4WtTxMJuVee6ozuDDG9Q9aGTHQbsXKRti2UY+33duiiBWs1Wp8pP5PBs4KT/rJlC9i7OU233HeTUyLHxAJuBQja5lWrwMnfybRvFeBvZVKt2f4I5mGr2RwwAel2IhiGg8n0eoq4OUgxgWTTFCI1MIaN/8J74zdRB7G+1ebpTuNKzs8UX8gKLAdI+EVKrD10mqbC9pFYS0T/xPjaoSxV4eQcaIypMqTUs7vbJ9ixghCh0AWLmChFP8n+ehPG+7PQE2Y60TPgzki0GzXhUbUpBeHMr2ICjPLIAXyCgApXcKy2mQgC96obhyOmZqA+qGqYY0r2mxcXthNbxbLzZhUDUmZi0vLsI6+lvfa8UCBVCtgz6XCNJF4/pATIq4iqONNiZzGM8SiPH5OH4x8TQP27tRLCCUVSz0Xq+p/Yg+vSYAgKrgu041CV1PFq+LnIqCFdn9QzWgsdM4/f7bzKLR2g7vIdKQ02rRMYc8PXh1r1rsU+ymzIOv4QXMpwRjwNFI2GX/1TcOf3CE5spq28zjN2d1YRXtchA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3835.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(366004)(396003)(39860400002)(346002)(451199018)(31686004)(54906003)(53546011)(66476007)(6916009)(4326008)(8676002)(6486002)(66556008)(316002)(31696002)(86362001)(36756003)(478600001)(66946007)(6506007)(2616005)(107886003)(6512007)(186003)(26005)(83380400001)(41300700001)(8936002)(2906002)(6666004)(38100700002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MjRBQWNSOWc3UXZabm5BUHRJY0tCQWdmcWxzYmZhQ3RkWUpId3FlWDlYdWYx?=
 =?utf-8?B?WE5qR29Dc2NTcWV3M0FuMTJUL0tLYVo4ampwM2NyOHZmWWlEWkk0UE1xQ1VC?=
 =?utf-8?B?MHEzNVNqMVBtNVJGQVdxemtmUlowZ0cyT3hhK3BydCtCYWpUUTFHYlVzY0xG?=
 =?utf-8?B?MHBNQmNTUWRRSC8vME8wSTdqRnExNmdTVDVDY3ZIS3JtaXJOd2NLNm5vU29G?=
 =?utf-8?B?ZXNidTJRaFFEbUdlMjlQVElNUGxvd3lzYjh5dGFXeGY4Yk8zMzc2bG5ialVL?=
 =?utf-8?B?d3pka1J5cmNZdzdYYVprMDZtUVVjcDVjRCtoZnJkMFEyQm1oS242dUp0UzhS?=
 =?utf-8?B?NVB6RmY2czVnZlJIL0hrUW9WS0Rka0NMVzZZNHdoNnRneFliQUQwbU9IV0g4?=
 =?utf-8?B?SzZPc0s5RkRpNVNZLysybFp3REt1K3d5ZDQrSkV1cHhIekwwU0pvUnY2amdt?=
 =?utf-8?B?dCtrQXYwbk5wOVhmRy9mOGttZXV5bmtpUFhDeTg4VmRnQjlPRUZuQnpNS2pE?=
 =?utf-8?B?dzA1REk0ZzJBR1RiV2h6UHdjRlZOTWVMV0ZLakgzdGFSMEZBbGpyd2E0OXFt?=
 =?utf-8?B?WEtHZm0rM3VWbDhmYWJRMHNCVmNhT0RWbVk5NDd4SldxRGVuNHRocHRJZDNK?=
 =?utf-8?B?Y1FzZGFDTGR2T1JCNkNJNmUvUDlOMXhkUjkwaHRPSjFVcnhlcGxGd3AzeWRS?=
 =?utf-8?B?dzRKN3Z2VVBrbjZtVzVWZEh6R1pPRHBpampZakFwMGZMT1QwamlFVG56R1JP?=
 =?utf-8?B?UXZpcGYxM0c0SDRvVGVybVVuSExnSXk3RUJrN0luUmxWbnJNOVk2dUhzc1hV?=
 =?utf-8?B?d1lSRWl2dVdmaDRxNjY5eEhaV1czM0U1NHpSK3NmclAwQlNsV2RxOVVxNkQr?=
 =?utf-8?B?YjZoS1VpQ3ZkMkxYd1pPUkhoMUh1K24yMUdvN3ptSWJka3ZCaGpYZktaY0V2?=
 =?utf-8?B?TUNEbFdNbkU0QlpJTnNVZ0pzWCs2N09JZkFlajg3dWVaZXYxRm9ESjFNZ2pN?=
 =?utf-8?B?YmhHNlZ4TnNwSUZqd21SUGFkUzRwaDQ2ZUFHZVVBblJqZkZvZDczTUlBUDhh?=
 =?utf-8?B?QzRjbjRNWjArNndPVlVUT2dNdlFpTjlFOEMrem9FOVRyUzJGMEE5eHdBZDhh?=
 =?utf-8?B?MHZGV1dxUm5EeFQ5eXVsUENWQ1BvZW9VZmtJVmxyZjRpck0yT2NuR3RSK05D?=
 =?utf-8?B?TFc1dHNOL2NqbzZKMjN0di93blQ2d3lOZkZDbzR0Y2F2WGdleitnZTk0L3ll?=
 =?utf-8?B?NFVjaHFSNkJ2cTJBN21IYTdSLzgrSVdhMTdRcGF6MjVJSVFZb3FVT1VuOGxS?=
 =?utf-8?B?akV3QUUrUVI3ZkIwTmxkUGhtS054NU83eC8wZXJCMDJwT3Z0dS9Pby8rVUNp?=
 =?utf-8?B?THp6bDZoYzBrVWs1am1aSVZuRzQxWFQ2K2lZTTdRbUQyaWo2OFpGSExQTWla?=
 =?utf-8?B?Zm4wRjc2UHpmemdkVHlZc3NIOElFbWp4T1E4WXh6YnFYVWtYc28rMU9zQ3Qw?=
 =?utf-8?B?NGFHMEN1dHN4RXFOL0JFM1FybllnaDJkZThOZVJtZS9ReWQwNUFxSmF1OTZh?=
 =?utf-8?B?TTY5aFMzMW5BamllbGFDaGY4VXB5YzU3bjJYVlF6L3RmUm9YQm95RTZ1Z0hq?=
 =?utf-8?B?QXVPa0tNVkFacWZQTDc4ZmFGdDk5UkduR1NKMjNTYm44YUp1ZzhhK0lRR0Nw?=
 =?utf-8?B?TFQ3KzB3SHlkVUR3aW52bDdJRW9SRU1weEoySlNBaExKaFVIbjhNWWIzZjNh?=
 =?utf-8?B?M2k2ZzJPQUJOV2Y0UCtPeTRQandTUElxWFFrNzNodHNYdGdEOStxM05NSnpz?=
 =?utf-8?B?M21SWFc4QVJ0aVJPUDZ2bHRic1NVOG1aYTJnd1NEWmc1WnFybVVQaS9Iaisr?=
 =?utf-8?B?bS9hNjF0QmhkTk1HV1lLZ2ZYOXBEb1ord1grQWtJV1FYdGRBUThxbmZaQXJl?=
 =?utf-8?B?MzFQbzRXcm5tOWpMOTdwZjduTkdCc3VUd1FGYW9NdGpCczdIc0FudHlDSmxK?=
 =?utf-8?B?c0x6Rkx1aFFWM2F3akxjMGs5ZmZqNFVqOFFyS1VqMVh1NG9qUVFzWkVLTm4v?=
 =?utf-8?B?SkRkcnhOMjM4ZUhCb3VKdHY5ODVRWmRCYWdNdUNneUx6WHJpckdQTUhpei9L?=
 =?utf-8?Q?YaWSV8YuWb7LHNIeZvUx5DFbr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7abd5f2c-133d-4aaa-13a9-08db0ff980c2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3835.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 08:40:48.8126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E9vt+t0v2oLzkFLieP4b1RHSmquaiiNO664GPeTq7UnwG7TgnGl8cWrHAxi+OA3pEWmy8C7gOGzvqfK1XpOGQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8245
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/16/2023 1:01 AM, Alexander Lobakin wrote:
> External email: Use caution opening links or attachments
>
>
> From: Gavin Li <gavinl@nvidia.com>
> Date: Wed, 15 Feb 2023 16:30:04 +0800
>
>> On 2/15/2023 11:36 AM, Gavin Li wrote:
>>> External email: Use caution opening links or attachments
>>>
>>>
>>> On 2/14/2023 11:26 PM, Alexander Lobakin wrote:
>>>> External email: Use caution opening links or attachments
>>>>
>>>>
>>>> From: Gavin Li <gavinl@nvidia.com>
>>>> Date: Tue, 14 Feb 2023 15:41:37 +0200
> [...]
>
>>>>> @@ -96,6 +99,70 @@ static int mlx5e_gen_ip_tunnel_header_vxlan(char
>>>>> buf[],
>>>>>         udp->dest = tun_key->tp_dst;
>>>>>         vxh->vx_flags = VXLAN_HF_VNI;
>>>>>         vxh->vx_vni = vxlan_vni_field(tun_id);
>>>>> +     if (tun_key->tun_flags & TUNNEL_VXLAN_OPT) {
>>>>> +             md = ip_tunnel_info_opts((struct ip_tunnel_info
>>>>> *)e->tun_info);
>>>>> +             vxlan_build_gbp_hdr(vxh, tun_key->tun_flags,
>>>>> +                                 (struct vxlan_metadata *)md);
>>>> Maybe constify both ip_tunnel_info_opts() and vxlan_build_gbp_hdr()
>>>> arguments instead of working around by casting away?
>>> ACK. Sorry for the confusion---I misunderstood the comment.
>> This ip_tunnel_info_opts is tricky to use const to annotate the arg
>> because it will have to cast from const to non-const again upon returning.
> It's okay to cast away for the `void *` returned.
> Alternatively, use can convert it to a macro and use
> __builtin_choose_expr() or _Generic to return const or non-const
> depending on whether the argument is constant. That's what was recently
> done for container_of() IIRC.

I've fixed vxlan_build_gbp_hdr in V2. For ip_tunnel_info_opts, it's 
confusing to me.

It would be as below after constifying the parameter.

static inline void *ip_tunnel_info_opts(const struct ip_tunnel_info *info)
{
     return (void *)(info + 1);
}
Is there any value gained by this change?

>
>>>>> +     }
>>>>> +
>>>>> +     return 0;
>>>>> +}
> [...]
>
> Thanks,
> Olek
