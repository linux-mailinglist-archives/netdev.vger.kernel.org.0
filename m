Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1D6416061
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 15:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241530AbhIWN5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 09:57:19 -0400
Received: from mail-bn7nam10on2047.outbound.protection.outlook.com ([40.107.92.47]:30762
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231974AbhIWN5R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 09:57:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dbx7Ks9i3Uhgzm8R6rKgAfh1v3A+1ZcC6ftHc+QdG48ROvqKKLpT78V5588uEPPTJ17l1Ll4sQIHMRUUYY0fli6suK6LDHTcZtbqCGfp9R90y87xCypBByOjYcAwn+OQhkZaEI22Sil/j95lP7NfPOAb2/nRwFXj87/iBB9150RBjnC6ysx3dYI7Gw02T5xIngVLqH4Io+o9gYwYRQI7iJI+oXq7PoIS0w9dIDOa8oWiG9ykxhBmgbOhPZC5zaK9Vr9DwbTePyfrSsm/YJBudYzko1xmlSRY9jO1xl62IHNYUZzS4VQeIOJbLJg+Bj4Hph7ROqC3JUSot5LPHlbjxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=uXNbn0g4xzMzyWf+BjpM9VY/3lEV/LNbIYeSWuJMylA=;
 b=IjgPnQu/Vb/rzwlJFE3Wit30AcgXXmLOGGcyqn6wKpbMgsx9sD/iv2+43ZMTjF+NhjfmABtNwE+4CFSPTRobhgh6wImnbddrSagJA4mvGItnLdFS0tvnZRKGDwFEXKEaPKTRrSmeq8BkueKkZEuvsR+O13xp6uj2D3gP/JchHmV31HPhxyb0WAxv278Zbq7XpKaDIl1X63R9VXeaNSQuk2OXontt+NOShqkWSUmOw4XEAw9NrLRcfN58QObrBbTZR245UaDP62VZ4GB2ihhrAgWbjot2VRjRkcy2GrQYzZmPAdagDV8UnELMm8ydRruxj+WZMzOvjhfr+it9XtiNjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uXNbn0g4xzMzyWf+BjpM9VY/3lEV/LNbIYeSWuJMylA=;
 b=lzUdpsXqh5W9fuM7AWU0ZhusoRBmQq5xorylAGRtGdOMYxwuO1rI6XsW6Ew6oUnOV4oAHrTCljc60AdhK3O0LnIJg6PUa/JvGOU3Kr0E4ecTeVmVRPhURUWgUiLqafc4T7N5pnrfqDpifcHWYNX2ZEHCsG3z9sAL6FpQ+IkgzJr6rxU9VKw3cbyUeEu+qeFCPNRyCcEqPztifVZw2ylc4D1LGD6ISjmDJzi81KXEulGRU08w58VMSehs3xB3CaBYQ+aKag+M8sAEsFOEkjw4/1J0eEQt0NTo5f7vMB7x4wnei9dAiyvMuW6reL7FHfTwm5RqNvrRPuXHl7/ltEE+4A==
Received: from DM5PR15CA0046.namprd15.prod.outlook.com (2603:10b6:4:4b::32) by
 MW2PR12MB2442.namprd12.prod.outlook.com (2603:10b6:907:4::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4544.15; Thu, 23 Sep 2021 13:55:43 +0000
Received: from DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:4b:cafe::6e) by DM5PR15CA0046.outlook.office365.com
 (2603:10b6:4:4b::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend
 Transport; Thu, 23 Sep 2021 13:55:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT064.mail.protection.outlook.com (10.13.172.234) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Thu, 23 Sep 2021 13:55:43 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 23 Sep
 2021 06:55:42 -0700
Received: from [172.27.15.96] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 23 Sep
 2021 13:55:37 +0000
Subject: Re: [PATCH mlx5-next 2/7] vfio: Add an API to check migration state
 transition validity
To:     Leon Romanovsky <leon@kernel.org>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>
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
        Saeed Mahameed <saeedm@nvidia.com>
References: <cover.1632305919.git.leonro@nvidia.com>
 <c87f55d6fec77a22b110d3c9611744e6b28bba46.1632305919.git.leonro@nvidia.com>
 <42729adc4df649f7b3ce5dc95e66e2dc@huawei.com> <YUxiPqShZT4bk0uL@unreal>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <60989aa8-4231-0cdf-47bb-1e2026bd1f17@nvidia.com>
Date:   Thu, 23 Sep 2021 16:55:35 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YUxiPqShZT4bk0uL@unreal>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f30a9f56-c5a8-4e6e-5501-08d97e99d5d6
X-MS-TrafficTypeDiagnostic: MW2PR12MB2442:
X-Microsoft-Antispam-PRVS: <MW2PR12MB24421E989B84A991FF1517DCDEA39@MW2PR12MB2442.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gAU8FT/dUXNfzqNzckBFkbuMhCWslULbYgsGu7hYXcIGEr6f+tqYpnFRJEItW68TIeiHWy0SanQhk/rAvRP1QxBv8SP2oQal4jFOjwhk8Xf+Z/cZ1T4ggOwaQiIR2NV1XGgJHRDvPIzpKCOj+UYCkd4nbU9HF5A1QeGerpg/OHbK6uHn/IfyWKQkv1n29waMHsP2phyykcXqXwf+mFVQHPaB5zrcgXjHOgIAGmV7D8+X02YEhVSBrZeL2wSwSmPYrwqS7aH/tBk8/sUC5b59Lunb7dPockHNTQ7xLCuHU66Db9H3zMYxA5nF9KYmmIx3YR5xo/O1y/TvbChfDnZwfQAGluwMKAx0z+Ys3YDILCbpIxBF0dhhVsD/dRNw7YlxVlaMEsM9B+WsXn7+Jzwvu8BnLmMR8Pfhd5hNwBAJRAB0EJwep99bN8vf6HUqzNwINLZ4NecO1VNldTu68Q8xUMZnm+fCV05fdd5fRvGaCpTVfCZljRuUleLVaeyNQ0OowRDPkAKFW6a06HMZ5VAJiEsQOOh60osXd55fVuRe3/bf0b7xvsapHQ/cKXWmkX6NhKF00Z0j8Qr8n3BY1D6EiTD69MJSKjxpK/k5Y31IdFB+ginLzTm1NUAf905QF/KX5p1f+PETR9FOgIQGrxbjqu+/vJgore8O/+WfzlHDg7xR13nUq4c/5HfqrHSmJTyKdyUT2XRX48ExCiS3yM0/uqI6W5TzH94r7O/m8ewdkkI=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(82310400003)(36860700001)(508600001)(70586007)(70206006)(31696002)(31686004)(426003)(54906003)(110136005)(316002)(5660300002)(86362001)(16576012)(107886003)(53546011)(4326008)(8936002)(2616005)(336012)(2906002)(16526019)(26005)(186003)(8676002)(83380400001)(7636003)(36756003)(356005)(47076005)(7416002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2021 13:55:43.1116
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f30a9f56-c5a8-4e6e-5501-08d97e99d5d6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2442
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/23/2021 2:17 PM, Leon Romanovsky wrote:
> On Thu, Sep 23, 2021 at 10:33:10AM +0000, Shameerali Kolothum Thodi wrote:
>>
>>> -----Original Message-----
>>> From: Leon Romanovsky [mailto:leon@kernel.org]
>>> Sent: 22 September 2021 11:39
>>> To: Doug Ledford <dledford@redhat.com>; Jason Gunthorpe <jgg@nvidia.com>
>>> Cc: Yishai Hadas <yishaih@nvidia.com>; Alex Williamson
>>> <alex.williamson@redhat.com>; Bjorn Helgaas <bhelgaas@google.com>; David
>>> S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Kirti
>>> Wankhede <kwankhede@nvidia.com>; kvm@vger.kernel.org;
>>> linux-kernel@vger.kernel.org; linux-pci@vger.kernel.org;
>>> linux-rdma@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
>>> <saeedm@nvidia.com>
>>> Subject: [PATCH mlx5-next 2/7] vfio: Add an API to check migration state
>>> transition validity
>>>
>>> From: Yishai Hadas <yishaih@nvidia.com>
>>>
>>> Add an API in the core layer to check migration state transition validity
>>> as part of a migration flow.
>>>
>>> The valid transitions follow the expected usage as described in
>>> uapi/vfio.h and triggered by QEMU.
>>>
>>> This ensures that all migration implementations follow a consistent
>>> migration state machine.
>>>
>>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>>> Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
>>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>>> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>>> ---
>>>   drivers/vfio/vfio.c  | 41 +++++++++++++++++++++++++++++++++++++++++
>>>   include/linux/vfio.h |  1 +
>>>   2 files changed, 42 insertions(+)
>>>
>>> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
>>> index 3c034fe14ccb..c3ca33e513c8 100644
>>> --- a/drivers/vfio/vfio.c
>>> +++ b/drivers/vfio/vfio.c
>>> @@ -1664,6 +1664,47 @@ static int vfio_device_fops_release(struct inode
>>> *inode, struct file *filep)
>>>   	return 0;
>>>   }
>>>
>>> +/**
>>> + * vfio_change_migration_state_allowed - Checks whether a migration state
>>> + *   transition is valid.
>>> + * @new_state: The new state to move to.
>>> + * @old_state: The old state.
>>> + * Return: true if the transition is valid.
>>> + */
>>> +bool vfio_change_migration_state_allowed(u32 new_state, u32 old_state)
>>> +{
>>> +	enum { MAX_STATE = VFIO_DEVICE_STATE_RESUMING };
>>> +	static const u8 vfio_from_state_table[MAX_STATE + 1][MAX_STATE + 1] = {
>>> +		[VFIO_DEVICE_STATE_STOP] = {
>>> +			[VFIO_DEVICE_STATE_RUNNING] = 1,
>>> +			[VFIO_DEVICE_STATE_RESUMING] = 1,
>>> +		},
>>> +		[VFIO_DEVICE_STATE_RUNNING] = {
>>> +			[VFIO_DEVICE_STATE_STOP] = 1,
>>> +			[VFIO_DEVICE_STATE_SAVING] = 1,
>>> +			[VFIO_DEVICE_STATE_SAVING | VFIO_DEVICE_STATE_RUNNING]
>>> = 1,
>> Do we need to allow _RESUMING state here or not? As per the "State transitions"
>> section from uapi/linux/vfio.h,
> It looks like we missed this state transition.
>
> Thanks

I'm not sure this state transition is valid.

Kirti, When we would like to move from RUNNING to RESUMING ?

Sameerali, can you please re-test and update if you see this transition ?


>
>> " * 4. To start the resuming phase, the device state should be transitioned from
>>   *    the _RUNNING to the _RESUMING state."
>>
>> IIRC, I have seen that transition happening on the destination dev while testing the
>> HiSilicon ACC dev migration.
>>
>> Thanks,
>> Shameer
>>
>>> +		},
>>> +		[VFIO_DEVICE_STATE_SAVING] = {
>>> +			[VFIO_DEVICE_STATE_STOP] = 1,
>>> +			[VFIO_DEVICE_STATE_RUNNING] = 1,
>>> +		},
>>> +		[VFIO_DEVICE_STATE_SAVING | VFIO_DEVICE_STATE_RUNNING] = {
>>> +			[VFIO_DEVICE_STATE_RUNNING] = 1,
>>> +			[VFIO_DEVICE_STATE_SAVING] = 1,
>>> +		},
>>> +		[VFIO_DEVICE_STATE_RESUMING] = {
>>> +			[VFIO_DEVICE_STATE_RUNNING] = 1,
>>> +			[VFIO_DEVICE_STATE_STOP] = 1,
>>> +		},
>>> +	};
>>> +
>>> +	if (new_state > MAX_STATE || old_state > MAX_STATE)
>>> +		return false;
>>> +
>>> +	return vfio_from_state_table[old_state][new_state];
>>> +}
>>> +EXPORT_SYMBOL_GPL(vfio_change_migration_state_allowed);
>>> +
>>>   static long vfio_device_fops_unl_ioctl(struct file *filep,
>>>   				       unsigned int cmd, unsigned long arg)
>>>   {
>>> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
>>> index b53a9557884a..e65137a708f1 100644
>>> --- a/include/linux/vfio.h
>>> +++ b/include/linux/vfio.h
>>> @@ -83,6 +83,7 @@ extern struct vfio_device
>>> *vfio_device_get_from_dev(struct device *dev);
>>>   extern void vfio_device_put(struct vfio_device *device);
>>>
>>>   int vfio_assign_device_set(struct vfio_device *device, void *set_id);
>>> +bool vfio_change_migration_state_allowed(u32 new_state, u32 old_state);
>>>
>>>   /* events for the backend driver notify callback */
>>>   enum vfio_iommu_notify_type {
>>> --
>>> 2.31.1
