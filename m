Return-Path: <netdev+bounces-1853-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BA6D6FF4BA
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:42:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E95291C20EB4
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:42:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 226AB372;
	Thu, 11 May 2023 14:42:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1267A36D
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 14:42:40 +0000 (UTC)
Received: from mail-ej1-x664.google.com (mail-ej1-x664.google.com [IPv6:2a00:1450:4864:20::664])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C11F11DBC
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 07:42:30 -0700 (PDT)
Received: by mail-ej1-x664.google.com with SMTP id a640c23a62f3a-9661a1ff1e9so980739766b.1
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 07:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google; t=1683816149; x=1686408149;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IlMEdv60lCdLqi6rRnnRAfr3hSy+NYDh68IMrkOcuA0=;
        b=TyAdxVPGVqcpvqa0BJkgRQfqRjC8XLO8P9Y6Xs5jFmBrWWLKDMOYLgmWfET5Y8ucpC
         U/3/mLI7xLr1Pnqlt35pNWAplsV/yHRLNRfxhHlA1r9J8NdeLak1PyBH/rw6/injypQs
         6GBQEfXvYtSUZE9mz6VjXegmKsvanmKIByNEDhrgKbEfw2Y9fUrVfkBy4QkRvwQv3uZd
         QUW78REGMNvlwKD07nsJ1RpDLIpqx6TSb2K7s7lAELiln+71YHBmD1gkpql2nbkDlD2s
         4jZEpyWowvS6zpAd+dShYUtHdVkc13lhV6AeWFqBhLvyymeyDui5QeY2hTLb68uwBGeI
         gEIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683816149; x=1686408149;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IlMEdv60lCdLqi6rRnnRAfr3hSy+NYDh68IMrkOcuA0=;
        b=C5h8cKmMHKlXb8OucQCCdwuBikgHuppu9/wPMUuTH2eIuvxOckiT/zBajA9ZBx9uO5
         PteybNojxBw33IeA70PVrbh2ceABT6gqxDT7EbhPZ7/akhdoRA+IyHaHD5ESqkpYsq9Q
         yZWQgTma/ncLSIo2YMwmKQVdm+Xhwb2ADaWcAvKnIqmm6lcF0TF4314DS/36J9SOz7gL
         oihyg3Wrp1ysZyqAef68i0Rk6vRB3UZJ8CWC9acxTLnxHGtPgFFusLiz5LXrDxTGdGEC
         0SFVF5Y7KsgqnS++oX9Kw2XLjT3gvyjtZqvFnIvn3CmjWGzTPoa+TDo7uTB3UCN7ZzxP
         P8dw==
X-Gm-Message-State: AC+VfDz/4mK2c0x7jOY/svnlShgLsHtAokBM6/kpfAQh6+Jmr6YcG+8v
	TB2IMngXzqSNBI3XJRtdRC2KhWXxtQp+Gxo0fFEXESTVwxABgQ==
X-Google-Smtp-Source: ACHHUZ7bRd2SqvP4oDv+CqHGLek2NBauGwej77146iSCy7DYH4WW+N2PpjmSM66zaN5Q9IM6BJvlZaZrZWc7
X-Received: by 2002:a17:907:a4b:b0:958:514f:d88a with SMTP id be11-20020a1709070a4b00b00958514fd88amr17770690ejc.34.1683816148642;
        Thu, 11 May 2023 07:42:28 -0700 (PDT)
Received: from smtpservice.6wind.com ([185.13.181.2])
        by smtp-relay.gmail.com with ESMTP id ox25-20020a170907101900b0094f3e169cb1sm2418745ejb.159.2023.05.11.07.42.28;
        Thu, 11 May 2023 07:42:28 -0700 (PDT)
X-Relaying-Domain: 6wind.com
Received: from bretzel (bretzel.dev.6wind.com [10.17.1.57])
	by smtpservice.6wind.com (Postfix) with ESMTPS id 5C954601AD;
	Thu, 11 May 2023 16:42:28 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
	(envelope-from <nicolas.dichtel@6wind.com>)
	id 1px7Uy-00071a-8v; Thu, 11 May 2023 16:42:28 +0200
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: David Ahern <dsahern@gmail.com>,
	netdev@vger.kernel.org,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH iproute2] ipnetns: fix fd leak with 'ip netns set'
Date: Thu, 11 May 2023 16:42:24 +0200
Message-Id: <20230511144224.26975-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

There is no reason to open this netns file. set_netnsid_from_name() uses
netns_get_fd() for this purpose and uses the returned fd.

Reported-by: Stephen Hemminger <stephen@networkplumber.org>
Fixes: d182ee1307c7 ("ipnetns: allow to get and set netns ids")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 ip/ipnetns.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/ip/ipnetns.c b/ip/ipnetns.c
index 1203534914fe..9d996832aef8 100644
--- a/ip/ipnetns.c
+++ b/ip/ipnetns.c
@@ -967,9 +967,8 @@ int set_netnsid_from_name(const char *name, int nsid)
 
 static int netns_set(int argc, char **argv)
 {
-	char netns_path[PATH_MAX];
 	const char *name;
-	int netns, nsid;
+	int nsid;
 
 	if (argc < 1) {
 		fprintf(stderr, "No netns name specified\n");
@@ -988,14 +987,6 @@ static int netns_set(int argc, char **argv)
 	else if (nsid < 0)
 		invarg("\"netnsid\" value should be >= 0", argv[1]);
 
-	snprintf(netns_path, sizeof(netns_path), "%s/%s", NETNS_RUN_DIR, name);
-	netns = open(netns_path, O_RDONLY | O_CLOEXEC);
-	if (netns < 0) {
-		fprintf(stderr, "Cannot open network namespace \"%s\": %s\n",
-			name, strerror(errno));
-		return -1;
-	}
-
 	return set_netnsid_from_name(name, nsid);
 }
 
-- 
2.39.2


