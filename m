Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E153D23EF
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 14:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbhGVMOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 08:14:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37914 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232088AbhGVMOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 08:14:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626958526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1CwiWu4T1TCrXr2lCQ50ReEt7fD3KW4sYxtYxQrRVQw=;
        b=HNSdtCwtJBLsLZ5BQD7d8VFqKcpukwNAtSpWdo2eqVRx7BIrbo83VVjwmivl/+oZpem7Zj
        i2qjqLsVRenc3X8iPP9b/1jg8crkaIw57X95joqVFLrGgksiQbuGSXFfawXJpGYF+TE4Y3
        zIzuMlzaI6vRv7EIMWSiv01b84gpNkc=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-7_SeR49POryR-i5dBEPhEQ-1; Thu, 22 Jul 2021 08:55:23 -0400
X-MC-Unique: 7_SeR49POryR-i5dBEPhEQ-1
Received: by mail-ej1-f72.google.com with SMTP id e23-20020a1709062497b0290504bafdd58dso1785125ejb.4
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 05:55:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1CwiWu4T1TCrXr2lCQ50ReEt7fD3KW4sYxtYxQrRVQw=;
        b=d9+Qbu1mzivzksHpDrGh7TsPa3FNbyee0D2EKhqIMOTwbU0nQGuSOOElRf5OANAnMy
         WJBfMwL7pj5rOof6bghHHxtPcHdrpbnPWrDFVMXnZkXt7BTSeJ0ZaHKHuFrBqX3YTmCo
         6Aiq+Y9+lEciqlfZFCstLtMGGGDQkLwCsPs5lk+0yE0ahLk4NaPjvJ/g+UQ0Nu2++J3R
         r2aAMvCokOkATStFS74j4l4hvnhvu40nRwm/KiEPLG/OWvAEoOFrcOkiWWZf72c6K3sR
         2KoDap27OexaPPDKmxFJ0ESBKbg10Ic1rhmenXzsc+S4cPu2OZv9PTCGEbIIB5njkhA6
         Oepg==
X-Gm-Message-State: AOAM533r2CYc6QyLN6mTmdoRkY08BGu8vAaHGaPtxYqgg0Es2L1F3IhK
        bGhdkDyVenOWmKAj6dDHuaRuZR0ebC/3EFhrVkkD18IgWoxEht3UGUW/vFA60Yg9yHJ5A7LR37B
        CE/raq2XRxfNr7aZL
X-Received: by 2002:a17:906:4b47:: with SMTP id j7mr43399493ejv.104.1626958522044;
        Thu, 22 Jul 2021 05:55:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQU28JFAqvNmUaGfaHpdW27wO3IJ4E+xBiNDz/aPu1UOIaWniwAJM4pJxCmsaa9I5ynqJCHA==
X-Received: by 2002:a17:906:4b47:: with SMTP id j7mr43399477ejv.104.1626958521846;
        Thu, 22 Jul 2021 05:55:21 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id g11sm12413592edt.85.2021.07.22.05.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 05:55:21 -0700 (PDT)
Date:   Thu, 22 Jul 2021 14:55:19 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org, Ram Muthiah <rammuthiah@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, jiang.wang@bytedance.com
Subject: Re: [PATCH 1/1] virtio/vsock: Make vsock virtio packet buff size
 configurable
Message-ID: <20210722125519.jzs7crke7yqfh73e@steredhat>
References: <20210721143001.182009-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210721143001.182009-1-lee.jones@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 03:30:00PM +0100, Lee Jones wrote:
>From: Ram Muthiah <rammuthiah@google.com>
>
>After a virtual device has been running for some time, the SLAB
>sustains ever increasing fragmentation. Contributing to this
>fragmentation are the virtio packet buffer allocations which
>are a drain on 64Kb compound pages. Eventually these can't be
>allocated due to fragmentation.
>
>To enable successful allocations for this packet buffer, the
>packet buffer's size needs to be reduced.
>
>In order to enable a reduction without impacting current users,
>this variable is being exposed as a command line parameter.
>
>Cc: "Michael S. Tsirkin" <mst@redhat.com>
>Cc: Jason Wang <jasowang@redhat.com>
>Cc: Stefan Hajnoczi <stefanha@redhat.com>
>Cc: Stefano Garzarella <sgarzare@redhat.com>
>Cc: "David S. Miller" <davem@davemloft.net>
>Cc: Jakub Kicinski <kuba@kernel.org>
>Cc: virtualization@lists.linux-foundation.org
>Cc: kvm@vger.kernel.org
>Cc: netdev@vger.kernel.org
>Signed-off-by: Ram Muthiah <rammuthiah@google.com>
>Signed-off-by: Lee Jones <lee.jones@linaro.org>
>---
> include/linux/virtio_vsock.h            | 4 +++-
> net/vmw_vsock/virtio_transport_common.c | 4 ++++
> 2 files changed, 7 insertions(+), 1 deletion(-)
>
>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>index 35d7eedb5e8e4..8c77d60a74d34 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -7,9 +7,11 @@
> #include <net/sock.h>
> #include <net/af_vsock.h>
>
>+extern uint virtio_transport_max_vsock_pkt_buf_size;
>+
> #define VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE	(1024 * 4)
> #define VIRTIO_VSOCK_MAX_BUF_SIZE		0xFFFFFFFFUL
>-#define VIRTIO_VSOCK_MAX_PKT_BUF_SIZE		(1024 * 64)
>+#define VIRTIO_VSOCK_MAX_PKT_BUF_SIZE		virtio_transport_max_vsock_pkt_buf_size
>
> enum {
> 	VSOCK_VQ_RX     = 0, /* for host to guest data */
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 169ba8b72a630..d0d913afec8b6 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -26,6 +26,10 @@
> /* Threshold for detecting small packets to copy */
> #define GOOD_COPY_LEN  128
>
>+uint virtio_transport_max_vsock_pkt_buf_size = 1024 * 64;
>+module_param(virtio_transport_max_vsock_pkt_buf_size, uint, 0444);
>+EXPORT_SYMBOL_GPL(virtio_transport_max_vsock_pkt_buf_size);
>+

Maybe better to add an entry under sysfs similar to what Jiang proposed 
here:
https://lists.linuxfoundation.org/pipermail/virtualization/2021-June/054769.html

Thanks,
Stefano

