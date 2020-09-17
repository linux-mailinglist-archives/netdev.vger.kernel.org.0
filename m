Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09C326E2F9
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 19:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbgIQRxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 13:53:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726419AbgIQRxI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 13:53:08 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2EFE206C3;
        Thu, 17 Sep 2020 17:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600365188;
        bh=6r/fiVpBEb2E6ivgukANgR/YTf3KbB5pwT1Vur5JxnQ=;
        h=From:To:Cc:Subject:Date:From;
        b=zseFi8ZicmmOjXcRwLP18pJs7XMR0XkQMZHKjYsVERwuqs2IhSWkbqcY6UdlPqmjR
         ahUZVlSyljaSVV7NQiBbx0f1llE0C3bVE56eOkdcqGFL/zDO61aR19SXosyaHGtyPO
         joo93mQyQCL6oOxv5PpBcjWpz/aQibLBRWNoUKCg=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, simon.horman@netronome.com,
        oss-drivers@netronome.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] nfp: use correct define to return NONE fec
Date:   Thu, 17 Sep 2020 10:52:57 -0700
Message-Id: <20200917175257.592636-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct ethtool_fecparam carries bitmasks not bit numbers.
We want to return 1 (NONE), not 0.

Fixes: 0d0870938337 ("nfp: implement ethtool FEC mode settings")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 6eb9fb9a1814..9c9ae33d84ce 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -829,8 +829,8 @@ nfp_port_get_fecparam(struct net_device *netdev,
 	struct nfp_eth_table_port *eth_port;
 	struct nfp_port *port;
 
-	param->active_fec = ETHTOOL_FEC_NONE_BIT;
-	param->fec = ETHTOOL_FEC_NONE_BIT;
+	param->active_fec = ETHTOOL_FEC_NONE;
+	param->fec = ETHTOOL_FEC_NONE;
 
 	port = nfp_port_from_netdev(netdev);
 	eth_port = nfp_port_get_eth_port(port);
-- 
2.26.2

