Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2E946497A3
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 02:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbiLLBQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 20:16:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLLBQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 20:16:57 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2081.outbound.protection.outlook.com [40.107.92.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0F46573;
        Sun, 11 Dec 2022 17:16:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a3j72xH7qcLcRgdxzxPXflNWoLlmhDIC8ESGl7YNiyrj6hPvlS1xI7jTbwBokxh8ODXzY8HYVdq7u3GfryrY0o7gKXCg0W3G1tb8Vu6DRGILWMBxihLjrbUSZvunHRaL+wCS/O84d03Lp6wS7pu9ouwmwSTwTR5S9wJET+htPZGHR87pmySuKKEqX38kC/DEG3b+YoP9SBrLHdZq4VigwQZ1NhHT3kUoMS0IfWH2pRxdPozLbhcCi8VC6G4+/7YVNizBh5967AFdmB9lGZ/0lEshwtF6moe1feT5r3oX4RERSoTUFUYsi6UHkEg/vj7JTxELVmoSLrYi2S18t+4izw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7M3nw4rHsgnGRfFzPiI99Xa1E+A/jcJ7bwB+DpAUtDA=;
 b=RQAGpBrRN6gwuFpJkzpw88t4qypYxwx3B8IdQeGw0G1kJT93ZODRGEjFsrd4G2umBmSZ30qphfwXCTVQD6OMe+GsrB3BkzSsm1DlUhB7zl5DtdCWebFoD1+ezNoC5HSXil5+w3Hqp2E8Fa3OC0J7iiSPYS2778OGth9vfTDrPUAcddIZHXzgvLhg6CT8TfzFHaGB5RcQqCQBKLpSoHj1ixfaICLrutZvtUO68DKXIT0aprjEERFOVQykEvfj9x5EAZCtEJ94IjCXa7vXScWXx+SH8Lv6ctCsD9j7k6vfPVw3JlSfxZWKbOGiCcD1DlAoUAklZ9EeUKxz7enyXjULJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7M3nw4rHsgnGRfFzPiI99Xa1E+A/jcJ7bwB+DpAUtDA=;
 b=Uo+RTMefwWg8cIVnXQW7ul9cStJEuRSvXGcz/k9Otfvbu2EjO0igFpLqwivbuRYOgIJ3N+8/tlKFcjPhYQxVA1Ijx8VwiasTav6hFUsRuN57d+VLUjQvWntywsb3VEwO65+AHaLRR/SmOd3prBNnfLJM8ihKc3NxWHOoDtgkL3E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MWHPR12MB1390.namprd12.prod.outlook.com (2603:10b6:300:12::13)
 by CH3PR12MB7498.namprd12.prod.outlook.com (2603:10b6:610:143::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 01:16:52 +0000
Received: from MWHPR12MB1390.namprd12.prod.outlook.com
 ([fe80::6fb5:a904:643a:4a5e]) by MWHPR12MB1390.namprd12.prod.outlook.com
 ([fe80::6fb5:a904:643a:4a5e%7]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 01:16:46 +0000
Message-ID: <2f809066-1157-e84e-4d83-f9dcb66135ab@amd.com>
Date:   Sun, 11 Dec 2022 17:16:44 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC PATCH vfio 0/7] pds vfio driver
Content-Language: en-US
To:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Brett Creeley <brett.creeley@amd.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com
Cc:     shannon.nelson@amd.com, drivers@pensando.io,
        Oren Duer <oren@nvidia.com>
References: <20221207010705.35128-1-brett.creeley@amd.com>
 <1352e2f7-4822-4e49-cf3b-d8a9d537a172@nvidia.com>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <1352e2f7-4822-4e49-cf3b-d8a9d537a172@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0136.namprd04.prod.outlook.com
 (2603:10b6:303:84::21) To MWHPR12MB1390.namprd12.prod.outlook.com
 (2603:10b6:300:12::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR12MB1390:EE_|CH3PR12MB7498:EE_
X-MS-Office365-Filtering-Correlation-Id: 118e81e8-93ef-4f2a-ae0f-08dadbde888a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hlviOSc1MIKhLr2PmuYSlg1NCmfdsvVyTJz71SynC/oSwCY1WRKaDI1XE8ugquLx3BBGC99DMenlwKCEjppgUunAeVRdkKtb9RF48N2lq55+CYgz3WgzZMG4NibPRtxKrijL5bDpZPOU+P0Do3w0AJD1pb3bimMSk+GUk92tuQsINhrkB8LrxJ+eMzdkjeqeprKYFAzt/m4zRsXwn8two33hrUMueM6q1HOLyeWSW9/93Q4rYeTE3vhZwICHHMl4roCbdQlAKzSXvZ5s4ffVWjZTrp/WIcNJ8jytEbxcg68siUN60dg22U22dE1m7iwnkVw/ydcOf+wEI2wHEJIfXJgdJ/5r4Epq7JkxfXGs+2j+TnheRdjSBYLGsvOHSY2DinKws8eOTIR0jfYYQbXT0vga4Cb7MXi162/rqEImrFepb9FHpDnAPYo0XCkSwHTClqOhcMVI1lX65UbLCIh3fQhqiwcoPUqA9jaTzMcN83RNpQuRNXrceKSS9Jt/eqtETRAwsxqEObBziDRq2qbCF1+hzoaAozSP/Wuqpis/ejrnp228RjB/9HekGqjlT/XNjEz2La2wLSc/Gs5Mrx4GvBt9Wo/e3I1jwfIfeKCbkpD+CVz/pxbWHdsNkmMExVmqSOyEYo6DzLtUyeZJ5RxmkWSI0Dczs3pHZyGrX/F7+HQbOuwhyxQ1lxIoX4HxAEeroOkpBuhbsB2R+Ujkc0G5fgcruZTGVlznJOREqj0s4eRqyKSe6tm3mt9ToVgrhfOHBAlOQ4y0Gxv+grQuC+AHTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1390.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(451199015)(38100700002)(7416002)(5660300002)(31696002)(2906002)(921005)(6486002)(966005)(478600001)(41300700001)(66556008)(66946007)(45080400002)(8676002)(4326008)(66476007)(316002)(110136005)(83380400001)(186003)(26005)(6506007)(8936002)(6512007)(2616005)(53546011)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q1M0U3J4NHVVMkFieTZaZEgzMXRHa3VLM2Vob2lsalNYQ3UxNTNreWh1emZq?=
 =?utf-8?B?TXNXL1Zad2R0QVlReW5LY0ZKVXYwdjJFbzNZT2E5bEZRRFNweEZHQlFlS0du?=
 =?utf-8?B?enBPS2Zia3lMbkcvZWlRMElVQmZxTkxtNVozT2UzZkdiV0JiTzd6M2dLbHhu?=
 =?utf-8?B?MWt3MVdVUzQwei9FdEh0Q1Z6THFPbW1RazRFSW5RdlpDRlpILzRlMC9IUFFw?=
 =?utf-8?B?MkM3aU5EeVZCeDMvcnpJUmhLb3htNkExSHoyM2R1a2NMSlNaN0pqb0IvUER0?=
 =?utf-8?B?cURhS08wRGxHL2NvWEtncFVsN2tuMlp3aE04RWExQ3V3ejcrbGYyelNRUzFi?=
 =?utf-8?B?bU9TcE9hcEw4NWI1bkk2TjlXRm1kcC81dEhHM2hoYkhDWEZhN0tGV1k3MDZQ?=
 =?utf-8?B?Wk1qd1pvR1p1cUVFM3R4L1RMSThuZFN1c3pSMkxJT2E5QWVqMjJXaWU4a1ps?=
 =?utf-8?B?YVdSRG5MUDljbjkyd3NPejlSWjVKaEphMFQrbDFTZmRlN3F2WjV6OTBZYXcw?=
 =?utf-8?B?ZDJWMUhSRXRuczBFU3RwUjBIdGVNa29IU3ZwNmFYb2JQdzU5ajlNL0JIWElU?=
 =?utf-8?B?enJlYkc2YVp1MFJqWjhMWDVSd3I2elJ4NjJWVXYyYXBnWENLb1U3Zy9Ld1RV?=
 =?utf-8?B?SkJoazJnZ1phMFNOeDhlNHUxcmczeVZjMGRBVjlBdDJmMXRBVzl0OGxZemla?=
 =?utf-8?B?L3lzWmVtWDMrVTV4cFNaam1GYnB2d0lKU2xYVUYxeFpBSEpJei9mSExXb1BJ?=
 =?utf-8?B?YXdLZjRoVSs5ZnR1NGRlQ3NHSHR6d3JXMXVyU2JuQlRFRmNKMG8wSkJXdXNh?=
 =?utf-8?B?VW5rYklndmltMVZCeEZnbm9QNFJmdGpJSnp2cFZaaU1zcDMrdmtKalgvZk4v?=
 =?utf-8?B?ZXhPUjAyZlJUNHdSZUpIVHJVR0tRbnI1ZTAvZHFXcUliYlhVc3hUR2cwWWNQ?=
 =?utf-8?B?UW12R0R1eGM0WHhCV2puU3lNdFN2NHI2Z3lZS1VDTE8wMHlEeFBLaW5QN2g1?=
 =?utf-8?B?MHBUK2ZyQjU1V25qTDQxSlN6RUpPNnhhVDNhdStZR0gzejRLRk5TbDF0dFBx?=
 =?utf-8?B?eDU3RENsZTRVVmdxNTh1cys2Sk5IenhDZlNIc3ZXRVdkQmhjT1dxVjFVUnlL?=
 =?utf-8?B?dXRYL1VOK3p3L1hrcTVjR0pXQ3B3c1lWRzVIb0VEZzBrSlppVytld2VEdWxX?=
 =?utf-8?B?dlp6UUIvVFhVMDk5WTR1MXJRMDQ4L0o1dUIwMjY5UkdEQzI5dHB4V284TUQ1?=
 =?utf-8?B?dmN6cGVXMWZJb0Y5Q2h0bUdmeXNHM0RTeTZwSjVLRmtxV3gvblo2cFFoTW9E?=
 =?utf-8?B?ZXBKdG1rVURrTTg0c0x4ZWtGN0tYeVo5T1VJY1ZtQThZNkZDSmZXQjdUQmxT?=
 =?utf-8?B?bkJuZFpkRm5yOE4xalNGcERtbFJTdXFHdzA2WFdNMnJ6TnJRR2VqSzR3UExY?=
 =?utf-8?B?cDBiTWMzS2xCdFlFUzdmMzk2ZHJJZ3c2Q2cxZ1FYTDd3L3NKaVRRUDZ6ejl4?=
 =?utf-8?B?NWUxb3d3ZS91VXZMRk1tWHUzcks2RGZRdWRVMVNoMzVoK20zbzFvMzRRNG9w?=
 =?utf-8?B?Tm1wYjlvdFR5SCsyMThuZGVWU3lJMHl5SGZNMkJqdk1FR2pBVGpBUTBqRnFT?=
 =?utf-8?B?QnlkWk1QZU9mOFcvcWo4TmR4MUp4U3pxSkVIMGc1R3pJbC9JdERTTU1PK21V?=
 =?utf-8?B?aEJNcGVUbkkyREFJWEprUVhqU3Y0OEw1ck9vRURNRDh3WEFab2JlMG9mTW5z?=
 =?utf-8?B?T0VIN1grcldNeFUrTW4yMnVoNE1lYzgwQ3ZKMlBEUW12R3R5MGpQL0QzWHNV?=
 =?utf-8?B?eXd2NXVSTU9abFM3bEVTUnVtRzMyNnhDWHorb0NtaGJzWDh5ZkF6bHJIVUpv?=
 =?utf-8?B?aUw1dDEzN2ZrYzhOVzFCY3NOSU90U2ZUbmFYeDdIU1BCVzhVZU9FWkRVNlFR?=
 =?utf-8?B?RHNFQmlqNU9FYnBDSkpKM0dKT09VamFSNEtnUU5UaEI5V3kxanVYbnpVa2FQ?=
 =?utf-8?B?QkxNVDV5N3pIaVdqL2NyRWVpUldFd2dCTldJVHpLMlVwNkJzS2taYjgraGda?=
 =?utf-8?B?bkZOdDdqRjZJZzZGRHpQTE1VTkk1d2pBQlVFUmRhUThpOWZwREg0STNVdFIv?=
 =?utf-8?Q?UCfG0E04gFg/9QlxSyAA/Gdr/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 118e81e8-93ef-4f2a-ae0f-08dadbde888a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1390.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 01:16:46.1201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hnB0MfSc9OkIWe2/MDa3WJfKkJrfnOG4HzwpGDHQzEZgCgu2OHaX/jVJQBqE0OYmFs0jLjZgRGGGuwyfhsjpsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7498
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/11/2022 4:54 AM, Max Gurtovoy wrote:
> Caution: This message originated from an External Source. Use proper 
> caution when opening attachments, clicking links, or responding.
> 
> 
> On 12/7/2022 3:06 AM, Brett Creeley wrote:
>> This is a first draft patchset for a new vendor specific VFIO driver for
>> use with the AMD/Pensando Distributed Services Card (DSC). This driver
>> (pds_vfio) is a client of the newly introduced pds_core driver.
>>
>> Reference to the pds_core patchset:
>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fnetdev%2F20221207004443.33779-1-shannon.nelson%40amd.com%2F&amp;data=05%7C01%7Cbrett.creeley%40amd.com%7C0591fe11a7c24bf8789908dadb76db84%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638063600829691750%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3VMvNtUto4HwCap65NvWrIADbLzGk4Ef9ZnA9fAB458%3D&amp;reserved=0
>>
>> AMD/Pensando already supports a NVMe VF device (1dd8:1006) in the
>> Distributed Services Card (DSC). This patchset adds the new pds_vfio
>> driver in order to support NVMe VF live migration.
>>
>> This driver will use the pds_core device and auxiliary_bus as the VFIO
>> control path to the DSC. The pds_core device creates auxiliary_bus 
>> devices
>> for each live migratable VF. The devices are named by their feature plus
>> the VF PCI BDF so the auxiliary_bus driver implemented by pds_vfio can 
>> find
>> its related VF PCI driver instance. Once this auxiliary bus connection
>> is configured, the pds_vfio driver can send admin queue commands to the
>> device and receive events from pds_core.
>>
>> An ASCII diagram of a VFIO instance looks something like this and can
>> be used with the VFIO subsystem to provide devices VFIO and live
>> migration support.
>>
>>                                 .------.  .--------------------------.
>>                                 | QEMU |--|  VM     .-------------.  |
>>                                 '......'  |         | nvme driver |  |
>>                                    |      |         .-------------.  |
>>                                    |      |         |  SR-IOV VF  |  |
>>                                    |      |         '-------------'  |
>>                                    |      '---------------||---------'
>>                                 .--------------.          ||
>>                                 |/dev/<vfio_fd>|          ||
>>                                 '--------------'          ||
>> Host Userspace                         |                 ||
>> ===================================================      ||
>> Host Kernel                            |                 ||
>>                                         |                 ||
>>             pds_core.LM.2305 <--+   .--------.            ||
>>                     |           |   |vfio-pci|            ||
>>                     |           |   '--------'            ||
>>                     |           |       |                 ||
>>           .------------.       .-------------.            ||
>>           |  pds_core  |       |   pds_vfio  |            ||
>>           '------------'       '-------------'            ||
>>                 ||                   ||                   ||
>>               09:00.0              09:00.1                ||
>> == PCI ==================================================||=====
>>                 ||                   ||                   ||
>>            .----------.         .----------.              ||
>>      ,-----|    PF    |---------|    VF    |-------------------,
>>      |     '----------'         '----------'  |      nvme      |
>>      |                     DSC                |  data/control  |
>>      |                                        |      path      |
>>      -----------------------------------------------------------
> 
> Hi Brett,
> 
> what is the class code of the pds_core device ?
> 
> I see that pds_vfio class_code is PCI_CLASS_STORAGE_EXPRESS.

The pds_core driver has the following as its only pci_device_id
entry:

PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_CORE_PF)

> 
>>
>>
>> The pds_vfio driver is targeted to reside in drivers/vfio/pci/pds.
>> It makes use of and introduces new files in the common include/linux/pds
>> include directory.
>>
>> Brett Creeley (7):
>>    pds_vfio: Initial support for pds_vfio VFIO driver
>>    pds_vfio: Add support to register as PDS client
>>    pds_vfio: Add VFIO live migration support
>>    vfio: Commonize combine_ranges for use in other VFIO drivers
>>    pds_vfio: Add support for dirty page tracking
>>    pds_vfio: Add support for firmware recovery
>>    pds_vfio: Add documentation files
>>
>>   .../ethernet/pensando/pds_vfio.rst            |  88 +++
>>   drivers/vfio/pci/Kconfig                      |   2 +
>>   drivers/vfio/pci/mlx5/cmd.c                   |  48 +-
>>   drivers/vfio/pci/pds/Kconfig                  |  10 +
>>   drivers/vfio/pci/pds/Makefile                 |  12 +
>>   drivers/vfio/pci/pds/aux_drv.c                | 216 +++++++
>>   drivers/vfio/pci/pds/aux_drv.h                |  30 +
>>   drivers/vfio/pci/pds/cmds.c                   | 486 ++++++++++++++++
>>   drivers/vfio/pci/pds/cmds.h                   |  44 ++
>>   drivers/vfio/pci/pds/dirty.c                  | 541 ++++++++++++++++++
>>   drivers/vfio/pci/pds/dirty.h                  |  49 ++
>>   drivers/vfio/pci/pds/lm.c                     | 484 ++++++++++++++++
>>   drivers/vfio/pci/pds/lm.h                     |  53 ++
>>   drivers/vfio/pci/pds/pci_drv.c                | 134 +++++
>>   drivers/vfio/pci/pds/pci_drv.h                |   9 +
>>   drivers/vfio/pci/pds/vfio_dev.c               | 238 ++++++++
>>   drivers/vfio/pci/pds/vfio_dev.h               |  42 ++
>>   drivers/vfio/vfio_main.c                      |  48 ++
>>   include/linux/pds/pds_core_if.h               |   1 +
>>   include/linux/pds/pds_lm.h                    | 356 ++++++++++++
>>   include/linux/vfio.h                          |   3 +
>>   21 files changed, 2847 insertions(+), 47 deletions(-)
>>   create mode 100644 
>> Documentation/networking/device_drivers/ethernet/pensando/pds_vfio.rst
>>   create mode 100644 drivers/vfio/pci/pds/Kconfig
>>   create mode 100644 drivers/vfio/pci/pds/Makefile
>>   create mode 100644 drivers/vfio/pci/pds/aux_drv.c
>>   create mode 100644 drivers/vfio/pci/pds/aux_drv.h
>>   create mode 100644 drivers/vfio/pci/pds/cmds.c
>>   create mode 100644 drivers/vfio/pci/pds/cmds.h
>>   create mode 100644 drivers/vfio/pci/pds/dirty.c
>>   create mode 100644 drivers/vfio/pci/pds/dirty.h
>>   create mode 100644 drivers/vfio/pci/pds/lm.c
>>   create mode 100644 drivers/vfio/pci/pds/lm.h
>>   create mode 100644 drivers/vfio/pci/pds/pci_drv.c
>>   create mode 100644 drivers/vfio/pci/pds/pci_drv.h
>>   create mode 100644 drivers/vfio/pci/pds/vfio_dev.c
>>   create mode 100644 drivers/vfio/pci/pds/vfio_dev.h
>>   create mode 100644 include/linux/pds/pds_lm.h
>>
>> -- 
>> 2.17.1
>>
