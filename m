Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A394228E7
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 15:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235701AbhJENyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 09:54:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235715AbhJENxL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 09:53:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00EB661401;
        Tue,  5 Oct 2021 13:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633441880;
        bh=vg+ilq+FkshFxvO6+fl5t/WS0G+CDNmxrnjPYa4IC0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fig2HUWcEY3DexFyepPirNmePAfb0Yp9eEcRjRlGFBUnsh3PsG1ckLof6+X0mnFe0
         90T6nkN/vAlP0vjZzSFns2fcKfbtD7uSoMnDOk1iFqnqR4CREdgMSW9bhU4apLeGec
         18m3HKKTxBo3EGJIpRnlXZvnU4w05fqChkS9c3Zjk8ourNe8XrDhT8Aa/fBPBOrp+O
         1FwVNVgB9Xknp6vH5lrcQnCgpWcqySsBJknvgLARGX1ieMHY5lcTkglilddCmxnnKk
         DeE6XnDRvF5qiqr97bCbyqrJBoHN7AabEVolDxylVWoTE2ooaUaFb5mQE/ydG7UhvW
         y7lamDte4VDkQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Aaron Young <aaron.young@oracle.com>,
        Rashmi Narasimhan <rashmi.narasimhan@oracle.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 31/40] net: sun: SUNVNET_COMMON should depend on INET
Date:   Tue,  5 Oct 2021 09:50:10 -0400
Message-Id: <20211005135020.214291-31-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135020.214291-1-sashal@kernel.org>
References: <20211005135020.214291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 103bde372f084206c6972be543ecc247ebbff9f3 ]

When CONFIG_INET is not set, there are failing references to IPv4
functions, so make this driver depend on INET.

Fixes these build errors:

sparc64-linux-ld: drivers/net/ethernet/sun/sunvnet_common.o: in function `sunvnet_start_xmit_common':
sunvnet_common.c:(.text+0x1a68): undefined reference to `__icmp_send'
sparc64-linux-ld: drivers/net/ethernet/sun/sunvnet_common.o: in function `sunvnet_poll_common':
sunvnet_common.c:(.text+0x358c): undefined reference to `ip_send_check'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Aaron Young <aaron.young@oracle.com>
Cc: Rashmi Narasimhan <rashmi.narasimhan@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sun/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/sun/Kconfig b/drivers/net/ethernet/sun/Kconfig
index 309de38a7530..b0d3f9a2950c 100644
--- a/drivers/net/ethernet/sun/Kconfig
+++ b/drivers/net/ethernet/sun/Kconfig
@@ -73,6 +73,7 @@ config CASSINI
 config SUNVNET_COMMON
 	tristate "Common routines to support Sun Virtual Networking"
 	depends on SUN_LDOMS
+	depends on INET
 	default m
 
 config SUNVNET
-- 
2.33.0

