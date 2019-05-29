Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 829802E4D1
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 20:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbfE2SwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 14:52:09 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40790 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbfE2SwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 14:52:09 -0400
Received: by mail-wm1-f68.google.com with SMTP id 15so2279464wmg.5
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 11:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=zIWh5H+i9VdhGd0Yg0fNP7Md3nJXz2y6skjOlIePbWQ=;
        b=Dv8hPthl/W4ofDDGjG8mmngy1CUF3x76LD6eIxnGC37xJe3+zRIk6ClWgMfZvkAZ9J
         aAUsOXCSI6T05ApvfJd7f3j6B6AMt0hxJVMAp7qxAGjGI94TOjz+13g4QWsP4LeBMrbv
         3k2cPz/S8/uvpDEUMda0kjMjJroqqWtPq6Vk/DB+NH75JxM9qBpuCHbWD1UbeBEQyVX5
         8jOYVWSSR6lgy5ZRDvN4ovehi5C71GhZAhZ9/uKCw33UDjV3jmcAgj5oDdRVgjPIlZGb
         Dzhh/GDl/pDO06mZh140KRRS2bHZXEsorRqLzVF1owvpNSFO6Spfwoa3tIvTAhDFmvS8
         KSdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=zIWh5H+i9VdhGd0Yg0fNP7Md3nJXz2y6skjOlIePbWQ=;
        b=KZhVI1mcX7+N8Er1h8GS8aNjLcicxFA00Bq6Xmev6ILda2Vvdwsm6bSshhAFwrt08z
         ATFjGO1Kh5oBUKdtWcErGRYvcLPI4GeA0rvOHg9svu/lzhWpA4JoZUBwlCpDygcGvPds
         kXnyFHfLFjZOI6U2HINYAiWT9f2rscXhuj/J/gfL+JfBjOG8P9d8AB0ooTwPg90RYwQ6
         6M4E9jYS/RoPt7Sawo3PIT2SRcrkjp9hQyF/Bqkh/PGtcN//pFlnKz1ZllQ0E+fMBRxY
         449h+XYEIk6zMjY4MTIGewhBx3pIH22xC8mTBnFMGlgEazUDTNxFodQ8DA+SG4TDaNVJ
         s4xA==
X-Gm-Message-State: APjAAAVcScYi/kB23ek0xUMLRlxTojcBG6hwTMMldUYwNF9na3crd+qf
        bPjdmLkItZljWhsPE/ADQRUPKEFb
X-Google-Smtp-Source: APXvYqzFSGuGv8w8AkXzRziuqnFsMNZ6BGiDIrpBuwSYajMWw3Axa5xra8xnIjKsIVCLtIK/5HBCsA==
X-Received: by 2002:a7b:c4d9:: with SMTP id g25mr7650096wmk.162.1559155927349;
        Wed, 29 May 2019 11:52:07 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:c13b:48f0:87ee:c916? (p200300EA8BF3BD00C13B48F087EEC916.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:c13b:48f0:87ee:c916])
        by smtp.googlemail.com with ESMTPSA id s14sm135966wmh.7.2019.05.29.11.52.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 11:52:06 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: enable WoL speed down on more chip versions
Message-ID: <19f0f196-0d7c-97a4-de21-b0754673c014@gmail.com>
Date:   Wed, 29 May 2019 20:52:03 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Call the pll power down function also for chip versions 02..06 and
13..15. The MAC can't be powered down on these chip versions, but at
least they benefit from the speed-down power-saving if WoL is enabled.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.c | 26 ++------------------------
 1 file changed, 2 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 9c849c83e..89aeadc1d 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -4105,7 +4105,7 @@ static void rtl_wol_suspend_quirk(struct rtl8169_private *tp)
 	}
 }
 
-static void r8168_pll_power_down(struct rtl8169_private *tp)
+static void rtl_pll_power_down(struct rtl8169_private *tp)
 {
 	if (r8168_check_dash(tp))
 		return;
@@ -4145,7 +4145,7 @@ static void r8168_pll_power_down(struct rtl8169_private *tp)
 	}
 }
 
-static void r8168_pll_power_up(struct rtl8169_private *tp)
+static void rtl_pll_power_up(struct rtl8169_private *tp)
 {
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_25 ... RTL_GIGA_MAC_VER_33:
@@ -4178,28 +4178,6 @@ static void r8168_pll_power_up(struct rtl8169_private *tp)
 	msleep(20);
 }
 
-static void rtl_pll_power_down(struct rtl8169_private *tp)
-{
-	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_02 ... RTL_GIGA_MAC_VER_06:
-	case RTL_GIGA_MAC_VER_13 ... RTL_GIGA_MAC_VER_15:
-		break;
-	default:
-		r8168_pll_power_down(tp);
-	}
-}
-
-static void rtl_pll_power_up(struct rtl8169_private *tp)
-{
-	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_02 ... RTL_GIGA_MAC_VER_06:
-	case RTL_GIGA_MAC_VER_13 ... RTL_GIGA_MAC_VER_15:
-		break;
-	default:
-		r8168_pll_power_up(tp);
-	}
-}
-
 static void rtl_init_rxcfg(struct rtl8169_private *tp)
 {
 	switch (tp->mac_version) {
-- 
2.21.0

