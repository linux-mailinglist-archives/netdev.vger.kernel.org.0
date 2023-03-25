Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE186C899A
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 01:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbjCYA1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 20:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbjCYA1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 20:27:19 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2045.outbound.protection.outlook.com [40.107.92.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB7915170
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 17:26:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dL2pAKH/08rIKRk9HIhujnp5u2UmYH3BmiAcPUTFp3ODwzYaqh1NbaAfyqySjLL0NLIKOmMd9vYtSTnabh3nWP4BVdysFLu54eKsYViCiBjS3K7lAvfnGkYzFNPyyusDBvk5r/zE821b4MRqmMUfIiQjq0Yf68pyaiEHcACZgIf39YufgsggeDfRzeBu5UztypclBkAevNWLJ3i2ScmvOyVeaFcIdBTyJyhQKGi73gwKEskxQxRhfKBa7wWp68Nr8+RdfLq7RH/iLqId9PZl8LLHGretBzJLpS3z5Hxo1SJ97yfY0GjGhQ7MsYQzinTE56vdCmRq8lcP1Guw3W/ZAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=83L9eSM198Syb5GxKDYADKL4cGWFFTuGdBaBSUS/8Nw=;
 b=Z2yOk7XEwij6ki8Wat8Ghp6CCFp2oTB0P066JqX50e8PeKHSfhJgWHxg0pZXVqvxyZLtOzbEKwlDwO3CFfWQKLBnJEcTiI0gikzfNYVZVsdnBQmvsRQgSvgPbbMYycDl0Rc6VUKKmiTR+6S/bfqB2W6apTwQtEdy1gB3K3qCecaNv9kXFqJ4Z7b2cdVzttyiv8SMFjsZSrcGSPL8qA5otTP97DEgWQnpCsRLvaxd3U2rNBdHMe35dYXg64uPIDD/VxnK9bZ7CkwTAbzRgoQ34ca3HJukfr4amdtYA6htV1jUB+iwfnVKscPRx4Zfu7daWGzUMgh5kOpYCIAcSOYEkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=83L9eSM198Syb5GxKDYADKL4cGWFFTuGdBaBSUS/8Nw=;
 b=BnsetoPNfgKSXWnqTulO6aDVrlT1sKm5ZJU4c2Dftw/7sIwa4wxq8jkiP9CcKuQs8dvPl9mslWA2RxqHGDPaCmA3VbLHWOHVVYRLeZcE6tsRf9ZLsd1ZHeqxqydyvqdMvb4hbVDh8H2jHNscAhadX6ggRWQnDMGQihymrRzk61Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 PH7PR12MB6881.namprd12.prod.outlook.com (2603:10b6:510:1b7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Sat, 25 Mar
 2023 00:26:31 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab%9]) with mapi id 15.20.6178.038; Sat, 25 Mar 2023
 00:26:31 +0000
Message-ID: <c99c65da-ff0a-e438-dde9-26da67037d2c@amd.com>
Date:   Fri, 24 Mar 2023 17:26:28 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v3 virtio 1/8] virtio: allow caller to override device id
 and DMA mask
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io
References: <20230322191038.44037-1-shannon.nelson@amd.com>
 <20230322191038.44037-2-shannon.nelson@amd.com>
 <CACGkMEvMvd9rwWZYTuc_gU1fSm8XPa=7=EOKjjzy7Mr=qEyqgA@mail.gmail.com>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <CACGkMEvMvd9rwWZYTuc_gU1fSm8XPa=7=EOKjjzy7Mr=qEyqgA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR04CA0034.namprd04.prod.outlook.com
 (2603:10b6:a03:40::47) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|PH7PR12MB6881:EE_
X-MS-Office365-Filtering-Correlation-Id: 519138e5-7c97-4f47-1790-08db2cc794db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9CCNFk74c36w0pEo9a1zVrrchfbx2/87FVPrziAUKz/R46JFQLXOhQUEzfyX2rpysF0fWx83uouELvg7ZaldKRz9csVgplOeNZdcYqf9bxdbRpK4O7dHlKKkoHY5jDWGEYe+jmr9PVLp2/Yi2UDDeboBBZ1SR50tdoy8z8sStzXU2j6UFwkSuHBLV28JAwv6df+LkWIrw4bD1PeBG/qqMYoXbRukOnLOO3aJD71u7kY+TkUv+sfeZs8A7R4EhHC3Sg//7fEERc/9tgKw7x3GyLERolV5Nkqu95pcegB8tDUW26o3nRMKLJg8R3C3qegCyZuYqhsYTpCHSieF0JUAmSt7ktlNwqjbXQJo892ZOQZXtU7GQ51iy+zJ2EgIhwk55Rzzoa/rCfHasb/NYxLXtj2258Htf8prPcFW5dHd/t0op1K0o4a6mbaO3g+HayqlcYl/vdLzZe0BWJAXvTGnqEk1wvX0MMjkzZwJbaKj5OQoAANnJ6oqha3dSZP8AKcFHLjppuFvbNnSxhlt86poUYmTkaLdyPHk4bCc8BRT9epLh6zPt05LzUQjYtZfdtYsDEq+9tfAfWPUdH+cNaZhcoHY4GEAj0v4TtcFvJ6AsSoOCbGuppbaJ0ieaWakXU1hpjEcjRarVoxTXrb4KHP8xhzHhjCL75Kh27jryWN50gmajWCuZLPaleTGlvMIuEDUupn3ns3FAXA/rnyFj3BfueOlrbLLU9PVbsdyqA/fuce/7yY6Pj/PUkaMgvQbsElA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(376002)(136003)(366004)(451199021)(2616005)(2906002)(38100700002)(31686004)(5660300002)(6666004)(8676002)(4326008)(66476007)(6916009)(316002)(66556008)(41300700001)(66946007)(44832011)(6486002)(6506007)(6512007)(26005)(36756003)(53546011)(8936002)(478600001)(86362001)(31696002)(186003)(83380400001)(21314003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RUs0MCtlTHNIT3dPOFFsRmJlMU1PaFh3THNNbE9TRTZrY0JFcGFENEdkUUZN?=
 =?utf-8?B?WlFIZUsxQjlCNGpQQU1NK0dMYmRwMFlkNzNSb0lrU2F6VlBidU9rcnZZdUh4?=
 =?utf-8?B?dUM3MElrZjh3ZGdMN0EwSmRVVzhGS0FvZE01VmI1dVlsbnp3YVpKZmVBdURW?=
 =?utf-8?B?YzBOa0k1N0tZNUlPd0xKZG11YTVoZTJvUFNFQ2xPRW5VczY1V2pqMWxpMlFM?=
 =?utf-8?B?SHViWHdsODE0UElqY05zOGJJaDF1UlRsWWdibGhTcjFXelhYbm9NNHZuYmUv?=
 =?utf-8?B?Vkh4ZzMwQ3ZCRTEzaE5JeGlCMFllT1IvUEZhTWlMa2ZoUjZDQjZHbEVRcjcy?=
 =?utf-8?B?c0JFVjNvOTlMbkNKL3V2eWVFZTFpNUNwKzdaaGVLbG1nMlJrUCsrRVgwZFNn?=
 =?utf-8?B?M1BRZ2tNU0R5VVZRamtqbDJPaWFBdFBqaEZkbnBFcWluUEx3M1phWFZQTmc0?=
 =?utf-8?B?clI1b2QrRjVHRkUvZWdvTW5KM2w4SjQ3bURPcUZtWlZNajBrbzg1OXRYTGpk?=
 =?utf-8?B?cXJXMktaZUlOa2VRTSt3dER5RzJ4ckNFZTd0aDVSbUZyb1FibEFhYngzUlhB?=
 =?utf-8?B?cGJkTkt0YURxTFExallDenpvMVR4cEgyKzNDaTdMWmZYaWtQWWZzVDg5dTUx?=
 =?utf-8?B?OUhqbGM1bFNYb3lqTFAxSEREdmRHOWxlOGd1aXFKQjhnR0tlYS80UUl3MUxs?=
 =?utf-8?B?VFlBTUo0OFJqMjhub3VmMXlxUFQ0Q0kveCszdDk0TlhtNkFseFFBWXdmNTRP?=
 =?utf-8?B?cUJSZlhkRnl6N2pLODljUTdWNSs2Z0JEOGExOU1vUUZUR3EyT2h2dlYyWG5X?=
 =?utf-8?B?YlJuQTExcU9JZTZCRHZTMkRpdmdVSXhlcUZFT1l0ZXZ3VHc2d3hDdVNtbndo?=
 =?utf-8?B?YUd6eXhJMCtNYXovek1BcUQvNmRhTkRUa21VSWw2SmYraWNvRjJ0NWdIaThz?=
 =?utf-8?B?VTVVelYvMStPQ2JaazhUWW9nMlFwWUtTOUFlR2k0OEdFVnZsMCtzaEx1NXcv?=
 =?utf-8?B?Q1B0RFVRc0xlNzZyaWMvUjBQM2ZNUGZxazJ4TzFteGdmVGIzbWRJdmY0eThH?=
 =?utf-8?B?cHFwYjVOMEoyZG04T0ExN1BFRWVYRExSZlVNd0lHSGgzUUU2Z0VWOURxcXRM?=
 =?utf-8?B?cTJYU1hFRGM2OVdsdkdtditlNG5yeXJXcGp5YjY5Ry9lMG1lZ1puUHZ5dDdU?=
 =?utf-8?B?UWcrRXUvcFgrTS9jODJVZWE4SHZnSzFBdmhwRW8zR0VaeEF6bWtaYUJ0SHhn?=
 =?utf-8?B?SVNRUHh3ZFZzSGVuMUpiL1VYRXFjUCtnYUc1NklXVlRYQW9FYTdyQ0h1OTcz?=
 =?utf-8?B?NHBNTzc3aEthcnBGbUFNSldseXc1N3F2dzU1cWs2YktDc3hSWWc0R29GRXRz?=
 =?utf-8?B?OFBCZ0ZSSEdXYUc4REJDZkUvNmxUKzcvTzNVTWxjdW5JZkQ0ZEppZEdBREFV?=
 =?utf-8?B?eXNLcXhnVE5rSUVJSmtMMlBzYlJwUzV1NVBYSlgwOWY2Ykh0L3prQlFLOUxP?=
 =?utf-8?B?eFhKM3BObHRrWEVlYlNyUUVWRkR5SzlsM3RHMDlBbTR6UWhmWTJCRzZ5ZWc4?=
 =?utf-8?B?UmJ1WEpHQVRBeG1JOXEwQjBrWnNreEg4UUVkYkYxUFQ1NVhtN1g3aVBHajlm?=
 =?utf-8?B?R2VXMnVBZ3o3Z2kxS2R6M3VkTERXWUREOG9KaTU4L3JxRmFNVkovalR3WHFV?=
 =?utf-8?B?WVlrVzhUMkNYaWJ3dGMwcnBhUEsrc3J1WVZWb005UnFrN21TY0s1cmk4eWRq?=
 =?utf-8?B?b0ZKZGFjSnZqUW1wc1g0MzJiNHpJT2c1THJpYzRKTTZDa2Y1MEx4VmdrRHE3?=
 =?utf-8?B?ZW9DeTNNQy9FbHBSMHlSdU5ZRkdHYlloSUxRcWVYNlhtMVlTSEtwL0lPb1oy?=
 =?utf-8?B?a1VqUlFZK0Z4NHQwdXlrMWMvVHBFZVZqVFVGSDhmZ0p5RkcrSUJ1MUlaUTNz?=
 =?utf-8?B?WTl0WkhZajc3eExyZG9pTzRtMVUxWUJYK3lrOFhwNG9CVXA0bFY3Yzh3M2JY?=
 =?utf-8?B?OXlTY2JSTUpFczQ2WGZJejRNM1lKVTJ2QWhtVk01NytKTmxyVTFobjJONUU2?=
 =?utf-8?B?ZGxpMVE3MDZQWGZOZXNsYXNGOGc4QzJMaE8yQ2dvVG9YNWcvSXNIV01RSGVu?=
 =?utf-8?Q?o/NJ1M4vhVEEnRoz/QMbVyFej?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 519138e5-7c97-4f47-1790-08db2cc794db
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2023 00:26:31.1807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nSfaOpk5AB5ESkEJzi6ByrY3+Br9sb+ghgxXAGg8W7CH5lJgc5Beb4uQhEqXxQbLRC4SdQAAi69GLzLvmQB8Bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6881
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/22/23 9:05 PM, Jason Wang wrote:
> On Thu, Mar 23, 2023 at 3:11 AM Shannon Nelson <shannon.nelson@amd.com> wrote:
>>
>> To allow a bit of flexibility with various virtio based devices, allow
>> the caller to specify a different device id and DMA mask.  This adds
>> fields to struct XXX to specify an override device id check and a DMA mask.
>>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> ---
>>   drivers/virtio/virtio_pci_modern_dev.c | 36 +++++++++++++++++---------
>>   include/linux/virtio_pci_modern.h      |  6 +++++
>>   2 files changed, 30 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/virtio/virtio_pci_modern_dev.c b/drivers/virtio/virtio_pci_modern_dev.c
>> index 869cb46bef96..6ad1bb9ae8fa 100644
>> --- a/drivers/virtio/virtio_pci_modern_dev.c
>> +++ b/drivers/virtio/virtio_pci_modern_dev.c
>> @@ -221,18 +221,25 @@ int vp_modern_probe(struct virtio_pci_modern_device *mdev)
>>
>>          check_offsets();
>>
>> -       /* We only own devices >= 0x1000 and <= 0x107f: leave the rest. */
>> -       if (pci_dev->device < 0x1000 || pci_dev->device > 0x107f)
>> -               return -ENODEV;
>> -
>> -       if (pci_dev->device < 0x1040) {
>> -               /* Transitional devices: use the PCI subsystem device id as
>> -                * virtio device id, same as legacy driver always did.
>> -                */
>> -               mdev->id.device = pci_dev->subsystem_device;
>> +       if (mdev->device_id_check_override) {
>> +               err = mdev->device_id_check_override(pci_dev);
>> +               if (err)
>> +                       return err;
>> +               mdev->id.device = pci_dev->device;
> 
> While at this, would it be better to let the device_id_check_override
> to return the mdev->id.device ?

Good idea - I'll add that.
sln


> 
> Others look good.
> 
> Thanks
> 
>>          } else {
>> -               /* Modern devices: simply use PCI device id, but start from 0x1040. */
>> -               mdev->id.device = pci_dev->device - 0x1040;
>> +               /* We only own devices >= 0x1000 and <= 0x107f: leave the rest. */
>> +               if (pci_dev->device < 0x1000 || pci_dev->device > 0x107f)
>> +                       return -ENODEV;
>> +
>> +               if (pci_dev->device < 0x1040) {
>> +                       /* Transitional devices: use the PCI subsystem device id as
>> +                        * virtio device id, same as legacy driver always did.
>> +                        */
>> +                       mdev->id.device = pci_dev->subsystem_device;
>> +               } else {
>> +                       /* Modern devices: simply use PCI device id, but start from 0x1040. */
>> +                       mdev->id.device = pci_dev->device - 0x1040;
>> +               }
>>          }
>>          mdev->id.vendor = pci_dev->subsystem_vendor;
>>
>> @@ -260,7 +267,12 @@ int vp_modern_probe(struct virtio_pci_modern_device *mdev)
>>                  return -EINVAL;
>>          }
>>
>> -       err = dma_set_mask_and_coherent(&pci_dev->dev, DMA_BIT_MASK(64));
>> +       if (mdev->dma_mask_override)
>> +               err = dma_set_mask_and_coherent(&pci_dev->dev,
>> +                                               mdev->dma_mask_override);
>> +       else
>> +               err = dma_set_mask_and_coherent(&pci_dev->dev,
>> +                                               DMA_BIT_MASK(64));
>>          if (err)
>>                  err = dma_set_mask_and_coherent(&pci_dev->dev,
>>                                                  DMA_BIT_MASK(32));
>> diff --git a/include/linux/virtio_pci_modern.h b/include/linux/virtio_pci_modern.h
>> index c4eeb79b0139..84765bbd8dc5 100644
>> --- a/include/linux/virtio_pci_modern.h
>> +++ b/include/linux/virtio_pci_modern.h
>> @@ -38,6 +38,12 @@ struct virtio_pci_modern_device {
>>          int modern_bars;
>>
>>          struct virtio_device_id id;
>> +
>> +       /* alt. check for vendor virtio device, return 0 or -ERRNO */
>> +       int (*device_id_check_override)(struct pci_dev *pdev);
>> +
>> +       /* alt. mask for devices with limited DMA space */
>> +       u64 dma_mask_override;
>>   };
>>
>>   /*
>> --
>> 2.17.1
>>
> 
