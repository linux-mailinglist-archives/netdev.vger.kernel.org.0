Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24EF12EB332
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 20:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729620AbhAETC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 14:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730730AbhAETCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 14:02:07 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4CFC0617A4;
        Tue,  5 Jan 2021 11:00:57 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id u19so1925574edx.2;
        Tue, 05 Jan 2021 11:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eVeK9xT+cQg4LNXHEMfEbDRIq/x+/jlGFuxcqUdAXkk=;
        b=jcC1h1LA3LIffEisBnCLmI474BqldfIodx219oNGc+tt7jVCAeTtqKvTzzBz9wGywY
         xLXZnkXKRb4tJyGv2FSzJHQe3VCsEwbeyxT8AM+ZiOvrAmuwX60JfOgfKjjpTrCSdR17
         31gEckmvlt5ym/S4IPYsGKaPpRfbE8UmicBunfKEp+VmZp+4a4khM6JGxjI3Hp6mfIJ8
         SBgCA6Ud37X2fK6DaSkslK97YsA56gd1r+QXOt2owRbKPq8OTBsc1SvCxnroBUNP6LFZ
         KYUhIkh6CgrLu0+wPKq4g6GQqq79w3dVBQd9zkObnAhpZI5YaBcR4QNJ4qwqV8rd68uY
         AMGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eVeK9xT+cQg4LNXHEMfEbDRIq/x+/jlGFuxcqUdAXkk=;
        b=H7y3w1G2Hv2h0mbmS8OdpZ0Ftp1U5mc65bZQ26l5x+G8WS791HiJKU9lDCopa3SP+D
         7hzk4x/bqkAZIdwwr1BA05NDSNTiFBjKN93CPFA6vJ4u81N6JmAJxBFkOWRuGefsvUiY
         O/qbGr9l5FipHShAWvw2xTXs7G6l3k8S96SJAUoWaCs3QXQW0Boy54m0fMhA0pidZwfq
         ZH/Oe8SwGv38u+BqizTuyVVmH1wWSK7VvzjCuIGhGsmd25nuT0uDScw6gC0HcumKWWKS
         UWqiEAJrqShXqc6ljOo7U+FKzosCURBpkXYpg73g3fJCeFaqQFMMWerI5Dg7VdbH8rgu
         Lmrg==
X-Gm-Message-State: AOAM530P2kp/jg9mRC+2sJZL5Qvbki3w44vR6wNNLdOiyI+QK9GB7fp9
        W/Iuu/i7HfVGy6LwGviIONM=
X-Google-Smtp-Source: ABdhPJywzGOkFcZAVkyk8PQ8M2oMIBob7kn/MLt8bOAZoMi0V7lOOqZiCgYYmkEvgxwjnb5ltoYSHw==
X-Received: by 2002:aa7:dd17:: with SMTP id i23mr1249282edv.14.1609873255865;
        Tue, 05 Jan 2021 11:00:55 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id z13sm205084edq.48.2021.01.05.11.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 11:00:55 -0800 (PST)
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
Subject: [RFC PATCH v2 net-next 06/12] parisc/led: reindent the code that gathers device statistics
Date:   Tue,  5 Jan 2021 20:58:56 +0200
Message-Id: <20210105185902.3922928-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210105185902.3922928-1-olteanv@gmail.com>
References: <20210105185902.3922928-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The standard in the Linux kernel is to use one tab character per
indentation level.

Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/parisc/led.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/parisc/led.c b/drivers/parisc/led.c
index 36c6613f7a36..3cada632a4be 100644
--- a/drivers/parisc/led.c
+++ b/drivers/parisc/led.c
@@ -359,16 +359,19 @@ static __inline__ int led_get_net_activity(void)
 	/* we are running as a workqueue task, so we can use an RCU lookup */
 	rcu_read_lock();
 	for_each_netdev_rcu(&init_net, dev) {
-	    const struct rtnl_link_stats64 *stats;
-	    struct rtnl_link_stats64 temp;
-	    struct in_device *in_dev = __in_dev_get_rcu(dev);
-	    if (!in_dev || !in_dev->ifa_list)
-		continue;
-	    if (ipv4_is_loopback(in_dev->ifa_list->ifa_local))
-		continue;
-	    stats = dev_get_stats(dev, &temp);
-	    rx_total += stats->rx_packets;
-	    tx_total += stats->tx_packets;
+		const struct rtnl_link_stats64 *stats;
+		struct rtnl_link_stats64 temp;
+		struct in_device *in_dev = __in_dev_get_rcu(dev);
+
+		if (!in_dev || !in_dev->ifa_list)
+			continue;
+
+		if (ipv4_is_loopback(in_dev->ifa_list->ifa_local))
+			continue;
+
+		stats = dev_get_stats(dev, &temp);
+		rx_total += stats->rx_packets;
+		tx_total += stats->tx_packets;
 	}
 	rcu_read_unlock();
 
-- 
2.25.1

