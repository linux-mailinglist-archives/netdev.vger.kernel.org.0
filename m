Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C11C50334A
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 07:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237504AbiDOXdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 19:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356521AbiDOXc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 19:32:58 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5664434A5;
        Fri, 15 Apr 2022 16:30:27 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id z99so11418599ede.5;
        Fri, 15 Apr 2022 16:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=QPfpEFZ8aXDfQbxEKJbQpBAkzVCysTDwHsga4YqOSIU=;
        b=QISmEUBnclB/8FoC/OJH0P0MIX1gd+Q5qbkwA0HU4NLGZmHpKQep1CtSmP+uc8xVa0
         +uvYQDcyKnDvQS0/Vtc1H8Gg+CiNqf/SpCj7Il/6580gnakyDJHkpMpJ3is/eI45AFOl
         C1kmOr6/7c0OMYqMIu67uA2m0fEVezN/KGFfYmxIpoCXYkbjGSZS3jKAW4cHJUIml8Hw
         HDVIYPLh+AxYqZcqFWBdGbXtLAupl+h8/aFEA6bNmsnGA7Hj0vFrRyn+d5GdxqJG0klr
         YOkoh/3JlUF/bFXiqdi460KZCbeabFsRMV1ME2lSlRNvg7kzOcmgo6zCeUBYCRIqQGwh
         AMPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QPfpEFZ8aXDfQbxEKJbQpBAkzVCysTDwHsga4YqOSIU=;
        b=XHwLXg4ZDmBB6Cmx412SgkffvVjBod8MBuzlo/dW63ZOdFdR0M4pL6TpgmXTsZtHKJ
         pZMDR0spc1xTDL5VT5Ai2OSu9gotyeWjbAH2GqWrtMBUYEydx2QJhvBMjsMT/2NBomCd
         q1E/2tcJf4F1hfmGoHW5GcgbKYVVVNM2j0GCBNA8DNOYtk3B4i3dyKllXc8C0acXHTUD
         wfZQW8ZhaXCoIBn8dUXeeuXIFQ9Pz26saAR7/IGB05acHxuznVSAi6LgLb1zqwxsj0id
         9jEWeB7LYpIe0KuY3ngw7dS9GT7kcK9+SjxxjRufQ0eVtBrPeUcHrTgaPc0HhDOf9BP9
         fb2w==
X-Gm-Message-State: AOAM530qzL0lTjoC+haN2sJFPt4cGrTfHLL88cjKv85XViUvb6pIOgLE
        ojnQVDca1oRRYg/Wk50r7jI=
X-Google-Smtp-Source: ABdhPJyDSnRt33zQXhpordsy/GhKN6dmBG8R2b/yv9Bg+Cu5t4p4d54mONj3Shzct4xfhJbqou6E0Q==
X-Received: by 2002:a05:6402:51cf:b0:419:63e2:2b96 with SMTP id r15-20020a05640251cf00b0041963e22b96mr1410938edd.336.1650065426148;
        Fri, 15 Apr 2022 16:30:26 -0700 (PDT)
Received: from localhost.localdomain (host-79-33-253-62.retail.telecomitalia.it. [79.33.253.62])
        by smtp.googlemail.com with ESMTPSA id z21-20020a1709063a1500b006da6436819dsm2114588eje.173.2022.04.15.16.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 16:30:25 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [net-next PATCH v3 5/6] net: dsa: qca8k: correctly handle mdio read error
Date:   Sat, 16 Apr 2022 01:30:16 +0200
Message-Id: <20220415233017.23275-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220415233017.23275-1-ansuelsmth@gmail.com>
References: <20220415233017.23275-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Restore original way to handle mdio read error by returning 0xffff.
This was wrongly changed when the internal_mdio_read was introduced,
now that both legacy and internal use the same function, make sure that
they behave the same way.

Fixes: ce062a0adbfe ("net: dsa: qca8k: fix kernel panic with legacy mdio mapping")
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index ef8d686de609..4fb1486795c4 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1287,7 +1287,12 @@ qca8k_internal_mdio_read(struct mii_bus *slave_bus, int phy, int regnum)
 	if (ret >= 0)
 		return ret;
 
-	return qca8k_mdio_read(priv, phy, regnum);
+	ret = qca8k_mdio_read(priv, phy, regnum);
+
+	if (ret < 0)
+		return 0xffff;
+
+	return ret;
 }
 
 static int
-- 
2.34.1

