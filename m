Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F18DA3110E8
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 20:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233643AbhBEReI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 12:34:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233291AbhBEP6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 10:58:24 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF37C061788;
        Fri,  5 Feb 2021 09:39:45 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id p21so10986086lfu.11;
        Fri, 05 Feb 2021 09:39:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+zrSOqxy0ErPj0MsXNXkfWyM9kqx4Wiah0w21ZGB0bY=;
        b=Ru7z4QFqDUc4HZlbYxWvSxAe1GiEb+ooIGs5rOByrwuRBVsilRSzNGZM0ds0A3rrlk
         ozOCIvW4ebbuaHKIeDyP479DnN0XmRjf18/bBchfJdkBKLs4753YPNgsCD6rwT+Ii0uW
         6SPXCa/2JjgPzz/9vvG+4bZ7EmK7zCgUHtEdkYhXSDUeWNWFzXYcORl28HBwNNs76z1l
         eTgEFewMIvNUC+1mpmDrwWtUeoCJH3qUrEqNok71fJrQyD6PINdRXhIqk/jjdag7ac8Q
         DtgiQ9pVWLpRT2SXzDd8CuIce/gA8rQaaDuj1iCMufRSLjoTNWCKV6ufQs/6wcUzkMGt
         fJUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+zrSOqxy0ErPj0MsXNXkfWyM9kqx4Wiah0w21ZGB0bY=;
        b=GGNgLx+Tg0Hg1KIviXgAh573NHAfx217AqjRvInUzgDLTBVh1LJtkVYKK3j1FNrAU3
         d56/298ZJWWlGkyXKCdtMeAQO04InYV/mn4KImVa44bdMwUlYAh/1igw4B8to2v7+1o+
         unATy6a/7q1cCUk2BdTpJu7ituF7dLFzcrjgei5/uNwetXMWGmjxbJI3O5I4c/px1JwC
         700y81rlQbnHxBTLoUEgDxpQLRnIBNzQTTqjCC4HCNGE4czjBLJTQ16ahWpIezY6uYB1
         nRGOmgcBd7mSUaO6uwa2fT2gBzb05PSgkNJAAbcTwSnzDqT8l93ATHKbfrnVsE8Gc5Ub
         2qcQ==
X-Gm-Message-State: AOAM533CdB1behEbuuX0qsQTNQV6v3xXZCOHS+ApUxSVjoYXN50dhgBT
        Xz2dj89TtGAIAnvJgU6KXLQfcFoAyaciGw==
X-Google-Smtp-Source: ABdhPJwTPAWomtIUQ4HSvW2olLG+DjgxdHlyqBYvMhA6g6oTJ4kWImNYQaENQwiN/naq27+jzUOJwA==
X-Received: by 2002:a19:c708:: with SMTP id x8mr2880474lff.575.1612546783915;
        Fri, 05 Feb 2021 09:39:43 -0800 (PST)
Received: from rafiki.local (user-5-173-242-247.play-internet.pl. [5.173.242.247])
        by smtp.gmail.com with ESMTPSA id n16sm1053230lfq.301.2021.02.05.09.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 09:39:43 -0800 (PST)
From:   Lech Perczak <lech.perczak@gmail.com>
To:     linux-usb@vger.kernel.org, netdev@vger.kernel.org
Cc:     Lech Perczak <lech.perczak@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH v2 2/2] usb: serial: option: add full support for ZTE P685M
Date:   Fri,  5 Feb 2021 18:39:04 +0100
Message-Id: <20210205173904.13916-3-lech.perczak@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210205173904.13916-1-lech.perczak@gmail.com>
References: <20210205173904.13916-1-lech.perczak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only 1st (DIAG) port was supported, support ports 1 (PCUI) and 2 (Modem)
on ff/00/00 too. Ports expose AT command interface. Blacklist ports 3
now used by qmi_wwan and port 4 for ADB, and finally simplify device ID
to match only ports 0-2.

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

Cc: Johan Hovold <johan@kernel.org>
Cc: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Lech Perczak <lech.perczak@gmail.com>

---
v2: Blacklist ports 3-4 and simplify device ID,
as suggested by Lars Melin.

 drivers/usb/serial/option.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 3fe959104311..485d07df8f69 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1567,7 +1567,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1272, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1273, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1274, 0xff, 0xff, 0xff) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1275, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE(ZTE_VENDOR_ID, 0x1275), .driver_info = RSVD(3) | RSVD(4) }, /* ZTE P685M */
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1276, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1277, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1278, 0xff, 0xff, 0xff) },
-- 
2.20.1

