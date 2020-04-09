Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22F6F1A3505
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 15:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbgDINlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 09:41:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53738 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbgDINla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 09:41:30 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jMXQs-00060h-CM; Thu, 09 Apr 2020 13:41:26 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net-sysfs: remove redundant assignment to variable ret
Date:   Thu,  9 Apr 2020 14:41:26 +0100
Message-Id: <20200409134126.417215-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable ret is being initialized with a value that is never read
and it is being updated later with a new value.  The initialization is
redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/core/net-sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index cf0215734ceb..4773ad6ec111 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -80,7 +80,7 @@ static ssize_t netdev_store(struct device *dev, struct device_attribute *attr,
 	struct net_device *netdev = to_net_dev(dev);
 	struct net *net = dev_net(netdev);
 	unsigned long new;
-	int ret = -EINVAL;
+	int ret;
 
 	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
-- 
2.25.1

