Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 897A51044C9
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 21:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727621AbfKTUJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 15:09:04 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51614 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727309AbfKTUJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 15:09:03 -0500
Received: by mail-wm1-f68.google.com with SMTP id g206so793988wme.1
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 12:09:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TyNR2V69LeRcW9tkDlmfo4/HJTThUKecm0q98ksRR1o=;
        b=M4ZwkrQDjII5+ots+bQguHQEDyejRR6Fd8bem5kRmSYRzsqJ8Q6h7c42Mg1425yFoO
         te86Qp8GFHEpClqEyCG5QyU387wU028HDTP9dMU05SmTpWmRAjl4C2X8/i+lBBvpHxwb
         QNXq0IKR4Wm3ZzGUQMNicMirgkF8NeA/cb3m/tTJ30P8v0EGKaIFTuOvZxAg2kWJGQ7V
         HqLdJWZ0xWSXF2vRN+JX/qGLssODDBus2WXN6Z1pjYlUd7tPgdYHvfTOnDdNPmFmYxUM
         PWe3Wz6sVH6cx5YH5cRBmjOK6LZOQYF707atRiz6hCpMzGH7Uo+tbJbFDEmgzWPNGJW3
         p1cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TyNR2V69LeRcW9tkDlmfo4/HJTThUKecm0q98ksRR1o=;
        b=SGrgT42QSCqqNV2wS0SjDtTbXyyZ0dOtTC242ibg4+R4jJuUg+heJDUgKaQYwKeWqJ
         HcCRLGhxmyFKBmzS7/huf/Am/LTqHFT6maZeRJ0OxBorKgVdRVRRehit+fV3rADv+64m
         yEEeJx9kO1K0utQ7KpHOUi6SZQUfG8s89HPTH0vADuNdcyEYgN0QoOSscOh1QqyKPcgx
         MAGexx2ubIKzP+e/X34b+0AMsl1HZ3Mu9GicYJxHFbrB3mvM87fuoh0YbMax1POEvCLH
         JSzCQWUYTEJ448AYtXQgyEyr7IKgO3vazVc7fs18BKGaDZI0BdTJrhwMWSYt7Gu02UUG
         QZ6A==
X-Gm-Message-State: APjAAAXpESlZS+auuxLdeYcTz4leyOfggs/M1U/k3LFKg2b4k5n1Q2IV
        1pcLe/OndUDQuAQ80YjGjtbLVJyn
X-Google-Smtp-Source: APXvYqzep67XgA3unXmXggUqOUOTDW540rKd3sMBMXhVcK6k6pXdfg/B03wfwMjEQ2h1VE5LyBkqQQ==
X-Received: by 2002:a7b:c255:: with SMTP id b21mr5838971wmj.39.1574280540913;
        Wed, 20 Nov 2019 12:09:00 -0800 (PST)
Received: from ?IPv6:2003:ea:8f2d:7d00:1b5:77c:1d90:d2c6? (p200300EA8F2D7D0001B5077C1D90D2C6.dip0.t-ipconnect.de. [2003:ea:8f2d:7d00:1b5:77c:1d90:d2c6])
        by smtp.googlemail.com with ESMTPSA id a11sm377496wmh.40.2019.11.20.12.09.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Nov 2019 12:09:00 -0800 (PST)
Subject: [PATCH net-next 2/3] r8169: use macro FIELD_SIZEOF in definition of
 FW_OPCODE_SIZE
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <6bb940ea-f479-f264-bc12-b4be52293dd6@gmail.com>
Message-ID: <f1e304a7-d8e1-c4c9-9c0a-d17ffcfae603@gmail.com>
Date:   Wed, 20 Nov 2019 21:07:41 +0100
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

Using macro FIELD_SIZEOF makes this define easier understandable.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_firmware.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_firmware.c b/drivers/net/ethernet/realtek/r8169_firmware.c
index 522415084..927bb46b3 100644
--- a/drivers/net/ethernet/realtek/r8169_firmware.c
+++ b/drivers/net/ethernet/realtek/r8169_firmware.c
@@ -37,7 +37,7 @@ struct fw_info {
 	u8	chksum;
 } __packed;
 
-#define FW_OPCODE_SIZE	sizeof(typeof(*((struct rtl_fw_phy_action *)0)->code))
+#define FW_OPCODE_SIZE FIELD_SIZEOF(struct rtl_fw_phy_action, code[0])
 
 static bool rtl_fw_format_ok(struct rtl_fw *rtl_fw)
 {
-- 
2.24.0


