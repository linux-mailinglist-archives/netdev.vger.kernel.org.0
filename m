Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 798AF287570
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 15:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730439AbgJHNu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 09:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730430AbgJHNuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 09:50:51 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D5CC061755
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 06:50:50 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id dt13so8203152ejb.12
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 06:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l2td5ECxpYmhlLqAYXeFepzm66i6U+5LXnAP65W/2Z8=;
        b=ilnXrotoSGp3ZJLXfWwgAXSoKCvdX2jeyC7F9BkT7RqenbFmRt2SADJQcYUo+GXbfb
         j0GXG1FPxEMLRKet9ca3uXtiwh80Buynnk5yDi19Za1vcvGDbxg5WfEgTf3HhK1jFx9e
         iXOZq9NbQIQoDMBNS3VETvOllgHgIzdhVQZSY+c1Ax5epZlYs4HAbADSJtSGHCvGiQ7G
         bOWKeENv0F8QtOKziOQjmhKCIJAKxNamMnt/yrVnrcz28oJkXM5/hX9P1uGM7HzxuYQe
         WAUTljg5/AJ5eEnqU2RjxgAmJJU9SDV4Fs+txV6uoGy262mqgkmslcgKOzbxfZ3tX/mV
         7FFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l2td5ECxpYmhlLqAYXeFepzm66i6U+5LXnAP65W/2Z8=;
        b=pTpZeJcDmcDYHZhZwAFvx1+uXD9024xGCkNNDISgkdoDMimt2GFSSOkZFQaVaNz2o4
         U6qWutzn8oXha5YbcWZoH1uWsVCP1xg8teMFrdDwUT6WUb6rC1eSzEYilz7TxkM7Hp9F
         dSqbnq5ppZi+Lc1GoosO7oJ8589w9T7sVEDGlLoUy70/6Jo3ZzHjYkz10CXqSnZP2AMy
         OdKULQ3p8gE4mrXJtwk9WUJFbm+zxiF3n/9zXhV0+HNBrRUFVKoBUWoXodKMVh34LhcL
         ZvMdxjqFIDPIAYHabUgGc8Rtnc/imGqFgzCrdAnLLQAqtiQ9Bkhh6JA/Jee0Vfutxe2i
         xvzw==
X-Gm-Message-State: AOAM532rLnydShlWIasfjn98/sjojSDU0oNIXlH3a3ZmQSlbAlQ/EDRu
        vjYUExtN3vkC+tlTa/eiedm/o4MF0NawWE3O
X-Google-Smtp-Source: ABdhPJzUQmX8yVOzXyi+jaCyJVrAwpEBSRnbaLyZ1P3YtZDTctYxPkFIOLGXRO8qDiE1zm+r/buCHA==
X-Received: by 2002:a17:906:cede:: with SMTP id si30mr9201495ejb.236.1602165048935;
        Thu, 08 Oct 2020 06:50:48 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id w21sm4169617ejo.70.2020.10.08.06.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 06:50:48 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 3/6] bridge: mdb: show igmpv3/mldv2 flags
Date:   Thu,  8 Oct 2020 16:50:21 +0300
Message-Id: <20201008135024.1515468-4-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201008135024.1515468-1-razor@blackwall.org>
References: <20201008135024.1515468-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

With IGMPv3/MLDv2 support we have 2 new flags:
 - added_by_star_ex: set when the S,G entry was automatically created
                     because of a *,G entry in EXCLUDE mode
 - blocked: set when traffic for the S,G entry for that port has to be
            blocked
Both flags are used only on the new S,G entries and are currently kernel
managed, i.e. similar to other flags which can't be set from user-space.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 bridge/mdb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/bridge/mdb.c b/bridge/mdb.c
index 94cd3c3b2390..d33bd5d5c7df 100644
--- a/bridge/mdb.c
+++ b/bridge/mdb.c
@@ -155,6 +155,10 @@ static void print_mdb_entry(FILE *f, int ifindex, const struct br_mdb_entry *e,
 		print_string(PRINT_ANY, NULL, " %s", "offload");
 	if (e->flags & MDB_FLAGS_FAST_LEAVE)
 		print_string(PRINT_ANY, NULL, " %s", "fast_leave");
+	if (e->flags & MDB_FLAGS_STAR_EXCL)
+		print_string(PRINT_ANY, NULL, " %s", "added_by_star_ex");
+	if (e->flags & MDB_FLAGS_BLOCKED)
+		print_string(PRINT_ANY, NULL, " %s", "blocked");
 	close_json_array(PRINT_JSON, NULL);
 
 	if (e->vid)
-- 
2.25.4

