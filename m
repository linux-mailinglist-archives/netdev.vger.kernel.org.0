Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC3F4F2D5
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 11:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbfD3J2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 05:28:39 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:35764 "EHLO
        michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbfD3J2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 05:28:37 -0400
Received: from ramsan ([84.194.111.163])
        by michel.telenet-ops.be with bizsmtp
        id 6ZUZ2000S3XaVaC06ZUZGA; Tue, 30 Apr 2019 11:28:35 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hLP3x-0007LX-Ev; Tue, 30 Apr 2019 11:28:33 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hLP3x-0001vi-CX; Tue, 30 Apr 2019 11:28:33 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>, linux-pm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH -next] mlxsw: Remove obsolete dependency on THERMAL=m
Date:   Tue, 30 Apr 2019 11:28:32 +0200
Message-Id: <20190430092832.7376-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The THERMAL configuration option was changed from tristate to bool, but
a dependency on THERMAL=m was forgotten, leading to a warning when
running "make savedefconfig":

    boolean symbol THERMAL tested for 'm'? test forced to 'n'

Fixes: be33e4fbbea581ea ("thermal/drivers/core: Remove the module Kconfig's option")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/ethernet/mellanox/mlxsw/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/Kconfig b/drivers/net/ethernet/mellanox/mlxsw/Kconfig
index b6b3ff0fe17f5c4e..7ccb950aa7d4aa30 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlxsw/Kconfig
@@ -22,7 +22,6 @@ config MLXSW_CORE_HWMON
 config MLXSW_CORE_THERMAL
 	bool "Thermal zone support for Mellanox Technologies Switch ASICs"
 	depends on MLXSW_CORE && THERMAL
-	depends on !(MLXSW_CORE=y && THERMAL=m)
 	default y
 	---help---
 	 Say Y here if you want to automatically control fans speed according
-- 
2.17.1

