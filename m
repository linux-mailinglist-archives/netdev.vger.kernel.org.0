Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6C1F633562
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 07:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbiKVGg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 01:36:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiKVGg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 01:36:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA76BF64
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 22:35:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669098932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZM4Milkw2zAcnxczOyM+6GmizWf8KILpVjHb60djrcY=;
        b=L+1WlU0LkFrEYzOCaxcr057Mn6T+q4QG0UYeDG6YhSFXef4GXkE3ZXz6rBK9tP2qtwVtFq
        qNyW8ZQWnOI66rFZNnE5LYDYIszE8xYRdWEAmu7hCRAf8b1WYNxQayu2Caf+SZL89p+5Mi
        r9kLIlQ0MgDz556TKbO0ooqV32eTZhY=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-46-8iPp5-lHP0e3Z8EMc6vqeQ-1; Tue, 22 Nov 2022 01:35:28 -0500
X-MC-Unique: 8iPp5-lHP0e3Z8EMc6vqeQ-1
Received: by mail-oo1-f71.google.com with SMTP id g1-20020a4a9241000000b0049fd16671b4so3827374ooh.14
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 22:35:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZM4Milkw2zAcnxczOyM+6GmizWf8KILpVjHb60djrcY=;
        b=UVgOMlXFR2NaMXmEi8Csv/rN/qxKoChmu/Is7hk7ySBBLMZdw9EM2CG+w78ZWJpfcn
         XwCK8qbl7np9LT5OgN7FWldtxNOOmAPhumYETB8l5horcY/vnsU4evm9ElD3+m9/wXZq
         gwNMjT1GccPOwM0YUresiTZ/QDFvd7pFNM3vHUuce3B2LKJvqV4hTUsfoDi/K2TZvv9m
         k6xtLJ6/JU8xpYX0LJv2EE2b16L1r8N+z/5unlPTziuCm2pqKiknTsJXsfvlIJ/RI75p
         +jJnkJ7AyRH5ZKQdYw9tcvJVZELgn617TVWjmt3hDzKj8nvUWzBd3WZFL2dl7aIUZlIP
         Kjpg==
X-Gm-Message-State: ANoB5plsYMj3ESfw/LXUzXX7J/eswtrRLvY01RS1d18vm/CKhJdXMee0
        RCx9MSh0UZPGRW2q4Q/k2B9j2hrAW4tEAncpSk+3ht7hTkCizNhP++qqJhO4VM+aVMb4gNvYAD7
        YenyG1zOy32owKTdTDGuJ+HmlBjr074cu
X-Received: by 2002:a05:6870:75c3:b0:142:f59e:e509 with SMTP id de3-20020a05687075c300b00142f59ee509mr3253194oab.280.1669098927224;
        Mon, 21 Nov 2022 22:35:27 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6vSg7F+y2vJHrbB6OsZgWmO5m4FP8axc6WoQaZbYtPI7DfnvYv58geqUmrZr8Mjawq2/0avBZF87pMlvGQuGg=
X-Received: by 2002:a05:6870:75c3:b0:142:f59e:e509 with SMTP id
 de3-20020a05687075c300b00142f59ee509mr3253181oab.280.1669098927012; Mon, 21
 Nov 2022 22:35:27 -0800 (PST)
MIME-Version: 1.0
References: <20221118225656.48309-1-snelson@pensando.io> <20221118225656.48309-20-snelson@pensando.io>
In-Reply-To: <20221118225656.48309-20-snelson@pensando.io>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 22 Nov 2022 14:35:16 +0800
Message-ID: <CACGkMEsGnmMCPrLv=mRviOung4N0F8pvYaGsuKMCky58S3uq2g@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 19/19] pds_vdpa: add Kconfig entry and pds_vdpa.rst
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mst@redhat.com, virtualization@lists.linux-foundation.org,
        drivers@pensando.io
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 19, 2022 at 6:57 AM Shannon Nelson <snelson@pensando.io> wrote:
>
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
>  .../ethernet/pensando/pds_vdpa.rst            | 85 +++++++++++++++++++
>  MAINTAINERS                                   |  1 +
>  drivers/vdpa/Kconfig                          |  7 ++
>  3 files changed, 93 insertions(+)
>  create mode 100644 Documentation/networking/device_drivers/ethernet/pensando/pds_vdpa.rst
>
> diff --git a/Documentation/networking/device_drivers/ethernet/pensando/pds_vdpa.rst b/Documentation/networking/device_drivers/ethernet/pensando/pds_vdpa.rst
> new file mode 100644
> index 000000000000..c517f337d212
> --- /dev/null
> +++ b/Documentation/networking/device_drivers/ethernet/pensando/pds_vdpa.rst
> @@ -0,0 +1,85 @@
> +.. SPDX-License-Identifier: GPL-2.0+
> +.. note: can be edited and viewed with /usr/bin/formiko-vim
> +
> +==========================================================
> +PCI vDPA driver for the Pensando(R) DSC adapter family
> +==========================================================
> +
> +Pensando vDPA VF Device Driver
> +Copyright(c) 2022 Pensando Systems, Inc
> +
> +Overview
> +========
> +
> +The ``pds_vdpa`` driver is a PCI and auxiliary bus driver and supplies
> +a vDPA device for use by the virtio network stack.  It is used with
> +the Pensando Virtual Function devices that offer vDPA and virtio queue
> +services.  It depends on the ``pds_core`` driver and hardware for the PF
> +and for device configuration services.
> +
> +Using the device
> +================
> +
> +The ``pds_vdpa`` device is enabled via multiple configuration steps and
> +depends on the ``pds_core`` driver to create and enable SR-IOV Virtual
> +Function devices.
> +
> +Shown below are the steps to bind the driver to a VF and also to the
> +associated auxiliary device created by the ``pds_core`` driver. This
> +example assumes the pds_core and pds_vdpa modules are already
> +loaded.
> +
> +.. code-block:: bash
> +
> +  #!/bin/bash
> +
> +  modprobe pds_core
> +  modprobe pds_vdpa
> +
> +  PF_BDF=`grep "vDPA.*1" /sys/kernel/debug/pds_core/*/viftypes | head -1 | awk -F / '{print $6}'`
> +
> +  # Enable vDPA VF auxiliary device(s) in the PF
> +  devlink dev param set pci/$PF_BDF name enable_vnet value true cmode runtime
> +
> +  # Create a VF for vDPA use
> +  echo 1 > /sys/bus/pci/drivers/pds_core/$PF_BDF/sriov_numvfs
> +
> +  # Find the vDPA services/devices available
> +  PDS_VDPA_MGMT=`vdpa mgmtdev show | grep vDPA | head -1 | cut -d: -f1`
> +
> +  # Create a vDPA device for use in virtio network configurations
> +  vdpa dev add name vdpa1 mgmtdev $PDS_VDPA_MGMT mac 00:11:22:33:44:55
> +
> +  # Set up an ethernet interface on the vdpa device
> +  modprobe virtio_vdpa
> +
> +
> +
> +Enabling the driver
> +===================
> +
> +The driver is enabled via the standard kernel configuration system,
> +using the make command::
> +
> +  make oldconfig/menuconfig/etc.
> +
> +The driver is located in the menu structure at:
> +
> +  -> Device Drivers
> +    -> Network device support (NETDEVICES [=y])
> +      -> Ethernet driver support
> +        -> Pensando devices
> +          -> Pensando Ethernet PDS_VDPA Support
> +
> +Support
> +=======
> +
> +For general Linux networking support, please use the netdev mailing
> +list, which is monitored by Pensando personnel::
> +
> +  netdev@vger.kernel.org
> +
> +For more specific support needs, please use the Pensando driver support
> +email::
> +
> +  drivers@pensando.io
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a4f989fa8192..a4d96e854757 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16152,6 +16152,7 @@ L:      netdev@vger.kernel.org
>  S:     Supported
>  F:     Documentation/networking/device_drivers/ethernet/pensando/
>  F:     drivers/net/ethernet/pensando/
> +F:     drivers/vdpa/pds/
>  F:     include/linux/pds/
>
>  PER-CPU MEMORY ALLOCATOR
> diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
> index 50f45d037611..1c44df18f3da 100644
> --- a/drivers/vdpa/Kconfig
> +++ b/drivers/vdpa/Kconfig
> @@ -86,4 +86,11 @@ config ALIBABA_ENI_VDPA
>           VDPA driver for Alibaba ENI (Elastic Network Interface) which is built upon
>           virtio 0.9.5 specification.
>
> +config PDS_VDPA
> +       tristate "vDPA driver for Pensando DSC devices"
> +       select VHOST_RING

Any reason it needs to select on vringh?

Thanks

> +       depends on PDS_CORE
> +       help
> +         VDPA network driver for Pensando's PDS Core devices.
> +
>  endif # VDPA
> --
> 2.17.1
>

