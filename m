Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEA47F2D55
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 12:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388291AbfKGLVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 06:21:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49054 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388022AbfKGLVk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 06:21:40 -0500
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 05155882FF
        for <netdev@vger.kernel.org>; Thu,  7 Nov 2019 11:21:40 +0000 (UTC)
Received: by mail-qt1-f200.google.com with SMTP id x50so2196545qth.4
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 03:21:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=wnfHxd+h5ByIy6pNIpYUPsi2zmTYpBRj65XvOkNtL/w=;
        b=Ap2dV2skqHkPgKM9Z8RyIP7gC3SOqjEKbeYczGCuKwmnQ5VC7C8mCtoZ930w5AJ07Y
         NGSMZiF3ultEBdUyJq5o+90rXDT0ICKu4P21olCs4i/1XonJ9TMGREXW49EAeLicwAgw
         VQA4jOSg72YU+TgCjKS4Gucjl9w7Jmv7BZlU6ynIYRRnq/0hiZDQSVb86wDaCH43vo+a
         kFT1efJT6EmssMIOqFVCILSgDI07UIKPbFu/gzB+EuhYN+1yNzv+ZmPiK8auGXelMdlz
         hepPV9C00AzT7NWZdJr+H0HR74/+FnDj939rqjNszqAERBOfPgMmMPqIIPKTWPgoFI8+
         yBTw==
X-Gm-Message-State: APjAAAVlhUdNEFmO5YbJ7V/kPdsD9SUA7U7iZo7b/aglrwcHxpYXnSmS
        R5XjnDfzCmYZob5A6fxfLwm64Nq87ZqMWgig9jVm2yeLpe0DHQfxTM/XvfZ0QRll2FpE7tmlKRA
        LMxLTXk1dWmGKhJG6
X-Received: by 2002:ac8:289d:: with SMTP id i29mr3319321qti.24.1573125698928;
        Thu, 07 Nov 2019 03:21:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqwLKHqje2IEEYthZFjXYN+ipb1SMK7JO7Dpv9RPMHrWqUxiMCMx6JeRQige0AiW+TwcjzGM5w==
X-Received: by 2002:ac8:289d:: with SMTP id i29mr3319270qti.24.1573125698659;
        Thu, 07 Nov 2019 03:21:38 -0800 (PST)
Received: from redhat.com (bzq-79-178-12-128.red.bezeqint.net. [79.178.12.128])
        by smtp.gmail.com with ESMTPSA id u27sm1182961qtj.5.2019.11.07.03.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 03:21:37 -0800 (PST)
Date:   Thu, 7 Nov 2019 06:21:26 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, tiwei.bie@intel.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        cohuck@redhat.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, zhenyuw@linux.intel.com,
        zhi.a.wang@intel.com, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
        airlied@linux.ie, daniel@ffwll.ch, farman@linux.ibm.com,
        pasic@linux.ibm.com, sebott@linux.ibm.com, oberpar@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        freude@linux.ibm.com, lingshan.zhu@intel.com, idos@mellanox.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com,
        stefanha@redhat.com
Subject: Re: [PATCH V10 6/6] docs: sample driver to demonstrate how to
 implement virtio-mdev framework
Message-ID: <20191107061942-mutt-send-email-mst@kernel.org>
References: <20191106133531.693-1-jasowang@redhat.com>
 <20191106133531.693-7-jasowang@redhat.com>
 <20191107040700-mutt-send-email-mst@kernel.org>
 <bd2f7796-8d88-0eb3-b55b-3ec062b186b7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bd2f7796-8d88-0eb3-b55b-3ec062b186b7@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 07, 2019 at 06:18:45PM +0800, Jason Wang wrote:
> 
> On 2019/11/7 下午5:08, Michael S. Tsirkin wrote:
> > On Wed, Nov 06, 2019 at 09:35:31PM +0800, Jason Wang wrote:
> > > This sample driver creates mdev device that simulate virtio net device
> > > over virtio mdev transport. The device is implemented through vringh
> > > and workqueue. A device specific dma ops is to make sure HVA is used
> > > directly as the IOVA. This should be sufficient for kernel virtio
> > > driver to work.
> > > 
> > > Only 'virtio' type is supported right now. I plan to add 'vhost' type
> > > on top which requires some virtual IOMMU implemented in this sample
> > > driver.
> > > 
> > > Acked-by: Cornelia Huck<cohuck@redhat.com>
> > > Signed-off-by: Jason Wang<jasowang@redhat.com>
> > I'd prefer it that we call this something else, e.g.
> > mvnet-loopback. Just so people don't expect a fully
> > functional device somehow. Can be renamed when applying?
> 
> 
> Actually, I plan to extend it as another standard network interface for
> kernel. It could be either a standalone pseudo device or a stack device.
> Does this sounds good to you?
> 
> Thanks

That's a big change in an interface so it's a good reason
to rename the driver at that point right?
Oherwise users of an old kernel would expect a stacked driver
and get a loopback instead.

Or did I miss something?

> 
> > 
> > 
