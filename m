Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 058091E43D3
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 15:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388364AbgE0Nfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 09:35:38 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:35437 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387664AbgE0Nfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 09:35:37 -0400
Received: from localhost.localdomain ([149.172.98.151]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MUD7D-1jUlQi0JwB-00RKHc; Wed, 27 May 2020 15:35:19 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Felix Fietkau <nbd@openwrt.org>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [net-next] mtk-star-emac: mark PM functions as __maybe_unused
Date:   Wed, 27 May 2020 15:34:45 +0200
Message-Id: <20200527133513.579367-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:cjj7qKhbYdAc+XoRu26dmgr99+0Mva2jDkFaa+78wl0aZCmV0UC
 ncWKQldljAs9dUqWY0pwFACTSCYn+/UUUoGqoBekQdJxfEOmZ8sl1HSxzBgSyVaAO/n82XN
 AkaShtBDsW9lZ8jpzC0+KlPr+2Y837pRS9hMODZSl5LC0r0sD1Ic6quun77ngs6pdMvub+y
 RyKC7kjWmzV29q58j/l4Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:oj+4JOX6juU=:0m8IpO+rj+vvHLiYhZyv58
 D4pCaNsPZ1/q70Tk2+JpIvmlDIZoPGimTin1lF+Sc16SU5olSM75WbhAaB7DcPnDWoTSgDxpT
 Rs1v3nRGTX5OU7FHDg7T0TwbHPu8hz5P0lA7uSExtaCZ9MdwFbiBA4V5Uifyi7+mFGBB3Ku05
 1p2K/sQLMSkLJ7R5YWl9J1xgm9Q13Dpx9yCdIhSHCNIfbGhxl2xhR1kr/IAB6H+7X+b5MfncL
 hilM5lyLg367eb/mY5vEOmG/BFU7qUYxOx51fTaKMD5piYkjGhe+VbbXk7wXmb8XFrunvAoaO
 stSL9IuHMslwPrE8R9t0OuJyoyD4p9ORgUJAt/aNnOzVWToYoM2Bz2ptG+brORPXNpQleY0vU
 ytUjSljBF9rh/7KWROwvrrIYKSfIksSCrriVubLuVKuTGEg4tF9VM0ENRChN6mstZXasxBdKb
 3kRtme4WFswSSMmttxf00aRO1IxGerzYscCJCqnR5KElnjHh9lUfU1rwx+E00RMappZji8y9N
 wc7oMm2EMBKGmQRYKrNdCboJP3EUNkmaqMf8PmI8lbEUmT6We8ZYT4uqyejwDtqRDlgL+yCsf
 oNg9rZBeBQB9urX3AOO68xlnOj4kSTQGcTYzdp1093vZpJINl9lErqkTeKoKWgRqeU0dZB9dI
 908SW4x0C349asxQQdKek789w1MRNkNgHYeeXo8yhlORH7/8e6gYpWQB6RjTBMZBs/Js+k4aP
 UPfmHIS6Tj4wmqsdhSBh5MmevMDEqNlXA2lfa12XRaqCtpj8w97k/qOMQG5W9LGa5paADueGt
 OMrDQ5hTnr6zTtfaIXcL+PRkXXI6gsp4NOpc4g/BJwgRSgpXJ0=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Without CONFIG_PM, the compiler warns about two unused functions:

drivers/net/ethernet/mediatek/mtk_star_emac.c:1472:12: error: unused function 'mtk_star_suspend' [-Werror,-Wunused-function]
drivers/net/ethernet/mediatek/mtk_star_emac.c:1488:12: error: unused function 'mtk_star_resume' [-Werror,-Wunused-function]

Mark these as __maybe_unused.

Fixes: 8c7bd5a454ff ("net: ethernet: mtk-star-emac: new driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index b18ce47c4f2e..3223567fe1cb 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -1469,7 +1469,7 @@ static int mtk_star_mdio_init(struct net_device *ndev)
 	return ret;
 }
 
-static int mtk_star_suspend(struct device *dev)
+static __maybe_unused int mtk_star_suspend(struct device *dev)
 {
 	struct mtk_star_priv *priv;
 	struct net_device *ndev;
@@ -1485,7 +1485,7 @@ static int mtk_star_suspend(struct device *dev)
 	return 0;
 }
 
-static int mtk_star_resume(struct device *dev)
+static __maybe_unused int mtk_star_resume(struct device *dev)
 {
 	struct mtk_star_priv *priv;
 	struct net_device *ndev;
-- 
2.26.2

