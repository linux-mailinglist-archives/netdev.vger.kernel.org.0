Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0232BB3AE
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730922AbgKTShR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:37:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:55180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731174AbgKTShN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:37:13 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C417B24124;
        Fri, 20 Nov 2020 18:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897432;
        bh=szf042y2s9sgwSPIKL6lzAqAJLKh9Jw1IOFO3mdaolE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oeHjZdCSofjeMmI9xih31DLKwyANZ7rHAW7CLK9y0d1rivty8MP53oItCKYp9jeKT
         0wc7gaygePioCZyYuNSoIyLzNQIjOqafmLAQpkJKGo7TtC63gldue3DCaZd1zqXU8I
         RLyL+t8nu2CeAOw9Wd8jHDtqEsZkLA+arrZWwy+s=
Date:   Fri, 20 Nov 2020 12:37:18 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 099/141] mt76: mt7615: Fix fall-through warnings for Clang
Message-ID: <5e4366865b6fd0d0dd6b504b66f430b67c315841.1605896060.git.gustavoars@kernel.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1605896059.git.gustavoars@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix a
warning by replacing a /* fall through */ comment with the new
pseudo-keyword macro fallthrough; instead of letting the code fall
through to the next case.

Notice that Clang doesn't recognize /* fall through */ comments as
implicit fall-through markings.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
index f4756bb946c3..9a9685e5ab84 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
@@ -127,7 +127,7 @@ mt7615_eeprom_parse_hw_band_cap(struct mt7615_dev *dev)
 		break;
 	case MT_EE_DBDC:
 		dev->dbdc_support = true;
-		/* fall through */
+		fallthrough;
 	default:
 		dev->mt76.cap.has_2ghz = true;
 		dev->mt76.cap.has_5ghz = true;
-- 
2.27.0

