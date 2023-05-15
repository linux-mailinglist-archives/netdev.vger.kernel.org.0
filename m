Return-Path: <netdev+bounces-2743-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FC0F703CB6
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 20:33:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3636E28146C
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 18:33:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA1DA182C2;
	Mon, 15 May 2023 18:33:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6399846E
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 18:33:20 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2054.outbound.protection.outlook.com [40.107.223.54])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D009D14371
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 11:33:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eaf4ENjWYU6enlLjsSbG+svKQQR/bHZMcfOle8P2BO7cCodE1SDH7yaBeQqSv4iL95rddhQWkwc3VnB3uAN5h3kUjiiB10bQFLUkc4LfTPZEsPemzS8XJ4b8hS9p2hqncm/iqOgE9cysHTDAuMFXtz99/4lDXkZUiqP1oCwC0Ewzgm17RibgNx1ClXx7oHyFnxsj6wD+6FFx2D9V1+Iov+ho0WCeFAY4HPQvUrtN0WQp3dVnKW0Lc9t40+O+2am8zm/KXBw6Nr27rMUhIyxWO6OaLjvq3t8E3xHdDAGKdhQoc2wfMv9IGx4mvTubZZrLiuyWo+JQutK9P4/I45pkUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=71VFcf0BdKYnMntw9FB4+DeJdkwr0QJfHSNOY+B6fgQ=;
 b=Lq6Qw8NI0jol4YRBrnpHR3Zl621NU+1eQqf0khM0z7NPGIz+Er2ZBZkYgKDoL5csSAX+4wJyihJRLXCTzw3m7baDBcBleC0ouHJ72N364tdM4OPXQwgY7hqZfr44BXYy0ppLZOFk9EMEqojNYkecZwz6R04HxthNI54SOj8Ya+PZatrPDBV/XkqkIFYd5P2jEBN7btqL3xd8C6SSFCT+JOgdeCgRgBOj69yww5gx9UnrdMZK/KLtdPh0tzHU/VQPWoLZBleNIoE2mkOq73BZ+hk5jxLn6XA9JZXy3eQpZoisdomjBkOT/4+dMi08mXQpobkOkNyJmpFehH1Jfanbag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=71VFcf0BdKYnMntw9FB4+DeJdkwr0QJfHSNOY+B6fgQ=;
 b=fdDVXkNHLVR8tHbgXO7rQ+d8VZteqio15zW+kRUV+ZYtn3Y8eh/3jNcZD5sRjGNl985B1971Y3lBAUs+ovkWpJ7hDwzqH9QOYAQuMjkpFN5H9tsFuF7RAgcnoPDzeVxj+LxDS0S+pKrBeSauAVTYznglFD/HBy7rfbtSiw/rAEI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 IA0PR12MB7532.namprd12.prod.outlook.com (2603:10b6:208:43e::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.30; Mon, 15 May 2023 18:33:07 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::fc3e:a5b4:7568:82bc]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::fc3e:a5b4:7568:82bc%5]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 18:33:07 +0000
Message-ID: <d6281472-b107-6128-4004-5a7a43f37ee8@amd.com>
Date: Mon, 15 May 2023 11:33:04 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: [PATCH v5 virtio 11/11] pds_vdpa: pds_vdps.rst and Kconfig
Content-Language: en-US
To: Jason Wang <jasowang@redhat.com>
Cc: "mst@redhat.com" <mst@redhat.com>,
 "virtualization@lists.linux-foundation.org"
 <virtualization@lists.linux-foundation.org>,
 "Creeley, Brett" <Brett.Creeley@amd.com>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "simon.horman@corigine.com" <simon.horman@corigine.com>,
 "drivers@pensando.io" <drivers@pensando.io>
References: <20230503181240.14009-1-shannon.nelson@amd.com>
 <20230503181240.14009-12-shannon.nelson@amd.com>
 <CACGkMEvxzRuW2i=3=wv=B7J8UfytxwRoA3SJRexuOgLzJtmZ3Q@mail.gmail.com>
From: Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <CACGkMEvxzRuW2i=3=wv=B7J8UfytxwRoA3SJRexuOgLzJtmZ3Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR04CA0024.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::34) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|IA0PR12MB7532:EE_
X-MS-Office365-Filtering-Correlation-Id: a8edbd05-dcc4-4453-180f-08db5572d414
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	sgQclKTSahH4baqj9dLzpjIC2vKaAzDOF7UPWf/Uqa3hcJT7+ex9Y0I3/1yzmatVthJfbS5zhFQVCmstchYUYaMBLqp0KN6fKXuZleRZ94NciK0Q70xpI6qO2tWde2PPi5W62lfJXTCIh7JLT6oCT/FtB2gf88M9LIaEyu27upp3I6MQcSNK82JmxIbC/RBuJJ/4qundWzpQ3HRLlNRgP+i3C/X5Fj6myob3C64v9tzTiSYYS91yrb6fo6s2K9IAmMZv4LXIEROWOLQX0/t1YwOT2ANRdZ6RKJf/Z95EHwN2rw0moVaUJIcmF6XHRzSo7qFhKXPppMefigpVzk2u4hxiP4P8ll1IzAkAMddO6Omme7Jx/+3KAWfPKHAB3QFr5UHQScTTpJDWbSWROdW4kHdPYF9WLbUC2PeTeFgXqpnsrBQGDiNVVl0tO3cD8m0TSOkmGodaMdF4z/c4+SgZJd1+CRFa0wvOkgg5GDvughLv3PpdnVDTANmAgwcZkM5ZugYEJc8oGcvfejEEPeJjeDrrydhbjyd3ItNWQdX7CPVIPCorPs4CAVEw+TQm1YZpnxxt38phLjhCO7790PdjrD9WB+aqvk3g5lmHgB2ArzZG4Eo5Gve9XEDLkwhgc4JuHJB5zAzxfvMDrGDng6gGAQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(39860400002)(366004)(346002)(136003)(451199021)(86362001)(2906002)(66899021)(31696002)(66946007)(66556008)(66476007)(316002)(4326008)(6916009)(38100700002)(6666004)(36756003)(478600001)(54906003)(83380400001)(53546011)(31686004)(8676002)(26005)(186003)(8936002)(6506007)(44832011)(6512007)(41300700001)(2616005)(6486002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TWNyYjNZN1NUVU8waS85SHN5UlpKaHc3SEZxRk5DRkp5U0VheEFzTlphdVZZ?=
 =?utf-8?B?S0NORGxFWWkxUis3Q0J5Y0QvSkUxVFhRd1NwbmpYWFlmdG15Qjl6dFRscDdG?=
 =?utf-8?B?M1NDWEdEY09HK0hwZjZvb01uZWtSVEZKNENiV0pmMWVsL3Nzby9BdGpPMUhG?=
 =?utf-8?B?dFV1RlR2Q1RTa2M5VWF4eHoxaXJtaGdQb09mbTRPMnZ0NFBUdWhDd0pHUXdz?=
 =?utf-8?B?N1NXbWFsajRpbzNBQ21jOFU0akw2azhQMjBYRUNhd3lmam1FZlk0MjFFMWpC?=
 =?utf-8?B?NUthQjc2R1cxd3lNYms3TFpRTVNYMDU5cExuRkVxVkRibGdhWk15bUtuYzdq?=
 =?utf-8?B?d09CeCs4dS9JVDB5UzBKaEtBSXZKQjZHT0tJcTN0UXRMTlNKSTNjT1RIRmxz?=
 =?utf-8?B?dDhUekpRbEpzYUhsMTNGZktHNTNGTjdDQnYzZUlGdXV6cm0ycHJ5VVpENjBw?=
 =?utf-8?B?SGxZcEJ4MDV5TFhnYWhJMnB1MzBiTEh0Mi9RRXAxM3ozMyt0OHpNZjVaa2VP?=
 =?utf-8?B?L1dLcTJaNDgvSy92K1RmVjFCWlBnODg0NUsrbjBsd3RtWWllY0VSTnZ6TEJs?=
 =?utf-8?B?SlRnMEZ3YTdwZHZXTFZJZXFNV05VNHA4OXJZTUp2UmZXcVFsK3l2UVBFdlJ0?=
 =?utf-8?B?R3A0SG5RTjUvYTFOazU2eHpxTXR5SzBkQ0UwMXVhQzF4MHBlck94OWJOTi95?=
 =?utf-8?B?NjZ1RUNEY3RWenQ4Q3lGQmNlc0tXUGJXS0pvc0VmMGhYa0tiWE5pKzJORG5w?=
 =?utf-8?B?Z0RieGRlZFJZU05UemJoMFFEVGFqcmxIOGtzNHVzUmJzOUtQY0xMZDRHeDl4?=
 =?utf-8?B?bXRzaDZVdGdXOU9XWXU5RGRVdGM3QjBoYi9UN0FkRkFjVVA2OUFBVHZZNDMv?=
 =?utf-8?B?TGZvMGlyVW5HVXNpNHpMU1JxdzVBSkpyNTh6VGxNK1QxdTZtTXZZSmhqckpZ?=
 =?utf-8?B?STVUOUNQZHgwd0tpT2VYTDgyK0VUdnp3eVFuYzZUd1V5M3A1R3F0Q0h3ZGx5?=
 =?utf-8?B?M3p0WnVpdkd0a3huNDQ5UTk2VFZHWWZQUVQrODlnYm1STkRVbHVjY3BYRlZ3?=
 =?utf-8?B?YkJibi9yMURMMjJWU2pjVVhlc09MUW9DSWpJTVRZVkZFMFh0cXROckd6TGg5?=
 =?utf-8?B?ckJZM2dlcUx3Z1hvanZLbXUvZEtROSthek1XY3FXVFdDdXR6c1d3eFkvcFl5?=
 =?utf-8?B?THJxSHJROGdKc1Q4VExXWnRDdHVqVnZlbGdrSFExS240RnhpaTBKTmJIUndV?=
 =?utf-8?B?bVZIOHIza2pBcTVDL01nTnIxc3V2VmEzNHRycktBelRtYUUzQ1g4SzJUZnp3?=
 =?utf-8?B?QlJwV3JQZEZkYjlIbHlTSkFUSW51WXZrd0VqWWpBWlNuY0hkUlppdUx4UlNY?=
 =?utf-8?B?WGtjd3lEemlkeldIckVhWExzcFNvWDJhOW9haGZrYTUveWk4ZFF5WUhtTVJF?=
 =?utf-8?B?T1ZtNWErSXNvT3VGSU5ObUlxVkFVSE9LUERTVjUvUjNTYWVFMWFqWmJ4eFBC?=
 =?utf-8?B?WjhDenJIZjVSbTNmUEtmM1duc1BjNFdTTCtLVGxyb3R5OEQ4aDM5OEQ3Mkdq?=
 =?utf-8?B?WGZwdmxoMmM4VmR5bllqeGxBQTlQaEUvTzNML21iWDhxNTE4d0dCMDBpQm5M?=
 =?utf-8?B?eURmYnBFV29NTEhzUEZPUHhsTTRUbXRHMmVETWxxc0UzZThsNkVUZTNPOGxa?=
 =?utf-8?B?Wm5KdjlDLzBBelp0ZUhFc1hJKzdtbEozTWNqRS9rSlhlYk9CZUdtd0czTzdG?=
 =?utf-8?B?NFJCekdPWVN1bFpHaWxpTThISVRTTnRQVmVVOFhETzVzaVJGK0VGOEo0NUxE?=
 =?utf-8?B?Z240eXQrREhiL1p5Q2JwalUxY1RLVzJsM3l4TkNrMHFoR3pQcUpLUTlNS0RF?=
 =?utf-8?B?RjZMT0FVc1MzQVA5UmFYaDN4ZjVvNktkdHFnTk5OMjZDMzhRYmlGWVlzVStw?=
 =?utf-8?B?aGMxVVRLNUlhTk9lbjVBUVB1U2VqL3dTQThMMTdnYW00aURSaEdmYTQyMmlB?=
 =?utf-8?B?Q3NDaGN6a0NBWU1sMnZaNnRFMlhobGRtekpmczJHWWdVQk5vMThuanJheFFI?=
 =?utf-8?B?N3F3QTBaMVE1amM1VnRMWGQxMHF1bGpma2RCYm1vUU5Bd2wvZWxNalRtbFAy?=
 =?utf-8?Q?0GYsCTkPmHYFCyoe+xaYzOVSZ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8edbd05-dcc4-4453-180f-08db5572d414
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 18:33:07.7332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 00pgwf+tWlm76O/yuzSfNGGHrAbirLPxNR/IuQlH34mc8pjEAYQ8hmoVBz+JvmeIH+Gv3RMz9ni0OvHtOK/6Yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7532
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/14/23 10:07 PM, Jason Wang wrote:
> On Thu, May 4, 2023 at 2:13 AM Shannon Nelson <shannon.nelson@amd.com> wrote:
>>
>> Add the documentation and Kconfig entry for pds_vdpa driver.
>>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> ---
>>   .../device_drivers/ethernet/amd/pds_vdpa.rst  | 85 +++++++++++++++++++
>>   .../device_drivers/ethernet/index.rst         |  1 +
>>   MAINTAINERS                                   |  4 +
>>   drivers/vdpa/Kconfig                          |  8 ++
>>   4 files changed, 98 insertions(+)
>>   create mode 100644 Documentation/networking/device_drivers/ethernet/amd/pds_vdpa.rst
>>
>> diff --git a/Documentation/networking/device_drivers/ethernet/amd/pds_vdpa.rst b/Documentation/networking/device_drivers/ethernet/amd/pds_vdpa.rst
>> new file mode 100644
>> index 000000000000..587927d3de92
>> --- /dev/null
>> +++ b/Documentation/networking/device_drivers/ethernet/amd/pds_vdpa.rst
>> @@ -0,0 +1,85 @@
>> +.. SPDX-License-Identifier: GPL-2.0+
>> +.. note: can be edited and viewed with /usr/bin/formiko-vim
>> +
>> +==========================================================
>> +PCI vDPA driver for the AMD/Pensando(R) DSC adapter family
>> +==========================================================
>> +
>> +AMD/Pensando vDPA VF Device Driver
>> +
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
>> +Function devices.  After the VFs are enabled, we enable the vDPA service
>> +in the ``pds_core`` device to create the auxiliary devices used by pds_vdpa.
>> +
>> +Example steps:
>> +
>> +.. code-block:: bash
>> +
>> +  #!/bin/bash
>> +
>> +  modprobe pds_core
>> +  modprobe vdpa
>> +  modprobe pds_vdpa
>> +
>> +  PF_BDF=`ls /sys/module/pds_core/drivers/pci\:pds_core/*/sriov_numvfs | awk -F / '{print $7}'`
>> +
>> +  # Enable vDPA VF auxiliary device(s) in the PF
>> +  devlink dev param set pci/$PF_BDF name enable_vnet cmode runtime value true
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
>> index 417ca514a4d0..94ecb67c0885 100644
>> --- a/Documentation/networking/device_drivers/ethernet/index.rst
>> +++ b/Documentation/networking/device_drivers/ethernet/index.rst
>> @@ -15,6 +15,7 @@ Contents:
>>      amazon/ena
>>      altera/altera_tse
>>      amd/pds_core
>> +   amd/pds_vdpa
>>      aquantia/atlantic
>>      chelsio/cxgb
>>      cirrus/cs89x0
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index ebd26b3ca90e..c565b71ce56f 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -22200,6 +22200,10 @@ SNET DPU VIRTIO DATA PATH ACCELERATOR
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
>> index cd6ad92f3f05..2ee1b288691d 100644
>> --- a/drivers/vdpa/Kconfig
>> +++ b/drivers/vdpa/Kconfig
>> @@ -116,4 +116,12 @@ config ALIBABA_ENI_VDPA
>>            This driver includes a HW monitor device that
>>            reads health values from the DPU.
>>
>> +config PDS_VDPA
>> +       tristate "vDPA driver for AMD/Pensando DSC devices"
>> +       depends on PDS_CORE
> 
> Need to select VIRTIO_PCI_LIB?

That's a good idea - I'll add that.

sln

> 
> Thanks
> 
>> +       help
>> +         vDPA network driver for AMD/Pensando's PDS Core devices.
>> +         With this driver, the VirtIO dataplane can be
>> +         offloaded to an AMD/Pensando DSC device.
>> +
>>   endif # VDPA
>> --
>> 2.17.1
>>
> 

