Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C531D376DE6
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 02:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbhEHAdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 20:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbhEHAdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 20:33:03 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1368BC061343
        for <netdev@vger.kernel.org>; Fri,  7 May 2021 17:30:07 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id t11-20020a05600c198bb02901476e13296aso5769661wmq.0
        for <netdev@vger.kernel.org>; Fri, 07 May 2021 17:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bVFC/q/a/upY2UrOsFJgBqNHVlwvYKfR2XYvx0H5iRk=;
        b=pw2gOIo3c3Zy3qk4Zufv8rD6JMUSmB1Z8yN7Tm/ycHzDLfUVFKvzBU/sC3Me1mFjqb
         JBGeuOaXJMmBXWAoPefkH5Fcs3XkviDkPl4IpXU9OGNHWLRW4ajPByfqub+HkWeIHM/F
         rKgF/prAkP1yAAYAFetHPlZRhJxpjcw64ldzY8MtPvqnfXzGLpZoGDMjE0tLNarNeiP7
         IiWQxs9vgpJkTFI5ETKLnja1FVAd9iemcmxQGWV0TiSSKNx7GRugty26sLZZALMjhmp8
         J8Z22ZaUepOip9jiKEnEgwTAeSvuO8f4MQP6sUqTQrN9XS2Z9eV1y++7AQq8t8y7JslN
         SEag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bVFC/q/a/upY2UrOsFJgBqNHVlwvYKfR2XYvx0H5iRk=;
        b=V2zNg+CmKnu+yltDcgCCljn7q0BOQ6DkmhJsiyz2L2vXeY9ZoKKV2yqW1h/CqMbCK2
         f9IpeplUjAT5NRtB6xuL5EMgo2HJH7L519sNZCBQ94kE+4qSsMaFzSMWRBvYzSr1QABB
         1QFmBjG1fyl5Nj9fnvYbMh3376PCkRyH27dwUp1FqL36bdV9VGo0vtiwIQTXbwfOjZMd
         v/aa5HS2N0ykQMK1r4tNVE1RYW+V1WI9CWq7KnmygLmXMmbGk6z2YI14+A6+BlpclD8F
         GLk0v3G86mUFsDuZnt38+vmqgkHz+8NnsUQsT0JpimTcFw9r7wi9PWxSYNSj0Gur/XXV
         EOqg==
X-Gm-Message-State: AOAM532MtuqVMnh46nFDWcw5DlkaM63J3uXhLLaL0JEuxAX3Jrj/UoDO
        jcnOtDJa0s5ot9y9HHL9RPg=
X-Google-Smtp-Source: ABdhPJyHWaL6afrdNG/T7zKVGn6b+/8r4dKlLvznznuF77FHPar14zSzkMJZf8frufbInBjIxzZ1Mg==
X-Received: by 2002:a1c:a78b:: with SMTP id q133mr13028392wme.68.1620433805710;
        Fri, 07 May 2021 17:30:05 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id f4sm10967597wrz.33.2021.05.07.17.30.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 17:30:05 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Subject: [RFC PATCH net-next v4 00/28] Multiple improvement to qca8k stability
Date:   Sat,  8 May 2021 02:29:19 +0200
Message-Id: <20210508002920.19945-29-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210508002920.19945-1-ansuelsmth@gmail.com>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently qca8337 switch are widely used on ipq8064 based router.
On these particular router it was notice a very unstable switch with
port not link detected as link with unknown speed, port dropping
randomly and general unreliability. Lots of testing and comparison
between this dsa driver and the original qsdk driver showed lack of some
additional delay and values. A main difference arised from the original
driver and the dsa one. The original driver didn't use MASTER regs to
read phy status and the dedicated mdio driver worked correctly. Now that
the dsa driver actually use these regs, it was found that these special
read/write operation required mutual exclusion to normal
qca8k_read/write operation. The add of mutex for these operation fixed
the random port dropping and now only the actual linked port randomly
dropped. Adding additional delay for set_page operation and fixing a bug
in the mdio dedicated driver fixed also this problem. The current driver
requires also more time to apply vlan switch. All of these changes and
tweak permit a now very stable and reliable dsa driver and 0 port
dropping. This series is currently tested by at least 5 user with
different routers and all reports positive results and no problems.

Changes v4:
- Use iopoll for busy_wait function
- Better describe and split some confusing commits
- Fix bad rgmii delay configurable patch
- Drop phy generic patch to pass flags with phylink_connect_phy
- Add dsa2 patch to declare mdio node in the switch node
- Add dsa patch to permit dsa driver to declare custom get_phys_mii_mask
    Some background about the last 2 patch.
    The qca8k switch doesn't have a 1:1 map between port reg and phy reg.
    Currently it's used a function to convert port to the internal phy reg.
    I added some patch to fix this.
    - The dsa driver now check if the mdio node is present and use the of variant
      of the mdiobus_register
    - A custom phy_mii_mask is required as currently the mask is generated from
      the port reg, but in our case the mask would be different as it should be
      generated from the phy reg. To generalize this I added an extra function
      that driver can provide to pass custom phy_mii_mask.
Changes v3:
- Revert mdio writel changes (use regmap with REGCACHE disabled)
- Split propagate error patch to 4 different patch
Changes v2:
- Implemented phy driver for internal PHYs
  I'm testing cable test functions as I found some documentation that
  actually declare regs about it. Problem is that it doesn't actually
  work. It seems that the value set are ignored by the phy.
- Made the rgmii delay configurable
- Reordered patch
- Split mdio patches to more specific ones
- Reworked mdio driver to use readl/writel instead of regmap
- Reworked the entire driver to make it aware of any read/write error.
- Added phy generic patch to pass flags with phylink_connect_phy
  function

Ansuel Smith (28):
  net: mdio: ipq8064: clean whitespaces in define
  net: mdio: ipq8064: add regmap config to disable REGCACHE
  net: mdio: ipq8064: enlarge sleep after read/write operation
  net: dsa: qca8k: change simple print to dev variant
  net: dsa: qca8k: use iopoll macro for qca8k_busy_wait
  net: dsa: qca8k: improve qca8k read/write/rmw bus access
  net: dsa: qca8k: handle qca8k_set_page errors
  net: dsa: qca8k: handle error with qca8k_read operation
  net: dsa: qca8k: handle error with qca8k_write operation
  net: dsa: qca8k: handle error with qca8k_rmw operation
  net: dsa: qca8k: handle error from qca8k_busy_wait
  net: dsa: qca8k: add support for qca8327 switch
  devicetree: net: dsa: qca8k: Document new compatible qca8327
  net: dsa: qca8k: add priority tweak to qca8337 switch
  net: dsa: qca8k: limit port5 delay to qca8337
  net: dsa: qca8k: add GLOBAL_FC settings needed for qca8327
  net: dsa: qca8k: add support for switch rev
  net: dsa: qca8k: add ethernet-ports fallback to setup_mdio_bus
  net: dsa: qca8k: make rgmii delay configurable
  net: dsa: qca8k: clear MASTER_EN after phy read/write
  net: dsa: qca8k: dsa: qca8k: protect MASTER busy_wait with mdio mutex
  net: dsa: qca8k: enlarge mdio delay and timeout
  net: dsa: register of_mdiobus if a mdio node is declared
  devicetree: net: dsa: Document use of mdio node inside switch node
  net: dsa: qca8k: add support for internal phy
  net: dsa: permit driver to provide custom phy_mii_mask for slave
    mdiobus
  net: dsa: qca8k: pass switch_revision info to phy dev_flags
  net: phy: add qca8k driver for qca8k switch internal PHY

 .../devicetree/bindings/net/dsa/dsa.yaml      |  28 +
 .../devicetree/bindings/net/dsa/qca8k.txt     |   1 +
 drivers/net/dsa/qca8k.c                       | 720 ++++++++++++++----
 drivers/net/dsa/qca8k.h                       |  58 +-
 drivers/net/mdio/mdio-ipq8064.c               |  70 +-
 drivers/net/phy/Kconfig                       |   7 +
 drivers/net/phy/Makefile                      |   1 +
 drivers/net/phy/qca8k.c                       | 172 +++++
 include/net/dsa.h                             |   7 +
 net/dsa/dsa2.c                                |  20 +-
 10 files changed, 894 insertions(+), 190 deletions(-)
 create mode 100644 drivers/net/phy/qca8k.c

-- 
2.30.2

