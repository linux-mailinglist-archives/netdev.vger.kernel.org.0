Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0B496290C4
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 04:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbiKODYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 22:24:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbiKODYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 22:24:16 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD0AB1E
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 19:24:15 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id s196so12103401pgs.3
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 19:24:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nZIw+4wRNs0H18koHiZbCawBpHsMHH6lJytzr7sid2k=;
        b=hUNRrtpZxUTvaf4UwxuWODJzQgDGX/Uxr0P2iZykbBrkK6Qq3eL59b5ObAlJioRh8B
         3hqxSThSdLo6iTI96NeQPYE4pPNFIUGasn46wMgICw4By9LVoECe9UlMtqLfMS/YQuNW
         tN1zEmpg3/XWw5g/vBs7ZvIt81v7EQ7npNAtglcNq+mxqy3SuZkCESp/NJ7SRQ3bBSMQ
         O6bHp22OLryZoSCiVj89uQYzsXYErGiFB5SRGH2k82TTEjyYSufFboWyvnecc+ZAZlVr
         ux47OSbvHo808vVSmDgWG+hPNsI7/JWvCI6ttDseYN4VDbAVAIhFO5CVRecM4YtK4pjh
         FFng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nZIw+4wRNs0H18koHiZbCawBpHsMHH6lJytzr7sid2k=;
        b=MBskEqPKM1i8GuT51EBQjO7iwLqmSOSl+GAtpg4o5jhv9k39aKYrHnxi84nz04g1IC
         nGA/0Q6uktmKBsaQd9S2YsBqOlc9WKM6hIBKJ97rMcuCBSfQqRK/ANsloH31+9pDf76G
         8eJiUitP3h0vpQSlYMCza4XfXgY5H5KQAXrizhU1Tf24j/X7WIuFR6rv1D3tUgo+a7nN
         8mmoZ4U8oiEWLNqJI3hZiFOhA8gQ7d6+7tHMWQIYYMlgAIjrVab/hdGue9obvTh8WJoj
         d2M7iHAmrJpJ/NIKof8TBv6lmA1+Heli0n0pA5KkvnPUDNVCcNUri2oOgmeSDSEQ6WtO
         ffHw==
X-Gm-Message-State: ANoB5plYu3SDPVmD9iEJ2x/AmWxZxk7g4cO4l6BosBWeV5UK/3uLdutp
        bwdHms7e8ITy2GAFiFcePQ78reQpqonB9Q==
X-Google-Smtp-Source: AA0mqf5YktbnViZm2jbMx5qmP8p7/WET6ukunfIivfsDOe1egIAxhlcBE+BV4qANsqAahNonzEjVdQ==
X-Received: by 2002:aa7:8d9a:0:b0:56b:ebd3:43b4 with SMTP id i26-20020aa78d9a000000b0056bebd343b4mr16255689pfr.61.1668482654051;
        Mon, 14 Nov 2022 19:24:14 -0800 (PST)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id g75-20020a62524e000000b0056164b52bd8sm7510561pfb.32.2022.11.14.19.24.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 19:24:12 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH iproute2] Revert "tc/tc_monitor: print netlink extack message"
Date:   Tue, 15 Nov 2022 11:24:00 +0800
Message-Id: <20221115032400.1175169-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 0cc5533b ("tc/tc_monitor: print netlink extack message")
as the patch mentioned in the commit ("sched: add extack for
tfilter_notify") is not applied to upstream.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tc/tc_monitor.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tc/tc_monitor.c b/tc/tc_monitor.c
index c279a4a1..f8816cc5 100644
--- a/tc/tc_monitor.c
+++ b/tc/tc_monitor.c
@@ -42,9 +42,6 @@ static int accept_tcmsg(struct rtnl_ctrl_data *ctrl,
 	if (timestamp)
 		print_timestamp(fp);
 
-	if (n->nlmsg_type == NLMSG_DONE)
-		nl_dump_ext_ack_done(n, 0, 0);
-
 	if (n->nlmsg_type == RTM_NEWTFILTER ||
 	    n->nlmsg_type == RTM_DELTFILTER ||
 	    n->nlmsg_type == RTM_NEWCHAIN ||
-- 
2.38.1

