Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E33368FC3
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 11:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241832AbhDWJug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 05:50:36 -0400
Received: from m12-14.163.com ([220.181.12.14]:40898 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229811AbhDWJug (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 05:50:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=qGJkn
        Op0Fjfs5Wkr2klPQ1xZyq4lzvCWiet6MP6DPGc=; b=LO4gG5a0142Q5h8/GohYs
        yVQ0Nnc9AedKe4iRGJWgqVH+E25xnxzkwoiyqt6+1vM7kLOpAVSnmyaUl/K+M0D7
        ovFWnY3n6DtQXx/LYK8iouxB46jDNKoSVIsi7LDITijVG1kSeGF6TKcWdeifz+EJ
        dfRDQbUKc4qVd/2lJA3YdY=
Received: from COOL-20201210PM.ccdomain.com (unknown [218.94.48.178])
        by smtp10 (Coremail) with SMTP id DsCowAA3km8rmIJgaCCyEw--.5294S2;
        Fri, 23 Apr 2021 17:49:35 +0800 (CST)
From:   zuoqilin1@163.com
To:     jussi.kivilinna@iki.fi, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, zuoqilin <zuoqilin@yulong.com>
Subject: [PATCH] wireless: Simplify expression
Date:   Fri, 23 Apr 2021 17:49:40 +0800
Message-Id: <20210423094940.1593-1-zuoqilin1@163.com>
X-Mailer: git-send-email 2.28.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DsCowAA3km8rmIJgaCCyEw--.5294S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7GF13XF4xGrW8Cr45tw4DCFg_yoWDJwc_Gr
        WIvF1kG34xXw1UKw48CFsxZryayr4DXFnYv3yjq3yakr45KFW8XrnYkFZxJr4DWw10yryx
        Cr12ka4xA3y0qjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU1hiStUUUUU==
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 52xr1xpolqiqqrwthudrp/xtbBRQd9iVPALUCsHwAAs7
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zuoqilin <zuoqilin@yulong.com>

It is not necessary to define the variable ret to receive
the return value of the get_bssid() method.

Signed-off-by: zuoqilin <zuoqilin@yulong.com>
---
 drivers/net/wireless/rndis_wlan.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 9fe7755..63ce244 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -1036,14 +1036,11 @@ static bool is_associated(struct usbnet *usbdev)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	u8 bssid[ETH_ALEN];
-	int ret;
 
 	if (!priv->radio_on)
 		return false;
 
-	ret = get_bssid(usbdev, bssid);
-
-	return (ret == 0 && !is_zero_ether_addr(bssid));
+	return (get_bssid(usbdev, bssid) == 0 && !is_zero_ether_addr(bssid));
 }
 
 static int disassociate(struct usbnet *usbdev, bool reset_ssid)
-- 
1.9.1

