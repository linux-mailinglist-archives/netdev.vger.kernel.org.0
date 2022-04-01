Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 302544EEBD9
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 12:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243938AbiDAKyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 06:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345072AbiDAKwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 06:52:45 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65CAC53E2A
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 03:50:55 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id f6-20020a1c3806000000b0038e4a0fc5easo1227720wma.3
        for <netdev@vger.kernel.org>; Fri, 01 Apr 2022 03:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QBKwD8HUOk6ZcRr/nLKL5Hzmfbcc34y7j+Mh2z7MZlA=;
        b=I5Hvt5BVjSAhFjOahgRq+v8E8jlzYBL2YIlZi+yuzZYLfb7G1eZ+ra/Cqw/xGQ0Qib
         JhG4lFsDyyevg5xwxnZgJR3iI7v5D836Bg3BHf9/jRB99F5G8e35Bz8GME4JQPYpEZ8y
         F/HNdkGIWnnUYEhbbMaOs4/exiwV2f5LtOgPUp0ZJuk80nh6ezzLApOI+Y4Og1OoR4eC
         ug+Qwh9TWSrO/AgrZ18o8Pv2Gu4qrQ2s8ukRiQ38qdtVnvJAYnBY4PfDtIVTA5j5P2aP
         R7uMmuxcRMXnFzhVn0KlBeMnNGsRoCmEfWDKaTcGJ67Mdka9zey3R4iewbIWohtzPwjc
         muTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QBKwD8HUOk6ZcRr/nLKL5Hzmfbcc34y7j+Mh2z7MZlA=;
        b=WD92ZQd7WNxbT5hFyCOLYmUKbLaMhYCVTc7wrjwt9YuZnzO4n4gLsBsOI5SoB3Q5BU
         CNm0YuBxkpj1rU56hI2o1I9sUngOs/yqnEPXov6SCCIsNvpqgORO23dH5IdgtpOVN6ky
         S+thqo9wsF1PvvhJKnLF9wpVdb2LgirVl+zTh6FbKPBzHKTOjnA0bBuL525Z7uaMXoNq
         T/bzkBYIYjoJB/BEp5P8FPcp64A8/NfxJ4cr5YyRcjyYSqBc8E2c8iuOdvRYG/0t2ent
         qOPnJYlamF92V3iqDfVNG554c7TFgLc4a/Kli52/L1bL0ZTbKqI7w1qbVyL0F3gESMYd
         Zskg==
X-Gm-Message-State: AOAM5324Zs3o7jGwFaXKSx+ZlG6SBzr29f81JFyTrdg3Ppv8uQirdJXi
        3RUPJ2BU83nGDQb1zXVpt7UZSQ==
X-Google-Smtp-Source: ABdhPJyNpBs9mmnzElZBquk0tBzk/CsYPd29bsHI3BohmQevd2bTWg1eoxFRWhMMDLZjtNuBUXIFOA==
X-Received: by 2002:a05:600c:4fcd:b0:38c:7495:e644 with SMTP id o13-20020a05600c4fcd00b0038c7495e644mr8344490wmq.102.1648810253781;
        Fri, 01 Apr 2022 03:50:53 -0700 (PDT)
Received: from joneslee-l.cable.virginm.net (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id c5-20020a5d63c5000000b002040822b680sm2379542wrw.81.2022.04.01.03.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 03:50:53 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/1] nl80211: Prevent out-of-bounds read when processing NL80211_ATTR_REG_ALPHA2
Date:   Fri,  1 Apr 2022 11:50:46 +0100
Message-Id: <20220401105046.1952815-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Checks are presently in place in validate_nla() to ensure strings
greater than 2 are not passed in by the user which could potentially
cause issues.

However, there is nothing to prevent userspace from only providing a
single (1) Byte as the data length parameter via nla_put().  If this
were to happen, it would cause an OOB read in regulatory_hint_user(),
since it makes assumptions that alpha2[0] and alpha2[1] will always be
accessible.

Add an additional check, to ensure enough data has been allocated to
hold both Bytes.

Cc: <stable@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 net/wireless/nl80211.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ee1c2b6b69711..80a516033db36 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7536,6 +7536,10 @@ static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
 		if (!info->attrs[NL80211_ATTR_REG_ALPHA2])
 			return -EINVAL;
 
+		if (nla_len(info->attrs[NL80211_ATTR_REG_ALPHA2]) !=
+		    nl80211_policy[NL80211_ATTR_REG_ALPHA2].len)
+			return -EINVAL;
+
 		data = nla_data(info->attrs[NL80211_ATTR_REG_ALPHA2]);
 		return regulatory_hint_user(data, user_reg_hint_type);
 	case NL80211_USER_REG_HINT_INDOOR:
-- 
2.35.1.1094.g7c7d902a7c-goog

