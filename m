Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAECA5AFAA4
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 05:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiIGDaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 23:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiIGD36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 23:29:58 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281B7356CA
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 20:29:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PPrM2DtwUoFG3nRXGr72zPeIT7+DDwrEbEIinux2qzKVfFtdSWKZgfLPhXFqUfls2saHmPpAhV6LanDpDDGnx8PXhVIFbLXtSW0S/RZG2+TVznH0+qW0nK06v1OAFCuEcV9ZZmcPhOs5AVYwioTv9BuKA9DEka9djpMffxdpM35g7svJ7fV4aujxKWCu5ynOOZIXNfT/SG1SLxdQOqwKACAoHkCg1R+bNu2rm+GIy+r71qGfvZkhFXkacqZj3f/cnFaxah0nYzDQBOqGU3Hj8v3Ei87ix56uOyUtX5HHtpl6xf49GEYAo7faQbEIj4qSyu10n/94keHWSD3ja8rliw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yRsZc83u2MAcOwgguVsrloYbnmMTH/1+X0KG1H/ZPEQ=;
 b=meogxqiSxpIUzcuRrqUDj1YLsUUF0ZgsrbBBSfQLIMSVqiHI8D4Ihwp7uZ32HpbV06bpQFP+y5TOFpOICdUCJFV/MSo2AkFv7J7T0xIamD/+T1vFgPnjxYpze2m8xXNDv0CsT9Wy0x6I44ueI4gvhV0oYu2VCd4x6l9Q+lmYFyt1dWVpSunxsf4UV0yXdaZASgXrty19nMawsuCzYAuW1X5YIzhZBZF7vcAH9vySNg+BEssc6XVTXK2shZIu1F5JqMo9xJaT+vnMKrLM0LWvmLxmqL5yO+H9T+XjFwaZ+thRbqqqiABgXsShxNb/uIyI+6QuJrIXvjUPKS8+uwaP8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yRsZc83u2MAcOwgguVsrloYbnmMTH/1+X0KG1H/ZPEQ=;
 b=ZKVoJ09XGuSA/kBFhARBT1uIlDmfVCklMj1I6hs7QbG2h5Esn23DcdgCeHqEIdhD/BGqif3C0wK6wk2PWBLertI+4BPtDOCiTqEV+//2keVlc3E1gO4HAe8Do6QBtx5+GqItnxDmTKhM55Enmouh7p8OXk++5KwQxbAk/eUyLixpw/UunwMOpQHLt2VkzpU/xrdsRqUQDhtyon/90XDFZIndG2k4YaLWE4B6rqAaI4K2JQVYToTskh8GUadwjszNz3AIs3oh4uKGPgTcB1F9D8UWfY/hUDG3czx3ngkEeGDJ5ujHahMZGg30cjmhJZVqIY6+UAa4HrBaTI97UESBbQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3835.namprd12.prod.outlook.com (2603:10b6:5:1c7::12)
 by DM4PR12MB5937.namprd12.prod.outlook.com (2603:10b6:8:68::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Wed, 7 Sep
 2022 03:29:55 +0000
Received: from DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::c4ee:2739:5cbc:4f7c]) by DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::c4ee:2739:5cbc:4f7c%6]) with mapi id 15.20.5588.018; Wed, 7 Sep 2022
 03:29:55 +0000
Message-ID: <d6531b71-7f11-e01d-d35c-4321c17a25dd@nvidia.com>
Date:   Wed, 7 Sep 2022 11:29:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [virtio-dev] [PATCH v5 2/2] virtio-net: use mtu size as buffer
 length for big packets
Content-Language: en-US
From:   Gavin Li <gavinl@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>, stephen@networkplumber.org,
        davem@davemloft.net, jesse.brandeburg@intel.com,
        alexander.h.duyck@intel.com, kuba@kernel.org,
        sridhar.samudrala@intel.com, loseweigh@gmail.com,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        virtio-dev@lists.oasis-open.org, mst@redhat.com
Cc:     gavi@nvidia.com, parav@nvidia.com,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>
References: <20220901021038.84751-1-gavinl@nvidia.com>
 <20220901021038.84751-3-gavinl@nvidia.com>
 <a5e1eae0-d977-a625-afa7-69582bf49cb8@redhat.com>
 <c487d07a-55ff-a49f-79d3-bf7dbf480127@nvidia.com>
In-Reply-To: <c487d07a-55ff-a49f-79d3-bf7dbf480127@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR03CA0119.apcprd03.prod.outlook.com
 (2603:1096:4:91::23) To DM6PR12MB3835.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb6732f9-3c58-4181-3f4b-08da90813b5e
X-MS-TrafficTypeDiagnostic: DM4PR12MB5937:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BRA3/3AhSnBDl9m1hCk+wwL9mnjfslIQHsiyenntTFuYEJokdt7Z7SbDgj1Ucn/+RWwHkMY33e4LEHh0nmfgEZTbcQFb5OHXfjRVBhmHB0UscL3hdEuh9pBWcCvT6VG5vdSlyAjlIE3yLbuH83fwoHbRPlgQRZq+t6fV5l4ksOqBd8Abm1t+7CeosttazrDHPvf0H33XQX8h3qU+VMDySbOmBxp38woyVcAQcDdjh6atlAX5QRzi1hPUNMhOfgWfiNqsNPhUyToWQ6X//Z9P2QjqXKvBaECfz04b2OuhnMcj9cBi+u/4mZbUkvsx2sTYwcbJ2yjIBtIh3OXke1zSHkEIL2xfChQwaplkWlHgTkVojFvSk8YEBhHvwQ0M9naIcHbt6DyPG7PYrpEJErdlNQHDE7NH+YqwJqCkoxi/twXzvzXW8OUUAbTtaLADnoGQ+nfcbtOfaG2kgLC+wdk3HTw0FZZVhwo5UjM74sSGk4rcW8huYxqY/g8dUVQhEHEZafHk6vuJeL9+BjQDL9V++J4ZjuWRILyrIscdr8o7EguFnDpypfYKQdt2aPlJyHyJPkYnEnJrsc/jB7kvQ7XtY/7oDsKddA+RSwnnxkB2XSwyZZVSvMZHqIevfr7PNBIwSrevYnsSFRsW0Efv4tUUsS3t77nFxt1tphDR3wxftatFhZDdwfgdzEuXk5YtmqVlZQRYd/pM2ieN1eQprQJxHNboOjANl353clKpU5rxp6tw70iaiTPWajmUAmZtPOTNJH/tfQruMde4yjgFCyr3rwXSHvdfkSZQ1eOrMs3BYJNlFc3Z4tuqtMQxoKKy/V3D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3835.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(39860400002)(346002)(376002)(396003)(31696002)(31686004)(38100700002)(86362001)(8676002)(36756003)(66476007)(66556008)(66946007)(4326008)(921005)(316002)(83380400001)(53546011)(6666004)(26005)(6506007)(478600001)(41300700001)(54906003)(186003)(6486002)(2906002)(2616005)(5660300002)(6512007)(7416002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UHh2UWEyTmN2ZnlDRkFwNkFCbDJTVEUwbFdHZG9GajZuaGZibUR4Um8zWXJZ?=
 =?utf-8?B?RXNJei9GaGorQ1NWOG5kRWZjQ0hNM2QrdU5RK1Z3eUJJczgwTlNCd045MHdW?=
 =?utf-8?B?aWlFVldzd0Z0d0FmV2Fsc2psUlc1Q0xLRElTRWVkNmdLcUpoVDIycVpuem9J?=
 =?utf-8?B?SmlaWEpLelNWOE45QkNKb0tqalpTMFpSSFo2Q2FUcUpxQ0d5OHY2cS9pR0lE?=
 =?utf-8?B?aHdoTGNqZGI0T09wZzlwZjZuWFNTWHIwQU02aEgyVkt0WGZFbUs4UjRjR05i?=
 =?utf-8?B?M3lmWWdkWDR5cjdTdG5PYUQrWFljK0lVb1NFNHBUcXcyTVRxTVVQaTd6anpL?=
 =?utf-8?B?dmxxOUUwbDlXQTFTYmpiQ0pHcmRnQS9laEhDYkFyVFM4YW5Sa3B3RDExaC9w?=
 =?utf-8?B?c0R4RUx4OEV0MzIyQ0pxRkk2dVlNTzYxQVp3L21mdmRpQUx5T01YeThybEcw?=
 =?utf-8?B?alNNc2ZUQ1N1WDJNY1Y5Qm13UkJhT2FyaTF5ZW9TUFpYOGNFQW43VzJOcmtU?=
 =?utf-8?B?cTI5d0pxVWZGcHpIVmlCUjhPblo0WGc3ZHdRVS9iOVkyWjJJM01Tb3didm1E?=
 =?utf-8?B?czRXcXQ2aTFkODhiRnl3M1pTSVowbVl5MUhNQnJtSkZTOVdDZ05pUlIrd0My?=
 =?utf-8?B?MzQwVTd0N2Zxb1hCUTI3UnhoVlZZc1hFdExPNkUxZUJ3bU4vUzZ0dUVyak9P?=
 =?utf-8?B?NmRWeHlRYmQyUzhTTzNLVW9Fd09WMlBtNEROWnFxMENiTkZTbTlaRlB1cFZD?=
 =?utf-8?B?MkFqVDFjTFFZU0RoVnYxbkJyY0MzUmNsQjV6MlVtd1krdW1VeVpYaWhrRUlB?=
 =?utf-8?B?WDRFMWR4eWhLTkxBR1NUdVVYRGpYdkZIK3pvZWpwdk1mc08xbVZMeFRmYWZI?=
 =?utf-8?B?V2JrYytzN2s5Zm4yQnNFb2RqSmFGKzE3c1ZGYWZSaktYRWtaSzJwT2x1aUVo?=
 =?utf-8?B?YVg2VzNOcE1iaHEwcUtROFRJZ1JVN01ka2FCbEJNMk9JSEt5WGNueC84cVFY?=
 =?utf-8?B?aDJLSWRHeXFUYkN1bnRSU1Y5TWgzWGpoVm93YkJ1Q2xCU291djJpYURnQmxB?=
 =?utf-8?B?aVZZMHV3TE5yWjNINXY2RXdsV1FDcG51c3R4OEhBdlN0VUpOaGFLRUtiQ0ZK?=
 =?utf-8?B?RDNuSjI1RFh5L0M5YjY3eGdqTE1Ba215WGsyVGJRRjRWWnM2bnQraVBjdDdE?=
 =?utf-8?B?U1VWcURXRVVYVUk0TUc2SHhaS1pQWFZoeVczVGo5UEV4VW55M0MzcnZlMk96?=
 =?utf-8?B?Y21KMkpxV0FNMUVjTXBpMUtSenc4WlBqcGp1dDdzY2YzRlhjUkNBQ3VoNlZJ?=
 =?utf-8?B?aGkyK2QrV1V5MEhWTVdNbkxCdHRoZnh0MndIdUZ6ZHpyRlJ5aFNBL3FaZGYz?=
 =?utf-8?B?Vk8zR1FVSUJhT0p4RURFcFE2dnF3R1Vsc0RZbUlNWUt4ajNENnR3R3FHVEQv?=
 =?utf-8?B?aXJyaXgwWjhaYkQ1UjlQN2hLZkhUSHBsc09CNFB6dy8wSS9oV3FzSUl1S01s?=
 =?utf-8?B?UUpzeTRqOFArYXVQdW0rWDZjZjdabUw1elNSVW11bDlTSEo4RHl5YnVueWxy?=
 =?utf-8?B?emc5aS9LeTdhZjgzQXhMOEFrSEdhT2NOd2NzR2MzMC9BS0J4TGk1T21GMjBC?=
 =?utf-8?B?QjVJVUdMcXhxcEdXRm5MQVJheVJabG5GSEkyU0s0YUFqUlliSXh3bFduT25R?=
 =?utf-8?B?aXJVUFJmU1ZtdUU2NjNIMVBwK2JvbUdEWWhPRTBXSmtrWldVMmhSa3ZzZUtV?=
 =?utf-8?B?RmlUUXFSNGNjQUUwSWo4ZUZnM2h3cFIwZEVMRkp6NUdVMFpza2xzNHY4cXhY?=
 =?utf-8?B?amhtd1Eyc2dXREwxUjN1YklxTVdtSUZDZlpwdTBJWHBUZEdxbWdjQjhGbWZj?=
 =?utf-8?B?bmQ1L29BWFNPenBJTUplWVBPMEhGQ0lJc1hKZjl0Qy9sQVhXRkg2TUxxcUFx?=
 =?utf-8?B?SkRjL09GQnB0cjZNdGRxOC9vRFpQUURBUVZxcFpSVHBVQmlJTDdVdVc4Qjdz?=
 =?utf-8?B?MFVXUlNibTBmZy81aEhzeXhzM3lvQmIvcjRFd3FkSnFzUE44L1RrNU42aEtP?=
 =?utf-8?B?K3o2dHZWWDcxQkdSekZXL2p0bFBtWUdOSXdiOUNpVGdVZEFmZzFmYjZIYTQ0?=
 =?utf-8?Q?smDlPmdbkv9DbpGCTMvzg+Ua3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb6732f9-3c58-4181-3f4b-08da90813b5e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3835.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2022 03:29:55.0372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Zu+6sks7WefiIugvLIq7gg0+Gk2bH9bEycrQVzNs+CzLJDViiIsUM1Z+Be1uQW2kPG6b6PuDNBzRtSp2KgTmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5937
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


On 9/7/2022 11:15 AM, Gavin Li wrote:
> External email: Use caution opening links or attachments
>
>
> On 9/7/2022 10:17 AM, Jason Wang wrote:
>> External email: Use caution opening links or attachments
>>
>>
>> 在 2022/9/1 10:10, Gavin Li 写道:
>>> Currently add_recvbuf_big() allocates MAX_SKB_FRAGS segments for big
>>> packets even when GUEST_* offloads are not present on the device.
>>> However, if guest GSO is not supported, it would be sufficient to
>>> allocate segments to cover just up the MTU size and no further.
>>> Allocating the maximum amount of segments results in a large waste of
>>> buffer space in the queue, which limits the number of packets that can
>>> be buffered and can result in reduced performance.
>>>
>>> Therefore, if guest GSO is not supported, use the MTU to calculate the
>>> optimal amount of segments required.
>>>
>>> When guest offload is enabled at runtime, RQ already has packets of
>>> bytes
>>> less than 64K. So when packet of 64KB arrives, all the packets of such
>>> size will be dropped. and RQ is now not usable.
>>>
>>> So this means that during set_guest_offloads() phase, RQs have to be
>>> destroyed and recreated, which requires almost driver reload.
>>>
>>> If VIRTIO_NET_F_CTRL_GUEST_OFFLOADS has been negotiated, then it should
>>> always treat them as GSO enabled.
>>>
>>> Accordingly, for now the assumption is that if guest GSO has been
>>> negotiated then it has been enabled, even if it's actually been 
>>> disabled
>>> at runtime through VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.
>>
>>
>> Nit: Actually, it's not the assumption but the behavior of the codes
>> itself. Since we don't try to change guest offloading in probe so it's
>> ok to check GSO via negotiated features?
>
Above commit log description is incorrect.
It got here from an intermediate patch.

Actually, GSO always takes the priority. If it is offered, driver will 
always post 64K worth of buffers.
When it is not offered, mtu is honored.

Let me repost v6 with above corrected commit log.
Thanks
>>
>> Thanks
>>
>>
>>>
>>> Below is the iperf TCP test results over a Mellanox NIC, using vDPA for
>>> 1 VQ, queue size 1024, before and after the change, with the iperf
>>> server running over the virtio-net interface.
>>>
>>> MTU(Bytes)/Bandwidth (Gbit/s)
>>>               Before   After
>>>    1500        22.5     22.4
>>>    9000        12.8     25.9
>>>
>>> Signed-off-by: Gavin Li <gavinl@nvidia.com>
>>> Reviewed-by: Gavi Teitz <gavi@nvidia.com>
>>> Reviewed-by: Parav Pandit <parav@nvidia.com>
>>> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>>> Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
>>> ---
>>> changelog:
>>> v4->v5
>>> - Addressed comments from Michael S. Tsirkin
>>> - Improve commit message
>>> v3->v4
>>> - Addressed comments from Si-Wei
>>> - Rename big_packets_sg_num with big_packets_num_skbfrags
>>> v2->v3
>>> - Addressed comments from Si-Wei
>>> - Simplify the condition check to enable the optimization
>>> v1->v2
>>> - Addressed comments from Jason, Michael, Si-Wei.
>>> - Remove the flag of guest GSO support, set sg_num for big packets and
>>>    use it directly
>>> - Recalculate sg_num for big packets in virtnet_set_guest_offloads
>>> - Replace the round up algorithm with DIV_ROUND_UP
>>> ---
>>>   drivers/net/virtio_net.c | 37 ++++++++++++++++++++++++-------------
>>>   1 file changed, 24 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>> index f831a0290998..dbffd5f56fb8 100644
>>> --- a/drivers/net/virtio_net.c
>>> +++ b/drivers/net/virtio_net.c
>>> @@ -225,6 +225,9 @@ struct virtnet_info {
>>>       /* I like... big packets and I cannot lie! */
>>>       bool big_packets;
>>>
>>> +     /* number of sg entries allocated for big packets */
>>> +     unsigned int big_packets_num_skbfrags;
>>> +
>>>       /* Host will merge rx buffers for big packets (shake it! shake
>>> it!) */
>>>       bool mergeable_rx_bufs;
>>>
>>> @@ -1331,10 +1334,10 @@ static int add_recvbuf_big(struct
>>> virtnet_info *vi, struct receive_queue *rq,
>>>       char *p;
>>>       int i, err, offset;
>>>
>>> -     sg_init_table(rq->sg, MAX_SKB_FRAGS + 2);
>>> +     sg_init_table(rq->sg, vi->big_packets_num_skbfrags + 2);
>>>
>>> -     /* page in rq->sg[MAX_SKB_FRAGS + 1] is list tail */
>>> -     for (i = MAX_SKB_FRAGS + 1; i > 1; --i) {
>>> +     /* page in rq->sg[vi->big_packets_num_skbfrags + 1] is list
>>> tail */
>>> +     for (i = vi->big_packets_num_skbfrags + 1; i > 1; --i) {
>>>               first = get_a_page(rq, gfp);
>>>               if (!first) {
>>>                       if (list)
>>> @@ -1365,7 +1368,7 @@ static int add_recvbuf_big(struct virtnet_info
>>> *vi, struct receive_queue *rq,
>>>
>>>       /* chain first in list head */
>>>       first->private = (unsigned long)list;
>>> -     err = virtqueue_add_inbuf(rq->vq, rq->sg, MAX_SKB_FRAGS + 2,
>>> +     err = virtqueue_add_inbuf(rq->vq, rq->sg,
>>> vi->big_packets_num_skbfrags + 2,
>>>                                 first, gfp);
>>>       if (err < 0)
>>>               give_pages(rq, first);
>>> @@ -3690,13 +3693,27 @@ static bool virtnet_check_guest_gso(const
>>> struct virtnet_info *vi)
>>>               virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO);
>>>   }
>>>
>>> +static void virtnet_set_big_packets_fields(struct virtnet_info *vi,
>>> const int mtu)
>>> +{
>>> +     bool guest_gso = virtnet_check_guest_gso(vi);
>>> +
>>> +     /* If device can receive ANY guest GSO packets, regardless of 
>>> mtu,
>>> +      * allocate packets of maximum size, otherwise limit it to only
>>> +      * mtu size worth only.
>>> +      */
>>> +     if (mtu > ETH_DATA_LEN || guest_gso) {
>>> +             vi->big_packets = true;
>>> +             vi->big_packets_num_skbfrags = guest_gso ?
>>> MAX_SKB_FRAGS : DIV_ROUND_UP(mtu, PAGE_SIZE);
>>> +     }
>>> +}
>>> +
>>>   static int virtnet_probe(struct virtio_device *vdev)
>>>   {
>>>       int i, err = -ENOMEM;
>>>       struct net_device *dev;
>>>       struct virtnet_info *vi;
>>>       u16 max_queue_pairs;
>>> -     int mtu;
>>> +     int mtu = 0;
>>>
>>>       /* Find if host supports multiqueue/rss virtio_net device */
>>>       max_queue_pairs = 1;
>>> @@ -3784,10 +3801,6 @@ static int virtnet_probe(struct virtio_device
>>> *vdev)
>>>       INIT_WORK(&vi->config_work, virtnet_config_changed_work);
>>>       spin_lock_init(&vi->refill_lock);
>>>
>>> -     /* If we can receive ANY GSO packets, we must allocate large
>>> ones. */
>>> -     if (virtnet_check_guest_gso(vi))
>>> -             vi->big_packets = true;
>>> -
>>>       if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
>>>               vi->mergeable_rx_bufs = true;
>>>
>>> @@ -3853,12 +3866,10 @@ static int virtnet_probe(struct virtio_device
>>> *vdev)
>>>
>>>               dev->mtu = mtu;
>>>               dev->max_mtu = mtu;
>>> -
>>> -             /* TODO: size buffers correctly in this case. */
>>> -             if (dev->mtu > ETH_DATA_LEN)
>>> -                     vi->big_packets = true;
>>>       }
>>>
>>> +     virtnet_set_big_packets_fields(vi, mtu);
>>> +
>>>       if (vi->any_header_sg)
>>>               dev->needed_headroom = vi->hdr_len;
>>>
>>
>
> ---------------------------------------------------------------------
> To unsubscribe, e-mail: virtio-dev-unsubscribe@lists.oasis-open.org
> For additional commands, e-mail: virtio-dev-help@lists.oasis-open.org
>
