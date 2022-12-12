Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43191649DA5
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbiLLLbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:31:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232079AbiLLLbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:31:09 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD00624E
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 03:31:03 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p4h1R-0000Ll-8a
        for netdev@vger.kernel.org; Mon, 12 Dec 2022 12:31:01 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 0AA5413CBE4
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 11:30:54 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 67A3713CBA3;
        Mon, 12 Dec 2022 11:30:53 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id c50556f0;
        Mon, 12 Dec 2022 11:30:47 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 18/39] net: devlink: add DEVLINK_INFO_VERSION_GENERIC_FW_BOOTLOADER
Date:   Mon, 12 Dec 2022 12:30:24 +0100
Message-Id: <20221212113045.222493-19-mkl@pengutronix.de>
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

As discussed in [1], abbreviating the bootloader to "bl" might not be
well understood. Instead, a bootloader technically being a firmware,
name it "fw.bootloader".

Add a new macro to devlink.h to formalize this new info attribute name
and update the documentation.

[1] https://lore.kernel.org/netdev/20221128142723.2f826d20@kernel.org/

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/20221130174658.29282-5-mailhol.vincent@wanadoo.fr
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 Documentation/networking/devlink/devlink-info.rst | 5 +++++
 include/net/devlink.h                             | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-info.rst b/Documentation/networking/devlink/devlink-info.rst
index 7572bf6de5c1..1242b0e6826b 100644
--- a/Documentation/networking/devlink/devlink-info.rst
+++ b/Documentation/networking/devlink/devlink-info.rst
@@ -198,6 +198,11 @@ fw.bundle_id
 
 Unique identifier of the entire firmware bundle.
 
+fw.bootloader
+-------------
+
+Version of the bootloader.
+
 Future work
 ===========
 
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 0f376a28b9c4..6a2e4f21779f 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -621,6 +621,8 @@ enum devlink_param_generic_id {
 #define DEVLINK_INFO_VERSION_GENERIC_FW_ROCE	"fw.roce"
 /* Firmware bundle identifier */
 #define DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID	"fw.bundle_id"
+/* Bootloader */
+#define DEVLINK_INFO_VERSION_GENERIC_FW_BOOTLOADER	"fw.bootloader"
 
 /**
  * struct devlink_flash_update_params - Flash Update parameters
-- 
2.35.1


