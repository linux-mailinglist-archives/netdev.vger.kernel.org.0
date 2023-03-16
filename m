Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7CF6BC4B2
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 04:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjCPD13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 23:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjCPD0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 23:26:41 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC1B320D06
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 20:25:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ah6U4DVqsIHZwOkBzv3zfw9ko4DDGUSPXBam5KN2J/22XHMaXZbQJkX9ILNfvgUE6SUqmf0Km9sN5JdMDWxoaIt3dd9TrD+3dKuaeg3pZpr5waGgfyZwzyP80sodkGDVk5j5BATKneEWWQr050qMGPv4JQiyjKDfo/pN1WnwzmUPDwOfuTBDNMvfbZvEntXUfuG82rqPdYMiEchmRItB0/y1wWtsvqJoi4iPRq+5kYdUxPDSETli6bL4wyHrX+lwv/tQYx4B4wT51Ti96254elOGnipsf5j5Jmn+KEqIYv3Abdtx3KrpyMgWqYDv0yQKpQG/RBBEQh00ybu/RI+ljA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nc1mE1VyuP70JAj9SIwqtGPeiO+CLlb3Ed0o8JLNALA=;
 b=KWIboYwSC7YWo+UWTR54JMDClHg+WdpRcJdTwQZCaqnxnxcvDdoWNymfH77MhtSAMV70OZ8agtNM6KLnv8MH/r134Qm5IYReB20FKQ4PCvH/HMtmg7JrIekxBGFg2xt7OABKGx5AvBJeG2eferj3dW7SNvxlkDwjGtiODTSxM6aDhLfiM/Siypsh4GWbpthkkO5y3uFC9RKHWQv/Mc7DUsIADCAtdTYr6AAom8eZjg6ypZKtZat9NBGV+4v3+4DvYTQPc4LLj3LKMnP5VUVnLE5q3vZY1PtkWlBlv/e9DClV5qjxrQZ7I8ACPThvddxcrWxEogRJvDsikAIfNrX9Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nc1mE1VyuP70JAj9SIwqtGPeiO+CLlb3Ed0o8JLNALA=;
 b=kmde1OECCs40Ol36T6qacEyQ8tMknO42Viw4MnS7xBGwDF5DRxU9g5gVznCyTQ0eQu76VyMokxJ4WJ2DwUr2V73qEvhoURNV9ITNr/7erE7AS7T1rUvISbcS73ml5K5DrgDRu/JjeNQzWtNGJjEsNUh2KF2hZg1Wr4oH3fsWyPU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 CY8PR12MB8215.namprd12.prod.outlook.com (2603:10b6:930:77::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.29; Thu, 16 Mar 2023 03:25:21 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab%8]) with mapi id 15.20.6178.024; Thu, 16 Mar 2023
 03:25:21 +0000
Message-ID: <ee3dd0c5-5e44-634d-7ab7-7a4c9c1cd4f7@amd.com>
Date:   Wed, 15 Mar 2023 20:25:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH RFC v2 virtio 3/7] pds_vdpa: virtio bar setup for vdpa
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io
References: <20230309013046.23523-1-shannon.nelson@amd.com>
 <20230309013046.23523-4-shannon.nelson@amd.com>
 <CACGkMEt5Jbsp=+st8aG_0kXD+OSSp+FX9vYE+gTkywp2ZN4LTw@mail.gmail.com>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <CACGkMEt5Jbsp=+st8aG_0kXD+OSSp+FX9vYE+gTkywp2ZN4LTw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR06CA0058.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::35) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|CY8PR12MB8215:EE_
X-MS-Office365-Filtering-Correlation-Id: 57885873-43d3-4f0c-d3f1-08db25ce1312
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7LIJpyg7/VrZSzoRFitU74Rts1FIVtXqL7BlW7r70ldAm1wG2y1+8sGBU23XZ8NHqRC3byEX06kZxtxR+aH3RFM/jsG+S9zm84RERwoNnfHU+Bim1MThM8VAhOtoktlCq467Z8r/tK1BjSN6QoUqIxGsB8R8hnuajdcvgSnaUd1GIL+WCEJo8cejRHvj2GvwzJoMuQV9EQ9KasO6XHhnU2H09/AGzKL/ODoHrXgOVhlvvZYxmGXgfHio6lDwvLXgAFsqnPKKZBiOoA1sWz59oZiLghuhUiBEWc9Y16fW72FZLqY9V62ksLeoNgBrEfUh58UlKmzbegSLUgo2lgZ2DkmNN65w4Da7+/QZGe4UAcZzkTChGkqXoFOzfYyb819V8hQuE7T01LpXDwVBvzxRoFnsEmrmTRdSvPaYHNzU9yFR0PK5VxnEqDsbjyo0ZtyE0Y3C3VqaxtJju6yDdjz0L3Vh3JWm8FIIUy7aSGv2VzfasNT5ANB5VHeF3drZT9H0oaCenQ0LYfEQFXL16Il8V4dt8gGPx6EMDLW96RgUKrmZcGUgLNHzxZXWF6G72YVYCDm4LBtoLvXMro2ZED6FXPd2yjm3s0x1Oz/tsJaZeKXCepo8yGvSeUqMpls/3TJJ6H5WdgTs7WUFLRv+2w/HbZlgd40hv8cRdWIeTyjUrit5pLXjbNhhGW0vSlxNlik1rgMSkLvQ2EWYvaAiy3C8SwNdEs/sYnmoc7H/CHeu5mc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(396003)(39860400002)(376002)(136003)(451199018)(2616005)(26005)(478600001)(6486002)(53546011)(36756003)(186003)(6512007)(316002)(6506007)(30864003)(38100700002)(5660300002)(86362001)(41300700001)(31696002)(8936002)(31686004)(44832011)(83380400001)(2906002)(66476007)(66946007)(66556008)(4326008)(6916009)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d0ozWWJ1WEhxdmpNcFdNMmluOTJDalIveTgwMjFCQ05HM0Fjb09DUW5YajVT?=
 =?utf-8?B?SzFvbWVLVndrTmE2RUFuYmtVZDhGTjROclVIeG1GSmRaa2JJU01IVy8zYVdv?=
 =?utf-8?B?dlNmS0QzMVo0WVg0NlU3M2tpK3BmVFBXSTk5d05MRVlSNDJMUHZWNi9GRVBo?=
 =?utf-8?B?b2c3VEpHZ0FGV2FkL2s3UUF2bkRsR3N0NHVpeWs5bEFsdFJQNWdHek5SYjk1?=
 =?utf-8?B?VmtYcG13bXVVbnpLQ2hwZzhKSFk1SUpoZ2U1bk5UTjNScndIaWZvdGVMMVJD?=
 =?utf-8?B?blVCTEVjZHhBZ3p6V05aOFBYbEpocndySElnWng5WUFVQ2RUM0pOOTdaS0J3?=
 =?utf-8?B?RjZ1Z1BPd25KdTJSUEMvUllERHB1NE80QUxKb3lxUUVvRko2UUg2M05laVZX?=
 =?utf-8?B?b2VpZXF2VGlYZHppVXovVnRON0RpYldOblhWaVlTSmlFcW5leGx1REN2RFFn?=
 =?utf-8?B?VmMzTUtzeFBQSHdOR3prOFhyQzA3RVgxRGRPT3NibVlYazdlcllFQlZiZ2Zu?=
 =?utf-8?B?VFpackdTUTE5MzV5VTRrWWJ0aVFScWFCcUhYeFRvT3JTSUN2d0RFT2QyNG14?=
 =?utf-8?B?cDM0aDdTTGw3OU9mR3JSZzVnTEtEZnYySjJmeHRWWExxR1NXWmFlN1VtWEMx?=
 =?utf-8?B?WGs4SDJoc0tRb2Zad0NqTlE1amxqWmNPb3A2NmZZYXVyd2thcXNRZGtSeVhL?=
 =?utf-8?B?RndmVE5yMWYxQU5wOHFhc2xBckNRbnF1WXJvdzdVRmV1RnU5NkxmWXpBQkZp?=
 =?utf-8?B?SjNKNnYyd2JOaEErck9kKy9kZWhFaWhxcmV4TjFMcTZjTDFPSndPYks4UnRn?=
 =?utf-8?B?RWYwaklQbjJCR0YxZUQ2UTlpYlF4MFNqbzkydTNsRTJVbjBRdmx1a2k0TytT?=
 =?utf-8?B?bFBRZS9EU0MvVitDWnpRYlkvWGVHOU93dDJoZTQ4RWdiWC9tZGRTVVF4aWQv?=
 =?utf-8?B?SEE2eFBYN2oyYjN0NFVpN3M1VVdKWlljR2xlaVBiM1M0TGlLVlk0V1ZabTI2?=
 =?utf-8?B?RkozOC9qaFBzTGl1ODNVbUYydzJPRmV5TjQ4S09JbG85c1FiaUF6U1VzTWF5?=
 =?utf-8?B?MFZXbHZrQ1RnOEl0RXJmUnFLcVBvMHFwdlZIOWNubHZhcW04b3FHaGJoa0du?=
 =?utf-8?B?UFRscExhTG9zS2swaUJoZ3AxeTB0eDlJb0FXczBhSkZHQ1F3ZW5JKy83RXFS?=
 =?utf-8?B?ZWppT3RmQ0JwR1UyRE5HUWdvcUVpZGpGOFBTUTFBWHVxcEN1aDNhSDdLMkN4?=
 =?utf-8?B?VXdJeXkvUlEyV3ovcUZEbU1tRmRHQnB2cE1GWjhkQ2VlbXpIVmN4OEhQTEUx?=
 =?utf-8?B?N2crM2FGeFpXQnYvSms0eWphN3p1V3NwdE56NGsrQW5QMXU0N1YvUEZ6Qys0?=
 =?utf-8?B?aFdLclBvcFhGSnNqalB2Sk91Q2RRMFVHMVU3RDhZU2tFRWk1Zmk1Yk1QSG5w?=
 =?utf-8?B?Z0NSWUVwVWdmOGRXdkxPaDVvZFFUeURCQXBzNE5MbHZHbFRJR1R3TmlHb2NZ?=
 =?utf-8?B?ejQyMEFEZy9SQ01haXM5K1krajh6a3JSeEF3UFVNZGdsUlA0Uys3ZWVVckNB?=
 =?utf-8?B?ayt5Y0tlZUViVWpKWHVjc0JQOXdHT1JaR2dHWVU4TlVJKysyQ05iNzFuSDE0?=
 =?utf-8?B?OU8reDE3Y0daVzJzb3RIcU1ldnJwdWV2blRuM2JGSkxUUmp3SnRGNXBxRGRJ?=
 =?utf-8?B?RzJLaFJKRmUyTUZFWjlJNlJMMFJJTjdGZWZvMnFtV09xSEhjNW8za0J0bnhz?=
 =?utf-8?B?U2dlckVhMGZvTjdacmt2Rm9JeTgwYzV4WEZrQWkvQklCeVF2M3lrNlRLZ1Fz?=
 =?utf-8?B?RXZzaGUzWHA3a1VZKzlVTXNJSi91eE53Lyt5MUpCT0M2aGZiN01kenVjb04v?=
 =?utf-8?B?NGQ2WjRVT0JvOG04TkM0dW80bGVHS2txcEg0ZVFIYkJQV3NBWkZhbEtwMndz?=
 =?utf-8?B?ZmZvM1p6eEUvSlZyMFowbDNNSXh1anAyVk1mQkM1djlSU1ZkOVUvSlNRL1Bs?=
 =?utf-8?B?QUNVMjJhTEhZenN4NGdpS3BGeUl6NXB0TXBlWkhyUDJXZTduZ1VmdVN6U1Zq?=
 =?utf-8?B?U3ZuWUU0Ly9iSWNKbkJPYUlvVUpqQzVpc2d3LzlYN0tZT3J5SlhUdFJPR3Bi?=
 =?utf-8?Q?6kl2LMuRMjA5rsvHxDku43hwz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57885873-43d3-4f0c-d3f1-08db25ce1312
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 03:25:21.7642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TPkwPKDK8MFij6Tve81aFIhIIzBuaoytyALREF1q1a7BzDF0UBRxDkzoyUfb7FQv4iMcCMBqx7BQcvi543R5Wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8215
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/23 12:05 AM, Jason Wang wrote:
> On Thu, Mar 9, 2023 at 9:31 AM Shannon Nelson <shannon.nelson@amd.com> wrote:
>>
>> The PDS vDPA device has a virtio BAR for describing itself, and
>> the pds_vdpa driver needs to access it.  Here we copy liberally
>> from the existing drivers/virtio/virtio_pci_modern_dev.c as it
>> has what we need, but we need to modify it so that it can work
>> with our device id and so we can use our own DMA mask.
> 
> By passing a pointer to a customized id probing routine to vp_modern_probe()?

The only real differences are that we needed to cut out the device id 
checks to use our vDPA VF device id, and remove 
dma_set_mask_and_coherent() because we need a different DMA_BIT_MASK().

Maybe a function pointer to something that can validate the device id, 
and a bitmask for setting DMA mapping; if they are 0/NULL, use the 
default device id check and DMA mask.

Adding them as extra arguments to the function call seems a bit messy, 
maybe add them to the struct virtio_pci_modern_device and the caller can 
set them as overrides if needed?

struct virtio_pci_modern_device {

	...

	int (*device_id_check_override(struct pci_dev *pdev));
	u64 dma_mask_override;
}

sln


> 
> Thanks
> 
> 
>>
>> We suspect there is room for discussion here about making the
>> existing code a little more flexible, but we thought we'd at
>> least start the discussion here.
>>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> ---
>>   drivers/vdpa/pds/Makefile     |   1 +
>>   drivers/vdpa/pds/aux_drv.c    |  14 ++
>>   drivers/vdpa/pds/aux_drv.h    |   1 +
>>   drivers/vdpa/pds/debugfs.c    |   1 +
>>   drivers/vdpa/pds/vdpa_dev.c   |   1 +
>>   drivers/vdpa/pds/virtio_pci.c | 281 ++++++++++++++++++++++++++++++++++
>>   drivers/vdpa/pds/virtio_pci.h |   8 +
>>   7 files changed, 307 insertions(+)
>>   create mode 100644 drivers/vdpa/pds/virtio_pci.c
>>   create mode 100644 drivers/vdpa/pds/virtio_pci.h
>>
>> diff --git a/drivers/vdpa/pds/Makefile b/drivers/vdpa/pds/Makefile
>> index 13b50394ec64..ca2efa8c6eb5 100644
>> --- a/drivers/vdpa/pds/Makefile
>> +++ b/drivers/vdpa/pds/Makefile
>> @@ -4,6 +4,7 @@
>>   obj-$(CONFIG_PDS_VDPA) := pds_vdpa.o
>>
>>   pds_vdpa-y := aux_drv.o \
>> +             virtio_pci.o \
>>                vdpa_dev.o
>>
>>   pds_vdpa-$(CONFIG_DEBUG_FS) += debugfs.o
>> diff --git a/drivers/vdpa/pds/aux_drv.c b/drivers/vdpa/pds/aux_drv.c
>> index 63e40ae68211..28158d0d98a5 100644
>> --- a/drivers/vdpa/pds/aux_drv.c
>> +++ b/drivers/vdpa/pds/aux_drv.c
>> @@ -4,6 +4,7 @@
>>   #include <linux/auxiliary_bus.h>
>>   #include <linux/pci.h>
>>   #include <linux/vdpa.h>
>> +#include <linux/virtio_pci_modern.h>
>>
>>   #include <linux/pds/pds_core.h>
>>   #include <linux/pds/pds_auxbus.h>
>> @@ -12,6 +13,7 @@
>>   #include "aux_drv.h"
>>   #include "debugfs.h"
>>   #include "vdpa_dev.h"
>> +#include "virtio_pci.h"
>>
>>   static const struct auxiliary_device_id pds_vdpa_id_table[] = {
>>          { .name = PDS_VDPA_DEV_NAME, },
>> @@ -49,8 +51,19 @@ static int pds_vdpa_probe(struct auxiliary_device *aux_dev,
>>          if (err)
>>                  goto err_aux_unreg;
>>
>> +       /* Find the virtio configuration */
>> +       vdpa_aux->vd_mdev.pci_dev = padev->vf->pdev;
>> +       err = pds_vdpa_probe_virtio(&vdpa_aux->vd_mdev);
>> +       if (err) {
>> +               dev_err(dev, "Unable to probe for virtio configuration: %pe\n",
>> +                       ERR_PTR(err));
>> +               goto err_free_mgmt_info;
>> +       }
>> +
>>          return 0;
>>
>> +err_free_mgmt_info:
>> +       pci_free_irq_vectors(padev->vf->pdev);
>>   err_aux_unreg:
>>          padev->ops->unregister_client(padev);
>>   err_free_mem:
>> @@ -65,6 +78,7 @@ static void pds_vdpa_remove(struct auxiliary_device *aux_dev)
>>          struct pds_vdpa_aux *vdpa_aux = auxiliary_get_drvdata(aux_dev);
>>          struct device *dev = &aux_dev->dev;
>>
>> +       pds_vdpa_remove_virtio(&vdpa_aux->vd_mdev);
>>          pci_free_irq_vectors(vdpa_aux->padev->vf->pdev);
>>
>>          vdpa_aux->padev->ops->unregister_client(vdpa_aux->padev);
>> diff --git a/drivers/vdpa/pds/aux_drv.h b/drivers/vdpa/pds/aux_drv.h
>> index 94ba7abcaa43..87ac3c01c476 100644
>> --- a/drivers/vdpa/pds/aux_drv.h
>> +++ b/drivers/vdpa/pds/aux_drv.h
>> @@ -16,6 +16,7 @@ struct pds_vdpa_aux {
>>
>>          int vf_id;
>>          struct dentry *dentry;
>> +       struct virtio_pci_modern_device vd_mdev;
>>
>>          int nintrs;
>>   };
>> diff --git a/drivers/vdpa/pds/debugfs.c b/drivers/vdpa/pds/debugfs.c
>> index 7b7e90fd6578..aa5e9677fe74 100644
>> --- a/drivers/vdpa/pds/debugfs.c
>> +++ b/drivers/vdpa/pds/debugfs.c
>> @@ -1,6 +1,7 @@
>>   // SPDX-License-Identifier: GPL-2.0-only
>>   /* Copyright(c) 2023 Advanced Micro Devices, Inc */
>>
>> +#include <linux/virtio_pci_modern.h>
>>   #include <linux/vdpa.h>
>>
>>   #include <linux/pds/pds_core.h>
>> diff --git a/drivers/vdpa/pds/vdpa_dev.c b/drivers/vdpa/pds/vdpa_dev.c
>> index bd840688503c..15d623297203 100644
>> --- a/drivers/vdpa/pds/vdpa_dev.c
>> +++ b/drivers/vdpa/pds/vdpa_dev.c
>> @@ -4,6 +4,7 @@
>>   #include <linux/pci.h>
>>   #include <linux/vdpa.h>
>>   #include <uapi/linux/vdpa.h>
>> +#include <linux/virtio_pci_modern.h>
>>
>>   #include <linux/pds/pds_core.h>
>>   #include <linux/pds/pds_adminq.h>
>> diff --git a/drivers/vdpa/pds/virtio_pci.c b/drivers/vdpa/pds/virtio_pci.c
>> new file mode 100644
>> index 000000000000..cb879619dac3
>> --- /dev/null
>> +++ b/drivers/vdpa/pds/virtio_pci.c
>> @@ -0,0 +1,281 @@
>> +// SPDX-License-Identifier: GPL-2.0-or-later
>> +
>> +/*
>> + * adapted from drivers/virtio/virtio_pci_modern_dev.c, v6.0-rc1
>> + */
>> +
>> +#include <linux/virtio_pci_modern.h>
>> +#include <linux/pci.h>
>> +
>> +#include "virtio_pci.h"
>> +
>> +/*
>> + * pds_vdpa_map_capability - map a part of virtio pci capability
>> + * @mdev: the modern virtio-pci device
>> + * @off: offset of the capability
>> + * @minlen: minimal length of the capability
>> + * @align: align requirement
>> + * @start: start from the capability
>> + * @size: map size
>> + * @len: the length that is actually mapped
>> + * @pa: physical address of the capability
>> + *
>> + * Returns the io address of for the part of the capability
>> + */
>> +static void __iomem *
>> +pds_vdpa_map_capability(struct virtio_pci_modern_device *mdev, int off,
>> +                       size_t minlen, u32 align, u32 start, u32 size,
>> +                       size_t *len, resource_size_t *pa)
>> +{
>> +       struct pci_dev *dev = mdev->pci_dev;
>> +       u8 bar;
>> +       u32 offset, length;
>> +       void __iomem *p;
>> +
>> +       pci_read_config_byte(dev, off + offsetof(struct virtio_pci_cap,
>> +                                                bar),
>> +                            &bar);
>> +       pci_read_config_dword(dev, off + offsetof(struct virtio_pci_cap, offset),
>> +                             &offset);
>> +       pci_read_config_dword(dev, off + offsetof(struct virtio_pci_cap, length),
>> +                             &length);
>> +
>> +       /* Check if the BAR may have changed since we requested the region. */
>> +       if (bar >= PCI_STD_NUM_BARS || !(mdev->modern_bars & (1 << bar))) {
>> +               dev_err(&dev->dev,
>> +                       "virtio_pci: bar unexpectedly changed to %u\n", bar);
>> +               return NULL;
>> +       }
>> +
>> +       if (length <= start) {
>> +               dev_err(&dev->dev,
>> +                       "virtio_pci: bad capability len %u (>%u expected)\n",
>> +                       length, start);
>> +               return NULL;
>> +       }
>> +
>> +       if (length - start < minlen) {
>> +               dev_err(&dev->dev,
>> +                       "virtio_pci: bad capability len %u (>=%zu expected)\n",
>> +                       length, minlen);
>> +               return NULL;
>> +       }
>> +
>> +       length -= start;
>> +
>> +       if (start + offset < offset) {
>> +               dev_err(&dev->dev,
>> +                       "virtio_pci: map wrap-around %u+%u\n",
>> +                       start, offset);
>> +               return NULL;
>> +       }
>> +
>> +       offset += start;
>> +
>> +       if (offset & (align - 1)) {
>> +               dev_err(&dev->dev,
>> +                       "virtio_pci: offset %u not aligned to %u\n",
>> +                       offset, align);
>> +               return NULL;
>> +       }
>> +
>> +       if (length > size)
>> +               length = size;
>> +
>> +       if (len)
>> +               *len = length;
>> +
>> +       if (minlen + offset < minlen ||
>> +           minlen + offset > pci_resource_len(dev, bar)) {
>> +               dev_err(&dev->dev,
>> +                       "virtio_pci: map virtio %zu@%u out of range on bar %i length %lu\n",
>> +                       minlen, offset,
>> +                       bar, (unsigned long)pci_resource_len(dev, bar));
>> +               return NULL;
>> +       }
>> +
>> +       p = pci_iomap_range(dev, bar, offset, length);
>> +       if (!p)
>> +               dev_err(&dev->dev,
>> +                       "virtio_pci: unable to map virtio %u@%u on bar %i\n",
>> +                       length, offset, bar);
>> +       else if (pa)
>> +               *pa = pci_resource_start(dev, bar) + offset;
>> +
>> +       return p;
>> +}
>> +
>> +/**
>> + * virtio_pci_find_capability - walk capabilities to find device info.
>> + * @dev: the pci device
>> + * @cfg_type: the VIRTIO_PCI_CAP_* value we seek
>> + * @ioresource_types: IORESOURCE_MEM and/or IORESOURCE_IO.
>> + * @bars: the bitmask of BARs
>> + *
>> + * Returns offset of the capability, or 0.
>> + */
>> +static inline int virtio_pci_find_capability(struct pci_dev *dev, u8 cfg_type,
>> +                                            u32 ioresource_types, int *bars)
>> +{
>> +       int pos;
>> +
>> +       for (pos = pci_find_capability(dev, PCI_CAP_ID_VNDR);
>> +            pos > 0;
>> +            pos = pci_find_next_capability(dev, pos, PCI_CAP_ID_VNDR)) {
>> +               u8 type, bar;
>> +
>> +               pci_read_config_byte(dev, pos + offsetof(struct virtio_pci_cap,
>> +                                                        cfg_type),
>> +                                    &type);
>> +               pci_read_config_byte(dev, pos + offsetof(struct virtio_pci_cap,
>> +                                                        bar),
>> +                                    &bar);
>> +
>> +               /* Ignore structures with reserved BAR values */
>> +               if (bar >= PCI_STD_NUM_BARS)
>> +                       continue;
>> +
>> +               if (type == cfg_type) {
>> +                       if (pci_resource_len(dev, bar) &&
>> +                           pci_resource_flags(dev, bar) & ioresource_types) {
>> +                               *bars |= (1 << bar);
>> +                               return pos;
>> +                       }
>> +               }
>> +       }
>> +       return 0;
>> +}
>> +
>> +/*
>> + * pds_vdpa_probe_virtio: probe the modern virtio pci device, note that the
>> + * caller is required to enable PCI device before calling this function.
>> + * @mdev: the modern virtio-pci device
>> + *
>> + * Return 0 on succeed otherwise fail
>> + */
>> +int pds_vdpa_probe_virtio(struct virtio_pci_modern_device *mdev)
>> +{
>> +       struct pci_dev *pci_dev = mdev->pci_dev;
>> +       int err, common, isr, notify, device;
>> +       u32 notify_length;
>> +       u32 notify_offset;
>> +
>> +       /* check for a common config: if not, use legacy mode (bar 0). */
>> +       common = virtio_pci_find_capability(pci_dev, VIRTIO_PCI_CAP_COMMON_CFG,
>> +                                           IORESOURCE_IO | IORESOURCE_MEM,
>> +                                           &mdev->modern_bars);
>> +       if (!common) {
>> +               dev_info(&pci_dev->dev,
>> +                        "virtio_pci: missing common config\n");
>> +               return -ENODEV;
>> +       }
>> +
>> +       /* If common is there, these should be too... */
>> +       isr = virtio_pci_find_capability(pci_dev, VIRTIO_PCI_CAP_ISR_CFG,
>> +                                        IORESOURCE_IO | IORESOURCE_MEM,
>> +                                        &mdev->modern_bars);
>> +       notify = virtio_pci_find_capability(pci_dev, VIRTIO_PCI_CAP_NOTIFY_CFG,
>> +                                           IORESOURCE_IO | IORESOURCE_MEM,
>> +                                           &mdev->modern_bars);
>> +       if (!isr || !notify) {
>> +               dev_err(&pci_dev->dev,
>> +                       "virtio_pci: missing capabilities %i/%i/%i\n",
>> +                       common, isr, notify);
>> +               return -EINVAL;
>> +       }
>> +
>> +       /* Device capability is only mandatory for devices that have
>> +        * device-specific configuration.
>> +        */
>> +       device = virtio_pci_find_capability(pci_dev, VIRTIO_PCI_CAP_DEVICE_CFG,
>> +                                           IORESOURCE_IO | IORESOURCE_MEM,
>> +                                           &mdev->modern_bars);
>> +
>> +       err = pci_request_selected_regions(pci_dev, mdev->modern_bars,
>> +                                          "virtio-pci-modern");
>> +       if (err)
>> +               return err;
>> +
>> +       err = -EINVAL;
>> +       mdev->common = pds_vdpa_map_capability(mdev, common,
>> +                                              sizeof(struct virtio_pci_common_cfg),
>> +                                              4, 0,
>> +                                              sizeof(struct virtio_pci_common_cfg),
>> +                                              NULL, NULL);
>> +       if (!mdev->common)
>> +               goto err_map_common;
>> +       mdev->isr = pds_vdpa_map_capability(mdev, isr, sizeof(u8), 1,
>> +                                           0, 1, NULL, NULL);
>> +       if (!mdev->isr)
>> +               goto err_map_isr;
>> +
>> +       /* Read notify_off_multiplier from config space. */
>> +       pci_read_config_dword(pci_dev,
>> +                             notify + offsetof(struct virtio_pci_notify_cap,
>> +                                               notify_off_multiplier),
>> +                             &mdev->notify_offset_multiplier);
>> +       /* Read notify length and offset from config space. */
>> +       pci_read_config_dword(pci_dev,
>> +                             notify + offsetof(struct virtio_pci_notify_cap,
>> +                                               cap.length),
>> +                             &notify_length);
>> +
>> +       pci_read_config_dword(pci_dev,
>> +                             notify + offsetof(struct virtio_pci_notify_cap,
>> +                                               cap.offset),
>> +                             &notify_offset);
>> +
>> +       /* We don't know how many VQs we'll map, ahead of the time.
>> +        * If notify length is small, map it all now.
>> +        * Otherwise, map each VQ individually later.
>> +        */
>> +       if ((u64)notify_length + (notify_offset % PAGE_SIZE) <= PAGE_SIZE) {
>> +               mdev->notify_base = pds_vdpa_map_capability(mdev, notify,
>> +                                                           2, 2,
>> +                                                           0, notify_length,
>> +                                                           &mdev->notify_len,
>> +                                                           &mdev->notify_pa);
>> +               if (!mdev->notify_base)
>> +                       goto err_map_notify;
>> +       } else {
>> +               mdev->notify_map_cap = notify;
>> +       }
>> +
>> +       /* Again, we don't know how much we should map, but PAGE_SIZE
>> +        * is more than enough for all existing devices.
>> +        */
>> +       if (device) {
>> +               mdev->device = pds_vdpa_map_capability(mdev, device, 0, 4,
>> +                                                      0, PAGE_SIZE,
>> +                                                      &mdev->device_len,
>> +                                                      NULL);
>> +               if (!mdev->device)
>> +                       goto err_map_device;
>> +       }
>> +
>> +       return 0;
>> +
>> +err_map_device:
>> +       if (mdev->notify_base)
>> +               pci_iounmap(pci_dev, mdev->notify_base);
>> +err_map_notify:
>> +       pci_iounmap(pci_dev, mdev->isr);
>> +err_map_isr:
>> +       pci_iounmap(pci_dev, mdev->common);
>> +err_map_common:
>> +       pci_release_selected_regions(pci_dev, mdev->modern_bars);
>> +       return err;
>> +}
>> +
>> +void pds_vdpa_remove_virtio(struct virtio_pci_modern_device *mdev)
>> +{
>> +       struct pci_dev *pci_dev = mdev->pci_dev;
>> +
>> +       if (mdev->device)
>> +               pci_iounmap(pci_dev, mdev->device);
>> +       if (mdev->notify_base)
>> +               pci_iounmap(pci_dev, mdev->notify_base);
>> +       pci_iounmap(pci_dev, mdev->isr);
>> +       pci_iounmap(pci_dev, mdev->common);
>> +       pci_release_selected_regions(pci_dev, mdev->modern_bars);
>> +}
>> diff --git a/drivers/vdpa/pds/virtio_pci.h b/drivers/vdpa/pds/virtio_pci.h
>> new file mode 100644
>> index 000000000000..f017cfa1173c
>> --- /dev/null
>> +++ b/drivers/vdpa/pds/virtio_pci.h
>> @@ -0,0 +1,8 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
>> +
>> +#ifndef _PDS_VIRTIO_PCI_H_
>> +#define _PDS_VIRTIO_PCI_H_
>> +int pds_vdpa_probe_virtio(struct virtio_pci_modern_device *mdev);
>> +void pds_vdpa_remove_virtio(struct virtio_pci_modern_device *mdev);
>> +#endif /* _PDS_VIRTIO_PCI_H_ */
>> --
>> 2.17.1
>>
> 
