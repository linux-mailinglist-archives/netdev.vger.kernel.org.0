Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A61CE4DE205
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 20:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240451AbiCRT7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 15:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233906AbiCRT7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 15:59:42 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193AA11BE7F
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 12:58:23 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id mj15-20020a17090b368f00b001c637aa358eso11269859pjb.0
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 12:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=squareup.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7DNcSknRRyOIVwRrgAKf5oFccRt3j4FBjnezO7r8xTE=;
        b=Lpd8f/FqmIEd4Wb6a14PZxhfUCRTtqJ78rLWN+vYgM20n1ZCcVljy8IMysxvRwiQ+K
         PO1CCsq0SgsJJy/Zp1dktmZqe+4xp39tg+ARVddzL4uWjBffxS6cdjkgeQgtfuP0gKu0
         knZskp2EqseO1PdrJ/lH+96pHIp2XSWHBe3WY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7DNcSknRRyOIVwRrgAKf5oFccRt3j4FBjnezO7r8xTE=;
        b=tU/9K7K8LsGsUT+9Xsj2P+yOlawWsAqVcqg1CryvsHhZ/XHmx/QKaHQWVB7xQN54qo
         XBXm714CVJjF63OE2qsazGotoIqFdqV4PFoO1+kLqQAY4nb/z6KRA5JEQg/3miglVLDl
         Q8OBiKF0ksDT4S7J2nMopG+zxLvR4fv8bScTIs6/gsPekd3ZK6M3FXhwJJYfVoWBlrU9
         YDM0LSgOu0ptqNcyCwu/6QpGNfmaicVQoEkNCkYen/fqx+mfTePtWZFaTy1wLrzZKTGT
         f9uPtKAj7Zxi7+DFozMPZzaGB5iZ3vX90bJnSJIRjPH89iaSOFaMebH9xqECZcY9yX/m
         nFEg==
X-Gm-Message-State: AOAM533A/VpwlEJyckdyCuperk24hxRW/41TMjnM8sSd8U90YIUx3zEE
        piNR3ZAMroLa7ZR55PisDxZf9Q==
X-Google-Smtp-Source: ABdhPJzV4za3iC3QOB+HZU39vjKQU0DIXDNWDddr1JVzSr5+TJxpkKg5om8pUuWGy/vonZBmn1TC1w==
X-Received: by 2002:a17:90a:7f92:b0:1bc:f09:59 with SMTP id m18-20020a17090a7f9200b001bc0f090059mr23817236pjl.98.1647633502606;
        Fri, 18 Mar 2022 12:58:22 -0700 (PDT)
Received: from localhost ([135.84.132.160])
        by smtp.gmail.com with UTF8SMTPSA id on15-20020a17090b1d0f00b001bfa3e36086sm13558713pjb.54.2022.03.18.12.58.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Mar 2022 12:58:22 -0700 (PDT)
From:   Edmond Gagnon <egagnon@squareup.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Edmond Gagnon <egagnon@squareup.com>,
        Benjamin Li <benl@squareup.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] wcn36xx: Expose get_sta_index in wcn36xx.h
Date:   Fri, 18 Mar 2022 14:58:02 -0500
Message-Id: <20220318195804.4169686-2-egagnon@squareup.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220318195804.4169686-1-egagnon@squareup.com>
References: <20220318195804.4169686-1-egagnon@squareup.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move this helper into wcn36xx.h for use in smd.c when constructing
HAL_GET_STATS messages.

Signed-off-by: Edmond Gagnon <egagnon@squareup.com>
Reviewed-by: Benjamin Li <benl@squareup.com>
---
 drivers/net/wireless/ath/wcn36xx/main.c    | 8 --------
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h | 8 ++++++++
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index b545d4b2b8c4..70531f62777e 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -184,14 +184,6 @@ static const struct wiphy_wowlan_support wowlan_support = {
 
 #endif
 
-static inline u8 get_sta_index(struct ieee80211_vif *vif,
-			       struct wcn36xx_sta *sta_priv)
-{
-	return NL80211_IFTYPE_STATION == vif->type ?
-	       sta_priv->bss_sta_index :
-	       sta_priv->sta_index;
-}
-
 static const char * const wcn36xx_caps_names[] = {
 	"MCC",				/* 0 */
 	"P2P",				/* 1 */
diff --git a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
index 9aa08b636d08..80a4e7aea419 100644
--- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
+++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
@@ -335,4 +335,12 @@ struct wcn36xx_sta *wcn36xx_sta_to_priv(struct ieee80211_sta *sta)
 	return (struct wcn36xx_sta *)sta->drv_priv;
 }
 
+static inline u8 get_sta_index(struct ieee80211_vif *vif,
+			       struct wcn36xx_sta *sta_priv)
+{
+	return vif->type == NL80211_IFTYPE_STATION ?
+	       sta_priv->bss_sta_index :
+	       sta_priv->sta_index;
+}
+
 #endif	/* _WCN36XX_H_ */
-- 
2.25.1

