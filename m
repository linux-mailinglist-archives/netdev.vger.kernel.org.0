Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB0C2EEA49
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 01:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729567AbhAHAVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 19:21:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729545AbhAHAVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 19:21:11 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94325C0612F9
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 16:20:30 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id h16so9465813edt.7
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 16:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PGROoMfI34lDCWqNhvEkdznyLyGxPUATqQ97/7CFg4U=;
        b=EMUK/Baa6+hPanaRcShuH5du0/6j/hZVFgOC46p4Gcr1dxILa3LK+i41xZU/gNSyJt
         qnFfSoZc5rU+Zv4Y4mL2ASQHf6A5WFjflTg8GBvUPQMoS8e8GRg9bmJo0PYHZVWiJfPp
         f+NkDy7S7zoAN/FBP8oRj1OzFQ8iFf7u2GqpjjIu4o9W/2/ChWkh6qYODqcV+5ou9L1d
         mn7751LNR6Z8wylMdATNu6+qtWi9R9GwQ5v8EYQ47ReDxVe7FwUj9FmCn5zvRmMZeBtz
         ScAnhcaOKCRJqVYE4XpPJqcn0kLIUTGbSeHrnfWPlvJmYwuIqM0YJy/Y3F0z/ZyvlLGy
         GEpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PGROoMfI34lDCWqNhvEkdznyLyGxPUATqQ97/7CFg4U=;
        b=l4YX7W9Yz1FgpTCdQ2peV/Df145bwva6HWFXRBoxMB56ehc/Pgal7wYbJJ8KfEeZOx
         r+gpw33bzjL7C3/3FMZykK9ImtjxD7Hmt28FTp1TXpKZpb7I0eIprG+WRRt6N0U0BOei
         HRBKbG9FoDDoqnvEBxmlIDq9GWdOgUd1qDsz+V26TGnGXbbbutBziCeYnyDUGdpMuowo
         4oevwMbZKLqlvTHeL28DAiy2il4H6rjmtyK5qcEORja79W7K6FJj9i43XqWovrLQv5zs
         zulVhA1kR0gq+S/2f/TWavXUbK3xlbOcIh8mN+eSKL7d6hqAfc3uaoNrVnOhpSmfyfBE
         gBDw==
X-Gm-Message-State: AOAM531AAsJyL0dyR7zkhqkHxFjB1KpVpZRSJAGTcA+0rMC/0VH+tFff
        abTRW+A5uCN43VTzOK4c/0E=
X-Google-Smtp-Source: ABdhPJwNXAC6Wiphcpt8iCWFsxQApcteEWg4lTXw4AjSSgWrnWMVhUgYlmo8IdFj0vh45hy99NdRIw==
X-Received: by 2002:aa7:d407:: with SMTP id z7mr3661632edq.234.1610065229285;
        Thu, 07 Jan 2021 16:20:29 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id rk12sm2981691ejb.75.2021.01.07.16.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 16:20:28 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
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
        Jiri Pirko <jiri@mellanox.com>, Florian Westphal <fw@strlen.de>
Subject: [PATCH v4 net-next 04/18] net: sysfs: don't hold dev_base_lock while retrieving device statistics
Date:   Fri,  8 Jan 2021 02:19:51 +0200
Message-Id: <20210108002005.3429956-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210108002005.3429956-1-olteanv@gmail.com>
References: <20210108002005.3429956-1-olteanv@gmail.com>
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

