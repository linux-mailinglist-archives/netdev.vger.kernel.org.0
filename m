Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD5326EEC75
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 04:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238824AbjDZCmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 22:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbjDZCmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 22:42:08 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2081.outbound.protection.outlook.com [40.107.237.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D03D185
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 19:42:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IaL+PJ282vRJ45Yar8Av3jsVZ5KlzQJZJeAW5WQRsv4E96awmTrwFBDDSqjRJ/22NK1hXi7ohu9aftlHVbBHF85l1lhccQwcqAb2jwaxlA1l+l4NbTv8EGiGKo6jhUvQ5yuA0S/jFeRDhvKV4CYIRmiby4znWvBxMm/zqbspPFBiD04KTW18LPDAuiKDSgz11uyLyGh3xRYdT5HHVLSEccNUwfXUyhLykINuJaMUhGJSdr+8MbOORf3Rz/J5JUswGfEPio1gsDomHWM4jK1vUFwwUvJIG+841SHoFP88oEsEbMRyU879z1d310PpIolKJAGmzLo9p2+8m2hL79wLoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tkoboV2iWumUkgBOL5Djw97+wvmnuPcY5F1nRtVOnvc=;
 b=RToOAEbVE/n9f8/SypLUejsZ+QNHKEpcOh6ub7GCFPquIM0o3il/8SBoQfig77GMDvC318lLWCGXjYqwCjhp+LMea4A/jhx5TCFD33zTvRUbcfWwyndIyjTtFrPII+T+Bh6pnrIwEUGXaHF7/sqEzfGHcFSsOpek6XJ/i4dv9KrJabCVWhjtU8VGMeYUCavPVPHOhAHq4xpqYG52m4rdGgs07G092vk+wgSDgs4ECqSxiiUyycZzu6QY1iG1Ws74o9LWnvEeEgocoTQ2BwMfXFu5LuT6pLev/JxpBNZp++aTPlN0Yo5g1IdGKM1v3az0n4Qguy+moWAOM/GPAaSXkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tkoboV2iWumUkgBOL5Djw97+wvmnuPcY5F1nRtVOnvc=;
 b=A/39SF/kM2xuNStZlk4iSK96H0+AHR3wwBL8We72Xa51EQOHmk57lF8bI99rY8m/prCLCGEzdstrdkEE3wuvdYWiE9WL5USQF53WY3A4Rf2dW4yywJwm2jXMv13kz1PemoF8RXe/d7ZBUWWdFBQ8G/r9JOGHh4UFApeJT3Txt4o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6573.namprd12.prod.outlook.com (2603:10b6:930:43::21)
 by BL1PR12MB5206.namprd12.prod.outlook.com (2603:10b6:208:31c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.34; Wed, 26 Apr
 2023 02:42:03 +0000
Received: from CY5PR12MB6573.namprd12.prod.outlook.com
 ([fe80::f1d6:fc33:2d4e:d370]) by CY5PR12MB6573.namprd12.prod.outlook.com
 ([fe80::f1d6:fc33:2d4e:d370%8]) with mapi id 15.20.6319.034; Wed, 26 Apr 2023
 02:42:02 +0000
Message-ID: <0ecb64f2-cabc-bd54-43f2-01da4a71cbb1@amd.com>
Date:   Tue, 25 Apr 2023 19:41:59 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH v4 virtio 01/10] virtio: allow caller to override device
 id and DMA mask
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     drivers@pensando.io, jasowang@redhat.com, mst@redhat.com,
        virtualization@lists.linux-foundation.org, brett.creeley@amd.com,
        netdev@vger.kernel.org
References: <20230425212602.1157-1-shannon.nelson@amd.com>
 <20230425212602.1157-2-shannon.nelson@amd.com>
 <1682474997.6771185-1-xuanzhuo@linux.alibaba.com>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <1682474997.6771185-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0006.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::19) To CY5PR12MB6573.namprd12.prod.outlook.com
 (2603:10b6:930:43::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6573:EE_|BL1PR12MB5206:EE_
X-MS-Office365-Filtering-Correlation-Id: dd5fa743-6f37-4322-702f-08db45ffd0e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3FxluN25GTVrv+JC3kOv+yfxEFq7rz0oCxDMTQvkMD+gD6duXZqC+mIkznxMABNFpL3NPpjR/17zYHGfrNOPAq1mGMaDNFd3Tg/uGS0IsgiSiM7kSK9ISAzvCoN7ye9LwHj5XAcm4zYCvGjjyLihQGI3Ks/yRPPuM/1+pKU70r6+QJilp4xHYekDZol+9jaT9+Y6uCKzvJ9VuQJ7XqojEPVnmFO2ATVxq+7TsVYJCuH7RwlcIYlJGzq/qZQyQsnTrOxFTtyQFyt30+BtxEQKUIFWDPlnEFAsDF69GHk3U4x8io5OMcTiSX2hdy7XBKIKscuECYAiVQFS5XYvIwKiQLlKf1aMeIq1jEdxGizuLAjFHtM2gA1Ykk/1uKw/mXC0XdNAQFzZdQCu84z/YQxIMYZ8DJDEK5/i+VyznyaGQNsIHJuFwQjJ7oDp5YPGvTaIf5Djp3FSJNucU9qb2w+0m2c0e4e52/S+I8lTYg896loC049JMqtukINTMGF68zal90r2PDkwK3WEUkEiCiSTq3TrlgCMNlxxBxi0nF8RrtixY1+ajuEuvKnrwkskXFo2U3SoJ0I/C+M68IBBdL7PlOg+BCo/Kwe24T3XySiukFYuUnYw67x23Nhsa5z9lOyYEsR33ziV0zA03tBzhemO+RECONXwqQLnccziZc/NY8fSQL1ia4TISs5f7JR+W+tcS/cD83b46T+5/bFuDRBwUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6573.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(136003)(346002)(39860400002)(396003)(451199021)(66556008)(86362001)(83380400001)(26005)(186003)(6506007)(6512007)(53546011)(2616005)(36756003)(31696002)(38100700002)(44832011)(6916009)(316002)(8936002)(5660300002)(8676002)(4326008)(41300700001)(6486002)(6666004)(66476007)(66946007)(478600001)(31686004)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SURzOW9MK2xFQXRiM3BGWlZodFVkNWNlMlFyUkl5bHlkaURIMmRDcTk0QVcz?=
 =?utf-8?B?S1lCcTRPZzJHamczTVRxOHZ0YkVyK3RkTU5qdjREN3o0RTdtTStOK1VqZ09U?=
 =?utf-8?B?MnZyRXp3WEZjaXJpM3JKaU9NUXhoenloYSswMkJON1FQTUdxbisvWUdLVHRT?=
 =?utf-8?B?NDRaNHN6TEdBRmdBWnM2QmVuOWhPelBueVl2TENiSS9zQVNuei9nUmJySmQ5?=
 =?utf-8?B?VHE5aGVQYnhHQ3VFc2ZkWHZtVnRCVmsvMHhzajVYNCtEVTRnNlhnZVNTczMy?=
 =?utf-8?B?bmlhSlRkK1lySnA0Q3ZPNUdBRmRqdzAxSFoxUnNSUmlvVXlwWkRiR29aOGtR?=
 =?utf-8?B?ZnZJL3duUU93QTZ5RjhZQ1dmUHM1YWR5Y0ZOT1pua3ZJcHNpSFhDdEtHWE5i?=
 =?utf-8?B?OGx3N2E1Rnp5aC9HTldiWDl2dlFKdTlPQlZIRjBIZlhKVSt5VFJSRlM2cXZh?=
 =?utf-8?B?blVRbnF0Y0lPTDlsQU1JV0ZPSHN0TllQZWJqc0FnZHlGSzlUaWJZV2drRWt4?=
 =?utf-8?B?YWlUeGlCWnFOaFJjQU9nM0paR2pETG5va0UrR0N4S0VONVRzMnR1cHdFeGM3?=
 =?utf-8?B?SWpVRXE1c2s5NmRKbjB5cGcwUVIzeVA4N2srZCtBWUdaOWNmR1VTMHA3YUNu?=
 =?utf-8?B?eDRDNnYrMlNrUU1uZjdGSHBMYmtLZCtLKzR2bmMzRzhQcGRtaGdSeSs5M2o0?=
 =?utf-8?B?V3ZBWGVSWC9qWElTdmpNWHd0aXE0N1hRVXB0MlFEMFJCY1N0TUcvVjNuaXBB?=
 =?utf-8?B?cFZBYkt6eEtEQWZUTDdLYkRycmlKK2ZFWFdDdS9Uc1F2Njh6QjQzT1lodUlL?=
 =?utf-8?B?a3JFbm9iaGxGMk9TaWhKdXBIc0F0K2pySDFhbHdrbFdNUTFRMzJSREdYc3JY?=
 =?utf-8?B?T0QwL2p2NFp4UVNIelZqZGNZWVFGb3J1L1J6NUhjSThYeWkrbXQ4WWlWQ1p0?=
 =?utf-8?B?MG5zaW5wZjk3NXFsaFUrZHZORm9weGRCVWFVdTQ4NTRZSStuQktVcDBZZ0Fr?=
 =?utf-8?B?bjd3aGpTVzhiendtKzR0S3FjUUlxNUc1dXZaTlo3SHdGRG9DMVFJcldjVjN0?=
 =?utf-8?B?SkdqenQyaHp0NTA1MDMyUTFkYjZwMEVidEJZUFhBU1MwUUVaQW14WlVWV3py?=
 =?utf-8?B?V3Evem1rdUdSWWIwVEVtc0xkbkUySXRaWFBsdFdzR0JLWldlWG5XQ0hqbDJX?=
 =?utf-8?B?UlNrM1RwMFJQOHBDd1lUbmZuNDBzZmVsbDdPK2ZXOVpDM0ZJcmcwRXBIM29N?=
 =?utf-8?B?cFpsbXo5WVZYbWIzZlViZWpFd0RIMWIwTXRsWUQxVVN1Nzk5NmpUL1BTdDE4?=
 =?utf-8?B?alIyZVhPczVwOVJVN09KRzlkcFByL2huSFlXK0REWFI4NnRTRk1kMlR4VUlT?=
 =?utf-8?B?M3YyRXRFUUdQOVVIQk5ySW93YWRvYlo0RklnanFuOGpiY04zMm90Q0wvUjlD?=
 =?utf-8?B?d0VLNWFKWFJXb1RBWkM5c0ROdmRKQm1PdlVIQkU1ajBHTVpMMHdCOCt0SGxs?=
 =?utf-8?B?UjdLRW9jSmNNdXRrUDhUUzVXUitNbndCQkVLM2dCT2dtNlRhNXVYdVc5QTBG?=
 =?utf-8?B?UUtJYTJQc2FTcTQyRUtzMlRCMjNxYjFjZzFQdGtnemFtUWtBS2ZWNyt1N3Uy?=
 =?utf-8?B?Um9Hby9jMzNYcldjTkhZd2h3V3RSYS96Y0RSbXNXQ2RlaFJqc2UvWUVtSU1i?=
 =?utf-8?B?d2hobUJSVld0TFBZN0hzZDRnMThmWUZoc3F6SDJOSmVrOHFDS2xwa2JqOTdy?=
 =?utf-8?B?amlJZDJ0WGM4Tk51bks4Ym41VEQ4VWxZVThDcS93SVBaTTBlc1k2VEVyOVo3?=
 =?utf-8?B?NlEvTzlBZEh0VkhndDlVRWZNZ1FMbTBtS0Q4R2RsYkd5aXRPRFFEdUpRT1RV?=
 =?utf-8?B?a2NVR3JaTUFHbjNVZCtMenREWjQ1eTBCV0RiY2pqbW53ajhSdEhCZ1B2V1pU?=
 =?utf-8?B?V3JHWEpCdXFhTUNHb0IxMFlIV3ZzOEpwYVZqdlU0Vm5ESXZ3OGQ2UGwwVGs5?=
 =?utf-8?B?S1RGV09oOUpOR1hTUWx0dDlWdFhmcUhuRWVnOUJlKzBJeVhneE5UaFVOYUhi?=
 =?utf-8?B?N3BlTlExbmNISVAwS0JNUlRDQkJWeUxTQlNWRjU3UkNNSG4rckdBRE9LVXFF?=
 =?utf-8?Q?LFYA211ZtGuU/KEo9+rqL9T0L?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd5fa743-6f37-4322-702f-08db45ffd0e0
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6573.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 02:42:02.8065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XtJrYK1Y8totUMGXcTUWO/RP9kA0AdeQ78hKGkC9JAD+GJhb7TZofHNM3s9aVdEb6EKkdGhZ+8KPYd4893xTqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5206
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/25/23 7:09 PM, Xuan Zhuo wrote:
> 
> On Tue, 25 Apr 2023 14:25:53 -0700, Shannon Nelson <shannon.nelson@amd.com> wrote:
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
>>
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
> 
> I would want to know is there any other reason to return the errno?
> How about return -ENODEV directly?

Because if device_id_check() is returning an errno, it is trying to 
communicate some information about what went wrong, and I really get 
annoyed when an intermediate layer stomps on the value and makes that 
potentially useful information disappear.

sln

> 
> Thanks.
> 
> 
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
>>        if (err)
>>                err = dma_set_mask_and_coherent(&pci_dev->dev,
>>                                                DMA_BIT_MASK(32));
>> diff --git a/include/linux/virtio_pci_modern.h b/include/linux/virtio_pci_modern.h
>> index c4eeb79b0139..067ac1d789bc 100644
>> --- a/include/linux/virtio_pci_modern.h
>> +++ b/include/linux/virtio_pci_modern.h
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
