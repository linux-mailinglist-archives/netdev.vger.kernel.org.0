Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0083A9418
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 09:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbhFPHg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 03:36:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30439 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231179AbhFPHg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 03:36:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623828860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VNd5rq7O+X7v4DbfCG2yqBupZLQdBei7SCAcvGOKyO8=;
        b=Tq/JnAQpHXF1dUkLTHZpVfQi6HC40O+le8S67XorH/AxOGlXZcDbbfm6mziSVqHOadzD+8
        ZXtWDCGN8w1UgNyzNOTU36t4kWaRXJfsTePRqXsb7hQu2julECaE0MRUpS9eLHORXtzs6q
        HlHBS3O10PVHbkLkAor6168KRGcXnDI=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-xi3h_CojPcGZqn0w8C_wNg-1; Wed, 16 Jun 2021 03:34:18 -0400
X-MC-Unique: xi3h_CojPcGZqn0w8C_wNg-1
Received: by mail-pf1-f197.google.com with SMTP id p190-20020a625bc70000b02902fb3dbe05a2so1061681pfb.21
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 00:34:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=VNd5rq7O+X7v4DbfCG2yqBupZLQdBei7SCAcvGOKyO8=;
        b=PY1X1f6aZVaQfzP5ypbyTjF77Rmu4U8gcIxmyUS0fnZ+17tKr+c8KXH6DklpNHnOvw
         ivqsIQlIZHdA6k5KmHprbXpNHWFjxi+ylUw9OljsOSVl+iH/WdiSjfFpYtniPsk4Yt8E
         Pt8rtlrwtp5m2JuFtcB9kb4wh9fwcdVDmmIg0WMni+xuubHfe+Xa2HZyo9vUJFFUfIUE
         0wnbsHsHAQ2z7RPoWjPmScwOrqsvMhktvn2SXOgjxZry/RcxbHvF9GkTfXOtqwLI7A7w
         B5TqzMVTnsJQAUwplXXHe8PjWQxaaHjw/yJMaZhc5f6u+MzV1OhyXKpkeuzdpML3gse3
         Ahcg==
X-Gm-Message-State: AOAM533XFcJgz4RXt+cLHqV2tnjo0VKQjK4E4YG2W1sTqWu8Zb2ddu4t
        UDDIF3FG1ouSEJzU1f/KUYvV5nT2PQp9/B4coZQgJS96e3lDMU0aVa4Dk1R9F96tDlnokjzLStz
        sQucE6+Fbkxf6Vsk3
X-Received: by 2002:a63:31c2:: with SMTP id x185mr3680260pgx.97.1623828857762;
        Wed, 16 Jun 2021 00:34:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxpWj9mu7EPVo9Xizh8HgAiHa9lTv3v0OYAjKCalyAeUEevOz3ooK6fJp6k/Gioc3mz2dTXug==
X-Received: by 2002:a63:31c2:: with SMTP id x185mr3680240pgx.97.1623828857481;
        Wed, 16 Jun 2021 00:34:17 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g6sm1277967pfq.110.2021.06.16.00.34.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jun 2021 00:34:16 -0700 (PDT)
Subject: Re: [PATCH net-next v5 10/15] virtio-net: independent directory
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        "dust . li" <dust.li@linux.alibaba.com>
References: <20210610082209.91487-1-xuanzhuo@linux.alibaba.com>
 <20210610082209.91487-11-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e43d40ab-7a5a-c6f7-979b-95a379bba170@redhat.com>
Date:   Wed, 16 Jun 2021 15:34:09 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210610082209.91487-11-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/6/10 ÏÂÎç4:22, Xuan Zhuo Ð´µÀ:
> Create a separate directory for virtio-net. AF_XDP support will be added
> later, and a separate xsk.c file will be added.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   MAINTAINERS                           |  2 +-
>   drivers/net/Kconfig                   |  8 +-------
>   drivers/net/Makefile                  |  2 +-
>   drivers/net/virtio/Kconfig            | 11 +++++++++++
>   drivers/net/virtio/Makefile           |  6 ++++++
>   drivers/net/{ => virtio}/virtio_net.c |  0
>   6 files changed, 20 insertions(+), 9 deletions(-)
>   create mode 100644 drivers/net/virtio/Kconfig
>   create mode 100644 drivers/net/virtio/Makefile
>   rename drivers/net/{ => virtio}/virtio_net.c (100%)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e69c1991ec3b..2041267f19f1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -19344,7 +19344,7 @@ S:	Maintained
>   F:	Documentation/devicetree/bindings/virtio/
>   F:	drivers/block/virtio_blk.c
>   F:	drivers/crypto/virtio/
> -F:	drivers/net/virtio_net.c
> +F:	drivers/net/virtio/
>   F:	drivers/vdpa/
>   F:	drivers/virtio/
>   F:	include/linux/vdpa.h
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index 4da68ba8448f..2297fe4183ae 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -392,13 +392,7 @@ config VETH
>   	  When one end receives the packet it appears on its pair and vice
>   	  versa.
>   
> -config VIRTIO_NET
> -	tristate "Virtio network driver"
> -	depends on VIRTIO
> -	select NET_FAILOVER
> -	help
> -	  This is the virtual network driver for virtio.  It can be used with
> -	  QEMU based VMMs (like KVM or Xen).  Say Y or M.
> +source "drivers/net/virtio/Kconfig"
>   
>   config NLMON
>   	tristate "Virtual netlink monitoring device"
> diff --git a/drivers/net/Makefile b/drivers/net/Makefile
> index 7ffd2d03efaf..c4c7419e0398 100644
> --- a/drivers/net/Makefile
> +++ b/drivers/net/Makefile
> @@ -28,7 +28,7 @@ obj-$(CONFIG_NET_TEAM) += team/
>   obj-$(CONFIG_TUN) += tun.o
>   obj-$(CONFIG_TAP) += tap.o
>   obj-$(CONFIG_VETH) += veth.o
> -obj-$(CONFIG_VIRTIO_NET) += virtio_net.o
> +obj-$(CONFIG_VIRTIO_NET) += virtio/
>   obj-$(CONFIG_VXLAN) += vxlan.o
>   obj-$(CONFIG_GENEVE) += geneve.o
>   obj-$(CONFIG_BAREUDP) += bareudp.o
> diff --git a/drivers/net/virtio/Kconfig b/drivers/net/virtio/Kconfig
> new file mode 100644
> index 000000000000..9bc2a2fc6c3e
> --- /dev/null
> +++ b/drivers/net/virtio/Kconfig
> @@ -0,0 +1,11 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +#
> +# virtio-net device configuration
> +#
> +config VIRTIO_NET
> +	tristate "Virtio network driver"
> +	depends on VIRTIO
> +	select NET_FAILOVER
> +	help
> +	  This is the virtual network driver for virtio.  It can be used with
> +	  QEMU based VMMs (like KVM or Xen).  Say Y or M.
> diff --git a/drivers/net/virtio/Makefile b/drivers/net/virtio/Makefile
> new file mode 100644
> index 000000000000..ccc80f40f33a
> --- /dev/null
> +++ b/drivers/net/virtio/Makefile
> @@ -0,0 +1,6 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Makefile for the virtio network device drivers.
> +#
> +
> +obj-$(CONFIG_VIRTIO_NET) += virtio_net.o
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio/virtio_net.c
> similarity index 100%
> rename from drivers/net/virtio_net.c
> rename to drivers/net/virtio/virtio_net.c

