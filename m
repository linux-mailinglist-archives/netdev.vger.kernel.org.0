Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5102D354B4E
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 05:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242317AbhDFDkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 23:40:42 -0400
Received: from m12-13.163.com ([220.181.12.13]:41563 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233205AbhDFDkd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 23:40:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=F34/1cGQedP54zIXnw
        kaDlSbvK1SESeQuYgvXovyB3w=; b=TETDe1vhiCVFxRKnxPq8P1ruzT0Qp9RA1t
        BiO0Cr+Sx3xw4jXqs39w1Y7jvM5v2vpMViNJAzMDGPSiQ7m6vnC9S1IGEwwAowjg
        rIugZgYxOrEVTvh0R35/E4MnOjFilK61DUc4fquJyPKkYC+7caMrjKZAA/O9riq1
        jOK+T/GsA=
Received: from wengjianfeng.ccdomain.com (unknown [119.137.52.42])
        by smtp9 (Coremail) with SMTP id DcCowABX9qrwzGtg3w6OEg--.53576S2;
        Tue, 06 Apr 2021 10:52:34 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     imitsyanko@quantenna.com, geomatsi@gmail.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, colin.king@canonical.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH v2] qtnfmac: remove meaningless goto statement and labels
Date:   Tue,  6 Apr 2021 10:52:06 +0800
Message-Id: <20210406025206.4924-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: DcCowABX9qrwzGtg3w6OEg--.53576S2
X-Coremail-Antispam: 1Uf129KBjvfXoWkJry8AryxtF13uw17p5X_AFyrtoZ3Zas8J3
        y8GrWUta4xKF4FgFyjyw1kCw43K3yUKrZ0yF4DGF1UWw1UJ3Z5WayFga4Skr45Jryxt34f
        JayqgFsxn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3AaLaJ3Ub
        IYCTnIWIevJa73UjIFyTuYvjxUsF1vDUUUU
X-Originating-IP: [119.137.52.42]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiqh5ssVr7sy2cDwAAsF
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

some function's label meaningless, the label statement follows
the goto statement, no other statements, so just remove it.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 67 -----------------------
 1 file changed, 67 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index f3ccbd2..c68563c 100644
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
@@ -1931,8 +1902,6 @@ int qtnf_cmd_send_change_sta(struct qtnf_vif *vif, const u8 *mac,
 	}
 
 	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb);
-	if (ret)
-		goto out;
 
 out:
 	qtnf_bus_unlock(vif->mac->bus);
@@ -1966,10 +1935,7 @@ int qtnf_cmd_send_del_sta(struct qtnf_vif *vif,
 	cmd->reason_code = cpu_to_le16(params->reason_code);
 
 	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb);
-	if (ret)
-		goto out;
 
-out:
 	qtnf_bus_unlock(vif->mac->bus);
 
 	return ret;
@@ -2189,10 +2155,6 @@ int qtnf_cmd_send_connect(struct qtnf_vif *vif,
 
 	qtnf_bus_lock(vif->mac->bus);
 	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb);
-	if (ret)
-		goto out;
-
-out:
 	qtnf_bus_unlock(vif->mac->bus);
 
 	return ret;
@@ -2218,10 +2180,6 @@ int qtnf_cmd_send_external_auth(struct qtnf_vif *vif,
 
 	qtnf_bus_lock(vif->mac->bus);
 	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb);
-	if (ret)
-		goto out;
-
-out:
 	qtnf_bus_unlock(vif->mac->bus);
 
 	return ret;
@@ -2245,10 +2203,7 @@ int qtnf_cmd_send_disconnect(struct qtnf_vif *vif, u16 reason_code)
 	cmd->reason = cpu_to_le16(reason_code);
 
 	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb);
-	if (ret)
-		goto out;
 
-out:
 	qtnf_bus_unlock(vif->mac->bus);
 
 	return ret;
@@ -2271,10 +2226,6 @@ int qtnf_cmd_send_updown_intf(struct qtnf_vif *vif, bool up)
 
 	qtnf_bus_lock(vif->mac->bus);
 	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb);
-	if (ret)
-		goto out;
-
-out:
 	qtnf_bus_unlock(vif->mac->bus);
 
 	return ret;
@@ -2580,10 +2531,6 @@ int qtnf_cmd_start_cac(const struct qtnf_vif *vif,
 
 	qtnf_bus_lock(bus);
 	ret = qtnf_cmd_send(bus, cmd_skb);
-	if (ret)
-		goto out;
-
-out:
 	qtnf_bus_unlock(bus);
 
 	return ret;
@@ -2611,10 +2558,6 @@ int qtnf_cmd_set_mac_acl(const struct qtnf_vif *vif,
 
 	qtnf_bus_lock(bus);
 	ret = qtnf_cmd_send(bus, cmd_skb);
-	if (ret)
-		goto out;
-
-out:
 	qtnf_bus_unlock(bus);
 
 	return ret;
@@ -2639,10 +2582,7 @@ int qtnf_cmd_send_pm_set(const struct qtnf_vif *vif, u8 pm_mode, int timeout)
 	qtnf_bus_lock(bus);
 
 	ret = qtnf_cmd_send(bus, cmd_skb);
-	if (ret)
-		goto out;
 
-out:
 	qtnf_bus_unlock(bus);
 
 	return ret;
@@ -2754,10 +2694,7 @@ int qtnf_cmd_send_wowlan_set(const struct qtnf_vif *vif,
 	cmd->triggers = cpu_to_le32(triggers);
 
 	ret = qtnf_cmd_send(bus, cmd_skb);
-	if (ret)
-		goto out;
 
-out:
 	qtnf_bus_unlock(bus);
 	return ret;
 }
@@ -2821,10 +2758,6 @@ int qtnf_cmd_send_update_owe(struct qtnf_vif *vif,
 
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


