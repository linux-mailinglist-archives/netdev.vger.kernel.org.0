Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A79BBE6A2
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 22:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393370AbfIYUto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 16:49:44 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53454 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728993AbfIYUtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 16:49:43 -0400
Received: by mail-wm1-f68.google.com with SMTP id i16so186800wmd.3;
        Wed, 25 Sep 2019 13:49:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=26gn2NTMQ9dZ0K5OTw06VLKtRMQYca/TvxMBDgiM3Gc=;
        b=sPxydplJQsLnQ+7EyrubEvK9CQs1bIJ8yiz1tgKnOfz3XtugwaJfHbdXuo4wkgVf2r
         Qt9hkrmcm7B444jVh+rSHPCWoGjWY9jXz9Z2Jp7mmXYW2YGvTow8g3qV2irlWTznB1KA
         UgYrWxPokB6ZEfyTv145LbJ499QCuttxOCkjrAPTCRz0bloKgwit8+AlNkSSbT8xTucu
         NqjnDwYpQ4liQJhbbZrYCXcmVMyP+b2vOpR43C0le7JXcFMgzzpekW9s1IvtphnUx/Yj
         UZZzZ4VAKKPshbnjGh8qZBuUiu46mmCE7JSngpHkN2MJ8s2E0k153s4ZTACweV6b/X6l
         dnbA==
X-Gm-Message-State: APjAAAVX4GxVDIq284+ygr8lPwJ0V11Ykbf1UpeAWi1ounVVX0XsMzoB
        Pb3BCz5wdArZcGtwYOysx8Y=
X-Google-Smtp-Source: APXvYqzKzgIgZwOz80DBC8lhUp17PeNmP3M+cq9fY7MrPkFZk2JBqNt3/TuqRc9dO1zOc40b0A716Q==
X-Received: by 2002:a1c:cb05:: with SMTP id b5mr94727wmg.79.1569444580810;
        Wed, 25 Sep 2019 13:49:40 -0700 (PDT)
Received: from localhost.localdomain (99-48-196-88.sta.estpak.ee. [88.196.48.99])
        by smtp.googlemail.com with ESMTPSA id z1sm364705wre.40.2019.09.25.13.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 13:49:40 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Denis Efremov <efremov@linux.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: dvm: excessive if in rs_bt_update_lq()
Date:   Wed, 25 Sep 2019 23:49:35 +0300
Message-Id: <20190925204935.27118-1-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need to check 'priv->bt_ant_couple_ok' twice in
rs_bt_update_lq(). The second check is always true. Thus, the
expression can be simplified.

Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rs.c b/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
index 74229fcb63a9..226165db7dfd 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
@@ -851,7 +851,7 @@ static void rs_bt_update_lq(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 		 * Is there a need to switch between
 		 * full concurrency and 3-wire?
 		 */
-		if (priv->bt_ci_compliance && priv->bt_ant_couple_ok)
+		if (priv->bt_ci_compliance)
 			full_concurrent = true;
 		else
 			full_concurrent = false;
-- 
2.21.0

