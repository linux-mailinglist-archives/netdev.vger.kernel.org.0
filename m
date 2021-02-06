Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44F67311D1E
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 13:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbhBFMaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 07:30:17 -0500
Received: from mail-wr1-f48.google.com ([209.85.221.48]:36240 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbhBFMaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 07:30:15 -0500
Received: by mail-wr1-f48.google.com with SMTP id u14so10908872wri.3;
        Sat, 06 Feb 2021 04:29:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6g1k3SFhjqedu/1j0b61HvZBLCKR46ltwlIl3YSgDVs=;
        b=kJyFjC4ifKlm2J3k86DX1qpo4G01vDsPW2vsDU1O1l/7zwVKtW+NZlrf1DVfZ2hlO1
         yPSRdLC7MYCxLY1fSKi1jx8IRjU0c9A4SqdDaQFxOGaYM/C2pe5KH5FT8W1264SB19Ty
         ALJUXvzEy898u+2u3Yb3VD+UZfQtPkkRi5DavqfF4llh2pnCRMeLj+bxWliAWv+2dDER
         0xqFfiYLvwwTagPZC6c51tAwoffD7AqX2IB3M8cHCxoBXV1pE8lxc4GXYg/AlzctmoBy
         8DzMKjwDyWlas4MHme/NwwhKqqwvC6m8KwhYAusWwnyfQ95gAjLXJhSCvNgRdlWmn3IO
         AQSg==
X-Gm-Message-State: AOAM532aXlF3JJXj+EkTsYrktyw7Zfk6HV3nYJiitVz+odvLsHWmfUpb
        JQfpEoW6cd8b/PLE1TBv3QN++mEFybY=
X-Google-Smtp-Source: ABdhPJxtXSt1RXtUx7YNMJ1Ljd6FDrlsdjfB9lgkpbRfzOXYcKtV51Y8G9umCp4Sr3+WYWVUrjcjAg==
X-Received: by 2002:a5d:58fa:: with SMTP id f26mr10283772wrd.33.1612614573407;
        Sat, 06 Feb 2021 04:29:33 -0800 (PST)
Received: from msft-t490s.teknoraver.net (net-2-36-203-239.cust.vodafonedsl.it. [2.36.203.239])
        by smtp.gmail.com with ESMTPSA id c11sm15421697wrs.28.2021.02.06.04.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Feb 2021 04:29:32 -0800 (PST)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] cfg80211: remove unused callback
Date:   Sat,  6 Feb 2021 13:29:20 +0100
Message-Id: <20210206122920.3210-1-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

The ieee80211 class registers a callback which actually does nothing.
Given that the callback is optional, and all its accesses are protected
by a NULL check, remove it entirely.

Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 net/wireless/sysfs.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/net/wireless/sysfs.c b/net/wireless/sysfs.c
index 3ac1f48195d2..41cb4d565149 100644
--- a/net/wireless/sysfs.c
+++ b/net/wireless/sysfs.c
@@ -81,12 +81,6 @@ static void wiphy_dev_release(struct device *dev)
 	cfg80211_dev_free(rdev);
 }
 
-static int wiphy_uevent(struct device *dev, struct kobj_uevent_env *env)
-{
-	/* TODO, we probably need stuff here */
-	return 0;
-}
-
 #ifdef CONFIG_PM_SLEEP
 static void cfg80211_leave_all(struct cfg80211_registered_device *rdev)
 {
@@ -157,7 +151,6 @@ struct class ieee80211_class = {
 	.owner = THIS_MODULE,
 	.dev_release = wiphy_dev_release,
 	.dev_groups = ieee80211_groups,
-	.dev_uevent = wiphy_uevent,
 	.pm = WIPHY_PM_OPS,
 	.ns_type = &net_ns_type_operations,
 	.namespace = wiphy_namespace,
-- 
2.29.2

