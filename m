Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723153237D4
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 08:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234409AbhBXHTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 02:19:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57989 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233186AbhBXHTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 02:19:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614151085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cUD9i8imHS99V2QE+X6CmyOUFv11LLo8e+TKwIxsJK4=;
        b=i2rwDlDPw6K2p8QESH1SKzVNcPC6v6u4EeH/BR44/lBNYHSe6JIru7cKeDwNTtNTj1j2H3
        URm/NWvKg7LzY93IDe3ghI6iUVt9VLqPza1pypqecfjSEuqusqk7E2XYi9hlyNg7/6Dvr1
        ei3ypqFUgitLwqtfSxzJnk60SoxQFho=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-549-8Ff3q1e5N5SVqFN5VRmLZw-1; Wed, 24 Feb 2021 02:18:04 -0500
X-MC-Unique: 8Ff3q1e5N5SVqFN5VRmLZw-1
Received: by mail-wr1-f72.google.com with SMTP id v18so637087wrr.8
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 23:18:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=cUD9i8imHS99V2QE+X6CmyOUFv11LLo8e+TKwIxsJK4=;
        b=fs3Kqxx839hir/jJYR5xhuCBfhz4l76M3GEOEmoMzpCEnw8zLf0kkDbFot4lOaz1fO
         IEoM4JfcpI4wWURNs4lezOKd+w54ngXw2XWPDEOD4Vly/60/1vy6H/gPTwB/B4PLGoA3
         FjJimpHQHITKBgBLX546SJXrEwGcgmgIHE5P4RqhGH8AJiCR6hRottEZ/rjPs5wEtXpr
         CbFht0ZcEdpQUroIHjlzytNelUqrZS1Te8Zq2nvrf5xp0cwh7fX6hrPtKsflN8CTWQr+
         1NEu5mBxD1qOiFYlqHycLXU+6PYsUAx2TK6LtQ+EoQztib6uXgd4GgKMhppfrzoTyLXq
         z40A==
X-Gm-Message-State: AOAM533e/ovFv+pJlP4velNNXJwLqNgwzQ+5W725Qsi2qGuqx/HD3sGm
        h9JAgR7ijA8tSwKSCLgYPIcL0+KcVneI+VdhSDs9O3erAPrbchkE/MLujTwiYsPQwwJACH+QZSK
        5rHy9cpmbu6unvcXq
X-Received: by 2002:adf:a2c2:: with SMTP id t2mr29717907wra.47.1614151083002;
        Tue, 23 Feb 2021 23:18:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx36dvoVgsKzOY2Q0IHxAEQncvNYFTe0HuoFP02ym271+rmQupV6f2qRhf/njQ/cCS+a70DPA==
X-Received: by 2002:adf:a2c2:: with SMTP id t2mr29717890wra.47.1614151082811;
        Tue, 23 Feb 2021 23:18:02 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id w11sm1800313wru.3.2021.02.23.23.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 23:18:02 -0800 (PST)
Date:   Wed, 24 Feb 2021 02:17:59 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>, elic@nvidia.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vdpa/mlx5: set_features should allow reset to zero
Message-ID: <20210224021222-mutt-send-email-mst@kernel.org>
References: <605e7d2d-4f27-9688-17a8-d57191752ee7@redhat.com>
 <20210222023040-mutt-send-email-mst@kernel.org>
 <22fe5923-635b-59f0-7643-2fd5876937c2@oracle.com>
 <fae0bae7-e4cd-a3aa-57fe-d707df99b634@redhat.com>
 <20210223082536-mutt-send-email-mst@kernel.org>
 <3ff5fd23-1db0-2f95-4cf9-711ef403fb62@oracle.com>
 <20210224000057-mutt-send-email-mst@kernel.org>
 <0559fd8c-ff44-cb7a-8a74-71976dd2ee33@redhat.com>
 <20210224014232-mutt-send-email-mst@kernel.org>
 <ce6b0380-bc4c-bcb8-db82-2605e819702c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ce6b0380-bc4c-bcb8-db82-2605e819702c@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 02:53:08PM +0800, Jason Wang wrote:
> 
> On 2021/2/24 2:46 下午, Michael S. Tsirkin wrote:
> > On Wed, Feb 24, 2021 at 02:04:36PM +0800, Jason Wang wrote:
> > > On 2021/2/24 1:04 下午, Michael S. Tsirkin wrote:
> > > > On Tue, Feb 23, 2021 at 11:35:57AM -0800, Si-Wei Liu wrote:
> > > > > On 2/23/2021 5:26 AM, Michael S. Tsirkin wrote:
> > > > > > On Tue, Feb 23, 2021 at 10:03:57AM +0800, Jason Wang wrote:
> > > > > > > On 2021/2/23 9:12 上午, Si-Wei Liu wrote:
> > > > > > > > On 2/21/2021 11:34 PM, Michael S. Tsirkin wrote:
> > > > > > > > > On Mon, Feb 22, 2021 at 12:14:17PM +0800, Jason Wang wrote:
> > > > > > > > > > On 2021/2/19 7:54 下午, Si-Wei Liu wrote:
> > > > > > > > > > > Commit 452639a64ad8 ("vdpa: make sure set_features is invoked
> > > > > > > > > > > for legacy") made an exception for legacy guests to reset
> > > > > > > > > > > features to 0, when config space is accessed before features
> > > > > > > > > > > are set. We should relieve the verify_min_features() check
> > > > > > > > > > > and allow features reset to 0 for this case.
> > > > > > > > > > > 
> > > > > > > > > > > It's worth noting that not just legacy guests could access
> > > > > > > > > > > config space before features are set. For instance, when
> > > > > > > > > > > feature VIRTIO_NET_F_MTU is advertised some modern driver
> > > > > > > > > > > will try to access and validate the MTU present in the config
> > > > > > > > > > > space before virtio features are set.
> > > > > > > > > > This looks like a spec violation:
> > > > > > > > > > 
> > > > > > > > > > "
> > > > > > > > > > 
> > > > > > > > > > The following driver-read-only field, mtu only exists if
> > > > > > > > > > VIRTIO_NET_F_MTU is
> > > > > > > > > > set.
> > > > > > > > > > This field specifies the maximum MTU for the driver to use.
> > > > > > > > > > "
> > > > > > > > > > 
> > > > > > > > > > Do we really want to workaround this?
> > > > > > > > > > 
> > > > > > > > > > Thanks
> > > > > > > > > And also:
> > > > > > > > > 
> > > > > > > > > The driver MUST follow this sequence to initialize a device:
> > > > > > > > > 1. Reset the device.
> > > > > > > > > 2. Set the ACKNOWLEDGE status bit: the guest OS has noticed the device.
> > > > > > > > > 3. Set the DRIVER status bit: the guest OS knows how to drive the
> > > > > > > > > device.
> > > > > > > > > 4. Read device feature bits, and write the subset of feature bits
> > > > > > > > > understood by the OS and driver to the
> > > > > > > > > device. During this step the driver MAY read (but MUST NOT write)
> > > > > > > > > the device-specific configuration
> > > > > > > > > fields to check that it can support the device before accepting it.
> > > > > > > > > 5. Set the FEATURES_OK status bit. The driver MUST NOT accept new
> > > > > > > > > feature bits after this step.
> > > > > > > > > 6. Re-read device status to ensure the FEATURES_OK bit is still set:
> > > > > > > > > otherwise, the device does not
> > > > > > > > > support our subset of features and the device is unusable.
> > > > > > > > > 7. Perform device-specific setup, including discovery of virtqueues
> > > > > > > > > for the device, optional per-bus setup,
> > > > > > > > > reading and possibly writing the device’s virtio configuration
> > > > > > > > > space, and population of virtqueues.
> > > > > > > > > 8. Set the DRIVER_OK status bit. At this point the device is “live”.
> > > > > > > > > 
> > > > > > > > > 
> > > > > > > > > so accessing config space before FEATURES_OK is a spec violation, right?
> > > > > > > > It is, but it's not relevant to what this commit tries to address. I
> > > > > > > > thought the legacy guest still needs to be supported.
> > > > > > > > 
> > > > > > > > Having said, a separate patch has to be posted to fix the guest driver
> > > > > > > > issue where this discrepancy is introduced to virtnet_validate() (since
> > > > > > > > commit fe36cbe067). But it's not technically related to this patch.
> > > > > > > > 
> > > > > > > > -Siwei
> > > > > > > I think it's a bug to read config space in validate, we should move it to
> > > > > > > virtnet_probe().
> > > > > > > 
> > > > > > > Thanks
> > > > > > I take it back, reading but not writing seems to be explicitly allowed by spec.
> > > > > > So our way to detect a legacy guest is bogus, need to think what is
> > > > > > the best way to handle this.
> > > > > Then maybe revert commit fe36cbe067 and friends, and have QEMU detect legacy
> > > > > guest? Supposedly only config space write access needs to be guarded before
> > > > > setting FEATURES_OK.
> > > > > 
> > > > > -Siwie
> > > > Detecting it isn't enough though, we will need a new ioctl to notify
> > > > the kernel that it's a legacy guest. Ugh :(
> > > 
> > > I'm not sure I get this, how can we know if there's a legacy driver before
> > > set_features()?
> > qemu knows for sure. It does not communicate this information to the
> > kernel right now unfortunately.
> 
> 
> I may miss something, but I still don't get how the new ioctl is supposed to
> work.
> 
> Thanks



Basically on first guest access QEMU would tell kernel whether
guest is using the legacy or the modern interface.
E.g. virtio_pci_config_read/virtio_pci_config_write will call ioctl(ENABLE_LEGACY, 1)
while virtio_pci_common_read will call ioctl(ENABLE_LEGACY, 0)

Or maybe we just add GET_CONFIG_MODERN and GET_CONFIG_LEGACY and
call the correct ioctl ... there are many ways to build this API.

> 
> > 
> > > And I wonder what will hapeen if we just revert the set_features(0)?
> > > 
> > > Thanks
> > > 
> > > 
> > > > 
> > > > > > > > > > > Rejecting reset to 0
> > > > > > > > > > > prematurely causes correct MTU and link status unable to load
> > > > > > > > > > > for the very first config space access, rendering issues like
> > > > > > > > > > > guest showing inaccurate MTU value, or failure to reject
> > > > > > > > > > > out-of-range MTU.
> > > > > > > > > > > 
> > > > > > > > > > > Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for
> > > > > > > > > > > supported mlx5 devices")
> > > > > > > > > > > Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
> > > > > > > > > > > ---
> > > > > > > > > > >       drivers/vdpa/mlx5/net/mlx5_vnet.c | 15 +--------------
> > > > > > > > > > >       1 file changed, 1 insertion(+), 14 deletions(-)
> > > > > > > > > > > 
> > > > > > > > > > > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > > > > > b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > > > > > index 7c1f789..540dd67 100644
> > > > > > > > > > > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > > > > > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > > > > > @@ -1490,14 +1490,6 @@ static u64
> > > > > > > > > > > mlx5_vdpa_get_features(struct vdpa_device *vdev)
> > > > > > > > > > >           return mvdev->mlx_features;
> > > > > > > > > > >       }
> > > > > > > > > > > -static int verify_min_features(struct mlx5_vdpa_dev *mvdev,
> > > > > > > > > > > u64 features)
> > > > > > > > > > > -{
> > > > > > > > > > > -    if (!(features & BIT_ULL(VIRTIO_F_ACCESS_PLATFORM)))
> > > > > > > > > > > -        return -EOPNOTSUPP;
> > > > > > > > > > > -
> > > > > > > > > > > -    return 0;
> > > > > > > > > > > -}
> > > > > > > > > > > -
> > > > > > > > > > >       static int setup_virtqueues(struct mlx5_vdpa_net *ndev)
> > > > > > > > > > >       {
> > > > > > > > > > >           int err;
> > > > > > > > > > > @@ -1558,18 +1550,13 @@ static int
> > > > > > > > > > > mlx5_vdpa_set_features(struct vdpa_device *vdev, u64
> > > > > > > > > > > features)
> > > > > > > > > > >       {
> > > > > > > > > > >           struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
> > > > > > > > > > >           struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
> > > > > > > > > > > -    int err;
> > > > > > > > > > >           print_features(mvdev, features, true);
> > > > > > > > > > > -    err = verify_min_features(mvdev, features);
> > > > > > > > > > > -    if (err)
> > > > > > > > > > > -        return err;
> > > > > > > > > > > -
> > > > > > > > > > >           ndev->mvdev.actual_features = features &
> > > > > > > > > > > ndev->mvdev.mlx_features;
> > > > > > > > > > >           ndev->config.mtu = cpu_to_mlx5vdpa16(mvdev, ndev->mtu);
> > > > > > > > > > >           ndev->config.status |= cpu_to_mlx5vdpa16(mvdev,
> > > > > > > > > > > VIRTIO_NET_S_LINK_UP);
> > > > > > > > > > > -    return err;
> > > > > > > > > > > +    return 0;
> > > > > > > > > > >       }
> > > > > > > > > > >       static void mlx5_vdpa_set_config_cb(struct vdpa_device
> > > > > > > > > > > *vdev, struct vdpa_callback *cb)

