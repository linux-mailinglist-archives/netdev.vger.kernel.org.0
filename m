Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B9F1DB207
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 13:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgETLoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 07:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgETLoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 07:44:24 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2FCC061A0E
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 04:44:23 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id n18so2517464wmj.5
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 04:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6UO8846LBADOFjPscf273ixSDXaAAOc6agORXCpe8H8=;
        b=iA7PIL9mvAGiJIzT2Pq6EhZQNK50yl9l6lgYY6TkjfmiyQO+FovVbAOv/7wzEq+1X9
         mk2kx8kVrndLXYGlYRob3K37sWxWbqbnI8GWDIJLCTr5oUVIejD7J+mx3gMpB4DTpKoA
         FaRG8wrpDNLkbm99XKF5izs/ettSvwFAAZmYaIAIsUjyqyNHUMtk4Qx46M6ANLR+w5F6
         ezbE69fQTXSyyZKnlQbLkm9Hz8B7xUbu2oIoAQM7RfA9ZciAbdiNho0I/X5IwEbO3PFa
         0jKUay9jsKzznzMRBfuWpuhc5UJyj2/R8Ql6/EQ+pOSBZzl4zjCE2czpVX94eI+feqOM
         A9+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6UO8846LBADOFjPscf273ixSDXaAAOc6agORXCpe8H8=;
        b=oyrzw5mZoJte3gDFNKwMZivAZfpYv2y4jlJbYyNF/k1LsUZXKx2ZepCffunDi7+tnZ
         L33TbOMnksl9sYaBT53yT9K97lP95tje3WrgwHxKfPsiZSBuahisYxIZDhYyQ4MBXkZ4
         kCWZUsha9KvMSgd7RpCExZu/bn2JQ2Khp9+x9uneW2oa73nDZQeGWmf/yYs31yyId4Am
         hFgVP9oufCLDLkYMEITs1yPFmUIYplJw+ou8IvidIu3lflLPUVQWZxP1y1S9rcYBFqjI
         0eR9PzU/8FehKWqS35lmnRFJdtVXI3gOb3GmD4iJhnNQBZvT1pOsFmWon0Z13guc6fzW
         2d1A==
X-Gm-Message-State: AOAM530Jueu0NNTmqQpaplpjpob8cYLKT+Vt4kp8oD0Za/K15VKj3CN3
        hmS5ik9mlMpCgrnRUGKsmYSj7g==
X-Google-Smtp-Source: ABdhPJzM9bN56A7SVl3pNrO/Ahl7zhy4npY69zCHarKqOc0WKvc7Va3/fmdS0rKJeLhFamtGgdLgcQ==
X-Received: by 2002:a05:600c:147:: with SMTP id w7mr4321322wmm.89.1589975062340;
        Wed, 20 May 2020 04:44:22 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id q2sm2530782wrx.60.2020.05.20.04.44.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 04:44:21 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Jonathan Corbet <corbet@lwn.net>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Edwin Peer <edwin.peer@broadcom.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 0/5] net: provide a devres variant of register_netdev()
Date:   Wed, 20 May 2020 13:44:10 +0200
Message-Id: <20200520114415.13041-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

This series applies on top of my mtk-eth-mac series[1].

Using devres helpers allows to shrink the probing code, avoid memory leaks in
error paths make sure the order in which resources are freed is the exact
opposite of their allocation. This series proposes to add a devres variant
of register_netdev() that will only work with net_device structures whose
memory is also managed.

First we add the missing documentation entry for the only other networking
devres helper: devm_alloc_etherdev().

Next we move devm_alloc_etherdev() into a separate source file.

We then use a proxy structure in devm_alloc_etherdev() to improve readability.

Last: we implement devm_register_netdev() and use it in mtk-eth-mac driver.

[1] https://lkml.org/lkml/2020/5/20/507

Bartosz Golaszewski (5):
  Documentation: devres: add a missing section for networking helpers
  net: move devres helpers into a separate source file
  net: devres: define a separate devres structure for
    devm_alloc_etherdev()
  net: devres: provide devm_register_netdev()
  net: ethernet: mtk_eth_mac: use devm_register_netdev()

 .../driver-api/driver-model/devres.rst        |  5 +
 drivers/net/ethernet/mediatek/mtk_eth_mac.c   | 17 +---
 include/linux/netdevice.h                     |  2 +
 net/Makefile                                  |  2 +-
 net/devres.c                                  | 95 +++++++++++++++++++
 net/ethernet/eth.c                            | 28 ------
 6 files changed, 104 insertions(+), 45 deletions(-)
 create mode 100644 net/devres.c

-- 
2.25.0

