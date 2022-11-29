Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECCE63CB03
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 23:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236713AbiK2WYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 17:24:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235889AbiK2WYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 17:24:34 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F24AF6CA1A
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 14:24:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HU+owpZ1FyeU0OTdsWLcNFY7SbiP76ztfr/3ae5IYQT/4tow4E1bndsVCXg4sK1FaWaiIP9gvh4cgMTczSa8Xtvc1xAOJqrU7e+Wcnhwz3dWE/DXKun6wth3c6/sfzKqEtrWeKplaeK7/NlzJV40KgkkLqU695g06mTXqF1WBhWFZEYSh9uzSc8vJ+reMMbIOym1kDNKtbAOikxNc0EzsfwdwyKtozjs+MDugCzHoFw3IbpoOCmT5F9lIc3oLvIFfdOIQFjNxn79VGDAGmk7Houoa4q3pz2iurZqWWxG0ae2ZYh/7i3j/Lv3fAwBs3H74bY2Tu9i/bzN8V9DEmeq+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XU+l4bK8+BpnTL/9vs5iNPetPf89h3xjh3f89AuHGD8=;
 b=AuT5YhnI5UIDdNXfP0h7uHrMdpuwjx2HiX/PQgKPQQavVwC2ZnSG1TqEhfBhsPoOlSLJTmyS10GHGnTG3C4vngXGUw8/B/afGzFka8DIey8k9sTHYHNkH0noHIFz+wWifQaIi+bPGKQdvSRTTX/nekoC9ShVqysYDTX43EIgYwcCqloFbfyEF/061iB18+nwvj50B40fLnfKh0JZmIvG9icHwLU8esYxyLUmfDq7jxn9EJzcwht3x7c/0XnIs//v+SK8fMFDv3Le1ZqWcEJET4qIUKLZMj6tAZw2I9/eEohpwgoLspg+1xntFABV/1txpGnLuTRdHSeEQLh6mJHtKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XU+l4bK8+BpnTL/9vs5iNPetPf89h3xjh3f89AuHGD8=;
 b=GNUlomGueeigt389oqXJ0h2VnsKPrAwsMs7A+F0AYtG+FwLO91qxqei/GJ/9sCtf7ll6S7+R27RRZiRPwcNZ7+SUpxQ2Pr2/FDM5FzeVElSpgGucCB59WHNqzXrBshZ/vvzEjQCu9+7sv3ZDB6HYAQrGzO/iw5i6jKom7ReJrXU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 MW4PR12MB7262.namprd12.prod.outlook.com (2603:10b6:303:228::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 22:24:29 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b%6]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 22:24:28 +0000
Message-ID: <589e7548-6985-3b35-ee5a-f24641b58a9e@amd.com>
Date:   Tue, 29 Nov 2022 14:24:24 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [RFC PATCH net-next 14/19] pds_vdpa: Add new PCI VF device for
 PDS vDPA services
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>,
        Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, mst@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     drivers@pensando.io
References: <20221118225656.48309-1-snelson@pensando.io>
 <20221118225656.48309-15-snelson@pensando.io>
 <5f7eba6a-442c-4b26-d83f-de7cf633ce65@redhat.com>
From:   Shannon Nelson <shnelson@amd.com>
In-Reply-To: <5f7eba6a-442c-4b26-d83f-de7cf633ce65@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:a03:40::21) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|MW4PR12MB7262:EE_
X-MS-Office365-Filtering-Correlation-Id: 8eb44220-e805-4f56-4ab1-08dad2587a68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QI3FpZFv0UvRpPjjsOkK/4hvfmj8qW5EAaSfnKnnkHOf4/9gcLe5ttI6ww9HO0LIhMPlcQXaEbPv98NQNIBr2ZCycPKPMXjCxGPA0WlVX1wof9pFhMzFk561/uhN5cbZ3IUQHgP6Ojk09epNClBAfdY+xahuEVszAcnsTWvSKY7h6jLy+2Btx7uUv6Tzfv/N1Jo7xqnc+dWdGlh75z+dmw1JguWxay1X1vGeqkBXWx9Fq4dfWvC2fFL00OaFDLAkOca+PihqxjrZgIpQzcOV3HlxfWxhXZvJ++BgjWWdo+sp3z6tjI40Tdt/2F87VEeCDwoR3vPINjazKJ3ti345Rx03xA/ZFH2gyxZjagq7eGBcIRGyTyPcfWv7CrDvlW0noVAM1uUK3BLGumZ0BGksUvVK7Ta9komsilIi7E7vAFvNCvBh3hNn+r6O9hqWjlUUhs0ORHjTmac5AoxxIteVPQ0i65UsZzupCtk3OtY8GkGVikRB237muGaLESqzbf25ujtvJB7eGZZOityNh9F0rY/0PkZLWZwne7/dgWPMJJiMyozsKqiPJ/Sqdt+auFk7OBhG7Cxz0XRK6k7C3hy98DsVI1azsn9MneqO81aBT/kER1SMfNXPOrIIDuctxm8hGngTcx2BlWPoDy91lOvqihZ7GOPGOpkfWj879gWOwP6arOq29NUsmsbxju0JM2wmktY7pKD1HfvOI2TMX8jtupqIRfIrfgROqgyTMumagac=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(366004)(396003)(376002)(39860400002)(451199015)(66556008)(66476007)(66946007)(8676002)(5660300002)(41300700001)(8936002)(36756003)(31696002)(30864003)(478600001)(53546011)(6506007)(6512007)(83380400001)(6666004)(26005)(2616005)(186003)(110136005)(316002)(6486002)(38100700002)(4326008)(2906002)(31686004)(66899015)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y3lQUFQzOE5yanM4V0RoMUNCNGlCSTF2VkNMSGlwU0JaMHh3N2U5SlNXYVpV?=
 =?utf-8?B?Z3NjbmtZMkgwWlR2MEMzUmp6MmltTlhTVUZHSHRzMkF4UFowZ2NrTCs3alNn?=
 =?utf-8?B?bklCWFIvUDZzeWswNEhORjRFckM4V0pBdmdkTmo3bFR3KzY5dktYTFpMTTBh?=
 =?utf-8?B?NFFkeG80eHlwRTgrQXFSRGFIT0NXSW1vQ2pnTk5UenE1L0xJSjlqNTZsTWhy?=
 =?utf-8?B?QVZrMmRlRVVibG5ZZkdrL0RyclR5Z0I4U1ZKRFRoN2xYL2pIUDFvc3Rsd0JE?=
 =?utf-8?B?L1QxbWh6Wkd2b21pWUxndk9TclA5RVllMW96KzExUjd0MXBmM0xTZWx6OU50?=
 =?utf-8?B?ZitzdEJxY2ZZTnhBN2lPUHBmaFlvTUpwMmhZeTRxS1kvUDdPc3hWUHE4dVRo?=
 =?utf-8?B?a29zbnQweW5SeE5WVXpMM1J0QkdaYS9iaSsxQXJRT3plMW1mZE9HOHB1bHo2?=
 =?utf-8?B?MzVSaHZmZFdRUjRkWnBNZGlrWjlaSHNEblRpcXNrSjgzNEt6cDlMdzdsMFBR?=
 =?utf-8?B?Tzhxa0srNzFSRnB3Q2lkSDhKK0MxMDVSUmliYkJLa1prdHR1S2lIZ1lIcDlj?=
 =?utf-8?B?T0RIb0JDR1BzaStaTG9TMWJkTWE0QXpFNlYzZ3FDenR1dytvaHNhaXc0amlB?=
 =?utf-8?B?SmF3MG9peEkwZUhVTCsvZmw4bENoRlhoQXZ1NHNXT1JqRFV5aFlyS2F0YkNV?=
 =?utf-8?B?endGUHNnTTdwc3hMRGdWWlN5cHFMa2JVR3UwZU9Ic2tLVk9ha3FuSnpYU25k?=
 =?utf-8?B?TDJKU3dPYjRweFc4TzMwemNtMFhJQWdUWWlTVEZLbXFUMXRvdDB4QTFhSUJE?=
 =?utf-8?B?TlhTdFNscG83R2FhK2ZycmUveXhYWDV0R1kwYXQxT0dEWXNmOEJzRW5CWjA0?=
 =?utf-8?B?aFkvWFh1cElZbUszSzAwY3V6dlhsYTRPeXZaaDV2UndTRHErcDdEUzAxUnUz?=
 =?utf-8?B?MlIwaUFoTFBDVlNKaHJnNmhMeDhleFlFdmtGN0I3ditsbnA3VS9wdWJnZytG?=
 =?utf-8?B?cVhPelJUOEt0a3lvQVZIVnR6MVNPYU9WZjZCdmgxK0pkSkpmVm0xRGwrN3Qy?=
 =?utf-8?B?WEJWSjcva0hOUGM0MDJRV0M2cHN1c2FjNWpxUUhyM3BiZzNCVW9LdVV3dTJq?=
 =?utf-8?B?YWI5UFU3VktLRXhUUS9sS1RGeUhqWTJ5WEJBVnBqMnlLZmN5L2IwdWhDTWxh?=
 =?utf-8?B?SE8xRW5wVjEybUFrcUhiOUV3by83dXU1eUs2RzFVWHR3N3FjZVlKTVZDYzNK?=
 =?utf-8?B?bldsM1JKbE1JLzMwVlhNSlU0ZmwvRjhXejdmcXVKb3U0Mm1wTkZKN0pVQUNs?=
 =?utf-8?B?UmJCaFJGSVUraG9panBFcFJXMkRCK2lCNEFXS09sd0wvY2t5VXdoNnJRdEE5?=
 =?utf-8?B?VExXK3JPVytoSHNEZkRHVTNxUUUyQ2hTRStXenFCS25oMDdnUGFyUTR0VE0v?=
 =?utf-8?B?TXlRR0M0RHZ3RTFaUUN0V1BmYitsendrZ3RaZks4ZUVCY1pYRW1VNElCenRL?=
 =?utf-8?B?NWJNUUo4WDhoN1JRYVNNb3JKdkU3dUg3VnRLeC84QXlaK01HVnNOTjJ1bXU0?=
 =?utf-8?B?b0tuZXc5Q1ZnMnZDYkZyTjkzcGhEem1ia3JYbUd3UFBiZUpxWnExOTNLOVZK?=
 =?utf-8?B?ZTBjd2dKdWUyOXFudWE5MkVOYnloYjF2Sy80bHZsRCtFQmhYYjl0MDFYbWVY?=
 =?utf-8?B?d3pzYzV4UWJhdExBMGI5VFdrVHB6Y0hKTGNYSkthYnBNU05yV0ViVkdxUkxr?=
 =?utf-8?B?R2VIN1VMVXJDeW40VjRtdWw5ZzZLdGJjWUFEWWdCZm9xeVdYVW5VSlVHeGlZ?=
 =?utf-8?B?R2xWTlEvZjJ2U0JNaFFCTGlLZHZ0UE1CakhHOGcwbEd4VVlYYytuZjI3dG9C?=
 =?utf-8?B?RmEzVlp2bjhCRzZHZDJtRENyUXpzM3RwcWpvNFB5MEh2V3BzOVE0dDAxQU9Z?=
 =?utf-8?B?VU9uSnFlWUk4dEJ0Uk1odFpTeE1vRDlCTFBsZ0g1dGZNNmt1NnBPOXV3a0dZ?=
 =?utf-8?B?RkdNSWx5ZDdMRklWV0hTeFVRVHdJRGpRYUtLY1lZOUkrVU03b3M4cmtZdnJ0?=
 =?utf-8?B?dlVKSmNxbFgwOVZVNUpmTld2cE8wYWdaZy9ZMitZdU5WYUlVbFluWUp0cW4v?=
 =?utf-8?Q?nOSrxThPjsjHMa/rDMrdy929c?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eb44220-e805-4f56-4ab1-08dad2587a68
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 22:24:28.0518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ko1DMb1ViKvjOxCeMq+mvdwHhYaBLeT18UvE+zmTJc9eM7suQh09yazXn76pJG5tcIi2wco/fJyWbvLgSOAwnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7262
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/22 7:53 PM, Jason Wang wrote:
> 在 2022/11/19 06:56, Shannon Nelson 写道:
>> This is the initial PCI driver framework for the new pds_vdpa VF
>> device driver, an auxiliary_bus client of the pds_core driver.
>> This does the very basics of registering for the new PCI
>> device 1dd8:100b, setting up debugfs entries, and registering
>> with devlink.
>>
>> The new PCI device id has not made it to the official PCI ID Repository
>> yet, but will soon be registered there.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> ---
>>   drivers/vdpa/pds/Makefile       |   7 +
>>   drivers/vdpa/pds/debugfs.c      |  44 +++++++
>>   drivers/vdpa/pds/debugfs.h      |  22 ++++
>>   drivers/vdpa/pds/pci_drv.c      | 143 +++++++++++++++++++++
>>   drivers/vdpa/pds/pci_drv.h      |  46 +++++++
>>   include/linux/pds/pds_core_if.h |   1 +
>>   include/linux/pds/pds_vdpa.h    | 219 ++++++++++++++++++++++++++++++++
>>   7 files changed, 482 insertions(+)
>>   create mode 100644 drivers/vdpa/pds/Makefile
>>   create mode 100644 drivers/vdpa/pds/debugfs.c
>>   create mode 100644 drivers/vdpa/pds/debugfs.h
>>   create mode 100644 drivers/vdpa/pds/pci_drv.c
>>   create mode 100644 drivers/vdpa/pds/pci_drv.h
>>   create mode 100644 include/linux/pds/pds_vdpa.h
>>
>> diff --git a/drivers/vdpa/pds/Makefile b/drivers/vdpa/pds/Makefile
>> new file mode 100644
>> index 000000000000..3ba28a875574
>> --- /dev/null
>> +++ b/drivers/vdpa/pds/Makefile
>> @@ -0,0 +1,7 @@
>> +# SPDX-License-Identifier: GPL-2.0-only
>> +# Copyright(c) 2022 Pensando Systems, Inc
>> +
>> +obj-$(CONFIG_PDS_VDPA) := pds_vdpa.o
>> +
>> +pds_vdpa-y := pci_drv.o      \
>> +           debugfs.o
>> diff --git a/drivers/vdpa/pds/debugfs.c b/drivers/vdpa/pds/debugfs.c
>> new file mode 100644
>> index 000000000000..f5b6654ae89b
>> --- /dev/null
>> +++ b/drivers/vdpa/pds/debugfs.c
>> @@ -0,0 +1,44 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/* Copyright(c) 2022 Pensando Systems, Inc */
>> +
>> +#include <linux/module.h>
>> +#include <linux/pci.h>
>> +#include <linux/types.h>
>> +
>> +#include <linux/pds/pds_core_if.h>
>> +#include <linux/pds/pds_vdpa.h>
>> +
>> +#include "pci_drv.h"
>> +#include "debugfs.h"
>> +
>> +#ifdef CONFIG_DEBUG_FS
>> +
>> +static struct dentry *dbfs_dir;
>> +
>> +void
>> +pds_vdpa_debugfs_create(void)
>> +{
>> +     dbfs_dir = debugfs_create_dir(PDS_VDPA_DRV_NAME, NULL);
>> +}
>> +
>> +void
>> +pds_vdpa_debugfs_destroy(void)
>> +{
>> +     debugfs_remove_recursive(dbfs_dir);
>> +     dbfs_dir = NULL;
>> +}
>> +
>> +void
>> +pds_vdpa_debugfs_add_pcidev(struct pds_vdpa_pci_device *vdpa_pdev)
>> +{
>> +     vdpa_pdev->dentry = 
>> debugfs_create_dir(pci_name(vdpa_pdev->pdev), dbfs_dir);
>> +}
>> +
>> +void
>> +pds_vdpa_debugfs_del_pcidev(struct pds_vdpa_pci_device *vdpa_pdev)
>> +{
>> +     debugfs_remove_recursive(vdpa_pdev->dentry);
>> +     vdpa_pdev->dentry = NULL;
>> +}
>> +
>> +#endif /* CONFIG_DEBUG_FS */
>> diff --git a/drivers/vdpa/pds/debugfs.h b/drivers/vdpa/pds/debugfs.h
>> new file mode 100644
>> index 000000000000..ac31ab47746b
>> --- /dev/null
>> +++ b/drivers/vdpa/pds/debugfs.h
>> @@ -0,0 +1,22 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/* Copyright(c) 2022 Pensando Systems, Inc */
>> +
>> +#ifndef _PDS_VDPA_DEBUGFS_H_
>> +#define _PDS_VDPA_DEBUGFS_H_
>> +
>> +#include <linux/debugfs.h>
>> +
>> +#ifdef CONFIG_DEBUG_FS
>> +
>> +void pds_vdpa_debugfs_create(void);
>> +void pds_vdpa_debugfs_destroy(void);
>> +void pds_vdpa_debugfs_add_pcidev(struct pds_vdpa_pci_device *vdpa_pdev);
>> +void pds_vdpa_debugfs_del_pcidev(struct pds_vdpa_pci_device *vdpa_pdev);
>> +#else
>> +static inline void pds_vdpa_debugfs_create(void) { }
>> +static inline void pds_vdpa_debugfs_destroy(void) { }
>> +static inline void pds_vdpa_debugfs_add_pcidev(struct 
>> pds_vdpa_pci_device *vdpa_pdev) { }
>> +static inline void pds_vdpa_debugfs_del_pcidev(struct 
>> pds_vdpa_pci_device *vdpa_pdev) { }
>> +#endif
>> +
>> +#endif /* _PDS_VDPA_DEBUGFS_H_ */
>> diff --git a/drivers/vdpa/pds/pci_drv.c b/drivers/vdpa/pds/pci_drv.c
>> new file mode 100644
>> index 000000000000..369e11153f21
>> --- /dev/null
>> +++ b/drivers/vdpa/pds/pci_drv.c
>> @@ -0,0 +1,143 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/* Copyright(c) 2022 Pensando Systems, Inc */
>> +
>> +#include <linux/module.h>
>> +#include <linux/pci.h>
>> +#include <linux/aer.h>
>> +#include <linux/types.h>
>> +#include <linux/vdpa.h>
>> +
>> +#include <linux/pds/pds_core_if.h>
>> +#include <linux/pds/pds_vdpa.h>
>> +
>> +#include "pci_drv.h"
>> +#include "debugfs.h"
>> +
>> +static void
>> +pds_vdpa_dma_action(void *data)
>> +{
>> +     pci_free_irq_vectors((struct pci_dev *)data);
>> +}
> 
> 
> Nit: since we're release irq vectors, it might be better to use
> "pds_vdpa_irq_action"

Sure.

> 
> 
>> +
>> +static int
>> +pds_vdpa_pci_probe(struct pci_dev *pdev,
>> +                const struct pci_device_id *id)
>> +{
>> +     struct pds_vdpa_pci_device *vdpa_pdev;
>> +     struct device *dev = &pdev->dev;
>> +     int err;
>> +
>> +     vdpa_pdev = kzalloc(sizeof(*vdpa_pdev), GFP_KERNEL);
>> +     if (!vdpa_pdev)
>> +             return -ENOMEM;
>> +     pci_set_drvdata(pdev, vdpa_pdev);
>> +
>> +     vdpa_pdev->pdev = pdev;
>> +     vdpa_pdev->vf_id = pci_iov_vf_id(pdev);
>> +     vdpa_pdev->pci_id = PCI_DEVID(pdev->bus->number, pdev->devfn);
>> +
>> +     /* Query system for DMA addressing limitation for the device. */
>> +     err = dma_set_mask_and_coherent(dev, 
>> DMA_BIT_MASK(PDS_CORE_ADDR_LEN));
>> +     if (err) {
>> +             dev_err(dev, "Unable to obtain 64-bit DMA for consistent 
>> allocations, aborting. %pe\n",
>> +                     ERR_PTR(err));
>> +             goto err_out_free_mem;
>> +     }
>> +
>> +     pci_enable_pcie_error_reporting(pdev);
>> +
>> +     /* Use devres management */
>> +     err = pcim_enable_device(pdev);
>> +     if (err) {
>> +             dev_err(dev, "Cannot enable PCI device: %pe\n", 
>> ERR_PTR(err));
>> +             goto err_out_free_mem;
>> +     }
>> +
>> +     err = devm_add_action_or_reset(dev, pds_vdpa_dma_action, pdev);
>> +     if (err) {
>> +             dev_err(dev, "Failed adding devres for freeing irq 
>> vectors: %pe\n",
>> +                     ERR_PTR(err));
>> +             goto err_out_pci_release_device;
>> +     }
>> +
>> +     pci_set_master(pdev);
>> +
>> +     pds_vdpa_debugfs_add_pcidev(vdpa_pdev);
>> +
>> +     dev_info(dev, "%s: PF %#04x VF %#04x (%d) vf_id %d domain %d 
>> vdpa_aux %p vdpa_pdev %p\n",
>> +              __func__, pci_dev_id(vdpa_pdev->pdev->physfn),
>> +              vdpa_pdev->pci_id, vdpa_pdev->pci_id, vdpa_pdev->vf_id,
>> +              pci_domain_nr(pdev->bus), vdpa_pdev->vdpa_aux, vdpa_pdev);
>> +
>> +     return 0;
>> +
>> +err_out_pci_release_device:
>> +     pci_disable_device(pdev);
> 
> 
> Do we still need to care about this consider we use
> devres/pcim_enable_device()?

It isn't absolutely necessary...  I like how the pcim/devm stuff will 
clean up lost items at removal time, but I like to try to keep lost 
items from happening in the first place.

> 
> 
>> +err_out_free_mem:
>> +     pci_disable_pcie_error_reporting(pdev);
>> +     kfree(vdpa_pdev);
>> +     return err;
>> +}
>> +
>> +static void
>> +pds_vdpa_pci_remove(struct pci_dev *pdev)
>> +{
>> +     struct pds_vdpa_pci_device *vdpa_pdev = pci_get_drvdata(pdev);
>> +
>> +     pds_vdpa_debugfs_del_pcidev(vdpa_pdev);
>> +     pci_clear_master(pdev);
>> +     pci_disable_pcie_error_reporting(pdev);
>> +     pci_disable_device(pdev);
>> +     kfree(vdpa_pdev);
>> +
>> +     dev_info(&pdev->dev, "Removed\n");
>> +}
>> +
>> +static const struct pci_device_id
>> +pds_vdpa_pci_table[] = {
>> +     { PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_VDPA_VF) },
>> +     { 0, }
>> +};
>> +MODULE_DEVICE_TABLE(pci, pds_vdpa_pci_table);
>> +
>> +static struct pci_driver
>> +pds_vdpa_pci_driver = {
>> +     .name = PDS_VDPA_DRV_NAME,
>> +     .id_table = pds_vdpa_pci_table,
>> +     .probe = pds_vdpa_pci_probe,
>> +     .remove = pds_vdpa_pci_remove
>> +};
>> +
>> +static void __exit
>> +pds_vdpa_pci_cleanup(void)
>> +{
>> +     pci_unregister_driver(&pds_vdpa_pci_driver);
>> +
>> +     pds_vdpa_debugfs_destroy();
>> +}
>> +module_exit(pds_vdpa_pci_cleanup);
>> +
>> +static int __init
>> +pds_vdpa_pci_init(void)
>> +{
>> +     int err;
>> +
>> +     pds_vdpa_debugfs_create();
>> +
>> +     err = pci_register_driver(&pds_vdpa_pci_driver);
>> +     if (err) {
>> +             pr_err("%s: pci driver register failed: %pe\n", 
>> __func__, ERR_PTR(err));
>> +             goto err_pci;
>> +     }
>> +
>> +     return 0;
>> +
>> +err_pci:
>> +     pds_vdpa_debugfs_destroy();
>> +     return err;
>> +}
>> +module_init(pds_vdpa_pci_init);
>> +
>> +MODULE_DESCRIPTION(PDS_VDPA_DRV_DESCRIPTION);
>> +MODULE_AUTHOR("Pensando Systems, Inc");
>> +MODULE_LICENSE("GPL");
>> diff --git a/drivers/vdpa/pds/pci_drv.h b/drivers/vdpa/pds/pci_drv.h
>> new file mode 100644
>> index 000000000000..747809e0df9e
>> --- /dev/null
>> +++ b/drivers/vdpa/pds/pci_drv.h
>> @@ -0,0 +1,46 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/* Copyright(c) 2022 Pensando Systems, Inc */
>> +
>> +#ifndef _PCI_DRV_H
>> +#define _PCI_DRV_H
>> +
>> +#include <linux/pci.h>
>> +#include <linux/virtio_pci_modern.h>
>> +
>> +#define PDS_VDPA_DRV_NAME           "pds_vdpa"
>> +#define PDS_VDPA_DRV_DESCRIPTION    "Pensando vDPA VF Device Driver"
>> +
>> +#define PDS_VDPA_BAR_BASE    0
>> +#define PDS_VDPA_BAR_INTR    2
>> +#define PDS_VDPA_BAR_DBELL   4
>> +
>> +struct pds_dev_bar {
>> +     int           index;
>> +     void __iomem  *vaddr;
>> +     phys_addr_t   pa;
>> +     unsigned long len;
>> +};
>> +
>> +struct pds_vdpa_intr_info {
>> +     int index;
>> +     int irq;
>> +     int qid;
>> +     char name[32];
>> +};
>> +
>> +struct pds_vdpa_pci_device {
>> +     struct pci_dev *pdev;
>> +     struct pds_vdpa_aux *vdpa_aux;
>> +
>> +     int vf_id;
>> +     int pci_id;
>> +
>> +     int nintrs;
>> +     struct pds_vdpa_intr_info *intrs;
>> +
>> +     struct dentry *dentry;
>> +
>> +     struct virtio_pci_modern_device vd_mdev;
>> +};
>> +
>> +#endif /* _PCI_DRV_H */
>> diff --git a/include/linux/pds/pds_core_if.h 
>> b/include/linux/pds/pds_core_if.h
>> index 6333ec351e14..6e92697657e4 100644
>> --- a/include/linux/pds/pds_core_if.h
>> +++ b/include/linux/pds/pds_core_if.h
>> @@ -8,6 +8,7 @@
>>
>>   #define PCI_VENDOR_ID_PENSANDO                      0x1dd8
>>   #define PCI_DEVICE_ID_PENSANDO_CORE_PF              0x100c
>> +#define PCI_DEVICE_ID_PENSANDO_VDPA_VF          0x100b
>>
>>   #define PDS_CORE_BARS_MAX                   4
>>   #define PDS_CORE_PCI_BAR_DBELL                      1
>> diff --git a/include/linux/pds/pds_vdpa.h b/include/linux/pds/pds_vdpa.h
>> new file mode 100644
>> index 000000000000..7ecef890f175
>> --- /dev/null
>> +++ b/include/linux/pds/pds_vdpa.h
>> @@ -0,0 +1,219 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/* Copyright(c) 2022 Pensando Systems, Inc */
>> +
>> +#ifndef _PDS_VDPA_IF_H_
>> +#define _PDS_VDPA_IF_H_
>> +
>> +#include <linux/pds/pds_common.h>
>> +
>> +#define PDS_DEV_TYPE_VDPA_STR        "vDPA"
>> +#define PDS_VDPA_DEV_NAME    PDS_CORE_DRV_NAME "." PDS_DEV_TYPE_VDPA_STR
>> +
>> +/*
>> + * enum pds_vdpa_cmd_opcode - vDPA Device commands
>> + */
>> +enum pds_vdpa_cmd_opcode {
>> +     PDS_VDPA_CMD_INIT               = 48,
>> +     PDS_VDPA_CMD_IDENT              = 49,
>> +     PDS_VDPA_CMD_RESET              = 51,
>> +     PDS_VDPA_CMD_VQ_RESET           = 52,
>> +     PDS_VDPA_CMD_VQ_INIT            = 53,
>> +     PDS_VDPA_CMD_STATUS_UPDATE      = 54,
>> +     PDS_VDPA_CMD_SET_FEATURES       = 55,
>> +     PDS_VDPA_CMD_SET_ATTR           = 56,
>> +};
>> +
>> +/**
>> + * struct pds_vdpa_cmd - generic command
>> + * @opcode:  Opcode
>> + * @vdpa_index:      Index for vdpa subdevice
>> + * @vf_id:   VF id
>> + */
>> +struct pds_vdpa_cmd {
>> +     u8     opcode;
>> +     u8     vdpa_index;
>> +     __le16 vf_id;
>> +};
>> +
>> +/**
>> + * struct pds_vdpa_comp - generic command completion
>> + * @status:  Status of the command (enum pds_core_status_code)
>> + * @rsvd:    Word boundary padding
>> + * @color:   Color bit
>> + */
>> +struct pds_vdpa_comp {
>> +     u8 status;
>> +     u8 rsvd[14];
>> +     u8 color;
>> +};
>> +
>> +/**
>> + * struct pds_vdpa_init_cmd - INIT command
>> + * @opcode:  Opcode PDS_VDPA_CMD_INIT
>> + * @vdpa_index: Index for vdpa subdevice
>> + * @vf_id:   VF id
>> + * @len:     length of config info DMA space
>> + * @config_pa:       address for DMA of virtio_net_config struct
> 
> 
> Looks like the structure is not specific to net, if yes, we may tweak
> the above comment to say it's the address of the device configuration 
> space.

We're not expecting to do anything other than net, but yes we can update 
this comment.

> 
> 
>> + */
>> +struct pds_vdpa_init_cmd {
>> +     u8     opcode;
>> +     u8     vdpa_index;
>> +     __le16 vf_id;
>> +     __le32 len;
>> +     __le64 config_pa;
>> +};
>> +
>> +/**
>> + * struct pds_vdpa_ident - vDPA identification data
>> + * @hw_features:     vDPA features supported by device
>> + * @max_vqs:         max queues available (2 queues for a single 
>> queuepair)
>> + * @max_qlen:                log(2) of maximum number of descriptors
>> + * @min_qlen:                log(2) of minimum number of descriptors
> 
> 
> Note that is you have the plan to support packed virtqueue, the qlen is
> not necessarily the power of 2.

Shouldn't be a problem - this is only a way of giving us the max queue 
len in an 8-bit value, it doesn't mean we can only deal with power-of-2 
actual use values.


> 
> 
>> + *
>> + * This struct is used in a DMA block that is set up for the 
>> PDS_VDPA_CMD_IDENT
>> + * transaction.  Set up the DMA block and send the address in the 
>> IDENT cmd
>> + * data, the DSC will write the ident information, then we can remove 
>> the DMA
>> + * block after reading the answer.  If the completion status is 0, 
>> then there
>> + * is valid information, else there was an error and the data should 
>> be invalid.
>> + */
>> +struct pds_vdpa_ident {
>> +     __le64 hw_features;
>> +     __le16 max_vqs;
>> +     __le16 max_qlen;
>> +     __le16 min_qlen;
>> +};
>> +
>> +/**
>> + * struct pds_vdpa_ident_cmd - IDENT command
>> + * @opcode:  Opcode PDS_VDPA_CMD_IDENT
>> + * @rsvd:       Word boundary padding
>> + * @vf_id:   VF id
>> + * @len:     length of ident info DMA space
>> + * @ident_pa:        address for DMA of ident info (struct 
>> pds_vdpa_ident)
>> + *                   only used for this transaction, then forgotten 
>> by DSC
>> + */
>> +struct pds_vdpa_ident_cmd {
>> +     u8     opcode;
>> +     u8     rsvd;
>> +     __le16 vf_id;
>> +     __le32 len;
>> +     __le64 ident_pa;
>> +};
>> +
>> +/**
>> + * struct pds_vdpa_status_cmd - STATUS_UPDATE command
>> + * @opcode:  Opcode PDS_VDPA_CMD_STATUS_UPDATE
>> + * @vdpa_index: Index for vdpa subdevice
>> + * @vf_id:   VF id
>> + * @status:  new status bits
>> + */
>> +struct pds_vdpa_status_cmd {
>> +     u8     opcode;
>> +     u8     vdpa_index;
>> +     __le16 vf_id;
>> +     u8     status;
>> +};
>> +
>> +/**
>> + * enum pds_vdpa_attr - List of VDPA device attributes
>> + * @PDS_VDPA_ATTR_MAC:          MAC address
>> + * @PDS_VDPA_ATTR_MAX_VQ_PAIRS: Max virtqueue pairs
>> + */
>> +enum pds_vdpa_attr {
>> +     PDS_VDPA_ATTR_MAC          = 1,
>> +     PDS_VDPA_ATTR_MAX_VQ_PAIRS = 2,
>> +};
>> +
>> +/**
>> + * struct pds_vdpa_setattr_cmd - SET_ATTR command
>> + * @opcode:          Opcode PDS_VDPA_CMD_SET_ATTR
>> + * @vdpa_index:              Index for vdpa subdevice
>> + * @vf_id:           VF id
>> + * @attr:            attribute to be changed (enum pds_vdpa_attr)
>> + * @pad:             Word boundary padding
>> + * @mac:             new mac address to be assigned as vdpa device 
>> address
>> + * @max_vq_pairs:    new limit of virtqueue pairs
>> + */
>> +struct pds_vdpa_setattr_cmd {
>> +     u8     opcode;
>> +     u8     vdpa_index;
>> +     __le16 vf_id;
>> +     u8     attr;
>> +     u8     pad[3];
>> +     union {
>> +             u8 mac[6];
>> +             __le16 max_vq_pairs;
> 
> 
> So does this mean if we want to set both mac and max_vq_paris, we need
> two commands? The seems to be less efficient, since the mgmt layer could
> provision more attributes here. Can we pack all attributes into a single
> command?

Yes, that is how the cmd is set up, similar to other setattr commands 
work in our firmware.  This was driven originally by our ionic's struct 
ionic_lif_setattr_cmd where you can see that the combined fields in the 
union would be much greater than the available 64 bytes for the request. 
  This is a new device, but we wanted to keep the cmd operations similar.

> 
> 
>> +     } __packed;
>> +};
>> +
>> +/**
>> + * struct pds_vdpa_vq_init_cmd - queue init command
>> + * @opcode: Opcode PDS_VDPA_CMD_VQ_INIT
>> + * @vdpa_index:      Index for vdpa subdevice
>> + * @vf_id:   VF id
>> + * @qid:     Queue id (bit0 clear = rx, bit0 set = tx, qid=N is ctrlq)
> 
> 
> I wonder any reason we need to design it like this, it would be better
> to make it general to be used by other type of virtio devices.

There's no plan to go beyond net devices, but if we find we need to 
revisit that, we can version the interface and add what is needed.

> 
> 
>> + * @len:     log(2) of max descriptor count
>> + * @desc_addr:       DMA address of descriptor area
>> + * @avail_addr:      DMA address of available descriptors (aka driver 
>> area)
>> + * @used_addr:       DMA address of used descriptors (aka device area)
>> + * @intr_index:      interrupt index
> 
> 
> Is this something like MSI-X vector?

It is an index into the VF's list of MSI-x vectors

> 
> 
>> + */
>> +struct pds_vdpa_vq_init_cmd {
>> +     u8     opcode;
>> +     u8     vdpa_index;
>> +     __le16 vf_id;
>> +     __le16 qid;
>> +     __le16 len;
>> +     __le64 desc_addr;
>> +     __le64 avail_addr;
>> +     __le64 used_addr;
>> +     __le16 intr_index;
>> +};
>> +
>> +/**
>> + * struct pds_vdpa_vq_init_comp - queue init completion
>> + * @status:  Status of the command (enum pds_core_status_code)
>> + * @hw_qtype:        HW queue type, used in doorbell selection
>> + * @hw_qindex:       HW queue index, used in doorbell selection
>> + * @rsvd:    Word boundary padding
>> + * @color:   Color bit
> 
> 
> More comment is needed to know the how to use this color bit.

Sure.  I'll add something somewhere about how this is used in place of a 
tail pointer.

> 
> 
>> + */
>> +struct pds_vdpa_vq_init_comp {
>> +     u8     status;
>> +     u8     hw_qtype;
>> +     __le16 hw_qindex;
>> +     u8     rsvd[11];
>> +     u8     color;
>> +};
>> +
>> +/**
>> + * struct pds_vdpa_vq_reset_cmd - queue reset command
>> + * @opcode:  Opcode PDS_VDPA_CMD_VQ_RESET
> 
> 
> Is there a chance that we could have more type of opcode here?

I'm not sure I understand this question... yes it is possible we can add 
to the enum pds_vdpa_cmd_opcode list.

sln

> 
> Thanks
> 
> 
>> + * @vdpa_index:      Index for vdpa subdevice
>> + * @vf_id:   VF id
>> + * @qid:     Queue id
>> + */
>> +struct pds_vdpa_vq_reset_cmd {
>> +     u8     opcode;
>> +     u8     vdpa_index;
>> +     __le16 vf_id;
>> +     __le16 qid;
>> +};
>> +
>> +/**
>> + * struct pds_vdpa_set_features_cmd - set hw features
>> + * @opcode: Opcode PDS_VDPA_CMD_SET_FEATURES
>> + * @vdpa_index:      Index for vdpa subdevice
>> + * @vf_id:   VF id
>> + * @rsvd:       Word boundary padding
>> + * @features:        Feature bit mask
>> + */
>> +struct pds_vdpa_set_features_cmd {
>> +     u8     opcode;
>> +     u8     vdpa_index;
>> +     __le16 vf_id;
>> +     __le32 rsvd;
>> +     __le64 features;
>> +};
>> +
>> +#endif /* _PDS_VDPA_IF_H_ */
> 
