Return-Path: <netdev+bounces-2308-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E3A770115E
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 23:33:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4422E1C212EE
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 21:33:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFF8C261EA;
	Fri, 12 May 2023 21:28:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49A8138F
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 21:28:49 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62CD4E713
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 14:28:27 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIe-0005HQ-DI; Fri, 12 May 2023 23:27:40 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIU-0033Vk-UV; Fri, 12 May 2023 23:27:30 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIU-003qhX-9g; Fri, 12 May 2023 23:27:30 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Wolfgang Grandegger <wg@grandegger.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	=?utf-8?q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Minghao Chi <chi.minghao@zte.com.cn>,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Wei Fang <wei.fang@nxp.com>,
	Rob Herring <robh@kernel.org>,
	Pavel Pisa <pisa@cmp.felk.cvut.cz>,
	Ondrej Ille <ondrej.ille@gmail.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Haibo Chen <haibo.chen@nxp.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Yang Yingliang <yangyingliang@huawei.com>,
	Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
	Chris Packham <chris.packham@alliedtelesis.co.nz>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Wolfram Sang <wsa@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Simon Horman <simon.horman@corigine.com>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Chen-Yu Tsai <wens@csie.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>,
	Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
	Michal Simek <michal.simek@amd.com>
Cc: linux-can@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kernel@pengutronix.de,
	linux-sunxi@lists.linux.dev,
	Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>
Subject: [PATCH net-next 00/19] can: Convert to platform remove callback returning void
Date: Fri, 12 May 2023 23:27:06 +0200
Message-Id: <20230512212725.143824-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=3125; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=CIVa8xJjV/wvM1n16ALppP7HbOG+7K8Otx33EB/s+c0=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkXq8jGmHgDZEf5cFd1OBFCsjWWCUAe06FRikIq ds4QLnPzAqJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZF6vIwAKCRCPgPtYfRL+ TmYxB/9iNwRB5UaB0O45PJH5RdP8FrqojNP8biv2y/VJGnuzlX8A/i0R+iAnz8Tjwn/doXTpQY1 DupInE8JbPNoloyz40iQR35UMlBZJctUUwsOnbhw8VoKR1t+kXUilqDqXJ/JqRVqV/FvaZnvJVo 6znakdpOYzjF8HttRpv35yOAMGdqOrWTQ8OBiJsz7BODeLQ5NORuHwNqY8J6bVMsBiY12dGiabB rTVqins7zFASXM4Wa/2/twpOEAjhmomMDvXEeDu35JfCpgEyEF8VNZBXb4XZU1FQMxcyFRfeU9k I8CHT0COd2M7AlGhwZnwX9y42GojbmwzsygTn8CYGVlD19Em
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

this series convers the drivers below drivers/net/can to the
.remove_new() callback of struct platform_driver(). The motivation is to
make the remove callback less prone for errors and wrong assumptions.
See commit 5c5a7680e67b ("platform: Provide a remove callback that
returns no value") for a more detailed rationale.

All drivers already returned zero unconditionally in their
.remove() callback, so converting them to .remove_new() is trivial.

Best regards
Uwe

Uwe Kleine-König (19):
  can: at91_can: Convert to platform remove callback returning void
  can: bxcan: Convert to platform remove callback returning void
  can: c_can: Convert to platform remove callback returning void
  can: cc770_isa: Convert to platform remove callback returning void
  can: cc770_platform: Convert to platform remove callback returning void
  can: ctucanfd: Convert to platform remove callback returning void
  can: flexcan: Convert to platform remove callback returning void
  can: grcan: Convert to platform remove callback returning void
  can: ifi_canfd: Convert to platform remove callback returning void
  can: janz-ican3: Convert to platform remove callback returning void
  can: m_can: Convert to platform remove callback returning void
  can: mscan/mpc5xxx_can.c -- Convert to platform remove callback returning void
  can: rcar: Convert to platform remove callback returning void
  can: sja1000_isa: Convert to platform remove callback returning void
  can: sja1000_platform: Convert to platform remove callback returning void
  can: softing: Convert to platform remove callback returning void
  can: sun4i_can: Convert to platform remove callback returning void
  can: ti_hecc: Convert to platform remove callback returning void
  can: xilinx: Convert to platform remove callback returning void

 drivers/net/can/at91_can.c                   | 6 ++----
 drivers/net/can/bxcan.c                      | 5 ++---
 drivers/net/can/c_can/c_can_platform.c       | 6 ++----
 drivers/net/can/cc770/cc770_isa.c            | 6 ++----
 drivers/net/can/cc770/cc770_platform.c       | 6 ++----
 drivers/net/can/ctucanfd/ctucanfd_platform.c | 6 ++----
 drivers/net/can/flexcan/flexcan-core.c       | 6 ++----
 drivers/net/can/grcan.c                      | 6 ++----
 drivers/net/can/ifi_canfd/ifi_canfd.c        | 6 ++----
 drivers/net/can/janz-ican3.c                 | 6 ++----
 drivers/net/can/m_can/m_can_platform.c       | 6 ++----
 drivers/net/can/mscan/mpc5xxx_can.c          | 6 ++----
 drivers/net/can/rcar/rcar_can.c              | 5 ++---
 drivers/net/can/rcar/rcar_canfd.c            | 6 ++----
 drivers/net/can/sja1000/sja1000_isa.c        | 6 ++----
 drivers/net/can/sja1000/sja1000_platform.c   | 6 ++----
 drivers/net/can/softing/softing_main.c       | 5 ++---
 drivers/net/can/sun4i_can.c                  | 6 ++----
 drivers/net/can/ti_hecc.c                    | 6 ++----
 drivers/net/can/xilinx_can.c                 | 6 ++----
 20 files changed, 40 insertions(+), 77 deletions(-)


base-commit: ac9a78681b921877518763ba0e89202254349d1b
-- 
2.39.2


