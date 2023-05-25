Return-Path: <netdev+bounces-5467-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22B6371151B
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 20:46:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D56B41C20F8E
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:46:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BC6624131;
	Thu, 25 May 2023 18:46:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBC523D6D
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 18:46:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E701CC433EF;
	Thu, 25 May 2023 18:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685040377;
	bh=3PDmc6L7A6mgTOux6TLm02hoP0ttjWOtM1RGrNSIS7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OPau+CB9hxqHaS+0tlgU9Z7bOEPHjI0DWJ0Gl/eCm45bTLVYyM4G/8pKVlzljyDwQ
	 QjGQeuVs8yYmwrONR0kxjPVutLlCxCYfbw84E+rGJMG3XEVUwAVm7tNEoeqo7/pGOy
	 P0fa2uJy66JBHYjHPKtV05QTAPbtt3vJWHGi90XEvpWzq6RBhLPV5CgKqOPa0g4Z2c
	 p38g+FC7PFCuAMP+jgPaqmW9poOXovCr3oWxf+uhRwhHvWcH5F48cKJ+2evEiIJrQM
	 9Y67DdCdqTaV9MF62102U2lzSRI7Joiof6xdhig1J9leG0LP6dBRO/NR2PlDN+3E/k
	 0EByGL04/05nQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrew@lunn.ch,
	hkallweit1@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 20/20] mdio_bus: unhide mdio_bus_init prototype
Date: Thu, 25 May 2023 14:45:16 -0400
Message-Id: <20230525184520.2004878-20-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230525184520.2004878-1-sashal@kernel.org>
References: <20230525184520.2004878-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 2e9f8ab68f42b059e80db71266c1675c07c664bd ]

mdio_bus_init() is either used as a local module_init() entry,
or it gets called in phy_device.c. In the former case, there
is no declaration, which causes a warning:

drivers/net/phy/mdio_bus.c:1371:12: error: no previous prototype for 'mdio_bus_init' [-Werror=missing-prototypes]

Remove the #ifdef around the declaration to avoid the warning..

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20230516194625.549249-4-arnd@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/phy.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 8b6850707e629..1c1cc2ec0a7fc 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -940,10 +940,8 @@ int phy_ethtool_set_link_ksettings(struct net_device *ndev,
 				   const struct ethtool_link_ksettings *cmd);
 int phy_ethtool_nway_reset(struct net_device *ndev);
 
-#if IS_ENABLED(CONFIG_PHYLIB)
 int __init mdio_bus_init(void);
 void mdio_bus_exit(void);
-#endif
 
 extern struct bus_type mdio_bus_type;
 
-- 
2.39.2


