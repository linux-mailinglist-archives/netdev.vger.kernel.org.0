Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E410C46FE48
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 10:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239745AbhLJKBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 05:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239744AbhLJKBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 05:01:09 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12B3C0617A2;
        Fri, 10 Dec 2021 01:57:34 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id l25so28362868eda.11;
        Fri, 10 Dec 2021 01:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G1PqsxidNrMoTjGDIxBZooRNsXyKClIcuNd6vtliFB8=;
        b=q4bOaXUOmEObDazQ+WcSijdmncOJx6SCwpAy/MPJrTUb3Jv3d6c2uu4tR+gDu86jXU
         694ZMSfQDAz52FiI4BvZ9koza89cbjjcmCBM4pEWLpp9irBWLUXE6ROTXcokMUJMOlIC
         YU8ANvFFknqVXroDSt8/8VaO1bJ5LjvPIxZKPxzIXFyg9DscKYqAoC9gHdkcE3R9Gumz
         CUdGHxDR7i8Qc1+jOL3t44pkAATeCS1BCY2TX9PRy+xGUF3y3JJt5FGzX4MsmwHrSLv8
         su7Z2mQJcy0nOeHZJtEPRucloIq2Vw4cVkqNk9s4xKTEYk4JZ/oY6KNeBUPCr3Qqs4RH
         R/zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G1PqsxidNrMoTjGDIxBZooRNsXyKClIcuNd6vtliFB8=;
        b=erLt/FOawPGRM5bTUtRHtT+n5+FNjekHitiGv8fIYOaQResulsLsRLTJVlGu6/7icd
         rhe19YjU+krJqhy52mATnRfl3i2jgnjwBoggS5G1lmnbU/VkMXrzryolJ2E4+oIoMRAi
         08qG0uUKKiVQSVeqbt+8T5j1He9DIfh6c3kEnKe6xCmCVQ2lTrDJtbInpw+PvMqJJevG
         9iAQAGxhWHV6dX5JsJro4xPI5yQuC2qTwKVzUVM5//mjxeU2X7I49szclUO+qyjh0ouq
         hBciEbIWEh8ExAGAuIWk3O+gmJaNICuv8BgmaaTFIIsbu6luZD90JkOuriMxsZdzL5Y/
         x0Hw==
X-Gm-Message-State: AOAM533Eigg/SqoNRHt28CBS5+BL92b7z3lYdFfJMEVRLz1qi2Jz2cmu
        hPudq8vrzNZxhLXJU5HdOKY=
X-Google-Smtp-Source: ABdhPJz469+q5aM+0D2AI0xw0XaXDTyvQH30Ksrha55k67rmXA9zPEdFDZKNBIFKq0rXGXMnUlm96Q==
X-Received: by 2002:a17:906:4f05:: with SMTP id t5mr23272318eju.68.1639130253127;
        Fri, 10 Dec 2021 01:57:33 -0800 (PST)
Received: from LABNL-ITC-SW01.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id l18sm1258814ejo.114.2021.12.10.01.57.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 01:57:32 -0800 (PST)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH 1/1] net: usb: qmi_wwan: add Telit 0x1070 composition
Date:   Fri, 10 Dec 2021 10:57:22 +0100
Message-Id: <20211210095722.22269-1-dnlplm@gmail.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the following Telit FN990 composition:

0x1070: tty, adb, rmnet, tty, tty, tty, tty

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
---
Hello Bjørn,

following the output of usb-devices:

T:  Bus=02 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#=  2 Spd=10000 MxCh= 0
D:  Ver= 3.20 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 9 #Cfgs=  1
P:  Vendor=1bc7 ProdID=1070 Rev=05.04
S:  Manufacturer=Telit Wireless Solutions
S:  Product=FN990A28
S:  SerialNumber=522db9de
C:  #Ifs= 8 Cfg#= 1 Atr=80 MxPwr=896mA
I:  If#=0x0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
I:  If#=0x1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=(none)
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=50 Driver=qmi_wwan
I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=60 Driver=option
I:  If#=0x4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
I:  If#=0x5 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
I:  If#=0x6 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option

Thanks,
Daniele
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 86b814e99224..f510e8219470 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1358,6 +1358,7 @@ static const struct usb_device_id products[] = {
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1040, 2)},	/* Telit LE922A */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1050, 2)},	/* Telit FN980 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1060, 2)},	/* Telit LN920 */
+	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1070, 2)},	/* Telit FN990 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1100, 3)},	/* Telit ME910 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1101, 3)},	/* Telit ME910 dual modem */
 	{QMI_FIXED_INTF(0x1bc7, 0x1200, 5)},	/* Telit LE920 */
-- 
2.30.2

