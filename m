Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93EDC41C367
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 13:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244807AbhI2L1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 07:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244528AbhI2L1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 07:27:08 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EEF4C06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 04:25:26 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id g41so9382752lfv.1
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 04:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=18QIUUZxp5qOvCoDwCvZFa4Ni+X1+Oj0cdvtjpdBJiM=;
        b=ZePE9kwX229auryBnfZKhnes7mFNagvIlxTm15GUEKJbrAKIIOiuGu0cQqGuLW/2XQ
         HqvvtDctccWZZl9cWyyhzXkqiszlSxfTdBNunqOFODcMKABf+ng116fY3HLrQz2PdSD4
         PczMZ3bcHCcr0O5v+6tyfQm1UUIYwyWq5NAg2vRHwn3QFNg1YJCvFvmx2eaVlOEf+Y7L
         zElWMM2hLIJlNqNXGCJD+9n6l4XaKxEr8L+qjdaT85mE20wuzbVeri/UwTZifVg0VXJt
         gBFO0/iHz9EPVTgbwEZYZHd0sfhbL38yhIjFsPgk+UrDqf7SBrTEG+W0xR26HDyunJcL
         tgpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=18QIUUZxp5qOvCoDwCvZFa4Ni+X1+Oj0cdvtjpdBJiM=;
        b=LHawerZ0lQd3r2lC0w8Zlt0bTv8EOxDWgz1yTtcE0HVY7pKAeqlx9jHVfZagIcr0rg
         H1llNRCzfscs2j35nFiBq8nhqZWdZznkczLO92+j8R67aLqABscpqNjb9ERX1JBOEj4t
         G7pVAaBJ3DRHL6lhGigJE9wQs3KECSFELtNeIPlppbeUh4dGdRv5q3X/4VIxIpoBJehx
         Q/7PGRAKn0QMyaIw8piBJEgJb8LmuGsYtAdEE+I5KWbUABvbkuHjIqz+BZBO5MSCa3DD
         DCaMagsCjP2zG0FTz5t0EMjA+U/85I51PNbWnZrTczirgWyuVSHEYbYfn79JULXyLIEP
         u7cA==
X-Gm-Message-State: AOAM531iimnLjYIjoRHOJjJUYkcnd15hwhEQEmxqSBvy8YaYaxd4aRpT
        f6r0ViTyITJG0yfJzLoemQtrrg==
X-Google-Smtp-Source: ABdhPJyeGveaPV5e5qX7NRUBE7tRuRUucI/ggniaYJo+mM81+O4XcbFhkTn5TLr0oCuqro7FlwGVHg==
X-Received: by 2002:a2e:bf18:: with SMTP id c24mr5622371ljr.408.1632914724678;
        Wed, 29 Sep 2021 04:25:24 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id br40sm213293lfb.64.2021.09.29.04.25.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 04:25:24 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH] net: dsa: rtl8366rb: Use core filtering tracking
Date:   Wed, 29 Sep 2021 13:23:22 +0200
Message-Id: <20210929112322.122140-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We added a state variable to track whether a certain port
was VLAN filtering or not, but we can just inquire the DSA
core about this.

Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Cc: DENG Qingfang <dqfext@gmail.com>
Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
Cc: Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
This fixes the diff between patch sets v7 and v8.
---
 drivers/net/dsa/rtl8366rb.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index 6382404814c3..bb9d017c2f9f 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -337,12 +337,10 @@
  * struct rtl8366rb - RTL8366RB-specific data
  * @max_mtu: per-port max MTU setting
  * @pvid_enabled: if PVID is set for respective port
- * @vlan_filtering: if VLAN filtering is enabled for respective port
  */
 struct rtl8366rb {
 	unsigned int max_mtu[RTL8366RB_NUM_PORTS];
 	bool pvid_enabled[RTL8366RB_NUM_PORTS];
-	bool vlan_filtering[RTL8366RB_NUM_PORTS];
 };
 
 static struct rtl8366_mib_counter rtl8366rb_mib_counters[] = {
@@ -1262,12 +1260,9 @@ static int rtl8366rb_vlan_filtering(struct dsa_switch *ds, int port,
 	if (ret)
 		return ret;
 
-	/* Keep track if filtering is enabled on each port */
-	rb->vlan_filtering[port] = vlan_filtering;
-
 	/* If VLAN filtering is enabled and PVID is also enabled, we must
 	 * not drop any untagged or C-tagged frames. If we turn off VLAN
-	 * filtering on a port, we need ti accept any frames.
+	 * filtering on a port, we need to accept any frames.
 	 */
 	if (vlan_filtering)
 		ret = rtl8366rb_drop_untagged(smi, port, !rb->pvid_enabled[port]);
@@ -1512,7 +1507,7 @@ static int rtl8366rb_set_mc_index(struct realtek_smi *smi, int port, int index)
 	 * not drop any untagged or C-tagged frames. Make sure to update the
 	 * filtering setting.
 	 */
-	if (rb->vlan_filtering[port])
+	if (dsa_port_is_vlan_filtering(dsa_to_port(smi->ds, port)))
 		ret = rtl8366rb_drop_untagged(smi, port, !pvid_enabled);
 
 	return ret;
-- 
2.31.1

