Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA18A59E8A0
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 19:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343927AbiHWRHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 13:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345154AbiHWRG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 13:06:27 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [IPv6:2001:4b98:dc4:8::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3803BBA60;
        Tue, 23 Aug 2022 07:05:30 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 288A924000B;
        Tue, 23 Aug 2022 14:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661263528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=iFPqKOGR/pEeybnRl36N5Hl9moFdpCNzqDZ6NzBxF+w=;
        b=J7HTEnhyRUNvjhdlO04AsiNxLjLiYu8IRKWK2O3N6m1IkbEm1XaQxix75kX7sIjKmvonhy
        jMJWUDBXukn97JFaaXfLClFfb1S16GB4hj4VagEhsfbMAdpCtA6eCXbzShd2RMO0cABWwp
        iacHgo6A6Ki3pZjRrgbLTs0qMV5zEQbkWAbzDzmqk3svbycnL5DMUzHngvbkH5RiS6x8Ea
        NaOExALm4UBE4QGr1gsGemAH0Z4Y8d7wJbbWUXjcT8TADiR4jpdl2M9MrFVDGsKm+++kKW
        B4pvhNuMhi1n02+Ju5u6vhnNhAdhw10xiK3lUFLKvWia276cCJ6S+hSdEfrwXw==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 0/2] net: altera: tse: phylink conversion
Date:   Tue, 23 Aug 2022 16:05:15 +0200
Message-Id: <20220823140517.3091239-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series converts the Altera Triple Speed Ethernet driver to phylink,
to benefit from the full flexibility that phylink gives, and proped SFP
support.

The first patch is a small rework of the PCS reset code, to make the
actual phylink conversion easier to read.

Maxime Chevallier (2):
  net: altera: tse: add a dedicated helper for reset
  net: altera: tse: convert to phylink

 drivers/net/ethernet/altera/Kconfig           |   1 +
 drivers/net/ethernet/altera/altera_tse.h      |  13 +
 .../net/ethernet/altera/altera_tse_ethtool.c  |  20 +-
 drivers/net/ethernet/altera/altera_tse_main.c | 434 ++++++------------
 4 files changed, 182 insertions(+), 286 deletions(-)

-- 
2.37.2

