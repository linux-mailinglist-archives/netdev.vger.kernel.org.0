Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A96518D9AB
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 21:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgCTUqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 16:46:39 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:34129 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbgCTUqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 16:46:38 -0400
Received: by mail-lj1-f196.google.com with SMTP id s13so7958103ljm.1;
        Fri, 20 Mar 2020 13:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cApA+BQWDVxDx5bb8kvwHSCG2U9HmDttS8GsDoUY+Kw=;
        b=qpEj1Tje57aXhu+hlbNWU3jX8SGXBY7IdfGVwDZB4lydl5bdifD7nlK2AY/BIPia4C
         8NOOGaBn5asdlzuGAlydeXi13QQlzhc0vnj1+Xk5B/F17WIjsnO3vAY+oMVFtWcdNFmv
         QZuN4gzX3XauQIDXoNX4+/EChKMJUOGQMzW9B+/wEI/BdoLjTt1hbRJ+WaXlJfq42rwQ
         rKk1L0AVwjnikzS9v2r9Cz7mPmOeOUi7ravHlYd6qWXSa7UqgnY/ukGOEhtckXL6VRP6
         UOqvDNjUcJ7nEDxKddsmfDu26b8ZBb6KuLHJLZoO/POxoCFIR2tI5D1r/YLi9udBpY+U
         C7QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cApA+BQWDVxDx5bb8kvwHSCG2U9HmDttS8GsDoUY+Kw=;
        b=DpK6v/Pd+WWSO8nkMUwbDyrhNjnyG/vgmEy1cuuJm1fMTEi7e3lQI7t1KkLphE3WqK
         ljtKEagpR1bc71zQAW8ugy6m4T6B8o96oWBRNqUxQkOYrHolI64Ygs82krn1//Y0fYJ1
         ZH5P1JQg2xu9nJqGOZsz2Uqqp4py8xLJYgXECgHWzQ0hhRvtgihHRJ6YMRp/zWefFL7/
         cCnmoEPdIaOUnon3UlN+FlFAgfT4c+DmNFsETAtalr0V4Dpd5srRqB1ETWOR/DWbyz/o
         gYwVGVMwH8taBkWEbJ1fjUv9RaPQwfVDbn64QCI0EExjiERBraESbHsw/BTXFYcAC2gF
         +iNw==
X-Gm-Message-State: ANhLgQ1D27yd8hkDdvvgG0DdGzsaOvZoGK1wF0yn8175buqulJtZtQ3I
        Evrs+qCeiVaCTsi5DlNccBU=
X-Google-Smtp-Source: ADFU+vuQeP/xD5dedHwcuWkWIJ1JpK1KHML8RuzzVJDZkVhmzwxPcsiLUu+DDmvOwUSsQ0UPYAcdIw==
X-Received: by 2002:a2e:8991:: with SMTP id c17mr6674129lji.278.1584737195853;
        Fri, 20 Mar 2020 13:46:35 -0700 (PDT)
Received: from localhost.localdomain ([185.188.71.122])
        by smtp.gmail.com with ESMTPSA id j6sm4078098lfb.13.2020.03.20.13.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 13:46:35 -0700 (PDT)
From:   Pawel Dembicki <paweldembicki@gmail.com>
Cc:     Pawel Dembicki <paweldembicki@gmail.com>,
        Cezary Jackiewicz <cezary@eko.one.pl>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: qmi_wwan: add support for ASKEY WWHC050
Date:   Fri, 20 Mar 2020 21:46:14 +0100
Message-Id: <20200320204614.4662-1-paweldembicki@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ASKEY WWHC050 is a mcie LTE modem.
The oem configuration states:

T:  Bus=01 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=480  MxCh= 0
D:  Ver= 2.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1690 ProdID=7588 Rev=ff.ff
S:  Manufacturer=Android
S:  Product=Android
S:  SerialNumber=813f0eef6e6e
C:* #Ifs= 6 Cfg#= 1 Atr=80 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=(none)
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=84(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=86(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=85(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
E:  Ad=88(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
E:  Ad=87(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 5 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=(none)
E:  Ad=89(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=06(O) Atr=02(Bulk) MxPS= 512 Ivl=125us

Tested on openwrt distribution.

Signed-off-by: Cezary Jackiewicz <cezary@eko.one.pl>
Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>
---
Changes in v2:
- drop option driver changes, it will be sended with separate patch
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 5754bb6ca0ee..6c738a271257 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1210,6 +1210,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x1435, 0xd182, 5)},	/* Wistron NeWeb D18 */
 	{QMI_FIXED_INTF(0x1435, 0xd191, 4)},	/* Wistron NeWeb D19Q1 */
 	{QMI_QUIRK_SET_DTR(0x1508, 0x1001, 4)},	/* Fibocom NL668 series */
+	{QMI_FIXED_INTF(0x1690, 0x7588, 4)},    /* ASKEY WWHC050 */
 	{QMI_FIXED_INTF(0x16d8, 0x6003, 0)},	/* CMOTech 6003 */
 	{QMI_FIXED_INTF(0x16d8, 0x6007, 0)},	/* CMOTech CHE-628S */
 	{QMI_FIXED_INTF(0x16d8, 0x6008, 0)},	/* CMOTech CMU-301 */
-- 
2.20.1

