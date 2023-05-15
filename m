Return-Path: <netdev+bounces-2467-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 117B17021DA
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 04:53:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C8D5280EF0
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 02:53:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38F3915D2;
	Mon, 15 May 2023 02:53:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2568FEA0
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 02:53:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB62E7A
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 19:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684119230;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6CabpyALIbC0XiIqIpyQi+CRaEbpYdCuFNhvblzhbiM=;
	b=J6gwXGgw2xnq2ePk6ol6dBPVFrdxxmfSY1RGYkDBTR5gnYIqS5JStR9MUP0/rkxpJ4WRkG
	ZldHdptAbiDqHqaammo0CVxWVjPvBssMS86LsMBSNLm7xl4QTj89mnxK17RImob+ZTxai+
	pUKvC4aug2uhKuPT1Uy61T3Zd/AMVjw=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-96-1RGvOHp1OVyaze_-yvQckQ-1; Sun, 14 May 2023 22:53:49 -0400
X-MC-Unique: 1RGvOHp1OVyaze_-yvQckQ-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-648f83d2169so5021804b3a.0
        for <netdev@vger.kernel.org>; Sun, 14 May 2023 19:53:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684119228; x=1686711228;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6CabpyALIbC0XiIqIpyQi+CRaEbpYdCuFNhvblzhbiM=;
        b=ZcoyOGVny3topkg/dVAdnMC8J7NIc9iZ20bF7wvBDW4TA3KS2ZHN0CL/NTFM6Uz990
         H3HpDf7Jhdulm4z+KMI3ijRGqlozKsN2Mty7WoQhQApCYCSdvb2qgK2gOfytrT4x8VAM
         SqT28SLwoTl0qjWNAlXgz4/MicfE9A4YQM7VDdP3OQgUUE+p6qYIKQ6v5kUkwqyQ4dyy
         p08sEiV+nZ1xqhg/qlCSPx19MdLt8PAkh9PKV/NS7lqBE6BdyOaRkebpw3yKFLyzEAEy
         BfpfoBNdmcHxKpfN4XiiLaVwk8+saET7oXwFBFE9/vu2zLrZqM8mG3Dmzj01HqtlJZV0
         Zpeg==
X-Gm-Message-State: AC+VfDxuPUKCO9fQbtknvYNZAE1L6h2g667O4j7BYKG937smO0ASMn0x
	QPlrisF3OSJ0chGnVDnOgU0iLbLZwSVS294zLuuTBXezvPBmINQFu4qUt5HFmV6vQ1vajc0+hfE
	7vqK4CfE80kFcWPNpnPlfN2Tjq5WZPA==
X-Received: by 2002:a05:6a00:14ce:b0:640:f313:efba with SMTP id w14-20020a056a0014ce00b00640f313efbamr44287684pfu.19.1684119227746;
        Sun, 14 May 2023 19:53:47 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4H0Vhtb1WKGWG0qToJXua++R64IEkjUvFNR/u68c6n1aFTk5roUr6tBN4mKUL/UL196m7IKQ==
X-Received: by 2002:a05:6a00:14ce:b0:640:f313:efba with SMTP id w14-20020a056a0014ce00b00640f313efbamr44287666pfu.19.1684119227419;
        Sun, 14 May 2023 19:53:47 -0700 (PDT)
Received: from [10.72.13.223] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id c22-20020aa78816000000b00642c5ef6050sm9479859pfo.173.2023.05.14.19.53.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 May 2023 19:53:47 -0700 (PDT)
Message-ID: <7012a65f-d265-e510-492b-5003b512ef05@redhat.com>
Date: Mon, 15 May 2023 10:53:39 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH v5 virtio 01/11] virtio: allow caller to override device
 id in vp_modern
To: Shannon Nelson <shannon.nelson@amd.com>, mst@redhat.com,
 virtualization@lists.linux-foundation.org, brett.creeley@amd.com,
 netdev@vger.kernel.org
Cc: simon.horman@corigine.com, drivers@pensando.io
References: <20230503181240.14009-1-shannon.nelson@amd.com>
 <20230503181240.14009-2-shannon.nelson@amd.com>
Content-Language: en-US
From: Jason Wang <jasowang@redhat.com>
In-Reply-To: <20230503181240.14009-2-shannon.nelson@amd.com>
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
> allow the caller to check for a different device id.  This adds a function
> pointer field to struct virtio_pci_modern_device to specify an override
> device id check.  If defined by the driver, this function will be called
> to check that the PCI device is the vendor's expected device, and will
> return the found device id to be stored in mdev->id.device.  This allows
> vendors with alternative vendor device ids to use this library on their
> own device BAR.
>
> Note: A lot of the diff in this is simply indenting the existing code
> into an else block.
>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>


Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


> ---
>   drivers/virtio/virtio_pci_modern_dev.c | 30 ++++++++++++++++----------
>   include/linux/virtio_pci_modern.h      |  3 +++
>   2 files changed, 22 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/virtio/virtio_pci_modern_dev.c b/drivers/virtio/virtio_pci_modern_dev.c
> index 869cb46bef96..9b2d6614de67 100644
> --- a/drivers/virtio/virtio_pci_modern_dev.c
> +++ b/drivers/virtio/virtio_pci_modern_dev.c
> @@ -218,21 +218,29 @@ int vp_modern_probe(struct virtio_pci_modern_device *mdev)
>   	int err, common, isr, notify, device;
>   	u32 notify_length;
>   	u32 notify_offset;
> +	int devid;
>   
>   	check_offsets();
>   
> -	/* We only own devices >= 0x1000 and <= 0x107f: leave the rest. */
> -	if (pci_dev->device < 0x1000 || pci_dev->device > 0x107f)
> -		return -ENODEV;
> -
> -	if (pci_dev->device < 0x1040) {
> -		/* Transitional devices: use the PCI subsystem device id as
> -		 * virtio device id, same as legacy driver always did.
> -		 */
> -		mdev->id.device = pci_dev->subsystem_device;
> +	if (mdev->device_id_check) {
> +		devid = mdev->device_id_check(pci_dev);
> +		if (devid < 0)
> +			return devid;
> +		mdev->id.device = devid;
>   	} else {
> -		/* Modern devices: simply use PCI device id, but start from 0x1040. */
> -		mdev->id.device = pci_dev->device - 0x1040;
> +		/* We only own devices >= 0x1000 and <= 0x107f: leave the rest. */
> +		if (pci_dev->device < 0x1000 || pci_dev->device > 0x107f)
> +			return -ENODEV;
> +
> +		if (pci_dev->device < 0x1040) {
> +			/* Transitional devices: use the PCI subsystem device id as
> +			 * virtio device id, same as legacy driver always did.
> +			 */
> +			mdev->id.device = pci_dev->subsystem_device;
> +		} else {
> +			/* Modern devices: simply use PCI device id, but start from 0x1040. */
> +			mdev->id.device = pci_dev->device - 0x1040;
> +		}
>   	}
>   	mdev->id.vendor = pci_dev->subsystem_vendor;
>   
> diff --git a/include/linux/virtio_pci_modern.h b/include/linux/virtio_pci_modern.h
> index c4eeb79b0139..e7b1db1dd0bb 100644
> --- a/include/linux/virtio_pci_modern.h
> +++ b/include/linux/virtio_pci_modern.h
> @@ -38,6 +38,9 @@ struct virtio_pci_modern_device {
>   	int modern_bars;
>   
>   	struct virtio_device_id id;
> +
> +	/* optional check for vendor virtio device, returns dev_id or -ERRNO */
> +	int (*device_id_check)(struct pci_dev *pdev);
>   };
>   
>   /*


