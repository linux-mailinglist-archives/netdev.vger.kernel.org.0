Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C96E25A1BD
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 00:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgIAW7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 18:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbgIAW7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 18:59:18 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F67FC061244;
        Tue,  1 Sep 2020 15:59:18 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id c142so1710825pfb.7;
        Tue, 01 Sep 2020 15:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4jS/NdDL0jR/GxH0UkvOA/rOyTppb7860U24VxNbz6Q=;
        b=Cu1gz2rkND3wStNEAaro1bXjDG6xSAkEJfJIQBs3jdEQMihqqKaHKWQaHmqrGtnbRS
         v4D7eDKaiBX90mJPQi89whPu2j4CS3XOECvP3sP7K0UBInjBlHet8l84Ea9YMcz+xOpW
         FFDucObCAKdiP7+U3hKLU8HPvIxFEuUHr7/FRb1cnlWM3dZ+sinxGPNa/jxKRDKCkjZE
         2tFWJyFUjkslh+ZVz/VwOnpsz3sqM+EFtimGonKDdc/GR+xk9vqt3ft4bugOGXvCQwIN
         qr0uvCprK72UU5MF+W1JxotEExi8UK0DRS5i25SUvwEEdk/vCHoxOxSCeR4YSoimE/7r
         4q1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4jS/NdDL0jR/GxH0UkvOA/rOyTppb7860U24VxNbz6Q=;
        b=XkCIRbMump2E2XmrFj9SXTky9SA3mlZ8uH+NaFuc/m1oeSvrByUO32BuCpr728S0WG
         Xci4wg20Gc/vGd1fsySw87XAhzYR922r09+RYc5nLA3rGWY9LJAjAoSKdVtgxn92a1ni
         fJT41Ag/u87ykygjJvPOztmhnJso05QeyxsL5YREPPGfqPh2AxJdgeZkC7tdVqE6Wldd
         Gnga3q9SSDM6ZNyh1WW0EHB9pdOfVK4Pemdn3KCMbofLU0G4TQKFJcBJtvOTcUYcQTHQ
         jYPi733pafDGubI9Qn5QfBhUvAtGUccrytZ3cvIPQc/CkbHj4Jcrcu6RDkc6+hVFEGtT
         nRvg==
X-Gm-Message-State: AOAM530aNHaYQJyh54Hb3Mu2VpVSG/bNBELTFIZMYJFvIfmAUwLP2LnD
        Nk6LagDd4NLQ/eLk9pDIqs2Ktn7CMQ0=
X-Google-Smtp-Source: ABdhPJzMpLjTU5htMiK2FZlKuyLiFPYwhEW98jAI2f+GW+NM7agnDAiIJJ38Stc7XeofN9qZOzE04Q==
X-Received: by 2002:a63:754:: with SMTP id 81mr3321778pgh.435.1599001157605;
        Tue, 01 Sep 2020 15:59:17 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m188sm2952750pfm.220.2020.09.01.15.59.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 15:59:16 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 0/3] net: dsa: bcm_sf2: Clock support
Date:   Tue,  1 Sep 2020 15:59:10 -0700
Message-Id: <20200901225913.1587628-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

This patch series adds support for controlling the SF2 switch core and
divider clock (where applicable).

Florian Fainelli (3):
  dt-bindings: net: Document Broadcom SF2 switch clocks
  net: dsa: bcm_sf2: request and handle clocks
  net: dsa: bcm_sf2: recalculate switch clock rate based on ports

 .../bindings/net/brcm,bcm7445-switch-v4.0.txt |  7 ++
 drivers/net/dsa/bcm_sf2.c                     | 84 ++++++++++++++++++-
 drivers/net/dsa/bcm_sf2.h                     |  4 +
 3 files changed, 93 insertions(+), 2 deletions(-)

-- 
2.25.1

