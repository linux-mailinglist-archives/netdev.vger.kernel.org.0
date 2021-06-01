Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEA7396F99
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 10:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbhFAIzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 04:55:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39415 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233182AbhFAIzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 04:55:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622537601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5aOcgj4/7/8wJi908yQhoCZVNaJnSsE8zNAKFi7tF3U=;
        b=ZQmaJhW4fCgur/2XtLKqB7KQAoaF2BxYrTLPI/3G/XytI9RKpUAgXLxC0hmlatopM4KoNO
        Y58POp1XyFpGIp8H0g9soAFnxAGFXt7LdoX6WJQ0qSOyH6gb2ddlhaRH0PzpnwzNblwqk2
        n1o7ZQrPF7hUpcfBKFBo75Jc1X1uclk=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-Lua6W556MAC3M-I_pF0RLw-1; Tue, 01 Jun 2021 04:53:18 -0400
X-MC-Unique: Lua6W556MAC3M-I_pF0RLw-1
Received: by mail-pg1-f200.google.com with SMTP id q64-20020a6343430000b02902164088f2f0so8467211pga.5
        for <netdev@vger.kernel.org>; Tue, 01 Jun 2021 01:53:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=5aOcgj4/7/8wJi908yQhoCZVNaJnSsE8zNAKFi7tF3U=;
        b=KtoGfnUFJbH1c6tMp4ZS3sGiLBgRW55FXropRuaZOLOvgUEgilefg6zvyw86PxM8sI
         WMrPFP0BZh1oLXzGLrHBLmv5oHWDpQKBjcJqPxtHLcg/VX6w1wdlzyfGJwjCHFPH41QM
         d8R/rSeJUlBdLS/1pKmmcnnTD5Z6cjSjdHKqnW1r3C+Pk03EFnnWyQeGB0dY8FE/PCDn
         d4JADYSusKw/3bUhD/zy9/Ru5Rv+pXmmjZKbMZo5mhCdv7zKG49xwK6hfAN8jp1UiTw6
         nTpTDtxtOTh1e6fj2xWf2ZiDenvLg4Lu/2LcT8BLcs2CZDzNDSnoRxQ6poAXCHckrBHr
         StZA==
X-Gm-Message-State: AOAM531hyJZaNUim566sSfDgK12zF/13ynT7Gzo+x2SnSsgQmf2PRmBS
        ynvS0NjFSxbcIdZcqylLO4LBcCDwi6sIxiHJ1dzzs8KHwaymhpiKp8Pu2znoljrcrNlLMOW/VfZ
        yhZ3UR9oT0HBAEdh9
X-Received: by 2002:aa7:801a:0:b029:2e0:c3db:15a2 with SMTP id j26-20020aa7801a0000b02902e0c3db15a2mr21386813pfi.42.1622537597098;
        Tue, 01 Jun 2021 01:53:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxYDHHGpH9/a6mLp3/nIDpF5g4JSP7vmJEL9FSrm7dg3eB9KGd67RXSUkJ2HsSU3cvFP8NNPA==
X-Received: by 2002:aa7:801a:0:b029:2e0:c3db:15a2 with SMTP id j26-20020aa7801a0000b02902e0c3db15a2mr21386795pfi.42.1622537596866;
        Tue, 01 Jun 2021 01:53:16 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k70sm1625715pgd.41.2021.06.01.01.53.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jun 2021 01:53:16 -0700 (PDT)
Subject: Re: [PATCH V3 1/2] vDPA/ifcvf: record virtio notify base
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210601062850.4547-1-lingshan.zhu@intel.com>
 <20210601062850.4547-2-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <63a73aab-964d-344f-d66b-e8e6224af687@redhat.com>
Date:   Tue, 1 Jun 2021 16:53:09 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210601062850.4547-2-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/6/1 ÏÂÎç2:28, Zhu Lingshan Ð´µÀ:
> This commit records virtio notify base physical addr and
> calculate doorbell physical address for vqs.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vdpa/ifcvf/ifcvf_base.c | 4 ++++
>   drivers/vdpa/ifcvf/ifcvf_base.h | 2 ++
>   2 files changed, 6 insertions(+)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
> index 1a661ab45af5..6e197fe0fcf9 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
> @@ -133,6 +133,8 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *pdev)
>   					      &hw->notify_off_multiplier);
>   			hw->notify_bar = cap.bar;
>   			hw->notify_base = get_cap_addr(hw, &cap);
> +			hw->notify_base_pa = pci_resource_start(pdev, cap.bar) +
> +					le32_to_cpu(cap.offset);
>   			IFCVF_DBG(pdev, "hw->notify_base = %p\n",
>   				  hw->notify_base);
>   			break;
> @@ -161,6 +163,8 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *pdev)
>   		notify_off = ifc_ioread16(&hw->common_cfg->queue_notify_off);
>   		hw->vring[i].notify_addr = hw->notify_base +
>   			notify_off * hw->notify_off_multiplier;
> +		hw->vring[i].notify_pa = hw->notify_base_pa +
> +			notify_off * hw->notify_off_multiplier;
>   	}
>   
>   	hw->lm_cfg = hw->base[IFCVF_LM_BAR];
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
> index 0111bfdeb342..447f4ad9c0bf 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
> @@ -73,6 +73,7 @@ struct vring_info {
>   	u16 last_avail_idx;
>   	bool ready;
>   	void __iomem *notify_addr;
> +	phys_addr_t notify_pa;
>   	u32 irq;
>   	struct vdpa_callback cb;
>   	char msix_name[256];
> @@ -87,6 +88,7 @@ struct ifcvf_hw {
>   	u8 notify_bar;
>   	/* Notificaiton bar address */
>   	void __iomem *notify_base;
> +	phys_addr_t notify_base_pa;
>   	u32 notify_off_multiplier;
>   	u64 req_features;
>   	u64 hw_features;

