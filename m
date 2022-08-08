Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B112D58C7AB
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 13:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242787AbiHHLjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 07:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234788AbiHHLjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 07:39:16 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD7CCCD;
        Mon,  8 Aug 2022 04:39:15 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id m67so8463279vsc.12;
        Mon, 08 Aug 2022 04:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xdGSmopuM5TyLK38p2RoVlcf3AVCEWRG00Gzgmtoveg=;
        b=AFI3TpTE6BbWZMzedPG8fQXeoc1Lhy/WwlJQC1SwHh1reyWh2SqzhD6rcy19rtnYKQ
         kXEI1ZVotlHu858zf7Ke9E5Tg6SKzvOHLoBq+Zl7Uj94UKJhErpFKtzpHej6s34P1uk8
         IlpO7xWNxirwNKzddFr56Gg91fgd8RW6qzx2fRvOmFfwXIisPxin5xBwd/rZ+ObQdlEj
         P3YUkZMR0IEYkC1xnE48pmrmiNo5PAEtPbBwrSmwaUpOkxZXjNQQKrq/3zX5BQzBBwY6
         tRuD2CO1WmAYJtxXxsb0D/orEn+E5d8JQgvAcAWGxvNIW+vbh++mop6Fhnj09brEzr3L
         TnzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xdGSmopuM5TyLK38p2RoVlcf3AVCEWRG00Gzgmtoveg=;
        b=SH+dSi/l0YS9rD+0Hu951SLj/5VO10/IirOVTgL5g/5tnRcZtSF0WtWngGy8/SJprS
         +30o28eQOmSowB9PYdnqO6nbGFlOZSoQOZbY2eTh5IAh5H6zyNcZPVlPWC2N9E386TC7
         naBVB9nAFwWkYgdB3nulBoaNKnt0prhTQ/P+rvJnJvXGAtVUsY++ftwf8shSXe9j30ZW
         UI17BpYlNugwMgxZ67GMofYhdl1NEP7Liw57ZPI1STEgJzsEMTdFyPGA3Om7qBT5jlfE
         R9EKNotmTOEYN+7/zdJeFD0OuZfua0XWEdpDMsO6hpVEeXMwfH4yUHNZb8Tnek2AcpPy
         wlzA==
X-Gm-Message-State: ACgBeo0Qg4iqpeHTjrfmjhA1SYBwcc+xuEadOs8cMLuqh+/2jnxV3fsy
        Fle/M0aNfy0P2ICT6rXBY3/DN9xguVUVDC15
X-Google-Smtp-Source: AA6agR7prPM14kEpUSqarVMrRZGt/KnCB4jC/Lg5VNgeiJwCrtQNGe1l155APWdWWmAWLCDOlUm/zw==
X-Received: by 2002:a05:6102:2223:b0:32d:2ae1:412 with SMTP id d3-20020a056102222300b0032d2ae10412mr7289585vsb.6.1659958754238;
        Mon, 08 Aug 2022 04:39:14 -0700 (PDT)
Received: from laptop.. ([2804:14c:71:8fe6:4b89:54a4:c33e:b94a])
        by smtp.gmail.com with ESMTPSA id b73-20020a1fb24c000000b00370a1dab940sm8922763vkf.36.2022.08.08.04.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 04:39:13 -0700 (PDT)
From:   Jose Alonso <joalonsof@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev <netdev@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Ronald Wahl <ronald.wahl@raritan.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Alonso <joalonsof@gmail.com>
Subject: [PATCH net] Revert "net: usb: ax88179_178a needs FLAG_SEND_ZLP"
Date:   Mon,  8 Aug 2022 08:35:04 -0300
Message-Id: <20220808113504.128907-1-joalonsof@gmail.com>
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
---
 drivers/net/usb/ax88179_178a.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 0ad468a00064..aff39bf3161d 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1680,7 +1680,7 @@ static const struct driver_info ax88179_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1693,7 +1693,7 @@ static const struct driver_info ax88178a_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1706,7 +1706,7 @@ static const struct driver_info cypress_GX3_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1719,7 +1719,7 @@ static const struct driver_info dlink_dub1312_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1732,7 +1732,7 @@ static const struct driver_info sitecom_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1745,7 +1745,7 @@ static const struct driver_info samsung_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1758,7 +1758,7 @@ static const struct driver_info lenovo_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1771,7 +1771,7 @@ static const struct driver_info belkin_info = {
 	.link_reset = ax88179_link_reset,
 	.reset	= ax88179_reset,
 	.stop	= ax88179_stop,
-	.flags	= FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags	= FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1784,7 +1784,7 @@ static const struct driver_info toshiba_info = {
 	.link_reset = ax88179_link_reset,
 	.reset	= ax88179_reset,
 	.stop = ax88179_stop,
-	.flags	= FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags	= FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1797,7 +1797,7 @@ static const struct driver_info mct_info = {
 	.link_reset = ax88179_link_reset,
 	.reset	= ax88179_reset,
 	.stop	= ax88179_stop,
-	.flags	= FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags	= FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1810,7 +1810,7 @@ static const struct driver_info at_umc2000_info = {
 	.link_reset = ax88179_link_reset,
 	.reset  = ax88179_reset,
 	.stop   = ax88179_stop,
-	.flags  = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags  = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1823,7 +1823,7 @@ static const struct driver_info at_umc200_info = {
 	.link_reset = ax88179_link_reset,
 	.reset  = ax88179_reset,
 	.stop   = ax88179_stop,
-	.flags  = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags  = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1836,7 +1836,7 @@ static const struct driver_info at_umc2000sp_info = {
 	.link_reset = ax88179_link_reset,
 	.reset  = ax88179_reset,
 	.stop   = ax88179_stop,
-	.flags  = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags  = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
-- 
2.37.1

