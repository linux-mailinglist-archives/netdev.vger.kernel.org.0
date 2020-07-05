Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F65E21504F
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 01:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgGEXP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 19:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727970AbgGEXP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 19:15:57 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BCDC061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 16:15:56 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id b25so39646011ljp.6
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 16:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pCh7I0ZhQzV84ffCy/JE09EsaXNAqdkNzL1j93/Ew24=;
        b=Q8iUIW34nfLMZFl2eKs8dYgWldAwa12OyTq8DyxdSvgohFU4hss74t2qxjSD2NO5AC
         TLJjc4WvH/0eWdB7vW8g7GA+5gzP1V4KEM+GYZZl0Fs2SDQCgBTEskWtT1kk0+EzrxaR
         GlT+zErYmeMm4JuDAvaBvs6EIGnVxj23ZrgrAWEgzw/dzfhX66SWrtLx0CRt0AYwD2p5
         9/GfbEFjSBf+jW/br+UA37jbIwmHukYx70HGdQiVXIrhkWFjCFs0ry2byBkq/2N/aI0I
         gkwF9iRCwDbqOkkJgYQNCMI/3Q8RA/J3pQT5a5618nkSBelOoikU/XnR2MSOwCaLl7/H
         1GUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pCh7I0ZhQzV84ffCy/JE09EsaXNAqdkNzL1j93/Ew24=;
        b=tD7ybaXHEkkx24v4xjrKdGTSZF4AQVNCWXNYK4CUFrr2+mySVXFVCXkhHoARd6z6O1
         zVEw+R/V4zIol5BgH99dOzGySA27t16ziQ1g0dJten4cGrz1nQWs8V13bw9TiYmDSZjZ
         IBBCGrSfiGrkOj9vIcgCRcVb+cdtMCZXySQEMwOvACSfQAzxSm82OEONBl4LvSzGxqHP
         GJftz/76Y5xm6AYTMbhE8IKPtcHX3YwiqXS2NpsAnPw82O/7qF3FIld2GHj23HdRQTJt
         YOzSxs+gBmzUzf9jdg0ZVJBC2DNTaVci06cGhskxJYdG57ZgdAUBgwmcXqmCYmk2DK1J
         1mzQ==
X-Gm-Message-State: AOAM530npwQH1fZKjdV1TBUtgfMtQrM9XijAPWLSUfsmlRNiU73vfR4U
        zBqMEiz7wR3hp+eqEtR4u0M332F34rY/XA==
X-Google-Smtp-Source: ABdhPJwGEg5ZVF0plr3NY2qglH1mv5QPfzeieEMitIAh7BkOnLQvqxQXjXg4AO4ANUlPtQTRdUvaFg==
X-Received: by 2002:a2e:8357:: with SMTP id l23mr21001927ljh.290.1593990955082;
        Sun, 05 Jul 2020 16:15:55 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id f14sm8439410lfa.35.2020.07.05.16.15.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2020 16:15:54 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>
Subject: [net-next PATCH 0/5 v3] RTL8366RB DSA tagging and fixes
Date:   Mon,  6 Jul 2020 01:15:45 +0200
Message-Id: <20200705231550.77946-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds rudimentary DSA tagging and fixes up some VLAN
issues in the RTL8366RB driver and in the RTL8366 core
in general.

Linus Walleij (5):
  net: dsa: tag_rtl4_a: Implement Realtek 4 byte A tag
  net: dsa: rtl8366rb: Support the CPU DSA tag
  net: dsa: rtl8366: Split out default VLAN config
  net: dsa: rtl8366: VLAN 0 as disable tagging
  net: dsa: rtl8366: Use top VLANs for default

 drivers/net/dsa/Kconfig     |   1 +
 drivers/net/dsa/rtl8366.c   | 135 +++++++++++++++++++++++++-----------
 drivers/net/dsa/rtl8366rb.c |  31 +++------
 include/net/dsa.h           |   2 +
 net/dsa/Kconfig             |   7 ++
 net/dsa/Makefile            |   1 +
 net/dsa/tag_rtl4_a.c        | 131 ++++++++++++++++++++++++++++++++++
 7 files changed, 245 insertions(+), 63 deletions(-)
 create mode 100644 net/dsa/tag_rtl4_a.c

-- 
2.26.2

