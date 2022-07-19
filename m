Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A31579F77
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 15:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239602AbiGSNUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 09:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243757AbiGSNTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 09:19:36 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C059C9088;
        Tue, 19 Jul 2022 05:36:30 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id ay11-20020a05600c1e0b00b003a3013da120so9874032wmb.5;
        Tue, 19 Jul 2022 05:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FfVB0Ls9OHYS9xIHYyqXiXhrpeb/G/aaLlwnUyTVJA8=;
        b=XOTBaMeaGi+WzNAxZBg9C4y6yOUXU/B2acZDPMK3PMCUgFXxDfObqQoxTFPJajNRKB
         XxUUiugJgfbyTA/uqIvUm1c/BwsYAinZYaqy4EKOzHNPkIvj9gSklnewYIZgnJ82JE+3
         O+U2gyzft6k6fbWrMisDuuQCVehEFLY9wkAQ3SB50m8daSXF3dxL6Yn27yry80FciP/H
         ERUI9nctkeGCj+OaFAM2TaZ38qhL4wzqndwM+AvCnTofPd+ML7TRDuTK6wtAByGEAtju
         9gxUzJOYGaoriqQxo10aiK4meSuunbHW0cXIAc6cyl/EeKIrF/VmLfsf17LJT5jEsXi4
         D6sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FfVB0Ls9OHYS9xIHYyqXiXhrpeb/G/aaLlwnUyTVJA8=;
        b=SQvYvZAI1X7pBgehabQg6Rjl8EVykv0bi2Ra2XGjCt2vToQDgNW531xe1/lY3bxYtc
         Ua6kS3Tvk97SwhGZ6A7yj6phdXAU1UzguLaADX20G6bNSa4EBpqI+03TL4o5UnUdF3Ci
         1Vv3PBmaSNio+vh2i0iZ7LlJGowRmVVRob34zUL25WGmkDt/XvcbGuSWlOWM8THf5puh
         awnVOG16npE9YcuTPH4yELVKe+gSP4ZZIC9GGRQty+A2oC7eq5iNzPeDQRRn2joL86fx
         jBqWZcuBxKQMQt92aBeoxReyUzujtwu32kQo/9rcyzwADiY1VDfNWNdpq5pYDq5TURP/
         rX2A==
X-Gm-Message-State: AJIora8MIoprAtFGw0oNGn31q3R3CWTQT8+Me2r/EQ1wKjfR+6riD4Vv
        m4LQwSekLlJTxPV7d1HqqVM=
X-Google-Smtp-Source: AGRyM1tIXn8RcsbRF7l5mXmB4tuxIzJwsRdnhqt1OUt66TC/zLf9o78m70gcpfvOTI6vZrAIIBFGAw==
X-Received: by 2002:a05:600c:21d4:b0:3a3:10a0:cc4f with SMTP id x20-20020a05600c21d400b003a310a0cc4fmr17442769wmj.75.1658234188822;
        Tue, 19 Jul 2022 05:36:28 -0700 (PDT)
Received: from baligh-ThinkCentre-M720q.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.googlemail.com with ESMTPSA id bp30-20020a5d5a9e000000b0021e297d6850sm3337522wrb.110.2022.07.19.05.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 05:36:28 -0700 (PDT)
From:   Baligh Gasmi <gasmibal@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Linus Lussing <linus.luessing@c0d3.blue>,
        Kalle Valo <kvalo@kernel.org>,
        Baligh Gasmi <gasmibal@gmail.com>
Subject: [RFC/RFT v5 4/4] mac80211: extend channel info with average busy time.
Date:   Tue, 19 Jul 2022 14:35:25 +0200
Message-Id: <20220719123525.3448926-5-gasmibal@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719123525.3448926-1-gasmibal@gmail.com>
References: <20220719123525.3448926-1-gasmibal@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the average busy time of the channel in the nl80211.

Signed-off-by: Baligh Gasmi <gasmibal@gmail.com>
---
 include/net/cfg80211.h       | 1 +
 include/uapi/linux/nl80211.h | 2 ++
 net/mac80211/cfg.c           | 8 ++++++++
 net/wireless/nl80211.c       | 6 ++++++
 4 files changed, 17 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 80f41446b1f0..38bafcaf3446 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4494,6 +4494,7 @@ struct cfg80211_ops {
 				struct cfg80211_fils_aad *fils_aad);
 	int	(*set_radar_background)(struct wiphy *wiphy,
 					struct cfg80211_chan_def *chandef);
+	int     (*get_avg_busy_time)(struct wiphy *wiphy, struct net_device *dev);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index d9490e3062a7..4e625f656bd6 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3177,6 +3177,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_DISABLE_EHT,
 
+	NL80211_ATTR_WIPHY_AVG_BUSY_TIME,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 4ddf297f40f2..21a9d0b37ff5 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -4536,6 +4536,13 @@ ieee80211_set_radar_background(struct wiphy *wiphy,
 	return local->ops->set_radar_background(&local->hw, chandef);
 }
 
+static int ieee80211_get_avg_busy_time(struct wiphy *wiphy,
+				       struct net_device *dev)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	return ewma_avg_busy_read(&sdata->avg_busy);
+}
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -4641,4 +4648,5 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.set_sar_specs = ieee80211_set_sar_specs,
 	.color_change = ieee80211_color_change,
 	.set_radar_background = ieee80211_set_radar_background,
+	.get_avg_busy_time = ieee80211_get_avg_busy_time,
 };
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 740b29481bc6..eeb3d85fd506 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3717,6 +3717,12 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flag
 			goto nla_put_failure;
 	}
 
+	if (rdev->ops->get_avg_busy_time) {
+		int busy = rdev->ops->get_avg_busy_time(&rdev->wiphy, dev);
+		nla_put_u32(msg, NL80211_ATTR_WIPHY_AVG_BUSY_TIME,
+			   busy);
+	}
+
 	wdev_lock(wdev);
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_AP:
-- 
2.37.1

