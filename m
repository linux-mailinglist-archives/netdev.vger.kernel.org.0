Return-Path: <netdev+bounces-9983-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BB0EE72B8F6
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:45:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 872E2281124
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 07:45:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03690D52D;
	Mon, 12 Jun 2023 07:45:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1961FA5
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 07:45:03 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5115172C
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 00:44:35 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1q8bsg-0001qo-Ig; Mon, 12 Jun 2023 09:22:26 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q8bsf-006ph4-KV; Mon, 12 Jun 2023 09:22:25 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q8bse-00DQdR-SW; Mon, 12 Jun 2023 09:22:24 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH] net: mlxsw: i2c: Switch back to use struct i2c_driver's .probe()
Date: Mon, 12 Jun 2023 09:22:22 +0200
Message-Id: <20230612072222.839292-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1116; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=C5dhvWoG6VIxcUYh22EeC3T4rZBQYuNsNKJ01m/QYhA=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkhsetkVwPNJzUON7MgOugs50/Ox/kRFkI909Kk Qo92510CiCJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZIbHrQAKCRCPgPtYfRL+ Tll2B/9fjkbeFoNGMeKFWf49aTk7kERLO2qOmrFIjbo+Rn5wgVgEB+A93pFmXn38ENYREn7oNW0 PcMh1OsKSVbWJ80EXeOLv6RXH+YaETjWOjGOk/cMfbFu0wocs4UoZFeD3kKCJwXu+QmyNv1S1/8 y8YH6WacgXrdFZea4CUgZAoNX1IH/b+vrA0mBETz78FHf5ks/SXykwuNxfoqcBHPzo2X0RciYOs fuOX0Mrr8oIDYM4VmWEXfPthe3IDPk1wCr2wtHibaiNgkEsgED8oL0tMnoI/mVw9I9TKiw6/vXo HckDO1CGRc1/u5Y+a4z9VsYYHn+nff2V1Gna6Rb9PBMGE14P
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

After commit b8a1a4cd5a98 ("i2c: Provide a temporary .probe_new()
call-back type"), all drivers being converted to .probe_new() and then
commit 03c835f498b5 ("i2c: Switch .probe() to not take an id parameter")
convert back to (the new) .probe() to be able to eventually drop
.probe_new() from struct i2c_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/ethernet/mellanox/mlxsw/i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/i2c.c b/drivers/net/ethernet/mellanox/mlxsw/i2c.c
index 2c586c2308ae..41298835a11e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/i2c.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/i2c.c
@@ -751,7 +751,7 @@ static void mlxsw_i2c_remove(struct i2c_client *client)
 
 int mlxsw_i2c_driver_register(struct i2c_driver *i2c_driver)
 {
-	i2c_driver->probe_new = mlxsw_i2c_probe;
+	i2c_driver->probe = mlxsw_i2c_probe;
 	i2c_driver->remove = mlxsw_i2c_remove;
 	return i2c_add_driver(i2c_driver);
 }

base-commit: ac9a78681b921877518763ba0e89202254349d1b
-- 
2.39.2


