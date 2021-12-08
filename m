Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D46C646DFDC
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 01:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241687AbhLIBAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 20:00:45 -0500
Received: from mailgw.kylinos.cn ([123.150.8.42]:13599 "EHLO nksmu.kylinos.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241678AbhLIBAo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 20:00:44 -0500
X-UUID: 78b2cbd73cde41478cded1d734961bc0-20211209
X-UUID: 78b2cbd73cde41478cded1d734961bc0-20211209
X-User: zhangyue1@kylinos.cn
Received: from localhost.localdomain [(172.17.127.2)] by nksmu.kylinos.cn
        (envelope-from <zhangyue1@kylinos.cn>)
        (Generic MTA)
        with ESMTP id 1053237904; Thu, 09 Dec 2021 09:05:24 +0800
From:   zhangyue <zhangyue1@kylinos.cn>
To:     amitkarwar@gmail.com, siva8118@gmail.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rsi: fix array out of bound
Date:   Wed,  8 Dec 2021 17:53:41 +0800
Message-Id: <20211208095341.47777-1-zhangyue1@kylinos.cn>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Limit the max of 'ii'. If 'ii' greater than or
equal to 'RSI_MAX_VIFS', the array 'adapter->vifs'
may be out of bound

Signed-off-by: zhangyue <zhangyue1@kylinos.cn>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index e70c1c7fdf59..913e11fb3807 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -1108,6 +1108,9 @@ static int rsi_mac80211_ampdu_action(struct ieee80211_hw *hw,
 			break;
 	}
 
+	if (ii >= RSI_MAX_VIFS)
+		return status;
+
 	mutex_lock(&common->mutex);
 
 	if (ssn != NULL)
-- 
2.30.0

