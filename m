Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572A0301834
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 21:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbhAWUHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 15:07:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbhAWUAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 15:00:10 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D541CC061352
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 11:59:36 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id a12so4174572lfb.1
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 11:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uEnUir7NULfyhfcHWwSmbaRoX9scIfA0jMqc4I/U48c=;
        b=h3lQ6MBNS4WgT2lmfNMoja3+Qw8J006XBzugSTcBp/oVp7aT4CO4IFYnWfL/AZgwK+
         JA10LGgvOsbAAWRLUHulSocCYqKxaO++lAWrpcsLvL7Kta9TtlgNaehV9Y4Hs9WmU0Fc
         NGnJ4Jfjomhh8fg8DLPXV1SqyYaCwbO/GcZJ+xAX/cnh8KeKyMx4G3dPPGGRTZ7dLMrg
         onl3DZdc92KBUztOqV69iWQEx2vp874U73mXyAonLcKGTU528jt3tcRlEseYhfojWVyX
         OqySyplJiV2u55xMR6g4MAqgbkPCvxHYWfC9ijdZ9eTChjSL70llNYPwcB6fnAdkYvQM
         UQtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uEnUir7NULfyhfcHWwSmbaRoX9scIfA0jMqc4I/U48c=;
        b=lfrWgNmXVRnat9B0bhQcs7BzFZoMUvEVuAbw2jJJ96nKWert3owfwUieDYT4aiDexD
         scC178u75rlRlsmq0pIPTrSzY9r/bRamCjeCXpZgAO5tAwpkFm8tnexM+nILx+Ur2EKh
         79acpY9zTpfLEIEOuVYrf9NHmleY25Pva39hs/ESIDOx7mgE8Ov+ChHqDKfqaKLcvgNK
         FMOAPeYz+qbJS92wmYxqvUpDy73Id28b1EkOVphEnCe51+577V8ZEa1JU8WnndXu0eAI
         L7FfCSKNyCwkSqvUFzf5PWNikVEX9z6526sRIecx77W1tF9fbbmVyvTIUc4UYvxomx1X
         y+jA==
X-Gm-Message-State: AOAM531a95DsKkvsRLq6kUcPx3z/xIpLmBZ5iT/0w4uDp3AeT9sf9+rL
        zbEonq9ezToI/yyFmoksjo5NYg==
X-Google-Smtp-Source: ABdhPJxvI1aq1vDb3qCkPy4oM7pt7fHt3Smc62p4LxFBgS2IQH5xo2NWcrblHvSnabELp/jbmC+kpA==
X-Received: by 2002:a19:1d8:: with SMTP id 207mr1702988lfb.54.1611431975453;
        Sat, 23 Jan 2021 11:59:35 -0800 (PST)
Received: from mimer.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id f9sm1265177lft.114.2021.01.23.11.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jan 2021 11:59:35 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     laforge@gnumonks.org, netdev@vger.kernel.org, pbshelar@fb.com,
        kuba@kernel.org
Cc:     pablo@netfilter.org, Jonas Bonn <jonas@norrbonn.se>
Subject: [RFC PATCH 06/16] gtp: set device type
Date:   Sat, 23 Jan 2021 20:59:06 +0100
Message-Id: <20210123195916.2765481-7-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210123195916.2765481-1-jonas@norrbonn.se>
References: <20210123195916.2765481-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set the devtype to 'gtp' when setting up the link.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
Acked-by: Harald Welte <laforge@gnumonks.org>
---
 drivers/net/gtp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 04d9de385549..a1bb02818977 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -610,6 +610,10 @@ static const struct net_device_ops gtp_netdev_ops = {
 	.ndo_get_stats64	= dev_get_tstats64,
 };
 
+static const struct device_type gtp_type = {
+	.name = "gtp",
+};
+
 static void gtp_link_setup(struct net_device *dev)
 {
 	unsigned int max_gtp_header_len = sizeof(struct iphdr) +
@@ -618,6 +622,7 @@ static void gtp_link_setup(struct net_device *dev)
 
 	dev->netdev_ops		= &gtp_netdev_ops;
 	dev->needs_free_netdev	= true;
+	SET_NETDEV_DEVTYPE(dev, &gtp_type);
 
 	dev->hard_header_len = 0;
 	dev->addr_len = 0;
-- 
2.27.0

