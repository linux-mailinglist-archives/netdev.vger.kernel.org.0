Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A039B2D7594
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 13:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405908AbgLKM1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 07:27:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405418AbgLKM06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 07:26:58 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C88C0613D6
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 04:26:17 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id h19so13024693lfc.12
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 04:26:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wxCz9MA/8byhqum2RUzZFDa7nG9BkhzkOhPFA/KKhwc=;
        b=p+Rz8VfgNZ0I2k+2nXMgUC4C21t176i5lqRAUgLo4HAxcr3NxDX6HNUzC1enluAuaO
         pbpvHJOb7h5F4EPE56O4HzdT1jYSkKVgpkMhk/nRv+Y7ZoYqM1S3G8SxqEOTKi9tNigP
         zxWA/ubBxQaPTnSRHchwxoDfCng3LkvK5hsLevV/t+5abzZK3AaKptk2EAW3nl1Wej5s
         WV14R3R15hEhfEsGzZ7mKN6QYYWxXVBTYYBwCMDPqZXlHpv2o2tDLu7keoD6ZmOZ+tUt
         Ue/Fa8tC4ZxTd/Uh/mgUpHd9fqIZOKc05de219agUvyHUgbNjctxDkGO3pAYMwivPeXq
         3byw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wxCz9MA/8byhqum2RUzZFDa7nG9BkhzkOhPFA/KKhwc=;
        b=HEzTayhUkGsdOBntxzKzwedQQX1HonB0zwmYGjPdprO4MGMOhV7mLykCGZdDees/x/
         SL2LMtwLZzoNAEoFo/NRCWOyvOi8ZkNKMeCA4rVJajrv6G98uJRxxP2x17fJJKl6vBuv
         iHBqN0/acMQb/tbRYPPo9lSL0p+9s1qPciZLQf0PkZCETUcz3Q8tzF5uOk5AFUlMv4nx
         u9NWuj3wJsqGXwFqU+tRnxya7RGrnRIYTQVCWsg1bzZXLAMgyj62/590PHy+BumAmgxF
         0fpsJdCkUbCWNoSGR1ygwisRK9mt+BC/rt5FovLWKdoIaBgprRTKp9GsHJlrsY+aXtiB
         ep6w==
X-Gm-Message-State: AOAM532lsuwD2t3XPtPTbeym3SmHmjzAfwYQxDcCHSekjJwF/8SJ3jO+
        p000rmPCmcYJUn4FRzVyakfopGRbNDbDMg==
X-Google-Smtp-Source: ABdhPJx9ySE+gVteaYCNmwReyOUBnzhksIZsb3rUarJQoyB7P7MOz+71N1SYS9FcNMWSWbmfsDQMqg==
X-Received: by 2002:ac2:4846:: with SMTP id 6mr4258264lfy.653.1607689576268;
        Fri, 11 Dec 2020 04:26:16 -0800 (PST)
Received: from mimer.emblasoft.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id s8sm335818lfi.21.2020.12.11.04.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 04:26:15 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     netdev@vger.kernel.org
Cc:     pablo@netfilter.org, laforge@gnumonks.org,
        Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH net-next v2 02/12] gtp: include role in link info
Date:   Fri, 11 Dec 2020 13:26:02 +0100
Message-Id: <20201211122612.869225-3-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201211122612.869225-1-jonas@norrbonn.se>
References: <20201211122612.869225-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Querying link info for the GTP interface doesn't reveal in which "role" the
device is set to operate.  Include this information in the info query
result.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
---
 drivers/net/gtp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 5a048f050a9c..5682d3ba7aa5 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -728,7 +728,8 @@ static int gtp_validate(struct nlattr *tb[], struct nlattr *data[],
 
 static size_t gtp_get_size(const struct net_device *dev)
 {
-	return nla_total_size(sizeof(__u32));	/* IFLA_GTP_PDP_HASHSIZE */
+	return nla_total_size(sizeof(__u32)) + /* IFLA_GTP_PDP_HASHSIZE */
+		nla_total_size(sizeof(__u32)); /* IFLA_GTP_ROLE */
 }
 
 static int gtp_fill_info(struct sk_buff *skb, const struct net_device *dev)
@@ -737,6 +738,8 @@ static int gtp_fill_info(struct sk_buff *skb, const struct net_device *dev)
 
 	if (nla_put_u32(skb, IFLA_GTP_PDP_HASHSIZE, gtp->hash_size))
 		goto nla_put_failure;
+	if (nla_put_u32(skb, IFLA_GTP_ROLE, gtp->role))
+		goto nla_put_failure;
 
 	return 0;
 
-- 
2.27.0

