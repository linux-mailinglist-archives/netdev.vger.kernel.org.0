Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC94418517
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 01:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbhIYXDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 19:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbhIYXDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 19:03:31 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A10BC061570
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 16:01:56 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id g41so57391050lfv.1
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 16:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i0sY75wD5swGSqNDlKhqp58pnTCdqC44xbx+KZQkxwI=;
        b=XJDyVlEvQtS3bTaTYnHTNV+c/AP+9HBH4i4eW/2ugIV6KB4vvSIhBtpHFweXxanl4b
         MEY4t0++ZrUugHlqkTOe3AHLDr34WK/vZVxS7qrAyE6QLQJ42edFlkqfh4J9Iwzem/q9
         QuugkwMkVsfuXSUWu0NwsWv2VqP6AdYWip1guzDfvdFtjV4/Q6RUatInvVCldzvKHZuZ
         E2aVHU669MHvQ7hg7+RGLQwT3jKXvERB3CtrIwCPCq0CGteCrBEjHB/xKCTAX6BHRY2K
         8qm2/R6KJJICDaTNNbAhow5t3+1CnIluwzfVzz5hboMbuAxOEoby+RbEQ4aMXRqUEJ9O
         fXeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i0sY75wD5swGSqNDlKhqp58pnTCdqC44xbx+KZQkxwI=;
        b=v/k8debNIXxPG+2HcgzEdhTQPasXl6pnvnuxq2Rwf6pYsg7jTFI/fS028BF4cCG6X3
         3SybET1aegDPZWy9Qm7NA3q59OnPhfXCHXqR0hJEMkqtEcMXLyDf/Ki+sCALg8uT8XWh
         +7ixd3PBudq6WwF6fMChRyI4N/hjOpm2rUheH3Wa/PU74Ccfw6Cv48oGJRYZJj97XUrp
         L/4/LWBF2gk97x9R25rQrfNZujjHDfo/OcPRQt2K8KTMkTynmo4RyTs37MoFF1UoBkk2
         WWCteGPAdULhk9JTxhadxjdEVtNm5Cr4R6A3aWvAnLzxrB3yY5FIgnOq7lqRtWzDcab+
         SXAw==
X-Gm-Message-State: AOAM530tJArGKlouM/gNg1SPOCqohCxTIkjnayiosJWRFsyQJdLk2Ab5
        9dseMawZGkhDiQcBw3nRPLSfow==
X-Google-Smtp-Source: ABdhPJzehdRrXXeZ+XuhINSGDCSKhAO4l9M71XMN/AOGfcNKaGla594dBUUrfNmrBh+JUiafyxG1Sg==
X-Received: by 2002:a05:6512:3f1b:: with SMTP id y27mr14388488lfa.606.1632610914838;
        Sat, 25 Sep 2021 16:01:54 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id d27sm1448111ljo.119.2021.09.25.16.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 16:01:54 -0700 (PDT)
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
Subject: [PATCH net-next 4/6 v7] net: dsa: rtl8366rb: Fix off-by-one bug
Date:   Sun, 26 Sep 2021 00:59:27 +0200
Message-Id: <20210925225929.2082046-5-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210925225929.2082046-1-linus.walleij@linaro.org>
References: <20210925225929.2082046-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The max VLAN number with non-4K VLAN activated is 15, and the
range is 0..15. Not 16.

The impact should be low since we by default have 4K VLAN and
thus have 4095 VLANs to play with in this switch. There will
not be a problem unless the code is rewritten to only use
16 VLANs.

Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
Cc: Mauri Sandberg <sandberg@mailfence.com>
Cc: DENG Qingfang <dqfext@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v6->v7:
- Collect Alvin's and Vladimir's review tags.
ChangeLog v5->v6:
- No changes just resending with the rest of the
  patches.
ChangeLog v4->v5:
- Add some more text describing that this is not a critical bug.
- Add Fixes tag
ChangeLog v1->v4:
- New patch for a bug discovered when fixing the other issues.
---
 drivers/net/dsa/rtl8366rb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index 01d794f94156..6382404814c3 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -1520,7 +1520,7 @@ static int rtl8366rb_set_mc_index(struct realtek_smi *smi, int port, int index)
 
 static bool rtl8366rb_is_vlan_valid(struct realtek_smi *smi, unsigned int vlan)
 {
-	unsigned int max = RTL8366RB_NUM_VLANS;
+	unsigned int max = RTL8366RB_NUM_VLANS - 1;
 
 	if (smi->vlan4k_enabled)
 		max = RTL8366RB_NUM_VIDS - 1;
-- 
2.31.1

