Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 706673BB6A5
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 07:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbhGEFML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 01:12:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45800 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229709AbhGEFMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 01:12:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625461773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GKsids3f945YQDF5Oen93rLvMd+sZCBgdX5IUN3ZQHE=;
        b=X2ttzcBAagBgxA3kPq+jmHuglmdO3DidUgxa0NiDTiRRaJbxZwYlDchnNkIqX80iJ/x4ad
        IbZ/3O4MnEjhnDDZcHSvXJx8NFTHOD228MaGwl2YbN7TuJqjDrN5eV0l4F5C0rx5dm+5Pn
        DfwBzVEIExZcePIC84lmGMLlAFcF8sQ=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-XlwIcjelOeaAyBcsjkbCjQ-1; Mon, 05 Jul 2021 01:09:31 -0400
X-MC-Unique: XlwIcjelOeaAyBcsjkbCjQ-1
Received: by mail-pl1-f200.google.com with SMTP id e12-20020a170902784cb02901298fdd4067so405775pln.0
        for <netdev@vger.kernel.org>; Sun, 04 Jul 2021 22:09:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=GKsids3f945YQDF5Oen93rLvMd+sZCBgdX5IUN3ZQHE=;
        b=RnDQ/Qvip2ycSUfNCxN6OfX+7qm3C2pmJFFnaQy7L3O2jCOPB/ZPKUZeSB/RwRAYvG
         AKvtSm/TfioQji/DRIP82F77n72fCBX+f4USsSR7ht1Ys9JTt+NBYkJTheL8YXBQC0BU
         LlauEuITuxOsrO85tdOleYVMtHK+vAE254yfQptyBrNhVtNWpfZ5ZVb2bfD0Q2+9lgjt
         g75r/4US+D4I370iX9vWjYJh12LnQfPa4wQ3F+VRQVui9g1OR+Dla9Q66g11IFgZv5Vs
         Rwcw8niSQeRcTFRTkoahG2ZCG4+QswhebdH6dNvJ1CvUw3r1qITEe/3AUp53F9A6n74g
         nRwQ==
X-Gm-Message-State: AOAM531Jb3aOxiGOqRct+2vgXH3IHhPWNm7PvvHFnSDua8iEdVWOOGoz
        pXoIw4P3ECwIEicyudwLExYRZ7TngwDXG2MTrg5cm2+QixDikUT99K5sNY5n0izKjeaWFypEgnZ
        iPQcJPv63eY7rVduM
X-Received: by 2002:a17:902:7403:b029:129:5f48:dc37 with SMTP id g3-20020a1709027403b02901295f48dc37mr9523536pll.58.1625461769923;
        Sun, 04 Jul 2021 22:09:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYKuL/vTytNEw3Xxr1NKzCafhtSD+dri4UUFdqvBeHMdSNzzAMluRD5YRZoC8KMP8WxfzvsA==
X-Received: by 2002:a17:902:7403:b029:129:5f48:dc37 with SMTP id g3-20020a1709027403b02901295f48dc37mr9523505pll.58.1625461769424;
        Sun, 04 Jul 2021 22:09:29 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d1sm10341887pfu.6.2021.07.04.22.09.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Jul 2021 22:09:28 -0700 (PDT)
Subject: Re: [PATCH 3/3] vDPA/ifcvf: set_status() should get a adapter from
 the mgmt dev
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210630082145.5729-1-lingshan.zhu@intel.com>
 <20210630082145.5729-4-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <81d8aaed-f2e8-bbf8-a7d5-71e41837d866@redhat.com>
Date:   Mon, 5 Jul 2021 13:09:24 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210630082145.5729-4-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/6/30 ÏÂÎç4:21, Zhu Lingshan Ð´µÀ:
> ifcvf_vdpa_set_status() should get a adapter from the
> management device
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>   drivers/vdpa/ifcvf/ifcvf_main.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index 7c2f64ca2163..28c71eef1d2b 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -212,13 +212,15 @@ static u8 ifcvf_vdpa_get_status(struct vdpa_device *vdpa_dev)
>   
>   static void ifcvf_vdpa_set_status(struct vdpa_device *vdpa_dev, u8 status)
>   {
> +	struct ifcvf_vdpa_mgmt_dev *ifcvf_mgmt_dev;
>   	struct ifcvf_adapter *adapter;
>   	struct ifcvf_hw *vf;
>   	u8 status_old;
>   	int ret;
>   
>   	vf  = vdpa_to_vf(vdpa_dev);
> -	adapter = dev_get_drvdata(vdpa_dev->dev.parent);


If this is a fix for patch 2, you need to squash this into that one.

Any reason that vdpa_to_adapter() can't work?

And I see:

+struct ifcvf_vdpa_mgmt_dev {
+	struct vdpa_mgmt_dev mdev;
+	struct ifcvf_adapter *adapter;
+	struct pci_dev *pdev;
+};

What's the reason for having a adapter pointer here?

Thanks


> +	ifcvf_mgmt_dev = dev_get_drvdata(vdpa_dev->dev.parent);
> +	adapter = ifcvf_mgmt_dev->adapter;
>   	status_old = ifcvf_get_status(vf);
>   
>   	if (status_old == status)

