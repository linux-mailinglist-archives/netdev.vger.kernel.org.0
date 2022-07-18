Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F810578D8A
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 00:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbiGRWaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 18:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234197AbiGRWaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 18:30:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 11E58286D9
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 15:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658183403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xtK+zDK0ly1B+4VR7K7+afdONMMr3N7lkh16MEfdihY=;
        b=GssfH2stuD/dlIcvw5KTvc2WeEAtXFpXEocnedYMcRsaJa7daX7rUb6wOrD5QFQ8uVs/AZ
        H75ttsqEvSLqX+LAj2rP820Lrhimx2lteVuv6B3MafVJ+9VSIPu3miuSNzmz8EutEB4HRr
        LhYtnFHV+m3NQs7H5WWAFOc1X878424=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-X1tfQKfiNcmqOSdJbRWo8w-1; Mon, 18 Jul 2022 18:30:01 -0400
X-MC-Unique: X1tfQKfiNcmqOSdJbRWo8w-1
Received: by mail-il1-f199.google.com with SMTP id n16-20020a056e02141000b002dabb875f0aso8330100ilo.10
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 15:30:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=xtK+zDK0ly1B+4VR7K7+afdONMMr3N7lkh16MEfdihY=;
        b=FuTR+zHgNyf1lL0jVQ7v9Qgr+T1c+DrNfNw5fA9hGXYJw9tpAWQhh9owTjLB0txdv2
         LiP+8rzIv9yYr1cDMZXua//ofiFRwgDN2fOZcQIcRYFZXxe5gez45ZxWJpyp4TuYznF3
         T9PJDUwe+GmiAc5QO/l73kc7ED0Zs7n1Guq6i+r3Ew2wTZAw0M0uyBN5DV6yo/FgMJ8p
         rMDzbTf3phUZgG/AVHb4CxJ0kCek56Ho9Bx94gp0tpas81mdtRYzrFhbeM2E4nCoKWPn
         fL0qZO0Vl5lsZu85h7yDFuLB2tznBM3I343GXQBgyZiQQQKHUFs1QvMnnLVDThjWnodD
         mvnw==
X-Gm-Message-State: AJIora/nDVXmaMUG37mtTpEr2EiSLMzUtEoEZ1ICFTKCoE8ulc+XvIGg
        qr40P1ahbDhgt4gpWw8MHNhnRZuN9gBx7m+ZtLTWsJj2nVCD+v4llx3uD0YiTShH3yUYyxUtI2z
        Rv+Rz6ZEGLNFVdO7h
X-Received: by 2002:a05:6e02:148c:b0:2dc:386c:9a1a with SMTP id n12-20020a056e02148c00b002dc386c9a1amr14866335ilk.188.1658183400596;
        Mon, 18 Jul 2022 15:30:00 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tAXqEcJK0pIkcIl+HlvZE/NM1Hw/04cn2Y4kQD0d6n104uGJ2KDqJv/Jab6Sp3lvrytW0Z8Q==
X-Received: by 2002:a05:6e02:148c:b0:2dc:386c:9a1a with SMTP id n12-20020a056e02148c00b002dc386c9a1amr14866315ilk.188.1658183400341;
        Mon, 18 Jul 2022 15:30:00 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id n2-20020a056e0208e200b002dcdbb4f7b7sm2752335ilt.24.2022.07.18.15.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 15:29:59 -0700 (PDT)
Date:   Mon, 18 Jul 2022 16:29:57 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH V2 vfio 03/11] vfio: Introduce DMA logging uAPIs
Message-ID: <20220718162957.45ac2a0b.alex.williamson@redhat.com>
In-Reply-To: <20220714081251.240584-4-yishaih@nvidia.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
        <20220714081251.240584-4-yishaih@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jul 2022 11:12:43 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> DMA logging allows a device to internally record what DMAs the device is
> initiating and report them back to userspace. It is part of the VFIO
> migration infrastructure that allows implementing dirty page tracking
> during the pre copy phase of live migration. Only DMA WRITEs are logged,
> and this API is not connected to VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE.
> 
> This patch introduces the DMA logging involved uAPIs.
> 
> It uses the FEATURE ioctl with its GET/SET/PROBE options as of below.
> 
> It exposes a PROBE option to detect if the device supports DMA logging.
> It exposes a SET option to start device DMA logging in given IOVAs
> ranges.
> It exposes a SET option to stop device DMA logging that was previously
> started.
> It exposes a GET option to read back and clear the device DMA log.
> 
> Extra details exist as part of vfio.h per a specific option.


Kevin, Kirti, others, any comments on this uAPI proposal?  Are there
potentially other devices that might make use of this or is everyone
else waiting for IOMMU based dirty tracking?

 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  include/uapi/linux/vfio.h | 79 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 79 insertions(+)
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 733a1cddde30..81475c3e7c92 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -986,6 +986,85 @@ enum vfio_device_mig_state {
>  	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
>  };
>  
> +/*
> + * Upon VFIO_DEVICE_FEATURE_SET start device DMA logging.
> + * VFIO_DEVICE_FEATURE_PROBE can be used to detect if the device supports
> + * DMA logging.
> + *
> + * DMA logging allows a device to internally record what DMAs the device is
> + * initiating and report them back to userspace. It is part of the VFIO
> + * migration infrastructure that allows implementing dirty page tracking
> + * during the pre copy phase of live migration. Only DMA WRITEs are logged,
> + * and this API is not connected to VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE.
> + *
> + * When DMA logging is started a range of IOVAs to monitor is provided and the
> + * device can optimize its logging to cover only the IOVA range given. Each
> + * DMA that the device initiates inside the range will be logged by the device
> + * for later retrieval.
> + *
> + * page_size is an input that hints what tracking granularity the device
> + * should try to achieve. If the device cannot do the hinted page size then it
> + * should pick the next closest page size it supports. On output the device
> + * will return the page size it selected.
> + *
> + * ranges is a pointer to an array of
> + * struct vfio_device_feature_dma_logging_range.
> + */
> +struct vfio_device_feature_dma_logging_control {
> +	__aligned_u64 page_size;
> +	__u32 num_ranges;
> +	__u32 __reserved;
> +	__aligned_u64 ranges;
> +};
> +
> +struct vfio_device_feature_dma_logging_range {
> +	__aligned_u64 iova;
> +	__aligned_u64 length;
> +};
> +
> +#define VFIO_DEVICE_FEATURE_DMA_LOGGING_START 3
> +
> +/*
> + * Upon VFIO_DEVICE_FEATURE_SET stop device DMA logging that was started
> + * by VFIO_DEVICE_FEATURE_DMA_LOGGING_START
> + */
> +#define VFIO_DEVICE_FEATURE_DMA_LOGGING_STOP 4
> +
> +/*
> + * Upon VFIO_DEVICE_FEATURE_GET read back and clear the device DMA log
> + *
> + * Query the device's DMA log for written pages within the given IOVA range.
> + * During querying the log is cleared for the IOVA range.
> + *
> + * bitmap is a pointer to an array of u64s that will hold the output bitmap
> + * with 1 bit reporting a page_size unit of IOVA. The mapping of IOVA to bits
> + * is given by:
> + *  bitmap[(addr - iova)/page_size] & (1ULL << (addr % 64))
> + *
> + * The input page_size can be any power of two value and does not have to
> + * match the value given to VFIO_DEVICE_FEATURE_DMA_LOGGING_START. The driver
> + * will format its internal logging to match the reporting page size, possibly
> + * by replicating bits if the internal page size is lower than requested.
> + *
> + * Bits will be updated in bitmap using atomic or to allow userspace to
> + * combine bitmaps from multiple trackers together. Therefore userspace must
> + * zero the bitmap before doing any reports.

Somewhat confusing, perhaps "between report sets"?

> + *
> + * If any error is returned userspace should assume that the dirty log is
> + * corrupted and restart.

Restart what?  The user can't just zero the bitmap and retry, dirty
information at the device has been lost.  Are we suggesting they stop
DMA logging and restart it, which sounds a lot like failing a migration
and starting over.  Or could the user gratuitously mark the bitmap
fully dirty and a subsequent logging report iteration might work?
Thanks,

Alex

> + *
> + * If DMA logging is not enabled, an error will be returned.
> + *
> + */
> +struct vfio_device_feature_dma_logging_report {
> +	__aligned_u64 iova;
> +	__aligned_u64 length;
> +	__aligned_u64 page_size;
> +	__aligned_u64 bitmap;
> +};
> +
> +#define VFIO_DEVICE_FEATURE_DMA_LOGGING_REPORT 5
> +
>  /* -------- API for Type1 VFIO IOMMU -------- */
>  
>  /**

