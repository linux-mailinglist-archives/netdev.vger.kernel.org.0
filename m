Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCCC396F90
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 10:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233734AbhFAIw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 04:52:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55610 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233828AbhFAIvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 04:51:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622537411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yivOBnqcmrnUcZvCryP/43pugu1L6MME5PS60ENJv/M=;
        b=MEFbHEEoAF2PKYvEvhKPGpkoEvnOdlXkihBy0VUES+LiBAQZklmoq+tvzRikNXJipYKhBv
        OiZaScbBJ6m++cEY1XKZcSnoWnKcdL4RlgOO3cZpj71+PojoFrbV2t7wY1lSWay6BIq6pq
        Untqrdbc5uooejaaexJSAQnVJ9G/PMA=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-H9R6CTdLM9KFeRrXZOZMCA-1; Tue, 01 Jun 2021 04:50:08 -0400
X-MC-Unique: H9R6CTdLM9KFeRrXZOZMCA-1
Received: by mail-pj1-f69.google.com with SMTP id r91-20020a17090a1864b029015da4ff1c12so8466090pja.4
        for <netdev@vger.kernel.org>; Tue, 01 Jun 2021 01:50:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=yivOBnqcmrnUcZvCryP/43pugu1L6MME5PS60ENJv/M=;
        b=dF38WPqDSG7vEV4mlQjXrtCh64EttNJnA6ynfB56RAqi96osvRRfZzqJ3rf9v1wCBr
         zO2mCrdQmUsxB/mFNLqgyPcPZv6uXeOhpU66Ouae1v9MQeoOBzZ+NMJU/3ffo7gabZiu
         dhh4D/taLOpJEFeYJfACKtpnJRvWPOdmhrFxytX3+aOF7JpLeFxu0/QXhpORWQtot1eZ
         ULLazbb0FtAFJyGMEDs9dLkTG1C91lgUe7q8AVbJMAPGElV43fPwu5ycgjKsCwCUwdmR
         zU7G7HFbI5v4FtWZ+6R9yzSvoeoZDbZifzn5kTsGuEofab+x3QFW33oVINelP+Zj6FCD
         SUZg==
X-Gm-Message-State: AOAM530RweH9lrPzeCHy7hCl3xJ31wK97RBZSnzBMxTC4yKSU1B4y/Vn
        lu46ThxXxHGop27mawRqz/x07fql/Sz24fh39UkXfZ73U+n7nHOPTUWDVjquzKY2pSOI86yaw+3
        pYsthOPHmcbAdFxLK
X-Received: by 2002:a17:90a:7e07:: with SMTP id i7mr12184736pjl.191.1622537407264;
        Tue, 01 Jun 2021 01:50:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwFpMEfUtTyPNfxXRLulAlYn/bEwbtUZktwkJFm+B/PvV/oT/iXyBBlyR0tLL37DB2ceP1RKw==
X-Received: by 2002:a17:90a:7e07:: with SMTP id i7mr12184726pjl.191.1622537407093;
        Tue, 01 Jun 2021 01:50:07 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f16sm13071239pju.12.2021.06.01.01.50.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jun 2021 01:50:06 -0700 (PDT)
Subject: Re: [PATCH V3 2/2] vDPA/ifcvf: implement doorbell mapping for ifcvf
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210601062850.4547-1-lingshan.zhu@intel.com>
 <20210601062850.4547-3-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d286a8f9-ac5c-ba95-777e-df926ea45292@redhat.com>
Date:   Tue, 1 Jun 2021 16:50:03 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210601062850.4547-3-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/6/1 ÏÂÎç2:28, Zhu Lingshan Ð´µÀ:
> This commit implements doorbell mapping feature for ifcvf.
> This feature maps the notify page to userspace, to eliminate
> vmexit when kick a vq.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>   drivers/vdpa/ifcvf/ifcvf_main.c | 21 +++++++++++++++++++++
>   1 file changed, 21 insertions(+)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index ab0ab5cf0f6e..d41db042612c 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -413,6 +413,26 @@ static int ifcvf_vdpa_get_vq_irq(struct vdpa_device *vdpa_dev,
>   	return vf->vring[qid].irq;
>   }
>   
> +static struct vdpa_notification_area ifcvf_get_vq_notification(struct vdpa_device *vdpa_dev,
> +							       u16 idx)
> +{
> +	struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
> +	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
> +	struct pci_dev *pdev = adapter->pdev;
> +	struct vdpa_notification_area area;
> +
> +	area.addr = vf->vring[idx].notify_pa;
> +	if (!vf->notify_off_multiplier)
> +		area.size = PAGE_SIZE;
> +	else
> +		area.size = vf->notify_off_multiplier;
> +
> +	if (area.addr % PAGE_SIZE)
> +		IFCVF_DBG(pdev, "vq %u doorbell address is not PAGE_SIZE aligned\n", idx);


I don't see the reason to keep this, or get_notification is not the 
proper place to do this kind of warning.

Thanks


> +
> +	return area;
> +}
> +
>   /*
>    * IFCVF currently does't have on-chip IOMMU, so not
>    * implemented set_map()/dma_map()/dma_unmap()
> @@ -440,6 +460,7 @@ static const struct vdpa_config_ops ifc_vdpa_ops = {
>   	.get_config	= ifcvf_vdpa_get_config,
>   	.set_config	= ifcvf_vdpa_set_config,
>   	.set_config_cb  = ifcvf_vdpa_set_config_cb,
> +	.get_vq_notification = ifcvf_get_vq_notification,
>   };
>   
>   static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)

