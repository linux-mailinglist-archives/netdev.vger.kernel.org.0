Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 720AB43B5A9
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 17:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236950AbhJZPfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 11:35:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49367 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231789AbhJZPe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 11:34:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635262355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gbVc7HOWJ2PFCnEywyz6wgN+/dC0LKc2fgos1ZmjSsE=;
        b=anumQXEnQAAygIZODRCG76ITpD5U3XqFgKA2riBjChX8Vjp3GnhrqvPhI667WUiKk/ZBvO
        IFHoxccIqNOOM/R6S7j6HatkESKOwvxEdgbVQ8jsva148MJubVOrsPlCEewVCZUt7on+2L
        YTFSOv7AyXxgsa3mInvQDRgs51jcK50=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-542-KfQH3nG9O-CMB1esLnYaRQ-1; Tue, 26 Oct 2021 11:32:30 -0400
X-MC-Unique: KfQH3nG9O-CMB1esLnYaRQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F612100C609;
        Tue, 26 Oct 2021 15:32:28 +0000 (UTC)
Received: from localhost (unknown [10.39.193.201])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0CA281981F;
        Tue, 26 Oct 2021 15:32:23 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        bhelgaas@google.com, jgg@nvidia.com, saeedm@nvidia.com
Cc:     linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, yishaih@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH V4 mlx5-next 06/13] vfio: Fix
 VFIO_DEVICE_STATE_SET_ERROR macro
In-Reply-To: <20211026090605.91646-7-yishaih@nvidia.com>
Organization: Red Hat GmbH
References: <20211026090605.91646-1-yishaih@nvidia.com>
 <20211026090605.91646-7-yishaih@nvidia.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Tue, 26 Oct 2021 17:32:19 +0200
Message-ID: <87pmrrdcos.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26 2021, Yishai Hadas <yishaih@nvidia.com> wrote:

> Fixed the non-compiled macro VFIO_DEVICE_STATE_SET_ERROR (i.e. SATE
> instead of STATE).
>
> Fixes: a8a24f3f6e38 ("vfio: UAPI for migration interface for device state")
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

This s-o-b chain looks weird; your s-o-b always needs to be last.

> ---
>  include/uapi/linux/vfio.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index ef33ea002b0b..114ffcefe437 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -622,7 +622,7 @@ struct vfio_device_migration_info {
>  					      VFIO_DEVICE_STATE_RESUMING))
>  
>  #define VFIO_DEVICE_STATE_SET_ERROR(state) \
> -	((state & ~VFIO_DEVICE_STATE_MASK) | VFIO_DEVICE_SATE_SAVING | \
> +	((state & ~VFIO_DEVICE_STATE_MASK) | VFIO_DEVICE_STATE_SAVING | \
>  					     VFIO_DEVICE_STATE_RESUMING)
>  
>  	__u32 reserved;

Change looks fine, although we might consider merging it with the next
patch? Anyway,

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

