Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4299534A9B5
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 15:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhCZO2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 10:28:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39982 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbhCZO1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 10:27:39 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lPnR0-0000cA-5y; Fri, 26 Mar 2021 14:27:34 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] ethtool: fec: Fix bitwise-and with ETHTOOL_FEC_NONE
Date:   Fri, 26 Mar 2021 14:27:33 +0000
Message-Id: <20210326142733.557548-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently ETHTOOL_FEC_NONE_BIT is being used as a mask, however
this is zero and the mask should be using ETHTOOL_FEC_NONE instead.
Fix this.

Addresses-Coverity: ("Bitwise-and with zero")
Fixes: 42ce127d9864 ("ethtool: fec: sanitize ethtool_fecparam->fec")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/ethtool/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 8797533ddc4b..26b3e7086075 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2586,7 +2586,7 @@ static int ethtool_set_fecparam(struct net_device *dev, void __user *useraddr)
 	if (copy_from_user(&fecparam, useraddr, sizeof(fecparam)))
 		return -EFAULT;
 
-	if (!fecparam.fec || fecparam.fec & ETHTOOL_FEC_NONE_BIT)
+	if (!fecparam.fec || fecparam.fec & ETHTOOL_FEC_NONE)
 		return -EINVAL;
 
 	fecparam.active_fec = 0;
-- 
2.30.2

