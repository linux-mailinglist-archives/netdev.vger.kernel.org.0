Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB1625AFE8B
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 10:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiIGIJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 04:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiIGIJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 04:09:11 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA7B8708A
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 01:09:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N70giFuiq1dIkGo2oHhrdQCq3mue73igcqmrOtcdGQJny59/VeA5n/V3bub1Go/IbOFcU0hmjToP50F7FJsQ5MumKB6TeBH2GxTU+t8aDHNZTLCErNQ8B+Ro/tZPLMsxFdqCVUe4qlliQkdhMBuePi8Hdn7t2KJhO58Rb7TolLrADgszPTw0QhpuKVNAFgyiBGLOdmClfXfHWKNJypaL6PYK6MvfYI/s2V4A42LFv+iY1pYxVo66XNePaofXeo44e1vrhm4NTCGLShjkbfa9sVn15GzEjC84xO5nDNz9rvU02POGXCcWPZQljuvaPoK1fgWW5moBLMODiKcO4h8PwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AG3Vpvu5fjEYeCaije6UF5n1bViD8d4cq0FNH32ja6I=;
 b=HeDzE69cJ1pTGKcdFrAfgtq1hWUUpBGpnlDHDIT5Ioqw6UtSks9JHufbcmsiAqSsAvSshgHOAqAaUM2NrU7uuhWxeHZddRvYXP9I0/WZWN4A3d5N7MfJ3q2KkAmg3xzYnDnQz2TGi1WV5Klsjca6neLuZZdsJHIHg0xJFoZKMOaCBQPjxBnZnaQhjZyF8AaPe1OzN0b1zEgdfv7S3fw11aXNKMV9JvBXSMUMUn61t64NIUJWS1hNb0wc8NN2O6hYitm0q2x0AxQqr6TPK3Ynu4IVYuwGCPEsst8PiCwi2SRPyVaiKM8tX/WjP4TGwJkSWlVvATrvkAH2ua/06WdFjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AG3Vpvu5fjEYeCaije6UF5n1bViD8d4cq0FNH32ja6I=;
 b=K1QwBVg0VklZGikhOFEOkzJ+aHkvImdzzgHXhcp3BUa109iXpacHZ5nIEyGk4VtBp0dM430PSOIAzTskUStGhGxah72vQ6FJ8tN8USe7zshHO3jOxCSzGKAuMZAJCIY5dqjc4YzIXABqdroUQtL34tGUsF4YCTaBULnz7sBvOEOL1Ujk3ow4guPQio/VCyuSdZ4o7mMEwG3gC+8j2f6LuixWEIh8x0Rbk/QOz0FfzwcRmFZfLxkDX27Y5aXF4cClGX/6UgHwaiOp87QuGkYZFuwWVTpVl4iUByj1lUMFPfIbszKbyT9XqidKD8rUvgugFkBSaqPBJX32+4UzM70GXg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3835.namprd12.prod.outlook.com (2603:10b6:5:1c7::12)
 by SJ0PR12MB6782.namprd12.prod.outlook.com (2603:10b6:a03:44d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12; Wed, 7 Sep
 2022 08:09:07 +0000
Received: from DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::c4ee:2739:5cbc:4f7c]) by DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::c4ee:2739:5cbc:4f7c%6]) with mapi id 15.20.5588.018; Wed, 7 Sep 2022
 08:09:07 +0000
Message-ID: <0355d1e4-a3cf-5b16-8c7f-b39b1ec14ade@nvidia.com>
Date:   Wed, 7 Sep 2022 16:08:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v5 2/2] virtio-net: use mtu size as buffer length for big
 packets
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     stephen@networkplumber.org, davem@davemloft.net,
        jesse.brandeburg@intel.com, alexander.h.duyck@intel.com,
        kuba@kernel.org, sridhar.samudrala@intel.com, jasowang@redhat.com,
        loseweigh@gmail.com, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        virtio-dev@lists.oasis-open.org, gavi@nvidia.com, parav@nvidia.com,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>
References: <20220901021038.84751-1-gavinl@nvidia.com>
 <20220901021038.84751-3-gavinl@nvidia.com>
 <20220907012608-mutt-send-email-mst@kernel.org>
From:   Gavin Li <gavinl@nvidia.com>
In-Reply-To: <20220907012608-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR01CA0132.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::36) To DM6PR12MB3835.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 387a56ab-8057-4553-a145-08da90a83c87
X-MS-TrafficTypeDiagnostic: SJ0PR12MB6782:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7o9wu7FJp8HiL7q9uYh4cOqwFDbRb80E/AZOaQcGx7IoR8obcuk6LfK381Yqez5YIXe9KgWlU1vumZKvMnfNiLl9P/iabouqMEiJJzA5h7SlqF2LNPTIEg7sO6b1atOEE1ONtDZ1jZkcIfXO2q+a6+k1WG2y7nNZE8dNi46v8rDOzqr99SbiPwwm5paMf/ZHX51WQ/99GzMZYQFVVq30Kpkm60IUPt+ryvIFyxi0sHH1+dPNpwMBSZxmODb2z6tdXDS7LWCDw1PQeoQeCEdVs3tFXigU3is5UPJY3I4bp101AFgd0xJ1u0Hmh0MU2w2+CvfhH3xz9pxR6GtlKMthhR84nMDYWzqu9JP4GDXNN0LMH/ID7DJwa+uvFNBnu3Bk9a3forvj+haLPDE5u9zZ1LEwXWaod41vNNObMKh71q4220mAIJnSNCQfBqbcG84W0uALDJrq30EtNdftmkqBm7FhI7G+okfso+dAYfkadwB6TYYvhVnNmyXMCIJYHGSNeC60Xw+b7zaYm3kwx5Tph7dx6m3KIanR20jk6GRBLtYt9cwXL9Yfz+YwXzkKTWlbaHCwB5SOK0rs+JUvUzROYDIGLKN0s3AYq3ea5qIwm+I0p6iUMtMqIqpR/AZGl7XXQIyKb/vckb2hfHqP80AGLMwaSzitagakLWAIOQClYe2EmUU3C2TXqhT9kJ6HvbIs92RDtv23d4P2SUANd1s9UTixV2gFDVXdnRarRyTLvKu/Nbr2Aul1YRORD0obv+dPSHu0KtxuRmIAX0JYKpowVmQjEx4TDR/7hSrLBr02G+k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3835.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(136003)(396003)(39860400002)(376002)(2616005)(86362001)(186003)(83380400001)(38100700002)(31696002)(66556008)(31686004)(8676002)(66476007)(36756003)(54906003)(66946007)(4326008)(6506007)(6916009)(7416002)(316002)(5660300002)(8936002)(26005)(6486002)(478600001)(2906002)(6666004)(53546011)(41300700001)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2wwTytZcDUrM0FjOTkxS1ErQ2Z0cVdvd1Z4UzVtWmpzcXpGUzF3bE9xQTJ0?=
 =?utf-8?B?azdiTHNIRkdVOTRsZysyd3lNdjZOV25lR0lGN1duaHRTZXhBaVBjcWhOU2w0?=
 =?utf-8?B?U2owVTlQbks0UEVrS3BNMUlmMVQybnF1YUkwNlBadnpWYmFrbDc3ZExtZENJ?=
 =?utf-8?B?SC8rcThMUkt6cmlTN25kQ3IzWFVPUUZsa1dtM01hWDI4ZnBmTTZNeHA3VTl4?=
 =?utf-8?B?UXJnSEx3UXhYMWJiOWJHUlRLajFieVFWNFJFZjk4Y2JWNHZRTnJTWkFrMWZ5?=
 =?utf-8?B?cExna0JwcW9HSWNtT3R5c3NKUlZJTXRidlNqcEI0Z2tGb1VjdkhMOE4xK3l5?=
 =?utf-8?B?L05tZ056cmh0WWNHSzZVY0YxdjVORVNoelVNT2xrMVlEbGIyVFpUWUcya3Mr?=
 =?utf-8?B?QXdGcm5uZ2VPMG1SU2VqNHFiOWw3T3lGc0RHb2VPUlQ1VW84N3o2Y2ZnNFlN?=
 =?utf-8?B?KzI1b0xHYXRWV29rRTBBZXl6Z3BKajk1bzBNa2RDUmd5MDE3TWg0cTVabDkv?=
 =?utf-8?B?WEs1RzU1VXNQbUd1SU1Tb1A2MUx0K3VUZ2FmbWtXRlp2VlFEOGF3ZExKdXI0?=
 =?utf-8?B?Mm1sRmVNTW03SXFyb1kxSGlIVi8wc0ZEZGRWcEFkVzJITXMwdXJLaVNYc0cx?=
 =?utf-8?B?anJYbnpHdFFFY0djNE1ZVDlLQ1VkRTFmS0FDT1VwM3A1YjdkQlpMUjhmS2lj?=
 =?utf-8?B?ZnpZbHJRY3RzbFdhditLRjFtZ3hNZ2xqNGs5S29EbGRLNURnUGorV0JwSjdq?=
 =?utf-8?B?QnVVMzZ2M3lQOFVreGd2WHI1V0phVTd4a3BXbG9GNU5QR0ZJUjJWNHpLOWc2?=
 =?utf-8?B?bUtNTmhWUEdqY1FpQ2N2ZHRsUHNMeGkyRlJaSG9uRlZnL2F2WDdZYUdOSG1j?=
 =?utf-8?B?ZVMxTGl2Q2NtV2VreTAwd2xobXV6Szk3cFdpdTkySmd1TjhEb1F4TTlUMWF0?=
 =?utf-8?B?SHBjVTIxQllpRi9QN0VnVzdJdGZBeEdHLys2bU1Sc0EwaVhMQ2N0cEp3RU9s?=
 =?utf-8?B?MWRpaHVmM3A4V3pUcHNENE4vbkFIV0ZIUHNQQTRnQjB2ZXI5bUE5Nm9lZVYz?=
 =?utf-8?B?ckozd2NPcmUrRjVkUjZGaWUrUUdpdmFwOURLQkVqTnhWWGYwOE1XckJwR3BM?=
 =?utf-8?B?aUE4cGEvb2tjN3dRRThBZCt5cmdkWXJnR1d0VG93NHRRUGtTeHRISTVGNmkz?=
 =?utf-8?B?Uk9abGFXTGJCL1JlTTZUU3ZzUjJqREtBS0JOQWN3T2dUMmFLczZTNnJaZnRI?=
 =?utf-8?B?bksvdG5Va3NjbStjOGRtRmNNbWdncjc2S0FWVExVWVE1N1RtVmlZb3BjVjNV?=
 =?utf-8?B?ejdnWWhteUZUTS82VVpQVGwrRmZ5eU1HcVVXQzdFU010TFBMV1Y3Rml2QlV0?=
 =?utf-8?B?ck9GVUVGL09sby8xVU5TdkUrZ2ZhZzEvVExrcFdDalJERy9SeE44aDZYQU4y?=
 =?utf-8?B?WU5wMWNRYlJBY3dlWHRVTEFHU2tLRnhXbGlvNEJuSnh2RjZiZUxnbzM3V3J1?=
 =?utf-8?B?a3FZbjJ0NDBlQU1rUUE0dWVZR2ZqU0hmQ2NoV21qRWlldll5VERUTFBURVZI?=
 =?utf-8?B?SGM0RFVyWXRkbjc3MlBKVko2UzVwQ3hpdXQ2Y3IrV2JQL2tUTElMMWdUY0NG?=
 =?utf-8?B?aXZ3UU9sWHJWeTA5V0pNYzN0WWo0N2R3dTJQQkNRTUNpM3hvUlJSMGlIVjVN?=
 =?utf-8?B?dXlqYi9QTnlIcWNLUlNEaGFodWxwOTMyMG1EbFRvbWNpL1B4MVg4K29QZWJD?=
 =?utf-8?B?MDVRV0ZUZ2pvYzlkWXVlb0xQRW1Od0xGTkZiYnVqZFBFOFZJNDc2MDlMNktQ?=
 =?utf-8?B?ZjlPajN1eTBYamxyankycll0ZXBNNjkxVTZiZFJOL2t6cnNGbWpLN0EvcmU0?=
 =?utf-8?B?ZjMzZkxHejdMN1dMTlgycXhGZ2RrKzRJVDNMVHJIbHlHNkxONjZMalhlR0pa?=
 =?utf-8?B?alREcVRBR2NuMjNGS2szSTVjMHdvTGZIMkx6bmlmbnFhb0ZuT1NpZ3JaeUNr?=
 =?utf-8?B?OUM5ZTYwYkpXS0szV3ZyRjdhM1NYL05Pa21vRTdUVUhKd0N4MWd2TTZ6Z3Fn?=
 =?utf-8?B?VFYycFlTUnpiTjFmOE9FRjk4c0czYzlzeUhSYk5DeUl1ZU9lWjZ0WUNiU0U3?=
 =?utf-8?Q?BE4BgTTfCL43+helwXO4uIfAK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 387a56ab-8057-4553-a145-08da90a83c87
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3835.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2022 08:09:07.5148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IICfWV5oSwIKt6oBuv+5iMNkgBnpoVNdLHFPN9TW+RI77fvXAI2Gpp6OJqG7k2weCNFkZ+Li0nLNWlL9Ty2cew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6782
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/7/2022 1:31 PM, Michael S. Tsirkin wrote:
> External email: Use caution opening links or attachments
>
>
> On Thu, Sep 01, 2022 at 05:10:38AM +0300, Gavin Li wrote:
>> Currently add_recvbuf_big() allocates MAX_SKB_FRAGS segments for big
>> packets even when GUEST_* offloads are not present on the device.
>> However, if guest GSO is not supported, it would be sufficient to
>> allocate segments to cover just up the MTU size and no further.
>> Allocating the maximum amount of segments results in a large waste of
>> buffer space in the queue, which limits the number of packets that can
>> be buffered and can result in reduced performance.
>>
>> Therefore, if guest GSO is not supported, use the MTU to calculate the
>> optimal amount of segments required.
>>
>> When guest offload is enabled at runtime, RQ already has packets of bytes
>> less than 64K. So when packet of 64KB arrives, all the packets of such
>> size will be dropped. and RQ is now not usable.
>>
>> So this means that during set_guest_offloads() phase, RQs have to be
>> destroyed and recreated, which requires almost driver reload.
>>
>> If VIRTIO_NET_F_CTRL_GUEST_OFFLOADS has been negotiated, then it should
>> always treat them as GSO enabled.
>>
>> Accordingly, for now the assumption is that if guest GSO has been
>> negotiated then it has been enabled, even if it's actually been disabled
>> at runtime through VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.
>>
>> Below is the iperf TCP test results over a Mellanox NIC, using vDPA for
>> 1 VQ, queue size 1024, before and after the change, with the iperf
>> server running over the virtio-net interface.
>>
>> MTU(Bytes)/Bandwidth (Gbit/s)
>>               Before   After
>>    1500        22.5     22.4
>>    9000        12.8     25.9
>>
>> Signed-off-by: Gavin Li <gavinl@nvidia.com>
>> Reviewed-by: Gavi Teitz <gavi@nvidia.com>
>> Reviewed-by: Parav Pandit <parav@nvidia.com>
>> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>> Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
>
> Which configurations were tested?
I tested it with DPDK vDPA + qemu vhost. Do you mean the feature set of 
the VM?
> Did you test devices without VIRTIO_NET_F_MTU ?
No.  It will need code changes.
>
>> ---
>> changelog:
>> v4->v5
>> - Addressed comments from Michael S. Tsirkin
>> - Improve commit message
>> v3->v4
>> - Addressed comments from Si-Wei
>> - Rename big_packets_sg_num with big_packets_num_skbfrags
>> v2->v3
>> - Addressed comments from Si-Wei
>> - Simplify the condition check to enable the optimization
>> v1->v2
>> - Addressed comments from Jason, Michael, Si-Wei.
>> - Remove the flag of guest GSO support, set sg_num for big packets and
>>    use it directly
>> - Recalculate sg_num for big packets in virtnet_set_guest_offloads
>> - Replace the round up algorithm with DIV_ROUND_UP
>> ---
>>   drivers/net/virtio_net.c | 37 ++++++++++++++++++++++++-------------
>>   1 file changed, 24 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index f831a0290998..dbffd5f56fb8 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -225,6 +225,9 @@ struct virtnet_info {
>>        /* I like... big packets and I cannot lie! */
>>        bool big_packets;
>>
>> +     /* number of sg entries allocated for big packets */
>> +     unsigned int big_packets_num_skbfrags;
>> +
>>        /* Host will merge rx buffers for big packets (shake it! shake it!) */
>>        bool mergeable_rx_bufs;
>>
>> @@ -1331,10 +1334,10 @@ static int add_recvbuf_big(struct virtnet_info *vi, struct receive_queue *rq,
>>        char *p;
>>        int i, err, offset;
>>
>> -     sg_init_table(rq->sg, MAX_SKB_FRAGS + 2);
>> +     sg_init_table(rq->sg, vi->big_packets_num_skbfrags + 2);
>>
>> -     /* page in rq->sg[MAX_SKB_FRAGS + 1] is list tail */
>> -     for (i = MAX_SKB_FRAGS + 1; i > 1; --i) {
>> +     /* page in rq->sg[vi->big_packets_num_skbfrags + 1] is list tail */
>> +     for (i = vi->big_packets_num_skbfrags + 1; i > 1; --i) {
>>                first = get_a_page(rq, gfp);
>>                if (!first) {
>>                        if (list)
>> @@ -1365,7 +1368,7 @@ static int add_recvbuf_big(struct virtnet_info *vi, struct receive_queue *rq,
>>
>>        /* chain first in list head */
>>        first->private = (unsigned long)list;
>> -     err = virtqueue_add_inbuf(rq->vq, rq->sg, MAX_SKB_FRAGS + 2,
>> +     err = virtqueue_add_inbuf(rq->vq, rq->sg, vi->big_packets_num_skbfrags + 2,
>>                                  first, gfp);
>>        if (err < 0)
>>                give_pages(rq, first);
>> @@ -3690,13 +3693,27 @@ static bool virtnet_check_guest_gso(const struct virtnet_info *vi)
>>                virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO);
>>   }
>>
>> +static void virtnet_set_big_packets_fields(struct virtnet_info *vi, const int mtu)
>
> I'd rename this to just virtnet_set_big_packets.
ACK
>
>
>> +{
>> +     bool guest_gso = virtnet_check_guest_gso(vi);
>> +
>> +     /* If device can receive ANY guest GSO packets, regardless of mtu,
>> +      * allocate packets of maximum size, otherwise limit it to only
>> +      * mtu size worth only.
>> +      */
>> +     if (mtu > ETH_DATA_LEN || guest_gso) {
>> +             vi->big_packets = true;
>> +             vi->big_packets_num_skbfrags = guest_gso ? MAX_SKB_FRAGS : DIV_ROUND_UP(mtu, PAGE_SIZE);
>> +     }
>> +}
>> +
>>   static int virtnet_probe(struct virtio_device *vdev)
>>   {
>>        int i, err = -ENOMEM;
>>        struct net_device *dev;
>>        struct virtnet_info *vi;
>>        u16 max_queue_pairs;
>> -     int mtu;
>> +     int mtu = 0;
>>
>>        /* Find if host supports multiqueue/rss virtio_net device */
>>        max_queue_pairs = 1;
>> @@ -3784,10 +3801,6 @@ static int virtnet_probe(struct virtio_device *vdev)
>>        INIT_WORK(&vi->config_work, virtnet_config_changed_work);
>>        spin_lock_init(&vi->refill_lock);
>>
>> -     /* If we can receive ANY GSO packets, we must allocate large ones. */
>> -     if (virtnet_check_guest_gso(vi))
>> -             vi->big_packets = true;
>> -
>>        if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
>>                vi->mergeable_rx_bufs = true;
>>
>> @@ -3853,12 +3866,10 @@ static int virtnet_probe(struct virtio_device *vdev)
>>
>>                dev->mtu = mtu;
>>                dev->max_mtu = mtu;
>> -
>> -             /* TODO: size buffers correctly in this case. */
>> -             if (dev->mtu > ETH_DATA_LEN)
>> -                     vi->big_packets = true;
>>        }
>>
>> +     virtnet_set_big_packets_fields(vi, mtu);
>> +
> If VIRTIO_NET_F_MTU is off, then mtu is uninitialized.
> You should move it to within if () above to fix.
mtu was initialized to 0 at the beginning of probe if VIRTIO_NET_F_MTU 
is off.

In this case,  big_packets_num_skbfrags will be set according to guest gso.

If guest gso is supported, it will be set to MAX_SKB_FRAGS else zero---- 
do you

think this is a bug to be fixed?

>
>>        if (vi->any_header_sg)
>>                dev->needed_headroom = vi->hdr_len;
>>
>> --
>> 2.31.1
