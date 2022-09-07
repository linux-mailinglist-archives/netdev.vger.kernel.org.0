Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3DC55AFA7D
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 05:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbiIGDQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 23:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbiIGDP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 23:15:57 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2082.outbound.protection.outlook.com [40.107.94.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F063D7B1CC
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 20:15:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Avd/XlCbZLeYs36TqYkgm1VCBWFpJ6T2Lf0y1ZxhxcufzvnsupZ16/xnw14VligFKYgHh05rClFkZ9K5dBnMF1krT/IQ7/LGfO6ZB/UzW3eJqVINvueZfYNW2sMFNtlv+mqBmLNdShooXAlp0GnuORcLePt/zmVbtIW/yesclFyH1FRuXzgzVM2v1PSKMJHyLMaOaLxicHYiwXo1eDJ6E4NMNJ4Sf2Wi78cWf40zE1FZ62RjpW4RrsNiuQvYxzDMtcBuEtdmDqRh6CBr/qeXkG6XGuI759lHnyOVHjxfT6zb8g+l3hKJk15SKxh2VlNSfC2Tt8SRhnG+Ud3FU9IE3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8nzmO66cj9Vls2dcKzg5rfeR6dR7bTlnStnV2amwnkw=;
 b=DDcnWvOIXnW5AmQ438yGDKfgOxkZ4fHTCPY5/o0MrGjp2MuSaUkAGnCrIbZb6UhUauELFneeQkeafo2ucCLNyFT9d8RrHh6ZKBYuH/D2jQ3bIbQ8kwUUxAzxNpp2hco2YqNlTi34r/mU9zxfrhRtdo/Pb4165bYgAYocmKdggqzQ/cTHGl1njpodtYUG0t+p+iSac/4JlLrt+Mofw7CIUeV/PZeFZqwXgVezACyKlbzXkkdNtBl7ousjEtKQ9fY43+6W+nF9i7XvdIsCYyXvlTw2qIFK9nvgQb51xYIUM06dOrEq7sw6xyvgLxTCygfbgLTrJldtrR5UXwgRT3PyYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8nzmO66cj9Vls2dcKzg5rfeR6dR7bTlnStnV2amwnkw=;
 b=aIRF58YcDEuxKPT8afaVk5FZ7r+hiXYbQ/A1LWyBTFJcCh53h/2JqPU5bLTD9hNUUXFi/rmW3L7fQdXUXdEZed4frz6jgAxpqeHqzMRicqN9pd9TDFntfhBwEwvWpkofIAOEELWvowZnIKE1ICgi5d4bGOuwHwogVI3dhwylEiVCNJiBnAT3fK9x+1GJ5bYiBN8pdoTpUaxw0deiiOQTYr+8VavRaNsxmD01eAxBbXJKJGHdgMBCERgS1fta9eHXLvQ4EMZc8jCdI6y8ymJao8cL3w8NjLI4r1IefaD71f2OC02rjrw5iCvn2I83fci8oic0aQpGoBZA7liIlUuYMQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3835.namprd12.prod.outlook.com (2603:10b6:5:1c7::12)
 by CH2PR12MB4953.namprd12.prod.outlook.com (2603:10b6:610:36::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Wed, 7 Sep
 2022 03:15:54 +0000
Received: from DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::c4ee:2739:5cbc:4f7c]) by DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::c4ee:2739:5cbc:4f7c%6]) with mapi id 15.20.5588.018; Wed, 7 Sep 2022
 03:15:53 +0000
Message-ID: <c487d07a-55ff-a49f-79d3-bf7dbf480127@nvidia.com>
Date:   Wed, 7 Sep 2022 11:15:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [virtio-dev] [PATCH v5 2/2] virtio-net: use mtu size as buffer
 length for big packets
Content-Language: en-US
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
From:   Gavin Li <gavinl@nvidia.com>
In-Reply-To: <a5e1eae0-d977-a625-afa7-69582bf49cb8@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0125.apcprd02.prod.outlook.com
 (2603:1096:4:188::13) To DM6PR12MB3835.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1068096e-e9ee-43fc-156a-08da907f4580
X-MS-TrafficTypeDiagnostic: CH2PR12MB4953:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kx8sixCIH85zq4M2XyFogDdriS2OJ96X3XRILHDALeCOrImj2AW6cXC/k5cGrV1/Rl/qbCtmQpMuoluTjGhy6CKCFJU0sRp/oIQ3bYURJ3zZQxfk5OPuY/7qyW4v4X4eWMD4wWvsX3/pB7pk6xqU7Kr10YL/3dzCQ0h+vtULSwUbHbi1SiUCJt34YB4j9TG7zr96FpGmfAaZUCcuTlBC3MZgsnQXG6fQ0c+vrOPgH9AA+rqFwy4T8twfJisq/m5nUHeCmWmzmy7YA7WdrBCdCIues3vPugl4yAsERkLqr336WM82zptrzWQuBN5hO4fEvuEljVcWGSqXCkX8MRbRze9Us+POVDU2xHNhQIwkYnAVpcwTBTCitwvpJR6YwRdkAf+yfmKlC7E9LObgWSyEpw+cJqnJy9q5fvAyS4/8MyegWPEJtS+YO0/KkPu2kOxyUjrfJKOH9dwlyhwBvObKGvqXX8xg3YMfLLy5s43dU1nDxYR4pNmYcW8Xw5KEheff5qrFax8pmdZ1Xakux56AMfFrj1R34QL9ft76/COq6mHxaamN0yNK5Xm1X1dHxKBVK/KD8J1yU4nGvPaJT0sp8/2ISmRkK8YaRUN60SH995X/tsK9uJVrvFYjnhxpvrsEx4DBuL0QRGNWhW+NJhJaEg2M4IefckM3Um8QqgTDWWGHyLquO/7bW4g4lLKSAu9ChDp1wKjhUd/j/U2LAEweTmPEBXw850oAKlcC/NO350JwJQiqFgdME9zU26RKCGkNzq5ujf09BGlj4npJgU++1/0laXb/p+hE4cyHtbjhJ2qeCbDfxosaEVz4tLzwjznO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3835.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(136003)(366004)(39860400002)(31696002)(6486002)(2616005)(38100700002)(186003)(478600001)(6506007)(41300700001)(86362001)(53546011)(6512007)(6666004)(83380400001)(921005)(26005)(54906003)(316002)(8676002)(8936002)(2906002)(31686004)(4326008)(66476007)(66946007)(36756003)(66556008)(7416002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SGFsUE9lS3VUT2VXeCt2SmhqenJyZXB0L3ZkRWNyWG1kYmQxWFU2WWJnQW82?=
 =?utf-8?B?ZzM5NWxPd3ViV0NNei85aHg0STZuQWZETUhWNjlGdTVXRzRuWEh1d2tJOWhX?=
 =?utf-8?B?Tk9EVVFPckpOK1ArWS9UbWVNai9HbGxjVStBNEllNDZ4SW1IQjRVeG45d1g4?=
 =?utf-8?B?ZkFDTi9DWERtTDViVTVJVlhFaC9jbXFrYW12R01ZQm1mNU1zdDJ1aUg4bGJ2?=
 =?utf-8?B?dlJhejFseHBldHRLekE4d1llaVpjUU00YjdYakxzTCttZzRSdlU4T2xaY28w?=
 =?utf-8?B?aUozaVNwb0hrbk5uNlo2Y0t6ZTZqWU1PUXdpMTRyNjc2Y1UydE9MSzRacGlY?=
 =?utf-8?B?RUJ2UGdNYmFTTks2UXlLU1l0LzJkVXo0OE9laHB2OTZMVzN3SCtyVFlwMkNR?=
 =?utf-8?B?Q3JFQ2VDUmRWYlV6aW5Cb2h5bXhLV0ZXTEh5OFJYRFJ5Um03ekZhemljR3hp?=
 =?utf-8?B?Z2JneUcybXVVQjQ2d29uVDhFVldoL0s2NFB0QS93YTB4bjRIOW03ZUVKbUh5?=
 =?utf-8?B?Ym1EMjNNNTVWU29EeFhvWjZ3TDhRaG5MMWNDV2VEeUtsbDAxQ3Iwb0srVjA3?=
 =?utf-8?B?b3Q2V3NNZEtVRnVOZUdEd0hZMVlDTS9HdWhwa1Q3ZkVnYW5tMXhrTHoyVUVm?=
 =?utf-8?B?WGQxVFZ6K3N2MVptbm14TmRUTUFXd1Z5U1dqb1E4bTdZRlBlMEprYUpQTEVV?=
 =?utf-8?B?a2NGL1FQc0dEOG5nRU9SYmszR3BkRTZGRFRlYjZ4V3A0d2MrM0RyMkRudVBH?=
 =?utf-8?B?U2dyZzZQd2RvOFhWTHl1YjBOMjZqSG16MlFheWxKczRXU214Y2FNTjNVYjht?=
 =?utf-8?B?b2Qwcy92TzRZRlQyZHRCd1FOSjFvQnNhYmRNYUlHMDBWdVZsMm1tRWZIZlI3?=
 =?utf-8?B?ZXdoeFlQUkVjU0VtdkY1NzNaL0x2VXlSV0YydmJmb3B6eXhRdkNHdE9VUXlS?=
 =?utf-8?B?aXMxZ0pMOEcvQlR2RDQxdDhzMWtaNWhVSDV6Mk54WEtOUUlKL1h1RC9oZGVt?=
 =?utf-8?B?d2ZkTko3Z3RlQVd3TG9BRVIwVGp2OXZRK3hSMU8vdlJqckNqVlVEdE1TUU40?=
 =?utf-8?B?cmZCcHVKSWIxN05XMHhRcVZncEZxYWVrK28yNzR0VHJTMnpCckFpc21WZVNk?=
 =?utf-8?B?TEVZMEg3cXRXVTlxK2tJQjNYVUpmcEQrbVd6YXJEVWZ4VUpHb1MzckZxc1Y4?=
 =?utf-8?B?NDRjYUMzdENwcHNJcEl0YTUxNVhIckIzZG1MRHEzTlQvMXVMai9vTnVyN2hj?=
 =?utf-8?B?UVI2NWFFenphZ3JNekxGL0xQWGYralZVcjdaakVhYUVDRDRaTFgySUR5Vmpk?=
 =?utf-8?B?ejY3OUk2R0hNcXBQQlk2bEkyV3AxNWM4QmIvalQ4MDF4ZGJOdFlxbzhuNDZv?=
 =?utf-8?B?VnNxNHhZVmdoczZKL3I4Ym1aUmV0M1dhcTAwSy9kcWFwRHBFQzM4UCs1YW02?=
 =?utf-8?B?UVlONjVMVzdPRVlZRVlBZXBnbGpTOWJuUWVRd3NkaEJQYS9oVDJkSDZUb2FZ?=
 =?utf-8?B?Zm1OZmdVbTk2UUZPb0drZUwzV1BjTTJpUUVnNFltN2lRUjdFZ0YxN0dRdjA5?=
 =?utf-8?B?aGpndERrZTU3RG1PR1hPR3hmSS9oV1U0cXRUTXpEQ3hsU25iNSs2UDdxblpp?=
 =?utf-8?B?S1AwUGJ3bHhXUEtFZjlVK21PelJ2MjR4MThvR25KMVNrTzBLczU3ZUt4YXg5?=
 =?utf-8?B?NGtkS2dZOG5JOHVKT2czaUEvWE1ha05sNkJuTERFbVZoblZRZWJ3azFTUVhi?=
 =?utf-8?B?Q05tOTY3RlQyc2Fhb3Q3MXRUN0twVytzaHlrbjlicEc2NVgwYmV2MkRNb3Mz?=
 =?utf-8?B?M3MvQkU4RDRPS2ZhQk9PSFpJN1pIUGJKOTgzMHZIQXJSVmpMeW5HTkpqRWdo?=
 =?utf-8?B?eFRsSnl3QmhCUmJLeG0rdG5VZnlLcVoxREwyYVhENkRMZjRrLzBjalJ6ZDBQ?=
 =?utf-8?B?aURSZDAxS1AvZm1TZEtkY0RtQ3lNWVF3SFFHNy9oWnFVSkZjZGhlRkVvVm13?=
 =?utf-8?B?YVRkK1JrTVJwOXBGcHZHRFd6UE9ZSmVUbWx0U2toZG9pMXJlYkl4TVFObVdX?=
 =?utf-8?B?d1JIZ3JIS0x1NjRYb3BIc0dSZTJSUTdHellLNGRmTVU0Ui9KZlJPaWRKcDV4?=
 =?utf-8?Q?V7As6CbTuqUzNT5Ur9utKVN3q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1068096e-e9ee-43fc-156a-08da907f4580
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3835.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2022 03:15:53.9176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zqOEyM4t2BcYVkbnrIcgw3+XbbJRZue42k6Zx0KluIDdCVfpEoI/mo1LlZT6CLH1/f4AuJTlb+vYSSwhRHXC1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4953
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


On 9/7/2022 10:17 AM, Jason Wang wrote:
> External email: Use caution opening links or attachments
>
>
> 在 2022/9/1 10:10, Gavin Li 写道:
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
>> Accordingly, for now the assumption is that if guest GSO has been
>> negotiated then it has been enabled, even if it's actually been disabled
>> at runtime through VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.
>
>
> Nit: Actually, it's not the assumption but the behavior of the codes
> itself. Since we don't try to change guest offloading in probe so it's
> ok to check GSO via negotiated features?

ACK

Should be

>
> Thanks
>
>
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
>> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>> Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
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
>>    use it directly
>> - Recalculate sg_num for big packets in virtnet_set_guest_offloads
>> - Replace the round up algorithm with DIV_ROUND_UP
>> ---
>>   drivers/net/virtio_net.c | 37 ++++++++++++++++++++++++-------------
>>   1 file changed, 24 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index f831a0290998..dbffd5f56fb8 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -225,6 +225,9 @@ struct virtnet_info {
>>       /* I like... big packets and I cannot lie! */
>>       bool big_packets;
>>
>> +     /* number of sg entries allocated for big packets */
>> +     unsigned int big_packets_num_skbfrags;
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
>> +     sg_init_table(rq->sg, vi->big_packets_num_skbfrags + 2);
>>
>> -     /* page in rq->sg[MAX_SKB_FRAGS + 1] is list tail */
>> -     for (i = MAX_SKB_FRAGS + 1; i > 1; --i) {
>> +     /* page in rq->sg[vi->big_packets_num_skbfrags + 1] is list 
>> tail */
>> +     for (i = vi->big_packets_num_skbfrags + 1; i > 1; --i) {
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
>> vi->big_packets_num_skbfrags + 2,
>>                                 first, gfp);
>>       if (err < 0)
>>               give_pages(rq, first);
>> @@ -3690,13 +3693,27 @@ static bool virtnet_check_guest_gso(const 
>> struct virtnet_info *vi)
>>               virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO);
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
>> +             vi->big_packets_num_skbfrags = guest_gso ? 
>> MAX_SKB_FRAGS : DIV_ROUND_UP(mtu, PAGE_SIZE);
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
