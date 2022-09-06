Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3C745AF66F
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 22:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbiIFU5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 16:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbiIFU5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 16:57:03 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685E89350D
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 13:56:51 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id t7so12224167wrm.10
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 13:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=PRqsWYZZH0s3GHQzsnOmHr+CxH/u15ul/CIYu9EYojs=;
        b=Vc9QaQE8ZfUf7ItbFMvQYVkMnX0f6ekQuvgXGvdF+seJxFAmGhZU4/sZzM4XxEMjKp
         Bw4VDC2zn+lHjwmmG+ga0OBUM9JHJjbAyQB7SRIgwBk4bFfGlXBe+AQwr0m2ooiMB1E6
         g0cjqP/MqzHpMFPaGU3LVjHNXSUv8yvec13xLxDaL4Ovjt8BeNHEQDmJoonssHWgvx/X
         PB4zHTc8Scb4UxDj9J0GCFqWPzYUCnllyPh1nxFrqwEA0J5vIX6zHkudspLS2HrA8us/
         fBZ7/Fno7MCwVrTyw0FSjccMQ+pSLZ9FfgMhHHnDfRVLwSZ6O4lKKGPPFkGRrUXvP93B
         MuyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=PRqsWYZZH0s3GHQzsnOmHr+CxH/u15ul/CIYu9EYojs=;
        b=XzN6lDHvvoyacVoZoGFXii1mXd4CutFn4lkhck0lV1Gp1hjpUO8kv8yH4IEKK9pkkA
         Q5kVHxVirmyl21GSow30zFGWq6Wvf+9PBsR6FtfkwtYgUf/MC+oTPF4u1ODdiO1zQOsV
         YjVrkDXGEfh7rKBOEbwGNqBgOkvzKKyp0kHsHYn2P/hJMq+y4aUUg1vKheG4JvBcoYtc
         C9KSV5sDhxHah7xiKdwu1jc1vpJS61W778x+GSWEdRsvE2E1v2uvm29zXjrx1/Usuh2k
         a4Xf2wj3ii6soFtjGXWtCvziSXOUkzr77oXJ2SfzVzZz6iaOhITDuFJHiGVIx0W5btMo
         zg6Q==
X-Gm-Message-State: ACgBeo2Y6rMqzzJ8R3EFImO0tpuYWhUeenVQbhooi4J8oXk+kHmwKpMi
        Nhmw5+GTTWT/pQR7hBJRxTucEw==
X-Google-Smtp-Source: AA6agR4pLdGZnGlAAJLaZh+M/E+8JiAP3AsAe0Vaci1KDqpNnMmIz2UttpItjJ4787L+hrDUmYj7Ig==
X-Received: by 2002:adf:fb10:0:b0:228:9072:72e1 with SMTP id c16-20020adffb10000000b00228907272e1mr150723wrr.459.1662497810733;
        Tue, 06 Sep 2022 13:56:50 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id n24-20020a1c7218000000b003a317ee3036sm15735887wmc.2.2022.09.06.13.56.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 13:56:48 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Thomas Haller <thaller@redhat.com>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/5] mptcp: allow privileged operations from user namespaces
Date:   Tue,  6 Sep 2022 22:55:42 +0200
Message-Id: <20220906205545.1623193-5-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220906205545.1623193-1-matthieu.baerts@tessares.net>
References: <20220906205545.1623193-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2701; i=matthieu.baerts@tessares.net;
 h=from:subject; bh=3W6+TJOTAo68xHMXohFmObHMW6ruenZqCo5JEcs+SRE=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBjF7O5PKfhLXp46IKTuhbxFJRXEMBLqpmcSLP2ZsMV
 idUjSFuJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCYxezuQAKCRD2t4JPQmmgc+q3D/
 9tWNzntGdWV3cJtFlqYZ74eleNBcqTmo/FFcgACrAoZRGXRSMygfyVd7RcWw6pxTrlCqCLxwTQcn7I
 K7eq5EmHyB0CIYg8ZMiEFR8s3joxLddN3xLmRELV3Sob8pAKc0lRF/FEGkHz0pMGb3cIzaLTezAXas
 pJkx0ufs0rPG6T2oZ0oxWuohbp26Hrd2EjWTdDb/gpwnhJT9aLhD6OmhwpVEKAiN6OJ+faxMRyoooG
 6lM1nifQobB0aO+3ZOLU/DmhZzVtx1d/Vn/i+EO5jBuk9TmLFHo5UVG0V61wGjKbXrqE1V88Lj8Z0k
 5RzVJcD8ekYq2EKBJm5MhIifxIudDkDFV62mgYfSg9v8Qlv2fBEr1HnQUIEhyr7E2ryYt+0sIpSazD
 sJfzTXXqEEaPXRZTV5dvCsoO4uw0GfIiNaDybuqTWUApeKdb/xNGJOkZp+Ta9WDq2Wcnwl454wEME2
 /q/x78qdSX3RPmKuDKcEr5VnZGwDd8qraCNbysp1c2N2+G0E7FvHBYqmaM4koDoR7d6SrLqmGxyXc3
 nz0537mhcNanyF0YOZdZot8GxiW9gh1SWld8y53nL2Iv/kYulTzM5VHX9Oju3ObpCJfn+CczCzYWB9
 5NYFg2Zzc4rhc5PtgXHmAhFQycp4WyOiFYiWsvG/HnIi77b/qUzRwuI+kEjA==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp; fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Haller <thaller@redhat.com>

GENL_ADMIN_PERM checks that the user has CAP_NET_ADMIN in the initial
namespace by calling netlink_capable(). Instead, use GENL_UNS_ADMIN_PERM
which uses netlink_ns_capable(). This checks that the caller has
CAP_NET_ADMIN in the current user namespace.

See also

  commit 4a92602aa1cd ("openvswitch: allow management from inside user namespaces")

which introduced this mechanism. See also

  commit 5617c6cd6f84 ("nl80211: Allow privileged operations from user namespaces")

which introduced this for nl80211.

Signed-off-by: Thomas Haller <thaller@redhat.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/pm_netlink.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 5e142c0c597a..afc98adf2746 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -2218,17 +2218,17 @@ static const struct genl_small_ops mptcp_pm_ops[] = {
 	{
 		.cmd    = MPTCP_PM_CMD_ADD_ADDR,
 		.doit   = mptcp_nl_cmd_add_addr,
-		.flags  = GENL_ADMIN_PERM,
+		.flags  = GENL_UNS_ADMIN_PERM,
 	},
 	{
 		.cmd    = MPTCP_PM_CMD_DEL_ADDR,
 		.doit   = mptcp_nl_cmd_del_addr,
-		.flags  = GENL_ADMIN_PERM,
+		.flags  = GENL_UNS_ADMIN_PERM,
 	},
 	{
 		.cmd    = MPTCP_PM_CMD_FLUSH_ADDRS,
 		.doit   = mptcp_nl_cmd_flush_addrs,
-		.flags  = GENL_ADMIN_PERM,
+		.flags  = GENL_UNS_ADMIN_PERM,
 	},
 	{
 		.cmd    = MPTCP_PM_CMD_GET_ADDR,
@@ -2238,7 +2238,7 @@ static const struct genl_small_ops mptcp_pm_ops[] = {
 	{
 		.cmd    = MPTCP_PM_CMD_SET_LIMITS,
 		.doit   = mptcp_nl_cmd_set_limits,
-		.flags  = GENL_ADMIN_PERM,
+		.flags  = GENL_UNS_ADMIN_PERM,
 	},
 	{
 		.cmd    = MPTCP_PM_CMD_GET_LIMITS,
@@ -2247,27 +2247,27 @@ static const struct genl_small_ops mptcp_pm_ops[] = {
 	{
 		.cmd    = MPTCP_PM_CMD_SET_FLAGS,
 		.doit   = mptcp_nl_cmd_set_flags,
-		.flags  = GENL_ADMIN_PERM,
+		.flags  = GENL_UNS_ADMIN_PERM,
 	},
 	{
 		.cmd    = MPTCP_PM_CMD_ANNOUNCE,
 		.doit   = mptcp_nl_cmd_announce,
-		.flags  = GENL_ADMIN_PERM,
+		.flags  = GENL_UNS_ADMIN_PERM,
 	},
 	{
 		.cmd    = MPTCP_PM_CMD_REMOVE,
 		.doit   = mptcp_nl_cmd_remove,
-		.flags  = GENL_ADMIN_PERM,
+		.flags  = GENL_UNS_ADMIN_PERM,
 	},
 	{
 		.cmd    = MPTCP_PM_CMD_SUBFLOW_CREATE,
 		.doit   = mptcp_nl_cmd_sf_create,
-		.flags  = GENL_ADMIN_PERM,
+		.flags  = GENL_UNS_ADMIN_PERM,
 	},
 	{
 		.cmd    = MPTCP_PM_CMD_SUBFLOW_DESTROY,
 		.doit   = mptcp_nl_cmd_sf_destroy,
-		.flags  = GENL_ADMIN_PERM,
+		.flags  = GENL_UNS_ADMIN_PERM,
 	},
 };
 
-- 
2.37.2

