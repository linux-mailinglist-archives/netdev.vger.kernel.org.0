Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3162314D44
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 11:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbhBIKiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 05:38:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231784AbhBIKdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 05:33:49 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3534C06178C
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 02:33:06 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id y8so22788566ede.6
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 02:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I8p1yL8oL+Ytya5lcpHLR75uvtJn3LoCt97HohBn+ks=;
        b=YI1w/guZWdhG297ZQ4L7uOg6Pe55rowm3b9+hYnWJ3B8mcaLtSXdzQ3Vh46Y8PP7iU
         1Y87kncl96eW8097+ZKEFjcpoyVe7evG9cQNYwl4MciyMaaSwog3tpzZ80MaN4wb3Db0
         TY21pRV4KaN/4i12MefEk8vLQrhPDueHJL749oO3uRdAwIdRCGcjCF+6Pp672V98/wQa
         8BoQFp6msbz3z2yXCBAfapeSuf9rEPVdfs8riG8V7CB9YRbTo/JZKV1d24oLX10zWgX9
         XnVjDszsFkhOXXWvsXsYTWMIvrO0/LJuvvILfrBHYFVRpFgEiDBMvo7N6LM0SLF/tWhO
         sCUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I8p1yL8oL+Ytya5lcpHLR75uvtJn3LoCt97HohBn+ks=;
        b=VPDzvWVTLmAoaU3dRW+TCnOsB9W643VQNtrg85qZeVCvaNVxZjqIXuRr4vKd8AhyK8
         2kn8d13VqNKTZfVH1qvDXn/coV0mBCoxV47uxDJbpI5iJUgoy0cI61U8ekSQoq8e/ZuN
         /hLmGq3CerWzBAqDByKW+Dx9lkEmiV03kqr8u3Q1wz4lv3Sn9vnhts2eMAqV2rkNsor4
         SLrzWx42OgmpQ9wXP91K1OJfROh76uypz1iZIeQRmftKY0JDCPvZXXNQYHlA2YTPP7v8
         QwGj8Z7TF+56++7XxGseMKpbgN7kmaXgOOHDNEa3HEm2RY5V7IEizuj5nwjHrsejkF1m
         Iz0g==
X-Gm-Message-State: AOAM532Q9Swp3p4+x9JtDrNsBwjhdAC8qd6653Elhc2+KgruMCp6crlS
        JEvwxVWxtq3bMvXuPRD+UpoqeQl89ok960B0/txzgg==
X-Google-Smtp-Source: ABdhPJzJBn61lo/lsFj/+wFwovU10TZghsHxqLpRtQhfiO2KdNLn/9AN9LUm7kze+E3AacZs+6ocHw==
X-Received: by 2002:a05:6402:d05:: with SMTP id eb5mr21675130edb.143.1612866785399;
        Tue, 09 Feb 2021 02:33:05 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id q20sm8486896ejs.17.2021.02.09.02.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 02:33:04 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, idosch@nvidia.com, andy@greyhouse.net,
        j.vosburgh@gmail.com, vfalico@gmail.com, kuba@kernel.org,
        davem@davemloft.net, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 2/3] bonding: 3ad: add support for 400G speed
Date:   Tue,  9 Feb 2021 12:32:08 +0200
Message-Id: <20210209103209.482770-3-razor@blackwall.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210209103209.482770-1-razor@blackwall.org>
References: <20210209103209.482770-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

In order to be able to use 3ad mode with 400G devices we need to extend
the supported speeds.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
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

