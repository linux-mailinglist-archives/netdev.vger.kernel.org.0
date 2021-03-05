Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9151032E32F
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 08:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbhCEHrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 02:47:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:37970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229446AbhCEHrs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 02:47:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FF9F64F44;
        Fri,  5 Mar 2021 07:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614930468;
        bh=gPpw/+5gKNXGYC0+/mLghLRkjHCwJI+DcYIlmUFX/PI=;
        h=Date:From:To:Cc:Subject:From;
        b=CbK2NZ8NKgicNyfTUCiMZN7uzNIuigKDK+fLQQfWlKBhURQ/9Zq0jW72owYyeCYsQ
         ZPOShx4m2CJ+dY/gDRvWkK6azf6JQS9T/ylpaOp0/KKpjzp3nx9mydhcZg6H6WiKr4
         Tg7cgQnFtAXRVKYX0T7rBJrEA8su9Ika3rSPnm76fcfxv4g2Yx8PqOs/TxMVDhZd0u
         ebDpVDGw5chAlLwkeda9riunp0jehi63zsAWvwUOOPn9nyplybAish22GmJb0K1UiP
         KjvY0JeXwrTt+juFxKW/hh9iMQIEA5S5rUvz3/MxrV5kMCdGMfrWezITgXBoiuDkX+
         nbL4KAZ/nm2wQ==
Date:   Fri, 5 Mar 2021 01:47:45 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] net: plip: Fix fall-through warnings for Clang
Message-ID: <20210305074745.GA123523@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

