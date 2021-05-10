Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69D4B3799C4
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 00:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhEJWNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 18:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbhEJWNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 18:13:18 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DABC061574;
        Mon, 10 May 2021 15:12:13 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id x19so25692545lfa.2;
        Mon, 10 May 2021 15:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hIXUVbTGBsLSYyOC432iVfvE9K0Kn0F0wM8I/jCX+dM=;
        b=G8/tgKBs0wUPtnjeYUMm1ZLUsZzMD+aREtvDqlxGY3IrwPDsoJ3WUTl9pQiBp2vLpr
         +6Sqv7yTyoOfhRSdVRjKKRVMm1QcnaBFyzk6Sft7iUo+DmVA1CPgt+zle519SXvYEKOJ
         B0zP6HGclbnE70U4APRGN8ML36INiQE2klG4F5rm/VvKkxprPSbyGnxcsS5TccNk+JcW
         zeLiQL7d6Bk1j3+WWYT3lahrKomqxvfgTpHApx+fZSvBuaGkWuEZAr3QJTRWCJAw4gLf
         1BqKMNF4qzOAYWjlbmQyF4xR+jhWmm2cAyTmx+Nemy4gxFFrM81ub6fTXeV6Qx0cwbgk
         UJcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hIXUVbTGBsLSYyOC432iVfvE9K0Kn0F0wM8I/jCX+dM=;
        b=blB39PlHjCeJBjEBWA/ExLbdG3TiOhg/gzOJtdERdUmETCcwXgEsiuYh+YmedD9JyR
         56g43JCTgSTqVHkh6Vwldlb9UzbeKwV6ruNlPp0izYtkWFR9H0dNM6NEvAWUXFKzEllH
         i5kk8/1U92/3dCbscqPSdsMKCp4AsmjRoYi5dwtCyggTwYZah/R73eslbl/iy9/CogpH
         M3SGgDWPLeprVEiv9yyo84CMgk7XgP29mwNlQgYBhk5rTjzOmP53v+5OcaB8BeIftz3i
         j7v+a6pm18ZcpNgsg1B8nlOwLi7n2wWdSzdWEsX1fbEv1TwyvVacxHwXVXN9W1moxV/d
         0wGw==
X-Gm-Message-State: AOAM5306Xk2BGKMnMgTVsaIJZW6TV4XuQlPfMlrCKzkHtZRjRXvazU3N
        S8IHcXIKzZmNgETgRqLpLzU=
X-Google-Smtp-Source: ABdhPJyMJuyhbehfG/EEX3hGQVVKfIPElG9J2Bb8xaeKtQwlVw2sR0Z4SGoUpqIe2j0sX0cBj4DLcQ==
X-Received: by 2002:a05:6512:5c5:: with SMTP id o5mr19241511lfo.168.1620684731689;
        Mon, 10 May 2021 15:12:11 -0700 (PDT)
Received: from localhost.localdomain (109-252-193-91.dynamic.spd-mgts.ru. [109.252.193.91])
        by smtp.gmail.com with ESMTPSA id o11sm2397900lfr.64.2021.05.10.15.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 15:12:11 -0700 (PDT)
From:   Dmitry Osipenko <digetx@gmail.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1] brcmfmac: Silence error messages about unsupported firmware features
Date:   Tue, 11 May 2021 01:11:48 +0300
Message-Id: <20210510221148.12134-1-digetx@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

KMSG is flooded with error messages about unsupported firmware
features on BCM4329 chip. The GET_ASSOCLIST error became especially
noisy with a newer NetworkManager version of Ubuntu 21.04. Let's print
the noisy error messages only once.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 11 +++++++++--
 .../net/wireless/broadcom/brcm80211/brcmfmac/core.c | 13 ++++++++++---
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index f4405d7861b6..631536d8abb4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -2892,8 +2892,15 @@ brcmf_cfg80211_dump_station(struct wiphy *wiphy, struct net_device *ndev,
 					     &cfg->assoclist,
 					     sizeof(cfg->assoclist));
 		if (err) {
-			bphy_err(drvr, "BRCMF_C_GET_ASSOCLIST unsupported, err=%d\n",
-				 err);
+			static bool error_printed = false;
+
+			/* GET_ASSOCLIST unsupported by firmware of older chips */
+			if (!error_printed || err != -EBADE) {
+				bphy_err(drvr, "BRCMF_C_GET_ASSOCLIST unsupported, err=%d\n",
+					 err);
+				error_printed = true;
+			}
+
 			cfg->assoclist.count = 0;
 			return -EOPNOTSUPP;
 		}
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 838b09b23abf..7f1a6234fd27 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -188,9 +188,16 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 	/*Finally, pick up the PROMISC flag */
 	cmd_value = (ndev->flags & IFF_PROMISC) ? true : false;
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_PROMISC, cmd_value);
-	if (err < 0)
-		bphy_err(drvr, "Setting BRCMF_C_SET_PROMISC failed, %d\n",
-			 err);
+	if (err < 0) {
+		static bool error_printed = false;
+
+		/* PROMISC unsupported by firmware of older chips */
+		if (!error_printed || err != -EBADE) {
+			bphy_err(drvr, "Setting BRCMF_C_SET_PROMISC unsupported, err=%d\n",
+				 err);
+			error_printed = true;
+		}
+	}
 	brcmf_configure_arp_nd_offload(ifp, !cmd_value);
 }
 
-- 
2.30.2

