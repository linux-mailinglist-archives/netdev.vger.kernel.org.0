Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B478583316
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 21:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236130AbiG0TJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 15:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236892AbiG0TJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 15:09:18 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253E1691E2
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 11:50:27 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id m5-20020a2598c5000000b0066faab590c5so13800925ybo.7
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 11:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BEk69dNG70BOHgb0SXLFWzzFpDyu+7tq1YolDhZdyzE=;
        b=B7uDYX/Cr97zFSRCvB7/fn1gKg5skiOo3orS627VXpMcYo8QEZ7oIrvYBjLdXKLvyw
         oxhx2F1iCRsyE1gIZ2hQTPsAZ46+3sYZ0ox/pMmaN1heCLPhTeZtrSP1HwOFBi+LY5w+
         O36Puictr1H9b2lkfo4jRR0Mo/xQr3nN7QsINYg+iKLGVrHaFtsRNdO2iKXWdHOJB+yI
         aOHHjRJdiN1hTtvuovOpKu1BWxPbokvLEXrXizIHGlzJb61Z0JET3FdTJLeRJ+YjUkgx
         ZtsTrJIP/RTGLKgls6kpdVgkFafVspj0h5Ad++NOeAflXkUYcUYlzfpi2vBLdxNvt1Jf
         7KOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BEk69dNG70BOHgb0SXLFWzzFpDyu+7tq1YolDhZdyzE=;
        b=N+T46Akz0jk7ypNTosySWiPw2CIJHev6X3iKkuULNC6ur1D3J0An7qkxMYEvQ7rZH2
         59srEOlP3uQOxVxRMwKKS+OdCeyVxgaEBVyjPDepvFr6ppMQxVv8L2puBi9Nz6WvYzfd
         EFTGD29ncz8LfWQp3i9QjhkXoKehf52jrbYint0C4HUUML/cCGm5ZiRZu1Dm0fOOUrLn
         bwIqL1rg+5mo7V9i+fNNM4Yjef+QZj7TEsKCU6vXARaPrAj6PAu/wqpsK16TE+9t+ViG
         gk7688V3LH0O6dbLTD49jjYREE1PA5Usxk11viu2m9lWzeP8FCRwCgI6DGiYVEF9mNHc
         No3A==
X-Gm-Message-State: AJIora+hkdMfNbsSCF5QwzokgimkG+uVrSYjT1lmOuqI7rDd12yTeyD6
        AcSvn+F/gi6G2LhKeFVGJxu/d2QaLyVwYSg=
X-Google-Smtp-Source: AGRyM1vBbGCvhJnuNcqNxmyfgvBqU63X92ObJ+fmmE6nsBM1EgRJPhCmvWH4pzIt7pOBmOkC8sjtqMGkHE01FH0=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:40ee:bae0:a4fd:c75b])
 (user=saravanak job=sendgmr) by 2002:a5b:502:0:b0:66e:206d:15f6 with SMTP id
 o2-20020a5b0502000000b0066e206d15f6mr18796823ybp.160.1658947826888; Wed, 27
 Jul 2022 11:50:26 -0700 (PDT)
Date:   Wed, 27 Jul 2022 11:50:11 -0700
In-Reply-To: <20220727185012.3255200-1-saravanak@google.com>
Message-Id: <20220727185012.3255200-4-saravanak@google.com>
Mime-Version: 1.0
References: <20220727185012.3255200-1-saravanak@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v1 3/3] Revert "PM: domains: Delete usage of driver_deferred_probe_check_state()"
From:   Saravana Kannan <saravanak@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Saravana Kannan <saravanak@google.com>, naresh.kamboju@linaro.org,
        kernel-team@android.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 5a46079a96451cfb15e4f5f01f73f7ba24ef851a.

There are a few more issues to fix that have been reported in the thread
for the original series [1]. We'll need to fix those before this will
work. So, revert it for now.

[1] - https://lore.kernel.org/lkml/20220601070707.3946847-1-saravanak@google.com/

Signed-off-by: Saravana Kannan <saravanak@google.com>
---
 drivers/base/power/domain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index 3e86772d5fac..739e52cd4aba 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -2730,7 +2730,7 @@ static int __genpd_dev_pm_attach(struct device *dev, struct device *base_dev,
 		mutex_unlock(&gpd_list_lock);
 		dev_dbg(dev, "%s() failed to find PM domain: %ld\n",
 			__func__, PTR_ERR(pd));
-		return -ENODEV;
+		return driver_deferred_probe_check_state(base_dev);
 	}
 
 	dev_dbg(dev, "adding to PM domain %s\n", pd->name);
-- 
2.37.1.359.gd136c6c3e2-goog

