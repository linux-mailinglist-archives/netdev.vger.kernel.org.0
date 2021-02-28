Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30F57327498
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 22:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhB1Vad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 16:30:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53148 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231162AbhB1Va0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 16:30:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614547739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GwitB7tmJHor6lKADpKSPcH+bNxWXn08rGoAHV5xDeo=;
        b=F8EeKrRtLA0R7xBypN8vW+mf8ekHJUlWh5EVTMFIGw/lVkzT7Bm1wke1jv/7UBsBbTZwvv
        4LzQOgGvFqA0/MvmY0ugF550ny7g6FNqwQdAlsRoB2qoA/MYK5+FQ+92cQJpCsDHibQt6t
        6Wy9TeZSGekJq/BSJ3FQ30hxPFxSgGs=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-pm5UCUqnMQSwNHlKkGMSzg-1; Sun, 28 Feb 2021 16:28:57 -0500
X-MC-Unique: pm5UCUqnMQSwNHlKkGMSzg-1
Received: by mail-ed1-f72.google.com with SMTP id g20so7822810edr.6
        for <netdev@vger.kernel.org>; Sun, 28 Feb 2021 13:28:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=GwitB7tmJHor6lKADpKSPcH+bNxWXn08rGoAHV5xDeo=;
        b=YwZ93gf03T9XSSOgJuxfx6CZzE7J8EseA0T5cLusufDofC43hNECHLgX4DMcQKBOUo
         kkmw2lViHeEJ2qVSJvioumpeMm2ZsnjSa1BnltS8dwStCjqOXGg3FTaB5LIqhR0bkUYt
         VP3qXrdBX0ejqjQ6/bNiWio9t3yIMpSd8xVDGs2IHS3VtwT7HSxL3qZViJpYafAideTW
         /dSXPzaBvawT2n//xiT6jybrZvytyBNCy7LT/XslhrRFGHkbYRlZeXHy2+ssoJaGNOtj
         sbHgL9c0Qdu8OLZvHtn1Q5WwHGlG2kMZtjolZs313JCKG09EWN00GfEDt3Iwu28ME2Mj
         4x2Q==
X-Gm-Message-State: AOAM531TKmLJ9jHsMFgNWcTGkb/OebtPJSLvY10dSn6fxJ65l9UD7VlI
        qH1Iw5cIifwmYFaCuM0nGGGxZFuLWTFLcIDR8/FjYa9NpI+UzgTEhl43fcpidyobdukEZafgqC4
        /7sj+p5z6Ch+1IRkC
X-Received: by 2002:a17:906:32c5:: with SMTP id k5mr12555461ejk.249.1614547736016;
        Sun, 28 Feb 2021 13:28:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzAVsa1rVUShElsu/jH2CLezpldoPZzydNiv+5BgmwRkiWsGZ/DvQoLF+G1p2t3dj0L2+6pRA==
X-Received: by 2002:a17:906:32c5:: with SMTP id k5mr12555456ejk.249.1614547735871;
        Sun, 28 Feb 2021 13:28:55 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id fi11sm9432236ejb.73.2021.02.28.13.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 13:28:55 -0800 (PST)
Date:   Sun, 28 Feb 2021 16:28:53 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Si-Wei Liu <si-wei.liu@oracle.com>
Cc:     Jason Wang <jasowang@redhat.com>, elic@nvidia.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vdpa/mlx5: set_features should allow reset to zero
Message-ID: <20210228162802-mutt-send-email-mst@kernel.org>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52836a63-4e00-ff58-50fb-9f450ce968d7@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 10:24:41AM -0800, Si-Wei Liu wrote:
> 
> 
> On 2/23/2021 9:04 PM, Michael S. Tsirkin wrote:
> > On Tue, Feb 23, 2021 at 11:35:57AM -0800, Si-Wei Liu wrote:
> > > 
> > > On 2/23/2021 5:26 AM, Michael S. Tsirkin wrote:
> > > > On Tue, Feb 23, 2021 at 10:03:57AM +0800, Jason Wang wrote:
> > > > > On 2021/2/23 9:12 上午, Si-Wei Liu wrote:
> > > > > > On 2/21/2021 11:34 PM, Michael S. Tsirkin wrote:
> > > > > > > On Mon, Feb 22, 2021 at 12:14:17PM +0800, Jason Wang wrote:
> > > > > > > > On 2021/2/19 7:54 下午, Si-Wei Liu wrote:
> > > > > > > > > Commit 452639a64ad8 ("vdpa: make sure set_features is invoked
> > > > > > > > > for legacy") made an exception for legacy guests to reset
> > > > > > > > > features to 0, when config space is accessed before features
> > > > > > > > > are set. We should relieve the verify_min_features() check
> > > > > > > > > and allow features reset to 0 for this case.
> > > > > > > > > 
> > > > > > > > > It's worth noting that not just legacy guests could access
> > > > > > > > > config space before features are set. For instance, when
> > > > > > > > > feature VIRTIO_NET_F_MTU is advertised some modern driver
> > > > > > > > > will try to access and validate the MTU present in the config
> > > > > > > > > space before virtio features are set.
> > > > > > > > This looks like a spec violation:
> > > > > > > > 
> > > > > > > > "
> > > > > > > > 
> > > > > > > > The following driver-read-only field, mtu only exists if
> > > > > > > > VIRTIO_NET_F_MTU is
> > > > > > > > set.
> > > > > > > > This field specifies the maximum MTU for the driver to use.
> > > > > > > > "
> > > > > > > > 
> > > > > > > > Do we really want to workaround this?
> > > > > > > > 
> > > > > > > > Thanks
> > > > > > > And also:
> > > > > > > 
> > > > > > > The driver MUST follow this sequence to initialize a device:
> > > > > > > 1. Reset the device.
> > > > > > > 2. Set the ACKNOWLEDGE status bit: the guest OS has noticed the device.
> > > > > > > 3. Set the DRIVER status bit: the guest OS knows how to drive the
> > > > > > > device.
> > > > > > > 4. Read device feature bits, and write the subset of feature bits
> > > > > > > understood by the OS and driver to the
> > > > > > > device. During this step the driver MAY read (but MUST NOT write)
> > > > > > > the device-specific configuration
> > > > > > > fields to check that it can support the device before accepting it.
> > > > > > > 5. Set the FEATURES_OK status bit. The driver MUST NOT accept new
> > > > > > > feature bits after this step.
> > > > > > > 6. Re-read device status to ensure the FEATURES_OK bit is still set:
> > > > > > > otherwise, the device does not
> > > > > > > support our subset of features and the device is unusable.
> > > > > > > 7. Perform device-specific setup, including discovery of virtqueues
> > > > > > > for the device, optional per-bus setup,
> > > > > > > reading and possibly writing the device’s virtio configuration
> > > > > > > space, and population of virtqueues.
> > > > > > > 8. Set the DRIVER_OK status bit. At this point the device is “live”.
> > > > > > > 
> > > > > > > 
> > > > > > > so accessing config space before FEATURES_OK is a spec violation, right?
> > > > > > It is, but it's not relevant to what this commit tries to address. I
> > > > > > thought the legacy guest still needs to be supported.
> > > > > > 
> > > > > > Having said, a separate patch has to be posted to fix the guest driver
> > > > > > issue where this discrepancy is introduced to virtnet_validate() (since
> > > > > > commit fe36cbe067). But it's not technically related to this patch.
> > > > > > 
> > > > > > -Siwei
> > > > > I think it's a bug to read config space in validate, we should move it to
> > > > > virtnet_probe().
> > > > > 
> > > > > Thanks
> > > > I take it back, reading but not writing seems to be explicitly allowed by spec.
> > > > So our way to detect a legacy guest is bogus, need to think what is
> > > > the best way to handle this.
> > > Then maybe revert commit fe36cbe067 and friends, and have QEMU detect legacy
> > > guest? Supposedly only config space write access needs to be guarded before
> > > setting FEATURES_OK.
> > > 
> > > -Siwie
> > Detecting it isn't enough though, we will need a new ioctl to notify
> > the kernel that it's a legacy guest. Ugh :(
> Well, although I think adding an ioctl is doable, may I know what the use
> case there will be for kernel to leverage such info directly? Is there a
> case QEMU can't do with dedicate ioctls later if there's indeed
> differentiation (legacy v.s. modern) needed?
> 
> One of the reason I asked is if this ioctl becomes a mandate for vhost-vdpa
> kernel. QEMU would reject initialize vhost-vdpa if doesn't see this ioctl
> coming?

Only on BE hosts or guests I think. With LE host and guest legacy and
modern behave the same so ioctl isn't needed.

> If it's optional, suppose the kernel may need it only when it becomes
> necessary?
> 
> Thanks,
> -Siwei

