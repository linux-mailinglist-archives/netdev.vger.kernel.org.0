Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85CB03CF4FD
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 09:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243055AbhGTGVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 02:21:15 -0400
Received: from m12-14.163.com ([220.181.12.14]:60175 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243192AbhGTGUb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 02:20:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=EFHAEyeznjaRByha1I
        PeNQQ59dwCgkZn4Fm5w0k6liM=; b=AbFQ/rGcALzxH/YA8QEpkHnUt+e489Dd9V
        82z8VcpZUFZlNK1PTEfeulp+0/ebdZcefmwTfZUMcqaYHPgpLzYLAmxefgE7p+B8
        ebX1Y9hdw6oS8exjl26pazPxUwHc7gzq2bQiHdg0jhUv0TzuIIpWWH0NxU8tTfox
        K+oj5d5Ec=
Received: from wengjianfeng.ccdomain.com (unknown [218.17.89.92])
        by smtp10 (Coremail) with SMTP id DsCowAAnOcOSdPZgzix+Bw--.36571S2;
        Tue, 20 Jul 2021 15:00:36 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     Jes.Sorensen@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH] rtl8xxxu: remove unnecessary labels
Date:   Tue, 20 Jul 2021 15:00:40 +0800
Message-Id: <20210720070040.20840-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: DsCowAAnOcOSdPZgzix+Bw--.36571S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7uw4kuFW8WF43Gw48XrWkZwb_yoW8AF4Upr
        ZrC3yYkr1rJr1IqFW7J3WqvF1fu3WSyr97WFZrtw1Sqan3Zrn5WF1q9r9Yyr40gFykJFya
        qrWDtrsrGa13KrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07bjc_-UUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiERTVsV7+4Gp4+AAAsL
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

Simplify the code by removing unnecessary labels and returning directly.

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c
index 4f93f88..3fd14e6 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c
@@ -256,10 +256,8 @@ static int rtl8723a_emu_to_active(struct rtl8xxxu_priv *priv)
 		udelay(10);
 	}
 
-	if (!count) {
-		ret = -EBUSY;
-		goto exit;
-	}
+	if (!count)
+		return -EBUSY;
 
 	/* We should be able to optimize the following three entries into one */
 
@@ -292,10 +290,8 @@ static int rtl8723a_emu_to_active(struct rtl8xxxu_priv *priv)
 		udelay(10);
 	}
 
-	if (!count) {
-		ret = -EBUSY;
-		goto exit;
-	}
+	if (!count)
+		return -EBUSY;
 
 	/* 0x4C[23] = 0x4E[7] = 1, switch DPDT_SEL_P output from WL BB */
 	/*
@@ -307,7 +303,6 @@ static int rtl8723a_emu_to_active(struct rtl8xxxu_priv *priv)
 	val8 &= ~LEDCFG2_DPDT_SELECT;
 	rtl8xxxu_write8(priv, REG_LEDCFG2, val8);
 
-exit:
 	return ret;
 }
 
@@ -327,7 +322,7 @@ static int rtl8723au_power_on(struct rtl8xxxu_priv *priv)
 
 	ret = rtl8723a_emu_to_active(priv);
 	if (ret)
-		goto exit;
+		return ret;
 
 	/*
 	 * 0x0004[19] = 1, reset 8051
@@ -353,7 +348,7 @@ static int rtl8723au_power_on(struct rtl8xxxu_priv *priv)
 	val32 &= ~(BIT(28) | BIT(29) | BIT(30));
 	val32 |= (0x06 << 28);
 	rtl8xxxu_write32(priv, REG_EFUSE_CTRL, val32);
-exit:
+
 	return ret;
 }
 
-- 
1.9.1

