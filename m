Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D79E65EC6F
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 14:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjAENJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 08:09:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232891AbjAENJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 08:09:24 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2073.outbound.protection.outlook.com [40.107.92.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89CED11C;
        Thu,  5 Jan 2023 05:09:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ICTNTH5bLt0jWwHgM0vO2+eAWLL3EDcLYoJ3y6PSj0goeTmffAigL9FS0vNDa3oecxDXls0S9l5UuEHHLYI587ixeWVDxfj9sg5YtFdQpET7tr64Ixy4TVV0qSUbM4cyTsN+OYQdrC9Cy69XmDQAZ1pAvKjvCJwo+Zzjkt69p9YCPm7P2WmSCehPYsvRC7ev0N6bmEV7hfEzYGsjoxjqsF0eOce2dSC9A2TOQcH18hdRVcD0vFrUH9+gC7Hj9M9+RvkPxYAsZOJB4KfzxHm6m0GOrnfeGwBX61B+WcBQtj2ogd+7GT+NetCNJ936hvfxNn9undD+p2aHEMdfIPYgEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v1DSLYWJZDmKq3FITzrbz8dblVJqCcKJVk0HplGojqc=;
 b=HR+CZd5p+0R4xGgrNptJG/7x/XqocE3kPMFSkNnRdDfynMhdQixnmcwA5YvwsIqyrYDO+LKoDkE2p9Iphurmx+Yyuh/TwO3qMxJvDivHTbU70Abr2JbIdCkn7Nhkb28FRH0GIXkzZNEOqKmau4KN6jNus/CbV+8kuOwK+YkmPHehUA0vsq+TGwaXB/4ExYfuJyVra5ERqmqf92nIF4XPql5y3XsfzfuHrKypSjHXMPMZGYe4Firwv/T5bzVG5K7MfSmCC5wD7zFCvJTbDvvXEQIV2dwXu9NyuHDb5aF5ubAu3hgLyYV/ov7OW27zpICkag7ZUvtL4u1aUh5J41NiRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v1DSLYWJZDmKq3FITzrbz8dblVJqCcKJVk0HplGojqc=;
 b=WyLdhJOt3pGFRllbsKaHOCV3rSIsxuk1DXImLs3ZGQdsYMki2ubU6EiOOlnW9Vy/ZRVDPZY3NQSvxGN4FhfUOu7O79mbOcY2e8nUKUUbOJJbW7gckJ06T7M9qtJVRm2YKJqi46utslReDnylttCN12MQO/RW1BCDb4qxJ0lUDv4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20)
 by MN2PR12MB4583.namprd12.prod.outlook.com (2603:10b6:208:26e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 13:09:02 +0000
Received: from BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::2e66:40bf:438e:74b]) by BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::2e66:40bf:438e:74b%9]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 13:09:02 +0000
Message-ID: <819d2d2d-c7de-b788-5de1-6754afb2aeb9@amd.com>
Date:   Thu, 5 Jan 2023 18:38:49 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 09/11] sfc: implement iova rbtree to store dma
 mappings
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     Gautam Dawar <gautam.dawar@amd.com>, linux-net-drivers@amd.com,
        netdev@vger.kernel.org, eperezma@redhat.com, tanuj.kamde@amd.com,
        Koushik.Dutta@amd.com, harpreet.anand@amd.com,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
References: <20221207145428.31544-1-gautam.dawar@amd.com>
 <20221207145428.31544-10-gautam.dawar@amd.com>
 <CACGkMEt+euNwg+DEYFMNhJGXm1v2UqiPx622F-=DARFB4CWavQ@mail.gmail.com>
 <6f3eb21d-4f2d-eff3-37d4-9731eacd4af3@amd.com>
 <CACGkMEtuamSSFvOXf6oBLtZ19sFEsq_2F5hHhOhG8AfOVFnqJQ@mail.gmail.com>
From:   Gautam Dawar <gdawar@amd.com>
In-Reply-To: <CACGkMEtuamSSFvOXf6oBLtZ19sFEsq_2F5hHhOhG8AfOVFnqJQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0102.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9b::23) To BL1PR12MB5825.namprd12.prod.outlook.com
 (2603:10b6:208:394::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5825:EE_|MN2PR12MB4583:EE_
X-MS-Office365-Filtering-Correlation-Id: af51a932-22db-4927-3069-08daef1e03c1
X-LD-Processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1BVTGPSmrfXPMSqe8rpvdBwI1pP7FqPAhg2s8OPbJo9iKhXv4w8RgZGKXah8OAmvGUi8vBtKFfvuSDNcepXTTBmn2uNZjku+HY8mOS/3dVs87kXQvZRYTToFE5oPUxkK2MQy26NNxYpJ5L7N6iGhId4NXT82EUvsL1EJESPuUkKZIvdvW9VNv3AICBoVRSfBHEWRqWQZEK45sM2uEglmwN1CP/2I5xaYcYVlIVOSsLGmJ+HXCGZlYgD0jbqU8OjNWVmDrExe7AjrNM4wDBewdGIsGcEvA7FgZgYcyKlZPPfDTIgATEzvrRxoxmDhVlQsx+zthb6HhDwjMeX7GLCI1Xx7JNlNshlUbsueCFHfd20R/xN8AKxSOvmcFu9kv+C0oqsl/NijY20y7Gb8l0IJS7SbZpyDq0W574UPZO2kvEyrrf/splGB99JiLCof9ySqymLFcBtCk4ae2irjrf/zYju8AwxbD1QT3C3dX0hwguifzrufvXzGn0vDlXn2WTZ+FwknsWCtW1Y3NsYtRZNKGkTlJGGI9ixx0VOXqG/GarENY/sRN9D1p40FQ7Z5nhVCEYrvmPsR+wgcUOlDm9mPQYjPXCxdHp5Fj2a4BbhSNtR55JYy6vaM3h+unPuGDZMhZdBEFNGezlmMw/h3sLJlTfw8wnSWieUrGOrh/m2Ew3qIOCsVT1aabH3/26vidG504GDPSE2rSg81OHw6lj2DacsGbEtZ4xLdC3N48/92lPS6SBydxFExp9XVY58YI7E7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5825.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(376002)(396003)(346002)(39860400002)(451199015)(6666004)(54906003)(6916009)(26005)(186003)(6512007)(4326008)(2616005)(66476007)(66556008)(66946007)(8676002)(31686004)(316002)(53546011)(6486002)(478600001)(6506007)(41300700001)(83380400001)(5660300002)(7416002)(8936002)(30864003)(2906002)(38100700002)(36756003)(31696002)(2004002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NzBYQjFJZlVtbFRhdVdRN05ITCtwRm8zWThYWW53dDFXenJnaHRoNjRoYzBD?=
 =?utf-8?B?dGpLeEwrMkJVTDhva2l0R0QvYjJwYitYSG1PZER6TkdlL3BjYnBMbkRlb3Na?=
 =?utf-8?B?RHN4and6RGtGSmNkTHdGZDJFQzg4SkxJRTZzYkRrQkZEQnZmMGhzSE9pQXA2?=
 =?utf-8?B?N1R4U2N3M3BGQTJTaFhrelBvbmJRU1NiVVh1TEtsUFZmM2ZmYjM5Y0tnR21B?=
 =?utf-8?B?VVZURjkrTDNrWWh0WXFVM0xLdWYxUHA3VVVIbnFROEgrVmtGa3ViMnp6NlFx?=
 =?utf-8?B?RkpjeWwvbllYNGJUeHJiL1hmdXk2bzZ2Rk1Rdjh6cjJHeElpbXBVcWtJVTdP?=
 =?utf-8?B?MCtTMEZHWVNsVldOOWVRcmZjdEExazVTcHV1Z0xlektyVnp1ODEzM1lrZmhr?=
 =?utf-8?B?R1Y1TW5raXJMR0VrRWVWSFF5UnBieVM3Q2dMUkRGMVhldW84WFZheGEyd1pi?=
 =?utf-8?B?RkNPd1JBdk8vbjZtQTUrdEFZbHRwb3FQWW9Yczd3aWs4UzJRVzJkQUJKSDNt?=
 =?utf-8?B?UHJSVTlEMmowRUQyMXdzYWVlM2R2Zks3a1dGcno5cGxHSno1NDMvNWh5Z2pM?=
 =?utf-8?B?SVlaRmtIclRYN1V6Z2w1dEFwRGxoNFlEaFJtdTVNZzhUNldkN09LNS82Q1pE?=
 =?utf-8?B?NG9iRkFKOTFLOHFSNU41RlhOa01ZVzc3Y0RPSG5GT3VsY3E1OHF4QlhVRVpU?=
 =?utf-8?B?RGZVMDdNZmNDazNxMTRGNzFpZGtZUlRIeVNPdjFuNTM1UU1oVEluSzFOUElS?=
 =?utf-8?B?cVJNUEt4YUd5enMveU94ZUJXMUNtN3N0SEljMDQ0cjNqb0V5UllwWHJ4WTRL?=
 =?utf-8?B?blh3dHhUZTdoTTBROW1UZ3hqZlNUZlZZWm42dmJWQTYwNWF2YzVEdEFQQm4v?=
 =?utf-8?B?ZUZDWFkzbVhpRytYaVRZa3I4dFlsNjlkN0RBcHY5SGZLNCtkWDVRLzdGQndT?=
 =?utf-8?B?aUh2T1FwN2dJVGpoMVEzaXlWS3cyUzBmWmdETEVVTitQVFlLMjJIT1RncTJV?=
 =?utf-8?B?WE8zWXl2YWhsWU9nVmNRRUdVd1lYQXAxTjk2Y24vYWtLdjd4SGZkVEVTT3Nt?=
 =?utf-8?B?aC9xUVo1eHRQMTRCS1ZlQzNZa1ZCNEpYYjl2cHRoKzNmWTRoRGRyUHViTmF1?=
 =?utf-8?B?UHRCa1NFemoyeW52YWtEdmNRc1B4ckEyY251V1U2K0Q5cUJSOFlUK3BPYnB6?=
 =?utf-8?B?VmFIN0xlc3BUc2VXSTZQUzIydENXeUxYM1NRenJWaVJmWDc5RjdST3VuZ2ZF?=
 =?utf-8?B?N1NRVVBZajA4ZlR0b0dEYlRVTHorbGxESklZWStqbU5UaWlQbVpGL3FoWXhK?=
 =?utf-8?B?TE5SZVZWUk90K2p2MEcxanB2OWl2clZ5UzFQc3lYMHBqd1RnZFVPcXdUamV6?=
 =?utf-8?B?ME1wNXY1QjdjRkI2WlVRd2hLNXlSNUVZK3h4cnpxV0QzSTl0WHpCTXZTb0Rz?=
 =?utf-8?B?Y0FRWm1ZYzVqU1IxU0NyNWtnSkNJWVVQU0FpbVVGTmpEMEdpcXBsdkhXdWcr?=
 =?utf-8?B?RGtuWTE0eTRVdmE1V0dUSHo0RkwxOWF0dERIclkvRUZ3YnluODM4UXg4MjRY?=
 =?utf-8?B?aUNybjJpN2twV25uckxYblFwWnVXUUVYN3lzSm5yMkMzbnhXMGtDbzF0Z1Vs?=
 =?utf-8?B?bFdRY2gvUUJpMGpmNzlsRmJJTkxoU0tDWE5BbW1Hd3FQeWtielYzR3B6dlJ4?=
 =?utf-8?B?V3hJd2pOdlZpaWIvc0dMbW5Za09hdVMrQVZmRGt3VDB6dmFWNkhpUVByZTVr?=
 =?utf-8?B?TmYwQ1dKRUx3RC9tQTZSY3NFeWI4SVlMQzIwYkpvOUtXM0F5S3RTQldhYnlB?=
 =?utf-8?B?S0Z4ZzV2OHFsVGtMZS9ybkU5OTZScmJBcHNBeVhBZ2lrNzkwcUNUSG9Ha0hk?=
 =?utf-8?B?VUZEZVNoKzhyUjA5MW1qL09rWUlVbm9EKzZKR2twL2xNQXZEb0QweUZzVmZD?=
 =?utf-8?B?Y3RZSGVVU0tWcldrOGhJbHErZWdiVkp0V1VSVWdsUUJUVTRTTEVyRU1GTWtx?=
 =?utf-8?B?dHdIY2VXcXBJbjhsM3lGYk1WSGV4MzFtQUkxVjRpQ3hpS0dDWEFIQjhUSlox?=
 =?utf-8?B?SVhSVnRzMTBNZWNVWElSRHhxK21rcDFkT1VlelNwZm5vcXVxSm83cncrQTRL?=
 =?utf-8?Q?b2BS7Ofv+Fj/lpOqn0rGexneP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af51a932-22db-4927-3069-08daef1e03c1
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5825.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 13:09:02.1315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: klSWabUVni5vW+DgAwWHxpbJKUiWRSwOS7yodkJ0nmVrDkMcO0lnE47ikV2c9Kjw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4583
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/19/22 11:33, Jason Wang wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>
>
> On Fri, Dec 16, 2022 at 8:48 PM Gautam Dawar <gdawar@amd.com> wrote:
>>
>> On 12/14/22 12:16, Jason Wang wrote:
>>> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>>>
>>>
>>> On Wed, Dec 7, 2022 at 10:57 PM Gautam Dawar <gautam.dawar@amd.com> wrote:
>>>> sfc uses a MCDI DMA buffer that is allocated on the host
>>>> for communicating with the Firmware. The MCDI buffer IOVA
>>>> could overlap with the IOVA used by the guest for the
>>>> virtqueue buffers. To detect such overlap, the DMA mappings
>>>> from the guest will be stored in a IOVA rbtree and every
>>>> such mapping will be compared against the MCDI buffer IOVA
>>>> range. If an overlap is detected, the MCDI buffer will be
>>>> relocated to a different IOVA.
>>> I think it can't prevent guests from guessing the MCDI buffer address
>>> and trying to DMA to/from that buffer.
>> Yes, if the guest can guess the MCDI buffer address, it could use it to
>> DMA to/from this buffer.
>>
>> However, the guest can modify the buffer contents but can't instruct the
>> MC to execute the request. To cause any MCDI failure, the request buffer
>> needs to be updated when host driver is about to execute the request or
>> response buffer needs to be updated after command execution but before
>> host driver reads it. This would be a very small time window and hard to
>> guess for the guest.
> Not that hard probably, actually, the guest driver don't even need to
> guess, just leave a small space in its IOVA space then it knows the
> host driver will use that for MCDI. So this is something we need to
> address.
>
> Any possibility to let the MCDI command run on PF instead of VF?
We evaluated this approach initially but it needed a communication 
mechanism between the VF and PF drivers and also would have added in a 
lot of complexity in passing MCDI messages back and forth. Hence, MCDI 
over PF isn't possible.
>
>>> It might work with some co-operation of the NIC who can validate the
>>> DMA initialized by the virtqueue and forbid the DMA to the MDCI
>>> buffer.
>> I think this problem can be solved using PASID which will be supported
>> by our next hardware version.
> That one way, another way is to add a check before initiating
> virtqueue DMA, if it tries to DMA to MCDI, fail. This seems easier.

Can you please elaborate on this? vdpa datapath doesn't involve the 
hypervisor and the host driver as virtqueues terminate between guest 
virtio-net driver and the hardware. Even the doorbell operations are 
memory mapped and IRQ bypass allows interrupts to be delivered directly 
to guest vCPU.

Where exactly are you recommending the address check to be placed?

Regards,

Gautam

>
> Thanks
>
>>> Thanks
>>>> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
>>>> ---
>>>>    drivers/net/ethernet/sfc/Makefile         |   3 +-
>>>>    drivers/net/ethernet/sfc/ef100_iova.c     | 205 ++++++++++++++++++++++
>>>>    drivers/net/ethernet/sfc/ef100_iova.h     |  40 +++++
>>>>    drivers/net/ethernet/sfc/ef100_nic.c      |   1 -
>>>>    drivers/net/ethernet/sfc/ef100_vdpa.c     |  38 ++++
>>>>    drivers/net/ethernet/sfc/ef100_vdpa.h     |  15 ++
>>>>    drivers/net/ethernet/sfc/ef100_vdpa_ops.c |   5 +
>>>>    drivers/net/ethernet/sfc/mcdi.h           |   3 +
>>>>    8 files changed, 308 insertions(+), 2 deletions(-)
>>>>    create mode 100644 drivers/net/ethernet/sfc/ef100_iova.c
>>>>    create mode 100644 drivers/net/ethernet/sfc/ef100_iova.h
>>>>
>>>> diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
>>>> index a10eac91ab23..85852ff50b7c 100644
>>>> --- a/drivers/net/ethernet/sfc/Makefile
>>>> +++ b/drivers/net/ethernet/sfc/Makefile
>>>> @@ -11,7 +11,8 @@ sfc-$(CONFIG_SFC_MTD) += mtd.o
>>>>    sfc-$(CONFIG_SFC_SRIOV)        += sriov.o ef10_sriov.o ef100_sriov.o ef100_rep.o \
>>>>                               mae.o tc.o tc_bindings.o tc_counters.o
>>>>
>>>> -sfc-$(CONFIG_SFC_VDPA) += mcdi_vdpa.o ef100_vdpa.o ef100_vdpa_ops.o
>>>> +sfc-$(CONFIG_SFC_VDPA) += mcdi_vdpa.o ef100_vdpa.o ef100_vdpa_ops.o \
>>>> +                          ef100_iova.o
>>>>    obj-$(CONFIG_SFC)      += sfc.o
>>>>
>>>>    obj-$(CONFIG_SFC_FALCON) += falcon/
>>>> diff --git a/drivers/net/ethernet/sfc/ef100_iova.c b/drivers/net/ethernet/sfc/ef100_iova.c
>>>> new file mode 100644
>>>> index 000000000000..863314c5b9b5
>>>> --- /dev/null
>>>> +++ b/drivers/net/ethernet/sfc/ef100_iova.c
>>>> @@ -0,0 +1,205 @@
>>>> +// SPDX-License-Identifier: GPL-2.0
>>>> +/* Driver for Xilinx network controllers and boards
>>>> + * Copyright(C) 2020-2022 Xilinx, Inc.
>>>> + * Copyright(C) 2022 Advanced Micro Devices, Inc.
>>>> + *
>>>> + * This program is free software; you can redistribute it and/or modify it
>>>> + * under the terms of the GNU General Public License version 2 as published
>>>> + * by the Free Software Foundation, incorporated herein by reference.
>>>> + */
>>>> +
>>>> +#include "ef100_iova.h"
>>>> +
>>>> +static void update_free_list_node(struct ef100_vdpa_iova_node *target_node,
>>>> +                                 struct ef100_vdpa_iova_node *next_node,
>>>> +                                 struct ef100_vdpa_nic *vdpa_nic)
>>>> +{
>>>> +       unsigned long target_node_end;
>>>> +       unsigned long free_area;
>>>> +       bool in_list;
>>>> +
>>>> +       target_node_end = target_node->iova + target_node->size;
>>>> +       free_area = next_node->iova - target_node_end;
>>>> +       in_list = !(list_empty(&target_node->free_node));
>>>> +
>>>> +       if (!in_list && free_area >= MCDI_BUF_LEN) {
>>>> +               list_add(&target_node->free_node,
>>>> +                        &vdpa_nic->free_list);
>>>> +       } else if (in_list && free_area < MCDI_BUF_LEN) {
>>>> +               list_del_init(&target_node->free_node);
>>>> +       }
>>>> +}
>>>> +
>>>> +static void update_free_list(struct ef100_vdpa_iova_node *iova_node,
>>>> +                            struct ef100_vdpa_nic *vdpa_nic,
>>>> +                            bool add_node)
>>>> +{
>>>> +       struct ef100_vdpa_iova_node *prev_in = NULL;
>>>> +       struct ef100_vdpa_iova_node *next_in = NULL;
>>>> +       struct rb_node *prev_node;
>>>> +       struct rb_node *next_node;
>>>> +
>>>> +       prev_node = rb_prev(&iova_node->node);
>>>> +       next_node = rb_next(&iova_node->node);
>>>> +
>>>> +       if (prev_node)
>>>> +               prev_in = rb_entry(prev_node,
>>>> +                                  struct ef100_vdpa_iova_node, node);
>>>> +       if (next_node)
>>>> +               next_in = rb_entry(next_node,
>>>> +                                  struct ef100_vdpa_iova_node, node);
>>>> +
>>>> +       if (add_node) {
>>>> +               if (prev_in)
>>>> +                       update_free_list_node(prev_in, iova_node, vdpa_nic);
>>>> +
>>>> +               if (next_in)
>>>> +                       update_free_list_node(iova_node, next_in, vdpa_nic);
>>>> +       } else {
>>>> +               if (next_in && prev_in)
>>>> +                       update_free_list_node(prev_in, next_in, vdpa_nic);
>>>> +               if (!list_empty(&iova_node->free_node))
>>>> +                       list_del_init(&iova_node->free_node);
>>>> +       }
>>>> +}
>>>> +
>>>> +int efx_ef100_insert_iova_node(struct ef100_vdpa_nic *vdpa_nic,
>>>> +                              u64 iova, u64 size)
>>>> +{
>>>> +       struct ef100_vdpa_iova_node *iova_node;
>>>> +       struct ef100_vdpa_iova_node *new_node;
>>>> +       struct rb_node *parent;
>>>> +       struct rb_node **link;
>>>> +       struct rb_root *root;
>>>> +       int rc = 0;
>>>> +
>>>> +       mutex_lock(&vdpa_nic->iova_lock);
>>>> +
>>>> +       root = &vdpa_nic->iova_root;
>>>> +       link = &root->rb_node;
>>>> +       parent = *link;
>>>> +       /* Go to the bottom of the tree */
>>>> +       while (*link) {
>>>> +               parent = *link;
>>>> +               iova_node = rb_entry(parent, struct ef100_vdpa_iova_node, node);
>>>> +
>>>> +               /* handle duplicate node */
>>>> +               if (iova_node->iova == iova) {
>>>> +                       rc = -EEXIST;
>>>> +                       goto out_unlock;
>>>> +               }
>>>> +
>>>> +               if (iova_node->iova > iova)
>>>> +                       link = &(*link)->rb_left;
>>>> +               else
>>>> +                       link = &(*link)->rb_right;
>>>> +       }
>>>> +
>>>> +       new_node = kzalloc(sizeof(*new_node), GFP_KERNEL);
>>>> +       if (!new_node) {
>>>> +               rc = -ENOMEM;
>>>> +               goto out_unlock;
>>>> +       }
>>>> +
>>>> +       new_node->iova = iova;
>>>> +       new_node->size = size;
>>>> +       INIT_LIST_HEAD(&new_node->free_node);
>>>> +
>>>> +       /* Put the new node here */
>>>> +       rb_link_node(&new_node->node, parent, link);
>>>> +       rb_insert_color(&new_node->node, root);
>>>> +
>>>> +       update_free_list(new_node, vdpa_nic, true);
>>>> +
>>>> +out_unlock:
>>>> +       mutex_unlock(&vdpa_nic->iova_lock);
>>>> +       return rc;
>>>> +}
>>>> +
>>>> +static struct ef100_vdpa_iova_node*
>>>> +ef100_rbt_search_node(struct ef100_vdpa_nic *vdpa_nic,
>>>> +                     unsigned long iova)
>>>> +{
>>>> +       struct ef100_vdpa_iova_node *iova_node;
>>>> +       struct rb_node *rb_node;
>>>> +       struct rb_root *root;
>>>> +
>>>> +       root = &vdpa_nic->iova_root;
>>>> +       if (!root)
>>>> +               return NULL;
>>>> +
>>>> +       rb_node = root->rb_node;
>>>> +
>>>> +       while (rb_node) {
>>>> +               iova_node = rb_entry(rb_node, struct ef100_vdpa_iova_node,
>>>> +                                    node);
>>>> +               if (iova_node->iova > iova)
>>>> +                       rb_node = rb_node->rb_left;
>>>> +               else if (iova_node->iova < iova)
>>>> +                       rb_node = rb_node->rb_right;
>>>> +               else
>>>> +                       return iova_node;
>>>> +       }
>>>> +
>>>> +       return NULL;
>>>> +}
>>>> +
>>>> +void efx_ef100_remove_iova_node(struct ef100_vdpa_nic *vdpa_nic,
>>>> +                               unsigned long iova)
>>>> +{
>>>> +       struct ef100_vdpa_iova_node *iova_node;
>>>> +
>>>> +       mutex_lock(&vdpa_nic->iova_lock);
>>>> +       iova_node = ef100_rbt_search_node(vdpa_nic, iova);
>>>> +       if (!iova_node)
>>>> +               goto out_unlock;
>>>> +
>>>> +       update_free_list(iova_node, vdpa_nic, false);
>>>> +
>>>> +       rb_erase(&iova_node->node, &vdpa_nic->iova_root);
>>>> +       kfree(iova_node);
>>>> +
>>>> +out_unlock:
>>>> +       mutex_unlock(&vdpa_nic->iova_lock);
>>>> +}
>>>> +
>>>> +void efx_ef100_delete_iova(struct ef100_vdpa_nic *vdpa_nic)
>>>> +{
>>>> +       struct ef100_vdpa_iova_node *iova_node;
>>>> +       struct rb_root *iova_root;
>>>> +       struct rb_node *node;
>>>> +
>>>> +       mutex_lock(&vdpa_nic->iova_lock);
>>>> +
>>>> +       iova_root = &vdpa_nic->iova_root;
>>>> +       while (!RB_EMPTY_ROOT(iova_root)) {
>>>> +               node = rb_first(iova_root);
>>>> +               iova_node = rb_entry(node, struct ef100_vdpa_iova_node, node);
>>>> +               if (!list_empty(&iova_node->free_node))
>>>> +                       list_del_init(&iova_node->free_node);
>>>> +               if (vdpa_nic->domain)
>>>> +                       iommu_unmap(vdpa_nic->domain, iova_node->iova,
>>>> +                                   iova_node->size);
>>>> +               rb_erase(node, iova_root);
>>>> +               kfree(iova_node);
>>>> +       }
>>>> +
>>>> +       mutex_unlock(&vdpa_nic->iova_lock);
>>>> +}
>>>> +
>>>> +int efx_ef100_find_new_iova(struct ef100_vdpa_nic *vdpa_nic,
>>>> +                           unsigned int buf_len,
>>>> +                           u64 *new_iova)
>>>> +{
>>>> +       struct ef100_vdpa_iova_node *iova_node;
>>>> +
>>>> +       /* pick the first node from freelist */
>>>> +       iova_node = list_first_entry_or_null(&vdpa_nic->free_list,
>>>> +                                            struct ef100_vdpa_iova_node,
>>>> +                                            free_node);
>>>> +       if (!iova_node)
>>>> +               return -ENOENT;
>>>> +
>>>> +       *new_iova = iova_node->iova + iova_node->size;
>>>> +       return 0;
>>>> +}
>>>> diff --git a/drivers/net/ethernet/sfc/ef100_iova.h b/drivers/net/ethernet/sfc/ef100_iova.h
>>>> new file mode 100644
>>>> index 000000000000..68e39c4152c7
>>>> --- /dev/null
>>>> +++ b/drivers/net/ethernet/sfc/ef100_iova.h
>>>> @@ -0,0 +1,40 @@
>>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>>> +/* Driver for Xilinx network controllers and boards
>>>> + * Copyright(C) 2020-2022 Xilinx, Inc.
>>>> + * Copyright(C) 2022 Advanced Micro Devices, Inc.
>>>> + *
>>>> + * This program is free software; you can redistribute it and/or modify it
>>>> + * under the terms of the GNU General Public License version 2 as published
>>>> + * by the Free Software Foundation, incorporated herein by reference.
>>>> + */
>>>> +#ifndef EFX_EF100_IOVA_H
>>>> +#define EFX_EF100_IOVA_H
>>>> +
>>>> +#include "ef100_nic.h"
>>>> +#include "ef100_vdpa.h"
>>>> +
>>>> +#if defined(CONFIG_SFC_VDPA)
>>>> +/**
>>>> + * struct ef100_vdpa_iova_node - guest buffer iova entry
>>>> + *
>>>> + * @node: red black tree node
>>>> + * @iova: mapping's IO virtual address
>>>> + * @size: length of mapped region in bytes
>>>> + * @free_node: free list node
>>>> + */
>>>> +struct ef100_vdpa_iova_node {
>>>> +       struct rb_node node;
>>>> +       unsigned long iova;
>>>> +       size_t size;
>>>> +       struct list_head free_node;
>>>> +};
>>>> +
>>>> +int efx_ef100_insert_iova_node(struct ef100_vdpa_nic *vdpa_nic,
>>>> +                              u64 iova, u64 size);
>>>> +void efx_ef100_remove_iova_node(struct ef100_vdpa_nic *vdpa_nic,
>>>> +                               unsigned long iova);
>>>> +void efx_ef100_delete_iova(struct ef100_vdpa_nic *vdpa_nic);
>>>> +int efx_ef100_find_new_iova(struct ef100_vdpa_nic *vdpa_nic,
>>>> +                           unsigned int buf_len, u64 *new_iova);
>>>> +#endif  /* CONFIG_SFC_VDPA */
>>>> +#endif /* EFX_EF100_IOVA_H */
>>>> diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
>>>> index 41811c519275..72820d2fe19d 100644
>>>> --- a/drivers/net/ethernet/sfc/ef100_nic.c
>>>> +++ b/drivers/net/ethernet/sfc/ef100_nic.c
>>>> @@ -33,7 +33,6 @@
>>>>
>>>>    #define EF100_MAX_VIS 4096
>>>>    #define EF100_NUM_MCDI_BUFFERS 1
>>>> -#define MCDI_BUF_LEN (8 + MCDI_CTL_SDU_LEN_MAX)
>>>>
>>>>    #define EF100_RESET_PORT ((ETH_RESET_MAC | ETH_RESET_PHY) << ETH_RESET_SHARED_SHIFT)
>>>>
>>>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
>>>> index 80bca281a748..b9368eb1acd5 100644
>>>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.c
>>>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
>>>> @@ -14,6 +14,7 @@
>>>>    #include <uapi/linux/vdpa.h>
>>>>    #include "ef100_vdpa.h"
>>>>    #include "mcdi_vdpa.h"
>>>> +#include "ef100_iova.h"
>>>>    #include "mcdi_filters.h"
>>>>    #include "mcdi_functions.h"
>>>>    #include "ef100_netdev.h"
>>>> @@ -280,6 +281,34 @@ static int get_net_config(struct ef100_vdpa_nic *vdpa_nic)
>>>>           return 0;
>>>>    }
>>>>
>>>> +static int vdpa_update_domain(struct ef100_vdpa_nic *vdpa_nic)
>>>> +{
>>>> +       struct vdpa_device *vdpa = &vdpa_nic->vdpa_dev;
>>>> +       struct iommu_domain_geometry *geo;
>>>> +       struct device *dma_dev;
>>>> +
>>>> +       dma_dev = vdpa_get_dma_dev(vdpa);
>>>> +       if (!device_iommu_capable(dma_dev, IOMMU_CAP_CACHE_COHERENCY))
>>>> +               return -EOPNOTSUPP;
>>>> +
>>>> +       vdpa_nic->domain = iommu_get_domain_for_dev(dma_dev);
>>>> +       if (!vdpa_nic->domain)
>>>> +               return -ENODEV;
>>>> +
>>>> +       geo = &vdpa_nic->domain->geometry;
>>>> +       /* save the geo aperture range for validation in dma_map */
>>>> +       vdpa_nic->geo_aper_start = geo->aperture_start;
>>>> +
>>>> +       /* Handle the boundary case */
>>>> +       if (geo->aperture_end == ~0ULL)
>>>> +               geo->aperture_end -= 1;
>>>> +       vdpa_nic->geo_aper_end = geo->aperture_end;
>>>> +
>>>> +       /* insert a sentinel node */
>>>> +       return efx_ef100_insert_iova_node(vdpa_nic,
>>>> +                                         vdpa_nic->geo_aper_end + 1, 0);
>>>> +}
>>>> +
>>>>    static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
>>>>                                                   const char *dev_name,
>>>>                                                   enum ef100_vdpa_class dev_type,
>>>> @@ -316,6 +345,7 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
>>>>           }
>>>>
>>>>           mutex_init(&vdpa_nic->lock);
>>>> +       mutex_init(&vdpa_nic->iova_lock);
>>>>           dev = &vdpa_nic->vdpa_dev.dev;
>>>>           efx->vdpa_nic = vdpa_nic;
>>>>           vdpa_nic->vdpa_dev.dma_dev = &efx->pci_dev->dev;
>>>> @@ -325,9 +355,11 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
>>>>           vdpa_nic->pf_index = nic_data->pf_index;
>>>>           vdpa_nic->vf_index = nic_data->vf_index;
>>>>           vdpa_nic->vdpa_state = EF100_VDPA_STATE_INITIALIZED;
>>>> +       vdpa_nic->iova_root = RB_ROOT;
>>>>           vdpa_nic->mac_address = (u8 *)&vdpa_nic->net_config.mac;
>>>>           ether_addr_copy(vdpa_nic->mac_address, mac);
>>>>           vdpa_nic->mac_configured = true;
>>>> +       INIT_LIST_HEAD(&vdpa_nic->free_list);
>>>>
>>>>           for (i = 0; i < EF100_VDPA_MAC_FILTER_NTYPES; i++)
>>>>                   vdpa_nic->filters[i].filter_id = EFX_INVALID_FILTER_ID;
>>>> @@ -353,6 +385,12 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
>>>>                   goto err_put_device;
>>>>           }
>>>>
>>>> +       rc = vdpa_update_domain(vdpa_nic);
>>>> +       if (rc) {
>>>> +               pci_err(efx->pci_dev, "update_domain failed, err: %d\n", rc);
>>>> +               goto err_put_device;
>>>> +       }
>>>> +
>>>>           rc = get_net_config(vdpa_nic);
>>>>           if (rc)
>>>>                   goto err_put_device;
>>>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
>>>> index 1b0bbba88154..c3c77029973d 100644
>>>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.h
>>>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
>>>> @@ -12,7 +12,9 @@
>>>>    #define __EF100_VDPA_H__
>>>>
>>>>    #include <linux/vdpa.h>
>>>> +#include <linux/iommu.h>
>>>>    #include <uapi/linux/virtio_net.h>
>>>> +#include <linux/rbtree.h>
>>>>    #include "net_driver.h"
>>>>    #include "ef100_nic.h"
>>>>
>>>> @@ -155,6 +157,12 @@ struct ef100_vdpa_filter {
>>>>     * @mac_configured: true after MAC address is configured
>>>>     * @filters: details of all filters created on this vdpa device
>>>>     * @cfg_cb: callback for config change
>>>> + * @domain: IOMMU domain
>>>> + * @iova_root: iova rbtree root
>>>> + * @iova_lock: lock to synchronize updates to rbtree and freelist
>>>> + * @free_list: list to store free iova areas of size >= MCDI buffer length
>>>> + * @geo_aper_start: start of valid IOVA range
>>>> + * @geo_aper_end: end of valid IOVA range
>>>>     */
>>>>    struct ef100_vdpa_nic {
>>>>           struct vdpa_device vdpa_dev;
>>>> @@ -174,6 +182,13 @@ struct ef100_vdpa_nic {
>>>>           bool mac_configured;
>>>>           struct ef100_vdpa_filter filters[EF100_VDPA_MAC_FILTER_NTYPES];
>>>>           struct vdpa_callback cfg_cb;
>>>> +       struct iommu_domain *domain;
>>>> +       struct rb_root iova_root;
>>>> +       /* mutex to synchronize rbtree operations */
>>>> +       struct mutex iova_lock;
>>>> +       struct list_head free_list;
>>>> +       u64 geo_aper_start;
>>>> +       u64 geo_aper_end;
>>>>    };
>>>>
>>>>    int ef100_vdpa_init(struct efx_probe_data *probe_data);
>>>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>>>> index 718b67f6da90..8c198d949fdb 100644
>>>> --- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>>>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>>>> @@ -10,6 +10,7 @@
>>>>
>>>>    #include <linux/vdpa.h>
>>>>    #include "ef100_vdpa.h"
>>>> +#include "ef100_iova.h"
>>>>    #include "io.h"
>>>>    #include "mcdi_vdpa.h"
>>>>
>>>> @@ -260,6 +261,7 @@ static void ef100_reset_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
>>>>           if (!vdpa_nic->status)
>>>>                   return;
>>>>
>>>> +       efx_ef100_delete_iova(vdpa_nic);
>>>>           vdpa_nic->vdpa_state = EF100_VDPA_STATE_INITIALIZED;
>>>>           vdpa_nic->status = 0;
>>>>           vdpa_nic->features = 0;
>>>> @@ -743,9 +745,12 @@ static void ef100_vdpa_free(struct vdpa_device *vdev)
>>>>           int i;
>>>>
>>>>           if (vdpa_nic) {
>>>> +               /* clean-up the mappings and iova tree */
>>>> +               efx_ef100_delete_iova(vdpa_nic);
>>>>                   for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++)
>>>>                           reset_vring(vdpa_nic, i);
>>>>                   ef100_vdpa_irq_vectors_free(vdpa_nic->efx->pci_dev);
>>>> +               mutex_destroy(&vdpa_nic->iova_lock);
>>>>                   mutex_destroy(&vdpa_nic->lock);
>>>>                   vdpa_nic->efx->vdpa_nic = NULL;
>>>>           }
>>>> diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
>>>> index db4ca4975ada..7d977a58a0df 100644
>>>> --- a/drivers/net/ethernet/sfc/mcdi.h
>>>> +++ b/drivers/net/ethernet/sfc/mcdi.h
>>>> @@ -7,6 +7,7 @@
>>>>    #ifndef EFX_MCDI_H
>>>>    #define EFX_MCDI_H
>>>>
>>>> +#include "mcdi_pcol.h"
>>>>    /**
>>>>     * enum efx_mcdi_state - MCDI request handling state
>>>>     * @MCDI_STATE_QUIESCENT: No pending MCDI requests. If the caller holds the
>>>> @@ -40,6 +41,8 @@ enum efx_mcdi_mode {
>>>>           MCDI_MODE_FAIL,
>>>>    };
>>>>
>>>> +#define MCDI_BUF_LEN (8 + MCDI_CTL_SDU_LEN_MAX)
>>>> +
>>>>    /**
>>>>     * struct efx_mcdi_iface - MCDI protocol context
>>>>     * @efx: The associated NIC.
>>>> --
>>>> 2.30.1
>>>>
