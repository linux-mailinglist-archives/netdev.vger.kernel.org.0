Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 051102CBD15
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 13:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbgLBMek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 07:34:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727068AbgLBMeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 07:34:37 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB771C061A47
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 04:33:53 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id j205so4436738lfj.6
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 04:33:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=teiV7Au9F3ql0miNmXw41Ar5KlhnBCmc6pHhmhDjjpQ=;
        b=J6e4caGaGq9dCvsewdbV2S/WWXvdKoHrkMDny9MJ4YC1O/6hftRELbR11ipgc0IXh2
         hHeT9uV2YUr1LD8ixLl6di+tpvvIvOWfl4jNLaaOr0x8jv1clKVZ+FV45MVWaBIzkUqD
         YInJs+p3lIpez0NnSNPskGLgIlHMTjSlyoMtrQb2b3RcUEsRHV6KuzmyPNAcWBwSuGyS
         XpMzIoNGyPFjTeSPbyeqK92okeXhek9VjbwBKCZ4cChjxPb365eCFJZDuez1WsdzGvqH
         zFy+RPG3zagNcsoYaoftLY0ZRaqH0pzd8wKDWyV0yQnO+6Y7uNSvchNvcXO4x90eAHOs
         SNEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=teiV7Au9F3ql0miNmXw41Ar5KlhnBCmc6pHhmhDjjpQ=;
        b=SplMiFyFs4SOysrhfm05Vo4AKVzF+cZi4wOV3nFacbTGHqqLsASzutP5zUxYAOnZIJ
         ELAKp4xPLjPxfFQ5j73eyp0KT/8/pAN/s3EMAyrlx7wr82Md2gdN4zHonjDPVo44qA9i
         rysw3ds39JdA9eYnYAJV5UUSEX848j/ikCZ7giJVd0mcoa9qDox3DuWZhWzRhjUS1m7s
         Obwd4j+hfnjjoegzQjl7I65cijuQ+/ZWTZvAv3K7lqK4UNlHO+xaa+oxl2iiHrRAGYoa
         /Xz/zWSZCm+6yM2w7ojUEdaRLm/Ycag6CV6SPpI5HneQ1DMQz45w+qTNHz/K+r3Duvyt
         c4xQ==
X-Gm-Message-State: AOAM530irBMvb8CNm7x0BHCQkoN3Wes5MA0agVElhjib8ISN7KPylcu7
        wkUyDS3BmRGe7LPF3FZ6qO9rnlEwPrtZ+A==
X-Google-Smtp-Source: ABdhPJy+tFXmnHCAPSB6AVqlteqzGwUxo5Bk2QvrpdlDmROd8qw9y98fCJerZYJIHJ44y819YmfEXQ==
X-Received: by 2002:a19:e059:: with SMTP id g25mr1177753lfj.584.1606912432263;
        Wed, 02 Dec 2020 04:33:52 -0800 (PST)
Received: from mimer.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id m7sm439230ljb.8.2020.12.02.04.33.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 04:33:51 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     netdev@vger.kernel.org, pablo@netfilter.org
Cc:     laforge@gnumonks.org, Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH 5/5] gtp: set device type
Date:   Wed,  2 Dec 2020 13:33:45 +0100
Message-Id: <20201202123345.565657-5-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201202123345.565657-1-jonas@norrbonn.se>
References: <20201202123345.565657-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set the devtype to 'gtp' when setting up the link.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
---
 drivers/net/gtp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index c19465458187..6de38e06588d 100644
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

