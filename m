Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3679D120EEF
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 17:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbfLPQNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 11:13:30 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:42719 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbfLPQN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 11:13:29 -0500
Received: by mail-pj1-f67.google.com with SMTP id o11so3172351pjp.9;
        Mon, 16 Dec 2019 08:13:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AmQdh3pTfFXGNaPpfcoXiau6bf5zP9ta7ynbOFe3lBQ=;
        b=KdjC8G35EsutpM/3fAf2/NEm3EQicZq3xTjd2OdwcQlxzKaqMytcfOHkJa0pEIQ++y
         MSd8X+CDewchQHE0iJaDtt/4hYadx2c7F/vut9Ycal2HAMglHHfho743uIV6Pp+bMuie
         pUW7VL51xj/bfzSf5PPD4uz4J5A6ZDYv9uPwcKDDyfoEU3EIyQAryH0cXmdqzlUc0Met
         LfXNkVOaqGZNovxdrLvcoXRIyu2LlCblNIkt6Qf7eOl9GK/VH7mBgysobKniTAomTi1X
         yu3Sj9TeTWNUa3SuQt4fOljXzR+MdMgYwP8Bnic+wGQs4uA9fNDEDVtBEwI6L4q5pjqC
         AnWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AmQdh3pTfFXGNaPpfcoXiau6bf5zP9ta7ynbOFe3lBQ=;
        b=mXhroJQOfEeHxPU44bIQDjv06ElxC/AwrI0x4hIjkRLgMzd9FaXXRQcBttnSn56TnH
         EestxKSSVwCtajQzU5ypP4EGMVKD+KiOPTfxTC6fpf1rbeJ5c2518mDxdSUY0HhOw+Bl
         O6wN60Y9gYBCCqmnFwJGS7bToAebRkoUfHPDDpapy4JuvhQUBe8hy42i3N6PwvAZ/mdt
         7f3rmSnxVPLNjt1tq5/Q8rkhSvjh2PdvrADow3E43U0NvGzhKF1D3+o2D10wk5mN/BdO
         Yig7uX69SX1SGI6uv9hwu3gh7x/iEqpnPrB2Er/uQ2RmQLrkkRGCZKEHDn2BmI+81PN9
         KYNg==
X-Gm-Message-State: APjAAAVnoQcjlh948cGjTMgIkf+wJ3i46+MuENdC3JAUBwNE8dkYPevR
        YzUhihpGhE+KCxiunmOJ06LQ5hHh
X-Google-Smtp-Source: APXvYqzdJVvsgB1W6Q+OxEVGonshdsMjMejjI8+uyBKIlzKf7ukb/p8y2+2KHhQxa/HQ1BQeN1GIPQ==
X-Received: by 2002:a17:902:a986:: with SMTP id bh6mr15829916plb.165.1576512808436;
        Mon, 16 Dec 2019 08:13:28 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 83sm23478433pgh.12.2019.12.16.08.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 08:13:27 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: [PATCH V6 net-next 00/11] Peer to Peer One-Step time stamping
Date:   Mon, 16 Dec 2019 08:13:15 -0800
Message-Id: <cover.1576511937.git.richardcochran@gmail.com>
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

- Patch 1 adds phy_device methods for existing time stamping fields.	(NEW in v6)
- Patches 2-5 convert the stack and drivers to the new methods.		(NEW in v6)
- Patches 6-9 add support for MII time stamping in non-PHY devices.
- Patch 10 adds the new P2P 1-step option.
- Patch 11 adds a driver implementing the new option.

Thanks,
Richard

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
 .../devicetree/bindings/ptp/timestamper.txt   |  41 +
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
 drivers/ptp/ptp_ines.c                        | 859 ++++++++++++++++++
 include/linux/mii_timestamper.h               | 121 +++
 include/linux/phy.h                           |  85 +-
 include/uapi/linux/net_tstamp.h               |   8 +
 net/8021q/vlan_dev.c                          |   4 +-
 net/Kconfig                                   |   7 +-
 net/core/dev_ioctl.c                          |   1 +
 net/core/timestamping.c                       |  20 +-
 net/ethtool/ioctl.c                           |   4 +-
 22 files changed, 1357 insertions(+), 65 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ptp/ptp-ines.txt
 create mode 100644 Documentation/devicetree/bindings/ptp/timestamper.txt
 create mode 100644 drivers/net/phy/mii_timestamper.c
 create mode 100644 drivers/ptp/ptp_ines.c
 create mode 100644 include/linux/mii_timestamper.h

-- 
2.20.1

