Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6901D2986
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 10:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbgENIBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 04:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726150AbgENIAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 04:00:12 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15152C05BD09
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 01:00:12 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id u16so31294513wmc.5
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 01:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hGk6SHkwZ0/IFFGnE1iOAP01F59WjRCQF/3H+v3exE4=;
        b=sy1VaUH34NUebXKcvazHWXxPF3ogvwlwIUiwdr//8TZImO1DzPnfHcTTZcIhBS2t/I
         Qtz3nDiCiZ5pQS4wSr6e0/W22c8uNiAYlEeHd8fIYxiJiPKBfex5hi0ce7n8Fhr0+9wa
         AbBd8vdDewHJDp4jNw8kHPOel9OBU2sY66VvLM5e4uEu6Gm8EdeBBbtGWKRQRCiVZ1uE
         06unoy6QL1YcMQtVm38WtgYVV2to6HPRNnV1qZTXU7IICbxebW47wE4iLEHHDatV3H3K
         6bBJXYtxb0k3v4LtjawRCa9xGcftkVmdzRZMERNYGj2uveFxL+9fwRDpzPprIiY5/R2M
         9fTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hGk6SHkwZ0/IFFGnE1iOAP01F59WjRCQF/3H+v3exE4=;
        b=s+rBYlmOzWztihCw/MmeDrwkFxzXveeLqQjz21+fSHTWDV6KXOSjPGiB8IkGVVfnbX
         8iU0JlkeLGbrNNMqe2sPfcVM8OH9jy+IDNcdTcw3hlxkgzPfMjcrpLSDrY4T6YkOMB+w
         RziVNeZMRaYPBnx8gOiMISFDHMIqjVZYqzM3vMO9S1ErGbc6ONTO6f/BCiquUzjtGd+L
         sXpKpneYoqTzaFWhb6/HakO/eXmd5JkKdbVDROT2IlJl+VQIeYzfukthAJ0YjlBQh3Qx
         SJV/nSi8mu19IKQLuaQZAevD9p0FuuqkBsLhMP0maQtC28o6jze+MRJJ9Z590+csl46f
         s/Xw==
X-Gm-Message-State: AGi0Pub18HjN7COiTXSmBYsJ3pwo2ygJvT5Dwopzv4vEqI45FS24UszE
        18eIYslSV6TX3HSG0B5FhYjE5w==
X-Google-Smtp-Source: APiQypKTmELbtmt9F3Y+bsG9moFkBY9H/xGDo99tpE05kdW0Y8evm2kVDCSS/WwL66naHiCax7tGDA==
X-Received: by 2002:a1c:3281:: with SMTP id y123mr47408066wmy.30.1589443210396;
        Thu, 14 May 2020 01:00:10 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id 81sm23337446wme.16.2020.05.14.01.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 01:00:09 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>,
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
Subject: [PATCH v3 04/15] net: ethernet: mediatek: rename Kconfig prompt
Date:   Thu, 14 May 2020 09:59:31 +0200
Message-Id: <20200514075942.10136-5-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200514075942.10136-1-brgl@bgdev.pl>
References: <20200514075942.10136-1-brgl@bgdev.pl>
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

