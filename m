Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61DA3322AA7
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 13:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232696AbhBWMhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 07:37:15 -0500
Received: from m12-17.163.com ([220.181.12.17]:34151 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232589AbhBWMhJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 07:37:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=dIDU6J0odxG9RlqAj0
        JO+hMmJN5ibrBl7SIKeXUpRbI=; b=JD38dWm62FEVyxAELIIIkjEfH+rLQvtUBW
        xNqE8GX5Ehu+lNYyo7hd5k3s4A8QlP6H5QNXPFMWEbureSr2xDPXDTfzmuGnENpd
        xQknTtKUUKuhsLDhxQjxKUqRg/fKAX/f8U5VAolv7EPI7z+AI8C0bHJC5QX9uO1P
        rveTxh/UQ=
Received: from wengjianfeng.ccdomain.com (unknown [119.137.54.165])
        by smtp13 (Coremail) with SMTP id EcCowABnbp52pzRgb_LjmQ--.8535S2;
        Tue, 23 Feb 2021 14:58:01 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     imitsyanko@quantenna.com, geomatsi@gmail.com, kvalo@codeaurora.org,
        kuba@kernel.org, ohannes.berg@intel.com, dlebed@quantenna.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH] qtnfmac: remove meaningless labels
Date:   Tue, 23 Feb 2021 14:57:54 +0800
Message-Id: <20210223065754.34392-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: EcCowABnbp52pzRgb_LjmQ--.8535S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tr18Jr1DWw45KFyxAw48Xrb_yoW5JF1xpr
        WrXa9Fkay8K3yvqas5ArZ5Zr1Yvw1xKFWxKrW8C3s5u3W0yr1rKa1Yva4YyrZ8JFW8Jryj
        qFWvqF1Uu3ZY9a7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j8miiUUUUU=
X-Originating-IP: [119.137.54.165]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiEQM2sV7+2yasZQABsA
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

some function's label meaningless, the return statement follows
the goto statement, so just remove it.

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 27 +++++------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 504b4d0..84b15a6 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -680,13 +680,10 @@ static int qtnf_set_default_key(struct wiphy *wiphy, struct net_device *dev,
 		eth_zero_addr(vif->bssid);
 
 	ret = qtnf_cmd_send_connect(vif, sme);
-	if (ret) {
+	if (ret)
 		pr_err("VIF%u.%u: failed to connect\n",
 		       vif->mac->macid, vif->vifid);
-		goto out;
-	}
 
-out:
 	return ret;
 }
 
@@ -702,13 +699,10 @@ static int qtnf_set_default_key(struct wiphy *wiphy, struct net_device *dev,
 		pr_warn("unexpected bssid: %pM", auth->bssid);
 
 	ret = qtnf_cmd_send_external_auth(vif, auth);
-	if (ret) {
+	if (ret)
 		pr_err("VIF%u.%u: failed to report external auth\n",
 		       vif->mac->macid, vif->vifid);
-		goto out;
-	}
 
-out:
 	return ret;
 }
 
@@ -727,8 +721,7 @@ static int qtnf_set_default_key(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	if (vif->wdev.iftype != NL80211_IFTYPE_STATION) {
-		ret = -EOPNOTSUPP;
-		goto out;
+		return -EOPNOTSUPP;
 	}
 
 	ret = qtnf_cmd_send_disconnect(vif, reason_code);
@@ -742,7 +735,6 @@ static int qtnf_set_default_key(struct wiphy *wiphy, struct net_device *dev,
 				      NULL, 0, true, GFP_KERNEL);
 	}
 
-out:
 	return ret;
 }
 
@@ -935,13 +927,10 @@ static int qtnf_update_owe_info(struct wiphy *wiphy, struct net_device *dev,
 		return -EOPNOTSUPP;
 
 	ret = qtnf_cmd_send_update_owe(vif, owe_info);
-	if (ret) {
+	if (ret)
 		pr_err("VIF%u.%u: failed to update owe info\n",
 		       vif->mac->macid, vif->vifid);
-		goto out;
-	}
 
-out:
 	return ret;
 }
 
@@ -987,18 +976,14 @@ static int qtnf_resume(struct wiphy *wiphy)
 	vif = qtnf_mac_get_base_vif(mac);
 	if (!vif) {
 		pr_err("MAC%u: primary VIF is not configured\n", mac->macid);
-		ret = -EFAULT;
-		goto exit;
+		return -EFAULT;
 	}
 
 	ret = qtnf_cmd_send_wowlan_set(vif, NULL);
-	if (ret) {
+	if (ret)
 		pr_err("MAC%u: failed to reset WoWLAN triggers\n",
 		       mac->macid);
-		goto exit;
-	}
 
-exit:
 	return ret;
 }
 
-- 
1.9.1


