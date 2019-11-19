Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA4881011A4
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 04:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfKSDLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 22:11:36 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38060 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727112AbfKSDLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 22:11:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=v9f8BYCrMCJuV+Nhkx2R4CSxZOsMU8pABJUkn54/Xi8=; b=LvxH8Xuq2c0IZyx+D3Ts/Ytrd
        eZHESIkCIkIb6PpPUCUnXL0/MCj1EuD/F2wi1+J92H3qroHmkbdG0q+t+YwikmEaWgDswZrg6C+lD
        yRTwjvgyRWFiQksHIPH0NcVHm7+CzkeNIiTWBtOnSIqf/cen/E2GpMvo6dojXO3wQ4/Z93V8XyLeN
        1J1ksqNT2tpapUuOQY7Hi0yKa7N7Qy9aI0/WKH6r+Fb964rn+81KBAGvBuIF3NnzuEuYmIsAzcaJg
        gJ1p+xQ/dHPAr6O7bCW/A3ipd7pZ9Hdso3M0+13Cl5VWZh2ZTo7PlYrcePxbrdtrJyy7ioORMNki/
        3lym4fq7A==;
Received: from [2601:1c0:6280:3f0::5a22]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iWtvM-0000Up-M6; Tue, 19 Nov 2019 03:11:28 +0000
Subject: Re: [PATCH V13 3/6] mdev: move to drivers/
To:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, mst@redhat.com, tiwei.bie@intel.com,
        gregkh@linuxfoundation.org, jgg@mellanox.com
Cc:     netdev@vger.kernel.org, cohuck@redhat.com,
        maxime.coquelin@redhat.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, rob.miller@broadcom.com,
        xiao.w.wang@intel.com, haotian.wang@sifive.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, airlied@linux.ie, daniel@ffwll.ch,
        farman@linux.ibm.com, pasic@linux.ibm.com, sebott@linux.ibm.com,
        oberpar@linux.ibm.com, heiko.carstens@de.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        freude@linux.ibm.com, lingshan.zhu@intel.com, eperezma@redhat.com,
        lulu@redhat.com, parav@mellanox.com,
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com,
        stefanha@redhat.com, hch@infradead.org, aadam@redhat.com,
        jakub.kicinski@netronome.com, jiri@mellanox.com,
        jeffrey.t.kirsher@intel.com
References: <20191118105923.7991-1-jasowang@redhat.com>
 <20191118105923.7991-4-jasowang@redhat.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <195f2686-752c-67f0-0dba-04178a6f5dda@infradead.org>
Date:   Mon, 18 Nov 2019 19:11:26 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191118105923.7991-4-jasowang@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/19 2:59 AM, Jason Wang wrote:
> diff --git a/drivers/mdev/Kconfig b/drivers/mdev/Kconfig
> new file mode 100644
> index 000000000000..4561f2d4178f
> --- /dev/null
> +++ b/drivers/mdev/Kconfig
> @@ -0,0 +1,19 @@
> +
> +config MDEV
> +	tristate "Mediated device driver framework"
> +	default n
> +	help
> +	  Provides a framework to virtualize devices.
> +
> +	  If you don't know what do here, say N.
> +
> +config VFIO_MDEV
> +	tristate "VFIO Mediated device driver"
> +        depends on VFIO && MDEV
> +        default n

Use tab on the 2 lines above, not spaces.

> +	help
> +	  Proivdes a mediated BUS for userspace driver through VFIO

	  Provides

> +	  framework. See Documentation/vfio-mediated-device.txt for
> +	  more details.
> +
> +	  If you don't know what do here, say N.


-- 
~Randy

