Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092542C4892
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 20:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729684AbgKYTi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 14:38:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729399AbgKYTi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 14:38:26 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67052C0613D4;
        Wed, 25 Nov 2020 11:38:16 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id c80so4121924oib.2;
        Wed, 25 Nov 2020 11:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=w9NIgPfC+yCFV/XyMTf7S5HPv8W61f7vg2UyvfdlDoI=;
        b=Wp0ziyajbY8jOpon7hiQGD1C9EZbId4DwpxPOFgKwrqmEi0iD/KjSxg3nB/Q7BJP2Q
         0xSq+Y/E9NIbBajsu4vq3hwKL327Arxuw8+n7tbNUkdZz234bciCKIG3rFjcyxGh9bvC
         TXW3si6qzbHBcw3r+D+PpNfaAP/qslxvIVOWwtykSQYwsAq3WvTOjGvdfcUqrEvuZvnO
         SxQNbJLgxvLZlSWep390zrbcWObEBcZnvfLMJpJggdYaRHIETq35DDNvYj/Ge2h9oB0D
         pOuCHCFPxKOKhwTSqJF/bnUwRs1c3LidWgrvUA/O1ABhk5wIdirrzuJpeEl1tLjlgbuN
         IZwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=w9NIgPfC+yCFV/XyMTf7S5HPv8W61f7vg2UyvfdlDoI=;
        b=LE+YjPdlnOgOtM0JhmH2SQSd0CmIQG4sz01yAbwnmxxKj3W3KgLZeMy87foy7dQa1A
         /lHv/leuPNCApWyKwL5Bxde2a+35swgPKG+BDjCVHbKM3xSj/wHP7+ZZmL2vOOOqR5Iq
         cQ4dbXcDSuhqhuX819BZXujGot+Tx7zZD9JEeL9Skvp7Npruwv+PcKMjLzfYAFPbeYo3
         FwSwUV1v1T2xjm3TslKyPievRBucZ4tfDW9rCGI6UjFsGdlUYTb3XIFLf9XOb09Yg+hl
         YYxmOTFBpPKw8kli61sHg29N9sanj+qLUl1JGs0RFiFYN1MeHpDUFR4u+F2i8+RszpEk
         abRA==
X-Gm-Message-State: AOAM532FQV2c/CFNgAqZj8w0KvNxH8lNLUbSOWhc0yyNE02vLC6WIe0O
        9GmYDtq0gJqYwzRSnMN1KQ8+WLV48hde
X-Google-Smtp-Source: ABdhPJxfOnF7/rzWlxPzM0s/U8V6HSsXPMQPhULg61kEGFyz0VhpCWqKDvk2snnf1w3vBaQnN4ODFw==
X-Received: by 2002:aca:af57:: with SMTP id y84mr3445332oie.122.1606333095205;
        Wed, 25 Nov 2020 11:38:15 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id m109sm1655753otc.30.2020.11.25.11.38.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Nov 2020 11:38:14 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller " <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next v2 0/3] Arrow SpeedChips XRS700x DSA Driver
Date:   Wed, 25 Nov 2020 13:37:37 -0600
Message-Id: <20201125193740.36825-1-george.mccollister@gmail.com>
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

George McCollister (3):
  dsa: add support for Arrow XRS700x tag trailer
  net: dsa: add Arrow SpeedChips XRS700x driver
  dt-bindings: net: dsa: add bindings for xrs700x switches

 .../devicetree/bindings/net/dsa/arrow,xrs700x.yaml |  74 +++
 drivers/net/dsa/Kconfig                            |   2 +
 drivers/net/dsa/Makefile                           |   1 +
 drivers/net/dsa/xrs700x/Kconfig                    |  26 +
 drivers/net/dsa/xrs700x/Makefile                   |   4 +
 drivers/net/dsa/xrs700x/xrs700x.c                  | 585 +++++++++++++++++++++
 drivers/net/dsa/xrs700x/xrs700x.h                  |  38 ++
 drivers/net/dsa/xrs700x/xrs700x_i2c.c              | 150 ++++++
 drivers/net/dsa/xrs700x/xrs700x_mdio.c             | 162 ++++++
 drivers/net/dsa/xrs700x/xrs700x_reg.h              | 205 ++++++++
 include/net/dsa.h                                  |   2 +
 net/dsa/Kconfig                                    |   6 +
 net/dsa/Makefile                                   |   1 +
 net/dsa/tag_xrs700x.c                              |  67 +++
 14 files changed, 1323 insertions(+)
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

