Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD06B47A92C
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 13:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbhLTMDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 07:03:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51547 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229533AbhLTMDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 07:03:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640001784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KVbqaqKX4D74IoU7gZGZhJb64pFjSvVeEMSn+p05yzk=;
        b=g/uud7FfnBM3NWRTcdMYQaLVk3rE0OgbCEv2Up4s/w1Px0AsxP8zvs6WHlBU7YxO2K2EQ/
        I74I27eLyGxvf6L4Zu4ylVxJB0CkS1xFrsounhEmhmElfdNjGzpY6MatQSBTL22BxmeXXD
        7VXW0fczqRzXO1JHpI+084fXq5FTIHk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-400-V-hrW0YvO_OXfYCj27H6eA-1; Mon, 20 Dec 2021 07:03:03 -0500
X-MC-Unique: V-hrW0YvO_OXfYCj27H6eA-1
Received: by mail-wr1-f69.google.com with SMTP id v18-20020a5d5912000000b001815910d2c0so3707011wrd.1
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 04:03:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KVbqaqKX4D74IoU7gZGZhJb64pFjSvVeEMSn+p05yzk=;
        b=0ifF4Z1/ERavq/pIk1uHDMdaT3wsAMGNz00Jm2cSzGGcf2MxDx0QZnr6jn3st41C08
         YipcbkVrTt0Fh6DidrkiaiqiIdKGUL9EU0ZHyVxtCfbN4xjGozeDhHIECk6pmNrffEI5
         4p3ACK5faAg9/HnEy9/A56OpXLbeJereR/1paosaK8l2m+GHS/FnjYSKy9cmy4tuQaeh
         VNfZuYwEK2cmOnuaxFruNsBIzrwWh66prGKTW1euBhMw7bVdODwM32vp7Bn556Bpb0Rs
         7J2xAHs4s1Jyu+IoPplKcGYitwDt9g9+iigM3ANtwI02d+CblpwHaq+NqBKRDsGMrCSf
         ojJw==
X-Gm-Message-State: AOAM5321saIuMs9lBlH5net05Z4aCDLHOSGO8g9ED3+oLW4cwtOTY48O
        MpJ9iwo4L5ya8HPmv7KVjxadG7iJLfQu/apKWWaJ6ARyVUuQ8cK6WK10VZOjKX9CsvY5X6rME7V
        Yhz9S07JzFj68ddPx
X-Received: by 2002:a05:600c:4ec7:: with SMTP id g7mr6690902wmq.152.1640001782470;
        Mon, 20 Dec 2021 04:03:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxGNokA5dsQSDTergDRmkdfHGMbynaCcZpoaZd2fEWra/4z7gJowICfiJWDmDY7zWfIv5pj3A==
X-Received: by 2002:a05:600c:4ec7:: with SMTP id g7mr6690874wmq.152.1640001782226;
        Mon, 20 Dec 2021 04:03:02 -0800 (PST)
Received: from redhat.com ([2.55.19.224])
        by smtp.gmail.com with ESMTPSA id r7sm10224532wrt.77.2021.12.20.04.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 04:03:01 -0800 (PST)
Date:   Mon, 20 Dec 2021 07:02:58 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     David Ahern <dsahern@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: Re: [iproute2-next v2 4/4] vdpa: Enable user to set mtu of the vdpa
 device
Message-ID: <20211220070136-mutt-send-email-mst@kernel.org>
References: <20211217080827.266799-1-parav@nvidia.com>
 <20211217080827.266799-5-parav@nvidia.com>
 <a38a9877-4b01-22b3-ac62-768265db0d5a@gmail.com>
 <20211218170602-mutt-send-email-mst@kernel.org>
 <PH0PR12MB548189EBA8346A960A0A409FDC7B9@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR12MB548189EBA8346A960A0A409FDC7B9@PH0PR12MB5481.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 20, 2021 at 03:49:21AM +0000, Parav Pandit wrote:
> 
> 
> > From: Michael S. Tsirkin <mst@redhat.com>
> > Sent: Sunday, December 19, 2021 3:37 AM
> > 
> > On Sat, Dec 18, 2021 at 01:53:01PM -0700, David Ahern wrote:
> > > On 12/17/21 1:08 AM, Parav Pandit wrote:
> > > > @@ -204,6 +217,8 @@ static void vdpa_opts_put(struct nlmsghdr *nlh,
> > struct vdpa *vdpa)
> > > >  	if (opts->present & VDPA_OPT_VDEV_MAC)
> > > >  		mnl_attr_put(nlh, VDPA_ATTR_DEV_NET_CFG_MACADDR,
> > > >  			     sizeof(opts->mac), opts->mac);
> > > > +	if (opts->present & VDPA_OPT_VDEV_MTU)
> > > > +		mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MTU,
> > opts->mtu);
> > >
> > > Why limit the MTU to a u16? Eric for example is working on "Big TCP"
> > > where IPv6 can work with Jumbograms where mtu can be > 64k.
> > >
> > > https://datatracker.ietf.org/doc/html/rfc2675
> > 
> > Well it's 16 bit at the virtio level, though we can extend that of course. Making
> > it match for now removes need for validation.
> > --
> As Michael mentioned virtio specification limits the mtu to 64k-1. Hence 16-bit.
> First we need to update the virtio spec to support > 64K mtu.
> However, when/if (I don't know when) that happens, we need to make this also u32.
> So may be we can make it u32 now, but still restrict the mtu value to 64k-1 in kernel, until the spec is updated.
> 
> Let me know, if you think that's future proofing is better, I first need to update the kernel to take nla u32.
> 
> > MST

After consideration, this future proofing seems like a good thing to have.

-- 
MST

