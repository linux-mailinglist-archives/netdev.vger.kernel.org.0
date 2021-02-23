Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912E3322885
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 11:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbhBWKD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 05:03:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31973 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230429AbhBWKDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 05:03:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614074500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fq9fMMA50uXmWN63AH4eeQqewule2njQVz39u52s5qo=;
        b=T9kBPs6nbi8KkWsGzaqe0GTY8YI+RR3Xx1bvok/fNa+8SlQWWENs4DKFuFbBH854Qd5nV2
        98gaqaAYFkVy0eBm5fVPukUl0No7BwLTFZnoV/P/HflvX2/hQetKwKQwcmqHy4CdsBNpmX
        GOFgrJK8cPYv7/LVNULUp9gJMif4ipo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-597-f6C4tC47PnWuZW9WyMUJaQ-1; Tue, 23 Feb 2021 05:01:36 -0500
X-MC-Unique: f6C4tC47PnWuZW9WyMUJaQ-1
Received: by mail-wm1-f69.google.com with SMTP id f185so499078wmf.8
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 02:01:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=fq9fMMA50uXmWN63AH4eeQqewule2njQVz39u52s5qo=;
        b=uKma4IttparyIk7SvpDafdA5RxWIbscThA8ajGPi3VcsLXb2mSGZqr8m79TP51mH+8
         iOKXxp6qYKOuUoTWYkajFIAZaG6cOxl5gGxEj6kpRobhfV0wVzc6i1YdWsA+0/pt3ba3
         qhyOBVdXAdnEjUNePRaLYRXoy/POYV0Vaq4aUZE+yQ7Wczi8DefQM+ewhVaAJ1bDZ248
         8kOn524mXuPHBk18IkMjkzPould5RPtkU7XZ40z8+QkENVAKp9XE2W68xqCUtKWwiZiN
         qYL6yE6Pl72vJQE276JRXd8II3Y5dflZqBSsRWoTNrq7mkMzAURQRqTEKDw0mUAeRmDD
         OCIA==
X-Gm-Message-State: AOAM530vwnu1AWGX6NAIFmKDR0mK8londeLytts8YQxTN1USGmmQmmMH
        Xwj6wB69Fp4pW20nm9LYJF1Q70k7PJV685Hvgo6ffFnQVWF0AtF28OlWvOA7e8ojt1wAdqxkrSX
        2m4rtB6iUemUVH0EA
X-Received: by 2002:adf:97d5:: with SMTP id t21mr1510162wrb.139.1614074495078;
        Tue, 23 Feb 2021 02:01:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzqzcytawXMdenSafG3a3yvlWPCUdXAY4CQjPGVhSoQqq+a9ZdeDw2NxLx25iW4TucswKLb7Q==
X-Received: by 2002:adf:97d5:: with SMTP id t21mr1510136wrb.139.1614074494799;
        Tue, 23 Feb 2021 02:01:34 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id z11sm2046114wmi.35.2021.02.23.02.01.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 02:01:33 -0800 (PST)
Date:   Tue, 23 Feb 2021 05:01:31 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>, elic@nvidia.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        virtio-dev@lists.oasis-open.org
Subject: Re: [PATCH] vdpa/mlx5: set_features should allow reset to zero
Message-ID: <20210223045600-mutt-send-email-mst@kernel.org>
References: <1613735698-3328-1-git-send-email-si-wei.liu@oracle.com>
 <605e7d2d-4f27-9688-17a8-d57191752ee7@redhat.com>
 <ee31e93b-5fbb-1999-0e82-983d3e49ad1e@oracle.com>
 <20210223041740-mutt-send-email-mst@kernel.org>
 <788a0880-0a68-20b7-5bdf-f8150b08276a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <788a0880-0a68-20b7-5bdf-f8150b08276a@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 05:46:20PM +0800, Jason Wang wrote:
> 
> On 2021/2/23 下午5:25, Michael S. Tsirkin wrote:
> > On Mon, Feb 22, 2021 at 09:09:28AM -0800, Si-Wei Liu wrote:
> > > 
> > > On 2/21/2021 8:14 PM, Jason Wang wrote:
> > > > On 2021/2/19 7:54 下午, Si-Wei Liu wrote:
> > > > > Commit 452639a64ad8 ("vdpa: make sure set_features is invoked
> > > > > for legacy") made an exception for legacy guests to reset
> > > > > features to 0, when config space is accessed before features
> > > > > are set. We should relieve the verify_min_features() check
> > > > > and allow features reset to 0 for this case.
> > > > > 
> > > > > It's worth noting that not just legacy guests could access
> > > > > config space before features are set. For instance, when
> > > > > feature VIRTIO_NET_F_MTU is advertised some modern driver
> > > > > will try to access and validate the MTU present in the config
> > > > > space before virtio features are set.
> > > > 
> > > > This looks like a spec violation:
> > > > 
> > > > "
> > > > 
> > > > The following driver-read-only field, mtu only exists if
> > > > VIRTIO_NET_F_MTU is set. This field specifies the maximum MTU for the
> > > > driver to use.
> > > > "
> > > > 
> > > > Do we really want to workaround this?
> > > Isn't the commit 452639a64ad8 itself is a workaround for legacy guest?
> > > 
> > > I think the point is, since there's legacy guest we'd have to support, this
> > > host side workaround is unavoidable. Although I agree the violating driver
> > > should be fixed (yes, it's in today's upstream kernel which exists for a
> > > while now).
> > Oh  you are right:
> > 
> > 
> > static int virtnet_validate(struct virtio_device *vdev)
> > {
> >          if (!vdev->config->get) {
> >                  dev_err(&vdev->dev, "%s failure: config access disabled\n",
> >                          __func__);
> >                  return -EINVAL;
> >          }
> > 
> >          if (!virtnet_validate_features(vdev))
> >                  return -EINVAL;
> > 
> >          if (virtio_has_feature(vdev, VIRTIO_NET_F_MTU)) {
> >                  int mtu = virtio_cread16(vdev,
> >                                           offsetof(struct virtio_net_config,
> >                                                    mtu));
> >                  if (mtu < MIN_MTU)
> >                          __virtio_clear_bit(vdev, VIRTIO_NET_F_MTU);
> 
> 
> I wonder why not simply fail here?

Back in 2016 it went like this:

	On Thu, Jun 02, 2016 at 05:10:59PM -0400, Aaron Conole wrote:
	> +     if (virtio_has_feature(vdev, VIRTIO_NET_F_MTU)) {
	> +             dev->mtu = virtio_cread16(vdev,
	> +                                       offsetof(struct virtio_net_config,
	> +                                                mtu));
	> +     }
	> +
	>       if (vi->any_header_sg)
	>               dev->needed_headroom = vi->hdr_len;
	> 

	One comment though: I think we should validate the mtu.
	If it's invalid, clear VIRTIO_NET_F_MTU and ignore.


Too late at this point :)

I guess it's a way to tell device "I can not live with this MTU",
device can fail FEATURES_OK if it wants to. MIN_MTU
is an internal linux thing and at the time I felt it's better to
try to make progress.


> 
> >          }
> > 
> >          return 0;
> > }
> > 
> > And the spec says:
> > 
> > 
> > The driver MUST follow this sequence to initialize a device:
> > 1. Reset the device.
> > 2. Set the ACKNOWLEDGE status bit: the guest OS has noticed the device.
> > 3. Set the DRIVER status bit: the guest OS knows how to drive the device.
> > 4. Read device feature bits, and write the subset of feature bits understood by the OS and driver to the
> > device. During this step the driver MAY read (but MUST NOT write) the device-specific configuration
> > fields to check that it can support the device before accepting it.
> > 5. Set the FEATURES_OK status bit. The driver MUST NOT accept new feature bits after this step.
> > 6. Re-read device status to ensure the FEATURES_OK bit is still set: otherwise, the device does not
> > support our subset of features and the device is unusable.
> > 7. Perform device-specific setup, including discovery of virtqueues for the device, optional per-bus setup,
> > reading and possibly writing the device’s virtio configuration space, and population of virtqueues.
> > 8. Set the DRIVER_OK status bit. At this point the device is “live”.
> > 
> > 
> > Item 4 on the list explicitly allows reading config space before
> > FEATURES_OK.
> > 
> > I conclude that VIRTIO_NET_F_MTU is set means "set in device features".
> 
> 
> So this probably need some clarification. "is set" is used many times in the
> spec that has different implications.
> 
> Thanks
> 
> 
> > 
> > Generally it is worth going over feature dependent config fields
> > and checking whether they should be present when device feature is set
> > or when feature bit has been negotiated, and making this clear.
> > 

