Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B7E2F6BA0
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 20:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730331AbhANT60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 14:58:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729069AbhANT60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 14:58:26 -0500
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A2F8C061575;
        Thu, 14 Jan 2021 11:57:46 -0800 (PST)
Received: by mail-oo1-xc34.google.com with SMTP id j8so1664363oon.3;
        Thu, 14 Jan 2021 11:57:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=syC+eoDuMnnkg3JHLhJFFPrmvuYEpcdHPmE2Pdh377A=;
        b=TGxMNi7kerF0tEfZ8rPOd5ItzSjo04/mPeKO+XYgHqc7qBPwZ1Ti3eNunNv/m+2mCQ
         KyO/eoaf5EY0nv/Pi0A2RhgyNGEQTsdeVxbdpztKE4aAB3FtWjkZzDQxw2IniO5RA3mG
         y0/47bDt8Fph+db18oqaTTz/PDmF/H5fiWM2zszIi3YthwjAvA+NM9kbDo3/hkbz2pVP
         crVBdiM1k0yKYyxJJrb7+ksMN/fxY4o+aYGrgehzzATgjGAHqRLMdSkOLTIcG3YVxJBT
         nEBHLryW/d6HILFbbwSzOqVRAlhI+eNHyCgYFtu1FSH93OSsgrDUMQT6f8mOjbD98YJG
         zTag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=syC+eoDuMnnkg3JHLhJFFPrmvuYEpcdHPmE2Pdh377A=;
        b=TvXB1zOGgi7suI1YRIoREhtVURyRnG7lgYrb3Qefv++wF8JX2zXHiUE6ioBh/4Ge1Q
         kW1O/IMwjT3HPzxu7VKAR8MADJLN0vCYJsqlbyBtu5oSEDYSyfg4IUffQrKvEyaSn3v1
         SHcEM66/5r5R+THpyago3huIhzQTAO2YmPFTCZ9KD60DtIMXJu6c1+L7qDx2dplfL+hx
         El2oul2vyMKvHmlqUAKPvdSyjDGpIuK96yVsbyWKQl0v8xnE0ICWnu1LIQ0I9k9POX34
         6sG4roa0NeprAll2MYGnb/NexmjZLdh7XrSZO6av0Xd8k4oo54tjIrQOFZQnn34t0wcJ
         6FBQ==
X-Gm-Message-State: AOAM532CY16dPpKVOKlo3bNsowW6nhMEhOMJ7tND3H207Uc9g6+ooGfY
        TG7lhwjVng1F1QWTeWbBqg==
X-Google-Smtp-Source: ABdhPJw/Y2UEAMCQ5R4rchBr33l9lt+rMyzXat5++Yog4HY2+Jyxz5lrxRPMg14JaqERvd/yo+rbTw==
X-Received: by 2002:a4a:98a3:: with SMTP id a32mr5754406ooj.51.1610654265615;
        Thu, 14 Jan 2021 11:57:45 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id e17sm1244820otk.64.2021.01.14.11.57.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Jan 2021 11:57:44 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Rob Herring <robh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next v5 0/3] Arrow SpeedChips XRS700x DSA Driver
Date:   Thu, 14 Jan 2021 13:57:31 -0600
Message-Id: <20210114195734.55313-1-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds a DSA driver for the Arrow SpeedChips XRS 7000 series
of HSR/PRP gigabit switch chips.

The chips use Flexibilis IP.
More information can be found here:
 https://www.flexibilis.com/products/speedchips-xrs7000/

The switches have up to three RGMII ports and one MII port and are
managed via mdio or i2c. They use a one byte trailing tag to identify
the switch port when in managed mode so I've added a tag driver which
implements this.

This series contains minimal DSA functionality which may be built upon
in future patches. The ultimate goal is to add HSR and PRP
(IEC 62439-3 Clause 5 & 4) offloading with integration into net/hsr.

Changes since v1:
 * Use central TX reallocation in tag driver. (Andrew Lunn)
 * Code style fixes. (Andrew Lunn, Vladimir Oltean)
 * Code simplifications. (Andrew Lunn, Vladimir Oltean)
 * Verify detected switch matches compatible. (Andrew Lunn)
 * Add inbound policy to allow BPDUs. (Andrew Lunn)
 * Move files into their own subdir. (Vladimir Oltean)
 * Automate regmap field allocation. (Vladimir Oltean)
 * Move setting link speed to .mac_link_up. (Vladimir Oltean)
 * Use different compatible strings for e/f variants.

Changes since v2:
 * Export constant xrs700x_info symbols. (Jakub Kicinski)
 * Report stats via .get_stats64. (Jakub Kicinski, Vladimir Oltean)
 * Use a 3 second polling rate for counters.

Changes since v3:
 * Builds against net-next now that get_stats64 commit has been merged.
 * Don't show status in devicetree examples. (Rob Herring)
 * Use ethernet-port(s) in devicetree examples. (Rob Herring)
 * Use strscpy() instead of strlcpy().

Changes since v4:
 * Removed some unneeded includes. (Vladimir Oltean)
 * Remove unneeded call to skb_linearize(). (Vladimir Oltean)
 * Make naming of variables more consistent. (Vladimir Oltean)
 * Use VLAN_N_VID instead of creating a define for MAX_VLAN.
   (Florian Fainelli)
 * Use devm_kcalloc instead of devm_kzalloc where appropriate.
   (Vladimir Oltean)
 * Use eth_stp_addr and write BPDU inbound policy address in a loop.
   (Florian Fainelli)
 * Set i2c/mdio data before registering. (Florian Fainelli)

George McCollister (3):
  dsa: add support for Arrow XRS700x tag trailer
  net: dsa: add Arrow SpeedChips XRS700x driver
  dt-bindings: net: dsa: add bindings for xrs700x switches

 .../devicetree/bindings/net/dsa/arrow,xrs700x.yaml |  73 +++
 drivers/net/dsa/Kconfig                            |   2 +
 drivers/net/dsa/Makefile                           |   1 +
 drivers/net/dsa/xrs700x/Kconfig                    |  26 +
 drivers/net/dsa/xrs700x/Makefile                   |   4 +
 drivers/net/dsa/xrs700x/xrs700x.c                  | 622 +++++++++++++++++++++
 drivers/net/dsa/xrs700x/xrs700x.h                  |  42 ++
 drivers/net/dsa/xrs700x/xrs700x_i2c.c              | 150 +++++
 drivers/net/dsa/xrs700x/xrs700x_mdio.c             | 163 ++++++
 drivers/net/dsa/xrs700x/xrs700x_reg.h              | 203 +++++++
 include/net/dsa.h                                  |   2 +
 net/dsa/Kconfig                                    |   6 +
 net/dsa/Makefile                                   |   1 +
 net/dsa/tag_xrs700x.c                              |  61 ++
 14 files changed, 1356 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
 create mode 100644 drivers/net/dsa/xrs700x/Kconfig
 create mode 100644 drivers/net/dsa/xrs700x/Makefile
 create mode 100644 drivers/net/dsa/xrs700x/xrs700x.c
 create mode 100644 drivers/net/dsa/xrs700x/xrs700x.h
 create mode 100644 drivers/net/dsa/xrs700x/xrs700x_i2c.c
 create mode 100644 drivers/net/dsa/xrs700x/xrs700x_mdio.c
 create mode 100644 drivers/net/dsa/xrs700x/xrs700x_reg.h
 create mode 100644 net/dsa/tag_xrs700x.c

-- 
2.11.0

