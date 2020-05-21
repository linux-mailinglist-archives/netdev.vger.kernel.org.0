Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75AE1DD7DE
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 22:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729964AbgEUUDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 16:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728635AbgEUUDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 16:03:19 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17B3C061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 13:03:18 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id n18so7675271wmj.5
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 13:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=/B9nKp9yxMB4rwwtGaYX++NFL5U9MbC7wMyHn7ohCbA=;
        b=fhG+vY3L5eIaLNwdcWaN7hs4c/RJgGTMSzpAcFpHpf+n7UgfR6eIMy/da2+SVlg/WX
         qnkvDteSPNX4/c7uSBxgGh4O1Ec/prZDfgtKNughkqnKUQM+zWtkSzilzqZFwzEayWZ1
         NGWyp0sul6sjV0tCPFjctgUgYvCrz3vICY8KVB8LMQm10G0TyVRakHOgIxIDBiIVDygt
         zskp9Z2QbGHDjkKgqhX5b9s2I+vibkc7BMURzvO3psik2uom0capB2+oc/oCZ/4skKPd
         NkPpucaEUOYHEAEeH/tnly3ybIsIWbct1e8CYHnZEMIcC9NgS51j8gQe/qCHVeVYGR0g
         5VPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=/B9nKp9yxMB4rwwtGaYX++NFL5U9MbC7wMyHn7ohCbA=;
        b=PhKnA7QwoEfA4tDc9a6DBbiGyEx/8OwU8QGiGVG+qDpfk5QfUz0aRsfktSJ/oZVtQP
         PaFm0fVdanRz9nmhmUjAgzIIMeclV9MPkaJ5xkLlMQfmUPZIJiqPJpNoDsGaxnkWO/3R
         4DTTWt1ls81jE9TUoGVOQVjL3+aJtUFHCXi7/XMvB/sdFUSABvIQvL6iSMKZ4UH7x/is
         zeud1Z1xsX1TTuQHWhdo4CVeWDZm7Uy88Wq9DROJtlZE7YF5DI3DqkSyxviAVsZbbqbp
         h8dkY9PHBo+cEOSAqzMb1cOx3hOLQmjnXzj8vn9jOImlTgTLb19r1HdshkkjsF3LqGqR
         iiGQ==
X-Gm-Message-State: AOAM5318JoF8eNypSzXacrOVeQPysa+rzkfCtdYHEuDE3FYHj5DFnYyM
        7N5Xy0tiLv9GLdMB9i5cQfsYLf4m
X-Google-Smtp-Source: ABdhPJzfNEenlYm7dV9ywuJxzgibJoZt2S9SDmJy2hFeRgeJZuZg3tvlVKgS28+5g04VzdWxVbuAzw==
X-Received: by 2002:a05:600c:206:: with SMTP id 6mr10155961wmi.170.1590091397202;
        Thu, 21 May 2020 13:03:17 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:846b:541e:76f2:f3d? (p200300ea8f285200846b541e76f20f3d.dip0.t-ipconnect.de. [2003:ea:8f28:5200:846b:541e:76f2:f3d])
        by smtp.googlemail.com with ESMTPSA id y207sm8320028wmd.7.2020.05.21.13.03.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2020 13:03:16 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] r8169: fix OCP access on RTL8117
Message-ID: <0cf2b89e-b2f5-cc94-8257-5b99a177818f@gmail.com>
Date:   Thu, 21 May 2020 22:03:08 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to r8168 vendor driver DASHv3 chips like RTL8168fp/RTL8117
need a special addressing for OCP access.
Fix is compile-tested only due to missing test hardware.

Fixes: 1287723aa139 ("r8169: add support for RTL8117")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
- applies on net-next with a bit of fuzz
---
 drivers/net/ethernet/realtek/r8169_main.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 78e15cc00..c51b48dc3 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1050,6 +1050,13 @@ static u16 rtl_ephy_read(struct rtl8169_private *tp, int reg_addr)
 		RTL_R32(tp, EPHYAR) & EPHYAR_DATA_MASK : ~0;
 }
 
+static void r8168fp_adjust_ocp_cmd(struct rtl8169_private *tp, u32 *cmd, int type)
+{
+	/* based on RTL8168FP_OOBMAC_BASE in vendor driver */
+	if (tp->mac_version == RTL_GIGA_MAC_VER_52 && type == ERIAR_OOB)
+		*cmd |= 0x7f0 << 18;
+}
+
 DECLARE_RTL_COND(rtl_eriar_cond)
 {
 	return RTL_R32(tp, ERIAR) & ERIAR_FLAG;
@@ -1058,9 +1065,12 @@ DECLARE_RTL_COND(rtl_eriar_cond)
 static void _rtl_eri_write(struct rtl8169_private *tp, int addr, u32 mask,
 			   u32 val, int type)
 {
+	u32 cmd = ERIAR_WRITE_CMD | type | mask | addr;
+
 	BUG_ON((addr & 3) || (mask == 0));
 	RTL_W32(tp, ERIDR, val);
-	RTL_W32(tp, ERIAR, ERIAR_WRITE_CMD | type | mask | addr);
+	r8168fp_adjust_ocp_cmd(tp, &cmd, type);
+	RTL_W32(tp, ERIAR, cmd);
 
 	rtl_udelay_loop_wait_low(tp, &rtl_eriar_cond, 100, 100);
 }
@@ -1073,7 +1083,10 @@ static void rtl_eri_write(struct rtl8169_private *tp, int addr, u32 mask,
 
 static u32 _rtl_eri_read(struct rtl8169_private *tp, int addr, int type)
 {
-	RTL_W32(tp, ERIAR, ERIAR_READ_CMD | type | ERIAR_MASK_1111 | addr);
+	u32 cmd = ERIAR_READ_CMD | type | ERIAR_MASK_1111 | addr;
+
+	r8168fp_adjust_ocp_cmd(tp, &cmd, type);
+	RTL_W32(tp, ERIAR, cmd);
 
 	return rtl_udelay_loop_wait_high(tp, &rtl_eriar_cond, 100, 100) ?
 		RTL_R32(tp, ERIDR) : ~0;
-- 
2.26.2

