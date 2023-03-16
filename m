Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBCA6BC4B1
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 04:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjCPD11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 23:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjCPD0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 23:26:41 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6848721A3E
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 20:25:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=meKmWelPoeJw1hcnjs282md58HEFBKUJCqy0uq7rTXTsreDeorHnjMHwAvgm7AHc/HlmwOAoIEwjX9IunNeyzjopiKpQrnBQQzWkiBv1bOjfBSPvM6oMvv2QBf3dXnM9Sh+oRoIWEoYrHFa8Htv+9i6PZpPlRtW++vCnK7+IjmFcNDcqVmKysopqPmQ4YYAVvTE8bN8U2ue618lw9SZZqHaJZ64QkC/0sb4GRU/+xg9GnGoS1HKNDKnN1vxa8m1WdlZ/oKbeBz312g5mGnfBlYhAbvYxVzOJ5aCDQS5KEQf0UJafDrEPfZQdCXuOIz/I2OEILK/COxMI7Sovaw9aDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hYnY56TBZz1bsIaunHoG1uZaI/eWWsgaTB/HRI297pM=;
 b=Qtr0vGWdTjr1P46kVVHwQv4c80iVS6/6d9IjDU43tlC21P/VWv38IAguaZ+KHpLWJipOzb5C15307HfzTNx0I7lgnxf2iHzY3ngQ5b1D4t9g8tskgQpX09ekfgsaxgcuyHaEhlck5Z0Ptjc0OQHle7AQw2oBYpW9MrG13UMQVO289BqZ1CjYqkTu9t/6tL0iD+W+A2/jz6QStEefHNwzgXGeqkQLKv5xNdXz/MCI3dyBBES9LSQOpP09oqOvGE5msGhgl8tkrlxCyrmMGeP7tMScpvPCuPMcym7af4Hvso2hHdCI/wNAGk7yuTeZ7+1/NUKLDyaeBeF84fIA60ctVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hYnY56TBZz1bsIaunHoG1uZaI/eWWsgaTB/HRI297pM=;
 b=RqI5V4mdJdEEv2UkXpd6clWBNjOhPtfnGUP/HkSc/QI1vNcPJ43WQ23LhW/01or0ua7Xbv2+1qOXUJRw8NWTBxT6tF4fNnyTHIAzbC992pkntMG2K90VZ8gTlTPPWAIOi3fV3UPHykiGTn10UmWaIL5zvCly53dNd8HRqs2T0JM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 CY8PR12MB8215.namprd12.prod.outlook.com (2603:10b6:930:77::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.29; Thu, 16 Mar 2023 03:25:17 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab%8]) with mapi id 15.20.6178.024; Thu, 16 Mar 2023
 03:25:16 +0000
Message-ID: <cde38f74-66da-7eb0-c933-d4848bd17bc1@amd.com>
Date:   Wed, 15 Mar 2023 20:25:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH RFC v2 virtio 4/7] pds_vdpa: add vdpa config client
 commands
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io
References: <20230309013046.23523-1-shannon.nelson@amd.com>
 <20230309013046.23523-5-shannon.nelson@amd.com>
 <CACGkMEtcm+VeTUKw_DF=bHFpYRUyqOkhh+UEfc+ppUp5zuNVkw@mail.gmail.com>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <CACGkMEtcm+VeTUKw_DF=bHFpYRUyqOkhh+UEfc+ppUp5zuNVkw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR06CA0056.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::33) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|CY8PR12MB8215:EE_
X-MS-Office365-Filtering-Correlation-Id: b272c936-9aab-4530-abc4-08db25ce1023
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 86rcZjVZiGaz0ync1tyTVy4+ayDS/ieRLM98W1GJBrPid3OLv1FRW/S1eP1XVfGnxYPIA/Z3O3B1a9J6ekNUWFjJvBsXH33He8O1fsmNPoEZ/XwSReO7LXtWL+RF3pIovds3RedoRVrraIINtm8CsjaNPkIC0cOcufSXWVmChQjemarAFYW7S7/ZI8vvG+IP87EjdquCV0lr5XPb5WE61WbR+KlCqEQSJqmNVcl3/hXr0pi2v7FxhNs2hxdlYcQwjJRBTVdVdpGNhtptqkArTNjjQNIqMkcIBDk7z8Nmyy0TqfS3vQKrjzIKXJLwk/pdjkv7UKk5ZMOuaO0bxS8TbGTpb0+oGPwPVsjeiiVDs2niBMATW42jVMysksb1rjZ/CCg1/7Dqgw+JASqJinIJOx2z7nrJ5jXp7DQXEvMeukPCPWVtAyqFcBRyzrTGPvLPt84JQMgWtsNc9jejP7RVObeKytcrsnUYu1OtdGMOQp9uQd7RmC2IptYUPwusVnGcic4tWs6Ph8JwezQLcUVw+VQKhEGS9cQsxlXKm5HN50r6lSB5iPM49wc2g6o2F/lps+IfSvaKYdjCsCMPGVwDLILR5q+qoLxEyN3jSNABMyraXtcEZs/rXFdqh7IVMo8wAyNuNFdaAWZ0Y3TppN9KlK5dozNXLmCQ3AWybJSWSMq96MYEvUQBG9mt4+d1y/jZQaXa0NAAs7v1+eMi1JxXYVnpGV1YrcSAZJWDeM11DxQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(396003)(39860400002)(376002)(136003)(451199018)(2616005)(26005)(478600001)(6486002)(53546011)(36756003)(186003)(6512007)(6666004)(316002)(6506007)(30864003)(38100700002)(5660300002)(86362001)(41300700001)(31696002)(8936002)(31686004)(44832011)(83380400001)(66899018)(2906002)(66476007)(66946007)(66556008)(4326008)(6916009)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cWhvbEtMRmhSeFVsMGVJNCtFc29uOTZHUEtXb2hYUVY1RWUrSEVQV0s0NUMz?=
 =?utf-8?B?dDFOdXc0Z0JoeWRRNTdIVmJwczVMTUFQMVJ0U1FBT3FUa25OZWVxQkRJdDFl?=
 =?utf-8?B?TEZzeWJ6bHk0VG1uNkc3MDNpUkRFSGRrNmRobUR6Z0lhTDZZaUpISEQ5SzIr?=
 =?utf-8?B?RG9sNWRzbGkwRmJtWFBuNUx5ZmNZM3BHLzVKMlR3US9hN3VDV3dPTHE2cWlp?=
 =?utf-8?B?OW8xeUR1MmgvRUtvaytJWnUwQ3cyWEFOT0Q3MHY3Z2ViVDBMOTFPZnBOQjAv?=
 =?utf-8?B?M1lYRmwvODRaZU5qaXpKWER6S3dIcmF6WFpiOFdhaVJJalFQblVGUVhhUkkx?=
 =?utf-8?B?YUtzQ2Q5L04rK1M5bGlpMlBWZnhaQlo5RlR5L1htaFd4UGN4Zk1ERGlEQUxv?=
 =?utf-8?B?cXIvTzRLNTBIYXpEdEl6Q1ArenlhQVBLTlllMEFMYTN6Uzc4VmRhbHR2dWRz?=
 =?utf-8?B?aThINGtEY2FKTnNTTlFYd1BmdERvd0pRcUVDbUxCSk5DTmJkak1HSGZlQWdM?=
 =?utf-8?B?UTdYS1VTZTdlcjRtKzMxQU9ERktwVDg3Zy9zU1NSUEhOWTU2YzlxdHk5NTFz?=
 =?utf-8?B?QlR2dFJxckxFQXVNRUdUZXNWNmgwUElpYUNqOGt1NEsyQTYzNmZIa251T2Ex?=
 =?utf-8?B?RzdTLzVWYXlkdXQ0TVpZM3MwdFBEbzRpd2FlK1ZOWGZPQlU4UDRaeDY5NnB1?=
 =?utf-8?B?aDFrWXlER1QvWENaK3RYNUFlWFg2ckpodUFUc1M1bVYzamU0eEMzU0RJbVJ1?=
 =?utf-8?B?N3VPam5CT3JQYS9JNjJ4b1NCVktOcStNd1psTm1rUkdlVTNxemZBWVBEZmFi?=
 =?utf-8?B?bzA1ZHVWMDJMamZBMkl6RFpwTGxQazkzc0xqS1ViS1EvQy9EQ2hVczJ5S24z?=
 =?utf-8?B?aEJtaEJ1ZXJWSU96OGxqSXNPK2VQN0tvd01abEdtN3E4dXVHWWh4dmtxeDJr?=
 =?utf-8?B?SElPYjJPM1cwR0pHZ2lHckNyaWUyWTRiemRLUlY4LzJVWkQrRjNMWEFERjRh?=
 =?utf-8?B?YndTdTQ4alBmbkt0UkRxb3NnMVZWM00yQkcrRnlSa2lMamxpc1BVTW1IQU54?=
 =?utf-8?B?NWJWWGw0TzNMOFRCaFpzZEo4QWpocUNkNHF1MjRXamp4K2tadHFkcE9VYzIy?=
 =?utf-8?B?cWo2Z010REtCZWp3RkFadVA2eDBwY3NyQjRRQmxQK25SYkJZMEx2OGtCVERp?=
 =?utf-8?B?MmVaYUNXbFRnY0o5RTVuS3V2OU02Y0lYYmVrY21DOThkNWdCK1hueGp2enRX?=
 =?utf-8?B?YWhWN1RYQjd1NGhYMEoxbkd1STE3MCswRFpGM2lMNGxxMS80NWFSY0ZPTksw?=
 =?utf-8?B?c2tHbmp3a1N6Q016NjIrNkpuZmNSa2d1Y3NWSHQyWlRhVWpoZXFtSVlka3hv?=
 =?utf-8?B?c0dSQ0ZjYUZYMVpic3g2bFU0cWhLNTlpSG12eEJCekRqRFpDQ1NuTUxLdExw?=
 =?utf-8?B?WVlLVW85QlJvS1hxN05nbkF6UEpWTTlWSCtnQkhvUm5hVW5sc0lzQ0JlRUNT?=
 =?utf-8?B?cVRDL3U2MzV0RkttTXFvV1l0N2hlbFM4UXBvK1J5YlBUNFF0SDk5VkQycVBp?=
 =?utf-8?B?dDZYV21Kd2xrUEk4U2pqaHVxV2F6ZkhiQ3FFMmhRTDZ6bXJ4dm1YRnZBQVcw?=
 =?utf-8?B?aGlCRDhFWDRVRHI3aGVCaHdXMjRYR3BIR200MWJIWWJyQzE1MmtuVnE3TVlQ?=
 =?utf-8?B?eXM4eHU1a0dWdCt3MUFPaWpUbENqTkZvS0lUdE1ZUkxMWTM1ZlVwU1lKTEFP?=
 =?utf-8?B?L2FNWFRtdWVaTHB4ekRlYVg0WWgrY2VDeGVPNGFoODFQVTBVb0tIU20xb1dX?=
 =?utf-8?B?UC9SaUJxN1diSGVBTUFuNkF4dkc1M3Ryem1rZVVDVlZrT0h1UElBTUtFUUV3?=
 =?utf-8?B?OG9HbjVzVHJhUTBBQ24zK3NhejdHaElUKzYvMDNYbzhGSTR3RFpqUmNmUTkx?=
 =?utf-8?B?TE5GcHBrdkJkNWpsMHFNaExHK0pKMjk2WWp6eVlLMzV6aDZvRy9OOXZsd0Zi?=
 =?utf-8?B?V3dHSEFQeUxaZEdsSk94ekVYR093aDdRZ3pzcHRTNHc4UDNwQTNFVnh1YUtq?=
 =?utf-8?B?TjJPdXBYN2QxSG0vRHMyK3RDR0dxOS9vNXNoZ3pORHBwdEFzWG9GM0ZNRlJI?=
 =?utf-8?Q?dyz4CH6hSZtO9FP+5emkd6rgv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b272c936-9aab-4530-abc4-08db25ce1023
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 03:25:16.8571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +F5vhOOsIZDgcanyaq0y4P/1n70AEsoGX387ek/CHlLpOSfKQvws/1tgudXGC/9e2qTNBSjCWTCBg5nlpb9fXg==
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
>> These are the adminq commands that will be needed for
>> setting up and using the vDPA device.
> 
> It's better to explain under which case the driver should use adminq,
> I see some functions overlap with common configuration capability.
> More below.

Yes, I agree this needs to be more clearly stated.  The overlap is 
because the original FW didn't have the virtio device as well modeled 
and we had to go through adminq calls to get things done.  Now that we 
have a reasonable virtio emulation and can use the virtio_net_config, we 
have a lot less need for the adminq calls.


> 
>>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> ---
>>   drivers/vdpa/pds/Makefile    |   1 +
>>   drivers/vdpa/pds/cmds.c      | 207 +++++++++++++++++++++++++++++++++++
>>   drivers/vdpa/pds/cmds.h      |  16 +++
>>   drivers/vdpa/pds/vdpa_dev.h  |  36 +++++-
>>   include/linux/pds/pds_vdpa.h | 175 +++++++++++++++++++++++++++++
>>   5 files changed, 434 insertions(+), 1 deletion(-)
>>   create mode 100644 drivers/vdpa/pds/cmds.c
>>   create mode 100644 drivers/vdpa/pds/cmds.h
>>
>> diff --git a/drivers/vdpa/pds/Makefile b/drivers/vdpa/pds/Makefile
>> index ca2efa8c6eb5..7211eba3d942 100644
>> --- a/drivers/vdpa/pds/Makefile
>> +++ b/drivers/vdpa/pds/Makefile
>> @@ -4,6 +4,7 @@
>>   obj-$(CONFIG_PDS_VDPA) := pds_vdpa.o
>>
>>   pds_vdpa-y := aux_drv.o \
>> +             cmds.o \
>>                virtio_pci.o \
>>                vdpa_dev.o
>>
>> diff --git a/drivers/vdpa/pds/cmds.c b/drivers/vdpa/pds/cmds.c
>> new file mode 100644
>> index 000000000000..45410739107c
>> --- /dev/null
>> +++ b/drivers/vdpa/pds/cmds.c
>> @@ -0,0 +1,207 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
>> +
>> +#include <linux/vdpa.h>
>> +#include <linux/virtio_pci_modern.h>
>> +
>> +#include <linux/pds/pds_core_if.h>
>> +#include <linux/pds/pds_adminq.h>
>> +#include <linux/pds/pds_auxbus.h>
>> +#include <linux/pds/pds_vdpa.h>
>> +
>> +#include "vdpa_dev.h"
>> +#include "aux_drv.h"
>> +#include "cmds.h"
>> +
>> +int pds_vdpa_init_hw(struct pds_vdpa_device *pdsv)
>> +{
>> +       struct pds_auxiliary_dev *padev = pdsv->vdpa_aux->padev;
>> +       struct device *dev = &padev->aux_dev.dev;
>> +       struct pds_vdpa_init_cmd init_cmd = {
>> +               .opcode = PDS_VDPA_CMD_INIT,
>> +               .vdpa_index = pdsv->vdpa_index,
>> +               .vf_id = cpu_to_le16(pdsv->vdpa_aux->vf_id),
>> +               .len = cpu_to_le32(sizeof(struct virtio_net_config)),
>> +               .config_pa = 0,   /* we use the PCI space, not an alternate space */
>> +       };
>> +       struct pds_vdpa_comp init_comp = {0};
>> +       int err;
>> +
>> +       /* Initialize the vdpa/virtio device */
>> +       err = padev->ops->adminq_cmd(padev,
>> +                                    (union pds_core_adminq_cmd *)&init_cmd,
>> +                                    sizeof(init_cmd),
>> +                                    (union pds_core_adminq_comp *)&init_comp,
>> +                                    0);
>> +       if (err)
>> +               dev_err(dev, "Failed to init hw, status %d: %pe\n",
>> +                       init_comp.status, ERR_PTR(err));
>> +
>> +       return err;
>> +}
>> +
>> +int pds_vdpa_cmd_reset(struct pds_vdpa_device *pdsv)
>> +{
> 
> This function is not used.
> 
> And I wonder what's the difference between reset via adminq and reset
> via pds_vdpa_set_status(0) ?

Ideally no difference.


> 
>> +       struct pds_auxiliary_dev *padev = pdsv->vdpa_aux->padev;
>> +       struct device *dev = &padev->aux_dev.dev;
>> +       struct pds_vdpa_cmd cmd = {
>> +               .opcode = PDS_VDPA_CMD_RESET,
>> +               .vdpa_index = pdsv->vdpa_index,
>> +               .vf_id = cpu_to_le16(pdsv->vdpa_aux->vf_id),
>> +       };
>> +       struct pds_vdpa_comp comp = {0};
>> +       int err;
>> +
>> +       err = padev->ops->adminq_cmd(padev,
>> +                                    (union pds_core_adminq_cmd *)&cmd,
>> +                                    sizeof(cmd),
>> +                                    (union pds_core_adminq_comp *)&comp,
>> +                                    0);
>> +       if (err)
>> +               dev_err(dev, "Failed to reset hw, status %d: %pe\n",
>> +                       comp.status, ERR_PTR(err));
> 
> It might be better to use deb_dbg() here since it can be triggered by the guest.

Sure.

> 
>> +
>> +       return err;
>> +}
>> +
>> +int pds_vdpa_cmd_set_mac(struct pds_vdpa_device *pdsv, u8 *mac)
>> +{
>> +       struct pds_auxiliary_dev *padev = pdsv->vdpa_aux->padev;
>> +       struct device *dev = &padev->aux_dev.dev;
>> +       struct pds_vdpa_setattr_cmd cmd = {
>> +               .opcode = PDS_VDPA_CMD_SET_ATTR,
>> +               .vdpa_index = pdsv->vdpa_index,
>> +               .vf_id = cpu_to_le16(pdsv->vdpa_aux->vf_id),
>> +               .attr = PDS_VDPA_ATTR_MAC,
>> +       };
>> +       struct pds_vdpa_comp comp = {0};
>> +       int err;
>> +
>> +       ether_addr_copy(cmd.mac, mac);
>> +       err = padev->ops->adminq_cmd(padev,
>> +                                    (union pds_core_adminq_cmd *)&cmd,
>> +                                    sizeof(cmd),
>> +                                    (union pds_core_adminq_comp *)&comp,
>> +                                    0);
>> +       if (err)
>> +               dev_err(dev, "Failed to set mac address %pM, status %d: %pe\n",
>> +                       mac, comp.status, ERR_PTR(err));
>> +
>> +       return err;
>> +}
>> +
>> +int pds_vdpa_cmd_set_max_vq_pairs(struct pds_vdpa_device *pdsv, u16 max_vqp)
>> +{
>> +       struct pds_auxiliary_dev *padev = pdsv->vdpa_aux->padev;
>> +       struct device *dev = &padev->aux_dev.dev;
>> +       struct pds_vdpa_setattr_cmd cmd = {
>> +               .opcode = PDS_VDPA_CMD_SET_ATTR,
>> +               .vdpa_index = pdsv->vdpa_index,
>> +               .vf_id = cpu_to_le16(pdsv->vdpa_aux->vf_id),
>> +               .attr = PDS_VDPA_ATTR_MAX_VQ_PAIRS,
>> +               .max_vq_pairs = cpu_to_le16(max_vqp),
>> +       };
>> +       struct pds_vdpa_comp comp = {0};
>> +       int err;
>> +
>> +       err = padev->ops->adminq_cmd(padev,
>> +                                    (union pds_core_adminq_cmd *)&cmd,
>> +                                    sizeof(cmd),
>> +                                    (union pds_core_adminq_comp *)&comp,
>> +                                    0);
>> +       if (err)
>> +               dev_err(dev, "Failed to set max vq pairs %u, status %d: %pe\n",
>> +                       max_vqp, comp.status, ERR_PTR(err));
>> +
>> +       return err;
>> +}
>> +
>> +int pds_vdpa_cmd_init_vq(struct pds_vdpa_device *pdsv, u16 qid,
>> +                        struct pds_vdpa_vq_info *vq_info)
>> +{
>> +       struct pds_auxiliary_dev *padev = pdsv->vdpa_aux->padev;
>> +       struct device *dev = &padev->aux_dev.dev;
>> +       struct pds_vdpa_vq_init_comp comp = {0};
>> +       struct pds_vdpa_vq_init_cmd cmd = {
>> +               .opcode = PDS_VDPA_CMD_VQ_INIT,
>> +               .vdpa_index = pdsv->vdpa_index,
>> +               .vf_id = cpu_to_le16(pdsv->vdpa_aux->vf_id),
>> +               .qid = cpu_to_le16(qid),
>> +               .len = cpu_to_le16(ilog2(vq_info->q_len)),
>> +               .desc_addr = cpu_to_le64(vq_info->desc_addr),
>> +               .avail_addr = cpu_to_le64(vq_info->avail_addr),
>> +               .used_addr = cpu_to_le64(vq_info->used_addr),
>> +               .intr_index = cpu_to_le16(qid),
>> +       };
>> +       int err;
>> +
>> +       dev_dbg(dev, "%s: qid %d len %d desc_addr %#llx avail_addr %#llx used_addr %#llx\n",
>> +               __func__, qid, ilog2(vq_info->q_len),
>> +               vq_info->desc_addr, vq_info->avail_addr, vq_info->used_addr);
>> +
>> +       err = padev->ops->adminq_cmd(padev,
>> +                                    (union pds_core_adminq_cmd *)&cmd,
>> +                                    sizeof(cmd),
>> +                                    (union pds_core_adminq_comp *)&comp,
>> +                                    0);
> 
> We map common cfg in pds_vdpa_probe_virtio, any reason for using
> adminq here? (I guess it might be faster?)

It's just easier to hand the values to the FW in a single package and 
let it sort things out as it needs, and it will complain with a handy 
error code if necessary.

> 
>> +       if (err) {
>> +               dev_err(dev, "Failed to init vq %d, status %d: %pe\n",
>> +                       qid, comp.status, ERR_PTR(err));
>> +               return err;
>> +       }
>> +
>> +       vq_info->hw_qtype = comp.hw_qtype;
> 
> What does hw_qtype mean?

Hmmm... this and hw_qindex are hardware specific values that I don't 
thinkg we need any longer.  I'll pull them out.

> 
>> +       vq_info->hw_qindex = le16_to_cpu(comp.hw_qindex);
>> +
>> +       return 0;
>> +}
>> +
>> +int pds_vdpa_cmd_reset_vq(struct pds_vdpa_device *pdsv, u16 qid)
>> +{
>> +       struct pds_auxiliary_dev *padev = pdsv->vdpa_aux->padev;
>> +       struct device *dev = &padev->aux_dev.dev;
>> +       struct pds_vdpa_vq_reset_cmd cmd = {
>> +               .opcode = PDS_VDPA_CMD_VQ_RESET,
>> +               .vdpa_index = pdsv->vdpa_index,
>> +               .vf_id = cpu_to_le16(pdsv->vdpa_aux->vf_id),
>> +               .qid = cpu_to_le16(qid),
>> +       };
>> +       struct pds_vdpa_comp comp = {0};
>> +       int err;
>> +
>> +       err = padev->ops->adminq_cmd(padev,
>> +                                    (union pds_core_adminq_cmd *)&cmd,
>> +                                    sizeof(cmd),
>> +                                    (union pds_core_adminq_comp *)&comp,
>> +                                    0);
>> +       if (err)
>> +               dev_err(dev, "Failed to reset vq %d, status %d: %pe\n",
>> +                       qid, comp.status, ERR_PTR(err));
>> +
>> +       return err;
>> +}
>> +
>> +int pds_vdpa_cmd_set_features(struct pds_vdpa_device *pdsv, u64 features)
>> +{
>> +       struct pds_auxiliary_dev *padev = pdsv->vdpa_aux->padev;
>> +       struct device *dev = &padev->aux_dev.dev;
>> +       struct pds_vdpa_set_features_cmd cmd = {
>> +               .opcode = PDS_VDPA_CMD_SET_FEATURES,
>> +               .vdpa_index = pdsv->vdpa_index,
>> +               .vf_id = cpu_to_le16(pdsv->vdpa_aux->vf_id),
>> +               .features = cpu_to_le64(features),
>> +       };
>> +       struct pds_vdpa_comp comp = {0};
>> +       int err;
>> +
>> +       err = padev->ops->adminq_cmd(padev,
>> +                                    (union pds_core_adminq_cmd *)&cmd,
>> +                                    sizeof(cmd),
>> +                                    (union pds_core_adminq_comp *)&comp,
>> +                                    0);
>> +       if (err)
>> +               dev_err(dev, "Failed to set features %#llx, status %d: %pe\n",
>> +                       features, comp.status, ERR_PTR(err));
>> +
>> +       return err;
>> +}
>> diff --git a/drivers/vdpa/pds/cmds.h b/drivers/vdpa/pds/cmds.h
>> new file mode 100644
>> index 000000000000..72e19f4efde6
>> --- /dev/null
>> +++ b/drivers/vdpa/pds/cmds.h
>> @@ -0,0 +1,16 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
>> +
>> +#ifndef _VDPA_CMDS_H_
>> +#define _VDPA_CMDS_H_
>> +
>> +int pds_vdpa_init_hw(struct pds_vdpa_device *pdsv);
>> +
>> +int pds_vdpa_cmd_reset(struct pds_vdpa_device *pdsv);
>> +int pds_vdpa_cmd_set_mac(struct pds_vdpa_device *pdsv, u8 *mac);
>> +int pds_vdpa_cmd_set_max_vq_pairs(struct pds_vdpa_device *pdsv, u16 max_vqp);
>> +int pds_vdpa_cmd_init_vq(struct pds_vdpa_device *pdsv, u16 qid,
>> +                        struct pds_vdpa_vq_info *vq_info);
>> +int pds_vdpa_cmd_reset_vq(struct pds_vdpa_device *pdsv, u16 qid);
>> +int pds_vdpa_cmd_set_features(struct pds_vdpa_device *pdsv, u64 features);
>> +#endif /* _VDPA_CMDS_H_ */
>> diff --git a/drivers/vdpa/pds/vdpa_dev.h b/drivers/vdpa/pds/vdpa_dev.h
>> index 97fab833a0aa..33284ebe538c 100644
>> --- a/drivers/vdpa/pds/vdpa_dev.h
>> +++ b/drivers/vdpa/pds/vdpa_dev.h
>> @@ -4,11 +4,45 @@
>>   #ifndef _VDPA_DEV_H_
>>   #define _VDPA_DEV_H_
>>
>> -#define PDS_VDPA_MAX_QUEUES    65
>> +#include <linux/pci.h>
>> +#include <linux/vdpa.h>
>> +
>> +struct pds_vdpa_vq_info {
>> +       bool ready;
>> +       u64 desc_addr;
>> +       u64 avail_addr;
>> +       u64 used_addr;
>> +       u32 q_len;
>> +       u16 qid;
>> +       int irq;
>> +       char irq_name[32];
>> +
>> +       void __iomem *notify;
>> +       dma_addr_t notify_pa;
>> +
>> +       u64 doorbell;
>> +       u16 avail_idx;
>> +       u16 used_idx;
>> +
>> +       u8 hw_qtype;
>> +       u16 hw_qindex;
>>
>> +       struct vdpa_callback event_cb;
>> +       struct pds_vdpa_device *pdsv;
>> +};
>> +
>> +#define PDS_VDPA_MAX_QUEUES    65
>> +#define PDS_VDPA_MAX_QLEN      32768
>>   struct pds_vdpa_device {
>>          struct vdpa_device vdpa_dev;
>>          struct pds_vdpa_aux *vdpa_aux;
>> +
>> +       struct pds_vdpa_vq_info vqs[PDS_VDPA_MAX_QUEUES];
>> +       u64 req_features;               /* features requested by vdpa */
>> +       u64 actual_features;            /* features negotiated and in use */
>> +       u8 vdpa_index;                  /* rsvd for future subdevice use */
>> +       u8 num_vqs;                     /* num vqs in use */
>> +       struct vdpa_callback config_cb;
>>   };
>>
>>   int pds_vdpa_get_mgmt_info(struct pds_vdpa_aux *vdpa_aux);
>> diff --git a/include/linux/pds/pds_vdpa.h b/include/linux/pds/pds_vdpa.h
>> index 3f7c08551163..b6a4cb4d3c6b 100644
>> --- a/include/linux/pds/pds_vdpa.h
>> +++ b/include/linux/pds/pds_vdpa.h
>> @@ -101,4 +101,179 @@ struct pds_vdpa_ident_cmd {
>>          __le32 len;
>>          __le64 ident_pa;
>>   };
>> +
>> +/**
>> + * struct pds_vdpa_status_cmd - STATUS_UPDATE command
>> + * @opcode:    Opcode PDS_VDPA_CMD_STATUS_UPDATE
>> + * @vdpa_index: Index for vdpa subdevice
>> + * @vf_id:     VF id
>> + * @status:    new status bits
>> + */
>> +struct pds_vdpa_status_cmd {
>> +       u8     opcode;
>> +       u8     vdpa_index;
>> +       __le16 vf_id;
>> +       u8     status;
>> +};
>> +
>> +/**
>> + * enum pds_vdpa_attr - List of VDPA device attributes
>> + * @PDS_VDPA_ATTR_MAC:          MAC address
>> + * @PDS_VDPA_ATTR_MAX_VQ_PAIRS: Max virtqueue pairs
>> + */
>> +enum pds_vdpa_attr {
>> +       PDS_VDPA_ATTR_MAC          = 1,
>> +       PDS_VDPA_ATTR_MAX_VQ_PAIRS = 2,
>> +};
>> +
>> +/**
>> + * struct pds_vdpa_setattr_cmd - SET_ATTR command
>> + * @opcode:            Opcode PDS_VDPA_CMD_SET_ATTR
>> + * @vdpa_index:                Index for vdpa subdevice
>> + * @vf_id:             VF id
>> + * @attr:              attribute to be changed (enum pds_vdpa_attr)
>> + * @pad:               Word boundary padding
>> + * @mac:               new mac address to be assigned as vdpa device address
>> + * @max_vq_pairs:      new limit of virtqueue pairs
>> + */
>> +struct pds_vdpa_setattr_cmd {
>> +       u8     opcode;
>> +       u8     vdpa_index;
>> +       __le16 vf_id;
>> +       u8     attr;
>> +       u8     pad[3];
>> +       union {
>> +               u8 mac[6];
>> +               __le16 max_vq_pairs;
>> +       } __packed;
>> +};
>> +
>> +/**
>> + * struct pds_vdpa_vq_init_cmd - queue init command
>> + * @opcode: Opcode PDS_VDPA_CMD_VQ_INIT
>> + * @vdpa_index:        Index for vdpa subdevice
>> + * @vf_id:     VF id
>> + * @qid:       Queue id (bit0 clear = rx, bit0 set = tx, qid=N is ctrlq)
>> + * @len:       log(2) of max descriptor count
>> + * @desc_addr: DMA address of descriptor area
>> + * @avail_addr:        DMA address of available descriptors (aka driver area)
>> + * @used_addr: DMA address of used descriptors (aka device area)
>> + * @intr_index:        interrupt index
>> + */
>> +struct pds_vdpa_vq_init_cmd {
>> +       u8     opcode;
>> +       u8     vdpa_index;
>> +       __le16 vf_id;
>> +       __le16 qid;
>> +       __le16 len;
>> +       __le64 desc_addr;
>> +       __le64 avail_addr;
>> +       __le64 used_addr;
>> +       __le16 intr_index;
> 
> Just wonder in which case intr_index can be different from qid, in
> pds_vdpa_cmd_init_vq() we had:
> 
>                  .intr_index = cpu_to_le16(qid),

Yes, it normally is going to be the same.  The FW allows us to specify 
it separate from the qid in order to allow flexibility in setting up 
interrupts when we want to experiment with it.  For now we just plug in 
the number.

sln

> 
> Thanks
> 
> 
>> +};
>> +
>> +/**
>> + * struct pds_vdpa_vq_init_comp - queue init completion
>> + * @status:    Status of the command (enum pds_core_status_code)
>> + * @hw_qtype:  HW queue type, used in doorbell selection
>> + * @hw_qindex: HW queue index, used in doorbell selection
>> + * @rsvd:      Word boundary padding
>> + * @color:     Color bit
>> + */
>> +struct pds_vdpa_vq_init_comp {
>> +       u8     status;
>> +       u8     hw_qtype;
>> +       __le16 hw_qindex;
>> +       u8     rsvd[11];
>> +       u8     color;
>> +};
>> +
>> +/**
>> + * struct pds_vdpa_vq_reset_cmd - queue reset command
>> + * @opcode:    Opcode PDS_VDPA_CMD_VQ_RESET
>> + * @vdpa_index:        Index for vdpa subdevice
>> + * @vf_id:     VF id
>> + * @qid:       Queue id
>> + */
>> +struct pds_vdpa_vq_reset_cmd {
>> +       u8     opcode;
>> +       u8     vdpa_index;
>> +       __le16 vf_id;
>> +       __le16 qid;
>> +};
>> +
>> +/**
>> + * struct pds_vdpa_set_features_cmd - set hw features
>> + * @opcode: Opcode PDS_VDPA_CMD_SET_FEATURES
>> + * @vdpa_index:        Index for vdpa subdevice
>> + * @vf_id:     VF id
>> + * @rsvd:       Word boundary padding
>> + * @features:  Feature bit mask
>> + */
>> +struct pds_vdpa_set_features_cmd {
>> +       u8     opcode;
>> +       u8     vdpa_index;
>> +       __le16 vf_id;
>> +       __le32 rsvd;
>> +       __le64 features;
>> +};
>> +
>> +/**
>> + * struct pds_vdpa_vq_set_state_cmd - set vq state
>> + * @opcode:    Opcode PDS_VDPA_CMD_VQ_SET_STATE
>> + * @vdpa_index:        Index for vdpa subdevice
>> + * @vf_id:     VF id
>> + * @qid:       Queue id
>> + * @avail:     Device avail index.
>> + * @used:      Device used index.
>> + *
>> + * If the virtqueue uses packed descriptor format, then the avail and used
>> + * index must have a wrap count.  The bits should be arranged like the upper
>> + * 16 bits in the device available notification data: 15 bit index, 1 bit wrap.
>> + */
>> +struct pds_vdpa_vq_set_state_cmd {
>> +       u8     opcode;
>> +       u8     vdpa_index;
>> +       __le16 vf_id;
>> +       __le16 qid;
>> +       __le16 avail;
>> +       __le16 used;
>> +};
>> +
>> +/**
>> + * struct pds_vdpa_vq_get_state_cmd - get vq state
>> + * @opcode:    Opcode PDS_VDPA_CMD_VQ_GET_STATE
>> + * @vdpa_index:        Index for vdpa subdevice
>> + * @vf_id:     VF id
>> + * @qid:       Queue id
>> + */
>> +struct pds_vdpa_vq_get_state_cmd {
>> +       u8     opcode;
>> +       u8     vdpa_index;
>> +       __le16 vf_id;
>> +       __le16 qid;
>> +};
>> +
>> +/**
>> + * struct pds_vdpa_vq_get_state_comp - get vq state completion
>> + * @status:    Status of the command (enum pds_core_status_code)
>> + * @rsvd0:      Word boundary padding
>> + * @avail:     Device avail index.
>> + * @used:      Device used index.
>> + * @rsvd:       Word boundary padding
>> + * @color:     Color bit
>> + *
>> + * If the virtqueue uses packed descriptor format, then the avail and used
>> + * index will have a wrap count.  The bits will be arranged like the "next"
>> + * part of device available notification data: 15 bit index, 1 bit wrap.
>> + */
>> +struct pds_vdpa_vq_get_state_comp {
>> +       u8     status;
>> +       u8     rsvd0;
>> +       __le16 avail;
>> +       __le16 used;
>> +       u8     rsvd[9];
>> +       u8     color;
>> +};
>> +
>>   #endif /* _PDS_VDPA_IF_H_ */
>> --
>> 2.17.1
>>
> 
