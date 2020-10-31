Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32EB02A1926
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 19:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbgJaSEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 14:04:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56478 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726254AbgJaSEq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 14:04:46 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kYvF6-004XGJ-41; Sat, 31 Oct 2020 19:04:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next] drivers: net: xen-netfront: Fixed W=1 set but unused warnings
Date:   Sat, 31 Oct 2020 19:04:35 +0100
Message-Id: <20201031180435.1081127-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/xen-netfront.c:2416:16: warning: variable ‘target’ set but not used [-Wunused-but-set-variable]
 2416 |  unsigned long target;

Remove target and just discard the return value from simple_strtoul().

This patch does give a checkpatch warning, but the warning was there
before anyway, as this file has lots of checkpatch warnings.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/xen-netfront.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 3e9895bec15f..920cac4385bf 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -2413,12 +2413,11 @@ static ssize_t store_rxbuf(struct device *dev,
 			   const char *buf, size_t len)
 {
 	char *endp;
-	unsigned long target;
 
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
 
-	target = simple_strtoul(buf, &endp, 0);
+	simple_strtoul(buf, &endp, 0);
 	if (endp == buf)
 		return -EBADMSG;
 
-- 
2.28.0

