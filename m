Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B15C1B90BE
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 15:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbfITNhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 09:37:20 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:33039 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727337AbfITNhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 09:37:20 -0400
Received: by mail-lf1-f65.google.com with SMTP id y127so5115160lfc.0;
        Fri, 20 Sep 2019 06:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jphzEcSkNncyQXURXy+bMvvSOETA08+BxHJ5z57Bb0M=;
        b=EfzMViMon0Yh012SQYg8h4xK0JFPuLUGf8hs1IklN8um4D/H4ReoSmHw3ok0fVz8wA
         ydZvJ9tblvpBVSh29a7WTqMk9IUdC3G8y9/FfinNiNstDyifALTmZzkCRw7WiQEDaBrp
         tRPJSKJCOj20Ei4e4kXUkdfi2HXwME57FgKE9QNgJHDSK8qBFcZji5mW9Ij/uxtduAZo
         bGYtLMXFiX6MzgLcHcy3BF2pOpnaIKYVsZO9Jf/uwXkNZLuL5kN4x94Vjyk1r6GTg2c/
         4U/y8/xo6DFTzBND9j9hKecItPSbnprkm0n3ZA+qqKYjSERd+JQepKHJRit1HW1zH9nA
         nDiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jphzEcSkNncyQXURXy+bMvvSOETA08+BxHJ5z57Bb0M=;
        b=iJOCnr5lz1gkSRcRxPmbHH1rDOb0BE9i9cysJIGB/azly/JMkzsnZ5FmbU0r8ug2z9
         V6FgerQ0cuCgc4Hl6A5oVmLw8p8W8i6ddFHIlkFTBVKOmxiNd4wsTxPtukOReyMvCSPN
         LNS5JIKSZdGmuO/Vg/FuyfIQPNojcK3yoIGqpp2r4wL/l9w0SGR+MxBHmkoB5pKC3sFg
         YV+w8ONTVKMzZjyC+Zr5YH8eVpD/D1G7FiyXr1cA+j7pxq3ZVWyycOnNzr1Rflcqjdt9
         hiA/iWOj2EkbiHICFuD3TwfXSPU0ltfc2nhV2gnxL1PgjQIQ157by/WKR5VfPngzA4mr
         xUig==
X-Gm-Message-State: APjAAAWWaFQ/LqJFRHcbOlR0j1El/zTwZH8WQB2xJMI3f5Bay0kvWM8H
        6Z/ldJ9Drp+r44OXy1awC0w=
X-Google-Smtp-Source: APXvYqxlzmxdYLzOPpcInVQyKgAS4zc777/kdZlRsQ6Gg/ppqj9M7QdxbhVc99mR+kWGcY6bb23LnQ==
X-Received: by 2002:a19:4347:: with SMTP id m7mr8570675lfj.146.1568986637463;
        Fri, 20 Sep 2019 06:37:17 -0700 (PDT)
Received: from localhost.localdomain (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id b25sm475423ljj.36.2019.09.20.06.37.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Sep 2019 06:37:15 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jouni Malinen <j@w1.fi>,
        hostap@lists.infradead.org, openwrt-devel@lists.openwrt.org
Cc:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH RFC] cfg80211: add new command for reporting wiphy crashes
Date:   Fri, 20 Sep 2019 15:37:08 +0200
Message-Id: <20190920133708.15313-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

Hardware or firmware instability may result in unusable wiphy. In such
cases usually a hardware reset is needed. To allow a full recovery
kernel has to indicate problem to the user space.

This new nl80211 command lets user space known wiphy has crashed and has
been just recovered. When applicable it should result in supplicant or
authenticator reconfiguring all interfaces.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
I'd like to use this new cfg80211_crash_report() in brcmfmac after a
successful recovery from a FullMAC firmware crash.

Later on I'd like to modify hostapd to reconfigure wiphy using a
previously used setup.

I'm OpenWrt developer & user and I got annoyed by my devices not auto
recovering after various failures. There are things I cannot fix (hw
failures or closed fw crashes) but I still expect my devices to get
back to operational state as soon as possible on their own.
---
 include/net/cfg80211.h       |  7 +++++++
 include/uapi/linux/nl80211.h |  2 ++
 net/wireless/nl80211.c       | 29 +++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ff45c3e1abff..668fa27c88cc 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -7437,6 +7437,13 @@ void cfg80211_pmsr_complete(struct wireless_dev *wdev,
 bool cfg80211_iftype_allowed(struct wiphy *wiphy, enum nl80211_iftype iftype,
 			     bool is_4addr, u8 check_swif);
 
+/**
+ * cfg80211_crash_report - report crashed wiphy that requires a setup
+ *
+ * @wiphy: the wiphy
+ * @gfp: allocation flags
+ */
+void cfg80211_crash_report(struct wiphy *wiphy, gfp_t gfp);
 
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index beee59c831a7..9e17feb03849 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1325,6 +1325,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_PROBE_MESH_LINK,
 
+	NL80211_CMD_CRASH_REPORT,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d21b1581a665..d29785fb0676 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -16940,6 +16940,35 @@ void cfg80211_update_owe_info_event(struct net_device *netdev,
 }
 EXPORT_SYMBOL(cfg80211_update_owe_info_event);
 
+void cfg80211_crash_report(struct wiphy *wiphy, gfp_t gfp)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_CRASH_REPORT);
+	if (!hdr)
+		goto nla_put_failure;
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx))
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
+
+	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy), msg, 0,
+				NL80211_MCGRP_CONFIG, gfp);
+
+	return;
+
+nla_put_failure:
+	nlmsg_free(msg);
+}
+EXPORT_SYMBOL(cfg80211_crash_report);
+
 /* initialisation/exit functions */
 
 int __init nl80211_init(void)
-- 
2.21.0

