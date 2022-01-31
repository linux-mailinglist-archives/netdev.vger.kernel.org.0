Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACBD14A5376
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 00:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiAaXn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 18:43:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:40238 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229706AbiAaXn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 18:43:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643672605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/7xlInaUv5l6ue1e1S+wPZAboxKRTQW6AQoeIk3l2Vc=;
        b=ZLvozTKNyGj4J5g9mrZ5tCK1BX+961ZdgpEMXbs36S4pqv89BJlYLjlXONJm5zO0e4ER0C
        JjpmxQfaHt2XHjXpobo1Rt0mn0B67VAJh93hRWBXpiffVI2e+W7c4HoTehnth2C29lw3Qi
        4sqhnhk0P23VlxnTCBmiulaXaiwuH/A=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-iPuezGg9Mdi38rPKQ09OWA-1; Mon, 31 Jan 2022 18:43:22 -0500
X-MC-Unique: iPuezGg9Mdi38rPKQ09OWA-1
Received: by mail-oo1-f71.google.com with SMTP id n5-20020a4ab345000000b002dc79e4a2baso5701487ooo.15
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 15:43:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/7xlInaUv5l6ue1e1S+wPZAboxKRTQW6AQoeIk3l2Vc=;
        b=g186W2bqr9ddErZokiOtMpsHvgtGWQEovCJfcPrfh9Yf38mg4hBgTLXOSQ9b6aezNM
         vJ1VGqP8EXNxV6r/C6aOqYk7hFZGQ4O+DubiZTgekMuzmXRonSfeSJ+WYgBdw1KEnt84
         CtyIyO6H53cJRxCj9Hpa9NNhcBf4MvDOKub/BLAWAG1/h7I9ckmhUOxOhpGWp1PmqbHe
         6SDVnmgGzQaQscE1EN/FIsCpeZD0KNqEw0w6YX6wSY3zEa8xgRYDdON5rwKwD5Te85Cz
         zm+n/88RHEEoElnzfFVUq0F8OJ06ccLIdtlDIw+GTFTrr8OXEb7jqYOjae0tjZrcoNoT
         xyyQ==
X-Gm-Message-State: AOAM531oRKP4TADFsT6YAakpjRM/TyWyDDBsxhOFMVk1iT8aDh0c+RuN
        VvI1m4k2puHdNdedpjP4fVqeOgEhN0osJHF+o4Ip2ThxOtyHWoxGP7c3M4q7xUdcfGTvSsWyzVq
        1teUzMXorusBtCKOC
X-Received: by 2002:a9d:eca:: with SMTP id 68mr3231725otj.274.1643672600966;
        Mon, 31 Jan 2022 15:43:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwIIscsCjZrdPrtfvgU68hP33J9m6+i95ENDKpW4UXSzQsbbIxZiIOevun4i4rf5nb72C02lA==
X-Received: by 2002:a9d:eca:: with SMTP id 68mr3231699otj.274.1643672600315;
        Mon, 31 Jan 2022 15:43:20 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id bc36sm3303827oob.45.2022.01.31.15.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 15:43:20 -0800 (PST)
Date:   Mon, 31 Jan 2022 16:43:18 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <bhelgaas@google.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH V6 mlx5-next 08/15] vfio: Define device migration
 protocol v2
Message-ID: <20220131164318.3da9eae5.alex.williamson@redhat.com>
In-Reply-To: <20220130160826.32449-9-yishaih@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
        <20220130160826.32449-9-yishaih@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 30 Jan 2022 18:08:19 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index ef33ea002b0b..d9162702973a 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -605,10 +605,10 @@ struct vfio_region_gfx_edid {
>  
>  struct vfio_device_migration_info {
>  	__u32 device_state;         /* VFIO device state */
> -#define VFIO_DEVICE_STATE_STOP      (0)
> -#define VFIO_DEVICE_STATE_RUNNING   (1 << 0)
> -#define VFIO_DEVICE_STATE_SAVING    (1 << 1)
> -#define VFIO_DEVICE_STATE_RESUMING  (1 << 2)
> +#define VFIO_DEVICE_STATE_V1_STOP      (0)
> +#define VFIO_DEVICE_STATE_V1_RUNNING   (1 << 0)
> +#define VFIO_DEVICE_STATE_V1_SAVING    (1 << 1)
> +#define VFIO_DEVICE_STATE_V1_RESUMING  (1 << 2)

I assume the below is kept until we rip out all the references, but I'm
not sure why we're bothering to define V1 that's not used anywhere
versus just deleting the above to avoid collision with the new enum.

>  #define VFIO_DEVICE_STATE_MASK      (VFIO_DEVICE_STATE_RUNNING | \
>  				     VFIO_DEVICE_STATE_SAVING |  \
>  				     VFIO_DEVICE_STATE_RESUMING)
> @@ -1002,6 +1002,162 @@ struct vfio_device_feature {
>   */
>  #define VFIO_DEVICE_FEATURE_PCI_VF_TOKEN	(0)
>  
> +/*
> + * Indicates the device can support the migration API. See enum
> + * vfio_device_mig_state for details. If present flags must be non-zero and
> + * VFIO_DEVICE_MIG_SET_STATE is supported.
> + *
> + * VFIO_MIGRATION_STOP_COPY means that RUNNING, STOP, STOP_COPY and
> + * RESUMING are supported.
> + */
> +struct vfio_device_feature_migration {
> +	__aligned_u64 flags;
> +#define VFIO_MIGRATION_STOP_COPY	(1 << 0)
> +};
> +#define VFIO_DEVICE_FEATURE_MIGRATION 1
> +
> +/*
> + * The device migration Finite State Machine is described by the enum
> + * vfio_device_mig_state. Some of the FSM arcs will create a migration data
> + * transfer session by returning a FD, in this case the migration data will
> + * flow over the FD using read() and write() as discussed below.
> + *
> + * There are 5 states to support VFIO_MIGRATION_STOP_COPY:
> + *  RUNNING - The device is running normally
> + *  STOP - The device does not change the internal or external state
> + *  STOP_COPY - The device internal state can be read out
> + *  RESUMING - The device is stopped and is loading a new internal state
> + *  ERROR - The device has failed and must be reset
> + *
> + * The FSM takes actions on the arcs between FSM states. The driver implements
> + * the following behavior for the FSM arcs:
> + *
> + * RUNNING -> STOP
> + * STOP_COPY -> STOP
> + *   While in STOP the device must stop the operation of the device. The
> + *   device must not generate interrupts, DMA, or advance its internal
> + *   state. When stopped the device and kernel migration driver must accept
> + *   and respond to interaction to support external subsystems in the STOP
> + *   state, for example PCI MSI-X and PCI config pace. Failure by the user to
> + *   restrict device access while in STOP must not result in error conditions
> + *   outside the user context (ex. host system faults).
> + *
> + *   The STOP_COPY arc will terminate a data transfer session.
> + *
> + * RESUMING -> STOP
> + *   Leaving RESUMING terminates a data transfer session and indicates the
> + *   device should complete processing of the data delivered by write(). The
> + *   kernel migration driver should complete the incorporation of data written
> + *   to the data transfer FD into the device internal state and perform
> + *   final validity and consistency checking of the new device state. If the
> + *   user provided data is found to be incomplete, inconsistent, or otherwise
> + *   invalid, the migration driver must fail the SET_STATE ioctl and
> + *   optionally go to the ERROR state as described below.
> + *
> + *   While in STOP the device has the same behavior as other STOP states
> + *   described above.
> + *
> + *   To abort a RESUMING session the device must be reset.
> + *
> + * STOP -> RUNNING
> + *   While in RUNNING the device is fully operational, the device may generate
> + *   interrupts, DMA, respond to MMIO, all vfio device regions are functional,
> + *   and the device may advance its internal state.
> + *
> + * STOP -> STOP_COPY
> + *   This arc begin the process of saving the device state and will return a
> + *   new data_fd.
> + *
> + *   While in the STOP_COPY state the device has the same behavior as STOP
> + *   with the addition that the data transfers session continues to stream the
> + *   migration state. End of stream on the FD indicates the entire device
> + *   state has been transferred.
> + *
> + *   The user should take steps to restrict access to vfio device regions while
> + *   the device is in STOP_COPY or risk corruption of the device migration data
> + *   stream.
> + *
> + * STOP -> RESUMING
> + *   Entering the RESUMING state starts a process of restoring the device
> + *   state and will return a new data_fd. The data stream fed into the data_fd
> + *   should be taken from the data transfer output of the saving group states
> + *   from a compatible device. The migration driver may alter/reset the
> + *   internal device state for this arc if required to prepare the device to
> + *   receive the migration data.
> + *
> + * any -> ERROR
> + *   ERROR cannot be specified as a device state, however any transition request
> + *   can be failed with an errno return and may then move the device_state into
> + *   ERROR. In this case the device was unable to execute the requested arc and
> + *   was also unable to restore the device to any valid device_state. The ERROR
> + *   state will be returned as described below in VFIO_DEVICE_MIG_SET_STATE. To
> + *   recover from ERROR VFIO_DEVICE_RESET must be used to return the
> + *   device_state back to RUNNING.
> + *
> + * The remaining possible transitions are interpreted as combinations of the
> + * above FSM arcs. As there are multiple paths through the FSM arcs the path
> + * should be selected based on the following rules:
> + *   - Select the shortest path.
> + * Refer to vfio_mig_get_next_state() for the result of the algorithm.
> + *
> + * The automatic transit through the FSM arcs that make up the combination
> + * transition is invisible to the user. When working with combination arcs the
> + * user may see any step along the path in the device_state if SET_STATE
> + * fails. When handling these types of errors users should anticipate future
> + * revisions of this protocol using new states and those states becoming
> + * visible in this case.
> + */
> +enum vfio_device_mig_state {
> +	VFIO_DEVICE_STATE_ERROR = 0,
> +	VFIO_DEVICE_STATE_STOP = 1,
> +	VFIO_DEVICE_STATE_RUNNING = 2,
> +	VFIO_DEVICE_STATE_STOP_COPY = 3,
> +	VFIO_DEVICE_STATE_RESUMING = 4,
> +};
> +
> +/**
> + * VFIO_DEVICE_MIG_SET_STATE - _IO(VFIO_TYPE, VFIO_BASE + 21)
> + *
> + * Execute a migration state change command on the VFIO device. The new state is
> + * supplied in device_state.
> + *
> + * The kernel migration driver must fully transition the device to the new state
> + * value before the write(2) operation returns to the user.
> + *
> + * The kernel migration driver must not generate asynchronous device state
> + * transitions outside of manipulation by the user or the VFIO_DEVICE_RESET
> + * ioctl as described above.
> + *
> + * If this function fails and returns -1 then the device_state is updated with
> + * the current state the device is in. This may be the original operating state
> + * or some other state along the combination transition path. The user can then
> + * decide if it should execute a VFIO_DEVICE_RESET, attempt to return to the
> + * original state, or attempt to return to some other state such as RUNNING or
> + * STOP. If errno is set to EOPNOTSUPP, EFAULT or ENOTTY then the device_state
> + * output is not reliable.

I haven't made it through the full series yet, but it's not clear to me
why these specific errnos are being masked above.

> + *
> + * If the new_state starts a new data transfer session then the FD associated
> + * with that session is returned in data_fd. The user is responsible to close
> + * this FD when it is finished. The user must consider the migration data
> + * segments carried over the FD to be opaque and non-fungible. During RESUMING,
> + * the data segments must be written in the same order they came out of the
> + * saving side FD.

The lifecycle of this FD is a little sketchy.  The user is responsible
to close the FD, are they required to?  ie. should the migration driver
fail transitions if there's an outstanding FD?  Should the core code
mangle the f_ops or force and EOF or in some other way disconnect the FD
to avoid driver bugs/exploits with users poking stale FDs?  Should we
be bumping a reference on the device FD such that we can't have
outstanding migration FDs with the device closed (and re-assigned to a
new user)?

> + *
> + * Setting device_state to VFIO_DEVICE_STATE_ERROR will always fail with EINVAL,
> + * and take no action. However the device_state will be updated with the current
> + * value.
> + *
> + * Return: 0 on success, -1 and errno set on failure.
> + */
> +struct vfio_device_mig_set_state {
> +	__u32 argsz;
> +	__u32 device_state;
> +	__s32 data_fd;
> +	__u32 flags;
> +};

argsz and flags layout is inconsistent with all other vfio ioctls.

> +
> +#define VFIO_DEVICE_MIG_SET_STATE _IO(VFIO_TYPE, VFIO_BASE + 21)

Did you consider whether this could also be implemented as a
VFIO_DEVICE_FEATURE?  Seems the feature struct would just be
device_state and data_fd.  Perhaps there's a use case for GET as well.
Thanks,

Alex

