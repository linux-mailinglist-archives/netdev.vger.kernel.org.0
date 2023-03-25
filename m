Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C140C6C899C
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 01:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbjCYA1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 20:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbjCYA1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 20:27:33 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2045.outbound.protection.outlook.com [40.107.92.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B2F158A6
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 17:27:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F2rBJccV30mcu/ORMT2QfJY/gsEya/1c6VO+iUrzVS3jvNSTp/1ntDW5YD5iuQXVpLK8BSrmg3fIUuwvEajanri1er1LWOfs32AkM3Tgxat29up9i/r5r8Zygy6q6WuqAG9QTAhnqrLc3XQGYb5rQt7g2gPYOflfg6RHuVpKWXVrIYXQmKV6rcdpqIT++NZEEpVTiq/IjWy76O3nsUwIFd2jidAAgadznLPqOXUEPB0G3MK5HubHMQ4kB2Cxpu89pTzNi7MnhNKUM8WtTL0CsbnK9y2W90piQA5vOS+h4apDWdE9pSweXFkpVc0//6wgQWTVCLCUb4japectCiav5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K6r3Yxp4u7W8UHFlkmDoX03owGw0BjjvIxQEMgJOoXE=;
 b=BtDGRPLEWbTpBwjDnXF3TVIZzxTK/KYf31+pn0rhTiPGksw032ae5nVsQcl0J+VAgKjMvCamij2Jb1ttTsnI8Kkqnl4Wr0Kjjg+DYo5wmf29cSa7HQUZ6QJbohaiLU/Z1MDQay3Pi0wVDnc1v4sHD0fqBOc/ejppPb1WIakLzYCDeqEeMWO3XXNCsXLOi32k3so8XzbL7MqPES527aq13tSxwJAZwKiIQ5LQeY0lfe/f+yN1Rx9lLRuGzt1NRBxpfRanKwHzjce/MGpaqiVwBhSsq1oHgw6MasGWOGKDmjqU4q+s06EOhDGSAXvgRw1DziBrlzGhhXrKUWekJh7sEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K6r3Yxp4u7W8UHFlkmDoX03owGw0BjjvIxQEMgJOoXE=;
 b=vn1Ki60+a6p4dApzuzII+BuEA53ruGYyWnco2hyK6sEorMRElx80cmgi4qOjhf/9WcbLSVYwEGJTWs/1ZH0T5A0HrFOG6CbDj/C2qufHGjL+DGHCDZhrar3u77El0dhyOl1sfF0W9RxXLgBexIdlUjNcBShja7EBd2NBy43LJD0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 PH7PR12MB6881.namprd12.prod.outlook.com (2603:10b6:510:1b7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Sat, 25 Mar
 2023 00:27:09 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab%9]) with mapi id 15.20.6178.038; Sat, 25 Mar 2023
 00:27:09 +0000
Message-ID: <e62be05a-7673-44bd-2658-f9b14144874d@amd.com>
Date:   Fri, 24 Mar 2023 17:27:06 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v3 virtio 8/8] pds_vdpa: pds_vdps.rst and Kconfig
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io
References: <20230322191038.44037-1-shannon.nelson@amd.com>
 <20230322191038.44037-9-shannon.nelson@amd.com>
 <CACGkMEvnZY8x+Wmz48ULBWsT4xEKtdW0Tyx+MOE+OGoca74Owg@mail.gmail.com>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <CACGkMEvnZY8x+Wmz48ULBWsT4xEKtdW0Tyx+MOE+OGoca74Owg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR04CA0031.namprd04.prod.outlook.com
 (2603:10b6:a03:40::44) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|PH7PR12MB6881:EE_
X-MS-Office365-Filtering-Correlation-Id: 433251a9-6a61-485c-d602-08db2cc7abb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1afsoyR0kjvYksF+UnM84Zae713GaS6vj145lUXWX1VtMaKB0SBZu1UcYz8D19X/dChVpgtwMpnacWDc9OkuB+/XQx+ZiYc2JuzbL1Cpqm0JkCFGVtIOjicvhakCLJgO9Txad5DvqtXt8T/ZC9D1uSRXXoSAO00NABU9oeJW+m+7cCGCocok2xiuHgFKEekpFkGwHkyor7IrdSSD+ykJPf00FspmFHGMZO6sj8yeN/WQD4KLyjO4Ha6W0GR7BbKoKkGIxjqdkvda8Sgy3orPBeE6Yk/oZ6zTzeSNmPumwRn9hlM7DKeExXRgB03zqbAwK7w+xrxJ2yGlPzMh7yuG82P7Rb2uCMHHbP1LHeerJbjqG+EVvfkTQmd9I4nKSxxMgmwX/AaEla9mQvYahLgUvH5SCRjCb2GXKJWztxIrkPXgBBfwJf0hY2lMj3okSsqAAJW2iH63CU7PxP1jZEuSHUjKVGNgXpq/etoWS1pTxyuyXP9CW5tUlqjmjf7mnENJGNxjJ4PLj99qCnuR+Io0vIuSHhOANvaAIG7xdKXW2Pa7h91PDBd0AgKodHrwwmB4pm0w4zVJbAZyw1PXNnNApn0NbusQ+ypKx8aPiF44205j5z3gtSlDVjHpp7PCB3m1DBg0NGzq6Tp2MaiReoVkUmevgJQ84GBIx0QtCB+Qnzk7kpFCH7UMttu/FekbdyvD7wK+7Y3jlkGDoXvfTXe3cdJxL7wt0JR3iUCZWjrR710=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(376002)(136003)(366004)(451199021)(66899021)(2616005)(2906002)(38100700002)(31686004)(5660300002)(6666004)(8676002)(4326008)(66476007)(6916009)(316002)(66556008)(41300700001)(66946007)(44832011)(6486002)(6506007)(6512007)(26005)(36756003)(53546011)(8936002)(478600001)(86362001)(31696002)(186003)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RjBkb1NRZmFaVUMxOU5SdlBwMzdXc3hEWkF4Y0xZRFVWakNzZDM2SGp5bmRM?=
 =?utf-8?B?bnRhb2lpdXhzMVozeU95TUVvTWNyVEc3bXpWQWpJLy9aQnFzbzlmMTNhTnJL?=
 =?utf-8?B?SFY0WTZNckFsZVNnTVY2WDhUMm14c3FseUdTMVVIVUVLSlY1ZS9uci9XaEZF?=
 =?utf-8?B?dUhUbDVGWXllT2JvaWd0VS9IM1o4VzhHZnFKK1hNam8vKzJRVjhraUZ6TGtW?=
 =?utf-8?B?SUtJeVBlMXdrbllLMy9vNXQzRVh6ZGxvam5vRWZXYldqY2NqMllMcmdiVmxz?=
 =?utf-8?B?cnVVZzRYR0pMZ1hVN3FaUllWc0kyQWcrU3NIanpNT3FoUEdYTG9adlNDSTBj?=
 =?utf-8?B?bFRCandSaXFNTUZDVk9oVVRkQlY5ZGJnQzFyVEJRbmlua3VObHhVZzBEQVRW?=
 =?utf-8?B?QVNRTGNSYUtGYjdCNjJKUlpleEs4aWVISjRtNlZKTTJTN1FUN0pYQ3hRdnRF?=
 =?utf-8?B?YmE5WGVtUC92Y0dBdSs1RlpiLzVtVit2QzF1QXhhc09WNkJyS05MZ1ZBYkVC?=
 =?utf-8?B?SE9TNno2YTNhYmljZmVwMG1UMTE0OHdjL1YxYkVzbk9tTXNRenIxcGg3VE1F?=
 =?utf-8?B?d01IVjhnY0RJYjlnd09IVWxMU2x0UnAwQklMYXZpcVV4SHE1NVMrRytVdC8y?=
 =?utf-8?B?K1lPYjJzOExTMjYrb3lYUFNqdmNNK3d2Y3dyQ3NkejAxbWExN0lOUE1GenFB?=
 =?utf-8?B?Ylh2UjR2R1BrM2Q4Tjc4cnJaZkdwQm9NM3dFZXd0bTEwb040TVJvUmdsTU44?=
 =?utf-8?B?VkpXT3NMaU43dk4rTnh5NDM0aGM5Zk16RVEzUnNhSkwxdi9BS1JqTzVhMWhZ?=
 =?utf-8?B?TGhOQTJRWGx4SE9WOWdRYXZpc0FTeFpZY2grRmFsU3E0ZG03TFNCSm5ZZFBK?=
 =?utf-8?B?K2ZMTTJPcXEyY3pzMUlOV3huN1pvY1k3ZVNpWm1MYlF5bFlhekozaUFBQ1Ba?=
 =?utf-8?B?VnJKWTIwYThwV3dzMC9MSHJ0Qllpb3hMVzAxZHJMYm5JZnZ2djg5cHVzUWJU?=
 =?utf-8?B?S2VTcE1GeFJVeHBtSXpPalVRaXBQd1NCQWFiVDFkRWlRNytvVzVRUWdTRTVY?=
 =?utf-8?B?dWsrWCtYRlJveitTdmhRVGdKcjRjUDhaUmFIVG9PdnFlMDNUVjNFNEdIS1lS?=
 =?utf-8?B?VVVoeXp3cDF6Z0ZlSFRhTE82K2F5cElCQ21pcUpETHlaaUVwNFNXNUZ1SDJX?=
 =?utf-8?B?dGdFMDdKMW44T3JxZjNNTmxaUE4zWXhDLzJIMEFVT1BoTGhUYXBkdmgvcHJu?=
 =?utf-8?B?M3FHclA2TGJPVU5iSmsxWjFsZEhNMGZLZlhhdnpzZnpCekN3d2cxUnFnODh1?=
 =?utf-8?B?MXp1aXgwalhIcDljbDVFaU1zS1lRWDQzUFZPWjZjbGJRR1djYXJGUHZXMGVE?=
 =?utf-8?B?ZXNoa1lxakpuSGhFQ2tweVNocnZGcDA3cWRPc0h6eWxwaytsSmNtS2E2WlhP?=
 =?utf-8?B?WSt6bldiMkZtQTdRSytpS0MvY05LbHlOUStkTzFiS1R4Sk5JSGh2Y281MzBE?=
 =?utf-8?B?VXpGd1Jlc0ZiOEZBUUVrTVlGbzJmM1N0c3p0aFZjN0xpclJRL3QyazVaRzRJ?=
 =?utf-8?B?NWsyWkdlNWZabkxQTEh3RWtFQWIrRW5DYTVDK3ptODBIVXk5d3l2V3FpeFRW?=
 =?utf-8?B?RGRZOUNMV21DTVgvOFI5NzZjMXQ5SmRJdlBLVFlaT25yd2IxejYwVFgzVW13?=
 =?utf-8?B?amtzS1ZBWTlJOU1wUDFFTUQ5V1FGTHBNTWlWOEFtd3h1ZUMrMzRqQUhTMmZY?=
 =?utf-8?B?VFRvODZNZDdyOER3eWZFSjE1WTd2Y0lhWkxjR2MrTm4xR2tBWFkrZTNOYjNa?=
 =?utf-8?B?MjlqazY0dU5RVUZkekJBV0hpYTRLWjNVTnpjQTJPM3ZvN0lLa1hQcFpod1dZ?=
 =?utf-8?B?Q0RIbWVEZWJ0L1RoZEZOVXRNalhEMEZLNmpxYVVyNFRwWUM3S1A3cC9qdk11?=
 =?utf-8?B?UWNvWFhObVRDTmNjRmo1YVcxVkxweU5taGI4TkZSSGdyQVUvb2xCTHNqWDFK?=
 =?utf-8?B?bG0vODBkVlRYdmNGZUl0aWcxcDJWUUdONzdqRVJaQUFXclRKQm53OXpmT1p2?=
 =?utf-8?B?S1JKenUwREIwRUhUdkhXaG9WY3U5VVdUcGloOU43TmRUU1JXbENiNUJSdFRI?=
 =?utf-8?Q?/At4gaHAxNuSBipw0ajLZo2Vs?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 433251a9-6a61-485c-d602-08db2cc7abb2
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2023 00:27:09.5201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QBP3kjqg0KRzKVWcbtZQZqQjy3qxumH2FUQlMcq74gGVpbkKHlHVFTp5a6kn3XwYf+e65pkiFouSgoZXXtXGGw==
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

On 3/22/23 10:22 PM, Jason Wang wrote:
> On Thu, Mar 23, 2023 at 3:11 AM Shannon Nelson <shannon.nelson@amd.com> wrote:
>>
>> Add the documentation and Kconfig entry for pds_vdpa driver.
>>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> ---
>>   .../device_drivers/ethernet/amd/pds_vdpa.rst  | 84 +++++++++++++++++++
>>   .../device_drivers/ethernet/index.rst         |  1 +
> 
> I wonder if it's better to have a dedicated directory for vDPA.

It probably makes sense, but I wasn't going to be so bold as to start 
messing with the documentation layout.

> 
>>   MAINTAINERS                                   |  4 +
>>   drivers/vdpa/Kconfig                          |  8 ++
>>   4 files changed, 97 insertions(+)
>>   create mode 100644 Documentation/networking/device_drivers/ethernet/amd/pds_vdpa.rst
>>
>> diff --git a/Documentation/networking/device_drivers/ethernet/amd/pds_vdpa.rst b/Documentation/networking/device_drivers/ethernet/amd/pds_vdpa.rst
>> new file mode 100644
>> index 000000000000..d41f6dd66e3e
>> --- /dev/null
>> +++ b/Documentation/networking/device_drivers/ethernet/amd/pds_vdpa.rst
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
> 
> This seems to require debugfs, I wonder if it's better to switch to
> using /sys/bus/pci ?

This was a quick and dirty way to find any PF devices that supported our 
vDPA.  Yes, this should get replaced with a non-debugfs method, I'll 
come up with something nicer.

Thanks,
sln

> 
> Others look good.
> 
> Thanks
> 
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
>> diff --git a/Documentation/networking/device_drivers/ethernet/index.rst b/Documentation/networking/device_drivers/ethernet/index.rst
>> index eaaf284e69e6..88dd38c7eb6d 100644
>> --- a/Documentation/networking/device_drivers/ethernet/index.rst
>> +++ b/Documentation/networking/device_drivers/ethernet/index.rst
>> @@ -14,6 +14,7 @@ Contents:
>>      3com/vortex
>>      amazon/ena
>>      amd/pds_core
>> +   amd/pds_vdpa
>>      altera/altera_tse
>>      aquantia/atlantic
>>      chelsio/cxgb
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 95b5f25a2c06..2af133861068 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -22108,6 +22108,10 @@ SNET DPU VIRTIO DATA PATH ACCELERATOR
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
