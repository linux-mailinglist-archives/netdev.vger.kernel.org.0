Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2F1409768
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 17:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239310AbhIMPfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 11:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240150AbhIMPf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 11:35:29 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3465DC12C759
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 07:45:44 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id g1so10172854lfj.12
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 07:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q6DknvnoVKlTPBFZkTxYtBHHlx7PNAbFfx/QOOMrkiY=;
        b=tz76PsDPS/GBTheceLTNvLVr1mWNVaT16nZlLvPlXVgnkDFqIv0CRujkHgmMQPPxIO
         ADACAfjP4v4fYePWjCNR2759Sxum4IO7vudVpR8z7fiEj+iVHcYLyiAal0l42PfS4z2Q
         J9aJBii6/ixwr0B85V0wOaHTjvdILL01NucMUUtkEYHYlB6rp+Dw/fYr80LYmILqQDts
         C9SZIC06RFSX+2SaxOxte5ILdj9yqcHuZJELqyV5CxqdYcDXHwZ5MjD6XyB7wC0BTHqh
         afINBfIzNIBogLAXh4V0fPC/Ego2y+Fj/xjICOEDplt2sMHt+nxxehD0bbBS7W7Aawqx
         eg1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q6DknvnoVKlTPBFZkTxYtBHHlx7PNAbFfx/QOOMrkiY=;
        b=PQcZ7mD2S3qvWAxteDWrLQDywGu3VewQGmB90gNFv0EdvwCoNV7skkyDF77oYh3Us+
         RZ4wi4bGEj2Fx92kjKJGLcaBCv7eny52A90vDLwEXkjiZkSWOZ+PH649wqjS8OnjzWey
         bV3bXkh3r7brr+p+8Mom3pWP4xkJa43eTtz/DYYqU4tK/vf9fd+rktCFKHtkNEVrFScu
         FKWoBXSa6MQ99dBdjnlmePWmg6a1RTku2XZjYz6k6/LIzVTWbFjKHaxicG+sJ9WTtkIu
         vahZ/5wskoN5Zvv2i704sDsqv1e9/dXNUQGcjRB/Ucx500QUrQs3hYR/ZJ9Di+nbEveN
         Nbmw==
X-Gm-Message-State: AOAM532+VOOC9IeO4C5bkx8JUnVKgzqSNTz1cezEO3SCvaIaV7m99A7o
        DFmhzmzphS8eMVEjuJaQEknqVQ==
X-Google-Smtp-Source: ABdhPJx0mZrAeTM5vvsM0PTWilljt9AhbMGzJay8x22RXWh4x6YxUfcrqSv1M3YW28rv98h0IDElbA==
X-Received: by 2002:a05:6512:982:: with SMTP id w2mr9642502lft.112.1631544342603;
        Mon, 13 Sep 2021 07:45:42 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id i12sm849825lfb.301.2021.09.13.07.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 07:45:42 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Mauri Sandberg <sandberg@mailfence.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH net-next 7/8] net: dsa: rtl8366: Fix a bug in deleting VLANs
Date:   Mon, 13 Sep 2021 16:42:59 +0200
Message-Id: <20210913144300.1265143-8-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913144300.1265143-1-linus.walleij@linaro.org>
References: <20210913144300.1265143-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We were checking that the MC (member config) was != 0
for some reason, all we need to check is that the config
has no ports, i.e. no members. Then it can be recycled.
This must be some misunderstanding.

Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: DENG Qingfang <dqfext@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v4:
- New patch for a bug found while fixing the other issues.
---
 drivers/net/dsa/rtl8366.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index 9652323167c2..fd725cfa18e7 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -381,7 +381,7 @@ int rtl8366_vlan_del(struct dsa_switch *ds, int port,
 			 * anymore then clear the whole member
 			 * config so it can be reused.
 			 */
-			if (!vlanmc.member && vlanmc.untag) {
+			if (!vlanmc.member) {
 				vlanmc.vid = 0;
 				vlanmc.priority = 0;
 				vlanmc.fid = 0;
-- 
2.31.1

