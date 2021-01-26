Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D1A3037EF
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 09:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390127AbhAZIbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 03:31:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26899 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390143AbhAZIaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 03:30:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611649728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bhV4Mq5/sBWiSQk3XJm+QtpJxWDhek1THdWB8YUzVxE=;
        b=gS/m9471EbvRBZyAUCCPUVXUxK5gCojKY/vsj8/h+vbQ0HlQYrBUbMML4OK1NySGK2xnYz
        hYjRHj2HFNj3PWzXridt4BnTDIcD8DV1XfgaKhuWLyz6shG4byiqIzHEViFyT2s96xIdDI
        I3UBSV94NMWvYqgF3/lu+JPGv2wT7hM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83--4Inxhf7N6asR7JiI5xpBw-1; Tue, 26 Jan 2021 03:28:44 -0500
X-MC-Unique: -4Inxhf7N6asR7JiI5xpBw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EFFA310054FF;
        Tue, 26 Jan 2021 08:28:42 +0000 (UTC)
Received: from [10.72.12.70] (ovpn-12-70.pek2.redhat.com [10.72.12.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8B76672168;
        Tue, 26 Jan 2021 08:28:35 +0000 (UTC)
Subject: Re: [PATCH v3] vhost_vdpa: fix the problem in
 vhost_vdpa_set_config_call
To:     Cindy Lu <lulu@redhat.com>, mst@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20210126071607.31487-1-lulu@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <757a05d2-c82e-e957-1b7c-55eb64495f1b@redhat.com>
Date:   Tue, 26 Jan 2021 16:28:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210126071607.31487-1-lulu@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/26 下午3:16, Cindy Lu wrote:
> In vhost_vdpa_set_config_call, the cb.private should be vhost_vdpa.
> this cb.private will finally use in vhost_vdpa_config_cb as
> vhost_vdpa. Fix this issue.
>
> Cc: stable@vger.kernel.org
> Fixes: 776f395004d82 ("vhost_vdpa: Support config interrupt in vdpa")
> Signed-off-by: Cindy Lu <lulu@redhat.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vhost/vdpa.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index ef688c8c0e0e..3fbb9c1f49da 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -319,7 +319,7 @@ static long vhost_vdpa_set_config_call(struct vhost_vdpa *v, u32 __user *argp)
>   	struct eventfd_ctx *ctx;
>   
>   	cb.callback = vhost_vdpa_config_cb;
> -	cb.private = v->vdpa;
> +	cb.private = v;
>   	if (copy_from_user(&fd, argp, sizeof(fd)))
>   		return  -EFAULT;
>   

