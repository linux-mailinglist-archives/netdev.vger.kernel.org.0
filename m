Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C02DE31440
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 19:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfEaRzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 13:55:18 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38591 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfEaRzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 13:55:18 -0400
Received: by mail-wm1-f67.google.com with SMTP id t5so6449138wmh.3
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 10:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uj0xVnHY7eHNXDAEIo63qis9rw82OG5cPB2RBQ+fnE4=;
        b=J4MFrX8thIxuXCfNa42K+Q5yKXPPr0ALGHvqlI8TXzmbqOwiYivEwslVy6IX5L3BMe
         3D2TuYAdQCVco3v8Q1lCDnDBJZ5peJf30CkycTYQDHN4EEYi+IIz8vJQ6yHUwqWCl253
         RLu3rySetbx7edmrql3fl9/mhUGj9ZWmBGopO9Tb/ueH5mYHh59yFUprmE8UpL/YJ8+l
         w8uRMAuoDYM49N+LMDS58Ekj/v1TVlzBO3bwfiWuoZZTU72oYW6WdRnz83LvTe1bnrh1
         xn7l6AIswo8DOXFZg58oVLMEN9YKQnuU6R0QQZeRyXoYoPujtG44kLLvYnQPx5oZTdxl
         IOXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uj0xVnHY7eHNXDAEIo63qis9rw82OG5cPB2RBQ+fnE4=;
        b=iqxn2M8txxXlpYd6LzDlLzoIqRNM0CpTMoJkDSiATX+ZF/izoX+bOjgksIdcSPNPxf
         0SYF6t3kwyPYvYW19dC34xq7iOs6wsUjzFt5FBuh9CmF2LPCoE1ydwWKS+EkdwjidsT5
         TqF3knVUdrLAeGTcMiJgrhXdndJOLwhWNa9XvWyC+WMjpaSsSyUTBrnZU0iOpSr+wZYK
         nE+kFCehV2i9Yt28bY8c4PEyTZcRiu8tYevy19TXxCStjjeFLkoX1fajNvJCGDYxQtSS
         cHDycp8H7EPDSsmCQjNwKUItwGrF8siNX8ZL22hPC16vqXuocPt1SET2x8mjZhSzP/WZ
         N7xQ==
X-Gm-Message-State: APjAAAWKR3wI4WrSSiaUtOdsMj58WXMseAdQy++Xvok9hACsFrq8SEL0
        NAL28LZzhOFaDpUA7/4cH4qhbaPK
X-Google-Smtp-Source: APXvYqyf2uFQ6PBhk4RI1TuKvUjbKTVsQrW8tVTsOrpY3juURtPTvDH0X7jFL570DCxk1RA1ADluyQ==
X-Received: by 2002:a1c:f116:: with SMTP id p22mr6410806wmh.70.1559325316247;
        Fri, 31 May 2019 10:55:16 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:2026:7a0b:4d8d:d1ce? (p200300EA8BF3BD0020267A0B4D8DD1CE.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:2026:7a0b:4d8d:d1ce])
        by smtp.googlemail.com with ESMTPSA id 32sm17372588wra.35.2019.05.31.10.55.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 10:55:15 -0700 (PDT)
Subject: [PATCH net-next 1/3] r8169: remove struct mdio_ops
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1e17bf2f-93a9-03ff-7101-7f680665f4a7@gmail.com>
Message-ID: <08c49d19-2c3b-1c1c-c98d-4aa4e7f5af71@gmail.com>
Date:   Fri, 31 May 2019 19:53:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1e17bf2f-93a9-03ff-7101-7f680665f4a7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mdio_ops are used in just one place, so we can simplify the code
and avoid the penalty of indirect calls in times of retpoline.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.c | 59 ++++++++++++----------------
 1 file changed, 26 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 13620bca1..3472eef75 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -655,11 +655,6 @@ struct rtl8169_private {
 	const struct rtl_coalesce_info *coalesce_info;
 	struct clk *clk;
 
-	struct mdio_ops {
-		void (*write)(struct rtl8169_private *, int, int);
-		int (*read)(struct rtl8169_private *, int);
-	} mdio_ops;
-
 	struct jumbo_ops {
 		void (*enable)(struct rtl8169_private *);
 		void (*disable)(struct rtl8169_private *);
@@ -1019,12 +1014,36 @@ static int r8168dp_2_mdio_read(struct rtl8169_private *tp, int reg)
 
 static void rtl_writephy(struct rtl8169_private *tp, int location, int val)
 {
-	tp->mdio_ops.write(tp, location, val);
+	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_27:
+		r8168dp_1_mdio_write(tp, location, val);
+		break;
+	case RTL_GIGA_MAC_VER_28:
+	case RTL_GIGA_MAC_VER_31:
+		r8168dp_2_mdio_write(tp, location, val);
+		break;
+	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_51:
+		r8168g_mdio_write(tp, location, val);
+		break;
+	default:
+		r8169_mdio_write(tp, location, val);
+		break;
+	}
 }
 
 static int rtl_readphy(struct rtl8169_private *tp, int location)
 {
-	return tp->mdio_ops.read(tp, location);
+	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_27:
+		return r8168dp_1_mdio_read(tp, location);
+	case RTL_GIGA_MAC_VER_28:
+	case RTL_GIGA_MAC_VER_31:
+		return r8168dp_2_mdio_read(tp, location);
+	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_51:
+		return r8168g_mdio_read(tp, location);
+	default:
+		return r8169_mdio_read(tp, location);
+	}
 }
 
 static void rtl_patchphy(struct rtl8169_private *tp, int reg_addr, int value)
@@ -4059,31 +4078,6 @@ static int rtl8169_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	return phy_mii_ioctl(tp->phydev, ifr, cmd);
 }
 
-static void rtl_init_mdio_ops(struct rtl8169_private *tp)
-{
-	struct mdio_ops *ops = &tp->mdio_ops;
-
-	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_27:
-		ops->write	= r8168dp_1_mdio_write;
-		ops->read	= r8168dp_1_mdio_read;
-		break;
-	case RTL_GIGA_MAC_VER_28:
-	case RTL_GIGA_MAC_VER_31:
-		ops->write	= r8168dp_2_mdio_write;
-		ops->read	= r8168dp_2_mdio_read;
-		break;
-	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_51:
-		ops->write	= r8168g_mdio_write;
-		ops->read	= r8168g_mdio_read;
-		break;
-	default:
-		ops->write	= r8169_mdio_write;
-		ops->read	= r8169_mdio_read;
-		break;
-	}
-}
-
 static void rtl_wol_suspend_quirk(struct rtl8169_private *tp)
 {
 	switch (tp->mac_version) {
@@ -7136,7 +7130,6 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pci_set_master(pdev);
 
-	rtl_init_mdio_ops(tp);
 	rtl_init_jumbo_ops(tp);
 
 	chipset = tp->mac_version;
-- 
2.21.0


