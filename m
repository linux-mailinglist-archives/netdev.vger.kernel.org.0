Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF7143BD5D
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 00:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237353AbhJZWo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 18:44:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:22370 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230420AbhJZWo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 18:44:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635288153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vW6qRmUkaWK4h81DeTaFQgDoiFlX7pUpcif9sgyaWrw=;
        b=Q1WdHaMRFKcRvYFM1PsHv+J/FU1eqRElZry/DS0UKKupm69tvKoHnkkGpEHnYbYFx6rHxR
        OdoSbyqxBpbdC/ZGjApDqwRdj8YxZ6sLsC2RDjLuR2muWy8IUtr9gdzWNIRDD+puLsQAfW
        xs3n/hccvRW1EB/DTJmVRo+9k9FELtI=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-5pqigeDeMN-B_k_o8l82Xg-1; Tue, 26 Oct 2021 18:42:31 -0400
X-MC-Unique: 5pqigeDeMN-B_k_o8l82Xg-1
Received: by mail-ot1-f71.google.com with SMTP id g17-20020a05683030b100b00552dffc33e5so303799ots.10
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 15:42:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vW6qRmUkaWK4h81DeTaFQgDoiFlX7pUpcif9sgyaWrw=;
        b=ylrCEdZP5ddWPoMX0Hz6c/s0b4//+CaBd3VGFRGy3F0CrDqXXjiMxy16jZIOmNQy6o
         h8Tf9ND9pplx1u307abwSkX9UTW7g5qP3/6UHiHCD94VA3rEqoMU8DD0rGbR7MQ3ynGL
         +TdkE1xczwz9OjfoZRuFb5J7tnvqltv+kHSPfLA9pk+b6FOI4ARw21BRg/yoIfPmm6yd
         QeCSknIUT+sFLRLNPb0IVNdUCbZ+VRN4OhD2dVi72jBOoSN4fKwcrB3P90DSsIrl2n9q
         Qz1LOZtZHHkkA5Ou7nu7eybS5a2hKwp5AUPevfqJHp5udh485DOTTFWEhkjl/cSD9Cut
         ZpQw==
X-Gm-Message-State: AOAM5321ny7wmd6KnRWzu/vVUfGqWElg1qo2WpIcdSvgXf39qNAtKWqx
        gXZeMRCES36dmTlkKF5aZXvkXAjmq3+bt/vNMHni4cjFv7klkP1VRm+0s7aC3QUciCrVPxAlOzE
        g5tAGoj7w9apkQHai
X-Received: by 2002:a05:6808:1894:: with SMTP id bi20mr769914oib.136.1635288151158;
        Tue, 26 Oct 2021 15:42:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxTJ8pUKHZ04zyJABGkvIBECvvHJ/yxeIB99sqoaN32sZxKt7cKcZiY+N0ugdRR1v5laGpqxg==
X-Received: by 2002:a05:6808:1894:: with SMTP id bi20mr769900oib.136.1635288150903;
        Tue, 26 Oct 2021 15:42:30 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id s127sm1733539oif.56.2021.10.26.15.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 15:42:30 -0700 (PDT)
Date:   Tue, 26 Oct 2021 16:42:28 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <bhelgaas@google.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH V4 mlx5-next 11/13] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211026164228.084a7524.alex.williamson@redhat.com>
In-Reply-To: <20211026090605.91646-12-yishaih@nvidia.com>
References: <20211026090605.91646-1-yishaih@nvidia.com>
        <20211026090605.91646-12-yishaih@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Oct 2021 12:06:03 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:
> +static int mlx5vf_pci_set_device_state(struct mlx5vf_pci_core_device *mvdev,
> +				       u32 state)
> +{
> +	struct mlx5vf_pci_migration_info *vmig = &mvdev->vmig;
> +	u32 old_state = vmig->vfio_dev_state;
> +	u32 flipped_bits = old_state ^ state;
> +	int ret = 0;
> +
> +	if (old_state == VFIO_DEVICE_STATE_ERROR ||
> +	    !VFIO_DEVICE_STATE_VALID(state) ||
> +	    (state & ~MLX5VF_SUPPORTED_DEVICE_STATES))
> +		return -EINVAL;
> +
> +	/* Running switches off */
> +	if ((flipped_bits & VFIO_DEVICE_STATE_RUNNING) &&
> +	    !(state & VFIO_DEVICE_STATE_RUNNING)) {
> +		ret = mlx5vf_pci_quiesce_device(mvdev);
> +		if (ret)
> +			return ret;
> +		ret = mlx5vf_pci_freeze_device(mvdev);
> +		if (ret) {
> +			vmig->vfio_dev_state = VFIO_DEVICE_STATE_ERROR;
> +			return ret;

Is it not possible for this to unwind, only entering the error state if
unquiesce also fails?

> +		}
> +	}
> +
> +	/* Saving switches on and not running */
> +	if ((flipped_bits &
> +	     (VFIO_DEVICE_STATE_RUNNING | VFIO_DEVICE_STATE_SAVING)) &&
> +	    ((state & (VFIO_DEVICE_STATE_RUNNING |
> +	      VFIO_DEVICE_STATE_SAVING)) == VFIO_DEVICE_STATE_SAVING)) {

Can't this be reduced to:

 if ((flipped_bits & ~VFIO_DEVICE_STATE_RESUMING) &&
     (state == VFIO_DEVICE_STATE_SAVING)) {

Maybe there's an argument for the original to be more invariant of TBD
device_state bits?  Thanks,

Alex

> +		ret = mlx5vf_pci_save_device_data(mvdev);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	/* Resuming switches on */
> +	if ((flipped_bits & VFIO_DEVICE_STATE_RESUMING) &&
> +	    (state & VFIO_DEVICE_STATE_RESUMING)) {
> +		mlx5vf_reset_mig_state(mvdev);
> +		ret = mlx5vf_pci_new_write_window(mvdev);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	/* Resuming switches off */
> +	if ((flipped_bits & VFIO_DEVICE_STATE_RESUMING) &&
> +	    !(state & VFIO_DEVICE_STATE_RESUMING)) {
> +		/* deserialize state into the device */
> +		ret = mlx5vf_load_state(mvdev);
> +		if (ret) {
> +			vmig->vfio_dev_state = VFIO_DEVICE_STATE_ERROR;
> +			return ret;
> +		}
> +	}
> +
> +	/* Running switches on */
> +	if ((flipped_bits & VFIO_DEVICE_STATE_RUNNING) &&
> +	    (state & VFIO_DEVICE_STATE_RUNNING)) {
> +		ret = mlx5vf_pci_unfreeze_device(mvdev);
> +		if (ret)
> +			return ret;
> +		ret = mlx5vf_pci_unquiesce_device(mvdev);
> +		if (ret) {
> +			vmig->vfio_dev_state = VFIO_DEVICE_STATE_ERROR;
> +			return ret;
> +		}
> +	}
> +
> +	vmig->vfio_dev_state = state;
> +	return 0;
> +}

