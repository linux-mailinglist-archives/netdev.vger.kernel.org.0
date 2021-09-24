Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070C0416F1D
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 11:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245276AbhIXJjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 05:39:21 -0400
Received: from mail-co1nam11on2081.outbound.protection.outlook.com ([40.107.220.81]:37217
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245269AbhIXJjU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 05:39:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iW+WVgyiPnyYeKIIx1CBko/QdqeCA84ppDUrsHq4kbe1xgEu88x8r+AKGSDkbl+5z5oOls7uX68AEqN0oS+PkS+KOO2/lLUeUAdmhq/dv9PHp+gHJGNF5hJNCjE40l4j6zuKbniFqMgkTK0xoHavyEMPRDWu33VRVQAz8SixCERikf7QA3X6zkYZP0aU0KXFHO4AxUcZBHsxVaoS0ioNRWsP3G1SZRlklk/aRNiT22QjUUHDW3DOqbA7/HxLNcNe9uvKIeCAifyiSwiUYlgu+qlU7IqwBIMbYYjUwQU5T6DgJWmdmKlI/hkD7d5Vf15knupBaKTpmVIEr5k7KMfjRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=59FejCern12InPqUNI0HFybJYSSFjknzO+7tbTLE+Cw=;
 b=emZ6V3keEUgWu1EsjoMJsqfeo9MYr5ljb+q2IhYf2lZtcN2vYA7oO4Q/qPZGWOoN8UFroiilv9Wr7AFxWDtApdkE7slw39oTLddmQwboyd+OXDL9bGJ5fnAj/6Vj39QxK3UGqDPMUqmM/cZksDguLugXbnPklcFZvgpE/qPHpGeu0grIauELf/Tcxmm3tQ+fRScIqP5TB+Idj7F/H7uqtER7f6UHHSVAIsjX5dWYP8dsY9xeHqsQcX63C637RIw7IN7tGydkigb1dKesNZ45zOFPVruBJGZUrwOVHjjjJmHRHTLIZ6AMAaMeL8lm5pE9ILpEXh/7k7zfh1OGarszTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=59FejCern12InPqUNI0HFybJYSSFjknzO+7tbTLE+Cw=;
 b=poe+Kc3yQ79+iCOTz3vVCpTMqCOVxtiNI8+kx7Nx4z8d5HnFF6ARXRXOmVSueHTZuthxXAXVeeCs6FF/JQr9dt3d3eHnudzozNUiJEhAAkXBnmIovryqkh+ySCeHouLG//eAGzfjeAT7agXyJRINgnvD+BmwqTSEJ9lkVVRWB4eiD9Iy0fF/V2ht88MB4lUPJOGeDkWyZnNx6eVu0Vd9oQlaOT+Fcpv95BvTLdtPy3NQ/ZxXmWNWB8mPzvAuP04fArFzehGsw6x2yKaNvQPYZ0blp0jdt+Tdrxu6stMB585JN6X48pclZvvjfj5sPn2MgjxDVzMCNW4UmF0d6Wn9Fg==
Received: from DM5PR2201CA0003.namprd22.prod.outlook.com (2603:10b6:4:14::13)
 by BY5PR12MB3779.namprd12.prod.outlook.com (2603:10b6:a03:1a7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Fri, 24 Sep
 2021 09:37:45 +0000
Received: from DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:14:cafe::94) by DM5PR2201CA0003.outlook.office365.com
 (2603:10b6:4:14::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend
 Transport; Fri, 24 Sep 2021 09:37:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT009.mail.protection.outlook.com (10.13.173.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Fri, 24 Sep 2021 09:37:44 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 24 Sep
 2021 02:37:44 -0700
Received: from [10.40.102.56] (172.20.187.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 24 Sep
 2021 09:37:39 +0000
Subject: Re: [PATCH mlx5-next 2/7] vfio: Add an API to check migration state
 transition validity
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "Max Gurtovoy" <mgurtovoy@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
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
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <92f40b8d-8035-1b74-4f27-0ddd850c6e30@nvidia.com>
Date:   Fri, 24 Sep 2021 15:07:35 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <164439bb579d41639edf9a01a538a5ef@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55becd4c-6ff3-49cb-3ed6-08d97f3ef680
X-MS-TrafficTypeDiagnostic: BY5PR12MB3779:
X-Microsoft-Antispam-PRVS: <BY5PR12MB377953B2B658E7E4E765ADC0DCA49@BY5PR12MB3779.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d+L0v8+OJsk4QXrXoVgmss5eW398FSQdDgioBFb8FdQltEk7pCSh2QN4BG53i+oNelYeLHxvluYXxDhDE3ptdFYgQWvDe0at+ro8nBroS+79myb+M3b/HcvF5f+f7JJYtj7Rb5PfIIFSrSDYIUTepf7kxw2cyFqLltvi2Mzl/cVG4APBhJdAyQqgjL2+MhQS2/OevMcHo/2QtGhlYEAPfug13C7p+5zd+Mj/aJ9WI8Uq2sTN2uZ6XDyCio0x4bWdXi1IbKYJaBJVfPYi7HaFGjjlQs7fLTlkNd9mQxe0q8zAZoPrFd+WGSyS1uqADOmINAvQ7ONyNElWRGINkq0l57322H1Ecp/Mk0y+jl+VYi3qrlI9vdhHav1FzRLc9c7V+1px7lZuEocV3F0cpxXkGvmT4VfyVa3RYs+4A3AmxjQrMj2JWdtIYCglZpON0L1w/U+yXDa8H2b4/T3N+Cok2DNi6FhY7MKMKIxNE/s/5L26QEQsYuQADWgwNLC6vHetNucn/BA25h6ua8Mnmp6hv3AyZXACky1efILpcTkAD7M8maDi4pSt5QhlnRAXhPQwvPkm4/QhRPTfECw4GV0kyHe9gb73ohb/TaDcjM/k+SfLP3GWoH9fNoeA9MwFWRtsatGDkDulk6HUjU0HTcJPiBwlEN8UrTVqFEWMWLuf3pO3AVbbwLF8IHGHlGIyiOf5mHoArWtuuw54an1oa6M2vDSZH7LzYi/fuWfOwf8R9z8=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(47076005)(8676002)(31686004)(26005)(31696002)(36756003)(82310400003)(86362001)(5660300002)(336012)(16526019)(6666004)(2906002)(4326008)(8936002)(36860700001)(186003)(316002)(110136005)(70206006)(16576012)(54906003)(7636003)(426003)(70586007)(356005)(53546011)(7416002)(508600001)(83380400001)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2021 09:37:44.8256
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 55becd4c-6ff3-49cb-3ed6-08d97f3ef680
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3779
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/24/2021 1:14 PM, Shameerali Kolothum Thodi wrote:
> 
> 
>> -----Original Message-----
>> From: Max Gurtovoy [mailto:mgurtovoy@nvidia.com]
>> Sent: 23 September 2021 14:56
>> To: Leon Romanovsky <leon@kernel.org>; Shameerali Kolothum Thodi
>> <shameerali.kolothum.thodi@huawei.com>
>> Cc: Doug Ledford <dledford@redhat.com>; Jason Gunthorpe
>> <jgg@nvidia.com>; Yishai Hadas <yishaih@nvidia.com>; Alex Williamson
>> <alex.williamson@redhat.com>; Bjorn Helgaas <bhelgaas@google.com>; David
>> S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Kirti
>> Wankhede <kwankhede@nvidia.com>; kvm@vger.kernel.org;
>> linux-kernel@vger.kernel.org; linux-pci@vger.kernel.org;
>> linux-rdma@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
>> <saeedm@nvidia.com>
>> Subject: Re: [PATCH mlx5-next 2/7] vfio: Add an API to check migration state
>> transition validity
>>
>>
>> On 9/23/2021 2:17 PM, Leon Romanovsky wrote:
>>> On Thu, Sep 23, 2021 at 10:33:10AM +0000, Shameerali Kolothum Thodi
>> wrote:
>>>>
>>>>> -----Original Message-----
>>>>> From: Leon Romanovsky [mailto:leon@kernel.org]
>>>>> Sent: 22 September 2021 11:39
>>>>> To: Doug Ledford <dledford@redhat.com>; Jason Gunthorpe
>> <jgg@nvidia.com>
>>>>> Cc: Yishai Hadas <yishaih@nvidia.com>; Alex Williamson
>>>>> <alex.williamson@redhat.com>; Bjorn Helgaas <bhelgaas@google.com>;
>> David
>>>>> S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Kirti
>>>>> Wankhede <kwankhede@nvidia.com>; kvm@vger.kernel.org;
>>>>> linux-kernel@vger.kernel.org; linux-pci@vger.kernel.org;
>>>>> linux-rdma@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
>>>>> <saeedm@nvidia.com>
>>>>> Subject: [PATCH mlx5-next 2/7] vfio: Add an API to check migration state
>>>>> transition validity
>>>>>
>>>>> From: Yishai Hadas <yishaih@nvidia.com>
>>>>>
>>>>> Add an API in the core layer to check migration state transition validity
>>>>> as part of a migration flow.
>>>>>
>>>>> The valid transitions follow the expected usage as described in
>>>>> uapi/vfio.h and triggered by QEMU.
>>>>>
>>>>> This ensures that all migration implementations follow a consistent
>>>>> migration state machine.
>>>>>
>>>>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>>>>> Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
>>>>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>>>>> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>>>>> ---
>>>>>    drivers/vfio/vfio.c  | 41
>> +++++++++++++++++++++++++++++++++++++++++
>>>>>    include/linux/vfio.h |  1 +
>>>>>    2 files changed, 42 insertions(+)
>>>>>
>>>>> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
>>>>> index 3c034fe14ccb..c3ca33e513c8 100644
>>>>> --- a/drivers/vfio/vfio.c
>>>>> +++ b/drivers/vfio/vfio.c
>>>>> @@ -1664,6 +1664,47 @@ static int vfio_device_fops_release(struct
>> inode
>>>>> *inode, struct file *filep)
>>>>>    	return 0;
>>>>>    }
>>>>>
>>>>> +/**
>>>>> + * vfio_change_migration_state_allowed - Checks whether a migration
>> state
>>>>> + *   transition is valid.
>>>>> + * @new_state: The new state to move to.
>>>>> + * @old_state: The old state.
>>>>> + * Return: true if the transition is valid.
>>>>> + */
>>>>> +bool vfio_change_migration_state_allowed(u32 new_state, u32
>> old_state)
>>>>> +{
>>>>> +	enum { MAX_STATE = VFIO_DEVICE_STATE_RESUMING };
>>>>> +	static const u8 vfio_from_state_table[MAX_STATE + 1][MAX_STATE +
>> 1] = {
>>>>> +		[VFIO_DEVICE_STATE_STOP] = {
>>>>> +			[VFIO_DEVICE_STATE_RUNNING] = 1,
>>>>> +			[VFIO_DEVICE_STATE_RESUMING] = 1,
>>>>> +		},
>>>>> +		[VFIO_DEVICE_STATE_RUNNING] = {
>>>>> +			[VFIO_DEVICE_STATE_STOP] = 1,
>>>>> +			[VFIO_DEVICE_STATE_SAVING] = 1,
>>>>> +			[VFIO_DEVICE_STATE_SAVING |
>> VFIO_DEVICE_STATE_RUNNING]
>>>>> = 1,
>>>> Do we need to allow _RESUMING state here or not? As per the "State
>> transitions"
>>>> section from uapi/linux/vfio.h,
>>> It looks like we missed this state transition.
>>>
>>> Thanks
>>
>> I'm not sure this state transition is valid.
>>
>> Kirti, When we would like to move from RUNNING to RESUMING ?
> 
> I guess it depends on what you report as your dev default state.
> 
> For HiSilicon ACC migration driver, we set the default to _RUNNING.
> 
> And when the migration starts, the destination side Qemu, set the
> device state to _RESUMING(vfio_load_state()).
> 
>  From the documentation, it looks like the assumption on default state of
> the VFIO dev is _RUNNING.
> 

That's right. in QEMU VFIO device state at init is running to maintain 
backward compatibility since migration support was added later.

RUNNING -> RESUMING state transition is valid.

Thanks,
Kirti

> "
> *  001b => Device running, which is the default state
> "
> 
>>
>> Sameerali, can you please re-test and update if you see this transition ?
> 
> Yes. And if I change the default state to _STOP, then the transition
> is from _STOP --> _RESUMING.
> 
> But the documentation on State transitions doesn't have _STOP --> _RESUMING
> transition as valid.
> 
> Thanks,
> Shameer
> 
>>
>>
>>>
>>>> " * 4. To start the resuming phase, the device state should be transitioned
>> from
>>>>    *    the _RUNNING to the _RESUMING state."
>>>>
>>>> IIRC, I have seen that transition happening on the destination dev while
>> testing the
>>>> HiSilicon ACC dev migration.
>>>>
>>>> Thanks,
>>>> Shameer
>>>>
>>>>> +		},
>>>>> +		[VFIO_DEVICE_STATE_SAVING] = {
>>>>> +			[VFIO_DEVICE_STATE_STOP] = 1,
>>>>> +			[VFIO_DEVICE_STATE_RUNNING] = 1,
>>>>> +		},
>>>>> +		[VFIO_DEVICE_STATE_SAVING | VFIO_DEVICE_STATE_RUNNING]
>> = {
>>>>> +			[VFIO_DEVICE_STATE_RUNNING] = 1,
>>>>> +			[VFIO_DEVICE_STATE_SAVING] = 1,
>>>>> +		},
>>>>> +		[VFIO_DEVICE_STATE_RESUMING] = {
>>>>> +			[VFIO_DEVICE_STATE_RUNNING] = 1,
>>>>> +			[VFIO_DEVICE_STATE_STOP] = 1,
>>>>> +		},
>>>>> +	};
>>>>> +
>>>>> +	if (new_state > MAX_STATE || old_state > MAX_STATE)
>>>>> +		return false;
>>>>> +
>>>>> +	return vfio_from_state_table[old_state][new_state];
>>>>> +}
>>>>> +EXPORT_SYMBOL_GPL(vfio_change_migration_state_allowed);
>>>>> +
>>>>>    static long vfio_device_fops_unl_ioctl(struct file *filep,
>>>>>    				       unsigned int cmd, unsigned long arg)
>>>>>    {
>>>>> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
>>>>> index b53a9557884a..e65137a708f1 100644
>>>>> --- a/include/linux/vfio.h
>>>>> +++ b/include/linux/vfio.h
>>>>> @@ -83,6 +83,7 @@ extern struct vfio_device
>>>>> *vfio_device_get_from_dev(struct device *dev);
>>>>>    extern void vfio_device_put(struct vfio_device *device);
>>>>>
>>>>>    int vfio_assign_device_set(struct vfio_device *device, void *set_id);
>>>>> +bool vfio_change_migration_state_allowed(u32 new_state, u32
>> old_state);
>>>>>
>>>>>    /* events for the backend driver notify callback */
>>>>>    enum vfio_iommu_notify_type {
>>>>> --
>>>>> 2.31.1
