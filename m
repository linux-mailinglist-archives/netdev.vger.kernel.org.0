Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC3C1A5D80
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 10:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgDLIiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 04:38:07 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50760 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725903AbgDLIiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 04:38:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586680684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pa4kCZZR1TWcPuT6bVou7G+wE1hyHACGM2NIHCRQaQs=;
        b=KXV3YmBCiEnkCdf7mITtScEV8BJgcPlHeV7CKpWO4kn7TisIjOIN0Cu51joHs7CmKT8cg7
        1rl7/KETRUSoq6EMU0Tf9nS1QMX+gWi3dhu6by6HPF5ExCqsJXLePcnLe6L8FlPbVM7yqS
        YCR5cHndY33R/oEqdxFLmsg34okPK/8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-GRobfD92MHS_lEz3aVZc_Q-1; Sun, 12 Apr 2020 04:38:02 -0400
X-MC-Unique: GRobfD92MHS_lEz3aVZc_Q-1
Received: by mail-wr1-f70.google.com with SMTP id p16so1857297wro.16
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 01:38:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pa4kCZZR1TWcPuT6bVou7G+wE1hyHACGM2NIHCRQaQs=;
        b=fQnxQzYb4uzInsUpvgYNaMJRxaqob1UHXsC2COSOB1ltZqsa0zrGmNW8N6+HSuhlpo
         pV0VEdVtV170D+WX61MkKKmJ8etzAgpOXvYvzjq9QOmEEkpmrSb4mSqsYGhoRSQQmbUb
         V7yxGIl9y4NGNShD6WezgNS7yTq7Z6jKkEktCPIRyCdK01QBz4d7zDN01gneH+eaQ7WA
         3MxudTYYczmyNrKwNdgg0ifn/89xD+hw8059dA8ZEdln55k4uAVL+/3NzUCJ8drAByrT
         Q1DDblX5Jd4c8WFARr82NoT8QZepGIAZJmVsYTaDnkIdkAiDbPJPNmPY74nWFazrF4Wi
         /ipg==
X-Gm-Message-State: AGi0Pub7YvFvlmlqANhzoV+PIVPsFSLpAI3Nukvxf03dLFKF/RL0rcio
        r21zQfTT/G/FJH5ux5z9bYwNZM3E2o4eQOqInlvDot1yVJ6ltw675P6MSkLOqTL4L2E/D5jR/QP
        czNKhjxhzdc9ms7ic
X-Received: by 2002:a1c:c90a:: with SMTP id f10mr12983093wmb.179.1586680680915;
        Sun, 12 Apr 2020 01:38:00 -0700 (PDT)
X-Google-Smtp-Source: APiQypJpGQcwg9BNxwrWgtjJoNNurdp47wD0GtLgDgtuiAQDaLS5bakxHQGpI2dtKfuzN5LGIim6Aw==
X-Received: by 2002:a1c:c90a:: with SMTP id f10mr12983074wmb.179.1586680680653;
        Sun, 12 Apr 2020 01:38:00 -0700 (PDT)
Received: from redhat.com (bzq-79-183-51-3.red.bezeqint.net. [79.183.51.3])
        by smtp.gmail.com with ESMTPSA id y5sm10563354wru.15.2020.04.12.01.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2020 01:37:59 -0700 (PDT)
Date:   Sun, 12 Apr 2020 04:37:55 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        David Hildenbrand <david@redhat.com>, eperezma@redhat.com,
        "Cc: stable@vger.kernel.org, david@redhat.com, dverkamp@chromium.org,
        hch@lst.de, jasowang@redhat.com, liang.z.li@intel.com, mst@redhat.com,
        tiny.windzz@gmail.com," <jasowang@redhat.com>,
        lingshan.zhu@intel.com, Michal Hocko <mhocko@kernel.org>,
        Nadav Amit <namit@vmware.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        David Rientjes <rientjes@google.com>, tiwei.bie@intel.com,
        tysand@google.com,
        "Cc: stable@vger.kernel.org, david@redhat.com, dverkamp@chromium.org,
        hch@lst.de, jasowang@redhat.com, liang.z.li@intel.com, mst@redhat.com,
        tiny.windzz@gmail.com," <wei.w.wang@intel.com>,
        xiao.w.wang@intel.com, yuri.benditovich@daynix.com
Subject: Re: [GIT PULL] vhost: fixes, vdpa
Message-ID: <20200412041730-mutt-send-email-mst@kernel.org>
References: <20200406171124-mutt-send-email-mst@kernel.org>
 <CAHk-=wg7sMywb2V8gifhpUDE=DWQTvg1wDieKVc0UoOSsOrynw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wg7sMywb2V8gifhpUDE=DWQTvg1wDieKVc0UoOSsOrynw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 11, 2020 at 09:38:05AM -0700, Linus Torvalds wrote:
> On Mon, Apr 6, 2020 at 2:11 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > The new vdpa subsystem with two first drivers.
> 
> So this one is really annoying to configure.
> 
> First it asks for vDPA driver for virtio devices (VIRTIO_VDPA) support.
> 
> If you say 'n', it then asks *again* for VDPA drivers (VDPA_MENU).
> 
> And then when you say 'n' to *that* it asks you for Vhost driver for
> vDPA-based backend (VHOST_VDPA).
> 
> This kind of crazy needs to stop.
> 
> Doing kernel configuration is not supposed to be like some truly
> horrendously boring Colossal Cave Adventure game where you have to
> search for a way out of maze of twisty little passages, all alike.
> 
>                 Linus

Hmm it's a good point.  Thanks, Linus!
I think this was copied from virtio which has drivers spread all over
the tree.

Jason, if VDPA_MENU is off, then we don't have any drivers. So what's
the point of selecting VDPA core from vhost/virtio then?

So how about this? Lightly tested. Jason, could you pls play with this
a bit more and let me know if you see any issues?

-->
vdpa: make vhost, virtio depend on menu

If user did not configure any vdpa drivers, neither vhost
nor virtio vdpa are going to be useful. So there's no point
in prompting for these and selecting vdpa core automatically.
Simplify configuration by making virtio and vhost vdpa
drivers depend on vdpa menu entry. Once done, we no longer
need a separate menu entry, so also get rid of this.
While at it, fix up the IFC entry: VDPA->vDPA for consistency
with other places.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

---

diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index cb6b17323eb2..3b43411361fe 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -64,7 +64,7 @@ config VHOST_VDPA
 	tristate "Vhost driver for vDPA-based backend"
 	depends on EVENTFD
 	select VHOST
-	select VDPA
+	depends on VDPA_MENU
 	help
 	  This kernel module can be loaded in host kernel to accelerate
 	  guest virtio devices with the vDPA-based backends.
diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index 2aadf398d8cc..bf13755a5ba5 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -45,7 +45,7 @@ config VIRTIO_PCI_LEGACY
 
 config VIRTIO_VDPA
 	tristate "vDPA driver for virtio devices"
-	select VDPA
+	depend on VDPA_MENU
 	select VIRTIO
 	help
 	  This driver provides support for virtio based paravirtual

