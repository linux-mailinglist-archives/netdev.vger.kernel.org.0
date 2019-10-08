Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5FCCF8FE
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 13:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730754AbfJHL5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 07:57:07 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35608 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730495AbfJHL5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 07:57:06 -0400
Received: by mail-pf1-f196.google.com with SMTP id 205so10659652pfw.2
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 04:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hvaDUZOLSF0wxoWkqzUVwDaFexl/5LBjhvozWaJtZAI=;
        b=k7sHcASbBxplKoSEsUXruYgwDDf7qetguZDjMU7Hl6e95E0NuR/FMsFLGK1CEvjpYS
         CKZpROrs5H4vrsfsukNjKRWCRSfEDXSyWKpEGxOHoNToVm4KyXbpTIBKbLKds5qkGkof
         FV1lkKUog07tDO4ZgpOwjbcuUwiYCTMgvH0luNiXyR/s5buNSlUm6xyXo8W30XwKsdKE
         rNEVxOkKG5DEWcSstEyLi9n1xVY4cpe5tp0R36e/s+AbVtbh+5xf9e8ypThqEnqmnPc1
         Wl7hWma6dj4H+FMmK+SsTubGJuvy17ao3n5GdrgU1Ui0GHueg4x/rKuQhq8/lquXbrNO
         xOeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hvaDUZOLSF0wxoWkqzUVwDaFexl/5LBjhvozWaJtZAI=;
        b=UkAOUmuOKwA9+9kQqdP15evoHob9If2KWA6aoUeiYoyfQkaVdS0TQzbWdV0yviq2WS
         7ZbhJRVRq0neZhF7DRCGIcRisOWbSRKb1QC+uhSMrIJ/xKCrnPolz703D2lvJCQ7PCcX
         /rwmLlF4mryaQrCavOXVBzBBZLViMWfqDJmicP52BLaGE4xFA3meuSl6DfHMtpcSjn51
         y0qiLdD2uBGLwSHjM0zELZxevyz6doiF6yb66iN/v7nypF1TCL123aLxDKhWTLILX38c
         ZWegeZDuvmEKBvIJlx5QlJKUU5VQiRuolhrV6BcalnjXLUA+6yszzguKv0t67yHypqUb
         6icQ==
X-Gm-Message-State: APjAAAWDRbKnPMPfQ3COJSgdweAS0Wci25HdVdiGEt2fULKWTr6bTODk
        fjqIMv7IiEobjl2vnrnJ4dSBAeRG
X-Google-Smtp-Source: APXvYqys59dyBYmtONXXuX5Dez4kdcdTFQp82/M2cnlnC89msL46wLDMKAqFJHu+wS1tzPdV4dSadw==
X-Received: by 2002:a65:6095:: with SMTP id t21mr310176pgu.197.1570535825583;
        Tue, 08 Oct 2019 04:57:05 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id b14sm18149932pfi.95.2019.10.08.04.57.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 04:57:05 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v2 06/10] net: openvswitch: simplify the flow_hash
Date:   Tue,  8 Oct 2019 09:00:34 +0800
Message-Id: <1570496438-15460-7-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1570496438-15460-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1570496438-15460-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Simplify the code and remove the unnecessary BUILD_BUG_ON.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/flow_table.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 7edddd9..667f474 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -432,13 +432,9 @@ int ovs_flow_tbl_flush(struct flow_table *flow_table)
 static u32 flow_hash(const struct sw_flow_key *key,
 		     const struct sw_flow_key_range *range)
 {
-	int key_start = range->start;
-	int key_end = range->end;
-	const u32 *hash_key = (const u32 *)((const u8 *)key + key_start);
-	int hash_u32s = (key_end - key_start) >> 2;
-
+	const u32 *hash_key = (const u32 *)((const u8 *)key + range->start);
 	/* Make sure number of hash bytes are multiple of u32. */
-	BUILD_BUG_ON(sizeof(long) % sizeof(u32));
+	int hash_u32s = range_n_bytes(range) >> 2;
 
 	return jhash2(hash_key, hash_u32s, 0);
 }
-- 
1.8.3.1

