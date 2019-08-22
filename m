Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD52F99447
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 14:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388743AbfHVMxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 08:53:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35091 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbfHVMxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 08:53:48 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1i0may-0003jn-O4; Thu, 22 Aug 2019 12:53:40 +0000
From:   Colin King <colin.king@canonical.com>
To:     David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] nexthops: remove redundant assignment to variable err
Date:   Thu, 22 Aug 2019 13:53:40 +0100
Message-Id: <20190822125340.30783-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Variable err is initialized to a value that is never read and it is
re-assigned later. The initialization is redundant and can be removed.

Addresses-Coverity: ("Unused Value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/ipv4/nexthop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 5fe5a3981d43..fc34fd1668d6 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1151,7 +1151,7 @@ static int nh_create_ipv4(struct net *net, struct nexthop *nh,
 		.fc_encap_type = cfg->nh_encap_type,
 	};
 	u32 tb_id = l3mdev_fib_table(cfg->dev);
-	int err = -EINVAL;
+	int err;
 
 	err = fib_nh_init(net, fib_nh, &fib_cfg, 1, extack);
 	if (err) {
-- 
2.20.1

