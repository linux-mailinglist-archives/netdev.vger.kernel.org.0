Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 365DC2EF5CE
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 17:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbhAHQdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 11:33:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbhAHQdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 11:33:05 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772BDC06129C
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 08:32:25 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id r5so11715072eda.12
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 08:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+vm+7xbZC0uXlRy64slHngow5lwfLKRAZrJ2gjlNLBs=;
        b=d9H31afCy25mPtswkMUumNK9DRMLwDIRNGL52Qqol3rHq+pBUMeZgyGYoXlx3GhjEZ
         p9vm4bXSNyTHJJwDnJNfiY2KiMOFguU30Hgv85V01LDN8tqWDWRyK2h9UlyfUl7PSjET
         FFl5ktZVf1PDPf8SlfkASVCLAdnaAfpXBplNuDxzRbKDpxrAXH1K5oZuRp+NKUFadV7Q
         PUj94I+BGNdqg7p7g/L4+Q+VigZ3zZLAdBIxSXH5rv1nJUcELHP0y+tf72FLum2sBZUk
         R6ytM4+UsfMVHL7qUXDJfqTIr/cDSOCWIKS2kaTel13CU/yOVFvLyd6EsjqiEceQz4Jz
         E6PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+vm+7xbZC0uXlRy64slHngow5lwfLKRAZrJ2gjlNLBs=;
        b=d4R11+CMxYHMcyE0dgH4y27vw6WW+N5DfqtT3cJ7GaN2lZmDUEJ3iBf9vl+zSuW6UN
         8o7lMCV/Eh7cJmBFD2F1p5csupCfCfWwBXtKkwXfC/l8z/tINm7gyXiRxZ8PGF1u/dbh
         gD+IT2DhBhV3jcoxN5y1RcqtgW3H9trddkALP2Q8fn949JxVOT8603om1dXg18sw3WK0
         AJGizb7gsnIgD/vSNz4WNtkIBxbN1OdaEhiBQf5BLlmcYFHFBx2v948Q3WlZtZyzGTqu
         586A09MFmScVHn/O7P4rn7vyB6UiigVTVdoy1NSYWPBaWgHZBsNwYB/cGt4NUgtXtg1j
         G6pQ==
X-Gm-Message-State: AOAM5308u4AMENAhZoJxjhVxi/CXo7tDPoxTTgfxjDYP1XnsFY6spJ0e
        +/ubJr0pWKTu2Tz2WHYM9vw=
X-Google-Smtp-Source: ABdhPJyormt5o0A+jnHndbROltikWg332ybxXaGgTlC/uYmV/mczHDvPU9uN6Z//WjozwwNhRqiMTA==
X-Received: by 2002:a50:d4d9:: with SMTP id e25mr5907064edj.243.1610123544152;
        Fri, 08 Jan 2021 08:32:24 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id x6sm3957737edl.67.2021.01.08.08.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 08:32:23 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH v5 net-next 04/16] net: sysfs: don't hold dev_base_lock while retrieving device statistics
Date:   Fri,  8 Jan 2021 18:31:47 +0200
Message-Id: <20210108163159.358043-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210108163159.358043-1-olteanv@gmail.com>
References: <20210108163159.358043-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In the effort of making .ndo_get_stats64 be able to sleep, we need to
ensure the callers of dev_get_stats do not use atomic context.

I need to preface this by saying that I have no idea why netstat_show
takes the dev_base_lock rwlock. Two things can be observed:
(a) it does not appear to be due to dev_isalive requiring it for some
    reason, because broadcast_show() also calls dev_isalive() and has
    had no problem existing since the beginning of git.
(b) the dev_get_stats function definitely does not need dev_base_lock
    protection either. In fact, holding the dev_base_lock is the entire
    problem here, because we want to make dev_get_stats sleepable, and
    holding a rwlock gives us atomic context.

So since no protection seems to be necessary, just run unlocked while
retrieving the /sys/class/net/eth0/statistics/* values.

Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v5:
None.

Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
None.

 net/core/net-sysfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index daf502c13d6d..8604183678fc 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -585,14 +585,13 @@ static ssize_t netstat_show(const struct device *d,
 	WARN_ON(offset > sizeof(struct rtnl_link_stats64) ||
 		offset % sizeof(u64) != 0);
 
-	read_lock(&dev_base_lock);
 	if (dev_isalive(dev)) {
 		struct rtnl_link_stats64 temp;
 		const struct rtnl_link_stats64 *stats = dev_get_stats(dev, &temp);
 
 		ret = sprintf(buf, fmt_u64, *(u64 *)(((u8 *)stats) + offset));
 	}
-	read_unlock(&dev_base_lock);
+
 	return ret;
 }
 
-- 
2.25.1

