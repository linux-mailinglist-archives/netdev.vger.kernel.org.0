Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 602FF15AA8
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 07:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729207AbfEGFkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:40:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729197AbfEGFkq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:40:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91F5520578;
        Tue,  7 May 2019 05:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207646;
        bh=HgdTLEb3jB+qZl9zWsPI3Ht5ORdhynr4mHeCSve1tIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gKVY95Yt4WOCzx2RunNc4JEN/GkFrh2KpJWNcJ7t5KMXspzr3aaR3ztY1ewNPrPqE
         AsjUURtJZ6T/erGP6B96flBEESuKHrQ1mRYV+9GGRfhzQGnnhlWsOPxgzA6rEtHj2X
         fAno+r6X66wX5IwppTrF+8V1PbMZlYkMKbeILJBU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matteo Croce <mcroce@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <alexander.levin@microsoft.com>,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 77/95] gtp: change NET_UDP_TUNNEL dependency to select
Date:   Tue,  7 May 2019 01:38:06 -0400
Message-Id: <20190507053826.31622-77-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@redhat.com>

[ Upstream commit c22da36688d6298f2e546dcc43fdc1ad35036467 ]

Similarly to commit a7603ac1fc8c ("geneve: change NET_UDP_TUNNEL
dependency to select"), GTP has a dependency on NET_UDP_TUNNEL which
makes impossible to compile it if no other protocol depending on
NET_UDP_TUNNEL is selected.

Fix this by changing the depends to a select, and drop NET_IP_TUNNEL from
the select list, as it already depends on NET_UDP_TUNNEL.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 drivers/net/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index aba0d652095b..f3357091e9d1 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -212,8 +212,8 @@ config GENEVE
 
 config GTP
 	tristate "GPRS Tunneling Protocol datapath (GTP-U)"
-	depends on INET && NET_UDP_TUNNEL
-	select NET_IP_TUNNEL
+	depends on INET
+	select NET_UDP_TUNNEL
 	---help---
 	  This allows one to create gtp virtual interfaces that provide
 	  the GPRS Tunneling Protocol datapath (GTP-U). This tunneling protocol
-- 
2.20.1

