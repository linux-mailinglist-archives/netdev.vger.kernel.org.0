Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8262EB330
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 20:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730844AbhAETC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 14:02:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbhAETCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 14:02:07 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E13C0617A2;
        Tue,  5 Jan 2021 11:00:53 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id w1so1758613ejf.11;
        Tue, 05 Jan 2021 11:00:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VqKUbghIDfYrfb3O7qIi6ZxV/2bVKA7+VXpaNALoN60=;
        b=o72EV0y5XH6HchkYJqkf18+T0vm0Uz19QPiFec6UrE0bJV5bAouj5tUFThd+IbUeaH
         yUe448KhNG1blJQxDZTQOSx3bw/rjUuPJafSLUnhGcVcmX+vwhSeVoHv6FFJBmfUSV+u
         a+CFVILyASpZpXFmOVMNnfqc28/9V6Dagm/1/RVHEVBz9ZLAMbGJ2DgFzJCl+FaHemvK
         1GjY//UjxbnawtELZ84EsOXDBNfazICZGH71XgnOA+CXCFm1CTMHQfQ9UV70yrAuXfPB
         oS/PFIl8l1oqOkgmzlk+HI19tTlFGLDsv257e3gWMIM1kgKEOxMeY7CZjnCo1NcYYmKo
         gsYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VqKUbghIDfYrfb3O7qIi6ZxV/2bVKA7+VXpaNALoN60=;
        b=M1hutG4tPrb4hRVKgwJ0Eg1RUHkNyiR0cC4WrgZI4iiC7Swpc7K1yq8N5SifqP1ZLu
         hqiO1N+HWterCDoTORwQ3FCeHH2y5RvBz9KZxbhbD8bsV0urLW5RtKpGDszsYFsd7z5K
         kfw6zsx5MxJRqCIPzPnVZCI4GAyXxl7itZ79+snsCX2aiw2Du8ryKcVn7BDt7uEsQESg
         9V2pIvLcrkMUyRed6IIc6pCQWeyv0TAC0rptoraJZJjYiyw2WQuoGbekEcH48AQQtGWa
         oD1vM9vuhziETvh7C6AmYmH7jpTgX/1yuVp+i5fbv8az0V5zMTjH/4YfCpvgOlHn2yuB
         roJg==
X-Gm-Message-State: AOAM531RutI4t0UBg4w1Xo31Gt+X70Mhk2pFxwDCIyMnGftIZ5/6JPeB
        SCtV2mABQMJQtisH1TP5JQQ=
X-Google-Smtp-Source: ABdhPJz1wURDbCR0bNBYRS2W9HuLCgl2tOQ8FkzBLbjCThN+VIxGm1iq/S2lOXku8roTHNgJI/WFnQ==
X-Received: by 2002:a17:906:f0cc:: with SMTP id dk12mr488324ejb.480.1609873251916;
        Tue, 05 Jan 2021 11:00:51 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id z13sm205084edq.48.2021.01.05.11.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 11:00:51 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jiri Benc <jbenc@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Florian Westphal <fw@strlen.de>, linux-s390@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-parisc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        dev@openvswitch.org
Subject: [RFC PATCH v2 net-next 04/12] net: sysfs: don't hold dev_base_lock while retrieving device statistics
Date:   Tue,  5 Jan 2021 20:58:54 +0200
Message-Id: <20210105185902.3922928-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210105185902.3922928-1-olteanv@gmail.com>
References: <20210105185902.3922928-1-olteanv@gmail.com>
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
 net/core/net-sysfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 999b70c59761..0782a476b424 100644
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

