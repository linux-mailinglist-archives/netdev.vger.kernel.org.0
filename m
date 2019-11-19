Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4E251011B7
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 04:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727737AbfKSDNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 22:13:11 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38176 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727535AbfKSDNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 22:13:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=w1ly8URM0uOTflt/kZy0TJgrnspB9XQu8w6aCtnLvW8=; b=KtVyMulpSnDq9tntYDC+RCTtm
        3c6gDhbbLXKTBKKG74KEtprK1lDyXcTafqs2dcpktR3n0+xokaPZNR9T5WyQjEbwEdEds3DhdXZ4d
        0Ro+8OLmVNDYLs9rZ1FpweXI1r26UTL/od3f2b/k1dap9wL/AKYGlAU9fmVHeSYf8OgCg6OS9baB+
        Us/Iy6vf8X/rVjc52xbJxiW7osJxNcjlB9jznCRfyQadI2nKpiDMU1fQWMwvqMOxKn5n6uOTzoE0i
        neVNEEJz7xBHo/L5sPOuSyVX1gF3xDEMd74hnHPXbJjX5qIccAbE088ZoeCm3qSzLSOhtcykJek+c
        YsXsmBv6A==;
Received: from [2601:1c0:6280:3f0::5a22]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iWtwt-0000dD-JO; Tue, 19 Nov 2019 03:13:03 +0000
Subject: Re: [PATCH V13 4/6] mdev: introduce mediated virtio bus
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
 <20191118105923.7991-5-jasowang@redhat.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <6c5f6e9e-0a4a-f514-2c26-08476b9a09f8@infradead.org>
Date:   Mon, 18 Nov 2019 19:13:01 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191118105923.7991-5-jasowang@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 11/18/19 2:59 AM, Jason Wang wrote:
> diff --git a/drivers/mdev/Kconfig b/drivers/mdev/Kconfig
> index 4561f2d4178f..cd84d4670552 100644
> --- a/drivers/mdev/Kconfig
> +++ b/drivers/mdev/Kconfig
> @@ -17,3 +17,13 @@ config VFIO_MDEV
>  	  more details.
>  
>  	  If you don't know what do here, say N.
> +
> +config MDEV_VIRTIO
> +       tristate "Mediated VIRTIO bus"
> +       depends on VIRTIO && MDEV
> +       default n
> +       help
> +	  Proivdes a mediated BUS for virtio. It could be used by

	  Provides

> +          either kenrel driver or userspace driver.

	            kernel

> +
> +	  If you don't know what do here, say N.

All of these lines should be indented with one tab, not spaces.

-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
