Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5A903227C9
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 10:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbhBWJ1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 04:27:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34635 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232014AbhBWJ0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 04:26:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614072314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+RC4HKdCieSzE1GPP3nuYiwb9hCgiuXOjbDbgHSeYuQ=;
        b=WdICmBex27NjpNfmmyI3+2ys2w3Njj2WgMS5tRAzTHIxfk782gwbW9UI31FNO9NGQh0CE5
        h4mSCu0zcyE+G7ECMfLy1IN3AB27nwDk0si5dq3/u0BgtxUgvtfvFXrbj6r17PHILgMNhz
        bAYFxUGQTJyeAkayLURCuzlGfKR9z/Q=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-XkVgOhixNf-i9Y01w94kew-1; Tue, 23 Feb 2021 04:25:10 -0500
X-MC-Unique: XkVgOhixNf-i9Y01w94kew-1
Received: by mail-wm1-f69.google.com with SMTP id w20so46257wmc.0
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 01:25:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+RC4HKdCieSzE1GPP3nuYiwb9hCgiuXOjbDbgHSeYuQ=;
        b=XTDC+K9OQ50QVsimUIYDhUnZxnFbR5yeG+R4Zg6hmSQNFIxgCUOwOs10DfunPhMj0n
         27LQRsAJm7UuUVxrgW+YiDMhCEM34cbWXwGKLN94PlDrs6avlMd/hthmXkenGD+dGPgk
         VR8+0ijaOrrrsaL1jhah3ot1eska9Pcd5VirS6KWUfCOpbGW/iFh9KlaJfIpRgEnMZkO
         fsYbYEIuw/ep6T+JcQU6GgSCfe3zN3QSNlHWI4r9RKCCbj/q5ieNzms4AKH802A7hR5f
         lF1cU545blzAPXWaQVXHI9qG6Ea6OwvPL1nvskSZWNb7HkIG9LHuOptEH3Xe4upSSrLl
         vOew==
X-Gm-Message-State: AOAM5305wPdL0eTmbaULzOlf/X4wF58VRbt7FEWwJ+XtVpmESRqXL29f
        GDYzKfDhgP/GP3kZEigAuS6/aWcgTNSCScQsTf96r1sRza278Mb5P3EzyiggCEDuUOFOeVctzxu
        UsoeI4SwdIGseh0Qu
X-Received: by 2002:a1c:5419:: with SMTP id i25mr24758760wmb.166.1614072309011;
        Tue, 23 Feb 2021 01:25:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxbWivNJ1jHNPfZXygVu+eudCK5iHdHVpEBEzm8ae6yMWWk75xprjTHIR+p+f5S+Nq1VlaorA==
X-Received: by 2002:a1c:5419:: with SMTP id i25mr24758746wmb.166.1614072308817;
        Tue, 23 Feb 2021 01:25:08 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id a6sm2054052wmj.23.2021.02.23.01.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 01:25:07 -0800 (PST)
Date:   Tue, 23 Feb 2021 04:25:05 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Si-Wei Liu <si-wei.liu@oracle.com>
Cc:     Jason Wang <jasowang@redhat.com>, elic@nvidia.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        virtio-dev@lists.oasis-open.org
Subject: Re: [PATCH] vdpa/mlx5: set_features should allow reset to zero
Message-ID: <20210223041740-mutt-send-email-mst@kernel.org>
References: <1613735698-3328-1-git-send-email-si-wei.liu@oracle.com>
 <605e7d2d-4f27-9688-17a8-d57191752ee7@redhat.com>
 <ee31e93b-5fbb-1999-0e82-983d3e49ad1e@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ee31e93b-5fbb-1999-0e82-983d3e49ad1e@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 22, 2021 at 09:09:28AM -0800, Si-Wei Liu wrote:
> 
> 
> On 2/21/2021 8:14 PM, Jason Wang wrote:
> > 
> > On 2021/2/19 7:54 下午, Si-Wei Liu wrote:
> > > Commit 452639a64ad8 ("vdpa: make sure set_features is invoked
> > > for legacy") made an exception for legacy guests to reset
> > > features to 0, when config space is accessed before features
> > > are set. We should relieve the verify_min_features() check
> > > and allow features reset to 0 for this case.
> > > 
> > > It's worth noting that not just legacy guests could access
> > > config space before features are set. For instance, when
> > > feature VIRTIO_NET_F_MTU is advertised some modern driver
> > > will try to access and validate the MTU present in the config
> > > space before virtio features are set.
> > 
> > 
> > This looks like a spec violation:
> > 
> > "
> > 
> > The following driver-read-only field, mtu only exists if
> > VIRTIO_NET_F_MTU is set. This field specifies the maximum MTU for the
> > driver to use.
> > "
> > 
> > Do we really want to workaround this?
> 
> Isn't the commit 452639a64ad8 itself is a workaround for legacy guest?
> 
> I think the point is, since there's legacy guest we'd have to support, this
> host side workaround is unavoidable. Although I agree the violating driver
> should be fixed (yes, it's in today's upstream kernel which exists for a
> while now).

Oh  you are right:


static int virtnet_validate(struct virtio_device *vdev)
{
        if (!vdev->config->get) {
                dev_err(&vdev->dev, "%s failure: config access disabled\n",
                        __func__);
                return -EINVAL;
        }

        if (!virtnet_validate_features(vdev))
                return -EINVAL;

        if (virtio_has_feature(vdev, VIRTIO_NET_F_MTU)) {
                int mtu = virtio_cread16(vdev,
                                         offsetof(struct virtio_net_config,
                                                  mtu));
                if (mtu < MIN_MTU)
                        __virtio_clear_bit(vdev, VIRTIO_NET_F_MTU);
        }

        return 0;
}

And the spec says:


The driver MUST follow this sequence to initialize a device:
1. Reset the device.
2. Set the ACKNOWLEDGE status bit: the guest OS has noticed the device.
3. Set the DRIVER status bit: the guest OS knows how to drive the device.
4. Read device feature bits, and write the subset of feature bits understood by the OS and driver to the
device. During this step the driver MAY read (but MUST NOT write) the device-specific configuration
fields to check that it can support the device before accepting it.
5. Set the FEATURES_OK status bit. The driver MUST NOT accept new feature bits after this step.
6. Re-read device status to ensure the FEATURES_OK bit is still set: otherwise, the device does not
support our subset of features and the device is unusable.
7. Perform device-specific setup, including discovery of virtqueues for the device, optional per-bus setup,
reading and possibly writing the device’s virtio configuration space, and population of virtqueues.
8. Set the DRIVER_OK status bit. At this point the device is “live”.


Item 4 on the list explicitly allows reading config space before
FEATURES_OK.

I conclude that VIRTIO_NET_F_MTU is set means "set in device features".

Generally it is worth going over feature dependent config fields
and checking whether they should be present when device feature is set
or when feature bit has been negotiated, and making this clear.

-- 
MST

