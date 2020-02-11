Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91B9C159272
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 16:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730187AbgBKPA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 10:00:58 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:34135 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728073AbgBKPA5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 10:00:57 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 02059ba5;
        Tue, 11 Feb 2020 14:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=JX7voRrNvyqx3y1FhLyis66BK
        rs=; b=MPCsTS4X1bsARpZ5aAgvm+Mzg42u475ahGnQRilaqPOS4Y/CnEDm1E/5p
        uAcW/MRFjzLpRVjOz/BPRb5/bG/iWtk+qOjPweUZDD+EVDEZqfbqRq2+3mkCF5YR
        sAlkgVGCl1KO2q3JixqB36XhYsngA2eE9sD2s21uW6FW6YxjL8da3MT1HNTk1sgt
        xzBTjt3ikD4gcg+CELw4LFwkIBm81aslopcbjWwbTk5i8FBnlIMttzJdhqM0sTTM
        69xx/7O+VwxIUA97GcyyjQdGFHndboUt21u0cWFS5NWxeFZ/OIQO4r/NBYlhzVwq
        q0ooQhWu2fSfD1fFGUFVQrqEXvbUg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3925063b (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Tue, 11 Feb 2020 14:59:11 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stefanr@s5r6.in-berlin.de
Subject: [PATCH v3 net 6/9] firewire: remove skb_share_check from xmit path
Date:   Tue, 11 Feb 2020 16:00:25 +0100
Message-Id: <20200211150028.688073-7-Jason@zx2c4.com>
In-Reply-To: <20200211150028.688073-1-Jason@zx2c4.com>
References: <20200210141423.173790-2-Jason@zx2c4.com>
 <20200211150028.688073-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an impossible condition to reach; an skb in ndo_start_xmit won't
be shared by definition.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: stefanr@s5r6.in-berlin.de
Link: https://lore.kernel.org/netdev/CAHmME9pk8HEFRq_mBeatNbwXTx7UEfiQ_HG_+Lyz7E+80GmbSA@mail.gmail.com/
---
 drivers/firewire/net.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
index 715e491dfbc3..c48eae922566 100644
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -1259,10 +1259,6 @@ static netdev_tx_t fwnet_tx(struct sk_buff *skb, struct net_device *net)
 	if (ptask == NULL)
 		goto fail;
 
-	skb = skb_share_check(skb, GFP_ATOMIC);
-	if (!skb)
-		goto fail;
-
 	/*
 	 * Make a copy of the driver-specific header.
 	 * We might need to rebuild the header on tx failure.
-- 
2.25.0

