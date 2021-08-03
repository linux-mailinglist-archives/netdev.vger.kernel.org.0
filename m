Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA113DE737
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 09:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234227AbhHCHah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 03:30:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32110 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234173AbhHCHag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 03:30:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627975825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2q5cKVt8HkdvWLVDPoAENZkOV4GLcj8mh5u4LwwqXQg=;
        b=NhQgdrvVrlJoU9lC1ntcW+R8P/deCNvTEs5OqstbA5nO98NEzEPJVYxqF22l8xyT5bgbPb
        OAzOBfQHDBSlWXL/rjS+clDm3y5yDXOKffgrOnQkdKHq5YCX4LA2GEBsk6RYrrdpojnaec
        jCFr++Vx824IT93aBwbqtJADPptlT98=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-5JlEOXe2NhqiDct2UdYogg-1; Tue, 03 Aug 2021 03:30:24 -0400
X-MC-Unique: 5JlEOXe2NhqiDct2UdYogg-1
Received: by mail-pl1-f200.google.com with SMTP id f9-20020a1709028609b0290128bcba6be7so15893725plo.18
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 00:30:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=2q5cKVt8HkdvWLVDPoAENZkOV4GLcj8mh5u4LwwqXQg=;
        b=Xz1ZkLKi45kd7E+V1aIRcg0O9R72C7D6z7mlRFUjy8l6YtMYZAkYju/q+DgSd1hUw7
         VmsyTsMuMw8BaG3TsE1ill6Dy2RjDQHWS2GrzwojWuGQpnGCw/Fo/rZ+xA/rlNqcsj8B
         lf4rCsg0O0FcIm8HNCOvuHYn7NUlCKD1MKRZoo3Jd6NThdsJ11jUPcVQ3zZ7xB7OirBH
         XSFyVPpUDi8yH0NZF9lU7BEwyqKmOeGImUHIuNv02l6jSbI+YeayEPRZwCauTsOJ3nFA
         XGVVu1OZggIkR93qazAzlih+EItiCvlRvlYGuQn4GcWYLMRGCwRSO0sL91SW/nBjLZx5
         Wy4Q==
X-Gm-Message-State: AOAM531IMs1eFs0R2AoiLVu6Hs/YgNuVPLj+PBD4M+hPM7LPlr2UkCqv
        rM6gegP2tzPS9q9DWpV1PQ1K9pj8r5cK+8eLIcz7oqhbc32Qd93TuFsku6Cga0RAt4NYu9B+xsu
        tMx6j+ecdXA3OV2Rt
X-Received: by 2002:a17:902:7c87:b029:12c:8f2d:4238 with SMTP id y7-20020a1709027c87b029012c8f2d4238mr2334687pll.50.1627975823463;
        Tue, 03 Aug 2021 00:30:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyxQbskpfqVraXEkI1LzhRrk+KradYU967AMB1od8U2sh7UOY8/HP+aNVn3ptEFADzrVm8jMg==
X-Received: by 2002:a17:902:7c87:b029:12c:8f2d:4238 with SMTP id y7-20020a1709027c87b029012c8f2d4238mr2334670pll.50.1627975823183;
        Tue, 03 Aug 2021 00:30:23 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u3sm1749726pjn.18.2021.08.03.00.30.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 00:30:22 -0700 (PDT)
Subject: Re: [PATCH v10 16/17] vduse: Introduce VDUSE - vDPA Device in
 Userspace
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        hch@infradead.org, christian.brauner@canonical.com,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20210729073503.187-1-xieyongji@bytedance.com>
 <20210729073503.187-17-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <eab9e694-42a5-9382-b829-1b7fade8a5ab@redhat.com>
Date:   Tue, 3 Aug 2021 15:30:13 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210729073503.187-17-xieyongji@bytedance.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/7/29 ÏÂÎç3:35, Xie Yongji Ð´µÀ:
> This VDUSE driver enables implementing software-emulated vDPA
> devices in userspace. The vDPA device is created by
> ioctl(VDUSE_CREATE_DEV) on /dev/vduse/control. Then a char device
> interface (/dev/vduse/$NAME) is exported to userspace for device
> emulation.
>
> In order to make the device emulation more secure, the device's
> control path is handled in kernel. A message mechnism is introduced
> to forward some dataplane related control messages to userspace.
>
> And in the data path, the DMA buffer will be mapped into userspace
> address space through different ways depending on the vDPA bus to
> which the vDPA device is attached. In virtio-vdpa case, the MMU-based
> software IOTLB is used to achieve that. And in vhost-vdpa case, the
> DMA buffer is reside in a userspace memory region which can be shared
> to the VDUSE userspace processs via transferring the shmfd.
>
> For more details on VDUSE design and usage, please see the follow-on
> Documentation commit.
>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>   Documentation/userspace-api/ioctl/ioctl-number.rst |    1 +
>   drivers/vdpa/Kconfig                               |   10 +
>   drivers/vdpa/Makefile                              |    1 +
>   drivers/vdpa/vdpa_user/Makefile                    |    5 +
>   drivers/vdpa/vdpa_user/vduse_dev.c                 | 1541 ++++++++++++++++++++
>   include/uapi/linux/vduse.h                         |  220 +++
>   6 files changed, 1778 insertions(+)
>   create mode 100644 drivers/vdpa/vdpa_user/Makefile
>   create mode 100644 drivers/vdpa/vdpa_user/vduse_dev.c
>   create mode 100644 include/uapi/linux/vduse.h
>
> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
> index 1409e40e6345..293ca3aef358 100644
> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> @@ -300,6 +300,7 @@ Code  Seq#    Include File                                           Comments
>   'z'   10-4F  drivers/s390/crypto/zcrypt_api.h                        conflict!
>   '|'   00-7F  linux/media.h
>   0x80  00-1F  linux/fb.h
> +0x81  00-1F  linux/vduse.h
>   0x89  00-06  arch/x86/include/asm/sockios.h
>   0x89  0B-DF  linux/sockios.h
>   0x89  E0-EF  linux/sockios.h                                         SIOCPROTOPRIVATE range
> diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
> index a503c1b2bfd9..6e23bce6433a 100644
> --- a/drivers/vdpa/Kconfig
> +++ b/drivers/vdpa/Kconfig
> @@ -33,6 +33,16 @@ config VDPA_SIM_BLOCK
>   	  vDPA block device simulator which terminates IO request in a
>   	  memory buffer.
>   
> +config VDPA_USER
> +	tristate "VDUSE (vDPA Device in Userspace) support"
> +	depends on EVENTFD && MMU && HAS_DMA
> +	select DMA_OPS
> +	select VHOST_IOTLB
> +	select IOMMU_IOVA
> +	help
> +	  With VDUSE it is possible to emulate a vDPA Device
> +	  in a userspace program.
> +
>   config IFCVF
>   	tristate "Intel IFC VF vDPA driver"
>   	depends on PCI_MSI
> diff --git a/drivers/vdpa/Makefile b/drivers/vdpa/Makefile
> index 67fe7f3d6943..f02ebed33f19 100644
> --- a/drivers/vdpa/Makefile
> +++ b/drivers/vdpa/Makefile
> @@ -1,6 +1,7 @@
>   # SPDX-License-Identifier: GPL-2.0
>   obj-$(CONFIG_VDPA) += vdpa.o
>   obj-$(CONFIG_VDPA_SIM) += vdpa_sim/
> +obj-$(CONFIG_VDPA_USER) += vdpa_user/
>   obj-$(CONFIG_IFCVF)    += ifcvf/
>   obj-$(CONFIG_MLX5_VDPA) += mlx5/
>   obj-$(CONFIG_VP_VDPA)    += virtio_pci/
> diff --git a/drivers/vdpa/vdpa_user/Makefile b/drivers/vdpa/vdpa_user/Makefile
> new file mode 100644
> index 000000000000..260e0b26af99
> --- /dev/null
> +++ b/drivers/vdpa/vdpa_user/Makefile
> @@ -0,0 +1,5 @@
> +# SPDX-License-Identifier: GPL-2.0
> +
> +vduse-y := vduse_dev.o iova_domain.o
> +
> +obj-$(CONFIG_VDPA_USER) += vduse.o
> diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
> new file mode 100644
> index 000000000000..6addc62e7de6
> --- /dev/null
> +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> @@ -0,0 +1,1541 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * VDUSE: vDPA Device in Userspace
> + *
> + * Copyright (C) 2020-2021 Bytedance Inc. and/or its affiliates. All rights reserved.
> + *
> + * Author: Xie Yongji <xieyongji@bytedance.com>
> + *
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/cdev.h>
> +#include <linux/device.h>
> +#include <linux/eventfd.h>
> +#include <linux/slab.h>
> +#include <linux/wait.h>
> +#include <linux/dma-map-ops.h>
> +#include <linux/poll.h>
> +#include <linux/file.h>
> +#include <linux/uio.h>
> +#include <linux/vdpa.h>
> +#include <linux/nospec.h>
> +#include <uapi/linux/vduse.h>
> +#include <uapi/linux/vdpa.h>
> +#include <uapi/linux/virtio_config.h>
> +#include <uapi/linux/virtio_ids.h>
> +#include <uapi/linux/virtio_blk.h>
> +#include <linux/mod_devicetable.h>
> +
> +#include "iova_domain.h"
> +
> +#define DRV_AUTHOR   "Yongji Xie <xieyongji@bytedance.com>"
> +#define DRV_DESC     "vDPA Device in Userspace"
> +#define DRV_LICENSE  "GPL v2"
> +
> +#define VDUSE_DEV_MAX (1U << MINORBITS)
> +#define VDUSE_BOUNCE_SIZE (64 * 1024 * 1024)
> +#define VDUSE_IOVA_SIZE (128 * 1024 * 1024)
> +#define VDUSE_REQUEST_TIMEOUT 30


I think we need make this as a module parameter. 0 probably means we 
need to wait for ever.

This can help in the case when the userspace is attached by GDB. If 
Michael is still not happy, we can find other solution (e.g only offload 
the datapath).

Other looks good.

Thanks


