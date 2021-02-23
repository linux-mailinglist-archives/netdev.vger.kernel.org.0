Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3655B32285F
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 11:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhBWJ71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 04:59:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34175 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232133AbhBWJ5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 04:57:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614074144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+9UOXjMdz3lHTcWvMJyRl4DlsSgw/pGrzIfxZceKJLg=;
        b=NgoT3MWccmIM4TlBDk3BApUd7T6PUDMJqmcR5cWqjX0cX57C4wbtSxngx++VFPhQXweTen
        LO3F80nohRXzX7fNlVvmS60AXhayhHE9YyQ+O/QnQmg6xEg8Vbr11XhPBZ3McSfr2JiEq5
        mGLRC2SFroNRLk7O+jNhk24Czb03EgI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-kMlzaQzJOFGKQ0_qdir5_A-1; Tue, 23 Feb 2021 04:55:42 -0500
X-MC-Unique: kMlzaQzJOFGKQ0_qdir5_A-1
Received: by mail-wr1-f70.google.com with SMTP id w11so7149987wrp.6
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 01:55:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+9UOXjMdz3lHTcWvMJyRl4DlsSgw/pGrzIfxZceKJLg=;
        b=msDIJi1sJz1/4pUW90/mOxPPyKv9IbzuZg8RPAhLyZ7He2zuDreKejZVXAW6z7GtFo
         YL6ggnnaxO1bqHYPDf4BEHOp1101mTanvgX/sUXWrW4N4D7r6fp6DT0ltx06MKy6gMey
         v/ntRg5Toe7MhYm4ixP4koSYbcyzvHw1fPM1WvzQqdPob43k3ZSoFl7I/NeKyhDEFSk8
         1BCaWTC29iBLB9CH6OzZTJjf5COF8A4Sofes4vVDhuypK1GBDpHvJvndCjqUuWhm1Ok2
         IySKrGqmlCPRnW0Nok5sh2DXIKCId8nquESrMMVso7VNByJ9RFcmZBUhy9osBQj2tBo+
         zqcA==
X-Gm-Message-State: AOAM530pXfBN2LhLDw5Pl0er2EBmj56og9c0fGabCBD5cbMWfyXg0/4B
        B6CMvbaEoXgU+zstqs5PqFw0KkhOMdvFkPXY4FLWFF/ad4ig5PFqVS8LY0tBvJp+fl7oFjlEejy
        1YEnkSZpI+iNiNI2S
X-Received: by 2002:adf:dd4a:: with SMTP id u10mr12417526wrm.253.1614074140893;
        Tue, 23 Feb 2021 01:55:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzUnL19tqj/USYQ+8ZatPBcBGOycf7+tVGdH/yYlA4wjDSUTopCTrlMNHsMzZuipo+DmCRKag==
X-Received: by 2002:adf:dd4a:: with SMTP id u10mr12417508wrm.253.1614074140719;
        Tue, 23 Feb 2021 01:55:40 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id x66sm1978777wmg.6.2021.02.23.01.55.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 01:55:40 -0800 (PST)
Date:   Tue, 23 Feb 2021 04:55:37 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Eli Cohen <elic@nvidia.com>, Si-Wei Liu <si-wei.liu@oracle.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vdpa/mlx5: set_features should allow reset to zero
Message-ID: <20210223045519-mutt-send-email-mst@kernel.org>
References: <1613735698-3328-1-git-send-email-si-wei.liu@oracle.com>
 <20210221144437.GA82010@mtl-vdi-166.wap.labs.mlnx>
 <20210221165047-mutt-send-email-mst@kernel.org>
 <20210222060526.GA110862@mtl-vdi-166.wap.labs.mlnx>
 <20210223042559-mutt-send-email-mst@kernel.org>
 <65494f6b-9613-1c0e-4a36-e4af2965235e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <65494f6b-9613-1c0e-4a36-e4af2965235e@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 05:48:10PM +0800, Jason Wang wrote:
> 
> On 2021/2/23 下午5:26, Michael S. Tsirkin wrote:
> > On Mon, Feb 22, 2021 at 08:05:26AM +0200, Eli Cohen wrote:
> > > On Sun, Feb 21, 2021 at 04:52:05PM -0500, Michael S. Tsirkin wrote:
> > > > On Sun, Feb 21, 2021 at 04:44:37PM +0200, Eli Cohen wrote:
> > > > > On Fri, Feb 19, 2021 at 06:54:58AM -0500, Si-Wei Liu wrote:
> > > > > > Commit 452639a64ad8 ("vdpa: make sure set_features is invoked
> > > > > > for legacy") made an exception for legacy guests to reset
> > > > > > features to 0, when config space is accessed before features
> > > > > > are set. We should relieve the verify_min_features() check
> > > > > > and allow features reset to 0 for this case.
> > > > > > 
> > > > > > It's worth noting that not just legacy guests could access
> > > > > > config space before features are set. For instance, when
> > > > > > feature VIRTIO_NET_F_MTU is advertised some modern driver
> > > > > > will try to access and validate the MTU present in the config
> > > > > > space before virtio features are set. Rejecting reset to 0
> > > > > > prematurely causes correct MTU and link status unable to load
> > > > > > for the very first config space access, rendering issues like
> > > > > > guest showing inaccurate MTU value, or failure to reject
> > > > > > out-of-range MTU.
> > > > > > 
> > > > > > Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
> > > > > > Signed-off-by: Si-Wei Liu<si-wei.liu@oracle.com>
> > > > > > ---
> > > > > >   drivers/vdpa/mlx5/net/mlx5_vnet.c | 15 +--------------
> > > > > >   1 file changed, 1 insertion(+), 14 deletions(-)
> > > > > > 
> > > > > > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > index 7c1f789..540dd67 100644
> > > > > > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > @@ -1490,14 +1490,6 @@ static u64 mlx5_vdpa_get_features(struct vdpa_device *vdev)
> > > > > >   	return mvdev->mlx_features;
> > > > > >   }
> > > > > > -static int verify_min_features(struct mlx5_vdpa_dev *mvdev, u64 features)
> > > > > > -{
> > > > > > -	if (!(features & BIT_ULL(VIRTIO_F_ACCESS_PLATFORM)))
> > > > > > -		return -EOPNOTSUPP;
> > > > > > -
> > > > > > -	return 0;
> > > > > > -}
> > > > > > -
> > > > > But what if VIRTIO_F_ACCESS_PLATFORM is not offerred? This does not
> > > > > support such cases.
> > > > Did you mean "catch such cases" rather than "support"?
> > > > 
> > > Actually I meant this driver/device does not support such cases.
> > Well the removed code merely failed without VIRTIO_F_ACCESS_PLATFORM
> > it didn't actually try to support anything ...
> 
> 
> I think it's used to catch the driver that doesn't support ACCESS_PLATFORM?
> 
> Thanks
> 

That is why I asked whether Eli meant catch.

-- 
MST

