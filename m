Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACB6129C08
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 18:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390731AbfEXQUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 12:20:32 -0400
Received: from mail-lf1-f54.google.com ([209.85.167.54]:41259 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389588AbfEXQUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 12:20:32 -0400
Received: by mail-lf1-f54.google.com with SMTP id d8so7577356lfb.8
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 09:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hvZ6fxFBO47PjH65Gpr3+W3352NyyTt1SMOx+Km6tTk=;
        b=j8HpfpNL7dYcUrFGJGskxvtZnkWE2mQwJEdDLV1qI4amSVemWzLD6AYqUw2kseanKw
         s+0hR7BYtUaNhwv0gQ5GdopRmdExLH3Zd/vDIuGao2U9wfY2pZMEOUk6HqAsc92wDryV
         MtnYLaOIOn4CGiG4SS10rtnjHmGN5SXaN+x0rsnxYDRaOKuvQObJe9vKgP5q1oCr/NMt
         eag6yyH9cWoCv/Yo8b5m58729Q0Wlu+wqGONM+MurkC4QMAxCtETu7jPGgM8VggvYmCW
         NmZtQdiE9KSnoOuHl68KPlEo7HKF6d0KLWCz9p59NCw1HJZpLKhEEyq8C+eyY6Pvp5X9
         LtNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hvZ6fxFBO47PjH65Gpr3+W3352NyyTt1SMOx+Km6tTk=;
        b=SGaD01Wd6lUKzAshDQ3omo/oB718ETTDAh8qEYEznB9Jd5XJdEyYYK3aAS695smPR4
         +VJMKW9u7Xry2UK0j7VXckSaZPn12kInEpcBlZ+Gj7oNjXonbmtKAExJkvwbFm7JACdQ
         opioonG6N5QmZlLh7pmLtJGMf6Gi5+1R41MdjulXzb2t7NVv3VhG3Vvo5VMNyykHx8Oj
         MaubOlDf3sBjSiDA09ctKJtANvFOTnblPL86i/EID/acApmLHyEKh1q0z9B3bTp/63kg
         rfa60llL7USmAvY8orBo357KrQ4QUHbnISjEwSl8sfZgYPzEdAIx/SWmwfNvxllHJ1bX
         ADmQ==
X-Gm-Message-State: APjAAAVirnCqBRmhvrjha6xyzIslFhFmyEJZScthIJjyzMfI40M+5Krq
        4ZIVUPI6SKD+VybDoQXbIE3oj7OdVHU=
X-Google-Smtp-Source: APXvYqxCvHpgfDSeLSElqXzMuh4m4W9qM94hJ4ywiFC+gya6f4U6+2ZzGQYi1UJAZKutzOXVRudEVg==
X-Received: by 2002:ac2:4a6e:: with SMTP id q14mr14803412lfp.46.1558714830475;
        Fri, 24 May 2019 09:20:30 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-d2cd225c.014-348-6c756e10.bbcust.telenor.se. [92.34.205.210])
        by smtp.gmail.com with ESMTPSA id y4sm618075lje.24.2019.05.24.09.20.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 May 2019 09:20:29 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Krzysztof Halasa <khalasa@piap.pl>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 0/8] Xscale IXP4xx ethernet refurbishing
Date:   Fri, 24 May 2019 18:20:15 +0200
Message-Id: <20190524162023.9115-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are switching the IXP4xx architecture to use device tree
so this patch set makes is possible to probe the ethernet from
the device tree.

We will delete the non-devicetree code path once all peripherals
are working with device tree and all boards are converted
over.

Linus Walleij (8):
  net: ethernet: ixp4xx: Standard module init
  net: ethernet: ixp4xx: Use distinct local variable
  net: ehernet: ixp4xx: Use devm_alloc_etherdev()
  ARM/net: ixp4xx: Pass ethernet physical base as resource
  net: ethernet: ixp4xx: Get port ID from base address
  net: ethernet: ixp4xx: Use parent dev for DMA pool
  net: ethernet: ixp4xx: Add DT bindings
  net: ethernet: ixp4xx: Support device tree probing

 .../bindings/net/intel,ixp4xx-ethernet.yaml   |  53 ++++
 arch/arm/mach-ixp4xx/fsg-setup.c              |  20 ++
 arch/arm/mach-ixp4xx/goramo_mlr.c             |  20 ++
 arch/arm/mach-ixp4xx/ixdp425-setup.c          |  20 ++
 arch/arm/mach-ixp4xx/nas100d-setup.c          |  10 +
 arch/arm/mach-ixp4xx/nslu2-setup.c            |  10 +
 arch/arm/mach-ixp4xx/omixp-setup.c            |  20 ++
 arch/arm/mach-ixp4xx/vulcan-setup.c           |  20 ++
 drivers/net/ethernet/xscale/ixp4xx_eth.c      | 245 +++++++++++-------
 9 files changed, 321 insertions(+), 97 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml

-- 
2.20.1

