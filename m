Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B836F3009C6
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 18:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729752AbhAVR3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 12:29:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728892AbhAVQA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 11:00:57 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D71CC061786
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 08:00:17 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id a109so5526340otc.1
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 08:00:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=n+6mmedH+4f3zyT4CbqLTkwAkD3BlL/CUT8bw9Am6fM=;
        b=LKI2iFZqRJMf6KfP7xIqCwXOTx1Y6h3liIw6gT5HPKGy8uN/kCGHoaVjFe/lowXrGr
         /Xu/VJqNnF0CILZJiBupx2gwwFXbBZ1Z2sJXTOoLDI74uB0HfsqeZbofvidC/4kwooiz
         QazIsot/FWWIk3lh4zhmYY32WaX+xbvTGHtPbtUlAhM29eFiYNN1yOHvuUPx7cGqq3Z6
         px7fG2Rx/PcCIQQKLjL9+2xmkYR4umlMv2cNDfgKuui3QA1YqIGvdwDO1rq15BYFrYs0
         DzH2Z0TYGY7iKp/d7eGZBWA8TrF776dJOLAOfeIrSw2MLlLVwV03AURMFWydXutmuwSU
         p8Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=n+6mmedH+4f3zyT4CbqLTkwAkD3BlL/CUT8bw9Am6fM=;
        b=Gy19/6mtdI99rSshiz+3QP2p8fAT+Rrf92SX4mycRzrE7aXkRrmVId76JkNM7oPlVx
         S2zx3tfSZsaiKAb19KuxatQ+pHNIJsRkeHT+SZjkCAi8Tm1QZepFRDa787QXWAdnSrYE
         GR0bmCncGA3y7T7jv5PWDFAePGii9WTmYPkU5AdayJBdRWgSPfF+CxqU1xpLR9Vv64ej
         z4IZCSyY8j5ONbhitTvoVeW49MjmpZM0zMTTfwST68ZFm6/T6MdwtY9y5hUoKpQ8+ef2
         9YDzIhR9MUdrB+hdSYhQNmieaxcInoMekOAdNXVEkjnWOzakcg8O+iTEly3MUyNMS+AW
         z/Bg==
X-Gm-Message-State: AOAM532AB/jZQ16g7xFImx0x4uQdNy46rmEcKpvvm0JBdtgX7Rh2QzBi
        uX7KbQ/P0w5HqDcGkfDXFw==
X-Google-Smtp-Source: ABdhPJzjtOvUIWpcut69MQBEfwq0SRBvS1AqqyTdoGC38s86ZgYymSzW5qXFZaSf5cyUwQ+u5DPNUg==
X-Received: by 2002:a05:6830:309b:: with SMTP id f27mr905347ots.118.1611331216532;
        Fri, 22 Jan 2021 08:00:16 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id y24sm1674942oos.44.2021.01.22.08.00.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Jan 2021 08:00:15 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Murali Karicheri <m-karicheri2@ti.com>, netdev@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [RFC PATCH net-next 0/3] add HSR offloading support for DSA switches
Date:   Fri, 22 Jan 2021 09:59:45 -0600
Message-Id: <20210122155948.5573-1-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for offloading HSR/PRP (IEC 62439-3) tag insertion, tag
removal, forwarding and duplication on DSA switches.
This series adds offloading to the xrs700x DSA driver.

Please let me know if you see any issues or anything that should be
discussed before submitting it as a non-RFC patch series. Since
many may not be familiar with HSR/PRP let me know if I omitted anything
in the commit messages which might have seemed obvious to me.

George McCollister (3):
  net: hsr: generate supervision frame without HSR tag
  net: hsr: add DSA offloading support
  net: dsa: xrs700x: add HSR offloading support

 Documentation/networking/netdev-features.rst |  20 +++++
 drivers/net/dsa/xrs700x/xrs700x.c            | 106 +++++++++++++++++++++++++++
 drivers/net/dsa/xrs700x/xrs700x_reg.h        |   5 ++
 include/linux/if_hsr.h                       |  22 ++++++
 include/linux/netdev_features.h              |   9 +++
 include/linux/netdevice.h                    |  13 ++++
 include/net/dsa.h                            |  13 ++++
 net/dsa/dsa_priv.h                           |  11 +++
 net/dsa/port.c                               |  34 +++++++++
 net/dsa/slave.c                              |  13 ++++
 net/dsa/switch.c                             |  24 ++++++
 net/dsa/tag_xrs700x.c                        |   7 +-
 net/ethtool/common.c                         |   4 +
 net/hsr/hsr_device.c                         |  44 ++---------
 net/hsr/hsr_forward.c                        |  37 ++++++++--
 net/hsr/hsr_forward.h                        |   1 +
 net/hsr/hsr_main.c                           |  14 ++++
 net/hsr/hsr_main.h                           |   8 +-
 net/hsr/hsr_slave.c                          |  13 +++-
 19 files changed, 343 insertions(+), 55 deletions(-)
 create mode 100644 include/linux/if_hsr.h

-- 
2.11.0

