Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB923110E2
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 20:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233509AbhBERd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 12:33:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233305AbhBEP6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 10:58:24 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D09AC06178A;
        Fri,  5 Feb 2021 09:39:45 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id a12so11085108lfb.1;
        Fri, 05 Feb 2021 09:39:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hseLb0dwWumgxU/+HV0VWRPn5JhtqayFxSzk7wGDI0A=;
        b=YYyzUyNidCYEs9vScdRQDO8FiLHKo2XmBcrp9CZaN6HRQeQs6rDCB7RfAlhSJcieMj
         UAG0dfnPO3SHfIGI0eimbXemT5HTZ1rzP6jxWOXfUmqOMnJQuaLx9EomeHsMxpKV5BYc
         1vFprZ6Q39fK1JwpHblakPJnNt0V44EFplrIzflfmJc0ZWG4ljZXQmK8jONYoZj7Extr
         pDxiIciKQsi2yiAgvOLedPf3x76RP7UjLG1H6eQQ79BvrOUcCKy/TehY0T4BkQAl/JLB
         ftyMovMboKeF31NdPB+BSrO4doGBfxx0sYKzhoOlOWGuQZm7fzguhJH6eC1dd99+fesh
         nOyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hseLb0dwWumgxU/+HV0VWRPn5JhtqayFxSzk7wGDI0A=;
        b=GSQQiWpZLORm9c0j2cZFpJL1z6OgPPqY/u8n5qCiGZ8NB/47T9H2qJDvCUsJg+IEjL
         frg84SYamqmQgdzJiB4mdA37bdWVKiHGSlkjQRpDGQgQ//enybR8De1hn9+ezSiV9pjw
         ISQ0fNpzvrtJ40qoKZ9mCvYd5EgbLbF4EuMpMh0Gx5/oaA+OkQgDcHi+Xu0P86u6N8qv
         wuSj5wyd7OHP7Yk+KAVs67lRJwMxujQkaAkUooDwykInI7bWpP3gYIjLdaUAYaKBOAGh
         fW8DrDKkDuNg5H+TjmKQEjbnBGFlJbx67oAPn6UvYruzEoVNSWk0k0amPljXMpFeSVwt
         5qjA==
X-Gm-Message-State: AOAM531uwJSEesheFqj7e17RVoUN2unpesniydLmy5iSVvTgBIpg4Li3
        /QV02ykNXLRhL7j4cZaLQJNhskcf1nHSPA==
X-Google-Smtp-Source: ABdhPJxP5sMoD/gCL4SiOmeR7Jb0WdHCMLb5NQG0CukrEqhNQjU1FgXtZHVGNf9yHo9uWsH5NSkbcg==
X-Received: by 2002:a19:347:: with SMTP id 68mr3126116lfd.110.1612546782596;
        Fri, 05 Feb 2021 09:39:42 -0800 (PST)
Received: from rafiki.local (user-5-173-242-247.play-internet.pl. [5.173.242.247])
        by smtp.gmail.com with ESMTPSA id n16sm1053230lfq.301.2021.02.05.09.39.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 09:39:42 -0800 (PST)
From:   Lech Perczak <lech.perczak@gmail.com>
To:     linux-usb@vger.kernel.org, netdev@vger.kernel.org
Cc:     Lech Perczak <lech.perczak@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH v2 1/2] net: usb: qmi_wwan: support ZTE P685M modem
Date:   Fri,  5 Feb 2021 18:39:03 +0100
Message-Id: <20210205173904.13916-2-lech.perczak@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210205173904.13916-1-lech.perczak@gmail.com>
References: <20210205173904.13916-1-lech.perczak@gmail.com>
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
v2: no changes to this patch, resend as series.

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

