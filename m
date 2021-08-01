Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0743DC917
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 02:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbhHAA3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 20:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbhHAA3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 20:29:50 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823EFC06175F
        for <netdev@vger.kernel.org>; Sat, 31 Jul 2021 17:29:43 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id x8so12999237lfe.3
        for <netdev@vger.kernel.org>; Sat, 31 Jul 2021 17:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S67hehFlo6jNmyu9sCArVSk1h4BF7dXPWzKi3QXXG5A=;
        b=baqvwAdMuin2lfIlAYqI+j5JldfRWaK8iP7WJl3RcGWejKRMqgCIGvcwmXHym8TV96
         /J8X/y0tVcV5zZd6r4LRpkilOfOxPIwzBpdyqhau5rH+G0sbFP+ddi6HmVnm17xu2BG4
         +kLGfjktbUdv7BO3e+qfPkq+jiIzHSNkkkwzP7QjM+iSoXVIlKrJ3wsOPSPxDhJ6mplw
         25LfeDCB5RJ7O2c+ORLvIGeBfGc1uUgFXVUHNB+Zi4unfReNVyWp/mM1l5NHNBirPUfn
         WkBdFB7zFtjLKKPeSPpSKxj6UyNAXc0OTgXIsaWoKTp1KWEqipLuz0nQMK4ou+k8bOv6
         OsmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S67hehFlo6jNmyu9sCArVSk1h4BF7dXPWzKi3QXXG5A=;
        b=KIpn8ubbrvujusNobTv/QG6uhxS9nMZEMlmWHyYrgUrmjr4Xaj1YstYUtp2AOnvyf9
         2mFoW1q4pgKJl6BC7NLe/RK2J0V/mMMCeroTF/kAdncHVnnWbzc6OmXNzEA/p3OKvoYp
         W48K3YfazV9DACHlzIB3o89jW4Z/RspUttbltDmRRUs1/MHRfC2JwQ1E3Yop8hbOK8eC
         ShBfDD/ulkeFMF0jA0JyO/7ub2hoB9Gm1zVm0l3g07pq7d7y1//KuwTULJQKhhJSNV5b
         s4kP1+T6L7TKxVaetCY/IOXV2iNqCLGzK1vse8giA2ws41eCzDTgDHyYdcD0/pnGgUEg
         684w==
X-Gm-Message-State: AOAM531pIa89UOLUNf6tUGx1G+IzAHRzl+GG13xS/fU/Dojosvh9nH7k
        YBO1EmU1BjnSAjVQCIImn+5bmbQi46yotw==
X-Google-Smtp-Source: ABdhPJyZcRDPyOetNlUhgfFBrsodW0Pyq9ZsBua9b0UdrGwAgSG8robscr4a0yS6F8khEOAcRgNW2Q==
X-Received: by 2002:a05:6512:3593:: with SMTP id m19mr2442257lfr.389.1627777781744;
        Sat, 31 Jul 2021 17:29:41 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id r6sm485255ljk.76.2021.07.31.17.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 17:29:41 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Imre Kaloz <kaloz@openwrt.org>, Krzysztof Halasa <khalasa@piap.pl>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 0/6] IXP46x PTP Timer clean-up and DT
Date:   Sun,  1 Aug 2021 02:27:31 +0200
Message-Id: <20210801002737.3038741-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a combination of a few cleanups from Arnd and some cleanup
and device tree support work from me, together modernizing the
PTP timer for the IXP46x platforms.

Arnd Bergmann (3):
  ixp4xx_eth: make ptp support a platform driver
  ixp4xx_eth: fix compile-testing
  ixp4xx_eth: enable compile testing

Linus Walleij (3):
  ixp4xx_eth: Stop referring to GPIOs
  ixp4xx_eth: Add devicetree bindings
  ixp4xx_eth: Probe the PTP module from the device tree

 .../bindings/net/intel,ixp46x-ptp-timer.yaml  |  54 ++++++++
 arch/arm/mach-ixp4xx/common.c                 |  14 ++
 drivers/net/ethernet/xscale/Kconfig           |  11 +-
 drivers/net/ethernet/xscale/Makefile          |   6 +-
 drivers/net/ethernet/xscale/ixp46x_ts.h       |  13 +-
 drivers/net/ethernet/xscale/ixp4xx_eth.c      |  35 +++--
 drivers/net/ethernet/xscale/ptp_ixp46x.c      | 122 +++++++++---------
 7 files changed, 175 insertions(+), 80 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/intel,ixp46x-ptp-timer.yaml

-- 
2.31.1

