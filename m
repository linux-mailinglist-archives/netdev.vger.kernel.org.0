Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB0D3172A4
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 22:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbhBJVqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 16:46:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232097AbhBJVqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 16:46:40 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2535FC061574
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 13:46:00 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id m1so3250575wml.2
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 13:45:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=DB1ccmNx8RxiJqECNlDPRnPi9NNbyDBXO5Xul4TVInU=;
        b=r9s0a5YPAOLL2A15MsjeR5tn6UwCLJLxfklUyuIViSp7Is4OJaNp5+1KUxwy2TiEYE
         hFyTNwX1Ruo04ur4E/m0eqPvUnSJgf2UAZ7Z5GrzBlEXHokritcG61/78bypif+ZxQ0M
         TuFo3pfDWiV/KjEbb0GGKV4Zw7XFCDDeaXjJdaYMjce//vrAr2UC3f9STDx60skLvIqD
         k4G0WT8oVhFknIY6eJ27dv/lIqC8b2wG9HFHHuPvyqeVosi/ftRo7+awxSLRTQO9os26
         EtQ9R7Z8wa5xej0eMJlZAg2EGvhXBh91B/FQvweqXM1oCV1QikJXBUghdjichK7iXdve
         y1Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=DB1ccmNx8RxiJqECNlDPRnPi9NNbyDBXO5Xul4TVInU=;
        b=hEX0qisk3iqvVUd2IJuU7Y+bwrCxr2fuYj2m0b++0fRC9d6bf+or0xAp35y31yTEHH
         x6MZBIQ12whDRHSsZLezltUwPHamdsjqTOsbuYLdN+dDb0tmlay3RH+l0j3Kivkje3pe
         6OODKWauzbc1sYW6b0/q8/oEGcKLOMWFcxz7wtbdPE928gZllzRE7t7sWTVqDUJD0U+O
         yjQZzW5ifFKg0tMz/3EBlo6IKQTcxOkMPbGpF6eqtEet8ksth1ZGXyy9uIP5CNbmpoUr
         ToDYZ4WwxDuh9gAk3IcdgSZbgszWROFoxLvAxQ8fS1KpUMdcYCyFvPU5tBddk02CTPHP
         4arA==
X-Gm-Message-State: AOAM531Do0Pnl5U3NEiGu64i0a0f1gz2B+r+r5w3QrEzuqnoUh0Y6xil
        iWWetZE9YIpiQTtrOTb+tSVnfGyympm/eQ==
X-Google-Smtp-Source: ABdhPJwnCt/i1pOvNUtHwsiNupx7Vfeol6ICQA6q9GInkd4sUKxe8BNiyiBONlWD5quxB4/HJtHqRA==
X-Received: by 2002:a05:600c:28d3:: with SMTP id h19mr1054495wmd.147.1612993558431;
        Wed, 10 Feb 2021 13:45:58 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:b0ff:e539:9460:c978? (p200300ea8f1fad00b0ffe5399460c978.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:b0ff:e539:9460:c978])
        by smtp.googlemail.com with ESMTPSA id n5sm4124776wmq.7.2021.02.10.13.45.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 13:45:57 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next] r8169: disable detection of bogus xid's 308/388
Message-ID: <86862b9d-29ec-de71-889d-8ca5bba66892@gmail.com>
Date:   Wed, 10 Feb 2021 22:45:51 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several years ago these two entries have been added, but it's not clear
why. There's no trace that there has ever been such a chip version, and
not even the r8101 vendor driver knows these id's. So let's disable
detection, and if nobody complains remove them completely later.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index bc588cde8..de439db75 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2037,9 +2037,12 @@ static enum mac_version rtl8169_get_mac_version(u16 xid, bool gmii)
 		{ 0x7c8, 0x348,	RTL_GIGA_MAC_VER_09 },
 		{ 0x7c8, 0x248,	RTL_GIGA_MAC_VER_09 },
 		{ 0x7c8, 0x340,	RTL_GIGA_MAC_VER_16 },
-		/* FIXME: where did these entries come from ? -- FR */
-		{ 0xfc8, 0x388,	RTL_GIGA_MAC_VER_13 },
-		{ 0xfc8, 0x308,	RTL_GIGA_MAC_VER_13 },
+		/* FIXME: where did these entries come from ? -- FR
+		 * Not even r8101 vendor driver knows these id's,
+		 * so let's disable detection for now. -- HK
+		 * { 0xfc8, 0x388,	RTL_GIGA_MAC_VER_13 },
+		 * { 0xfc8, 0x308,	RTL_GIGA_MAC_VER_13 },
+		 */
 
 		/* 8110 family. */
 		{ 0xfc8, 0x980,	RTL_GIGA_MAC_VER_06 },
-- 
2.30.1

