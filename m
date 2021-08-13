Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25D783EB741
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 17:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241051AbhHMPAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 11:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241048AbhHMPAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 11:00:45 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26AF6C0617AE
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 08:00:18 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id qk33so18750855ejc.12
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 08:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aa6aODpsX834V6oU0xZmiqy1nFlZHpElVbhhKZgOhDo=;
        b=sQEOZPXHoxZtbTNkHHooY4Pumi+oskz2F8ufdb3z6JrWAZa1A6Q72GLJxcN3nWax19
         vihTl5SF3JYm2heSXB8FQ+QsvGRblKrLsjSWXbJ3D4a3Jx56AIA/ojVZn10ynMIiq/+z
         gPrEYy752hlctVr60LlMKKuPUpp5v2EoWndmvDAzPKzzHrjNSYltG4+ZWM0oM8hTYAyc
         RSLASk9DytjL35qgc/9+F0YRWQya24EEjesNUYKL/vELEnZ2KMaRUL60vYConZ7lTUwH
         nN4zfmFbt0wck+AGDxFMMRYtINkv5fV3oxZG4ePmPGi8X3wOk5YX7FT7pW7Cnpg4+sYF
         x6sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aa6aODpsX834V6oU0xZmiqy1nFlZHpElVbhhKZgOhDo=;
        b=JLryh/MEMLpSHWfiKYlmKF/AaQj6u8YT1627uA6/5+/SQxCtPi0D/vLB0J3YgXSM7O
         deDU9+cimAebRkmtvne3ONJX+mOPLjBHQsP8591j3igS+c+WLdc9gvALf9pcs4Z6uVBa
         j9jDLBdA+6izU9wC5uy9Fu9EWthbm2YNZO8f+M3MVwz9m4x882zXtgRA4DNAQZu63mo1
         QaC9OG575EjxAnGgi2oHRgp7L2rh7dJgh5/xcx/GJ5fOtunWfUfB6yYLoqR7PXC+JuCh
         IL5IzGrSeqBdc3tOUHtLzPH41i6q0EsnaBAozk/qHIrbakGhW33KUc8OxawhRGMW9QWE
         xJXQ==
X-Gm-Message-State: AOAM531YmqKXgfH+JJpRtTeOJFMzSObEbIY4fAWKPp/R4Ba1gJh4RhSf
        DKetR07mGHP1k/RUtfnFUxcZGafJi5cLn+O8
X-Google-Smtp-Source: ABdhPJzFsTMAlozstkoNR1mzooQNgJooaMiRFM9ZbCOcrTg0bzwofyZywtoh6eDuaMoWuHlZvOgzBw==
X-Received: by 2002:a17:906:c20d:: with SMTP id d13mr2796793ejz.259.1628866816195;
        Fri, 13 Aug 2021 08:00:16 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id d26sm1015711edp.90.2021.08.13.08.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 08:00:15 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 6/6] net: bridge: vlan: dump mcast ctx querier state
Date:   Fri, 13 Aug 2021 18:00:02 +0300
Message-Id: <20210813150002.673579-7-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210813150002.673579-1-razor@blackwall.org>
References: <20210813150002.673579-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Use the new mcast querier state dump infrastructure and export vlans'
mcast context querier state embedded in attribute
BRIDGE_VLANDB_GOPTS_MCAST_QUERIER_STATE.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 include/uapi/linux/if_bridge.h | 1 +
 net/bridge/br_vlan_options.c   | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index eceaad200bf6..f71a81fdbbc6 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -563,6 +563,7 @@ enum {
 	BRIDGE_VLANDB_GOPTS_MCAST_QUERIER,
 	BRIDGE_VLANDB_GOPTS_MCAST_ROUTER,
 	BRIDGE_VLANDB_GOPTS_MCAST_ROUTER_PORTS,
+	BRIDGE_VLANDB_GOPTS_MCAST_QUERIER_STATE,
 	__BRIDGE_VLANDB_GOPTS_MAX
 };
 #define BRIDGE_VLANDB_GOPTS_MAX (__BRIDGE_VLANDB_GOPTS_MAX - 1)
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index b4fd5fa441b7..49dec53a4a74 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -299,7 +299,9 @@ bool br_vlan_global_opts_fill(struct sk_buff *skb, u16 vid, u16 vid_range,
 	    nla_put_u8(skb, BRIDGE_VLANDB_GOPTS_MCAST_QUERIER,
 		       v_opts->br_mcast_ctx.multicast_querier) ||
 	    nla_put_u8(skb, BRIDGE_VLANDB_GOPTS_MCAST_ROUTER,
-		       v_opts->br_mcast_ctx.multicast_router))
+		       v_opts->br_mcast_ctx.multicast_router) ||
+	    br_multicast_dump_querier_state(skb, &v_opts->br_mcast_ctx,
+					    BRIDGE_VLANDB_GOPTS_MCAST_QUERIER_STATE))
 		goto out_err;
 
 	clockval = jiffies_to_clock_t(v_opts->br_mcast_ctx.multicast_last_member_interval);
@@ -379,6 +381,7 @@ static size_t rtnl_vlan_global_opts_nlmsg_size(void)
 		+ nla_total_size(sizeof(u64)) /* BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_INTVL */
 		+ nla_total_size(sizeof(u8)) /* BRIDGE_VLANDB_GOPTS_MCAST_QUERIER */
 		+ nla_total_size(sizeof(u8)) /* BRIDGE_VLANDB_GOPTS_MCAST_ROUTER */
+		+ br_multicast_querier_state_size() /* BRIDGE_VLANDB_GOPTS_MCAST_QUERIER_STATE */
 #endif
 		+ nla_total_size(sizeof(u16)); /* BRIDGE_VLANDB_GOPTS_RANGE */
 }
-- 
2.31.1

