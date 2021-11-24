Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D89545CE53
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 21:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237844AbhKXUsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 15:48:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235709AbhKXUsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 15:48:03 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE48C061574
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 12:44:53 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id c4so6615686wrd.9
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 12:44:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=jt+UnhoQIByLvmOOZvlG96D7Lxcd7N48I38ceCTYkPI=;
        b=cN36UP6b3k3yIYoFeCXCfN1obaPTmLlRDZeB22sugDTzMzfdVjZICsLD+hiJSLZdne
         oWwIXCJR7JLP4A65Ni4HN4menk1A3RQ+lN7FaXUBzm3vhhP7YZv046/BkgSrMxYMjzBE
         F5sgi3wVPHDe4WcYZGE3DZxtylwSpMgIE9s8HRLOY6o3e85Do2TzSVIj993Lo0NDVSBN
         s7lzzJKX7HG+3Xs6OIB3QEXwu2AzrBFHdn5zfQiP/7tdIhz8YMdN09b8FehN8PbuwuIZ
         XoArQ00f0BeXVstbkkVA5ROlp8oQkUH5vjFYgr/JouBBgmUWfC2s7hiVpPg7B6dzPQCH
         TPIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=jt+UnhoQIByLvmOOZvlG96D7Lxcd7N48I38ceCTYkPI=;
        b=DgNGBibF+zL7BG9BH/dBDugurWnuImlDCsEnqGpjBWjaRd1Mh0mH6Ymd81cLyS+88N
         GYEjq9Efa47NefRmwkQdk6HzWq9lUS4E9bCpBKh5LuAQQHNqg297H7PJoAeASkYB73yW
         yjDE4fpIqHRmyN1mGMZsK9eo1C9VFpH+To2Ag1M2iW3IDh2OPWteWyYtlvL5VYrGQ09C
         n36kem3BJhCDLoJIOWLUhZ+QGlhhHYHHsui3e5TKiqxhIrlsH1bEnQ24wb7z9tVbddAN
         zvPaM2K2p9Op/OtzrgditAsvcOXMIpsgVy9c7fwRwTJRLbvAt4OLAd2bqejF+v9ZNx5t
         KTQw==
X-Gm-Message-State: AOAM5306jhl70DnjF/7iT98VNtZZWIPByBs88SX5ra/SZDaCDZEMUKWx
        ZBJwpStgyXO8TTsq1siT5Ajh/3kQi84=
X-Google-Smtp-Source: ABdhPJxqcSxRwVCpWy0Rzo4pWpw7imB3vawwtsk1vy2UyN+QX6HRHQunr1E5EijN+RV1iecYaZ7mOQ==
X-Received: by 2002:adf:8296:: with SMTP id 22mr1491446wrc.581.1637786691960;
        Wed, 24 Nov 2021 12:44:51 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:9c1d:b348:90aa:36a5? (p200300ea8f1a0f009c1db34890aa36a5.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:9c1d:b348:90aa:36a5])
        by smtp.googlemail.com with ESMTPSA id p5sm862255wrd.13.2021.11.24.12.44.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Nov 2021 12:44:51 -0800 (PST)
Message-ID: <2cd3df01-5f8b-08dd-6def-3f31a3014bde@gmail.com>
Date:   Wed, 24 Nov 2021 21:44:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: disable detection of chip version 60
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <7708d13a-4a2b-090d-fadf-ecdd0fff5d2e@gmail.com>
Content-Language: en-US
In-Reply-To: <7708d13a-4a2b-090d-fadf-ecdd0fff5d2e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems only XID 609 made it to the mass market. Therefore let's
disable detection of the other RTL8125a XID's. If nobody complains
we can remove support for RTL_GIGA_MAC_VER_60 later.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index e9b560051..76a029860 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1969,8 +1969,11 @@ static enum mac_version rtl8169_get_mac_version(u16 xid, bool gmii)
 		{ 0x7cf, 0x641,	RTL_GIGA_MAC_VER_63 },
 
 		/* 8125A family. */
-		{ 0x7cf, 0x608,	RTL_GIGA_MAC_VER_60 },
-		{ 0x7c8, 0x608,	RTL_GIGA_MAC_VER_61 },
+		{ 0x7cf, 0x609,	RTL_GIGA_MAC_VER_61 },
+		/* It seems only XID 609 made it to the mass market.
+		 * { 0x7cf, 0x608,	RTL_GIGA_MAC_VER_60 },
+		 * { 0x7c8, 0x608,	RTL_GIGA_MAC_VER_61 },
+		 */
 
 		/* RTL8117 */
 		{ 0x7cf, 0x54b,	RTL_GIGA_MAC_VER_53 },
-- 
2.34.0

