Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D65013E985
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390872AbgAPRiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:38:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:54192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393331AbgAPRiW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:38:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3887246D6;
        Thu, 16 Jan 2020 17:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196301;
        bh=Ql2WNdd4sxMDmkZDEeT0eV8i9qJNfsKdRKQKMTB1Hx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gwkcjPI/H5cwsfo0+Wg2cf0sY0xrTkAaONQnYEFP7SEuCa6jI4c3CuJnkqOac+qIv
         2TEaqP4YFXv/Abwdnqmbjg3L9V2Tt88LgcTqAADrWAGzA4nY9V84bSNB8bEvACgZ6P
         vgsvwTiE9tP3kH4JMdmRQNTPJeiDWdsOy9rmvYuc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Mukesh Ojha <mojha@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 112/251] ehea: Fix a copy-paste err in ehea_init_port_res
Date:   Thu, 16 Jan 2020 12:34:21 -0500
Message-Id: <20200116173641.22137-72-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit c8f191282f819ab4e9b47b22a65c6c29734cefce ]

pr->tx_bytes should be assigned to tx_bytes other than
rx_bytes.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: ce45b873028f ("ehea: Fixing statistics")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ehea/ehea_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index 2dd17e01e3a7..3692adb8902d 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -1476,7 +1476,7 @@ static int ehea_init_port_res(struct ehea_port *port, struct ehea_port_res *pr,
 
 	memset(pr, 0, sizeof(struct ehea_port_res));
 
-	pr->tx_bytes = rx_bytes;
+	pr->tx_bytes = tx_bytes;
 	pr->tx_packets = tx_packets;
 	pr->rx_bytes = rx_bytes;
 	pr->rx_packets = rx_packets;
-- 
2.20.1

