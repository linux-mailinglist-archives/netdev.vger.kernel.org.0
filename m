Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC51D4DE23A
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 21:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240646AbiCRUPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 16:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240592AbiCRUPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 16:15:40 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0335257182
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 13:13:59 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id w27so15782377lfa.5
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 13:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=2ZJOcMdF9DzKhm/fJPtO5SnzEXwErjJt/hDqOg/WJc8=;
        b=QOuIyvnAaXQP5F1WRGC8O0VbHEQ6gEp7fwi4Kyi4BjZU9CZ3BFN1LyzSSNPJBJVD8a
         1bvdNXsu22C5CmQwoU/uxH5NWI9pDMeRqwKAjDMVsrZjZhG63VI+rj+AbE8QKF2+uUQG
         p2fGH7u3d0nKSH64QzIUu3+kv23y51fADm/ZAk/hZEKBlB9VycnSUKfAxFY/vpq78+p5
         WniHtM7hLcf49bP2/QEZHtnB53KfDnqoB+rOdkM0kRSvrpXdDHPEHS5dwPxqRVqnjTY0
         7riCR6Gi854YvhKDNEIZp6UWGXEUVQ+J4wIAM8vs4KA7MIqh7Y3R8Nuyvi6HZ0OQV5Vz
         o0WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=2ZJOcMdF9DzKhm/fJPtO5SnzEXwErjJt/hDqOg/WJc8=;
        b=rGhSRhOstqTxksyVWUaCxzWADBljg00kvXaKmZkFtCgdONfbLg/0gbVgKX6JkWFaqg
         QFiHl57Br1S93/1sRI5bFVBGQn7M7HIH3WkXD8OwchocFEt/QJJ51U1GmehHuhtM+G/e
         dYvUTdmKlcAFhfcjh1qHaFVtWb90NCn037PHOOUaQNKA09ThGbqzLg5Islas3icmSxcN
         0QVBmD7CLzWeP8iA0hVTC1xsp/vlHuKJboBHj2izOwcS9PcSCLZgh4fihQKCwqg4aSl9
         6pwrfbvIimufLP4uqa0aVws1cFOeIV0GqUoPQ1WMDtDRGp2deJorwkQ1+GRnglhSgQu0
         veKQ==
X-Gm-Message-State: AOAM530yTp6WN9INVCCazVjF5hrIpIgmPISzBz38n2FuT3LatwtfO0YO
        9U7SsUNMl5RNDZuaw/XEAtWjNA==
X-Google-Smtp-Source: ABdhPJztr619VArVriWnwc6+AAMRU1IiL9Xq0Pl/tdAkr2QE+P5FseUm70/ioo9yeIlMftrrjdVhUA==
X-Received: by 2002:a19:f115:0:b0:448:277f:8e with SMTP id p21-20020a19f115000000b00448277f008emr6798140lfh.503.1647634437698;
        Fri, 18 Mar 2022 13:13:57 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id u6-20020a197906000000b00448a5b9d066sm981692lfc.189.2022.03.18.13.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 13:13:57 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] net: dsa: mv88e6xxx: Require ops be implemented to claim STU support
Date:   Fri, 18 Mar 2022 21:13:20 +0100
Message-Id: <20220318201321.4010543-2-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220318201321.4010543-1-tobias@waldekranz.com>
References: <20220318201321.4010543-1-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Westermo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simply having a physical STU table in the device doesn't do us any
good if there's no implementation of the relevant ops to access that
table. So ensure that chips that claim STU support can also talk to
the hardware.

This fixes an issue where chips that had a their ->info->max_sid
set (due to their family membership), but no implementation (due to
their chip-specific ops struct) would fail to probe.

Fixes: 49c98c1dc7d9 ("net: dsa: mv88e6xxx: Disentangle STU from VTU")
Reported-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/chip.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 6a0b66354e1d..5e03cfe50156 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -730,7 +730,9 @@ struct mv88e6xxx_hw_stat {
 
 static inline bool mv88e6xxx_has_stu(struct mv88e6xxx_chip *chip)
 {
-	return chip->info->max_sid > 0;
+	return chip->info->max_sid > 0 &&
+		chip->info->ops->stu_loadpurge &&
+		chip->info->ops->stu_getnext;
 }
 
 static inline bool mv88e6xxx_has_pvt(struct mv88e6xxx_chip *chip)
-- 
2.25.1

