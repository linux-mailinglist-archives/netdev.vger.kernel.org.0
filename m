Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542FA2BB241
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgKTSQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:16:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728292AbgKTSQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 13:16:58 -0500
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2119C0613CF;
        Fri, 20 Nov 2020 10:16:58 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id m13so11415281oih.8;
        Fri, 20 Nov 2020 10:16:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=HRJZo6xpQlt+VeyQ3i80zX7O+azAB7Dr0gFEmNy+/NA=;
        b=uRqYAS76GCmSCcI4KdgZ1a6q5U/LANbENgjkcLZrxROx+4XMbRCihHAnewJ56M0SeC
         Y+Ggn1v1p+ShuBjNz/bfZ9DCwcu2Y/9BOLp3uMUjVK6zx9URzFIJjpRWqrJYLDbtZ0/k
         NNmNO6zmd4u6E8++9dqQSSyWVVEcMxY+Ax68Z0nPTBRA8VonWQ91DbEvC9FK17aB5xfc
         CumklEJuR4buIdEiMw7I764uJjPFimp5u6FX9fQAgswMgT/ixg8FbdBiFLceLEZDXYyf
         A1/qZhnj1JUuUWhbKc+03j/wnuKX6ugW6BW7eJLwL+GzmNUpzbVeeG4gFd8FEaLDkriE
         9zWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HRJZo6xpQlt+VeyQ3i80zX7O+azAB7Dr0gFEmNy+/NA=;
        b=SYdTzv4ROVDuA9uk6vBCUF/2qaO4jFAhLGSY9VoRR+Cg7ajpK0FZF4D5Tc0U1r+F+o
         V2wUfSIGj+vPGC+821ObzLM+zeIsM/FOcj0bSDiCMtfbNQyJBHPPDV4F1amJsXGKw3q4
         5myqXO9JKOwWW6ZE63RBYWPNMpi0e87R8RZE1zoBOQgq1zg2oSpnBp1AbOVpEfedwrUk
         TrSJH8L30SEeEgDMxssJC9q44foqdkDN6f3iezycPI1xjXl0nZETibFHyG0OuB1tZa8+
         OkliANUgrmSx1VQh0YCZq4gRZoNJ8T9kKVKKGitrcLj8VcB8oo1J7tUX1GIAWIqJjmTK
         sIPw==
X-Gm-Message-State: AOAM532Zs//Pio4yoOv2M3SgaBHp8gHc+NH9vFOf73DqB37URc7oHNKV
        7SmSm1k3jA9A7hVMJdbHExSHSsYa0Q==
X-Google-Smtp-Source: ABdhPJyLj9cQS4DCxviYr3swJiMwQLp0+DXvIEPJGsMfKDVKVC9vbHpWC3+xWSg1FcW9+Z1PoE+JNw==
X-Received: by 2002:a05:6808:5:: with SMTP id u5mr7279889oic.18.1605896218184;
        Fri, 20 Nov 2020 10:16:58 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id y35sm1764420otb.5.2020.11.20.10.16.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Nov 2020 10:16:56 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller " <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next 0/3] Arrow SpeedChips XRS700x DSA Driver
Date:   Fri, 20 Nov 2020 12:16:24 -0600
Message-Id: <20201120181627.21382-1-george.mccollister@gmail.com>
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

George McCollister (3):
  dsa: add support for Arrow XRS700x tag trailer
  net: dsa: add Arrow SpeedChips XRS700x driver
  dt-bindings: net: dsa: add bindings for xrs700x switches

 .../devicetree/bindings/net/dsa/arrow,xrs700x.yaml |  72 +++
 drivers/net/dsa/Kconfig                            |  26 +
 drivers/net/dsa/Makefile                           |   3 +
 drivers/net/dsa/xrs700x.c                          | 529 +++++++++++++++++++++
 drivers/net/dsa/xrs700x.h                          |  27 ++
 drivers/net/dsa/xrs700x_i2c.c                      | 148 ++++++
 drivers/net/dsa/xrs700x_mdio.c                     | 160 +++++++
 drivers/net/dsa/xrs700x_reg.h                      | 205 ++++++++
 include/net/dsa.h                                  |   2 +
 net/dsa/Kconfig                                    |   6 +
 net/dsa/Makefile                                   |   1 +
 net/dsa/tag_xrs700x.c                              |  91 ++++
 12 files changed, 1270 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
 create mode 100644 drivers/net/dsa/xrs700x.c
 create mode 100644 drivers/net/dsa/xrs700x.h
 create mode 100644 drivers/net/dsa/xrs700x_i2c.c
 create mode 100644 drivers/net/dsa/xrs700x_mdio.c
 create mode 100644 drivers/net/dsa/xrs700x_reg.h
 create mode 100644 net/dsa/tag_xrs700x.c

-- 
2.11.0

