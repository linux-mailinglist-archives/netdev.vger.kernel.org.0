Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 761AF2EF280
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 13:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727697AbhAHMYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 07:24:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727227AbhAHMYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 07:24:39 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0C0C0612F5
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 04:24:23 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id g185so8255997wmf.3
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 04:24:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=OHXoOJSsJ8hDdk0tlgmUhHtjpiGBZ0sWHr1Xlz6qQs8=;
        b=L77Yk4HRrjTOP8SzucKCYLILnwV7060l9/KGMpMgKzG4/d7iDZ83nhLcrUpYGvc37S
         g5/5JL0+tVcJU+Fbr4kK4eF2I0U2e0Y4j1aZ+djAqmwLIzaiw4Mx+IOw1LQCIbzng6az
         IO7KoedE9BAYPCCuTX4y1bIHI/zpXYyKcdn79lTro7CnKQI75/0vR1Bj4WsHhjVZ7eFa
         or2KH8yj1P10TmyG1ZV3X6MuuKpVeeAeB+GhsnWx8L3COjp2rU5bsc6sUWg6O91nklsG
         m5htO6MVhsMajZkEvp7q0sGOKUGKp0Y23WDG3T3U3ya//xT3wkGR5fMQkzqGwwiK+m69
         JsRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=OHXoOJSsJ8hDdk0tlgmUhHtjpiGBZ0sWHr1Xlz6qQs8=;
        b=WRV4thzSQasIf8/7TJFe44NrSgnmUDYHOg6uZRzLx0xDTJHHvUz957id4CR9C6oYyv
         7zuXF4bjCj4UP2qu+XuQPHF6vu5F+580UEjgsYP60DGK+asAIgx9q2jBqEAC2DXl5wUj
         Yf3CRlsXqzBahXid7+38qvWCjyQlpPiKG5+isNI2w1OxuYh1vOPSEqroXm22tTvJv2m/
         9EvyoekdnCfA80f0hBs7OQ/65q9fN9gdZDDfysXtW4orhxXKIKj766/hzjPBNLmPXiUq
         H/lb2a/Nfy5x1JtaDjmAGHoYDKCGvHHYEtBMghVYsb+zwc6tFdVII687RoHRjt0iKRKd
         2c7Q==
X-Gm-Message-State: AOAM532NsROKZLnl32vG2bVOpc0tjRRmj4cMsRv8d0KxXmP31TOmct4A
        cAPE9AurcqoRebmV6HRxNNcb7OS5AF8=
X-Google-Smtp-Source: ABdhPJwYYNWrfRS7YXXVW4rQcnhXF/5VotEy/LfPYMhJ69vD+F2fOuwX/MhHnfk+CqBn41OFssxJ6w==
X-Received: by 2002:a7b:c35a:: with SMTP id l26mr2745581wmj.182.1610108662112;
        Fri, 08 Jan 2021 04:24:22 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:6dbb:aa76:4e1a:5cc4? (p200300ea8f0655006dbbaa764e1a5cc4.dip0.t-ipconnect.de. [2003:ea:8f06:5500:6dbb:aa76:4e1a:5cc4])
        by smtp.googlemail.com with ESMTPSA id b83sm11988770wmd.48.2021.01.08.04.24.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jan 2021 04:24:21 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next] r8169: deprecate support for RTL_GIGA_MAC_VER_27
Message-ID: <fb6ff074-a9c3-94ce-0636-52276d8604f2@gmail.com>
Date:   Fri, 8 Jan 2021 13:24:16 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RTL8168dp is ancient anyway, and I haven't seen any trace of its early
version 27 yet. This chip versions needs quite some special handling,
therefore it would facilitate driver maintenance if support for it
could be dropped. For now just disable detection of this chip version.
If nobody complains we can remove support for it in the near future.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index e72d8f3ae..f94965615 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1962,7 +1962,11 @@ static enum mac_version rtl8169_get_mac_version(u16 xid, bool gmii)
 		{ 0x7c8, 0x280,	RTL_GIGA_MAC_VER_26 },
 
 		/* 8168DP family. */
-		{ 0x7cf, 0x288,	RTL_GIGA_MAC_VER_27 },
+		/* It seems this early RTL8168dp version never made it to
+		 * the wild. Let's see whether somebody complains, if not
+		 * we'll remove support for this chip version completely.
+		 * { 0x7cf, 0x288,      RTL_GIGA_MAC_VER_27 },
+		 */
 		{ 0x7cf, 0x28a,	RTL_GIGA_MAC_VER_28 },
 		{ 0x7cf, 0x28b,	RTL_GIGA_MAC_VER_31 },
 
-- 
2.29.2

