Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB96677830
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 11:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbjAWKFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 05:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbjAWKFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 05:05:21 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2062.outbound.protection.outlook.com [40.107.223.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5F244B7;
        Mon, 23 Jan 2023 02:05:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k1yuWHqo+2dtvjD53dHnVndWDkFLV0sPfMI94KxJqTGAvxYw8ALeHXhXtg1B2uLRFNldn/aDoI9U+t9vcTVUF71T0oyDwMKwGAZo1R5+spakIPqwKJSyzl/wqrZ2xn/yBoZBYbUQR0UZtqgL/xMHt++w+A8PpduMHb3YwPs2vF8GV+XnIRgjkBOYRGsPqwXTqN+QMzv5OTyJp2YcoaaeQRu7YBv7MiYC+bLENw83fzm789h8YZ+FeKCpQNc1yXldcYB5WB1VFR5Fz4pDuNK7KmHGoqUZ8/+GHWjMbXQ5gN6pOl4iwM8Tq3IFuqvvU+0vFcZ+YoPNIQ0mtP7xEzcMmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x0nkmUR4VXQrIGJAIf1zm+5jc/pUynbPplvtuaZZ4bY=;
 b=UHMXompsYVAuJa1pFtBtUYqmAT819h9/+tVGK3lMD7LKAeyxROUsUooq5P0MaTA5FGik2I0CBZ4o/AlWGNnP9BKLJMGBNnq1ix39R8xe5coM1ijpu9g3WnIlyCM34xQsvKkVXjzm2mGZi6QECA5J6ggkKmuMiMKSAydoEpc8/Pj03HtTQz2tjv89pOs93auts+30vwzPAv2vICrXcVGUaw7Oo6gQmgeODeeRm9FiAUsHvABXXc3KQWwV6+sTtnV9V2MxHiUvRrL7QKrf71x4HlqH9WAFwpJpAeoC6nU+2GVxoNnn3YGbFt/Gf7CbIqZlgbQkVoJeaEIA6ach1eUPUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x0nkmUR4VXQrIGJAIf1zm+5jc/pUynbPplvtuaZZ4bY=;
 b=aRwOSw4XAE60mhmzDMZ2JDoqBvxnwO8gPWAz1fm+NsX42Gk8OkhxFYMn7Lb9H7ZRl4u3rbN2r2XGxYpHCX8iArX9mNCFJNoUfUN9CM14NR8sMSaIU6D3p0fOd36RtlHhHjGJgBNVBMIAvtMse3h6UoIiBKaQP4Cfba+regjNeHxMDSoQoAE+IX65dJWMuVd7bIY8wP3/+oqSvx9lTSqxBFxNhixSxW4lZZVMYtYZhcUxazXAWrfnaPgCMgP5yEKp+AV+bbMimnyfZzJOKozTnEmmU1OdGqlQb/7zMBJd8ohCYoKsz8+KlHT6yPokkokvEIATV+LNctPG89iVai+kRQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM8PR12MB5400.namprd12.prod.outlook.com (2603:10b6:8:3b::12) by
 IA1PR12MB8079.namprd12.prod.outlook.com (2603:10b6:208:3fb::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.33; Mon, 23 Jan 2023 10:05:16 +0000
Received: from DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::70c6:a62a:4199:b8ed]) by DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::70c6:a62a:4199:b8ed%5]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 10:05:16 +0000
Message-ID: <920a779b-88f5-617f-792d-a174311b5b36@nvidia.com>
Date:   Mon, 23 Jan 2023 12:05:05 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 1/4] virtio_net: notify MAC address change on device
 initialization
To:     Laurent Vivier <lvivier@redhat.com>, linux-kernel@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Gautam Dawar <gautam.dawar@xilinx.com>,
        Cindy Lu <lulu@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>
References: <20230122100526.2302556-1-lvivier@redhat.com>
 <20230122100526.2302556-2-lvivier@redhat.com>
 <07a24753-767b-4e1e-2bcf-21ec04bc044a@nvidia.com>
 <8b80ac91-cf60-f5ff-a5dd-c5247c9c8f64@redhat.com>
Content-Language: en-US
From:   Eli Cohen <elic@nvidia.com>
In-Reply-To: <8b80ac91-cf60-f5ff-a5dd-c5247c9c8f64@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR08CA0146.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::24) To DM8PR12MB5400.namprd12.prod.outlook.com
 (2603:10b6:8:3b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5400:EE_|IA1PR12MB8079:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bb4165d-b122-4dfd-05d5-08dafd295375
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ibq9pAq29XOA8m2BQJvlav3VX47usQXcZS2EBtcajYAYycB5nCKn6HQ4CoSK4i7+1awBRoUCWguig5Ub0HSIE0Bdlvi7RoAa0rKoqTyqAoPt6hZP/VkERdcYUzvtfDyxzo5+BBmvofG/9fSuTN/eCU41XEoQ9gp41BA0gJw/1uVYWdl5AzfK7k7pn5RNEMvSuCzklX/Bf5wmcw38chZxCKRYTxk2mXcugoGOGzAlaZsYKZTvrk3Ukc/8Ta8MdeJ6gTELLbt/bybgUgaS2xe4C6kjTu+YiPSqgZ4jPiP79p5sH4o3nagg30gA41EWxpzIP9hdvegqVjcawd3xnd2DeuwDvjU7AvNeHtdlnj1zCNUR78dO/LZJce45Ur/2+obNswOPzFJCV12UzqPeGd7zMklbkfNcuvzYOAaePCdF6+jqQdRSJV8O0ls2mkRoKHWwV2jFG5KDGWTl2MygHywCQZneHTDB5d/cFv27QdUxIyuM3o+pXskQnOSzB+tn5JRz3Ta/MKm6TVGB5W/t2S43QJfT11U+OHLHzUqqiyWQMIn35VIv7SB6E0nTFHnn1+hjJszquM3n7jQNAfINOK9dpiK02zjeKto9j+yInR5eJaaKBzukH3GTp+gfrI2gLlp4i8boHOQmIhjIGzluafo8BZhgStDne2JcOnslJvPOaYTRQJ2QDgZdQFwyP7ivjwKPqc7xmgX50f9/CKMR3PfSTOlyNkWXSpe/baQcKoYxk0o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(366004)(39860400002)(136003)(396003)(451199015)(36756003)(86362001)(2906002)(38100700002)(8936002)(7416002)(4326008)(41300700001)(5660300002)(83380400001)(31696002)(478600001)(6486002)(31686004)(186003)(8676002)(6506007)(26005)(53546011)(6512007)(66946007)(66556008)(66476007)(54906003)(2616005)(316002)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TjdKUlF3ZTl3QVA3emNHOGNua0FRdXpIRUVzTnJOSWljN3JRQUppUmNoU3Fu?=
 =?utf-8?B?Mkk4L0N3QUZwbzJSb1QrbXo0aXJTWUwrenZscWNPalRUVENLTi9mVVJud2pX?=
 =?utf-8?B?aEJaNXAxekFqSk14SndsUy96SGtvSzVtRU5oSFo1dHhidnZCanlhK3VXb3Q3?=
 =?utf-8?B?UUJPQlJuLzhnTDBONDZDckFMeUlJTmpxaUlUSGtGcVljT3llV3NBNUN1Kysw?=
 =?utf-8?B?TlhKVUs0V1BkV3RQWFAweHRQWGFlTHJnTlVyM1Yxc3JUYWdueXc3TTIrN1Fy?=
 =?utf-8?B?Z3BEUEFTT3oxeDU2WnRkTW9PYUkyVzN4RXFmRDNFN1lubzczaFdBNlkyd1Yx?=
 =?utf-8?B?cFBJQVJscVIyaE1hYjlheVRESSt3cXZUNUJZT25DbExwYVNLeEdVbUpkY0dP?=
 =?utf-8?B?aFZ6U1J3MnhNWjVQZlJpZ0tsLzh3T0JHUzhKUGhONTMvR25USitSQXZubGhX?=
 =?utf-8?B?TWQ5bzZLNnY2clMwRm1ud0NyMWpZM21xZWxwUkJKbHkrSGlhclViNXB0ZTRx?=
 =?utf-8?B?bk5xRUNoYndadjZ1bGxEemFKblBzSnlwKzBTajJiblYxcUdKOUw0SzdnNjlG?=
 =?utf-8?B?bW5KdFNDQjk5T2pwYXFDSXRwbHhHODM3dWNCL3pLWjBhTDJBR3hwS21RUmtn?=
 =?utf-8?B?cHA0Sk9ZVkwyakNjMDhFVjEyd21LSkpkVkF6UENPUnVZQ2NkSDRWVWJjUFlm?=
 =?utf-8?B?L1lLVU5MT2tKMWpRUFl5bFhoOUduMDVsdTNwenRveSs1K0d4V0hDV3Q0c1R1?=
 =?utf-8?B?bVRVVzhZNXR4VGZSa0NPRlZCRktQZmZReGMxNHV4MDM2WUxZNm9wUVZ0Lzk5?=
 =?utf-8?B?ODVUdmZnWHBLMHZac2FxK0M0aVRBVEl0clN1NnBEMkpqemFqRkh2alhQalVu?=
 =?utf-8?B?WmM4MUMwMVdpb3F5d2dDSndJakNVdWMrN2t0QTNhZ0NPdXBLR0IwaEdYQTUx?=
 =?utf-8?B?eStMb0JvZ2FJQnBpNlhhY2w1RHVvMTB5ZEZ3cVJOMncyVmFQVDVpK3NWUzNJ?=
 =?utf-8?B?MU55YzVjeWVDV3ZEcHNuV0pmMmRHK0p6WjBOYWErYjNiQzVERllyOU1pTjN1?=
 =?utf-8?B?NjdNcjIwWGtJbW85NlF6MEdUM25xTjB1MHlSZjFicHVUR01sNFZuUS9namMv?=
 =?utf-8?B?WTgrTU0yRkluVFV4QzU2TEhFaGd1M1E1VHl1OWJxblpkVXQ5TCtTdTdYQmUr?=
 =?utf-8?B?K0E0SFZka25FNEsvenFneXpBVFg1a0t4UXZncmlOWVZOMSs5cjFOWlNybWpV?=
 =?utf-8?B?Y1NtMmQ0KzFES2NENGliR1JBSzI4S1ZDcWpyYi9JRTExeDhCU2l6SU9tM0sz?=
 =?utf-8?B?YTFzYjUvWVFQdnBUK3JZQnJ3TmtIVENDblRkK0MwMHVwdVlFYmJSOU1SNnYr?=
 =?utf-8?B?OURkT2hBNWNpejRhTXh4clZ5a3VWVGdSMStSRUVIZUF5Z1F4YTRHM0h4Z0hy?=
 =?utf-8?B?OEorNVdvWG9PMkFHeUJFOTd6TjdleTZFNDdrMmE0dkxkbnhYYzgxRUxMSkJM?=
 =?utf-8?B?bGVIdUJHT2k1cWpyMUxTNVVQN3lzY0F1WDU2eU9ndlN4bkdsWFpjVmp6dnpL?=
 =?utf-8?B?WTdNQXcvNEl1L0c4R2tVYTd2Rm1TUmgwa3Z3Mmo5YWw0Zk92bzdLU0RVa3pC?=
 =?utf-8?B?WG1FZ2tzZ2srTXBXOWlZTGY2ZWZudDZuSVMvSG9kZ3ZqYStpMkZRVGN5NDlE?=
 =?utf-8?B?R0RickJiVGR0M3hRaGtCREpsNDFSREpIV3lVZVVURkE0UnBFSS8xU2lkT1ow?=
 =?utf-8?B?NXBzMWhUdDE0RlBnSkFOdnMzdDVHc05TV2RXZ1luci93azZFVmpmclB1NnV1?=
 =?utf-8?B?YitBdHFHeE5vVUk3cWhDclgrNFhINC9SejhUTlN0U09hNVZma04yT09ERlhs?=
 =?utf-8?B?YThvaWJaSitqQ0FHOUx0blh5VlJXcGhuRmxPb29qcjdmWFpqbXMxVU4wRmdJ?=
 =?utf-8?B?WFpyTDdRMVkvY2ZieWFnNG1jZFlubjhJelZRUzhuUDRCTkZVWUxJV2Ftdkhh?=
 =?utf-8?B?VVFTVVkzY0FmdVNDZVdqaEtJYzVXbFpqZHRiNHlzbm9nQkpBV0RWaHA1L0l6?=
 =?utf-8?B?T0NzaGxTZDFDc2NsY0g5Qm5xQTBpeVIrTWYxemJ6NEpQeWM2MDFPTjRBbVlx?=
 =?utf-8?Q?zDNugiu1/RGQ9JAwbE35jhbfO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bb4165d-b122-4dfd-05d5-08dafd295375
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5400.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 10:05:16.4678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Haq/HI493T+/qPtPBWkAOudRpJJN8eadkaUmB/B3bLMurELIJ8j/DJ2M17ASyYTv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8079
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 23/01/2023 11:52, Laurent Vivier wrote:
> On 1/22/23 14:47, Eli Cohen wrote:
>>
>> On 22/01/2023 12:05, Laurent Vivier wrote:
>>> In virtnet_probe(), if the device doesn't provide a MAC address the
>>> driver assigns a random one.
>>> As we modify the MAC address we need to notify the device to allow it
>>> to update all the related information.
>>>
>>> The problem can be seen with vDPA and mlx5_vdpa driver as it doesn't
>>> assign a MAC address by default. The virtio_net device uses a random
>>> MAC address (we can see it with "ip link"), but we can't ping a net
>>> namespace from another one using the virtio-vdpa device because the
>>> new MAC address has not been provided to the hardware.
>>>
>>> Signed-off-by: Laurent Vivier <lvivier@redhat.com>
>>> ---
>>>   drivers/net/virtio_net.c | 14 ++++++++++++++
>>>   1 file changed, 14 insertions(+)
>>>
>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>> index 7723b2a49d8e..25511a86590e 100644
>>> --- a/drivers/net/virtio_net.c
>>> +++ b/drivers/net/virtio_net.c
>>> @@ -3800,6 +3800,8 @@ static int virtnet_probe(struct virtio_device 
>>> *vdev)
>>>           eth_hw_addr_set(dev, addr);
>>>       } else {
>>>           eth_hw_addr_random(dev);
>>> +        dev_info(&vdev->dev, "Assigned random MAC address %pM\n",
>>> +             dev->dev_addr);
>>>       }
>>>       /* Set up our device-specific information */
>>> @@ -3956,6 +3958,18 @@ static int virtnet_probe(struct virtio_device 
>>> *vdev)
>>>       pr_debug("virtnet: registered device %s with %d RX and TX 
>>> vq's\n",
>>>            dev->name, max_queue_pairs);
>>> +    /* a random MAC address has been assigned, notify the device */
>>> +    if (dev->addr_assign_type == NET_ADDR_RANDOM &&
>> Maybe it's better to not count on addr_assign_type and use a local 
>> variable to indicate that virtnet_probe assigned random MAC. The 
>> reason is that the hardware driver might have done that as well and 
>> does not need notification.
>
> eth_hw_addr_random() sets explicitly NET_ADDR_RANDOM, while 
> eth_hw_addr_set() doesn't change addr_assign_type so it doesn't seem 
> this value is set by the hardware driver.
>
> So I guess it's the default value (NET_ADDR_PERM) in this case (even 
> if it's a random address from the point of view of the hardware).
>
> If you prefer I can replace it by "!virtio_has_feature(vdev, 
> VIRTIO_NET_F_MAC)"?
>
My point is this. What if the hardware driver decides to choose a random 
address by calling eth_hw_addr_random(). In this case 
dev->addr_assign_type = NET_ADDR_RANDOM is executed unconditionally. But 
now you will needlessly execute the control command because the hardware 
address already knows about this address.


> Thanks,
> Laurent
>
