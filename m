Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E787419E1D
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 20:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236126AbhI0S0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 14:26:10 -0400
Received: from mail-bn7nam10on2058.outbound.protection.outlook.com ([40.107.92.58]:60385
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229875AbhI0S0J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 14:26:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AI2bV0L1hohYsKZxnQwvSy9C59sU/wy2CiI8hqD5yisqAnskjnBzMmmWi9dkZM5YdaBd1xKFWwzn7MCyptm3wJQqlZZlK6WpvVwqvKy+aaEimlCtsdPD7V0WFJtVAvasXdaJLbSG3pjNrMcYQm4VU7ziutl4yHVxUvRpQuXURcaKSIxOh47oW7Hyy2nKPgSp12JwjiGmfrTFoJXC4SNwNVom15Q9iCYEIn4icDz0IxjghKwVl2RbdVXPd05ObJcXV85oFn82sws3gCsZ5gaFh1GQ5csmSGtA8MncXBmdc9uym8J96/G60KmqPn4DZTHQ93C4hp532fhpE+qYNWzZvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=PHt3hq2nxv0YrXnJSnwOZ1Mlq+SXuKPGkBl9Wd0FpAc=;
 b=CFeNHE7eImb2iWb7vJ6VU8a2S+RkxjsOwwXL2cmzeqj76Ebo6S/6GtsvPsVLK5a50yAifiBG5+fOVDXEkP3OBr7tvIlRyOe/m8cVY8TLXEWUuTyBfjCloeHLHvSykuRYTMYxbR4l4v5p8sBFzqWjn1NuS05nWbIa1vEkHaHKWuZxtZb3gj7MiNcb1NMeGsDO7h5In+S3/KukJ2pgQS5SYYk7HPjq6fK397LD3nUUTEYrd90Zes0fQfzltZ5EZU3j/t2HoqrSBbYVMWyyiB1ci7fcxKzyxl9Fv9NOC0u5Vt2Cp8gp7As2KMZFH1eBbQ2j4jH60+i8V4IBFdO2WL15iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PHt3hq2nxv0YrXnJSnwOZ1Mlq+SXuKPGkBl9Wd0FpAc=;
 b=CQS0zwu+GYAU9JnW9JhOsGqNHOOyWwoeiUNIcl0mcLDmq/W+2EFMOpcZ+vHMdbP4z1fpTEjXwv7aM0d1uIekfsSHqZRSP1Q/gRdyezfrtwnhlYhxGQv9Jt4hX2c2iD5keu1nSLfAzeaYTc/60n3jverRfPLLRxG8ygBvf7VQbbJgpL/IXlAn4w7dSKmIdf7f9vJ7vUehf5uoRmigWdfSoCTv7iDPitzRb8We+rbq4LS6zC/zeKfUKpB1M1Kyx1777StTWVziF/TkQr2JT+2pEVd4FgGy1vzs/3gt1K+P/3hWTnR3zvEFeCQACe2YmjIj40iquNdkGoOMvoO6Nl8xug==
Received: from BN6PR22CA0065.namprd22.prod.outlook.com (2603:10b6:404:ca::27)
 by MN2PR12MB3181.namprd12.prod.outlook.com (2603:10b6:208:ae::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Mon, 27 Sep
 2021 18:24:28 +0000
Received: from BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:ca:cafe::a3) by BN6PR22CA0065.outlook.office365.com
 (2603:10b6:404:ca::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14 via Frontend
 Transport; Mon, 27 Sep 2021 18:24:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT049.mail.protection.outlook.com (10.13.177.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Mon, 27 Sep 2021 18:24:28 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 27 Sep
 2021 18:24:27 +0000
Received: from [172.27.0.62] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 27 Sep
 2021 18:24:22 +0000
Subject: Re: [PATCH mlx5-next 2/7] vfio: Add an API to check migration state
 transition validity
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "Leon Romanovsky" <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Kirti Wankhede" <kwankhede@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        liulongfang <liulongfang@huawei.com>
References: <cover.1632305919.git.leonro@nvidia.com>
 <c87f55d6fec77a22b110d3c9611744e6b28bba46.1632305919.git.leonro@nvidia.com>
 <42729adc4df649f7b3ce5dc95e66e2dc@huawei.com> <YUxiPqShZT4bk0uL@unreal>
 <60989aa8-4231-0cdf-47bb-1e2026bd1f17@nvidia.com>
 <164439bb579d41639edf9a01a538a5ef@huawei.com>
 <078fc846-1f72-adc0-339c-1b638c6c6e33@nvidia.com>
 <85743eabdae04d08bb5eba7b6857496e@huawei.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <fb8adab1-3409-691a-d02c-552155e4b601@nvidia.com>
Date:   Mon, 27 Sep 2021 21:24:19 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <85743eabdae04d08bb5eba7b6857496e@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3fa588d8-2668-4158-d30e-08d981e40af1
X-MS-TrafficTypeDiagnostic: MN2PR12MB3181:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3181B62C58A0884C477CCD67DEA79@MN2PR12MB3181.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HHbBeFpTakS162dBadK0Siz3lOm+SXBJcxBXRLjrTsXYs+Od9cxmjn5XwoAGa8nNJzZiFEAuRbmoxPTyqL7MkmZV2gyKzkyNfAaxarRAVhkxmUsk3IWybyUFE0qq0z/tycA5pc312dKpBoEuwTMSObtM/34S0/uv2wGSu2y4f/ByRXJjYUSF+CauM9LmD3QWuzZ2qDqZWP/T77WXJAR/KejGw1+hFhLo7Jefz9deBqYmbss6EIx4WnvuPgsNSJGMZzvJd39C5d8hZB/s7dRIWYnumqefbieFT6tkMRGOF+7XFLxfUe9j5c9uDn9fQUgWNOvsd72R/NhLM0j7KTKdx6O2EdTS+/dS1o8WoG8KfjADqxntbcjU9SQ/LNoxLL3RjeplUTUKO6wFRYk5Ob1LJ7/RkE2GaRajr9o7KGR6KWqm8NIJEGTmqmVpdUX5J7SDDYKwz4bsPO8k5lCW4BmOz8dg922GKcYQb01AArDZbLaWZn4LeM+HYETzwlrB4JsmL67BkJSgUvsS7Y9Rn43Vr4QuMWokZ8pQi2HirsE9luew0WLn8kFBmxGP8FxMvxcv2bBtKMJ7ZDHxJ+LQO+t3lbl7WQUua6mmVMUH4JqOa4HqNXPFzMftV333/S9PIn76LtQK8Ro3kNYCmE+tNoYILaaq3rtuanK7KtIfjUHJjwxnQujwmE0r+Z2bH6SKWNSXJPytdEcxAgZEHwXJWioLf5Yom0XQAfVpo9ZUBBG/TnQ=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(110136005)(508600001)(8676002)(336012)(54906003)(70586007)(70206006)(2616005)(86362001)(36756003)(6666004)(16576012)(426003)(316002)(36906005)(31696002)(7636003)(356005)(31686004)(5660300002)(8936002)(186003)(53546011)(4326008)(82310400003)(16526019)(26005)(47076005)(7416002)(2906002)(83380400001)(36860700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 18:24:28.3534
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fa588d8-2668-4158-d30e-08d981e40af1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3181
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/26/2021 7:17 PM, Shameerali Kolothum Thodi wrote:
>
>> -----Original Message-----
>> From: Max Gurtovoy [mailto:mgurtovoy@nvidia.com]
>> Sent: 26 September 2021 10:10
>> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
>> Leon Romanovsky <leon@kernel.org>
>> Cc: Doug Ledford <dledford@redhat.com>; Jason Gunthorpe
>> <jgg@nvidia.com>; Yishai Hadas <yishaih@nvidia.com>; Alex Williamson
>> <alex.williamson@redhat.com>; Bjorn Helgaas <bhelgaas@google.com>; David
>> S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Kirti
>> Wankhede <kwankhede@nvidia.com>; kvm@vger.kernel.org;
>> linux-kernel@vger.kernel.org; linux-pci@vger.kernel.org;
>> linux-rdma@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
>> <saeedm@nvidia.com>; liulongfang <liulongfang@huawei.com>
>> Subject: Re: [PATCH mlx5-next 2/7] vfio: Add an API to check migration state
>> transition validity
>>
>>
>> On 9/24/2021 10:44 AM, Shameerali Kolothum Thodi wrote:
>>>> -----Original Message-----
>>>> From: Max Gurtovoy [mailto:mgurtovoy@nvidia.com]
>>>> Sent: 23 September 2021 14:56
>>>> To: Leon Romanovsky <leon@kernel.org>; Shameerali Kolothum Thodi
>>>> <shameerali.kolothum.thodi@huawei.com>
>>>> Cc: Doug Ledford <dledford@redhat.com>; Jason Gunthorpe
>>>> <jgg@nvidia.com>; Yishai Hadas <yishaih@nvidia.com>; Alex Williamson
>>>> <alex.williamson@redhat.com>; Bjorn Helgaas <bhelgaas@google.com>;
>>>> David S. Miller <davem@davemloft.net>; Jakub Kicinski
>>>> <kuba@kernel.org>; Kirti Wankhede <kwankhede@nvidia.com>;
>>>> kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>>>> linux-pci@vger.kernel.org; linux-rdma@vger.kernel.org;
>>>> netdev@vger.kernel.org; Saeed Mahameed <saeedm@nvidia.com>
>>>> Subject: Re: [PATCH mlx5-next 2/7] vfio: Add an API to check
>>>> migration state transition validity
>>>>
>>>>
>>>> On 9/23/2021 2:17 PM, Leon Romanovsky wrote:
>>>>> On Thu, Sep 23, 2021 at 10:33:10AM +0000, Shameerali Kolothum Thodi
>>>> wrote:
>>>>>>> -----Original Message-----
>>>>>>> From: Leon Romanovsky [mailto:leon@kernel.org]
>>>>>>> Sent: 22 September 2021 11:39
>>>>>>> To: Doug Ledford <dledford@redhat.com>; Jason Gunthorpe
>>>> <jgg@nvidia.com>
>>>>>>> Cc: Yishai Hadas <yishaih@nvidia.com>; Alex Williamson
>>>>>>> <alex.williamson@redhat.com>; Bjorn Helgaas <bhelgaas@google.com>;
>>>> David
>>>>>>> S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>;
>>>>>>> Kirti Wankhede <kwankhede@nvidia.com>; kvm@vger.kernel.org;
>>>>>>> linux-kernel@vger.kernel.org; linux-pci@vger.kernel.org;
>>>>>>> linux-rdma@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
>>>>>>> <saeedm@nvidia.com>
>>>>>>> Subject: [PATCH mlx5-next 2/7] vfio: Add an API to check migration
>>>>>>> state transition validity
>>>>>>>
>>>>>>> From: Yishai Hadas <yishaih@nvidia.com>
>>>>>>>
>>>>>>> Add an API in the core layer to check migration state transition
>>>>>>> validity as part of a migration flow.
>>>>>>>
>>>>>>> The valid transitions follow the expected usage as described in
>>>>>>> uapi/vfio.h and triggered by QEMU.
>>>>>>>
>>>>>>> This ensures that all migration implementations follow a
>>>>>>> consistent migration state machine.
>>>>>>>
>>>>>>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>>>>>>> Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
>>>>>>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>>>>>>> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>>>>>>> ---
>>>>>>>     drivers/vfio/vfio.c  | 41
>>>> +++++++++++++++++++++++++++++++++++++++++
>>>>>>>     include/linux/vfio.h |  1 +
>>>>>>>     2 files changed, 42 insertions(+)
>>>>>>>
>>>>>>> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c index
>>>>>>> 3c034fe14ccb..c3ca33e513c8 100644
>>>>>>> --- a/drivers/vfio/vfio.c
>>>>>>> +++ b/drivers/vfio/vfio.c
>>>>>>> @@ -1664,6 +1664,47 @@ static int vfio_device_fops_release(struct
>>>> inode
>>>>>>> *inode, struct file *filep)
>>>>>>>     	return 0;
>>>>>>>     }
>>>>>>>
>>>>>>> +/**
>>>>>>> + * vfio_change_migration_state_allowed - Checks whether a
>>>>>>> +migration
>>>> state
>>>>>>> + *   transition is valid.
>>>>>>> + * @new_state: The new state to move to.
>>>>>>> + * @old_state: The old state.
>>>>>>> + * Return: true if the transition is valid.
>>>>>>> + */
>>>>>>> +bool vfio_change_migration_state_allowed(u32 new_state, u32
>>>> old_state)
>>>>>>> +{
>>>>>>> +	enum { MAX_STATE = VFIO_DEVICE_STATE_RESUMING };
>>>>>>> +	static const u8 vfio_from_state_table[MAX_STATE + 1][MAX_STATE +
>>>> 1] = {
>>>>>>> +		[VFIO_DEVICE_STATE_STOP] = {
>>>>>>> +			[VFIO_DEVICE_STATE_RUNNING] = 1,
>>>>>>> +			[VFIO_DEVICE_STATE_RESUMING] = 1,
>>>>>>> +		},
>>>>>>> +		[VFIO_DEVICE_STATE_RUNNING] = {
>>>>>>> +			[VFIO_DEVICE_STATE_STOP] = 1,
>>>>>>> +			[VFIO_DEVICE_STATE_SAVING] = 1,
>>>>>>> +			[VFIO_DEVICE_STATE_SAVING |
>>>> VFIO_DEVICE_STATE_RUNNING]
>>>>>>> = 1,
>>>>>> Do we need to allow _RESUMING state here or not? As per the "State
>>>> transitions"
>>>>>> section from uapi/linux/vfio.h,
>>>>> It looks like we missed this state transition.
>>>>>
>>>>> Thanks
>>>> I'm not sure this state transition is valid.
>>>>
>>>> Kirti, When we would like to move from RUNNING to RESUMING ?
>>> I guess it depends on what you report as your dev default state.
>>>
>>> For HiSilicon ACC migration driver, we set the default to _RUNNING.
>> Where do you set it and report it ?
> Currently, in _open_device() we set the device_state to _RUNNING.

Why do you do it ?

>
> I think in your case the default of vmig->vfio_dev_state == 0 (_STOP).
>
>>> And when the migration starts, the destination side Qemu, set the
>>> device state to _RESUMING(vfio_load_state()).
>>>
>>>   From the documentation, it looks like the assumption on default state
>>> of the VFIO dev is _RUNNING.
>>>
>>> "
>>> *  001b => Device running, which is the default state "
>>>
>>>> Sameerali, can you please re-test and update if you see this transition ?
>>> Yes. And if I change the default state to _STOP, then the transition
>>> is from _STOP --> _RESUMING.
>>>
>>> But the documentation on State transitions doesn't have _STOP -->
>>> _RESUMING transition as valid.
>>>
>>> Thanks,
>>> Shameer
>>>
>>>>>> " * 4. To start the resuming phase, the device state should be
>>>>>> transitioned
>>>> from
>>>>>>     *    the _RUNNING to the _RESUMING state."
>>>>>>
>>>>>> IIRC, I have seen that transition happening on the destination dev
>>>>>> while
>>>> testing the
>>>>>> HiSilicon ACC dev migration.
>>>>>>
>>>>>> Thanks,
>>>>>> Shameer
>>>>>>
>>>>>>> +		},
>>>>>>> +		[VFIO_DEVICE_STATE_SAVING] = {
>>>>>>> +			[VFIO_DEVICE_STATE_STOP] = 1,
>>>>>>> +			[VFIO_DEVICE_STATE_RUNNING] = 1,
>>>>>>> +		},
>>>>>>> +		[VFIO_DEVICE_STATE_SAVING | VFIO_DEVICE_STATE_RUNNING]
>>>> = {
>>>>>>> +			[VFIO_DEVICE_STATE_RUNNING] = 1,
>>>>>>> +			[VFIO_DEVICE_STATE_SAVING] = 1,
>>>>>>> +		},
>>>>>>> +		[VFIO_DEVICE_STATE_RESUMING] = {
>>>>>>> +			[VFIO_DEVICE_STATE_RUNNING] = 1,
>>>>>>> +			[VFIO_DEVICE_STATE_STOP] = 1,
>>>>>>> +		},
>>>>>>> +	};
>>>>>>> +
>>>>>>> +	if (new_state > MAX_STATE || old_state > MAX_STATE)
>>>>>>> +		return false;
>>>>>>> +
>>>>>>> +	return vfio_from_state_table[old_state][new_state];
>>>>>>> +}
>>>>>>> +EXPORT_SYMBOL_GPL(vfio_change_migration_state_allowed);
>>>>>>> +
>>>>>>>     static long vfio_device_fops_unl_ioctl(struct file *filep,
>>>>>>>     				       unsigned int cmd, unsigned long arg)
>>>>>>>     {
>>>>>>> diff --git a/include/linux/vfio.h b/include/linux/vfio.h index
>>>>>>> b53a9557884a..e65137a708f1 100644
>>>>>>> --- a/include/linux/vfio.h
>>>>>>> +++ b/include/linux/vfio.h
>>>>>>> @@ -83,6 +83,7 @@ extern struct vfio_device
>>>>>>> *vfio_device_get_from_dev(struct device *dev);
>>>>>>>     extern void vfio_device_put(struct vfio_device *device);
>>>>>>>
>>>>>>>     int vfio_assign_device_set(struct vfio_device *device, void
>>>>>>> *set_id);
>>>>>>> +bool vfio_change_migration_state_allowed(u32 new_state, u32
>>>> old_state);
>>>>>>>     /* events for the backend driver notify callback */
>>>>>>>     enum vfio_iommu_notify_type {
>>>>>>> --
>>>>>>> 2.31.1
