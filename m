Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 829076B743E
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 11:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbjCMKhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 06:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCMKhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 06:37:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFCA25C101
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 03:37:28 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pbfY7-0008Sx-Qo; Mon, 13 Mar 2023 11:37:04 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pbfY0-003pKV-Hz; Mon, 13 Mar 2023 11:36:56 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pbfXz-004W3U-Lb; Mon, 13 Mar 2023 11:36:55 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Wei Fang <wei.fang@nxp.com>, Wolfram Sang <wsa@kernel.org>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mark Brown <broonie@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Li Yang <leoyang.li@nxp.com>
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH net-next 0/9] net: freescale: Convert to platform remove callback returning void
Date:   Mon, 13 Mar 2023 11:36:44 +0100
Message-Id: <20230313103653.2753139-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2042; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=zEpAFLkQY7859LsqSDJWo8ZNP9TlRFY5PH190cEWY4A=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBkDvyhwmwCq1zII8pwd14nInfWvi52xpRLIUiex kwAWAILM+iJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCZA78oQAKCRDB/BR4rcrs Cf6zB/0eoZBQgKLXSRBSgpHLu+MlmE6cHo/846kLcdkdzaROLzniQyY2NJoz78kgzBxtLN+NUEj nHP8TLO0mcrFKlmF1G1C71bR0HwcOOWA5guicQZ33DIjpyEj5Poef/XjET7SILh09CntWgDH3t3 a5p9LUfG23pLleOxpmMcUPIjCvrucMvpM9hkEAQqkdSddPrUkEf9CNRVnVZbyj3UgbamIkLfElK DoCs12GKHAHZxTXQRtAVAzDGFu1ca+zGN13WWGvgaty6OzgcCjxMILUdoy8cYI2myaXljAfRlA4 Qdr/lvBbqoaKctBm8pIrbwb/sK0JLelntECfDzvNEspJOtHM
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

this patch set converts the platform drivers below
drivers/net/ethernet/freescale to the .remove_new() callback. Compared to the
traditional .remove() this one returns void. This is a good thing because the
driver core (mostly) ignores the return value and still removes the device
binding. This is part of a bigger effort to convert all 2000+ platform
drivers to this new callback to eventually change .remove() itself to
return void.

The first two patches here are preparation, the following patches
actually convert the drivers.

Best regards
Uwe

Uwe Kleine-König (9):
  net: dpaa: Improve error reporting
  net: fec: Don't return early on error in .remove()
  net: dpaa: Convert to platform remove callback returning void
  net: fec: Convert to platform remove callback returning void
  net: fman: Convert to platform remove callback returning void
  net: fs_enet: Convert to platform remove callback returning void
  net: fsl_pq_mdio: Convert to platform remove callback returning void
  net: gianfar: Convert to platform remove callback returning void
  net: ucc_geth: Convert to platform remove callback returning void

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c        |  8 ++++----
 drivers/net/ethernet/freescale/fec_main.c             | 11 ++++-------
 drivers/net/ethernet/freescale/fec_mpc52xx.c          |  6 ++----
 drivers/net/ethernet/freescale/fec_mpc52xx_phy.c      |  6 ++----
 drivers/net/ethernet/freescale/fman/mac.c             |  5 ++---
 drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c |  5 ++---
 drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c  |  6 ++----
 drivers/net/ethernet/freescale/fs_enet/mii-fec.c      |  6 ++----
 drivers/net/ethernet/freescale/fsl_pq_mdio.c          |  6 ++----
 drivers/net/ethernet/freescale/gianfar.c              |  6 ++----
 drivers/net/ethernet/freescale/ucc_geth.c             |  6 ++----
 11 files changed, 26 insertions(+), 45 deletions(-)

base-commit: fe15c26ee26efa11741a7b632e9f23b01aca4cc6
-- 
2.39.1

