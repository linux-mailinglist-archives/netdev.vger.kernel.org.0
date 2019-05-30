Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 633632FFBA
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 17:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbfE3P6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 11:58:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51272 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3P6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 11:58:01 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hWNRC-0000U8-AQ; Thu, 30 May 2019 15:57:54 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] nexthop: remove redundant assignment to err
Date:   Thu, 30 May 2019 16:57:54 +0100
Message-Id: <20190530155754.31634-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable err is initialized with a value that is never read
and err is reassigned a few statements later. This initialization
is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/ipv4/nexthop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 1af8a329dacb..7a5a3d08fec3 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -836,7 +836,7 @@ static int nh_create_ipv6(struct net *net,  struct nexthop *nh,
 		.fc_encap = cfg->nh_encap,
 		.fc_encap_type = cfg->nh_encap_type,
 	};
-	int err = -EINVAL;
+	int err;
 
 	if (!ipv6_addr_any(&cfg->gw.ipv6))
 		fib6_cfg.fc_flags |= RTF_GATEWAY;
-- 
2.20.1

