Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E39323692
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 06:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233653AbhBXFFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 00:05:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46500 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233487AbhBXFFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 00:05:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614143063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qg7BvJGVrkmLzWoca1uwqa7WR08fGmAwdwMQIZ6814o=;
        b=h8pAYYFBo8rc3ANpe+rnoY7ooO8kxSY2BcLsAmkilczzvqRCsbuyWmVnCIBwAYkPSkHm6T
        OlmYUuXjXmy4fzcxJUwQpuHZic4D+YtYPMIV7uV8lv1XRDgA5Lx/tV+Uao3FAlLcGqGY5Q
        KPDxWmVysbclvHqXXOXlcIgu/weYnsY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-542-4t8bjaBePkyRueP8kYYL9A-1; Wed, 24 Feb 2021 00:04:22 -0500
X-MC-Unique: 4t8bjaBePkyRueP8kYYL9A-1
Received: by mail-wr1-f69.google.com with SMTP id u15so486360wrn.3
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 21:04:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=qg7BvJGVrkmLzWoca1uwqa7WR08fGmAwdwMQIZ6814o=;
        b=EM1nEpAbZif+A6gFjj2y+JklDhJ4h8CEMBxONyZiaPR++2q+tfaSO9CC93OZeOElky
         7zjmw5nABsSpOq6vJa/CZjuzYybQ949DJp1q3R8GohYVeT03Z72fgpe3qpa0LNBajSer
         y4BH8ZJ/5FnsUH1igScxRFMR6+pwg01AA6n97QKsX8WE7YnSK8e+V9lx/8www+l9psXh
         SJUYbQeWWPcpiDlpB31iBmdYEEftanJfiFbv5K33o6GBtavCkK/kFunG+RNANzkJIrJj
         onx+wvMcjBHzg2THOc9DAmtfohiAZPRWSGVYY/ZUQh1xeyIaZYY3EKjMKNkMS5d0RvUG
         Gu8A==
X-Gm-Message-State: AOAM531E42E8LTbq78lEvnFZIMShiYaQsbH0WFYcc23lGgbckDXTO8h6
        t2Wc9OnhCFSk3NRanTith3NmvQIyuTMbI1PqFUGw0J/ad62sEBN8NcDrGeNgEkqXS0x7ey+22qQ
        GndRGKcHQDzMku+7U
X-Received: by 2002:a1c:a7d3:: with SMTP id q202mr1810769wme.93.1614143060716;
        Tue, 23 Feb 2021 21:04:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwunTZi4C12uuXwV71LG4B0VWOYbn2ATYH4hZ4doxg/op9ieMqFayUgQTdJX1JbFuvjFcJIRg==
X-Received: by 2002:a1c:a7d3:: with SMTP id q202mr1810757wme.93.1614143060543;
        Tue, 23 Feb 2021 21:04:20 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id g11sm920528wmk.32.2021.02.23.21.04.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 21:04:19 -0800 (PST)
Date:   Wed, 24 Feb 2021 00:04:16 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Si-Wei Liu <si-wei.liu@oracle.com>
Cc:     Jason Wang <jasowang@redhat.com>, elic@nvidia.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vdpa/mlx5: set_features should allow reset to zero
Message-ID: <20210224000057-mutt-send-email-mst@kernel.org>
References: <1613735698-3328-1-git-send-email-si-wei.liu@oracle.com>
 <605e7d2d-4f27-9688-17a8-d57191752ee7@redhat.com>
 <20210222023040-mutt-send-email-mst@kernel.org>
 <22fe5923-635b-59f0-7643-2fd5876937c2@oracle.com>
 <fae0bae7-e4cd-a3aa-57fe-d707df99b634@redhat.com>
 <20210223082536-mutt-send-email-mst@kernel.org>
 <3ff5fd23-1db0-2f95-4cf9-711ef403fb62@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3ff5fd23-1db0-2f95-4cf9-711ef403fb62@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 11:35:57AM -0800, Si-Wei Liu wrote:
> 
> 
> On 2/23/2021 5:26 AM, Michael S. Tsirkin wrote:
> > On Tue, Feb 23, 2021 at 10:03:57AM +0800, Jason Wang wrote:
> > > On 2021/2/23 9:12 上午, Si-Wei Liu wrote:
> > > > 
> > > > On 2/21/2021 11:34 PM, Michael S. Tsirkin wrote:
> > > > > On Mon, Feb 22, 2021 at 12:14:17PM +0800, Jason Wang wrote:
> > > > > > On 2021/2/19 7:54 下午, Si-Wei Liu wrote:
> > > > > > > Commit 452639a64ad8 ("vdpa: make sure set_features is invoked
> > > > > > > for legacy") made an exception for legacy guests to reset
> > > > > > > features to 0, when config space is accessed before features
> > > > > > > are set. We should relieve the verify_min_features() check
> > > > > > > and allow features reset to 0 for this case.
> > > > > > > 
> > > > > > > It's worth noting that not just legacy guests could access
> > > > > > > config space before features are set. For instance, when
> > > > > > > feature VIRTIO_NET_F_MTU is advertised some modern driver
> > > > > > > will try to access and validate the MTU present in the config
> > > > > > > space before virtio features are set.
> > > > > > This looks like a spec violation:
> > > > > > 
> > > > > > "
> > > > > > 
> > > > > > The following driver-read-only field, mtu only exists if
> > > > > > VIRTIO_NET_F_MTU is
> > > > > > set.
> > > > > > This field specifies the maximum MTU for the driver to use.
> > > > > > "
> > > > > > 
> > > > > > Do we really want to workaround this?
> > > > > > 
> > > > > > Thanks
> > > > > And also:
> > > > > 
> > > > > The driver MUST follow this sequence to initialize a device:
> > > > > 1. Reset the device.
> > > > > 2. Set the ACKNOWLEDGE status bit: the guest OS has noticed the device.
> > > > > 3. Set the DRIVER status bit: the guest OS knows how to drive the
> > > > > device.
> > > > > 4. Read device feature bits, and write the subset of feature bits
> > > > > understood by the OS and driver to the
> > > > > device. During this step the driver MAY read (but MUST NOT write)
> > > > > the device-specific configuration
> > > > > fields to check that it can support the device before accepting it.
> > > > > 5. Set the FEATURES_OK status bit. The driver MUST NOT accept new
> > > > > feature bits after this step.
> > > > > 6. Re-read device status to ensure the FEATURES_OK bit is still set:
> > > > > otherwise, the device does not
> > > > > support our subset of features and the device is unusable.
> > > > > 7. Perform device-specific setup, including discovery of virtqueues
> > > > > for the device, optional per-bus setup,
> > > > > reading and possibly writing the device’s virtio configuration
> > > > > space, and population of virtqueues.
> > > > > 8. Set the DRIVER_OK status bit. At this point the device is “live”.
> > > > > 
> > > > > 
> > > > > so accessing config space before FEATURES_OK is a spec violation, right?
> > > > It is, but it's not relevant to what this commit tries to address. I
> > > > thought the legacy guest still needs to be supported.
> > > > 
> > > > Having said, a separate patch has to be posted to fix the guest driver
> > > > issue where this discrepancy is introduced to virtnet_validate() (since
> > > > commit fe36cbe067). But it's not technically related to this patch.
> > > > 
> > > > -Siwei
> > > 
> > > I think it's a bug to read config space in validate, we should move it to
> > > virtnet_probe().
> > > 
> > > Thanks
> > I take it back, reading but not writing seems to be explicitly allowed by spec.
> > So our way to detect a legacy guest is bogus, need to think what is
> > the best way to handle this.
> Then maybe revert commit fe36cbe067 and friends, and have QEMU detect legacy
> guest? Supposedly only config space write access needs to be guarded before
> setting FEATURES_OK.
> 
> -Siwie

Detecting it isn't enough though, we will need a new ioctl to notify
the kernel that it's a legacy guest. Ugh :(


> > > > > 
> > > > > > > Rejecting reset to 0
> > > > > > > prematurely causes correct MTU and link status unable to load
> > > > > > > for the very first config space access, rendering issues like
> > > > > > > guest showing inaccurate MTU value, or failure to reject
> > > > > > > out-of-range MTU.
> > > > > > > 
> > > > > > > Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for
> > > > > > > supported mlx5 devices")
> > > > > > > Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
> > > > > > > ---
> > > > > > >     drivers/vdpa/mlx5/net/mlx5_vnet.c | 15 +--------------
> > > > > > >     1 file changed, 1 insertion(+), 14 deletions(-)
> > > > > > > 
> > > > > > > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > index 7c1f789..540dd67 100644
> > > > > > > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > @@ -1490,14 +1490,6 @@ static u64
> > > > > > > mlx5_vdpa_get_features(struct vdpa_device *vdev)
> > > > > > >         return mvdev->mlx_features;
> > > > > > >     }
> > > > > > > -static int verify_min_features(struct mlx5_vdpa_dev *mvdev,
> > > > > > > u64 features)
> > > > > > > -{
> > > > > > > -    if (!(features & BIT_ULL(VIRTIO_F_ACCESS_PLATFORM)))
> > > > > > > -        return -EOPNOTSUPP;
> > > > > > > -
> > > > > > > -    return 0;
> > > > > > > -}
> > > > > > > -
> > > > > > >     static int setup_virtqueues(struct mlx5_vdpa_net *ndev)
> > > > > > >     {
> > > > > > >         int err;
> > > > > > > @@ -1558,18 +1550,13 @@ static int
> > > > > > > mlx5_vdpa_set_features(struct vdpa_device *vdev, u64
> > > > > > > features)
> > > > > > >     {
> > > > > > >         struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
> > > > > > >         struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
> > > > > > > -    int err;
> > > > > > >         print_features(mvdev, features, true);
> > > > > > > -    err = verify_min_features(mvdev, features);
> > > > > > > -    if (err)
> > > > > > > -        return err;
> > > > > > > -
> > > > > > >         ndev->mvdev.actual_features = features &
> > > > > > > ndev->mvdev.mlx_features;
> > > > > > >         ndev->config.mtu = cpu_to_mlx5vdpa16(mvdev, ndev->mtu);
> > > > > > >         ndev->config.status |= cpu_to_mlx5vdpa16(mvdev,
> > > > > > > VIRTIO_NET_S_LINK_UP);
> > > > > > > -    return err;
> > > > > > > +    return 0;
> > > > > > >     }
> > > > > > >     static void mlx5_vdpa_set_config_cb(struct vdpa_device
> > > > > > > *vdev, struct vdpa_callback *cb)

