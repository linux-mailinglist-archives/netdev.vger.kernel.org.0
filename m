Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71A31128B12
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 20:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbfLUTgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 14:36:43 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46690 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbfLUTgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 14:36:42 -0500
Received: by mail-pf1-f193.google.com with SMTP id y14so7063534pfm.13;
        Sat, 21 Dec 2019 11:36:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eYA18M1AHwTBfGDn9HaHwahCZ9Z228s4VmZRiOLYjRM=;
        b=VtHrEbAWfdVDDZGox1YE1G7CRmege9NbDWizAXiWGhpVTBinL2u+soJ4LzYligSDW2
         Cp7JLjFxfgwHPRKv64U/oM5i4uUQESMlpzCM8fy6MXqzAe5WR6SMHCCluYdmVwSmjvOn
         bVY11nxCyIkfTawbeaebrRWnyhMOiI39x9XzY3f4GrFjDBglu+OKPPtIa/PEGwFJTsvd
         +F9VnhwEKgjns7lN3YfgVmBO+xhC4vM6IT9ivvO7HBoZljKozLP4He8VgkFmWSRg3eeO
         vJ9OCTlxizr4KW63hk4mBVtuL9WilXvqFntleOZpo7m5fms1Ap/33kSzvPmf/ySL2mvc
         9qrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eYA18M1AHwTBfGDn9HaHwahCZ9Z228s4VmZRiOLYjRM=;
        b=XJMdeNnLX108xlzp5iniWmXjkYNv7a2coLiMWZwWFl4JSiqbIeKWuY+7Tpr+BWcMC6
         OhJ6UcXyh3fSf4b5PLmy6ZF6uzgysUdXnLzJ9YXlDMfWuAjgxWlBohaplFdHi68RKeK5
         QxJ9FxTcYj2Jn8Kp3DAdP9k0xrcJ4Uk9YK2XKbmGFN/AYsIS08ctFM3vgi7ztY7ABurK
         ze2jFdB58d0LVR/64Tg/AM11xLJM4oxulqiwOiy3a2Vxy5obZ+KNj5Q6cvic8aMNC813
         eV2BTlcV7ERHQnCFELnr7sZnbblheQ0Co4CiV5dtMjJS7eGo7J6ttsSY/kISJbHVFf2i
         9Guw==
X-Gm-Message-State: APjAAAWiPdRK8sXQZfU3edEGQMUlNieiyRMnbxIS2vqspXL7NtWH3R1m
        7hqBiHcLqLLHI5LsGWQyRzHXWoR8
X-Google-Smtp-Source: APXvYqwA965W55iHgOHil2WldY42io+p8qmLr8ZxB+yIKgiDSkjJfQWuO7o5an2mz5tfTkMJexg8jQ==
X-Received: by 2002:a63:4e22:: with SMTP id c34mr22037250pgb.214.1576957001147;
        Sat, 21 Dec 2019 11:36:41 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id y197sm18512603pfc.79.2019.12.21.11.36.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 11:36:40 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: [PATCH V8 net-next 00/12] Peer to Peer One-Step time stamping
Date:   Sat, 21 Dec 2019 11:36:26 -0800
Message-Id: <cover.1576956342.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for PTP (IEEE 1588) P2P one-step time
stamping along with a driver for a hardware device that supports this.

If the hardware supports p2p one-step, it subtracts the ingress time
stamp value from the Pdelay_Request correction field.  The user space
software stack then simply copies the correction field into the
Pdelay_Response, and on transmission the hardware adds the egress time
stamp into the correction field.

This new functionality extends CONFIG_NETWORK_PHY_TIMESTAMPING to
cover MII snooping devices, but it still depends on phylib, just as
that option does.  Expanding beyond phylib is not within the scope of
the this series.

User space support is available in the current linuxptp master branch.

- Patch 1 adds phy_device methods for existing time stamping fields.
- Patches 2-5 convert the stack and drivers to the new methods.
- Patch 6 moves code around the dp83640 driver.
- Patches 7-10 add support for MII time stamping in non-PHY devices.
- Patch 11 adds the new P2P 1-step option.
- Patch 12 adds a driver implementing the new option.

Thanks,
Richard

Changed in v8:
~~~~~~~~~~~~~~

- Avoided adding forward functional declarations in the dp83640 driver.
- Picked up Florian's new review tags and another one from Andrew.

Changed in v7:
~~~~~~~~~~~~~~

- Converted pr_debug|err to dev_ variants in new driver.
- Fixed device tree documentation per Rob's v6 review.
- Picked up Andrew's and Rob's review tags.
- Silenced sparse warnings in new driver.

Changed in v6:
~~~~~~~~~~~~~~

- Added methods for accessing the phy_device time stamping fields.
- Adjust the device tree documentation per Rob's v5 review.
- Fixed the build failures due to missing exports.

Changed in v5:
~~~~~~~~~~~~~~

- Fixed build failure in macvlan.
- Fixed latent bug with its gcc warning in the driver.

Changed in v4:
~~~~~~~~~~~~~~

- Correct error paths and PTR_ERR return values in the framework.
- Expanded KernelDoc comments WRT PHY locking.
- Pick up Andrew's review tag.

Changed in v3:
~~~~~~~~~~~~~~

- Simplify the device tree binding and document the time stamping
  phandle by itself.

Changed in v2:
~~~~~~~~~~~~~~

- Per the v1 review, changed the modeling of MII time stamping
  devices.  They are no longer a kind of mdio device.

Richard Cochran (12):
  net: phy: Introduce helper functions for time stamping support.
  net: macvlan: Use the PHY time stamping interface.
  net: vlan: Use the PHY time stamping interface.
  net: ethtool: Use the PHY time stamping interface.
  net: netcp_ethss: Use the PHY time stamping interface.
  net: phy: dp83640: Move the probe and remove methods around.
  net: Introduce a new MII time stamping interface.
  net: Add a layer for non-PHY MII time stamping drivers.
  dt-bindings: ptp: Introduce MII time stamping devices.
  net: mdio: of: Register discovered MII time stampers.
  net: Introduce peer to peer one step PTP time stamping.
  ptp: Add a driver for InES time stamping IP core.

 .../devicetree/bindings/ptp/ptp-ines.txt      |  35 +
 .../devicetree/bindings/ptp/timestamper.txt   |  42 +
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |   1 +
 drivers/net/ethernet/ti/netcp_ethss.c         |   8 +-
 drivers/net/macvlan.c                         |   4 +-
 drivers/net/phy/Makefile                      |   2 +
 drivers/net/phy/dp83640.c                     | 217 ++---
 drivers/net/phy/mii_timestamper.c             | 125 +++
 drivers/net/phy/phy.c                         |   4 +-
 drivers/net/phy/phy_device.c                  |   5 +
 drivers/of/of_mdio.c                          |  30 +-
 drivers/ptp/Kconfig                           |  10 +
 drivers/ptp/Makefile                          |   1 +
 drivers/ptp/ptp_ines.c                        | 852 ++++++++++++++++++
 include/linux/mii_timestamper.h               | 121 +++
 include/linux/phy.h                           |  85 +-
 include/uapi/linux/net_tstamp.h               |   8 +
 net/8021q/vlan_dev.c                          |   4 +-
 net/Kconfig                                   |   7 +-
 net/core/dev_ioctl.c                          |   1 +
 net/core/timestamping.c                       |  20 +-
 net/ethtool/ioctl.c                           |   4 +-
 22 files changed, 1432 insertions(+), 154 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ptp/ptp-ines.txt
 create mode 100644 Documentation/devicetree/bindings/ptp/timestamper.txt
 create mode 100644 drivers/net/phy/mii_timestamper.c
 create mode 100644 drivers/ptp/ptp_ines.c
 create mode 100644 include/linux/mii_timestamper.h

-- 
2.20.1

