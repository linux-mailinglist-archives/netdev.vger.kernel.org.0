Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8502A445912
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 18:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234045AbhKDR6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 13:58:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229971AbhKDR6K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 13:58:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 975EA611C3;
        Thu,  4 Nov 2021 17:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636048531;
        bh=5i72Fk9BLTc/FU3vprgtxY+x3JDf2p08T0ByVT4553Q=;
        h=From:To:Cc:Subject:Date:From;
        b=fwHXa+HBl1PQdBsGWtz30qFvMx1aFQUdwKBE6WIErjmMQEtMoni6dxKmbKyeSgDHm
         83V6OZ4NTINYZoirCcx7GyEnxbBmMyM/q3bG1FXafA3haawn7/bEINDW2HVL2Xs3b/
         yZkZPNQN1KV1nacVdJPQ5y583SxQhPHCn6028W5O5WkAir276UmZTK3G0sXMn9I71o
         HBl7p7zpzhej1TKuVEP31jkggIo8ETYNPzbPKfOOFn5Q2CDV0YBZGr9oxHgi9upRj6
         /vsglR6WKTP7eHTBh4pBP8+kLIyaMT4PK4ivT2FleU849ZMLUOiOqE2lJ3Vh+NG5Gi
         wFh1LGBp07xpQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, l.stelmach@samsung.com,
        Jakub Kicinski <kuba@kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net] net: ax88796c: hide ax88796c_dt_ids if !CONFIG_OF
Date:   Thu,  4 Nov 2021 10:55:27 -0700
Message-Id: <20211104175527.91343-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Build bot says:

>> drivers/net/ethernet/asix/ax88796c_main.c:1116:34: warning: unused variable 'ax88796c_dt_ids' [-Wunused-const-variable]
   static const struct of_device_id ax88796c_dt_ids[] = {
                                    ^

The only reference to this array is wrapped in of_match_ptr().

Reported-by: kernel test robot <lkp@intel.com>
Fixes: a97c69ba4f30 ("net: ax88796c: ASIX AX88796C SPI Ethernet Adapter Driver")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/asix/ax88796c_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethernet/asix/ax88796c_main.c
index 4b0c5a09fd57..2086de05385c 100644
--- a/drivers/net/ethernet/asix/ax88796c_main.c
+++ b/drivers/net/ethernet/asix/ax88796c_main.c
@@ -1114,11 +1114,13 @@ static int ax88796c_remove(struct spi_device *spi)
 	return 0;
 }
 
+#ifdef CONFIG_OF
 static const struct of_device_id ax88796c_dt_ids[] = {
 	{ .compatible = "asix,ax88796c" },
 	{},
 };
 MODULE_DEVICE_TABLE(of, ax88796c_dt_ids);
+#endif
 
 static const struct spi_device_id asix_id[] = {
 	{ "ax88796c", 0 },
-- 
2.31.1

