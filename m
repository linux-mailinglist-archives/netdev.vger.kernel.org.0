Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D698F3238EC
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 09:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbhBXIrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 03:47:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44595 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234196AbhBXIop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 03:44:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614156199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NVOivrQkbhUYYYcVGD6e4aORmI1x2sDphQp+U9sGHXA=;
        b=F9+tRs+DVtxq94MecSunsk7kXVDBdIC7nGvfShJtoED/2bkFkAn/rxVB/Uh9JuoTSVydmo
        hbQnpn7536gQa5YpO7coRqdrgCGTihFtki26NGAS2Jdjc+W/aQ+SKeHvNihFNumOxiEUAW
        ipVwRdPKe/Vi7lxFPrTDubRLM1bC4Hk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-101-CT3_9yVSNReZOpFlduNv1g-1; Wed, 24 Feb 2021 03:43:18 -0500
X-MC-Unique: CT3_9yVSNReZOpFlduNv1g-1
Received: by mail-wr1-f70.google.com with SMTP id e13so731515wrg.4
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 00:43:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NVOivrQkbhUYYYcVGD6e4aORmI1x2sDphQp+U9sGHXA=;
        b=Cy3u0RBJuIlkdbtnVj5Li0FOQQGKm4nl5L76dS7mcbaWaH+1txYf20MNBE7V2+WUlM
         H3xLa0pS3hoY/21nVYsNz1tOFPNIgmUWbljDO1Jpkv5/rHte7otdc9vu+rVbuxLbqYlV
         +bJUKHCl8OqGBkJ8DePrMYGw8t/RogP2puNUjGrTeKNiiG8NYXtyZLduC30ihP513+s3
         6ae9AwZo40oSqvpInRjucMhvReib9MOYH1B8jlc1sCWgXq/c/itS9wTvZYJLLsO/TU/t
         cU0W99Vy3C1wo7uBcrqSgT9aEND5LDElj8br/zXwnQljHfA+HuVEsd/aFffYiV+KlWfR
         AR5A==
X-Gm-Message-State: AOAM531tJ6fM+DeIYn/0Jq0jMJ7XU05K+MCBgJKCeqp75GreaLNCQCay
        6EMC55pzS2wfSRYGbBx41F/qt4a3cjObAUJz5pUxqkkWv5IsZLp7ZHepYkJLMXctZKOT+ywxviK
        +pOGb2fD4kiAHBFGN
X-Received: by 2002:a7b:cc0c:: with SMTP id f12mr2668462wmh.111.1614156196958;
        Wed, 24 Feb 2021 00:43:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzRkCwcT9hRuAmpCp7SDuEw17ulTeSXlbxTyKBOWvlFkXiNm9VLPs2WH/dTrgyX5sOSIXsenA==
X-Received: by 2002:a7b:cc0c:: with SMTP id f12mr2668455wmh.111.1614156196796;
        Wed, 24 Feb 2021 00:43:16 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id q20sm1614382wmc.14.2021.02.24.00.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 00:43:16 -0800 (PST)
Date:   Wed, 24 Feb 2021 03:43:13 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>, elic@nvidia.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vdpa/mlx5: set_features should allow reset to zero
Message-ID: <20210224034240-mutt-send-email-mst@kernel.org>
References: <22fe5923-635b-59f0-7643-2fd5876937c2@oracle.com>
 <fae0bae7-e4cd-a3aa-57fe-d707df99b634@redhat.com>
 <20210223082536-mutt-send-email-mst@kernel.org>
 <3ff5fd23-1db0-2f95-4cf9-711ef403fb62@oracle.com>
 <20210224000057-mutt-send-email-mst@kernel.org>
 <0559fd8c-ff44-cb7a-8a74-71976dd2ee33@redhat.com>
 <20210224014232-mutt-send-email-mst@kernel.org>
 <ce6b0380-bc4c-bcb8-db82-2605e819702c@redhat.com>
 <20210224021222-mutt-send-email-mst@kernel.org>
 <babc654d-8dcd-d8a2-c3b6-d20cc4fc554c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <babc654d-8dcd-d8a2-c3b6-d20cc4fc554c@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 04:26:43PM +0800, Jason Wang wrote:
>     Basically on first guest access QEMU would tell kernel whether
>     guest is using the legacy or the modern interface.
>     E.g. virtio_pci_config_read/virtio_pci_config_write will call ioctl(ENABLE_LEGACY, 1)
>     while virtio_pci_common_read will call ioctl(ENABLE_LEGACY, 0)
> 
> 
> But this trick work only for PCI I think?
> 
> Thanks

ccw has a revision it can check. mmio does not have transitional devices
at all.

-- 
MST

