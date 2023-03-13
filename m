Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD636B6F75
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 07:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjCMG01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 02:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbjCMG00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 02:26:26 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061.outbound.protection.outlook.com [40.107.93.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278F537F2A;
        Sun, 12 Mar 2023 23:26:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mOoa3bPZvaqx5BN91Tc5gZvGyODSpEamqlEKhu2uWkU7oN2BZLtSEJWaOyspzr02AuT8R19wPNLT6DIh3yCO9cIgAZH8aUkvuGNs5AvfCpxeoPIO3ErmGG4OcB2xOdMuNjl+q9cB0H/biTSxLExppei4cYNvZxfmVz+lS4xslPjry5LkuvHthNbJdZLIvcXPT4GHFg5rx5C7eOLfFSZNYKpJXQ6r/TH5ty+TOjvLrQgcRQe6M5f2gY1T9AofUZFBeaoto3d9Vw3/Z9fUyDEJkNEGWHMBUS4/ophvJr9mioyY5bXgA3yM2WRpkzItWsoeBnIBTJtRYlNumGDyXwA0WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mUKN22MrAQ34YBYRGPic2w4gP+Kc3w02j2TLe7pKyFs=;
 b=lcX87OW+/wHVbvYKGvTFunpqonDhaoZX3AgWiCNpiW+UPWhaT3DT84B+YLDoT/Nv1CJZ0AAhbqidBniMbBcobDj4+CLoZgIjgxwmy6YE0k77E6T0Qb3dKKHoZi9k/+65NoUgp5STVji4evQrrsOc8BKJmmng7gNucJJ+G8oSG7OeujXWENPouNYsnaZHhoH6vDbsquBT9T/Nt8stJhsG9vJMkT3Ea/BXTN4sbLvVWfu7knhVtO+ivcM7Zz52adxHTeLB5c4Yqqr0ztQA13X0zGhuGfU2lIHOXc54X3k3+i1PUGmwypPxpTZAc0pVlhPpeqwJp0LjFAc+jf8NXM2Epw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mUKN22MrAQ34YBYRGPic2w4gP+Kc3w02j2TLe7pKyFs=;
 b=2hViz5X+DriJCpGa/eF5U3tyk9EuVYV8/rPkm7IRYlM6Dq/pPhybtjBWcsiq0b0E+EcTFic0fU2Mvyd3rBFiez+Ff+FcsSenP6q/G0M+650nM8HYVl/JLc7aD1mNFY/X1SZg/TRh8D/pmMGQw7kEoDZ+fgMPEN+2NfdkGwwZVIA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20)
 by PH7PR12MB5902.namprd12.prod.outlook.com (2603:10b6:510:1d6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 06:26:19 +0000
Received: from BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::7222:fe4b:effd:b732]) by BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::7222:fe4b:effd:b732%5]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 06:26:19 +0000
Message-ID: <09557c14-d1d6-2af6-b280-65991bcaffc7@amd.com>
Date:   Mon, 13 Mar 2023 11:56:05 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v2 00/14] sfc: add vDPA support for EF100 devices
To:     Jason Wang <jasowang@redhat.com>,
        Gautam Dawar <gautam.dawar@amd.com>
Cc:     linux-net-drivers@amd.com, Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
References: <20230307113621.64153-1-gautam.dawar@amd.com>
 <CACGkMEtDqQJDQ5wRbU0xObi1hiTbaQ3K2Tfq36ZYXCW8BcphYA@mail.gmail.com>
Content-Language: en-US
From:   Gautam Dawar <gdawar@amd.com>
In-Reply-To: <CACGkMEtDqQJDQ5wRbU0xObi1hiTbaQ3K2Tfq36ZYXCW8BcphYA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0093.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9b::21) To BL1PR12MB5825.namprd12.prod.outlook.com
 (2603:10b6:208:394::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5825:EE_|PH7PR12MB5902:EE_
X-MS-Office365-Filtering-Correlation-Id: 01dc4efc-7451-4bbb-472e-08db238bdaf3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZO8XPTCrIF8VQlwmXZdSG9FQlTQNgv2hn3DainosEFHUH+LEfY66B8tt8gNs3wPFSn/mdIc9rnbWakxcJ2389yBxOZXmYuDhysIx9D9dzGTwudxxUd7jORr41hIjMtV2SdfSRDZ1fGCsq/2fpo6Fpdd6D1w158q6UA4T550cYqv0ilLvz5e5dn7PRSDjhYku6uln7Ie2M5KsewK8X6prgCNYQtFCPHaCGHXS4Ixqs+XjtA6JyRKZ8d2Ng9jg22CYslD0Oxkt5JrNbHx92iCSadtVuwcyEo9DziM4zLRmALMD05l6L4ZMyhnLPMeP36UAfxIqN4ppV/b9rrzNu1GcH3Y0A1lnBz3+H6gtR60slBSRiDhpS9CYDpAWoisbmib/KBIg4tWeT2VoFvvwyTNPZfXb/2NeMD/dzi+R3siESasSjgcKNBaMFkdwCX9H4ZsJcG3BBynhb0kODMiT6aCNnYd4TmG0IIMrwm/39/pLni5VBysv0UO7NTYR/pQYcOBbOrF14a9QyV/y76JR0SoMBs93zBsulN4V1zYvX1lW+dFL9yFXcGAudEPq/rKxJHd/m18+0WFndSND0/wgWfRtxWJ4vO0fVGTgGFnJJjz8EHtLVEObIRj7r6iIgpZyTMsIWtbc0IroPbrUxC4/C0GiU69P89hf/cbEf7NB8lh4B5lDrHXTkjgZx3X25scXuEGTFNEyggt1TXyxDG2G3c2x1oUJf9xee6QBIvmhXUwz460=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5825.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(451199018)(31686004)(36756003)(7416002)(5660300002)(2616005)(8936002)(41300700001)(186003)(6512007)(53546011)(6506007)(26005)(4326008)(31696002)(83380400001)(2906002)(6666004)(66476007)(66556008)(66946007)(8676002)(6486002)(316002)(6636002)(54906003)(478600001)(110136005)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RUQrUnlBVXoxYjJaK2libkNOdmJQMEZ3dHJ2bzRUbm5NU3lCVjBocjMrWC91?=
 =?utf-8?B?SE9pR24vZUpoSlQzbkw2UkduU25DamRPVFpuVTVzYU9RbGJqOXhBaUxNVy9r?=
 =?utf-8?B?MmVKVWlmVk1NNVJMVlBEY04wNjBqdHJXZ0JOS1pXWDZTR2l1MCtudkpVa1RT?=
 =?utf-8?B?MXlaMmdOTGVVVVQxOFRkUDJZVE9rSVFVbFZRRS9TelNYZnhieWV2UnJCVGVS?=
 =?utf-8?B?UWdZdG92Y2xXRDJnLzdlUkNMMlNmQno3dGFJK3pPa05tc2hyT2gxWVBycHJG?=
 =?utf-8?B?WVpabjFCWGNGLzZsRFFvNXR2ayt6UmFsTEJrbWZTVHNEckpkQWcvNXNEQms5?=
 =?utf-8?B?NTNwdFg2TjNSbldmVk5NVWVHMmN4eEdmZStQUEhreXhFMStyb1dkSHA3bkNS?=
 =?utf-8?B?enBUYmNTeTRDUWNySDc5MHIxYURwWEtWVUxHN0w1VzArSlF1Y1JxRjFGVy8z?=
 =?utf-8?B?d3l0Q3J0U1dZa0wwekUxL2JJakNObFB5Yzh0ZUM2ZzJpMWoydWNRcHhhbjdU?=
 =?utf-8?B?YzJPbTFoTjc2bTY0K2g1K0wyOHRKM2k1dDFsTGlVMFBwekExdDBNNFJabWJl?=
 =?utf-8?B?ZTl3ZWk3UmxzcUk5RHFhRU03UWNHSjhjcjZBd3ZCUFlTT1Rab2g5TnRDRmN3?=
 =?utf-8?B?SVBLMDFEcnRzUERIUzJYNytLSituSEVMcnZUOE5nSXQxcndvQ3h0dVZHZ1RK?=
 =?utf-8?B?RVEvVlNwVnNyQVBzVmIrQTFudTlWWGZlNzVsbnZPV1RoY2RIekJLdjB0MWN1?=
 =?utf-8?B?K1Q3emdlUmVXYmtiZmhTaERoK1VQVGx4TlowUjJ6eUVqNVVmc05Sc1FoR0ZE?=
 =?utf-8?B?aVZYV0s1bjhTWHBYWjZOYnZMMXZ4WWFNK1M2cGZsaVJ4eW84VUNHa1VHRlVv?=
 =?utf-8?B?S1hWMmlEc3AzZENvNDRBSFRqM3NqZk9HWEt0b0Rqa3k4ditsYittaGxkSExD?=
 =?utf-8?B?WmhPeHRVQTRJVHJmQklqUHFUdmpJV1lpRVVreGNIRjZkWkJHbDlBZ1ZmTi81?=
 =?utf-8?B?OTl5d0t0blpSM3dMNEY3bUlUZTRzNHd0TzFiNmRSa2ErVzA3N3FnRGgrcFhr?=
 =?utf-8?B?UWRya21NaEhudktrWmVMMHFaNU9oL1NRZ0VmamNqbnUvdG5BMjF2V0xXcnBJ?=
 =?utf-8?B?TUF1NVQ1K0JPRDF4NURkMnlXOSszWTRDeVlRYUU5ZU9QVlVHZUllZ1hkYzh2?=
 =?utf-8?B?VW5WTkIvcFprbDllakFYaU5Sc1RVZkViZFpRcDNNbVVKRkFBSUNFUWdCL0Vl?=
 =?utf-8?B?ck5iL28xTzlqZ2lzdGhIdit6V3M2VUFyeGYxOTZzeGVtdlN5anRSWC91VnVy?=
 =?utf-8?B?WDBCNnR1YmRERUxmZjkyWmtHbzJoRXpCZC9UemY2R0s2MS9jcG1hcFRDUks4?=
 =?utf-8?B?TmFjeDFxZytUOENHS0Z5L2ppTHNxcFptR2JhbVBqSHFwSDF0SG9kdXduUTJV?=
 =?utf-8?B?M3YzVjZ4bjVEd0JxVkl4ZVNHWjVaL0hVNFFrc1YwbDVFbXdjNXptV3ZCZFhX?=
 =?utf-8?B?U1dhSWl0WUJnRmwyWnFyR0twUUtkVFAxc1RNd1RJQ3lIVTB1YXpDMTU0K3Ix?=
 =?utf-8?B?MXdEWXg5NkdLWm9uM05CVW1Kejc4OEVBMXZWMGhadDB2Z1E5dzZNSHVNem9Y?=
 =?utf-8?B?REp3bndnOFBiQThlVnRtWlpZLzFiekswelkvdElCQzAxZXUwaHRCbnFrOGJX?=
 =?utf-8?B?cFJubkNMNG9URW9PZEFnOTBCTHFFOFVQQVpQRHI3bWYzQ1VpVlhjbTdsNFZ4?=
 =?utf-8?B?T3RvM3lhaSt4SkVHRG1Sa3gzZGlXSHVmYU1NUWNyYTNFeSt2RTA2Kzh3VHpu?=
 =?utf-8?B?NG5pbUJMbkZBYmZZSUFUd2huNUptWFN3aTM1NlZJRm9CN0t6dVdoTGFrcnVr?=
 =?utf-8?B?VC85N2tZRzBqRk9tdTBYbVEzRmJtMHd4bmVFUksydk9ScmJxR3ZHMWlqTXM2?=
 =?utf-8?B?d3VkaTFObS9EZDJyelZaLzdtZlN2OTh1bVBIMFhyTWFJMStsN1VWWEd1RHZT?=
 =?utf-8?B?QVRGekxqM1Q2eDZ5ZlN1bTN5ZjZwSW1takxSaUF5TG5HZ1o2ZFFGMGc3TUNw?=
 =?utf-8?B?VFpEMEVHN0tac21MaFJwZVdza0JZQlYvZmU1MnN2SFhwTFRDdkhtWVJ0b1VL?=
 =?utf-8?Q?w/VeEXrMPBik8CcvnoMdLuYr3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01dc4efc-7451-4bbb-472e-08db238bdaf3
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5825.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 06:26:18.8715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w3O1BwfZJVIEzw3f7k6nG5Kt6Wt4MfZ6d7Hq1dDQhIUheZANoc+aGkQxsFaaAt8p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5902
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/10/23 10:39, Jason Wang wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>
>
> On Tue, Mar 7, 2023 at 7:36 PM Gautam Dawar <gautam.dawar@amd.com> wrote:
>> Hi All,
>>
>> This series adds the vdpa support for EF100 devices.
> Would you mind posting some performance numbers for this device?

Sure, will do with the next version of this patch series.

Thanks

> Thanks
>
>> For now, only a network class of vdpa device is supported and
>> they can be created only on a VF. Each EF100 VF can have one
>> of the three function personalities (EF100, vDPA & None) at
>> any time with EF100 being the default. A VF's function personality
>> is changed to vDPA while creating the vdpa device using vdpa tool.
>>
>> A vDPA management device is created per VF to allow selection of
>> the desired VF for vDPA device creation. The MAC address for the
>> target net device must be set either by specifying at the vdpa
>> device creation time via the `mac` parameter of the `vdpa dev add`
>> command or should be specified as the hardware address of the virtual
>> function using `devlink port function set hw_addr` command before
>> creating the vdpa device with the former taking precedence.
>>
>> Changes since v1:
>>
>> - To ensure isolation between DMA initiated by userspace (guest OS)
>>    and the host MCDI buffer, ummap VF's MCDI DMA buffer and use PF's
>>    IOMMU domain instead for executing vDPA VF's MCDI commands.
>> - As a result of above change, it is no more necessary to check for
>>    MCDI buffer's IOVA range overlap with the guest buffers. Accordingly,
>>    the DMA config operations and the rbtree/list implementation to store
>>    IOVA mappings have been dropped.
>> - Support vDPA only if running Firmware supports CLIENT_CMD_VF_PROXY
>>    capability.
>> - Added .suspend config operation and updated get_vq_state/set_vq_state
>>    to support Live Migration. Also, features VIRTIO_F_ORDER_PLATFORM and
>>    VIRTIO_F_IN_ORDER have been masked off in get_device_features() to
>>    allow Live Migration as QEMU SVQ doesn't support them yet.
>> - Removed the minimum version (v6.1.0) requirement of QEMU as
>>    VIRTIO_F_IN_ORDER is not exposed
>> - Fetch the vdpa device MAC address from the underlying VF hw_addr (if
>>    set via `devlink port function set hw_addr` command)
>> - Removed the mandatory requirement of specifying mac address while
>>    creating vdpa device
>> - Moved create_vring_ctx() and get_doorbell_offset() in dev_add()
>> - Moved IRQ allocation at the time of vring creation
>> - Merged vring_created member of struct ef100_vdpa_vring_info as one
>>    of the flags in vring_state
>> - Simplified .set_status() implementation
>> - Removed un-necessary vdpa_state checks against
>>    EF100_VDPA_STATE_INITIALIZED
>> - Removed userspace triggerable warning in kick_vq()
>> - Updated year 2023 in copyright banner of new files
>>
>> Gautam Dawar (14):
>>    sfc: add function personality support for EF100 devices
>>    sfc: implement MCDI interface for vDPA operations
>>    sfc: update MCDI headers for CLIENT_CMD_VF_PROXY capability bit
>>    sfc: evaluate vdpa support based on FW capability CLIENT_CMD_VF_PROXY
>>    sfc: implement init and fini functions for vDPA personality
>>    sfc: implement vDPA management device operations
>>    sfc: implement vdpa device config operations
>>    sfc: implement vdpa vring config operations
>>    sfc: implement device status related vdpa config operations
>>    sfc: implement filters for receiving traffic
>>    sfc: use PF's IOMMU domain for running VF's MCDI commands
>>    sfc: unmap VF's MCDI buffer when switching to vDPA mode
>>    sfc: update vdpa device MAC address
>>    sfc: register the vDPA device
>>
>>   drivers/net/ethernet/sfc/Kconfig          |    8 +
>>   drivers/net/ethernet/sfc/Makefile         |    1 +
>>   drivers/net/ethernet/sfc/ef10.c           |    2 +-
>>   drivers/net/ethernet/sfc/ef100.c          |    7 +-
>>   drivers/net/ethernet/sfc/ef100_netdev.c   |   26 +-
>>   drivers/net/ethernet/sfc/ef100_nic.c      |  183 +-
>>   drivers/net/ethernet/sfc/ef100_nic.h      |   26 +-
>>   drivers/net/ethernet/sfc/ef100_vdpa.c     |  543 +++
>>   drivers/net/ethernet/sfc/ef100_vdpa.h     |  224 ++
>>   drivers/net/ethernet/sfc/ef100_vdpa_ops.c |  793 ++++
>>   drivers/net/ethernet/sfc/mcdi.c           |  108 +-
>>   drivers/net/ethernet/sfc/mcdi.h           |    9 +-
>>   drivers/net/ethernet/sfc/mcdi_filters.c   |   51 +-
>>   drivers/net/ethernet/sfc/mcdi_functions.c |    9 +-
>>   drivers/net/ethernet/sfc/mcdi_functions.h |    3 +-
>>   drivers/net/ethernet/sfc/mcdi_pcol.h      | 4390 ++++++++++++++++++++-
>>   drivers/net/ethernet/sfc/mcdi_vdpa.c      |  259 ++
>>   drivers/net/ethernet/sfc/mcdi_vdpa.h      |   83 +
>>   drivers/net/ethernet/sfc/net_driver.h     |   21 +
>>   drivers/net/ethernet/sfc/ptp.c            |    4 +-
>>   20 files changed, 6574 insertions(+), 176 deletions(-)
>>   create mode 100644 drivers/net/ethernet/sfc/ef100_vdpa.c
>>   create mode 100644 drivers/net/ethernet/sfc/ef100_vdpa.h
>>   create mode 100644 drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>>   create mode 100644 drivers/net/ethernet/sfc/mcdi_vdpa.c
>>   create mode 100644 drivers/net/ethernet/sfc/mcdi_vdpa.h
>>
>> --
>> 2.30.1
>>
