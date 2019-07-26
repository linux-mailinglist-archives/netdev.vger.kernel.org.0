Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B90C771CE
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 21:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388351AbfGZTFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 15:05:13 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44539 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387743AbfGZTFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 15:05:13 -0400
Received: by mail-wr1-f65.google.com with SMTP id p17so55429844wrf.11
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 12:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=OU+xI+UC2+jhskW0aNJzaD9odUC1cGBoiqXoFh7kqho=;
        b=duXIShv0BePiUvertcoqsv6gkDctw0/RSb9VpcTQj0I4eHAc5ebYi+WJrw6J0o7nzp
         26fJxjV9fM/uui8MTW2UOK2T0O7i6SneE394NuPxFOk8WX+zFKtbCHVadJJcBoJEjXtV
         uz80LnLpbrKN5nmdtAkzUWWkDoZcX2SkaYm645UHcKuqUozOsKOVIqlLYE1VCgOoBsok
         lOP9daRe6xnfMAEOECkphx2KeLKJM3BDMl2NWr4+SHxinDwL4eTafjfIqUbq0Kk/zMMG
         XVC0r2Iniu2FW9noInY9WNSZMc6G11W6ZxM50o8x2JfX7U2Q38CPok+R4k3vKjek+s/D
         4Vvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=OU+xI+UC2+jhskW0aNJzaD9odUC1cGBoiqXoFh7kqho=;
        b=UzNGjRvBOyqZrHPVvwRpiBQFevwS5xwJmVPpzWO5JtWkTYqvuUQpThdl8TOAbL0GHP
         Lo5xSNVOwuUhfZAY2GhcL91f9OKl7DDqerUvnxADPItG5a4QIp/SIyYRYWri45vqUF+h
         7UWtu8StZzHLsRi1PQf6EDfnbO/yAL8J/eNwRwrtfJzZiJL0sB/7PXyjOc8EKfmZbUw8
         dAptiyPzgP1ZBwDxGVbySvfL1V+TNTP092bJctzZ//UAfaxv6rcTsMGlhmz7NTlELja3
         3GgQ82hLeSDEG2NwkvPEGf2m7PTjMhs/xu5Ab34FcKsV011DcAlPie7UWnDyVD9reiz2
         w78Q==
X-Gm-Message-State: APjAAAWo2k6ZSYwpZOreli5uLPjLMKitlmZisvLViZl8Q42jd6ky/gjA
        a4uDE/PBSo7qGYXT/lRTo6GtAqRN
X-Google-Smtp-Source: APXvYqyEr2cb8SoxXQxj0DCmVElQuck3Qa+QntXQihR6peOx+nF/JOjsxLUJp9lp5Oi2cUVwpqm3FQ==
X-Received: by 2002:adf:f888:: with SMTP id u8mr12078381wrp.238.1564167910593;
        Fri, 26 Jul 2019 12:05:10 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f43:4200:55f1:e404:698f:358? (p200300EA8F43420055F1E404698F0358.dip0.t-ipconnect.de. [2003:ea:8f43:4200:55f1:e404:698f:358])
        by smtp.googlemail.com with ESMTPSA id i6sm47012754wrv.47.2019.07.26.12.05.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 12:05:09 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: align setting PME with vendor driver
Message-ID: <dfc84691-5643-63be-6338-55fe56df18b9@gmail.com>
Date:   Fri, 26 Jul 2019 20:56:20 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Align setting PME with the vendor driver. PMEnable is writable on
RTL8169 only, on later chip versions it's read-only. PME_SIGNAL is
used on chip versions from RTL8168evl with the exception of the
RTL8168f family.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index e1e1c89fb..5c337234b 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1414,18 +1414,22 @@ static void __rtl8169_set_wol(struct rtl8169_private *tp, u32 wolopts)
 	}
 
 	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_02 ... RTL_GIGA_MAC_VER_17:
+	case RTL_GIGA_MAC_VER_02 ... RTL_GIGA_MAC_VER_06:
 		options = RTL_R8(tp, Config1) & ~PMEnable;
 		if (wolopts)
 			options |= PMEnable;
 		RTL_W8(tp, Config1, options);
 		break;
-	default:
+	case RTL_GIGA_MAC_VER_34:
+	case RTL_GIGA_MAC_VER_37:
+	case RTL_GIGA_MAC_VER_39 ... RTL_GIGA_MAC_VER_51:
 		options = RTL_R8(tp, Config2) & ~PME_SIGNAL;
 		if (wolopts)
 			options |= PME_SIGNAL;
 		RTL_W8(tp, Config2, options);
 		break;
+	default:
+		break;
 	}
 
 	rtl_lock_config_regs(tp);
-- 
2.22.0

