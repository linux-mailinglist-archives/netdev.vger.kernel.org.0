Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D00B361C48
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 11:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241263AbhDPIsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 04:48:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34258 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241097AbhDPIsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 04:48:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618562864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2r7NGmqheP2GV+6A/LiwNG2tOhjWpE+ouB1t/RVmSe4=;
        b=FUhgS5DsuE9li4xMlFG9nF2S4BrL+uOfeU8Cwf5Es7/eZ22UJGXVILczvaPcWcHvtbunbU
        77xXP4Ox9Atq3lLNIW1H1VQx8Bk6kW0iUgYpfPqn/o0BEh/IPLij5ONUcAqTvuF0lRRZet
        /j0lRhQa0q9aRVYVvrA/slWu+49x1Xs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-sF2BvjVvOuiYVzrZVVMtKQ-1; Fri, 16 Apr 2021 04:47:42 -0400
X-MC-Unique: sF2BvjVvOuiYVzrZVVMtKQ-1
Received: by mail-ed1-f69.google.com with SMTP id d2-20020aa7d6820000b0290384ee872881so2560326edr.10
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 01:47:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2r7NGmqheP2GV+6A/LiwNG2tOhjWpE+ouB1t/RVmSe4=;
        b=f1AdurBePFHS7OTTaZMdIRZqrmSDAnfv5IoDuay0xG0g0vxZ9Q8GLXAmclz7AWl9X1
         GeqMg8TB8YsGuQyhq5xwik6ncvlVn0FDO6vP1PdF4TRSH6n1HG0fK1LvWOJ1IiIfkR+C
         5fhOF7cFy59BnEthsFQF81xnbuixOkKpIjeNOk2SIQhKSfyxb3ia+q2Yr57xDxotLBlE
         7TWsl9RWsvRJG6g5GMLehN4AO+JHiPfm0TCZdt7knp95Ksioejym7MsX/P+yNA8OlkeS
         SvR124GHDc1rLZLfNIhl6PapDeziS/0GnZM9RbDU8zYU9mqn/uZeoNcF2ZBhyluupaWT
         YbHA==
X-Gm-Message-State: AOAM532r4K7SZHKqnHau7xMnwZoalp1WJ/Fy4uRXMW3+hZr25bvfVnp7
        B4zz3jHuJnDtEGvesnlxrPWjtbcJaCZwY/H444ZmldGKZulOG7sOOPSBuwCj1JswpXKn74NLS4r
        ScQdhFivKiUMQGDEw
X-Received: by 2002:aa7:db87:: with SMTP id u7mr8433905edt.16.1618562861496;
        Fri, 16 Apr 2021 01:47:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyB2d7tIaEFMBWd3DwYN1KfiOebKxLZRxhbIvY5dtME0hUSHkW/0SULGJHTws6pnnflB3CeaA==
X-Received: by 2002:aa7:db87:: with SMTP id u7mr8433888edt.16.1618562861323;
        Fri, 16 Apr 2021 01:47:41 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id m14sm1016232edc.18.2021.04.16.01.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 01:47:41 -0700 (PDT)
Date:   Fri, 16 Apr 2021 10:47:38 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 3/3] vDPA/ifcvf: get_config_size should return dev
 specific config size
Message-ID: <20210416084738.k2xr7m6rdhrvoqr2@steredhat>
References: <20210416071628.4984-1-lingshan.zhu@intel.com>
 <20210416071628.4984-4-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210416071628.4984-4-lingshan.zhu@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 03:16:28PM +0800, Zhu Lingshan wrote:
>get_config_size() should return the size based on the decected
>device type.
>
>Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>---
> drivers/vdpa/ifcvf/ifcvf_main.c | 19 ++++++++++++++++++-
> 1 file changed, 18 insertions(+), 1 deletion(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
>index 376b2014916a..3b6f7862dbb8 100644
>--- a/drivers/vdpa/ifcvf/ifcvf_main.c
>+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>@@ -356,7 +356,24 @@ static u32 ifcvf_vdpa_get_vq_align(struct vdpa_device *vdpa_dev)
>
> static size_t ifcvf_vdpa_get_config_size(struct vdpa_device *vdpa_dev)
> {
>-	return sizeof(struct virtio_net_config);
>+	struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
>+	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>+	struct pci_dev *pdev = adapter->pdev;
>+	size_t size;
>+
>+	switch (vf->dev_type) {
>+	case VIRTIO_ID_NET:
>+		size = sizeof(struct virtio_net_config);
>+		break;
>+	case VIRTIO_ID_BLOCK:
>+		size = sizeof(struct virtio_blk_config);
>+		break;
>+	default:
>+		size = 0;
>+		IFCVF_ERR(pdev, "VIRTIO ID %u not supported\n", vf->dev_type);
>+	}
>+
>+	return size;
> }
>
> static void ifcvf_vdpa_get_config(struct vdpa_device *vdpa_dev,
>-- 
>2.27.0
>

