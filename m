Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 628F756303C
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 11:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbiGAJec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 05:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234108AbiGAJe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 05:34:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D864B7479B
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 02:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656668067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TRbVMG9pe9kLTW8fXLQQcAgh1G0fF5UqNIzjXT/Ehks=;
        b=OiRme08BuhoN3oeFaQt/Uzmea7rRGStdapZ9YuOICUojt1RYNYb4WGog67b6Y24YB1q2wx
        n7AS94U0IFaJ/TWlKAyhR6wPYGTfdMnlO+50Dom294E5Q1Pr53AnFdeiM/aylkS6BMDLsT
        xjySP658WqTyehYDNwHuyg54ciGozJ8=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-sLKpC6QQOmeJbVHNNA-N1w-1; Fri, 01 Jul 2022 05:34:25 -0400
X-MC-Unique: sLKpC6QQOmeJbVHNNA-N1w-1
Received: by mail-pl1-f199.google.com with SMTP id e8-20020a17090301c800b0016a57150c37so1212200plh.3
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 02:34:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TRbVMG9pe9kLTW8fXLQQcAgh1G0fF5UqNIzjXT/Ehks=;
        b=BK/EZ/kxfmmOsehmMUcotlTNKDGCENrGl7iGVHwupIZBApyShdtl6ZfHpoKGft26EW
         aewVm7DXDNj1+bKQ2nKCUjK6I2QgVMe3ki6uhlknp7pTgx73DzV+NSKVsE51kOq8bBBV
         m1CEpUKx2LzGPHVgttnUBtRUg1o58iQRFOzZiqlHI0mAh5nU64V3/5gD9JWNT4jyCidA
         q5BqqgRYwoa4EYhbQI9u+fX/9Kzo2sbPKWB2VssvDt2aeNVCErD+iwDmjvilQ9ZFV2qO
         g3j5cvVMkChCF54uTNGn5eHIDumDTmzDX7xlxg97mohPBrk0yfNMc46jW9IaF8jEJDCQ
         2aPg==
X-Gm-Message-State: AJIora9Oj005bEF/5zJGP7tHgvagRappOYKh39Z5nED+OcLuHuFBDP7J
        NkwZxjd1+kbp99cAxbluZTcGvHdbMygU1ENBe72YK7GrbIjtp434TM+WGjmXdxzFIZctTyuNsQk
        qGXQxemHh6BEauA7O
X-Received: by 2002:a63:be41:0:b0:40c:b4a8:dee9 with SMTP id g1-20020a63be41000000b0040cb4a8dee9mr11432173pgo.107.1656668064250;
        Fri, 01 Jul 2022 02:34:24 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sE5v7ksf3buwxxjLGMpBCFIkErXWPc59l6I+VsrcgW6eytue9aR08XqOAivwqVk5DzrN+qQw==
X-Received: by 2002:a63:be41:0:b0:40c:b4a8:dee9 with SMTP id g1-20020a63be41000000b0040cb4a8dee9mr11432146pgo.107.1656668063999;
        Fri, 01 Jul 2022 02:34:23 -0700 (PDT)
Received: from [10.72.13.237] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x1-20020a636301000000b004085adf1372sm14860507pgb.77.2022.07.01.02.34.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Jul 2022 02:34:23 -0700 (PDT)
Message-ID: <10281add-4d72-efe6-e94d-1f19ced9cb27@redhat.com>
Date:   Fri, 1 Jul 2022 17:34:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v11 24/40] virtio_pci: struct virtio_pci_common_cfg add
 queue_notify_data
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org
Cc:     Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org,
        kangjie.xu@linux.alibaba.com
References: <20220629065656.54420-1-xuanzhuo@linux.alibaba.com>
 <20220629065656.54420-25-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220629065656.54420-25-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/6/29 14:56, Xuan Zhuo 写道:
> Add queue_notify_data in struct virtio_pci_common_cfg, which comes from
> here https://github.com/oasis-tcs/virtio-spec/issues/89
>
> Since I want to add queue_reset after queue_notify_data, I submitted
> this patch first.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Acked-by: Jason Wang <jasowang@redhat.com>
> ---
>   include/linux/virtio_pci_modern.h | 2 ++
>   include/uapi/linux/virtio_pci.h   | 1 +
>   2 files changed, 3 insertions(+)
>
> diff --git a/include/linux/virtio_pci_modern.h b/include/linux/virtio_pci_modern.h
> index c4f7ffbacb4e..9f31dde46f57 100644
> --- a/include/linux/virtio_pci_modern.h
> +++ b/include/linux/virtio_pci_modern.h
> @@ -29,6 +29,8 @@ struct virtio_pci_common_cfg {
>   	__le32 queue_avail_hi;		/* read-write */
>   	__le32 queue_used_lo;		/* read-write */
>   	__le32 queue_used_hi;		/* read-write */
> +	__le16 queue_notify_data;	/* read-write */
> +	__le16 padding;
>   };


As previous patch, I think it's better to simple embed the uAPI 
structure here.

Thanks


>   
>   struct virtio_pci_modern_device {
> diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
> index 247ec42af2c8..748b3eb62d2f 100644
> --- a/include/uapi/linux/virtio_pci.h
> +++ b/include/uapi/linux/virtio_pci.h
> @@ -176,6 +176,7 @@ struct virtio_pci_cfg_cap {
>   #define VIRTIO_PCI_COMMON_Q_AVAILHI	44
>   #define VIRTIO_PCI_COMMON_Q_USEDLO	48
>   #define VIRTIO_PCI_COMMON_Q_USEDHI	52
> +#define VIRTIO_PCI_COMMON_Q_NDATA	56
>   
>   #endif /* VIRTIO_PCI_NO_MODERN */
>   

