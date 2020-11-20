Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF9B2BB3C8
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731298AbgKTSiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:38:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:56612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731009AbgKTSiU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:38:20 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F38824124;
        Fri, 20 Nov 2020 18:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897499;
        bh=gPpw/+5gKNXGYC0+/mLghLRkjHCwJI+DcYIlmUFX/PI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f+dAq8mGgjnerXz5Roo1NYzqDrMXI0uYmrwTCaYXWgEVR2B+a9EzezCXId1jX3lZT
         tjYLZecZf5uipL1vs3njuQfKUM3scgZihdjc8Brce44cC8UDZMjjbFCVsS/nSRrobO
         hnFh418ITyFF4oA+1YgsAQi5fIG0nAej/jRdOXsU=
Date:   Fri, 20 Nov 2020 12:38:25 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 111/141] net: plip: Fix fall-through warnings for Clang
Message-ID: <44c10df4dbe85f2c8e14d760b6e83acecd22ebe2.1605896060.git.gustavoars@kernel.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1605896059.git.gustavoars@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
warnings by explicitly adding multiple break statements instead of
letting the code fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/plip/plip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/plip/plip.c b/drivers/net/plip/plip.c
index 4406b353123e..e26cf91bdec2 100644
--- a/drivers/net/plip/plip.c
+++ b/drivers/net/plip/plip.c
@@ -516,6 +516,7 @@ plip_receive(unsigned short nibble_timeout, struct net_device *dev,
 		*data_p |= (c0 << 1) & 0xf0;
 		write_data (dev, 0x00); /* send ACK */
 		*ns_p = PLIP_NB_BEGIN;
+		break;
 	case PLIP_NB_2:
 		break;
 	}
@@ -808,6 +809,7 @@ plip_send_packet(struct net_device *dev, struct net_local *nl,
 				return HS_TIMEOUT;
 			}
 		}
+		break;
 
 	case PLIP_PK_LENGTH_LSB:
 		if (plip_send(nibble_timeout, dev,
-- 
2.27.0

