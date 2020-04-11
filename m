Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 128F31A4CD1
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 02:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgDKAUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 20:20:23 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35983 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbgDKAUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 20:20:19 -0400
Received: by mail-wm1-f67.google.com with SMTP id a201so4001464wme.1;
        Fri, 10 Apr 2020 17:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WqLpUe/3+ebAsfSyEr8eWQGQOEEyLPgemLyG5SvrhHI=;
        b=ve00Ui45sd+mRIObqi4fVxpgDL1FPby9VCzCj4up6kJluTET85j6C/jkaFTqIiYuT2
         1GhQGH7Sx8HCdF86m+cAKpqG94WATIWwwv3oP5hGRWQBpkyyCQxLel51jzVSK6Nd2Zai
         lxaMJxKAfk7aEH+J5TOxzxVln/e4UL90yec+A7WY7I/6rEvheZU6yvou3zB6uqQmyrZe
         Zlj5M8US/WwEC2BcQddcpVluxzqwGbCNosji3FGUDXv48GI6Tr/w1FUlo+a/AZOT6kQl
         EO2vgzMWWDQKe+G9BK1TqgJccORmQo6iJZpkHulI2Mkf2LTPpZQPheRN4exbUQCIM5lc
         pUmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WqLpUe/3+ebAsfSyEr8eWQGQOEEyLPgemLyG5SvrhHI=;
        b=R8MACe4Zcce+OB2s1WOhn68taUezANBy0QkD5yknRpYWVjr2/VOGnGMtrX7QNnBKim
         txBHmDMvbB7FfY4u5TiH8dT9ZQpOntVyF+ytFYZHe4/PZFODI0WhCjyaGC2G4hDkrZ5n
         286n3mkdGVlYNEb4aPtZlZ9rzcuqoQX6iBhvzfY66+mNC1ogu8/e2mJVAs/Bx7eThAYV
         D+dubES/InM9SRLgdWS1lEe18GB4RXWEs6Bo/2E+GZ0wFEhaL2g/I9Y1AuYbImoxjFKX
         c0229AeDSmcvyNgOV2c1J6/3LNnzJrW70sNgZLNvjSi4uE8iAoE4bYeKsvqgx93Gss4X
         /+UQ==
X-Gm-Message-State: AGi0Pubw80t9+Pgzcck6RWFekHOVvfPazUBBV4ZIoUSGTzjWNwUw3YMw
        ww41YqhkJBjD8qjoN+e5/zzlADmCXJMo
X-Google-Smtp-Source: APiQypJTY6BBVpJIbEZoG4XC26odBRDzb6vOdpzxy/8sR/Td9iLmxzbhYDkcX8M+D2UiwGrPh8Pt7A==
X-Received: by 2002:a1c:7ed7:: with SMTP id z206mr6958804wmc.64.1586564417420;
        Fri, 10 Apr 2020 17:20:17 -0700 (PDT)
Received: from ninjahost.lan (host-2-102-14-153.as13285.net. [2.102.14.153])
        by smtp.gmail.com with ESMTPSA id b191sm5091594wmd.39.2020.04.10.17.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2020 17:20:16 -0700 (PDT)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     boqun.feng@gmail.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org (open list:BROADCOM BRCM80211
        IEEE802.11n WIRELESS DRIVER),
        brcm80211-dev-list.pdl@broadcom.com (open list:BROADCOM BRCM80211
        IEEE802.11n WIRELESS DRIVER),
        brcm80211-dev-list@cypress.com (open list:BROADCOM BRCM80211
        IEEE802.11n WIRELESS DRIVER),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
Subject: [PATCH 5/9] mac80211: Add missing annotation for brcms_down()
Date:   Sat, 11 Apr 2020 01:19:29 +0100
Message-Id: <20200411001933.10072-6-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200411001933.10072-1-jbi.octave@gmail.com>
References: <0/9>
 <20200411001933.10072-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse reports a warning at brcms_down()

warning: context imbalance in brcms_down()
	- unexpected unlock
The root cause is the missing annotation at brcms_down()
Add the missing __must_hold(&wl->lock) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
index c3dbeacea6ca..648efcbc819f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
@@ -1431,6 +1431,7 @@ int brcms_up(struct brcms_info *wl)
  * precondition: perimeter lock has been acquired
  */
 void brcms_down(struct brcms_info *wl)
+	__must_hold(&wl->lock)
 {
 	uint callbacks, ret_val = 0;
 
-- 
2.24.1

