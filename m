Return-Path: <netdev+bounces-11898-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BBFE4735070
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:36:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E5A01C20995
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 09:36:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8E09C134;
	Mon, 19 Jun 2023 09:36:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE180BE6D
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 09:36:56 +0000 (UTC)
Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67ACAF
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 02:36:48 -0700 (PDT)
X-QQ-mid: bizesmtp65t1687167308th49ip9u
Received: from wxdbg.localdomain.com ( [122.235.139.240])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 19 Jun 2023 17:34:58 +0800 (CST)
X-QQ-SSF: 01400000000000J0Z000000A0000000
X-QQ-FEAT: +ynUkgUhZJm9MO0hB0Dc/gnmzMfNXpy8+affs+IFj0YqwjJlMPL+vCXspfRcA
	9FUIshKtIc43VPgj7R9Id9/+AJWPuKZ45WKLPtcMb6t1lnfJkTW/n/IzOt427yIPomssYQl
	WKTXzAPB35DJiwqJZOuZhGh0ahQN+vAbpo4OFgYO60TLDchxP9PHA8LgyRyQLkYwndnHwGw
	z+HmYDbXO794JZb0m8nbzjshepC6E4xXnl4v/CfQTxzlnEbMDyOo5B8ldQZjCkf38ImxbE1
	jUktTyMwGo5nix5V50V0hrAtP04lJko/6xnaC/UNFdHtgVHq5tWMWNKj/+B2Wj9cDNWOQNX
	2LWykfGrPmPME1Ln0sUfDII+fe6uNdF5rAYYTDn5YpN7m2fN39QwXywvZqGfA==
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 5743408101749244496
From: Jiawen Wu <jiawenwu@trustnetic.com>
To: andrew@lunn.ch,
	hkallweit1@gmail.com,
	linux@armlinux.org.uk,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org
Cc: Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net] net: mdio: fix the wrong parameters
Date: Mon, 19 Jun 2023 17:49:48 +0800
Message-Id: <20230619094948.84452-1-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PHY address and device address are passed in the wrong order.

Fixes: 4e4aafcddbbf ("net: mdio: Add dedicated C45 API to MDIO bus drivers")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/phy/mdio_bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 389f33a12534..8b3618d3da4a 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -1287,7 +1287,7 @@ EXPORT_SYMBOL_GPL(mdiobus_modify_changed);
  * @mask: bit mask of bits to clear
  * @set: bit mask of bits to set
  */
-int mdiobus_c45_modify_changed(struct mii_bus *bus, int devad, int addr,
+int mdiobus_c45_modify_changed(struct mii_bus *bus, int addr, int devad,
 			       u32 regnum, u16 mask, u16 set)
 {
 	int err;
-- 
2.27.0


