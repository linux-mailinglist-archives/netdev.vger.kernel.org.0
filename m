Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E304666CE03
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 18:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbjAPRxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 12:53:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233853AbjAPRwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 12:52:39 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B003B653
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 09:35:04 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id c3so807812ljh.1
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 09:35:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t7F9JKouL1KurTO0QVKHN8g/5zAESWUg12UOdA+LKsI=;
        b=E3DYP0epTmdQaBr8PG3Lc8mLskVrmA2L1g1uosAju1bFb9Zd1/cbdiapQ5fFkaSZWK
         o6rwyTvWmoqnqO3GQ/PewcCOeU0+EVt2OCdA60ZsN2J+CeH1ab2BXc3aMXbO3uUsfHzx
         qv2fyovh8SRghPRZL80Urm0MOg9l7NaqDEA9Wj0/szZhsXkat75oRTQwgH4S2taaVfvI
         ye2rM+2rYjemoac3jVmVgsJM7q93qCrMpk1DijXEctb18ivK5LdNH+j1ll+sZnNopfVw
         p5jf7bQUsXQ7jDJbMKnRbGzaygpSujEZUXF/8g/SGPq88bZcs42LLCGQMTgOI04QcHju
         UK2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t7F9JKouL1KurTO0QVKHN8g/5zAESWUg12UOdA+LKsI=;
        b=Wwl4p8wur8T+tbYz6hocpLwwBT2biKcBvg+kVzcmMp8RBOjButCQe8tIG2JUhSfYhI
         fIjKqMWIOKr+BMg7/rqpqZVN0deKHA8AprYCfM9V3T7BT2m6mydBxhb+U9cwIUwuWcRM
         GTPT0kXge+XFwONII9P3crpvnvx0PKCx1LlxbotO+clTaxBi6psvmnUC8/5JSateeXnn
         +Od64Cd5sGfDOmXZzNDl62hw91DIw5KQaidf3TRxsBdYSe8PAOhFb/xSWf7cWfwI1fMk
         PSOghuyIq89E9zcAQqpxQsz1hdls7qNJs3IQW96QhpN2qspAtpjr4CvbJMo8VT4YqLuW
         8ghA==
X-Gm-Message-State: AFqh2krVMbwUnrBMpbg3v7zUWEKs8YfHp/iRu8CJHRowgfKTHXIZqv2N
        5WTxtxqhGYsbGWr3Ty1VoJPh0g==
X-Google-Smtp-Source: AMrXdXuUnMtiRTBXJ6Nfs4XBmV3kM8wxIrl3j8mU01006aaUz85HcnPiZoQhJ+bNzRNdkZ6kmD/RtQ==
X-Received: by 2002:a2e:90c7:0:b0:28b:77ce:f88b with SMTP id o7-20020a2e90c7000000b0028b77cef88bmr180131ljg.8.1673890504000;
        Mon, 16 Jan 2023 09:35:04 -0800 (PST)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id k20-20020a2e8894000000b0028b7f51414fsm707333lji.80.2023.01.16.09.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 09:35:03 -0800 (PST)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     rafael@kernel.org, andriy.shevchenko@linux.intel.com,
        sean.wang@mediatek.com, Landen.Chao@mediatek.com,
        linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, hkallweit1@gmail.com, mw@semihalf.com,
        jaz@semihalf.com, tn@semihalf.com, Samer.El-Haj-Mahmoud@arm.com
Subject: [net-next: PATCH v4 5/8] device property: introduce fwnode_find_parent_dev_match
Date:   Mon, 16 Jan 2023 18:34:17 +0100
Message-Id: <20230116173420.1278704-6-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20230116173420.1278704-1-mw@semihalf.com>
References: <20230116173420.1278704-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new generic routine fwnode_find_parent_dev_match that can be used
e.g. as a callback for class_find_device(). It searches for the struct
device corresponding to a struct fwnode_handle by iterating over device
and its parents.

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 include/linux/property.h |  1 +
 drivers/base/property.c  | 23 ++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/linux/property.h b/include/linux/property.h
index 37179e3abad5..4ae20d7c5103 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -109,6 +109,7 @@ struct device *fwnode_get_next_parent_dev(struct fwnode_handle *fwnode);
 unsigned int fwnode_count_parents(const struct fwnode_handle *fwn);
 struct fwnode_handle *fwnode_get_nth_parent(struct fwnode_handle *fwn,
 					    unsigned int depth);
+int fwnode_find_parent_dev_match(struct device *dev, const void *data);
 bool fwnode_is_ancestor_of(struct fwnode_handle *ancestor, struct fwnode_handle *child);
 struct fwnode_handle *fwnode_get_next_child_node(
 	const struct fwnode_handle *fwnode, struct fwnode_handle *child);
diff --git a/drivers/base/property.c b/drivers/base/property.c
index bbb3e499ff4a..84849d4934cc 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -693,6 +693,29 @@ struct fwnode_handle *fwnode_get_nth_parent(struct fwnode_handle *fwnode,
 }
 EXPORT_SYMBOL_GPL(fwnode_get_nth_parent);
 
+/**
+ * fwnode_find_parent_dev_match - look for a device matching the struct fwnode_handle
+ * @dev: the struct device to initiate the search
+ * @data: pointer passed for comparison
+ *
+ * Looks up the device structure corresponding with the fwnode by iterating
+ * over @dev and its parents.
+ * The routine can be used e.g. as a callback for class_find_device().
+ *
+ * Returns: %1 - match is found
+ *          %0 - match not found
+ */
+int fwnode_find_parent_dev_match(struct device *dev, const void *data)
+{
+	for (; dev; dev = dev->parent) {
+		if (device_match_fwnode(dev, data))
+			return 1;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fwnode_find_parent_dev_match);
+
 /**
  * fwnode_is_ancestor_of - Test if @ancestor is ancestor of @child
  * @ancestor: Firmware which is tested for being an ancestor
-- 
2.29.0

