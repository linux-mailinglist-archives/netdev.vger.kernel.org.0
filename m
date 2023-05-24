Return-Path: <netdev+bounces-5002-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0646970F684
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:34:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C1CD71C20DCF
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:34:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7FD9182D1;
	Wed, 24 May 2023 12:32:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C53D1950A
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:32:36 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29FB318C
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:32:35 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ore@pengutronix.de>)
	id 1q1nfE-0006vo-2q; Wed, 24 May 2023 14:32:24 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ore@pengutronix.de>)
	id 1q1nfC-002Tz7-It; Wed, 24 May 2023 14:32:22 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ore@pengutronix.de>)
	id 1q1nfB-00APZi-Li; Wed, 24 May 2023 14:32:21 +0200
From: Oleksij Rempel <o.rempel@pengutronix.de>
To: "David S. Miller" <davem@davemloft.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Woojung Huh <woojung.huh@microchip.com>,
	Arun Ramadoss <arun.ramadoss@microchip.com>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>,
	kernel@pengutronix.de,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	UNGLinuxDriver@microchip.com,
	"Russell King (Oracle)" <linux@armlinux.org.uk>
Subject: [PATCH net-next v1 0/5] Microchip DSA Driver Improvements
Date: Wed, 24 May 2023 14:32:15 +0200
Message-Id: <20230524123220.2481565-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

I'd like to share a set of patches for the Microchip DSA driver. These
patches were chosen from a bigger set because they are simpler and
should be easier to review. The goal is to make the code easier to read,
get rid of unused code, and handle errors better.

Oleksij Rempel (4):
  net: dsa: microchip: improving error handling for 8-bit register RMW
    operations
  net: dsa: microchip: remove ksz_port:on variable
  net: dsa: microchip: ksz8: Prepare ksz8863_smi for regmap register
    access validation
  net: dsa: microchip: Add register access control for KSZ8873 chip

Vladimir Oltean (1):
  net: dsa: microchip: add an enum for regmap widths

 drivers/net/dsa/microchip/ksz8795.c      | 28 ++-------
 drivers/net/dsa/microchip/ksz8863_smi.c  | 13 +++-
 drivers/net/dsa/microchip/ksz9477.c      | 24 ++++----
 drivers/net/dsa/microchip/ksz9477_i2c.c  |  2 +-
 drivers/net/dsa/microchip/ksz_common.c   | 47 ++++++++++++++-
 drivers/net/dsa/microchip/ksz_common.h   | 77 +++++++++++++++++-------
 drivers/net/dsa/microchip/ksz_spi.c      |  2 +-
 drivers/net/dsa/microchip/lan937x_main.c |  8 +--
 8 files changed, 135 insertions(+), 66 deletions(-)

-- 
2.39.2


