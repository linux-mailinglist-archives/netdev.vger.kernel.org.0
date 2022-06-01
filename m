Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE7B7539DD3
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 09:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350139AbiFAHHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 03:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350111AbiFAHHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 03:07:39 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F15B8CB3F
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 00:07:29 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id s66-20020a252c45000000b0065ca728881bso709607ybs.14
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 00:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=eS/2TM+GfDlfIh94cuHfgXIohxcqeVLl/51vayxOGcM=;
        b=nEbS5SUQKPV2uEuRcyqOCeYxkIcVm6QtbRuafH1IWgffM/UiSk4n7jieCoUxjX9Oaq
         WdF2MZAjtTV+A+oRtPcrP2vyYILJP7A+Sg3USDA4WMYh1mFqe4FUjmEsa0guT0E1V4tj
         CRvpIOw9ggRCgKvj+BCr2MskAML9dPYYf+XO0/d9/Xj9Uc/+LTk7YMR8wiug+nW8uluL
         vowkrv4PAa7gy873wiXvd7t6in/QuT1Qpd5KLLyCXllUZoQDqvWM1KUKzksMRYWJwumF
         +1QzKxLzBi0hg9GJrGLwC8SMCfssBQpKzUmvRevuplmTStk4Ali/UF0v2Vw1hH1Gn3Yl
         JBDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=eS/2TM+GfDlfIh94cuHfgXIohxcqeVLl/51vayxOGcM=;
        b=XqyTfPlIcohu1WF2qo9/alYwFkb11FLiUnoYh3bFCb3y19U6g3rT1YjQSvSbFZax6k
         2KGck0oslhvSpQkRzm9dYpQTn0nkjH+i7wfZWQ5O3CUENo0ae1Yt1HMw9YstMLffL+nY
         Bb/AyfmP/MDiXJ8viKirNq7jYck3hVHnLsTkfSpS3R1extj8MmcQCT46Atb1JHUDYAqE
         59UsEnNaut4h+EYh+tagbX0xVYFWBKb8Pe0wSu+gqqv8nNpBMS29XgpTN8bC0hsFp9KN
         byYW/JxaMMHIkfULfpsJa+gH/iOHHYviXY/9Fht+bLxqsgl6ae27HbbNDZiYq6in04iu
         k8PQ==
X-Gm-Message-State: AOAM533KLIscZrx1pL2qRYQvncd1mfZKm/8mkJ8G4+975rkXecPkJygy
        5IrJS4qSR3e0Mw1oDhFK9bvqkWPCCTxEe7E=
X-Google-Smtp-Source: ABdhPJwtAnnXhJAd8leQI7IsJQYpPEGmerba49yF9GJ2QPuTWzcc40IB9+ccBefvJrVmInskP9rGOF8g1cQWJjY=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:f3aa:cafe:c20a:e136])
 (user=saravanak job=sendgmr) by 2002:a81:ac67:0:b0:30c:4692:77fd with SMTP id
 z39-20020a81ac67000000b0030c469277fdmr16106442ywj.180.1654067249191; Wed, 01
 Jun 2022 00:07:29 -0700 (PDT)
Date:   Wed,  1 Jun 2022 00:07:02 -0700
In-Reply-To: <20220601070707.3946847-1-saravanak@google.com>
Message-Id: <20220601070707.3946847-7-saravanak@google.com>
Mime-Version: 1.0
References: <20220601070707.3946847-1-saravanak@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 6/9] Revert "driver core: Set default deferred_probe_timeout
 back to 0."
From:   Saravana Kannan <saravanak@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     Saravana Kannan <saravanak@google.com>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 11f7e7ef553b6b93ac1aa74a3c2011b9cc8aeb61.

Let's take another shot at getting deferred_probe_timeout=10 to work.

Signed-off-by: Saravana Kannan <saravanak@google.com>
---
 drivers/base/dd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 4a55fbb7e0da..335e71d3a618 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -256,7 +256,12 @@ static int deferred_devs_show(struct seq_file *s, void *data)
 }
 DEFINE_SHOW_ATTRIBUTE(deferred_devs);
 
+#ifdef CONFIG_MODULES
+int driver_deferred_probe_timeout = 10;
+#else
 int driver_deferred_probe_timeout;
+#endif
+
 EXPORT_SYMBOL_GPL(driver_deferred_probe_timeout);
 
 static int __init deferred_probe_timeout_setup(char *str)
-- 
2.36.1.255.ge46751e96f-goog

