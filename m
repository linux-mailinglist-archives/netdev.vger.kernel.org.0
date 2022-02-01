Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0F64A63D9
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 19:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234686AbiBASbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 13:31:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44047 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229915AbiBASbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 13:31:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643740308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lWcCCfSrxGYDduQ3iXNmhKq8eIpL0JoSBTfvltj/8CM=;
        b=ZOP72GPeB3a9BU1x5OQFO1kD6PKaHUS/GxdwylrEAPXpErqMDW+hIDGPWD8244JB8n/KlR
        hhRdaV0H4B84T07Bkdkirp1XhTIwgihCaOFjpl6IqBeji/29ip1+bpaJamghg9Zq+R96h8
        V0u+a0flrqVz6fi1pIPKUEjpTgpt0zw=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-PSWudKruNBacycuWdVMpgQ-1; Tue, 01 Feb 2022 13:31:47 -0500
X-MC-Unique: PSWudKruNBacycuWdVMpgQ-1
Received: by mail-oo1-f72.google.com with SMTP id g8-20020a4aa708000000b002e8efc514a6so6774323oom.12
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 10:31:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lWcCCfSrxGYDduQ3iXNmhKq8eIpL0JoSBTfvltj/8CM=;
        b=3HwhY0j0Dx/5DBstN6QyMAnJa69LZJzJ1zngaHfG+lPSMCvFkMv0ToG+ljVsm497C4
         ESl9jD+yoD9jni7YNd6O/7dKvMFUXd15POVTLOHzl4dJi5SaU+keAV6OmqSQvD+rHU7A
         a5/ATNJmLMu1ev2e2VzXBVGY7opTwZpyXM6HXjW1iXJqepbI1UurxC3E7M6NBOdVo5OG
         W5bsiOUNw3yprYztyeVCy0gPB6UYAWf5IwvAMVN1VC8iAmexDXDISKq8EniR1S0LrcOq
         lhljplt0nmMaw6/p6mEPLVknJ74O9AHJ9N6n0VjcAqEpW/V0Z1Swl3oeFBvO9n4xP6a/
         noUQ==
X-Gm-Message-State: AOAM533Oxtzz7ZMuKHkMRwP6dLvHAaMfINyIbXcHgznXtp2TjynhdlPL
        5ST4Zpr4zrds1ZLQZbsKsThpYXDLvlIwKrkHkSf8/mcL/fZ1At/zpk+Wp/mRERRl4ewiF2Cv0aP
        aW2PpREp75iVbHWXv
X-Received: by 2002:a05:6808:bd6:: with SMTP id o22mr2056177oik.309.1643740306993;
        Tue, 01 Feb 2022 10:31:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw8CVMKC1GZyh/e69wmJFpSseU2Qrzj5ioYE5cAr/3TsLa65dQuvn6qvN1/aRP6C70RiE9NBg==
X-Received: by 2002:a05:6808:bd6:: with SMTP id o22mr2056155oik.309.1643740306743;
        Tue, 01 Feb 2022 10:31:46 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id r186sm10151672oie.23.2022.02.01.10.31.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 10:31:46 -0800 (PST)
Date:   Tue, 1 Feb 2022 11:31:44 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <bhelgaas@google.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH V6 mlx5-next 09/15] vfio: Extend the device migration
 protocol with RUNNING_P2P
Message-ID: <20220201113144.0c8dfaa5.alex.williamson@redhat.com>
In-Reply-To: <20220130160826.32449-10-yishaih@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
        <20220130160826.32449-10-yishaih@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 30 Jan 2022 18:08:20 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> From: Jason Gunthorpe <jgg@nvidia.com>
> 
> The RUNNING_P2P state is designed to support multiple devices in the same
> VM that are doing P2P transactions between themselves. When in RUNNING_P2P
> the device must be able to accept incoming P2P transactions but should not
> generate outgoing transactions.
> 
> As an optional extension to the mandatory states it is defined as
> inbetween STOP and RUNNING:
>    STOP -> RUNNING_P2P -> RUNNING -> RUNNING_P2P -> STOP
> 
> For drivers that are unable to support RUNNING_P2P the core code silently
> merges RUNNING_P2P and RUNNING together. Drivers that support this will be
> required to implement 4 FSM arcs beyond the basic FSM. 2 of the basic FSM
> arcs become combination transitions.
> 
> Compared to the v1 clarification, NDMA is redefined into FSM states and is
> described in terms of the desired P2P quiescent behavior, noting that
> halting all DMA is an acceptable implementation.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/vfio/vfio.c       | 70 ++++++++++++++++++++++++++++++---------
>  include/linux/vfio.h      |  2 ++
>  include/uapi/linux/vfio.h | 34 +++++++++++++++++--
>  3 files changed, 88 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index b12be212d048..a722a1a8a48a 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1573,39 +1573,55 @@ u32 vfio_mig_get_next_state(struct vfio_device *device,
>  			    enum vfio_device_mig_state cur_fsm,
>  			    enum vfio_device_mig_state new_fsm)
>  {
> -	enum { VFIO_DEVICE_NUM_STATES = VFIO_DEVICE_STATE_RESUMING + 1 };
> +	enum { VFIO_DEVICE_NUM_STATES = VFIO_DEVICE_STATE_RUNNING_P2P + 1 };
>  	/*
> -	 * The coding in this table requires the driver to implement 6
> +	 * The coding in this table requires the driver to implement
>  	 * FSM arcs:
>  	 *         RESUMING -> STOP
> -	 *         RUNNING -> STOP
>  	 *         STOP -> RESUMING
> -	 *         STOP -> RUNNING
>  	 *         STOP -> STOP_COPY
>  	 *         STOP_COPY -> STOP
>  	 *
> -	 * The coding will step through multiple states for these combination
> -	 * transitions:
> -	 *         RESUMING -> STOP -> RUNNING
> +	 * If P2P is supported then the driver must also implement these FSM
> +	 * arcs:
> +	 *         RUNNING -> RUNNING_P2P
> +	 *         RUNNING_P2P -> RUNNING
> +	 *         RUNNING_P2P -> STOP
> +	 *         STOP -> RUNNING_P2P
> +	 * Without P2P the driver must implement:
> +	 *         RUNNING -> STOP
> +	 *         STOP -> RUNNING
> +	 *
> +	 * If all optional features are supported then the coding will step
> +	 * through multiple states for these combination transitions:
> +	 *         RESUMING -> STOP -> RUNNING_P2P
> +	 *         RESUMING -> STOP -> RUNNING_P2P -> RUNNING
>  	 *         RESUMING -> STOP -> STOP_COPY
> -	 *         RUNNING -> STOP -> RESUMING
> -	 *         RUNNING -> STOP -> STOP_COPY
> +	 *         RUNNING -> RUNNING_P2P -> STOP
> +	 *         RUNNING -> RUNNING_P2P -> STOP -> RESUMING
> +	 *         RUNNING -> RUNNING_P2P -> STOP -> STOP_COPY
> +	 *         RUNNING_P2P -> STOP -> RESUMING
> +	 *         RUNNING_P2P -> STOP -> STOP_COPY
> +	 *         STOP -> RUNNING_P2P -> RUNNING
>  	 *         STOP_COPY -> STOP -> RESUMING
> -	 *         STOP_COPY -> STOP -> RUNNING
> +	 *         STOP_COPY -> STOP -> RUNNING_P2P
> +	 *         STOP_COPY -> STOP -> RUNNING_P2P -> RUNNING
>  	 */
>  	static const u8 vfio_from_fsm_table[VFIO_DEVICE_NUM_STATES][VFIO_DEVICE_NUM_STATES] = {
>  		[VFIO_DEVICE_STATE_STOP] = {
>  			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_STOP,
> -			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_RUNNING,
> +			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_RUNNING_P2P,
>  			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP_COPY,
>  			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_RESUMING,
> +			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_RUNNING_P2P,
>  			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
>  		},
>  		[VFIO_DEVICE_STATE_RUNNING] = {
> -			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_RUNNING_P2P,
>  			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_RUNNING,
> -			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP,
> -			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_RUNNING_P2P,
> +			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_RUNNING_P2P,
> +			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_RUNNING_P2P,
>  			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
>  		},
>  		[VFIO_DEVICE_STATE_STOP_COPY] = {
> @@ -1613,6 +1629,7 @@ u32 vfio_mig_get_next_state(struct vfio_device *device,
>  			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_STOP,
>  			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP_COPY,
>  			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_STOP,
>  			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
>  		},
>  		[VFIO_DEVICE_STATE_RESUMING] = {
> @@ -1620,6 +1637,15 @@ u32 vfio_mig_get_next_state(struct vfio_device *device,
>  			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_STOP,
>  			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP,
>  			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_RESUMING,
> +			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
> +		},
> +		[VFIO_DEVICE_STATE_RUNNING_P2P] = {
> +			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_RUNNING,
> +			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_RUNNING_P2P,
>  			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
>  		},
>  		[VFIO_DEVICE_STATE_ERROR] = {
> @@ -1627,14 +1653,26 @@ u32 vfio_mig_get_next_state(struct vfio_device *device,
>  			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_ERROR,
>  			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_ERROR,
>  			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_ERROR,
> +			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_ERROR,
>  			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
>  		},
>  	};
> +	bool have_p2p = device->migration_flags & VFIO_MIGRATION_P2P;
> +
>  	if (cur_fsm >= ARRAY_SIZE(vfio_from_fsm_table) ||
>  	    new_fsm >= ARRAY_SIZE(vfio_from_fsm_table))
>  		return VFIO_DEVICE_STATE_ERROR;
>  
> -	return vfio_from_fsm_table[cur_fsm][new_fsm];
> +	if (!have_p2p && (new_fsm == VFIO_DEVICE_STATE_RUNNING_P2P ||
> +			  cur_fsm == VFIO_DEVICE_STATE_RUNNING_P2P))
> +		return VFIO_DEVICE_STATE_ERROR;

new_fsm is provided by the user, we pass set_state.device_state
directly to .migration_set_state.  We should do bounds checking and
compatibility testing on the end state in the core so that we can
return an appropriate -EINVAL and -ENOSUPP respectively, otherwise
we're giving userspace a path to put the device into ERROR state, which
we claim is not allowed.

Testing cur_fsm is more an internal consistency check, maybe those
should be WARN_ON.

> +
> +	cur_fsm = vfio_from_fsm_table[cur_fsm][new_fsm];
> +	if (!have_p2p) {
> +		while (cur_fsm == VFIO_DEVICE_STATE_RUNNING_P2P)
> +			cur_fsm = vfio_from_fsm_table[cur_fsm][new_fsm];
> +	}

Perhaps this could be generalized with something like:

	static const unsigned int state_flags_table[VFIO_DEVICE_NUM_STATES] = {
		[VFIO_DEVICE_STATE_STOP] = VFIO_MIGRATION_STOP_COPY,
		[VFIO_DEVICE_STATE_RUNNING] = VFIO_MIGRATION_STOP_COPY,
		[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_MIGRATION_STOP_COPY,
		[VFIO_DEVICE_STATE_RESUMING] = VFIO_MIGRATION_STOP_COPY,
		[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_MIGRATION_P2P,
		[VFIO_DEVICE_STATE_ERROR] = ~0U,
	};

	while (!(state_flags_table[cur_fsm] & device->migration_flags))
		cur_fsm = vfio_from_fsm_table[cur_fsm][new_fsm];

Thanks,
Alex

