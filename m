Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8EB1A61D5
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 05:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbgDMD6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 23:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:55076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728632AbgDMD57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 23:57:59 -0400
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com [205.139.110.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108FBC0086B6
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 20:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586750274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6N50RfIS2nCxFimWzt9WF72+xwJQvZPe8nfXlTQ11ak=;
        b=htorcfDPth6FL8HzeDImEy0Hy8Ho2mBEekvEuszT2F8xmx1++jepy6PRbWBNuS8Fvrtl5v
        W66wRzV4h0CSx4VKRn35RSgcjAzPaBoRzW/t2kwqA0US8CCs3M8MaMlDNezYEM7DoObI8v
        fWpS5woy8ZeBKnMXVQMoWgGEZJK5dH0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-9CvYkBqvNYWoIq_BU-OEfg-1; Sun, 12 Apr 2020 23:57:52 -0400
X-MC-Unique: 9CvYkBqvNYWoIq_BU-OEfg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C5E68017F3;
        Mon, 13 Apr 2020 03:57:51 +0000 (UTC)
Received: from [10.72.13.79] (ovpn-13-79.pek2.redhat.com [10.72.13.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D35497AE9;
        Mon, 13 Apr 2020 03:57:46 +0000 (UTC)
Subject: Re: [PATCH v2] vdpa: make vhost, virtio depend on menu
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
References: <20200412125018.74964-1-mst@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <1ccf929a-99fc-55ad-3613-146186399c2c@redhat.com>
Date:   Mon, 13 Apr 2020 11:57:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200412125018.74964-1-mst@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/12 =E4=B8=8B=E5=8D=888:50, Michael S. Tsirkin wrote:
> If user did not configure any vdpa drivers, neither vhost
> nor virtio vdpa are going to be useful. So there's no point
> in prompting for these and selecting vdpa core automatically.
> Simplify configuration by making virtio and vhost vdpa
> drivers depend on vdpa menu entry. Once done, we no longer
> need a separate menu entry, so also get rid of this.
> While at it, fix up the IFC entry: VDPA->vDPA for consistency
> with other places.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>
> changes from v1:
> 	fix up virtio vdpa Kconfig
>
>   drivers/vdpa/Kconfig   | 16 +++++-----------
>   drivers/vhost/Kconfig  |  2 +-
>   drivers/virtio/Kconfig |  2 +-
>   3 files changed, 7 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
> index d0cb0e583a5d..71d9a64f2c7d 100644
> --- a/drivers/vdpa/Kconfig
> +++ b/drivers/vdpa/Kconfig
> @@ -1,21 +1,16 @@
>   # SPDX-License-Identifier: GPL-2.0-only
> -config VDPA
> -	tristate
> +menuconfig VDPA
> +	tristate "vDPA drivers"
>   	help
>   	  Enable this module to support vDPA device that uses a
>   	  datapath which complies with virtio specifications with
>   	  vendor specific control path.
>  =20
> -menuconfig VDPA_MENU
> -	bool "VDPA drivers"
> -	default n
> -
> -if VDPA_MENU
> +if VDPA
>  =20
>   config VDPA_SIM
>   	tristate "vDPA device simulator"
>   	depends on RUNTIME_TESTING_MENU && HAS_DMA
> -	select VDPA
>   	select VHOST_RING
>   	select VHOST_IOTLB
>   	default n
> @@ -25,9 +20,8 @@ config VDPA_SIM
>   	  development of vDPA.
>  =20
>   config IFCVF
> -	tristate "Intel IFC VF VDPA driver"
> +	tristate "Intel IFC VF vDPA driver"
>   	depends on PCI_MSI
> -	select VDPA
>   	default n
>   	help
>   	  This kernel module can drive Intel IFC VF NIC to offload
> @@ -35,4 +29,4 @@ config IFCVF
>   	  To compile this driver as a module, choose M here: the module will
>   	  be called ifcvf.
>  =20
> -endif # VDPA_MENU
> +endif # VDPA
> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> index cb6b17323eb2..e79cbbdfea45 100644
> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -64,7 +64,7 @@ config VHOST_VDPA
>   	tristate "Vhost driver for vDPA-based backend"
>   	depends on EVENTFD
>   	select VHOST
> -	select VDPA
> +	depends on VDPA
>   	help
>   	  This kernel module can be loaded in host kernel to accelerate
>   	  guest virtio devices with the vDPA-based backends.
> diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
> index 2aadf398d8cc..395c3f4d49cb 100644
> --- a/drivers/virtio/Kconfig
> +++ b/drivers/virtio/Kconfig
> @@ -45,7 +45,7 @@ config VIRTIO_PCI_LEGACY
>  =20
>   config VIRTIO_VDPA
>   	tristate "vDPA driver for virtio devices"
> -	select VDPA
> +	depends on VDPA
>   	select VIRTIO
>   	help
>   	  This driver provides support for virtio based paravirtual

