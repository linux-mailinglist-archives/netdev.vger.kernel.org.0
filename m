Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C13311FC6
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 20:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhBFTsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 14:48:37 -0500
Received: from mail-wr1-f43.google.com ([209.85.221.43]:34795 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhBFTsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 14:48:35 -0500
Received: by mail-wr1-f43.google.com with SMTP id g10so12067391wrx.1;
        Sat, 06 Feb 2021 11:48:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6g1k3SFhjqedu/1j0b61HvZBLCKR46ltwlIl3YSgDVs=;
        b=lm0Slv6cxbRa+N26dRL+glQ93BzL7Z+5h/+5NgLLSn9kzh6eP8Ztpe/bZ5XJi6EseT
         +WTz1gIumMfwTBSFxx/ZKA0+mEZa2O6mpCtXjyhqBVXcbkYSSh3fLiHRTVrIP+zGjHr8
         XlElhQGEuIWIh5jRK4AfSoyg0zY/32hZeX6Fn1UdqdXgicI40Ai0WVGxmVyhTkBPar3h
         a6Q8DkD1moVuu+uRD4D2hzG8oC0Tj+iLJ2bIf6MC732yN4iM6SHBkucYpP0GRPol2An8
         N4pWYW0WaeLFffTcba+OoEngzYfMHBCGfDMBd4BBQmuC0uNdQLJo4p3+xNvUEiE+e/bi
         KNHw==
X-Gm-Message-State: AOAM531c+rEygXvCn9RekLOadIi3XhF5ay0GimWSxkB6Zo7g7i6G3WEa
        y1sPy7FB//iWtlm+CF5zalLCLjQQUxE=
X-Google-Smtp-Source: ABdhPJwQ2AN7lgHQDkpa5Sp6smR+vnQUcixsh7mmlxuWdUuCMxxwWuV3Smn6d7BvchunugEHEwBzvg==
X-Received: by 2002:a05:6000:1082:: with SMTP id y2mr11107594wrw.27.1612640873008;
        Sat, 06 Feb 2021 11:47:53 -0800 (PST)
Received: from msft-t490s.teknoraver.net (net-2-36-203-239.cust.vodafonedsl.it. [2.36.203.239])
        by smtp.gmail.com with ESMTPSA id e10sm16922915wro.65.2021.02.06.11.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Feb 2021 11:47:52 -0800 (PST)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH RESEND net-next] cfg80211: remove unused callback
Date:   Sat,  6 Feb 2021 20:47:47 +0100
Message-Id: <20210206194747.11086-1-mcroce@linux.microsoft.com>
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

