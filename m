Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 493B664A625
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 18:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbiLLRqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 12:46:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232552AbiLLRqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 12:46:35 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2074.outbound.protection.outlook.com [40.107.92.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70EED13F72;
        Mon, 12 Dec 2022 09:46:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h9pe78o33tcb7MGbsJ0w4jskxVepezLaFITBzo17iuRO+aVqUF4KUghe6ekkdBhloPOwhy/mwHPs2jj2HzqbvCDggwaTHLCATJJbZBnidSHhThKdiJE0khSl9rRE6t1zWHZca6h9CxnmbQrB/fpIO+A9PIfyt6/qceVvT59dkYv3+IWJAG3NG6w5dn/Kn4K9VZZMQEdCSiYLXM021fu76hqEGvcM+1UFSO1eCbz02QjT5yCHDEg8KeRKsF+MxctcYT+lb3lyx8btKH/UVMxE/J7V3PW0ScRa9woiFKbcR9T9cgBldmlXViGJM7Qi6IX9/RaNj1YQ9Wm5x8dYiL11aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oY33JL3P+L1jz7I6uypdJ8U+iEIODE2+oXCCa20siTw=;
 b=GXxMfaDC2cG5d2oEg+GrybAw6zeC2CM4pxAPxtb5LO8tIoWjItdDMyiAePHye18jQUPjKZgIxRi5ndo8Sad+EDBWRjyAHkgbU20b3HGLJM1vukGhdJgmRkDSvjBoLllD6P6n8pebDTlZu87u0mL3rOdFOCOinrXfQr7vNLh2DGT8/Jr4T1OfQN00SRUaG9yyYtMBRU+Prag4jfjDkemCpZQBuIC+07T/0n0wN+6XPpV2MqmjxNypwslQCws5hyNGJeap4Mjq3jHMHHUAwzuLhQrgl8gHOCvQPaEL6KuVhAzPUP3WJmSFDiLPJFdYv+b0/KuGpJD5r5v8IRrSmQbzzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oY33JL3P+L1jz7I6uypdJ8U+iEIODE2+oXCCa20siTw=;
 b=UOl1Um0tAJnWKWg5SWpmdf73wQatN9rZxDPuSHkn8qzzIDA7TwmbeItiMhT5mAem5ngkOkZtVbd5SLvPIUwZ+tuWOTO+Xpu0P3YQ8rtpPl3AK90iFct3o8tW45nNIqWlD5ahO6DeuKj6ZaZfU7T5Cv0CURD6wmozwvIM3OIUFYg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MWHPR12MB1390.namprd12.prod.outlook.com (2603:10b6:300:12::13)
 by DS7PR12MB6141.namprd12.prod.outlook.com (2603:10b6:8:9b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 17:46:30 +0000
Received: from MWHPR12MB1390.namprd12.prod.outlook.com
 ([fe80::6fb5:a904:643a:4a5e]) by MWHPR12MB1390.namprd12.prod.outlook.com
 ([fe80::6fb5:a904:643a:4a5e%7]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 17:46:30 +0000
Message-ID: <873fbfbf-13af-e413-cfc0-2dd01ff821be@amd.com>
Date:   Mon, 12 Dec 2022 09:46:29 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC PATCH vfio 0/7] pds vfio driver
Content-Language: en-US
From:   Brett Creeley <bcreeley@amd.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Brett Creeley <brett.creeley@amd.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com
Cc:     shannon.nelson@amd.com, drivers@pensando.io,
        Oren Duer <oren@nvidia.com>
References: <20221207010705.35128-1-brett.creeley@amd.com>
 <1352e2f7-4822-4e49-cf3b-d8a9d537a172@nvidia.com>
 <2f809066-1157-e84e-4d83-f9dcb66135ab@amd.com>
In-Reply-To: <2f809066-1157-e84e-4d83-f9dcb66135ab@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0136.namprd03.prod.outlook.com
 (2603:10b6:303:8c::21) To MWHPR12MB1390.namprd12.prod.outlook.com
 (2603:10b6:300:12::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR12MB1390:EE_|DS7PR12MB6141:EE_
X-MS-Office365-Filtering-Correlation-Id: ae75fcec-9211-4fbe-152d-08dadc68ccf3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n8U1L4oFzUxa/jjMP99JvqCReegYiSKNd36QN8kvxkS8Xl2ewqrAMeWqVmA5Pq6dGBDMnGMLtuB8sBLkg0d1al/o6oOqwMMIRcqha7L0IboUF27JuI2YRBKpn/6ywMOuoIvlcbNZNLqzff55/5kuc1y6unCE5jOPi8Y4U475V9kDj5l5OdXF5KcihO0UF7G3W5y3p6McGbhBl2OIWcm+n+YktOOSNJoSB+R0da51e05rwXGjYU2Q1qPRngklBAiDGCKCbgnixh2KkBX8MLOIScBHc1Gi2KSf5NwQD/lK5gFFE00CJJWxTUzPvnQFpnt0iItqCtnYaeGn/o3+AjJzat+MRjxTP+TMivSunbez5wVZLq5nmLXNmYwNsIY7TA+oSodg/gsNQyZkKGRhMchcxFNdLRl/aT81jXfJY2tBl8xuY7QwNd05MoP8yqe1nqnuN+dX3xiirtXLrIuoquxvclapFWpKc4fPMWvb9HacuOQ2ITZHG0UOAXkOD7e9Phh6HCVJso4qd82ohsDu4Grgoc9sPXidYQOz8jdA4bO4dTIUL43pVnsDDD+jtRePSjd41JlM6sUaPkuJJNXiJjYpMssJdYmpWxASPH5aF7J3Bl0+tq0oKBNPSac+PvF7LFEGDtdf0DHwSXccewiz8ZAK6EEX4wsojeyKkaLUmbXoprWocx8UI2Po7ni7/FoWNxZpJ9CCmbwKcgSt8VDqTTQJuHx8BXhGerXMWDg2VP3nlTVZ/sXy5yyVaQFCNox0pubjL3AnZXrx28NcwrqkZ6MwyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1390.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(39860400002)(366004)(346002)(136003)(451199015)(921005)(2906002)(2616005)(38100700002)(5660300002)(8936002)(110136005)(316002)(83380400001)(41300700001)(26005)(6512007)(36756003)(7416002)(6486002)(478600001)(966005)(31696002)(186003)(6506007)(31686004)(45080400002)(4326008)(66476007)(8676002)(53546011)(66946007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SG40RjBUM2JmWHgrOUtVZWxCNVUreG1vR3p6bjZtaUhwazVxZHpDM1JQQ2pw?=
 =?utf-8?B?THUrZzFPa2RpTmhhUUFoemEyeVJsYlBjZmhGa25qSkFobEIwVitiSkFmSTUw?=
 =?utf-8?B?QXN0cG84cjQzaUIrS0YrMThPblJsODVSRDY0UGdUWHo3QkRMK0k1ald0MXA2?=
 =?utf-8?B?R0swNE9IOWtDNWZUMkFNQU5ETWFyREpEMTVPNVFibVp6dlFFOTlCZngrYWEr?=
 =?utf-8?B?M1NRSUttUkRRRkpsQVhWcS94OGZ1Nmk3cDF0cjJ0ekNENTRveU4xVE9nTWFY?=
 =?utf-8?B?U1gycGQwdFVVS2dlQjNWeUJhczU1dFpVZUhyamVoUy8vekg5NkRUNTFLTUcr?=
 =?utf-8?B?UFlsYUdxRXpwTVowT0JRcmNweFdWZHlGam1Ram9vb3RaVThsVWxmQ3lMZDB2?=
 =?utf-8?B?c2c1cERnc3VRSnhpQjRxUFMya2dXU2FvTTMycEkva1VXd1NZS1FBUENuQjVr?=
 =?utf-8?B?ODJrVnhqYzVYUWlQUTQ5bVE5WFB4eXhRVEJsQ05yUXk2Z1BlMHZYZjljR3R3?=
 =?utf-8?B?UmxzTXl4MnZXcE5JVzZXclpsRHFWRlA2dDVXVGNDZmFnOXpnakxabWZIanFH?=
 =?utf-8?B?SUdlYzY1K2RwNkZZSHpHTUxxUW1LNzVmTGZZdjhaMWhvRS9taUMvZjR1WFA5?=
 =?utf-8?B?citDbS9yZU54R1pCZzBBWldqVHV6NjBoS1FpVHFTRlE1WlRFTklIMlQ1SmhQ?=
 =?utf-8?B?L05SWk1VbVRPMis2WGZIUW5ZcVhEQ2JmNm93NC9tUWRqVmhROEl5N0V1dWkv?=
 =?utf-8?B?cTVaS2VwZlRmeUtPZE0zeVRvck9aQjErQ1dpeXpYTXhOUG9iS3Y2OWk4QU91?=
 =?utf-8?B?RjcrRjdWb25ETm4vd1NaVGd5Z3dxWVFENUt2Qm1RNDFPQkl2MHFHS2tPZWV0?=
 =?utf-8?B?UDFUQXJNQm9aN3BOTWkwZndMbFFXdERyTnZOaFZxaXJ1dHNiM24zdXNydWJu?=
 =?utf-8?B?V2xROFpuZWY1VldJWklHa2VhUlRDZXlaTXNnZFJsRjBWbisyMnpVQis3ZDZV?=
 =?utf-8?B?VUNNcS85dmRMaGRMeDVra2ZYd0NwVFMwbW4rTnQyeHJYUkdkUlZ0cGtqZk5y?=
 =?utf-8?B?cUs4bnY1bm5FL3JoeS84VzBQOC9Ba0Z2TndiL1g2UWZYa3VxdkVmT2dqY0VJ?=
 =?utf-8?B?TWFPc2hIbUtLYVB3L1lsUVVhbDErVFBwdjFBbHFQRXpkL3NnNkgzUVZ5emds?=
 =?utf-8?B?R2NURWVhRHRYZGQ0RWlxRVlEdSs2VUcxMzE3ZDI3Ukg5RHEzY25rS3hIbUwv?=
 =?utf-8?B?dlZSOU1CSThyV1hibFIwNVZYMEhLSnVkaXFkV0Fzd2k0eFZkMGJrdDNWNXVj?=
 =?utf-8?B?RkFkUStwbTlXVWkvT2p5My9UTlp5SGRJcWJvKzVGUXcvaUMvb0crbVdzODVh?=
 =?utf-8?B?czh0alorM1hNYThJWlg0dGNxTHpXMnRsTk51KzJ0TlQxclVIZWU4bndobWkw?=
 =?utf-8?B?eWFpTkZwQ1o2TWRUelVQNEh0RGVCUTc5a0FHYlZNYmxNZW82a0Q2WG5CRTVy?=
 =?utf-8?B?M0MzVjMydGRWS2lTMEFCRjUrQ0JIellaaW5JaUlyNlVmUytsWk1FajZteGV0?=
 =?utf-8?B?RzhoTFZlK01jVGplZzZuSzlsUVIrWTg5N1pMSWc5M2NwREtoVFJNSTNNbWs2?=
 =?utf-8?B?Smh5aURzV1FLakZqZjZ1SllNc05uZGNWMlZ5WmNqQ3FCVVROaTlwdEdQZG9M?=
 =?utf-8?B?eVgxWkdibWoxZFh1dnhpKzZwUDhIZW9iVUxPYm5qTWg0ZVJBYm5VMURocFNC?=
 =?utf-8?B?eG4yRnJrYWJ3QVhSRTNZSXp3blc2K3hhalRRRnNsMnNWZnYwdVdKQmdlN014?=
 =?utf-8?B?cUNiOVp4bGpBcGVEcHlVRk5RQ0dlM2dGSkdVT3JlMkoyR3JyRVg3clh6d3pX?=
 =?utf-8?B?Ni92Mi9rUFRmWklKY0c4QXFoUFFZZjlIUjVjSTJoUFRGUjlsb3Ztc3V4Sit5?=
 =?utf-8?B?MlVyRjkvdmZHZGZiM3NuN285N2tKM2ZiQmVvam1pMDhaeTlNc2dUYWpkUmxS?=
 =?utf-8?B?dUpoQ0RHY01TZ3l4ejVOSjYrQzR1N2xrN05PbEVObXJ0QkZkTEl2OVArVUpO?=
 =?utf-8?B?b2VLN0FBVGJzc2pPSTVCQXRMeDFrdkpiZlcyK2xpMVJMb1dCNEhvelFDb0d0?=
 =?utf-8?Q?p4pH+CysqSFM+2tTYQe7eflCs?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae75fcec-9211-4fbe-152d-08dadc68ccf3
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1390.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 17:46:30.1101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 388lHstHqNpRReItOERUTHfAlov4qyYlYkNsyDtPE9KvsxBRQsBCHaBRafWmGJr8Lth0RUBfGCVu/o7lzAWuwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6141
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/11/2022 5:16 PM, Brett Creeley wrote:
> 
> On 12/11/2022 4:54 AM, Max Gurtovoy wrote:
>> Caution: This message originated from an External Source. Use proper 
>> caution when opening attachments, clicking links, or responding.
>>
>>
>> On 12/7/2022 3:06 AM, Brett Creeley wrote:
>>> This is a first draft patchset for a new vendor specific VFIO driver for
>>> use with the AMD/Pensando Distributed Services Card (DSC). This driver
>>> (pds_vfio) is a client of the newly introduced pds_core driver.
>>>
>>> Reference to the pds_core patchset:
>>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fnetdev%2F20221207004443.33779-1-shannon.nelson%40amd.com%2F&amp;data=05%7C01%7Cbrett.creeley%40amd.com%7C0591fe11a7c24bf8789908dadb76db84%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638063600829691750%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3VMvNtUto4HwCap65NvWrIADbLzGk4Ef9ZnA9fAB458%3D&amp;reserved=0
>>>
>>> AMD/Pensando already supports a NVMe VF device (1dd8:1006) in the
>>> Distributed Services Card (DSC). This patchset adds the new pds_vfio
>>> driver in order to support NVMe VF live migration.
>>>
>>> This driver will use the pds_core device and auxiliary_bus as the VFIO
>>> control path to the DSC. The pds_core device creates auxiliary_bus 
>>> devices
>>> for each live migratable VF. The devices are named by their feature plus
>>> the VF PCI BDF so the auxiliary_bus driver implemented by pds_vfio 
>>> can find
>>> its related VF PCI driver instance. Once this auxiliary bus connection
>>> is configured, the pds_vfio driver can send admin queue commands to the
>>> device and receive events from pds_core.
>>>
>>> An ASCII diagram of a VFIO instance looks something like this and can
>>> be used with the VFIO subsystem to provide devices VFIO and live
>>> migration support.
>>>
>>>                                 .------.  .--------------------------.
>>>                                 | QEMU |--|  VM     .-------------.  |
>>>                                 '......'  |         | nvme driver |  |
>>>                                    |      |         .-------------.  |
>>>                                    |      |         |  SR-IOV VF  |  |
>>>                                    |      |         '-------------'  |
>>>                                    |      '---------------||---------'
>>>                                 .--------------.          ||
>>>                                 |/dev/<vfio_fd>|          ||
>>>                                 '--------------'          ||
>>> Host Userspace                         |                 ||
>>> ===================================================      ||
>>> Host Kernel                            |                 ||
>>>                                         |                 ||
>>>             pds_core.LM.2305 <--+   .--------.            ||
>>>                     |           |   |vfio-pci|            ||
>>>                     |           |   '--------'            ||
>>>                     |           |       |                 ||
>>>           .------------.       .-------------.            ||
>>>           |  pds_core  |       |   pds_vfio  |            ||
>>>           '------------'       '-------------'            ||
>>>                 ||                   ||                   ||
>>>               09:00.0              09:00.1                ||
>>> == PCI ==================================================||=====
>>>                 ||                   ||                   ||
>>>            .----------.         .----------.              ||
>>>      ,-----|    PF    |---------|    VF    |-------------------,
>>>      |     '----------'         '----------'  |      nvme      |
>>>      |                     DSC                |  data/control  |
>>>      |                                        |      path      |
>>>      -----------------------------------------------------------
>>
>> Hi Brett,
>>
>> what is the class code of the pds_core device ?
>>
>> I see that pds_vfio class_code is PCI_CLASS_STORAGE_EXPRESS.
> 
> The pds_core driver has the following as its only pci_device_id
> entry:
> 
> PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_CORE_PF)

The PCI class code for this device is 0x12 (Processing accelerator).

Thanks,

Brett
> 
>>
>>>
>>>
>>> The pds_vfio driver is targeted to reside in drivers/vfio/pci/pds.
>>> It makes use of and introduces new files in the common include/linux/pds
>>> include directory.
>>>
>>> Brett Creeley (7):
>>>    pds_vfio: Initial support for pds_vfio VFIO driver
>>>    pds_vfio: Add support to register as PDS client
>>>    pds_vfio: Add VFIO live migration support
>>>    vfio: Commonize combine_ranges for use in other VFIO drivers
>>>    pds_vfio: Add support for dirty page tracking
>>>    pds_vfio: Add support for firmware recovery
>>>    pds_vfio: Add documentation files
>>>
>>>   .../ethernet/pensando/pds_vfio.rst            |  88 +++
>>>   drivers/vfio/pci/Kconfig                      |   2 +
>>>   drivers/vfio/pci/mlx5/cmd.c                   |  48 +-
>>>   drivers/vfio/pci/pds/Kconfig                  |  10 +
>>>   drivers/vfio/pci/pds/Makefile                 |  12 +
>>>   drivers/vfio/pci/pds/aux_drv.c                | 216 +++++++
>>>   drivers/vfio/pci/pds/aux_drv.h                |  30 +
>>>   drivers/vfio/pci/pds/cmds.c                   | 486 ++++++++++++++++
>>>   drivers/vfio/pci/pds/cmds.h                   |  44 ++
>>>   drivers/vfio/pci/pds/dirty.c                  | 541 ++++++++++++++++++
>>>   drivers/vfio/pci/pds/dirty.h                  |  49 ++
>>>   drivers/vfio/pci/pds/lm.c                     | 484 ++++++++++++++++
>>>   drivers/vfio/pci/pds/lm.h                     |  53 ++
>>>   drivers/vfio/pci/pds/pci_drv.c                | 134 +++++
>>>   drivers/vfio/pci/pds/pci_drv.h                |   9 +
>>>   drivers/vfio/pci/pds/vfio_dev.c               | 238 ++++++++
>>>   drivers/vfio/pci/pds/vfio_dev.h               |  42 ++
>>>   drivers/vfio/vfio_main.c                      |  48 ++
>>>   include/linux/pds/pds_core_if.h               |   1 +
>>>   include/linux/pds/pds_lm.h                    | 356 ++++++++++++
>>>   include/linux/vfio.h                          |   3 +
>>>   21 files changed, 2847 insertions(+), 47 deletions(-)
>>>   create mode 100644 
>>> Documentation/networking/device_drivers/ethernet/pensando/pds_vfio.rst
>>>   create mode 100644 drivers/vfio/pci/pds/Kconfig
>>>   create mode 100644 drivers/vfio/pci/pds/Makefile
>>>   create mode 100644 drivers/vfio/pci/pds/aux_drv.c
>>>   create mode 100644 drivers/vfio/pci/pds/aux_drv.h
>>>   create mode 100644 drivers/vfio/pci/pds/cmds.c
>>>   create mode 100644 drivers/vfio/pci/pds/cmds.h
>>>   create mode 100644 drivers/vfio/pci/pds/dirty.c
>>>   create mode 100644 drivers/vfio/pci/pds/dirty.h
>>>   create mode 100644 drivers/vfio/pci/pds/lm.c
>>>   create mode 100644 drivers/vfio/pci/pds/lm.h
>>>   create mode 100644 drivers/vfio/pci/pds/pci_drv.c
>>>   create mode 100644 drivers/vfio/pci/pds/pci_drv.h
>>>   create mode 100644 drivers/vfio/pci/pds/vfio_dev.c
>>>   create mode 100644 drivers/vfio/pci/pds/vfio_dev.h
>>>   create mode 100644 include/linux/pds/pds_lm.h
>>>
>>> -- 
>>> 2.17.1
>>>
