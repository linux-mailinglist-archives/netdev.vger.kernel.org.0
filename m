Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47ED2F0238
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 18:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbhAIR2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 12:28:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbhAIR2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 12:28:08 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2D1C0617A4
        for <netdev@vger.kernel.org>; Sat,  9 Jan 2021 09:27:28 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id qw4so18739992ejb.12
        for <netdev@vger.kernel.org>; Sat, 09 Jan 2021 09:27:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ovfprG4fnZ7oxcJrrp2stelHr4YWI6qY04aWSEUZeCY=;
        b=k7R0PClCpvqFPWkzIr0mQz6jXrZGVG1yT9pwObwzXk2NJ7bRo/FdkaNlObF49jXdmM
         3enJhxyot1Mhj1Lh8gUrZRVi8k4dYjhU9tvQyRW9TufaMwpsD8aFX2WbpGo3PEYmQCie
         jJPhwLIuh1PfQ6aTyRBqmRXBVZ39wvQ1g/YehVAy7qfJ6ojgW1lnvKomxK7HLJqSROT7
         krgiROHC/4q3VAdlw2byvECQFfoynUnpUjXHGir9z4dwr7lmFwDa9UTeJEQQC5iIH1jQ
         a27Xlmy2Jf1cQKvhndfxIMOKJ6FQuxxc6Lpu6Yx9S9WEDa9kmizlj984Ht2/X/4AxWGO
         R14g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ovfprG4fnZ7oxcJrrp2stelHr4YWI6qY04aWSEUZeCY=;
        b=r4j7g9i1WUwLadUDTqXWPCinmk4PJe8ulGZybLY27t+QnZpOvzznnMLZyDl3o/bHtO
         S70Dh9qaVaaPa3xZEXXApEqnOJS0NQojtxcen+SsDDBm9e1H7WjAw98W2n1NGk4S7aVP
         V5RG7NVytFzy+fzTc7mrpBh4tV1uMkNpUudREA6ZwlGsML03EN/samy+ydFBiFbbFgmA
         5eTNgeF13RjXbQhzPn2OT2Ww34b57+UYGFvffHhmgdKuEZ4vynnZ+iQ/TEkVmaSbjXYr
         cl1T5C7TxKV0YyjeiN98vHBYibviZyhgLdqpfULWPkc493GWJ2WrZMXgtuRIWh39gGRL
         4bdQ==
X-Gm-Message-State: AOAM533kgkCaSExPWV1XaRioo/21Pm/w+9FC/ltLtCy8YKCbK5oJdb/R
        cNWnAJtGlh9GvwPXvXycLss=
X-Google-Smtp-Source: ABdhPJy+bWhlZh8HI1Ff8AnfYsyHgQqu5vmdPtfj6GLZ9GzqjDjBVEK6Za7oJIfofcsbsruyqAal+g==
X-Received: by 2002:a17:906:eb8d:: with SMTP id mh13mr5850514ejb.299.1610213247043;
        Sat, 09 Jan 2021 09:27:27 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id h16sm4776714eji.110.2021.01.09.09.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 09:27:26 -0800 (PST)
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
Subject: [PATCH v6 net-next 04/15] net: sysfs: don't hold dev_base_lock while retrieving device statistics
Date:   Sat,  9 Jan 2021 19:26:13 +0200
Message-Id: <20210109172624.2028156-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210109172624.2028156-1-olteanv@gmail.com>
References: <20210109172624.2028156-1-olteanv@gmail.com>
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
Changes in v6:
None.

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

