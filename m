Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15CF21B8622
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 13:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgDYL2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 07:28:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56087 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbgDYL2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 07:28:18 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jSIyl-0002iM-4Y; Sat, 25 Apr 2020 11:28:15 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: rtnetlink: remove redundant assignment to variable err
Date:   Sat, 25 Apr 2020 12:28:14 +0100
Message-Id: <20200425112814.137857-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable err is being initializeed with a value that is never read
and it is being updated later with a new value. The initialization
is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/core/rtnetlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index d6f4f4a9e8ba..2269199c5891 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3997,8 +3997,8 @@ static int rtnl_fdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct ndmsg *ndm;
 	struct nlattr *tb[NDA_MAX+1];
 	struct net_device *dev;
-	int err = -EINVAL;
 	__u8 *addr;
+	int err;
 	u16 vid;
 
 	if (!netlink_capable(skb, CAP_NET_ADMIN))
-- 
2.25.1

