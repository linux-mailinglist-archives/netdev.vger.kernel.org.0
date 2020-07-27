Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A59822EACD
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 13:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbgG0LHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 07:07:14 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:40719 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728546AbgG0LGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 07:06:17 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 27 Jul 2020 14:06:14 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (dev-l-vrt-135.mtl.labs.mlnx [10.234.135.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 06RB6E8t022257;
        Mon, 27 Jul 2020 14:06:14 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Debian-10) with ESMTP id 06RB6Ef6002408;
        Mon, 27 Jul 2020 14:06:14 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 06RB6EJV002407;
        Mon, 27 Jul 2020 14:06:14 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next RFC 13/13] devlink: Add Documentation/networking/devlink/devlink-reload.rst
Date:   Mon, 27 Jul 2020 14:02:33 +0300
Message-Id: <1595847753-2234-14-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
References: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devlink reload rst documentation file.
Update index file to include it.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
---
 .../networking/devlink/devlink-reload.rst     | 56 +++++++++++++++++++
 Documentation/networking/devlink/index.rst    |  1 +
 2 files changed, 57 insertions(+)
 create mode 100644 Documentation/networking/devlink/devlink-reload.rst

diff --git a/Documentation/networking/devlink/devlink-reload.rst b/Documentation/networking/devlink/devlink-reload.rst
new file mode 100644
index 000000000000..092574229bab
--- /dev/null
+++ b/Documentation/networking/devlink/devlink-reload.rst
@@ -0,0 +1,56 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==============
+Devlink Reload
+==============
+
+``devlink-reload`` provides mechanism to reload either driver or firmware or both,
+depends on reload level selected.
+The driver reload is used to re-initiate driver's entities, including applying
+new values to ``devlink`` entities which are used during driver load, such as
+``devlink-params`` in configuration mode ``driverinit`` or ``devlink-resources``.
+The firmware reload is used either to reset the firmware or upgrade the firmware
+if new firmware is already stored and waiting to be activated.
+Some driver's may support fw_live_patch which will do firmware upgrade,
+applying changes without the need for reset.
+
+Reload levels
+=============
+
+Reload may be set in different reload levels.
+
+.. list-table:: Possible reload levels
+   :widths: 5 90
+
+   * - Name
+     - Description
+   * - ``driver``
+     - Driver entities re-instantiation only.
+   * - ``fw_reset``
+     - Firmware reset and driver entities re-instantiation. Can be used for
+       firmware upgrade if new firmware is stored and driver supports such
+       firmware upgrade.
+   * - ``fw_live_patch``
+     - Firmware live patch, applies firmware changes without reset.
+
+Change namespace
+================
+
+All devlink instances are created in init_net and stay there for a
+lifetime. Allow user to be able to move devlink instances into
+namespaces during devlink reload operation. That ensures proper
+re-instantiation of driver objects, including netdevices.
+
+example usage
+-------------
+
+.. code:: shell
+
+    $ devlink dev reload help
+    $ devlink dev reload DEV [ netns { PID | NAME | ID } ] [ level { driver | fw_reset | fw_live_patch } ]
+
+    # Run reload command with driver's default level:
+    $ devlink dev reload pci/0000:82:00.0
+
+    # Run reload command with fw_reset level:
+    $ devlink dev reload pci/0000:82:00.0 level fw_reset
diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
index 7684ae5c4a4a..d82874760ae2 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -20,6 +20,7 @@ general.
    devlink-params
    devlink-region
    devlink-resource
+   devlink-reload
    devlink-trap
 
 Driver-specific documentation
-- 
2.17.1

