Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF789549E42
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 22:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbiFMUBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 16:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347484AbiFMUBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 16:01:21 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37BA7CB70
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 11:32:49 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id p129so8763769oig.3
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 11:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:date:content-transfer-encoding
         :user-agent:mime-version;
        bh=Jm05G51fM/Kw7kqpM/WmAYUoh2cInjiy8mzUnZqemRk=;
        b=dxRblik3h4psWYJIfgmlBGPNa4D8Zd+RtBCQZnHrL+e9/XUt1fbZF4S6mLMBBprXgY
         Sz4RK1EANwbrlMSNY3x6zw6RAHw6tIuOcqnQk+5J2Vn4xh4h2LlIU/AODZL8GjuOdV9m
         1kz+Ank6JV7MASlTbRciLJ3Y5RpHHsJc0pWzEeODEWLe8V3IBwYKALA/dEgOhkulwQoq
         WqiU22he7kG29f4O2Ew+IPfOKaq81VzhtuiTnvGer/0aMi/nlL379PWpt3/4TNHY5N4c
         Ukr0fZRKhx4OQLB1FZLuou7TLRlj4IzoHDbdIztMVMmu05bkrs4YLIbWUyYEToBNnXLJ
         Dr8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date
         :content-transfer-encoding:user-agent:mime-version;
        bh=Jm05G51fM/Kw7kqpM/WmAYUoh2cInjiy8mzUnZqemRk=;
        b=F5gFOBPPlYpFEBdP6HGAq9fN/EIgxo/Ri3zfHvC5kS7CnEpI5HNFhltSQbMCjEGaFr
         pu4RbpfmqGZ04C2B+RnvFqsuNEwv/74otmLfp0TnbUGBAvKHTNBqThwmTMfHPr+9PO0T
         DBITlWSG4jIWhZpYjy3Uo//zxzB+JiFtrLm25cUb1Ukz9W8g+qH1U4IXufnjVHlXpRWw
         A6Vw+eDxr5ekAdrm7bFZa2cS/M5hHeoYtDgHky8Dww3aMYnc098q5u9yvIeyz0uiOCHV
         oeAtnl0POEoWZ6t/frPmuAP5zoUbY6Xdf5AyGqPEh4VlLyaoSjE7LbMlgpWckPx7nt6O
         kSbQ==
X-Gm-Message-State: AOAM5312sTceahff8ev2QD4S5FYOn/og1HDqSHZ5MGDVbIxwLM8ejtr1
        4CfekyzvWyXnyitBt3hG0ipizC319v3m/g==
X-Google-Smtp-Source: ABdhPJzdionEiMerZSieXQZhKpQxYQOADfnFJ2tyuucW11tdWH0Aa1ePqni9qX936AGYSKmmaNlJUw==
X-Received: by 2002:a05:6808:3c6:b0:32f:38b9:71fa with SMTP id o6-20020a05680803c600b0032f38b971famr26699oie.217.1655145168266;
        Mon, 13 Jun 2022 11:32:48 -0700 (PDT)
Received: from ?IPv6:2804:14c:71:8e3a:8161:7a72:233f:e435? ([2804:14c:71:8e3a:8161:7a72:233f:e435])
        by smtp.gmail.com with ESMTPSA id o13-20020a05680803cd00b0032ebb50538fsm3524534oie.57.2022.06.13.11.32.46
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 11:32:47 -0700 (PDT)
Message-ID: <32138cf48914f241a998480f343e199ecd9b78c3.camel@gmail.com>
Subject: [PATCH] net: usb: ax88179_178a needs FLAG_SEND_ZLP
From:   Jose Alonso <joalonsof@gmail.com>
To:     netdev@vger.kernel.org
Date:   Mon, 13 Jun 2022 15:32:44 -0300
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


The extra byte inserted by usbnet.c when
 (length % dev->maxpacket =3D=3D 0) is causing problems to device.

This patch sets FLAG_SEND_ZLP to avoid this.

Tested with: 0b95:1790 ASIX Electronics Corp. AX88179 Gigabit Ethernet

Problems observed:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
1) Using ssh/sshfs. The remote sshd daemon can abort with the message:
   "message authentication code incorrect"
   This happens because the tcp message sent is corrupted during the
   USB "Bulk out". The device calculate the tcp checksum and send a
   valid tcp message to the remote sshd. Then the encryption detects
   the error and aborts.
2) NETDEV WATCHDOG: ... (ax88179_178a): transmit queue 0 timed out
3) Stop normal work without any log message.
   The "Bulk in" continue receiving packets normally.
   The host sends "Bulk out" and the device responds with -ECONNRESET.
   (The netusb.c code tx_complete ignore -ECONNRESET)
Under normal conditions these errors take days to happen and in
intense usage take hours.

A test with ping gives packet loss, showing that something is wrong:
ping -4 -s 462 {destination}	# 462 =3D 512 - 42 - 8
Not all packets fail.
My guess is that the device tries to find another packet starting
at the extra byte and will fail or not depending on the next
bytes (old buffer content).
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Signed-off-by: Jose Alonso <joalonsof@gmail.com>

---

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.=
c
index 7a8c11a26eb5..4704ed6f00ef 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1750,7 +1750,7 @@ static const struct driver_info ax88179_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1763,7 +1763,7 @@ static const struct driver_info ax88178a_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1776,7 +1776,7 @@ static const struct driver_info cypress_GX3_info =3D =
{
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1789,7 +1789,7 @@ static const struct driver_info dlink_dub1312_info =
=3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1802,7 +1802,7 @@ static const struct driver_info sitecom_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1815,7 +1815,7 @@ static const struct driver_info samsung_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1828,7 +1828,7 @@ static const struct driver_info lenovo_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1841,7 +1841,7 @@ static const struct driver_info belkin_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset	=3D ax88179_reset,
 	.stop	=3D ax88179_stop,
-	.flags	=3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags	=3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1854,7 +1854,7 @@ static const struct driver_info toshiba_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset	=3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags	=3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags	=3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1867,7 +1867,7 @@ static const struct driver_info mct_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset	=3D ax88179_reset,
 	.stop	=3D ax88179_stop,
-	.flags	=3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags	=3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1880,7 +1880,7 @@ static const struct driver_info at_umc2000_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset  =3D ax88179_reset,
 	.stop   =3D ax88179_stop,
-	.flags  =3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags  =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1893,7 +1893,7 @@ static const struct driver_info at_umc200_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset  =3D ax88179_reset,
 	.stop   =3D ax88179_stop,
-	.flags  =3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags  =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1906,7 +1906,7 @@ static const struct driver_info at_umc2000sp_info =3D=
 {
 	.link_reset =3D ax88179_link_reset,
 	.reset  =3D ax88179_reset,
 	.stop   =3D ax88179_stop,
-	.flags  =3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags  =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
--

