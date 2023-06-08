Return-Path: <netdev+bounces-9116-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC19E727562
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 05:03:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 20DAF1C20F52
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 03:03:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7702A57;
	Thu,  8 Jun 2023 03:03:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9281637
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 03:03:34 +0000 (UTC)
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8BB2115;
	Wed,  7 Jun 2023 20:03:32 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id 46e09a7af769-6b291d55f52so60782a34.2;
        Wed, 07 Jun 2023 20:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686193412; x=1688785412;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZIJSy3f8mfMTvVk+C/jv8xuqI307FWWCGcIcKPcWwQA=;
        b=A3Se/JedcbFPQpz/OS95VPY+fztk8F3cGTFsYO+ezyPvH7JQ7xM+jwL12g6rYNpPAq
         bl+IP1LwNB3c2YUfOCBRPTJmRusoynQoCOHuU3vR0IkJO8lEm46Uw452w8xunCn3cbTi
         WB1W3/1FTYz5ynctELrcwTWeQ2qXQH1Rf1wm0Qtack1exdIDczkuz/sBG7/bxBLvhZPt
         yoZZZiKez4pfVZ7WKNSKMArsZ5LmlxU9iZn5Ab1nu9fltKiA0gLP+HHCCrwKhlcFSJVG
         Nw3cuMK7L4n2S98YVS+2LIrFoqMA2pMsM+4KbKRTtx5+K+TJYm3AC4yUxWRuvMQReiLS
         /7Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686193412; x=1688785412;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZIJSy3f8mfMTvVk+C/jv8xuqI307FWWCGcIcKPcWwQA=;
        b=GXXWnmdvijTWV0kXXld5Amz9xfUfmFJ/wissHHCl+c6H4wf8pISxejRHRqolD8TcEK
         hIRBmKhwpiR5nqOu0yOE1ebHkYLzvaKDxg6cN1GFYpFUvGMJFk6M+VbmHvsktjq/HBSY
         LV4kFq0O3Ykid18wouRDWydJdE63zQVDYFo2l8xB3GNFwdXitRHI2WJ6bG1VPwTDYY08
         7TGbKhXNYiHwhkNQ0G7Mr3a8Z9SwFnwcJEOTj42mjzmTVHo3mlpBNPyAx11+fiDxyKbb
         fod8O7ZsPQsOv5R/uwdbuzGRgytRj3vgBi0YGRQmB3XjfJ1ssc7hT+sHbwzCMfPVU8Ok
         W8XQ==
X-Gm-Message-State: AC+VfDwUwfJTg56XJdzNe4K8ObCIBegK5NCxWfJkFlfgc7mrKuLx8myo
	T0PRqzqd0AadFMgHH/jRSOI=
X-Google-Smtp-Source: ACHHUZ4R+6s7cg2wRZfDGQyockcpDWi9JMFyEToT/pb/qLH2yA0XBOVCSZ5aNSuT/0F7/sIvqJhtLQ==
X-Received: by 2002:a9d:4b09:0:b0:6af:a47b:28b4 with SMTP id q9-20020a9d4b09000000b006afa47b28b4mr5177613otf.2.1686193412148;
        Wed, 07 Jun 2023 20:03:32 -0700 (PDT)
Received: from weshuang.weshuang (123-51-235-192.moxa.com. [123.51.235.192])
        by smtp.googlemail.com with ESMTPSA id a15-20020aa7864f000000b0064fe332209esm56378pfo.98.2023.06.07.20.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 20:03:31 -0700 (PDT)
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
Subject: [PATCH V2 1/1] net: usb: qmi_wwan: add support for Compal RXM-G1
Date: Thu,  8 Jun 2023 11:01:42 +0800
Message-Id: <20230608030141.3546-1-wes.huang@moxa.com>
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

From: Wes Huang <wes.huang@moxa.com>

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
V1 -> V2: No code change, just add "From" to the email body to let
author information is correct.

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


