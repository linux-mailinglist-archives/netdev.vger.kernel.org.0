Return-Path: <netdev+bounces-2468-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B211D7021DC
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 04:54:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E481280FA2
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 02:54:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 873D815D2;
	Mon, 15 May 2023 02:54:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B25BEA0
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 02:54:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75F4E7A
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 19:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684119260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EkzlwX51KE129ml/9poCdEkruLOF2qo9tI3tXAC4N1o=;
	b=VhF2ER+xRtp+nhNbzEhUUviimG+qmMuGKzEQlvH04IaBL53cXOk0tdS4h3vtBWxmuRUCWt
	xosnhDtNXyQGtMHQJohq2ZHAkOcyeEz+/3prmqhbNPwOusnGcecnKUFpZkE8FVX2sNueQ+
	CUDTGjrstkHFz3PAdZOBDRhI08Dqf60=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-412-0bKImmVmMje49XgTYBx0rA-1; Sun, 14 May 2023 22:54:19 -0400
X-MC-Unique: 0bKImmVmMje49XgTYBx0rA-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-6439a13ba1eso11804591b3a.0
        for <netdev@vger.kernel.org>; Sun, 14 May 2023 19:54:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684119257; x=1686711257;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EkzlwX51KE129ml/9poCdEkruLOF2qo9tI3tXAC4N1o=;
        b=RWbfhsf5uZTOGW30g06eXjiisit6BDS8lxIyHjawZIhh9WdVNlfRbkF8a8ugNYqnKq
         +7cKjQhZm5+W46ibBuv+iOGYYBqr7hJn+CTIQ/nutdwxUeSlK0ZwSWOENG8Lr6i7aGPK
         Hz7Ku1aEp25fXSza3uZi9aZs4r3JCYB8MDEkJ8VS2iooXGNkQRscU10dXcZsgpnDQWOA
         VpjPVtlF+mcpajT+pNkomG/KEPcnj0MBRDOXlGIuOTz/js7RxmA05Kj09TUYIUaTzdXL
         0otLntiauuUb5qctT/W3gtOO3btR3c9skYp1dfRKUhf8jmyHs+j8LJe1OMKpkaxNtgGe
         ektQ==
X-Gm-Message-State: AC+VfDyRC99Cw+dut/HKNWutQNDmxwd1WKmjXciAWma6nIXdAJTZ6+OI
	MjA1U0OYf07PP/uL7D8lGKdW9CJ6uTnonkiMgNGnVfLuxqyWNF03I5v3fqn5vOLtFO7ZfsI3XN0
	OnzyKvtKQptwWNtXpWB9AkEDiL0iF0g==
X-Received: by 2002:a05:6a00:1a06:b0:645:e008:d7ba with SMTP id g6-20020a056a001a0600b00645e008d7bamr33616785pfv.27.1684119257506;
        Sun, 14 May 2023 19:54:17 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ54myTqbH/N66ayTKu7p7Naxk1W4iTkxHVxbTrenFvZw42D9bZCcna/F3moNHQnqTqxvQG6IA==
X-Received: by 2002:a05:6a00:1a06:b0:645:e008:d7ba with SMTP id g6-20020a056a001a0600b00645e008d7bamr33616766pfv.27.1684119257204;
        Sun, 14 May 2023 19:54:17 -0700 (PDT)
Received: from [10.72.13.223] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id f26-20020aa78b1a000000b0063b6bd2216dsm652307pfd.187.2023.05.14.19.54.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 May 2023 19:54:16 -0700 (PDT)
Message-ID: <747f6c1f-2bd1-a331-796d-dbef43692183@redhat.com>
Date: Mon, 15 May 2023 10:54:12 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH v5 virtio 02/11] virtio: allow caller to override device
 DMA mask in vp_modern
Content-Language: en-US
To: Shannon Nelson <shannon.nelson@amd.com>, mst@redhat.com,
 virtualization@lists.linux-foundation.org, brett.creeley@amd.com,
 netdev@vger.kernel.org
Cc: simon.horman@corigine.com, drivers@pensando.io
References: <20230503181240.14009-1-shannon.nelson@amd.com>
 <20230503181240.14009-3-shannon.nelson@amd.com>
From: Jason Wang <jasowang@redhat.com>
In-Reply-To: <20230503181240.14009-3-shannon.nelson@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


在 2023/5/4 02:12, Shannon Nelson 写道:
> To add a bit of vendor flexibility with various virtio based devices,
> allow the caller to specify a different DMA mask.  This adds a dma_mask
> field to struct virtio_pci_modern_device.  If defined by the driver,
> this mask will be used in a call to dma_set_mask_and_coherent() instead
> of the traditional DMA_BIT_MASK(64).  This allows limiting the DMA space
> on vendor devices with address limitations.
>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>


Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


> ---
>   drivers/virtio/virtio_pci_modern_dev.c | 3 ++-
>   include/linux/virtio_pci_modern.h      | 3 +++
>   2 files changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/virtio/virtio_pci_modern_dev.c b/drivers/virtio/virtio_pci_modern_dev.c
> index 9b2d6614de67..aad7d9296e77 100644
> --- a/drivers/virtio/virtio_pci_modern_dev.c
> +++ b/drivers/virtio/virtio_pci_modern_dev.c
> @@ -268,7 +268,8 @@ int vp_modern_probe(struct virtio_pci_modern_device *mdev)
>   		return -EINVAL;
>   	}
>   
> -	err = dma_set_mask_and_coherent(&pci_dev->dev, DMA_BIT_MASK(64));
> +	err = dma_set_mask_and_coherent(&pci_dev->dev,
> +					mdev->dma_mask ? : DMA_BIT_MASK(64));
>   	if (err)
>   		err = dma_set_mask_and_coherent(&pci_dev->dev,
>   						DMA_BIT_MASK(32));
> diff --git a/include/linux/virtio_pci_modern.h b/include/linux/virtio_pci_modern.h
> index e7b1db1dd0bb..067ac1d789bc 100644
> --- a/include/linux/virtio_pci_modern.h
> +++ b/include/linux/virtio_pci_modern.h
> @@ -41,6 +41,9 @@ struct virtio_pci_modern_device {
>   
>   	/* optional check for vendor virtio device, returns dev_id or -ERRNO */
>   	int (*device_id_check)(struct pci_dev *pdev);
> +
> +	/* optional mask for devices with limited DMA space */
> +	u64 dma_mask;
>   };
>   
>   /*


