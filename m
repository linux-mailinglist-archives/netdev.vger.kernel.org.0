Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 545C7128203
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 19:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbfLTSP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 13:15:26 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43241 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727442AbfLTSPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 13:15:25 -0500
Received: by mail-pl1-f195.google.com with SMTP id p27so4424924pli.10;
        Fri, 20 Dec 2019 10:15:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lO//EsBagd0v62HI5e2wkHMmr4Jh18WGAA456XEJyjs=;
        b=tMw/5OpEKlDf66y+/WphzlsOB79RZjIshQivOilP6d2SBrGRbzIvfsMfw209iRJio4
         e7icun13AGDZqSj1GnnyieFriPPByueAm4+qvJ+6VokPCmDfeJfIdXgmODRZPHZZdzPj
         DqYy9ovw8PaqT7066izQ4950Sj+/gvKA9pA7YIt+z9aihyLWN9T+rp2iNmXdi0lZosff
         qluUomXXqoBBu20SGWi9pGtRgL8TlC5D92nOIgY22ZOcqYP5F36FKVjsxOUf1YOLzOA3
         FPxZQ9UlkbcH/uWrtgoeO/0ykqodnHECmXbz/ttOTZFMoPP0N4EP6qvEW/AJivQllGO4
         A/5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lO//EsBagd0v62HI5e2wkHMmr4Jh18WGAA456XEJyjs=;
        b=VkcP5sH4g7GAG38UNWhdMb7AwIJ3sb4yKZtU6jwvJrfrv7UDmjqBvIk3tMtU5jmnFh
         6syhIfmuAzEnCpVfxBNE2GsFW22lN2SjqqA1NqqrAVX5WMYpEUbn6Ra/442PoTLeJwZR
         pDvhmwtCDGOMdSwy787jxUmS9bXQ6/nMj4Iqa1pbCEiMjETkEfeul5HF3r2sk98zRRuQ
         R4fRMAV08avCTv9rIAzxgvxu9v0kWHFAJ5wBZsLBIywvoXgv5HMmhYnJA9rLGPdobHIk
         g97WIXEzFqQa7omd+3YRWyJaDWpKAJeop0BweQminaZUe8oqxOqvNVU4tBCT3fmiQAoU
         v79w==
X-Gm-Message-State: APjAAAUE6mLQiETtfQIl1f0sCwxFFGEhSOJX953zyez1ZnklxK5gwju2
        PTl49nCmpoIzG2vo8XF0B3oHAu3x
X-Google-Smtp-Source: APXvYqwDredtkNh/dAwr79ySAizvvjJl7yJx8tzaOWPXdc/g/h63VSHnuR4VP3YMndk6RlhCA4Ezbg==
X-Received: by 2002:a17:902:788e:: with SMTP id q14mr16498068pll.305.1576865723973;
        Fri, 20 Dec 2019 10:15:23 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id j28sm11833869pgb.36.2019.12.20.10.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 10:15:22 -0800 (PST)
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
Subject: [PATCH V7 net-next 00/11] Peer to Peer One-Step time stamping
Date:   Fri, 20 Dec 2019 10:15:09 -0800
Message-Id: <cover.1576865315.git.richardcochran@gmail.com>
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
- Patches 6-9 add support for MII time stamping in non-PHY devices.
- Patch 10 adds the new P2P 1-step option.
- Patch 11 adds a driver implementing the new option.

Thanks,
Richard

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

Richard Cochran (11):
  net: phy: Introduce helper functions for time stamping support.
  net: macvlan: Use the PHY time stamping interface.
  net: vlan: Use the PHY time stamping interface.
  net: ethtool: Use the PHY time stamping interface.
  net: netcp_ethss: Use the PHY time stamping interface.
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
 drivers/net/phy/dp83640.c                     |  47 +-
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
 22 files changed, 1351 insertions(+), 65 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ptp/ptp-ines.txt
 create mode 100644 Documentation/devicetree/bindings/ptp/timestamper.txt
 create mode 100644 drivers/net/phy/mii_timestamper.c
 create mode 100644 drivers/ptp/ptp_ines.c
 create mode 100644 include/linux/mii_timestamper.h

-- 
2.20.1

