Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA451CDE64
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 17:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730610AbgEKPJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 11:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730216AbgEKPI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 11:08:26 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42613C05BD0B
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 08:08:25 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id e16so11424607wra.7
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 08:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hGk6SHkwZ0/IFFGnE1iOAP01F59WjRCQF/3H+v3exE4=;
        b=BnhSIlLGUOMFfC52MRwFwUpau+oL5+IxT7j73mv3XA1jTJZIJIQz2A/+dUwdH20AGh
         coCnf65IfW/UjA0wdDtQEthrmM8Ua/pXygXmqI4yi88+KH4Uab82HS2/hHcO4784GWdB
         0iqX/pvaP0IKonT6d12xExIGCNHih0ZfZQU8HVvdvGkTTHUxUKAb8glPwIZ6XV94TsaT
         dxCnvPFTg9k8b7kDnf62Wlr7b6Ux+/TCMYSL3XMCogB5LHqGBfCnPXkFZHH0b7TeHnja
         qCqPTnXSnlMojw3lCfew9QmkzTsHB8hA3NlY5bQ7vBpf0MxDJz4DQ4jVFgerZnnu2hS4
         r0qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hGk6SHkwZ0/IFFGnE1iOAP01F59WjRCQF/3H+v3exE4=;
        b=SAU6AYEeEp6h4p8PkYIzIMO5/kY+2Zq+et1msetDRlSWaWDktqspejOmOpXxEQ8Icc
         K0hPDKjabxhJESeRAFRNmQTHf3UjZCNzZ6nvrhzG8z8fpLLaXpNOzMorygbRHJNddBok
         sZlT04R12PSaUQTwNqglOUC/990TZaLeVed5vqf3kxKuzNEh10tkkcnUa4Ax6hT/bzr6
         Tyyt9EQI2hYqBNPRQEyfjONdAPkT96Cd0OVjwbbJVpj7MHM2Ue/ORn5Y7GW++9H8DIfx
         SkYkHAc0dn6+uwkmQ/1fkig597iAq/+zgRB/CRVcTVF3Ifve/4TXDfAiRjMji3OEWvme
         EVBw==
X-Gm-Message-State: AGi0PuZtmx2S7piwZuRITRkTaISqNM7sLSE/KbeZ4Nrs05gedtCLkbcg
        WImRDKWAstXgcZhInB5HmW0uKw==
X-Google-Smtp-Source: APiQypLau2nbF8LlznCAI/x+Zn88CGRz70T0Uof7qjtAsaEtaADMu0aaeRnM9pZ/buyq3Tlceyfynw==
X-Received: by 2002:adf:a1c8:: with SMTP id v8mr19191837wrv.79.1589209704001;
        Mon, 11 May 2020 08:08:24 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id 94sm3514792wrf.74.2020.05.11.08.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 08:08:23 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Rob Herring <robh+dt@kernel.org>,
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
Subject: [PATCH v2 03/14] net: ethernet: mediatek: rename Kconfig prompt
Date:   Mon, 11 May 2020 17:07:48 +0200
Message-Id: <20200511150759.18766-4-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200511150759.18766-1-brgl@bgdev.pl>
References: <20200511150759.18766-1-brgl@bgdev.pl>
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

