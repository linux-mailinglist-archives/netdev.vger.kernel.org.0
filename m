Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B74137B0A5
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 23:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhEKVR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 17:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbhEKVRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 17:17:55 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FAA0C061574;
        Tue, 11 May 2021 14:16:48 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id e11so13396233ljn.13;
        Tue, 11 May 2021 14:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=osCn6ypOUhoWp7HtfAu6ClFz6GUI5XGyO6vrfaQnjWw=;
        b=SQ7kZPkAZpOc1zuGaxa/kmSYBev4NCc47yR00hQce9UlxftkJpONQ2WFrow1fF2tbZ
         HG7bRKaaGkGML+tdas7ARtO7nLyw4d2QhyfM20QAuVOeFftD/rn7zMD1zGewgJ1LSFey
         sFZE2Dx9Zg2kG1ku39D75BWmG+Aoz6IzaFXszwsYmHHmym/A3ZaVZsPYKJyh6M+5StUj
         6RsmP8AxxvC4FygzBR++rFqaOWi2F2HCh1l0eCEuyjGIbVA9Na5pOC6RM3LYwai6n+h+
         /bZGtVr4NJG6ywr07tgO1b3eADX4yhEuSoy+TKOKCFgUnbKNDu5rstePwdpj90Hvmcnb
         m/Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=osCn6ypOUhoWp7HtfAu6ClFz6GUI5XGyO6vrfaQnjWw=;
        b=rZ5zydppsDEN3zeA6MCjtsvvWOsLd6v3rM8c7hV2zP+j3o45FDX+g/C/Zqa6rNDfhQ
         LdljJ351VkrlC3sEsJ3iKQh4DwGCL6Ml0IqIdvGHfGhLS7SUcye38dFO79H4n8brdjPz
         IBZTENuUl9RUE08B8sz6oYGAEDBWqeaDPsf9toCihw4COyLQtV4R9JcguM4znFhPU/CP
         KE1HzSKKhlNjSyxppm9Zp1YOfmnKow46JxiTV3xXwlYKvdDbN9wy5UGxZ4HCnFb6kkZQ
         khwyby3tqtcuZcE78n1ZHz0+LI/aoHw5nWi/ZbK7zT0LugN7ihDzU+rbOBvUp5n1j99i
         cQAw==
X-Gm-Message-State: AOAM531ek3vpokMpCa82fZ3EEMPkopd4hAOFzxNPlA4v7xUK8J656szo
        2ceEGcKt2Ogsh5pyS1IwFpw=
X-Google-Smtp-Source: ABdhPJxU6NYAY+gmGHPQ3K7q4BrApWfgG3pow1zq2GlP5Zw2SaeOKrtIpclie1VD9QFBk9RS5HZ/ig==
X-Received: by 2002:a2e:9bd7:: with SMTP id w23mr25547197ljj.401.1620767806080;
        Tue, 11 May 2021 14:16:46 -0700 (PDT)
Received: from localhost.localdomain (109-252-193-91.dynamic.spd-mgts.ru. [109.252.193.91])
        by smtp.gmail.com with ESMTPSA id a20sm3882527ljn.94.2021.05.11.14.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 14:16:45 -0700 (PDT)
From:   Dmitry Osipenko <digetx@gmail.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] brcmfmac: Silence error messages about unsupported firmware features
Date:   Wed, 12 May 2021 00:15:49 +0300
Message-Id: <20210511211549.30571-2-digetx@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210511211549.30571-1-digetx@gmail.com>
References: <20210511211549.30571-1-digetx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

KMSG is flooded with error messages about unsupported firmware
features of BCM4329 chip. The GET_ASSOCLIST error became especially
noisy with a newer NetworkManager version of Ubuntu 21.04. Turn the
noisy error messages into info messages and print them out only once.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---

v2: - Switched to use generic printk helper as was suggested by
      Andy Shevchenko in a comment to v1.

    - Silenced message about the rxchain, which is also unsupported
      by BCM4329.

 .../broadcom/brcm80211/brcmfmac/cfg80211.c       | 16 +++++++++++++---
 .../wireless/broadcom/brcm80211/brcmfmac/core.c  | 11 ++++++++---
 .../wireless/broadcom/brcm80211/brcmfmac/debug.h |  4 ++++
 3 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index f4405d7861b6..27331dfc9ec0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -2892,8 +2892,13 @@ brcmf_cfg80211_dump_station(struct wiphy *wiphy, struct net_device *ndev,
 					     &cfg->assoclist,
 					     sizeof(cfg->assoclist));
 		if (err) {
-			bphy_err(drvr, "BRCMF_C_GET_ASSOCLIST unsupported, err=%d\n",
-				 err);
+			/* GET_ASSOCLIST unsupported by firmware of older chips */
+			if (err == -EBADE)
+				bphy_info_once(drvr, "BRCMF_C_GET_ASSOCLIST unsupported\n");
+			else
+				bphy_err(drvr, "BRCMF_C_GET_ASSOCLIST failed, err=%d\n",
+					 err);
+
 			cfg->assoclist.count = 0;
 			return -EOPNOTSUPP;
 		}
@@ -6848,7 +6853,12 @@ static int brcmf_setup_wiphybands(struct brcmf_cfg80211_info *cfg)
 
 	err = brcmf_fil_iovar_int_get(ifp, "rxchain", &rxchain);
 	if (err) {
-		bphy_err(drvr, "rxchain error (%d)\n", err);
+		/* rxchain unsupported by firmware of older chips */
+		if (err == -EBADE)
+			bphy_info_once(drvr, "rxchain unsupported\n");
+		else
+			bphy_err(drvr, "rxchain error (%d)\n", err);
+
 		nchain = 1;
 	} else {
 		for (nchain = 0; rxchain; nchain++)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 838b09b23abf..f98b48cfc001 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -188,9 +188,14 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 	/*Finally, pick up the PROMISC flag */
 	cmd_value = (ndev->flags & IFF_PROMISC) ? true : false;
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_PROMISC, cmd_value);
-	if (err < 0)
-		bphy_err(drvr, "Setting BRCMF_C_SET_PROMISC failed, %d\n",
-			 err);
+	if (err < 0) {
+		/* PROMISC unsupported by firmware of older chips */
+		if (err == -EBADE)
+			bphy_info_once(drvr, "BRCMF_C_SET_PROMISC unsupported\n");
+		else
+			bphy_err(drvr, "Setting BRCMF_C_SET_PROMISC failed, err=%d\n",
+				 err);
+	}
 	brcmf_configure_arp_nd_offload(ifp, !cmd_value);
 }
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
index 44ba6f389fa9..9bb5f709d41a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
@@ -60,6 +60,10 @@ void __brcmf_err(struct brcmf_bus *bus, const char *func, const char *fmt, ...);
 				  ##__VA_ARGS__);			\
 	} while (0)
 
+#define bphy_info_once(drvr, fmt, ...)					\
+	wiphy_info_once((drvr)->wiphy, "%s: " fmt, __func__,		\
+			##__VA_ARGS__)
+
 #if defined(DEBUG) || defined(CONFIG_BRCM_TRACING)
 
 /* For debug/tracing purposes treat info messages as errors */
-- 
2.30.2

