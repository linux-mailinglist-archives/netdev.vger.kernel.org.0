Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB59D1C57D2
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 16:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729386AbgEEODU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 10:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729379AbgEEODS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 10:03:18 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A4FC0610D6
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 07:03:18 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id j5so2110535wrq.2
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 07:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1qePp19LiRiOBXtccpgQ+eI6GUOhz0auoBWQ11adkXY=;
        b=LQwCci65NzZKH7S/k3KLNL9uDqCmT0NhL3+vr0FbsT08zlA7KCjEKKJA3sZtnf2+C9
         MgO3OOfj1iU8OOWJHAIFg37vsHsbgcG/ty8jsHreNlysA9n/Au6JLGB7Xxv750eTBgT+
         Sl+iLzCZd3APUglRO82tTPfZvQVLMJ3uavNHAqLe/avFh/YZADgXqEMvzVqRopDktCy2
         JBbLkT1YWVum/i0H4xsIcA/O3SnOtyCQ72Fc/9gVx/ow94+06PK5wjuMsmA86t5vb78a
         f1BNH1aOQZ6Kmm6CjzEh853K5kHs/8DpEoorye+0Q8Vxs8MX0SzFaarHH6cmphLUotuV
         jc4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1qePp19LiRiOBXtccpgQ+eI6GUOhz0auoBWQ11adkXY=;
        b=IAMrHl82xwHT04549uulUQFrwzRh52EgiY0vuv6a3nwvNWZKoc2vOOPYE1y3J+mQCf
         qlHgHj77chxGjKBq6YeuHrRk+09oTycbhHhpa4IZ2vp6Lm5gO1d91sLwclO+DcgKEfoA
         zZqlX/+NYwdNXL+8QnhL8qj7RieYF826QMguDoeceLV/P2uJ4bTM3c7AmW0tZZTd//TL
         E9vO8AkFr8oh6XqdG3cQ8y3MXVIQfzL/X6ntqaYBiMxoDzeYLQ1XtpTXkOxV6+VnCNEI
         8cicNSOKWS+VESWB5CgrA1bE2YuNx5vXApdpXlVwWqNiC0LLQhJw4l+TW+HVH7QOL8Gb
         DSIw==
X-Gm-Message-State: AGi0PuYRhbK2b2dZh3TPXPNGxXDLIGWZu7pvUQUr7Lc1P4Er4+X8KF/e
        Ji5RYpFdwRhm2ZdquklW93qt6Q==
X-Google-Smtp-Source: APiQypKqTKjLTaeehBmyF8ZBLt7Ztsq7bEei0OsGAye1X2D3s2hQaZgytBvFg7WpUlAYtX37tEZNHw==
X-Received: by 2002:adf:ab5c:: with SMTP id r28mr3827494wrc.384.1588687396984;
        Tue, 05 May 2020 07:03:16 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id c190sm4075755wme.4.2020.05.05.07.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 07:03:16 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@openwrt.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 09/11] ARM64: dts: mediatek: add an alias for ethernet0 for pumpkin boards
Date:   Tue,  5 May 2020 16:02:29 +0200
Message-Id: <20200505140231.16600-10-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200505140231.16600-1-brgl@bgdev.pl>
References: <20200505140231.16600-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Add the ethernet0 alias for ethernet so that u-boot can find this node
and fill in the MAC address.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi b/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
index a31093d7142b..97d9b000c37e 100644
--- a/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
+++ b/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
@@ -9,6 +9,7 @@
 / {
 	aliases {
 		serial0 = &uart0;
+		ethernet0 = &ethernet;
 	};
 
 	chosen {
-- 
2.25.0

