Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D167123CC2E
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 18:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgHEQ3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 12:29:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50073 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726402AbgHEQ1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 12:27:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596644839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=536n/y6iFl/5D6nOT9vy92U02GWyC/k+fDxzVf0r1Qs=;
        b=gFeUZxjzixI5JA3CYll0ExjWTDcYKG/MNwXk3LbeMWHf1Wym3QQuQpiXzbVjfkju+ruo5q
        VwVydksLUUInVFF49A4hV1ehubUil47nq/OBptIGwLVggSjTCNPyhf8OvD7vfGpecEHLgK
        GQIy++fVNt2vwPHXMcV6S1dT74UeAag=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-ZUfSqFHyMZiVjF5Cb7MfsA-1; Wed, 05 Aug 2020 07:53:45 -0400
X-MC-Unique: ZUfSqFHyMZiVjF5Cb7MfsA-1
Received: by mail-wm1-f71.google.com with SMTP id h6so2365113wml.8
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 04:53:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=536n/y6iFl/5D6nOT9vy92U02GWyC/k+fDxzVf0r1Qs=;
        b=GwyuW+5l9TVZS+5eoqYbl87ZeyACrqbs++vEbju9GhEcbZDCZJIPOwqkjkf2NNfQKo
         7jV05PJGqtIRyzY8TZ4sXPNqrQqci+GdFOoubxInrlyX5two4o4NBxqxPFBk6x19/N3b
         F7/L/X+uS/XU0IcSiszR54MdkaQ70B217CVo/iWRXGrJU1em4xltuza1FTIcfyhyp68C
         Ls/55+zG5YvQu4R0vKe/3JoM62KPCXjAdNpOd+W9sEphpLDs34jFMJwvSYl/x1qmmGH3
         5JgnT98lSuJj+KYvZNGa+F6bTaHgSwVhXuBSEQOCgunPDlc0ki+axkjiyFH/P33/Q9o2
         YxHQ==
X-Gm-Message-State: AOAM533ziwGC351/9Sav1y27CWK7hmAGzI7FnoaDRWFY/+lym1OmC1cu
        grM5VCGwj7K+YBlamr9fsBbfWWH/nEAVf5faIcWK5+Oyk1Jk2Up7ZNBOA0Ciz2m6/RxeeBY20cu
        hDEVeqAPIWKCMqBRk
X-Received: by 2002:a1c:c345:: with SMTP id t66mr2959884wmf.0.1596628424848;
        Wed, 05 Aug 2020 04:53:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx+wbkOm3jDct7STQrMsu6ZusEOvveaPFmID5XQoyiqlXiOd8CqLKRq0y1l+w8OoRQyu4N5ow==
X-Received: by 2002:a1c:c345:: with SMTP id t66mr2959868wmf.0.1596628424612;
        Wed, 05 Aug 2020 04:53:44 -0700 (PDT)
Received: from redhat.com (bzq-79-180-0-181.red.bezeqint.net. [79.180.0.181])
        by smtp.gmail.com with ESMTPSA id v15sm2493810wrm.23.2020.08.05.04.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 04:53:43 -0700 (PDT)
Date:   Wed, 5 Aug 2020 07:53:41 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org, eli@mellanox.com,
        shahafs@mellanox.com, parav@mellanox.com
Subject: Re: [PATCH 2/2] vhost_vdpa: unified set_vq_irq() and update_vq_irq()
Message-ID: <20200805075253-mutt-send-email-mst@kernel.org>
References: <20200805113832.3755-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200805113832.3755-1-lingshan.zhu@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 05, 2020 at 07:38:32PM +0800, Zhu Lingshan wrote:
> This commit merge vhost_vdpa_update_vq_irq() logics into
> vhost_vdpa_setup_vq_irq(), so that code are unified.
> 
> In vhost_vdpa_setup_vq_irq(), added checks for the existence
> for get_vq_irq().
> 
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>

which commit should I squash this into?

commit f8e695e9dbd88464bc3d1f01769229dedf8f30d6
Author: Zhu Lingshan <lingshan.zhu@intel.com>
Date:   Fri Jul 31 14:55:31 2020 +0800

    vhost_vdpa: implement IRQ offloading in vhost_vdpa
    

this one?

> ---
>  drivers/vhost/vdpa.c | 28 ++++++----------------------
>  1 file changed, 6 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 26f166a8192e..044e1f54582a 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -122,8 +122,12 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
>  	struct vdpa_device *vdpa = v->vdpa;
>  	int ret, irq;
>  
> -	spin_lock(&vq->call_ctx.ctx_lock);
> +	if (!ops->get_vq_irq)
> +		return;
> +
>  	irq = ops->get_vq_irq(vdpa, qid);
> +	spin_lock(&vq->call_ctx.ctx_lock);
> +	irq_bypass_unregister_producer(&vq->call_ctx.producer);
>  	if (!vq->call_ctx.ctx || irq < 0) {
>  		spin_unlock(&vq->call_ctx.ctx_lock);
>  		return;
> @@ -144,26 +148,6 @@ static void vhost_vdpa_unsetup_vq_irq(struct vhost_vdpa *v, u16 qid)
>  	spin_unlock(&vq->call_ctx.ctx_lock);
>  }
>  
> -static void vhost_vdpa_update_vq_irq(struct vhost_virtqueue *vq)
> -{
> -	spin_lock(&vq->call_ctx.ctx_lock);
> -	/*
> -	 * if it has a non-zero irq, means there is a
> -	 * previsouly registered irq_bypass_producer,
> -	 * we should update it when ctx (its token)
> -	 * changes.
> -	 */
> -	if (!vq->call_ctx.producer.irq) {
> -		spin_unlock(&vq->call_ctx.ctx_lock);
> -		return;
> -	}
> -
> -	irq_bypass_unregister_producer(&vq->call_ctx.producer);
> -	vq->call_ctx.producer.token = vq->call_ctx.ctx;
> -	irq_bypass_register_producer(&vq->call_ctx.producer);
> -	spin_unlock(&vq->call_ctx.ctx_lock);
> -}
> -
>  static void vhost_vdpa_reset(struct vhost_vdpa *v)
>  {
>  	struct vdpa_device *vdpa = v->vdpa;
> @@ -452,7 +436,7 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>  			cb.private = NULL;
>  		}
>  		ops->set_vq_cb(vdpa, idx, &cb);
> -		vhost_vdpa_update_vq_irq(vq);
> +		vhost_vdpa_setup_vq_irq(v, idx);
>  		break;
>  
>  	case VHOST_SET_VRING_NUM:
> -- 
> 2.18.4

