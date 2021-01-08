Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908632EF318
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 14:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbhAHNeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 08:34:06 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50544 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbhAHNeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 08:34:04 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 108DPdUd109883;
        Fri, 8 Jan 2021 13:32:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=S4zkW1M4aTxRNcJblTq8nmnAoFttecuVr7DB3iYS6lc=;
 b=u43BWw/YI46k+PZDdz6WgFXEaetk1U74Zlf6i1GzYDfBCjp2TclctQZfEm69hfePQ3lF
 cLN/e1XxgUS2OeTwOaaTys0uRP1vUFZEKV3i/6tXp/NaKhytTrPuVZ8wiGwQCbSUbxys
 P60h0XHWLot0qHkXh9mVOxr89HvQ6nVgMAvA+OPttZmzmXyf+fgt3zfqNS5eqXGIFtig
 uyVdf/PpYc/lmKRfaqoHjE5emwYXEjn20lwGfJZRlhSkp6SrMtJaxZ1JWh9NwbiwE/Ov
 FjYEbhHZEolr0NNoVTS9y8SvZnd50yp4LcmRpMM97dXdvLPbhRCG7O4hC+MoKZ+oUAW+ Rg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 35wepmh24m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 08 Jan 2021 13:32:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 108DKYVC100966;
        Fri, 8 Jan 2021 13:32:42 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 35v4rfafy5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jan 2021 13:32:42 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 108DWXDO026007;
        Fri, 8 Jan 2021 13:32:33 GMT
Received: from [192.168.1.6] (/116.231.20.68)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Jan 2021 13:32:33 +0000
Subject: Re: [RFC v2 06/13] vduse: Introduce VDUSE - vDPA Device in Userspace
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        jasowang@redhat.com, stefanha@redhat.com, sgarzare@redhat.com,
        parav@nvidia.com, akpm@linux-foundation.org, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20201222145221.711-1-xieyongji@bytedance.com>
 <20201222145221.711-7-xieyongji@bytedance.com>
From:   Bob Liu <bob.liu@oracle.com>
Message-ID: <f8dcb8d0-0024-1f78-d1a7-e487ca3deda7@oracle.com>
Date:   Fri, 8 Jan 2021 21:32:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201222145221.711-7-xieyongji@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080076
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1011 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080076
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/22/20 10:52 PM, Xie Yongji wrote:
> This VDUSE driver enables implementing vDPA devices in userspace.
> Both control path and data path of vDPA devices will be able to
> be handled in userspace.
> 
> In the control path, the VDUSE driver will make use of message
> mechnism to forward the config operation from vdpa bus driver
> to userspace. Userspace can use read()/write() to receive/reply
> those control messages.
> 
> In the data path, the VDUSE driver implements a MMU-based on-chip
> IOMMU driver which supports mapping the kernel dma buffer to a
> userspace iova region dynamically. Userspace can access those
> iova region via mmap(). Besides, the eventfd mechanism is used to
> trigger interrupt callbacks and receive virtqueue kicks in userspace
> 
> Now we only support virtio-vdpa bus driver with this patch applied.
> 
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>  Documentation/driver-api/vduse.rst                 |   74 ++
>  Documentation/userspace-api/ioctl/ioctl-number.rst |    1 +
>  drivers/vdpa/Kconfig                               |    8 +
>  drivers/vdpa/Makefile                              |    1 +
>  drivers/vdpa/vdpa_user/Makefile                    |    5 +
>  drivers/vdpa/vdpa_user/eventfd.c                   |  221 ++++
>  drivers/vdpa/vdpa_user/eventfd.h                   |   48 +
>  drivers/vdpa/vdpa_user/iova_domain.c               |  442 ++++++++
>  drivers/vdpa/vdpa_user/iova_domain.h               |   93 ++
>  drivers/vdpa/vdpa_user/vduse.h                     |   59 ++
>  drivers/vdpa/vdpa_user/vduse_dev.c                 | 1121 ++++++++++++++++++++
>  include/uapi/linux/vdpa.h                          |    1 +
>  include/uapi/linux/vduse.h                         |   99 ++
>  13 files changed, 2173 insertions(+)
>  create mode 100644 Documentation/driver-api/vduse.rst
>  create mode 100644 drivers/vdpa/vdpa_user/Makefile
>  create mode 100644 drivers/vdpa/vdpa_user/eventfd.c
>  create mode 100644 drivers/vdpa/vdpa_user/eventfd.h
>  create mode 100644 drivers/vdpa/vdpa_user/iova_domain.c
>  create mode 100644 drivers/vdpa/vdpa_user/iova_domain.h
>  create mode 100644 drivers/vdpa/vdpa_user/vduse.h
>  create mode 100644 drivers/vdpa/vdpa_user/vduse_dev.c
>  create mode 100644 include/uapi/linux/vduse.h
> 
> diff --git a/Documentation/driver-api/vduse.rst b/Documentation/driver-api/vduse.rst
> new file mode 100644
> index 000000000000..da9b3040f20a
> --- /dev/null
> +++ b/Documentation/driver-api/vduse.rst
> @@ -0,0 +1,74 @@
> +==================================
> +VDUSE - "vDPA Device in Userspace"
> +==================================
> +
> +vDPA (virtio data path acceleration) device is a device that uses a
> +datapath which complies with the virtio specifications with vendor
> +specific control path. vDPA devices can be both physically located on
> +the hardware or emulated by software. VDUSE is a framework that makes it
> +possible to implement software-emulated vDPA devices in userspace.
> +

Could you explain a bit more why need a VDUSE framework?
Software emulated vDPA devices is more likely used by debugging only when
don't have real hardware.
Do you think do the emulation in kernel space is not enough?

Thanks,
Bob

> +How VDUSE works
> +------------
> +Each userspace vDPA device is created by the VDUSE_CREATE_DEV ioctl on
> +the VDUSE character device (/dev/vduse). Then a file descriptor pointing
> +to the new resources will be returned, which can be used to implement the
> +userspace vDPA device's control path and data path.
> +
> +To implement control path, the read/write operations to the file descriptor
> +will be used to receive/reply the control messages from/to VDUSE driver.
> +Those control messages are based on the vdpa_config_ops which defines a
> +unified interface to control different types of vDPA device.
> +


