Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1F71F2585
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 01:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732113AbgFHX1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:27:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:55618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729807AbgFHX1R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:27:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9109E20814;
        Mon,  8 Jun 2020 23:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658837;
        bh=P3J1uhq5KaE5PWts86ExAV3RvdYcRyFqVg7BLWLL3Yg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mzgqSheZdAVZJ/IhXNMxYgtGCzzP+9Ee7F/YdLxznIGkUuoN0/W9Enhc32TJrctoC
         fTS61AUgjgutK3Y/mQeIV8e4XsHWweNS8Xc9c8Hr1JvHcLm/1GyjbBlUaurfWNeaQy
         Izcieq05U/FTURdh2WLGCe0prbHT7AQbJzKQdNbA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 27/50] net: lpc-enet: fix error return code in lpc_mii_init()
Date:   Mon,  8 Jun 2020 19:26:17 -0400
Message-Id: <20200608232640.3370262-27-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232640.3370262-1-sashal@kernel.org>
References: <20200608232640.3370262-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 88ec7cb22ddde725ed4ce15991f0bd9dd817fd85 ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: b7370112f519 ("lpc32xx: Added ethernet driver")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Acked-by: Vladimir Zapolskiy <vz@mleia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/nxp/lpc_eth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index 9fcaf1910633..9b98ec3dcb82 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -845,7 +845,8 @@ static int lpc_mii_init(struct netdata_local *pldat)
 	if (mdiobus_register(pldat->mii_bus))
 		goto err_out_unregister_bus;
 
-	if (lpc_mii_probe(pldat->ndev) != 0)
+	err = lpc_mii_probe(pldat->ndev);
+	if (err)
 		goto err_out_unregister_bus;
 
 	return 0;
-- 
2.25.1

