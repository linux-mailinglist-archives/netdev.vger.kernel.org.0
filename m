Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3BD11D5A5C
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 21:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbgEOTtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 15:49:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbgEOTtJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 15:49:09 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D6842076A;
        Fri, 15 May 2020 19:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589572148;
        bh=nyMWzLtVthSC+E7N6RC896KCh+R67tXwPSENWexXnhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r9Ki/DqnDBvJL30kWYDpd3vwFM8q71LEsbBH2cWm12Vwaw5Gy/mIDchhF4zCfW7Kn
         tX4pwQzaVKCfAK1NaRXBdxKX7eiLOIa49mphXxIiibC0tiovpv3unyBjSStbJX/4zq
         0H8G3Ge8/2To4QCDrt1OvUfkGJ9dTo8OPBi+huZ0=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org,
        simon.horman@netronome.com, kernel-team@fb.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/3] nfp: don't check lack of RX/TX channels
Date:   Fri, 15 May 2020 12:49:01 -0700
Message-Id: <20200515194902.3103469-3-kuba@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200515194902.3103469-1-kuba@kernel.org>
References: <20200515194902.3103469-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Core will now perform this check.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index a5aa3219d112..6eb9fb9a1814 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1438,8 +1438,7 @@ static int nfp_net_set_channels(struct net_device *netdev,
 	unsigned int total_rx, total_tx;
 
 	/* Reject unsupported */
-	if (!channel->combined_count ||
-	    channel->other_count != NFP_NET_NON_Q_VECTORS ||
+	if (channel->other_count != NFP_NET_NON_Q_VECTORS ||
 	    (channel->rx_count && channel->tx_count))
 		return -EINVAL;
 
-- 
2.25.4

