Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4B80119903
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbfLJVl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:41:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:38964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729937AbfLJVeG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:34:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 320BC222C4;
        Tue, 10 Dec 2019 21:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013645;
        bh=YxEtpmiNCRn/jEj2AHiY6cENakVyQhsWOpHRM5wtLHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yp2M8nagqmdTfG0w2tmxRRuxccsNkDkI+D6tKpihl85/r5WwM8cNNF1ry6tPFxz9Q
         Co0ZVaC5U2Kk+FhKDdMp97xiNt2n1KU8MN0QBiChEARM9/cK34T+8QWDClusrA+rdN
         LQqHUAeW338U5P+wbythxvq6fjwxRPenHe0LkcuE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mao Wenan <maowenan@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 085/177] net: dsa: LAN9303: select REGMAP when LAN9303 enable
Date:   Tue, 10 Dec 2019 16:30:49 -0500
Message-Id: <20191210213221.11921-85-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
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
index d3ce1e4cb4d3c..dbfb6ad80fac8 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -66,6 +66,7 @@ config NET_DSA_REALTEK_SMI
 config NET_DSA_SMSC_LAN9303
 	tristate
 	select NET_DSA_TAG_LAN9303
+	select REGMAP
 	---help---
 	  This enables support for the SMSC/Microchip LAN9303 3 port ethernet
 	  switch chips.
-- 
2.20.1

