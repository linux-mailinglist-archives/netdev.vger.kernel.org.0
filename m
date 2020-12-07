Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666322D1D05
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 23:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgLGWOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 17:14:47 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:17298 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727783AbgLGWOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 17:14:47 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fcea92e0004>; Mon, 07 Dec 2020 14:14:06 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 7 Dec
 2020 22:14:04 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <jacob.e.keller@intel.com>, Parav Pandit <parav@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v5] devlink: Add devlink port documentation
Date:   Tue, 8 Dec 2020 00:13:42 +0200
Message-ID: <20201207221342.553976-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201130164119.571362-1-parav@nvidia.com>
References: <20201130164119.571362-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607379246; bh=KB71SKYP1m02ESzB9nq4flSHDUWruZVdtpwb1yX/tmQ=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=XKGZ1RaP7J5bYfhgrmnJE82GLuKty0BTR98C5da0cKNowW5frgNoaEg9eRKYd/MIX
         T+Uyxq/0CDmt4aH4shcOFtO/LMKMWYz5D3S9AoQtqp3r3zUJ74BGH84GiwS1Ex5mre
         y+MlaS6R3QA9Tz4IIiTEDJKLlFGClo8Rhk59+4V8y35bHjXFgEM4NtNmx/aU4b6+AT
         OEkLfb4ljp5noNEKyDXU8psGq4UlWigL3yeltuhFHY77Zh4mC+IJ2TeD+TKIME/MXG
         UzxFvxH6PKpktezlzZGx0n6c2gPfxAk7XRdEuzlczrDXUnMKWCGycWFKwXZcPwoSnY
         dxJij1/tpcdIw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added documentation for devlink port and port function related commands.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
Changelog:
v4->v5:
 - described logically ingress and egress point of devlink port
 - removed networking from devlink port description
 - rephrased port type description
 - introdue PCI controller section and description
 - rephrased controller, device, function description
 - removed confusing eswitch to system wording
 - rephrased port function description
 - added example of mac address in port function attribute description
v3->v4:
 - changed 'exist' to 'exists'
 - added 'an' eswitch
 - changed 'can have one' to 'consists of'
 - changed 'who intents' to 'that intends'
 - removed unnecessary comma
 - rewrote description for the example diagram
 - changed 'controller consist of' to 'controller consists of'
v2->v3:
 - rephrased many lines
 - first paragraph now describe devlink port
 - instead of saying PCI device/function, using PCI function every
   where
 - changed 'physical link layer' to 'link layer'
 - made devlink port type description more clear
 - made devlink port flavour description more clear
 - moved devlink port type table after port flavour
 - added description for the example diagram
 - describe CPU port that its linked to DSA
 - made devlink port description for eswitch port more clear
v1->v2:
 - Removed duplicate table entries for DEVLINK_PORT_FLAVOUR_VIRTUAL.
 - replaced 'consist of' to 'consisting'
 - changed 'can be' to 'can be of'
---
 .../networking/devlink/devlink-port.rst       | 116 ++++++++++++++++++
 Documentation/networking/devlink/index.rst    |   1 +
 2 files changed, 117 insertions(+)
 create mode 100644 Documentation/networking/devlink/devlink-port.rst

diff --git a/Documentation/networking/devlink/devlink-port.rst b/Documentat=
ion/networking/devlink/devlink-port.rst
new file mode 100644
index 000000000000..dce87d2c07ac
--- /dev/null
+++ b/Documentation/networking/devlink/devlink-port.rst
@@ -0,0 +1,116 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+Devlink Port
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+``devlink-port`` is a port that exists on the device. It has a logically
+separate ingress/egress point of the device. A devlink port can be of one
+among many flavours. A devlink port flavour along with port attributes
+describe what a port represents.
+
+A device driver that intends to publish a devlink port sets the
+devlink port attributes and registers the devlink port.
+
+Devlink port flavours are described below.
+
+.. list-table:: List of devlink port flavours
+   :widths: 33 90
+
+   * - Flavour
+     - Description
+   * - ``DEVLINK_PORT_FLAVOUR_PHYSICAL``
+     - Any kind of physical networking port. This can be an eswitch physic=
al
+       port or any other physical port on the device.
+   * - ``DEVLINK_PORT_FLAVOUR_DSA``
+     - This indicates a DSA interconnect port.
+   * - ``DEVLINK_PORT_FLAVOUR_CPU``
+     - This indicates a CPU port applicable only to DSA.
+   * - ``DEVLINK_PORT_FLAVOUR_PCI_PF``
+     - This indicates an eswitch port representing a networking port of
+       PCI physical function (PF).
+   * - ``DEVLINK_PORT_FLAVOUR_PCI_VF``
+     - This indicates an eswitch port representing a networking port of
+       PCI virtual function (VF).
+   * - ``DEVLINK_PORT_FLAVOUR_VIRTUAL``
+     - This indicates a virtual port for the virtual PCI device such as PC=
I VF.
+
+Devlink port can have a different type based on the link layer described b=
elow.
+
+.. list-table:: List of devlink port types
+   :widths: 23 90
+
+   * - Type
+     - Description
+   * - ``DEVLINK_PORT_TYPE_ETH``
+     - Driver should set this port type when a link layer of the port is
+       Ethernet.
+   * - ``DEVLINK_PORT_TYPE_IB``
+     - Driver should set this port type when a link layer of the port is
+       InfiniBand.
+   * - ``DEVLINK_PORT_TYPE_AUTO``
+     - This type is indicated by the user when driver should detect the po=
rt
+       type automatically.
+
+PCI controllers
+---------------
+In most cases PCI device has only one controller. A controller consists of
+potentially multiple physical and virtual functions. Such PCI function con=
sists
+of one or more ports. This port of the function is represented by the devl=
ink
+eswitch port.
+
+A PCI Device connected to multiple CPUs or multiple PCI root complex or
+SmartNIC, however, may have multiple controllers. For a device with multip=
le
+controllers, each controller is distinguished by a unique controller numbe=
r.
+An eswitch on the PCI device may suppport ports of multiple controllers.=20
+
+An example view of two controller systems::
+
+In this example, external controller (identified by controller number =3D =
1)
+doesn't have eswitch. Local controller (identified by controller number =
=3D 0)
+has the eswitch. Devlink instance on local controller has eswitch devlink
+ports representing ports for both the controllers.
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
+    -----------  |           --------- ---------         ------- ------- |
+    | smartNIC|  |           | vf(s) | | sf(s) |         |vf(s)| |sf(s)| |
+    | pci rc  |=3D=3D| -------   ----/---- ---/----- ------- ---/--- ---/-=
-- |
+    | connect |  | | pf0 |______/________/       | pf1 |___/_______/     |
+    -----------  | -------                       -------                 |
+                 |                                                       |
+                 |  local controller_num=3D0 (eswitch)                    =
 |
+                 ---------------------------------------------------------
+
+Port function configuration
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
+
+A user can configure the port function attribute before enumerating the
+PCI function. Usually it means, user should configure port function attrib=
ute
+before a bus specific device for the function is created. However, when
+SRIOV is enabled, virtual function devices are created on the PCI bus.
+Hence, function attribute should be configured before binding virtual
+function device to the driver.
+
+User may set the hardware address of the function represented by the devli=
nk
+port function. For Ethernet port function this means a MAC address.
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

