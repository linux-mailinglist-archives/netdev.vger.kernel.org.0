Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF044B41E3
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 07:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240758AbiBNGQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 01:16:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233761AbiBNGQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 01:16:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 01E40517C8
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 22:16:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644819367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NF1/NPeUWNiJlC0A0ifogeZR5Lr3JaYAP0Q8qqKkG4w=;
        b=SglZ35rNYkrOyN+6wMugAom/r/UmzbV0qjrbzRW980KvYZqeiCZ64lg76Gr6H5JQg0/NO7
        zzqyJUJhsDDyF2zdl6sYo63wUM9vxSLi2fozzTTVO/Sx9+bXBnENawCL5DWhCCzLNkxu3A
        /qcNunFG5gPh9T4rg2tRUYCOCYPjYBk=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-fP_HvOaDPceiHM1cck45HQ-1; Mon, 14 Feb 2022 01:16:06 -0500
X-MC-Unique: fP_HvOaDPceiHM1cck45HQ-1
Received: by mail-pj1-f70.google.com with SMTP id q12-20020a17090a2e0c00b001b874772fecso10225519pjd.2
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 22:16:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NF1/NPeUWNiJlC0A0ifogeZR5Lr3JaYAP0Q8qqKkG4w=;
        b=Cxz/C8InLcJEGPZHeHgX4T1qzCu54ydqtYZgL7rJOLja1jw2dhtZ6lloqZJW6KiZR+
         VvSEXr0XDy0iR3agbc/umvbF39TKYB+/YiiqeDPCDd5WjbxezFR6uZ6Am8Tqtskx7KE9
         jglaNp03QXLTLKOsj2jTv+bhk52Huc/0NgJiO35CwyomvT89Ya11r6hZd9OP6YoN4CTF
         gBdBquzOKp64iWFSjGSQEXXMeJgGmitqkbY6w9kFRSExfvIrfUK1HPr2lu7X5DX12rTK
         eNEA5WzazFCoRb+1zSUpEQrjGWlIFDKY8Cdoh6sZSCXCBM8lBwyMWoD/XgUgXJpn0a+G
         pK1g==
X-Gm-Message-State: AOAM531DubFtq6OKgeFDhe6NvFQfe3hZgresyY905R3icdAyJPYJkkM+
        Tv9iuEN0lHlkenDexlMX9653Xdjfc8xqJhOdd/1DL/ig9WZcPV0P3Km6GnbSX10ncU3WwYQrBCb
        u81OmIeGcTZoGyAum
X-Received: by 2002:a05:6a00:1892:: with SMTP id x18mr12764897pfh.20.1644819365614;
        Sun, 13 Feb 2022 22:16:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx6SwUZsLff3cs83pvyeBxbCmftVQTztg6Yvm98p1XlJI3EP/KbBrzcE7/YJjwVZOOLrhfVig==
X-Received: by 2002:a05:6a00:1892:: with SMTP id x18mr12764878pfh.20.1644819365375;
        Sun, 13 Feb 2022 22:16:05 -0800 (PST)
Received: from [10.72.12.239] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w2sm18461513pfb.139.2022.02.13.22.16.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Feb 2022 22:16:04 -0800 (PST)
Message-ID: <5b9e287a-08bd-10b9-4159-5b36f192a387@redhat.com>
Date:   Mon, 14 Feb 2022 14:15:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH V4 1/4] vDPA/ifcvf: implement IO read/write helpers in the
 header file
Content-Language: en-US
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20220203072735.189716-1-lingshan.zhu@intel.com>
 <20220203072735.189716-2-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220203072735.189716-2-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/2/3 下午3:27, Zhu Lingshan 写道:
> re-implement IO read/write helpers in the header file, so that
> they can be utilized among modules.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>


I wonder if we can simply use include/linux/virtio_pci_modern.h.

The accessors vp_ioreadX/writeX() there were decoupled from the 
virtio_pci_modern_device structure.

Thanks


> ---
>   drivers/vdpa/ifcvf/ifcvf_base.c | 36 --------------------------------
>   drivers/vdpa/ifcvf/ifcvf_base.h | 37 +++++++++++++++++++++++++++++++++
>   2 files changed, 37 insertions(+), 36 deletions(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
> index 7d41dfe48ade..397692ae671c 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
> @@ -10,42 +10,6 @@
>   
>   #include "ifcvf_base.h"
>   
> -static inline u8 ifc_ioread8(u8 __iomem *addr)
> -{
> -	return ioread8(addr);
> -}
> -static inline u16 ifc_ioread16 (__le16 __iomem *addr)
> -{
> -	return ioread16(addr);
> -}
> -
> -static inline u32 ifc_ioread32(__le32 __iomem *addr)
> -{
> -	return ioread32(addr);
> -}
> -
> -static inline void ifc_iowrite8(u8 value, u8 __iomem *addr)
> -{
> -	iowrite8(value, addr);
> -}
> -
> -static inline void ifc_iowrite16(u16 value, __le16 __iomem *addr)
> -{
> -	iowrite16(value, addr);
> -}
> -
> -static inline void ifc_iowrite32(u32 value, __le32 __iomem *addr)
> -{
> -	iowrite32(value, addr);
> -}
> -
> -static void ifc_iowrite64_twopart(u64 val,
> -				  __le32 __iomem *lo, __le32 __iomem *hi)
> -{
> -	ifc_iowrite32((u32)val, lo);
> -	ifc_iowrite32(val >> 32, hi);
> -}
> -
>   struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw)
>   {
>   	return container_of(hw, struct ifcvf_adapter, vf);
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
> index c486873f370a..949b4fb9d554 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
> @@ -42,6 +42,43 @@
>   #define ifcvf_private_to_vf(adapter) \
>   	(&((struct ifcvf_adapter *)adapter)->vf)
>   
> +static inline u8 ifc_ioread8(u8 __iomem *addr)
> +{
> +	return ioread8(addr);
> +}
> +
> +static inline u16 ifc_ioread16(__le16 __iomem *addr)
> +{
> +	return ioread16(addr);
> +}
> +
> +static inline u32 ifc_ioread32(__le32 __iomem *addr)
> +{
> +	return ioread32(addr);
> +}
> +
> +static inline void ifc_iowrite8(u8 value, u8 __iomem *addr)
> +{
> +	iowrite8(value, addr);
> +}
> +
> +static inline void ifc_iowrite16(u16 value, __le16 __iomem *addr)
> +{
> +	iowrite16(value, addr);
> +}
> +
> +static inline void ifc_iowrite32(u32 value, __le32 __iomem *addr)
> +{
> +	iowrite32(value, addr);
> +}
> +
> +static inline void ifc_iowrite64_twopart(u64 val,
> +				  __le32 __iomem *lo, __le32 __iomem *hi)
> +{
> +	ifc_iowrite32((u32)val, lo);
> +	ifc_iowrite32(val >> 32, hi);
> +}
> +
>   struct vring_info {
>   	u64 desc;
>   	u64 avail;

