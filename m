Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3A43603F5
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 10:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbhDOINI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 04:13:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47557 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230090AbhDOINF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 04:13:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618474362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Uok685ar2aRiyh2dl0JSULm/jJ/D8RgjO+Fo8IDWGJU=;
        b=LWDL6pJCYGt7X3/SemiiguvJ6Kl/Fn6RYoSKTFldwo8l7roFw1RWmcd+8DFwQ3uR3Y1GEZ
        it/vB3YM5OW7KPQCwa1FjJ23czDHVGNOuGXJ7W0GSWqOrbBdv/yd9ba/QfE6YhPShWrGtL
        vEWrk1tTsHiFqph86gC9rF1Gcx/IeMw=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-FClzL6ZwPM-xmgVTnpp-Gw-1; Thu, 15 Apr 2021 04:12:40 -0400
X-MC-Unique: FClzL6ZwPM-xmgVTnpp-Gw-1
Received: by mail-ej1-f71.google.com with SMTP id p25-20020a1709061419b0290378364a6464so645249ejc.15
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 01:12:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Uok685ar2aRiyh2dl0JSULm/jJ/D8RgjO+Fo8IDWGJU=;
        b=TV3pIRlysKtXSq5Bc3uaFuRYlLvvJGTE3A9+/XG77BUIGIbPBlBvgw4ak26tm0EgvO
         23sZSi8YVOWPP5W2ZZbj3v2TDh/p2BCJ2WMo+dm8NgUCBXahijcgEGuPpHiZBrGmHQiN
         aX3PbVdxhRKWbPgBwi5t+AnHiIdrVzzh+IskO6Qp72JpaMzgOT+hfOuSZGuA4DsFE7J/
         HMkCRORRy+YOR03ifyLazZdEObnFsmKv2xMzENK7KAKelCBS2fj2oOo7gBWh5AaED+BW
         xw77budvKgn+hqKbUz1mLAsxHZREXak2MrYxPH71wbQ6zgQVppNo/FkggYdeRIWnTB/5
         SuNA==
X-Gm-Message-State: AOAM5327S5fsC8HAHzRSAYzydc+hgPhi3L+IP23+l6crp2ceVdhs7Eqs
        y2DraoSt01wmemrqjtpAVxn+JeuDOIazhKKp/o+Uh60TUoR1qu/3GS1mPTzhRfIIu/oCQXXQHAa
        bk07ZFDyv9xjbKuCk
X-Received: by 2002:a17:906:d110:: with SMTP id b16mr2182974ejz.146.1618474358961;
        Thu, 15 Apr 2021 01:12:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/ODVdHnATxPBtkndhJ7egTCylTFfXw5aTQ3MS4uE7R4xjYS19p1A2QjPyN6E/lbnVqiSGRg==
X-Received: by 2002:a17:906:d110:: with SMTP id b16mr2182957ejz.146.1618474358784;
        Thu, 15 Apr 2021 01:12:38 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id w13sm911888edx.80.2021.04.15.01.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 01:12:38 -0700 (PDT)
Date:   Thu, 15 Apr 2021 10:12:36 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        leonro@nvidia.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] vDPA/ifcvf: get_config_size should return dev
 specific config size
Message-ID: <20210415081236.anbssqtsyjnmiaby@steredhat>
References: <20210414091832.5132-1-lingshan.zhu@intel.com>
 <20210414091832.5132-4-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210414091832.5132-4-lingshan.zhu@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 05:18:32PM +0800, Zhu Lingshan wrote:
>get_config_size() should return the size based on the decected
>device type.
>
>Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>---
> drivers/vdpa/ifcvf/ifcvf_main.c | 11 ++++++++++-
> 1 file changed, 10 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
>index 9b6a38b798fa..b48b9789b69e 100644
>--- a/drivers/vdpa/ifcvf/ifcvf_main.c
>+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>@@ -347,7 +347,16 @@ static u32 ifcvf_vdpa_get_vq_align(struct vdpa_device *vdpa_dev)
>
> static size_t ifcvf_vdpa_get_config_size(struct vdpa_device *vdpa_dev)
> {
>-	return sizeof(struct virtio_net_config);
>+	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>+	size_t size;
>+
>+	if (vf->dev_type == VIRTIO_ID_NET)
>+		size = sizeof(struct virtio_net_config);
>+
>+	if (vf->dev_type == VIRTIO_ID_BLOCK)
>+		size = sizeof(struct virtio_blk_config);
>+
>+	return size;

I'm not familiar with the ifcvf details, but can it happen that the 
device is not block or net?

Should we set `size` to 0 by default to handle this case or are we sure 
it's one of the two?

Maybe we should add a comment or a warning message in this case, to 
prevent some analysis tool or compiler from worrying that `size` might 
be uninitialized.

I was thinking something like this:

	switch(vf->dev_type) {
	case VIRTIO_ID_NET:
		size = sizeof(struct virtio_net_config);
		break;
	case VIRTIO_ID_BLOCK:
		size = sizeof(struct virtio_blk_config);
		break;
	default:
		/* or WARN(1, "") if dev_warn() not apply */
		dev_warn(... , "virtio ID [0x%x] not supported\n")
		size = 0;

	}

Thanks,
Stefano

