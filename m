Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F9F368A83
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 03:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240007AbhDWBsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 21:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235302AbhDWBsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 21:48:30 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C9FC061574;
        Thu, 22 Apr 2021 18:47:53 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id s15so55735781edd.4;
        Thu, 22 Apr 2021 18:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4Pnkgz0fTAFmO6ZX7bVI46yKfVJfz4qErV1BxeztbGs=;
        b=ZQMwZwsd9af3osmmbvfui9hh6lA8XlKO3FXDmY9g5a/xIWwlyw0ns+Gjl4C8qoTZOl
         XgBRxM39NkPozwJ3wArUndj2qZlirdTfF5xFFDsIQQZrv59jsiV35vrSO6lR/kmGOMlh
         aSPonshqU+R+uGoPTt/4P9XBmn51JGp/jLA30qF9ccFPLpkuXgHsLd0mA7qZUyatrATy
         54uNCoCtqqf99wYaVkb/G4DnHZWFTxkUeLJiBfy8mdKB0z872i5ECA6AqHp/VmrikoOz
         nGZd/3Qh2LzVZScWgr+k0p+5uUHcuNEY1ExvvqCBaC4zdPvZn0kwyuo5Y968VxBS//pD
         02Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4Pnkgz0fTAFmO6ZX7bVI46yKfVJfz4qErV1BxeztbGs=;
        b=ZTiOxB0eFPHng+HIUY2Go3cNXNNydvIIOjJdy5lUR8QeQ8dBW8KGL75OHdrkbLow6F
         iOTqWa9By2L5xpDEFgOVseY/P/DM7fCBBSBdSPBl6qG1HbsXOt9yjM6JxrIffxxcq0/3
         B+oa2zAa80BCAhKRRcY+LJofh8zpO/ddQFtbzWoLB7MXN1Dcjzl6RKjRmKECDk6FLtLY
         WHxWt8zCxzJvqD4ecHEEP2UiphGbuvgXOtFr1S7FXE4IKr3BM2xFc+27ra6vJAf8bQPp
         qXVax/YYo74Yl5qr3h2GAtG4HCFAGtTOLCf9wjymuxtYAVPIsccRJF/INinDbG9n93Fa
         KZDA==
X-Gm-Message-State: AOAM531qPBAt07IPszgqugI559Dy73eMWIkcmpYWb5cWlBEkgnzYcaXI
        gGaQGtkC42uJSKfuZ93K17A=
X-Google-Smtp-Source: ABdhPJxWfoag/IE8o2tQjxSFph5zTEvS4YZdmJM7L+qYNaIRMwpx3sgCLjRUUxO8KdAwae3TrT1VSA==
X-Received: by 2002:aa7:cd83:: with SMTP id x3mr1499644edv.373.1619142471646;
        Thu, 22 Apr 2021 18:47:51 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id t4sm3408635edd.6.2021.04.22.18.47.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 18:47:51 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/14] Multiple improvement to qca8k stability
Date:   Fri, 23 Apr 2021 03:47:26 +0200
Message-Id: <20210423014741.11858-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
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

Ansuel Smith (14):
  drivers: net: dsa: qca8k: handle error with set_page
  drivers: net: dsa: qca8k: tweak internal delay to oem spec
  drivers: net: mdio: mdio-ip8064: improve busy wait delay
  drivers: net: dsa: qca8k: apply suggested packet priority
  drivers: net: dsa: qca8k: add support for qca8327 switch
  devicetree: net: dsa: qca8k: Document new compatible qca8327
  drivers: net: dsa: qca8k: limit priority tweak to qca8337 switch
  drivers: net: dsa: qca8k: add GLOBAL_FC settings needed for qca8327
  drivers: net: dsa: qca8k: add support for switch rev
  drivers: net: dsa: qca8k: add support for specific QCA access function
  drivers: net: dsa: qca8k: apply switch revision fix
  drivers: net: dsa: qca8k: clear MASTER_EN after phy read/write
  drivers: net: dsa: qca8k: protect MASTER busy_wait with mdio mutex
  drivers: net: dsa: qca8k: enlarge mdio delay and timeout

 .../devicetree/bindings/net/dsa/qca8k.txt     |   1 +
 drivers/net/dsa/qca8k.c                       | 256 ++++++++++++++++--
 drivers/net/dsa/qca8k.h                       |  54 +++-
 drivers/net/mdio/mdio-ipq8064.c               |  36 ++-
 4 files changed, 304 insertions(+), 43 deletions(-)

-- 
2.30.2

