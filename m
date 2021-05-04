Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42FA9373281
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 00:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233266AbhEDWdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 18:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233489AbhEDWcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 18:32:14 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E427C061347
        for <netdev@vger.kernel.org>; Tue,  4 May 2021 15:30:04 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id i24so12269338edy.8
        for <netdev@vger.kernel.org>; Tue, 04 May 2021 15:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KUAJ+qUJsKFxC40+sC4pRLEBQbI2R1YOPprjQqwepXQ=;
        b=iuU9AzfDP9LszbhJR09QWc/91FvJPzbC3Dj0/Lv4o3lBOZFANhEEV3calwtNwAxZwi
         6A1WYs+GJIY4BZmETVrN4o5CqYFRG3oi4FmD6yfSbWAv+7lbR3zxz1RHAYqgJ1E5jLmZ
         XrykMnr6NvHZsMYhvY9BEjhOo+CzMjEpCcVBD/gGYcanz1I0ewZkk9bLhg+N9Wb9J4Mi
         ksBLsMwhyIqQWKDNgHqDlPXfArZjpuw3li/TKTRkl9BakuOEv+Do/swKknJP23FkjXHI
         oedSFrfVdmFKctM3wg1JGnSzQmzcc6jVuEDhTOnnWwSZ5aVPlbY6qHFIP7ZD1WIkO+Ku
         tAbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KUAJ+qUJsKFxC40+sC4pRLEBQbI2R1YOPprjQqwepXQ=;
        b=k/bdKnbpNgUzYvA4KFXD02sHslTcSxUxJ7uuuPgCk50XIbLTG255Aak9c8VbsXqIee
         b/EFM3mhyjTYrlRrEwr6P0wzjQbYMQWqn8yY82baqyJE6+C1QwFGJIJP78DsRbdQV6w8
         JqCWkMeSmObKC3Kh43/gNAuBNqyzAqy9E/gnsr0UWgI7ZH00Dx5EMLM5hG2a7QZ985jd
         jFp2aPJyw2QrUop4iLJnsBoj2iiZpqPH6i837HZhkiGP2zuScQo2WVr2F6M5q0V+GUm2
         ZXRfn6Ua03ClcMQaV/QF97LiuzSgZEj3qDau88jwQsKuvYyqJeg1f76lhj2ODxhd/Iqv
         CybA==
X-Gm-Message-State: AOAM531MqG+RVgg/pmh0FxyGqewSPIggCmEuVN2EsCT31ArQNvbMBxig
        nifC5SIygB3H8+umEbN5JT0=
X-Google-Smtp-Source: ABdhPJxKhX2IJbP7e5XHse2905QtgvgGQy+OvGAEaAu8oorSscgMU+yDaoH0xEpn5t7s3kIrATM0Nw==
X-Received: by 2002:a50:eb82:: with SMTP id y2mr28309588edr.190.1620167403226;
        Tue, 04 May 2021 15:30:03 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q12sm2052946ejy.91.2021.05.04.15.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 15:30:02 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Subject: [RFC PATCH next-next v3 00/20] Multiple improvement to qca8k stability
Date:   Wed,  5 May 2021 00:29:15 +0200
Message-Id: <20210504222915.17206-21-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210504222915.17206-1-ansuelsmth@gmail.com>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
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

A decision about the extra mdio delay is still to be taken but I
preferred to push a v2 since there is a new driver and more changes than
v0.

Ansuel Smith (20):
  net: mdio: ipq8064: clean whitespaces in define
  net: mdio: ipq8064: add regmap config to disable REGCACHE
  net: mdio: ipq8064: enlarge sleep after read/write operation
  net: dsa: qca8k: handle qca8k_set_page errors
  net: dsa: qca8k: handle error with qca8k_read operation
  net: dsa: qca8k: handle error with qca8k_write operation
  net: dsa: qca8k: handle error with qca8k_rmw operation
  net: dsa: qca8k: add support for qca8327 switch
  devicetree: net: dsa: qca8k: Document new compatible qca8327
  net: dsa: qca8k: add priority tweak to qca8337 switch
  net: dsa: qca8k: add GLOBAL_FC settings needed for qca8327
  net: dsa: qca8k: add support for switch rev
  net: dsa: qca8k: make rgmii delay configurable
  net: dsa: qca8k: clear MASTER_EN after phy read/write
  net: dsa: qca8k: dsa: qca8k: protect MASTER busy_wait with mdio mutex
  net: dsa: qca8k: enlarge mdio delay and timeout
  net: phy: phylink: permit to pass dev_flags to phylink_connect_phy
  net: dsa: slave: pass dev_flags also to internal PHY
  net: dsa: qca8k: pass switch_revision info to phy dev_flags
  net: phy: add qca8k driver for qca8k switch internal PHY

 .../devicetree/bindings/net/dsa/qca8k.txt     |   1 +
 drivers/net/dsa/qca8k.c                       | 602 ++++++++++++++----
 drivers/net/dsa/qca8k.h                       |  54 +-
 drivers/net/ethernet/cadence/macb_main.c      |   2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |   2 +-
 drivers/net/mdio/mdio-ipq8064.c               |  58 +-
 drivers/net/phy/Kconfig                       |   7 +
 drivers/net/phy/Makefile                      |   1 +
 drivers/net/phy/phylink.c                     |  12 +-
 drivers/net/phy/qca8k.c                       | 174 +++++
 include/linux/phylink.h                       |   2 +-
 net/dsa/slave.c                               |   6 +-
 12 files changed, 756 insertions(+), 165 deletions(-)
 create mode 100644 drivers/net/phy/qca8k.c

-- 
2.30.2

