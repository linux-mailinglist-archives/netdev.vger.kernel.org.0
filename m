Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315FC302877
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 18:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729603AbhAYRJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 12:09:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728759AbhAYQ4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 11:56:07 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15924C06174A
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 08:55:26 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id a1so13563953wrq.6
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 08:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=GJMVjIhhFJ4r/l27K2hWTLnP+dOq5YGNVehTsffsC6A=;
        b=nV+u0HGcISh7g+c8D/m8O2TTL4WxlvSVULmOJYto4z3kcGgP7Nr8tDvNXh+k0HYmBk
         5MBhov9lHSVdUN1aT0JL32at4FLP/O0QsKeDxlj2wpPTdJPuWhXMe+i1febRNhKzePSd
         wnaAldqvtFKenw81CxJ3+MBAreuvZPx1M95Cud4S5hhTyetP6KX7/nn0GfujB9FJfl4o
         sewRPK/DA1sJmZDGNQ0ikbvPBcy7rlzH/UwbQTyAzubZABubD6TE9BxuV2BkzzIMGVWU
         HpxNA/R0ZSIZIIoJdk257+8edm8PCend0W4lSqh97Gv7ZOuB0Ta6Aj4e38t9R4t4uSmv
         2y3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=GJMVjIhhFJ4r/l27K2hWTLnP+dOq5YGNVehTsffsC6A=;
        b=MMMiuONXCvgw7TeNB9yUh7go6QkT4fRTaHFZprscWLHFJg8RIqQX3abLhZRu7saQYJ
         WNnTKbxddVdWaY4BxRwJrIjCEOsbCuupXrLk4gTXa4KpUZ8jt87jfM4fqv89/BaTmZ4N
         9xlAj9emBxBG5tkTh4QSs2mdZ7Cx7D5y3+u4KGEnAObdlW7A+qtzemdIZ6LHkOjv6U6g
         6iGvsWdchr54wc83VdOtlfDzXZLbYqOIUqCLnPIMSJJYOHohyXeAIL5qrWX03+2rJ4fd
         lzZNSdBVjf34Yx6e8SAcS+MKUpBarXkL+64Dn+D43Fm9/7ABVurujyP4SpqIKLWpD9ht
         +vtQ==
X-Gm-Message-State: AOAM531kEGIhaJQxWA0pMrk4DlDgT9yNaaOv9uL++WJWxXu14ANQxhGV
        LhbPx79aTfw9rNjqryoksL/c3yB/yW8=
X-Google-Smtp-Source: ABdhPJzATyxMh7d9I9W6AVAY6u99VOhXemIJC0f85wihx+ONewmsmBsPNoLlJEi6V/afuGzOppCAjQ==
X-Received: by 2002:adf:e8c5:: with SMTP id k5mr2096688wrn.242.1611593724620;
        Mon, 25 Jan 2021 08:55:24 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:20b9:2450:6471:c6e0? (p200300ea8f06550020b924506471c6e0.dip0.t-ipconnect.de. [2003:ea:8f06:5500:20b9:2450:6471:c6e0])
        by smtp.googlemail.com with ESMTPSA id r1sm23596470wrl.95.2021.01.25.08.55.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 08:55:24 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next] r8169: remove not needed call to rtl_wol_enable_rx
 from rtl_shutdown
Message-ID: <34ce78e2-596c-e2ac-16aa-c550fa624c22@gmail.com>
Date:   Mon, 25 Jan 2021 17:55:12 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rtl_wol_enable_rx() is called via the following call chain if WoL
is enabled:
rtl8169_down()
-> rtl_prepare_power_down()
   -> rtl_wol_enable_rx()
Therefore we don't have to call this function here.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index fb67d8f79..475e6f01e 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4850,10 +4850,8 @@ static void rtl_shutdown(struct pci_dev *pdev)
 	rtl_rar_set(tp, tp->dev->perm_addr);
 
 	if (system_state == SYSTEM_POWER_OFF) {
-		if (tp->saved_wolopts) {
-			rtl_wol_enable_rx(tp);
+		if (tp->saved_wolopts)
 			rtl_wol_shutdown_quirk(tp);
-		}
 
 		pci_wake_from_d3(pdev, tp->saved_wolopts);
 		pci_set_power_state(pdev, PCI_D3hot);
-- 
2.30.0

