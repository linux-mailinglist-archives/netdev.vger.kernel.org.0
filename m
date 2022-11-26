Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0AA63972B
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 17:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiKZQXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 11:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiKZQXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 11:23:12 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE92167D3;
        Sat, 26 Nov 2022 08:22:50 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id w79so6670287pfc.2;
        Sat, 26 Nov 2022 08:22:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vp+9zaIiM6o3AbLJPzloleeAqXF3PPreHB77EhGVkH4=;
        b=jJzS/vl3K9wBJJWaAASEZ3VJpJbW41iogkAB78k8y3rZDNrO95YRSR6teWO4S6INPI
         hAqkUqoINYo6VJ2+xfNyyDSDi4Seb1cOkiFIizhP/kzkyMSTyrY/gpQCwNFs1Ao7ARjR
         33v5YAET2nyB/AuntWUIFM0TNygUSDU5YH2pKoZJWtFNc60U+q3lAfPX+p3lanXz6L+/
         H4Z6Opw0/95H2FUUCwLTvoVmaYnMAqqUm9DsGa66nEawNVZ6UjbF6y9KVm8sRqo2SrEx
         0i9JVwA4BWl1i5mXq/t0tB9Kckd2VEtzsh+QzHAonCd9H8yV7Nx9h1hwo4YoYV3DqilO
         mwGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Vp+9zaIiM6o3AbLJPzloleeAqXF3PPreHB77EhGVkH4=;
        b=pok2hTFbbGKzyqi346K2KEpZ1bCCIuoGxJQCI0Bf3Ns911vFWBQxKn26GYn/bCSqb1
         6nZn2c+EvIaVtcwhadaiGwmzYuDOG4E4NlAktINVd8DywcrqCa0lsZJaIW9ETifzgHbt
         qklt9ApFfi6O2d9Gx/fPXITeU0PTHtLESYCWw9jpywn9NloJYPTFjLN1TUijVOx2z8fH
         4PvqqmU8zzDLYTBHYVyjY2o0A1iYtCg/QjmgoGZSyLIO28ZMKZ8f3kyakNeNt1AQuHa7
         QJ0J+VzFYuvwLE1v9eERV6SgEPRPCZ1I+ymczx+lT81mUis3nrClYIxc/6Q7GiUJFpxR
         RDEA==
X-Gm-Message-State: ANoB5pkLco4xXIB7wuv5YEZ2vE2bxW3IwUCGrVb5Jo476oM4aitArDHF
        vylX/pg369ZMV9EGk/A/BTxu/dZ5VGcFkg==
X-Google-Smtp-Source: AA0mqf4LP6zXi8g3B37g6l8jS1EUU+w57isv5IxyiwIefaSjnWCcO6NuZ37SOesqZ4uuil52AzNvdw==
X-Received: by 2002:a62:e80f:0:b0:574:cc3d:a23f with SMTP id c15-20020a62e80f000000b00574cc3da23fmr6887091pfi.53.1669479769553;
        Sat, 26 Nov 2022 08:22:49 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id y14-20020a63e24e000000b00460ea630c1bsm4169601pgj.46.2022.11.26.08.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Nov 2022 08:22:49 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     linux-can@vger.kernel.org
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Saeed Mahameed <saeed@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@nvidia.com>,
        Lukas Magel <lukas.magel@posteo.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v4 6/6] Documentation: devlink: add devlink documentation for the etas_es58x driver
Date:   Sun, 27 Nov 2022 01:22:11 +0900
Message-Id: <20221126162211.93322-7-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221126162211.93322-1-mailhol.vincent@wanadoo.fr>
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

List all the version information reported by the etas_es58x
driver. Also, update MAINTAINERS with the newly created file.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 .../networking/devlink/etas_es58x.rst         | 33 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 2 files changed, 34 insertions(+)
 create mode 100644 Documentation/networking/devlink/etas_es58x.rst

diff --git a/Documentation/networking/devlink/etas_es58x.rst b/Documentation/networking/devlink/etas_es58x.rst
new file mode 100644
index 000000000000..83f59713eed5
--- /dev/null
+++ b/Documentation/networking/devlink/etas_es58x.rst
@@ -0,0 +1,33 @@
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
+     - Version of firmware running on the device. Also available
+       through ``ethtool -i``.
+   * - ``bl``
+     - running
+     - Version of the bootloader running on the device.
+   * - ``board.rev``
+     - fixed
+     - The hardware revision of the device.
+   * - ``serial_number``
+     - fixed
+     - The USB serial number. Also available through ``lsusb -v``.
diff --git a/MAINTAINERS b/MAINTAINERS
index 61fe86968111..d95642683fc4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7686,6 +7686,7 @@ ETAS ES58X CAN/USB DRIVER
 M:	Vincent Mailhol <mailhol.vincent@wanadoo.fr>
 L:	linux-can@vger.kernel.org
 S:	Maintained
+F:	Documentation/networking/devlink/etas_es58x.rst
 F:	drivers/net/can/usb/etas_es58x/
 
 ETHERNET BRIDGE
-- 
2.37.4

