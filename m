Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D917E42F9C2
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 19:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237969AbhJORMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 13:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232244AbhJORMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 13:12:50 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80DEFC061570
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 10:10:43 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id y12so42372514eda.4
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 10:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zv/bK6mv5i9aibqrnGxAb4uWDtguEVNXq1Vv1S231L0=;
        b=LADuMVCO4xqEnY8XtfY68QPmh0j4u+jmRzAyhCsS7/cjP1R152zUQDgbrOVo2G8pQ3
         rvfwlwkfbr9bPBeXVcIQDcCVFXRj+8pY0xRg172AKBcp9jiJ94ULiZXH/P8Mm6aRwpo3
         6dEn7iaP5bKaRw+Chd53ENoCCnLzle36KX950=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zv/bK6mv5i9aibqrnGxAb4uWDtguEVNXq1Vv1S231L0=;
        b=RlEqtqdcg++bcyrXh4obcmYCUKZH29pn6bS43zrQHwG0Yb/J+GHUVQpdM//1UeZL57
         d6t2pyrr3LFgKjoYPQnf1pyIFnfP6MdPQOUumHeus8PjmgnTbuqgNz+nzbUV8MqdtJA9
         NMVqybjRWXZV2vp5tkUvG3ZEhR3HTg6/KYcgYj3oOsJme33HsBdO7mAoHojCVNcLIhz9
         jsZnE52JJuKv8OUALVFUiXLVyN57YpqyRukeubHYe3QinmzJj+jZ55bGo2kfdfnrOB3s
         uemsrP9h2ZfzB9P6x10l8YSXj5qd2njjR+vvtLF/Zb+lr2vWUbTnYl5+IBiJfIm1qGeX
         wylg==
X-Gm-Message-State: AOAM532KZ3Uy1nuxweHLVLNIXHPPoT5bprn3Na8RN5whY+IO+gm6mIX2
        D4nib/61iVKU0I8q+OFZWsaxJvh5U95sgA==
X-Google-Smtp-Source: ABdhPJzh4WyZ9nyjsvpOmA2Zw1S4wU5DwOqcpKJNaooxezl70aeeyc/j806OAfKkDZOoNJ7WrdRaEg==
X-Received: by 2002:a05:6402:4250:: with SMTP id g16mr19339439edb.26.1634317842088;
        Fri, 15 Oct 2021 10:10:42 -0700 (PDT)
Received: from capella.. (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id jt24sm4735792ejb.59.2021.10.15.10.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 10:10:41 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next 0/7] net: dsa: add support for RTL8365MB-VC
Date:   Fri, 15 Oct 2021 19:10:21 +0200
Message-Id: <20211015171030.2713493-1-alvin@pqrs.dk>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

This series adds support for Realtek's RTL8365MB-VC, a 4+1 port
10/100/1000M Ethernet switch. The driver - rtl8365mb - was developed by
Michael Ramussen and myself.

This version of the driver is relatively slim, implementing only the
standalone port functionality and no offload capabilities. It is based
on a previous RFC series [1] from August, and the main difference is the
removal of some spurious VLAN operations. Otherwise I have simply
addressed most of the feedback. Please see the respective patches for
more detail.

In parallel I am working on offloading the bridge layer capabilities,
but I would like to get the basic stuff upstreamed as soon as possible.

v2 -> v2:
  - move IRQ setup earlier in probe per Florian's suggestion
  - fix compilation error on some archs due to FIELD_PREP use in v1
  - follow Jakub's suggestion and use the standard ethtool stats API;
    NOTE: new patch in the series for relevant DSA plumbing
  - following the stats change, it became apparent that the rtl8366
    helper library is no longer that helpful; scrap it and implement
    the ethtool ops specifically for this chip

v1 -> v2:
  - drop DSA port type checks during MAC configuration
  - use OF properties to configure RGMII TX/RX delay
  - don't set default fwd_offload_mark if packet is trapped to CPU
  - remove port mapping macros
  - update device tree bindings documentation with an example
  - cosmetic changes to the tagging driver using FIELD_* macros

[1] https://lore.kernel.org/netdev/20210822193145.1312668-1-alvin@pqrs.dk/

Alvin Šipraga (7):
  ether: add EtherType for proprietary Realtek protocols
  net: dsa: allow reporting of standard ethtool stats for slave devices
  net: dsa: move NET_DSA_TAG_RTL4_A to right place in Kconfig/Makefile
  dt-bindings: net: dsa: realtek-smi: document new compatible rtl8365mb
  net: dsa: tag_rtl8_4: add realtek 8 byte protocol 4 tag
  net: dsa: realtek-smi: add rtl8365mb subdriver for RTL8365MB-VC
  net: phy: realtek: add support for RTL8365MB-VC internal PHYs

 .../bindings/net/dsa/realtek-smi.txt          |   87 +
 drivers/net/dsa/Kconfig                       |    1 +
 drivers/net/dsa/Makefile                      |    2 +-
 drivers/net/dsa/realtek-smi-core.c            |    4 +
 drivers/net/dsa/realtek-smi-core.h            |    1 +
 drivers/net/dsa/rtl8365mb.c                   | 1981 +++++++++++++++++
 drivers/net/phy/realtek.c                     |    8 +
 include/net/dsa.h                             |    8 +
 include/uapi/linux/if_ether.h                 |    1 +
 net/dsa/Kconfig                               |   20 +-
 net/dsa/Makefile                              |    3 +-
 net/dsa/slave.c                               |   34 +
 net/dsa/tag_rtl8_4.c                          |  185 ++
 13 files changed, 2326 insertions(+), 9 deletions(-)
 create mode 100644 drivers/net/dsa/rtl8365mb.c
 create mode 100644 net/dsa/tag_rtl8_4.c

-- 
2.32.0

