Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEEDB1BCDBD
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 22:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgD1U4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 16:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726291AbgD1U4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 16:56:07 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D17DC03C1AC
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 13:56:07 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id x25so287667wmc.0
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 13:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=q1YtzlgX6fiwU3GHH7MyTV9bOgsEU7dYRsUnZ+H+cQc=;
        b=hJVXCrFsn6TZ+f7071XKbl7V3m4Hzxe1WUhuIA3s7Bj6cDEuWRtCAKGmpicUSjiul2
         Acq6VJ20MDkQGEs22lGDN/cl0r1hRB3+CJFCoMmimf1SCJrZW7K1umyhchqDuC8jsHvO
         udZtnUoJCg4qU5gEYl+uFusSJwEIO1XoXSbN9gICBN3nQalxg+VbGKHPLXXkC/AdLca7
         gGCShmkg2M2mB/9410ymNHT2UbL/uCSFcBFROLEesKB32cHt+sl5/LRQJ1+cMRpjGjvn
         4xXpWNiol5L91HosapfWySJmmGwg1ADWrBPezaVAgqxpVVuL74UvrsrWYW674QE3l4Pt
         EjkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=q1YtzlgX6fiwU3GHH7MyTV9bOgsEU7dYRsUnZ+H+cQc=;
        b=rqgsxcg2aTS6zG4iwYPbYjGrINok06/R/OF6FYWm3uyT7FYPBa4x2YpBwyvP5H4ox2
         cCFIADitxpm3mGfvRdUFa0zn5PT9I7U4QmXbq2542bdAUrJhZ8XwNVn8iWiulA4oPf4s
         Ioqqb6BaFTgOFdBXAzibXgD4sVwmVHim77xENwCG8zQIh71GkDXYEE82BMSJQsVeOwYj
         e6qnPgApuUK6UacaEw1g1yiD5cBJBOX9ItvLR7LeSOE3S0d/n4sOOCsopu/CKL/uilBg
         zwSXBwxS0yLI4JuTHWz8pel400fn3RUAcW84qj2g7Rh1bT+BrZTdJJTR0Gdn6BOhR31F
         5NhQ==
X-Gm-Message-State: AGi0PuYPFN1SPDNjACq/TUOgLrCSBtSIkixmdynrX4EZl4aGtk+s6rIO
        ZQc/2Al7jSt+eYVrKIXsBCqredZg
X-Google-Smtp-Source: APiQypJ/Dy4gPt7GGoa8rlZTQHM814SbsFtdJwhkM7rCDCRlB0zdDjFCnV0b0zn+010gXhKWaw7V+w==
X-Received: by 2002:a1c:4c10:: with SMTP id z16mr6589809wmf.77.1588107366062;
        Tue, 28 Apr 2020 13:56:06 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f3a:4f00:1417:f780:dfa5:2ab4? (p200300EA8F3A4F001417F780DFA52AB4.dip0.t-ipconnect.de. [2003:ea:8f3a:4f00:1417:f780:dfa5:2ab4])
        by smtp.googlemail.com with ESMTPSA id u74sm4958630wmu.13.2020.04.28.13.56.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2020 13:56:05 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: improve max jumbo packet size definition
Message-ID: <5571405c-3b2a-8669-320d-daa21f4c279c@gmail.com>
Date:   Tue, 28 Apr 2020 22:54:12 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sync definition of max jumbo packet size with vendor driver and reserve
22 bytes for VLAN ethernet header plus checksum.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 68d525556..8966687aa 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -87,10 +87,10 @@
 #define RTL_R16(tp, reg)		readw(tp->mmio_addr + (reg))
 #define RTL_R32(tp, reg)		readl(tp->mmio_addr + (reg))
 
-#define JUMBO_4K	(4*1024 - ETH_HLEN - 2)
-#define JUMBO_6K	(6*1024 - ETH_HLEN - 2)
-#define JUMBO_7K	(7*1024 - ETH_HLEN - 2)
-#define JUMBO_9K	(9*1024 - ETH_HLEN - 2)
+#define JUMBO_4K	(4 * SZ_1K - VLAN_ETH_HLEN - ETH_FCS_LEN)
+#define JUMBO_6K	(6 * SZ_1K - VLAN_ETH_HLEN - ETH_FCS_LEN)
+#define JUMBO_7K	(7 * SZ_1K - VLAN_ETH_HLEN - ETH_FCS_LEN)
+#define JUMBO_9K	(9 * SZ_1K - VLAN_ETH_HLEN - ETH_FCS_LEN)
 
 static const struct {
 	const char *name;
-- 
2.26.2

