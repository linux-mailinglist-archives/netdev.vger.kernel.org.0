Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5DDD3230DE
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 19:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbhBWSf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 13:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233982AbhBWSfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 13:35:46 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFAC3C061574;
        Tue, 23 Feb 2021 10:35:05 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id u20so35361512ejb.7;
        Tue, 23 Feb 2021 10:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lnwVFFQQDuYoLD4H/4zwU5IDIG9Pt3VM/f+MXHjJNnM=;
        b=Ll09qTFdS+Hxo6fHCqFEvJ2u+puEasSIs+hvAXqUA4VQBrAKQOKRpgBEXcWhizMqn8
         27e9yVGkFjqWfZ01gVERGeUAsU0Issw7ALDh8J1wOjMQBeuZJacyJQlsQlRU2Ly7w40n
         6jUH8e/2P7v7eP05+oLHOEL2MLAxajCIyLcyI7/TxxXHMKK/F4Q1JClHxAYioSboClks
         +jttXcYBiC6Eqwc2LgSnotjOIJDmFzbc6O/Sh5pcRjcxJcceGf2jvQkCEXtif4S+p8Np
         d7/RENEdotSXoQQNN8ofJsLbp84AkTVWxY7IpfQCt9FJJp9yyhfTeqABafLE5CraG6/j
         8bmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lnwVFFQQDuYoLD4H/4zwU5IDIG9Pt3VM/f+MXHjJNnM=;
        b=VSRFdKUBV4iMwsDRcp7nU8i0Gu4dL8+a3+QDYw2egx9zhkBZGafcrQSaXSJHUqy/kV
         v3HEkxUgc1mBpOtTBCo2h+J8G1nIl1RxdY56Es2GIAjkWVoj5U+m7j0xyXIhb23Z7HmV
         EYDHpupHZ1KZsHZ2sLl5bcIV8UIo/Q1GhzLFZ8B1kp3oo1pDKIk9A1VLkKFb7nTMsHXd
         t4DCRiurHRw7pWECIigOthu3FA7VAtsWfqZENhKVD4n58jenyhFrljk9qPmPE7N2zxSz
         l9OfntG59UaDxwCBaWA7r0zwQqbp0p8iLJjrcefagS7Tfj7RB1iGjlOozXvZbnpX/H4X
         Pb3w==
X-Gm-Message-State: AOAM533vNqiFi0NlqmvBMTMh7gkKPHd1s+DaNTqqRiiNz1dFS6pd6aRD
        qfzp6tysmiyks2Imc5q0D59dZtbdOY+GUA==
X-Google-Smtp-Source: ABdhPJz475EqJ9KOiG3vxE8jY7mRrBpm6fbFOT3z2PV3z7qQmFiD86l03TnATPgjg9DqHuQRBnOktQ==
X-Received: by 2002:a17:906:bc84:: with SMTP id lv4mr28113127ejb.136.1614105304615;
        Tue, 23 Feb 2021 10:35:04 -0800 (PST)
Received: from rafiki.local (user-5-173-242-247.play-internet.pl. [5.173.242.247])
        by smtp.gmail.com with ESMTPSA id hq14sm2617242ejc.30.2021.02.23.10.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 10:35:03 -0800 (PST)
From:   Lech Perczak <lech.perczak@gmail.com>
To:     netdev@vger.kernel.org, linux-usb@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Lech Perczak <lech.perczak@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH v3] net: usb: qmi_wwan: support ZTE P685M modem
Date:   Tue, 23 Feb 2021 19:34:56 +0100
Message-Id: <20210223183456.6377-1-lech.perczak@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210206121322.074ddbd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210206121322.074ddbd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that interface 3 in "option" driver is no longer mapped, add device
ID matching it to qmi_wwan.

The modem is used inside ZTE MF283+ router and carriers identify it as
such.
Interface mapping is:
0: QCDM, 1: AT (PCUI), 2: AT (Modem), 3: QMI, 4: ADB

T:  Bus=02 Lev=02 Prnt=02 Port=05 Cnt=01 Dev#=  3 Spd=480  MxCh= 0
D:  Ver= 2.01 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=19d2 ProdID=1275 Rev=f0.00
S:  Manufacturer=ZTE,Incorporated
S:  Product=ZTE Technologies MSM
S:  SerialNumber=P685M510ZTED0000CP&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&0
C:* #Ifs= 5 Cfg#= 1 Atr=a0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=83(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=85(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
E:  Ad=87(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 4 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=(none)
E:  Ad=88(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Acked-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Lech Perczak <lech.perczak@gmail.com>
---
Now that patch for "option" has landed in 'master' and 'net', resend the second part.

v3: no changes, resend separately again, add Acked-by from Bjørn Mork.

v2: no changes to this patch, resend as series.

 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 6c3d8c2abd38..17a050521b86 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1318,6 +1318,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x19d2, 0x1255, 4)},
 	{QMI_FIXED_INTF(0x19d2, 0x1256, 4)},
 	{QMI_FIXED_INTF(0x19d2, 0x1270, 5)},	/* ZTE MF667 */
+	{QMI_FIXED_INTF(0x19d2, 0x1275, 3)},	/* ZTE P685M */
 	{QMI_FIXED_INTF(0x19d2, 0x1401, 2)},
 	{QMI_FIXED_INTF(0x19d2, 0x1402, 2)},	/* ZTE MF60 */
 	{QMI_FIXED_INTF(0x19d2, 0x1424, 2)},
-- 
2.20.1

