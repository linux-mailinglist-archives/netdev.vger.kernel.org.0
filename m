Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABEF02C8E97
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 21:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbgK3UBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 15:01:25 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:13948 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727374AbgK3UBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 15:01:25 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc54f750001>; Mon, 30 Nov 2020 12:00:53 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 30 Nov
 2020 20:00:44 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <jacob.e.keller@intel.com>, Parav Pandit <parav@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v2] devlink: Add devlink port documentation
Date:   Mon, 30 Nov 2020 22:00:25 +0200
Message-ID: <20201130200025.573239-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201130164119.571362-1-parav@nvidia.com>
References: <20201130164119.571362-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606766453; bh=Jpk9hJD771S4dwi4G8b5PrdhyB/LWpSBQcKmK9MR3Lo=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=fjIg2GrUZvCqWGFn0n8lbFb3olEgu4TGJy5d3fGNKGCdGTyKxgXhzGLRcs2lTBeCj
         fwqJUsguz0KiBSG9kmvZsqXcT6Uus4icZePFo3HHrc+6q5jlc8gCNYT4Gjl9R9YdFW
         qHwF7MJ5EEIiVjRWBIibhDHSlkruLH2WweC5204ZraCd1eOVfEIA+5YN05Do5PLBJh
         VUc8WgRQamdSEE9tYwSlOBGTBUDBkq6AuAjfkbJ7l6HVHv9Oi/+X9D9PBLauQguiN9
         19onZs4KHWydXDYPx7sIrr0tMeIFDtrGjogpU8mo0mdQyKOVi/uQF9Jro763PxEPiL
         FeXVRAgKVPJKA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added documentation for devlink port and port function related commands.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
Changelog:
v1->v2:
 - Removed duplicate table entries for DEVLINK_PORT_FLAVOUR_VIRTUAL.
 - replaced 'consist of' to 'consisting'
 - changed 'can be' to 'can be of'
---
 .../networking/devlink/devlink-port.rst       | 100 ++++++++++++++++++
 Documentation/networking/devlink/index.rst    |   1 +
 2 files changed, 101 insertions(+)
 create mode 100644 Documentation/networking/devlink/devlink-port.rst

diff --git a/Documentation/networking/devlink/devlink-port.rst b/Documentat=
ion/networking/devlink/devlink-port.rst
new file mode 100644
index 000000000000..f3ed65acbd52
--- /dev/null
+++ b/Documentation/networking/devlink/devlink-port.rst
@@ -0,0 +1,100 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+Devlink Port
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+``devlink-port`` provides capability for a driver to expose various
+flavours of ports which exist on device. A devlink port can be of an
+embedded switch (eswitch) present on the device.
+
+A devlink port can be of 3 diffferent types.
+
+.. list-table:: List of devlink port types
+   :widths: 23 90
+
+   * - Type
+     - Description
+   * - ``DEVLINK_PORT_TYPE_ETH``
+     - This type is set for a devlink port when a physical link layer of t=
he port
+       is Ethernet.
+   * - ``DEVLINK_PORT_TYPE_IB``
+     - This type is set for a devlink port when a physical link layer of t=
he port
+       is InfiniBand.
+   * - ``DEVLINK_PORT_TYPE_AUTO``
+     - This type is indicated by the user when user prefers to set the por=
t type
+       to be automatically detected by the device driver.
+
+Devlink port can be of few different flavours described below.
+
+.. list-table:: List of devlink port flavours
+   :widths: 33 90
+
+   * - Flavour
+     - Description
+   * - ``DEVLINK_PORT_FLAVOUR_PHYSICAL``
+     - Any kind of port which is physically facing the user. This can be
+       a eswitch physical port or any other physical port on the device.
+   * - ``DEVLINK_PORT_FLAVOUR_CPU``
+     - This indicates a CPU port.
+   * - ``DEVLINK_PORT_FLAVOUR_DSA``
+     - This indicates a interconnect port in a distributed switch architec=
ture.
+   * - ``DEVLINK_PORT_FLAVOUR_PCI_PF``
+     - This indicates an eswitch port representing PCI physical function(P=
F).
+   * - ``DEVLINK_PORT_FLAVOUR_PCI_VF``
+     - This indicates an eswitch port representing PCI virtual function(VF=
).
+   * - ``DEVLINK_PORT_FLAVOUR_VIRTUAL``
+     - This indicates a virtual port facing the user.
+
+A devlink port may be for a controller consisting one or more PCI device(s=
).
+A devlink instance holds ports of two types of controllers.
+
+(1) controller discovered on same system where eswitch resides
+This is the case where PCI PF/VF of a controller and devlink eswitch
+instance both are located on a single system.
+
+(2) controller located on external host system.
+This is the case where a controller is located in one system and its
+devlink eswitch ports are located in a different system.
+
+An example view of two controller systems::
+
+                 ---------------------------------------------------------
+                 |                                                       |
+                 |           --------- ---------         ------- ------- |
+    -----------  |           | vf(s) | | sf(s) |         |vf(s)| |sf(s)| |
+    | server  |  | -------   ----/---- ---/----- ------- ---/--- ---/--- |
+    | pci rc  |=3D=3D=3D | pf0 |______/________/       | pf1 |___/_______/=
     |
+    | connect |  | -------                       -------                 |
+    -----------  |     | controller_num=3D1 (no eswitch)                  =
 |
+                 ------|--------------------------------------------------
+                 (internal wire)
+                       |
+                 ---------------------------------------------------------
+                 | devlink eswitch ports and reps                        |
+                 | ----------------------------------------------------- |
+                 | |ctrl-0 | ctrl-0 | ctrl-0 | ctrl-0 | ctrl-0 |ctrl-0 | |
+                 | |pf0    | pf0vfN | pf0sfN | pf1    | pf1vfN |pf1sfN | |
+                 | ----------------------------------------------------- |
+                 | |ctrl-1 | ctrl-1 | ctrl-1 | ctrl-1 | ctrl-1 |ctrl-1 | |
+                 | |pf0    | pf0vfN | pf0sfN | pf1    | pf1vfN |pf1sfN | |
+                 | ----------------------------------------------------- |
+                 |                                                       |
+                 |                                                       |
+                 |           --------- ---------         ------- ------- |
+                 |           | vf(s) | | sf(s) |         |vf(s)| |sf(s)| |
+                 | -------   ----/---- ---/----- ------- ---/--- ---/--- |
+                 | | pf0 |______/________/       | pf1 |___/_______/     |
+                 | -------                       -------                 |
+                 |                                                       |
+                 |  local controller_num=3D0 (eswitch)                    =
 |
+                 ---------------------------------------------------------
+
+Port function configuration
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
+
+When a port flavor is ``DEVLINK_PORT_FLAVOUR_PCI_PF`` or
+``DEVLINK_PORT_FLAVOUR_PCI_VF``, it represents the port of a PCI function.
+A user can configure the port function attributes before enumerating the
+function. For example user may set the hardware address of the function
+represented by the devlink port.
diff --git a/Documentation/networking/devlink/index.rst b/Documentation/net=
working/devlink/index.rst
index d82874760ae2..aab79667f97b 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -18,6 +18,7 @@ general.
    devlink-info
    devlink-flash
    devlink-params
+   devlink-port
    devlink-region
    devlink-resource
    devlink-reload
--=20
2.26.2

