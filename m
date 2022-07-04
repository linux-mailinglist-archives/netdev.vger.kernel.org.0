Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF15564CBE
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 06:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiGDEn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 00:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiGDEn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 00:43:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3EE3B63BC
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 21:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656909834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i7iwf0AkIgxRzHQgP0FEutfReQrr2UT7CGP9VnI7Q4k=;
        b=Ctf7ihZSLQdgvVoXF839MS/AKgV7j8CPCF7qIZf2FGiZawiAh0pbWk9gnwwCgLRJlwZe3p
        oY77kb0EtViAVjwzICiesJhuMGiAejzQJAyAHBBx7wX/Qx0cMzoegSfMGP6idF2p9qkmb6
        HrhhG9Pt6CLLdB14p8zPwPxbV2vDSf4=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-1-zw2C4cO6SzC3tz9DOF0w-1; Mon, 04 Jul 2022 00:43:52 -0400
X-MC-Unique: 1-zw2C4cO6SzC3tz9DOF0w-1
Received: by mail-pf1-f198.google.com with SMTP id z5-20020aa785c5000000b00527d84dfb49so2190039pfn.21
        for <netdev@vger.kernel.org>; Sun, 03 Jul 2022 21:43:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=i7iwf0AkIgxRzHQgP0FEutfReQrr2UT7CGP9VnI7Q4k=;
        b=PeJWPLMJInP/5fXVbe+YJGKVYolZQAgwaOxoqvRTicWJ17gxghA0nk3g7B/gMFFGGg
         EhePjjb5Bf9ew4MkaC/SjyNRvOacewUjL4GPPSbeDN2w0gWotIfjwS9OYA4htBM2MALE
         WRI/a7diKS2fj5foNA5EFZUL9RVo+Mph+BhD3p5CXSgHfo09XHEuyt7cbIBl3WsEz4Ko
         B21BgEKUE10VE16kr7IggdEOnGyauy8ePthjsg4S95pEC1+sJWdzH1+4tRFD7AWyMiTZ
         ezDxNgcQJvesvFLEb2QJsicFbdsi5A3QVMqnxz7/vXZJGJQnmUpj97Uh4KB++hXHv7Ww
         0KCg==
X-Gm-Message-State: AJIora+OjUV94Or96y1Ml5m91E6dzq1bPs9+3G+hQO7kmSJbxtenvvzL
        5CwFs+++qE0Nz+yoRhniC0iW0Sv/rlE+cybK6kZj3RePXWRtMZfN2B8/kpXeozfCm25QdpAJL7g
        wO8mEsZXAAdaIbBKq
X-Received: by 2002:a62:1606:0:b0:525:2679:f9d0 with SMTP id 6-20020a621606000000b005252679f9d0mr35334633pfw.65.1656909831198;
        Sun, 03 Jul 2022 21:43:51 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vd5ABgEadTDyD7ArHJ2WciogVXo3weq1+LT6uq0isirV16fZ5AZFT11uG+GvRGAq8yT91fQQ==
X-Received: by 2002:a62:1606:0:b0:525:2679:f9d0 with SMTP id 6-20020a621606000000b005252679f9d0mr35334613pfw.65.1656909830941;
        Sun, 03 Jul 2022 21:43:50 -0700 (PDT)
Received: from [10.72.13.251] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t2-20020a1709028c8200b0016a3248376esm19724732plo.181.2022.07.03.21.43.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Jul 2022 21:43:50 -0700 (PDT)
Message-ID: <c602c6c3-b38a-9543-2bb5-03be7d99fef3@redhat.com>
Date:   Mon, 4 Jul 2022 12:43:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH V3 2/6] vDPA/ifcvf: support userspace to query features
 and MQ of a management device
Content-Language: en-US
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        parav@nvidia.com, xieyongji@bytedance.com, gautam.dawar@amd.com
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-3-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220701132826.8132-3-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/7/1 21:28, Zhu Lingshan 写道:
> Adapting to current netlink interfaces, this commit allows userspace
> to query feature bits and MQ capability of a management device.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>   drivers/vdpa/ifcvf/ifcvf_base.c | 12 ++++++++++++
>   drivers/vdpa/ifcvf/ifcvf_base.h |  1 +
>   drivers/vdpa/ifcvf/ifcvf_main.c |  3 +++
>   3 files changed, 16 insertions(+)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
> index fb957b57941e..7c5f1cc93ad9 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
> @@ -346,6 +346,18 @@ int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num)
>   	return 0;
>   }
>   
> +u16 ifcvf_get_max_vq_pairs(struct ifcvf_hw *hw)
> +{
> +	struct virtio_net_config __iomem *config;
> +	u16 val, mq;
> +
> +	config = hw->dev_cfg;
> +	val = vp_ioread16((__le16 __iomem *)&config->max_virtqueue_pairs);
> +	mq = le16_to_cpu((__force __le16)val);
> +
> +	return mq;
> +}
> +
>   static int ifcvf_hw_enable(struct ifcvf_hw *hw)
>   {
>   	struct virtio_pci_common_cfg __iomem *cfg;
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
> index f5563f665cc6..d54a1bed212e 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
> @@ -130,6 +130,7 @@ u64 ifcvf_get_hw_features(struct ifcvf_hw *hw);
>   int ifcvf_verify_min_features(struct ifcvf_hw *hw, u64 features);
>   u16 ifcvf_get_vq_state(struct ifcvf_hw *hw, u16 qid);
>   int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num);
> +u16 ifcvf_get_max_vq_pairs(struct ifcvf_hw *hw);
>   struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw);
>   int ifcvf_probed_virtio_net(struct ifcvf_hw *hw);
>   u32 ifcvf_get_config_size(struct ifcvf_hw *hw);
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index 0a5670729412..3ff7096d30f1 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -791,6 +791,9 @@ static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
>   	vf->hw_features = ifcvf_get_hw_features(vf);
>   	vf->config_size = ifcvf_get_config_size(vf);
>   
> +	ifcvf_mgmt_dev->mdev.max_supported_vqs = ifcvf_get_max_vq_pairs(vf);


Do we want #qps or #queues?

FYI, vp_vdpa did:

drivers/vdpa/virtio_pci/vp_vdpa.c: mgtdev->max_supported_vqs = 
vp_modern_get_num_queues(mdev);

Thanks


> +	ifcvf_mgmt_dev->mdev.supported_features = vf->hw_features;
> +
>   	adapter->vdpa.mdev = &ifcvf_mgmt_dev->mdev;
>   	ret = _vdpa_register_device(&adapter->vdpa, vf->nr_vring);
>   	if (ret) {

