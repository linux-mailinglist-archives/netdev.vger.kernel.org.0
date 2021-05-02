Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBD4370FAA
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 01:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbhEBXKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 19:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232628AbhEBXI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 19:08:28 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DD8C06138E
        for <netdev@vger.kernel.org>; Sun,  2 May 2021 16:07:36 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id y26so4292271eds.4
        for <netdev@vger.kernel.org>; Sun, 02 May 2021 16:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AVRK6rDw0HAKRUaSyc4SRgJocC+PbJLDYnd+ncbat3s=;
        b=V3kPFNzyuy0yo9Yya9m6XmQcHZgLhJmpjIoQfpIY9ssP4jkVJkudDGYKScAfMHHvZ6
         8q+a5U5lW/ruXgU8tK1UGlaf/u+xIkoRjIbFcnSOV9Eog7NRG+AkdWPDaBTpf8G0r0tK
         ViVIlghMVdygJ7wSYWRMOujIr6ZOeUj4APJnpPeDF/t8gPmPpvoNKfNlF2xrH6w4NhtE
         k4Z92NwtSE8Bg+xtNaeuw1LENW8AenLeaeMosGHG3EKkXLJ71H9HLtuiIG6kYaDcyQoj
         uO8ml21iDctVNYZ4JY6EPflvt1/0E0o/bO0bZcgWcx7kVl459Xxi3iQqVA9OmfG5H2CV
         swfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AVRK6rDw0HAKRUaSyc4SRgJocC+PbJLDYnd+ncbat3s=;
        b=J+2vzmqqHWuZwDMjskheitnnhrqKjqVFbM2Docv/XzRo7mAN3F8iSk+sMWKsS3vdnd
         z1PiCGBnI6h9OC0WyNyzWlRF6LAqJ8YzKWchfUNht/HU37xGKWacG3a5j35fQoLyotOU
         6Nox4mzNXiHDxHuhsstgpr/BfJzuJadTxu2dP5gq+ddEph4bqT6YlCEdDIpuWRm5B4qj
         +3rbqSomtlIjYe8NpF05opRADW4H7TRslZZ5sOgOgq6SwMQiLyJVcoIrnt/+1sGfmgv5
         L/J0A1LjylphzGMup4LinyhSeOHPDVsKORCg8HH3n+EAY8Wc5wl+qcFf6i4JNW1gqxAg
         F+/g==
X-Gm-Message-State: AOAM533XMDrVR2AEg5y/Mv+5hBiY2kwlX2M2hgoEqPqihi/sFntCr0tc
        nH4YD0utLfhxLAgzSRq2ZMcz1IIhC/NEDg==
X-Google-Smtp-Source: ABdhPJwLZIZ8RiH2IETbnd+vwjU72wKj/HGUUd0y99xXlr61x7D4UaZhnDyZMhm2vw5tTi+tFQCJRg==
X-Received: by 2002:a05:6402:26ce:: with SMTP id x14mr11377415edd.216.1619996854760;
        Sun, 02 May 2021 16:07:34 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id z17sm10003874ejc.69.2021.05.02.16.07.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 May 2021 16:07:34 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Subject: [RFC PATCH net-next v2 00/17] Multiple improvement to qca8k stability
Date:   Mon,  3 May 2021 01:07:10 +0200
Message-Id: <20210502230710.30676-18-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502230710.30676-1-ansuelsmth@gmail.com>
References: <20210502230710.30676-1-ansuelsmth@gmail.com>
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

Ansuel Smith (17):
  net: mdio: ipq8064: clean whitespaces in define
  net: mdio: ipq8064: switch to write/readl function
  net: mdio: ipq8064: enlarge sleep after read/write operation
  net: dsa: qca8k: rework read/write/set_page to provide error
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
 drivers/net/dsa/qca8k.c                       | 649 ++++++++++++++----
 drivers/net/dsa/qca8k.h                       |  54 +-
 drivers/net/ethernet/cadence/macb_main.c      |   2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |   2 +-
 drivers/net/mdio/mdio-ipq8064.c               |  64 +-
 drivers/net/phy/Kconfig                       |   7 +
 drivers/net/phy/Makefile                      |   1 +
 drivers/net/phy/phylink.c                     |  12 +-
 drivers/net/phy/qca8k.c                       | 174 +++++
 include/linux/phylink.h                       |   2 +-
 net/dsa/slave.c                               |   6 +-
 12 files changed, 772 insertions(+), 202 deletions(-)
 create mode 100644 drivers/net/phy/qca8k.c

-- 
2.30.2

