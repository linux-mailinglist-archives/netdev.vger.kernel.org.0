Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D372E954
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 19:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729113AbfD2RiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 13:38:11 -0400
Received: from gateway32.websitewelcome.com ([192.185.145.123]:38582 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728873AbfD2RiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 13:38:10 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id 56F58114728E
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 12:38:09 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id LAEDh1IHyYTGMLAEDh6N0f; Mon, 29 Apr 2019 12:38:09 -0500
X-Authority-Reason: nr=8
Received: from [189.250.54.97] (port=58018 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1hLAEC-002Wao-FP; Mon, 29 Apr 2019 12:38:08 -0500
Date:   Mon, 29 Apr 2019 12:38:07 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH net-next] netdevsim: fix fall-through annotation
Message-ID: <20190429173807.GA18088@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 189.250.54.97
X-Source-L: No
X-Exim-ID: 1hLAEC-002Wao-FP
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.250.54.97]:58018
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace "pass through" with a proper "fall through" annotation
in order to fix the following warning:

drivers/net/netdevsim/bus.c: In function ‘new_device_store’:
drivers/net/netdevsim/bus.c:170:14: warning: this statement may fall through [-Wimplicit-fallthrough=]
   port_count = 1;
   ~~~~~~~~~~~^~~
drivers/net/netdevsim/bus.c:172:2: note: here
  case 2:
  ^~~~

Warning level 3 was used: -Wimplicit-fallthrough=3

This fix is part of the ongoing efforts to enable
-Wimplicit-fallthrough

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/netdevsim/bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index ae482347b67b..fd68eeac574c 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -168,7 +168,7 @@ new_device_store(struct bus_type *bus, const char *buf, size_t count)
 	switch (err) {
 	case 1:
 		port_count = 1;
-		/* pass through */
+		/* fall through */
 	case 2:
 		if (id > INT_MAX) {
 			pr_err("Value of \"id\" is too big.\n");
-- 
2.21.0

