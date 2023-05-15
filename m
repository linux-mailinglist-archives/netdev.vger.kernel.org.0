Return-Path: <netdev+bounces-2488-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A8882702329
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 07:07:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5989A2810CB
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 05:07:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4D161C20;
	Mon, 15 May 2023 05:07:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929D010E6
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 05:07:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C07E56
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 22:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684127250;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QKZHvRmtbGrlB9TiMCKvV90xCw0G0VcCqDjdpolfJIA=;
	b=i5UzSEcOrznNga7+yqlUFdycfWex3Zvbl9UEI/xtBvUv5brNB3gQ+w+7HPPaRPh7p/NQtu
	43qjyo9H2nE0/P3nTXwvMVjag4dwlO9d42b46PUuE7CNtEAotb2w3ERx6IWRZe+Bi7D45h
	5HG/Anz+4AVG91MJpeQncebxl76dBPA=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-112-DwopKan_O8KcNEt_nRdLOg-1; Mon, 15 May 2023 01:07:29 -0400
X-MC-Unique: DwopKan_O8KcNEt_nRdLOg-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-4f3789c4a3cso1102508e87.2
        for <netdev@vger.kernel.org>; Sun, 14 May 2023 22:07:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684127248; x=1686719248;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QKZHvRmtbGrlB9TiMCKvV90xCw0G0VcCqDjdpolfJIA=;
        b=SaZCiaW/lXYEUKjGVCOwjTXCfgcG2vKdkYcOWVXVhwb2JBUtFFW6EgzJoIWF7ma3K8
         olZzr8VXXr1EQlL8OrmeImPa1Bo8FkpL+OYkAw4jASt2f13KH93W0/wl8ll0fsh41jcN
         hTt2EPzWJh6XKruvSxN4m/qK30kjobbAeN4D8J5XdK+PLT+gE0WjAe0kMDFeyXH2a0PN
         LzcgaRcNsfupYOQkKiCw8+c5rjEqFeLRJJ/PoBvwZVnARx7g4P7s/0KEWd6lILJhnHXE
         K1QJa1VApnGRHq7Z/l3Ldvve/3hTGCicXHW66u4IWi4uy9vSnV8xqwP0ys0NUAcg1upz
         8wdw==
X-Gm-Message-State: AC+VfDzRcd4Up6kuuA14ObQnfcHPChCw8ammH3RfjP8juzV4S68c9hma
	xtHF4FD3xptyQdoAXym5pcnUCjnmn+j8hn82eTo4Id1h9Pz19o3R68qaYL3axjeqR42i9pwkNIl
	1xiGmbICnqjqyG9om6foa6EyJ1iSGPfRs
X-Received: by 2002:ac2:4a7a:0:b0:4ed:d250:1604 with SMTP id q26-20020ac24a7a000000b004edd2501604mr5617083lfp.57.1684127248004;
        Sun, 14 May 2023 22:07:28 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5A2Jta/mMxoVzPA48qfPIiuZGYiwTSTn2WlbiarOl+yGNcnMsPx90fz4OXORRJSsuaiKkvKSG2Cxlt63sNtHs=
X-Received: by 2002:ac2:4a7a:0:b0:4ed:d250:1604 with SMTP id
 q26-20020ac24a7a000000b004edd2501604mr5617071lfp.57.1684127247680; Sun, 14
 May 2023 22:07:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230503181240.14009-1-shannon.nelson@amd.com> <20230503181240.14009-12-shannon.nelson@amd.com>
In-Reply-To: <20230503181240.14009-12-shannon.nelson@amd.com>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 15 May 2023 13:07:16 +0800
Message-ID: <CACGkMEvxzRuW2i=3=wv=B7J8UfytxwRoA3SJRexuOgLzJtmZ3Q@mail.gmail.com>
Subject: Re: [PATCH v5 virtio 11/11] pds_vdpa: pds_vdps.rst and Kconfig
To: Shannon Nelson <shannon.nelson@amd.com>
Cc: mst@redhat.com, virtualization@lists.linux-foundation.org, 
	brett.creeley@amd.com, netdev@vger.kernel.org, simon.horman@corigine.com, 
	drivers@pensando.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 4, 2023 at 2:13=E2=80=AFAM Shannon Nelson <shannon.nelson@amd.c=
om> wrote:
>
> Add the documentation and Kconfig entry for pds_vdpa driver.
>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  .../device_drivers/ethernet/amd/pds_vdpa.rst  | 85 +++++++++++++++++++
>  .../device_drivers/ethernet/index.rst         |  1 +
>  MAINTAINERS                                   |  4 +
>  drivers/vdpa/Kconfig                          |  8 ++
>  4 files changed, 98 insertions(+)
>  create mode 100644 Documentation/networking/device_drivers/ethernet/amd/=
pds_vdpa.rst
>
> diff --git a/Documentation/networking/device_drivers/ethernet/amd/pds_vdp=
a.rst b/Documentation/networking/device_drivers/ethernet/amd/pds_vdpa.rst
> new file mode 100644
> index 000000000000..587927d3de92
> --- /dev/null
> +++ b/Documentation/networking/device_drivers/ethernet/amd/pds_vdpa.rst
> @@ -0,0 +1,85 @@
> +.. SPDX-License-Identifier: GPL-2.0+
> +.. note: can be edited and viewed with /usr/bin/formiko-vim
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +PCI vDPA driver for the AMD/Pensando(R) DSC adapter family
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +AMD/Pensando vDPA VF Device Driver
> +
> +Copyright(c) 2023 Advanced Micro Devices, Inc
> +
> +Overview
> +=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +The ``pds_vdpa`` driver is an auxiliary bus driver that supplies
> +a vDPA device for use by the virtio network stack.  It is used with
> +the Pensando Virtual Function devices that offer vDPA and virtio queue
> +services.  It depends on the ``pds_core`` driver and hardware for the PF
> +and VF PCI handling as well as for device configuration services.
> +
> +Using the device
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +The ``pds_vdpa`` device is enabled via multiple configuration steps and
> +depends on the ``pds_core`` driver to create and enable SR-IOV Virtual
> +Function devices.  After the VFs are enabled, we enable the vDPA service
> +in the ``pds_core`` device to create the auxiliary devices used by pds_v=
dpa.
> +
> +Example steps:
> +
> +.. code-block:: bash
> +
> +  #!/bin/bash
> +
> +  modprobe pds_core
> +  modprobe vdpa
> +  modprobe pds_vdpa
> +
> +  PF_BDF=3D`ls /sys/module/pds_core/drivers/pci\:pds_core/*/sriov_numvfs=
 | awk -F / '{print $7}'`
> +
> +  # Enable vDPA VF auxiliary device(s) in the PF
> +  devlink dev param set pci/$PF_BDF name enable_vnet cmode runtime value=
 true
> +
> +  # Create a VF for vDPA use
> +  echo 1 > /sys/bus/pci/drivers/pds_core/$PF_BDF/sriov_numvfs
> +
> +  # Find the vDPA services/devices available
> +  PDS_VDPA_MGMT=3D`vdpa mgmtdev show | grep vDPA | head -1 | cut -d: -f1=
`
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
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +The driver is enabled via the standard kernel configuration system,
> +using the make command::
> +
> +  make oldconfig/menuconfig/etc.
> +
> +The driver is located in the menu structure at:
> +
> +  -> Device Drivers
> +    -> Network device support (NETDEVICES [=3Dy])
> +      -> Ethernet driver support
> +        -> Pensando devices
> +          -> Pensando Ethernet PDS_VDPA Support
> +
> +Support
> +=3D=3D=3D=3D=3D=3D=3D
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
> diff --git a/Documentation/networking/device_drivers/ethernet/index.rst b=
/Documentation/networking/device_drivers/ethernet/index.rst
> index 417ca514a4d0..94ecb67c0885 100644
> --- a/Documentation/networking/device_drivers/ethernet/index.rst
> +++ b/Documentation/networking/device_drivers/ethernet/index.rst
> @@ -15,6 +15,7 @@ Contents:
>     amazon/ena
>     altera/altera_tse
>     amd/pds_core
> +   amd/pds_vdpa
>     aquantia/atlantic
>     chelsio/cxgb
>     cirrus/cs89x0
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ebd26b3ca90e..c565b71ce56f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22200,6 +22200,10 @@ SNET DPU VIRTIO DATA PATH ACCELERATOR
>  R:     Alvaro Karsz <alvaro.karsz@solid-run.com>
>  F:     drivers/vdpa/solidrun/
>
> +PDS DSC VIRTIO DATA PATH ACCELERATOR
> +R:     Shannon Nelson <shannon.nelson@amd.com>
> +F:     drivers/vdpa/pds/
> +
>  VIRTIO BALLOON
>  M:     "Michael S. Tsirkin" <mst@redhat.com>
>  M:     David Hildenbrand <david@redhat.com>
> diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
> index cd6ad92f3f05..2ee1b288691d 100644
> --- a/drivers/vdpa/Kconfig
> +++ b/drivers/vdpa/Kconfig
> @@ -116,4 +116,12 @@ config ALIBABA_ENI_VDPA
>           This driver includes a HW monitor device that
>           reads health values from the DPU.
>
> +config PDS_VDPA
> +       tristate "vDPA driver for AMD/Pensando DSC devices"
> +       depends on PDS_CORE

Need to select VIRTIO_PCI_LIB?

Thanks

> +       help
> +         vDPA network driver for AMD/Pensando's PDS Core devices.
> +         With this driver, the VirtIO dataplane can be
> +         offloaded to an AMD/Pensando DSC device.
> +
>  endif # VDPA
> --
> 2.17.1
>


