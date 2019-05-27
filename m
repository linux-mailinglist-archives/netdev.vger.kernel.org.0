Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37E322BB2F
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 22:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbfE0UNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 16:13:34 -0400
Received: from gateway23.websitewelcome.com ([192.185.49.124]:33360 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726657AbfE0UNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 16:13:34 -0400
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 455F94B64
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 15:13:33 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id VLzxhrQDFdnCeVLzxhWXLZ; Mon, 27 May 2019 15:13:33 -0500
X-Authority-Reason: nr=8
Received: from [189.250.47.159] (port=41708 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1hVLzw-003uCI-CB; Mon, 27 May 2019 15:13:32 -0500
Date:   Mon, 27 May 2019 15:13:31 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH net-next] net: mvpp2: cls: Remove unnecessary comparison of
 unsigned integer with < 0
Message-ID: <20190527201331.GA14908@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 189.250.47.159
X-Source-L: No
X-Exim-ID: 1hVLzw-003uCI-CB
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.250.47.159]:41708
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 2
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need to compare info->fs.location with < 0 because such
comparison of an unsigned value is always false.

Fix this by removing such comparison.

Addresses-Coverity-ID: 1445598 ("Unsigned compared against 0")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
index d046f7a1dcf5..40beeb72ae10 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -1232,8 +1232,7 @@ int mvpp2_ethtool_cls_rule_ins(struct mvpp2_port *port,
 	struct mvpp2_ethtool_fs *efs, *old_efs;
 	int ret = 0;
 
-	if (info->fs.location >= 4 ||
-	    info->fs.location < 0)
+	if (info->fs.location >= 4)
 		return -EINVAL;
 
 	efs = kzalloc(sizeof(*efs), GFP_KERNEL);
-- 
2.21.0

