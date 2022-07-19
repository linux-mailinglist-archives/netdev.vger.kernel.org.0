Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F31D579F7C
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 15:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237518AbiGSNUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 09:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243747AbiGSNTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 09:19:35 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF442AC8;
        Tue, 19 Jul 2022 05:36:29 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id z13so1812781wro.13;
        Tue, 19 Jul 2022 05:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yM3+8zTlhjwI5zRwAownh+8azeEiykzkYJwzAaOCCI8=;
        b=eHLDMDFDuMgJmsxLX+mrq/2WWxFiv9kIWo0TDVM4NuItY1cXJzj+WyQfSKLgGUxQva
         1x3/aou1FHLuWC64UqnMIVTxHzOxlMzJOxaDD6PpaC+Y7NSnlJwEbfh8BojhfXJQd7TY
         rFx+9YbTmbkRXIjsK2/SW76CS6p9Yqpw05ZzJ6brlzRYI6FT7ZQKEcqVtDs+TjOitID3
         9HHvj1dU2mw9yDPryTtRZYViDoXf4pYmmAsPGwdY3xE8i+APbmVZQXV8WR8KqsUxBzXz
         foB8a392YYEJGFajl69kE9n+7jEk2sYQCjFYSqnpXI6zT7vhfcYc67YQECqRnKndGYGz
         S9Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yM3+8zTlhjwI5zRwAownh+8azeEiykzkYJwzAaOCCI8=;
        b=pkYy1UHk+7tTePS3lmOqKNfWpBvT4xtdrzUeQb3Tr7dWEg+m9MFh+oiNNaO9nabV4E
         /Y+pMwnXCG9gEHvezkMIcE0A0XL3cYO8ZtCkdE9Fwqc57XGjhQScNFHeqxtdeiz40OJw
         jXWhJGLtOEou+zn3mSPbHNwkMwk8suejWKYpeI2rP1jVlXXcJPPsiSXAe2Vc8PdybUDa
         k6mr/szgtxFTUB+oyVF3HDKXgtX0psmkG2mDIeUdJAcRBfUiJVqveaopgcVs+tUgiMm/
         XNFk1O9oJscbNjtKeu93NJV5zVP3AcZdEpedGz1gAVic2INRL+3lQCAxthEYYa5JedIc
         qCsQ==
X-Gm-Message-State: AJIora8GwCYReoqL5DDwxDc3b3yz+anrWjpC/HxLXB2WOQ7E0Qs/b9Ws
        geovrNUT0rN5tfItlQMInQg=
X-Google-Smtp-Source: AGRyM1trZfY/zjIyZWbNtVdlg7dvhrcyOaGsOw4O0be2ggT6hc6Qb2glit1C0HvevtTsQWG/jMOKEA==
X-Received: by 2002:a5d:414a:0:b0:21d:6be5:1765 with SMTP id c10-20020a5d414a000000b0021d6be51765mr27173653wrq.419.1658234187491;
        Tue, 19 Jul 2022 05:36:27 -0700 (PDT)
Received: from baligh-ThinkCentre-M720q.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.googlemail.com with ESMTPSA id bp30-20020a5d5a9e000000b0021e297d6850sm3337522wrb.110.2022.07.19.05.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 05:36:27 -0700 (PDT)
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
Subject: [RFC/RFT v5 3/4] mac80211: add busy time factor into expected throughput
Date:   Tue, 19 Jul 2022 14:35:24 +0200
Message-Id: <20220719123525.3448926-4-gasmibal@gmail.com>
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

When estimating the expected throughput, take into account the busy time
of the current channel.

Signed-off-by: Baligh Gasmi <gasmibal@gmail.com>
---
 net/mac80211/sta_info.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 201aab465234..7e32c06ae771 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2000,6 +2000,8 @@ void ieee80211_sta_update_tp(struct ieee80211_local *local,
 			     bool ack, int retry)
 {
 	unsigned long diff;
+	struct ieee80211_sub_if_data *sdata;
+	u32 avg_busy;
 	struct rate_control_ref *ref = NULL;
 
 	if (!skb || !sta || !tx_time_est)
@@ -2014,6 +2016,7 @@ void ieee80211_sta_update_tp(struct ieee80211_local *local,
 	if (local->ops->get_expected_throughput)
 		return;
 
+	sdata = sta->sdata;
 	tx_time_est += ack ? 4 : 0;
 	tx_time_est += retry ? retry * 2 : 2;
 
@@ -2022,6 +2025,10 @@ void ieee80211_sta_update_tp(struct ieee80211_local *local,
 
 	diff = jiffies - sta->deflink.status_stats.last_tp_update;
 	if (diff > HZ / 10) {
+		avg_busy = ewma_avg_busy_read(&sdata->avg_busy) >> 1;
+		sta->deflink.tx_stats.tp_tx_time_est +=
+			(sta->deflink.tx_stats.tp_tx_time_est * avg_busy) / 100;
+
 		ewma_avg_est_tp_add(&sta->deflink.status_stats.avg_est_tp,
 				    sta->deflink.tx_stats.tp_tx_size /
 				    sta->deflink.tx_stats.tp_tx_time_est);
-- 
2.37.1

