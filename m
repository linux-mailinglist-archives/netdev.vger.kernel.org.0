Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA6F24CE1C
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 08:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgHUGi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 02:38:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726057AbgHUGiZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 02:38:25 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D2A820732;
        Fri, 21 Aug 2020 06:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597991905;
        bh=Ot86Wj7sGjwZ7S3FH9jm1Yn6Pi0PnzBLyHIPsHidRJU=;
        h=Date:From:To:Cc:Subject:From;
        b=qufkHiis02jnJfGAZaugIRfoT9J+KnnMiuwCZJedt128Z0/B624C0PM3XpxIaswzc
         4tPz8LUc2UeTxbP0c7Pbr16XRhBhIWwZ7m4HyNCdDlyLkZCZFByOrV1aSGrf01Aqrk
         BTbG/sGPiRGPaAictnmiuPSPxy6l/hIK7SwBzcpE=
Date:   Fri, 21 Aug 2020 01:44:12 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] b43legacy: Use fallthrough pseudo-keyword
Message-ID: <20200821064412.GA20612@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the existing /* fall through */ comments and its variants with
the new pseudo-keyword macro fallthrough[1].

[1] https://www.kernel.org/doc/html/v5.7/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/broadcom/b43legacy/dma.c  | 2 +-
 drivers/net/wireless/broadcom/b43legacy/main.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43legacy/dma.c b/drivers/net/wireless/broadcom/b43legacy/dma.c
index f7594e2a896e..7e2f70c4207c 100644
--- a/drivers/net/wireless/broadcom/b43legacy/dma.c
+++ b/drivers/net/wireless/broadcom/b43legacy/dma.c
@@ -189,7 +189,7 @@ return dev->dma.tx_ring1;
 	switch (queue_priority) {
 	default:
 		B43legacy_WARN_ON(1);
-		/* fallthrough */
+		fallthrough;
 	case 0:
 		ring = dev->dma.tx_ring3;
 		break;
diff --git a/drivers/net/wireless/broadcom/b43legacy/main.c b/drivers/net/wireless/broadcom/b43legacy/main.c
index 2eaf481f03f1..7fab9f107c10 100644
--- a/drivers/net/wireless/broadcom/b43legacy/main.c
+++ b/drivers/net/wireless/broadcom/b43legacy/main.c
@@ -1537,7 +1537,7 @@ static int do_request_fw(struct b43legacy_wldev *dev,
 		size = be32_to_cpu(hdr->size);
 		if (size != (*fw)->size - sizeof(struct b43legacy_fw_header))
 			goto err_format;
-		/* fallthrough */
+		fallthrough;
 	case B43legacy_FW_TYPE_IV:
 		if (hdr->ver != 1)
 			goto err_format;
@@ -2076,7 +2076,7 @@ static void b43legacy_rate_memory_init(struct b43legacy_wldev *dev)
 		b43legacy_rate_memory_write(dev, B43legacy_OFDM_RATE_36MB, 1);
 		b43legacy_rate_memory_write(dev, B43legacy_OFDM_RATE_48MB, 1);
 		b43legacy_rate_memory_write(dev, B43legacy_OFDM_RATE_54MB, 1);
-		/* fallthrough */
+		fallthrough;
 	case B43legacy_PHYTYPE_B:
 		b43legacy_rate_memory_write(dev, B43legacy_CCK_RATE_1MB, 0);
 		b43legacy_rate_memory_write(dev, B43legacy_CCK_RATE_2MB, 0);
-- 
2.27.0

