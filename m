Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AAC9D0A86
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 11:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbfJIJHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 05:07:40 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:46144 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbfJIJHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 05:07:40 -0400
Received: by mail-wr1-f54.google.com with SMTP id o18so1793550wrv.13;
        Wed, 09 Oct 2019 02:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ta+/5ldQGB+hQ02x4fVREF0oQ0DITbv7hMBJfZw+9TM=;
        b=kSekB4a/ABipTwgg1Qzp7epXKhEwAuOKkTec/M0OE2Vzq2tQi9s472DhdolzskEgZ2
         dAIuU7pkag+jeMos2kkniNxXULhn9dQT0YfCl+E3RG17+MFjbKbhKft6s3K6QSAIhsFX
         XIBOezlTm3ymtmdEjSizhIJUuUGJuoExU0oyeqFXanI99aEHN4l5cvGotWbyLlZCAnNP
         uucf6aQDGhtyGXohR1kwiZa4JSyCt9OjAplLMClvaJ7OVS+3bnonLMWli3Htp+JsNF/y
         XrPd7ZjUC35GoA0AaKEaiDb6nwq0fjHkf8yOotkRJMoHZuOvn/wxzHVONRvd7vv7b+8Y
         u19A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ta+/5ldQGB+hQ02x4fVREF0oQ0DITbv7hMBJfZw+9TM=;
        b=q0FkyM+RfIrWDe8KGxoyr8+cDdLZZ6gI47wNro6YXOM7Uxk1kJbmhCCCOqoYTXSZk8
         kGzgkqIehhTqAbUUMXGajfR9r8Qcyco3YBwzztTQVKjZlGJDKHaPtF6hcXfjeAJfc2dG
         LuzVH6QFri0ZZ6Eu7gg+h/58+TSUnBNLf12Rj7yy8C0KnkS2uMfr2TBDTqdxZKD0x2TI
         6TsjWMW7GzMvmeDrlThGjRxc489zUNf8MsR1x6J/28aPWeSa0t/Lp+WyQO0GpD8P14K8
         RLzWafCy2DgqVccsc8whRhr/YTx77QtJTHIGmt5HDRznWR/4Be231p32dnRyeuWRRnWQ
         CeQQ==
X-Gm-Message-State: APjAAAUS2fys/k0GDRDjXh4KXeZYwm2ETIT+44sSXDnSjPZ7A9Aa+XQX
        qkkrl6Fo1J4zD8PvClwGHJY=
X-Google-Smtp-Source: APXvYqz7FQygHN5c8EGYOxeRMN5XY7LilFagA/oUi/soiqSfTAOHZvzXyhLJeAkM9IYRTXgdG4ehBw==
X-Received: by 2002:adf:9e02:: with SMTP id u2mr2048434wre.329.1570612056616;
        Wed, 09 Oct 2019 02:07:36 -0700 (PDT)
Received: from danielepa-ThinkCentre-M93p.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id n26sm676450wmd.42.2019.10.09.02.07.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 02:07:35 -0700 (PDT)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        linux-usb@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH 1/1] net: usb: qmi_wwan: add Telit 0x1050 composition
Date:   Wed,  9 Oct 2019 11:07:18 +0200
Message-Id: <20191009090718.12879-1-dnlplm@gmail.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for Telit FN980 0x1050 composition

0x1050: tty, adb, rmnet, tty, tty, tty, tty

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
---
Hi Bjørn,

please find below usb-devices output

T:  Bus=03 Lev=01 Prnt=01 Port=06 Cnt=02 Dev#= 10 Spd=480 MxCh= 0
D:  Ver= 2.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1bc7 ProdID=1050 Rev=04.14
S:  Manufacturer=Telit Wireless Solutions
S:  Product=FN980m
S:  SerialNumber=270b8241
C:  #Ifs= 7 Cfg#= 1 Atr=80 MxPwr=500mA
I:  If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
I:  If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=usbfs
I:  If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
I:  If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#= 5 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#= 6 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option

Thanks,
Daniele
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 3d77cd402ba9..596428ec71df 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1327,6 +1327,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x2357, 0x0201, 4)},	/* TP-LINK HSUPA Modem MA180 */
 	{QMI_FIXED_INTF(0x2357, 0x9000, 4)},	/* TP-LINK MA260 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1040, 2)},	/* Telit LE922A */
+	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1050, 2)},	/* Telit FN980 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1100, 3)},	/* Telit ME910 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1101, 3)},	/* Telit ME910 dual modem */
 	{QMI_FIXED_INTF(0x1bc7, 0x1200, 5)},	/* Telit LE920 */
-- 
2.17.1

