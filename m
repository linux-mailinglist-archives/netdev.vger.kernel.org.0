Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237BA2D1CBB
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 23:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727719AbgLGWF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 17:05:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbgLGWF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 17:05:26 -0500
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C163C061749;
        Mon,  7 Dec 2020 14:04:46 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id o25so17219633oie.5;
        Mon, 07 Dec 2020 14:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=C3N3paf93HavLvwzDFDFeKUOun8/j//DcO2lRDULPik=;
        b=loy0br6Xjh587Iqzl8Y+AlQP159ArLJt2gBSbEo7SZftOhERDV4Bx6kPlQtKkgQeIS
         MVFA/7UmzDzEcdpFQxz2+yGOVdEBa1fSDo/M1DoN1p6dQGz5Tw50UFoM79KyRZjvby+q
         y+bs0A6PqKVPrn6cD1xdHNsvep2SaUKPGvrGgFaakDNNBt5pAQy97WTS7EFbSp2aXb6r
         fPqlvFlrqSr0xs/T7IYfaZNz6vpmv+27aCM1sdPVlmgHuR2liz3pz4WA6F5kD9xHRyoX
         denZZSbslylLcRfM/NzNxqgxRLPjRwSilbH3cnOtx66eTxPUTrkeT3UD8XYg4Lmq+lKJ
         3feA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=C3N3paf93HavLvwzDFDFeKUOun8/j//DcO2lRDULPik=;
        b=fkN+a9JU7IVYGhlDuSatF3Onk0h48Q+FzCgfzDnv7v0tCmBrirxBeFE0DaTkBDwyqp
         yfvXyMzTGTlL97yMVit6HKQadO1+fAcLNfn2pBoVTuKT9C7EBD3bI0g3uTguSbJQPEAq
         KZz9ydbHl356IMSK1qX4Y9QfSai2s56UygRJKnUPOYaC5CiZIJtnjJRNMwbgz+M8S2e7
         XppwIR6jfHYtX/eBv5RmD0PJ8FpsQoRVn74yeBx/XdcIu2pD+rdlTSiwa0hCLQOJwr18
         vb2DMpZ53AnuLd+yS4s4d71KsbzfeVN+XfJKAQt3wtMIJUlE0/y1QN8xeIpXzL6V+9xV
         s61A==
X-Gm-Message-State: AOAM533FbKSQK5wkMHHSm+HOLt9EDcbIAvAggctQ7uyF2/Z/Z/HQePWX
        Nxgly8EOFC/9zacvg68XjTczYCiXZJP0
X-Google-Smtp-Source: ABdhPJyuxhWTKn2phKXfRbHuKOgy9n9dqPqZywkLDnB8ejQWC2wkJa+x2i3+a21xrBy9+Kx9++mTHA==
X-Received: by 2002:aca:42d7:: with SMTP id p206mr651378oia.133.1607378685472;
        Mon, 07 Dec 2020 14:04:45 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id g5sm2940472otq.43.2020.12.07.14.04.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Dec 2020 14:04:44 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller " <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next v3 0/3] Arrow SpeedChips XRS700x DSA Driver
Date:   Mon,  7 Dec 2020 16:03:52 -0600
Message-Id: <20201207220355.8707-1-george.mccollister@gmail.com>
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

"net: dsa: add Arrow SpeedChips XRS700x driver" depends on:
"net: dsa: add optional stats64 support" being merged first.
https://lore.kernel.org/netdev/20201204145624.11713-2-o.rempel@pengutronix.de/

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

George McCollister (3):
  dsa: add support for Arrow XRS700x tag trailer
  net: dsa: add Arrow SpeedChips XRS700x driver
  dt-bindings: net: dsa: add bindings for xrs700x switches

 .../devicetree/bindings/net/dsa/arrow,xrs700x.yaml |  74 +++
 drivers/net/dsa/Kconfig                            |   2 +
 drivers/net/dsa/Makefile                           |   1 +
 drivers/net/dsa/xrs700x/Kconfig                    |  26 +
 drivers/net/dsa/xrs700x/Makefile                   |   4 +
 drivers/net/dsa/xrs700x/xrs700x.c                  | 629 +++++++++++++++++++++
 drivers/net/dsa/xrs700x/xrs700x.h                  |  42 ++
 drivers/net/dsa/xrs700x/xrs700x_i2c.c              | 150 +++++
 drivers/net/dsa/xrs700x/xrs700x_mdio.c             | 162 ++++++
 drivers/net/dsa/xrs700x/xrs700x_reg.h              | 205 +++++++
 include/net/dsa.h                                  |   2 +
 net/dsa/Kconfig                                    |   6 +
 net/dsa/Makefile                                   |   1 +
 net/dsa/tag_xrs700x.c                              |  67 +++
 14 files changed, 1371 insertions(+)
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

