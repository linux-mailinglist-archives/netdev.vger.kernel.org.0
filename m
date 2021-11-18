Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7204553A7
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 05:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242873AbhKRESN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 23:18:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:36130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242864AbhKRESG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 23:18:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 058A761B6F;
        Thu, 18 Nov 2021 04:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637208907;
        bh=GUNyiG5vNDRYlKsjXNzmhm88pt7worAx1umJhCVUo6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SunzAXEvZEoGAKYkklQKJcGsDYGmiSM/eYOkOSv+1QpBbh5K87mgz8lFcJRNhZLlV
         PsRNroQNQAge3Lz7kJHjDEZixbMESpr4qg980e8KYRRxBPrOPD1kjlCjxBSQtJEI27
         9IPZJNVSwLBY9f9nqPbcwfUpbronX82L6QFfMma9gq3KqrpXItCgzdjHpORK/amoXO
         F6UcXBH9L3+8kaL3ITvoDQ4nYMV4tGSg40sbax7DbPwk9ORRi7qjT10lKJif5tzVb1
         CD9BxKdbQjHZzS8YazSTM34+s+6fZ/Iqt++L4ql5uWpyKQG4vV3cwZ8SWpNfLKkiC5
         XjA82ho4ItkeQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        stas.yakovlev@gmail.com, kvalo@codeaurora.org
Subject: [PATCH net-next 4/9] ipw2200: constify address in ipw_send_adapter_address
Date:   Wed, 17 Nov 2021 20:14:56 -0800
Message-Id: <20211118041501.3102861-5-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118041501.3102861-1-kuba@kernel.org>
References: <20211118041501.3102861-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add const to the address param of ipw_send_adapter_address()
all the functions down the chain have already been changed.

Not sure how I lost this in the rebase.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: stas.yakovlev@gmail.com
CC: kvalo@codeaurora.org
---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index 23037bfc9e4c..5727c7c00a28 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -2303,7 +2303,7 @@ static int ipw_send_ssid(struct ipw_priv *priv, u8 * ssid, int len)
 				ssid);
 }
 
-static int ipw_send_adapter_address(struct ipw_priv *priv, u8 * mac)
+static int ipw_send_adapter_address(struct ipw_priv *priv, const u8 * mac)
 {
 	if (!priv || !mac) {
 		IPW_ERROR("Invalid args\n");
-- 
2.31.1

