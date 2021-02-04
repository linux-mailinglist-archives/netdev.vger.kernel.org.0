Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E8E30FFAC
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 22:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbhBDVuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 16:50:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhBDVui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 16:50:38 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A73AC0613D6;
        Thu,  4 Feb 2021 13:49:58 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id a8so6833667lfi.8;
        Thu, 04 Feb 2021 13:49:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C65JtMBiv1gFFOLJmknxDTvCB8bxiehzthVzdzJn8fk=;
        b=dc4AL3gdi3Zk1yFggkLXXlSYs5j5bk34J/VtQBhtYHUGW7J/O9C1te+BvSJVyaGowG
         q3bXOQKTvoROh+c8s4Jdscj8IWoeXaOTHFv8LDhJssdTnmG48fE+DcIW5oX1pFcNE/a1
         1aYR0ZYjpqhzOqj4ljXomR4O4EI5JOWeQxRPLM0OILmcXt7K5St7xB/Zr+LL2bMa2J3A
         PZgJxOMfwiTV2cegRewE7vsK0HV7/W9sL8qv6lUlEGddaVftzTCBF0PT+0GxcaKIHCKz
         1M1Pfd29z7HUTXJUPp3jnztQVz2DHeYRW5PNV1pDic6kB3Oy4nF5duktj8xEQXqqL46Y
         qwaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C65JtMBiv1gFFOLJmknxDTvCB8bxiehzthVzdzJn8fk=;
        b=QJWnouhNjDRIJvgkWPDDqMR2uSdXRMA1J3b/NGUJieGvJtl06iDqbNFLpqkBT+kNW+
         By34mzxaxZAPF+ETz9M0CGENo+YM5R4x2hYTyFgBrVq+Ex+xPGCIxaojcxoAWjKkwCvZ
         UnasmtmtTxBBTygu1L9MD5h+8Q5UzaZC3MnNZ1LC5elN1oan59AMo16obJdnybhetIaC
         71QuJfKSW4Llx+bL05HUzS8/fn4Axy3fHqobsPyuEWoY/U6v6d2/gN6hBhVQ/RbKYJCN
         3Eua80KLM8d5LiIPB2L7A8Ody9z/+LA0Sj58BugbIVVBLATvMK3YobZjbDnlcxMLeH+o
         xIkQ==
X-Gm-Message-State: AOAM533y+JNvnLlK2XWRa+cgiZkMuCN0foxaM91WhpUoc64ym5xNOjgV
        7XTq51rEC0qE4gJJQhKfmn47dyVoJGTXEw==
X-Google-Smtp-Source: ABdhPJxqy896Bdh0SbC61CoXzSKzSg5Az0YCgIJuiF1h4zA3tKDHN1z2rSOuJCFc2Rip5wWrjwMyvQ==
X-Received: by 2002:a19:ca45:: with SMTP id h5mr704637lfj.251.1612475396622;
        Thu, 04 Feb 2021 13:49:56 -0800 (PST)
Received: from rafiki.local (user-5-173-242-247.play-internet.pl. [5.173.242.247])
        by smtp.gmail.com with ESMTPSA id q30sm750975lfd.83.2021.02.04.13.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 13:49:55 -0800 (PST)
From:   Lech Perczak <lech.perczak@gmail.com>
To:     netdev@vger.kernel.org, linux-usb@vger.kernel.org
Cc:     Lech Perczak <lech.perczak@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH 1/2] net: usb: qmi_wwan: support ZTE P685M modem
Date:   Thu,  4 Feb 2021 22:49:07 +0100
Message-Id: <20210204214907.15646-1-lech.perczak@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

Cc: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Lech Perczak <lech.perczak@gmail.com>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index cc4819282820..a0bf7737402f 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1235,6 +1235,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x19d2, 0x1255, 4)},
 	{QMI_FIXED_INTF(0x19d2, 0x1256, 4)},
 	{QMI_FIXED_INTF(0x19d2, 0x1270, 5)},	/* ZTE MF667 */
+	{QMI_FIXED_INTF(0x19d2, 0x1275, 3)},	/* ZTE P685M */
 	{QMI_FIXED_INTF(0x19d2, 0x1401, 2)},
 	{QMI_FIXED_INTF(0x19d2, 0x1402, 2)},	/* ZTE MF60 */
 	{QMI_FIXED_INTF(0x19d2, 0x1424, 2)},
-- 
2.20.1

