Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22D656C899D
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 01:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbjCYA1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 20:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbjCYA11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 20:27:27 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2058.outbound.protection.outlook.com [40.107.92.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1017715882
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 17:27:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZHHwxiPtBmhcp9vI1uVGvne/3qLcMXEqfe2KW23/zDgdNNZmVjEsMKz9sCTPusX+kc+TIMt6+WnxQ0zXRli6OL0F7T+a9MbuumZ0S01ccT1qEoi4qmv+rSoRST1dfCIA4EwBei3WOzmKRd870wltBJYC4u1njU0fYQOUTgwz8CoFP94tlKuXGgiZdNwWaU80OZpMv3jEAo3XfBeUbnL3Ug1kXGhnHMwwpvzXzMbaPwLDxJCv34vEoTPZ04VRSiO6LEaTwXCNCyeE6GNSgqV9B/jamhIJG3KiFS9MwrYXZL9+kIcF+soBu0+KpcSLEABiyMjLPmKKTNRb4Sf7DDYhkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JJ2XB4XtAP1onu7XnY7d4s+0lBBfwyWwRCQyaR9Dgf0=;
 b=LXaUaVpf46s5lcB2MkWokkbsQ1Jhpby8zOHoJT8RNbGIL33gN4yor19QdICNACWcHWW5INv0NTe+yK6VSpqtAlmXn0pSvZP+KIKoC0lV+zhCnXEb+3POclj/qNtEcnGo6odKHjZnjq4MiDyC1zEcHo5mg92iijoK7pxkJf4eqaxEm+nVlJNAJ17sGSwRTfqQ+Hg+kGSKTHgsdCHh11HiZ8Vp5NwvV+CqvTTseAHDcxkJ/ny9NAFXzDuu7OBQrlILWjYZP3Xk+5ISNmzyOVQ3Md7gbW+s3G7JgncWL/qVhNYRWYeKwok4rdP0THtwpKZRJT3hzzemOODgEEOTwbU4wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JJ2XB4XtAP1onu7XnY7d4s+0lBBfwyWwRCQyaR9Dgf0=;
 b=NEyoK/NGM0Z1ivyZRo9OYZ1mhZ9Wz20vfUNiqBvgZHAuataUeHsbiZmoFu+AMwgo/tH5oIJUU0HX/iOHuNgMylvMRmK3BuiJ3XyUHstqbtGq43uFaXkrJwI5LwXpmX9ydKxgY1oxl+XQaffyy3wHMqvxs4FYp1mQ4fX3DiEB77Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 PH7PR12MB6881.namprd12.prod.outlook.com (2603:10b6:510:1b7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Sat, 25 Mar
 2023 00:26:43 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab%9]) with mapi id 15.20.6178.038; Sat, 25 Mar 2023
 00:26:43 +0000
Message-ID: <90a64850-1c58-6c89-c46f-2971760f4c57@amd.com>
Date:   Fri, 24 Mar 2023 17:26:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v3 virtio 4/8] pds_vdpa: virtio bar setup for vdpa
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io
References: <20230322191038.44037-1-shannon.nelson@amd.com>
 <20230322191038.44037-5-shannon.nelson@amd.com>
 <CACGkMEtBGZ-ViLk=tRJiAMm_YJJ2XomRQAKdCpa1tWE4KmuRJA@mail.gmail.com>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <CACGkMEtBGZ-ViLk=tRJiAMm_YJJ2XomRQAKdCpa1tWE4KmuRJA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR04CA0024.namprd04.prod.outlook.com
 (2603:10b6:a03:40::37) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|PH7PR12MB6881:EE_
X-MS-Office365-Filtering-Correlation-Id: a08e3788-d47a-4b76-c68a-08db2cc79bd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DbArvrlGd7Xx4K7v4f0Ak1poyabW03z7CmuF4n9EoOJLOrcZEyIhgqUNxqki3qLW7N7xIkxCSRxeRKTt3lTbHJZfo5THy8j5/zzMakO0VgA/BiiliWAqo3JiH1CoDKmNDcMyowEijA75bMM4vrb5AZe/d1B2QFkzdcBcqFJxKlVDYhUF4GpE4LArlWiM9Fego4yxcETVjtO779cIawTIn7TGmehFi9SlpTxLYQX3NOmIgOn/LyNv0XVhQgOyTbo2xjgjSgpKqykl3Q+OyWJwWkeVEvzlK6tAOzCaczsxmWoviKi7ITFrJsLHdafViUb6FdvUw1vW4OvRdIepr3SxALzmT9ErQsI70kMG6lEwqWU9T0tyY7fj9zAXbUOBbR3PpSUivX9bh8KI2ht6cHyBw09PrJE4b0lVTmkwlN78SxSXk8Qv9rB2qmBPpS7dYwRo0q5dnodeabQPq5ajdxRcm4vBvHj9zhI6FI58KVXa+w9nwZuT77QebTTolyjbaGCsE63q9smI9oKpJC2vWJvKJz5PL6a6+hP7nrf9VrHboIs6rDDwq0iPB17ZEXsPogBtsJIqNnA0xT5/CniCBGped5cczYXecod7BPFb+Mry97nrO2w835ZH2QLM0urmEOgSxPLEKUOlevGvR3OYRp6Zsb1SVgZEWq0s7WA84HD/RRCc2CGV77MNEdqy9g6F0LBwW/92QDQmqxiXvW9437iaGshNqzL6FK7yvC45U3BkTj8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(376002)(136003)(366004)(451199021)(2616005)(2906002)(38100700002)(31686004)(5660300002)(8676002)(4326008)(66476007)(6916009)(316002)(66556008)(41300700001)(66946007)(44832011)(6486002)(6506007)(6512007)(26005)(36756003)(53546011)(8936002)(478600001)(86362001)(31696002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SlpSaXJzakl3WC8ycnNsOXhoM2loREhiV1U2MlNrTlc0eDNoTXM5MFZTN08w?=
 =?utf-8?B?MnhXdThOUmFVOWpMaHhVc1NVcXkyWWwxdEZYMERHRnVVVFMrU3RMdjE0R0cr?=
 =?utf-8?B?b0duUFk3TVY2WFQwZzhZZUg2Ykc1N3UzT0tkcm5xblA1QnpvVTkyWDlXTjVG?=
 =?utf-8?B?U25KZEh0UElWUTM1R0VCNExiakdrZFNxREFId2lHS0dmTG84NlN0c3RFanlG?=
 =?utf-8?B?UFJNbFpCdHAwNW9sak9VWnlrQlhVaHpIMy9XYyt0bHVER1NiYngrNzdzMHBO?=
 =?utf-8?B?dWt6ZmJyTy9UVVdvQ1ZjOC9zZWVycUhmWlA5cllmNU1mZ0V3MjlpYThPajJQ?=
 =?utf-8?B?OVJHa05CZEpuWi8ycXJMYXlhRkhQbXU0K3BaQmRRcTBaZ0xGMXpUcHphbWlt?=
 =?utf-8?B?VEN5aysvRDRlRVA1R0dLV3diazN0Y0g5cWFvWXRic0cyV1hBazdKbjV5M2JU?=
 =?utf-8?B?VFV4QithU1NoL2Q2U3NkYmlWU0NENnBra2NtYUZRSnZqTFlhbFJSaWZYWVlD?=
 =?utf-8?B?SDR0MXF6MUVEeUJQZGJ0NDlQUEVZMHZTU1B0ZVN2a2R3OXZaUmJoRkhQSkFq?=
 =?utf-8?B?cFJsN1d3K3JDWFJKQ0pVZWEvNEdobHh4dW1ST082Qk1PMHF4WXNBM0Fuc2RO?=
 =?utf-8?B?Mjh5RERTNkt1Y0RGTnpNWHFBUTJrL3lIcFZRY3duYU1pejd3eVhZcGZDWXQ4?=
 =?utf-8?B?MXlKb01OMytyeUUzR0R5d3VvaytyK0V1cDJDV3FFdG82b0VkUGVIQUJFVFM1?=
 =?utf-8?B?MEdQaDJGeER2ZjA2Z3FRUis0MGhjbkRqeHlwdms5MXRDbldGaXA3M0lRVExy?=
 =?utf-8?B?ZGFLd1oyb3hseU82Y0dQblpFNUxaNjE3S0FPcXdoWnJqd0x1aDBsZmpMbHM0?=
 =?utf-8?B?YnJKZmF5dTZxV3VURU8raHNNSGlMRFpPSk5wWlBndE1ZZklBaDNLZUFUdzNw?=
 =?utf-8?B?dEFJS2hPUVBwUnBJeGthMWFhRmFSeldrcC9mK1k2K3hzOW5EL2FNUXB0eDNB?=
 =?utf-8?B?bU5DTUVMTWw5aE5MV2RVZ0FCT1N4Z2pxSG9nSTFWRzNNa09Hb2w3Vk1rNnNR?=
 =?utf-8?B?aE9CWW13cXhQSXozRHk5WE9KeVlvV1hxSWREZXRZTTBhRy9FZ1FKRlJSY2dz?=
 =?utf-8?B?MTkvaTNFbFMvMEF4ZVRJcVp5YlJpY3R3SFg0Qm1jTnBzaVB0R0FrcC9sL3p3?=
 =?utf-8?B?TDA0OTFsL2E5dWE2ZVhsVndqZUVhUUwyZlFVbWVBQkhSZlZlcDh2TUw3a1NU?=
 =?utf-8?B?UXdDRk8xdEFsQndJcGdkQlBqMXdGVVJoaFNjaDZNNVNjdDJxMENtMjl0REp6?=
 =?utf-8?B?WjIvSGo0OHI3VmJJM3dvcWxMK085TG5YV2tUSmR6N1pGRVd3NWt5Z09QOXlY?=
 =?utf-8?B?TnZPMU5rajVxZzZWU2hEbTlHTnVqSWMvcnQ4djdrTmdEazlMeVM5WHVob2ZO?=
 =?utf-8?B?SUp5THVSR1NEc1pCODNROGU4WHRmVDN1dWRMV0NqUkxWZGJqaHdvdHl0aFN6?=
 =?utf-8?B?d2MzQyt6SzRyRXFaTzdyTGlIK3ZFS0p0eXVMbXVqam40NzNWNXpwVExKYWRs?=
 =?utf-8?B?d3BkNTNTMzljVW1VVWxxb3dicHJBZllaNGkva1Y3NkpXakRDSnY5czlxL1dZ?=
 =?utf-8?B?KzJRRXpFSFY0Z29INWh2Wm1XNjAyYVdKUjRGaFpVNEdOZmNjWjVZSVE4MXVq?=
 =?utf-8?B?c2VOcVp2SXBLME9odzRlR05VbGovV0IxN2VEb0VqN0prNHJCd2RiTjdqZGcz?=
 =?utf-8?B?THZEK1l6RUJJblljYzdPUlc5dlZ1ek9TTEJBbVdqSEJzNUExc2g5NnJuM2s1?=
 =?utf-8?B?SzV0MDAzdW1kck0yMzIwSTR3UjRkQXlCV0ZScGxVSzFiSUIvYW1lVjFHSnh1?=
 =?utf-8?B?cjMra053M1ViTjZGc1FnR2FpU0M2NVNBVVZ2VzBTRGZsOUJkZ21FUW9JV1hR?=
 =?utf-8?B?dDZ1R0JQRTQ2SDJOZndjdHc4UFUwQjd0bmlFZDYyR3dhUGNZYW9hb0hsMmxi?=
 =?utf-8?B?Q3hacEtIczFsV3VQYURoNHdOOXdEK3E0ZHpzM1pnY0VKaWVsRUtQVmx0NCtU?=
 =?utf-8?B?SC93VzI5OWNaak96bTAvM1E0NnBmNDBlTWJ1S0pmRkUreTErbkRYdnhqak5X?=
 =?utf-8?Q?q42kyz71xKvet3yAZu4dCMp87?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a08e3788-d47a-4b76-c68a-08db2cc79bd7
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2023 00:26:42.9186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iJ+lueUSUgTvkwRG6kdHHBSBhur3wWAoLBzezVG4MmxK5PNzKYNzbLSGjj2L2/stuCeJacCTG+S0KGuyW0bv8w==
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

On 3/22/23 10:11 PM, Jason Wang wrote:
> On Thu, Mar 23, 2023 at 3:11 AM Shannon Nelson <shannon.nelson@amd.com> wrote:
>>
>> Prep and use the "modern" virtio bar utilities to get our
>> virtio config space ready.
>>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> ---
>>   drivers/vdpa/pds/aux_drv.c | 25 +++++++++++++++++++++++++
>>   drivers/vdpa/pds/aux_drv.h |  3 +++
>>   2 files changed, 28 insertions(+)
>>
>> diff --git a/drivers/vdpa/pds/aux_drv.c b/drivers/vdpa/pds/aux_drv.c
>> index 881acd869a9d..8f3ae3326885 100644
>> --- a/drivers/vdpa/pds/aux_drv.c
>> +++ b/drivers/vdpa/pds/aux_drv.c
>> @@ -4,6 +4,7 @@
>>   #include <linux/auxiliary_bus.h>
>>   #include <linux/pci.h>
>>   #include <linux/vdpa.h>
>> +#include <linux/virtio_pci_modern.h>
>>
>>   #include <linux/pds/pds_common.h>
>>   #include <linux/pds/pds_core_if.h>
>> @@ -20,12 +21,22 @@ static const struct auxiliary_device_id pds_vdpa_id_table[] = {
>>          {},
>>   };
>>
>> +static int pds_vdpa_device_id_check(struct pci_dev *pdev)
>> +{
>> +       if (pdev->device != PCI_DEVICE_ID_PENSANDO_VDPA_VF ||
>> +           pdev->vendor != PCI_VENDOR_ID_PENSANDO)
>> +               return -ENODEV;
> 
> Similar to patch 1, if we don't need to override we probably can
> rename the device_id_check_override to device_id_check(). Otherwise
> it's better to let this function to return device id.

Sure, I'll tweak this.
sln


> 
> Thanks
> 
>> +
>> +       return 0;
>> +}
>> +
>>   static int pds_vdpa_probe(struct auxiliary_device *aux_dev,
>>                            const struct auxiliary_device_id *id)
>>
>>   {
>>          struct pds_auxiliary_dev *padev =
>>                  container_of(aux_dev, struct pds_auxiliary_dev, aux_dev);
>> +       struct device *dev = &aux_dev->dev;
>>          struct pds_vdpa_aux *vdpa_aux;
>>          int err;
>>
>> @@ -42,8 +53,21 @@ static int pds_vdpa_probe(struct auxiliary_device *aux_dev,
>>          if (err)
>>                  goto err_free_mem;
>>
>> +       /* Find the virtio configuration */
>> +       vdpa_aux->vd_mdev.pci_dev = padev->vf_pdev;
>> +       vdpa_aux->vd_mdev.device_id_check_override = pds_vdpa_device_id_check;
>> +       vdpa_aux->vd_mdev.dma_mask_override = DMA_BIT_MASK(PDS_CORE_ADDR_LEN);
>> +       err = vp_modern_probe(&vdpa_aux->vd_mdev);
>> +       if (err) {
>> +               dev_err(dev, "Unable to probe for virtio configuration: %pe\n",
>> +                       ERR_PTR(err));
>> +               goto err_free_mgmt_info;
>> +       }
>> +
>>          return 0;
>>
>> +err_free_mgmt_info:
>> +       pci_free_irq_vectors(padev->vf_pdev);
>>   err_free_mem:
>>          kfree(vdpa_aux);
>>          auxiliary_set_drvdata(aux_dev, NULL);
>> @@ -56,6 +80,7 @@ static void pds_vdpa_remove(struct auxiliary_device *aux_dev)
>>          struct pds_vdpa_aux *vdpa_aux = auxiliary_get_drvdata(aux_dev);
>>          struct device *dev = &aux_dev->dev;
>>
>> +       vp_modern_remove(&vdpa_aux->vd_mdev);
>>          pci_free_irq_vectors(vdpa_aux->padev->vf_pdev);
>>
>>          kfree(vdpa_aux);
>> diff --git a/drivers/vdpa/pds/aux_drv.h b/drivers/vdpa/pds/aux_drv.h
>> index 94ba7abcaa43..8f5140401573 100644
>> --- a/drivers/vdpa/pds/aux_drv.h
>> +++ b/drivers/vdpa/pds/aux_drv.h
>> @@ -4,6 +4,8 @@
>>   #ifndef _AUX_DRV_H_
>>   #define _AUX_DRV_H_
>>
>> +#include <linux/virtio_pci_modern.h>
>> +
>>   #define PDS_VDPA_DRV_DESCRIPTION    "AMD/Pensando vDPA VF Device Driver"
>>   #define PDS_VDPA_DRV_NAME           "pds_vdpa"
>>
>> @@ -16,6 +18,7 @@ struct pds_vdpa_aux {
>>
>>          int vf_id;
>>          struct dentry *dentry;
>> +       struct virtio_pci_modern_device vd_mdev;
>>
>>          int nintrs;
>>   };
>> --
>> 2.17.1
>>
> 
