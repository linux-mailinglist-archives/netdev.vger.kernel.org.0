Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0622218738
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 14:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729160AbgGHM0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 08:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729147AbgGHM0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 08:26:04 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921B9C08C5DC
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 05:26:04 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id f5so38151715ljj.10
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 05:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2R+KQCTyrveBpGh4ucun2aE369nQ+wm18EnYKfQqTko=;
        b=wiLZjnFNLUNPgEMHDdan+Acv/mPyBZOXelUk1IizzMmO00OgiYC7LIZxUihJx/ogjU
         5dPGUqdTczWKyrgAvd7ubZEtm6Q+b1QUUvdPx9nafx00xyVOXqsYrmcDgZKrKZt8LQS2
         /DNty599kvG7LoH5r+NG6ff3paV3FkDEthoDU5oR5G5eGRgYYm77ccHSDsJdd+Fvonfe
         G0fbxJD52ydjMOGj8EFJguvTxlIV4lPfOfpnbkojd6j1ZfH3VDWLYexbWhN+CaeC2fCu
         e5W4BZ4u5NF04G8cbK23TfImdFGV1SH4qGPNXwIlvEgHN5hildQxyjCIw5c4Jd7Dh5a9
         /khg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2R+KQCTyrveBpGh4ucun2aE369nQ+wm18EnYKfQqTko=;
        b=JoBduuDm/I4LqvW2ttRgBEnERb6lmDX/2XFXtcpEi+tZuog3fLs/IUcXVwKXIoDVVm
         gMkFpuFBk8DhJwTVTnv6IJX/L2zfcfNw/RdnjOhx0W7zvp1Xk+jm/19k+kcAIBAk6LmA
         NgP8LmObjQev2cnXV9h0qbGgTcGTm2XMFodF27lUoxXkJfDlv3BkUv3N/r/gBjrc1SRP
         vDBltsEquCGzEmtoTNrb63N5jcIK/YvUUPCwsy6ykc84KJI6tpCwdn0fKcW84fKpvpdY
         ICD0obqE5dBg/UrifvcWN0nxNLkNR8U6cumaiQei0dV2U6V/AomBvOat7DutvKKDW+7j
         pXmg==
X-Gm-Message-State: AOAM53118ql8ZXPTEHij7LErdJp2dJoMyo1ZxtGcgm58UXl4pli7La2y
        TDVvif4A5iC7Y5Ckb3YzfVkzSg==
X-Google-Smtp-Source: ABdhPJy8TwRyhqKTqV75GHGFWMJ62Adnf2d6keaL6WgKfceLmW/olJeN8g/KMU2Ge4y7dVBiZvDfnw==
X-Received: by 2002:a2e:b8d5:: with SMTP id s21mr31941266ljp.34.1594211163092;
        Wed, 08 Jul 2020 05:26:03 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id q128sm874934ljb.140.2020.07.08.05.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 05:26:02 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>
Subject: [net-next PATCH 0/2 v6] RTL8366RB tagging support
Date:   Wed,  8 Jul 2020 14:25:35 +0200
Message-Id: <20200708122537.1341307-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds DSA tagging support to the RTL8366RB
DSA driver.

There is a minor performance improvement in the tag parser
compared to the previous patch set and the review tags
have been collected.

Linus Walleij (2):
  net: dsa: tag_rtl4_a: Implement Realtek 4 byte A tag
  net: dsa: rtl8366rb: Support the CPU DSA tag

 drivers/net/dsa/Kconfig     |   1 +
 drivers/net/dsa/rtl8366rb.c |  31 +++------
 include/net/dsa.h           |   2 +
 net/dsa/Kconfig             |   7 ++
 net/dsa/Makefile            |   1 +
 net/dsa/tag_rtl4_a.c        | 130 ++++++++++++++++++++++++++++++++++++
 6 files changed, 149 insertions(+), 23 deletions(-)
 create mode 100644 net/dsa/tag_rtl4_a.c

-- 
2.26.2

