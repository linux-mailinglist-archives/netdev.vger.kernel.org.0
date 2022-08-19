Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8167F59A836
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 00:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240096AbiHSWQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 18:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239874AbiHSWQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 18:16:32 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE2F5C2769
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 15:16:26 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-334d894afd8so97425217b3.19
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 15:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=UEHQVTWtY0L8HbB+rn9ayHruCFvSoeqhTJ8tjVlmltk=;
        b=G2nd61G3YUXzDJ7SOy7p3Qqr78Kti/oBcRHEJCvFPJ3XR67+EfeAz3oL+KH6MiVRbY
         tLUHabNGnrIIu/MfxR4qQjPz24fIMblKNFZui8waxypli1TuNkLNz+vRl9fxaPQ0Z2mZ
         kotKh+3b3CwBEck2dyzgBfVi+g1q/BV2925Smv0NJgFjQxyQE1jla7m1Qc6Nu/f/+dEa
         628Q1guJzowvfMIdGpOI1HmNMERryzw6kIihBEIUyZFMUi0tR+z6oh4WLK5HxmENqGNM
         cZ0WdQebFYvYsjOqxNxer8SRsCzQkHMxVRG88otL5Sve16E+Z/V+pPWfso0/qJYZNTy7
         SFXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=UEHQVTWtY0L8HbB+rn9ayHruCFvSoeqhTJ8tjVlmltk=;
        b=IKxSR3dQbdsN/zV+icgIEsNRDLqYrbx2GDpzG/yailGVc7JqC9e30SIMk0OPkNfYh/
         KShUgZs4y8DZXE62e2UI3f30JK3Jxd9NzFgzRbvf/F7o7HIJt+wZyCxnZVB8FZLT1hKO
         nSwVKxAXsx8JDZBsUEIKkdpebNTV4BVAKAp9pyoNAQ5GCq+nBrs23mSoNOhUXpoYd/De
         Ru717J2G2w2xVYEVVLv+vmUXTSmaJuhDPkGOxW2fL0odin0rmA0H3ZNw0KtC1hdWxTiz
         g/bf1HcGqzkKK+F9qUnAkGtSftmAOwkl5vIiM/jSByRAsNtqdHsdjazYH3K/5VHkCgYL
         T6Vw==
X-Gm-Message-State: ACgBeo3mtdRNFQ3GVsB6iMhAniEakYvAwH+g89ppEpc7jA7r6z6mhhOY
        GvHoXZYyHF3TSIFqyXeBktwk7F4ij+cT2P4=
X-Google-Smtp-Source: AA6agR638n52xQqz9XIsj65fwvEuV9sSup7NrBB1J1/XruxyVUcUJ+K5sX7kFFdZ7d5G3+DvuVzyrAmwjsqUwv8=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:f93e:7b61:ce3d:5b06])
 (user=saravanak job=sendgmr) by 2002:a81:83c5:0:b0:334:a89b:1e5d with SMTP id
 t188-20020a8183c5000000b00334a89b1e5dmr9134295ywf.178.1660947385806; Fri, 19
 Aug 2022 15:16:25 -0700 (PDT)
Date:   Fri, 19 Aug 2022 15:16:12 -0700
In-Reply-To: <20220819221616.2107893-1-saravanak@google.com>
Message-Id: <20220819221616.2107893-3-saravanak@google.com>
Mime-Version: 1.0
References: <20220819221616.2107893-1-saravanak@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v2 2/4] Revert "net: mdio: Delete usage of driver_deferred_probe_check_state()"
From:   Saravana Kannan <saravanak@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saravana Kannan <saravanak@google.com>
Cc:     Peng Fan <peng.fan@nxp.com>, Luca Weiss <luca.weiss@fairphone.com>,
        Doug Anderson <dianders@chromium.org>,
        Colin Foster <colin.foster@in-advantage.com>,
        Tony Lindgren <tony@atomide.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jean-Philippe Brucker <jpb@kernel.org>,
        kernel-team@android.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, iommu@lists.linux.dev,
        netdev@vger.kernel.org
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

This reverts commit f8217275b57aa48d98cc42051c2aac34152718d6.

There are a few more issues to fix that have been reported in the thread
for the original series [1]. We'll need to fix those before this will work.
So, revert it for now.

[1] - https://lore.kernel.org/lkml/CAMuHMdWo_wRwV-i_iyTxVnEsf3Th9GBAG+wxUQMQGnw1t2ijTg@mail.gmail.com/

Fixes: f8217275b57a ("net: mdio: Delete usage of driver_deferred_probe_check_state()")
Reviewed-by: Tony Lindgren <tony@atomide.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Saravana Kannan <saravanak@google.com>
---
 drivers/net/mdio/fwnode_mdio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 3e79c2c51929..1c1584fca632 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -47,7 +47,9 @@ int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
 	 * just fall back to poll mode
 	 */
 	if (rc == -EPROBE_DEFER)
-		rc = -ENODEV;
+		rc = driver_deferred_probe_check_state(&phy->mdio.dev);
+	if (rc == -EPROBE_DEFER)
+		return rc;
 
 	if (rc > 0) {
 		phy->irq = rc;
-- 
2.37.1.595.g718a3a8f04-goog

