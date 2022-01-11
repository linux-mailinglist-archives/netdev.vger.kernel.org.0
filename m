Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0F9448BA87
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 23:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345853AbiAKWLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 17:11:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244521AbiAKWLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 17:11:49 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280B2C06173F;
        Tue, 11 Jan 2022 14:11:49 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id d3so1430839lfv.13;
        Tue, 11 Jan 2022 14:11:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ABpuuHXn/KSGqt8Q9356w3nXXxQ7pyPctr1HuJVZT2U=;
        b=a2+4ko2r4QG7Xqfy6WgZsBf3aMwAHTa2+gMBuERyMgGhP7qNuZJl3w0715EzXMTTSI
         fi8w9TMUK1tRJpkU+B7+K2YalE5m5m4GAiP98esCyLJHJ6IlN02FIRFCooeY96EGzvaI
         Pf7KEYUnml/dBHp0z9SWI46aAkGAFu8PFg7HycNhoXojlNohccp+M231XsgYkMrp0m3K
         kXqH9EtwrvspiggSNNfn/qxGZzuGqk04bAFEbP2+VfFs6P+1Stwl74apbbj/zq9z4If3
         OK2ruGGOD9K6sUdxWemTacVc0VkmSNy4R1JQ3GUda0m2kQYgCTubCZ6gRmRAqxI2equc
         r7pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ABpuuHXn/KSGqt8Q9356w3nXXxQ7pyPctr1HuJVZT2U=;
        b=NrLMB0mT+LDWGTC5jFniSh12rgLn4k+QhURRE9q+2be6lXA/e5W5eMmzrlCNSAn8Y5
         nab7CPnQIArkBIdvgxIVGCbzRKMgexGRoD58gLF2vl4bEfdh3JpRf8Px/1ZutzrWYciJ
         S192K6xZcWhWgFbptuwisRsdB5N+S1FuOcdhsJaqcgmkemh/aWYOU/4rlPBHGo6yHwmM
         muGtIwB+u0gWjckYHhj0yMdElaqC1noJBQ0fYp5oGSbXCHlOATEkqK0G8x45b6YyU1uT
         hmMVm/xiqZHP9aTE1vCZYYOlcaMaDZTlWqzes1+2sTfHhNucNZNSFDcpeO956dFFvMUH
         /EyA==
X-Gm-Message-State: AOAM531vRI8HkMfCtFgebrJjTJ59ie81MAjErGRKwnJ2WFP570DfQpp3
        rzUbPBQlQifNTTc7pP7cgA3Hw/hCQQk=
X-Google-Smtp-Source: ABdhPJyL3/IL7jI2fdxyGMRF3GlgNLwZAfS/A7//8SIMNrS5K0zvTxQnYvj+lV52PfoI+7iGViJQYQ==
X-Received: by 2002:a05:6512:acc:: with SMTP id n12mr4674024lfu.196.1641939107228;
        Tue, 11 Jan 2022 14:11:47 -0800 (PST)
Received: from WBEC678.wbe.local (xt27d8.stansat.pl. [83.243.39.216])
        by smtp.gmail.com with ESMTPSA id q10sm309678lfu.53.2022.01.11.14.11.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 14:11:46 -0800 (PST)
From:   Pawel Dembicki <paweldembicki@gmail.com>
To:     linux-usb@vger.kernel.org
Cc:     Pawel Dembicki <paweldembicki@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: qmi_wwan: add ZTE MF286D modem 19d2:1485
Date:   Tue, 11 Jan 2022 23:11:32 +0100
Message-Id: <20220111221132.14586-1-paweldembicki@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modem from ZTE MF286D is an Qualcomm MDM9250 based 3G/4G modem.

T:  Bus=02 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  3 Spd=5000 MxCh= 0
D:  Ver= 3.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 9 #Cfgs=  1
P:  Vendor=19d2 ProdID=1485 Rev=52.87
S:  Manufacturer=ZTE,Incorporated
S:  Product=ZTE Technologies MSM
S:  SerialNumber=MF286DZTED000000
C:* #Ifs= 7 Cfg#= 1 Atr=80 MxPwr=896mA
A:  FirstIf#= 0 IfCount= 2 Cls=02(comm.) Sub=06 Prot=00
I:* If#= 0 Alt= 0 #EPs= 1 Cls=02(comm.) Sub=02 Prot=ff Driver=rndis_host
E:  Ad=82(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=rndis_host
E:  Ad=81(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:* If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
E:  Ad=83(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
E:  Ad=85(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=84(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:* If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
E:  Ad=87(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=86(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:* If#= 5 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
E:  Ad=88(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
E:  Ad=8e(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=0f(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:* If#= 6 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=usbfs
E:  Ad=05(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=89(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms

Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index f510e8219470..0d5bc26c9f2e 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1316,6 +1316,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x19d2, 0x1426, 2)},	/* ZTE MF91 */
 	{QMI_FIXED_INTF(0x19d2, 0x1428, 2)},	/* Telewell TW-LTE 4G v2 */
 	{QMI_FIXED_INTF(0x19d2, 0x1432, 3)},	/* ZTE ME3620 */
+	{QMI_FIXED_INTF(0x19d2, 0x1485, 5)},	/* ZTE MF286D */
 	{QMI_FIXED_INTF(0x19d2, 0x2002, 4)},	/* ZTE (Vodafone) K3765-Z */
 	{QMI_FIXED_INTF(0x2001, 0x7e16, 3)},	/* D-Link DWM-221 */
 	{QMI_FIXED_INTF(0x2001, 0x7e19, 4)},	/* D-Link DWM-221 B1 */
-- 
2.25.1

