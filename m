Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A1E265E00
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 12:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbgIKKf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 06:35:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36928 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgIKKfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 06:35:24 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kGgOb-0004WL-Pk; Fri, 11 Sep 2020 10:35:09 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ipv6: remove redundant assignment to variable err
Date:   Fri, 11 Sep 2020 11:35:09 +0100
Message-Id: <20200911103509.22907-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable err is being initialized with a value that is never read and
it is being updated later with a new value. The initialization is redundant
and can be removed.  Also re-order variable declarations in reverse
Christmas tree ordering.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/ipv6/route.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 5e7e25e2523a..e8ee20720fe0 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5284,9 +5284,10 @@ static int ip6_route_multipath_del(struct fib6_config *cfg,
 {
 	struct fib6_config r_cfg;
 	struct rtnexthop *rtnh;
+	int last_err = 0;
 	int remaining;
 	int attrlen;
-	int err = 1, last_err = 0;
+	int err;
 
 	remaining = cfg->fc_mp_len;
 	rtnh = (struct rtnexthop *)cfg->fc_mp;
-- 
2.27.0

