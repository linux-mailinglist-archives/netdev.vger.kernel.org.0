Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6A42DA054
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 20:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502623AbgLNTHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 14:07:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:46106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408589AbgLNRhL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 12:37:11 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Rasesh Mody <rmody@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 031/105] net: broadcom CNIC: requires MMU
Date:   Mon, 14 Dec 2020 18:28:05 +0100
Message-Id: <20201214172556.777271267@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 14483cbf040fcb38113497161088a1ce8ce5d713 ]

The CNIC kconfig symbol selects UIO and UIO depends on MMU.
Since 'select' does not follow dependency chains, add the same MMU
dependency to CNIC.

Quietens this kconfig warning:

WARNING: unmet direct dependencies detected for UIO
  Depends on [n]: MMU [=n]
  Selected by [m]:
  - CNIC [=m] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_BROADCOM [=y] && PCI [=y] && (IPV6 [=m] || IPV6 [=m]=n)

Fixes: adfc5217e9db ("broadcom: Move the Broadcom drivers")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Rasesh Mody <rmody@marvell.com>
Cc: GR-Linux-NIC-Dev@marvell.com
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Link: https://lore.kernel.org/r/20201129070843.3859-1-rdunlap@infradead.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
index 7fb42f388d591..7b79528d6eed2 100644
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@ -88,6 +88,7 @@ config BNX2
 config CNIC
 	tristate "QLogic CNIC support"
 	depends on PCI && (IPV6 || IPV6=n)
+	depends on MMU
 	select BNX2
 	select UIO
 	help
-- 
2.27.0



