Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E65E49208F
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 08:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236433AbiARHwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 02:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234433AbiARHwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 02:52:08 -0500
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA753C061574;
        Mon, 17 Jan 2022 23:52:07 -0800 (PST)
Received: by mail-qk1-x72d.google.com with SMTP id d11so8837595qkj.12;
        Mon, 17 Jan 2022 23:52:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ARPIxdFgO3QwR8chXKrHvtWtalXkDgZkqXDak149zP4=;
        b=Oa45b6lk6t6a6enAMlpgLgz0UgXbGc0X+YDqMc13DQVllR4CpP6Vm1hd1PPW86FbwC
         PgSL5lICmMxPhE3sgJDqmoTlTBLasC79sV7oesTHXdBX/tb3gt/InDx3d972ZhuLEGS3
         fdRvOoFsQh09455+HIBvHTHTsHQcA6nEdDD0cgJ+IfcJd9NxW1RnCULKNggWoxq8HWoW
         g5I3P7111Xd12vnKNpUymBBqeWgJdnRjVt+z3l8+5XtfoHCyYROIeK6WbbSseLH5n2Sz
         6rKCHVdTXTs1VsquyzCg9i7RrVFOwOMDgDlk327zZ/QeiWLfysoTA3kdIPkcyerC5Z8v
         PDwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ARPIxdFgO3QwR8chXKrHvtWtalXkDgZkqXDak149zP4=;
        b=V+0SbcDzc6B++Dt4L7bnlPA8ytXG99eavLPDjjIfe7m+b8kinjZ4eAGgIEre9n5PzL
         PI3CkZ7N3yDykKcKCH0FT5fg5gKVeSKK9rxoZ/w0SsnwA5+scCN6GpbkQIJCcmlqD1BF
         QBAnAR0ZXHNAnQ47YNvMgkRrCl0CuqoMkEvi0UK/4zQxrEz823BTiCFCkN6BKY3YaBfx
         us9QgEnQHg8d+GfwehPdKVWy6/Wq8wT2yNZ44VhnFHc9MTAIlwOnvFAuAD5/wOLp3nvP
         3ad2yQH/oYDwaRa7g9kxL3NrJ8SUvjelEW+ZzK07g8W4/xwVwqcW3eKbEdwrO+kwMu70
         +G1g==
X-Gm-Message-State: AOAM532wtqS+fuaIoZJszaJzEHTYTInA54XlIWh7a7iMajuSwbcLV1rj
        Cir4DrgCOV3fdeOg1WzYLNqMjzyZP8Y=
X-Google-Smtp-Source: ABdhPJzn0mH/orswoGcx5mEDo9sQiZ3VhpO4J+W6w3+/5G5d3n7CT6acqQeGrmpblhgyvRZ28ZQx5Q==
X-Received: by 2002:a05:620a:2848:: with SMTP id h8mr17320606qkp.270.1642492327001;
        Mon, 17 Jan 2022 23:52:07 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id bk14sm3532064qkb.35.2022.01.17.23.52.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 23:52:06 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>, CGEL ZTE <cgel.zte@gmail.com>
Subject: [PATCH] net/ipv6: remove unneeded err variable
Date:   Tue, 18 Jan 2022 07:51:59 +0000
Message-Id: <20220118075159.925542-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

Return value from rhashtable_lookup_insert_fast() directly instead
of taking this in another redundant variable.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
---
 net/ipv6/seg6_hmac.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/ipv6/seg6_hmac.c b/net/ipv6/seg6_hmac.c
index 29bc4e7c3046..f8e25e3a5944 100644
--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -291,12 +291,9 @@ EXPORT_SYMBOL(seg6_hmac_info_lookup);
 int seg6_hmac_info_add(struct net *net, u32 key, struct seg6_hmac_info *hinfo)
 {
 	struct seg6_pernet_data *sdata = seg6_pernet(net);
-	int err;
 
-	err = rhashtable_lookup_insert_fast(&sdata->hmac_infos, &hinfo->node,
+	return rhashtable_lookup_insert_fast(&sdata->hmac_infos, &hinfo->node,
 					    rht_params);
-
-	return err;
 }
 EXPORT_SYMBOL(seg6_hmac_info_add);
 
-- 
2.25.1

