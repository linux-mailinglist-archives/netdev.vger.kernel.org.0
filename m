Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B49361C15
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 11:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240847AbhDPIrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 04:47:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41795 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240789AbhDPIri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 04:47:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618562833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wRo3dX7HZBf9pYjFq5ETZzrsfm6Cv5K3vSoaAXFlhHU=;
        b=Zhc59n+wMFOArTO2MZ7egfc3ywABXk260fQ7d6GwaQWaS1C2RzScIn+urEQ/l17YZZEHlq
        rYxh/MHk4rMGitotSu+V309799g1JN03JtXm16Hr2uA3rEvMoDBDOuRL105qNBv9YZJ3p/
        Kxy1igSbxKNvhj3WeFCwNxy9eiy6/AE=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-pYrro6sVNFWOGNHiIL20Kg-1; Fri, 16 Apr 2021 04:47:11 -0400
X-MC-Unique: pYrro6sVNFWOGNHiIL20Kg-1
Received: by mail-ej1-f71.google.com with SMTP id o25-20020a1709061d59b029037c94676df5so1800749ejh.7
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 01:47:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wRo3dX7HZBf9pYjFq5ETZzrsfm6Cv5K3vSoaAXFlhHU=;
        b=h2VIHWcoL5Pb9rQuSaWvzgowFXH4Q+fk3V1N/90OanEL53ZqxIw9TU4IDkxSDyIvg+
         mOiY7AOP3e9wSmeLpdAPnNmvcDcyKqX8f72EpPx4hUXTaihxeLnFNRj/yDuf48p4OuWe
         yuW4gDA0Yj+ddA9mEJrHaJbhn2Juhsm+LIIcRGYoSIGXqZ8vNl7YH6oz+NuAOtLfjTkw
         rcMhEFctuEsC+AJ5mYPoHvoESKT9l5ea5FzHt4DsVix5o2d3Pz2XP1rE4sFFEo2ynOnb
         VysGhKyYh1uUUAeHmJj61xAqMk3rR0bKMXCWfIPSLyUuoxHI508PlmVvfmBkeGt0+Kys
         F6bQ==
X-Gm-Message-State: AOAM532LOF6nRbTR9rtb3r2VsthYpU3NUV3PrGPfO0xXwU7L0kfJ44he
        LlAZcSLrerVryf6MPlH/4QfL4qfiS1PB6p9k4r5YPb6Ig16qbSUQ155lcHRKWLBMvRDuwYzlX3A
        kRqaVBItiokBWnGu3
X-Received: by 2002:a50:8fe6:: with SMTP id y93mr8637332edy.224.1618562830126;
        Fri, 16 Apr 2021 01:47:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwh1Zl2ub3jfnrnRMGdIeGAkIGOzcVmqwkMtbMOyGQ3+DRwPr4tDakxV4LySH2DCPUs/c6RYw==
X-Received: by 2002:a50:8fe6:: with SMTP id y93mr8637313edy.224.1618562829919;
        Fri, 16 Apr 2021 01:47:09 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id k9sm3617309eje.102.2021.04.16.01.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 01:47:09 -0700 (PDT)
Date:   Fri, 16 Apr 2021 10:47:07 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 2/3] vDPA/ifcvf: enable Intel C5000X-PL virtio-block
 for vDPA
Message-ID: <20210416084707.ruqzvg4airzkkc2t@steredhat>
References: <20210416071628.4984-1-lingshan.zhu@intel.com>
 <20210416071628.4984-3-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210416071628.4984-3-lingshan.zhu@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 03:16:27PM +0800, Zhu Lingshan wrote:
>This commit enabled Intel FPGA SmartNIC C5000X-PL virtio-block
>for vDPA.
>
>Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>---
> drivers/vdpa/ifcvf/ifcvf_base.h |  8 +++++++-
> drivers/vdpa/ifcvf/ifcvf_main.c | 19 ++++++++++++++++++-
> 2 files changed, 25 insertions(+), 2 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
>index 1c04cd256fa7..0111bfdeb342 100644
>--- a/drivers/vdpa/ifcvf/ifcvf_base.h
>+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
>@@ -15,6 +15,7 @@
> #include <linux/pci_regs.h>
> #include <linux/vdpa.h>
> #include <uapi/linux/virtio_net.h>
>+#include <uapi/linux/virtio_blk.h>
> #include <uapi/linux/virtio_config.h>
> #include <uapi/linux/virtio_pci.h>
>
>@@ -28,7 +29,12 @@
> #define C5000X_PL_SUBSYS_VENDOR_ID	0x8086
> #define C5000X_PL_SUBSYS_DEVICE_ID	0x0001
>
>-#define IFCVF_SUPPORTED_FEATURES \
>+#define C5000X_PL_BLK_VENDOR_ID		0x1AF4
>+#define C5000X_PL_BLK_DEVICE_ID		0x1001
>+#define C5000X_PL_BLK_SUBSYS_VENDOR_ID	0x8086
>+#define C5000X_PL_BLK_SUBSYS_DEVICE_ID	0x0002
>+
>+#define IFCVF_NET_SUPPORTED_FEATURES \
> 		((1ULL << VIRTIO_NET_F_MAC)			| \
> 		 (1ULL << VIRTIO_F_ANY_LAYOUT)			| \
> 		 (1ULL << VIRTIO_F_VERSION_1)			| \
>diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
>index 469a9b5737b7..376b2014916a 100644
>--- a/drivers/vdpa/ifcvf/ifcvf_main.c
>+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>@@ -168,10 +168,23 @@ static struct ifcvf_hw *vdpa_to_vf(struct vdpa_device *vdpa_dev)
>
> static u64 ifcvf_vdpa_get_features(struct vdpa_device *vdpa_dev)
> {
>+	struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
> 	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>+	struct pci_dev *pdev = adapter->pdev;
>+
> 	u64 features;
>
>-	features = ifcvf_get_features(vf) & IFCVF_SUPPORTED_FEATURES;
>+	switch (vf->dev_type) {
>+	case VIRTIO_ID_NET:
>+		features = ifcvf_get_features(vf) & IFCVF_NET_SUPPORTED_FEATURES;
>+		break;
>+	case VIRTIO_ID_BLOCK:
>+		features = ifcvf_get_features(vf);
>+		break;
>+	default:
>+		features = 0;
>+		IFCVF_ERR(pdev, "VIRTIO ID %u not supported\n", vf->dev_type);
>+	}
>
> 	return features;
> }
>@@ -517,6 +530,10 @@ static struct pci_device_id ifcvf_pci_ids[] = {
> 			 C5000X_PL_DEVICE_ID,
> 			 C5000X_PL_SUBSYS_VENDOR_ID,
> 			 C5000X_PL_SUBSYS_DEVICE_ID) },
>+	{ PCI_DEVICE_SUB(C5000X_PL_BLK_VENDOR_ID,
>+			 C5000X_PL_BLK_DEVICE_ID,
>+			 C5000X_PL_BLK_SUBSYS_VENDOR_ID,
>+			 C5000X_PL_BLK_SUBSYS_DEVICE_ID) },
>
> 	{ 0 },
> };
>-- 
>2.27.0
>

