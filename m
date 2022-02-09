Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 057C94AE7FE
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 05:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244580AbiBIEHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 23:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346828AbiBIDiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 22:38:54 -0500
Received: from mail-m974.mail.163.com (mail-m974.mail.163.com [123.126.97.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EA077C043188;
        Tue,  8 Feb 2022 19:33:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=P6YRM
        vZrszN+VySkNSrGHtGd3i/66fEQ9oe+G3JBq3c=; b=PtMAVONpTzf0raGf7V42m
        jcs9M/IbShvr0zwBAUMYYK5BFl5XvgU3EBZyiNAZVZfYGcwjsZdXrxmCGbY4eLb0
        n2sMQS2g/zwh+GLHhMVoImLK1LNp/YjFbfxa76WiDiAYYiz6ltr5UTimd6FIuxTS
        R/Kt+39kz9Gg9KbY/YiCpI=
Received: from localhost.localdomain (unknown [112.97.82.107])
        by smtp4 (Coremail) with SMTP id HNxpCgC3pRo4KwNiKHlaBg--.26133S2;
        Wed, 09 Feb 2022 10:47:24 +0800 (CST)
From:   Slark Xiao <slark_xiao@163.com>
To:     bjorn@mork.no, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Slark Xiao <slark_xiao@163.com>
Subject: [PATCH net] net: usb: qmi_wwan: Add support for Dell DW5829e
Date:   Wed,  9 Feb 2022 10:47:17 +0800
Message-Id: <20220209024717.8564-1-slark_xiao@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HNxpCgC3pRo4KwNiKHlaBg--.26133S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxur4UJrW5XrykCr47JF4DXFb_yoW5Xryfpr
        1UAr17AFyUJF12vFykAF1xZryF9an7Wr9rtasF9an7WFWIvrs7t3yDtF9rZF1Iga1fK3WD
        tFs8Kr47Kwn5GFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRpHqsUUUUU=
X-Originating-IP: [112.97.82.107]
X-CM-SenderInfo: xvod2y5b0lt0i6rwjhhfrp/1tbiRwGhZFc7VzxTYQABs3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dell DW5829e same as DW5821e except the CAT level.
DW5821e supports CAT16 but DW5829e supports CAT9.
Also, DW5829e includes normal and eSIM type.
Please see below test evidence:

T:  Bus=04 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#=  5 Spd=5000 MxCh= 0
D:  Ver= 3.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS= 9 #Cfgs=  1
P:  Vendor=413c ProdID=81e6 Rev=03.18
S:  Manufacturer=Dell Inc.
S:  Product=DW5829e Snapdragon X20 LTE
S:  SerialNumber=0123456789ABCDEF
C:  #Ifs= 6 Cfg#= 1 Atr=a0 MxPwr=896mA
I:  If#=0x0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
I:  If#=0x1 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=00 Prot=00 Driver=usbhid
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option

T:  Bus=04 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#=  7 Spd=5000 MxCh= 0
D:  Ver= 3.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS= 9 #Cfgs=  1
P:  Vendor=413c ProdID=81e4 Rev=03.18
S:  Manufacturer=Dell Inc.
S:  Product=DW5829e-eSIM Snapdragon X20 LTE
S:  SerialNumber=0123456789ABCDEF
C:  #Ifs= 6 Cfg#= 1 Atr=a0 MxPwr=896mA
I:  If#=0x0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
I:  If#=0x1 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=00 Prot=00 Driver=usbhid
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option

Signed-off-by: Slark Xiao <slark_xiao@163.com>
---
 drivers/net/usb/qmi_wwan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 37e5f3495362..3353e761016d 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1400,6 +1400,8 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x413c, 0x81d7, 0)},	/* Dell Wireless 5821e */
 	{QMI_FIXED_INTF(0x413c, 0x81d7, 1)},	/* Dell Wireless 5821e preproduction config */
 	{QMI_FIXED_INTF(0x413c, 0x81e0, 0)},	/* Dell Wireless 5821e with eSIM support*/
+	{QMI_FIXED_INTF(0x413c, 0x81e4, 0)},	/* Dell Wireless 5829e with eSIM support*/
+	{QMI_FIXED_INTF(0x413c, 0x81e6, 0)},	/* Dell Wireless 5829e */
 	{QMI_FIXED_INTF(0x03f0, 0x4e1d, 8)},	/* HP lt4111 LTE/EV-DO/HSPA+ Gobi 4G Module */
 	{QMI_FIXED_INTF(0x03f0, 0x9d1d, 1)},	/* HP lt4120 Snapdragon X5 LTE */
 	{QMI_QUIRK_SET_DTR(0x22de, 0x9051, 2)}, /* Hucom Wireless HM-211S/K */
-- 
2.25.1

