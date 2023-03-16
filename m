Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 044CB6BC4B4
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 04:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjCPD1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 23:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjCPD0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 23:26:45 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2071.outbound.protection.outlook.com [40.107.93.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED331F92E
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 20:25:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jqfjD+VVTeCCG4xF/mCy6Rt/0+0McG2I/IuMnrWAibLkgf+khI091hR09X2UIPaWs4s4nm95L4noBKr2JDhmoV1+kIdk1y9I2HjWN2ThBlYKANT94ePCNL3WReP5UJlPqMhvbnFB2tSuDtWyCdeV/jVlzGsf4WuvUkwi/nFAId10j0hLEt8XC0YH7NNN97zcsUFvr9saBkGAsi++Fhsxonp3MxCZKOPGmaJG7zFZMrfA51oTls4cuO0m+dKDk11of8YVH1Yvba/Z+TBiJkGGLlD+SFvFiBAqtPNJxoRSZphdk3sOFeFbx1rr+n6Ro2wpszc9kHuhvkR9B6sBVO9+Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EJ0l50LH4HR8GJkVigk/oCoAjj5dyquQaikmkA5MF1E=;
 b=CfwAnAv4aATzgz8lMlAoBmHfK5aEft6Wl3gFbl4xQalcbTVVl2JeZilBlCJyHV5SHRMZZvO5XNHED1U28dfzVkMXY3rp0WPeJ4nlrurVV62EM/xFFjUrMuhkFj1z3E16c8sr/onA5VU3gzUv43v+vp8Cy+s4ZOJqDUtLLbhkOrycK2FWb+nG5O07eJxSDOwZ9V/gG9aRP2OZvUeuI6NApeV5uNopSReTNvVXhoeVTPe9GfTwDHQDvJoeKbvggozNnud22YeXC0vgURk5jFE0odXPz1YecLdR2VgAxJH4JN6ALS0YBZR5kafGYsgG1R56srbATfRAsfBesw7oFqJlMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EJ0l50LH4HR8GJkVigk/oCoAjj5dyquQaikmkA5MF1E=;
 b=4gzrNcP4Lf15uiDFqNYYAtouAHyVC3wd4j3v/nsh7fuDQLgK7ePBUX3dRSZzFQhtr3wrr68R09h5NM7VI/FSDFnDgs2kxjyNjC9qW05SgLktNGsp2pIFAsvbk842s6fkgA2VR2qSSK/sMBPjl8iGsXaMPvLgUsnRCBGzVr1rgLU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 CY8PR12MB8215.namprd12.prod.outlook.com (2603:10b6:930:77::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.29; Thu, 16 Mar 2023 03:25:33 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab%8]) with mapi id 15.20.6178.024; Thu, 16 Mar 2023
 03:25:33 +0000
Message-ID: <fda7a918-342b-bdf9-7845-2863056290fc@amd.com>
Date:   Wed, 15 Mar 2023 20:25:30 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH RFC v2 virtio 7/7] pds_vdpa: pds_vdps.rst and Kconfig
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io
References: <20230309013046.23523-1-shannon.nelson@amd.com>
 <20230309013046.23523-8-shannon.nelson@amd.com>
 <CACGkMEsuG98ASnuS2zjfro3ZkBhAr5KnhWYWqBkyT9ZzPvLXiw@mail.gmail.com>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <CACGkMEsuG98ASnuS2zjfro3ZkBhAr5KnhWYWqBkyT9ZzPvLXiw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR06CA0054.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::31) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|CY8PR12MB8215:EE_
X-MS-Office365-Filtering-Correlation-Id: 94ff5bfb-9eb8-4797-27f3-08db25ce19d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lhW+ctF7UofL/advr+AhlaBaldIvO/3Y8eO86gyUEsSy+0EHuSbQpRYfdkk2dRj0F7UIMAn3AzTpwDpGCIfMHu+cvGNpqL0CM1x72teOZNNRb3JUCcaSMAc0uOivppIFOak9rIreAsJU98AxC0s60S65Lh4KaUOoyB6rsgEiy00Tjc4gD89ru0TtQBBj85naZmLgSPcXOjLXVOMV7qrTbatarMThUoAA/FV9x6Yhe5D8ZsKco/4L2AcRRCvKuRIx+tBvNekQTiLSG/RMtZR3Zuc1WXFKjdZiJy0/wv/lwkTZUb8PAgnh1qJeitxeHiTaB6oIdI8zra4EBjpr1ZZefgK5ct1IFTdpZ4W0XgtLO100oL9lccy+5DlnzPUzolwydUWMbsbruT+JNL6fPnMGeNIEwHp75qj9otwoOLfeIiFTcvhLymhYuzwMbd/AKJaf98FJTwG2LNDqcVCiKHF7bZ3sfn00TKHw+r0ZbLZtfSMx6vp28H3ZDw+7FsEwXHvH4WVroC6NIz9dEbr83pCxvBvXtT1Vpayy6x1ZR4fv1hqsC/Bt/8s8mxX+Cp9xxvIVVHzhcTaPcptylLqsK+FkLZ6ejb3cVvxagf8/CJfhb1KbHrvRwAAmCcFCmiWzHj8odAHjWUwsQtdzUiCYH5AzA9a1RtAA7ZDUw1CtxWweLGxPe2dzmxuOjMGA50MdMqz2aqbwuyPlTxc/2iXZZpuAWn6QrkgKv0KYnGOdyXApHSs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(396003)(39860400002)(376002)(136003)(451199018)(2616005)(26005)(478600001)(6486002)(53546011)(36756003)(186003)(6512007)(316002)(6506007)(38100700002)(5660300002)(86362001)(41300700001)(31696002)(8936002)(31686004)(44832011)(83380400001)(66899018)(2906002)(66476007)(66946007)(66556008)(4326008)(6916009)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T0FaVmR0TmlUYk1aTEw1dFkrdGJMb0hTdHpSd1IrVHBuaDhsdGZNeVZ1MlVz?=
 =?utf-8?B?K29QK29hVEpRMERpdWh4cnlkYVdtd0F1NC9BT1h0V2dnVHFDNE1ML2tCcTky?=
 =?utf-8?B?TzNVaVo4UEdFUXRCQlZuQlJ0djZPdUptMUY2WUZXd2lqR1EwaHQ1UjhOa3V4?=
 =?utf-8?B?ZHRKdytRVExsNDVxWWNkQ0cyWjdsSWIrZzMvaHllN21HMzlXTGpsUis4aFJ5?=
 =?utf-8?B?UmdURG5DRHZDcVJxdGtWc3V2eHpYNFZYZ0FIQ2RLWnVJanV2eG9kN3FmSTFx?=
 =?utf-8?B?U2N5K2RPcEhuWG9pWFZ4S0JUVjU4WW9Od0dkUWJmYVgzbGVVZ2VMd0JSbENX?=
 =?utf-8?B?aVROS0s0OGlONzNyT2lWV3N5dXJmV3k5c0VqY1pnMVpzQ3hkV3haWVMxT3Z0?=
 =?utf-8?B?Ny94ZGlXd2o4c3RlaFdFOUQ0UVE0ZG52MG12R2JxbVRjRE84d2NuNWRMRDhU?=
 =?utf-8?B?bVFMV0FJUVdXeEppczExVGJyZ2hmT2ppY0RZNWZqMzloYTBjdVdVb3F5QkU5?=
 =?utf-8?B?UURmSmt5NElOK2ZJZy9jU281cWF0VnIrTU04dmF5S0R1QTNDaEFDM2hOZFVG?=
 =?utf-8?B?bmVxLzRodkJFR1I0LzBqMTJDaXBaV1hZZ1RqckVMNVhiZC9RQ0ZDZ2RuaENo?=
 =?utf-8?B?dm10Z3lUa3ZPNHp6Yi9ZQXhPYlRueXh3VTJYcXBseEkvajZFeXhuelNiVjhC?=
 =?utf-8?B?dGFQQlFEWjRQVkZMTUxaL1pPUUJ5N1QxYUtFZ1lJNmNOSCtZWHNSbldXbS95?=
 =?utf-8?B?TSsrL2d1eHJLYllqRWZSUW5QSTYyTUlBQllvRWdMQ1BwZkdOeEFkbklPTER6?=
 =?utf-8?B?MDZjK2tKYjJEZE9hN1BmdkswYlFnYUd3VGMwOWJRYXV1UFZ2NVZ6YkRtNE8z?=
 =?utf-8?B?MVlqcVJXUjBBdnR3OVdFTVE5ajZieUJlUnQ4NkNhQ2VkVnBKVHpkcVhDbTBB?=
 =?utf-8?B?RDVKQ1J3U1lrd05vTUg0N3JERkRTWTJUT0Q4bVdycllFaFgrQTdTcVQ4VTFE?=
 =?utf-8?B?NVJGVXJwMkJ2c0FvdStNYlRQYTUyL3l5VnBKSE1UUVVGbGZwby9qeHJETi9x?=
 =?utf-8?B?YjRGTkc1a2VjTC9WY09PdzZRekJTT2hsRCtRNUZGcTlWRUdINjZqQWhlcWxR?=
 =?utf-8?B?SUZRb1FuV2VxcWEzTjRCclF3OExkSGRkSG03QlZzenRNS0JnSGFaYlJkVWF2?=
 =?utf-8?B?WE5Cdks3Q2JvaVFWL1JqTXZLc2FNa25la250aXZuUThVNGs2Zmk1SkFHOGFv?=
 =?utf-8?B?TGdXZUkxaStzTitzUHVHQWFhVjVJbzlBSnZWUGdqMGo4K2NNOXVlbElrcmVV?=
 =?utf-8?B?WGNHQzgzSytvN09Ga3RuUTBTVW9ycmNtSXVIL1czLzkrQzRLYjNSUERsR0Fh?=
 =?utf-8?B?RVVYLy9tNVFBUXZUWUQ3U0F1SXdNTmViYU1xWTMyMkNGanMzVmxUWjloMURu?=
 =?utf-8?B?Q0FYU3IzZjRId2ppcDZTZWVuTFNYWER2T01NcldoZC9HRFJzaFppSWNzNTNJ?=
 =?utf-8?B?bTFleUpFQ3B5RC9vNHlMcDU3anFjNGVPZ1ZpWUIwTExXbGhGUE01RUJKTEZP?=
 =?utf-8?B?MUs2RVNYL01DL1kxMStxWHd6TjFIY0dxRnB0WUhVK01IbFBzcXptekhkQkVr?=
 =?utf-8?B?ek9lMjltM0F3WU9NWHBnbkdFQWE4V3ErelgxQkw5dFNKT3p4VmVHRVErUXEy?=
 =?utf-8?B?ck1Qdkl3TndmR0xjeFBvUVc0VjJuNy82NWVlOXU2ODkyQnEwR21hL003K1Fv?=
 =?utf-8?B?MDBmaC9iS1VHbTlEV0llQlVEN3lzQk9NaDI2K25aREwyYXhJZWhlUkYvdXJO?=
 =?utf-8?B?cnlEM2QvVVR1Kzd3R1IyazlaUCsyK1FQeVB5bGhnVzYvZnZYRzZEUW9MVGJ0?=
 =?utf-8?B?WEhCd2loQ00xT3FRaVVNT2VxVjJvNWI0Ykpzb3RBVUJhMEpQL2xwUE5nbDVX?=
 =?utf-8?B?M3dEdFZvSWNUajZCZ0lCeVMzM0xDdkxGb21wL1pnMHNNV0JuanB0eDgwaGJm?=
 =?utf-8?B?dmZSM3JmK21kNkZ0Wmh2eGVYMlVNUHRrbk11UVpIZ3pUT1RHR2kxSURLT3lp?=
 =?utf-8?B?QlZvSlBRcEdxREFqbzNmV0VtNnplNUlMNDJCZ004ZU5kT1Z4ZHFqUjBGTnpk?=
 =?utf-8?Q?F+WSF3Vhyx/lNAwjK+d83ILfI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94ff5bfb-9eb8-4797-27f3-08db25ce19d6
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 03:25:33.1418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IwzMjXcsP+ROn4YKn+dPY6t5RVstgVnWAV4olmVeWDpJHIOgNtEnkTzucj+vQMbcSypOBIKt/33TlvOf5VNxdQ==
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
>> Add the documentation and Kconfig entry for pds_vdpa driver.
>>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> ---
>>   .../ethernet/pensando/pds_vdpa.rst            | 84 +++++++++++++++++++
>>   MAINTAINERS                                   |  4 +
>>   drivers/vdpa/Kconfig                          |  8 ++
>>   3 files changed, 96 insertions(+)
>>   create mode 100644 Documentation/networking/device_drivers/ethernet/pensando/pds_vdpa.rst
>>
>> diff --git a/Documentation/networking/device_drivers/ethernet/pensando/pds_vdpa.rst b/Documentation/networking/device_drivers/ethernet/pensando/pds_vdpa.rst
>> new file mode 100644
>> index 000000000000..d41f6dd66e3e
>> --- /dev/null
>> +++ b/Documentation/networking/device_drivers/ethernet/pensando/pds_vdpa.rst
>> @@ -0,0 +1,84 @@
>> +.. SPDX-License-Identifier: GPL-2.0+
>> +.. note: can be edited and viewed with /usr/bin/formiko-vim
>> +
>> +==========================================================
>> +PCI vDPA driver for the AMD/Pensando(R) DSC adapter family
>> +==========================================================
>> +
>> +AMD/Pensando vDPA VF Device Driver
>> +Copyright(c) 2023 Advanced Micro Devices, Inc
>> +
>> +Overview
>> +========
>> +
>> +The ``pds_vdpa`` driver is an auxiliary bus driver that supplies
>> +a vDPA device for use by the virtio network stack.  It is used with
>> +the Pensando Virtual Function devices that offer vDPA and virtio queue
>> +services.  It depends on the ``pds_core`` driver and hardware for the PF
>> +and VF PCI handling as well as for device configuration services.
>> +
>> +Using the device
>> +================
>> +
>> +The ``pds_vdpa`` device is enabled via multiple configuration steps and
>> +depends on the ``pds_core`` driver to create and enable SR-IOV Virtual
>> +Function devices.
>> +
>> +Shown below are the steps to bind the driver to a VF and also to the
>> +associated auxiliary device created by the ``pds_core`` driver.
>> +
>> +.. code-block:: bash
>> +
>> +  #!/bin/bash
>> +
>> +  modprobe pds_core
>> +  modprobe vdpa
>> +  modprobe pds_vdpa
>> +
>> +  PF_BDF=`grep -H "vDPA.*1" /sys/kernel/debug/pds_core/*/viftypes | head -1 | awk -F / '{print $6}'`
>> +
>> +  # Enable vDPA VF auxiliary device(s) in the PF
>> +  devlink dev param set pci/$PF_BDF name enable_vnet value true cmode runtime
>> +
> 
> Does this mean we can't do per VF configuration for vDPA enablement
> (e.g VF0 for vdpa VF1 to other type)?

For now, yes, a PF only supports one VF type at a time.  We've thought 
about possibilities for some heterogeneous configurations, and tried to 
do some planning for future flexibility, but our current needs don't go 
that far.  If and when we get there, we might look at how Guatam's group 
did their VF personalities in their EF100 driver, or some other 
possibilities.

Thanks for looking through these, I appreciate your time and comments.

sln


> 
> Thanks
> 
> 
>> +  # Create a VF for vDPA use
>> +  echo 1 > /sys/bus/pci/drivers/pds_core/$PF_BDF/sriov_numvfs
>> +
>> +  # Find the vDPA services/devices available
>> +  PDS_VDPA_MGMT=`vdpa mgmtdev show | grep vDPA | head -1 | cut -d: -f1`
>> +
>> +  # Create a vDPA device for use in virtio network configurations
>> +  vdpa dev add name vdpa1 mgmtdev $PDS_VDPA_MGMT mac 00:11:22:33:44:55
>> +
>> +  # Set up an ethernet interface on the vdpa device
>> +  modprobe virtio_vdpa
>> +
>> +
>> +
>> +Enabling the driver
>> +===================
>> +
>> +The driver is enabled via the standard kernel configuration system,
>> +using the make command::
>> +
>> +  make oldconfig/menuconfig/etc.
>> +
>> +The driver is located in the menu structure at:
>> +
>> +  -> Device Drivers
>> +    -> Network device support (NETDEVICES [=y])
>> +      -> Ethernet driver support
>> +        -> Pensando devices
>> +          -> Pensando Ethernet PDS_VDPA Support
>> +
>> +Support
>> +=======
>> +
>> +For general Linux networking support, please use the netdev mailing
>> +list, which is monitored by Pensando personnel::
>> +
>> +  netdev@vger.kernel.org
>> +
>> +For more specific support needs, please use the Pensando driver support
>> +email::
>> +
>> +  drivers@pensando.io
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index cb21dcd3a02a..da981c5bc830 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -22120,6 +22120,10 @@ SNET DPU VIRTIO DATA PATH ACCELERATOR
>>   R:     Alvaro Karsz <alvaro.karsz@solid-run.com>
>>   F:     drivers/vdpa/solidrun/
>>
>> +PDS DSC VIRTIO DATA PATH ACCELERATOR
>> +R:     Shannon Nelson <shannon.nelson@amd.com>
>> +F:     drivers/vdpa/pds/
>> +
>>   VIRTIO BALLOON
>>   M:     "Michael S. Tsirkin" <mst@redhat.com>
>>   M:     David Hildenbrand <david@redhat.com>
>> diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
>> index cd6ad92f3f05..c910cb119c1b 100644
>> --- a/drivers/vdpa/Kconfig
>> +++ b/drivers/vdpa/Kconfig
>> @@ -116,4 +116,12 @@ config ALIBABA_ENI_VDPA
>>            This driver includes a HW monitor device that
>>            reads health values from the DPU.
>>
>> +config PDS_VDPA
>> +       tristate "vDPA driver for AMD/Pensando DSC devices"
>> +       depends on PDS_CORE
>> +       help
>> +         VDPA network driver for AMD/Pensando's PDS Core devices.
>> +         With this driver, the VirtIO dataplane can be
>> +         offloaded to an AMD/Pensando DSC device.
>> +
>>   endif # VDPA
>> --
>> 2.17.1
>>
> 
