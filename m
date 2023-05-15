Return-Path: <netdev+bounces-2470-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60D7E7021E1
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 04:56:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6786D1C20992
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 02:56:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64CE015D2;
	Mon, 15 May 2023 02:56:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A5FEA0
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 02:56:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5FFE7A
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 19:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684119398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bUzbYHlUKg4/PI7O371dyR3ua40/pcwitfUhWTzjBSs=;
	b=ahYN47m5aNTuv8f56rDudXtrSEdENq7B3Bi5ctjKG6zW8InblpEB5cF6aijb2vTqiQh1pn
	VF1oGWdAD9oU0CKu5LNsQXdJvLDBbRfu1pNkbOUUCK0f3rvJfZXy+cjqbYaALKtpFGjh26
	VImpbRDPLPTfxiSQeLrL0bdRmf/TCgA=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-37-4xU3aghUM-OVp4QSYR6cFA-1; Sun, 14 May 2023 22:56:37 -0400
X-MC-Unique: 4xU3aghUM-OVp4QSYR6cFA-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-64389a4487fso7107154b3a.1
        for <netdev@vger.kernel.org>; Sun, 14 May 2023 19:56:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684119396; x=1686711396;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bUzbYHlUKg4/PI7O371dyR3ua40/pcwitfUhWTzjBSs=;
        b=Ao883NUpfgZWiZNTihcQWR4JCJDCniXHy4K0+468zb8MCJ3ZgBWcq05yu3uQHiVa1n
         Qm9PM1lbU9Woz0STNCCEpI/XuqCCf2zZL4NtYhDh8gIKeVMQI4YMP9o04JD7ts5x6eUi
         hkuASccZ+YKqh7Ukf4oz+7RV53hCvrhk9b9Q9aFIF3VYu8VkC3vb2tVfUmkwNAC80y7B
         aiavNhrjfGtnJRZR9jQS9d7Cimrj4hfBwM/Yp+YbfIlqozN9+W3fQIjurEDgnS0Jod3x
         S+OyfMvzIYQPtU0Qb7gkxw8BLSOkyaD3lXx0MakOxJoZXOHonRWzVwMSDXbb5rlGJBOR
         lk6w==
X-Gm-Message-State: AC+VfDwILPbf+Idr+Jyobs77LWdGSGoljKrrDHUVCQMT6yNrlpOn+UQ1
	EaCLFd60nvJ3Z1M3tyxZKCNdnZxmce+OwQf5fZ/HTyiDZ6dIIL4lpsi+183VsJzrnS3KI7gGUzy
	MQBA5dJDacmBp770XPZPuMDMkHG+dQw==
X-Received: by 2002:a05:6a00:98a:b0:643:85a0:57fe with SMTP id u10-20020a056a00098a00b0064385a057femr50531312pfg.2.1684119396286;
        Sun, 14 May 2023 19:56:36 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4hQEUIlMZ5h7tntqMDRWtxGUwHc/2UUFSzmrkm/+4lnJ71Lh5riU0+mDR8KDLtSS3qVIgQyA==
X-Received: by 2002:a05:6a00:98a:b0:643:85a0:57fe with SMTP id u10-20020a056a00098a00b0064385a057femr50531294pfg.2.1684119395925;
        Sun, 14 May 2023 19:56:35 -0700 (PDT)
Received: from [10.72.13.223] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id e11-20020a62ee0b000000b00642ea56f06dsm10636893pfi.26.2023.05.14.19.56.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 May 2023 19:56:35 -0700 (PDT)
Message-ID: <372f2dd4-74ae-1bd1-6f54-3bb3f9b05451@redhat.com>
Date: Mon, 15 May 2023 10:56:23 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH v5 virtio 04/11] pds_vdpa: move enum from common to adminq
 header
Content-Language: en-US
To: Shannon Nelson <shannon.nelson@amd.com>, mst@redhat.com,
 virtualization@lists.linux-foundation.org, brett.creeley@amd.com,
 netdev@vger.kernel.org
Cc: simon.horman@corigine.com, drivers@pensando.io
References: <20230503181240.14009-1-shannon.nelson@amd.com>
 <20230503181240.14009-5-shannon.nelson@amd.com>
From: Jason Wang <jasowang@redhat.com>
In-Reply-To: <20230503181240.14009-5-shannon.nelson@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


在 2023/5/4 02:12, Shannon Nelson 写道:
> The pds_core_logical_qtype enum and IFNAMSIZ are not needed
> in the common PDS header, only needed when working with the
> adminq, so move them to the adminq header.
>
> Note: This patch might conflict with pds_vfio patches that are
>        in review, depending on which patchset gets pulled first.
>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>


Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


> ---
>   include/linux/pds/pds_adminq.h | 21 +++++++++++++++++++++
>   include/linux/pds/pds_common.h | 21 ---------------------
>   2 files changed, 21 insertions(+), 21 deletions(-)
>
> diff --git a/include/linux/pds/pds_adminq.h b/include/linux/pds/pds_adminq.h
> index 98a60ce87b92..61b0a8634e1a 100644
> --- a/include/linux/pds/pds_adminq.h
> +++ b/include/linux/pds/pds_adminq.h
> @@ -222,6 +222,27 @@ enum pds_core_lif_type {
>   	PDS_CORE_LIF_TYPE_DEFAULT = 0,
>   };
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
>   /**
>    * union pds_core_lif_config - LIF configuration
>    * @state:	    LIF state (enum pds_core_lif_state)
> diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
> index 2a0d1669cfd0..435c8e8161c2 100644
> --- a/include/linux/pds/pds_common.h
> +++ b/include/linux/pds/pds_common.h
> @@ -41,27 +41,6 @@ enum pds_core_vif_types {
>   
>   #define PDS_VDPA_DEV_NAME	PDS_CORE_DRV_NAME "." PDS_DEV_TYPE_VDPA_STR
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
>   int pdsc_register_notify(struct notifier_block *nb);
>   void pdsc_unregister_notify(struct notifier_block *nb);
>   void *pdsc_get_pf_struct(struct pci_dev *vf_pdev);


