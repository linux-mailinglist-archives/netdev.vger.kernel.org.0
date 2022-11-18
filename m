Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77F146302A6
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 00:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbiKRXNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 18:13:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235327AbiKRXMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 18:12:48 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02597C5B64
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:34 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id b1-20020a17090a7ac100b00213fde52d49so6377390pjl.3
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zFMi2feoJ+RjaE0j445FQO60hHdYEFLFsIY5S9hkY6M=;
        b=3TGMLuLqFBp/YauyGyuqd/XIJzMHwZZonb1clqglhfchFRGjGYTtuPNe2iyj1IcTfd
         tUKKoDfkRgQjzlU59xfAc+Cw60f5fwtvVqNXimDICWscQBEN6qK+/7jWhgBQ19BEqRAJ
         51+1+2cIprzwsuEZXeo9BmRVDxYBmfENyrjYnrnyVL2jL65XGt+hPpb2obgjHyqUL+6n
         9F8m+/P3Gw4/Qje47BhcuXmeyqZw5l4BYFHh+HRicaJ0tY1peMcdvhK0pSc++13L4Xzo
         wdBSBYItuuaTJrf+hmpWJefQ4rQBK7HDd4ZHejzLY0lkGcbpbMo2jeBYGYkC7BQ8bDGv
         Qs9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zFMi2feoJ+RjaE0j445FQO60hHdYEFLFsIY5S9hkY6M=;
        b=xzbfFiyh0ZCazve3NQOJag6OE7f2BYo16STKA3G1k1qxcBMvhdv9SwVT6AE4Hrsfa1
         /Ny3LSOvgWp51IPiVFaW9uksQzFOCFeVguu3BVWYcuyMCb2fAr8jZ11IzdcgmFQBVWZ0
         De6udycSIH9oqLuhsDGhNp7raEn6JISW5TvrdQ3jlni+Y/Crz9zTILgSzwC/6ISUqKiN
         XlY3rYxbzGSFLLCbK7QIYaM0tP5HN2sopELbs23PRYcYWzWHDLPD2CicuVKGXtryBxdF
         s6ZXUrnvxlmhQgz4Xv7IZRBYRJaI6iswKa9FbHDmnbDmaAw224vGNovfzqAuEQnDvYEU
         xWxQ==
X-Gm-Message-State: ANoB5pkG/Hw1FC+I0czQ8YG90MlOe9j52jaw1HP6+cc++wx0uwqa613H
        2jty6cme707WEqmwlJ70PRAp/Nt4eAhijg==
X-Google-Smtp-Source: AA0mqf4DXXKX7Xfiz4VxdocJ9x9eXDb8KqlZhKysSTNekQk9E0k+vq9G6BsXOn78Yejy+Qrtp16ckA==
X-Received: by 2002:a17:90a:6f47:b0:218:910a:124b with SMTP id d65-20020a17090a6f4700b00218910a124bmr2570231pjk.16.1668812231971;
        Fri, 18 Nov 2022 14:57:11 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id k89-20020a17090a3ee200b002005fcd2cb4sm6004818pjc.2.2022.11.18.14.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 14:57:11 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [RFC PATCH net-next 00/19] pds core and vdpa drivers
Date:   Fri, 18 Nov 2022 14:56:37 -0800
Message-Id: <20221118225656.48309-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Summary:
--------
This is a first draft patchset of a pair of new drivers for use with
the AMD/Pensando Distributed Services Card (DSC), intended to work along
side the existing ionic Ethernet driver to provide support of devices
for better virtualization support.  These drivers work together using
the auxiliary_bus for client drivers (pds_vdpa) to use the core
configuration services (pds_core).

This large patchset is both drivers combined in order to give a full
RFC view and can be split into separate pds_core and pds_vdpa patchsets
in the future.


Detail:
-------
AMD/Pensando is making available a new set of devices for supporting vDPA,
VFio, and potentially other features in the Distributed Services Card
(DSC).  These features are implemented through a PF that serves as a Core
device for controlling and configuring its VF devices.  These VF devices
have separate drivers that use the auxiliary_bus to work through the Core
device as the control path.

Currently, the DSC supports standard ethernet operations using the
ionic driver.  This is not replaced by the Core-based devices - these
new devices are in addition to the existing Ethernet device.  Typical DSC
configurations will include both PDS devices and Ionic Eth devices.

The Core device is a new PCI PF device managed by a new driver 'pds_core'.
It sets up a small representer netdev for managing the associated VFs,
and sets up auxiliary_bus devices for each VF for communicating with
the drivers for the VF devices.  The VFs may be for VFio/NVMe or vDPA,
and other services in the future; these VF types are selected as part
of the DSC internal FW configurations, which is out of the scope of
this patchset.  The Core device sets up devlink parameters for enabling
available feature sets.

Once a feature set is enabled, auxiliary_bus devices are created for each
VF that supports the feature.  These auxiliary_bus devices are named by
their feature plus VF PCI bdf so the auxiliary device driver can find
its related VF PCI driver instance.  The VF's driver then connects to
and uses this auxiliary_device to do control path configuration of the
feature through the PF device.

A cheap ASCII diagram of vDPA instance looks something like this and can
then be used with the vdpa kernel module to provide devices for virtio_vdpa
kernel module for host interfaces, vhost_vdpa kernel module for interfaces
exported into your favorite VM.


                                  ,----------.
                                  |   vdpa   |
                                  '----------'
                                       |
                                     vdpa_dev
                                    ctl   data
                                     |     ||
           pds_core.vDPA.2305 <---+  |     ||
                   |              |  |     ||
       netdev      |              |  |     ||
          |        |              |  |     ||
         .------------.         .------------.
         |  pds_core  |         |  pds_vdpa  |
         '------------'         '------------'
               ||                     ||
	     09:00.0                09:00.1
== PCI =========================================================
               ||                     ||
          .----------.           .----------.
    ,-----|    PF    |-----------|    VF    |-------,
    |     '----------'           -----------'       |
    |                     DSC                       |
    |                                               |
    -------------------------------------------------


The pds_core driver is targeted to reside in
drivers/net/ethernet/pensando/pds_core and the pds_vdpa driver lands
in drivers/vdpa/pds.  There are some shared include files placed in
include/linux/pds, which seemed reasonable at the time, but I've recently
seen suggestions of putting files like this under include/net instead,
so that may be up for some discussion.

I appreciate any and all time folks can spend reviewing and commenting.

Thanks,
sln

Shannon Nelson (19):
  pds_core: initial framework for pds_core driver
  pds_core: add devcmd device interfaces
  pds_core: health timer and workqueue
  pds_core: set up device and adminq
  pds_core: Add adminq processing and commands
  pds_core: add FW update feature to devlink
  pds_core: set up the VIF definitions and defaults
  pds_core: initial VF configuration
  pds_core: add auxiliary_bus devices
  pds_core: devlink params for enabling VIF support
  pds_core: add the aux client API
  pds_core: publish events to the clients
  pds_core: Kconfig and pds_core.rst
  pds_vdpa: Add new PCI VF device for PDS vDPA services
  pds_vdpa: virtio bar setup for vdpa
  pds_vdpa: add auxiliary driver
  pds_vdpa: add vdpa config client commands
  pds_vdpa: add support for vdpa and vdpamgmt interfaces
  pds_vdpa: add Kconfig entry and pds_vdpa.rst

 .../ethernet/pensando/pds_core.rst            | 162 ++++
 .../ethernet/pensando/pds_vdpa.rst            |  85 ++
 MAINTAINERS                                   |   4 +-
 drivers/net/ethernet/pensando/Kconfig         |  12 +
 .../net/ethernet/pensando/pds_core/Makefile   |  15 +
 .../net/ethernet/pensando/pds_core/adminq.c   | 299 +++++++
 .../net/ethernet/pensando/pds_core/auxbus.c   | 306 +++++++
 drivers/net/ethernet/pensando/pds_core/core.c | 616 ++++++++++++++
 drivers/net/ethernet/pensando/pds_core/core.h | 342 ++++++++
 .../net/ethernet/pensando/pds_core/debugfs.c  | 262 ++++++
 drivers/net/ethernet/pensando/pds_core/dev.c  | 403 +++++++++
 .../net/ethernet/pensando/pds_core/devlink.c  | 310 +++++++
 drivers/net/ethernet/pensando/pds_core/fw.c   | 192 +++++
 drivers/net/ethernet/pensando/pds_core/main.c | 440 ++++++++++
 .../net/ethernet/pensando/pds_core/netdev.c   | 504 +++++++++++
 drivers/vdpa/Kconfig                          |   7 +
 drivers/vdpa/pds/Makefile                     |  11 +
 drivers/vdpa/pds/aux_drv.c                    | 156 ++++
 drivers/vdpa/pds/aux_drv.h                    |  28 +
 drivers/vdpa/pds/cmds.c                       | 266 ++++++
 drivers/vdpa/pds/cmds.h                       |  17 +
 drivers/vdpa/pds/debugfs.c                    | 234 +++++
 drivers/vdpa/pds/debugfs.h                    |  28 +
 drivers/vdpa/pds/pci_drv.c                    | 172 ++++
 drivers/vdpa/pds/pci_drv.h                    |  49 ++
 drivers/vdpa/pds/vdpa_dev.c                   | 796 ++++++++++++++++++
 drivers/vdpa/pds/vdpa_dev.h                   |  60 ++
 drivers/vdpa/pds/virtio_pci.c                 | 283 +++++++
 include/linux/pds/pds_adminq.h                | 643 ++++++++++++++
 include/linux/pds/pds_auxbus.h                |  88 ++
 include/linux/pds/pds_common.h                |  99 +++
 include/linux/pds/pds_core_if.h               | 582 +++++++++++++
 include/linux/pds/pds_intr.h                  | 160 ++++
 include/linux/pds/pds_vdpa.h                  | 219 +++++
 34 files changed, 7849 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/networking/device_drivers/ethernet/pensando/pds_core.rst
 create mode 100644 Documentation/networking/device_drivers/ethernet/pensando/pds_vdpa.rst
 create mode 100644 drivers/net/ethernet/pensando/pds_core/Makefile
 create mode 100644 drivers/net/ethernet/pensando/pds_core/adminq.c
 create mode 100644 drivers/net/ethernet/pensando/pds_core/auxbus.c
 create mode 100644 drivers/net/ethernet/pensando/pds_core/core.c
 create mode 100644 drivers/net/ethernet/pensando/pds_core/core.h
 create mode 100644 drivers/net/ethernet/pensando/pds_core/debugfs.c
 create mode 100644 drivers/net/ethernet/pensando/pds_core/dev.c
 create mode 100644 drivers/net/ethernet/pensando/pds_core/devlink.c
 create mode 100644 drivers/net/ethernet/pensando/pds_core/fw.c
 create mode 100644 drivers/net/ethernet/pensando/pds_core/main.c
 create mode 100644 drivers/net/ethernet/pensando/pds_core/netdev.c
 create mode 100644 drivers/vdpa/pds/Makefile
 create mode 100644 drivers/vdpa/pds/aux_drv.c
 create mode 100644 drivers/vdpa/pds/aux_drv.h
 create mode 100644 drivers/vdpa/pds/cmds.c
 create mode 100644 drivers/vdpa/pds/cmds.h
 create mode 100644 drivers/vdpa/pds/debugfs.c
 create mode 100644 drivers/vdpa/pds/debugfs.h
 create mode 100644 drivers/vdpa/pds/pci_drv.c
 create mode 100644 drivers/vdpa/pds/pci_drv.h
 create mode 100644 drivers/vdpa/pds/vdpa_dev.c
 create mode 100644 drivers/vdpa/pds/vdpa_dev.h
 create mode 100644 drivers/vdpa/pds/virtio_pci.c
 create mode 100644 include/linux/pds/pds_adminq.h
 create mode 100644 include/linux/pds/pds_auxbus.h
 create mode 100644 include/linux/pds/pds_common.h
 create mode 100644 include/linux/pds/pds_core_if.h
 create mode 100644 include/linux/pds/pds_intr.h
 create mode 100644 include/linux/pds/pds_vdpa.h

-- 
2.17.1

