Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 537BF63DC6C
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 18:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbiK3Rse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 12:48:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiK3RsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 12:48:08 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C359DF8;
        Wed, 30 Nov 2022 09:47:32 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id r18so16736778pgr.12;
        Wed, 30 Nov 2022 09:47:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cBWVgR+RLUqkJ8KuTZNticMrWH5FaJ887K/c4/dMWdA=;
        b=WsjXgGWo66TTf4k4CxDjO+Yxift66oL1FoKPNxBbihKtuoOA6A11uvbDG1PwudCgXQ
         w2Ti5aXY8NPBiYPRx1hyWUXPmCkOESo3MEfV2IflpG7PcWR5dtjp0WF24VSI2s/8jqEl
         u0Zs46TlIevVudlrikGM7pRi4OV7QB008WyTpDuAw4c5SX+SWGbr7y10DFDAgzZ+CEnd
         +07OmOj6ViR0TZqXMuxH+nduGu3vUSf9+2P3pSXh/Z8SIDh1Zyl8nMfCKI49nfag8N7p
         x6YY/OHtrnAAu/wR7sapVecrlvjsHAfYrOtnVtWdTb2qLKrbft82Y93QZwMsWIzWv9tf
         kTCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cBWVgR+RLUqkJ8KuTZNticMrWH5FaJ887K/c4/dMWdA=;
        b=fW70i49ADstA59XQ8pgtgeVJfjFfOKyuYCcEUi3VkErUxEBOE45uRiM9PeeZ2iPutT
         NihDMKpVYvRELdg2xw8opexIiKvI5CwuR4ekkBZgLY/V/+B3/0XUGJos/IIY1607+p5d
         Mx2Srcr3MGMTMSGEnO6FE60a/QfyldRhI8LG/vjfzZ0K48O6gvYy55B8NlEnnYCjmpPs
         vbN2PV2yCGOeVq4Q/x/jbmfS4WdbQNnmWYaT5DfkRIpwdbg9Bzrc6LGrkCti5RZdh14h
         161Gl2fbbFCG99+rA3DLYzlSjGcDjSBbu06xzvGZF3EGd/RZLbXTMMz7gwevlv5PhtDN
         09Gg==
X-Gm-Message-State: ANoB5plzxDzBqMAmOlEPSUJ4PM1X9VYrTGq5bvZgwAJ6sjQ+Sr6/B0xi
        1lnh+YMYnZB2L6PZ7TzLwFDuKF+tjikdew==
X-Google-Smtp-Source: AA0mqf6+iAYcgK40TW/F0ayXJMs5DDcd7U+Q10WoXb0OwWhIMHR8WWRiUQOxMJTsUAUBjvY3o6NNAQ==
X-Received: by 2002:a63:1345:0:b0:476:f92f:69f0 with SMTP id 5-20020a631345000000b00476f92f69f0mr55727855pgt.463.1669830451644;
        Wed, 30 Nov 2022 09:47:31 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id p3-20020aa79e83000000b00574cdb63f03sm1714505pfq.144.2022.11.30.09.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 09:47:31 -0800 (PST)
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
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v5 7/7] Documentation: devlink: add devlink documentation for the etas_es58x driver
Date:   Thu,  1 Dec 2022 02:46:58 +0900
Message-Id: <20221130174658.29282-8-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221130174658.29282-1-mailhol.vincent@wanadoo.fr>
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221130174658.29282-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

List all the version information reported by the etas_es58x driver
through devlink. Also, update MAINTAINERS with the newly created file.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 .../networking/devlink/etas_es58x.rst         | 36 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 2 files changed, 37 insertions(+)
 create mode 100644 Documentation/networking/devlink/etas_es58x.rst

diff --git a/Documentation/networking/devlink/etas_es58x.rst b/Documentation/networking/devlink/etas_es58x.rst
new file mode 100644
index 000000000000..9893e57b625a
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
+   * - ``bl``
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
2.37.4

