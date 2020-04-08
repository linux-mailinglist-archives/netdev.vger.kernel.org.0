Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39B471A2914
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 21:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729386AbgDHTGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 15:06:21 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:51681 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbgDHTGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 15:06:20 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.145]) with ESMTPA (Nemesis) id
 1Mnq0K-1ixdiP2yeg-00pIaM; Wed, 08 Apr 2020 21:06:07 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ath11k: fix missing return in ath11k_thermal_set_throttling
Date:   Wed,  8 Apr 2020 21:05:57 +0200
Message-Id: <20200408190606.870098-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:SeyubJqFpa1uafAlCsFxxDdFdIAWrMtRLnpLQBjRCYvNbclJZd+
 3TPNst9q4QXUyugz143HRknRijNEFwEvl9MBJr/brYhGtVhUtFFEs/eK8GVOgPzmehL2NcT
 Buc+ywYb93iNu8gC+h6PmnazxslEYSHKztCYXZPVkI26WDLYIdsph1dg5wsHjOEvuyVgFjy
 P5faWwfYJcYYudJ9/c2GA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:6+0XJ7spHeE=:c38GdB3GYqq35dV+iS/LzJ
 yqnSpzMGz26tnARxwvAnIYB0Jm7RqRQNgOXeiBOSpyEfbcCmAWBaKj2Qewl9/5TdWv9tDWCea
 1A8teM01nY/STU5PfZZLJS6zfkpDESqz0IKo9xZJfGKnlzgzdqew4Yt8VYxJbQaImBmHga09n
 JYGEYcR5V+9D4vkcOawjLR9ZXckzEI7TJsKUXeSI8JYsBOM0E6y1GSPc9heLNTSwH/L4/xjE3
 BRogw47X0eSyUWzJ0Drb7gC0Il7ygmKvWlOmh0v+r6zste7W55M0ARvL6z8aO0z6kgZP7r16f
 +42l0QH6NmkcPRgFDJ3eucLNYpnyTRA2wv5qdxaQy6EDRkmso26KW9be6U7G32WndgYYGRRMI
 18buGGuMfDm9OHABOhXjumFWTuOe33630T23nq4VD8ShUDi2GnlkOekyJ0lFQIkaD/MNHxDQo
 wPiWZD9WIpN+yk/Wh+ZT741wLq51ppWTQCmh2JZtCOuJ1rwfVbqsEthQXHAWwsdPqQFVOHEcu
 9MzrGzLNg4k5qDPjckmFB8S3gRerZPftuNsI70kHIjo7RAiuRKuSfgUdoIkBj/StgVNvXwZxo
 7Lo16TKe6/uwxhJyjdqDSeM2JNtW+SbOdPR+OFHJLQLUY655g91YxJZp1EiXUVUxJ3y+TMvQj
 8MApRnajPz538QFmRMvrdeFc9pWJwCd8PcMwQGLkvbCt+TybYlz3sRjYb4dg+k5sou/5gOd5Z
 1DjQSShjxKOHdx/hjqWVOv1XhiikOPO6qcsHwHSJ4/95o8pL4NLbwtrKXLisU0WVJ2anb6TQE
 Gqvtczba9hsT48NSJcWmaOETPRm58u2n92dPYWhstv8uWPGsAo=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The empty stub version of this function causes a compile-time
warning:

In file included from drivers/net/wireless/ath/ath11k/core.h:23,
                 from drivers/net/wireless/ath/ath11k/dp_rx.h:8,
                 from drivers/net/wireless/ath/ath11k/ce.c:6:
drivers/net/wireless/ath/ath11k/thermal.h: In function 'ath11k_thermal_set_throttling':
drivers/net/wireless/ath/ath11k/thermal.h:45:1: error: no return statement in function returning non-void [-Werror=return-type]

Just return success here.

Fixes: a41d10348b01 ("ath11k: add thermal sensor device support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/ath/ath11k/thermal.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath11k/thermal.h b/drivers/net/wireless/ath/ath11k/thermal.h
index 459b8d49c184..f1395a14748c 100644
--- a/drivers/net/wireless/ath/ath11k/thermal.h
+++ b/drivers/net/wireless/ath/ath11k/thermal.h
@@ -42,6 +42,7 @@ static inline void ath11k_thermal_unregister(struct ath11k *ar)
 
 static inline int ath11k_thermal_set_throttling(struct ath11k *ar, u32 throttle_state)
 {
+	return 0;
 }
 
 static inline void ath11k_thermal_event_temperature(struct ath11k *ar,
-- 
2.26.0

