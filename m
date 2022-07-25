Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8943957F867
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 04:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbiGYC44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 22:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbiGYC4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 22:56:55 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F5C2DC0;
        Sun, 24 Jul 2022 19:56:54 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id by10-20020a056830608a00b0061c1ac80e1dso7760293otb.13;
        Sun, 24 Jul 2022 19:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:content-transfer-encoding
         :user-agent:mime-version;
        bh=FnLaB8t2y77OdaPXADkAU4lqeIh98rF0oKHWs91ZE7c=;
        b=lriM6HncIGTrDXUYAbKrdu8h+GSYdNcedJdHAluLtug6iRaJGWVKSowEghfGVmWUmp
         NFGfTDDtgIEbdLstAswe/CZQEdO0mWzZZ/yLfNSqehX00geuLpHWjWHuv6cca7OCBb9y
         FtUnU/8DMdFbVcsyd2bp5SZk+z7y74COnDJdl7EActSVfNrYQGW1YAvZ50QlIR+zmIhF
         X+CsbKmhOguSIPLPiMEh40mS5IGPuFBcE/RrVdElOeQJKxYcqLvnf37+74D+7+/t9yr+
         LyL9q4KV4feCNxQ41HZ5qHrW+GHXDRsF+lAWbnbaV68XauOoRMX0vXsQ0+5+8E6FJbAY
         nJDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date
         :content-transfer-encoding:user-agent:mime-version;
        bh=FnLaB8t2y77OdaPXADkAU4lqeIh98rF0oKHWs91ZE7c=;
        b=2hrY2xJkX3IIwnWPvoR2fQehKC8k933DvoQpE3XgS5ZKj06dtbEmhd6mrxfEVX5r7/
         99LlQvivSg/30LetdezGg/NFZhJgIwbyMZ65jGubjc1wjDIR3rNLILkZt/qhLALRLPke
         5mIudSyc5F+A1moT+FcVWzazJzmQeaaARQXz89+GwgZdiAzeCMkkVHpBaBU/Ll36hyF/
         FIrv3LId5/LQJ5/fcM7HZoS7ivDMCLQSBzCDMbgp/nVsEDLb31eNLwzlPSRkFDF83kj/
         KUGKorENdXhpx1dGAKPsVlvDemf6Ou//CDGISLdi9XJwDGdpKhsf4d0GcB92pOXzpe1Z
         pWlw==
X-Gm-Message-State: AJIora98y7G09B3vwL1jS1QQLEgtrv2gh0Yr4iLdVU1xl8RDTPrly6px
        Y9iLBnKPk0RavieTKf6D+4B/Lri+nYNu0g==
X-Google-Smtp-Source: AGRyM1toGW+BqnuQVmhkthZl8CCmaHh9ItYk9l1Fi28Ni++FxdSW4XYNDko1dw66pLz2aBQo78h74A==
X-Received: by 2002:a9d:5888:0:b0:618:d00f:a915 with SMTP id x8-20020a9d5888000000b00618d00fa915mr3890330otg.100.1658717813640;
        Sun, 24 Jul 2022 19:56:53 -0700 (PDT)
Received: from ?IPv6:2804:14c:71:96e6:64c:ef9b:3df0:9e8d? ([2804:14c:71:96e6:64c:ef9b:3df0:9e8d])
        by smtp.gmail.com with ESMTPSA id b8-20020a056830310800b0061ca5495cc2sm4561583ots.30.2022.07.24.19.56.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 19:56:53 -0700 (PDT)
Message-ID: <68f9828853d4646a80022e9060f0f8bb7e099167.camel@gmail.com>
Subject: Patch for 4.14 stable tree "net: usb: ax88179_178a needs
 FLAG_SEND_ZLP"
From:   Jose Alonso <joalonsof@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Date:   Sun, 24 Jul 2022 23:56:51 -0300
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For 4.14 stable tree:
--------------------
From 36a15e1cb134c0395261ba1940762703f778438c Mon Sep 17 00:00:00 2001
From: Jose Alonso <joalonsof@gmail.com>
Date: Mon, 13 Jun 2022 15:32:44 -0300
Subject: net: usb: ax88179_178a needs FLAG_SEND_ZLP

From: Jose Alonso <joalonsof@gmail.com>

commit 36a15e1cb134c0395261ba1940762703f778438c upstream.

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ax88179_178a.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1707,7 +1707,7 @@ static const struct driver_info ax88179_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1720,7 +1720,7 @@ static const struct driver_info ax88178a_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1733,7 +1733,7 @@ static const struct driver_info cypress_GX3_info =3D =
{
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1746,7 +1746,7 @@ static const struct driver_info dlink_dub1312_info =
=3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1759,7 +1759,7 @@ static const struct driver_info sitecom_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1772,7 +1772,7 @@ static const struct driver_info samsung_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1785,7 +1785,7 @@ static const struct driver_info lenovo_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1798,7 +1798,7 @@ static const struct driver_info belkin_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset	=3D ax88179_reset,
 	.stop	=3D ax88179_stop,
-	.flags	=3D FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags	=3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };

