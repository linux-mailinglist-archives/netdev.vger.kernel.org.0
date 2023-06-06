Return-Path: <netdev+bounces-8564-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78FF172492D
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 18:31:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 332A0280F9F
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 16:31:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F93533C86;
	Tue,  6 Jun 2023 16:29:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458372DBA3
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 16:29:12 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0669BFB
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:29:11 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1q6ZXy-00056g-MD; Tue, 06 Jun 2023 18:28:39 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q6ZXt-005Y5L-Jy; Tue, 06 Jun 2023 18:28:33 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q6ZXs-00Bl0H-T2; Tue, 06 Jun 2023 18:28:32 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Madalin Bucur <madalin.bucur@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Russell King <linux@armlinux.org.uk>,
	Wei Fang <wei.fang@nxp.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rob Herring <robh@kernel.org>,
	Pantelis Antoniou <pantelis.antoniou@gmail.com>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Li Yang <leoyang.li@nxp.com>,
	Andrew Lunn <andrew@lunn.ch>
Cc: netdev@vger.kernel.org,
	kernel@pengutronix.de,
	Shenwei Wang <shenwei.wang@nxp.com>,
	Clark Wang <xiaoning.wang@nxp.com>,
	NXP Linux Team <linux-imx@nxp.com>,
	Sean Anderson <sean.anderson@seco.com>,
	linuxppc-dev@lists.ozlabs.org
Subject: [PATCH net-next v2 0/8] net: freescale: Convert to platform remove callback returning void
Date: Tue,  6 Jun 2023 18:28:21 +0200
Message-Id: <20230606162829.166226-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2111; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=ifORGlB8NnnN7C0PLfACjVXzQ4yGeMnq54Ri1/2fUes=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkf16h12MYTSl4MZWUEKbTi+ZStZi9mSF55Lk12 UNajEQa70GJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZH9eoQAKCRCPgPtYfRL+ TrsQB/4pIc4JGD4LfFdOzHU4ZGmnbFCnJAhHq7RapDr2JPkLre7QHU4c+3sLh1J+z0llliMQMk5 A9WpCP+hboycBLCGSb+aUJoyDFXVLu2t4T6ZKZPLgdmjKefELscE5B5N+x8gYynWb6+bBDJP1hC m66XSjHCAekg23XQ4TJYD8ZMrLCxNGAkrOwURJuwNytzqZYK4KbjnT4O+bdz8TWZNO+toOB73lJ GaeP65oOXjaaUnbFhSzC6TvZdFmfkDlWhco9TjxePN1wSmRhMWTCx//lIEfJeb0YJOUfpcI2RRl VZ9jtlLxMZ61fy2d4mjS0NpMSbEfnO9aC9muZeT+EJoP6we8
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

(implicit) v1 of this series was sent in March and can be found at
https://lore.kernel.org/netdev/20230313103653.2753139-1-u.kleine-koenig@pengutronix.de

Changes since then:

 - Dropped "net: fec: Don't return early on error in .remove()", this is
   replaced by "net: fec: Better handle pm_runtime_get() failing in .remove()"
   which is already in v6.4-rc3 as f816b9829b19394d318e01953aa3b2721bca040d.

 - Simplified

	dev_err(&pdev->dev, ...

   to

	dev_err(dev, ...

   in patch #1; pointed out by Madalin Bucur.

 - Added some review tags received for v1.

Thanks to Madalin Bucur, Andrew Lunn, Michal Kubiak and Jakub Kicinski for
their replies to v1.

Best regards
Uwe

Uwe Kleine-König (8):
  net: dpaa: Improve error reporting
  net: dpaa: Convert to platform remove callback returning void
  net: fec: Convert to platform remove callback returning void
  net: fman: Convert to platform remove callback returning void
  net: fs_enet: Convert to platform remove callback returning void
  net: fsl_pq_mdio: Convert to platform remove callback returning void
  net: gianfar: Convert to platform remove callback returning void
  net: ucc_geth: Convert to platform remove callback returning void

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c        | 8 ++++----
 drivers/net/ethernet/freescale/fec_main.c             | 5 ++---
 drivers/net/ethernet/freescale/fec_mpc52xx.c          | 6 ++----
 drivers/net/ethernet/freescale/fec_mpc52xx_phy.c      | 6 ++----
 drivers/net/ethernet/freescale/fman/mac.c             | 5 ++---
 drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c | 5 ++---
 drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c  | 6 ++----
 drivers/net/ethernet/freescale/fs_enet/mii-fec.c      | 6 ++----
 drivers/net/ethernet/freescale/fsl_pq_mdio.c          | 6 ++----
 drivers/net/ethernet/freescale/gianfar.c              | 6 ++----
 drivers/net/ethernet/freescale/ucc_geth.c             | 6 ++----
 11 files changed, 24 insertions(+), 41 deletions(-)

base-commit: d4031ec844bc52fe7f2f844e9c476727fd6b8240
-- 
2.39.2


