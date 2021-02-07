Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70FB63120A0
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 01:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhBGAzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 19:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbhBGAzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 19:55:50 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1017EC06174A;
        Sat,  6 Feb 2021 16:55:09 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id f1so16663575lfu.3;
        Sat, 06 Feb 2021 16:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6h+heYhygsXnSMC08EOO+2H8p2FaBb1HiQe2ZxTK5YA=;
        b=bTCXk1xoFTmCOpKiYvpqDfXVGidpvTsbcE2F4/z/p71XFabsKrsNvdBEYAK/+ZsFNo
         dMO17Prkx1bal2dWhS4riqH5piEKWnfHwrw+EAB16uMAHagTQFmgvSnKaon3DrWfILuA
         9iKLmeBrIdZLfSbYwGWrMuTVFFgTPMEhiB001HDy5Tb3Uk3q9NzfSH+8fN8o1nMo7kRv
         n5j7OptfTmBqGr+7ikAjGo5JbI6IkYUO5y/ulZM0+DJAWWkBOC5hhN/ugT6yczk6gIvf
         kklWLe6KPN4d6Jk23yIK1tXBGQl55GEgLEN3XiX8ymQiMMCBcyVfyIDRsJsDd4lWg3GE
         yjnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6h+heYhygsXnSMC08EOO+2H8p2FaBb1HiQe2ZxTK5YA=;
        b=lxCe8pq4sd2jscK3KxaBWftCLT83cFZORAd/rQ8sB0qOhXhi8z4w/ZjLW1fz1WNRVt
         8JnfAbNECF7Cq7ztbFWpdH3SoTXityKtpwGa4Lx/FgH41MXgzyiX1/KCckC8fdQKolPy
         BMCcE9mZgR/xwaxiby5s2QOKgHOiLabwvbhcciHoiexHsuEzfCiK4o1P36/sQg7rYeYB
         PxQAOFgxUX3OYngrw/l+mwQDIRwtpHJmgbPAq1d+Nlbs5z0ZVQe4RoA4OkgEhnvQ3JmI
         SL/tzT0p8OAlFYIbMX6kPcuYrsNO8/FND0aWeM3w5DtklwlAIqh1TukhTGuqqNYUyydj
         ZOsg==
X-Gm-Message-State: AOAM533yx3rcRdtaDjg+yYvD/6dAeRFDyXcR6EFpifqjcCC4QlloRQxa
        1BGxStMuiSxTVgavueNGgEq8MpNy7UQg5g==
X-Google-Smtp-Source: ABdhPJwlFcFp0qxdXew8YcOxTtMTXfmVRK97ncXURzwnbIFNZdI+qAB/3UYDIL15bGZtu9MJ68tZ1g==
X-Received: by 2002:a19:5e1d:: with SMTP id s29mr6788082lfb.440.1612659307586;
        Sat, 06 Feb 2021 16:55:07 -0800 (PST)
Received: from rafiki.local (user-5-173-242-247.play-internet.pl. [5.173.242.247])
        by smtp.gmail.com with ESMTPSA id o14sm1453485ljp.48.2021.02.06.16.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Feb 2021 16:55:07 -0800 (PST)
From:   Lech Perczak <lech.perczak@gmail.com>
To:     netdev@vger.kernel.org, linux-usb@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Lech Perczak <lech.perczak@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH v3] usb: serial: option: update interface mapping for ZTE P685M
Date:   Sun,  7 Feb 2021 01:54:43 +0100
Message-Id: <20210207005443.12936-1-lech.perczak@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210206121322.074ddbd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210206121322.074ddbd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch prepares for qmi_wwan driver support for the device.
Previously "option" driver mapped itself to interfaces 0 and 3 (matching
ff/ff/ff), while interface 3 is in fact a QMI port.
Interfaces 1 and 2 (matching ff/00/00) expose AT commands,
and weren't supported previously at all.
Without this patch, a possible conflict would exist if device ID was
added to qmi_wwan driver for interface 3.

Update and simplify device ID to match interfaces 0-2 directly,
to expose QCDM (0), PCUI (1), and modem (2) ports and avoid conflict
with QMI (3), and ADB (4).

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
v3: No changes to contents of the patch.
Resend as separate patch to be merged through USB subsystem, the
following patch for qmi_wwan will go through netdev tree after this is
merged.
Updated commit description, added note about possible qmi_wwan conflict.

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

