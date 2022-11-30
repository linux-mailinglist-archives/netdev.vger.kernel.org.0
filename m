Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5C6D63CC53
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 01:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiK3ALj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 19:11:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiK3ALh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 19:11:37 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2088.outbound.protection.outlook.com [40.107.102.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 000BE64A3F
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 16:11:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O36Hf0uLSKcEYC2aMuyn9eQwJM7JUKbE+UBCvBHuP5Rn6cx9MxYqM92ndEjheJHQZ5hyqVrkB2Fx9Z82XedQPgQBC8+24OzdTGaKZ40EGt8hMNLxxX6uZvPW0m+YbI+sGAuTzNAAkH+rHKQn3WivmeyCWe4zazr1whXPrsBK/L2Lgvk4Se1beZJ2CTGJjiRW35hUs5OiFpnBBr5EylIsn42DLYSvnIm5Z6yOdHxnmHtRKWeJ4L0wDcE4LwTCrdyw2leHwAkVmdfzH/yBwFSxvyJPB8Gin23yZpxiZQ9aoQI7LSi3klQcxJIME+ohwzgyykGVWFkk/gNtNOIjYInn2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9wL2lb5R1v58trtDMUCNEZsnlNHVXTtNK+0dPIcH6xs=;
 b=MYtmJq+gcQcgEpgyLwADZlVu9egiMtRxFHPI1U1Z9Zan6FszHdN8MfgmLj+Xs0kuArohJCkj/MaAs9ng9TS3gfKlDNRX90GSxR92AyTwazdZr6pypQltj5XwzlQB6g1RfqIeuL2MJ8M1VLhY5EJKet9EYiuKCFlEJ1VWG6UUegs4fvgbSNIBcdFoBgJrKyIBBw4pZGfBQjEq3Od4244UDFXCQEL4RyJ6eUqPWvsq/4v6hht0cH/QYX4KjJLx/yAOoxM5IdYuhBsEYvZL/RamBMQ4PqB6+qG7BJFqdl1HzS6lD9rq/GHPpexRuQxV14/Lcqqr+28Zuvk2w63IiJ2cvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9wL2lb5R1v58trtDMUCNEZsnlNHVXTtNK+0dPIcH6xs=;
 b=FRSxqZtB97MRmgPvBjjuiXPc6WkvdDg36H4qZMpxpYtnVK1ErzJ3THvsweMxM1QSpOTlc51kwoda2ncg76GmyZffwZW0C+tRpsWDSJ3LnFp+chbKWyArh131sz3ysTGuvFUMmKQud/kGh95q54eaod/cDzrDqvh2ntbNvE1BxBo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 SA0PR12MB4416.namprd12.prod.outlook.com (2603:10b6:806:99::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Wed, 30 Nov 2022 00:11:31 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b%6]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 00:11:31 +0000
Message-ID: <4b4e7474-5b36-6b2c-a0a5-2e198e1bab0c@amd.com>
Date:   Tue, 29 Nov 2022 16:11:28 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [RFC PATCH net-next 18/19] pds_vdpa: add support for vdpa and
 vdpamgmt interfaces
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>,
        Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mst@redhat.com, virtualization@lists.linux-foundation.org,
        drivers@pensando.io
References: <20221118225656.48309-1-snelson@pensando.io>
 <20221118225656.48309-19-snelson@pensando.io>
 <CACGkMEtvz4LrS9_t3NWdsEs=XnrtOcAgDSJJ4Z_efZR5c5D-cg@mail.gmail.com>
From:   Shannon Nelson <shnelson@amd.com>
In-Reply-To: <CACGkMEtvz4LrS9_t3NWdsEs=XnrtOcAgDSJJ4Z_efZR5c5D-cg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0123.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::8) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|SA0PR12MB4416:EE_
X-MS-Office365-Filtering-Correlation-Id: a55afe1f-9e8f-4331-bb3e-08dad2676ecf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KmRuH6bmZqaf/uVQGO1ox7i1QTyDZUiciFnP+6TVed2G/k+NoD7g0nysYTqGIeg9RBoHh68014ooBKC91bZrwd2xY3P+yAueov7bnI6Psr56y8W3V8IHGAEVTok1XIxe7QMNQbzDZf0PSfeZDow1cRriwjxLuYuHaEbX7dTMqkelAnkLTeI54b7wJavoSFV6o9pYwBPX52KGWW6Zo0qENltFNC/5Ew+kCapJpcE53Vl58dsyHVvFHmRZLWxjAjxz5yFD3fJ8p1ibrB1v9kwT2hyg5/fcORhwdqroznuWdLXF8Bli2t+fD1XUMpmcnHkJmyYv82gt+X7NyN8Q4LGJ4vpgcfdRePO1OTu3sFudKuw0P2ub7Pt6AatKSAI7VZDRntG00EcaiArDIEIKTMSXWCrozdmGT0nUHnEKWlVm7edRbxmahUkJ7kKWVEyd9xVbpxm1jBOBNHRwyLVBWNwI+ewwCyZfWtodRXB9aGbo5TmosT7RKlNGoTFleyXkIx0bSj7yvsjwwO+CTNiA69Nk8pBsJkq/IFxcFYRzC3x+YYOjNupHwZLfdPyAZKJnLDz55TcHmh/7tOR3qnTH8y6cDLGcHVho/NfUU1ZSRhDVCI3VOxEKMaUJ5m7NYToh++9Bs8CjNS4uIb4rjJPftkAK5JhPgTFb9hZoPnaAtJFgMEQQTw+vex/gXHsdrGiJHxu0dKDEq1jU30uQAI4VGMHhHzmtmwVxJiaIzRVr4K8MkmA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(366004)(396003)(136003)(451199015)(66899015)(38100700002)(83380400001)(31686004)(110136005)(6506007)(6486002)(6666004)(26005)(6512007)(36756003)(31696002)(186003)(2616005)(53546011)(8936002)(478600001)(5660300002)(30864003)(66556008)(316002)(8676002)(66476007)(4326008)(41300700001)(2906002)(66946007)(45980500001)(43740500002)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aHdkRjFSME9HL3hIYXk1Mi9ML1NJOXZBQzVaaU1QbW1XNTJ6V3d2K1FabkYz?=
 =?utf-8?B?SUx0TUtpdFBSMkNBMnlCVnZ3blQ3VS9RbzlZcEVXV2w4RFM2dXcxWU91akRB?=
 =?utf-8?B?NTA3cUdxRlQ1RVl5aEFFVFhhNitRK0Zrd0FvNWpSbUJqcGswbVcvaFh3a1hu?=
 =?utf-8?B?eEJ1bE5DOVpWd0loN2YyRC9jSkZUSTRRY1d2M0RJQk51eWFTVzBpMWJuSUNV?=
 =?utf-8?B?OGh2bWxLWnV1V3lBbkFrWU4wOFVFZlZWSzh1bzRqa3hzZkhVclBkZmlKZGZY?=
 =?utf-8?B?MDRPa2IwQWEveHkzdktMY2VSeWJEaityMWNtSWtuMVlsZnY0aC8wRDh0THk2?=
 =?utf-8?B?OGJ1TWhzWDJlK0hvd2poU1JySXBtQ3hORHlFdWgxWjRSOTh5bmVDdFhnRHc5?=
 =?utf-8?B?STA1cC93OEJTQ1RpdWxRSlNxMDRRUFBhbzV6cFJiYUtkNUJkV0ZoeThoNG5M?=
 =?utf-8?B?YVBIcjZ3ZTFpaHM5K3ZrV3dsYlphaFYrS0FQL2xEeG92cjN0bkQ4MTRkL0ZI?=
 =?utf-8?B?OVYrako1SldZSEJVOUxDTmg3Z3M0UWp2T3UwWnR6dXJURHFuRXNWKzkwcDBY?=
 =?utf-8?B?NFNsQ2VzdmduZ1FyTXJvd0YwZlFSSXpaMmhOQXRXdVZ5ZTRneVdWSjJibXhr?=
 =?utf-8?B?bDZBcm54N1VzWC9heUY3WUhSSm85U3ljNlFkanVpZjd1cWg1eUNOVU0zb25W?=
 =?utf-8?B?S1lxcWRhU1NxWFlVRjRUZE1rdHhEOGw5RlB1MVFKSmZjMFpudXB2dldkYmUv?=
 =?utf-8?B?SUoyQkYrNW5UbjVJaW9VN3cxazh4aitFcU9EcnIxQzEwM3lBNk14WG42Y1NI?=
 =?utf-8?B?Q2VHTDEybVFocUx2QU5qU0J3dEwrS3l0M0RWalVSdFY3SWdUVzRYVjMwYlRK?=
 =?utf-8?B?c2FublJTd2JZQXBMMTB5TnAwVi9SY2ZoaXFGVVNGWjhTbUVMSmFhbzJCSEhV?=
 =?utf-8?B?anlNQ3Z2My84cTZTZXJJb0NaUkd1aUQ5ODYxa0dNWjRpQ3cwOHlySEI1dDl0?=
 =?utf-8?B?M0g3UWJlQ3M5UXJ0dVpYSFZYejl0Mkx4QnFTOFNqSS8vaks0ZTN1RUhFaDlX?=
 =?utf-8?B?dkFLNlRKelNHbmhGYm15UDFQdmFLVXpoN1lhTnFiYmR2L0lwRFlUTGpsdEpU?=
 =?utf-8?B?bldpRnIwYU1jdlQ3RzRjTUcxazFEbGxGVmtrVkdoS2pjemxBejVYOWNmNTk2?=
 =?utf-8?B?eDErTXQ3YXUzSW1mQUdvZG5ncjZtZk1zZmxUbjJrb3Z0WEpOV3ltSDlVanRa?=
 =?utf-8?B?YjJyb1NtSHNGTHJkZmxTY0FUWlo0L214N3ZzbXJSSmtjRjNzU3U1RzlXUFF0?=
 =?utf-8?B?cm15RUpLZ1k2L2xrS0dOTXYzc0tiWHMzRW9tNTdmb2xheHAzb1B5dHhVc3d2?=
 =?utf-8?B?NDV6eVIvb1dZWlRNdHR4YmNhdG5wcEhucmF4Si9HazlmL0lrbkNBZDZsRk1i?=
 =?utf-8?B?Umxad0hpMXgwdlkxNVZOS214ZmtGRHdJL1M4NjFxOXN6QWIreGxROEgxWVRx?=
 =?utf-8?B?UjY2djJIUHBESTVsUlZKV2xheDNydDJobUdNamhTWkIvLzNxK3hQOWhPN2xz?=
 =?utf-8?B?bnZzenlmTnh2b3ZTdjB6THB6VWxFVXcwR2VHZUtROVZrWkpteXNHUFJTVWJX?=
 =?utf-8?B?Y3JkNXU2ck9KNExCR0hJRUh0S3FYbEUrZlNSNDR6aTJtVUtESS9lNmhmNHV3?=
 =?utf-8?B?Z2V1cG9aM3NWanY3K3hocnV4S1E5WktlRElvTnVpQmY1R2MzVnVvY3V2NGZw?=
 =?utf-8?B?QWREK3FtRFhTaDhCeThYRlB5SkVyVWllSldpZnRIeFhEaVlGeFhVWURYK2h5?=
 =?utf-8?B?c3huNll5OXp6dm9vVTFIRjVLNzdsZk0xVWlVcFMwZmpSZW04WGNodTM5RGg0?=
 =?utf-8?B?NXNKZnV6RjQ3TnpSRnd3UHVxaEZOaGdiS1J1S1Q5ZFU4VWFhY2VsM2lKQXVB?=
 =?utf-8?B?djdhYktpT012TWFwQkN5THpPSk8rRnRaM3ltRVZhbDlnQjJZSFhTZnhqN0J5?=
 =?utf-8?B?N1ZBM0dma3JDU1hqRkU0cEJoMjRxWjc1Wkhrek9KcTNUbXpsMmJqN25xRFov?=
 =?utf-8?B?Y2lzS2NBYjlKOFJ1aWhpV3NudVFIUXdWekZHYXh2YURPK0d5VUJoRlVqY1J1?=
 =?utf-8?Q?eNFTIx6c9BYEzl9PhZ2AwXeHk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a55afe1f-9e8f-4331-bb3e-08dad2676ecf
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 00:11:31.0325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6n1RZAzsbpJwczkgihuMIALz+YUL2V2RKJ4bmXDVoPkWZLZ4g/4dN50N5AUKxQ205phzrDXF59tdYoFIDtK7vA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4416
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/22 10:32 PM, Jason Wang wrote:
> On Sat, Nov 19, 2022 at 6:57 AM Shannon Nelson <snelson@pensando.io> wrote:
>>
>> This is the vDPA device support, where we advertise that we can
>> support the virtio queues and deal with the configuration work
>> through the pds_core's adminq.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> ---
>>   drivers/vdpa/pds/Makefile   |   3 +-
>>   drivers/vdpa/pds/aux_drv.c  |  33 ++
>>   drivers/vdpa/pds/debugfs.c  | 167 ++++++++
>>   drivers/vdpa/pds/debugfs.h  |   4 +
>>   drivers/vdpa/pds/vdpa_dev.c | 796 ++++++++++++++++++++++++++++++++++++
>>   5 files changed, 1002 insertions(+), 1 deletion(-)
>>   create mode 100644 drivers/vdpa/pds/vdpa_dev.c
>>
>> diff --git a/drivers/vdpa/pds/Makefile b/drivers/vdpa/pds/Makefile
>> index fafd356ddf86..7fde4a4a1620 100644
>> --- a/drivers/vdpa/pds/Makefile
>> +++ b/drivers/vdpa/pds/Makefile
>> @@ -7,4 +7,5 @@ pds_vdpa-y := aux_drv.o \
>>                cmds.o \
>>                pci_drv.o \
>>                debugfs.o \
>> -             virtio_pci.o
>> +             virtio_pci.o \
>> +             vdpa_dev.o
>> diff --git a/drivers/vdpa/pds/aux_drv.c b/drivers/vdpa/pds/aux_drv.c
>> index aef3c984dc90..83b9a5a79325 100644
>> --- a/drivers/vdpa/pds/aux_drv.c
>> +++ b/drivers/vdpa/pds/aux_drv.c
>> @@ -12,6 +12,7 @@
>>   #include <linux/pds/pds_vdpa.h>
>>
>>   #include "aux_drv.h"
>> +#include "vdpa_dev.h"
>>   #include "pci_drv.h"
>>   #include "debugfs.h"
>>
>> @@ -25,10 +26,25 @@ static void
>>   pds_vdpa_aux_notify_handler(struct pds_auxiliary_dev *padev,
>>                              union pds_core_notifyq_comp *event)
>>   {
>> +       struct pds_vdpa_device *pdsv = padev->priv;
>>          struct device *dev = &padev->aux_dev.dev;
>>          u16 ecode = le16_to_cpu(event->ecode);
>>
>>          dev_info(dev, "%s: event code %d\n", __func__, ecode);
>> +
>> +       /* Give the upper layers a hint that something interesting
>> +        * may have happened.  It seems that the only thing this
>> +        * triggers in the virtio-net drivers above us is a check
>> +        * of link status.
>> +        *
>> +        * We don't set the NEEDS_RESET flag for EVENT_RESET
>> +        * because we're likely going through a recovery or
>> +        * fw_update and will be back up and running soon.
>> +        */
>> +       if (ecode == PDS_EVENT_RESET || ecode == PDS_EVENT_LINK_CHANGE) {
>> +               if (pdsv->hw.config_cb.callback)
>> +                       pdsv->hw.config_cb.callback(pdsv->hw.config_cb.private);
>> +       }
>>   }
>>
>>   static int
>> @@ -80,10 +96,25 @@ pds_vdpa_aux_probe(struct auxiliary_device *aux_dev,
>>                  goto err_register_client;
>>          }
>>
>> +       /* Get device ident info and set up the vdpa_mgmt_dev */
>> +       err = pds_vdpa_get_mgmt_info(vdpa_aux);
>> +       if (err)
>> +               goto err_register_client;
>> +
>> +       /* Let vdpa know that we can provide devices */
>> +       err = vdpa_mgmtdev_register(&vdpa_aux->vdpa_mdev);
>> +       if (err) {
>> +               dev_err(dev, "%s: Failed to initialize vdpa_mgmt interface: %pe\n",
>> +                       __func__, ERR_PTR(err));
>> +               goto err_mgmt_reg;
>> +       }
>> +
>>          pds_vdpa_debugfs_add_ident(vdpa_aux);
>>
>>          return 0;
>>
>> +err_mgmt_reg:
>> +       padev->ops->unregister_client(padev);
>>   err_register_client:
>>          auxiliary_set_drvdata(aux_dev, NULL);
>>   err_invalid_driver:
>> @@ -98,6 +129,8 @@ pds_vdpa_aux_remove(struct auxiliary_device *aux_dev)
>>          struct pds_vdpa_aux *vdpa_aux = auxiliary_get_drvdata(aux_dev);
>>          struct device *dev = &aux_dev->dev;
>>
>> +       vdpa_mgmtdev_unregister(&vdpa_aux->vdpa_mdev);
>> +
>>          vdpa_aux->padev->ops->unregister_client(vdpa_aux->padev);
>>          if (vdpa_aux->vdpa_vf)
>>                  pci_dev_put(vdpa_aux->vdpa_vf->pdev);
>> diff --git a/drivers/vdpa/pds/debugfs.c b/drivers/vdpa/pds/debugfs.c
>> index f766412209df..aa3143126a7e 100644
>> --- a/drivers/vdpa/pds/debugfs.c
>> +++ b/drivers/vdpa/pds/debugfs.c
>> @@ -11,6 +11,7 @@
>>   #include <linux/pds/pds_auxbus.h>
>>   #include <linux/pds/pds_vdpa.h>
>>
>> +#include "vdpa_dev.h"
>>   #include "aux_drv.h"
>>   #include "pci_drv.h"
>>   #include "debugfs.h"
>> @@ -19,6 +20,72 @@
>>
>>   static struct dentry *dbfs_dir;
>>
>> +#define PRINT_SBIT_NAME(__seq, __f, __name)                     \
>> +       do {                                                    \
>> +               if (__f & __name)                               \
>> +                       seq_printf(__seq, " %s", &#__name[16]); \
>> +       } while (0)
>> +
>> +static void
>> +print_status_bits(struct seq_file *seq, u16 status)
>> +{
>> +       seq_puts(seq, "status:");
>> +       PRINT_SBIT_NAME(seq, status, VIRTIO_CONFIG_S_ACKNOWLEDGE);
>> +       PRINT_SBIT_NAME(seq, status, VIRTIO_CONFIG_S_DRIVER);
>> +       PRINT_SBIT_NAME(seq, status, VIRTIO_CONFIG_S_DRIVER_OK);
>> +       PRINT_SBIT_NAME(seq, status, VIRTIO_CONFIG_S_FEATURES_OK);
>> +       PRINT_SBIT_NAME(seq, status, VIRTIO_CONFIG_S_NEEDS_RESET);
>> +       PRINT_SBIT_NAME(seq, status, VIRTIO_CONFIG_S_FAILED);
>> +       seq_puts(seq, "\n");
>> +}
>> +
>> +#define PRINT_FBIT_NAME(__seq, __f, __name)                \
>> +       do {                                               \
>> +               if (__f & BIT_ULL(__name))                 \
>> +                       seq_printf(__seq, " %s", #__name); \
>> +       } while (0)
>> +
>> +static void
>> +print_feature_bits(struct seq_file *seq, u64 features)
>> +{
>> +       seq_puts(seq, "features:");
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CSUM);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_GUEST_CSUM);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_MTU);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_MAC);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_GUEST_TSO4);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_GUEST_TSO6);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_GUEST_ECN);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_GUEST_UFO);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_HOST_TSO4);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_HOST_TSO6);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_HOST_ECN);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_HOST_UFO);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_MRG_RXBUF);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_STATUS);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CTRL_VQ);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CTRL_RX);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CTRL_VLAN);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CTRL_RX_EXTRA);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_GUEST_ANNOUNCE);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_MQ);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CTRL_MAC_ADDR);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_HASH_REPORT);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_RSS);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_RSC_EXT);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_STANDBY);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_SPEED_DUPLEX);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_F_NOTIFY_ON_EMPTY);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_F_ANY_LAYOUT);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_F_VERSION_1);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_F_ACCESS_PLATFORM);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_F_RING_PACKED);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_F_ORDER_PLATFORM);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_F_SR_IOV);
>> +       seq_puts(seq, "\n");
>> +}
>> +
>>   void
>>   pds_vdpa_debugfs_create(void)
>>   {
>> @@ -49,10 +116,18 @@ static int
>>   identity_show(struct seq_file *seq, void *v)
>>   {
>>          struct pds_vdpa_aux *vdpa_aux = seq->private;
>> +       struct vdpa_mgmt_dev *mgmt;
>>
>>          seq_printf(seq, "aux_dev:            %s\n",
>>                     dev_name(&vdpa_aux->padev->aux_dev.dev));
>>
>> +       mgmt = &vdpa_aux->vdpa_mdev;
>> +       seq_printf(seq, "max_vqs:            %d\n", mgmt->max_supported_vqs);
>> +       seq_printf(seq, "config_attr_mask:   %#llx\n", mgmt->config_attr_mask);
>> +       seq_printf(seq, "supported_features: %#llx\n", mgmt->supported_features);
>> +       print_feature_bits(seq, mgmt->supported_features);
>> +       seq_printf(seq, "local_mac_bit:      %d\n", vdpa_aux->local_mac_bit);
>> +
>>          return 0;
>>   }
>>   DEFINE_SHOW_ATTRIBUTE(identity);
>> @@ -64,4 +139,96 @@ pds_vdpa_debugfs_add_ident(struct pds_vdpa_aux *vdpa_aux)
>>                              vdpa_aux, &identity_fops);
>>   }
>>
>> +static int
>> +config_show(struct seq_file *seq, void *v)
>> +{
>> +       struct pds_vdpa_device *pdsv = seq->private;
>> +       struct virtio_net_config *vc = &pdsv->vn_config;
>> +
>> +       seq_printf(seq, "mac:                  %pM\n", vc->mac);
>> +       seq_printf(seq, "max_virtqueue_pairs:  %d\n",
>> +                  __virtio16_to_cpu(true, vc->max_virtqueue_pairs));
>> +       seq_printf(seq, "mtu:                  %d\n", __virtio16_to_cpu(true, vc->mtu));
>> +       seq_printf(seq, "speed:                %d\n", le32_to_cpu(vc->speed));
>> +       seq_printf(seq, "duplex:               %d\n", vc->duplex);
>> +       seq_printf(seq, "rss_max_key_size:     %d\n", vc->rss_max_key_size);
>> +       seq_printf(seq, "rss_max_indirection_table_length: %d\n",
>> +                  le16_to_cpu(vc->rss_max_indirection_table_length));
>> +       seq_printf(seq, "supported_hash_types: %#x\n",
>> +                  le32_to_cpu(vc->supported_hash_types));
>> +       seq_printf(seq, "vn_status:            %#x\n",
>> +                  __virtio16_to_cpu(true, vc->status));
>> +       print_status_bits(seq, __virtio16_to_cpu(true, vc->status));
>> +
>> +       seq_printf(seq, "hw_status:            %#x\n", pdsv->hw.status);
>> +       print_status_bits(seq, pdsv->hw.status);
>> +       seq_printf(seq, "req_features:         %#llx\n", pdsv->hw.req_features);
>> +       print_feature_bits(seq, pdsv->hw.req_features);
>> +       seq_printf(seq, "actual_features:      %#llx\n", pdsv->hw.actual_features);
>> +       print_feature_bits(seq, pdsv->hw.actual_features);
>> +       seq_printf(seq, "vdpa_index:           %d\n", pdsv->hw.vdpa_index);
>> +       seq_printf(seq, "num_vqs:              %d\n", pdsv->hw.num_vqs);
>> +
>> +       return 0;
>> +}
>> +DEFINE_SHOW_ATTRIBUTE(config);
>> +
>> +static int
>> +vq_show(struct seq_file *seq, void *v)
>> +{
>> +       struct pds_vdpa_vq_info *vq = seq->private;
>> +       struct pds_vdpa_intr_info *intrs;
>> +
>> +       seq_printf(seq, "ready:      %d\n", vq->ready);
>> +       seq_printf(seq, "desc_addr:  %#llx\n", vq->desc_addr);
>> +       seq_printf(seq, "avail_addr: %#llx\n", vq->avail_addr);
>> +       seq_printf(seq, "used_addr:  %#llx\n", vq->used_addr);
>> +       seq_printf(seq, "q_len:      %d\n", vq->q_len);
>> +       seq_printf(seq, "qid:        %d\n", vq->qid);
>> +
>> +       seq_printf(seq, "doorbell:   %#llx\n", vq->doorbell);
>> +       seq_printf(seq, "avail_idx:  %d\n", vq->avail_idx);
>> +       seq_printf(seq, "used_idx:   %d\n", vq->used_idx);
>> +       seq_printf(seq, "intr_index: %d\n", vq->intr_index);
>> +
>> +       intrs = vq->pdsv->vdpa_aux->vdpa_vf->intrs;
>> +       seq_printf(seq, "irq:        %d\n", intrs[vq->intr_index].irq);
>> +       seq_printf(seq, "irq-name:   %s\n", intrs[vq->intr_index].name);
>> +
>> +       seq_printf(seq, "hw_qtype:   %d\n", vq->hw_qtype);
>> +       seq_printf(seq, "hw_qindex:  %d\n", vq->hw_qindex);
>> +
>> +       return 0;
>> +}
>> +DEFINE_SHOW_ATTRIBUTE(vq);
>> +
>> +void
>> +pds_vdpa_debugfs_add_vdpadev(struct pds_vdpa_device *pdsv)
>> +{
>> +       struct dentry *dentry;
>> +       const char *name;
>> +       int i;
>> +
>> +       dentry = pdsv->vdpa_aux->vdpa_vf->dentry;
>> +       name = dev_name(&pdsv->vdpa_dev.dev);
>> +
>> +       pdsv->dentry = debugfs_create_dir(name, dentry);
>> +
>> +       debugfs_create_file("config", 0400, pdsv->dentry, pdsv, &config_fops);
>> +
>> +       for (i = 0; i < pdsv->hw.num_vqs; i++) {
>> +               char name[8];
>> +
>> +               snprintf(name, sizeof(name), "vq%02d", i);
>> +               debugfs_create_file(name, 0400, pdsv->dentry, &pdsv->hw.vqs[i], &vq_fops);
>> +       }
>> +}
>> +
>> +void
>> +pds_vdpa_debugfs_del_vdpadev(struct pds_vdpa_device *pdsv)
>> +{
>> +       debugfs_remove_recursive(pdsv->dentry);
>> +       pdsv->dentry = NULL;
>> +}
>> +
>>   #endif /* CONFIG_DEBUG_FS */
>> diff --git a/drivers/vdpa/pds/debugfs.h b/drivers/vdpa/pds/debugfs.h
>> index 939a4c248aac..f0567e4ee4e4 100644
>> --- a/drivers/vdpa/pds/debugfs.h
>> +++ b/drivers/vdpa/pds/debugfs.h
>> @@ -13,12 +13,16 @@ void pds_vdpa_debugfs_destroy(void);
>>   void pds_vdpa_debugfs_add_pcidev(struct pds_vdpa_pci_device *vdpa_pdev);
>>   void pds_vdpa_debugfs_del_pcidev(struct pds_vdpa_pci_device *vdpa_pdev);
>>   void pds_vdpa_debugfs_add_ident(struct pds_vdpa_aux *vdpa_aux);
>> +void pds_vdpa_debugfs_add_vdpadev(struct pds_vdpa_device *pdsv);
>> +void pds_vdpa_debugfs_del_vdpadev(struct pds_vdpa_device *pdsv);
>>   #else
>>   static inline void pds_vdpa_debugfs_create(void) { }
>>   static inline void pds_vdpa_debugfs_destroy(void) { }
>>   static inline void pds_vdpa_debugfs_add_pcidev(struct pds_vdpa_pci_device *vdpa_pdev) { }
>>   static inline void pds_vdpa_debugfs_del_pcidev(struct pds_vdpa_pci_device *vdpa_pdev) { }
>>   static inline void pds_vdpa_debugfs_add_ident(struct pds_vdpa_aux *vdpa_aux) { }
>> +static inline void pds_vdpa_debugfs_add_vdpadev(struct pds_vdpa_device *pdsv) { }
>> +static inline void pds_vdpa_debugfs_del_vdpadev(struct pds_vdpa_device *pdsv) { }
>>   #endif
>>
>>   #endif /* _PDS_VDPA_DEBUGFS_H_ */
>> diff --git a/drivers/vdpa/pds/vdpa_dev.c b/drivers/vdpa/pds/vdpa_dev.c
>> new file mode 100644
>> index 000000000000..824be42aff0d
>> --- /dev/null
>> +++ b/drivers/vdpa/pds/vdpa_dev.c
>> @@ -0,0 +1,796 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/* Copyright(c) 2022 Pensando Systems, Inc */
>> +
>> +#include <linux/interrupt.h>
>> +#include <linux/module.h>
>> +#include <linux/pci.h>
>> +#include <linux/sysfs.h>
>> +#include <linux/types.h>
>> +#include <linux/vdpa.h>
>> +#include <uapi/linux/virtio_pci.h>
>> +#include <uapi/linux/vdpa.h>
>> +
>> +#include <linux/pds/pds_intr.h>
>> +#include <linux/pds/pds_core_if.h>
>> +#include <linux/pds/pds_adminq.h>
>> +#include <linux/pds/pds_auxbus.h>
>> +#include <linux/pds/pds_vdpa.h>
>> +
>> +#include "vdpa_dev.h"
>> +#include "pci_drv.h"
>> +#include "aux_drv.h"
>> +#include "pci_drv.h"
>> +#include "cmds.h"
>> +#include "debugfs.h"
>> +
>> +static int
>> +pds_vdpa_setup_driver(struct pds_vdpa_device *pdsv)
>> +{
>> +       struct device *dev = &pdsv->vdpa_dev.dev;
>> +       int err = 0;
>> +       int i;
>> +
>> +       /* Verify all vqs[] are in ready state */
>> +       for (i = 0; i < pdsv->hw.num_vqs; i++) {
>> +               if (!pdsv->hw.vqs[i].ready) {
>> +                       dev_warn(dev, "%s: qid %d not ready\n", __func__, i);
>> +                       err = -ENOENT;
>> +               }
>> +       }
>> +
>> +       return err;
>> +}
>> +
>> +static struct pds_vdpa_device *
>> +vdpa_to_pdsv(struct vdpa_device *vdpa_dev)
>> +{
>> +       return container_of(vdpa_dev, struct pds_vdpa_device, vdpa_dev);
>> +}
>> +
>> +static struct pds_vdpa_hw *
>> +vdpa_to_hw(struct vdpa_device *vdpa_dev)
>> +{
>> +       struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
>> +
>> +       return &pdsv->hw;
>> +}
>> +
>> +static int
>> +pds_vdpa_set_vq_address(struct vdpa_device *vdpa_dev, u16 qid,
>> +                       u64 desc_addr, u64 driver_addr, u64 device_addr)
>> +{
>> +       struct pds_vdpa_hw *hw = vdpa_to_hw(vdpa_dev);
>> +
>> +       hw->vqs[qid].desc_addr = desc_addr;
>> +       hw->vqs[qid].avail_addr = driver_addr;
>> +       hw->vqs[qid].used_addr = device_addr;
>> +
>> +       return 0;
>> +}
>> +
>> +static void
>> +pds_vdpa_set_vq_num(struct vdpa_device *vdpa_dev, u16 qid, u32 num)
>> +{
>> +       struct pds_vdpa_hw *hw = vdpa_to_hw(vdpa_dev);
>> +
>> +       hw->vqs[qid].q_len = num;
>> +}
>> +
>> +static void
>> +pds_vdpa_kick_vq(struct vdpa_device *vdpa_dev, u16 qid)
>> +{
>> +       struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
>> +
>> +       iowrite16(qid, pdsv->hw.vqs[qid].notify);
>> +}
>> +
>> +static void
>> +pds_vdpa_set_vq_cb(struct vdpa_device *vdpa_dev, u16 qid,
>> +                  struct vdpa_callback *cb)
>> +{
>> +       struct pds_vdpa_hw *hw = vdpa_to_hw(vdpa_dev);
>> +
>> +       hw->vqs[qid].event_cb = *cb;
>> +}
>> +
>> +static irqreturn_t
>> +pds_vdpa_isr(int irq, void *data)
>> +{
>> +       struct pds_core_intr __iomem *intr_ctrl;
>> +       struct pds_vdpa_device *pdsv;
>> +       struct pds_vdpa_vq_info *vq;
>> +
>> +       vq = data;
>> +       pdsv = vq->pdsv;
>> +
>> +       if (vq->event_cb.callback)
>> +               vq->event_cb.callback(vq->event_cb.private);
>> +
>> +       /* Since we don't actually know how many vq descriptors are
>> +        * covered in this interrupt cycle, we simply clean all the
>> +        * credits and re-enable the interrupt.
>> +        */
>> +       intr_ctrl = (struct pds_core_intr __iomem *)pdsv->vdpa_aux->vdpa_vf->vd_mdev.isr;
>> +       pds_core_intr_clean_flags(&intr_ctrl[vq->intr_index],
>> +                                 PDS_CORE_INTR_CRED_REARM);
>> +
>> +       return IRQ_HANDLED;
>> +}
>> +
>> +static void
>> +pds_vdpa_release_irq(struct pds_vdpa_device *pdsv, int qid)
>> +{
>> +       struct pds_vdpa_intr_info *intrs = pdsv->vdpa_aux->vdpa_vf->intrs;
>> +       struct pci_dev *pdev = pdsv->vdpa_aux->vdpa_vf->pdev;
>> +       struct pds_core_intr __iomem *intr_ctrl;
>> +       int index;
>> +
>> +       intr_ctrl = (struct pds_core_intr __iomem *)pdsv->vdpa_aux->vdpa_vf->vd_mdev.isr;
>> +       index = pdsv->hw.vqs[qid].intr_index;
>> +       if (index == VIRTIO_MSI_NO_VECTOR)
>> +               return;
>> +
>> +       if (intrs[index].irq == VIRTIO_MSI_NO_VECTOR)
>> +               return;
>> +
>> +       if (qid & 0x1) {
>> +               pdsv->hw.vqs[qid].intr_index = VIRTIO_MSI_NO_VECTOR;
>> +       } else {
>> +               pds_core_intr_mask(&intr_ctrl[index], PDS_CORE_INTR_MASK_SET);
>> +               devm_free_irq(&pdev->dev, intrs[index].irq, &pdsv->hw.vqs[qid]);
>> +               pdsv->hw.vqs[qid].intr_index = VIRTIO_MSI_NO_VECTOR;
>> +               intrs[index].irq = VIRTIO_MSI_NO_VECTOR;
>> +       }
>> +}
>> +
>> +static void
>> +pds_vdpa_set_vq_ready(struct vdpa_device *vdpa_dev, u16 qid, bool ready)
>> +{
>> +       struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
>> +       struct pci_dev *pdev = pdsv->vdpa_aux->vdpa_vf->pdev;
>> +       struct pds_vdpa_hw *hw = vdpa_to_hw(vdpa_dev);
>> +       struct device *dev = &pdsv->vdpa_dev.dev;
>> +       struct pds_core_intr __iomem *intr_ctrl;
>> +       int err;
>> +
>> +       dev_dbg(dev, "%s: qid %d ready %d => %d\n",
>> +                __func__, qid, hw->vqs[qid].ready, ready);
>> +       if (ready == hw->vqs[qid].ready)
>> +               return;
>> +
>> +       intr_ctrl = (struct pds_core_intr __iomem *)pdsv->vdpa_aux->vdpa_vf->vd_mdev.isr;
> 
> It looks to me pds has a different layout/semantic for isr than virtio
> spec. I'd suggest to not reuse spec isr here to avoid confusion.

Hmm, yes, that needs some straightening out.

> 
>> +       if (ready) {
> 
> Spec said no interrupt before DRIVER_OK, it looks more simple if we
> move the interrupt setup to set_status():
> 
> E.g we can know if we have sufficient vectors and use different
> mapping policies in advance.

I'll look at that.

> 
>> +               struct pds_vdpa_intr_info *intrs = pdsv->vdpa_aux->vdpa_vf->intrs;
>> +               int index = VIRTIO_MSI_NO_VECTOR;
>> +               int i;
>> +
>> +               /*  Tx and Rx queues share interrupts, and they start with
>> +                *  even numbers, so only find an interrupt for the even numbered
>> +                *  qid, and let the odd number use what the previous queue got.
>> +                */
>> +               if (qid & 0x1) {
>> +                       int even = qid & ~0x1;
>> +
>> +                       index = hw->vqs[even].intr_index;
>> +               } else {
>> +                       for (i = 0; i < pdsv->vdpa_aux->vdpa_vf->nintrs; i++) {
>> +                               if (intrs[i].irq == VIRTIO_MSI_NO_VECTOR) {
>> +                                       index = i;
>> +                                       break;
>> +                               }
>> +                       }
>> +               }
>> +
>> +               if (qid & 0x1) {
>> +                       hw->vqs[qid].intr_index = index;
>> +               } else if (index != VIRTIO_MSI_NO_VECTOR) {
>> +                       int irq;
>> +
>> +                       irq = pci_irq_vector(pdev, index);
>> +                       snprintf(intrs[index].name, sizeof(intrs[index].name),
>> +                                "vdpa-%s-%d", dev_name(dev), index);
>> +
>> +                       err = devm_request_irq(&pdev->dev, irq, pds_vdpa_isr, 0,
>> +                                              intrs[index].name, &hw->vqs[qid]);
>> +                       if (err) {
>> +                               dev_info(dev, "%s: no irq for qid %d: %pe\n",
>> +                                        __func__, qid, ERR_PTR(err));
> 
> Should we fail?
> 
>> +                       } else {
>> +                               intrs[index].irq = irq;
>> +                               hw->vqs[qid].intr_index = index;
>> +                               pds_core_intr_mask(&intr_ctrl[index],
>> +                                                  PDS_CORE_INTR_MASK_CLEAR);
> 
> I guess the reason that you don't simply use VF MSI-X is the DPU can
> support vDPA subdevice in the future?
> 
>> +                       }
>> +               } else {
>> +                       dev_info(dev, "%s: no intr slot for qid %d\n",
>> +                                __func__, qid);
> 
> Do we need to fail here?
> 
>> +               }
>> +
>> +               /* Pass vq setup info to DSC */
>> +               err = pds_vdpa_cmd_init_vq(pdsv, qid, &hw->vqs[qid]);
>> +               if (err) {
>> +                       pds_vdpa_release_irq(pdsv, qid);
>> +                       ready = false;
>> +               }
>> +       } else {
>> +               pds_vdpa_release_irq(pdsv, qid);
>> +               (void) pds_vdpa_cmd_reset_vq(pdsv, qid);
>> +       }
>> +
>> +       hw->vqs[qid].ready = ready;
>> +}
>> +
>> +static bool
>> +pds_vdpa_get_vq_ready(struct vdpa_device *vdpa_dev, u16 qid)
>> +{
>> +       struct pds_vdpa_hw *hw = vdpa_to_hw(vdpa_dev);
>> +
>> +       return hw->vqs[qid].ready;
>> +}
>> +
>> +static int
>> +pds_vdpa_set_vq_state(struct vdpa_device *vdpa_dev, u16 qid,
>> +                     const struct vdpa_vq_state *state)
>> +{
>> +       struct pds_vdpa_hw *hw = vdpa_to_hw(vdpa_dev);
>> +
>> +       hw->vqs[qid].used_idx = state->split.avail_index;
>> +       hw->vqs[qid].avail_idx = state->split.avail_index;
>> +
>> +       return 0;
>> +}
>> +
>> +static int
>> +pds_vdpa_get_vq_state(struct vdpa_device *vdpa_dev, u16 qid,
>> +                     struct vdpa_vq_state *state)
>> +{
>> +       struct pds_vdpa_hw *hw = vdpa_to_hw(vdpa_dev);
>> +
>> +       state->split.avail_index = hw->vqs[qid].avail_idx;
> 
> Who is in charge of reading avail_idx from the hardware?

We didn't have that available in the early FW, so it isn't here yet. 
Work in progerss.

> 
>> +
>> +       return 0;
>> +}
>> +
>> +static struct vdpa_notification_area
>> +pds_vdpa_get_vq_notification(struct vdpa_device *vdpa_dev, u16 qid)
>> +{
>> +       struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
>> +       struct pds_vdpa_hw *hw = vdpa_to_hw(vdpa_dev);
>> +       struct virtio_pci_modern_device *vd_mdev;
>> +       struct vdpa_notification_area area;
>> +
>> +       area.addr = hw->vqs[qid].notify_pa;
>> +
>> +       vd_mdev = &pdsv->vdpa_aux->vdpa_vf->vd_mdev;
>> +       if (!vd_mdev->notify_offset_multiplier)
>> +               area.size = PAGE_SIZE;
>> +       else
>> +               area.size = vd_mdev->notify_offset_multiplier;
>> +
>> +       return area;
>> +}
>> +
>> +static int
>> +pds_vdpa_get_vq_irq(struct vdpa_device *vdpa_dev, u16 qid)
>> +{
>> +       struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
>> +       struct pds_vdpa_hw *hw = vdpa_to_hw(vdpa_dev);
>> +       int irq = VIRTIO_MSI_NO_VECTOR;
>> +       int index;
>> +
>> +       if (pdsv->vdpa_aux->vdpa_vf->intrs) {
>> +               index = hw->vqs[qid].intr_index;
>> +               irq = pdsv->vdpa_aux->vdpa_vf->intrs[index].irq;
> 
> The notification area mapping might only work well when each vq has
> it's own irq. Otherwise guest may see spurious interrupt which may
> degrade the performance.

We haven't been expecting to use shared interrupts - are we being overly 
optimistic?


> 
>> +       }
>> +
>> +       return irq;
>> +}
>> +
>> +static u32
>> +pds_vdpa_get_vq_align(struct vdpa_device *vdpa_dev)
>> +{
>> +
>> +       return PAGE_SIZE;
>> +}
>> +
>> +static u32
>> +pds_vdpa_get_vq_group(struct vdpa_device *vdpa_dev, u16 idx)
>> +{
>> +       return 0;
>> +}
>> +
>> +static u64
>> +pds_vdpa_get_device_features(struct vdpa_device *vdpa_dev)
>> +{
>> +       struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
>> +
>> +       return le64_to_cpu(pdsv->vdpa_aux->ident.hw_features);
>> +}
>> +
>> +static int
>> +pds_vdpa_set_driver_features(struct vdpa_device *vdpa_dev, u64 features)
>> +{
>> +       struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
>> +       struct pds_vdpa_hw *hw = vdpa_to_hw(vdpa_dev);
>> +       struct device *dev = &pdsv->vdpa_dev.dev;
>> +       u64 nego_features;
>> +       u64 set_features;
>> +       u64 missing;
>> +       int err;
>> +
>> +       if (!(features & BIT_ULL(VIRTIO_F_ACCESS_PLATFORM)) && features) {
>> +               dev_err(dev, "VIRTIO_F_ACCESS_PLATFORM is not negotiated\n");
>> +               return -EOPNOTSUPP;
> 
> Should we fail the FEATURE_OK in this case and all the other below
> error conditions?

Perhaps I'm missing a nuance in the inteface... isn't that what we're 
doing by returning a non-zero status?

> 
>> +       }
>> +
>> +       hw->req_features = features;
>> +
>> +       /* Check for valid feature bits */
>> +       nego_features = features & le64_to_cpu(pdsv->vdpa_aux->ident.hw_features);
>> +       missing = hw->req_features & ~nego_features;
>> +       if (missing) {
>> +               dev_err(dev, "Can't support all requested features in %#llx, missing %#llx features\n",
>> +                       hw->req_features, missing);
>> +               return -EOPNOTSUPP;
>> +       }
>> +
>> +       dev_dbg(dev, "%s: %#llx => %#llx\n",
>> +                __func__, hw->actual_features, nego_features);
>> +
>> +       if (hw->actual_features == nego_features)
>> +               return 0;
>> +
>> +       /* Update hw feature configuration, strip MAC bit if locally set */
>> +       if (pdsv->vdpa_aux->local_mac_bit)
>> +               set_features = nego_features & ~BIT_ULL(VIRTIO_NET_F_MAC);
> 
> Need some document to explain how local_mac_bit work.

I'll look at expanding the comment in pds_vdpa_get_mgmt_info() where 
this would get set to true.  Basically, it is tracking whether or not 
the driver is faking the VIRTIO_NET_F_MAC capability for the device.

> 
>> +       else
>> +               set_features = nego_features;
>> +       err = pds_vdpa_cmd_set_features(pdsv, set_features);
>> +       if (!err)
>> +               hw->actual_features = nego_features;
>> +
>> +       return err;
>> +}
>> +
>> +static u64
>> +pds_vdpa_get_driver_features(struct vdpa_device *vdpa_dev)
>> +{
>> +       struct pds_vdpa_hw *hw = vdpa_to_hw(vdpa_dev);
>> +
>> +       return hw->actual_features;
>> +}
>> +
>> +static void
>> +pds_vdpa_set_config_cb(struct vdpa_device *vdpa_dev, struct vdpa_callback *cb)
>> +{
>> +       struct pds_vdpa_hw *hw = vdpa_to_hw(vdpa_dev);
>> +
>> +       hw->config_cb.callback = cb->callback;
>> +       hw->config_cb.private = cb->private;
>> +}
>> +
>> +static u16
>> +pds_vdpa_get_vq_num_max(struct vdpa_device *vdpa_dev)
>> +{
>> +       struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
>> +       u32 max_qlen;
>> +
>> +       max_qlen = min_t(u32, PDS_VDPA_MAX_QLEN,
>> +                             1 << le16_to_cpu(pdsv->vdpa_aux->ident.max_qlen));
> 
> Assuming we can fetch the max_qlen from the device, any reason have
> another layer like PDS_VDPA_MAX_QLEN?

Yes, I think this can be simplified to just the read.

> 
>> +
>> +       return (u16)max_qlen;
>> +}
>> +
>> +static u32
>> +pds_vdpa_get_device_id(struct vdpa_device *vdpa_dev)
>> +{
>> +       return VIRTIO_ID_NET;
>> +}
>> +
>> +static u32
>> +pds_vdpa_get_vendor_id(struct vdpa_device *vdpa_dev)
>> +{
>> +       return PCI_VENDOR_ID_PENSANDO;
>> +}
>> +
>> +static u8
>> +pds_vdpa_get_status(struct vdpa_device *vdpa_dev)
>> +{
>> +       struct pds_vdpa_hw *hw = vdpa_to_hw(vdpa_dev);
>> +
>> +       return hw->status;
> 
> How is this synchronized with the device or it is fully emulated by this driver?

For now has been fronted by the driver, but probably should be coming 
out of the virtio_net_config block.

> 
>> +}
>> +
>> +static void
>> +pds_vdpa_set_status(struct vdpa_device *vdpa_dev, u8 status)
>> +{
>> +       struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
>> +       struct pds_vdpa_hw *hw = vdpa_to_hw(vdpa_dev);
>> +       struct device *dev = &pdsv->vdpa_dev.dev;
>> +       int err;
>> +
>> +       if (hw->status == status)
>> +               return;
>> +
>> +       /* If the DRIVER_OK bit turns on, time to start the queues */
>> +       if ((status ^ hw->status) & VIRTIO_CONFIG_S_DRIVER_OK) {
>> +               if (status & VIRTIO_CONFIG_S_DRIVER_OK) {
>> +                       err = pds_vdpa_setup_driver(pdsv);
>> +                       if (err) {
>> +                               dev_err(dev, "failed to setup driver: %pe\n", ERR_PTR(err));
>> +                               status = hw->status | VIRTIO_CONFIG_S_FAILED;
>> +                       }
>> +               } else {
>> +                       dev_warn(dev, "did not expect DRIVER_OK to be cleared\n");
>> +               }
>> +       }
>> +
>> +       err = pds_vdpa_cmd_set_status(pdsv, status);
>> +       if (!err)
>> +               hw->status = status;
>> +}
>> +
>> +static int
>> +pds_vdpa_reset(struct vdpa_device *vdpa_dev)
>> +{
>> +       struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
>> +       struct pds_vdpa_hw *hw = vdpa_to_hw(vdpa_dev);
>> +       int i;
>> +
>> +       if (hw->status == 0)
>> +               return 0;
>> +
>> +       if (hw->status & VIRTIO_CONFIG_S_DRIVER_OK) {
>> +
>> +               /* Reset the vqs */
>> +               for (i = 0; i < hw->num_vqs; i++) {
>> +                       pds_vdpa_release_irq(pdsv, i);
>> +                       (void) pds_vdpa_cmd_reset_vq(pdsv, i);
> 
> (void) is unnecessary.

yep

> 
>> +
>> +                       memset(&pdsv->hw.vqs[i], 0, sizeof(pdsv->hw.vqs[0]));
>> +                       pdsv->hw.vqs[i].ready = false;
>> +               }
>> +       }
>> +
>> +       hw->status = 0;
>> +       (void) pds_vdpa_cmd_set_status(pdsv, 0);
>> +
>> +       return 0;
>> +}
>> +
>> +static size_t
>> +pds_vdpa_get_config_size(struct vdpa_device *vdpa_dev)
>> +{
>> +       return sizeof(struct virtio_net_config);
>> +}
>> +
>> +static void
>> +pds_vdpa_get_config(struct vdpa_device *vdpa_dev,
>> +                   unsigned int offset,
>> +                   void *buf, unsigned int len)
>> +{
>> +       struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
>> +
>> +       if (offset + len <= sizeof(struct virtio_net_config))
>> +               memcpy(buf, (u8 *)&pdsv->vn_config + offset, len);
>> +}
>> +
>> +static void
>> +pds_vdpa_set_config(struct vdpa_device *vdpa_dev,
>> +                   unsigned int offset, const void *buf,
>> +                   unsigned int len)
>> +{
>> +       /* In the virtio_net context, this callback seems to only be
>> +        * called in drivers supporting the older non-VERSION_1 API,
>> +        * so we can leave this an empty function, but we need  to
>> +        * define the function in case it does get called, as there
>> +        * are currently no checks for existence before calling in
>> +        * that path.
>> +        *
>> +        * The implementation would be something like:
>> +        * if (offset + len <= sizeof(struct virtio_net_config))
>> +        *      memcpy((u8 *)&pdsv->vn_config + offset, buf, len);
>> +        */
> 
> And we need to notify the hardware that config has been changed.

Sure

> 
>> +}
>> +
>> +static const struct vdpa_config_ops pds_vdpa_ops = {
>> +       .set_vq_address         = pds_vdpa_set_vq_address,
>> +       .set_vq_num             = pds_vdpa_set_vq_num,
>> +       .kick_vq                = pds_vdpa_kick_vq,
>> +       .set_vq_cb              = pds_vdpa_set_vq_cb,
>> +       .set_vq_ready           = pds_vdpa_set_vq_ready,
>> +       .get_vq_ready           = pds_vdpa_get_vq_ready,
>> +       .set_vq_state           = pds_vdpa_set_vq_state,
>> +       .get_vq_state           = pds_vdpa_get_vq_state,
>> +       .get_vq_notification    = pds_vdpa_get_vq_notification,
>> +       .get_vq_irq             = pds_vdpa_get_vq_irq,
>> +       .get_vq_align           = pds_vdpa_get_vq_align,
>> +       .get_vq_group           = pds_vdpa_get_vq_group,
>> +
>> +       .get_device_features    = pds_vdpa_get_device_features,
>> +       .set_driver_features    = pds_vdpa_set_driver_features,
>> +       .get_driver_features    = pds_vdpa_get_driver_features,
>> +       .set_config_cb          = pds_vdpa_set_config_cb,
>> +       .get_vq_num_max         = pds_vdpa_get_vq_num_max,
>> +/*     .get_vq_num_min (optional) */
>> +       .get_device_id          = pds_vdpa_get_device_id,
>> +       .get_vendor_id          = pds_vdpa_get_vendor_id,
>> +       .get_status             = pds_vdpa_get_status,
>> +       .set_status             = pds_vdpa_set_status,
>> +       .reset                  = pds_vdpa_reset,
>> +       .get_config_size        = pds_vdpa_get_config_size,
>> +       .get_config             = pds_vdpa_get_config,
>> +       .set_config             = pds_vdpa_set_config,
>> +
>> +/*     .get_generation (optional) */
>> +/*     .get_iova_range (optional) */
>> +/*     .set_group_asid */
>> +/*     .set_map (optional) */
>> +/*     .dma_map (optional) */
>> +/*     .dma_unmap (optional) */
>> +/*     .free (optional) */
>> +};
>> +static struct virtio_device_id pds_vdpa_id_table[] = {
>> +       {VIRTIO_ID_NET, VIRTIO_DEV_ANY_ID},
>> +       {0},
>> +};
>> +
>> +static int
>> +pds_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
>> +                const struct vdpa_dev_set_config *add_config)
>> +{
>> +       struct pds_vdpa_aux *vdpa_aux;
>> +       struct pds_vdpa_device *pdsv;
>> +       struct vdpa_mgmt_dev *mgmt;
>> +       u16 fw_max_vqs, vq_pairs;
>> +       struct device *dma_dev;
>> +       struct pds_vdpa_hw *hw;
>> +       struct pci_dev *pdev;
>> +       struct device *dev;
>> +       u8 mac[ETH_ALEN];
>> +       int err;
>> +       int i;
>> +
>> +       vdpa_aux = container_of(mdev, struct pds_vdpa_aux, vdpa_mdev);
>> +       dev = &vdpa_aux->padev->aux_dev.dev;
>> +       mgmt = &vdpa_aux->vdpa_mdev;
>> +
>> +       if (vdpa_aux->pdsv) {
>> +               dev_warn(dev, "Multiple vDPA devices on a VF is not supported.\n");
>> +               return -EOPNOTSUPP;
>> +       }
>> +
>> +       pdsv = vdpa_alloc_device(struct pds_vdpa_device, vdpa_dev,
>> +                                dev, &pds_vdpa_ops, 1, 1, name, false);
>> +       if (IS_ERR(pdsv)) {
>> +               dev_err(dev, "Failed to allocate vDPA structure: %pe\n", pdsv);
>> +               return PTR_ERR(pdsv);
>> +       }
>> +
>> +       vdpa_aux->pdsv = pdsv;
>> +       pdsv->vdpa_aux = vdpa_aux;
>> +       pdsv->vdpa_aux->padev->priv = pdsv;
>> +
>> +       pdev = vdpa_aux->vdpa_vf->pdev;
>> +       pdsv->vdpa_dev.dma_dev = &pdev->dev;
>> +       dma_dev = pdsv->vdpa_dev.dma_dev;
>> +       hw = &pdsv->hw;
>> +
>> +       pdsv->vn_config_pa = dma_map_single(dma_dev, &pdsv->vn_config,
>> +                                           sizeof(pdsv->vn_config), DMA_FROM_DEVICE);
> 
> I think we should use coherent mapping instead of streaming mapping
> otherwise we may end up with coherency issues when accessing the
> device configuration space.

Makes sense

> 
>> +       if (dma_mapping_error(dma_dev, pdsv->vn_config_pa)) {
>> +               dev_err(dma_dev, "Failed to map vn_config space\n");
>> +               pdsv->vn_config_pa = 0;
>> +               err = -ENOMEM;
>> +               goto err_out;
>> +       }
>> +
>> +       err = pds_vdpa_init_hw(pdsv);
>> +       if (err) {
>> +               dev_err(dev, "Failed to init hw: %pe\n", ERR_PTR(err));
>> +               goto err_unmap;
>> +       }
>> +
>> +       fw_max_vqs = le16_to_cpu(pdsv->vdpa_aux->ident.max_vqs);
>> +       vq_pairs = fw_max_vqs / 2;
>> +
>> +       /* Make sure we have the queues being requested */
>> +       if (add_config->mask & (1 << VDPA_ATTR_DEV_NET_CFG_MAX_VQP))
>> +               vq_pairs = add_config->net.max_vq_pairs;
>> +
>> +       hw->num_vqs = 2 * vq_pairs;
>> +       if (mgmt->supported_features & BIT_ULL(VIRTIO_NET_F_CTRL_VQ))
>> +               hw->num_vqs++;
>> +
>> +       if (hw->num_vqs > fw_max_vqs) {
>> +               dev_err(dev, "%s: queue count requested %u greater than max %u\n",
>> +                        __func__, hw->num_vqs, fw_max_vqs);
>> +               err = -ENOSPC;
>> +               goto err_unmap;
>> +       }
>> +
>> +       if (hw->num_vqs != fw_max_vqs) {
>> +               err = pds_vdpa_cmd_set_max_vq_pairs(pdsv, vq_pairs);
>> +               if (err == -ERANGE) {
>> +                       hw->num_vqs = fw_max_vqs;
>> +                       dev_warn(dev, "Known FW issue - overriding to use max_vq_pairs %d\n",
>> +                                hw->num_vqs / 2);
> 
> Should we fail here? Since the device has a different max_vqp that expected.

Wasn't sure if we should annoy users with a fail here, or try to adjust 
and continue on with something that should work.

> 
>> +               } else if (err) {
>> +                       dev_err(dev, "Failed to update max_vq_pairs: %pe\n",
>> +                               ERR_PTR(err));
>> +                       goto err_unmap;
>> +               }
>> +       }
>> +
>> +       /* Set a mac, either from the user config if provided
>> +        * or set a random mac if default is 00:..:00
>> +        */
>> +       if (add_config->mask & (1 << VDPA_ATTR_DEV_NET_CFG_MACADDR)) {
>> +               ether_addr_copy(mac, add_config->net.mac);
>> +               pds_vdpa_cmd_set_mac(pdsv, mac);
>> +       } else if (is_zero_ether_addr(pdsv->vn_config.mac)) {
>> +               eth_random_addr(mac);
>> +               pds_vdpa_cmd_set_mac(pdsv, mac);
>> +       }
>> +
>> +       for (i = 0; i < hw->num_vqs; i++) {
>> +               hw->vqs[i].qid = i;
>> +               hw->vqs[i].pdsv = pdsv;
>> +               hw->vqs[i].intr_index = VIRTIO_MSI_NO_VECTOR;
> 
> Let's rename this as msix_vector to be aligned with the virtio spec.

Sure.

> 
>> +               hw->vqs[i].notify = vp_modern_map_vq_notify(&pdsv->vdpa_aux->vdpa_vf->vd_mdev,
>> +                                                           i, &hw->vqs[i].notify_pa);
>> +       }
>> +
>> +       pdsv->vdpa_dev.mdev = &vdpa_aux->vdpa_mdev;
>> +
>> +       /* We use the _vdpa_register_device() call rather than the
>> +        * vdpa_register_device() to avoid a deadlock because this
>> +        * dev_add() is called with the vdpa_dev_lock already set
>> +        * by vdpa_nl_cmd_dev_add_set_doit()
>> +        */
>> +       err = _vdpa_register_device(&pdsv->vdpa_dev, hw->num_vqs);
>> +       if (err) {
>> +               dev_err(dev, "Failed to register to vDPA bus: %pe\n", ERR_PTR(err));
>> +               goto err_unmap;
>> +       }
>> +
>> +       pds_vdpa_debugfs_add_vdpadev(pdsv);
>> +       dev_info(&pdsv->vdpa_dev.dev, "Added with mac %pM\n", pdsv->vn_config.mac);
> 
> dev_dbg?

That was the eventual idea.

> 
>> +
>> +       return 0;
>> +
>> +err_unmap:
>> +       dma_unmap_single(dma_dev, pdsv->vn_config_pa,
>> +                        sizeof(pdsv->vn_config), DMA_FROM_DEVICE);
>> +err_out:
>> +       put_device(&pdsv->vdpa_dev.dev);
>> +       vdpa_aux->pdsv = NULL;
>> +       return err;
>> +}
>> +
>> +static void
>> +pds_vdpa_dev_del(struct vdpa_mgmt_dev *mdev, struct vdpa_device *vdpa_dev)
>> +{
>> +       struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
>> +       struct pds_vdpa_aux *vdpa_aux;
>> +
>> +       dev_info(&vdpa_dev->dev, "Removed\n");
>> +
>> +       vdpa_aux = container_of(mdev, struct pds_vdpa_aux, vdpa_mdev);
>> +       _vdpa_unregister_device(vdpa_dev);
>> +       pds_vdpa_debugfs_del_vdpadev(pdsv);
>> +
>> +       if (vdpa_aux->pdsv->vn_config_pa)
>> +               dma_unmap_single(vdpa_dev->dma_dev, vdpa_aux->pdsv->vn_config_pa,
>> +                                sizeof(vdpa_aux->pdsv->vn_config), DMA_FROM_DEVICE);
>> +
>> +       vdpa_aux->pdsv = NULL;
>> +}
>> +
>> +static const struct vdpa_mgmtdev_ops pds_vdpa_mgmt_dev_ops = {
>> +       .dev_add = pds_vdpa_dev_add,
>> +       .dev_del = pds_vdpa_dev_del
>> +};
>> +
>> +int
>> +pds_vdpa_get_mgmt_info(struct pds_vdpa_aux *vdpa_aux)
>> +{
>> +       struct pds_vdpa_pci_device *vdpa_pdev;
>> +       struct pds_vdpa_ident_cmd ident_cmd = {
>> +               .opcode = PDS_VDPA_CMD_IDENT,
>> +               .vf_id = cpu_to_le16(vdpa_aux->vdpa_vf->vf_id),
>> +       };
>> +       struct pds_vdpa_comp ident_comp = {0};
>> +       struct vdpa_mgmt_dev *mgmt;
>> +       struct device *dma_dev;
>> +       dma_addr_t ident_pa;
>> +       struct pci_dev *pdev;
>> +       struct device *dev;
>> +       __le64 mac_bit;
>> +       u16 max_vqs;
>> +       int err;
>> +       int i;
>> +
>> +       vdpa_pdev = vdpa_aux->vdpa_vf;
>> +       pdev = vdpa_pdev->pdev;
>> +       dev = &vdpa_aux->padev->aux_dev.dev;
>> +       mgmt = &vdpa_aux->vdpa_mdev;
>> +
>> +       /* Get resource info from the device */
>> +       dma_dev = &pdev->dev;
>> +       ident_pa = dma_map_single(dma_dev, &vdpa_aux->ident,
>> +                                 sizeof(vdpa_aux->ident), DMA_FROM_DEVICE);
> 
> I wonder how this work. The ident_pa is mapped through VF, but the
> command is sent to PF adminq if I understand correctly. If yes, this
> might work but looks tricky. We'd better explain this is safe since
> vDPA is not yet created so no userspace can use that. Or I wonder if
> we can just piggyback the ident via the adminq response so we don't
> need to worry the security implications.

I'll work with our FW folks on this.

Thanks for all the comments,
sln

> 
> Thanks
> 
>> +       if (dma_mapping_error(dma_dev, ident_pa)) {
>> +               dev_err(dma_dev, "Failed to map ident space\n");
>> +               return -ENOMEM;
>> +       }
>> +
>> +       ident_cmd.ident_pa = cpu_to_le64(ident_pa);
>> +       ident_cmd.len = cpu_to_le32(sizeof(vdpa_aux->ident));
>> +       err = vdpa_aux->padev->ops->adminq_cmd(vdpa_aux->padev,
>> +                                              (union pds_core_adminq_cmd *)&ident_cmd,
>> +                                              sizeof(ident_cmd),
>> +                                              (union pds_core_adminq_comp *)&ident_comp,
>> +                                              0);
>> +       dma_unmap_single(dma_dev, ident_pa,
>> +                        sizeof(vdpa_aux->ident), DMA_FROM_DEVICE);
>> +       if (err) {
>> +               dev_err(dev, "Failed to ident hw, status %d: %pe\n",
>> +                       ident_comp.status, ERR_PTR(err));
>> +               return err;
>> +       }
>> +
>> +       /* The driver adds a default mac address if the device doesn't,
>> +        * so we need to sure we advertise VIRTIO_NET_F_MAC
>> +        */
>> +       mac_bit = cpu_to_le64(BIT_ULL(VIRTIO_NET_F_MAC));
>> +       if (!(vdpa_aux->ident.hw_features & mac_bit)) {
>> +               vdpa_aux->ident.hw_features |= mac_bit;
>> +               vdpa_aux->local_mac_bit = true;
>> +       }
>> +
>> +       max_vqs = le16_to_cpu(vdpa_aux->ident.max_vqs);
>> +       mgmt->max_supported_vqs = min_t(u16, PDS_VDPA_MAX_QUEUES, max_vqs);
>> +       if (max_vqs > PDS_VDPA_MAX_QUEUES)
>> +               dev_info(dev, "FYI - Device supports more vqs (%d) than driver (%d)\n",
>> +                        max_vqs, PDS_VDPA_MAX_QUEUES);
>> +
>> +       mgmt->ops = &pds_vdpa_mgmt_dev_ops;
>> +       mgmt->id_table = pds_vdpa_id_table;
>> +       mgmt->device = dev;
>> +       mgmt->supported_features = le64_to_cpu(vdpa_aux->ident.hw_features);
>> +       mgmt->config_attr_mask = BIT_ULL(VDPA_ATTR_DEV_NET_CFG_MACADDR);
>> +       mgmt->config_attr_mask |= BIT_ULL(VDPA_ATTR_DEV_NET_CFG_MAX_VQP);
>> +
>> +       /* Set up interrupts now that we know how many we might want
>> +        * TX and RX pairs will share interrupts, so halve the vq count
>> +        * Add another for a control queue if supported
>> +        */
>> +       vdpa_pdev->nintrs = mgmt->max_supported_vqs / 2;
>> +       if (mgmt->supported_features & BIT_ULL(VIRTIO_NET_F_CTRL_VQ))
>> +               vdpa_pdev->nintrs++;
>> +
>> +       err = pci_alloc_irq_vectors(pdev, vdpa_pdev->nintrs, vdpa_pdev->nintrs,
>> +                                   PCI_IRQ_MSIX);
>> +       if (err < 0) {
>> +               dev_err(dma_dev, "Couldn't get %d msix vectors: %pe\n",
>> +                       vdpa_pdev->nintrs, ERR_PTR(err));
>> +               return err;
>> +       }
>> +       vdpa_pdev->nintrs = err;
>> +       err = 0;
>> +
>> +       vdpa_pdev->intrs = devm_kcalloc(&pdev->dev, vdpa_pdev->nintrs,
>> +                                       sizeof(*vdpa_pdev->intrs),
>> +                                       GFP_KERNEL);
>> +       if (!vdpa_pdev->intrs) {
>> +               vdpa_pdev->nintrs = 0;
>> +               pci_free_irq_vectors(pdev);
>> +               return -ENOMEM;
>> +       }
>> +
>> +       for (i = 0; i < vdpa_pdev->nintrs; i++)
>> +               vdpa_pdev->intrs[i].irq = VIRTIO_MSI_NO_VECTOR;
>> +
>> +       return 0;
>> +}
>> --
>> 2.17.1
>>
> 
