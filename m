Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1F12F269D
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 04:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbhALDSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 22:18:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56786 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726386AbhALDSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 22:18:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610421429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vdL9xijqYhEmBrknuY6rf1ZBEjGj8lHKRm8qxVj2FtM=;
        b=aUdccw8NJp5L6FBcKOF5NWBoCjSsCEg4sL5A5Gu788DFtRkHw9JhgliEUivi0ueXWaqbJJ
        tnxiQiMxRRIhuMUTLQBF/XnFbss9Gsmd7jjoCI/q9N+TG06k/Q++iIMXKzaqFrb+GF+tyz
        NhNCRV42S8/hCeAi2LNVskVTztgj97M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-vEyIChIWN3OhI1Lu5P_qaA-1; Mon, 11 Jan 2021 22:17:07 -0500
X-MC-Unique: vEyIChIWN3OhI1Lu5P_qaA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70C15107ACFB;
        Tue, 12 Jan 2021 03:17:06 +0000 (UTC)
Received: from [10.72.12.225] (ovpn-12-225.pek2.redhat.com [10.72.12.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 45FA96A8F9;
        Tue, 12 Jan 2021 03:17:03 +0000 (UTC)
Subject: Re: [PATCH v1] vhost_vdpa: fix the problem in
 vhost_vdpa_set_config_call
To:     Cindy Lu <lulu@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        lingshan.zhu@intel.com
References: <20210112024648.31428-1-lulu@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <7045438c-2f8b-b804-81bd-f9a5cf6e20bb@redhat.com>
Date:   Tue, 12 Jan 2021 11:17:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210112024648.31428-1-lulu@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/12 上午10:46, Cindy Lu wrote:
> in vhost_vdpa_set_config_call, the cb.private should be vhost_vdpa.


Should be "In"


> this cb.private will finally use in vhost_vdpa_config_cb as
> vhost_vdpa.Fix this issue


An whitespace is needed before Fix and a full stop after "issue"

Fixes: 776f395004d82 ("vhost_vdpa: Support config interrupt in vdpa")

Acked-by: Jason Wang <jasowang@redhat.com>

Please post a V2 with the above fixed and cc stable.

Thanks


>
> Signed-off-by: Cindy Lu <lulu@redhat.com>
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

