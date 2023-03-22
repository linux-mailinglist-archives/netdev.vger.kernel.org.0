Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0C56C4B89
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 14:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbjCVNTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 09:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbjCVNT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 09:19:26 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16CB5D44E
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 06:19:20 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-541a39df9f4so188805767b3.20
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 06:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679491160;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WhKKmDSTt/szmWTvrQ7cQQTb/66HNgMpwledR6Om+lc=;
        b=UsBbHMWxtgFGAjlpmUtFtOJhjmKCUkh6esRz06/d5yhtktnYm6q1bE9bhLEwKNy78z
         yU2iVw/VosWOq7eBvDoVdM230Bs3d2mqbu14TaKFzz47Tld/I80M7sW/1YBGISLkJCZE
         833T9PQXolukws1WiaKF1+SmbQibZCPuExP4SQH8Au5X0EsaXZik/WYxvF+8sBDWo9Im
         Cak5OUq9p4ZxaPwXMbVDe+Qd4/GMsYvVIgOYnYZyYCkbO58f82V7uUHzQS4QVRFjMC+F
         MBu2zWgQuBxcshv6bvn4q/mI5ddDYkAz9yawvVh8VHZYdbBSAGyDcn3LwFqxK9/30+Kz
         hBjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679491160;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WhKKmDSTt/szmWTvrQ7cQQTb/66HNgMpwledR6Om+lc=;
        b=pJiplfS1/euqHUr8Y8d5fjex0XClfLsZN6NcFfechFomigFd8b9Sy1X9pzLisZwr+I
         eO2YBCaMRhECMBcUM6k3U93OW2DFQf637Q2CDj2KScpskELHGOzBzI9ves71oFkDnpg6
         H/87cwJxNJ6pzqJsTC4Z/01p11dKRzxjL1e8GhWyqrXislcEFeBH31LW4uN05/yLikzR
         5OSH9i2O7OofHrNUk0gcdw2xTfR8VjqRzILl30r6KtTmWaugtdLiUTi3vBWTc+pfETBA
         FUERJ9HryhMRlOiqZkqSgUqQSsZlaKvgbNjmCepkrTnfT3oI2ot+giltUByZ2nyyoUgn
         8P0A==
X-Gm-Message-State: AAQBX9dmbVCDwFc+1D+0LqvyOZarEWC1ckNFg9gM5Hgrcluh48iumCEn
        DxdiZDSf6DyjExNNwLxw5ULIuKhIFGM=
X-Google-Smtp-Source: AKy350Zn1Hu3yId9nrChlA+7hXQZ2MkkgZci8Kdr+WX/hBEyiE/WfBActg1eTtkx8m+6d/rugC2TgHIZ1ck=
X-Received: from jaewan1.c.googlers.com ([fda3:e722:ac3:cc00:3:22c1:c0a8:e59])
 (user=jaewan job=sendgmr) by 2002:a25:d512:0:b0:b45:5cbe:48b3 with SMTP id
 r18-20020a25d512000000b00b455cbe48b3mr3860854ybe.0.1679491160190; Wed, 22 Mar
 2023 06:19:20 -0700 (PDT)
Date:   Wed, 22 Mar 2023 13:16:34 +0000
In-Reply-To: <20230322131637.2633968-1-jaewan@google.com>
Mime-Version: 1.0
References: <20230322131637.2633968-1-jaewan@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230322131637.2633968-3-jaewan@google.com>
Subject: [PATCH v10 2/5] wifi: nl80211: make nl80211_send_chandef non-static
From:   Jaewan Kim <jaewan@google.com>
To:     michal.kubiak@intel.com, gregkh@linuxfoundation.org,
        johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-team@android.com, adelva@google.com,
        Jaewan Kim <jaewan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose nl80211_send_chandef functionality for mac80211_hwsim or vendor
netlink can use it where needed.

Signed-off-by: Jaewan Kim <jaewan@google.com>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
---
V8: Initial commit (split from other change)
---
 include/net/cfg80211.h | 9 +++++++++
 net/wireless/nl80211.c | 4 ++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f115b2550309..bcce8e9e2aba 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -938,6 +938,15 @@ int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
 				  const struct cfg80211_chan_def *chandef,
 				  enum nl80211_iftype iftype);
 
+/**
+ * nl80211_send_chandef - sends the channel definition.
+ * @msg: the msg to send channel definition
+ * @chandef: the channel definition to check
+ *
+ * Returns: 0 if sent the channel definition to msg, < 0 on error
+ **/
+int nl80211_send_chandef(struct sk_buff *msg, const struct cfg80211_chan_def *chandef);
+
 /**
  * ieee80211_chanwidth_rate_flags - return rate flags for channel width
  * @width: the channel width of the channel
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 112b4bb009c8..1fd9e6545225 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3756,8 +3756,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 	return result;
 }
 
-static int nl80211_send_chandef(struct sk_buff *msg,
-				const struct cfg80211_chan_def *chandef)
+int nl80211_send_chandef(struct sk_buff *msg, const struct cfg80211_chan_def *chandef)
 {
 	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
 		return -EINVAL;
@@ -3788,6 +3787,7 @@ static int nl80211_send_chandef(struct sk_buff *msg,
 		return -ENOBUFS;
 	return 0;
 }
+EXPORT_SYMBOL(nl80211_send_chandef);
 
 static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flags,
 			      struct cfg80211_registered_device *rdev,
-- 
2.40.0.rc1.284.g88254d51c5-goog

