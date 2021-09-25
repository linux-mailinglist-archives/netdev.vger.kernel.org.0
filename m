Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FCC7418242
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 15:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245621AbhIYN1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 09:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245591AbhIYN1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 09:27:12 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2EAC061570
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 06:25:37 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id u8so52108769lff.9
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 06:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l58tRXqzKdB7MAdnaHT3OcMQZTQEtALQkUgXblUNQ0M=;
        b=dciIA8OiaRzRMYpy8Xo6wDLagonesv4wTKocpCMMaorSVqT4IVh0JbTtVJwRk9XEXx
         p/ARgE295C1MAOSqRfNaQqjNYnEKo7djgSyDMv7LHqV+FeFdvieoS4uD6kzJ89qpbV0f
         +3FCS+qe02rymYRClR1JwQdvf1+V0DxA0kHDSb4JE38+Yiz6/9tuP68lNbAeymjmUhfU
         y3cZXPoHzU5T2OV+dnTidkpWCkb5V+l5ZPSaZrRf2Gn+KoliIHF6+2sL4uwv3eVuVkGP
         BPPPj6Xipv5FfTbpg3Yn8n5aFwKPkQ7EXyco6rBQ5d4LuYEUy1bHgCn+/IjkJ7XDM2Rs
         CLEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l58tRXqzKdB7MAdnaHT3OcMQZTQEtALQkUgXblUNQ0M=;
        b=n+Dc1WIfJ/rT0PFosNtwdEqhEwOKvk4+zKpMRy9u4Rm2Yn0b3QAuxrNwWbaoY7EfDu
         Ii3xq+OvMFlPMKSGA6jiDfOjIhXCD0hiun6a9sAJv3uGH/TuBit/yPeBcg2OnpNvcpgc
         05JYSmY3BNJiMtpqiAvn7spIidPubrM5by9F50BvEPU6GRMk27iDNUxJSUQVBLUicYph
         8XQvtGv/Owtg55yBZTzGWq/VEV1rxcBCbu1XjCKXoeLb2yO38TQrN5vFF57/MzrQfW1Y
         MVNGAbAOfl1aS2E5cg0zvXOlbDX/upuC0YD+hzw7SvzvrNjivrpSpXcxSPIKv9ZTtME8
         juHA==
X-Gm-Message-State: AOAM530ZJ/tq+jsPNbgPSeDJegVOLg+EMHKxmCIOlh1DzGdWQ9Z+Y4Kg
        TsCjJbyDpX/uHh12rYFjS0KWXw==
X-Google-Smtp-Source: ABdhPJwaNpsKTDONWlv2iUTJmGtqSEAwfo8eQsceKkQsdOjkvFoZYvuWtUgTRUxb01rquqICcRkElA==
X-Received: by 2002:a2e:aa8b:: with SMTP id bj11mr17412295ljb.180.1632576336065;
        Sat, 25 Sep 2021 06:25:36 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id y25sm199590ljj.23.2021.09.25.06.25.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 06:25:35 -0700 (PDT)
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
Subject: [PATCH net-next 5/6 v6] net: dsa: rtl8366: Fix a bug in deleting VLANs
Date:   Sat, 25 Sep 2021 15:23:10 +0200
Message-Id: <20210925132311.2040272-6-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210925132311.2040272-1-linus.walleij@linaro.org>
References: <20210925132311.2040272-1-linus.walleij@linaro.org>
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

Fixes: 4ddcaf1ebb5e ("net: dsa: rtl8366: Properly clear member config")
Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: DENG Qingfang <dqfext@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v5->v6:
- No changes just resending with the rest of the
  patches.
ChangeLog v4->v5:
- Collect Florians review tag
- Add Fixes tag
ChangeLog v1->v4:
- New patch for a bug found while fixing the other issues.
---
 drivers/net/dsa/rtl8366.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index 0672dd56c698..f815cd16ad48 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -374,7 +374,7 @@ int rtl8366_vlan_del(struct dsa_switch *ds, int port,
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

