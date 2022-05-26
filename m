Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D5F534B5D
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 10:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346668AbiEZIQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 04:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346658AbiEZIQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 04:16:10 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5981BBA9A9
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 01:16:06 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id t14-20020a65608e000000b003fa321e8ea3so533869pgu.18
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 01:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BAxCptwO7y2xVPn5yxfUXuZaiLDAgG5VdQuxNau2t/A=;
        b=SSAklAtF5M2MvdVlYodbyAxTphyyK02Oj42SVcd3FTLXmUoOWmKohwP0jyuy7Dywnn
         z+Rwg5B5m390JADA/tH9Kd5hrRor7L7xc2HarYOOY1eeh0X5ooFq6gop9u+FKPEH68sX
         PSmyWhcvNVI+KSAsfLsiJwAoZy4hoOLroAWm7/PcoZRZ5RRn7c5QPkSzY4al45bC9y1m
         rxt4J+H9awRoebh/t2rs9NdCgcDLPVKf5pbTahtHh4OEILiQvhD1Izdrf/nBW5LrZ6Hr
         cCTqNUjkmGwlDPIsIOZy6KsBLIleiDr0kGVZMU24uQyWpnq1xNF84jdZo+Qvww3Nq5FM
         6uTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BAxCptwO7y2xVPn5yxfUXuZaiLDAgG5VdQuxNau2t/A=;
        b=ZQ3UseidMqVG0R2ZrK3VcKaVB0HWEtL2yw22ROWFUPSzgBN2OUj1FY0utILdkA020J
         3O+CRpfCylbrWOKC1zyZ1M9vnNDKRAb7mRZmBxpCBvGDILlqokCtCC6c1QA++rIw8X8w
         P2CCvPNGx/SactP99cP/qvXGRtwVhP26Ju51Y78QOzCkqKgmbPhP66uGu2qqByVZvsgz
         1RAVa4hXdC0jtAOVxgJIm9QPKl3nCoz+nejurKcSraRF2LMWPddMjZtmiHHuavgm/OEz
         7/j1qLLZvG1y19jT2YGvL50h3h7+fRxjv/Bsj4m/Te7bzeu9Rvc5zUcYYrRSW1G2cakO
         9ErQ==
X-Gm-Message-State: AOAM5317yZ5VJFrAnnNu81U+jzMqqaX4jkKkuts2C1JrCkULOfysoBhx
        k1UyflzQG9G2/EjbLMpBlio3TimPTqspxNo=
X-Google-Smtp-Source: ABdhPJz4snZQEDVmZXj6RODHXR7rp3pbTlyyKgm6WM3ongSTDnEvvxBi0qJKrzgY36D1YxzBeGXt+A93QwpkuHs=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:ff1f:a3b7:b6de:d30f])
 (user=saravanak job=sendgmr) by 2002:a17:902:b58f:b0:15e:b2f4:b75 with SMTP
 id a15-20020a170902b58f00b0015eb2f40b75mr37115965pls.25.1653552965291; Thu,
 26 May 2022 01:16:05 -0700 (PDT)
Date:   Thu, 26 May 2022 01:15:43 -0700
In-Reply-To: <20220526081550.1089805-1-saravanak@google.com>
Message-Id: <20220526081550.1089805-5-saravanak@google.com>
Mime-Version: 1.0
References: <20220526081550.1089805-1-saravanak@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [RFC PATCH v1 4/9] Revert "driver core: Set default
 deferred_probe_timeout back to 0."
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
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     Saravana Kannan <saravanak@google.com>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        John Stultz <jstultz@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kernel-team@android.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, iommu@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
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
index 11b0fb6414d3..f963d9010d7f 100644
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
2.36.1.124.g0e6072fb45-goog

