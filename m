Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 568663237BD
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 08:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234382AbhBXHOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 02:14:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22386 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234379AbhBXHNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 02:13:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614150727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s5urpx7+14Nbuik1VeRNoEiZMhIyaDIyvE6g+cvtgSs=;
        b=iWAgH7TQjfMVNTQslIiANLWHRqi8E8u/V9Bc1faPlSidPxQvCVWpNNoVbJOlWmFrSGNEou
        RRXEupjcrI7L87ph4d/g1WVnlg/idQH15FCtmMBxr36A+xc3DboPYLBtrN3aKngtiZPfFX
        dd2QfaxbKYq/dhGZtXrh/TWK7VPiX/U=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-MP66aaGSMM-RE8FIYZWdMQ-1; Wed, 24 Feb 2021 02:12:06 -0500
X-MC-Unique: MP66aaGSMM-RE8FIYZWdMQ-1
Received: by mail-wm1-f71.google.com with SMTP id h16so169605wmq.8
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 23:12:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=s5urpx7+14Nbuik1VeRNoEiZMhIyaDIyvE6g+cvtgSs=;
        b=shGayb9VluXfJSCi3iVs9wRDQb4K3yERYXwULmE0EQm8Xz73kBbGLmgyonYICPFe+1
         OBOX1Q5UpXR83FT1KosEXTqt3OKCF7MwF/pqIOL4D1+8p6Fq57S402aTYDixV7kbDbeu
         cmGu1Bum+ObCpwSF6HRh5JTDF4nnrFWoq8DZWI/Pc1nUIWX7AkZUEnJ5VHnD25dzM482
         e6vBpTf73jfOHJdIZXCmHo8zeK8d+W9J3+pxFdHul+4C2A0q9KEswQ3h4fcY+ICIytrQ
         0LrGQdNK5zoIbMQF6At+a8peIBLu7QqZL+drb5gk4ZdK0T0XdBTtnHAwEoFKvhk5BQH1
         uYTw==
X-Gm-Message-State: AOAM530IHX8vtExfkmUx+XHYMw49aSsY9kqGQirdNbzM/a0+CgYOtExd
        VMJajYbRO53ZnK8jdjvwTEfRKJKIIdcP3mNNzizvCkE06CX5mTrJl9VZvf+Cmsv6MTqM+sqaEIQ
        o8LqR6QyHMVNHfmxp
X-Received: by 2002:a1c:4444:: with SMTP id r65mr2340660wma.22.1614150724365;
        Tue, 23 Feb 2021 23:12:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwadgw2sbmpJNGXYqDbem1Ufvnw+j0n4YzrCFoLPNbR6eiG3H/7UMUwjHA8tQWn5GnaAdb2QA==
X-Received: by 2002:a1c:4444:: with SMTP id r65mr2340640wma.22.1614150724189;
        Tue, 23 Feb 2021 23:12:04 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id p12sm1269626wmq.1.2021.02.23.23.12.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 23:12:03 -0800 (PST)
Date:   Wed, 24 Feb 2021 02:12:01 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Eli Cohen <elic@nvidia.com>, Si-Wei Liu <si-wei.liu@oracle.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vdpa/mlx5: set_features should allow reset to zero
Message-ID: <20210224021054-mutt-send-email-mst@kernel.org>
References: <20210222023040-mutt-send-email-mst@kernel.org>
 <22fe5923-635b-59f0-7643-2fd5876937c2@oracle.com>
 <fae0bae7-e4cd-a3aa-57fe-d707df99b634@redhat.com>
 <20210223082536-mutt-send-email-mst@kernel.org>
 <3ff5fd23-1db0-2f95-4cf9-711ef403fb62@oracle.com>
 <7e6291a4-30b1-6b59-a2bf-713e7b56826d@redhat.com>
 <20210224000528-mutt-send-email-mst@kernel.org>
 <20210224064520.GA204317@mtl-vdi-166.wap.labs.mlnx>
 <20210224014700-mutt-send-email-mst@kernel.org>
 <ef775724-b5fb-ca70-ed2f-f23d8fbf4cd8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ef775724-b5fb-ca70-ed2f-f23d8fbf4cd8@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 02:55:13PM +0800, Jason Wang wrote:
> 
> On 2021/2/24 2:47 下午, Michael S. Tsirkin wrote:
> > On Wed, Feb 24, 2021 at 08:45:20AM +0200, Eli Cohen wrote:
> > > On Wed, Feb 24, 2021 at 12:17:58AM -0500, Michael S. Tsirkin wrote:
> > > > On Wed, Feb 24, 2021 at 11:20:01AM +0800, Jason Wang wrote:
> > > > > On 2021/2/24 3:35 上午, Si-Wei Liu wrote:
> > > > > > 
> > > > > > On 2/23/2021 5:26 AM, Michael S. Tsirkin wrote:
> > > > > > > On Tue, Feb 23, 2021 at 10:03:57AM +0800, Jason Wang wrote:
> > > > > > > > On 2021/2/23 9:12 上午, Si-Wei Liu wrote:
> > > > > > > > > On 2/21/2021 11:34 PM, Michael S. Tsirkin wrote:
> > > > > > > > > > On Mon, Feb 22, 2021 at 12:14:17PM +0800, Jason Wang wrote:
> > > > > > > > > > > On 2021/2/19 7:54 下午, Si-Wei Liu wrote:
> > > > > > > > > > > > Commit 452639a64ad8 ("vdpa: make sure set_features is invoked
> > > > > > > > > > > > for legacy") made an exception for legacy guests to reset
> > > > > > > > > > > > features to 0, when config space is accessed before features
> > > > > > > > > > > > are set. We should relieve the verify_min_features() check
> > > > > > > > > > > > and allow features reset to 0 for this case.
> > > > > > > > > > > > 
> > > > > > > > > > > > It's worth noting that not just legacy guests could access
> > > > > > > > > > > > config space before features are set. For instance, when
> > > > > > > > > > > > feature VIRTIO_NET_F_MTU is advertised some modern driver
> > > > > > > > > > > > will try to access and validate the MTU present in the config
> > > > > > > > > > > > space before virtio features are set.
> > > > > > > > > > > This looks like a spec violation:
> > > > > > > > > > > 
> > > > > > > > > > > "
> > > > > > > > > > > 
> > > > > > > > > > > The following driver-read-only field, mtu only exists if
> > > > > > > > > > > VIRTIO_NET_F_MTU is
> > > > > > > > > > > set.
> > > > > > > > > > > This field specifies the maximum MTU for the driver to use.
> > > > > > > > > > > "
> > > > > > > > > > > 
> > > > > > > > > > > Do we really want to workaround this?
> > > > > > > > > > > 
> > > > > > > > > > > Thanks
> > > > > > > > > > And also:
> > > > > > > > > > 
> > > > > > > > > > The driver MUST follow this sequence to initialize a device:
> > > > > > > > > > 1. Reset the device.
> > > > > > > > > > 2. Set the ACKNOWLEDGE status bit: the guest OS has
> > > > > > > > > > noticed the device.
> > > > > > > > > > 3. Set the DRIVER status bit: the guest OS knows how to drive the
> > > > > > > > > > device.
> > > > > > > > > > 4. Read device feature bits, and write the subset of feature bits
> > > > > > > > > > understood by the OS and driver to the
> > > > > > > > > > device. During this step the driver MAY read (but MUST NOT write)
> > > > > > > > > > the device-specific configuration
> > > > > > > > > > fields to check that it can support the device before accepting it.
> > > > > > > > > > 5. Set the FEATURES_OK status bit. The driver MUST NOT accept new
> > > > > > > > > > feature bits after this step.
> > > > > > > > > > 6. Re-read device status to ensure the FEATURES_OK bit is still set:
> > > > > > > > > > otherwise, the device does not
> > > > > > > > > > support our subset of features and the device is unusable.
> > > > > > > > > > 7. Perform device-specific setup, including discovery of virtqueues
> > > > > > > > > > for the device, optional per-bus setup,
> > > > > > > > > > reading and possibly writing the device’s virtio configuration
> > > > > > > > > > space, and population of virtqueues.
> > > > > > > > > > 8. Set the DRIVER_OK status bit. At this point the device is “live”.
> > > > > > > > > > 
> > > > > > > > > > 
> > > > > > > > > > so accessing config space before FEATURES_OK is a spec
> > > > > > > > > > violation, right?
> > > > > > > > > It is, but it's not relevant to what this commit tries to address. I
> > > > > > > > > thought the legacy guest still needs to be supported.
> > > > > > > > > 
> > > > > > > > > Having said, a separate patch has to be posted to fix the guest driver
> > > > > > > > > issue where this discrepancy is introduced to
> > > > > > > > > virtnet_validate() (since
> > > > > > > > > commit fe36cbe067). But it's not technically related to this patch.
> > > > > > > > > 
> > > > > > > > > -Siwei
> > > > > > > > I think it's a bug to read config space in validate, we should
> > > > > > > > move it to
> > > > > > > > virtnet_probe().
> > > > > > > > 
> > > > > > > > Thanks
> > > > > > > I take it back, reading but not writing seems to be explicitly
> > > > > > > allowed by spec.
> > > > > > > So our way to detect a legacy guest is bogus, need to think what is
> > > > > > > the best way to handle this.
> > > > > > Then maybe revert commit fe36cbe067 and friends, and have QEMU detect
> > > > > > legacy guest? Supposedly only config space write access needs to be
> > > > > > guarded before setting FEATURES_OK.
> > > > > 
> > > > > I agree. My understanding is that all vDPA must be modern device (since
> > > > > VIRITO_F_ACCESS_PLATFORM is mandated) instead of transitional device.
> > > > > 
> > > > > Thanks
> > > > Well mlx5 has some code to handle legacy guests ...
> > > > Eli, could you comment? Is that support unused right now?
> > > > 
> > > If you mean support for version 1.0, well the knob is there but it's not
> > > set in the firmware I use. Note sure if we will support this.
> > Hmm you mean it's legacy only right now?
> > Well at some point you will want advanced goodies like RSS
> > and all that is gated on 1.0 ;)
> 
> 
> So if my understanding is correct the device/firmware is legacy but require
> VIRTIO_F_ACCESS_PLATFORM semanic? Looks like a spec violation?
> 
> Thanks

Legacy mode description is the spec is non-normative. As such as long as
guests work, they work ;)

> 
> > 
> > > > > > -Siwie
> > > > > > 
> > > > > > > > > > > > Rejecting reset to 0
> > > > > > > > > > > > prematurely causes correct MTU and link status unable to load
> > > > > > > > > > > > for the very first config space access, rendering issues like
> > > > > > > > > > > > guest showing inaccurate MTU value, or failure to reject
> > > > > > > > > > > > out-of-range MTU.
> > > > > > > > > > > > 
> > > > > > > > > > > > Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for
> > > > > > > > > > > > supported mlx5 devices")
> > > > > > > > > > > > Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
> > > > > > > > > > > > ---
> > > > > > > > > > > >      drivers/vdpa/mlx5/net/mlx5_vnet.c | 15 +--------------
> > > > > > > > > > > >      1 file changed, 1 insertion(+), 14 deletions(-)
> > > > > > > > > > > > 
> > > > > > > > > > > > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > > > > > > b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > > > > > > index 7c1f789..540dd67 100644
> > > > > > > > > > > > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > > > > > > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > > > > > > @@ -1490,14 +1490,6 @@ static u64
> > > > > > > > > > > > mlx5_vdpa_get_features(struct vdpa_device *vdev)
> > > > > > > > > > > >          return mvdev->mlx_features;
> > > > > > > > > > > >      }
> > > > > > > > > > > > -static int verify_min_features(struct mlx5_vdpa_dev *mvdev,
> > > > > > > > > > > > u64 features)
> > > > > > > > > > > > -{
> > > > > > > > > > > > -    if (!(features & BIT_ULL(VIRTIO_F_ACCESS_PLATFORM)))
> > > > > > > > > > > > -        return -EOPNOTSUPP;
> > > > > > > > > > > > -
> > > > > > > > > > > > -    return 0;
> > > > > > > > > > > > -}
> > > > > > > > > > > > -
> > > > > > > > > > > >      static int setup_virtqueues(struct mlx5_vdpa_net *ndev)
> > > > > > > > > > > >      {
> > > > > > > > > > > >          int err;
> > > > > > > > > > > > @@ -1558,18 +1550,13 @@ static int
> > > > > > > > > > > > mlx5_vdpa_set_features(struct vdpa_device *vdev, u64
> > > > > > > > > > > > features)
> > > > > > > > > > > >      {
> > > > > > > > > > > >          struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
> > > > > > > > > > > >          struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
> > > > > > > > > > > > -    int err;
> > > > > > > > > > > >          print_features(mvdev, features, true);
> > > > > > > > > > > > -    err = verify_min_features(mvdev, features);
> > > > > > > > > > > > -    if (err)
> > > > > > > > > > > > -        return err;
> > > > > > > > > > > > -
> > > > > > > > > > > >          ndev->mvdev.actual_features = features &
> > > > > > > > > > > > ndev->mvdev.mlx_features;
> > > > > > > > > > > >          ndev->config.mtu = cpu_to_mlx5vdpa16(mvdev, ndev->mtu);
> > > > > > > > > > > >          ndev->config.status |= cpu_to_mlx5vdpa16(mvdev,
> > > > > > > > > > > > VIRTIO_NET_S_LINK_UP);
> > > > > > > > > > > > -    return err;
> > > > > > > > > > > > +    return 0;
> > > > > > > > > > > >      }
> > > > > > > > > > > >      static void mlx5_vdpa_set_config_cb(struct vdpa_device
> > > > > > > > > > > > *vdev, struct vdpa_callback *cb)

