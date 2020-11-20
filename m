Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D39A2BB376
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730891AbgKTSek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:34:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:53144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730703AbgKTSek (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:34:40 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 991E522470;
        Fri, 20 Nov 2020 18:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897279;
        bh=CuQmBcGw1Tcf9LcSgU1XCa+a0oRLel92NRzOoYzG22o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vv8uC3O/tZroUCgGmN4oD7xwyT9rrQSWz59m1DDGQCjbcT9HaIaI4/xbniJmJo5FU
         9jcPFaeUXT/2LoGyeZW/v5+h8XhfvBUs0LFzppUzKSottjD2pbBUMtjt7aoghDrP80
         IfiUPeVuFYeZwStuHcYWDZODsBxAPfno8gEvC8eQ=
Date:   Fri, 20 Nov 2020 12:34:45 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 073/141] carl9170: Fix fall-through warnings for Clang
Message-ID: <04257418814755f081fa0ac14a61b01328cdc4ed.1605896059.git.gustavoars@kernel.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1605896059.git.gustavoars@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
by explicitly adding a break statement instead of letting the code fall
through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/ath/carl9170/tx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index 235cf77cd60c..6b8446ff48c8 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -840,6 +840,7 @@ static bool carl9170_tx_rts_check(struct ar9170 *ar,
 	case CARL9170_ERP_RTS:
 		if (likely(!multi))
 			return true;
+		break;
 
 	default:
 		break;
-- 
2.27.0

