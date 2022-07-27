Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4475558205D
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 08:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbiG0GpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 02:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiG0GoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 02:44:09 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008A440BF6
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:43:47 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id bf9so25649560lfb.13
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AZnXgTWAmHAAkiH1J3eS3SuupS7jjAspolqgIKE9W3w=;
        b=If2TkJ8pMmsyfyfVuwa7SGbtltDAMjKUSVBgzQ482CqXgjwCPUCroLSM7qOdjNGVBM
         TNPjT8ZkVwGNKL8KCbhck1+9MDMX3E+ZB9bZ8Ln7FDo9IGAf+bVsd8o9PoPr32469aVn
         Cm/v5Ya0yA901PbzfwGPaBZu1hX69UpO9iriYZ+vuUP1/N2EQZDVthkd/lZz6qmy7kdC
         9ipfZGbD+lPMZJHPkZzgG9NW9Kp8WjNVjbtxD6hE8Ydrdg8lJ/ykf2UZWKlRb20T0ygH
         jsYPNiKVscbNdWaUugzaY1V4gawVPKOtbCC8ivNzlCzf4g6mZFqhTvWM/gttpgL4BB9Q
         10tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AZnXgTWAmHAAkiH1J3eS3SuupS7jjAspolqgIKE9W3w=;
        b=HXEKmr9xvmVot8GAQr4skUtUYGNDzVVBsR4yrZOAm0uqkB0HBr+pCe38iZLykpioXL
         ejKGlyLYmxUe3CmW/wyWSJ/19nvpchSg+/3Z7PxuOQsM4S7fBqXpTJK5KN6S0trftPGm
         Tof3gKTVLPEUUAOx1IsGZr0B+RIuxexAZRR6uhzFgJF7tJpMHOqxUUHXzWajtWyWswdO
         oHY42d8GKBLcDqJMozfziqjUh3FLLnxs9oL+Cpno6Rhlai98JXFWcR8WwYO4TRdxk3H8
         /tYxKmXORyUbCdoERPyjytx22f3cMuAt75E9jmrg/TwrEuXqZlrricdCVL2ATlMkgd9g
         K2UQ==
X-Gm-Message-State: AJIora/RMKDKnSXZlyUaLhkLW38+jj+YSBML6KgeuroTS04SBOZLISwj
        wHiJyiwPTmfc43pbVtKXRrKXCg==
X-Google-Smtp-Source: AGRyM1ulVcNyJ4rwZ+4mPHuX4JlRF3Mn/mt8yKy6C/OG/KII/LeRx1Z9arhrE35NZl54VBFs1Azx0g==
X-Received: by 2002:a05:6512:602:b0:48a:8278:52da with SMTP id b2-20020a056512060200b0048a827852damr6096896lfe.257.1658904226137;
        Tue, 26 Jul 2022 23:43:46 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id w19-20020a05651234d300b0048a97a1df02sm1157231lfr.6.2022.07.26.23.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 23:43:45 -0700 (PDT)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     rafael@kernel.org, andriy.shevchenko@linux.intel.com,
        sean.wang@mediatek.com, Landen.Chao@mediatek.com,
        linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, hkallweit1@gmail.com, gjb@semihalf.com,
        mw@semihalf.com, jaz@semihalf.com, tn@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, upstream@semihalf.com
Subject: [net-next: PATCH v3 5/8] device property: introduce fwnode_find_parent_dev_match
Date:   Wed, 27 Jul 2022 08:43:18 +0200
Message-Id: <20220727064321.2953971-6-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20220727064321.2953971-1-mw@semihalf.com>
References: <20220727064321.2953971-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a new generic routine fwnode_find_parent_dev_match
that can be used e.g. as a callback for class_find_device().
It searches for the struct device corresponding to a
struct fwnode_handle by iterating over device and
its parents.

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 include/linux/property.h |  1 +
 drivers/base/property.c  | 23 ++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/linux/property.h b/include/linux/property.h
index a5b429d623f6..829254a5ae63 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -95,6 +95,7 @@ struct device *fwnode_get_next_parent_dev(struct fwnode_handle *fwnode);
 unsigned int fwnode_count_parents(const struct fwnode_handle *fwn);
 struct fwnode_handle *fwnode_get_nth_parent(struct fwnode_handle *fwn,
 					    unsigned int depth);
+int fwnode_find_parent_dev_match(struct device *dev, const void *data);
 bool fwnode_is_ancestor_of(struct fwnode_handle *ancestor, struct fwnode_handle *child);
 struct fwnode_handle *fwnode_get_next_child_node(
 	const struct fwnode_handle *fwnode, struct fwnode_handle *child);
diff --git a/drivers/base/property.c b/drivers/base/property.c
index ed6f449f8e5c..ee6a8144f103 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -685,6 +685,29 @@ struct fwnode_handle *fwnode_get_nth_parent(struct fwnode_handle *fwnode,
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

