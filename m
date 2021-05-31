Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9410739569D
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 09:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbhEaH77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 03:59:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49539 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229640AbhEaH75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 03:59:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622447894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EdRsDMw4H1zTHoV4Q0DDi+MXBcsk6roz9PziidrlNag=;
        b=DnqUoRAy4Uqw1XaHjWu3Kw3vuvVNS1jH6yTUe1z2TWGbaaWKr0aHglMEl29BbYKR3ij8t0
        N2Mv1E24gEhb51fgWifKSjAe94EN7onPgmzj59OiiiZ7+3qo1KWZtHvZh0fTvL2V9nBv+A
        sLqr2l+qrnQevTfG/W5iOm37aTVQN0k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-I3OLvASbNja5hRImbNs9cg-1; Mon, 31 May 2021 03:58:12 -0400
X-MC-Unique: I3OLvASbNja5hRImbNs9cg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C7F8107ACCA;
        Mon, 31 May 2021 07:58:11 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-190.ams2.redhat.com [10.36.113.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F0D91E6;
        Mon, 31 May 2021 07:58:07 +0000 (UTC)
Date:   Mon, 31 May 2021 09:58:04 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH RESEND 1/2] virtio: update virtio id table, add
 transitional ids
Message-ID: <20210531095804.47629646.cohuck@redhat.com>
In-Reply-To: <20210531072743.363171-2-lingshan.zhu@intel.com>
References: <20210531072743.363171-1-lingshan.zhu@intel.com>
        <20210531072743.363171-2-lingshan.zhu@intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 May 2021 15:27:42 +0800
Zhu Lingshan <lingshan.zhu@intel.com> wrote:

> This commit updates virtio id table by adding transitional device
> ids
> 
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  include/uapi/linux/virtio_ids.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/include/uapi/linux/virtio_ids.h b/include/uapi/linux/virtio_ids.h
> index f0c35ce8628c..fcc9ec6a73c1 100644
> --- a/include/uapi/linux/virtio_ids.h
> +++ b/include/uapi/linux/virtio_ids.h
> @@ -57,4 +57,16 @@
>  #define VIRTIO_ID_BT			28 /* virtio bluetooth */
>  #define VIRTIO_ID_MAC80211_HWSIM	29 /* virtio mac80211-hwsim */
>  
> +/*
> + * Virtio Transitional IDs
> + */
> +
> +#define VIRTIO_TRANS_ID_NET		1000 /* transitional virtio net */
> +#define VIRTIO_TRANS_ID_BLOCK		1001 /* transitional virtio block */
> +#define VIRTIO_TRANS_ID_BALLOON		1002 /* transitional virtio balloon */
> +#define VIRTIO_TRANS_ID_CONSOLE		1003 /* transitional virtio console */
> +#define VIRTIO_TRANS_ID_SCSI		1004 /* transitional virtio SCSI */
> +#define VIRTIO_TRANS_ID_RNG		1005 /* transitional virtio rng */
> +#define VIRTIO_TRANS_ID_9P		1009 /* transitional virtio 9p console */
> +
>  #endif /* _LINUX_VIRTIO_IDS_H */

Isn't this a purely virtio-pci concept? (The spec lists the virtio ids
in the common section, and those transitional ids in the pci section.)
IOW, is there a better, virtio-pci specific, header for this?

