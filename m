Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31B0BE4B59
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 14:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504588AbfJYMmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 08:42:24 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41716 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504536AbfJYMl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 08:41:29 -0400
Received: by mail-lj1-f193.google.com with SMTP id f5so2537022ljg.8
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 05:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hZ80kzn0Gvq+HATqtue47iWJ3txb4sckDQxEWou7YbE=;
        b=e1DVB6RZEIL83T6n/wBWlDoSAGhgc43PWtNmqC+8x8knw1OPJuHYkFi6EckaV0yl50
         3NosFnZQLJRuhrGVXGt9YAJsZfBzRMZwHn8bQXhFdHCQpU+CKevYxKU3bP6j/l2J0a5v
         7J4JQLigfgV2yB+YvMuOIhkA821Cd+cf8A0IM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hZ80kzn0Gvq+HATqtue47iWJ3txb4sckDQxEWou7YbE=;
        b=PVXugBtisqMBaDbC9sP6BICHJG3wGDr6TOW1XVc7Dcw3W/sluTjwOZH66X/mnFx6eA
         2uu1SFrzQBT8EuuJ8TnaipzBDQ2KWr9/u4DsjsK2fBvYSaWF1cXMGtMQBQFKgzTRibDm
         I2xyerLMlKwutxJsbeZboHszWiOYagNj52GFAzOHvgJ4FpuZEEvptVZYjYB+LDUd9ciC
         9S9LHnda6eiV8QOT9FUVHzQBG3rreII0VWIu7yZijzAsuRDGYARAiVNZpt0Yo9n8JT5S
         X8mbBptWgRcgoL8c8exlMLdSySteaVdTZsWbRG0P+bGIRy6cN4Sc0NIjhSPV7JsYqXFa
         xpdQ==
X-Gm-Message-State: APjAAAVeR0pAV7yvuEalIq2s6WqVQTJ0oZKyndZjgscEq7QAVseAnUaA
        Z3Rx8zliAzP2dJnbyUWGsrOZ8A==
X-Google-Smtp-Source: APXvYqzWrsLr+TldTrlwBZiQV+Lk357fJEtEmfSVzLgRlqUQdBGnYmw9pDFh/e+z/41+RxJtA1JaXQ==
X-Received: by 2002:a05:651c:120f:: with SMTP id i15mr2442422lja.144.1572007287647;
        Fri, 25 Oct 2019 05:41:27 -0700 (PDT)
Received: from prevas-ravi.prevas.se ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id 10sm821028lfy.57.2019.10.25.05.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 05:41:27 -0700 (PDT)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Qiang Zhao <qiang.zhao@nxp.com>, Li Yang <leoyang.li@nxp.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Scott Wood <oss@buserror.net>,
        Valentin Longchamp <valentin.longchamp@keymile.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        netdev@vger.kernel.org
Subject: [PATCH v2 19/23] net: ethernet: freescale: make UCC_GETH explicitly depend on PPC32
Date:   Fri, 25 Oct 2019 14:40:54 +0200
Message-Id: <20191025124058.22580-20-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191025124058.22580-1-linux@rasmusvillemoes.dk>
References: <20191018125234.21825-1-linux@rasmusvillemoes.dk>
 <20191025124058.22580-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, QUICC_ENGINE depends on PPC32, so this in itself does not
change anything. In order to allow removing the PPC32 dependency from
QUICC_ENGINE and avoid allmodconfig build failures, add this explicit
dependency.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/net/ethernet/freescale/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/Kconfig b/drivers/net/ethernet/freescale/Kconfig
index 6a7e8993119f..97d27c7740d4 100644
--- a/drivers/net/ethernet/freescale/Kconfig
+++ b/drivers/net/ethernet/freescale/Kconfig
@@ -75,6 +75,7 @@ config FSL_XGMAC_MDIO
 config UCC_GETH
 	tristate "Freescale QE Gigabit Ethernet"
 	depends on QUICC_ENGINE
+	depends on PPC32
 	select FSL_PQ_MDIO
 	select PHYLIB
 	---help---
-- 
2.23.0

