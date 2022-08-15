Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED425931A2
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 17:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242721AbiHOPSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 11:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242952AbiHOPS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 11:18:26 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9283422B00;
        Mon, 15 Aug 2022 08:18:24 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id s129so7429918vsb.11;
        Mon, 15 Aug 2022 08:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=Tw0mKg1eiprXvUlSjUgU/ilfOQ+v+x5I0qY8WFzm1HY=;
        b=HTvcN943EpRY338D0+9n/XeYYWbHdlXhtjsTUAE+ziye3PXO3ssRvTmLo2525S2t7B
         uUAPtgIGyKsj8m46R+SAQBADCHpbUZhyOZcb5nXKoSYOl47B4lHfwPLAjXFY4LbRhEHA
         CYeL2yO0AAyFaPtJnI8uNph6SiR16Ctw6c+HbbwwcjHWx1jgcU3Q0uAGseGOEeK2x/HW
         t6ijlu3hGyHlpbsgI8HFC38cwBO78rMW0BGB83qWPfO3NNlfbu8riGhyD96G5HPI2f/+
         Q8ajKQYg6JHSpXFkkxdotd193bDJWYcjnRwfU2EvARbYXBNxANVjrC+yFrYCVgcP8kgf
         fz4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=Tw0mKg1eiprXvUlSjUgU/ilfOQ+v+x5I0qY8WFzm1HY=;
        b=CorIEUbb4RPkBkWeR/yup8aBuzOGhxA1E8p63iS/u7ZTGC7jDPMhhnjheSqxahl+bD
         Uer2EEQ/kiL/b3c2uuo8g0p+zSpM2XiLxrv5wt3oIFcuArp/Z0zTQy1hziCa1Upqmwha
         lri/sDjDeU+ePzB8eEv2L5/s6Xg1Pa44GenlW3yCm5pzZuNiLJAh3o23xxI/cwUHJ6T+
         V7OQJuUZ3p5Q1SqY/s6W62znmFFhO8ykDyXRpslE/bO1uU+1FZEzA2kDl7liZXa3x4gv
         K36mXN0/KvUTy+kKiZknYxnaB3PLite5a8SUA6dRWuhvmiJAfyzCyJKPlDOms2T0cexK
         N6Zg==
X-Gm-Message-State: ACgBeo2ogTst95R1Kfbpp3YBamCJ/CSNrjr2X8QNZJ8bS2+9VoC7tcT/
        qfH2kKGre2z8bmp+SvJ8I58=
X-Google-Smtp-Source: AA6agR4SVUITKBqLHLNx85tZkgYa/rSNt+pOvgH4N5iBwSFtYWU7WIrGAGwsuJzhphEADKTuanHMlg==
X-Received: by 2002:a67:f595:0:b0:388:9591:abd4 with SMTP id i21-20020a67f595000000b003889591abd4mr6238286vso.42.1660576703562;
        Mon, 15 Aug 2022 08:18:23 -0700 (PDT)
Received: from laptop.. ([2804:14c:71:8fe6:44c:4bb9:384e:eda5])
        by smtp.gmail.com with ESMTPSA id w6-20020ab076c6000000b00383c1958249sm5351425uaq.24.2022.08.15.08.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 08:18:23 -0700 (PDT)
From:   Jose Alonso <joalonsof@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev <netdev@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Ronald Wahl <ronald.wahl@raritan.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Alonso <joalonsof@gmail.com>
Subject: [PATCH stable 5.10.x] Revert "net: usb: ax88179_178a needs FLAG_SEND_ZLP"
Date:   Mon, 15 Aug 2022 12:18:15 -0300
Message-Id: <20220815151815.319075-1-joalonsof@gmail.com>
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
 drivers/net/usb/ax88179_178a.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 0ac4f59e3f18..79a53fe245e5 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1796,7 +1796,7 @@ static const struct driver_info ax88179_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1809,7 +1809,7 @@ static const struct driver_info ax88178a_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1822,7 +1822,7 @@ static const struct driver_info cypress_GX3_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1835,7 +1835,7 @@ static const struct driver_info dlink_dub1312_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1848,7 +1848,7 @@ static const struct driver_info sitecom_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1861,7 +1861,7 @@ static const struct driver_info samsung_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1874,7 +1874,7 @@ static const struct driver_info lenovo_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1887,7 +1887,7 @@ static const struct driver_info belkin_info = {
 	.link_reset = ax88179_link_reset,
 	.reset	= ax88179_reset,
 	.stop	= ax88179_stop,
-	.flags	= FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags	= FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1900,7 +1900,7 @@ static const struct driver_info toshiba_info = {
 	.link_reset = ax88179_link_reset,
 	.reset	= ax88179_reset,
 	.stop = ax88179_stop,
-	.flags	= FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags	= FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1913,7 +1913,7 @@ static const struct driver_info mct_info = {
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

