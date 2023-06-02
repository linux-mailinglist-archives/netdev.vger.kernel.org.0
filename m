Return-Path: <netdev+bounces-7311-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6880C71F9B5
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 07:42:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A32F91C210EC
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 05:41:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4DE01FB7;
	Fri,  2 Jun 2023 05:41:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B0A1FA0
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 05:41:57 +0000 (UTC)
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9898F197;
	Thu,  1 Jun 2023 22:41:54 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1b026657a6fso14866685ad.0;
        Thu, 01 Jun 2023 22:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685684514; x=1688276514;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3CaEroasOn4UO6sL5Z/L/5g3HrtiTz/xAX7Vnu4/IiE=;
        b=UJo7bgnZf7QCmkXkiRYgmyEH+4UfbK+dZc1XJ/OymlprZcuFiEf99txwV8oF/s022Y
         7JlGc3naOs5KG5Zs7UwtF8umAHRZ9IHgM5cOi8wcvBsJJ0Ymg8WW0A+78Sr0WMXq2OQ7
         CCTlgm4r4edRN8ZdNuDDoiWJ7qqKGz5fmatJUr1vRFDOhVYOdnAbMX51jPmrTyShQ8u3
         nYjf1Bd4jXxwRWZZqIUUMRA7rCKGH8ZOaNZI2ug+DupoAKsw3R/ZmJ46MeT8daZnFZ9e
         iwZo/w4ScG/GnYlteww/JSYz+kRK4Dqd+hAZld1wsRLFVB1RMPu1N6rCLU/ntCnJkMew
         IO2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685684514; x=1688276514;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3CaEroasOn4UO6sL5Z/L/5g3HrtiTz/xAX7Vnu4/IiE=;
        b=i99ItJYSIf8G9Ns0mO8KkTLyqro95+BPYeaQjHVTwFYmDL9meMZjoFS5y5cV4vGa8y
         5l589N9kal8tLddvWZ1Trbi8nLgFtcuBA9qu9W9+AoQaxyxG0wiIJnC109vTgBZXEb4S
         uZa/VK1DkYu2dMGWuaJsP7t1W7X6Y2apr4AymMW6LQf9QZIytYgirKJSg3JpCUo41UQi
         ikJM45rK4Qj9a121PtzugLc/V5P/ASqTU4s6NTCsvytEK6gwedhpOUzZCwyk13PW/wrI
         fVNc3FrtPcC6qTNHrSU1TM2oTow4rwu97YcSvpRyimA8l07Qx5RQckdY5yMfcQUP6M4w
         AMDQ==
X-Gm-Message-State: AC+VfDzmhsRG75lH7/Qb1ADJuqKTxFGLoKD4Q1wjzjevxNtBWM94tnJx
	SZ+8e4D+RvfnI4lUn7lxuu4=
X-Google-Smtp-Source: ACHHUZ5qal2e2kKGi2AeosoAprqOmUv7hTHuG2bhDNbMjh0QT+z7D6gV9a/wkkXA+/VNBe8nPt1Rbg==
X-Received: by 2002:a17:902:8506:b0:1ad:1c29:80ef with SMTP id bj6-20020a170902850600b001ad1c2980efmr1351861plb.18.1685684513926;
        Thu, 01 Jun 2023 22:41:53 -0700 (PDT)
Received: from weshuang.weshuang (123-51-235-192.moxa.com. [123.51.235.192])
        by smtp.googlemail.com with ESMTPSA id w3-20020a170902d70300b001ab0d815dbbsm390501ply.23.2023.06.01.22.41.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 22:41:53 -0700 (PDT)
From: Wes Huang <wes155076@gmail.com>
X-Google-Original-From: Wes Huang <wes.huang@moxa.com>
To: bjorn@mork.no
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wes Huang <wes.huang@moxa.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/1] net: usb: qmi_wwan: add support for Compal RXM-G1
Date: Fri,  2 Jun 2023 13:41:12 +0800
Message-Id: <20230602054112.2299565-1-wes.huang@moxa.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add support for Compal RXM-G1 which is based on Qualcomm SDX55 chip.
This patch adds support for two compositions:

0x9091: DIAG + MODEM + QMI_RMNET + ADB
0x90db: DIAG + DUN + RMNET + DPL + QDSS(Trace) + ADB

T:  Bus=03 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=5000 MxCh= 0
D:  Ver= 3.20 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 9 #Cfgs=  1
P:  Vendor=05c6 ProdID=9091 Rev= 4.14
S:  Manufacturer=QCOM
S:  Product=SDXPRAIRIE-MTP _SN:719AB680
S:  SerialNumber=719ab680
C:* #Ifs= 4 Cfg#= 1 Atr=80 MxPwr=896mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=(none)
E:  Ad=81(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=83(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
E:  Ad=84(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
E:  Ad=8e(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=0f(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:* If#= 3 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=(none)
E:  Ad=03(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=85(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms

T:  Bus=03 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=5000 MxCh= 0
D:  Ver= 3.20 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 9 #Cfgs=  1
P:  Vendor=05c6 ProdID=90db Rev= 4.14
S:  Manufacturer=QCOM
S:  Product=SDXPRAIRIE-MTP _SN:719AB680
S:  SerialNumber=719ab680
C:* #Ifs= 6 Cfg#= 1 Atr=80 MxPwr=896mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=(none)
E:  Ad=81(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=83(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
E:  Ad=84(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
E:  Ad=8e(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=0f(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:* If#= 3 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=8f(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:* If#= 4 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=85(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:* If#= 5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=(none)
E:  Ad=03(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=86(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms

Cc: stable@vger.kernel.org
Signed-off-by: Wes Huang <wes.huang@moxa.com>
---
 drivers/net/usb/qmi_wwan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 571e37e67f9c..90f4655a671d 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1220,7 +1220,9 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x05c6, 0x9080, 8)},
 	{QMI_FIXED_INTF(0x05c6, 0x9083, 3)},
 	{QMI_FIXED_INTF(0x05c6, 0x9084, 4)},
+	{QMI_QUIRK_SET_DTR(0x05c6, 0x9091, 2)},	/* Compal RXM-G1 */
 	{QMI_FIXED_INTF(0x05c6, 0x90b2, 3)},    /* ublox R410M */
+	{QMI_QUIRK_SET_DTR(0x05c6, 0x90db, 2)},	/* Compal RXM-G1 */
 	{QMI_FIXED_INTF(0x05c6, 0x920d, 0)},
 	{QMI_FIXED_INTF(0x05c6, 0x920d, 5)},
 	{QMI_QUIRK_SET_DTR(0x05c6, 0x9625, 4)},	/* YUGA CLM920-NC5 */
-- 
2.30.2


