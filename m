Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F52341A345
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 00:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237960AbhI0Wse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 18:48:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24829 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237860AbhI0Wsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 18:48:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632782812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8F+8mdvFnjyvb27t/Z7nCLuVODAh1SKK2P1DV+cBzVQ=;
        b=T8rl9bJniw4vopVQ7mtIaOb48I3cuFVPEbhpGi+9B/WGYumaEZSxPdI3yPReDQgDkWaAI2
        n9lDoWkfWL9fazmKwT11LSAv5xpOnP5rtAkEzqlHhgHKfB8LxYXCEjSTcb+QLzCiEldJJm
        rnak6LdxAQKREuTWXfkkUHizZbpSBe0=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-85-UPUROmX4PkOkIUQCtNMhMA-1; Mon, 27 Sep 2021 18:46:50 -0400
X-MC-Unique: UPUROmX4PkOkIUQCtNMhMA-1
Received: by mail-oi1-f199.google.com with SMTP id j200-20020acaebd1000000b0027357b3466aso16456306oih.1
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 15:46:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=8F+8mdvFnjyvb27t/Z7nCLuVODAh1SKK2P1DV+cBzVQ=;
        b=XwvedZbCAKaNf/pJIbHoBXbGrMTDNGTsfc0Zv2cH6Ldc6oOdNpkRXNKdmDhDPDwnrI
         RlmiNrgpKG0pLHCUmWwj47GTw2MiAXpQI9jBhHkAywAMoNowXNHM3hQU+WpO8/HsBQOs
         D/OaxvFS+KkKJkLrdQXRexcS+16S2VpFVfuycP3Umpg/e6+OjbcUBJZcg6DBlclTsl/c
         z4+jb1RyC8b5evnH2p262kpQ4zpXTUbK94L2MzV/euSY0qSyOk1NLOZDN3bPagqUdW3C
         fIFYLYx4PdZ0f4lS1LX19YwyeGQWyqxQU0UqDcL00h67DFQeI6eFgeJNmCbJwlDPe725
         CYXQ==
X-Gm-Message-State: AOAM531o6gVsHYnmLBC44xmH0mC/2uQ1g7ueiXqX/Ki9b8k7u+fTkFeT
        6yMkGyZn1xw5JIgeu3iTIsnRuxihd/9BGhBFaDJJBZvuE04k3Maf6hVSilXnX3RB4GCfw5EHyJZ
        H0dkpSlyWZAZ0vppm
X-Received: by 2002:a9d:3e4b:: with SMTP id h11mr2287822otg.294.1632782810027;
        Mon, 27 Sep 2021 15:46:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1jND2vrOW39yVryOFHax2Bs9KlJre1+KCsNJKeV9Tr2lKgH+ZgnhOc6Tb6usJYsbl04jIhQ==
X-Received: by 2002:a9d:3e4b:: with SMTP id h11mr2287802otg.294.1632782809801;
        Mon, 27 Sep 2021 15:46:49 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id y9sm4403779ooe.10.2021.09.27.15.46.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 15:46:49 -0700 (PDT)
Date:   Mon, 27 Sep 2021 16:46:48 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH mlx5-next 2/7] vfio: Add an API to check migration state
 transition validity
Message-ID: <20210927164648.1e2d49ac.alex.williamson@redhat.com>
In-Reply-To: <c87f55d6fec77a22b110d3c9611744e6b28bba46.1632305919.git.leonro@nvidia.com>
References: <cover.1632305919.git.leonro@nvidia.com>
        <c87f55d6fec77a22b110d3c9611744e6b28bba46.1632305919.git.leonro@nvidia.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Sep 2021 13:38:51 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> From: Yishai Hadas <yishaih@nvidia.com>
> 
> Add an API in the core layer to check migration state transition validity
> as part of a migration flow.
> 
> The valid transitions follow the expected usage as described in
> uapi/vfio.h and triggered by QEMU.
> 
> This ensures that all migration implementations follow a consistent
> migration state machine.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/vfio/vfio.c  | 41 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/vfio.h |  1 +
>  2 files changed, 42 insertions(+)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 3c034fe14ccb..c3ca33e513c8 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1664,6 +1664,47 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
>  	return 0;
>  }
>  
> +/**
> + * vfio_change_migration_state_allowed - Checks whether a migration state
> + *   transition is valid.
> + * @new_state: The new state to move to.
> + * @old_state: The old state.
> + * Return: true if the transition is valid.
> + */
> +bool vfio_change_migration_state_allowed(u32 new_state, u32 old_state)
> +{
> +	enum { MAX_STATE = VFIO_DEVICE_STATE_RESUMING };
> +	static const u8 vfio_from_state_table[MAX_STATE + 1][MAX_STATE + 1] = {
> +		[VFIO_DEVICE_STATE_STOP] = {
> +			[VFIO_DEVICE_STATE_RUNNING] = 1,
> +			[VFIO_DEVICE_STATE_RESUMING] = 1,
> +		},

Our state transition diagram is pretty weak on reachable transitions
out of the _STOP state, why do we select only these two as valid?

Consistent behavior to userspace is of course nice, but I wonder if we
were expecting a device reset to get us back to _RUNNING, or if the
drivers would make use of the protocol through which a driver can nak
(write error, no state change) or fault (_ERROR device state) a state
change.

There does need to be a way to get back to _RUNNING to support a
migration failure without a reset, but would that be from _SAVING
or from _STOP and what's our rationale for the excluded states?

I'll see if I can dig through emails to find what was intended to be
reachable from _STOP.  Kirti or Connie, do you recall?

Also, I think the _ERROR state is implicitly handled correctly here,
its value is >MAX_STATE so we can't transition into or out of it, but a
comment to indicate that it's been considered for this would be nice.

> +		[VFIO_DEVICE_STATE_RUNNING] = {
> +			[VFIO_DEVICE_STATE_STOP] = 1,
> +			[VFIO_DEVICE_STATE_SAVING] = 1,
> +			[VFIO_DEVICE_STATE_SAVING | VFIO_DEVICE_STATE_RUNNING] = 1,
> +		},

Shameer's comment is correct here, _RESUMING is a valid next state
since the default state is _RUNNING.

> +		[VFIO_DEVICE_STATE_SAVING] = {
> +			[VFIO_DEVICE_STATE_STOP] = 1,
> +			[VFIO_DEVICE_STATE_RUNNING] = 1,
> +		},

What's the rationale that we can't return to _SAVING|_RUNNING here?

> +		[VFIO_DEVICE_STATE_SAVING | VFIO_DEVICE_STATE_RUNNING] = {
> +			[VFIO_DEVICE_STATE_RUNNING] = 1,
> +			[VFIO_DEVICE_STATE_SAVING] = 1,
> +		},

Can't we always _STOP the device at any point?

> +		[VFIO_DEVICE_STATE_RESUMING] = {
> +			[VFIO_DEVICE_STATE_RUNNING] = 1,
> +			[VFIO_DEVICE_STATE_STOP] = 1,
> +		},

Couldn't it be possible to switch immediately to _RUNNING|_SAVING for
tracing purposes?  Or _SAVING, perhaps to validate the restored state
without starting the device?  Thanks,

Alex

> +	};
> +
> +	if (new_state > MAX_STATE || old_state > MAX_STATE)
> +		return false;
> +
> +	return vfio_from_state_table[old_state][new_state];
> +}
> +EXPORT_SYMBOL_GPL(vfio_change_migration_state_allowed);
> +
>  static long vfio_device_fops_unl_ioctl(struct file *filep,
>  				       unsigned int cmd, unsigned long arg)
>  {
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index b53a9557884a..e65137a708f1 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -83,6 +83,7 @@ extern struct vfio_device *vfio_device_get_from_dev(struct device *dev);
>  extern void vfio_device_put(struct vfio_device *device);
>  
>  int vfio_assign_device_set(struct vfio_device *device, void *set_id);
> +bool vfio_change_migration_state_allowed(u32 new_state, u32 old_state);
>  
>  /* events for the backend driver notify callback */
>  enum vfio_iommu_notify_type {

