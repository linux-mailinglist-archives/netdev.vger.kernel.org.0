Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8AFC3EBE1E
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 00:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235117AbhHMWCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 18:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234831AbhHMWCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 18:02:46 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1941EC061756
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 15:02:19 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id r9so13060256lfn.3
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 15:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ezoHcZbnVdbBFAFAIeqVBHpcFgPMwDczmJ+Z8xem0fk=;
        b=TuG0y9uxxcrZptl7itfSV8ytb3pWspxh48g5LQKf7vd86IhQ2Z6zBhh0XGvnsJXmb+
         yjETck9G0GcK/LSwY64xh1UYJV4TvvHvKiezoem0uypIixKBNhZ7hwXZBJgvSWM3LUOw
         9l3KVcWt/0csE/2FLi80K+2k13IfS3A5dfWDnvbv8TvF0FToPRpFvpUkVzpuHqE9QGrU
         HOgjZNR6GUX7lDuRzXTCAlcZhtnfma6fzHHLltKAWBpRXUbuLpEY3iH0muUAT6b6Y+wd
         mQQChk2A+dwOGJXvyN5JDrTbTj/EHKOFrNyOy5IaodK07w3hK8VqsqQ8o2ZVd0sOY79q
         VMGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ezoHcZbnVdbBFAFAIeqVBHpcFgPMwDczmJ+Z8xem0fk=;
        b=bO0mtg5XyZudA2GWUthhTt4CSvVzCosKztJNZu41N2lepMchFj0PY4XRFHM1kQsPkG
         Lz52HAsiel3p4TqXaZxNPydiRUNBblWOvO+Hf6ubyAx0YqQ+ndu66zD480YbtSAtVP+M
         Z/0BQdINhYB/bUHrBLKkwvaxQY3e/G6KpvAgUnWOdUwqaqYyoGSphTzON3hdJK1UhhJl
         5QMqtPszzypBu7pxuLQKUnHCK7bLv6MAKAPrEOVG/M93Ngw/Ejq/dT+UjxG0xWrHlXHw
         4JWFqK2LexvfRB2BXY5G0QG/0ZcipwqdyX4/PSqBAzsLzi3t/lmQ03+74wIZ1EcSxsKt
         C55g==
X-Gm-Message-State: AOAM532ZgXn1YzubGmCnhPSj3Hb5iG3pF76RJpYuDIJAUKto9ANRc2j8
        nbF1w1KeqjyuLwJJnTI0bkqBICHpUYA/Zg==
X-Google-Smtp-Source: ABdhPJzs2Ey1rDsqiJ9AMxrO2eYUgJi4NsQIRfN23hUhHs8oDyV1/01AGsSgmPOC0xe1hsg9Xh0svw==
X-Received: by 2002:a05:6512:2296:: with SMTP id f22mr3072375lfu.248.1628892137334;
        Fri, 13 Aug 2021 15:02:17 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id s17sm274912ljp.61.2021.08.13.15.02.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 15:02:17 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Imre Kaloz <kaloz@openwrt.org>, Krzysztof Halasa <khalasa@piap.pl>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 0/6 v2] IXP46x PTP Timer clean-up and DT
Date:   Sat, 14 Aug 2021 00:00:05 +0200
Message-Id: <20210813220011.921211-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a combination of a few cleanups from Arnd and some cleanup
and device tree support work from me, together modernizing the
PTP timer for the IXP46x platforms.

ChangeLog v1->v2:

This is now rebased on net-next and the upstream kernel should
contain fixes for the issues found by the build robot.

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

