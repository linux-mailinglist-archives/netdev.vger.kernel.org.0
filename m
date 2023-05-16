Return-Path: <netdev+bounces-2841-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 596CC7043F1
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 05:30:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DEC56281016
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 03:30:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D94472568;
	Tue, 16 May 2023 03:30:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B9123BD
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 03:30:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2534B49E0
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 20:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684207808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fyyXDgBCIDdmCinicR4vCNg8vFj4fP6c+Ugcp/1OuMg=;
	b=Db+M6leNfnBG3hTPb78jCSacYSVN+I6qEQGLXGzFMTxag1KjHDuQHyzs8TYa/tBBMdcSCu
	zIqG/gAR1K3x2A18TwmSDE8OO6RBaD0bFjNT1uCmKRS49Wj259fG+8qET45abunIjnw8sy
	oEg6G/XjcPPc3epWcY3/n9O1ldG8ZpE=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-272-3WDEJxqiP9ebYCSwNoX_aw-1; Mon, 15 May 2023 23:30:06 -0400
X-MC-Unique: 3WDEJxqiP9ebYCSwNoX_aw-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-4f38f48be8bso54231e87.2
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 20:30:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684207805; x=1686799805;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fyyXDgBCIDdmCinicR4vCNg8vFj4fP6c+Ugcp/1OuMg=;
        b=Y7+RuvEMpylUQwT3o3U+lwrDHByCbEBJetSIBSvNraCg40+UIoFBprkSJRIw1Tz/c5
         gcKhhcTPf2Ex4/ReUABo5+8hmcgkNDZHuGyYV1Pe10ECl4KESJCz/9SQC10lh0rC5zAA
         C9OozDbfDW1N0gY3eO7pzoxahjcjD+PTrea6T4tqnWcDReD3teq+uK4PWHmzt+p33XON
         BcDs13dQSGNWX1RKqZwcv+YdZCx2XSc6zTlX9Shjncc7Acp8j2Hkl+G+/tBDZghDapMu
         HnisD3ZRRp9vG4VvHl/KZLculMGeIlgpnTVRDxInhK4ktB+nR21oXqixPLkSvJugQYcH
         mH8A==
X-Gm-Message-State: AC+VfDxtxCT5xWqqrEGX729LH9VKAA/rkDSEtwvnOUweyEBTUw/tblIN
	pHdjmNa25GgBv/bu3FYRb8Mm89pq3MV/4R04RP6BYfMyZ+WTcl9tFk4ScOdsMKyxrROzmw6XNi7
	FiD6Em24owlQvHela26YKI3xSrxMJwKht
X-Received: by 2002:ac2:528c:0:b0:4eb:52c8:5ce0 with SMTP id q12-20020ac2528c000000b004eb52c85ce0mr6736951lfm.12.1684207805477;
        Mon, 15 May 2023 20:30:05 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6MK3Mi3Admnfq4O5YdXSIZMlnVO14BWtTmfpBzZHlr343EDVaSKWGF63IvhAluNvegcpthIQ8iwH26hf//+qk=
X-Received: by 2002:ac2:528c:0:b0:4eb:52c8:5ce0 with SMTP id
 q12-20020ac2528c000000b004eb52c85ce0mr6736947lfm.12.1684207805185; Mon, 15
 May 2023 20:30:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230516025521.43352-1-shannon.nelson@amd.com> <20230516025521.43352-12-shannon.nelson@amd.com>
In-Reply-To: <20230516025521.43352-12-shannon.nelson@amd.com>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 16 May 2023 11:29:54 +0800
Message-ID: <CACGkMEtFKSSFOAmoHJZE+0ZotR=GOA3y4sf8YbjJ=vR1rvyEBg@mail.gmail.com>
Subject: Re: [PATCH v6 virtio 11/11] pds_vdpa: pds_vdps.rst and Kconfig
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

On Tue, May 16, 2023 at 10:56=E2=80=AFAM Shannon Nelson <shannon.nelson@amd=
.com> wrote:
>
> Add the documentation and Kconfig entry for pds_vdpa driver.
>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  .../device_drivers/ethernet/amd/pds_vdpa.rst  | 85 +++++++++++++++++++
>  .../device_drivers/ethernet/index.rst         |  1 +
>  MAINTAINERS                                   |  4 +
>  drivers/vdpa/Kconfig                          | 10 +++
>  4 files changed, 100 insertions(+)
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
> index e2fd64c2ebdc..c3f509eeaf1d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22296,6 +22296,10 @@ F:     include/linux/vringh.h
>  F:     include/uapi/linux/virtio_*.h
>  F:     tools/virtio/
>
> +PDS DSC VIRTIO DATA PATH ACCELERATOR
> +R:     Shannon Nelson <shannon.nelson@amd.com>
> +F:     drivers/vdpa/pds/
> +
>  VIRTIO CRYPTO DRIVER
>  M:     Gonglei <arei.gonglei@huawei.com>
>  L:     virtualization@lists.linux-foundation.org
> diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
> index cd6ad92f3f05..656c1cb541de 100644
> --- a/drivers/vdpa/Kconfig
> +++ b/drivers/vdpa/Kconfig
> @@ -116,4 +116,14 @@ config ALIBABA_ENI_VDPA
>           This driver includes a HW monitor device that
>           reads health values from the DPU.
>
> +config PDS_VDPA
> +       tristate "vDPA driver for AMD/Pensando DSC devices"
> +       select VIRTIO_PCI_LIB
> +       depends on PCI_MSI
> +       depends on PDS_CORE
> +       help
> +         vDPA network driver for AMD/Pensando's PDS Core devices.
> +         With this driver, the VirtIO dataplane can be
> +         offloaded to an AMD/Pensando DSC device.
> +
>  endif # VDPA
> --
> 2.17.1
>


