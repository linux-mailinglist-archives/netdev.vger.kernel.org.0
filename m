Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87BEC4843E8
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 15:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234448AbiADO4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 09:56:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbiADO4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 09:56:53 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B8FC061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 06:56:52 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id r17so76700303wrc.3
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 06:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f8y3fxQ7Ixt8X6KzlM4QoJHjlMDWhk5dk98sHG3phE8=;
        b=LnBgmJrGWXQSJznhBJE7nxnjt6hdhnRrlVkEdW/QZH+gDm/GnpetPv7QTsZX8pf/8b
         cHfgr6n/Wm3EK3AJEjCNoYm6HmQbgcMMsVwHWjur2NzP5TnDVKc2nnp1oInjOu2+q6hd
         1gnY07zR7Wb+Ufe59UmTXEEynlolGPNxTLcRerhKv0W4vtk6RVv1OuIE42MQltOi/1BF
         Tshs6HHsmUsS+m5MDHlegZhacwkdZ+NYq+AC1j4gY8MdxfREkQHPUaSReq1LBuo010Ws
         GICNQ97F95sXfLa4gRtAnbevuAblhYx3UcEeHdABqenh4BRMujIZl+5kNTbbwnwzThn3
         WD2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f8y3fxQ7Ixt8X6KzlM4QoJHjlMDWhk5dk98sHG3phE8=;
        b=cyZtRw0NhSV6FGwuCSJTj3BV32OJdM2zw+os4c5eQ+BXMXJ1Hb3MzF/GqbV0eRsk2n
         qdY8jWGQpKzl6QoMXPgkWWLWvaoKjx8enJdGDrSS8SDRpVgmQtnwF5XoNR/Oi3M5CeW/
         yac19E0iVfyF2ELmDXm1sazfLSQM40OKdiPRBnoIsakO4Z1S4oRyqiPgdf8UqFSCl5X3
         UOPYiirV+KcO1ZmKwefeeDbezZQLnzEWaU2apBRPpuj9wJwu9yDJZfKyrulI8mSNNqNl
         HVE67Sg8U0ZqC1tk3WbMj1h3nBiJa85BgXKDhLlfrE9zh2+HcND1OiOpZauN9j9xnxmj
         r3uA==
X-Gm-Message-State: AOAM532ZRey2PTrGaAYxjxUWcW2JqnjlEd6K2zfW5VzC05JWf1ng0VSS
        goptBm/wKRJaHz8743x+WYd4tg==
X-Google-Smtp-Source: ABdhPJzGZKFOs4DEcC/6CKGwfstjaCLEUD0B2urzy0Wb63F4ZVqkq++d9906q+a/ZlR7wvNjeeMIIA==
X-Received: by 2002:a5d:5889:: with SMTP id n9mr42818211wrf.476.1641308211178;
        Tue, 04 Jan 2022 06:56:51 -0800 (PST)
Received: from localhost.localdomain ([2001:861:44c0:66c0:f6da:6ac:481:1df0])
        by smtp.gmail.com with ESMTPSA id k10sm19309859wrz.113.2022.01.04.06.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 06:56:50 -0800 (PST)
From:   Neil Armstrong <narmstrong@baylibre.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-oxnas@groups.io,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>
Subject: [PATCH v2 0/3] ARM: ox810se: Add Ethernet support
Date:   Tue,  4 Jan 2022 15:56:43 +0100
Message-Id: <20220104145646.135877-1-narmstrong@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for the Synopsys DWMAC controller found in the
OX820SE SoC, by using almost the same glue code as the OX820.

Patch 1 & 2 are for net branch, patch 3 will be queued to arm-soc.

Changes since v1:
- correctly update value read from register
- add proper tag on patch 3 for arm-soc tree

Neil Armstrong (3):
  dt-bindings: net: oxnas-dwmac: Add bindings for OX810SE
  net: stmmac: dwmac-oxnas: Add support for OX810SE
  ARM: dts: ox810se: Add Ethernet support

 .../devicetree/bindings/net/oxnas-dwmac.txt   |   3 +
 arch/arm/boot/dts/ox810se-wd-mbwe.dts         |   4 +
 arch/arm/boot/dts/ox810se.dtsi                |  18 +++
 .../net/ethernet/stmicro/stmmac/dwmac-oxnas.c | 115 +++++++++++++-----
 4 files changed, 111 insertions(+), 29 deletions(-)

-- 
2.25.1

