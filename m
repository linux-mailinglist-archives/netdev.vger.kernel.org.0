Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25D3267AF7
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 16:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgILOmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 10:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgILOlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 10:41:13 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9106AC061573;
        Sat, 12 Sep 2020 07:41:12 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id t16so13351233edw.7;
        Sat, 12 Sep 2020 07:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=FCbvivGtd05YtsKcJ2nkEeStBvY/hK/UHdLWigrZ968=;
        b=Vt1JnpjFnz1rDOwo0/SnzQ8t+b/Kf8DcqkqzNytM5FB3ZVwTx4B5FGg7Y7pZ8ihE81
         pEtpRAO7iC34VUldmMby0ra3EejnPfJDoStm50sORFE92UOT1+K1yGyAYnaOKqrzkGTA
         t3E9XF0/gxTLvfz7PYh+RaQjL6wJOFVeNgkUXGZnSpF0Cde5p+AqpB8Zb8LIL58QW9Ou
         QU52N3F1L18tuWV0cdL/EZpX0SQQREZ2s314Ior+aOgjMMD9HT7eXFpziwOwYDPVe3rv
         OHcsD10sgAPlWPwkXqfkF5gmF6rYJcXJlzrksFdTqiwJu6CXDgDqj4YCf+oP+DaAnVJ3
         eJLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FCbvivGtd05YtsKcJ2nkEeStBvY/hK/UHdLWigrZ968=;
        b=tTewl6bNd4RHA2DbU7mUIbkZnNHWIpHbhxiq0/OfrF0dtrK4PfZG/K3t+JSPpydu/g
         xpzyZPebglJkJg9h5DMTRUKqIx4xaSBpAoolDM6sVZrY/zicMOoVyKF9/+gZbCxMZcbB
         y7SEmEqoYBWLpPubwUqPsGBFxu81Q+QjwlocNT4W97d5sIZy6VSNwUJRjnD7oJs4shbS
         f842DVd+Fr9fqBBWiB9bmXvIuG88vY5940Zn/XnTCirqKETm61QBP8eM/54rdZpSQvbi
         66z/naEg/tn2HtrnzW6eBxOgngPVUnbqVvo/B9q3ElkmE2g1l8/ZjShSni9RoK8pou85
         /x1g==
X-Gm-Message-State: AOAM532mIkws7XXT2jeXwF3cvfS442zDGttaMlAmZZ46OEufMIne+TXC
        SOJw0GL9czG2bpVHx7O8joXxSZl6YKY=
X-Google-Smtp-Source: ABdhPJxafxGw9HXKe4OVCBfKuAcDjprAwQ3PWlu0tHFENMP84NUpXDKBgCOa1tfRp9lhqRMOynhVJg==
X-Received: by 2002:a05:6402:515:: with SMTP id m21mr8778683edv.348.1599921670267;
        Sat, 12 Sep 2020 07:41:10 -0700 (PDT)
Received: from ogabbay-VM.habana-labs.com ([213.57.90.10])
        by smtp.gmail.com with ESMTPSA id y25sm4842938edv.15.2020.09.12.07.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2020 07:41:09 -0700 (PDT)
From:   Oded Gabbay <oded.gabbay@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     SW_Drivers@habana.ai, gregkh@linuxfoundation.org,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com
Subject: [PATCH v2 00/14] Adding GAUDI NIC code to habanalabs driver
Date:   Sat, 12 Sep 2020 17:40:52 +0300
Message-Id: <20200912144106.11799-1-oded.gabbay@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This is the second version of the patch-set to upstream the GAUDI NIC code
into the habanalabs driver.

Modifications were made following reviews of the first version and are
detailed in the commit message of each patch that was changed.

A general note I want to write here is that I removed the debugfs patch
completely as the feedback was it is not acceptable to add debugfs
entries for configuration in netdev.

The original cover letter is attached here for people who didn't read the
first patch-set:

This patch-set adds support for initializing and using the GAUDI NIC ports,
functioning as scale-out interconnect when doing distributed Deep Learning
training. The training can be performed over tens of thousands of GAUDIs
and it is done using the RDMA-over-converged-Ethernet (RoCE) v2 protocol.

Each GAUDI exposes 10x100GbE ports that are designed to scale-out the
inter-GAUDI communication by integrating a complete communication engine
on-die. This native integration allows users to use the same scaling
technology, both inside the server and rack (termed as scale-up), as well
as for scaling across racks (scale-out). The racks can be connected
directly between GAUDI processors, or through any number of standard
Ethernet switches.

The driver exposes the NIC ports to the user as standard Ethernet ports by
registering each port to the networking subsystem. This allows the user to
manage the ports with standard tools such as ifconfig, ethtool, etc. It
also enables us to connect to the Linux networking stack and thus support
standard networking protocols, such as IPv4, IPv6, TCP, etc. In addition,
we can also leverage protocols such as DCB for dynamically configuring
priorities to avoid congestion.

For each NIC port there is a matching QMAN entity. For RoCE, the user
submits workloads to the NIC through the QMAN, same as he does for the
compute engines. For regular Ethernet, the user sends and receives packets
through the standard Ethernet sockets. Those sockets are used only as a
control path. The data path that is used for AI training goes through the
RoCE interface.

It is important to note that there are some limitations and uniqueness
in GAUDI's NIC H/W, compared to other networking adapters that enforced us
to use a less-than-common driver design:

1. The NIC functionality is NOT exposed as different PCI Physical
   Functions. There is a single PF which is used for compute and
   networking, as the main goal of the NIC ports is to be used as
   intra-communication and not as standard network interfaces. This
   implies we can't connect different drivers to handle the networking
   ports because it is the same device, from the kernel POV, as the
   compute. Therefore, we must integrate the networking code into the
   main habanalabs driver.

2. Although our communication engine implements RDMA, and the driver code
   uses well-known RDMA concepts such as QP context, CQ, WQ, etc., the
   GAUDI architecture does NOT support other basic IBverbs concepts, such
   as MR and protection domain. Therefore, we can't connect to the standard
   IBverb infrastructure in the user-space and kernel (rdma-core library
   and infiniband subsystem, respectively) because the standard RDMA s/w
   and tools won't work on our H/W. Instead, we added a new IOCTL to the
   driver's existing IOCTL API. The new IOCTL exposes the available
   NIC control operations to the user (e.g. Create a QP context).

3. The die-on communication engine provides minimal offloading for standard
   Ethernet and TCP/IP protocols, as those are only used for control plane.
   E.g. the packets are copied rather than using descriptors.
   Therefore, the Ethernet performance is quite low compared to standard
   Ethernet adapters.

4. There is no virtualization support per port.

Most or all of the above limitations will hopefully be improved in future
ASIC generations.

Patch-set organization:

- Patches 1 & 2 are just adding some auto-generated register header files
  and NIC-related definitions to the interface between the driver and the
  GAUDI firmware.

- Patch 3 adds initialization of security restrictions on the NIC engines.

- Patch 4 adds initialization of the NIC QMANs. The QMANs are needed to
  send RDMA packets through the NIC engines.

- Patches 5-11 adds the NIC driver code. It contains the basic Ethernet
  driver and H/W initialization, the NIC PHY driver code and the new NIC
  control IOCTL operations.

- Patch 12-13 adds support for ethtool and DCB.

- Patch 14 adds the implementation of the high-level init/fini functions
  and their calls from the common code. This is the patch that actually
  enables the NIC ports and allows the user to work with them.

Thanks,
Oded

Omer Shpigelman (14):
  habanalabs/gaudi: add NIC H/W and registers definitions
  habanalabs/gaudi: add NIC firmware-related definitions
  habanalabs/gaudi: add NIC security configuration
  habanalabs/gaudi: add support for NIC QMANs
  habanalabs/gaudi: add NIC Ethernet support
  habanalabs/gaudi: add NIC PHY code
  habanalabs/gaudi: allow user to get MAC addresses in INFO IOCTL
  habanalabs/gaudi: add a new IOCTL for NIC control operations
  habanalabs/gaudi: add CQ control operations
  habanalabs/gaudi: add WQ control operations
  habanalabs/gaudi: add QP error handling
  habanalabs/gaudi: Add ethtool support using coresight
  habanalabs/gaudi: support DCB protocol
  habanalabs/gaudi: add NIC init/fini calls from common code

 drivers/misc/habanalabs/common/context.c      |    1 +
 drivers/misc/habanalabs/common/device.c       |   24 +-
 drivers/misc/habanalabs/common/firmware_if.c  |   44 +
 drivers/misc/habanalabs/common/habanalabs.h   |   33 +-
 .../misc/habanalabs/common/habanalabs_drv.c   |    5 +
 .../misc/habanalabs/common/habanalabs_ioctl.c |  151 +-
 drivers/misc/habanalabs/common/pci.c          |    1 +
 drivers/misc/habanalabs/gaudi/Makefile        |    3 +
 drivers/misc/habanalabs/gaudi/gaudi.c         |  957 +++-
 drivers/misc/habanalabs/gaudi/gaudiP.h        |  331 +-
 .../misc/habanalabs/gaudi/gaudi_coresight.c   |  144 +
 drivers/misc/habanalabs/gaudi/gaudi_nic.c     | 4093 +++++++++++++++++
 drivers/misc/habanalabs/gaudi/gaudi_nic.h     |  353 ++
 .../misc/habanalabs/gaudi/gaudi_nic_dcbnl.c   |  108 +
 .../misc/habanalabs/gaudi/gaudi_nic_ethtool.c |  613 +++
 drivers/misc/habanalabs/gaudi/gaudi_phy.c     | 1276 +++++
 .../misc/habanalabs/gaudi/gaudi_security.c    | 3973 ++++++++++++++++
 drivers/misc/habanalabs/goya/goya.c           |   44 +
 .../misc/habanalabs/include/common/cpucp_if.h |   34 +-
 .../include/gaudi/asic_reg/gaudi_regs.h       |   26 +-
 .../include/gaudi/asic_reg/nic0_qm0_masks.h   |  800 ++++
 .../include/gaudi/asic_reg/nic0_qm0_regs.h    |  834 ++++
 .../include/gaudi/asic_reg/nic0_qm1_regs.h    |  834 ++++
 .../include/gaudi/asic_reg/nic0_qpc0_masks.h  |  500 ++
 .../include/gaudi/asic_reg/nic0_qpc0_regs.h   |  710 +++
 .../include/gaudi/asic_reg/nic0_qpc1_regs.h   |  710 +++
 .../include/gaudi/asic_reg/nic0_rxb_regs.h    |  508 ++
 .../include/gaudi/asic_reg/nic0_rxe0_masks.h  |  354 ++
 .../include/gaudi/asic_reg/nic0_rxe0_regs.h   |  158 +
 .../include/gaudi/asic_reg/nic0_rxe1_regs.h   |  158 +
 .../include/gaudi/asic_reg/nic0_stat_regs.h   |  518 +++
 .../include/gaudi/asic_reg/nic0_tmr_regs.h    |  184 +
 .../include/gaudi/asic_reg/nic0_txe0_masks.h  |  336 ++
 .../include/gaudi/asic_reg/nic0_txe0_regs.h   |  264 ++
 .../include/gaudi/asic_reg/nic0_txe1_regs.h   |  264 ++
 .../include/gaudi/asic_reg/nic0_txs0_masks.h  |  336 ++
 .../include/gaudi/asic_reg/nic0_txs0_regs.h   |  214 +
 .../include/gaudi/asic_reg/nic0_txs1_regs.h   |  214 +
 .../include/gaudi/asic_reg/nic1_qm0_regs.h    |  834 ++++
 .../include/gaudi/asic_reg/nic1_qm1_regs.h    |  834 ++++
 .../include/gaudi/asic_reg/nic2_qm0_regs.h    |  834 ++++
 .../include/gaudi/asic_reg/nic2_qm1_regs.h    |  834 ++++
 .../include/gaudi/asic_reg/nic3_qm0_regs.h    |  834 ++++
 .../include/gaudi/asic_reg/nic3_qm1_regs.h    |  834 ++++
 .../include/gaudi/asic_reg/nic4_qm0_regs.h    |  834 ++++
 .../include/gaudi/asic_reg/nic4_qm1_regs.h    |  834 ++++
 drivers/misc/habanalabs/include/gaudi/gaudi.h |   12 +
 .../habanalabs/include/gaudi/gaudi_fw_if.h    |   24 +
 .../habanalabs/include/gaudi/gaudi_masks.h    |   15 +
 .../include/hw_ip/nic/nic_general.h           |   13 +
 include/uapi/misc/habanalabs.h                |  296 +-
 51 files changed, 27080 insertions(+), 62 deletions(-)
 create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic.c
 create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic.h
 create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic_dcbnl.c
 create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic_ethtool.c
 create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_phy.c
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm0_masks.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc0_masks.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxb_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe0_masks.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_stat_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_tmr_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe0_masks.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs0_masks.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic1_qm0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic1_qm1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic2_qm0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic2_qm1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic3_qm0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic3_qm1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic4_qm0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic4_qm1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/hw_ip/nic/nic_general.h

-- 
2.17.1

