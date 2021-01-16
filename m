Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C62C2F8A6E
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 02:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729173AbhAPB0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 20:26:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729073AbhAPB0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 20:26:33 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE9E3C061795
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:25:52 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id v24so9247713lfr.7
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=I2MDp2bsfstQYUyH+t/jAMlPvFO7J70eM+caStL93S4=;
        b=HgCm51uOmmKcMOOzJyPBW8W9pzpFlPTbTuuWJbZtclF+6wZNy4ioleqYqSKb32bTsY
         6IpECem7J/FBbSsNy6YmZZSyfx4yrzvaoMxQ8veLuC1qBpUOqLLwt2OnPLZTusS5Y1ec
         AyTYnpIxSPChZirGJ02qDjZy5FbFFzqcl8Eg5ASV1ZrPCxbzC8fe5z7tBBoX39/Z4U4F
         JIGxyZru5sZPAWPiKr7xcRSWd7NBY5KtxeCdwZALYA6+l3/wDMEZt2rEBKwcM/6XOE6L
         kB0NvpUVs5saKxchAhDsWhg/EuatJM7xrGZlVERyJE51IcV7hb2pnxDgNM9S8n2hD0ng
         jVcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=I2MDp2bsfstQYUyH+t/jAMlPvFO7J70eM+caStL93S4=;
        b=jbOpnWlmy5cxTDwhvHiG3C5sSI3fn/v8q4RJUI4waW3gkWSJktRrsjLSoBPGNs3JR4
         vj1hn8SfPfuh+NWtekDUe+Llbcb+xXecb/vtaJjDq1yMLEU4wTRiQcWc13gKNMvWRmxV
         5JxA26pColYLVAeUChwGI242ccFoG6mfuQsK19ue26IUNbqh6odWxCiXYznL+acvX/YD
         tjxyraLasZnynqJaMtjRxjkpBswaW3HyWdZR9dcleVqH8y7U4OOuptxt8rbYH/Gkcow5
         9sqhTkACqafDUXEi2PbkpqLBFQvBGl2NbE28re1TSYO6pAhtWHbPubCw5ztADJ9gi+cJ
         E/9Q==
X-Gm-Message-State: AOAM533YkVOSY91uRluWTNhHfl7qUgiN6s32foduS+w+NkhVwl4SDLY8
        oGfBb/CDDZI77ts4ePAgxr/dNw==
X-Google-Smtp-Source: ABdhPJyq5hlVxENQf/30b+v+mSkh9rTkO1S8RYxQPbKcmvvqHb6cGZypqpXOUpJ1mIbDQW5GWwLUyg==
X-Received: by 2002:a19:4813:: with SMTP id v19mr7237054lfa.655.1610760351421;
        Fri, 15 Jan 2021 17:25:51 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id 198sm1085686lfn.51.2021.01.15.17.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 17:25:50 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, roopa@nvidia.com, nikolay@nvidia.com,
        netdev@vger.kernel.org
Subject: [RFC net-next 4/7] net: dsa: Include local addresses in assisted CPU port learning
Date:   Sat, 16 Jan 2021 02:25:12 +0100
Message-Id: <20210116012515.3152-5-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210116012515.3152-1-tobias@waldekranz.com>
References: <20210116012515.3152-1-tobias@waldekranz.com>
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add local addresses (i.e. the ports' MAC addresses) to the hardware
FDB when assisted CPU port learning is enabled.

NOTE: The bridge's own MAC address is also "local". If that address is
not shared with any port, the bridge's MAC is not be added by this
functionality - but the following commit takes care of that case.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 net/dsa/slave.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index c5c81cba8259..dca393e45547 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2174,10 +2174,12 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 		fdb_info = ptr;
 
 		if (dsa_slave_dev_check(dev)) {
-			if (!fdb_info->added_by_user)
-				return NOTIFY_OK;
-
 			dp = dsa_slave_to_port(dev);
+
+			if (fdb_info->local && dp->ds->assisted_learning_on_cpu_port)
+				dp = dp->cpu_dp;
+			else if (!fdb_info->added_by_user)
+				return NOTIFY_OK;
 		} else {
 			/* Snoop addresses learnt on foreign interfaces
 			 * bridged with us, for switches that don't
-- 
2.17.1

