Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED5BA2EACDD
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 15:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730586AbhAEOFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 09:05:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:57642 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbhAEOFB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 09:05:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0B248AEBB;
        Tue,  5 Jan 2021 14:03:43 +0000 (UTC)
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vkoul@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Mark Brown <broonie@kernel.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-watchdog@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH 05/10] dma: tx49 removal
Date:   Tue,  5 Jan 2021 15:02:50 +0100
Message-Id: <20210105140305.141401-6-tsbogend@alpha.franken.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210105140305.141401-1-tsbogend@alpha.franken.de>
References: <20210105140305.141401-1-tsbogend@alpha.franken.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---
 drivers/dma/Kconfig    |  2 +-
 drivers/dma/txx9dmac.h | 10 ----------
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index d242c7632621..22fedfb6f5f9 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -601,7 +601,7 @@ config S3C24XX_DMAC
 
 config TXX9_DMAC
 	tristate "Toshiba TXx9 SoC DMA support"
-	depends on MACH_TX49XX || MACH_TX39XX
+	depends on MACH_TX39XX
 	select DMA_ENGINE
 	help
 	  Support the TXx9 SoC internal DMA controller.  This can be
diff --git a/drivers/dma/txx9dmac.h b/drivers/dma/txx9dmac.h
index aa53eafb1519..4acf29f50a29 100644
--- a/drivers/dma/txx9dmac.h
+++ b/drivers/dma/txx9dmac.h
@@ -26,11 +26,6 @@
  * DMA channel.
  */
 
-#ifdef CONFIG_MACH_TX49XX
-static inline bool txx9_dma_have_SMPCHN(void)
-{
-	return true;
-}
 #define TXX9_DMA_USE_SIMPLE_CHAIN
 #else
 static inline bool txx9_dma_have_SMPCHN(void)
@@ -40,13 +35,8 @@ static inline bool txx9_dma_have_SMPCHN(void)
 #endif
 
 #ifdef __LITTLE_ENDIAN
-#ifdef CONFIG_MACH_TX49XX
-#define CCR_LE	TXX9_DMA_CCR_LE
-#define MCR_LE	0
-#else
 #define CCR_LE	0
 #define MCR_LE	TXX9_DMA_MCR_LE
-#endif
 #else
 #define CCR_LE	0
 #define MCR_LE	0
-- 
2.29.2

