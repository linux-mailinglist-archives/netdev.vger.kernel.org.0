Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 205131044C8
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 21:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbfKTUJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 15:09:05 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36994 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbfKTUJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 15:09:04 -0500
Received: by mail-wr1-f68.google.com with SMTP id t1so1455954wrv.4
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 12:09:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9nKUhP92Oc+91o12eI/muFJbDSQxBxjVx9WcvRC2Rhs=;
        b=sGaOg5gAgafeB5mswBC4DlxiNAwe7UHwBKY60lkT03O8YLnMCm+RtVLueT47kbjR14
         mCrugTwAjoYt+QrXH7Xg4+jLGc9FdtFbvPbG1D5VPsWsahvK/baxDg23uK0ElMUwqhQ6
         iYPfZmMXnJMJPnI1IfOsiaWUpZsKJqprQea5NgUo91PGP0yV5ZEMCXFcpR9XsWndC23E
         2f8BWsGl4FOzim6Z+XYdlXiBqIu7RV9A7g2Wn3SmDeGNMzB9lI3PhFpH2g9pMJoP0e/3
         XcFO773NkmnXtGIs12CsoVby7cx11s1T+LUiCSJgoilIosdd7hCXvMZfejkgrKUZsiYu
         m/KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9nKUhP92Oc+91o12eI/muFJbDSQxBxjVx9WcvRC2Rhs=;
        b=Cf2pfPZvzjUqV+9GRYcecc6gcaEM3qJvzG+SeUrPl+CxzxjQElBTLsFBEQXl6Y80S6
         HUgmmOXHLnum9cxWhNWiF1+hk7BQoMGAfC27uFl03Wkd+UL04P5D5OMpzuGVrEA81Z2l
         fgzfe6ygGObh5r9YU0iV+V0/lHHoi+R4KTkpzz6d/z6gE746qmWxpoHLXITFf/LTvRe8
         Ogz0+Nz2FhaMaZqexvt2r2/RIisiLE8QAHKyU/csz3OKy0rnpmLh85tfmZV8VnxnAhOr
         65nMZ7yFfySZXhWjPtwELfiySOaNi33Z66Io4D8y0dJSljxrRPun67QISrL1Q6ZT4zbZ
         le9A==
X-Gm-Message-State: APjAAAW/Ck6YV4gpL5X4PFszW5NoBgmBYNeGxRcshy/uQYh0IF3CZl1c
        +R7lDRs345D9RvE4OVFHJ/h273wk
X-Google-Smtp-Source: APXvYqyn5QZWtiXZUY8URn/XAcel5JLejBCOFqNUuf5YIXISGzRJY3TeaTeWejc7JqdDTSBqbeIIXA==
X-Received: by 2002:a5d:44c1:: with SMTP id z1mr5685470wrr.162.1574280542232;
        Wed, 20 Nov 2019 12:09:02 -0800 (PST)
Received: from ?IPv6:2003:ea:8f2d:7d00:1b5:77c:1d90:d2c6? (p200300EA8F2D7D0001B5077C1D90D2C6.dip0.t-ipconnect.de. [2003:ea:8f2d:7d00:1b5:77c:1d90:d2c6])
        by smtp.googlemail.com with ESMTPSA id w11sm477664wra.83.2019.11.20.12.09.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Nov 2019 12:09:01 -0800 (PST)
Subject: [PATCH net-next 3/3] r8169: add check for PHY_MDIO_CHG to
 rtl_nic_fw_data_ok
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <6bb940ea-f479-f264-bc12-b4be52293dd6@gmail.com>
Message-ID: <4ea94370-971e-4044-d8f5-df1366ecd975@gmail.com>
Date:   Wed, 20 Nov 2019 21:08:47 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <6bb940ea-f479-f264-bc12-b4be52293dd6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only values 0 and 1 are currently defined as parameters for
PHY_MDIO_CHG. Instead of silently ignoring unknown values and
misinterpreting the firmware code let's explicitly check.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_firmware.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_firmware.c b/drivers/net/ethernet/realtek/r8169_firmware.c
index 927bb46b3..355cc810e 100644
--- a/drivers/net/ethernet/realtek/r8169_firmware.c
+++ b/drivers/net/ethernet/realtek/r8169_firmware.c
@@ -92,19 +92,24 @@ static bool rtl_fw_data_ok(struct rtl_fw *rtl_fw)
 
 	for (index = 0; index < pa->size; index++) {
 		u32 action = le32_to_cpu(pa->code[index]);
+		u32 val = action & 0x0000ffff;
 		u32 regno = (action & 0x0fff0000) >> 16;
 
 		switch (action >> 28) {
 		case PHY_READ:
 		case PHY_DATA_OR:
 		case PHY_DATA_AND:
-		case PHY_MDIO_CHG:
 		case PHY_CLEAR_READCOUNT:
 		case PHY_WRITE:
 		case PHY_WRITE_PREVIOUS:
 		case PHY_DELAY_MS:
 			break;
 
+		case PHY_MDIO_CHG:
+			if (val > 1)
+				goto out;
+			break;
+
 		case PHY_BJMPN:
 			if (regno > index)
 				goto out;
@@ -164,12 +169,12 @@ void rtl_fw_write_firmware(struct rtl8169_private *tp, struct rtl_fw *rtl_fw)
 			index -= (regno + 1);
 			break;
 		case PHY_MDIO_CHG:
-			if (data == 0) {
-				fw_write = rtl_fw->phy_write;
-				fw_read = rtl_fw->phy_read;
-			} else if (data == 1) {
+			if (data) {
 				fw_write = rtl_fw->mac_mcu_write;
 				fw_read = rtl_fw->mac_mcu_read;
+			} else {
+				fw_write = rtl_fw->phy_write;
+				fw_read = rtl_fw->phy_read;
 			}
 
 			break;
-- 
2.24.0


