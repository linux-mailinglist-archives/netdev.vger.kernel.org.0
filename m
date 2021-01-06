Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 046462EBE55
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 14:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbhAFNLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 08:11:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbhAFNLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 08:11:41 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6690DC061360
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 05:10:34 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id 6so4955391ejz.5
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 05:10:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+tj1XEo4ryLaIi8vmIkKVGmlQ877BVhUerN4i9UMtWk=;
        b=qJXWpJ5Y+TU/l9EO0/IoL3VGL70PynRv5LmXjnfAMcglCfc5t9Wq4d4/zsAZ169qIi
         3gAyD8Hj4+AUrDK3SYm3pq5X0sA2BStuHTnsS7n58cnLBKvsZyyzchs1xdFobM+AY3MT
         5wNe96OcuqK1gbqSZhyfCYCRxL6QS4rvbDcPCM2Evop2XFuuny12dQkH0ui/EMnamvCH
         JTilrc/uwZiOu4XxsVIk1hC93raTm7TACVdP1Bf6qwY/B0bpry3ZP0AuKnHK8OTb/iNz
         z8+B5Zy4DQUZhpRH8R2Hgu0Vfi+GCHKNJ9HHmrLo8hSZ7kK4LSUMDGtbFR4bCbAOXxq8
         /hMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+tj1XEo4ryLaIi8vmIkKVGmlQ877BVhUerN4i9UMtWk=;
        b=rnj7Vkxg8Tvv2d3X+QoNiyrVnf4wBccVyEsytT9gjgs5a9dHjT/HFJvQ1fWR2LjAFq
         Id0gSpRf1H0kIXibzn5R2S9qALNRBLOIv3nFULOfD44dGDOjIJE/FiqvafgMoYAWD621
         vP58X8s/vIn68aij4a6USOuGM/3/IbDVs7thejgfq/11+qTm7P+l7Her06TpDr8/zCBG
         acLthaCwfPRt8560uh/Zdz4KsiJkiRr3XPP9WdzDlbaEzkGbnv/WpUald+ahD8YXZQXm
         fd5f0P+baEvMusKXJLrhBUiQda0OetW1pZOFzrJYjRQP95YZcqw3kdvCL1y3mTF6Q31q
         TcLA==
X-Gm-Message-State: AOAM5336yBPONUjkta76L3Cz3Nu+Uw9MhNZq8VJgIrfrr4DEna7h6umQ
        5x21tgxbRLPd0TjSGfeSd+o=
X-Google-Smtp-Source: ABdhPJz85LSF2R/7GRW8O2dE5HFoycwy+VXp4/myxqjgUJicg5KRNNb+53veIbHdsu8noUkbgqXWQg==
X-Received: by 2002:a17:906:9605:: with SMTP id s5mr2850851ejx.179.1609938633191;
        Wed, 06 Jan 2021 05:10:33 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id p22sm1241858ejx.59.2021.01.06.05.10.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 05:10:32 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v2 net-next 10/10] net: switchdev: delete the transaction object
Date:   Wed,  6 Jan 2021 15:10:06 +0200
Message-Id: <20210106131006.577312-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210106131006.577312-1-olteanv@gmail.com>
References: <20210106131006.577312-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Now that all users of struct switchdev_trans have been modified to do
without it, we can remove this structure and the two helpers to determine
the phase.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Jiri Pirko <jiri@nvidia.com>
---
Changes in v2:
None.

 include/net/switchdev.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index f873e2c5e125..88fcac140966 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -16,20 +16,6 @@
 #define SWITCHDEV_F_SKIP_EOPNOTSUPP	BIT(1)
 #define SWITCHDEV_F_DEFER		BIT(2)
 
-struct switchdev_trans {
-	bool ph_prepare;
-};
-
-static inline bool switchdev_trans_ph_prepare(struct switchdev_trans *trans)
-{
-	return trans && trans->ph_prepare;
-}
-
-static inline bool switchdev_trans_ph_commit(struct switchdev_trans *trans)
-{
-	return trans && !trans->ph_prepare;
-}
-
 enum switchdev_attr_id {
 	SWITCHDEV_ATTR_ID_UNDEFINED,
 	SWITCHDEV_ATTR_ID_PORT_STP_STATE,
-- 
2.25.1

