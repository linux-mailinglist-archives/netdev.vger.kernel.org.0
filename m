Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43AC5415BFF
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 12:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240423AbhIWKep convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 23 Sep 2021 06:34:45 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3852 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbhIWKeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 06:34:44 -0400
Received: from fraeml713-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HFWdw4R79z67bWP;
        Thu, 23 Sep 2021 18:30:44 +0800 (CST)
Received: from lhreml717-chm.china.huawei.com (10.201.108.68) by
 fraeml713-chm.china.huawei.com (10.206.15.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 23 Sep 2021 12:33:10 +0200
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml717-chm.china.huawei.com (10.201.108.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 23 Sep 2021 11:33:10 +0100
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.008; Thu, 23 Sep 2021 11:33:10 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Yishai Hadas <yishaih@nvidia.com>,
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
Subject: RE: [PATCH mlx5-next 2/7] vfio: Add an API to check migration state
 transition validity
Thread-Topic: [PATCH mlx5-next 2/7] vfio: Add an API to check migration state
 transition validity
Thread-Index: AQHXr54pt96rmXk0YUaXSN2Kf89+2auxakgA
Date:   Thu, 23 Sep 2021 10:33:10 +0000
Message-ID: <42729adc4df649f7b3ce5dc95e66e2dc@huawei.com>
References: <cover.1632305919.git.leonro@nvidia.com>
 <c87f55d6fec77a22b110d3c9611744e6b28bba46.1632305919.git.leonro@nvidia.com>
In-Reply-To: <c87f55d6fec77a22b110d3c9611744e6b28bba46.1632305919.git.leonro@nvidia.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.85.235]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky [mailto:leon@kernel.org]
> Sent: 22 September 2021 11:39
> To: Doug Ledford <dledford@redhat.com>; Jason Gunthorpe <jgg@nvidia.com>
> Cc: Yishai Hadas <yishaih@nvidia.com>; Alex Williamson
> <alex.williamson@redhat.com>; Bjorn Helgaas <bhelgaas@google.com>; David
> S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Kirti
> Wankhede <kwankhede@nvidia.com>; kvm@vger.kernel.org;
> linux-kernel@vger.kernel.org; linux-pci@vger.kernel.org;
> linux-rdma@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
> <saeedm@nvidia.com>
> Subject: [PATCH mlx5-next 2/7] vfio: Add an API to check migration state
> transition validity
> 
> From: Yishai Hadas <yishaih@nvidia.com>
> 
> Add an API in the core layer to check migration state transition validity
> as part of a migration flow.
> 
> The valid transitions follow the expected usage as described in
> uapi/vfio.h and triggered by QEMU.
> 
> This ensures that all migration implementations follow a consistent
> migration state machine.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/vfio/vfio.c  | 41 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/vfio.h |  1 +
>  2 files changed, 42 insertions(+)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 3c034fe14ccb..c3ca33e513c8 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1664,6 +1664,47 @@ static int vfio_device_fops_release(struct inode
> *inode, struct file *filep)
>  	return 0;
>  }
> 
> +/**
> + * vfio_change_migration_state_allowed - Checks whether a migration state
> + *   transition is valid.
> + * @new_state: The new state to move to.
> + * @old_state: The old state.
> + * Return: true if the transition is valid.
> + */
> +bool vfio_change_migration_state_allowed(u32 new_state, u32 old_state)
> +{
> +	enum { MAX_STATE = VFIO_DEVICE_STATE_RESUMING };
> +	static const u8 vfio_from_state_table[MAX_STATE + 1][MAX_STATE + 1] = {
> +		[VFIO_DEVICE_STATE_STOP] = {
> +			[VFIO_DEVICE_STATE_RUNNING] = 1,
> +			[VFIO_DEVICE_STATE_RESUMING] = 1,
> +		},
> +		[VFIO_DEVICE_STATE_RUNNING] = {
> +			[VFIO_DEVICE_STATE_STOP] = 1,
> +			[VFIO_DEVICE_STATE_SAVING] = 1,
> +			[VFIO_DEVICE_STATE_SAVING | VFIO_DEVICE_STATE_RUNNING]
> = 1,

Do we need to allow _RESUMING state here or not? As per the "State transitions"
section from uapi/linux/vfio.h, 

" * 4. To start the resuming phase, the device state should be transitioned from
 *    the _RUNNING to the _RESUMING state."

IIRC, I have seen that transition happening on the destination dev while testing the 
HiSilicon ACC dev migration. 

Thanks,
Shameer

> +		},
> +		[VFIO_DEVICE_STATE_SAVING] = {
> +			[VFIO_DEVICE_STATE_STOP] = 1,
> +			[VFIO_DEVICE_STATE_RUNNING] = 1,
> +		},
> +		[VFIO_DEVICE_STATE_SAVING | VFIO_DEVICE_STATE_RUNNING] = {
> +			[VFIO_DEVICE_STATE_RUNNING] = 1,
> +			[VFIO_DEVICE_STATE_SAVING] = 1,
> +		},
> +		[VFIO_DEVICE_STATE_RESUMING] = {
> +			[VFIO_DEVICE_STATE_RUNNING] = 1,
> +			[VFIO_DEVICE_STATE_STOP] = 1,
> +		},
> +	};
> +
> +	if (new_state > MAX_STATE || old_state > MAX_STATE)
> +		return false;
> +
> +	return vfio_from_state_table[old_state][new_state];
> +}
> +EXPORT_SYMBOL_GPL(vfio_change_migration_state_allowed);
> +
>  static long vfio_device_fops_unl_ioctl(struct file *filep,
>  				       unsigned int cmd, unsigned long arg)
>  {
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index b53a9557884a..e65137a708f1 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -83,6 +83,7 @@ extern struct vfio_device
> *vfio_device_get_from_dev(struct device *dev);
>  extern void vfio_device_put(struct vfio_device *device);
> 
>  int vfio_assign_device_set(struct vfio_device *device, void *set_id);
> +bool vfio_change_migration_state_allowed(u32 new_state, u32 old_state);
> 
>  /* events for the backend driver notify callback */
>  enum vfio_iommu_notify_type {
> --
> 2.31.1

