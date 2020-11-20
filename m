Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7E62BB339
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730584AbgKTSbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:31:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:50512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729492AbgKTSbI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:31:08 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFF2024171;
        Fri, 20 Nov 2020 18:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897067;
        bh=QYXhdK+3EdmYSTWb4k0uZ7ooZZCcolf1Sjnxe+zYfU8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IKNjKoxrIZ3NYQzm+8lIHMvCy3hdOecFoEld3xr8QZSNcAOe5aA5NPZtkBfJk2Jsd
         zQ/yHGjG2lpvRrUd6QJSJ2qlJak/Ls/P8z1gRlDd/CbwTDtZQOeXe9Q21h/r7z19eq
         1miYyehS2rRBwbTkhcSO3425P9eJW2eYz/yCFkDc=
Date:   Fri, 20 Nov 2020 12:31:13 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 045/141] net: mscc: ocelot: Fix fall-through warnings for
 Clang
Message-ID: <a36175068f59c804403ec36a303cf1b72473a5a5.1605896059.git.gustavoars@kernel.org>
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
by explicitly adding a break statement instead of just letting the code
fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_vcap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index d8c778ee6f1b..8f3ed81b9a08 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -761,6 +761,7 @@ static void is1_entry_set(struct ocelot *ocelot, int ix,
 			vcap_key_bytes_set(vcap, &data, VCAP_IS1_HK_ETYPE,
 					   etype.value, etype.mask);
 		}
+		break;
 	}
 	default:
 		break;
-- 
2.27.0

