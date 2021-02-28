Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6068C3274A0
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 22:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhB1Vg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 16:36:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51450 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230298AbhB1Vg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 16:36:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614548100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ReI9nC5t0ilGJKO9iEAq6ntFlruOaE8Rz2Sr5GLVUJo=;
        b=HxNiZomYAGLHhvgGA72LDvYO9xeaWo9Dl5Cp2dMtSxEyjZh4GT145FH/v2/HsGzIQfipQB
        Y/SsZAJx0PNeBpFeYVVwNV1HqJIp+L30UjZ2hB1Sf2XjivE4jQoUC53N31Jr2vzpRnojPO
        0q6ZAf0iV1BdCijjHEv2ndxylMdiLCg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-NadEr3jaN9Ks7NpMOlmAIQ-1; Sun, 28 Feb 2021 16:34:57 -0500
X-MC-Unique: NadEr3jaN9Ks7NpMOlmAIQ-1
Received: by mail-ej1-f71.google.com with SMTP id p6so5648682ejw.1
        for <netdev@vger.kernel.org>; Sun, 28 Feb 2021 13:34:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ReI9nC5t0ilGJKO9iEAq6ntFlruOaE8Rz2Sr5GLVUJo=;
        b=Kmdmz0h4eNeYY4dHCIuR0n/QcycK+O6jRzZy1ATYIVJBGmkmrqOMWLuEzslxWMwCZ/
         iImDI78pzTybIRfXN1wBnLQQz2b6sWhSlfBsao4LuYI34MwHetL2N6cFlLdw3jTnp6dm
         qcQ1s6jA0T2bmChKoPrFYIqRlOAfOml2zkvOJLckKsghXjcPE4J4+7bxB8EvDbKvveRv
         6m/rG9kBOtjw5XAihB6ySqW5oNHERezOCZY3k9Nbd65WK7ItAhM0yg+ASlVlz8IDEN7R
         EBlMlob8uxTNXAnXb/jO1BoQfbpOfeqQepEZjw2Vf6oqNN9EvR5X3ZBn4AlxtSmBGcp1
         C0kg==
X-Gm-Message-State: AOAM532iZtEDjXjSy4Ug2xhg2q9b7eoYGCnAXiI8iSpcssRJyNrdBvKf
        1uIbN+QAwCEAmIlphwyv9fuFIH45l014q0l0YER2qDr0k50RaMMJbTTuovXnEcaf5B95wFylmMh
        BH4udqPAiNep0juff
X-Received: by 2002:aa7:d954:: with SMTP id l20mr9537932eds.1.1614548096612;
        Sun, 28 Feb 2021 13:34:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyZfpQusPlK8SeLupsX5MkpMrCMoVqG9E1G+3AItVqjBlS3hF76KS3hDto3VFFR3Yt+hLv8gQ==
X-Received: by 2002:aa7:d954:: with SMTP id l20mr9537925eds.1.1614548096518;
        Sun, 28 Feb 2021 13:34:56 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id lm24sm4333097ejb.53.2021.02.28.13.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 13:34:56 -0800 (PST)
Date:   Sun, 28 Feb 2021 16:34:53 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Si-Wei Liu <si-wei.liu@oracle.com>
Cc:     Jason Wang <jasowang@redhat.com>, elic@nvidia.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vdpa/mlx5: set_features should allow reset to zero
Message-ID: <20210228163031-mutt-send-email-mst@kernel.org>
References: <1613735698-3328-1-git-send-email-si-wei.liu@oracle.com>
 <605e7d2d-4f27-9688-17a8-d57191752ee7@redhat.com>
 <20210222023040-mutt-send-email-mst@kernel.org>
 <22fe5923-635b-59f0-7643-2fd5876937c2@oracle.com>
 <fae0bae7-e4cd-a3aa-57fe-d707df99b634@redhat.com>
 <20210223082536-mutt-send-email-mst@kernel.org>
 <3ff5fd23-1db0-2f95-4cf9-711ef403fb62@oracle.com>
 <20210224000057-mutt-send-email-mst@kernel.org>
 <52836a63-4e00-ff58-50fb-9f450ce968d7@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52836a63-4e00-ff58-50fb-9f450ce968d7@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 10:24:41AM -0800, Si-Wei Liu wrote:
> > Detecting it isn't enough though, we will need a new ioctl to notify
> > the kernel that it's a legacy guest. Ugh :(
> Well, although I think adding an ioctl is doable, may I know what the use
> case there will be for kernel to leverage such info directly? Is there a
> case QEMU can't do with dedicate ioctls later if there's indeed
> differentiation (legacy v.s. modern) needed?

BTW a good API could be

#define VHOST_SET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
#define VHOST_GET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)

we did it per vring but maybe that was a mistake ...

-- 
MST

