Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8F31AE20F
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 18:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729981AbgDQQUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 12:20:32 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:54726 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729581AbgDQQUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 12:20:32 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id 1A17C2A2AE9
From:   Andrzej Pietrasiewicz <andrzej.p@collabora.com>
To:     linux-pm@vger.kernel.org
Cc:     Zhang Rui <rui.zhang@intel.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Peter Kaestle <peter@piie.net>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Support Opensource <support.opensource@diasemi.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Allison Randal <allison@lohutok.net>,
        Enrico Weigelt <info@metux.net>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Barlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [RFC v3 0/2] Stop monitoring disabled devices
Date:   Fri, 17 Apr 2020 18:20:18 +0200
Message-Id: <20200417162020.19980-1-andrzej.p@collabora.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <9ac3b37a-8746-b8ee-70e1-9c876830ac83@linaro.org>
References: <9ac3b37a-8746-b8ee-70e1-9c876830ac83@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the third iteration of this RFC. It has been substantially
rewritten compared to v2.

The first patch makes all the drivers store their mode in struct
thermal_zone_device. Such a move has consequences: driver-specific
variables for storing mode are not necessary. Consequently get_mode()
methods become obsolete. Then sysfs "mode" attribute stops depending
on get_mode() being provided, because it is always provided from now on.

The first patch also introduces the initial mode to be optionally passed
to thermal_zone_device_register().

Given all the groundwork done in patch 1/2 patch 2/2 becomes very simple.

This series addresses comments from Daniel and Bartlomiej - thank you guys!

Andrzej Pietrasiewicz (2):
  thermal: core: Let thermal zone device's mode be stored in its struct
  thermal: core: Stop polling DISABLED thermal devices

 drivers/acpi/thermal.c                        | 46 +++++---------
 .../ethernet/mellanox/mlxsw/core_thermal.c    | 57 ++++--------------
 drivers/platform/x86/acerhdf.c                | 17 +-----
 drivers/thermal/da9062-thermal.c              | 16 ++---
 drivers/thermal/imx_thermal.c                 | 29 +++------
 .../intel/int340x_thermal/int3400_thermal.c   | 30 ++--------
 .../thermal/intel/intel_quark_dts_thermal.c   | 22 ++-----
 drivers/thermal/of-thermal.c                  | 30 +++-------
 drivers/thermal/thermal_core.c                | 60 +++++++++++++++++--
 drivers/thermal/thermal_core.h                | 16 +++++
 drivers/thermal/thermal_sysfs.c               | 29 +--------
 include/linux/thermal.h                       |  7 ++-
 12 files changed, 139 insertions(+), 220 deletions(-)

-- 
2.17.1

