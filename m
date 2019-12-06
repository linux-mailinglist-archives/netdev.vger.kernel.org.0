Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD09F11594C
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 23:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbfLFWYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 17:24:30 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43414 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbfLFWY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 17:24:29 -0500
Received: by mail-wr1-f66.google.com with SMTP id d16so9382266wre.10
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 14:24:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=0jUQ1r9hCZRsvTJwRe5izn6hoBkUNR1J5PxY3KvzvxU=;
        b=m7/9r9q34Mxcye6Oat4yxVZMAhfbwkTmMwteiWCuAPGkFRXuLFz3mtENDPfXEk1gs9
         beOHhHi/dPorh0a9uT+9ldUiMm6KJwCNiLG6v5nQsgAWciVlh+XnQMPlkl+SJ8WGs7BA
         ITgPBPCrUys84T+x493CSgymSPJOmixgPjGEKMFyE6oHRG9HWnLLJMDtic4jjtsH4xb6
         oq/59qBPo3xMmGa3qjBzZ+Vx/3illJMiHiUNnK7cc0DLqlqd+lsokyT8QJmLI7eL1X8u
         e2Irb5HkQr97BH7M73+CgKryeDw3Pl+8VCLZm1PVk2gwv7FkVX899Npdjn7Xs9WsC/Dx
         Ha3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=0jUQ1r9hCZRsvTJwRe5izn6hoBkUNR1J5PxY3KvzvxU=;
        b=s6Rm6TGIX16Wuk27NOKO4r4t9kdKv8OTAr6lCtmSBs2GC66lgXUBoQkCNOwgL6cqym
         AQkNcX2LJKTnNK9ATdmge2NZERvwvFjG2xZ66I/e3SltfhS2hHLeUEQt3wbr3H/4FmqU
         LwQIaHJKiqQuegJmEg+ho01al2K9+GkvbcvPWQNz143zJvsJ7gv72saGGtb9fPslwK7Y
         XYZq3bxHxXEeLT54dBx9HdzRhRp9SaPnygfz7MQmgMK/v9THzV1sB2I7fNtSllanoxYo
         WbFAmM51TU5Vgo6y2z+IOEGSrDAK85nm/5CtOqbaXkAJ1gxxuHwDwLsHinjruvo2+KqP
         CcWg==
X-Gm-Message-State: APjAAAXgkxH+KXXM2Dhgjvtw3q3MLAAjwaa59h3IzUc5zkNHYRgyNUBI
        GNc5VRCqGuy9Y3ryxCxtmpGFJjPD
X-Google-Smtp-Source: APXvYqwiMS4FZNVwzGIlrCoX/vSn59OtdhFF+/38oNVdf30vVg9ojfQACeCio3vwW6OZroJe28QLyQ==
X-Received: by 2002:adf:e2cc:: with SMTP id d12mr17087903wrj.168.1575671067432;
        Fri, 06 Dec 2019 14:24:27 -0800 (PST)
Received: from ?IPv6:2003:ea:8f4a:6300:386f:a543:2f50:333c? (p200300EA8F4A6300386FA5432F50333C.dip0.t-ipconnect.de. [2003:ea:8f4a:6300:386f:a543:2f50:333c])
        by smtp.googlemail.com with ESMTPSA id c4sm4817465wml.7.2019.12.06.14.24.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Dec 2019 14:24:26 -0800 (PST)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] r8169: fix rtl_hw_jumbo_disable for RTL8168evl
Message-ID: <8aa55fa1-5ba6-2f65-e651-463fe3bed303@gmail.com>
Date:   Fri, 6 Dec 2019 22:55:00 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In referenced fix we removed the RTL8168e-specific jumbo config for
RTL8168evl in rtl_hw_jumbo_enable(). We have to do the same in
rtl_hw_jumbo_disable().

Fixes: c07fd3caadc3 ("r8169: fix jumbo configuration for RTL8168evl")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 38d212686..46a492229 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3896,7 +3896,7 @@ static void rtl_hw_jumbo_disable(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_27 ... RTL_GIGA_MAC_VER_28:
 		r8168dp_hw_jumbo_disable(tp);
 		break;
-	case RTL_GIGA_MAC_VER_31 ... RTL_GIGA_MAC_VER_34:
+	case RTL_GIGA_MAC_VER_31 ... RTL_GIGA_MAC_VER_33:
 		r8168e_hw_jumbo_disable(tp);
 		break;
 	default:
-- 
2.24.0

