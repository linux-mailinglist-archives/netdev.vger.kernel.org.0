Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D25E313E3E8
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387466AbgAPREt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:04:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:55764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388429AbgAPRCi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:02:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46D162073A;
        Thu, 16 Jan 2020 17:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194158;
        bh=r2ozivp/+T5c+7IpmxT1h+AGMB/feE9xMGPML1D/wtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1enZNenjn7l37tlLrJPIbCWSuldsmHPlIdW6Znvc8mh/OrO7r2aBgdnZhvgY7fCDS
         a0XKoBATj9HJR6dq+hnT+VyZDR3yh/FDGnG6CU8kMMk+q/TDUsdpCXJbqu4UkbLwDE
         og2QAfJyrHTQePZBHd4QKeDQh9G/s2IJS1bGHgmE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, oss-drivers@netronome.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 240/671] nfp: fix simple vNIC mailbox length
Date:   Thu, 16 Jan 2020 11:52:29 -0500
Message-Id: <20200116165940.10720-123-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

[ Upstream commit eaab2d2d0fe4393b040dbf3922e18cd2ab7d6b85 ]

The simple vNIC mailbox length should be 12 decimal and not 0x12.
Using a decimal also makes it clear this is a length value and not
another field within the simple mailbox defines.

Found by code inspection, there are no known firmware configurations
where this would cause issues.

Fixes: 527d7d1b9949 ("nfp: read mailbox address from TLV caps")
Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
index 44d3ea75d043..ab602a79b084 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
@@ -423,7 +423,7 @@
 #define NFP_NET_CFG_MBOX_SIMPLE_CMD	0x0
 #define NFP_NET_CFG_MBOX_SIMPLE_RET	0x4
 #define NFP_NET_CFG_MBOX_SIMPLE_VAL	0x8
-#define NFP_NET_CFG_MBOX_SIMPLE_LEN	0x12
+#define NFP_NET_CFG_MBOX_SIMPLE_LEN	12
 
 #define NFP_NET_CFG_MBOX_CMD_CTAG_FILTER_ADD 1
 #define NFP_NET_CFG_MBOX_CMD_CTAG_FILTER_KILL 2
-- 
2.20.1

