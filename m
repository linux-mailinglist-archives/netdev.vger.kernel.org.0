Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A78B15A7924
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 10:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiHaIf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 04:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiHaIfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 04:35:55 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20629.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639719BB70
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 01:35:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oi5+OPTKFYAZzg/rM6npScMbDweVeny2V5UzjoSHKNwd/yEPDOO/uVqun5PBCSQ02SgCPDeYfJ58bGTZjCiLBA0NOfY9/hYS3SijzWMXgUGmxcZ4WSXSNlcmJEUZFNUcGpPoamFWwDGw7DPlwbiNL9stnw3FX5gmqbfSMg59xL1iZI+2hz02BI5AA8BG5PgYsiDoU01g8PAjYuRx18EP9pASQFYRib+PzQNCWXUzRp3hHPgIVJGXspRMjGp4kxRo0NEoyKRD08fbnAoAv8jlNn6NuBf3jyxqTn/iqOrcNWdh3n0fImIHRsI2rO44tzfqqK7SuB2q8sNAZP7BicPEiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K3Gb+NwMAhn6g88LkPpUHqbGj/VBtInmWUVjrMxnBU4=;
 b=BQbSopuTi6i+4SVadmJnAwLdIbj5aO07i45lDYMMuKq9gh+ys6pRiNoDzQPy4EbS2fuf/oUGP6wNkmCVwLDCwEZkrlgySsgXm34Q9ZCA2NPv7DuCrLHa+8AI4meBmQekzyqq0Hgdri04Jx9SAip6nD4xddTNrnhKE8LHURSbLOBDJPEGEnDOIn2jigpLG4v9/PWiMWgNQq7rBn4ixLdrjP9FNncVXD6P7u0dZQ8Bd2QBkc2BOkxu/GTiuKJJGzUalfJ0m3sDwqeMmkoaGElNP4qCA2krW7AqoZfENSK28iR9CM7ji0ypCm1PPO65Q8MG9zdfRYndzZKoDls9M6vI6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K3Gb+NwMAhn6g88LkPpUHqbGj/VBtInmWUVjrMxnBU4=;
 b=VatdpJpyAkyJep/S5P7Yn8+jn+GJujnpmWq5YWqIWrOEnhv8kZaU0RjLVdOiiHwfsmprWNvNM7RV6sXriV+eMp0k/6l5HQ5eANigx74PnfvjCnBdWfRgZ9z5objnHZaQid5nkx6wNKFtBOzonDLokb3J2Nv68S51yzI8cPhloZ0ubCWarmnHfdiRsstTKN5trHl9SvlhXzJMANGIvlyk7NsIpdAueJt36csp5hohm47otSDx8SyIf6GSLFsEImfWsqjWIvA3COVpO+HXwAhyno6uv0Qkuy04el0+RcJbzn7KUsvU77qsWSSG2LxDmncudXnQfEmAVE9GZ0ycSJa6BA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3835.namprd12.prod.outlook.com (2603:10b6:5:1c7::12)
 by PH7PR12MB6764.namprd12.prod.outlook.com (2603:10b6:510:1ae::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.19; Wed, 31 Aug
 2022 08:35:51 +0000
Received: from DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::e52a:9fc5:c7f0:7612]) by DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::e52a:9fc5:c7f0:7612%6]) with mapi id 15.20.5566.021; Wed, 31 Aug 2022
 08:35:51 +0000
Message-ID: <453a50f7-ab7d-3474-cab6-2e83a3c3acbf@nvidia.com>
Date:   Wed, 31 Aug 2022 16:35:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [virtio-dev] [PATCH v3 2/2] virtio-net: use mtu size as buffer
 length for big packets
To:     Si-Wei Liu <si-wei.liu@oracle.com>, stephen@networkplumber.org,
        davem@davemloft.net, jesse.brandeburg@intel.com,
        alexander.h.duyck@intel.com, kuba@kernel.org,
        sridhar.samudrala@intel.com, jasowang@redhat.com,
        loseweigh@gmail.com, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        virtio-dev@lists.oasis-open.org, mst@redhat.com
Cc:     gavi@nvidia.com, parav@nvidia.com
References: <20220830022634.69686-1-gavinl@nvidia.com>
 <20220830022634.69686-3-gavinl@nvidia.com>
 <ed397c98-316c-4785-0d16-81605246c2cb@oracle.com>
Content-Language: en-US
From:   Gavin Li <gavinl@nvidia.com>
In-Reply-To: <ed397c98-316c-4785-0d16-81605246c2cb@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR03CA0095.apcprd03.prod.outlook.com
 (2603:1096:4:7c::23) To DM6PR12MB3835.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78f18f1d-d4b4-402e-691c-08da8b2bcf69
X-MS-TrafficTypeDiagnostic: PH7PR12MB6764:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JiWt3EWmetIwKwAvMgG/5atXsmL1PflSlEkcu+tyBSYAVUUZMUrfdtfsERjffghio8M3bVg6j6vIy8n+FMvTXG7VnlbsjFX3gUMjDuLAy8y+8P/IlWVuAdVEtkDBicT5AfX3ABGCEvdnwtN3XvvNr6DTesLMM17qO5VUBEyPA19Uj5LhbppS5dabiBtNzGq8EblPnL8DC2zjeJUqSssk6/K6WjLfEwob592hQtpCoe2EYyUxRMjzIprkxSdNwrGTfhbUsQ3VXTszRyz8N1h1AG9sqgyBNfI9BD2VgpFn05iroDFVWTeve2eUuMZWL+8liE73hBCpGnnqy+zGOFFk+nF6Xeaz1nZrENVZpiOSh5aW12mqKk4hoXqsHw0Z3xbi3IqL/xt1z6gVoEo/NsSC45QJkwc0RamNIvS0YI/tvRZ4hHAwXWtn8S1T2fwY2gd6zCWF8WpxNM2yGFsMuBqre8UPG03flMBZUlVwDTUX1/HLKFKyzzGXmCshTvCLtO6j4lCKVbce6F//6VLg3rJnyVw/8bVTvqywAGjydZWCb0pbI9h3l17x57dZ6oTYF7SjOFXGHQEtCJgh2Rx2SLZakecJXG+uWQmEMwVRE9Ct1v2CHvFyu8dhe4zY+VNH0uode4bvv8lSjYY/N7/xYrPMk1/v6LLUVjVleKFojEGo72cwK8bsRIY/9xXv4KA3U74vnPhFfUP4ylBDxuR60RW+GlB88iscGs++XZKX0DIpLgGt5eEHuZuTkuZycYWfsbZVa8uc8JKn+k4eZUT0IZSt2qIjKKSstr2JxSb9/kB9o62J8fxXbJMpfcOOmCsyfeMr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3835.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(39860400002)(346002)(136003)(366004)(6666004)(86362001)(2906002)(31696002)(83380400001)(186003)(316002)(2616005)(8936002)(38100700002)(31686004)(7416002)(921005)(36756003)(66946007)(66476007)(66556008)(4326008)(5660300002)(8676002)(6486002)(6506007)(478600001)(107886003)(26005)(53546011)(41300700001)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YmtITkVmYlNpMkRTYyswR2x5emdGa2RRV3VOK2gvQ211bWErbkNpSEN1MTRS?=
 =?utf-8?B?cHFMdThVaWFkc2dueHJnYnBhYUhUcVZsOVlTMEFKSFczR3A5cVRieDdPVFlm?=
 =?utf-8?B?eXdPUEVKUEswVVRNMytuMlcwcGxyY0o1VGp4Mnh3K2dCQnBrc2FPdHdPRXJX?=
 =?utf-8?B?NVNJVTY0UFpNUDdpQVUxL3d4QnlPSTNEQjRSVHhKSTAxWkN0a0RBVGRGWEQ3?=
 =?utf-8?B?SXFHRFBZMVgvaWpaa29rL0ZTVWR2M3BXb0U2T0FZbGJvUUZ1Q2Z0TDZyR3pF?=
 =?utf-8?B?L1Iza2kycGducitscTZoeXRnVzRDeHB1OGtPRG4vSVh1dlBJNjFEYzc4Nm83?=
 =?utf-8?B?RnYydXBYQUJjeTdmVmZXRnIyT29uUmhOd1NlL3BpdnNaOEpaTzFPTy9CcC84?=
 =?utf-8?B?aUw1anVqY3k0L3BtdVV6S0V0Ri9uYzZqVDJCVjdSMGJvYjFJRitXamZDVFFH?=
 =?utf-8?B?ZFFLNEFXUEVQcG1yUTJ2d25sYmV3YndlZVh4TDYxVlpRV0FKeUphUjVndEth?=
 =?utf-8?B?eU9aOExHTEw2aW1ZUndLRHJ4VTlhQjJzK2h3S1U2NDJXUURDMkJYeTNUczQ2?=
 =?utf-8?B?QUhHd0JzYVcxWEM2dmdkV2s1MXVyZ3B5bWdMalp1UmRkam51dGthRThvWVBa?=
 =?utf-8?B?SklXZWY3WWNYZUtEWDBteURLSDU4NlVlZERWTm8zeThjaFFzM1c5cHI4Tndo?=
 =?utf-8?B?NTV6Z25CZGpPdWJGWkxuRDVJSHJCaStRWW8ydHlieTR5Rkk2bHFWNkZMU0E5?=
 =?utf-8?B?c20rUFlBT2RoaHhLVnk5OGlRck1uNzR6Znd2MklIOTJveVJjQ3NjemZDYXB3?=
 =?utf-8?B?b3lEWlRsZDlEei9CMVlRbFNFWFZ6MVMvT1lURVhqNnY1dlNGU0MweFNweTJ5?=
 =?utf-8?B?KzlGSkR0eWdJSEZCTkxiV3Y5b3hUQlRWSENLUDNPTTNibkxSVGx3SnNrOHNE?=
 =?utf-8?B?WG51bW9Tczg1MnZZV1ZBdWNFNUpoZ1JSZkhwZHdNNS9uRS82YlBsRVhST0Rn?=
 =?utf-8?B?ZloxY1JnWFgyNVlCTVV2bmI1VTg2YWRnT0dxQUtpWEl6enVhY294ZzRjbDkx?=
 =?utf-8?B?bnAwSDloNUFMSzZhQUszc3RWMjFwSm1ZRWtlZVNpcVQ1eVJtN09yZ3RLYmpq?=
 =?utf-8?B?dDVmVHpCKzZBbEpESnpTMmVXejhnYVhwdjdoL1NrVkhWTVI2Z0hXTmtxamdI?=
 =?utf-8?B?azI0SGwwcEcxb05vQnowUDJScTljeTJOdENhVThsRDU1VTdkaXUwQ2NJNGdY?=
 =?utf-8?B?M2ZlVUs5dFZDajZkNjlhYnNhL1ljN25IMCs3RjlPSHlyTlpRN3dVbzBweTRW?=
 =?utf-8?B?V2ZsdXl6WDFtSFpNWWEvT0Y3ckhDOUlyTlkwL1BYU0J0M2JEdVAxKzI0RUF3?=
 =?utf-8?B?ME5GaFdPWkkrUjJtYVdJWUxaMmttZWRUTk8xeUZ4Vjd0TktOd0pRMmk3aEIr?=
 =?utf-8?B?SG02WThxNTlHYlFFaHJrSUtZejdoa3RIM2h3c0R1cWFJZWRXYVBMVW5wbktr?=
 =?utf-8?B?WCt0WGZWbXFCZGF6WE9TNXV5S1lpVXA1OXlDWFVENE8rVHBad2xhZzZSQmtk?=
 =?utf-8?B?b00xaXBFTW9ZcDRVOWxCTXR5VzBIekpFUGRKRXljOEF1aHRsN25vbGp3Y1Ru?=
 =?utf-8?B?c2ViQ3Q1RGxCbmd3UVlpVDUvQkY2TVY0emVacllQZ3N6ZzhGLzFVT2Nqa2FS?=
 =?utf-8?B?TlhzMGpIb3QyekpJamNQMno3R2VGK3haS2Q2d0pEdWY1b0dLNm9ROHpZbGx0?=
 =?utf-8?B?WW0rV1hyMGlESzhiWWJsbXFhOThzOFc1YWtWVFZzbEZYYTA5RUpwZGs0Y0lk?=
 =?utf-8?B?L1NJUkF3Wi95K1FJQ0FUb3g4YVRiN2dqbDRLMzNEdXhabE1SQTZ0ZGd1RDdU?=
 =?utf-8?B?Z2xWeXVNTUxaYW4yTXQwVFl1M2hGYndUVVZQVUpBZTd3czgvOW05YkNiVXJm?=
 =?utf-8?B?VG51bXVkTE9RcXR1WG1ZY3lYakJVNXJibTFTcDY2cXoycEkwSWdpRmhxY3ps?=
 =?utf-8?B?UVNDM2dGWFgwSUNOczJpOVJHZHpnRDZab0dTdSs2TlVLTUJUblVTYktRY25w?=
 =?utf-8?B?WEt6a2J1N0kyS2NJa0piRU1yUEM5K3RMM0Vjc1FSTUxvL0tRMWMydnRaU3dL?=
 =?utf-8?Q?i2XpIvc8OqfoAi0N5/DZYRPP9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78f18f1d-d4b4-402e-691c-08da8b2bcf69
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3835.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 08:35:50.9430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sl3TYVgdHOmHPFunkUaelW5bF1RQLyAp1b5+Qx2vOWTPV6fkwlVr6wPW8roSQPpIphglE/HjVcsydA4bdPS0Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6764
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/31/2022 4:33 PM, Si-Wei Liu wrote:
> External email: Use caution opening links or attachments
>
>
> On 8/29/2022 7:26 PM, Gavin Li wrote:
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
>> When guest offload is enabled at runtime, RQ already has packets of 
>> bytes
>> less than 64K. So when packet of 64KB arrives, all the packets of such
>> size will be dropped. and RQ is now not usable.
>>
>> So this means that during set_guest_offloads() phase, RQs have to be
>> destroyed and recreated, which requires almost driver reload.
>>
>> If VIRTIO_NET_F_CTRL_GUEST_OFFLOADS has been negotiated, then it should
>> always treat them as GSO enabled.
>>
>> Below is the iperf TCP test results over a Mellanox NIC, using vDPA for
>> 1 VQ, queue size 1024, before and after the change, with the iperf
>> server running over the virtio-net interface.
>>
>> MTU(Bytes)/Bandwidth (Gbit/s)
>>               Before   After
>>    1500        22.5     22.4
>>    9000        12.8     25.9
>>
>> Signed-off-by: Gavin Li <gavinl@nvidia.com>
>> Reviewed-by: Gavi Teitz <gavi@nvidia.com>
>> Reviewed-by: Parav Pandit <parav@nvidia.com>
>> ---
>> changelog:
>> v2->v3
>> - Addressed comments from Si-Wei
>> - Simplify the condition check to enable the optimization
>> v1->v2
>> - Addressed comments from Jason, Michael, Si-Wei.
>> - Remove the flag of guest GSO support, set sg_num for big packets and
>>    use it directly
>> - Recalculate sg_num for big packets in virtnet_set_guest_offloads
>> - Replace the round up algorithm with DIV_ROUND_UP
>> ---
>>   drivers/net/virtio_net.c | 37 ++++++++++++++++++++++++-------------
>>   1 file changed, 24 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index e1904877d461..d2721e71af18 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -225,6 +225,9 @@ struct virtnet_info {
>>       /* I like... big packets and I cannot lie! */
>>       bool big_packets;
>>
>> +     /* number of sg entries allocated for big packets */
>> +     unsigned int big_packets_sg_num;
> Sorry for nit picking, but in my opinion big_packets_num_skbfrags might
> be a better name than big_packets_sg_num, where the comment could be
> written as "number of skb fragments for big packets" rather than "number
> of sg entries allocated for big packets".
ACK
>
> Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
>
>> +
>>       /* Host will merge rx buffers for big packets (shake it! shake 
>> it!) */
>>       bool mergeable_rx_bufs;
>>
>> @@ -1331,10 +1334,10 @@ static int add_recvbuf_big(struct 
>> virtnet_info *vi, struct receive_queue *rq,
>>       char *p;
>>       int i, err, offset;
>>
>> -     sg_init_table(rq->sg, MAX_SKB_FRAGS + 2);
>> +     sg_init_table(rq->sg, vi->big_packets_sg_num + 2);
>>
>> -     /* page in rq->sg[MAX_SKB_FRAGS + 1] is list tail */
>> -     for (i = MAX_SKB_FRAGS + 1; i > 1; --i) {
>> +     /* page in rq->sg[vi->big_packets_sg_num + 1] is list tail */
>> +     for (i = vi->big_packets_sg_num + 1; i > 1; --i) {
>>               first = get_a_page(rq, gfp);
>>               if (!first) {
>>                       if (list)
>> @@ -1365,7 +1368,7 @@ static int add_recvbuf_big(struct virtnet_info 
>> *vi, struct receive_queue *rq,
>>
>>       /* chain first in list head */
>>       first->private = (unsigned long)list;
>> -     err = virtqueue_add_inbuf(rq->vq, rq->sg, MAX_SKB_FRAGS + 2,
>> +     err = virtqueue_add_inbuf(rq->vq, rq->sg, 
>> vi->big_packets_sg_num + 2,
>>                                 first, gfp);
>>       if (err < 0)
>>               give_pages(rq, first);
>> @@ -3690,13 +3693,27 @@ static bool virtnet_check_guest_gso(const 
>> struct virtnet_info *vi)
>>               virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO));
>>   }
>>
>> +static void virtnet_set_big_packets_fields(struct virtnet_info *vi, 
>> const int mtu)
>> +{
>> +     bool guest_gso = virtnet_check_guest_gso(vi);
>> +
>> +     /* If device can receive ANY guest GSO packets, regardless of mtu,
>> +      * allocate packets of maximum size, otherwise limit it to only
>> +      * mtu size worth only.
>> +      */
>> +     if (mtu > ETH_DATA_LEN || guest_gso) {
>> +             vi->big_packets = true;
>> +             vi->big_packets_sg_num = guest_gso ? MAX_SKB_FRAGS : 
>> DIV_ROUND_UP(mtu, PAGE_SIZE);
>> +     }
>> +}
>> +
>>   static int virtnet_probe(struct virtio_device *vdev)
>>   {
>>       int i, err = -ENOMEM;
>>       struct net_device *dev;
>>       struct virtnet_info *vi;
>>       u16 max_queue_pairs;
>> -     int mtu;
>> +     int mtu = 0;
>>
>>       /* Find if host supports multiqueue/rss virtio_net device */
>>       max_queue_pairs = 1;
>> @@ -3784,10 +3801,6 @@ static int virtnet_probe(struct virtio_device 
>> *vdev)
>>       INIT_WORK(&vi->config_work, virtnet_config_changed_work);
>>       spin_lock_init(&vi->refill_lock);
>>
>> -     /* If we can receive ANY GSO packets, we must allocate large 
>> ones. */
>> -     if (virtnet_check_guest_gso(vi))
>> -             vi->big_packets = true;
>> -
>>       if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
>>               vi->mergeable_rx_bufs = true;
>>
>> @@ -3853,12 +3866,10 @@ static int virtnet_probe(struct virtio_device 
>> *vdev)
>>
>>               dev->mtu = mtu;
>>               dev->max_mtu = mtu;
>> -
>> -             /* TODO: size buffers correctly in this case. */
>> -             if (dev->mtu > ETH_DATA_LEN)
>> -                     vi->big_packets = true;
>>       }
>>
>> +     virtnet_set_big_packets_fields(vi, mtu);
>> +
>>       if (vi->any_header_sg)
>>               dev->needed_headroom = vi->hdr_len;
>>
>
