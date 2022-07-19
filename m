Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB205579F70
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 15:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238146AbiGSNT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 09:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243699AbiGSNTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 09:19:31 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF859C7B5;
        Tue, 19 Jul 2022 05:36:27 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id a5so21364520wrx.12;
        Tue, 19 Jul 2022 05:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C5Yck6u5bzJdtJYVbvpnhCrTJsEoVdG4F3GJtRMkNSU=;
        b=Pq6BwkMe6F15WzfFLXBphW9Y1WnWCkuRntFHdLh05HInSisbTHbQpOucPzP7dOiUVj
         nBaqkTYMdn8XYwZli54EZ0O7SwW9IWpG2+Ak0iL6RaEwoRi4F75S6q9UdmocPfsWVrfZ
         iRt+avNMEb55iegR+lat44HSLsHOYVflsxOrE5RVg8m9wyY2qI0y11Wmh57LNyOlYAyT
         a+UvZUokkQMerkDLLqn/K+kNMBUqge9imfb+faAIWSmj3QgBRFvvKHRwFbijUa+K+TzQ
         gC1yyoFchdCAOzCjkpiV8JGNsXRBkVNfL8zpafuhaG9iH6okIDfTXqZZm+kLQy4rOtZG
         e08w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C5Yck6u5bzJdtJYVbvpnhCrTJsEoVdG4F3GJtRMkNSU=;
        b=JAWInYiGbvco8504GCE/BmPh1/C210F1j52GPb3sK5ICZi5np+dHfSeZ7fC0CtwOhy
         5IvMCQ5qCRLGEpjzAMzn8wYpdD3Z7oPbduXJOaDQupyBmPSw2HFM3V5RwOghUb+ke8sm
         xBU/E8FK0LLfOTWRP55YaUf7s9EMyDxqqmvIi3dMTTkuE/bXKFNYdfu3Jp2jUIHUKT33
         vQl5fNTjZ0L6XTggs2vD9gr3imhgaU8jI5Dm20PaIHXVDDpRiPfceBU5ot7X+wP80euH
         8A0lJMk5LTt2672Eh0vsBj0vEAWUvktoYakQJycyQmGjMf4Hr4imhmfcBzIy04XykM5s
         OsRw==
X-Gm-Message-State: AJIora9RvNohbRuAAwzKI/KCb5loHy+VD4sso+KpwOTJcCUeW6cYrZEF
        jZDtrhBB9V4w6ZEi4ieJ6Wk=
X-Google-Smtp-Source: AGRyM1sQSUbrsR97drF4VYh5l75YPNOjd50TPGyKJdH1eV/SqdOcjS43IbZjIeLc9O1FsmvXmnYwLg==
X-Received: by 2002:a5d:64ad:0:b0:21d:adb6:c266 with SMTP id m13-20020a5d64ad000000b0021dadb6c266mr28160614wrp.638.1658234186008;
        Tue, 19 Jul 2022 05:36:26 -0700 (PDT)
Received: from baligh-ThinkCentre-M720q.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.googlemail.com with ESMTPSA id bp30-20020a5d5a9e000000b0021e297d6850sm3337522wrb.110.2022.07.19.05.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 05:36:25 -0700 (PDT)
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
Subject: [RFC/RFT v5 2/4] mac80211: add periodic monitor for channel busy time
Date:   Tue, 19 Jul 2022 14:35:23 +0200
Message-Id: <20220719123525.3448926-3-gasmibal@gmail.com>
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

Add a worker scheduled periodicaly to calculate the busy time average of
the current channel.

This will be used in the estimation for expected throughput.

Signed-off-by: Baligh Gasmi <gasmibal@gmail.com>
---
 net/mac80211/ieee80211_i.h |  6 ++++
 net/mac80211/iface.c       | 65 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 86ef0a46a68c..2cb388335ce8 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -901,6 +901,7 @@ struct ieee80211_if_nan {
 	struct idr function_inst_ids;
 };
 
+DECLARE_EWMA(avg_busy, 8, 4)
 struct ieee80211_sub_if_data {
 	struct list_head list;
 
@@ -1024,6 +1025,11 @@ struct ieee80211_sub_if_data {
 	} debugfs;
 #endif
 
+	struct delayed_work monitor_work;
+	u64 last_time;
+	u64 last_time_busy;
+	struct ewma_avg_busy avg_busy;
+
 	/* must be last, dynamically sized area in this! */
 	struct ieee80211_vif vif;
 };
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 15a73b7fdd75..e1b20964933c 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1972,6 +1972,64 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
 	mutex_unlock(&local->iflist_mtx);
 }
 
+#define DEFAULT_MONITOR_INTERVAL_MS 1000
+
+static void ieee80211_if_monitor_work(struct work_struct *work)
+{
+	struct delayed_work *delayed_work = to_delayed_work(work);
+	struct ieee80211_sub_if_data *sdata =
+		container_of(delayed_work, struct ieee80211_sub_if_data,
+				monitor_work);
+	struct survey_info survey;
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct ieee80211_channel *channel = NULL;
+	int q = 0;
+	u64 interval = DEFAULT_MONITOR_INTERVAL_MS;
+
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+	if (chanctx_conf)
+		channel = chanctx_conf->def.chan;
+	rcu_read_unlock();
+
+	if (!channel)
+		goto end;
+
+	if (!local->started)
+		goto end;
+
+	do {
+		survey.filled = 0;
+		if (drv_get_survey(local, q++, &survey) != 0) {
+			survey.filled = 0;
+			break;
+		}
+	} while (channel != survey.channel);
+
+	if (survey.filled & SURVEY_INFO_TIME) {
+		/* real interval */
+		interval = survey.time - sdata->last_time;
+		/* store last time */
+		sdata->last_time = survey.time;
+	}
+
+	if (survey.filled & SURVEY_INFO_TIME_BUSY) {
+		/* busy */
+		u64 busy = survey.time_busy < sdata->last_time_busy ? 0 :
+			survey.time_busy - sdata->last_time_busy;
+		/* average percent busy time */
+		ewma_avg_busy_add(&sdata->avg_busy,
+				(busy * 100) / interval);
+		/* store last busy time */
+		sdata->last_time_busy = survey.time_busy;
+	}
+
+end:
+	schedule_delayed_work(&sdata->monitor_work,
+			msecs_to_jiffies(DEFAULT_MONITOR_INTERVAL_MS));
+}
+
 int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		     unsigned char name_assign_type,
 		     struct wireless_dev **new_wdev, enum nl80211_iftype type,
@@ -2085,6 +2143,8 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 			  ieee80211_dfs_cac_timer_work);
 	INIT_DELAYED_WORK(&sdata->dec_tailroom_needed_wk,
 			  ieee80211_delayed_tailroom_dec);
+	INIT_DELAYED_WORK(&sdata->monitor_work,
+			ieee80211_if_monitor_work);
 
 	for (i = 0; i < NUM_NL80211_BANDS; i++) {
 		struct ieee80211_supported_band *sband;
@@ -2156,6 +2216,9 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 	list_add_tail_rcu(&sdata->list, &local->interfaces);
 	mutex_unlock(&local->iflist_mtx);
 
+	schedule_delayed_work(&sdata->monitor_work,
+			msecs_to_jiffies(DEFAULT_MONITOR_INTERVAL_MS));
+
 	if (new_wdev)
 		*new_wdev = &sdata->wdev;
 
@@ -2166,6 +2229,8 @@ void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata)
 {
 	ASSERT_RTNL();
 
+	cancel_delayed_work_sync(&sdata->monitor_work);
+
 	mutex_lock(&sdata->local->iflist_mtx);
 	list_del_rcu(&sdata->list);
 	mutex_unlock(&sdata->local->iflist_mtx);
-- 
2.37.1

