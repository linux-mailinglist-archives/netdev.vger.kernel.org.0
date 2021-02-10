Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91EF1317197
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 21:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbhBJUpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 15:45:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233343AbhBJUos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 15:44:48 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFA6C061788
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 12:43:46 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id c6so4647549ede.0
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 12:43:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lNFN8fxT3BHlHEV3hfFYnwQv4HDAZ/cqFw/3w7+Ypno=;
        b=euqc3Ont53NKpKea5YMJTkC2rr6oWXWI2AHpFOK/FlE8aiKpEiQQq7OcUe7UFa7xei
         tRfNXEY5DmpJtpJr2eGJJDgPvQSeXVSPWirXzMggc+JwphmQhgtdxAavt53GbqJc9sbS
         AvoUqEsBaif4y4kfrzK8/8WSveVR6HS/L1laOq8QvUWcVNx0GoTRuo5056r2TJ73AnNK
         YNpV/LDUFMjfPuhDfjPgPJWsIrhszVdqKVVhYQSb5NNgv3JZROn0RUm6KNQeC4dYAryP
         kCrOlCFLBJ/1zORlydv9iWVy4Jjrfio4sS2C5pUbwxUc3Ggxsi+HXO3SDeaqXyhiZ2LI
         izdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lNFN8fxT3BHlHEV3hfFYnwQv4HDAZ/cqFw/3w7+Ypno=;
        b=rWEBRGxfopHEpxaA6lv2o4T7lwhRerQ5w4UtTKbvflrNXCVZ5nLzgQ7pM/LWUivGnS
         OgG3TUze0vH7LypOGkhD+6KI02sCxUBMpW09bP/xOnVB0igY4VY2v1j29yfZiaBMVrKD
         YQBtLHgJymyIUehdQ0eBEJBjvkQ9WBY3xQmuuiGdPR3iTh3vYWeeBBUEphj9ioO15aAF
         kIY8mWC/pE0ZIo9fwwk1T7M7fybUrtBhqwRyX6wYimNmLDjCasrpZvlPbR5hTthYk8ak
         pnI+tuPvqZrZ7L2J1QZQ//z7FFtx8CGHsLDHVpW60qsj1y4sgFOy0saJxaDnRymFXYTs
         bjFA==
X-Gm-Message-State: AOAM5301L2a0hFUv0qdybnmmwoGbTh6CBqovLDuVu4Hp98AzA8WHl6E1
        F6Io/YFM41xr3fQ5uryhQA76Hxv7fTdrcZB35jhJIQ==
X-Google-Smtp-Source: ABdhPJxbpcEBmovG7jPHzgsYzuWZAUH/mnzOKXsaSsHXsmZwGyTgnIFbIkCAI060O/x/j5rjRPd4Fg==
X-Received: by 2002:a05:6402:306c:: with SMTP id bs12mr4937940edb.348.1612989825277;
        Wed, 10 Feb 2021 12:43:45 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id l1sm2062655eje.12.2021.02.10.12.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 12:43:44 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, andy@greyhouse.net, j.vosburgh@gmail.com,
        vfalico@gmail.com, kuba@kernel.org, davem@davemloft.net,
        alexander.duyck@gmail.com, idosch@nvidia.com,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next v2 2/3] bonding: 3ad: add support for 400G speed
Date:   Wed, 10 Feb 2021 22:43:32 +0200
Message-Id: <20210210204333.729603-3-razor@blackwall.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210210204333.729603-1-razor@blackwall.org>
References: <20210210204333.729603-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

In order to be able to use 3ad mode with 400G devices we need to extend
the supported speeds.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
v2: no changes

 drivers/net/bonding/bond_3ad.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 390e877419f3..2e670f68626d 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -74,6 +74,7 @@ enum ad_link_speed_type {
 	AD_LINK_SPEED_56000MBPS,
 	AD_LINK_SPEED_100000MBPS,
 	AD_LINK_SPEED_200000MBPS,
+	AD_LINK_SPEED_400000MBPS,
 };
 
 /* compare MAC addresses */
@@ -247,6 +248,7 @@ static inline int __check_agg_selection_timer(struct port *port)
  *     %AD_LINK_SPEED_56000MBPS
  *     %AD_LINK_SPEED_100000MBPS
  *     %AD_LINK_SPEED_200000MBPS
+ *     %AD_LINK_SPEED_400000MBPS
  */
 static u16 __get_link_speed(struct port *port)
 {
@@ -318,6 +320,10 @@ static u16 __get_link_speed(struct port *port)
 			speed = AD_LINK_SPEED_200000MBPS;
 			break;
 
+		case SPEED_400000:
+			speed = AD_LINK_SPEED_400000MBPS;
+			break;
+
 		default:
 			/* unknown speed value from ethtool. shouldn't happen */
 			if (slave->speed != SPEED_UNKNOWN)
@@ -742,6 +748,9 @@ static u32 __get_agg_bandwidth(struct aggregator *aggregator)
 		case AD_LINK_SPEED_200000MBPS:
 			bandwidth = nports * 200000;
 			break;
+		case AD_LINK_SPEED_400000MBPS:
+			bandwidth = nports * 400000;
+			break;
 		default:
 			bandwidth = 0; /* to silence the compiler */
 		}
-- 
2.29.2

