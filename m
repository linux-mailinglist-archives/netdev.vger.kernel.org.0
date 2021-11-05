Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 390564460B5
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 09:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232787AbhKEIfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 04:35:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28265 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232758AbhKEIfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 04:35:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636101181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JSxcNVRVB/DnKZ4+R+U2HEVeDSNW0idhy+8Cu/Pwcx0=;
        b=PV2nb4cAhAvv+yeBt5BJVkxQ65eG2qw3KwP5+7mmyzXu8ora/M8ZgevyBwQIoSeD3SilXT
        4uBZ8HWMuvAA77MHSAVFOauEb/ruk7JrEJ9jHar0MnTymJbWaNlUvD0sx0QtZSfO7xNscI
        fWz4hB1XylyFs8Jgzd2jt/658te4+C0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-SRzd4a4cO5-zwBPfzRbYnA-1; Fri, 05 Nov 2021 04:32:57 -0400
X-MC-Unique: SRzd4a4cO5-zwBPfzRbYnA-1
Received: by mail-ed1-f72.google.com with SMTP id s12-20020a50dacc000000b003dbf7a78e88so8226610edj.2
        for <netdev@vger.kernel.org>; Fri, 05 Nov 2021 01:32:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=JSxcNVRVB/DnKZ4+R+U2HEVeDSNW0idhy+8Cu/Pwcx0=;
        b=oYXYi5PPP+HK62mPvL6Z2bO679NvhIDnaiHhntBdK5hq/D3gc7Z5WHqftIYuYwj3vu
         nC4GIvG17AwN48HSCB+EWhWBI+SqjnpNmwWFecVtZKJK8RyWB7ziQTOkIKijN8yrA1qW
         lbi9xam+syzXzavUt28MO89Yz8N1T3jqbcCoGHpeu99VKHdovzuuI5itH+TkCe3T4e/Q
         1+Ie5WkrnsS3J41tdzEwNNXfl0MXWlmmMbtPiN9MCDYbnwjyT43jZVISgnUBuMSLjSXQ
         vJ4j6g/bGOWNN3OQBnolulhEtdXiOPtNbCw8zdjDSPPTLm5Rc30UwXoQc0Xy4+ddfyD9
         vgPQ==
X-Gm-Message-State: AOAM532pBYOh2sTb4C4DZ5Gfx84ZAISnQdQ07uVPnrDwMqI4y0OZS+6l
        taz0ccohS1sws39Jmdimse8z+6qF+ZNNvru0mWQNtaMpHysnrUs17l0k78oUDJckl2otp9znvX/
        RT6cr5KL5RAhQat/H
X-Received: by 2002:a05:6402:6c8:: with SMTP id n8mr44987885edy.38.1636101176830;
        Fri, 05 Nov 2021 01:32:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1GoJj1G+zOd7oQ+Yq/sGjIs8oFTI+82pGo9B8tvnTk8Cb+1Fmockzi86p8mv8w/4VBcIpXg==
X-Received: by 2002:a05:6402:6c8:: with SMTP id n8mr44987864edy.38.1636101176724;
        Fri, 05 Nov 2021 01:32:56 -0700 (PDT)
Received: from steredhat (host-87-10-72-39.retail.telecomitalia.it. [87.10.72.39])
        by smtp.gmail.com with ESMTPSA id f22sm4127471edu.26.2021.11.05.01.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 01:32:56 -0700 (PDT)
Date:   Fri, 5 Nov 2021 09:32:53 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH] vdpa: Avoid duplicate call to vp_vdpa get_status
Message-ID: <20211105083253.y4mikalhbfwmcuhp@steredhat>
References: <20211104195833.2089796-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211104195833.2089796-1-eperezma@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 04, 2021 at 08:58:33PM +0100, Eugenio Pérez wrote:
>It has no sense to call get_status twice, since we already have a
>variable for that.
>
>Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
>---
> drivers/vhost/vdpa.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>index 01c59ce7e250..10676ea0348b 100644
>--- a/drivers/vhost/vdpa.c
>+++ b/drivers/vhost/vdpa.c
>@@ -167,13 +167,13 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
> 	status_old = ops->get_status(vdpa);
>
> 	/*
> 	 * Userspace shouldn't remove status bits unless reset the
> 	 * status to 0.
> 	 */
>-	if (status != 0 && (ops->get_status(vdpa) & ~status) != 0)
>+	if (status != 0 && (status_old & ~status) != 0)
> 		return -EINVAL;
>
> 	if ((status_old & VIRTIO_CONFIG_S_DRIVER_OK) && !(status & VIRTIO_CONFIG_S_DRIVER_OK))
> 		for (i = 0; i < nvqs; i++)
> 			vhost_vdpa_unsetup_vq_irq(v, i);
>
>-- 
>2.27.0
>

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

