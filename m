Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793221AF481
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 22:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbgDRUJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 16:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728287AbgDRUJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 16:09:58 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF690C061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 13:09:57 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id e26so6473799wmk.5
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 13:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bXU1GMC3crE6wZvmjHayWqOikz0CzzcRhHsydXn+bio=;
        b=E9GBF4fUYJ3c/BB3VufvxuLFj+y/R8yLkbi8M6by+S8NPbldYESraqVLI48rBp9tzE
         BsTERZiEfgc3PRNk5Q2XV3BEVQtrpVvr3j0aB4tE2fUyFS1fdZp6wEuxSDLC5L7zzeb4
         1GT0mwVJSYecPdfSuBfnqRALk6Jm+vI30N3rGIsBoaCdqUezc3Py/Ax9tAN3lrE5fb9l
         K0Ufc6ux2uQXJHXkn5pQlMYvn1CLsOjVt7iYwbkxZNTpci33GX0IdE+jwKoNTtS3QrBp
         KGr15ug9kICVs5ceN9k/KC7NvfJpD4QJH+Q07ofxmncoKxt//hQFcdoMgODT2bYzjFte
         FCeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bXU1GMC3crE6wZvmjHayWqOikz0CzzcRhHsydXn+bio=;
        b=aNHg9LUp8Ws9g3cFxH7qAKD0QjA2ZZwriv+ORrJdd02oytQUvsaBaBuCHF7GytjwDQ
         fTwgvfFjBHVhlEqrF/zjUe3cQvbFge6zqGEYdbq+crS08KMv2wvUaGCWjPpj9QCCr1XZ
         DbshhjUeqEeNJ58ikK+zTuAygJaZWtP1qWzFUhqsCtDvIBI5FMjoKq6NUcXBmDHJBewO
         /JEPVQwMppq46TiNVcyarwnZx4mbRa7rJt5fff9hChH2Tz5W5MikjhRjkr3WYjiPVypE
         uD3TPU39RWaJBhgZ9F4LPPfUYJnEy+VzJ6yHCcYAIoYZ2UfIIDbzpV176ZllH22Z9ZMm
         TT0w==
X-Gm-Message-State: AGi0PuY5dn07eN4DE0BL56uPN+9YEWECa8QqH8SxUrGc5rlY5iP80w9H
        gOQ6XvqMYhvgQ6CkYIPX5XLXReyt
X-Google-Smtp-Source: APiQypKFR3xBZbIolBQLPSmZZZHuiIYQ2zkLuQsY5dDFnXnAkjiDC/5VHsKEksjvERR5cXEUZes63w==
X-Received: by 2002:a1c:5683:: with SMTP id k125mr9299777wmb.17.1587240596313;
        Sat, 18 Apr 2020 13:09:56 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:939:e10c:14c5:fe9f? (p200300EA8F2960000939E10C14C5FE9F.dip0.t-ipconnect.de. [2003:ea:8f29:6000:939:e10c:14c5:fe9f])
        by smtp.googlemail.com with ESMTPSA id h5sm19158009wrp.97.2020.04.18.13.09.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 13:09:55 -0700 (PDT)
Subject: [PATCH net-next 2/2] r8169: remove PHY resume delay that is handled
 in the PHY driver now
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <c4e18f15-7c37-13a2-4e26-1203da318f67@gmail.com>
Message-ID: <84800b8b-8f38-5288-5845-6fb5e940a072@gmail.com>
Date:   Sat, 18 Apr 2020 22:09:42 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <c4e18f15-7c37-13a2-4e26-1203da318f67@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Realtek PHY driver takes care of adding the needed delay now,
therefore we can remove the delay here.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index bf5bf0597..cac56bd67 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2391,8 +2391,6 @@ static void rtl_pll_power_up(struct rtl8169_private *tp)
 	}
 
 	phy_resume(tp->phydev);
-	/* give MAC/PHY some time to resume */
-	msleep(20);
 }
 
 static void rtl_init_rxcfg(struct rtl8169_private *tp)
-- 
2.26.1


