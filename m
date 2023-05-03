Return-Path: <netdev+bounces-173-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 346CD6F59DB
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 16:22:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 825331C20E25
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 14:22:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC3541078D;
	Wed,  3 May 2023 14:22:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D26321E
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 14:22:23 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2083.outbound.protection.outlook.com [40.107.94.83])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD276A7A
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 07:21:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UUdue4HzFZ7Bzw4bqnVMPCJmxI4XqX92g6KX4HBvyElqetNIhGVRHzBszOxBtfHzZgT4vp8QV5XEdum1tNYxTfXfH/KFiXoXkGDOJ41bMuKr9ySiVwXdUAk1jibKnOPk+22SpW9sQbCcWdxbdKSFu0Nhfn9sZ7Un1/vW9XWtE0RkLe1Hj3ELZYEWT2Iwj0WRoGiNWnKqlWkGxAV+XekS4yGniCfU9ZGFJxWF5dAZii1BGEgxsGrXb3gk+y700G+ya0an7laNTS5LOc/RilOVJgT4F6wZyGW0bE+pjCYTRYIPibybexucppOk8SgVKM0YnjowdCMSd/wDMg817GcjDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ev+V2xyfwBZatGg3nJjMYz4jiwl6VHjac3ICiBI/vow=;
 b=i9DD1N/PKp5KEVj9JpMF/5+m8ATabcCgZcBW0DLRnUfDDW68+Ds7QP4p4bnkGgBEhx9GVVQfvU5dWhWio+BwtXykTfEsgzSjeJbfZ97vYFpoZBSW6Z0Mij43hHUf4nOAv0IbUzilTZKBsH2qjiKhfzF/5hmEcGBi4Hl/L+zhhRqyWsj+o9fn4PYg8x4QMRVDPrswA3vvbIlpv+Cma6BmgPL4I8Gxw5mCX9NITvhw5cOg5Og7XWCHY1QQrQQ2nkxIvES/L6rZJtqRMTBjLUtG4gnZGhyGtLAjTRD3Bl/9QJ3norROpSI3PxNOB1amkc0SN+bEZDZ5w79nvKpApUqWmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ev+V2xyfwBZatGg3nJjMYz4jiwl6VHjac3ICiBI/vow=;
 b=rzLSY1jGYIz5EWAMTKBp1bflYRPd69Rmx3pd1MZkb3waHysJYGIJh+grp+5GP9VgGdjxAyoQKcZe+02TrY7SeCapdkJgxCZH6k2hBqp7Y+J5sxXoz8t5WXkcd0ztqVIFvDAkLBketqZJmsVMHYnqvaPw/ntXLZYKsdypU33c0YI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 PH8PR12MB7181.namprd12.prod.outlook.com (2603:10b6:510:22a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Wed, 3 May
 2023 14:21:50 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::fc3e:a5b4:7568:82bc]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::fc3e:a5b4:7568:82bc%5]) with mapi id 15.20.6363.022; Wed, 3 May 2023
 14:21:50 +0000
Message-ID: <08305e99-022a-7e24-ee17-10d93b876908@amd.com>
Date: Wed, 3 May 2023 07:21:47 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH v4 virtio 01/10] virtio: allow caller to override device
 id and DMA mask
Content-Language: en-US
To: Simon Horman <simon.horman@corigine.com>
Cc: jasowang@redhat.com, mst@redhat.com,
 virtualization@lists.linux-foundation.org, brett.creeley@amd.com,
 netdev@vger.kernel.org, drivers@pensando.io
References: <20230425212602.1157-1-shannon.nelson@amd.com>
 <20230425212602.1157-2-shannon.nelson@amd.com>
 <ZE/QS0lnUvxFacjf@corigine.com>
From: Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <ZE/QS0lnUvxFacjf@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0065.namprd03.prod.outlook.com
 (2603:10b6:a03:331::10) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|PH8PR12MB7181:EE_
X-MS-Office365-Filtering-Correlation-Id: 14fc2eeb-371a-428c-b815-08db4be1bc81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5SWRS/6vavASDk0gOm9VQnDywUouY9sVTeEelBT0KYjlKNd9yN93d06jfajTaIfNyQH4/5jD5E4znA3NauLIAN3dEMM5Edznp3bPg6Tt2oLIUoOhcAwI8Bzt5eGNGimLzoeFyAje+PNwEv9d2K6p43d8s2wYAmEAIzVxyrvREpQzNXvs9WdzsTrT7CuqLqxvMB0ySimJwDwJl8W9UHXw3K1FPPcXKHMQCJnnxuRJ9VJGSVfE5hLqeN/cARIpN5/aXR0DJFLEGyhXTHR2SiVC9OkNdCGo/O4R8wboIG0BoasAlss1ZxlR5YEkG/HAdXnIMbhiqgwhr/EJbW7jw0XH5Gplpc9xCxjx7dEvC0LX3a+aAal0cNORqOJXLWCx4HNmIWH+VMNL8oaL+bVq+BCgngeUIkyyPDc3rbknZu7AD5z8LDZII9jcjKPdgNSa7LYEJm/TjZY132J+zKK/aFoFyf9T0ktwZ0jSRPEZmD2WBndHrVTatzXptaCS3tgPOLuSIgVoVEhRi9sNQYMaeZEMMGQphOfHZ0vS8wQtaptuWdoKR3BV3jNhI/T1mbUePZHfgcW4n4LLdc1xv8O1iDwZM/wROJGDuFGgUY7RjvAQSMaY1alqGjHJg0VqoaEiODM1vnQD4yGr/DpKIltA92Ae0w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(396003)(39860400002)(366004)(346002)(451199021)(83380400001)(6916009)(2906002)(44832011)(5660300002)(41300700001)(86362001)(36756003)(316002)(8936002)(2616005)(8676002)(31696002)(478600001)(38100700002)(6666004)(6486002)(6506007)(6512007)(4326008)(53546011)(186003)(26005)(66556008)(66476007)(31686004)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?enhJbE91OFJJbVZTOFdsRmgvNlREaW56Sy9qN1FQczVDTG9pYUd1eCttVWN0?=
 =?utf-8?B?MWUwbHlQZi8xQ3hwcXFKcm9NVUplbmpzQUo2ZzJHVXBWRENwejMrbkFkYita?=
 =?utf-8?B?cnVqcnJJUWUvZW5GTDBZYnc2TGMxdldHQUFDZWI2VkpmUis2STJ4R1loTlk1?=
 =?utf-8?B?MkE2SG5XZVNKSFVjK3AwbEVlbXVUZVlpQjV4WmoxbE5HRlUxRWxiZUlxTVRh?=
 =?utf-8?B?aGl5Tk5DcGI3KzZKOFVBdHVEUjFOL1A0Y2EwM3FtcHZUOXBZU1Axb0pUck5P?=
 =?utf-8?B?b24yeGRoaWpuWWRYdVVxY2IvQkdMTmVGRzBWdWRxT0l0WWtqVU81MXdxQ2R6?=
 =?utf-8?B?cWJrcmY2aENiQXUyUmkzVGlOZGtKYzFaalNONUg1dzUrWE5XeHFZSERMMEs1?=
 =?utf-8?B?ZGVROFk4WWpKbFI1bzFNbUZ5bnFHMGpxZURtMUFUcGdyeTl0U3VCVjNIeWh6?=
 =?utf-8?B?Uk1tcDN4STMybjgxUEk1OSt0bnB6QmphcHk5QlF1QmxrQ3pWRy8zMEtTUWk5?=
 =?utf-8?B?MHpTZW8xdmd2WTBsaEpySFNiM3pJRkFIdkIvWXV1N3V4dkM0SHdMUHlyVVp0?=
 =?utf-8?B?S0xWb09SR1dvSklIek9tRUJUNHh3QzIxYVBYeGpnTW8xZW51KytXYWdoT3gr?=
 =?utf-8?B?S3NSb0FwV0dXY0hQOG5MWnUrN2haMkd1c3RRdVlkK2xrbXVEeEFTMGMrY0hp?=
 =?utf-8?B?Q2hIbi94Y0NySldYN0pUWGNtNm82MjRtb2dEbmtSVXVjNWVHVkw4ek94aUZQ?=
 =?utf-8?B?cUdFTURLQnNjaWNLeXJ5SHA4cmM4NUZJbmJzeGNKbFM2a2hJakl5Nk1oNzZz?=
 =?utf-8?B?VjRWL2VZSzNvRklSdmlCTjVjWWFmQ2doS2FSVXo0VFFIZVBBb01LT3dHOWFV?=
 =?utf-8?B?VFBnQkJHZXN4Zk9BZ2hZVlZ2WE8rcVZzbkdSdE9ST0w1b25uWDBSTit4bVB1?=
 =?utf-8?B?ZytqYWI0RTdhMkY5a2o5NGRHR1JtRHdPZHNEeTkvY1BDVUNoWDVwMFpkZ2d3?=
 =?utf-8?B?UkxNb0ttWUVKQ25ZMlhYNzlQWFhJbUh1dy9pTXdmVVo4cFUrUHQwUUlaWVJZ?=
 =?utf-8?B?K0p3NXVkbUpINjRyVkszdHo4QlMzZkZobzNCdFRuSjBUYXgxR0VYUCtGTDRU?=
 =?utf-8?B?UEhmcWFjY3EveGZBbDdqSGNjSkVXbVlPNGpzYmRFVmFzVnowd3dMMFZFMWd0?=
 =?utf-8?B?bDg4MVhUYXNzRmd4SkNzc2hLN2ovd2NhZ2JsSGdPRm1WWlhRMEcrdlRUTzla?=
 =?utf-8?B?MW9STEV3TDI1V0NPTmxicE9Td0pRa3FoRGE4K3BoSGkra2NyTlcyRzVLTThr?=
 =?utf-8?B?Nmw2RWlhckxONHdKSTlpdUtxZHJiRVFpajc1a1dKeEVZSDZ3b2Q0QSt3SGFa?=
 =?utf-8?B?Y0NHWEs5bTNBeG4ySGJ0dFlUZ2oydDVvWUtBVUFYcmV6bDA1ZXovcEZaa0s2?=
 =?utf-8?B?Tlh6NThMZzMzNFhyRktoeVE2ZDFNZXBLQTZWQTFKNE0yeEtCTWhXbk9ubFZl?=
 =?utf-8?B?L295TFE0U25tZXlNbVBSdmFUTFJLNUNpQ3duUjdmaGcyUWhiVHpweVEzUk9K?=
 =?utf-8?B?bXRwM1lvZkdVcFNEaTFDOVVQb2wvTkFWUmtoejEyVHdXdDhIZE5mM1NXa1R0?=
 =?utf-8?B?VFY1cTFocDlubVBtM1NXSFZZTDZJN1V4dGRyb2dQK3ljK1dQOE4xUEVndkFN?=
 =?utf-8?B?RmJmQzlhc3duRksvbnpBVU1HYjlHbjJ6NE9mcEVTQTg2eWlFZEhXa2xPMGRQ?=
 =?utf-8?B?YVEwRjB1QW40WGNybEpPOElrRVc1bjlvL1ZzMEkvQnd6T0o2KzZyRzVBZ3U3?=
 =?utf-8?B?RlhQVmcyenJBVTMyeXFVNFd3b2VSb3A2Q285ZnNUMURrTUk5M05jUWplR2ZC?=
 =?utf-8?B?bEY0dHNERlMvUnBXSytRVjlHSGNidDIvK3pGdVFLcTlMSlgrVGRVU2lhZXgv?=
 =?utf-8?B?U1VJcGlHdTY2VEpwenBQYUc5TXVtdDE0dmhxQkxrOFpuMy8yVWtnOUpyU0Vn?=
 =?utf-8?B?MnYvazM1bExxVmtrNkFoS00xMlcvdmEwSnBJVjY1M1N1L21CTnh2YmFNMUx5?=
 =?utf-8?B?bEN0S1pTVFhOZ0F1L2JZREpPQ2hxTmxpQ0RDOUxUZnVmOWs1NHdBaGpFV0hz?=
 =?utf-8?Q?HydSi5AXMMIbzhDas+Af1MtXM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14fc2eeb-371a-428c-b815-08db4be1bc81
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2023 14:21:50.6913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N9xXLXlvyh9N1OWu5ThRJCMBN6QqBp+JrYWV755tWoaHOa+uw5K6RYnSOEdloLZtj7rFaLH32kgduOa5u9BlhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7181
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/1/23 7:44 AM, Simon Horman wrote:
> 
> 
> On Tue, Apr 25, 2023 at 02:25:53PM -0700, Shannon Nelson wrote:
>> To add a bit of flexibility with various virtio based devices, allow
>> the caller to specify a different device id and DMA mask.  This adds
>> fields to struct virtio_pci_modern_device to specify an override device
>> id check and a DMA mask.
>>
>> int (*device_id_check)(struct pci_dev *pdev);
>>        If defined by the driver, this function will be called to check
>>        that the PCI device is the vendor's expected device, and will
>>        return the found device id to be stored in mdev->id.device.
>>        This allows vendors with alternative vendor device ids to use
>>        this library on their own device BAR.
>>
>> u64 dma_mask;
>>        If defined by the driver, this mask will be used in a call to
>>        dma_set_mask_and_coherent() instead of the traditional
>>        DMA_BIT_MASK(64).  This allows limiting the DMA space on
>>        vendor devices with address limitations.
> 
> Hi Shannon,
> 
> I don't feel strongly about this, but as there are two new features,
> perhaps it would appropriate to have two patches.

Sure, I can respin and split these out to separate patches, and I'll 
keep your verbosity notes below in mind :-).  Yes, the kdoc would be a 
good thing, but I'd like to keep the mission-creep to a minimum and come 
back to that one separately.

sln

> 
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> ---
>>   drivers/virtio/virtio_pci_modern_dev.c | 37 +++++++++++++++++---------
>>   include/linux/virtio_pci_modern.h      |  6 +++++
>>   2 files changed, 31 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/virtio/virtio_pci_modern_dev.c b/drivers/virtio/virtio_pci_modern_dev.c
>> index 869cb46bef96..1f2db76e8f91 100644
>> --- a/drivers/virtio/virtio_pci_modern_dev.c
>> +++ b/drivers/virtio/virtio_pci_modern_dev.c
>> @@ -218,21 +218,29 @@ int vp_modern_probe(struct virtio_pci_modern_device *mdev)
>>        int err, common, isr, notify, device;
>>        u32 notify_length;
>>        u32 notify_offset;
>> +     int devid;
>>
>>        check_offsets();
>>
>> -     /* We only own devices >= 0x1000 and <= 0x107f: leave the rest. */
>> -     if (pci_dev->device < 0x1000 || pci_dev->device > 0x107f)
>> -             return -ENODEV;
>> -
>> -     if (pci_dev->device < 0x1040) {
>> -             /* Transitional devices: use the PCI subsystem device id as
>> -              * virtio device id, same as legacy driver always did.
>> -              */
>> -             mdev->id.device = pci_dev->subsystem_device;
>> +     if (mdev->device_id_check) {
>> +             devid = mdev->device_id_check(pci_dev);
>> +             if (devid < 0)
>> +                     return devid;
>> +             mdev->id.device = devid;
>>        } else {
>> -             /* Modern devices: simply use PCI device id, but start from 0x1040. */
>> -             mdev->id.device = pci_dev->device - 0x1040;
>> +             /* We only own devices >= 0x1000 and <= 0x107f: leave the rest. */
>> +             if (pci_dev->device < 0x1000 || pci_dev->device > 0x107f)
>> +                     return -ENODEV;
>> +
>> +             if (pci_dev->device < 0x1040) {
>> +                     /* Transitional devices: use the PCI subsystem device id as
>> +                      * virtio device id, same as legacy driver always did.
>> +                      */
>> +                     mdev->id.device = pci_dev->subsystem_device;
>> +             } else {
>> +                     /* Modern devices: simply use PCI device id, but start from 0x1040. */
>> +                     mdev->id.device = pci_dev->device - 0x1040;
>> +             }
>>        }
>>        mdev->id.vendor = pci_dev->subsystem_vendor;
>>
> 
> The diff above is verbose, but looks good to me :)
> 
>> @@ -260,7 +268,12 @@ int vp_modern_probe(struct virtio_pci_modern_device *mdev)
>>                return -EINVAL;
>>        }
>>
>> -     err = dma_set_mask_and_coherent(&pci_dev->dev, DMA_BIT_MASK(64));
>> +     if (mdev->dma_mask)
>> +             err = dma_set_mask_and_coherent(&pci_dev->dev,
>> +                                             mdev->dma_mask);
>> +     else
>> +             err = dma_set_mask_and_coherent(&pci_dev->dev,
>> +                                             DMA_BIT_MASK(64));
> 
> Maybe it is nicer to avoid duplicating the function call, something like
> this:
> 
>          u64 dma_mask;
>          ...
> 
>          dma_mask = mdev->dma_mask ? : DMA_BIT_MASK(64);
>          err = dma_set_mask_and_coherent(&pci_dev->dev, dma_mask);
> 
> or, without a local variable.
> 
>          err = dma_set_mask_and_coherent(&pci_dev->dev,
>                                          mdev->dma_mask ? : DMA_BIT_MASK(64));
> 
>>        if (err)
>>                err = dma_set_mask_and_coherent(&pci_dev->dev,
>>                                                DMA_BIT_MASK(32));
>> diff --git a/include/linux/virtio_pci_modern.h b/include/linux/virtio_pci_modern.h
>> index c4eeb79b0139..067ac1d789bc 100644
>> --- a/include/linux/virtio_pci_modern.h
>> +++ b/include/linux/virtio_pci_modern.h
> 
> Maybe it would be good to add kdoc for struct virtio_pci_modern_device
> at some point.
> 
>> @@ -38,6 +38,12 @@ struct virtio_pci_modern_device {
>>        int modern_bars;
>>
>>        struct virtio_device_id id;
>> +
>> +     /* optional check for vendor virtio device, returns dev_id or -ERRNO */
>> +     int (*device_id_check)(struct pci_dev *pdev);
>> +
>> +     /* optional mask for devices with limited DMA space */
>> +     u64 dma_mask;
>>   };
>>
>>   /*
>> --
>> 2.17.1
>>

