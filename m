Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8CC63CC69
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 01:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbiK3ANz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 19:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbiK3ANi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 19:13:38 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2081.outbound.protection.outlook.com [40.107.102.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B481716F6
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 16:13:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VOjFnplrIdK3n1ukZWnZoemsk7HqL87c9WQF4O4HDpE1bbNaRXSsuEhFHPGFf7RMFnHHlxrHkV9CecEdgJRvVi1h48L8z3DZs4rF8DtxBNlPDRQm7bhlFTefmRgOhUP21wu3Y1TtCpTQraPhWr/JZKuCWKDbOwFvmhi8X7RJLVrC2w9KrCo1AW3gb94jF3od3v9TBesToG8kfOA4YXoBYA7q54DUPkVZ/S8TjMz6GoUl5p1SjQ012YimSuLzWDmMangGdV21bdmXKQ5aX9/1+tBTV9e3Y9WUeedWmTn8SCQs9Yc8smG+BwUpW9cLx9prhiB/h4fTva2lt+jn7YkRGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1nJ7oOG6SsdK4Z1y9bs5hDjWJ4gerfMmJr4cnlEw81E=;
 b=bPxVBbcoGs58z3X00PTCl6dhOzrH4KQgEgN8H0R1cT6NU3cYxn/aIY7JVaIFF6t/PPPa4sW5XDgjSeP+wIzdWOGNhSr0wyqFK6x3bJngsgh6EYwe6JqgMMKRi2Hzp+aatCe7lywRwoIUvYv2BXmcbN0KN0r3r/XnRz7o5n+r50X1urAyi4RZwrjWfeEuRZGkUrVI37C9kXQHrFPOfOUpP2WVk8ES1WLtswKdlAbCsBGgY12lhAnJPf4YVBYTA9WsOxQsmsvlMU1UmdgvHLDL3NmgjG6KCGf/sYzOgHdB3i2L0ekbPRurtlbzAIEG9YiJqnqKeFC3S9I3/OcC1SX1zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1nJ7oOG6SsdK4Z1y9bs5hDjWJ4gerfMmJr4cnlEw81E=;
 b=Q4BkJHKvGFSqxWo1W9Vr2w/Ju/lfa8aGjwz57bTb2CGDp5K8pd+cD7QinPYBmW1EVAo4lk5WbB28Y1UKWY9rxT84hZxf5j9XdAuhl00/W1/35TPgG5mq8+NsVlkyBRap+EQFx6c07F00ngdua5XyEA6rm12cAct2U0HEH2DB0O8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 SA0PR12MB4416.namprd12.prod.outlook.com (2603:10b6:806:99::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Wed, 30 Nov 2022 00:13:26 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b%6]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 00:13:26 +0000
Message-ID: <b57f1942-8108-6891-6320-4f349f086142@amd.com>
Date:   Tue, 29 Nov 2022 16:13:23 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [RFC PATCH net-next 19/19] pds_vdpa: add Kconfig entry and
 pds_vdpa.rst
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>,
        Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mst@redhat.com, virtualization@lists.linux-foundation.org,
        drivers@pensando.io
References: <20221118225656.48309-1-snelson@pensando.io>
 <20221118225656.48309-20-snelson@pensando.io>
 <CACGkMEsGnmMCPrLv=mRviOung4N0F8pvYaGsuKMCky58S3uq2g@mail.gmail.com>
From:   Shannon Nelson <shnelson@amd.com>
In-Reply-To: <CACGkMEsGnmMCPrLv=mRviOung4N0F8pvYaGsuKMCky58S3uq2g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0142.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::27) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|SA0PR12MB4416:EE_
X-MS-Office365-Filtering-Correlation-Id: 7847cee8-c501-41c3-ea79-08dad267b38a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yaZa/hj9KMIhB8wK3T4uESvsVWOZ+ExptPbsND/v6atl60jKMzNhXmN2NIvOmnxU46xieLk2DOUiPbiK99u2b8LOe0GVLmzUquWdoOJOiWA5uUlwhcUgZdKjMngC6DNawkd7HKXluFj357vNIVkof/WaZKdQaZy0Qkzvd24qvNiG3HnmpM/1VVLXghUAME2HuvxvPicsJE0s0asrB6sYGBVsHWSXj5IHnsAMlToDM+2p00/B9vzQuwnN2/g33zPHzlJv1KWI870VlLZ0EDF8dkUsk6spqiNGGrxLeuJTHguz1BOKkvF5ZdMTho2mIUlRKs5z0RwWLsDqASS50tdme0uyj6EWnZBSkIuh0NhxAEFVWe8bF7fvCOZEXdrO0DJ1M9rFKmoFq3EMSz/hwR4tPupezBBsZ0hXEQBM3ftAbbMIHaVbpxRTjUDQFIzngeObfdjou3RL23lsJJb0i0UynKqwvfhFUglbKGlCEXQNx1umg1pI571UmYb7c1p0nf0T/UmBO1G/R8hn7JykWSlqmF8X96rK37TvVVRE2udc2v6ht2CtZ4Q7QotNSZqT8cqPm7vzp2JvRvHRDvmKerenXRB+812jGYBRh2svadpU/j6cXLCWq3ewCG0CnCRBD26D4Erx4mkGsOl7Ijr20JB2eruNzUvQ5aHIzPAaEc4T9ZISR6uosHZHG7/yskbX09hZGSY/L2gpKedkspa3BobvRyGT7wQ7wSbcbV6WEHZGFh0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(366004)(396003)(136003)(451199015)(66899015)(38100700002)(83380400001)(31686004)(110136005)(6506007)(6486002)(6666004)(26005)(6512007)(36756003)(31696002)(186003)(2616005)(53546011)(8936002)(478600001)(5660300002)(66556008)(316002)(8676002)(66476007)(4326008)(41300700001)(2906002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bW1WWmhVbkU2OE1vekNHOEZsQ3llTTIrd3NKVEROT1Q4VUFKZ2tUTGJVeHRY?=
 =?utf-8?B?U3JsMTdoTW1NWS9IRzhkMWs3MktzaE9ieGxMbGdGcHMxK2FHZEErSGlpSHgy?=
 =?utf-8?B?MlFPd1JmQkxydG95dXhYM01sTk5Cb2JtNnREaHE0d25DQXMwdC81SWxTM0pE?=
 =?utf-8?B?eXZQV3JSbjJ6R3ovYmxKNGNORWp0TGZaK1V1Q2owZmxQS3RsVUs4WUxua3Mw?=
 =?utf-8?B?elJjMW81a28xL1FLOFpxaWlNMFhSbjF3Wml0T283MnN1K05JZjlDV2RmU3BJ?=
 =?utf-8?B?Uzd0RU9POGEyTlRvUUhqbmVra1ZvbFFMVzUwUk1idEtDMkN2K21heHRueGo0?=
 =?utf-8?B?R2dOZFlteDVkbmFuNERNTDZqcS85UkF5bzNLWVQ4UDRBSzh0NVc0UjM4Q0F2?=
 =?utf-8?B?SXVRZ0tjOG9ZM2hsVWNvYnhXYUtLSjlrcXZiVml6MGlCZkhhcDR4T0VqOCtl?=
 =?utf-8?B?TXdkS1ZsV2V3VkxUSzIwR2c3VzhxblJQWUpia3ZNYUZJUGxWYTQxY0Z1d3Js?=
 =?utf-8?B?NmVyMnRxQnFTcEFLMXI0WFE1NE1NRi9XV1l1MW1IeUdub0tuSVVubzlNd2p0?=
 =?utf-8?B?RkVTdU95d0hzeHNuUG13RjREdjdPOUxZcGJFZC9YSHZmSWJrTXJoQldTcExh?=
 =?utf-8?B?ZUgyYUJnekVIc2xxVGhzVXBKem4wOEJac2tnZGhhdG1NMmJEVys0U3U3aU9t?=
 =?utf-8?B?cm9qUmhVWWs4Qld6aVlZQ3VOa0dJNk1NVU40V01HbFo2QUtHT1RBaTU3dHNa?=
 =?utf-8?B?ZEZjdEtQZlJPUnMzalRlLzZhdjJUVHAxRk1aMEJ6cHFCUFZ4ZGozbGkrbHRy?=
 =?utf-8?B?NTBJbTZ1ZU5JdkxBd0x4TDhpREVrcloyZ0FyamlxeFFZd2E3UmdLVTJsNmxh?=
 =?utf-8?B?eFAvR05xVG5hQkUxbFFPOHNaTEQ5bjVzNmxzMEE0cHk5cDVleXZiOFJuNEJu?=
 =?utf-8?B?QXljelJJMnd3Qm5JZjVRTkx3YlFFU0ZCYVZETTY0T1Y4KzF3OUZ5NFRiZUs3?=
 =?utf-8?B?MHFLc1EvY1FUa0xRbzNCQmh6WWxUS0FoMGppdzRqYTlMa0tVY3RNdFZOcWZS?=
 =?utf-8?B?ci9zbkxMMERlOGdjenFuUHhXcWxrSmI5S3BzdjZQQU1lOGN0MjRDbjc3K2tJ?=
 =?utf-8?B?eWJicDJSb01Pc0JRZlI4STBxMzdhRE1ETUJXVGdnZklNVWJ4MlYvem1YNDVX?=
 =?utf-8?B?RkFPNVNvVTdpMjQyVnUzSG9qb0ZHWlVydDVQOUwySVNUcmg2U0YrQ2dVRitN?=
 =?utf-8?B?azdGbE00eU5wYWFnODluRlhFdzBadS9qTGxteXBPYW55M1Bwa3ZxWEFaS1Rs?=
 =?utf-8?B?VmtpMWtvZ0ZUMG1zbXpuektEaVZ5L1YvZWxVWTF6cEFzeEROaHV5dTZSR0dr?=
 =?utf-8?B?dVhMUVFMNWpJNldyeFdRMmJXV2hiUmNsa3VtUW94eUJMNmttZmFkUEJNbmt2?=
 =?utf-8?B?bUxmeXpwdnN2ZWtJK1dDZzBidUMrd3lGQ1NCMW14VTlLcCtab05hbFQxU08z?=
 =?utf-8?B?SGU5L3B4U2NORC94V1praE03QUFlMUhVYStQQmZtaHV0S2xCT2swcjNTb1F5?=
 =?utf-8?B?YlU4YUs4NFRRd2JEenI5TUxjQVJkSXErSjdPemdlSjhGakpIVFU4UkFTd1NH?=
 =?utf-8?B?dEwrRlJ3UlV0UWNHdUs2VFV0Tys3UXpPRGxMZHZReHJTRldOWVBuTDZlRStR?=
 =?utf-8?B?aVA0S0ZLdHJRN3lBd25ETXgvSmVGVUpLY3lVWjBsZWovVTc5cW5YV3RJK0hE?=
 =?utf-8?B?c2N2RFB4N0FOUmVKK1laY2plSjljcUdoN0ZWQ3ZiS1lrWDJ5andlUUg1K2d5?=
 =?utf-8?B?N09vcUpBb0RacEE4WWhiLys2dk55ZW5FbHFyL2FXZ1J5Rld1R1dMNnVOdVI5?=
 =?utf-8?B?YWJocUUwN2lZQ21ZS1lWYys5SitQVmhDaFhqdVhqUUxKNGJxc3NCVW9ETnpW?=
 =?utf-8?B?M2hycGovN09nMzBLVlY3U2E3NTZscmJiQ1lsMWh2SHNNOHF0c2U2QTRYbEJI?=
 =?utf-8?B?VXRjcHl5THZ1SlZ3bzY2LzhaVHA4VFdEaE8vdWZmVElOY3FsVnN3cTRvWGNE?=
 =?utf-8?B?V2U3c0RmZnVzSm4zV1ZaaDVQSFgyR3M4ek4rcTlWWmlEUVExRVI0Y0pEQkJ4?=
 =?utf-8?Q?/zyfsdPRIQEHL53KmxaRhUccA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7847cee8-c501-41c3-ea79-08dad267b38a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 00:13:26.3430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iYsivsHFNYIFIsoGCm+Ov8YoxEh3vA3fmIypfwXl9fMGqtJnPJzRnlxh5z8uw4f6tIsV7Mc6HC5teDJKhcPZBw==
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

On 11/21/22 10:35 PM, Jason Wang wrote:
> On Sat, Nov 19, 2022 at 6:57 AM Shannon Nelson <snelson@pensando.io> wrote:
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> ---
>>   .../ethernet/pensando/pds_vdpa.rst            | 85 +++++++++++++++++++
>>   MAINTAINERS                                   |  1 +
>>   drivers/vdpa/Kconfig                          |  7 ++
>>   3 files changed, 93 insertions(+)
>>   create mode 100644 Documentation/networking/device_drivers/ethernet/pensando/pds_vdpa.rst
>>
>> diff --git a/Documentation/networking/device_drivers/ethernet/pensando/pds_vdpa.rst b/Documentation/networking/device_drivers/ethernet/pensando/pds_vdpa.rst
>> new file mode 100644
>> index 000000000000..c517f337d212
>> --- /dev/null
>> +++ b/Documentation/networking/device_drivers/ethernet/pensando/pds_vdpa.rst
>> @@ -0,0 +1,85 @@
>> +.. SPDX-License-Identifier: GPL-2.0+
>> +.. note: can be edited and viewed with /usr/bin/formiko-vim
>> +
>> +==========================================================
>> +PCI vDPA driver for the Pensando(R) DSC adapter family
>> +==========================================================
>> +
>> +Pensando vDPA VF Device Driver
>> +Copyright(c) 2022 Pensando Systems, Inc
>> +
>> +Overview
>> +========
>> +
>> +The ``pds_vdpa`` driver is a PCI and auxiliary bus driver and supplies
>> +a vDPA device for use by the virtio network stack.  It is used with
>> +the Pensando Virtual Function devices that offer vDPA and virtio queue
>> +services.  It depends on the ``pds_core`` driver and hardware for the PF
>> +and for device configuration services.
>> +
>> +Using the device
>> +================
>> +
>> +The ``pds_vdpa`` device is enabled via multiple configuration steps and
>> +depends on the ``pds_core`` driver to create and enable SR-IOV Virtual
>> +Function devices.
>> +
>> +Shown below are the steps to bind the driver to a VF and also to the
>> +associated auxiliary device created by the ``pds_core`` driver. This
>> +example assumes the pds_core and pds_vdpa modules are already
>> +loaded.
>> +
>> +.. code-block:: bash
>> +
>> +  #!/bin/bash
>> +
>> +  modprobe pds_core
>> +  modprobe pds_vdpa
>> +
>> +  PF_BDF=`grep "vDPA.*1" /sys/kernel/debug/pds_core/*/viftypes | head -1 | awk -F / '{print $6}'`
>> +
>> +  # Enable vDPA VF auxiliary device(s) in the PF
>> +  devlink dev param set pci/$PF_BDF name enable_vnet value true cmode runtime
>> +
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
>> index a4f989fa8192..a4d96e854757 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -16152,6 +16152,7 @@ L:      netdev@vger.kernel.org
>>   S:     Supported
>>   F:     Documentation/networking/device_drivers/ethernet/pensando/
>>   F:     drivers/net/ethernet/pensando/
>> +F:     drivers/vdpa/pds/
>>   F:     include/linux/pds/
>>
>>   PER-CPU MEMORY ALLOCATOR
>> diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
>> index 50f45d037611..1c44df18f3da 100644
>> --- a/drivers/vdpa/Kconfig
>> +++ b/drivers/vdpa/Kconfig
>> @@ -86,4 +86,11 @@ config ALIBABA_ENI_VDPA
>>            VDPA driver for Alibaba ENI (Elastic Network Interface) which is built upon
>>            virtio 0.9.5 specification.
>>
>> +config PDS_VDPA
>> +       tristate "vDPA driver for Pensando DSC devices"
>> +       select VHOST_RING
> 
> Any reason it needs to select on vringh?

Copied from an example... maybe not needed.

sln

> 
> Thanks
> 
>> +       depends on PDS_CORE
>> +       help
>> +         VDPA network driver for Pensando's PDS Core devices.
>> +
>>   endif # VDPA
>> --
>> 2.17.1
>>
