Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939CA3C1831
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 19:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbhGHRfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 13:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbhGHRfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 13:35:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1911C061574;
        Thu,  8 Jul 2021 10:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=kFgsm0QLBs/EmPxl0wGUNK5go+DtDBkQXPkUTOtc8Sc=; b=y50iv/NcmeUAirCKi7y8eFRcAQ
        C+Cbm8Ij/OJlszOWYxIdOiG8mSY5MJgsoTKFUS/rtxzV2lpeWDpn2uiZ4N8gH8vnWu7io6zMFBKZY
        uMkBoBg0cc2TIXIqgjK6zCI25QXc9bK369YSd+iSUs1okoJ+RtBujlJID3icepDeh2N68wMNVZmH4
        N9mcoLmaGaUFg2ZAkBg37SAxlYq2OBiKxSAWrOTNN3sdcKkpdyHluUv/OeMbBz0xFtVe93hO0xx/8
        bWVTxqBrLTcH8v+qdRsK77IHp74pGkSJDvrnU94f2wnS4eMZXAqQf3nB8ZatJgyblfIKrrztDxBTs
        l+Chm2zg==;
Received: from [2601:1c0:6280:3f0::aefb] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m1Xtf-00HZ7P-LQ; Thu, 08 Jul 2021 17:33:11 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, linux-arm-kernel@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next] net: microchip: sparx5: fix kconfig warning
Date:   Thu,  8 Jul 2021 10:33:10 -0700
Message-Id: <20210708173310.7370-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PHY_SPARX5_SERDES depends on OF so SPARX5_SWITCH should also depend
on OF since 'select' does not follow any dependencies.

WARNING: unmet direct dependencies detected for PHY_SPARX5_SERDES
  Depends on [n]: (ARCH_SPARX5 || COMPILE_TEST [=n]) && OF [=n] && HAS_IOMEM [=y]
  Selected by [y]:
  - SPARX5_SWITCH [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_MICROCHIP [=y] && NET_SWITCHDEV [=y] && HAS_IOMEM [=y]

Fixes: 3cfa11bac9bb ("net: sparx5: add the basic sparx5 driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Lars Povlsen <lars.povlsen@microchip.com>
Cc: Steen Hegelund <Steen.Hegelund@microchip.com>
Cc: UNGLinuxDriver@microchip.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
 drivers/net/ethernet/microchip/sparx5/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20210708.orig/drivers/net/ethernet/microchip/sparx5/Kconfig
+++ linux-next-20210708/drivers/net/ethernet/microchip/sparx5/Kconfig
@@ -2,6 +2,7 @@ config SPARX5_SWITCH
 	tristate "Sparx5 switch driver"
 	depends on NET_SWITCHDEV
 	depends on HAS_IOMEM
+	depends on OF
 	select PHYLINK
 	select PHY_SPARX5_SERDES
 	select RESET_CONTROLLER
