Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C925A262CAA
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 11:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgIIJ5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 05:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbgIIJ5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 05:57:16 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E177EC061573;
        Wed,  9 Sep 2020 02:57:15 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id q9so1669645wmj.2;
        Wed, 09 Sep 2020 02:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vzJ2+owmiLfYv0cJPn9WGDrp2m6lL87kIpE3iI2zcfI=;
        b=UymuNGiU1rRtNtj90xat6K+VNYkIHfxXx0aUubLRLV8Vt+X7JbbSYF7mdrJwurXZUH
         8G09VZqoOuUHiHg2Gzj1bzgJH5zZKHG/6etP5k9kZ/MZNrxOZm/7H2avBYfRYQZpVpFL
         Pb2K1VVkQoJ7gODU+yfDEpCo5eUOLllMC+S+9fSyp2EMYvyOYBnzYnwBCU2qNhc0/nQQ
         gNozl3Jnh/FbxYbRcE4aHUXH9L0DIG6aPM2msSNk2BZ1oriiEdim+nfGGH7OlMKdg+09
         /d5clbtplgGXCcRDUExBOMNQR2bcvlqVbuBLlhDk2kTxelR/cKvW/u1pCRp3vJ0F0IUR
         TSwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vzJ2+owmiLfYv0cJPn9WGDrp2m6lL87kIpE3iI2zcfI=;
        b=LQilAuqMUwXWdjIyZMQS8YoALTjHjxzWK0Vw0Tb1LMt1minfthoUEk1eFV2bDloQGp
         V3rPKigsGn/f62Qt1TwUogHGcdwZk1dt+/Hoc84BbIHsoxmq81ehJ4WTGDH0z/L9bmRF
         KfXYU8J3sWgCZ2l2uZj7cK+XGpmd2bnozjkhstbBV9JF8o+kkEt/5eUhfMcWzYhsraGW
         7hXEeEW5Mvy9pC7kLYRl4gVsK+DbkFlJka88DZwmWM6fOqxFsbQhoFQ4Qn+expsaAObH
         UJR+FtegyiGNMhf4jjQkUA5dHnk4TlfdyMT6XC6NF0poBEi9Dc3P8Z4aD4AW/ud6FAoY
         Oi1A==
X-Gm-Message-State: AOAM533PZbGD+9melJAdQ6WPpzzGxqMHr5yorQbvmgvsra961Smy4JcW
        mL0vPlo8qN/+MUJIEKYhtJNvuLHjT1b3SQ==
X-Google-Smtp-Source: ABdhPJx0pAEeNLqqBK/0LW0KyVkmWPS/hnK0xBnBcd/aCzJZ0k8zTYt12mQMUj9IICUolv71rfhAHA==
X-Received: by 2002:a1c:14e:: with SMTP id 75mr2897019wmb.114.1599645434391;
        Wed, 09 Sep 2020 02:57:14 -0700 (PDT)
Received: from localhost.localdomain ([85.153.229.216])
        by smtp.gmail.com with ESMTPSA id l15sm3381621wrt.81.2020.09.09.02.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 02:57:13 -0700 (PDT)
From:   Necip Fazil Yildiran <fazilyildiran@gmail.com>
To:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org
Cc:     ard.biesheuvel@linaro.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        paul@pgazz.com, jeho@cs.utexas.edu,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>
Subject: [PATCH] net: wireless: fix unmet direct dependendices config warning when !CRYPTO
Date:   Wed,  9 Sep 2020 12:54:53 +0300
Message-Id: <20200909095452.3080-1-fazilyildiran@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When LIB80211_CRYPT_CCMP is enabled and CRYPTO is disabled, it results in unmet
direct dependencies config warning. The reason is that LIB80211_CRYPT_CCMP
selects CRYPTO_AES and CRYPTO_CCM, which are subordinate to CRYPTO. This is
reproducible with CRYPTO disabled and R8188EU enabled, where R8188EU selects
LIB80211_CRYPT_CCMP but does not select or depend on CRYPTO.

Honor the kconfig menu hierarchy to remove kconfig dependency warnings.

Fixes: a11e2f85481c ("lib80211: use crypto API ccm(aes) transform for CCMP processing")
Signed-off-by: Necip Fazil Yildiran <fazilyildiran@gmail.com>
---
 net/wireless/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index faf74850a1b5..27026f587fa6 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -217,6 +217,7 @@ config LIB80211_CRYPT_WEP
 
 config LIB80211_CRYPT_CCMP
 	tristate
+	select CRYPTO
 	select CRYPTO_AES
 	select CRYPTO_CCM
 
-- 
2.25.1

