Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89D3C649DA8
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbiLLLbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:31:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbiLLLbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:31:11 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0166616C
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 03:31:04 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p4h1S-0000QC-Rg
        for netdev@vger.kernel.org; Mon, 12 Dec 2022 12:31:02 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id A116C13CBFF
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 11:30:55 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id E7B1613CBB7;
        Mon, 12 Dec 2022 11:30:53 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id cbc7e61b;
        Mon, 12 Dec 2022 11:30:47 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 21/39] Documentation: devlink: add devlink documentation for the etas_es58x driver
Date:   Mon, 12 Dec 2022 12:30:27 +0100
Message-Id: <20221212113045.222493-22-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221212113045.222493-1-mkl@pengutronix.de>
References: <20221212113045.222493-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

List all the version information reported by the etas_es58x driver
through devlink. Also, update MAINTAINERS with the newly created file.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/20221130174658.29282-8-mailhol.vincent@wanadoo.fr
[mkl: fixed version information table: "bl" -> "fw.bootloader"
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../networking/devlink/etas_es58x.rst         | 36 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 2 files changed, 37 insertions(+)
 create mode 100644 Documentation/networking/devlink/etas_es58x.rst

diff --git a/Documentation/networking/devlink/etas_es58x.rst b/Documentation/networking/devlink/etas_es58x.rst
new file mode 100644
index 000000000000..3b857d82a44c
--- /dev/null
+++ b/Documentation/networking/devlink/etas_es58x.rst
@@ -0,0 +1,36 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==========================
+etas_es58x devlink support
+==========================
+
+This document describes the devlink features implemented by the
+``etas_es58x`` device driver.
+
+Info versions
+=============
+
+The ``etas_es58x`` driver reports the following versions
+
+.. list-table:: devlink info versions implemented
+   :widths: 5 5 90
+
+   * - Name
+     - Type
+     - Description
+   * - ``fw``
+     - running
+     - Version of the firmware running on the device. Also available
+       through ``ethtool -i`` as the first member of the
+       ``firmware-version``.
+   * - ``fw.bootloader``
+     - running
+     - Version of the bootloader running on the device. Also available
+       through ``ethtool -i`` as the second member of the
+       ``firmware-version``.
+   * - ``board.rev``
+     - fixed
+     - The hardware revision of the device.
+   * - ``serial_number``
+     - fixed
+     - The USB serial number. Also available through ``lsusb -v``.
diff --git a/MAINTAINERS b/MAINTAINERS
index 955c1be1efb2..71f4f8776779 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7682,6 +7682,7 @@ ETAS ES58X CAN/USB DRIVER
 M:	Vincent Mailhol <mailhol.vincent@wanadoo.fr>
 L:	linux-can@vger.kernel.org
 S:	Maintained
+F:	Documentation/networking/devlink/etas_es58x.rst
 F:	drivers/net/can/usb/etas_es58x/
 
 ETHERNET BRIDGE
-- 
2.35.1


