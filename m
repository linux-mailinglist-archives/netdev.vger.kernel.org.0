Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7DED1DF79D
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 15:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387821AbgEWN1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 09:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387783AbgEWN1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 09:27:22 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 866CEC061A0E
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 06:27:20 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id u1so11273853wmn.3
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 06:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vkX2gAQLIXJ9uj3WUomW1bZyEutKwO7zwPcKUvDNbGs=;
        b=aZv6u+u9OcqamzTM8oSsMQCNupHcwIZaVmUQ/fuDEAEexf93ZxyIIjhx/CDw4aXOgv
         NOPwijbXQXl+FdHr6Gj5klzGzceksP3UAh/tC40uAT6uib99m4ACrWQjfI0LuP1TDWvz
         R+rymcQKGqccVYvw53qMdoLS3UoIPQ63N4laBhqwXtg+r8GnxpHw89Odof1q5alrLC9i
         m1uJD4F8+Sp2as/kHK7dAxCVLkML/rW+rE9amtXsHc+eeINmpPp0wVCw0REwh1uCTivn
         owbwr8iy0v3xnFeZaNjnOMrfR7o9IAhLk9WBAE8IPU+/QUkYsJcKepvoMR0SNAPBPs+8
         mKwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vkX2gAQLIXJ9uj3WUomW1bZyEutKwO7zwPcKUvDNbGs=;
        b=IgtE3BApnLgd26DjUVT0O9+Zt6DdYFdYJUuN81eYPtUaq5COy5+fCp4oo32YeroXGO
         qDjjx3CnG1X7GLsTiO8SPK0/E+z/rGjoJ1QyDC0CDSjQnR5Z8BMVTHUtojD4XJKMFPeX
         NJPn2m8xeHQsyyAeeXv/7wTNVk4c17gLDU9q0Aru3lz7N2ftXYGVnD9ovYbiZXY8NCmI
         Um/8EBPIpEqQy8J0pC6CzuFmzMEym2CTmJf1fi5jaGZfMMj0+guxF+b8T94k6Vk2cykp
         LdiZx6+Liczk0NSF01OSHPmq6BM33tN7sNUDPc1wd99SmHmd0/lGBb9iRxtCXb79f0Ms
         BBVQ==
X-Gm-Message-State: AOAM532sXCgGqYCQ/7nRiLuDsP/b18Lat4vyRBKWCUTcF+FguLn+TTef
        sEsR71rqq/fj3FTPorjc6gVRaw==
X-Google-Smtp-Source: ABdhPJxC8nZI33xT+XlLdoH7IBEbX8XggatVzrK5OwzBh8IMeKhz7+y+q4FCGYH/str1A7VuWBOXaw==
X-Received: by 2002:a05:600c:20ca:: with SMTP id y10mr18295681wmm.126.1590240439200;
        Sat, 23 May 2020 06:27:19 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id g69sm8098703wmg.15.2020.05.23.06.27.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 06:27:18 -0700 (PDT)
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
Subject: [PATCH v2 0/5] net: provide a devres variant of register_netdev()
Date:   Sat, 23 May 2020 15:27:06 +0200
Message-Id: <20200523132711.30617-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

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

v1 -> v2:
- rebase on top of net-next after driver rename, no functional changes

Bartosz Golaszewski (5):
  Documentation: devres: add a missing section for networking helpers
  net: move devres helpers into a separate source file
  net: devres: define a separate devres structure for
    devm_alloc_etherdev()
  net: devres: provide devm_register_netdev()
  net: ethernet: mtk_star_emac: use devm_register_netdev()

 .../driver-api/driver-model/devres.rst        |  5 +
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 17 +---
 include/linux/netdevice.h                     |  2 +
 net/Makefile                                  |  2 +-
 net/devres.c                                  | 95 +++++++++++++++++++
 net/ethernet/eth.c                            | 28 ------
 6 files changed, 104 insertions(+), 45 deletions(-)
 create mode 100644 net/devres.c

-- 
2.25.0

