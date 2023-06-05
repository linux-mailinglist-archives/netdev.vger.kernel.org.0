Return-Path: <netdev+bounces-7991-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29F6072261F
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:42:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D989C2811F6
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:42:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1275C134CE;
	Mon,  5 Jun 2023 12:42:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050076FC3
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:42:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCA1DB
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 05:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685968921;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mOmw6tP0FZFUTC7PGHcbRuETRmz8QZ6Xd4tQSfJHTaA=;
	b=O7Rm+wK/ctTBI1kVBJbfXXgStQmIm5bWMttqdMotIWt2lLl2t/yNPoRrYhjiF7qBLg2A/k
	5nE1DNEk72dfFHcrYSaR8M+BVfAErae4wBi4brH9PR1dlCIwQfnxX1sw+Zn0wsYV0D1BBl
	69KPXB9N0nRiG9iQIgYaw2BZZtzHGZE=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-354-CkajOw3RMaSCGpit1_e25Q-1; Mon, 05 Jun 2023 08:42:00 -0400
X-MC-Unique: CkajOw3RMaSCGpit1_e25Q-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-4f01644f62eso3211412e87.0
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 05:42:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685968919; x=1688560919;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mOmw6tP0FZFUTC7PGHcbRuETRmz8QZ6Xd4tQSfJHTaA=;
        b=Ayj97eHx9YTXUjVE7ICuU10nmZdFkzJSpgnGs77/kV6+URgdgctMiKtnx7gR27uNxW
         ML+VtAnhGIHkbN7hE3ocmKF5rZYEl1WhspnukInpRTCDZOpKrKYYWfNg4/yp4TWPeQIV
         Tol9Cvc8nKoD9O/tSkMYbTdJGytdx7PIJwqqqMxt7TMIIIf0tLCmd2vLSUEM+gEs+Jnw
         gZRefLbKTwSjwAWBRtdGfKIgV2JqD18zFmTAgXYZ9MTbfv2UjwmHq17ZVgBWoXI8bKtQ
         mQ0pOgHRndPsH/XrR8B2RFvdtEVPUc4Q5Zry//wtp8mpD98sxvAx2vYIHh3/Ji5UK28U
         znMA==
X-Gm-Message-State: AC+VfDxmJNxiD7sO6rMHeTNnA+WrX0Fg7hT5Or7S4j1Uwh8eOODhLgW1
	TkF+XD9SuoonlnCiNxCbz01OZDXlmDO90uudmEHEAvuK3X5ayKW1X+OTMVGURGsAOIN0Fii2UGT
	WOljS3L5FWuX1HnUP
X-Received: by 2002:a05:6512:96c:b0:4f5:a181:97b8 with SMTP id v12-20020a056512096c00b004f5a18197b8mr4498041lft.25.1685968918877;
        Mon, 05 Jun 2023 05:41:58 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7c02ynCF81jcSmROQilZ0qb05p4TMq5PV+aVib550acBLMoEwSQbxeF+apcaXIC3Jw7wScGQ==
X-Received: by 2002:a05:6512:96c:b0:4f5:a181:97b8 with SMTP id v12-20020a056512096c00b004f5a18197b8mr4498025lft.25.1685968918475;
        Mon, 05 Jun 2023 05:41:58 -0700 (PDT)
Received: from redhat.com ([2.55.4.169])
        by smtp.gmail.com with ESMTPSA id 24-20020a05600c231800b003f6041f5a6csm10669207wmo.12.2023.06.05.05.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 05:41:58 -0700 (PDT)
Date: Mon, 5 Jun 2023 08:41:54 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Tiwei Bie <tiwei.bie@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
Message-ID: <20230605084104-mutt-send-email-mst@kernel.org>
References: <20230605110644.151211-1-sgarzare@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230605110644.151211-1-sgarzare@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 01:06:44PM +0200, Stefano Garzarella wrote:
> vhost-vdpa IOCTLs (eg. VHOST_GET_VRING_BASE, VHOST_SET_VRING_BASE)
> don't support packed virtqueue well yet, so let's filter the
> VIRTIO_F_RING_PACKED feature for now in vhost_vdpa_get_features().
> 
> This way, even if the device supports it, we don't risk it being
> negotiated, then the VMM is unable to set the vring state properly.
> 
> Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
> Cc: stable@vger.kernel.org
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
> 
> Notes:
>     This patch should be applied before the "[PATCH v2 0/3] vhost_vdpa:
>     better PACKED support" series [1] and backported in stable branches.
>     
>     We can revert it when we are sure that everything is working with
>     packed virtqueues.
>     
>     Thanks,
>     Stefano
>     
>     [1] https://lore.kernel.org/virtualization/20230424225031.18947-1-shannon.nelson@amd.com/

I'm a bit lost here. So why am I merging "better PACKED support" then?
Does this patch make them a NOP?

>  drivers/vhost/vdpa.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 8c1aefc865f0..ac2152135b23 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -397,6 +397,12 @@ static long vhost_vdpa_get_features(struct vhost_vdpa *v, u64 __user *featurep)
>  
>  	features = ops->get_device_features(vdpa);
>  
> +	/*
> +	 * IOCTLs (eg. VHOST_GET_VRING_BASE, VHOST_SET_VRING_BASE) don't support
> +	 * packed virtqueue well yet, so let's filter the feature for now.
> +	 */
> +	features &= ~BIT_ULL(VIRTIO_F_RING_PACKED);
> +
>  	if (copy_to_user(featurep, &features, sizeof(features)))
>  		return -EFAULT;
>  
> 
> base-commit: 9561de3a55bed6bdd44a12820ba81ec416e705a7
> -- 
> 2.40.1


