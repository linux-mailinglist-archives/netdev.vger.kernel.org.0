Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D7A3B73D8
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 16:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234163AbhF2OJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 10:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233062AbhF2OJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 10:09:50 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B69E7C061766
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 07:07:22 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id bu12so36697835ejb.0
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 07:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HDFzCNuLgKoVL4N8qSF6ScaYL/eIkjL+npECoBu/hQ0=;
        b=Z+NmDbbOoqNFyAwTX/7hrCXLKPpKucfwvLs1E044CuiTg/WIh0FYHdH3XTFuXnIv8T
         jRQDJ4YGn3SLh05g7zy0X/k9AJTezaa/SQWIQ60e4oHXcx/9UPYivMmE29B5pR650rKR
         biGvahr0LHELWmuXBXzXz0cZk2+pfVAZ+2HiF1kQrGpfnIQK42VV7p9MEfF20VeO7NUV
         u7UmFBF6mAiSqXP3DVxfH88PM54TJrkbQGaWU8yhUqu991q9ZVBnCQH+6nUZS6ScjuM5
         mYZZMT1/EV5dIbbYTIjV4p6jkUi3yqN49KvE7y+WhSjl+MBV3olCOIVrpqpHG09ZmRoy
         RVcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HDFzCNuLgKoVL4N8qSF6ScaYL/eIkjL+npECoBu/hQ0=;
        b=Js9GnH/rKeVWr2qzYmuRj7R3NNMHbIrnk7Tr2FTMb6FlZrD3cwG/8ONXQTcqrUxUVR
         8nBm1L0J0R/rBw2AxgnXSjjYD4qSRwCsNk3iTWrqESMov65xEJjpUkGWZQivsa4Z/sre
         dao3vGiiBUGiYXj3MQXfwCWf0bTAxeg49HIOELY4yWs/XpFgFCn0HbmReH8KZE0ld0HL
         BnGusC48wpB4vuZdtXivK9czQA6Squ81BeTllZ+w6Ufnz06K6x9P6NHV1xxxTOdNNzdX
         s3ai5a2j7juCACveQ/UvT9fc52y2xaFIpaDySUkNjxPlqTKl9ef8HKP1k7jGHMYf2NjO
         JXGQ==
X-Gm-Message-State: AOAM5334N2pZGZuSbonc9IUV2NcL5ohqgXXNsJmJlINheZ3CVevvNp7t
        nNpi5WV/eMOnGQOm33DQhaOWrwccEYo=
X-Google-Smtp-Source: ABdhPJxBieTxy7gfTKdqHrukrQJVsjTj55lMkQHLUxdTPsDZKGfLYVnU8hAAekJDado5qe7PsER+OQ==
X-Received: by 2002:a17:906:b191:: with SMTP id w17mr31096730ejy.10.1624975641252;
        Tue, 29 Jun 2021 07:07:21 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id b27sm8220121ejl.10.2021.06.29.07.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 07:07:21 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        bridge@lists.linux-foundation.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v5 net-next 05/15] net: dsa: introduce dsa_is_upstream_port and dsa_switch_is_upstream_of
Date:   Tue, 29 Jun 2021 17:06:48 +0300
Message-Id: <20210629140658.2510288-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210629140658.2510288-1-olteanv@gmail.com>
References: <20210629140658.2510288-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In preparation for the new cross-chip notifiers for host addresses,
let's introduce some more topology helpers which we are going to use to
discern switches that are in our path towards the dedicated CPU port
from switches that aren't.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v4->v5: none

 include/net/dsa.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index ea47783d5695..5f632cfd33c7 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -491,6 +491,32 @@ static inline unsigned int dsa_upstream_port(struct dsa_switch *ds, int port)
 	return dsa_towards_port(ds, cpu_dp->ds->index, cpu_dp->index);
 }
 
+/* Return true if this is the local port used to reach the CPU port */
+static inline bool dsa_is_upstream_port(struct dsa_switch *ds, int port)
+{
+	if (dsa_is_unused_port(ds, port))
+		return false;
+
+	return port == dsa_upstream_port(ds, port);
+}
+
+/* Return true if @upstream_ds is an upstream switch of @downstream_ds, meaning
+ * that the routing port from @downstream_ds to @upstream_ds is also the port
+ * which @downstream_ds uses to reach its dedicated CPU.
+ */
+static inline bool dsa_switch_is_upstream_of(struct dsa_switch *upstream_ds,
+					     struct dsa_switch *downstream_ds)
+{
+	int routing_port;
+
+	if (upstream_ds == downstream_ds)
+		return true;
+
+	routing_port = dsa_routing_port(downstream_ds, upstream_ds->index);
+
+	return dsa_is_upstream_port(downstream_ds, routing_port);
+}
+
 static inline bool dsa_port_is_vlan_filtering(const struct dsa_port *dp)
 {
 	const struct dsa_switch *ds = dp->ds;
-- 
2.25.1

