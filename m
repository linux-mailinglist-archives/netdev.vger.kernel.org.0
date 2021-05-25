Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE61B39068A
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 18:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbhEYQYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 12:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233054AbhEYQX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 12:23:58 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711ABC061574
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 09:22:27 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id f75-20020a1c1f4e0000b0290171001e7329so13158222wmf.1
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 09:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=EaNus8elNxGQWpW+u3l9Yb+mvE18u9+6KaHWxo/CPrY=;
        b=EcY0/ZeYD2qVQlutHNxIx+1/Cgmi1hTBz/1nPMrCtPdkJf+Ujt0KE9Jh6uk5b+XAxL
         RtVALqIwwvVGfejzN7E1J70Ke+3xmYwlzKFPh/spwRZ1A78gi42ivduIpHNxT4aQyRUM
         ctUCK/EMSlQRI2q+E4v7zrnzx/+S/aB1QAI9B+VJ5MxmPwj+kzAqyRgLpqgTR7G8SrX0
         mw+bprex708kuEX1MH2vEHn3ne/n4z+HThN9tWacuCGaKcYc5L4dnwC5QhlORH8coqKH
         OBJeiofDCCLtyjsDazBG/AHKLhWO6o2IMHt6xZrFQ0TTzVIJHkDODUQtt0VbgdeVKR+n
         AS6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=EaNus8elNxGQWpW+u3l9Yb+mvE18u9+6KaHWxo/CPrY=;
        b=C+m/j1VpOPOwlnPty+kxMvwB5LUf1+rR13KygM7QnA3wOxY1zCWXKP0lLO3l6Bc+d3
         aotvkRwp3Ffc4vOJo1cmz6mZ4ZmJ181frh7vqDykD6xEvr08JQGtEgACJkFBEq989VkZ
         vEeyb3u+/bBj0TX/scuRC5eBamBIx3XE/GRRmkqEXaL5JFjnnR9GhaOcGqcaemYB86pv
         r2jamvAyzwh0EPCyIM6CvFAEUIDrjJfGobLz/sMQfY4XyhgKiBNeqzLdbbyZhH2O/QUx
         Z6bIqJF+TlV2k0GOo3st7/xw5XsQcmqyZReAjRHj5o2GNbCmeZzmXcv14TjfJ6cogKkF
         dAEw==
X-Gm-Message-State: AOAM530+wTiZqIsFvu5neWZj1G+hpyb74+YGfxpdtAqgrNlQcsAg98H9
        3GYX1bbW1NBAaq2/S+bjvkY3rE8flWhA9Q==
X-Google-Smtp-Source: ABdhPJyptRrgBxwSxeSQxbIqdIxmXD9BZ8PWhSSx5dE8LLpMuKV+Eh/LTxEIAoKZ+O4DtFyIZoZRxQ==
X-Received: by 2002:a7b:c3d4:: with SMTP id t20mr24053094wmj.13.1621959745898;
        Tue, 25 May 2021 09:22:25 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:d5ad:807c:5350:bb5a])
        by smtp.gmail.com with ESMTPSA id s2sm1893631wmc.21.2021.05.25.09.22.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 May 2021 09:22:25 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, m.chetan.kumar@intel.com,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next] net: wwan: core: Add WWAN device index sysfs attribute
Date:   Tue, 25 May 2021 18:31:18 +0200
Message-Id: <1621960278-7924-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add index sysfs attribute for WWAN devices. This index is used to
uniquely indentify and reference a WWAN device. 'index' is the
attribute name that other device classes use (wireless, v4l2-dev,
rfkill, etc...).

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/wwan/wwan_core.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 92a8a6f..6e8f19c 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -63,6 +63,20 @@ struct wwan_port {
 	wait_queue_head_t waitqueue;
 };
 
+static ssize_t index_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct wwan_device *wwan = to_wwan_dev(dev);
+
+	return sprintf(buf, "%d\n", wwan->id);
+}
+static DEVICE_ATTR_RO(index);
+
+static struct attribute *wwan_dev_attrs[] = {
+	&dev_attr_index.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(wwan_dev);
+
 static void wwan_dev_destroy(struct device *dev)
 {
 	struct wwan_device *wwandev = to_wwan_dev(dev);
@@ -74,6 +88,7 @@ static void wwan_dev_destroy(struct device *dev)
 static const struct device_type wwan_dev_type = {
 	.name    = "wwan_dev",
 	.release = wwan_dev_destroy,
+	.groups = wwan_dev_groups,
 };
 
 static int wwan_dev_parent_match(struct device *dev, const void *parent)
-- 
2.7.4

