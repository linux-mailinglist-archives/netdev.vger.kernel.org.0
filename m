Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75A365931A9
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 17:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243020AbiHOPTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 11:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243132AbiHOPTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 11:19:20 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE8C25E87;
        Mon, 15 Aug 2022 08:19:18 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id f23so1293314uap.9;
        Mon, 15 Aug 2022 08:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=PdihbPSR1RHCQjqK0jUsMnTw3ZHD4FvjNayiLueermI=;
        b=oj49l20Dx9k135cSQ2mm1K8FkpNjqgOcX/MRALA7JmK8CBrWNjjeYGTs5bcw6M11E7
         WFAiaAdUzCzaC7CZuZlsyC+LtwO9DHSvcGo/tOsGubx6NI7StKa0PeRl2y+sK5S774Ei
         iX2gVjTvLW6313Ic5Gx3+Kk99eJO5CF1tJQtBCIz43kEVGs0lkYmBGv6SQPHepfaCJcn
         9s4T7wWatBXOrSktSfrSWcdkT/SFa4rkwQ/WCkjk7AVi8Hk6tKqCg1tm6Jvx0qfQwL4n
         wKolYCZeycIWuT02Qig5BGtspPdeTZlPKxsLiUHX4iGaNsgC0Vfk7RkFurjRTvmPZHKf
         9L1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=PdihbPSR1RHCQjqK0jUsMnTw3ZHD4FvjNayiLueermI=;
        b=HCIfIdQrFn39sp+5+o/0sCprm3+EFv46OP492au8r0q6j4m5cv3jmjHlcWMWBLXujU
         f48ozk7mvv9dfTd/hsrOAQDMkIUnhJXbcBg4EoxUpZhjMKuOCkM8gwOI8BZf9XTPwUVo
         MOQ8xxEC1ihPXu8TjNKxqEfW4QMnTD9/b3VpyDGVXocjpMBZyPpwp0RDnMKRe1CHzbQm
         5oJs5s+a++Lv0ZsUL+4v1Uy/2socbUwU+F47o2EN7eTQwsSeD2oED0+hlxiUALXQy/Mn
         VQ8R9VMCtsTt0akcEhdsoZl9FD+p7Et93EUQOsIvKlni3oL+0U4hMyYDJ+JJmPEWPJFx
         KRlg==
X-Gm-Message-State: ACgBeo1r+2j4UGTDNFTEHUshY4+r/NtgJMjeYPCzc5WmniWM3qkBSqGD
        yPQheIZ+z2dFaafhpDw4jdE=
X-Google-Smtp-Source: AA6agR5x368TW7xWWDKYqVEvNvLVtQm/j8i/QbGAfkqbeCW/Ao6sKkpl6WWYNPcnQi7unAkiAIrUsA==
X-Received: by 2002:ab0:3f0c:0:b0:383:f357:9c02 with SMTP id bt12-20020ab03f0c000000b00383f3579c02mr6994764uab.19.1660576758024;
        Mon, 15 Aug 2022 08:19:18 -0700 (PDT)
Received: from laptop.. ([2804:14c:71:8fe6:44c:4bb9:384e:eda5])
        by smtp.gmail.com with ESMTPSA id u10-20020ac5cdca000000b0038030db4c79sm3699325vkn.54.2022.08.15.08.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 08:19:17 -0700 (PDT)
From:   Jose Alonso <joalonsof@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev <netdev@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Ronald Wahl <ronald.wahl@raritan.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Alonso <joalonsof@gmail.com>
Subject: [PATCH stable 4.9.x] Revert "net: usb: ax88179_178a needs FLAG_SEND_ZLP"
Date:   Mon, 15 Aug 2022 12:19:12 -0300
Message-Id: <20220815151912.319147-1-joalonsof@gmail.com>
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
 drivers/net/usb/ax88179_178a.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 460a0294ea97..48938d00ff7e 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1703,7 +1703,7 @@ static const struct driver_info ax88179_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1716,7 +1716,7 @@ static const struct driver_info ax88178a_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1729,7 +1729,7 @@ static const struct driver_info cypress_GX3_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1742,7 +1742,7 @@ static const struct driver_info dlink_dub1312_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1755,7 +1755,7 @@ static const struct driver_info sitecom_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1768,7 +1768,7 @@ static const struct driver_info samsung_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1781,7 +1781,7 @@ static const struct driver_info lenovo_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
-- 
2.37.1

