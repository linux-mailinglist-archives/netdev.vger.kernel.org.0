Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74AAF324AA9
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 07:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbhBYGxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 01:53:07 -0500
Received: from m12-16.163.com ([220.181.12.16]:53234 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229561AbhBYGxC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 01:53:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=KJ87GDorKAbnOFbMVg
        2BY4VDOg0JBKdJF+HgB8fHkuY=; b=VjEY4fGLMF5zqskoNG0B9vq7HmUrxofEtt
        J809Mnr7Isv0o5dF/SGXdDoV3O4IY0ph0/ZnEOkKpVEMVz6r4yT5D0DAvAzu4gUr
        QgLDpfWy6e3KeCkmZxhdI32j6XiIxpm/s4hHFnxzG3l3ieGuY2vjbrXiponWQcvv
        wsu/H/BIQ=
Received: from wengjianfeng.ccdomain.com (unknown [218.17.89.92])
        by smtp12 (Coremail) with SMTP id EMCowAA3PytMSDdgynBxdg--.3200S2;
        Thu, 25 Feb 2021 14:48:46 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     imitsyanko@quantenna.com, geomatsi@gmail.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, colin.king@canonical.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH] qtnfmac: remove meaningless goto statement and labels
Date:   Thu, 25 Feb 2021 14:48:42 +0800
Message-Id: <20210225064842.36952-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: EMCowAA3PytMSDdgynBxdg--.3200S2
X-Coremail-Antispam: 1Uf129KBjvfXoWkWrWrtF17GF1UCF17p5X_AFyUtoZ3Zas8J3
        y8GryUta4xKF4FgFyjyw1kCw43K3yUKrZ0kF4DGF1UWw1UJ3Z8WayFga4S9r45Jryxt34x
        JayqgFsxn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3AaLaJ3Ub
        IYCTnIWIevJa73UjIFyTuYvjxUDUUUUUUUU
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiqg5EsVr7sN-ifgAAsD
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

some function's label meaningless, the label statement follows
the goto statement, no other statements, so just remove it.

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 68 -----------------------
 1 file changed, 68 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index f3ccbd2..842bf03 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -379,10 +379,6 @@ int qtnf_cmd_send_stop_ap(struct qtnf_vif *vif)
 
 	qtnf_bus_lock(vif->mac->bus);
 	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb);
-	if (ret)
-		goto out;
-
-out:
 	qtnf_bus_unlock(vif->mac->bus);
 
 	return ret;
@@ -407,10 +403,7 @@ int qtnf_cmd_send_register_mgmt(struct qtnf_vif *vif, u16 frame_type, bool reg)
 	cmd->do_register = reg;
 
 	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb);
-	if (ret)
-		goto out;
 
-out:
 	qtnf_bus_unlock(vif->mac->bus);
 
 	return ret;
@@ -446,10 +439,7 @@ int qtnf_cmd_send_frame(struct qtnf_vif *vif, u32 cookie, u16 flags,
 		qtnf_cmd_skb_put_buffer(cmd_skb, buf, len);
 
 	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb);
-	if (ret)
-		goto out;
 
-out:
 	qtnf_bus_unlock(vif->mac->bus);
 
 	return ret;
@@ -477,10 +467,6 @@ int qtnf_cmd_send_mgmt_set_appie(struct qtnf_vif *vif, u8 frame_type,
 
 	qtnf_bus_lock(vif->mac->bus);
 	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb);
-	if (ret)
-		goto out;
-
-out:
 	qtnf_bus_unlock(vif->mac->bus);
 
 	return ret;
@@ -1677,10 +1663,7 @@ int qtnf_cmd_send_update_phy_params(struct qtnf_wmac *mac, u32 changed)
 					 wiphy->retry_short);
 
 	ret = qtnf_cmd_send(mac->bus, cmd_skb);
-	if (ret)
-		goto out;
 
-out:
 	qtnf_bus_unlock(mac->bus);
 
 	return ret;
@@ -1772,10 +1755,7 @@ int qtnf_cmd_send_add_key(struct qtnf_vif *vif, u8 key_index, bool pairwise,
 					 params->seq_len);
 
 	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb);
-	if (ret)
-		goto out;
 
-out:
 	qtnf_bus_unlock(vif->mac->bus);
 
 	return ret;
@@ -1807,10 +1787,7 @@ int qtnf_cmd_send_del_key(struct qtnf_vif *vif, u8 key_index, bool pairwise,
 	cmd->pairwise = pairwise;
 
 	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb);
-	if (ret)
-		goto out;
 
-out:
 	qtnf_bus_unlock(vif->mac->bus);
 
 	return ret;
@@ -1837,10 +1814,7 @@ int qtnf_cmd_send_set_default_key(struct qtnf_vif *vif, u8 key_index,
 	cmd->multicast = multicast;
 
 	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb);
-	if (ret)
-		goto out;
 
-out:
 	qtnf_bus_unlock(vif->mac->bus);
 
 	return ret;
@@ -1864,10 +1838,7 @@ int qtnf_cmd_send_set_default_mgmt_key(struct qtnf_vif *vif, u8 key_index)
 	cmd->key_index = key_index;
 
 	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb);
-	if (ret)
-		goto out;
 
-out:
 	qtnf_bus_unlock(vif->mac->bus);
 
 	return ret;
@@ -1931,10 +1902,7 @@ int qtnf_cmd_send_change_sta(struct qtnf_vif *vif, const u8 *mac,
 	}
 
 	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb);
-	if (ret)
-		goto out;
 
-out:
 	qtnf_bus_unlock(vif->mac->bus);
 
 	return ret;
@@ -1966,10 +1934,7 @@ int qtnf_cmd_send_del_sta(struct qtnf_vif *vif,
 	cmd->reason_code = cpu_to_le16(params->reason_code);
 
 	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb);
-	if (ret)
-		goto out;
 
-out:
 	qtnf_bus_unlock(vif->mac->bus);
 
 	return ret;
@@ -2189,10 +2154,6 @@ int qtnf_cmd_send_connect(struct qtnf_vif *vif,
 
 	qtnf_bus_lock(vif->mac->bus);
 	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb);
-	if (ret)
-		goto out;
-
-out:
 	qtnf_bus_unlock(vif->mac->bus);
 
 	return ret;
@@ -2218,10 +2179,6 @@ int qtnf_cmd_send_external_auth(struct qtnf_vif *vif,
 
 	qtnf_bus_lock(vif->mac->bus);
 	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb);
-	if (ret)
-		goto out;
-
-out:
 	qtnf_bus_unlock(vif->mac->bus);
 
 	return ret;
@@ -2245,10 +2202,7 @@ int qtnf_cmd_send_disconnect(struct qtnf_vif *vif, u16 reason_code)
 	cmd->reason = cpu_to_le16(reason_code);
 
 	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb);
-	if (ret)
-		goto out;
 
-out:
 	qtnf_bus_unlock(vif->mac->bus);
 
 	return ret;
@@ -2271,10 +2225,6 @@ int qtnf_cmd_send_updown_intf(struct qtnf_vif *vif, bool up)
 
 	qtnf_bus_lock(vif->mac->bus);
 	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb);
-	if (ret)
-		goto out;
-
-out:
 	qtnf_bus_unlock(vif->mac->bus);
 
 	return ret;
@@ -2580,10 +2530,6 @@ int qtnf_cmd_start_cac(const struct qtnf_vif *vif,
 
 	qtnf_bus_lock(bus);
 	ret = qtnf_cmd_send(bus, cmd_skb);
-	if (ret)
-		goto out;
-
-out:
 	qtnf_bus_unlock(bus);
 
 	return ret;
@@ -2611,10 +2557,6 @@ int qtnf_cmd_set_mac_acl(const struct qtnf_vif *vif,
 
 	qtnf_bus_lock(bus);
 	ret = qtnf_cmd_send(bus, cmd_skb);
-	if (ret)
-		goto out;
-
-out:
 	qtnf_bus_unlock(bus);
 
 	return ret;
@@ -2639,10 +2581,7 @@ int qtnf_cmd_send_pm_set(const struct qtnf_vif *vif, u8 pm_mode, int timeout)
 	qtnf_bus_lock(bus);
 
 	ret = qtnf_cmd_send(bus, cmd_skb);
-	if (ret)
-		goto out;
 
-out:
 	qtnf_bus_unlock(bus);
 
 	return ret;
@@ -2754,10 +2693,7 @@ int qtnf_cmd_send_wowlan_set(const struct qtnf_vif *vif,
 	cmd->triggers = cpu_to_le32(triggers);
 
 	ret = qtnf_cmd_send(bus, cmd_skb);
-	if (ret)
-		goto out;
 
-out:
 	qtnf_bus_unlock(bus);
 	return ret;
 }
@@ -2821,10 +2757,6 @@ int qtnf_cmd_send_update_owe(struct qtnf_vif *vif,
 
 	qtnf_bus_lock(vif->mac->bus);
 	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb);
-	if (ret)
-		goto out;
-
-out:
 	qtnf_bus_unlock(vif->mac->bus);
 
 	return ret;
-- 
1.9.1


