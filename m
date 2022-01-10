Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8809D489011
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 07:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238937AbiAJGQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 01:16:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51154 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234844AbiAJGQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 01:16:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641795360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DuAR6pDmjPSmilfQNNx62xoV3MRy1i7Xzh1+aNTGJYI=;
        b=MeUFHFX7PcSs9pTIXI4iHwWL45TKQ3vjAXWz9UdQYgL3mOmZBaqNuEDoMqbE3p0J/BdOnD
        TW9myeZxxiW+AYtlrl4vj1UClXmRA/KVprc1qURK9O/c0l09sNE2QmW25wHlReT+HSBXIJ
        lbDrNSk6JJLWWngjgtygBg7UHqNfLa8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-232-3X3W8CIIMpOuQfbICX6tQQ-1; Mon, 10 Jan 2022 01:15:58 -0500
X-MC-Unique: 3X3W8CIIMpOuQfbICX6tQQ-1
Received: by mail-wr1-f69.google.com with SMTP id w25-20020adf8bd9000000b001a255212b7cso3742732wra.18
        for <netdev@vger.kernel.org>; Sun, 09 Jan 2022 22:15:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DuAR6pDmjPSmilfQNNx62xoV3MRy1i7Xzh1+aNTGJYI=;
        b=Z/GOgzDqJ+s8NXc/yVL+Atkk3g1EkXBZ+/m2q5Fukoyu5N7FPF/NmG3EWmqx8OxEqp
         cf23iUD10t3UP4aENYrpdHyiC2A+DfsfvrDeu7YBiXHWD/iL4IqZ2ppY9VmlbkKIAK3k
         zKFXuOHfu0wx/bzx+VJNBzLGnvcHHgNfIa30MwW5GJ9jL/s4VNZyWLkqXQvqjkZuLQox
         jufB66MF+K+BwgZWMTmq6l2Ith2w/z6Aw4ilMfPpDiWj50bH3kWUCuVbaG8r/wHHonqc
         b0vSZnQ+JKHjB/PJ1THUWVkxKVLH55MxOz6OTpuX7A055AylxN0z3XVSpNTuu7bWvJ5Q
         QBTw==
X-Gm-Message-State: AOAM530arpl6o2dRXvo9RuwJvVFNTkJdStTolowav52fsV2hB86SArvQ
        VGt8VVmwwKWihW2ijv8GAKDuxQh4BGiC87VTON8JbRNVFlKMnQFM3g6/c8E4UrWPdg9DbNampb6
        KSLaQScGairAyT6ZK
X-Received: by 2002:a05:600c:3ac8:: with SMTP id d8mr20874265wms.72.1641795357470;
        Sun, 09 Jan 2022 22:15:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzLIa8PnL05a8466JRC6v+Lp344IfsyMl4FvMzUH4z7ULmZGf7ijQzfIjGGaPzms+3O9uvBcQ==
X-Received: by 2002:a05:600c:3ac8:: with SMTP id d8mr20874254wms.72.1641795357303;
        Sun, 09 Jan 2022 22:15:57 -0800 (PST)
Received: from redhat.com ([2a03:c5c0:107d:b60c:c297:16fe:7528:e989])
        by smtp.gmail.com with ESMTPSA id n12sm5807586wmq.30.2022.01.09.22.15.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 22:15:56 -0800 (PST)
Date:   Mon, 10 Jan 2022 01:15:53 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH 2/7] vDPA/ifcvf: introduce new helpers to set config
 vector and vq vectors
Message-ID: <20220110011320-mutt-send-email-mst@kernel.org>
References: <20220110051851.84807-1-lingshan.zhu@intel.com>
 <20220110051851.84807-3-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110051851.84807-3-lingshan.zhu@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 01:18:46PM +0800, Zhu Lingshan wrote:
> This commit introduces new helpers to set config vector
> and vq vectors in virtio common config space.
> 
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vdpa/ifcvf/ifcvf_base.c | 30 ++++++++++++++++++++++++++++++
>  drivers/vdpa/ifcvf/ifcvf_base.h |  2 ++
>  2 files changed, 32 insertions(+)
> 
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
> index 0b5df4cfaf06..696a41560eaa 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
> @@ -15,6 +15,36 @@ struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw)
>  	return container_of(hw, struct ifcvf_adapter, vf);
>  }
>  
> +int ifcvf_set_vq_vector(struct ifcvf_hw *hw, u16 qid, int vector)
> +{
> +	struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
> +	struct ifcvf_adapter *ifcvf = vf_to_adapter(hw);
> +
> +	ifc_iowrite16(qid, &cfg->queue_select);
> +	ifc_iowrite16(vector, &cfg->queue_msix_vector);
> +	if (ifc_ioread16(&cfg->queue_msix_vector) == VIRTIO_MSI_NO_VECTOR) {
> +		IFCVF_ERR(ifcvf->pdev, "No msix vector for queue %u\n", qid);
> +			return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +int ifcvf_set_config_vector(struct ifcvf_hw *hw, int vector)
> +{
> +	struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
> +	struct ifcvf_adapter *ifcvf = vf_to_adapter(hw);
> +
> +	cfg = hw->common_cfg;
> +	ifc_iowrite16(vector,  &cfg->msix_config);
> +	if (ifc_ioread16(&cfg->msix_config) == VIRTIO_MSI_NO_VECTOR) {
> +		IFCVF_ERR(ifcvf->pdev, "No msix vector for device config\n");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +

The messages are confusing. Something like "unable to set" would be
clearer. And maybe supply the info which vector and which vq to set?

>  static void __iomem *get_cap_addr(struct ifcvf_hw *hw,
>  				  struct virtio_pci_cap *cap)
>  {
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
> index c924a7673afb..1d5431040d7d 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
> @@ -157,4 +157,6 @@ u16 ifcvf_get_vq_state(struct ifcvf_hw *hw, u16 qid);
>  int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num);
>  struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw);
>  int ifcvf_probed_virtio_net(struct ifcvf_hw *hw);
> +int ifcvf_set_vq_vector(struct ifcvf_hw *hw, u16 qid, int vector);
> +int ifcvf_set_config_vector(struct ifcvf_hw *hw, int vector);
>  #endif /* _IFCVF_H_ */
> -- 
> 2.27.0

