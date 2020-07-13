Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04E8021D1B6
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 10:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbgGMI3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 04:29:18 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:46461 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725830AbgGMI3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 04:29:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594628956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2EP1wYFVmWWtdehI67MqaS4RP11/+pSykSlwf0ANA6o=;
        b=KJpAO/M0aAgLoeL0qrNNP0lMtBGp66QcJRz3AcMo+qT+NGKfXvC0UdRPCYEZIjAW3iORl4
        +pyQvNj/QJtHCXFYsDy6wtRNs8mONIehHvUVRx7iSCMXB1i3yFEhy/tJfBk+d8tX+DfYjv
        07MT10c/AyiVLpOrkWvTFl+NITrSwi8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-4g4OQ4hlOxG33hYQB2ee9g-1; Mon, 13 Jul 2020 04:29:15 -0400
X-MC-Unique: 4g4OQ4hlOxG33hYQB2ee9g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDFF61080;
        Mon, 13 Jul 2020 08:29:13 +0000 (UTC)
Received: from [10.72.13.177] (ovpn-13-177.pek2.redhat.com [10.72.13.177])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F84C6FEF3;
        Mon, 13 Jul 2020 08:28:58 +0000 (UTC)
Subject: Re: [PATCH 5/7] virtio_vdpa: init IRQ offloading function pointers to
 NULL.
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        alex.williamson@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com
References: <1594565366-3195-1-git-send-email-lingshan.zhu@intel.com>
 <1594565366-3195-5-git-send-email-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <276bf939-8e12-e28a-64f7-1767851e0db5@redhat.com>
Date:   Mon, 13 Jul 2020 16:28:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1594565366-3195-5-git-send-email-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/7/12 下午10:49, Zhu Lingshan wrote:
> This commit initialize IRQ offloading function pointers in
> virtio_vdpa_driver to NULL. Becasue irq offloading only focus
> on VMs for vhost_vdpa.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>   drivers/virtio/virtio_vdpa.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
> index c30eb55..1e8acb9 100644
> --- a/drivers/virtio/virtio_vdpa.c
> +++ b/drivers/virtio/virtio_vdpa.c
> @@ -386,6 +386,8 @@ static void virtio_vdpa_remove(struct vdpa_device *vdpa)
>   	},
>   	.probe	= virtio_vdpa_probe,
>   	.remove = virtio_vdpa_remove,
> +	.setup_vq_irq = NULL,
> +	.unsetup_vq_irq = NULL,
>   };


Is this really needed consider the it's static?

Thanks


>   
>   module_vdpa_driver(virtio_vdpa_driver);

