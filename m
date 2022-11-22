Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3142634A10
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 23:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235216AbiKVWdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 17:33:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232734AbiKVWdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 17:33:35 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2071.outbound.protection.outlook.com [40.107.220.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868EAA6590
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 14:33:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=liQW8ZY9GBUFiX8yZMQDBK4GClLKEeBAR+l7U5WSLCJdCZyZ3qVZg7pcOR9KUbyUMUjWZLkNJZWgKXnaao0hQx6+SefwcE7lVqaxyPPgmJ2kyFjKo1gIm5TGswuOglY9mRJV2LpdTCadwgwRZs/ZeZX1+SYJVuOu4JsfNXB08ucuABb+DB2oLZYVTV0fB2wuB+avwEM7pNTLKjR0kH6wuRuF+OKYRU8QXpezLzaDEi+kcdNqB89+xt6kvubSkbKRBxc5sU/1tR1NslCCOhP8trBEjfU5ydfzRje7Nh4nMoTrLfjLU8/yKOvsuqF0aWr7krqshpSHxA8ztNboNNZz8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B/kZ92Ql+rLK12rQNW5vNEouJTz5pxhiDU+hfuKLjDI=;
 b=XIasO4kMcIpVmfaw0qqBsx3j8L8zopVWSy87ZOPitSI9QcgbjfGzFI7P5DjVBtsgZGUijQDoq4L8977mwwOAHP4nYwxztbjo51Q0t/W1D2pDr4Rzq2lX9dI8NzalEnuGTvHy5HZBTil4v3bS8SAhAAeway5fRrfGEVGz/a0uNsMI312I2c+S6ieEJyiukVyyQaFdU6UBQaS3HuAIxAa6lGEMY864Jc/Ya5xIVqjPnzwXFl0nCrEtPLyrQces9RfFudEOQJCui2/gb/x6Ughu4bhlV43pngnIVG0yMjEYiwOjGsWOhuT3U7N26QAUVqguCZYRfLyX8/auIPG4a53kvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B/kZ92Ql+rLK12rQNW5vNEouJTz5pxhiDU+hfuKLjDI=;
 b=sfWlnz9n/gqd5j2NHURRiRxIu5Idgfv5KZkdAu5t6IW+iwG5Lw7I9j35Z1We0dCeJ5iPowZl/VfrzR74Z2ytNTjwKXhswU5Cs/mBekZ95FH1JWpnwTZlIskwDjBnSHSIwo9izI5nKQwEDXIFIJ3IDfXbiHY3ueCOiQIHPmHFEuA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 DM4PR12MB7504.namprd12.prod.outlook.com (2603:10b6:8:110::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Tue, 22 Nov 2022 22:33:32 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b%5]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 22:33:32 +0000
Message-ID: <680d0543-ccdc-409e-0c8a-471e425949c1@amd.com>
Date:   Tue, 22 Nov 2022 14:33:27 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
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
X-ClientProxiedBy: BY5PR17CA0072.namprd17.prod.outlook.com
 (2603:10b6:a03:167::49) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|DM4PR12MB7504:EE_
X-MS-Office365-Filtering-Correlation-Id: b05916f8-3afc-4719-935c-08daccd995ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ojqBkDpxxzge+PPakHiTQ47VzTvpKQT5nHa7REfWjQR9MH79j+JMAGW2k4KKOmQJxjwwO/ptGWzVYuRDl+K2rmlxdbuWW7qAA9zC3h4hXDaZjv1lm3bpISaPMStmntYJFrFfyH4LFi5LRMUTPbHy7aWXb3emk6OUVVWjlKD/iva3K1gWVztQxjSPZtNgDyq0GRjvKZV7oq8jbY1kav1eT7u0d/G6/Kb46lVl0zbas2wZSxb9MeL4jqWHs9jxGfNblwCVzUb9k3gLcEpiKGE68POF+pZx5kbDQPOp+kKyarzrdqtGmUzNdoszKG498nWvxUIfDueQfzQAeHIDqS21OQT8O5rvoejG0NVt2sRlPzi6yey0x7XgE/xjSlS9Cp9YDGXqurOc3/LNC6SSAI95vXaIvxitOVvcSfM5DRc3S0IcQsH//aW76LJLF2XoaNTjUhZds+i/FHwQ851V67huBqSGUH+5+NS0WaGEzPWKFBfS5E7CXAHoHkAdJnKMDko83gW5RRebyg5OMwL85/uIqFbdsc4bf9Vlu9CX17i0/9mur1jDzaxii4WeJENDc7YYdH5hkaP0ViScbLgLxDfkOYGoHbHiEIkWiXeYyhAHgnWHYw0bKaw41g582McqXIw6/c2or4v8jvaBsONFV6sCA+667sBgOen4PRXxM8j19msYv/dJbH1/jpeXu6S7rsqeGMp8t7NsUPQSaw0gtsII6mLN5IfTr9DQTf4q7UgtMJ8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(396003)(366004)(346002)(39860400002)(451199015)(66946007)(66476007)(6486002)(4326008)(66556008)(36756003)(478600001)(8676002)(316002)(41300700001)(5660300002)(110136005)(38100700002)(53546011)(26005)(6506007)(186003)(6512007)(2616005)(6666004)(31696002)(83380400001)(2906002)(66899015)(31686004)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2Rjc2hFUUptUk01bURXbW1CYUhhd1VYV0ZydkxmNldzbU5CaG9vaXRHU1Vi?=
 =?utf-8?B?OXdoMGZ0OHVaYXJUNDM5YmhBYUFxZUZXVENUeC91Y09pSi8vQ1U0dEpBN0Nl?=
 =?utf-8?B?RzJMcmo3MlBXc0s1TEcrV1h5WkdYZGplKzkwSmdkOEhyTUVPZ2NNWS8rRzJK?=
 =?utf-8?B?OFlOV1grQWtWMm5jMDd5TERmU25CZ3FVUmVWKzIvNXhEMHZ4Rjd0NnEwOTVn?=
 =?utf-8?B?ZjlZdU9HL1pTcm5JWElCQ3V3VVRTR0cxdzFRdXc0ZFkwTVkzNG5vblJDQkUx?=
 =?utf-8?B?NitHd3VpOTJZV3hMdkJhS1hRVjlkNXBKMlFVRkh2MFFEQks0aC9BM3FTZzJh?=
 =?utf-8?B?MUdJWXo3R2ZpZWhiT0VHNzZBeGNEdTdwd2FpUytCOFZMVDRPSVBkV1ZMa0Mv?=
 =?utf-8?B?SWZEV254STVVQ0h1WlB2c2pkZ2lwWXNjdjlUS0V0NUVvdHNKUWRySGl0Vmpv?=
 =?utf-8?B?amFEclJqdmRVQXowRmJ0L2NqbndtMWY0c051aUREOUFHdURnNGYvcUlEQURx?=
 =?utf-8?B?OFNrdUhMay83aXY2MWhqNFVqaXpudFNBa3RjYnloaUtvRDZUNGtmK0xrWEs5?=
 =?utf-8?B?S1dVZGRCTld0aWlRSHJzMUtIZk1wRlFObWpuaWkwcGlscnYvclRKOCtOQzNC?=
 =?utf-8?B?aTNvVE0vdEFoMmU3cE1adks0c29qT2V1UUFzaitWUEFNSFZuRTRuOExHQlRr?=
 =?utf-8?B?bEZBeCsxdStkWWVKWlZkd09ZR2pNR2dPWmphK3BSRlhYQi81MFN4THB6S3o5?=
 =?utf-8?B?TWRZZnp2Lzd3ZnRLQmhJcFZoYUp6ZXNNd2xaZThQMDlnZks3ZlhKN3doWENm?=
 =?utf-8?B?TFNKZmZxMk83bk1KcVB4NUdMM1dVUkhjQlhSY2VhTUI2V0hkb1didldLdzlp?=
 =?utf-8?B?aFNPNHV3VFVxdEdGeUxEd2R4V0R6d0tiTVJrdWNHNjRnZTgwa0cySEJZNGhM?=
 =?utf-8?B?bC83UGU2UWIvNm4xbzNxbzg1c0ZRcFRrdnIzTThQdUNUaXBRYzNZcGdVY1px?=
 =?utf-8?B?RW9MQzdGMlJ4YzE2N29RaXJWcjVFWWgwRWRBcHBXRzlzVndrTUNaSkxKcEd3?=
 =?utf-8?B?WGZ1c1U0M01iRXNuRDAxUnYremxkQTN5RDFzb2Q2SW11M2pkM0g3ZkJkRkcw?=
 =?utf-8?B?bFJNc1prNGIrZmZMVTN0MEdpdnByWmFQelJaNUlmakNpa0dPWWdadDhDcTBr?=
 =?utf-8?B?eERKTXdJckpBaHhObXpVWHVzcVBqcExBRGp5VlFGN3cwUGFHMEtmNnU2VERT?=
 =?utf-8?B?dVV4cEQzeTBRd3BaVDFheHVwY3lVOUhvYVpoNUdnUy9ocFlZSkVNTXdkTnU5?=
 =?utf-8?B?MTU4ZDJueWtBWXgwclcxaTI3c1kzclJhL1BFdGp3L1Y5ekdQbUUxRHZlbm9j?=
 =?utf-8?B?bG1GbDdsRlZ4ajBZZVoxQkFmN1FDRVpGNDJwYVVZTlVHQ2hoeEM3M2duNGVX?=
 =?utf-8?B?aEVMTWV4N3BYNzFwU0VLV05pT3RKaVVIWHdkYWFKYUMwNnJnRDEvWUVVdkVa?=
 =?utf-8?B?cGxxVm5XczRrb3RnVk91R0pXWUMzNTl6ZHdpUENYZjM5dEYzZEQ2UXJrVmlK?=
 =?utf-8?B?YnNWT2txdnZJV3VRTkFwVVI0R0pPL2tJblBJSVgwWG1IUlAyL0dCTnEwV3VE?=
 =?utf-8?B?bW0xbm5DMGNHZUVlQlBOQ0xxcnAydjRzMEpVZEc5OE1GeGRmeldldG5TQUtp?=
 =?utf-8?B?dlgzOTBVWEVXazdpaFROL1RTTS9lKy9ZYUVrdThDeHgwWjFoRzduaUNiUzZP?=
 =?utf-8?B?TDhXL2srUFFHYnRTMEc0eEdOWjJseStsMmd6M2dWYXl3ZEdaS0RNeEVMUDVu?=
 =?utf-8?B?bzdLdnR3Y3dBelVwZ0k2ZHpCeksrL1NnVUsxYjVMK245RXFueEpOVzFCUDZY?=
 =?utf-8?B?aStuRDlsK3F6R0tLUEsrdXVSY1lHMStqSjFMYS9mN0dLQ3VEd2tsS0czVEEw?=
 =?utf-8?B?ZGtSYTFnUElEWFZxZk54Y0lDZjYrVGgwaEZKU2RQVWVYTmVkekJGM3l3ZG1j?=
 =?utf-8?B?VFhGYjk0MUJOdTZFMXJ3VVlFWjJNeHFQZ25hbmhRSjJIMHJqUlAvZXhxOWtz?=
 =?utf-8?B?RWdKM3BCbUpOOW1QdXA4UndsVkFGUHVLOVVUbGhYcnFxdXJXWDV5SWpsd1ds?=
 =?utf-8?Q?zy2vH908YT8tAqNu6rUrVq/jn?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b05916f8-3afc-4719-935c-08daccd995ce
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 22:33:32.0909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: egL1yBudTyW0feZVo1yJJDAW91fdNCcafIb0oH/BPSdrL4zEyS9U2Nr1O/6uN3tfYSMyyyPXS9hph8GttnpylQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7504
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/22 10:35 PM, Jason Wang wrote:
> 
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
> 
> Thanks
> 

Hi Jason,

Thanks for your comments, I appreciate the time.  I'll be able to 
respond to them more fully next week when I'm back from the holidays.

sln

