Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0132565C65F
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 19:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbjACSiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 13:38:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbjACSiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 13:38:08 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2082.outbound.protection.outlook.com [40.107.100.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF29281;
        Tue,  3 Jan 2023 10:38:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jVvPa6f9yZdnSlS+LBj7ths0p43V6dZTaukZtdN9ruWKd1RUH8kLuhurK4LnEVfTC8tLt26IT16atoETjLHq7tcxVQ+ch5N2DZjmkK8/AVBAK29csNHnozeFIL1Mh17pGHYLiJGuOtdeHy0mMYn3B15bW9omRijQfIT2wqqE6JHEU77go/AovrjulH7r3nuYZa3EbgI0XLoQKB+wPE4VQ+U4AwFRUzwVQPWlac8RxvzJoGeBCWKrCumU/hdVw7P36WZAlUL3h1PD/rIaJNKI4Fa/PqvSSCkm/cEoN+YWXgoTO7S60+phiN7pEAqWnRC+MkhRe4MNb9cowSWvOv58Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cVJDRcUEKqQ0JfZ12+qYXC8+sADyVsqN04NJ9bxKQws=;
 b=hj/0vGp/WEx4mTzguGPLnoxfd3Ft0VjCSI/UGBRgPs1HTorkkZf13PMsBnqMtg6a3KBJGS2B7krwgiVipT2GXtETnTrMW6s2hQN3XdTGkL18qf3kCxzy6hnvHmOM7FVoDjOS5IjJZYMNzGkPoXLaB4VgReh91hQrPh2e8CxCoOTIJmrAtar28VH+Yf9hEGILKP2Qxli5H9zsh6C8f64zshYGrapG1s5FZHi5miEoyVBKHb4pfex62fFgKZ/MgqsgyiE34uRoo3ZLwpKHL+dGBz7ne/xNJm4DGkNLIKPF0/Zh3CJGv+luGqv5sxYxFDA5kqYZlawFcr9ydGuOHFEt8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cVJDRcUEKqQ0JfZ12+qYXC8+sADyVsqN04NJ9bxKQws=;
 b=2z8+E4KGYqJXpzEKx22M3IX1418NBW04/8UE1cznp2DOOi9QfkdY4O8AzqKoa6ZEhCaMoxWzYc8FQfRUtyT6Xk0ZJFDqQ6uDKCuRM7HARCKYn3MPmGvS9+XakRUC6ZfuyO2LLkodEFsWwnrsINtnEMkEpAWqDZ8GwibcrEMM9Gk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 CH3PR12MB8186.namprd12.prod.outlook.com (2603:10b6:610:129::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Tue, 3 Jan
 2023 18:38:04 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::43e4:6bab:7b1e:235f]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::43e4:6bab:7b1e:235f%9]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 18:38:04 +0000
Message-ID: <04455ea2-79f0-dc78-5148-a73893d0bc53@amd.com>
Date:   Tue, 3 Jan 2023 10:38:00 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.0
Subject: Re: [RFC PATCH v2 vfio 1/7] vfio/pds: Initial support for pds_vfio
 VFIO driver
To:     liulongfang <liulongfang@huawei.com>,
        Brett Creeley <brett.creeley@amd.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com
Cc:     drivers@pensando.io
References: <20221214232136.64220-1-brett.creeley@amd.com>
 <20221214232136.64220-2-brett.creeley@amd.com>
 <a62bb7e5-e5f5-8fa5-27e2-c682725d7139@huawei.com>
Content-Language: en-US
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <a62bb7e5-e5f5-8fa5-27e2-c682725d7139@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR04CA0006.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::16) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|CH3PR12MB8186:EE_
X-MS-Office365-Filtering-Correlation-Id: 739df7d4-d11a-4b30-a462-08daedb9a618
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O+6gsUupliNxJKaTy1+qo8tgPCPhTPfeWukdDkzQQQ5v86N5NLauin6pDV8ZELgd8N1l0HoHyz+z9DCcE4hF0Sw53RkQWTpssxGVqaAoNYPQXIzUOzWQC4EAlNm5kLgcZpgM9W1xvnxXINo4Kmq8NUhmNIqjZtX3FicGj05jKH58bEO4vFJQhX4c7UtV7KUsc6vKzVxa7ru2SWvcLJfI+TdcAxylrCeUCWcBIqM8DzD8VKr8i1ipigKLztQxqN5CSSO2yUf6fXaBtbh2QP78hJSgj1dqFWBC5No1V5VdBBodNUQQL0IB9yVZB5VfArP7ZoRJjjmBiEYxR6+kTS/hrnMFLm9xbqn+6qkjRY1q3lrJ2b+xZu8G+R0+qeCpPfOxVb2ZIA8Px3ke4r8X9RD5kF7aYeKX9XcyYA93gY+IY2VDhm9JjnVBIqpK7LNu1JfuYJqlcVIKN5uZDzsJoaYzoqd0U0j6T4HL6wT+gOV6ngV/fDSjtit/od9TPmU6cmTJkkaUjlRXASghFXn3fnBfNuJseUeWHoDGL0cCkDpNvoOI4zWgLsJ+LiXb1zI2Y6k4puq5vqMGZ6SHsu+l7O2LmT13hooaq/YbC4eWplc7l11Ul8JI4jp1fnEetKuYiBnJkdaYWFuzjJrSmQ3nV22Hc+wAUEr41LPzLcFpBsx1vr1scs0YO6LPHF9mzV1j+qA4r/vXjXx57AQ9vzisWCDtMRPDOe8ZIQeiH6TlVH2v5+5rCIK+JrXcXMIUp1oZIaEp+xFGZdpEm2exJ2WtIj/kEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(376002)(366004)(346002)(451199015)(316002)(2616005)(921005)(186003)(6512007)(6486002)(478600001)(26005)(86362001)(6506007)(36756003)(53546011)(31696002)(110136005)(31686004)(6666004)(41300700001)(8936002)(2906002)(44832011)(5660300002)(7416002)(83380400001)(8676002)(66476007)(4326008)(66556008)(66946007)(38100700002)(22166006)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YXJvYysxTWhwbldFWkh6UVRacmVZTGcveDNjaHpEclA3NnpOZjZYTkd2WVZs?=
 =?utf-8?B?amVtdzdVSnpMUkxOWWVWMHRaTFZic0dwbUh4emg1M1pYdUhiUFdrbnpVVDI0?=
 =?utf-8?B?dFhQZVhrOCtySGdpSE9iZTBITVdXUzBrK1lkNG5idEE5U0gyYXpNZTVYZ2Ja?=
 =?utf-8?B?L0dQcVA5MzZzamY2WTBicVhlT1BxQ0pSR0daWHFYOUwvNkFxcjBvR0ROVks5?=
 =?utf-8?B?UHUwOUp1MnRNOFpEWEN6K3k3NURtczE2a2taTU5PZFNkMFB2TDd5Z3JIVGVL?=
 =?utf-8?B?S0psSGY5aE1YWVQzOXVvbk1BNjJyU0VrY2dVS1VYWTBYb25odGU1c3d5TjR1?=
 =?utf-8?B?UW9KUm1UandweU5EaktJcXo4Ti8xYkN1WXZXTk5yZksrT013OWk2Y3dWOVJh?=
 =?utf-8?B?eHdocXV3eGQzUTZhMFNJVVpOUHNaOGJ0NjRPeUx3L21FVE83c2NHQVk3TCtY?=
 =?utf-8?B?YkY2cTUzU1FLeTArQzNRNC90OHFEMDBUYmpHNG0yNlJxc011ckE0cXpHTlJn?=
 =?utf-8?B?d0xQeDF4YThiMmNHZkxHeXIyVFBIamYxK2Z4S3l3SlJITWpDSDJVTVpLR2Q3?=
 =?utf-8?B?THpZUzdrZXJFeDdIdkdMQnNJVFZHZHpUandXRWs1UkIrZVlVMkcySjBZQm9V?=
 =?utf-8?B?SEh6R1BIQzFSZkJRV3VzajhkT0ZQWjNEV25qbG1UclRHaDFaSnVkOFVzSHU1?=
 =?utf-8?B?UjFXOFJ5d1ZiOHVQeTRYVWY1M2F0WFNsN0FEOEhBelpITm9pam1qQ3A3RXJo?=
 =?utf-8?B?VUJpM1ZtellhZmhRcFlKSkVubHhQcTFvMmlUTFZtSTF4VExHUEhSVVVJYU1q?=
 =?utf-8?B?bUpTd0ptU0l4UVhzeG5vaUhTWmhUbUxsZHZwTktKOWthUmV0TVBQREVkYzIw?=
 =?utf-8?B?ZUhTSmdGOXlxalArZko3RmZ6eTRHMVpOS0oxT2dNOVFWd3VjNG1NRmJ5L3hV?=
 =?utf-8?B?RDd0NVl3TmtCZTY2WFBEV0xMSnVMbW5HL2FpNStpSmxCUnpxV2UybVdReThp?=
 =?utf-8?B?YURmV2NiNk1BdHlOTXpiL2hVNENTa1FPK0RvZ3pYRWRyVXJUbGhZd3BXbGkv?=
 =?utf-8?B?dEtpNFduQmVGSFoyallXTTR2WVA5ck5tL3I4bWl1SU9JY3c0V2dEdWJJcFBI?=
 =?utf-8?B?UWFWNUZpeU1mc28vVWVINWZXTFgzeG4wOHV6NFdJT1ZMMHN0Wk5ILys2cDRT?=
 =?utf-8?B?MmxhLzJNOVE3K0RqUVFtMkJCc1F1T3BzSy9hVmdhTDQxbFp4RDhZVE5UelpM?=
 =?utf-8?B?SHZ4cUZoRkFUZjNQSC9UVkJWaldaUWd6ckN4eDE4a3ExZ1NURExpMTg0T1pS?=
 =?utf-8?B?ajVidVVkdUN5cTBiZ2VpRmRlWkpvakJOTkp2Nk5MR21lTXlFb2VNUFhEVmhj?=
 =?utf-8?B?VjBMdHdKVVUyVDFZMUJwbmpzU0J5dVdsbVgwQzd0NzhkTlNpYjF0ZmlyaHND?=
 =?utf-8?B?cWNweEFXVmFoWGt1a3NPTWpPcnZsaGk3b01HbnlOYVRwRkFESzV1Wm11V25X?=
 =?utf-8?B?U3RKOXdIcWI4R291cmJsS0dGbTExckFub093S3ZHVUkvWWRWOFRWOXlUc0Zt?=
 =?utf-8?B?cFJYOWQ5QUY2OEx3RTVBZVZZd2c4MzdHeXlZdWNDcWRQcVl1eUFXYTdjUFVi?=
 =?utf-8?B?Q3J4V3JBMnU5TDhDR0RHb2d1aVNwazd6QW53a3R5OHRUbXIzbTFaTWF6NGRP?=
 =?utf-8?B?emRFMkhJR0lwOUlpWlZXeDZzVGg4MFBOaGxDOGxhTFR6NlRzcmhzQ3VvR3Iy?=
 =?utf-8?B?QndEeWtHZTMzN0dFdldRVHNoRWNQYm53VnlFRWRtWkxpazNXaytPZGhTYVBL?=
 =?utf-8?B?Y1p0ZjJVVldVWGpwbEJKK2lrbWRBVDR0U2NIcVJCODhrLzkvdXVxeXZZSXln?=
 =?utf-8?B?Y1ZHZWJ0dlIzT2JRUHYvQnFGaTdmcG9NS3ZvbGhlTGVXanpoaFdDbzZTVFlV?=
 =?utf-8?B?TEM2aFBnd1p2VnJLcko4bFVUL0ErSExJMTFiUDFUeU5uYWlkMGpwNFQ5clNF?=
 =?utf-8?B?VEhxK21YYXVxUVNOdDhVeFB3alZ5SEFmSG12YmhvVFFCbkl1QmtWbVlrNWgx?=
 =?utf-8?B?ekdJODZhVFhxZzhWeVBjWGFtaXRrTmV6dG5uNUdZQUMvM0RqNzRGU1NnUEVG?=
 =?utf-8?Q?EjpHZtgHi4DOd8K6RVYhfVsxT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 739df7d4-d11a-4b30-a462-08daedb9a618
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 18:38:03.9742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UizLO71JP7mgpV7BNaGE+th5iB5kd7jdtB/TOwfFT50jeMRRcHN/6jRObt3NhwBbpkpiDzIJfen5n6KzwmcH5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8186
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/3/23 4:12 AM, liulongfang wrote:
> On 2022/12/15 7:21, Brett Creeley wrote:
>> This is the initial framework for the new pds_vfio device driver. This
>> does the very basics of registering the PCI device 1dd8:1006 and
>> configuring as a VFIO PCI device.
>>
>> With this change, the VF device can be bound to the pds_vfio driver on
>> the host and presented to the VM as an NVMe VF.
>>
>> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> ---
>>   drivers/vfio/pci/pds/Makefile   |   6 ++
>>   drivers/vfio/pci/pds/pci_drv.c  | 102 ++++++++++++++++++++++++++++++++
>>   drivers/vfio/pci/pds/vfio_dev.c |  74 +++++++++++++++++++++++
>>   drivers/vfio/pci/pds/vfio_dev.h |  23 +++++++
>>   include/linux/pds/pds_core_if.h |   1 +
>>   5 files changed, 206 insertions(+)
>>   create mode 100644 drivers/vfio/pci/pds/Makefile
>>   create mode 100644 drivers/vfio/pci/pds/pci_drv.c
>>   create mode 100644 drivers/vfio/pci/pds/vfio_dev.c
>>   create mode 100644 drivers/vfio/pci/pds/vfio_dev.h
>>
>> diff --git a/drivers/vfio/pci/pds/Makefile b/drivers/vfio/pci/pds/Makefile
>> new file mode 100644
>> index 000000000000..dcc8f6beffe2
>> --- /dev/null
>> +++ b/drivers/vfio/pci/pds/Makefile
>> @@ -0,0 +1,6 @@
>> +# SPDX-License-Identifier: GPL-2.0
>> +obj-$(CONFIG_PDS_VFIO_PCI) += pds_vfio.o
>> +
>> +pds_vfio-y := \
>> +     pci_drv.o       \
>> +     vfio_dev.o
>> diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_drv.c
>> new file mode 100644
>> index 000000000000..09cab0dbb0e9
>> --- /dev/null
>> +++ b/drivers/vfio/pci/pds/pci_drv.c
>> @@ -0,0 +1,102 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright(c) 2022 Pensando Systems, Inc */
>> +
>> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>> +
>> +#include <linux/module.h>
>> +#include <linux/pci.h>
>> +#include <linux/types.h>
>> +#include <linux/vfio.h>
>> +
>> +#include <linux/pds/pds_core_if.h>
>> +
>> +#include "vfio_dev.h"
>> +
>> +#define PDS_VFIO_DRV_NAME            "pds_vfio"
>> +#define PDS_VFIO_DRV_DESCRIPTION     "Pensando VFIO Device Driver"
>> +#define PCI_VENDOR_ID_PENSANDO               0x1dd8
>> +
>> +static int
>> +pds_vfio_pci_probe(struct pci_dev *pdev,
>> +                const struct pci_device_id *id)
>> +{
>> +     struct pds_vfio_pci_device *pds_vfio;
>> +     int err;
>> +
>> +     pds_vfio = vfio_alloc_device(pds_vfio_pci_device, vfio_coredev.vdev,
>> +                                  &pdev->dev,  pds_vfio_ops_info());
>> +     if (IS_ERR(pds_vfio))
>> +             return PTR_ERR(pds_vfio);
>> +
>> +     dev_set_drvdata(&pdev->dev, &pds_vfio->vfio_coredev);
>> +     pds_vfio->pdev = pdev;
>> +
>> +     err = vfio_pci_core_register_device(&pds_vfio->vfio_coredev);
>> +     if (err)
>> +             goto out_put_vdev;
>> +
>> +     return 0;
>> +
>> +out_put_vdev:
>> +     vfio_put_device(&pds_vfio->vfio_coredev.vdev);
>> +     return err;
>> +}
>> +
>> +static void
>> +pds_vfio_pci_remove(struct pci_dev *pdev)
>> +{
>> +     struct pds_vfio_pci_device *pds_vfio = pds_vfio_pci_drvdata(pdev);
>> +
>> +     vfio_pci_core_unregister_device(&pds_vfio->vfio_coredev);
>> +     vfio_put_device(&pds_vfio->vfio_coredev.vdev);
>> +}
>> +
>> +static const struct pci_device_id
>> +pds_vfio_pci_table[] = {
>> +     {
>> +             .class = PCI_CLASS_STORAGE_EXPRESS,
>> +             .class_mask = 0xffffff,
>> +             .vendor = PCI_VENDOR_ID_PENSANDO,
>> +             .device = PCI_DEVICE_ID_PENSANDO_NVME_VF,
>> +             .subvendor = PCI_ANY_ID,
>> +             .subdevice = PCI_ANY_ID,
>> +             .override_only = PCI_ID_F_VFIO_DRIVER_OVERRIDE,
>> +     },
>> +     { 0, }
>> +};
>> +MODULE_DEVICE_TABLE(pci, pds_vfio_pci_table);
>> +
>> +static struct pci_driver
>> +pds_vfio_pci_driver = {
>> +     .name = PDS_VFIO_DRV_NAME,
>> +     .id_table = pds_vfio_pci_table,
>> +     .probe = pds_vfio_pci_probe,
>> +     .remove = pds_vfio_pci_remove,
>> +     .driver_managed_dma = true,
>> +};
>> +
>> +static void __exit
>> +pds_vfio_pci_cleanup(void)
>> +{
>> +     pci_unregister_driver(&pds_vfio_pci_driver);
>> +}
>> +module_exit(pds_vfio_pci_cleanup);
>> +
>> +static int __init
>> +pds_vfio_pci_init(void)
>> +{
>> +     int err;
>> +
>> +     err = pci_register_driver(&pds_vfio_pci_driver);
>> +     if (err) {
>> +             pr_err("pci driver register failed: %pe\n", ERR_PTR(err));
>> +             return err;
>> +     }
>> +
>> +     return 0;
>> +}
>> +module_init(pds_vfio_pci_init);
> 
> It would be better to use module_pci_driver(pds_vfio_pci_driver) instead

Generally you are correct, but note that the next patch adds the 
auxiliary_driver registration so that it is no longer  a simple PCI init.

sln

> 
> Thanks,
> Longfang.
> 
>> +
>> +MODULE_DESCRIPTION(PDS_VFIO_DRV_DESCRIPTION);
>> +MODULE_AUTHOR("Pensando Systems, Inc");
>> +MODULE_LICENSE("GPL");
>> diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
>> new file mode 100644
>> index 000000000000..f8f4006c0915
>> --- /dev/null
>> +++ b/drivers/vfio/pci/pds/vfio_dev.c
>> @@ -0,0 +1,74 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright(c) 2022 Pensando Systems, Inc */
>> +
>> +#include <linux/vfio.h>
>> +#include <linux/vfio_pci_core.h>
>> +
>> +#include "vfio_dev.h"
>> +
>> +struct pds_vfio_pci_device *
>> +pds_vfio_pci_drvdata(struct pci_dev *pdev)
>> +{
>> +     struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
>> +
>> +     return container_of(core_device, struct pds_vfio_pci_device,
>> +                         vfio_coredev);
>> +}
>> +
>> +static int
>> +pds_vfio_init_device(struct vfio_device *vdev)
>> +{
>> +     struct pds_vfio_pci_device *pds_vfio =
>> +             container_of(vdev, struct pds_vfio_pci_device,
>> +                          vfio_coredev.vdev);
>> +     struct pci_dev *pdev = to_pci_dev(vdev->dev);
>> +     int err;
>> +
>> +     err = vfio_pci_core_init_dev(vdev);
>> +     if (err)
>> +             return err;
>> +
>> +     pds_vfio->vf_id = pci_iov_vf_id(pdev);
>> +     pds_vfio->pci_id = PCI_DEVID(pdev->bus->number, pdev->devfn);
>> +
>> +     return 0;
>> +}
>> +
>> +static int
>> +pds_vfio_open_device(struct vfio_device *vdev)
>> +{
>> +     struct pds_vfio_pci_device *pds_vfio =
>> +             container_of(vdev, struct pds_vfio_pci_device,
>> +                          vfio_coredev.vdev);
>> +     int err;
>> +
>> +     err = vfio_pci_core_enable(&pds_vfio->vfio_coredev);
>> +     if (err)
>> +             return err;
>> +
>> +     vfio_pci_core_finish_enable(&pds_vfio->vfio_coredev);
>> +
>> +     return 0;
>> +}
>> +
>> +static const struct vfio_device_ops
>> +pds_vfio_ops = {
>> +     .name = "pds-vfio",
>> +     .init = pds_vfio_init_device,
>> +     .release = vfio_pci_core_release_dev,
>> +     .open_device = pds_vfio_open_device,
>> +     .close_device = vfio_pci_core_close_device,
>> +     .ioctl = vfio_pci_core_ioctl,
>> +     .device_feature = vfio_pci_core_ioctl_feature,
>> +     .read = vfio_pci_core_read,
>> +     .write = vfio_pci_core_write,
>> +     .mmap = vfio_pci_core_mmap,
>> +     .request = vfio_pci_core_request,
>> +     .match = vfio_pci_core_match,
>> +};
>> +
>> +const struct vfio_device_ops *
>> +pds_vfio_ops_info(void)
>> +{
>> +     return &pds_vfio_ops;
>> +}
>> diff --git a/drivers/vfio/pci/pds/vfio_dev.h b/drivers/vfio/pci/pds/vfio_dev.h
>> new file mode 100644
>> index 000000000000..289479a08dce
>> --- /dev/null
>> +++ b/drivers/vfio/pci/pds/vfio_dev.h
>> @@ -0,0 +1,23 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright(c) 2022 Pensando Systems, Inc */
>> +
>> +#ifndef _VFIO_DEV_H_
>> +#define _VFIO_DEV_H_
>> +
>> +#include <linux/pci.h>
>> +#include <linux/vfio_pci_core.h>
>> +
>> +struct pds_vfio_pci_device {
>> +     struct vfio_pci_core_device vfio_coredev;
>> +     struct pci_dev *pdev;
>> +
>> +     int vf_id;
>> +     int pci_id;
>> +};
>> +
>> +const struct vfio_device_ops *
>> +pds_vfio_ops_info(void);
>> +struct pds_vfio_pci_device *
>> +pds_vfio_pci_drvdata(struct pci_dev *pdev);
>> +
>> +#endif /* _VFIO_DEV_H_ */
>> diff --git a/include/linux/pds/pds_core_if.h b/include/linux/pds/pds_core_if.h
>> index 6e92697657e4..4362b94a7666 100644
>> --- a/include/linux/pds/pds_core_if.h
>> +++ b/include/linux/pds/pds_core_if.h
>> @@ -9,6 +9,7 @@
>>   #define PCI_VENDOR_ID_PENSANDO                       0x1dd8
>>   #define PCI_DEVICE_ID_PENSANDO_CORE_PF               0x100c
>>   #define PCI_DEVICE_ID_PENSANDO_VDPA_VF          0x100b
>> +#define PCI_DEVICE_ID_PENSANDO_NVME_VF               0x1006
>>
>>   #define PDS_CORE_BARS_MAX                    4
>>   #define PDS_CORE_PCI_BAR_DBELL                       1
>>
