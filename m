Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D59C45A6C3
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 16:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236744AbhKWPs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 10:48:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236257AbhKWPs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 10:48:26 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8035C061574;
        Tue, 23 Nov 2021 07:45:17 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id y13so93826947edd.13;
        Tue, 23 Nov 2021 07:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ij04fNOkXgioJw97U+iulLRX+rqwFDSnPQZPSWJRbPc=;
        b=nTY3sn6sQcSOZnVnMySRStBq+xZIx9+RGPnjX/mcu46Ix3cpdB6c08K3xlBrHsrSJ7
         DYe1KR2N0XMQLGnElDOEOUobmS8Dye5IRN46ItKDkHB3AAd4Z/TltDv/oEeQVsOzhtN3
         ewdLfF2hlC6mtjhGptu8qLPq/kYq8mi58J7UUzP7bGIF/SoAtmqKHupQX/Xc57xhZCvw
         93oLvuj9RZTC+fS0YolRE3Sy4uCKz0t6oFCCdhheLYs0xZGdKexyZu8Tqt3pYNO/e1bQ
         Ctxwcb/6pBTdcRKZpM7bTsVHeTibs1JxIBKwsMAtLoLonumnvkhGaHu81knfiQ+HoBig
         EShA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ij04fNOkXgioJw97U+iulLRX+rqwFDSnPQZPSWJRbPc=;
        b=2GoE4EOsj8rzF+/4cNxW6ujoTYjE/T9YAW+KBRPtmhOi0K/J0hDMbusY7h434swEhO
         Vc53gL+eoK70e+/upCp8qYIsVuFTSiiDUPkwK+0iILJVi7jnj/93P9zJ92N9FwbKuQq+
         aJ36PgStCBXpIkoitiVk8q2kGdOABSgwi0cHYqJ9/QFzBqDqXS/oLxRGfozH4gJAetx8
         XJye8FqY7PBqTC/I++w3X1bdm6k9AchnLmmw/xz5smQyZimSPzRGjLU/AUT0vtdUGSVl
         yaz/wgXpZZT1JuOxURZpbZLZ6035mXCdKdyhPHr1gnJAwZnRbQvjRJKJZlYajn3o/rfG
         ORyA==
X-Gm-Message-State: AOAM530YVXSpknXZsyIsRvskoY2FhoKLc6lwNBLgkT+9TzD0GnaN9Eks
        mWKRa7XwNPyduNWZybQdTmQ=
X-Google-Smtp-Source: ABdhPJy26UECaALCGkv0TFvScMeWIZT0+XZ/+vMqzTb5n1UOX5LE0v26nV7aDVe+n1RWUN/DU6qQHA==
X-Received: by 2002:a05:6402:124e:: with SMTP id l14mr10736119edw.74.1637682316188;
        Tue, 23 Nov 2021 07:45:16 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id hr11sm5633254ejc.108.2021.11.23.07.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 07:45:15 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        kernel test robot <lkp@intel.com>
Subject: [net-next PATCH] net: dsa: qca8k: fix warning in LAG feature
Date:   Tue, 23 Nov 2021 16:44:46 +0100
Message-Id: <20211123154446.31019-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix warning reported by bot.
Make sure hash is init to 0 and fix wrong logic for hash_type in
qca8k_lag_can_offload.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 6516df08a5d5..d04b25eca250 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -2228,7 +2228,7 @@ qca8k_lag_can_offload(struct dsa_switch *ds,
 	if (info->tx_type != NETDEV_LAG_TX_TYPE_HASH)
 		return false;
 
-	if (info->hash_type != NETDEV_LAG_HASH_L2 ||
+	if (info->hash_type != NETDEV_LAG_HASH_L2 &&
 	    info->hash_type != NETDEV_LAG_HASH_L23)
 		return false;
 
@@ -2242,8 +2242,8 @@ qca8k_lag_setup_hash(struct dsa_switch *ds,
 {
 	struct qca8k_priv *priv = ds->priv;
 	bool unique_lag = true;
+	u32 hash = 0;
 	int i, id;
-	u32 hash;
 
 	id = dsa_lag_id(ds->dst, lag);
 
-- 
2.32.0

