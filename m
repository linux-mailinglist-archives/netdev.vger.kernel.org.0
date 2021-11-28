Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C39D4605BC
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 12:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357141AbhK1LIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 06:08:51 -0500
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:54466 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235416AbhK1LGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 06:06:51 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id rHxzm009nTdRTrHy0m5LNL; Sun, 28 Nov 2021 12:03:33 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 28 Nov 2021 12:03:33 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] ethtool: netlink: Slightly simplify 'ethnl_features_to_bitmap()'
Date:   Sun, 28 Nov 2021 12:03:30 +0100
Message-Id: <17fca158231c6f03689bd891254f0dd1f4e84cb8.1638091829.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'dest' bitmap is fully initialized by the 'for' loop, so there is no
need to explicitly reset it.

This also makes this function in line with 'ethnl_features_to_bitmap32()'
which does not clear the destination before writing it.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 net/ethtool/features.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index 1c9f4df273bd..2e7331b23996 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -136,7 +136,6 @@ static void ethnl_features_to_bitmap(unsigned long *dest, netdev_features_t val)
 	const unsigned int words = BITS_TO_LONGS(NETDEV_FEATURE_COUNT);
 	unsigned int i;
 
-	bitmap_zero(dest, NETDEV_FEATURE_COUNT);
 	for (i = 0; i < words; i++)
 		dest[i] = (unsigned long)(val >> (i * BITS_PER_LONG));
 }
-- 
2.30.2

