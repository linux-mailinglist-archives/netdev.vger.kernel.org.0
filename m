Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF682EB340
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 20:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730877AbhAETCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 14:02:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730721AbhAETCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 14:02:06 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C6FC0617A0;
        Tue,  5 Jan 2021 11:00:51 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id ce23so1808096ejb.8;
        Tue, 05 Jan 2021 11:00:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gXxH7XycmXvUqlZcFwUkejt1OoMf3vVYxjArYoaytKU=;
        b=k7aJk7JSeBhjkdQYFq1o74fF9008dhO4twF9GnhDJvNLCvysN5ghZY0MukuT6Ldx5r
         hjfmUJdABmhBk5KkOrsRUGqy0EapxPCvw1mhmSEDxpRuKg2aFvSKl40pSwwrWuOV3Hk0
         GSN6axVYXCoqvCJoZmhqklr+jXNapYiDSKpCfSYX0D2SPOo2HfWFN1L2/P7hd9Ctrvdr
         yqVyTWk2F8ND0tpE8NarPyhgoS7DeBdv5pU7bmV9kEcmM5lXdfcp1Q8dLMmFyQ4fH3kN
         F4q1o1beQ8QiB4w4k+5OJ7v09Lhd9FnBi26qe9nITMkNxJPdmGZg9xIeStMil/AoyFlW
         eVkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gXxH7XycmXvUqlZcFwUkejt1OoMf3vVYxjArYoaytKU=;
        b=l+v46VUrqZIb/uO1BYtiq9U2bJ895oDtGjMTH/1+Qd/jNNoysrViIanymfiTGDMgzJ
         YLo/CbqKkeXWhZ36VshyVzeWYhaFU0bW2Ry3vTXC+a2ZBBA6mS0isA7SbJu3G48ktt7m
         VL3/VzsljlXV1Skk3sUJV4i5PPCGqUVrLcKbD9Rc6abFhDTyz2MYqGAjHjiexdakR6/B
         sUmx+wjSRD1aKQPqKA1mtAbcHgq+RXll4mQOGaZ/Wnw+bK1aed2u3YZcsTZh+gqYjgyF
         lfLM6GQ1GXbAcuKI2ReACM02teefWSA87oDR5qm0FMEfHjqvtzAj6Ms4LmgNSurv/W9q
         23Kw==
X-Gm-Message-State: AOAM532eS4uy6EojWBE/JX8BjCxaexyKIfWnilVnBPUIaW0iPF9kj1EO
        B30LLkxYMKeQTN5NCOD557k=
X-Google-Smtp-Source: ABdhPJwpcymrW8DoPhCny1stgOREGqkJGxUm2ZUJNyqT3MOT+DQW0wnVqqZPBdtZFvzWUrkJqlkOyw==
X-Received: by 2002:a17:906:e94c:: with SMTP id jw12mr524669ejb.56.1609873249982;
        Tue, 05 Jan 2021 11:00:49 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id z13sm205084edq.48.2021.01.05.11.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 11:00:49 -0800 (PST)
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
Subject: [RFC PATCH v2 net-next 03/12] net: procfs: hold netif_lists_lock when retrieving device statistics
Date:   Tue,  5 Jan 2021 20:58:53 +0200
Message-Id: <20210105185902.3922928-4-olteanv@gmail.com>
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

The /proc/net/dev file uses an RCU read-side critical section to ensure
the integrity of the list of network interfaces, because it iterates
through all net devices in the netns to show their statistics.

To offer the equivalent protection against an interface registering or
deregistering, while also remaining in sleepable context, we can use the
netns mutex for the interface lists.

Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/core/net-procfs.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index c714e6a9dad4..4784703c1e39 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -21,7 +21,7 @@ static inline struct net_device *dev_from_same_bucket(struct seq_file *seq, loff
 	unsigned int count = 0, offset = get_offset(*pos);
 
 	h = &net->dev_index_head[get_bucket(*pos)];
-	hlist_for_each_entry_rcu(dev, h, index_hlist) {
+	hlist_for_each_entry(dev, h, index_hlist) {
 		if (++count == offset)
 			return dev;
 	}
@@ -51,9 +51,11 @@ static inline struct net_device *dev_from_bucket(struct seq_file *seq, loff_t *p
  *	in detail.
  */
 static void *dev_seq_start(struct seq_file *seq, loff_t *pos)
-	__acquires(RCU)
 {
-	rcu_read_lock();
+	struct net *net = seq_file_net(seq);
+
+	netif_lists_lock(net);
+
 	if (!*pos)
 		return SEQ_START_TOKEN;
 
@@ -70,9 +72,10 @@ static void *dev_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 }
 
 static void dev_seq_stop(struct seq_file *seq, void *v)
-	__releases(RCU)
 {
-	rcu_read_unlock();
+	struct net *net = seq_file_net(seq);
+
+	netif_lists_unlock(net);
 }
 
 static void dev_seq_printf_stats(struct seq_file *seq, struct net_device *dev)
-- 
2.25.1

