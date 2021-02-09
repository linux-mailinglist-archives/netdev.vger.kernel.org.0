Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B19314D43
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 11:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbhBIKhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 05:37:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbhBIKdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 05:33:46 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93CCFC06178B
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 02:33:05 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id g10so22816757eds.2
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 02:33:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TKQ1UQj1xew0STcnsGD6Hcrs1RmaMhBETBwTXfNQszA=;
        b=vuHO+IlGt+5nd4vhOjPjau19hGJg2pz7v//MpO6rIJy7hHpVub0bGSn+c9+vFYECTZ
         +mRl3EqNKfuNjJMAuqP8gaThFycUEAYwr1myQlxC9A+83Gih0SUaSvffK+O/Q7W7YVvG
         6MlMDENufYHHwhsdHswMbrGqA9dm+KsyMmKirFcxWvsTsP2x9AhS9Y++qrl/yx1aNqoe
         oVqtN74/EK4kZxFbdmnjPc6GsfUWwtS/SSWagxBPOy+RyLDUAS5goMR+X/HygWMSH8fi
         cDJGqgO5JWyI9DB65vBfYyxB1xpMM3X5/stsubNOVC0+k8oqzHCtF4rVwmD8mai3FAqq
         Z6vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TKQ1UQj1xew0STcnsGD6Hcrs1RmaMhBETBwTXfNQszA=;
        b=euqsQbhHgffmgeqEYvSbC7wfJYxtxAEyg/q/yIzlmu6ULu3gY9Oei91tO8QIwEAnRh
         7x7snhSKlxsk2u/FSd4YRjvxogPyltStysCdglUu20lxfKTSWebkugin8pa71NuTl3Ui
         pzsD3N6CiQhZg36Q54kJs0IbOyjvdXpdohjLtIT4s11HS45B5qQcjzYSWv6Ieo40uYlp
         h1UQYtVw7O3vD245jFGJryIkhdovWt4LsbhR5LLi28GuCdR79q8Sr2CpAZPDVA/+skNU
         9K0yIvPIdorP4M6cI3Std2Q3EXjS7JHwhNugNArzDqs7/vgKeYl/+aBa/9tlSlo6VFra
         GkCg==
X-Gm-Message-State: AOAM532h4bAT0aKL6c3dc3ambxx5HglWs7vL/FO7gQhkmi6TUCQpVQs/
        eO2Vw1uX70pNNj8RHzqTKIQBxOveYCV7uR2aPfH1SQ==
X-Google-Smtp-Source: ABdhPJydvGrflFO6/qYCbXRzHZh43eQ3wYl1cGR1ck8+jpNBmIaUi3aSncnobTm6rNZx9n/cncwlpg==
X-Received: by 2002:a05:6402:206f:: with SMTP id bd15mr3929712edb.342.1612866784050;
        Tue, 09 Feb 2021 02:33:04 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id q20sm8486896ejs.17.2021.02.09.02.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 02:33:03 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, idosch@nvidia.com, andy@greyhouse.net,
        j.vosburgh@gmail.com, vfalico@gmail.com, kuba@kernel.org,
        davem@davemloft.net, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 1/3] bonding: 3ad: add support for 200G speed
Date:   Tue,  9 Feb 2021 12:32:07 +0200
Message-Id: <20210209103209.482770-2-razor@blackwall.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210209103209.482770-1-razor@blackwall.org>
References: <20210209103209.482770-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

In order to be able to use 3ad mode with 200G devices we need to extend
the supported speeds.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/bonding/bond_3ad.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index aa001b16765a..390e877419f3 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -73,6 +73,7 @@ enum ad_link_speed_type {
 	AD_LINK_SPEED_50000MBPS,
 	AD_LINK_SPEED_56000MBPS,
 	AD_LINK_SPEED_100000MBPS,
+	AD_LINK_SPEED_200000MBPS,
 };
 
 /* compare MAC addresses */
@@ -245,6 +246,7 @@ static inline int __check_agg_selection_timer(struct port *port)
  *     %AD_LINK_SPEED_50000MBPS
  *     %AD_LINK_SPEED_56000MBPS
  *     %AD_LINK_SPEED_100000MBPS
+ *     %AD_LINK_SPEED_200000MBPS
  */
 static u16 __get_link_speed(struct port *port)
 {
@@ -312,6 +314,10 @@ static u16 __get_link_speed(struct port *port)
 			speed = AD_LINK_SPEED_100000MBPS;
 			break;
 
+		case SPEED_200000:
+			speed = AD_LINK_SPEED_200000MBPS;
+			break;
+
 		default:
 			/* unknown speed value from ethtool. shouldn't happen */
 			if (slave->speed != SPEED_UNKNOWN)
@@ -733,6 +739,9 @@ static u32 __get_agg_bandwidth(struct aggregator *aggregator)
 		case AD_LINK_SPEED_100000MBPS:
 			bandwidth = nports * 100000;
 			break;
+		case AD_LINK_SPEED_200000MBPS:
+			bandwidth = nports * 200000;
+			break;
 		default:
 			bandwidth = 0; /* to silence the compiler */
 		}
-- 
2.29.2

