Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52EA82F4299
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 04:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbhAMDkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 22:40:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33916 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726003AbhAMDkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 22:40:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610509125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fSaLRoG57KvO7g+HhBEQBIyCeK5sYiN7HkTE57zkReU=;
        b=WGu/K8aYD7DCrnGN7gDIRGROSZBEJEaOxP47+7gCAvYNsVF2AgL8ilT+1C3VFNcs535MgC
        YjUZ1aNVoaGNdzzu6EV//KVzUfSxh8FJivhu8opmIsaap8UlF2OCgu8riAOKJJIDCdS+hi
        2vNNsj7xw9TAIchRNythflXdJYQF0Po=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-LlhP_UCCPhyJ2DE4Q9BBuA-1; Tue, 12 Jan 2021 22:38:43 -0500
X-MC-Unique: LlhP_UCCPhyJ2DE4Q9BBuA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D45A805EE3;
        Wed, 13 Jan 2021 03:38:42 +0000 (UTC)
Received: from [10.72.12.205] (ovpn-12-205.pek2.redhat.com [10.72.12.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F370B60BFA;
        Wed, 13 Jan 2021 03:38:36 +0000 (UTC)
Subject: Re: [PATCH v3] vhost_vdpa: fix the problem in
 vhost_vdpa_set_config_call
To:     Cindy Lu <lulu@redhat.com>, mst@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        lingshan.zhu@intel.com
Cc:     stable@vger.kernel.org
References: <20210112053629.9853-1-lulu@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <1403c336-4493-255f-54e3-c55dd2015c40@redhat.com>
Date:   Wed, 13 Jan 2021 11:38:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210112053629.9853-1-lulu@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/12 下午1:36, Cindy Lu wrote:
> In vhost_vdpa_set_config_call, the cb.private should be vhost_vdpa.
> this cb.private will finally use in vhost_vdpa_config_cb as
> vhost_vdpa. Fix this issue.
>
> Fixes: 776f395004d82 ("vhost_vdpa: Support config interrupt in vdpa")
> Acked-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Cindy Lu <lulu@redhat.com>
> ---


Hi Cindy:

I think at least you forget to cc stable.

Thanks


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

