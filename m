Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEEB2F4E03
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 16:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbhAMPAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 10:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726428AbhAMPAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 10:00:22 -0500
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD310C061786;
        Wed, 13 Jan 2021 06:59:41 -0800 (PST)
Received: by mail-oo1-xc2e.google.com with SMTP id y14so573185oom.10;
        Wed, 13 Jan 2021 06:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=258PK+5f9SfRjPXqz+PqCNncjnatqdhPMWQuDcb2+Yk=;
        b=N7dEvDar2tsLO1EFXUuMFUyXs0/byBR4xnPe3sqxqSvwwWyPdmBH7XcumYG7XoPD3u
         r70SswJnWbsjAA/moKhfXvitJTDEy9GGfNL32dgYOn1Jk3n6MqDaogH3UdSPJOH5UZhj
         Tle86VOMmNNWg/M/68xHyeWOT5hnE/WqQCbO/omK+EuJXtA/SsoqoUPFZVbnZrRgTxqE
         0uUKvN0RPpvzpn/3jPnFMUQkcNX4jiBzjjtpcCqJl0HjyoxH5ZACdePnDDYk5gdrSSOF
         0WaFjz81UdwkBlekCdIbh36s+TuFVNpVgpQhvztKfeDclohGZ7xu1NZgRzc8n0fcXJc3
         jBbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=258PK+5f9SfRjPXqz+PqCNncjnatqdhPMWQuDcb2+Yk=;
        b=Q8QYQ3jHeww20NG/6rmCAOsZ75tbjq0vCxrMK8WCAXTuIvvv2/DFwSYtWauMMNzE1B
         ZHaVax3ks/UBcXQiVoe1XlWX7BdvqmuT8KdILOhGkUvZgCq/mOjflwHq0PzdNHABmItg
         3OnZKuJa52oGfcqzLOK8ppWPu3LWrGwg9lpXyuEIBM9x6zzocVE43s1Suj1OEt2U07y0
         6DWdDfJFc07247JsIFN9haEyeSlMqPQqAFiA9FJ04CS6Q9o/5EXg8SMBFRJbX3KJU6Th
         8+Qkpjt1Rm4rZaE13lL/lmG+TNlBmq0Ab9xT7RgtrS/fYIw/AjI8yjTK0CXgtWmsOnOo
         sJ5w==
X-Gm-Message-State: AOAM531MPESKwNeSVcNxBt/lhJKTd+B+W8F9oC/bM3jPUIfNtjZQJSeH
        sb6MXY1qGsdiDoayzJIvXQ==
X-Google-Smtp-Source: ABdhPJx52MJ30ZOsAUopAL2IkYXO/TLDnkPBDAKhx0TlTNHc6mBchNn7itav8cBACj8HaXbun2hPzA==
X-Received: by 2002:a4a:d396:: with SMTP id i22mr1503843oos.55.1610549981185;
        Wed, 13 Jan 2021 06:59:41 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id f25sm440719oou.39.2021.01.13.06.59.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Jan 2021 06:59:39 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Rob Herring <robh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next v4 0/3] Arrow SpeedChips XRS700x DSA Driver
Date:   Wed, 13 Jan 2021 08:59:19 -0600
Message-Id: <20210113145922.92848-1-george.mccollister@gmail.com>
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

George McCollister (3):
  dsa: add support for Arrow XRS700x tag trailer
  net: dsa: add Arrow SpeedChips XRS700x driver
  dt-bindings: net: dsa: add bindings for xrs700x switches

 .../devicetree/bindings/net/dsa/arrow,xrs700x.yaml |  73 +++
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
 14 files changed, 1370 insertions(+)
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

