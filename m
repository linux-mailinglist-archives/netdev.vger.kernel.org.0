Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E76956B35FA
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 06:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjCJFL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 00:11:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbjCJFKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 00:10:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003AC108211
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 21:09:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678424955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gooWS3hDuOnEfIrQXNJibPdBu4nf3TG1tpeCDx4EWgk=;
        b=aLjiBYuAuO2fdQsAZwgajc1VeOk+FJp9oBPrqIKMDwzeOQJ+1UlHhobBU1Qw0A1e8NRdms
        jaD132yAT2pe6/qdh7h2B1X1o27nBElaykl/uy/mI7m+ZpAC+MUL2nhEUGq8plzZoyXCPn
        5SF+vgfRSLZTw/Y3x59k9m+RFSeaSbw=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-435-ueb8p2XqNEm18-yS4UiIsA-1; Fri, 10 Mar 2023 00:09:13 -0500
X-MC-Unique: ueb8p2XqNEm18-yS4UiIsA-1
Received: by mail-ot1-f71.google.com with SMTP id w27-20020a056830411b00b0069411644fc5so1887438ott.14
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 21:09:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678424953;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gooWS3hDuOnEfIrQXNJibPdBu4nf3TG1tpeCDx4EWgk=;
        b=OtJVSM0MXIb/KQRZID1e+xcUvICetsM6S1LF09hYhHcxlU/63+XxOUaW/5gyxGOhqQ
         N2CarZxsrGnx/gS5qX0uyTwF+dMg8S/C/mR6uAanxMlJfBb1OCYo5ZDmScoszqu5RNH9
         OJACPDkNLqtf5J2R8EmjSac7HUlbcekNAczaYukuFLuDtej/GRg2CdBPv5VEeFmzp8vX
         9H5Jevc2oKzJ6z4SAXXEFCdtiW1uBlEtBl29VvyvfgmeE7PRCGG51XReT9v1MGYqPYP5
         054EA3LO/+szCZiIYhfyq4oMO95bjo5GDqoe9C+o6Hz3fd6NZrCYhAlDqfw38iT9dobk
         igcQ==
X-Gm-Message-State: AO0yUKV8dls5xhmqzBNOQ3oEIzQIRjOwE7cONHJc6JQjjdHDOUEgaAPG
        TfUZ+CDoMXlXqfeoa314vklMT5/3yUb3wAZOYwX/iI8U6X7hK2hP7TGN8R6F3KqZjFYes6B69rD
        8v3t/lLaC/WZcQNgH/gb0qwmgsyrLkXM+
X-Received: by 2002:aca:1708:0:b0:37f:9a01:f661 with SMTP id j8-20020aca1708000000b0037f9a01f661mr7186457oii.9.1678424953078;
        Thu, 09 Mar 2023 21:09:13 -0800 (PST)
X-Google-Smtp-Source: AK7set+QLR0bzVbr/SxEPiBKHjENzlaLwQ9WuXtHOZKZs1790dS8nexDfLdkP7erkZNnQJMfjpkoOWhFRu0+O1c9DLo=
X-Received: by 2002:aca:1708:0:b0:37f:9a01:f661 with SMTP id
 j8-20020aca1708000000b0037f9a01f661mr7186441oii.9.1678424952854; Thu, 09 Mar
 2023 21:09:12 -0800 (PST)
MIME-Version: 1.0
References: <20230307113621.64153-1-gautam.dawar@amd.com>
In-Reply-To: <20230307113621.64153-1-gautam.dawar@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 10 Mar 2023 13:09:01 +0800
Message-ID: <CACGkMEtDqQJDQ5wRbU0xObi1hiTbaQ3K2Tfq36ZYXCW8BcphYA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 00/14] sfc: add vDPA support for EF100 devices
To:     Gautam Dawar <gautam.dawar@amd.com>
Cc:     linux-net-drivers@amd.com, Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 7, 2023 at 7:36=E2=80=AFPM Gautam Dawar <gautam.dawar@amd.com> =
wrote:
>
> Hi All,
>
> This series adds the vdpa support for EF100 devices.

Would you mind posting some performance numbers for this device?

Thanks

> For now, only a network class of vdpa device is supported and
> they can be created only on a VF. Each EF100 VF can have one
> of the three function personalities (EF100, vDPA & None) at
> any time with EF100 being the default. A VF's function personality
> is changed to vDPA while creating the vdpa device using vdpa tool.
>
> A vDPA management device is created per VF to allow selection of
> the desired VF for vDPA device creation. The MAC address for the
> target net device must be set either by specifying at the vdpa
> device creation time via the `mac` parameter of the `vdpa dev add`
> command or should be specified as the hardware address of the virtual
> function using `devlink port function set hw_addr` command before
> creating the vdpa device with the former taking precedence.
>
> Changes since v1:
>
> - To ensure isolation between DMA initiated by userspace (guest OS)
>   and the host MCDI buffer, ummap VF's MCDI DMA buffer and use PF's
>   IOMMU domain instead for executing vDPA VF's MCDI commands.
> - As a result of above change, it is no more necessary to check for
>   MCDI buffer's IOVA range overlap with the guest buffers. Accordingly,
>   the DMA config operations and the rbtree/list implementation to store
>   IOVA mappings have been dropped.
> - Support vDPA only if running Firmware supports CLIENT_CMD_VF_PROXY
>   capability.
> - Added .suspend config operation and updated get_vq_state/set_vq_state
>   to support Live Migration. Also, features VIRTIO_F_ORDER_PLATFORM and
>   VIRTIO_F_IN_ORDER have been masked off in get_device_features() to
>   allow Live Migration as QEMU SVQ doesn't support them yet.
> - Removed the minimum version (v6.1.0) requirement of QEMU as
>   VIRTIO_F_IN_ORDER is not exposed
> - Fetch the vdpa device MAC address from the underlying VF hw_addr (if
>   set via `devlink port function set hw_addr` command)
> - Removed the mandatory requirement of specifying mac address while
>   creating vdpa device
> - Moved create_vring_ctx() and get_doorbell_offset() in dev_add()
> - Moved IRQ allocation at the time of vring creation
> - Merged vring_created member of struct ef100_vdpa_vring_info as one
>   of the flags in vring_state
> - Simplified .set_status() implementation
> - Removed un-necessary vdpa_state checks against
>   EF100_VDPA_STATE_INITIALIZED
> - Removed userspace triggerable warning in kick_vq()
> - Updated year 2023 in copyright banner of new files
>
> Gautam Dawar (14):
>   sfc: add function personality support for EF100 devices
>   sfc: implement MCDI interface for vDPA operations
>   sfc: update MCDI headers for CLIENT_CMD_VF_PROXY capability bit
>   sfc: evaluate vdpa support based on FW capability CLIENT_CMD_VF_PROXY
>   sfc: implement init and fini functions for vDPA personality
>   sfc: implement vDPA management device operations
>   sfc: implement vdpa device config operations
>   sfc: implement vdpa vring config operations
>   sfc: implement device status related vdpa config operations
>   sfc: implement filters for receiving traffic
>   sfc: use PF's IOMMU domain for running VF's MCDI commands
>   sfc: unmap VF's MCDI buffer when switching to vDPA mode
>   sfc: update vdpa device MAC address
>   sfc: register the vDPA device
>
>  drivers/net/ethernet/sfc/Kconfig          |    8 +
>  drivers/net/ethernet/sfc/Makefile         |    1 +
>  drivers/net/ethernet/sfc/ef10.c           |    2 +-
>  drivers/net/ethernet/sfc/ef100.c          |    7 +-
>  drivers/net/ethernet/sfc/ef100_netdev.c   |   26 +-
>  drivers/net/ethernet/sfc/ef100_nic.c      |  183 +-
>  drivers/net/ethernet/sfc/ef100_nic.h      |   26 +-
>  drivers/net/ethernet/sfc/ef100_vdpa.c     |  543 +++
>  drivers/net/ethernet/sfc/ef100_vdpa.h     |  224 ++
>  drivers/net/ethernet/sfc/ef100_vdpa_ops.c |  793 ++++
>  drivers/net/ethernet/sfc/mcdi.c           |  108 +-
>  drivers/net/ethernet/sfc/mcdi.h           |    9 +-
>  drivers/net/ethernet/sfc/mcdi_filters.c   |   51 +-
>  drivers/net/ethernet/sfc/mcdi_functions.c |    9 +-
>  drivers/net/ethernet/sfc/mcdi_functions.h |    3 +-
>  drivers/net/ethernet/sfc/mcdi_pcol.h      | 4390 ++++++++++++++++++++-
>  drivers/net/ethernet/sfc/mcdi_vdpa.c      |  259 ++
>  drivers/net/ethernet/sfc/mcdi_vdpa.h      |   83 +
>  drivers/net/ethernet/sfc/net_driver.h     |   21 +
>  drivers/net/ethernet/sfc/ptp.c            |    4 +-
>  20 files changed, 6574 insertions(+), 176 deletions(-)
>  create mode 100644 drivers/net/ethernet/sfc/ef100_vdpa.c
>  create mode 100644 drivers/net/ethernet/sfc/ef100_vdpa.h
>  create mode 100644 drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>  create mode 100644 drivers/net/ethernet/sfc/mcdi_vdpa.c
>  create mode 100644 drivers/net/ethernet/sfc/mcdi_vdpa.h
>
> --
> 2.30.1
>

