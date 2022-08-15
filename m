Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A85FA5931A6
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 17:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242765AbiHOPTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 11:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241006AbiHOPS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 11:18:56 -0400
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F9421244;
        Mon, 15 Aug 2022 08:18:55 -0700 (PDT)
Received: by mail-ua1-x929.google.com with SMTP id 5so2987543uay.5;
        Mon, 15 Aug 2022 08:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=BcFt82RUJW5J4Iiz0vCULij2YJ4NVB/55zK7nEHb9eY=;
        b=eFv1TcrWGwhXeSzH9ocXhFgb/LzBL1vHh8KGtQZKKulysTE7pusFqful0WCwhPyDkW
         +Tq8+r6FKv6aTnfMDqaDN0zlmjTjUR8g9rSPFAqvUF+FYUOGrtvoPnqfUJxle6HpKNGU
         S7Wtqy2f0Dg7BVC7PPvHS8l7g6oav7rb23qZIdSj77jQKuwh6cQpPe8yLwZA5iG66+ft
         Y2dScHNxDZGa5A1tCpfa/J8EhYoUdMgJ7dWUyIjoSmatS+hEyGKBuj6X0Ie+euudubJh
         iPIaYUmWlFWiiTD/76FSCnwkHdYtTUcqYs+TsO9q07/S+jZN3g5de35BJVX9QEAZvw95
         nTxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=BcFt82RUJW5J4Iiz0vCULij2YJ4NVB/55zK7nEHb9eY=;
        b=7n+TEG1TkaG1J6l6ybNWRtLVCFh/UlpJirZcj3+gpPVQkG+W6MB5W6D7g+JEpynIlJ
         jWbpMbhYJNV5zC9Zj1fNXN9C2TlCTs9CCbTBPQ+gQei/xJHD/RjM6CJQjwSS+dWNf4hu
         8rTQw+SpZikEoa0x98pie6Yyi7m/kwOLIxF1CzZCBQ1NtD3rvBWQtt8hu3Fl5IYgCTJQ
         kga5FXbs8dIYtzg7cewB2vwS1t65aFPDVkDpMAJP2EmHk3SaglJHBbY5j8CGDTVA7ifQ
         NM+4oLlUhcxi7a6eRGpV/TToxzFv3CAYIBeMA3jNyenSV0gv7tHapdYgdWg5vVIk+O8A
         oTPg==
X-Gm-Message-State: ACgBeo3XYGV55sg0Yjde9fUUa42eR5dhrCawvKwcn/bc0Y/HD/OCrbtJ
        yhfJHjo1RczMDGHoNYlA4AY=
X-Google-Smtp-Source: AA6agR54n1c87zyWyaYOlgaiFlWuSXxRglI+j+aGxTXocodD4s7OTb3WsPJlyhJEL4m+6be+ReNgqQ==
X-Received: by 2002:ab0:2259:0:b0:384:e172:e16 with SMTP id z25-20020ab02259000000b00384e1720e16mr6714549uan.61.1660576734756;
        Mon, 15 Aug 2022 08:18:54 -0700 (PDT)
Received: from laptop.. ([2804:14c:71:8fe6:44c:4bb9:384e:eda5])
        by smtp.gmail.com with ESMTPSA id v74-20020a1f2f4d000000b0037d0bb0a3c8sm6955818vkv.15.2022.08.15.08.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 08:18:54 -0700 (PDT)
From:   Jose Alonso <joalonsof@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev <netdev@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Ronald Wahl <ronald.wahl@raritan.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Alonso <joalonsof@gmail.com>
Subject: [PATCH stable 4.19.x] Revert "net: usb: ax88179_178a needs FLAG_SEND_ZLP"
Date:   Mon, 15 Aug 2022 12:18:48 -0300
Message-Id: <20220815151848.319112-1-joalonsof@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 6fd2c17fb6e02a8c0ab51df1cfec82ce96b8e83d upstream.

This reverts commit 36a15e1cb134c0395261ba1940762703f778438c.

The usage of FLAG_SEND_ZLP causes problems to other firmware/hardware
versions that have no issues.

The FLAG_SEND_ZLP is not safe to use in this context.
See:
https://patchwork.ozlabs.org/project/netdev/patch/1270599787.8900.8.camel@Linuxdev4-laptop/#118378
The original problem needs another way to solve.

Fixes: 36a15e1cb134 ("net: usb: ax88179_178a needs FLAG_SEND_ZLP")
Cc: stable@vger.kernel.org
Reported-by: Ronald Wahl <ronald.wahl@raritan.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216327
Link: https://bugs.archlinux.org/task/75491
Signed-off-by: Jose Alonso <joalonsof@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ax88179_178a.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index efee7bacfd76..cf6ff8732fb2 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1706,7 +1706,7 @@ static const struct driver_info ax88179_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1719,7 +1719,7 @@ static const struct driver_info ax88178a_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1732,7 +1732,7 @@ static const struct driver_info cypress_GX3_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1745,7 +1745,7 @@ static const struct driver_info dlink_dub1312_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1758,7 +1758,7 @@ static const struct driver_info sitecom_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1771,7 +1771,7 @@ static const struct driver_info samsung_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1784,7 +1784,7 @@ static const struct driver_info lenovo_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1797,7 +1797,7 @@ static const struct driver_info belkin_info = {
 	.link_reset = ax88179_link_reset,
 	.reset	= ax88179_reset,
 	.stop	= ax88179_stop,
-	.flags	= FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags	= FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
-- 
2.37.1

