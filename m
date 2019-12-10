Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1B01196A1
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbfLJV2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:28:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:60432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728120AbfLJVK3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:10:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF5C0246B8;
        Tue, 10 Dec 2019 21:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012228;
        bh=EwON0KxD+25ZAhruFvpeWwE6GlempRxfhHmX9ra5pWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GJU40CmfWPJxdwSZQ5j1TIkIdVSCcS4Vkraa6mML2DzsEHrwDkXFD+y7PiGePsX2y
         iARzH5quwNxd0Ir+qkMVdhtpZjW0nGXTEtaOmUaMmaHio6c/v+XzDtu/TyCwdhccEk
         Gngx7Qt/jO/WHEwxl92+AekunXdiEtnHob4OqQos=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mao Wenan <maowenan@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 178/350] net: dsa: LAN9303: select REGMAP when LAN9303 enable
Date:   Tue, 10 Dec 2019 16:04:43 -0500
Message-Id: <20191210210735.9077-139-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mao Wenan <maowenan@huawei.com>

[ Upstream commit b6989d248a2d13f02895bae1a9321b3bbccc0283 ]

When NET_DSA_SMSC_LAN9303=y and NET_DSA_SMSC_LAN9303_MDIO=y,
below errors can be seen:
drivers/net/dsa/lan9303_mdio.c:87:23: error: REGMAP_ENDIAN_LITTLE
undeclared here (not in a function)
  .reg_format_endian = REGMAP_ENDIAN_LITTLE,
drivers/net/dsa/lan9303_mdio.c:93:3: error: const struct regmap_config
has no member named reg_read
  .reg_read = lan9303_mdio_read,

It should select REGMAP in config NET_DSA_SMSC_LAN9303.

Fixes: dc7005831523 ("net: dsa: LAN9303: add MDIO managed mode support")
Signed-off-by: Mao Wenan <maowenan@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index f6232ce8481fe..685e12b05a7c0 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -77,6 +77,7 @@ config NET_DSA_REALTEK_SMI
 config NET_DSA_SMSC_LAN9303
 	tristate
 	select NET_DSA_TAG_LAN9303
+	select REGMAP
 	---help---
 	  This enables support for the SMSC/Microchip LAN9303 3 port ethernet
 	  switch chips.
-- 
2.20.1

