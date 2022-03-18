Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 710504DE239
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 21:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240656AbiCRUPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 16:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240597AbiCRUPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 16:15:41 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0276225C58E
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 13:14:01 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id w7so15774433lfd.6
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 13:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=f6gea0UG9jF1oSbEYIKOlY6k/1X2Ig9+3aPWLWMPbTs=;
        b=qW/8IFYanN7dg2cRHPnA7zIPpJrXbVuhw18VcKSZEZ1dsDD8MWoglqFCf9fjr8Tp0e
         rc6SbupQj6ePG68aNTApxmOLXCaLoxefPnejYjP9QVLKON0V93rqsf1P9XJXqkK6mAhF
         /4rx6Z5F+pnoH7nd5v8Kwjyh+/NaaClc0waQ9FwR07O+JcU7p4EfO+G9Od+yJd3HxCCY
         e/oFCl5ylO2jm372mQqiA7mX847cqn2EhbSkDqGLxdJyc+y+BLAIvMMphtDivNRoBm1F
         yTREk/hp1jY0klZQjmfTQdclkd4lElmh7N/oTF4lSK5x0ENgsinvubiV7xaSoVFZ7UZ/
         NlgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=f6gea0UG9jF1oSbEYIKOlY6k/1X2Ig9+3aPWLWMPbTs=;
        b=3tqhw72+zMPl9aoyVFtQvi92ALvDYgYkzIk7Go4OQOsQlaz6zzsFcstq+UjrrM/mHK
         i5WMKKkrFT70BYFJi360/8xHm+ZLwxkR7Ji3Esw8Xxps98sW/+y16LG6EgcK8Q4vfLzq
         LTFffQbyBPMCyeeKi9msiJkQQeQiyXZEm62UrYFDb73wV3alXLV2PTsSDOEHudhsKiz5
         KWMH2KYhLAG6GcnAq80aKIy8Ogn+Ik2hqtnvoLKkwweCbaxTPz8Rbb2pTRgf4M4L/K6W
         EOoePeuUKk6xAyshh/W1oucvjEN+EvzpPS//HTTeFRhmrJ88P1NAUxRUdKr7RS3s0wOT
         z+hQ==
X-Gm-Message-State: AOAM532gnUh7iWD9Ay1cNUsRG4N3vYa9brM2q4quEEcaS4Z7sg7au/hH
        wzi+5Mi6ggQGRyjFJopH4fO+zQ==
X-Google-Smtp-Source: ABdhPJxsMgi1afxkpBpYy8ig1qY/KutmgQgFJnK1vP49Krrid3LqS1GwMkq9UFX7Cetlwa4A+whZCw==
X-Received: by 2002:a05:6512:39cd:b0:44a:cd5:e5e6 with SMTP id k13-20020a05651239cd00b0044a0cd5e5e6mr2466427lfu.574.1647634438845;
        Fri, 18 Mar 2022 13:13:58 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id u6-20020a197906000000b00448a5b9d066sm981692lfc.189.2022.03.18.13.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 13:13:58 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Marek Behun <kabel@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] net: dsa: mv88e6xxx: Ensure STU support in VLAN MSTI callback
Date:   Fri, 18 Mar 2022 21:13:21 +0100
Message-Id: <20220318201321.4010543-3-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220318201321.4010543-1-tobias@waldekranz.com>
References: <20220318201321.4010543-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the same way that we check for STU support in the MST state
callback, we should also verify it before trying to change a VLANs
MSTI membership.

Fixes: acaf4d2e36b3 ("net: dsa: mv88e6xxx: MST Offloading")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index b36393ba6d49..afb9417ffca0 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2678,6 +2678,9 @@ static int mv88e6xxx_vlan_msti_set(struct dsa_switch *ds,
 	u8 old_sid, new_sid;
 	int err;
 
+	if (!mv88e6xxx_has_stu(chip))
+		return -EOPNOTSUPP;
+
 	mv88e6xxx_reg_lock(chip);
 
 	err = mv88e6xxx_vtu_get(chip, msti->vid, &vlan);
-- 
2.25.1

