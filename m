Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1912F2E522
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 21:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbfE2TPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 15:15:20 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42284 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbfE2TPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 15:15:19 -0400
Received: by mail-wr1-f68.google.com with SMTP id l2so2531406wrb.9
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 12:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=p+BPDJcjcgwVodcJu2/c3bVJ3Q+Y9n5JCWpzp9FvMI8=;
        b=A3m1jPTPgtUO7mqa33wuS3In1Xwn+ik3CgSXCasRtuZiA8944dXiryMsii6iHUQx4F
         xt+tub0YkIzxdpIudqxOgShTp+aRjXIZ+7UWfalQBZgAjEpHf5qZtrsYoLQjoFyE969b
         8spxnTCL5Utq5aWT6ktc8wT4JFwMFsnkXfvt831exyj1A7Vk/cbwg3+wliDIVIwLOyPP
         0T6UckgaBo/yjHBGJIRck6rtvvXW7NEjqJxMfztO8ywX6Xe3vJW6TjdWJDuvG2FJmY1l
         gYjS4oPXmEH64TjfLNhYmd/UsjEdRs7eUc0q5t6V2yxLtm8vxFE0LK2F/DEXx5RKGPyc
         WUUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=p+BPDJcjcgwVodcJu2/c3bVJ3Q+Y9n5JCWpzp9FvMI8=;
        b=j5WtLhtUQT1wPkvPWIEZRpA61q0D+oFgNgfl49nnto0xytmQdpj0DmZn+yVZtG4aCD
         blWvbuas2SP2PgGvVmIMtCI4UpR0FS0iGckeGHZ2cOYYMigj9DHJpbOcbiD2tdF42z6J
         7++WRB9hU/9+YftQKV8oD8gQhviw7zVBk+eMnxgxbE+TiPjntGjtyCHXxLkMj0GG90B2
         CTPeGCxbIYlYmlYKuUIVwMTkRR5lH53g4QqSd+oCuff4aNIktSUoWOto+nFukLQ+pUGC
         5qnG5ZZDliEIuYYbG4i2AauFzmzlUEFD9sKJQ9afCVW+VaEiDNfcZAurlvefNJFVmRht
         9rUg==
X-Gm-Message-State: APjAAAVAySgkxm/3JeCV8ikZvJJWkgxf9VzcZfQzlwgy9c1MZpMx6nYe
        ib20cFhNCo/rFCu/vAq/OzoVnPsW
X-Google-Smtp-Source: APXvYqw0O+Ky1g9WjDN4wXyGZrVEiPP5r2RG4zzQj1Fa95jet81YMesi//UY0oxbhcgy/Z0H7Am8Xw==
X-Received: by 2002:adf:f84f:: with SMTP id d15mr4008199wrq.53.1559157316808;
        Wed, 29 May 2019 12:15:16 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:c13b:48f0:87ee:c916? (p200300EA8BF3BD00C13B48F087EEC916.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:c13b:48f0:87ee:c916])
        by smtp.googlemail.com with ESMTPSA id b2sm600243wrt.20.2019.05.29.12.15.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 12:15:16 -0700 (PDT)
Subject: [PATCH net-next 2/2] r8169: decouple rtl_phy_write_fw from actual
 driver code
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <57c46ad0-f086-7321-aeca-8744a607b622@gmail.com>
Message-ID: <eacdadea-3f90-d10a-5c54-488634732f77@gmail.com>
Date:   Wed, 29 May 2019 21:15:06 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <57c46ad0-f086-7321-aeca-8744a607b622@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is a further step towards decoupling firmware handling from
the actual driver code. Firmware can be for PHY and/or MAC, and two
pairs of read/write functions are needed for handling PHY firmware and
MAC firmware respectively. Pass these functions via struct rtl_fw and
avoid the ugly switching of mdio_ops behind the back of rtl_writephy().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.c | 48 ++++++++++++++++------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index af5359d20..962ef3d8c 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -626,6 +626,10 @@ struct rtl8169_stats {
 	struct u64_stats_sync	syncp;
 };
 
+struct rtl8169_private;
+typedef void (*rtl_fw_write_t)(struct rtl8169_private *tp, int reg, int val);
+typedef int (*rtl_fw_read_t)(struct rtl8169_private *tp, int reg);
+
 struct rtl8169_private {
 	void __iomem *mmio_addr;	/* memory map physical address */
 	struct pci_dev *pci_dev;
@@ -679,6 +683,10 @@ struct rtl8169_private {
 
 	const char *fw_name;
 	struct rtl_fw {
+		rtl_fw_write_t phy_write;
+		rtl_fw_read_t phy_read;
+		rtl_fw_write_t mac_mcu_write;
+		rtl_fw_read_t mac_mcu_read;
 		const struct firmware *fw;
 
 #define RTL_VER_SIZE		32
@@ -1009,7 +1017,7 @@ static int r8168dp_2_mdio_read(struct rtl8169_private *tp, int reg)
 	return value;
 }
 
-static void rtl_writephy(struct rtl8169_private *tp, int location, u32 val)
+static void rtl_writephy(struct rtl8169_private *tp, int location, int val)
 {
 	tp->mdio_ops.write(tp, location, val);
 }
@@ -2427,17 +2435,15 @@ static int rtl_check_firmware(struct rtl8169_private *tp, struct rtl_fw *rtl_fw)
 	return rc;
 }
 
-static void rtl_phy_write_fw(struct rtl8169_private *tp, struct rtl_fw *rtl_fw)
+static void rtl_fw_write_firmware(struct rtl8169_private *tp,
+				  struct rtl_fw *rtl_fw)
 {
 	struct rtl_fw_phy_action *pa = &rtl_fw->phy_action;
-	struct mdio_ops org, *ops = &tp->mdio_ops;
-	u32 predata, count;
+	rtl_fw_write_t fw_write = rtl_fw->phy_write;
+	rtl_fw_read_t fw_read = rtl_fw->phy_read;
+	int predata = 0, count = 0;
 	size_t index;
 
-	predata = count = 0;
-	org.write = ops->write;
-	org.read = ops->read;
-
 	for (index = 0; index < pa->size; ) {
 		u32 action = le32_to_cpu(pa->code[index]);
 		u32 data = action & 0x0000ffff;
@@ -2448,7 +2454,7 @@ static void rtl_phy_write_fw(struct rtl8169_private *tp, struct rtl_fw *rtl_fw)
 
 		switch(action & 0xf0000000) {
 		case PHY_READ:
-			predata = rtl_readphy(tp, regno);
+			predata = fw_read(tp, regno);
 			count++;
 			index++;
 			break;
@@ -2465,11 +2471,11 @@ static void rtl_phy_write_fw(struct rtl8169_private *tp, struct rtl_fw *rtl_fw)
 			break;
 		case PHY_MDIO_CHG:
 			if (data == 0) {
-				ops->write = org.write;
-				ops->read = org.read;
+				fw_write = rtl_fw->phy_write;
+				fw_read = rtl_fw->phy_read;
 			} else if (data == 1) {
-				ops->write = mac_mcu_write;
-				ops->read = mac_mcu_read;
+				fw_write = rtl_fw->mac_mcu_write;
+				fw_read = rtl_fw->mac_mcu_read;
 			}
 
 			index++;
@@ -2479,7 +2485,7 @@ static void rtl_phy_write_fw(struct rtl8169_private *tp, struct rtl_fw *rtl_fw)
 			index++;
 			break;
 		case PHY_WRITE:
-			rtl_writephy(tp, regno, data);
+			fw_write(tp, regno, data);
 			index++;
 			break;
 		case PHY_READCOUNT_EQ_SKIP:
@@ -2496,7 +2502,7 @@ static void rtl_phy_write_fw(struct rtl8169_private *tp, struct rtl_fw *rtl_fw)
 			index++;
 			break;
 		case PHY_WRITE_PREVIOUS:
-			rtl_writephy(tp, regno, predata);
+			fw_write(tp, regno, predata);
 			index++;
 			break;
 		case PHY_SKIPN:
@@ -2511,9 +2517,6 @@ static void rtl_phy_write_fw(struct rtl8169_private *tp, struct rtl_fw *rtl_fw)
 			BUG();
 		}
 	}
-
-	ops->write = org.write;
-	ops->read = org.read;
 }
 
 static void rtl_release_firmware(struct rtl8169_private *tp)
@@ -2527,9 +2530,9 @@ static void rtl_release_firmware(struct rtl8169_private *tp)
 
 static void rtl_apply_firmware(struct rtl8169_private *tp)
 {
-	/* TODO: release firmware once rtl_phy_write_fw signals failures. */
+	/* TODO: release firmware if rtl_fw_write_firmware signals failure. */
 	if (tp->rtl_fw)
-		rtl_phy_write_fw(tp, tp->rtl_fw);
+		rtl_fw_write_firmware(tp, tp->rtl_fw);
 }
 
 static void rtl_apply_firmware_cond(struct rtl8169_private *tp, u8 reg, u16 val)
@@ -4359,6 +4362,11 @@ static void rtl_request_firmware(struct rtl8169_private *tp)
 	if (!rtl_fw)
 		goto err_warn;
 
+	rtl_fw->phy_write = rtl_writephy;
+	rtl_fw->phy_read = rtl_readphy;
+	rtl_fw->mac_mcu_write = mac_mcu_write;
+	rtl_fw->mac_mcu_read = mac_mcu_read;
+
 	rc = request_firmware(&rtl_fw->fw, tp->fw_name, tp_to_dev(tp));
 	if (rc < 0)
 		goto err_free;
-- 
2.21.0


