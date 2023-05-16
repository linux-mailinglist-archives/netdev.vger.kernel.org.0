Return-Path: <netdev+bounces-2862-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 570CD7044FD
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 08:12:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77FD228117E
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 06:12:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D1161D2B4;
	Tue, 16 May 2023 06:12:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1CE3FDC
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 06:12:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0FF10C1
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 23:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684217569;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=acXAPI+j75jg9aaFVO84Z4crvWYhC8JaTkZZBzVz0e8=;
	b=MGZ5fYoI7lSvWPMnQnVppYhNOPjVbxxroAX5T9k/5E7wCFg7ECcVuGvvgQ9jmFMhE8pdvQ
	0G/jAAobgWJ93ueKseCPPBxUwciIfyIBG8CSn6z7w2Lp0GnDi/F5+SJNix3CLgfkkeGQYi
	aZmHWwVF13ALHi0gN86XBhr+Sxce/sA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-144-oyq6lbegPRGo9nnkojUE0g-1; Tue, 16 May 2023 02:12:48 -0400
X-MC-Unique: oyq6lbegPRGo9nnkojUE0g-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f433a2308bso8832765e9.0
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 23:12:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684217567; x=1686809567;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=acXAPI+j75jg9aaFVO84Z4crvWYhC8JaTkZZBzVz0e8=;
        b=erC/lXKDS8RS+Aa+9FFK7qUOQ2zwyV0G/eO7DXrnpYy5x7oaayUC2zrPcUP5Lm383Z
         OKSR+LaToMajRWiHRRm77oW3ue1pxhXAt3Jo7Wd3oFibRseHfeFllG+ZRb05rwm4YbTr
         tnc0kaJ3vZPO+73Vg260VfUDn4Z+dnKN04H4618tojImwNMWmJJnC7HF0AGKhCCUL6Yd
         4mUJi/JMPUdnEQs7Y/AKX7CSyFsJytmKGd0P2iETgmL8siNnhZKdeepO0EJH+o3gCzqr
         R/CQXwjOHunpsoPwwcBQBji4HPvMWluwOAO6wvyqe5iVe+fVyRMD+ucUzBnYS1QC+04V
         Qwlw==
X-Gm-Message-State: AC+VfDxyNVCBVcezSNk1UmBlC6EM1toQvzkcPZIVQxehU+1m7YeAVdtQ
	XE3TFjQj3fcWyncHQPHwFNphIOuh18fVr9V5RlZhEEqrvX0SD2fjtpT1uMaQegL1EsYQot6gGfL
	aFN4nz2bnirR1gPTN
X-Received: by 2002:a05:600c:4f45:b0:3f4:2bcf:e19 with SMTP id m5-20020a05600c4f4500b003f42bcf0e19mr16817559wmq.8.1684217566884;
        Mon, 15 May 2023 23:12:46 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6QmQ2YHayqLcYv6xqe53acMOnxaqTXWoMpXiMr4c4hHzQCAirgTrt8EM5xbrYsKan7zlNlmw==
X-Received: by 2002:a05:600c:4f45:b0:3f4:2bcf:e19 with SMTP id m5-20020a05600c4f4500b003f42bcf0e19mr16817542wmq.8.1684217566547;
        Mon, 15 May 2023 23:12:46 -0700 (PDT)
Received: from redhat.com ([2.52.26.5])
        by smtp.gmail.com with ESMTPSA id w12-20020a05600c474c00b003f07ef4e3e0sm32311772wmo.0.2023.05.15.23.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 23:12:45 -0700 (PDT)
Date: Tue, 16 May 2023 02:12:42 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Shannon Nelson <shannon.nelson@amd.com>
Cc: jasowang@redhat.com, virtualization@lists.linux-foundation.org,
	brett.creeley@amd.com, netdev@vger.kernel.org,
	simon.horman@corigine.com, drivers@pensando.io
Subject: Re: [PATCH v6 virtio 04/11] pds_vdpa: move enum from common to
 adminq header
Message-ID: <20230516020938-mutt-send-email-mst@kernel.org>
References: <20230516025521.43352-1-shannon.nelson@amd.com>
 <20230516025521.43352-5-shannon.nelson@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230516025521.43352-5-shannon.nelson@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 07:55:14PM -0700, Shannon Nelson wrote:
> The pds_core_logical_qtype enum and IFNAMSIZ are not needed
> in the common PDS header, only needed when working with the
> adminq, so move them to the adminq header.
> 
> Note: This patch might conflict with pds_vfio patches that are
>       in review, depending on which patchset gets pulled first.
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> Acked-by: Jason Wang <jasowang@redhat.com>

It's a bit weird to add code in one patch then move it
in another. Why not start with it in the final location?

More importantly, the use of adminq terminology here
is a going to be somewhat confusing with the unrelated
admin virtqueue just having landed in the virtio spec.
Is this terminology coming from some hardware spec?

> ---
>  include/linux/pds/pds_adminq.h | 21 +++++++++++++++++++++
>  include/linux/pds/pds_common.h | 21 ---------------------
>  2 files changed, 21 insertions(+), 21 deletions(-)
> 
> diff --git a/include/linux/pds/pds_adminq.h b/include/linux/pds/pds_adminq.h
> index 98a60ce87b92..61b0a8634e1a 100644
> --- a/include/linux/pds/pds_adminq.h
> +++ b/include/linux/pds/pds_adminq.h
> @@ -222,6 +222,27 @@ enum pds_core_lif_type {
>  	PDS_CORE_LIF_TYPE_DEFAULT = 0,
>  };
>  
> +#define PDS_CORE_IFNAMSIZ		16
> +
> +/**
> + * enum pds_core_logical_qtype - Logical Queue Types
> + * @PDS_CORE_QTYPE_ADMINQ:    Administrative Queue
> + * @PDS_CORE_QTYPE_NOTIFYQ:   Notify Queue
> + * @PDS_CORE_QTYPE_RXQ:       Receive Queue
> + * @PDS_CORE_QTYPE_TXQ:       Transmit Queue
> + * @PDS_CORE_QTYPE_EQ:        Event Queue
> + * @PDS_CORE_QTYPE_MAX:       Max queue type supported
> + */
> +enum pds_core_logical_qtype {
> +	PDS_CORE_QTYPE_ADMINQ  = 0,
> +	PDS_CORE_QTYPE_NOTIFYQ = 1,
> +	PDS_CORE_QTYPE_RXQ     = 2,
> +	PDS_CORE_QTYPE_TXQ     = 3,
> +	PDS_CORE_QTYPE_EQ      = 4,
> +
> +	PDS_CORE_QTYPE_MAX     = 16   /* don't change - used in struct size */
> +};
> +
>  /**
>   * union pds_core_lif_config - LIF configuration
>   * @state:	    LIF state (enum pds_core_lif_state)
> diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
> index 2a0d1669cfd0..435c8e8161c2 100644
> --- a/include/linux/pds/pds_common.h
> +++ b/include/linux/pds/pds_common.h
> @@ -41,27 +41,6 @@ enum pds_core_vif_types {
>  
>  #define PDS_VDPA_DEV_NAME	PDS_CORE_DRV_NAME "." PDS_DEV_TYPE_VDPA_STR
>  
> -#define PDS_CORE_IFNAMSIZ		16
> -
> -/**
> - * enum pds_core_logical_qtype - Logical Queue Types
> - * @PDS_CORE_QTYPE_ADMINQ:    Administrative Queue
> - * @PDS_CORE_QTYPE_NOTIFYQ:   Notify Queue
> - * @PDS_CORE_QTYPE_RXQ:       Receive Queue
> - * @PDS_CORE_QTYPE_TXQ:       Transmit Queue
> - * @PDS_CORE_QTYPE_EQ:        Event Queue
> - * @PDS_CORE_QTYPE_MAX:       Max queue type supported
> - */
> -enum pds_core_logical_qtype {
> -	PDS_CORE_QTYPE_ADMINQ  = 0,
> -	PDS_CORE_QTYPE_NOTIFYQ = 1,
> -	PDS_CORE_QTYPE_RXQ     = 2,
> -	PDS_CORE_QTYPE_TXQ     = 3,
> -	PDS_CORE_QTYPE_EQ      = 4,
> -
> -	PDS_CORE_QTYPE_MAX     = 16   /* don't change - used in struct size */
> -};
> -
>  int pdsc_register_notify(struct notifier_block *nb);
>  void pdsc_unregister_notify(struct notifier_block *nb);
>  void *pdsc_get_pf_struct(struct pci_dev *vf_pdev);
> -- 
> 2.17.1


