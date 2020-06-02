Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E86A61EB4F4
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 07:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725921AbgFBFPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 01:15:22 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:47859 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725781AbgFBFPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 01:15:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591074920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Omt9gJipjlxk0xAiBkDipMLYpK/jCtWILzTzD1eFi2g=;
        b=IMukX3sOMlM8mgpuDBgEJx7qRf7dV6flhp4QzdZOJqHVfHbzK6nzzOZWIZwPmaA1ERyUMZ
        xZkdHXhr8FDX1cxfedAp1VGBp1VNI4cSze6y8E4cG3yLSZujyi2z07heo3SgCLfy8qxxG4
        4y5VuwtYiW15TQRz1ND4sbDy7VDFUto=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-WI4c_0yhOn6xPZNj3CCkrw-1; Tue, 02 Jun 2020 01:09:38 -0400
X-MC-Unique: WI4c_0yhOn6xPZNj3CCkrw-1
Received: by mail-wr1-f70.google.com with SMTP id h92so870998wrh.23
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 22:09:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Omt9gJipjlxk0xAiBkDipMLYpK/jCtWILzTzD1eFi2g=;
        b=rmL2sgiUi/ezPMxLRUboGor62FgSGn0PbNz1rDTqxy3w++iI1a8Ul3M5C1HJ3hQLsT
         ObQ0bfikYC/yQtb8FGVKNMuWiJ1SjF/fm+hec/EIkje5KpzloGWFIw2ecKzzagpvKSV5
         Ac3DrD5TylYc3YZ5fHhC+td7hm0xVOeBkILsYPo0VkTupdwpeB+QXKwWfYt1lxgbsxOp
         8oiMWI6yReny47/BGBqEbs6VTx1fz0kGLSF8E/XcTzvqcdEoMM0votYwJkhPdCQrZ+71
         pP/VUUdfTnyRsU1aqDBKiq8LUkmZO1bHbdmGstmtkd/svq+kqvcxEtfaDyh6oFb4PKU4
         335w==
X-Gm-Message-State: AOAM530ru1czaU0ZTj6bQj/6RH4PIcDRYfi9/qEzLdOH6+m2JHgFsCNq
        ooQNmCYVdZuUVnV4e9eoDlFF4atX5UDjoCMPXT/SpPtc8BYS6At+Q7Scp5gr7gMfKtcj7jJyX5u
        2mQpshRaH+lVi96SL
X-Received: by 2002:a05:6000:11cd:: with SMTP id i13mr23481646wrx.141.1591074577588;
        Mon, 01 Jun 2020 22:09:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzC4LVeDOhERR8qf9AS4nc4Mi6WpaPRsevGBTu/GWRHQywd6PHu2y8E93bGd9V5IBqDeftUgQ==
X-Received: by 2002:a05:6000:11cd:: with SMTP id i13mr23481639wrx.141.1591074577444;
        Mon, 01 Jun 2020 22:09:37 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id a3sm1785369wmb.7.2020.06.01.22.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 22:09:36 -0700 (PDT)
Date:   Tue, 2 Jun 2020 01:09:34 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.miller@broadcom.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com, gdawar@xilinx.com,
        saugatm@xilinx.com, vmireyno@marvell.com,
        zhangweining@ruijie.com.cn, eli@mellanox.com
Subject: Re: [PATCH 5/6] vdpa: introduce virtio pci driver
Message-ID: <20200602010809-mutt-send-email-mst@kernel.org>
References: <20200529080303.15449-1-jasowang@redhat.com>
 <20200529080303.15449-6-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529080303.15449-6-jasowang@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 04:03:02PM +0800, Jason Wang wrote:
> Note that since virtio specification does not support get/restore
> virtqueue state. So we can not use this driver for VM. This can be
> addressed by extending the virtio specification.

Looks like exactly the kind of hardware limitation VDPA is supposed to
paper over within guest. So I suggest we use this as
a litmus test, and find ways for VDPA to handle this without
spec changes.

-- 
MST

