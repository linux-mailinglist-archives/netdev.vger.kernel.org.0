Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B7C2A2A7C
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 13:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbgKBMQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 07:16:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46600 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728484AbgKBMQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 07:16:20 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kZYkx-0000OA-Fi; Mon, 02 Nov 2020 12:16:15 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: dev_ioctl: remove redundant initialization of variable err
Date:   Mon,  2 Nov 2020 12:16:15 +0000
Message-Id: <20201102121615.695196-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable err is being initialized with a value that is never read
and it is being updated later with a new value.  The initialization is
redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/core/dev_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 205e92e604ef..db8a0ff86f36 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -230,7 +230,7 @@ static int dev_do_ioctl(struct net_device *dev,
 			struct ifreq *ifr, unsigned int cmd)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
-	int err = -EOPNOTSUPP;
+	int err;
 
 	err = dsa_ndo_do_ioctl(dev, ifr, cmd);
 	if (err == 0 || err != -EOPNOTSUPP)
-- 
2.27.0

