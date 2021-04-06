Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9327E354B46
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 05:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242306AbhDFDhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 23:37:25 -0400
Received: from m12-13.163.com ([220.181.12.13]:60041 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233556AbhDFDhZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 23:37:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=dIDU6J0odxG9RlqAj0
        JO+hMmJN5ibrBl7SIKeXUpRbI=; b=BbpHXbiBYlVZuatcxDhEvf8w3qMWjvFtUL
        WnsD7JteofleAHEdcNHlfar9OM71fDlOi389DR03Re1bsfERT07qXa0/gxGZLONQ
        6E/xjNTI+9gRJEfaL7nIK9n/XW9HgS0ObQH9RgswO3GbsZs/E+tYfqfQtk/qmzsC
        UoOvHvPXM=
Received: from wengjianfeng.ccdomain.com (unknown [218.17.89.92])
        by smtp9 (Coremail) with SMTP id DcCowABXbrkUzGtgTKGNEg--.53507S2;
        Tue, 06 Apr 2021 10:48:54 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     imitsyanko@quantenna.com, geomatsi@gmail.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, johannes.berg@intel.com,
        arend.vanspriel@broadcom.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH RESEND] qtnfmac: remove meaningless labels
Date:   Tue,  6 Apr 2021 10:48:47 +0800
Message-Id: <20210406024847.27620-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: DcCowABXbrkUzGtgTKGNEg--.53507S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tr18Jr1DWw45KFyxAw48Xrb_yoW5JF1xpr
        WrXa9Fkay8K3yvqas5ArZ5Zr1Yvw1xKFWxKrW8C3s5u3W0yr1rKa1Yva4YyrZ8JFW8Jryj
        qFWvqF1Uu3ZY9a7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jlbyAUUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiLxZssVUMX1zr4QAAs0
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


