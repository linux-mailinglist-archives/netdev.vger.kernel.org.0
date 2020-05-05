Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0B81C57F9
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 16:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbgEEOEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 10:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729326AbgEEODK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 10:03:10 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D2DC061A41
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 07:03:09 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id g13so2863743wrb.8
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 07:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hGk6SHkwZ0/IFFGnE1iOAP01F59WjRCQF/3H+v3exE4=;
        b=kvPVV59bLwvQgCRXMMdalhwBGJXiNTAb3RXUaXffdzF/CnPAYnbZfbo5XFRy/U6Hmn
         UYDrC8U2QoSOzSL6kGoZRN+trWItJsZE5rzGhy9yuYPhWqlj27+0bcwhKKCOlWh3BJTz
         l98EqUfia2miyFfDeTxIe2M54ZAExtU1gQ4zySphZmhTJmKHOCSN/LRtVxgdZyy0jInD
         wO02lzvY3Qbg7bm454+9uzwwhlluP7XjN3Ti461uWWCrAgdX/Yj4Iw4pSLlI3+6vKsfZ
         1RqRrgrWqUsGXLeFN6IFuiLJoSlwRD/aG0+tqgvGYmGcLsB9nQQPQtqFBO1K/kBh/rYb
         XAEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hGk6SHkwZ0/IFFGnE1iOAP01F59WjRCQF/3H+v3exE4=;
        b=CN9hsHKeyvtkUY4VCX+Y430lRtvPWmDmbBwIczQkT25OkbYAGU7F/QWZNOukLM80Ru
         ySYeLPcWPdbQ9cvhG2dEItNomw/86naxrBRUPCF4TyoOsOzpzs9kTXfQtuuagmwNAaAr
         wderG4jYkF06NVqi3Bb5UfzveqNn+PsiCGiAMo8WitimU0h5/64Yws7HkahyMvVgFeEv
         NqgpfQdRYD3tU5lBEXwdOWagrOavvG456AY+hkkSLD+pgkaUGGDxurtH9QKW6R+W9Y0H
         5gnkG0FXvmTSrVCi8ui9ij7dSuMttCOIxVo/oofWg9lB/0mORwj4Cw/uMexP95oUZTYw
         fKGQ==
X-Gm-Message-State: AGi0PuYyFWOd1sHU66ZQxSQpRw44VcO66HpDAsPMY5Zpvr7gk7h2lQ9j
        aIehfCi4B0zXS8JgfGIWXxCLOw==
X-Google-Smtp-Source: APiQypIPk6Gmfh+TOm1lNpI6ui+UW11cc/DzL7lShUJ6Uv4UPglvQgiExWM6SHeIDM9Wlw/jZVJSDQ==
X-Received: by 2002:adf:8169:: with SMTP id 96mr3846446wrm.283.1588687388304;
        Tue, 05 May 2020 07:03:08 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id c190sm4075755wme.4.2020.05.05.07.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 07:03:07 -0700 (PDT)
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
Subject: [PATCH 03/11] net: ethernet: mediatek: rename Kconfig prompt
Date:   Tue,  5 May 2020 16:02:23 +0200
Message-Id: <20200505140231.16600-4-brgl@bgdev.pl>
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

We'll soon by adding a second MediaTek Ethernet driver so modify the
Kconfig prompt.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/net/ethernet/mediatek/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/Kconfig b/drivers/net/ethernet/mediatek/Kconfig
index 4968352ba188..5079b8090f16 100644
--- a/drivers/net/ethernet/mediatek/Kconfig
+++ b/drivers/net/ethernet/mediatek/Kconfig
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config NET_VENDOR_MEDIATEK
-	bool "MediaTek ethernet driver"
+	bool "MediaTek devices"
 	depends on ARCH_MEDIATEK || SOC_MT7621 || SOC_MT7620
 	---help---
 	  If you have a Mediatek SoC with ethernet, say Y.
-- 
2.25.0

