Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB9E01A2918
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 21:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729646AbgDHTG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 15:06:26 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:42319 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbgDHTGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 15:06:25 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MvsMz-1j3Usz47Ff-00syup; Wed, 08 Apr 2020 21:06:15 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ath11k: fix ath11k_thermal_unregister() prototype
Date:   Wed,  8 Apr 2020 21:05:58 +0200
Message-Id: <20200408190606.870098-2-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200408190606.870098-1-arnd@arndb.de>
References: <20200408190606.870098-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:oCd7sSwGt5YtvhR1EtVG0EnYB9ND3DYTFpON3rvHRhezeRJWaRg
 Ci6yzknixyP/4TPSc1fyYK73SO0IkwNLsHhHTzYYSG5k/1dnG1fjxvWXV50DYhHixOZbMdv
 +42Z2mRdZSFWAqVbcg5V+d9vHOiLGFsaK8ip4Dicrmfl5S3uUCgIxwAKdPFKVXbwriEa6Sa
 O/F6qoAP0GvkXWi2IC4qw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:zxTRjTk5c/c=:zhbeWRqSNt8W0fzyMu5juw
 MRbewvuYqX9K1I0IDrbEIfVCPD2xbdooiMURmcTFDAC2RcpS/hDgLYx4eVs50PlalUNU9aAsg
 guWyWIDkxhidVDkwWDCt5/pGHpz5HomTasdnRbBatxfQ2ndfu7Bx/0WY6V/l9OOlzPoA6gLJ5
 kOYDGB0LZFxyBrmi7pRNaCxSzUDxusPYqBuP6iJfIe8N46CUdMsUwtiCjpS0waxyJh27adnmW
 cxLaXjW2vN1a8/Zz2sOXwq/s7CO78H6S4aLiLoTjL1VcqGJeOredn5gGg5a/Qv10T8Zc1KxUu
 hEyy/ly4rycB9ilP7Pj7761hABxe4h59D2N6OdGisHQDSjU0XgI7YVsK01Ng/THs5WRCXV9iA
 bCbMRJGN49+07ZXStR34cBfy7KblaWScaSRUonTsSSOwnM9ZZDATYBwXJqiJSZV3jvc4gn3FD
 y45gg5ANZ51wEqiEZogkjz0kYyNrfyS8HYywNGLal/tPfEv12TY/rBhcvwcx5r/dsai7TsxYW
 bzc9Ds6+xqCveZjqL6bieq7PBYAE3/Xr9ALMIMSXIRn95Mh1R0gFntQcbjFTknA4ov0fWQ0Kk
 rAM4DkJfw1PpmWpdidK4mn6lvYBEvUmSrR+vrKpVyFPzalx9KXqg0opkKq0CTfG5mezpuDOkk
 LXtqlTdM6egg62XdXns6znUqmbR7px5Cfaganv7HH8BFvby5XhHqasViE4JCryd4CffrcOwMT
 hPNuj/dedv+w0lmubBYBU1D2yYSCVJuaTscvyq+u1payGmjtA5L72ysDj8yMFSLwehcMcfahA
 1WetWAtMqVq8znb6W3WOFaJTlxgutZE2JZkFzzfWDZZ+unbVpE=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The stub function has the wrong prototype, causing a warning:

drivers/net/wireless/ath/ath11k/core.c: In function 'ath11k_core_pdev_destroy':
drivers/net/wireless/ath/ath11k/core.c:416:28: error: passing argument 1 of 'ath11k_thermal_unregister' from incompatible pointer type [-Werror=incompatible-pointer-types]

Change it to take the same arguments as the normal implementation.

Fixes: 2a63bbca06b2 ("ath11k: add thermal cooling device support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/ath/ath11k/thermal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/thermal.h b/drivers/net/wireless/ath/ath11k/thermal.h
index f1395a14748c..ea9a58bf6a93 100644
--- a/drivers/net/wireless/ath/ath11k/thermal.h
+++ b/drivers/net/wireless/ath/ath11k/thermal.h
@@ -36,7 +36,7 @@ static inline int ath11k_thermal_register(struct ath11k_base *sc)
 	return 0;
 }
 
-static inline void ath11k_thermal_unregister(struct ath11k *ar)
+static inline void ath11k_thermal_unregister(struct ath11k_base *ar)
 {
 }
 
-- 
2.26.0

