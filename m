Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4E94187D9
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 11:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbhIZJLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 05:11:31 -0400
Received: from mail-mw2nam08on2069.outbound.protection.outlook.com ([40.107.101.69]:33600
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229687AbhIZJL0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Sep 2021 05:11:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZTkuGarOV4OsepjX4Af+txfq9enmQ3OtvbL+wRAyWghfH00cLeU3tS4gGwxu+cZqq4mHKXpm9yTdZVETy8J4g2c/3szaSQZs+F8z/fPHlAsYsRFrNgnPGjn0jPsbru571myTcVHfk86Od/fjDFAxn42F6NWpAuvHL3+7T7Q/hWJMkD03P0yMPfkrhUI/pLuJ5JAAWSicKK08dG0JCYaQUUL9UAI7F0hMk5u/3XP2GKF2ZsBIif7Nsz7t1XUJaGCklA4cQiw630NDnWQDxNKezSySsmWZoXXdRLlBECEl/r864mttQLU8SUE373+1CmXQmHg6ANR9a2Lm227ML4MHag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=EJkf39FG+ejw6aDjMXmV9u5iv8kq2mvaJNDPZlmavM0=;
 b=b95eUC4qhffArAENuF1qhw1XAOrZO7EHngDYp8iTNvKmnd0atXOtkTPYrrKVuyXYlIgDj+mceLfq1e0uA5wPFg+GOdUNLCZrMUX/B8i0Jwxs2FrzuOtElfSIET8RYTryxUhZTiSAlAhPLgy+Omz0aAYmFku66zn9S2a9mWop1pCzLhGA6x4vlu9bnk/4kpjYW/k9I87tLVF8mIVRldt2nrJizgZP95lGk/0aUMZQljA6UF973/Z2DfNQTbGN8q7ugBptsAZESNNrv/Kf5tChTzzK+gIhHsGkR0bdjitxznYH4dDIgv/iWEu5WY9tZh2DWUBGw30WDrIbgsroLKKwmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EJkf39FG+ejw6aDjMXmV9u5iv8kq2mvaJNDPZlmavM0=;
 b=f0pbGgKqiNN6kC4UTA+Z2RfeyUf23RW770MuJPHm3Cm3YTg3FV/cWQlV6o6uJUtvV6Rw1zkiTc3NkN2Aq8cDVI4LusWxYk5LEJbM28idNiWPZklsYKXP0xpeln1vilX/j8x4O3NJ0f6rCUnKMTwy62foJ+OoXPiWUfYWgz7NDmP9URtgI+6qOuy1ddSX7DJZsWj9sd8hdqYgfOENj23zOM3yP0ZQzyHP20MDsvqLcGI49vV2vSKJvOiHO2qsZb/ZfvQAgBWabg4by/t6zCXUZbfmRhRgdhr04x2nEN0EhUYW8zars+IPnT1/V3ain45+bIqTebCznUWz8tU6WBhBkA==
Received: from BN9PR03CA0383.namprd03.prod.outlook.com (2603:10b6:408:f7::28)
 by DM6PR12MB4370.namprd12.prod.outlook.com (2603:10b6:5:2aa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Sun, 26 Sep
 2021 09:09:48 +0000
Received: from BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f7:cafe::90) by BN9PR03CA0383.outlook.office365.com
 (2603:10b6:408:f7::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend
 Transport; Sun, 26 Sep 2021 09:09:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT049.mail.protection.outlook.com (10.13.177.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Sun, 26 Sep 2021 09:09:48 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 26 Sep
 2021 09:09:45 +0000
Received: from [172.27.12.58] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 26 Sep
 2021 09:09:35 +0000
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
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <078fc846-1f72-adc0-339c-1b638c6c6e33@nvidia.com>
Date:   Sun, 26 Sep 2021 12:09:31 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <164439bb579d41639edf9a01a538a5ef@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5391ac67-a2fa-43c7-d8f0-08d980cd6435
X-MS-TrafficTypeDiagnostic: DM6PR12MB4370:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4370382E59CBB673B0BAAD56DEA69@DM6PR12MB4370.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iFJPFMTsLY7nZh2tuRc4Vn1baq6CYEAFi891pfukU03b9GNYKskFwIi6k7xQFDw4t93KAbylY3yeKA5eGMAEV9XMBuzqXaZLFJo92oRlKrFXe+Pos+o6x/nBcRI3PrnpGxzVJw0XwFm1GagOqr0ri6aaZi0omC6SXGRfD7/KR6RIVj/MzVMkLWB8ihCKEG9F2PVoFZTIhE6qZUthvfrP9n6/pckX8s08csrOfyon7xFSo7kQLvjE1E8PwyW+BnsVm2e4g95cPwtWTBjlMa6RbCNLy2/HxZvu5bcoEBtxijV2Ozyjb4sCRFLDAYRs5EC8yEp3sDqc2GOgkCYt+hBjR83VWJ0DswMjm8kDm2AWYYowcIUHWLiRgdqhbknQG2N6JtMw6QY9CY9fyTR+yKn1IGwZ1qCMSQAR2iUZOIw2llNcR7+jA+eQpgg4Ij6f3ywU/5V2GAjJMNvRYZ32pKo1ks0Hys61mgf8U3zhckame0GMEBFCjxgrJjyUNkYrjN9krRUDcjbhquVu0UuI/H+KKhqkZUAiGszmNUaBhjEFFJdhrTbRkabm+VLXwRLAULLWliCq40wQ9XIP+H8Tys/aKWTNnjrhQPqToHO0rzdvjYVTDwFqFrseWQYVE92G9S4JQpE7MCkHcg+ahNCuCTHeb2KyHa5+l7TLTCYI4+ebbOPH0FZVstDKJkRNa5MF9NleByjQ+LrN2s96mILdnbGxzLJ/2o02Wa4oUzf5b/vqmjU=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(6666004)(31696002)(83380400001)(54906003)(4326008)(110136005)(26005)(36906005)(5660300002)(2906002)(316002)(16576012)(356005)(36860700001)(16526019)(186003)(7636003)(336012)(8676002)(2616005)(82310400003)(31686004)(53546011)(426003)(8936002)(70206006)(70586007)(7416002)(508600001)(86362001)(47076005)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2021 09:09:48.5858
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5391ac67-a2fa-43c7-d8f0-08d980cd6435
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4370
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/24/2021 10:44 AM, Shameerali Kolothum Thodi wrote:
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
>> I'm not sure this state transition is valid.
>>
>> Kirti, When we would like to move from RUNNING to RESUMING ?
> I guess it depends on what you report as your dev default state.
>
> For HiSilicon ACC migration driver, we set the default to _RUNNING.

Where do you set it and report it ?


>
> And when the migration starts, the destination side Qemu, set the
> device state to _RESUMING(vfio_load_state()).
>
>  From the documentation, it looks like the assumption on default state of
> the VFIO dev is _RUNNING.
>
> "
> *  001b => Device running, which is the default state
> "
>
>> Sameerali, can you please re-test and update if you see this transition ?
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
>>>>>    /* events for the backend driver notify callback */
>>>>>    enum vfio_iommu_notify_type {
>>>>> --
>>>>> 2.31.1
