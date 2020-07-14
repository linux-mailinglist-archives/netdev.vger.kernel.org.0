Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06E321EFEA
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 14:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgGNMB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 08:01:27 -0400
Received: from smtp36.i.mail.ru ([94.100.177.96]:44524 "EHLO smtp36.i.mail.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726352AbgGNMB0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 08:01:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail;
        h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:Cc:To:From; bh=qbHt0xTQ8gvYX85r2GgVVZNjX4CqlbhbtSIusxndApI=;
        b=rarA1JVvjcBb5okw+X5zdOWmuf1u5RpupNZRvNSNmIhlP55VbNJytTD7vEJRAIluohnrfqO+kUQbMk8GB3rh9G8v21nA+novJqE2szsk5ZgX+eNqXDkJV0GusgvlOLd9EaE7bs8nRecORAxlOWFWqBsL1BRyNkJbT8IYbUy0LM8=;
Received: by smtp36.i.mail.ru with esmtpa (envelope-from <fido_max@inbox.ru>)
        id 1jvJch-0003R0-2o; Tue, 14 Jul 2020 15:01:23 +0300
From:   Maxim Kochetkov <fido_max@inbox.ru>
Cc:     Maxim Kochetkov <fido_max@inbox.ru>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] gianfar: Use random MAC address when none is given
Date:   Tue, 14 Jul 2020 15:01:04 +0300
Message-Id: <20200714120104.257819-1-fido_max@inbox.ru>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp36.i.mail.ru; auth=pass smtp.auth=fido_max@inbox.ru smtp.mailfrom=fido_max@inbox.ru
X-7564579A: 646B95376F6C166E
X-77F55803: 4F1203BC0FB41BD9BB76C036EA8E79AC7183BC094B6F439707A04E6D4477B360182A05F538085040FE9E7DC89FC4EB4012E6849F381C3FA7DC809E60F3FC4F0404B695EBED5383FD
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE7AED985C8E545F588EA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F79006370D3D68FCEFFDD9EA8638F802B75D45FF5571747095F342E8C7A0BC55FA0FE5FC213B1F18E6357999AC01BF80EEC924F54356B433C02D987D389733CBF5DBD5E913377AFFFEAFD269176DF2183F8FC7C05A64D9A1E9CA65708941B15DA834481FCF19DD082D7633A0E7DDDDC251EA7DABA471835C12D1D977725E5C173C3A84C34964A708C60C975A117882F4460429728AD0CFFFB425014E40A5AABA2AD371193AA81AA40904B5D9A18204E546F3947C724336BCC0EE1BA82D242C3BD2E3F4C64AD6D5ED66289B52C79FDBAFFB82A7259735652A29929C6C725E5C173C3A84C36ED3D2230264E88FBA3038C0950A5D36B5C8C57E37DE458B0B4866841D68ED3567F23339F89546C55F5C1EE8F4F765FC2303E78B907142AC75ECD9A6C639B01BBD4B6F7A4D31EC0BC0CAF46E325F83A522CA9DD8327EE4930A3850AC1BE2E735E4A630A5B664A4FFC4224003CC836476C0CAF46E325F83A50BF2EBBBDD9D6B0F5D41B9178041F3E72623479134186CDE6BA297DBC24807EABDAD6C7F3747799A
X-C8649E89: 94EF0272A9D89B9EF87A4F89EFDF43799A759607405807F9AD839F8A94B4F7BAC9759BC6ED5F36F0
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2biojB6ZTT+PDdQTwMtP0u4aUog==
X-Mailru-Sender: 11C2EC085EDE56FA9C10FA2967F5AB24DD87BDCA44971A3634F755EE91CABA9A8D65200875EB1684EE9242D420CFEBFD3DDE9B364B0DF2891A624F84B2C74EDA4239CF2AF0A6D4F80DA7A0AF5A3A8387
X-Mras: Ok
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there is no valid MAC address in the device tree,
use a random MAC address.

Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
---
 drivers/net/ethernet/freescale/gianfar.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index b3c69e9038ea..b513b8c5c3b5 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -779,8 +779,12 @@ static int gfar_of_init(struct platform_device *ofdev, struct net_device **pdev)
 
 	mac_addr = of_get_mac_address(np);
 
-	if (!IS_ERR(mac_addr))
+	if (!IS_ERR(mac_addr)) {
 		ether_addr_copy(dev->dev_addr, mac_addr);
+	} else {
+		eth_hw_addr_random(dev);
+		dev_info(&ofdev->dev, "Using random MAC address: %pM\n", dev->dev_addr);
+	}
 
 	if (model && !strcasecmp(model, "TSEC"))
 		priv->device_flags |= FSL_GIANFAR_DEV_HAS_GIGABIT |
-- 
2.27.0

