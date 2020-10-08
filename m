Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9060F28756D
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 15:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730429AbgJHNuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 09:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730399AbgJHNut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 09:50:49 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C14C061755
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 06:50:49 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id h24so8204401ejg.9
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 06:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FlFQHHVj4IoDeVU7kJZFVW8ehm4+dl4AEtWuRJN8els=;
        b=G7ErnkHq+eFr52/6R9p/y4mUxNpA161ItZ/XDkj1CG3+ty03ei0XI5msRluv/boaB7
         YX9NuFvUoUI7K20Sv1x+m+u55ws1y7CA6A3LeR/0QTX0UL06G6a+pCA8BXHDw4TdxX8U
         bKf+ieXWGlOrdp0wKUMY14igclF7Q1AkKDUgxOBzrEXYBi1EJcFvnUmrBdNCEfzHrOGY
         A3DznTBYcpauCGpjnP2AEB+7ea9wUm0Biyu7LVHuVTmUVLJW8ShEUm7sOSobqutBhYvv
         fzaCWJ1btsaUkkE/GqfQli5urS/wWD7fbqeQ3hu6dsTCv+CvGzPykzUuIv231tKZin1V
         0F+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FlFQHHVj4IoDeVU7kJZFVW8ehm4+dl4AEtWuRJN8els=;
        b=e4ILNcq1e8BVLmzVptIr6GkHjyuwfY31rH1p3gACzFnbfiui9KwjK9ctgC4VkPqlap
         OyOzkT1IDWx2Jd2TLIhxGzA+xQ2OTFISwf8VePt2O/ricTHsjlFzzXs1Ht1spNpMlojB
         Ezdrulsoxs6mI9C/4pXKD1c4vMKWy47RKAiI4TFRKwq7wTIuU/obZSkxDD0KVYm5m371
         H5RMxjSwHu3Cbdym2m0kCmW6AfYNrmw178fluTzBuKMlsrymc2ia53p9LcRWqgC/51Oz
         UnicWvYuYTBjVdebG18FXuBaiAJzEgk/uvTf3AHitJEHYkPKf8zIgVhxd9UALgfFXeBT
         YIyw==
X-Gm-Message-State: AOAM533Z8oRbeOIu4hhWeboHNF9bbkiXc0zJ8qreu/NHsySHKaFGvUOh
        jueQxrHeZLSL7iAzeXkaYTnY6Ld2m3/kSpGt
X-Google-Smtp-Source: ABdhPJzQyl8ZIXb/E10om04StJLwH32LZ/lDuqO3B2VEtFbtncwZY57VrU1ZOMGXSMGIeEEbBO1bkQ==
X-Received: by 2002:a17:906:cf9d:: with SMTP id um29mr8665238ejb.307.1602165047703;
        Thu, 08 Oct 2020 06:50:47 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id w21sm4169617ejo.70.2020.10.08.06.50.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 06:50:47 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 2/6] bridge: mdb: print fast_leave flag
Date:   Thu,  8 Oct 2020 16:50:20 +0300
Message-Id: <20201008135024.1515468-3-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201008135024.1515468-1-razor@blackwall.org>
References: <20201008135024.1515468-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

We're not showing the fast_leave flag when it's set. Currently that can
be only when an mdb entry is being deleted due to fast leave, so it will
only affect mdb monitor.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 bridge/mdb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/bridge/mdb.c b/bridge/mdb.c
index 01c8a6e389a8..94cd3c3b2390 100644
--- a/bridge/mdb.c
+++ b/bridge/mdb.c
@@ -153,6 +153,8 @@ static void print_mdb_entry(FILE *f, int ifindex, const struct br_mdb_entry *e,
 	open_json_array(PRINT_JSON, "flags");
 	if (e->flags & MDB_FLAGS_OFFLOAD)
 		print_string(PRINT_ANY, NULL, " %s", "offload");
+	if (e->flags & MDB_FLAGS_FAST_LEAVE)
+		print_string(PRINT_ANY, NULL, " %s", "fast_leave");
 	close_json_array(PRINT_JSON, NULL);
 
 	if (e->vid)
-- 
2.25.4

