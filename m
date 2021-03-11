Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96585336F17
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 10:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbhCKJoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 04:44:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231904AbhCKJn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 04:43:58 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F28C061574;
        Thu, 11 Mar 2021 01:43:58 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id u18so9915370plc.12;
        Thu, 11 Mar 2021 01:43:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=jQIVJbhzgg9ExMqmPGfrcbGNRUuxXYmbfOhJYaQQYi4=;
        b=NHOvI6XY1tH9NH8L8YhqVRMWUxequ4w8UwfuGERHU6bus4Km+pfxVgyTpNwHdbAQhY
         CLkgYtOf7zs5peS1TQYIDgIgs8kUoVYaIQn5yDGNEmcE7l/CfJ0SNPdOXa1JjXBFsUDu
         mLIz2yS27If3BvxQuOlBxFC8Coe/LmEVyHrpiIvI0Y25QhX77U8eeIss6vILXwchQz9B
         ckLTTSqGgKJ6WILr01gTodq9GCrmKinA4fj+twzA+QRIc9ohnKZFbwOzDPYbN1z3h4Q2
         +G5hCs6lv4BIIYt/KMPl/YoVKbx+RDh0gRmHVB/I1sfQn5TTTm3glnMM6xcPCUjd4j40
         rCLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=jQIVJbhzgg9ExMqmPGfrcbGNRUuxXYmbfOhJYaQQYi4=;
        b=PCps7lzNyceA4RtRNmyCiuVwHdCuE1ILTiWbVIQc5QYzW1kLQrx7S2i34nkrbu+n7R
         CJHFo5BdNLo5lFpUR4INZIZtLWaHxtXEA8dN9RPrM1RXql3BnczTBDdrhtEtngwtuZjY
         T3W+GlWqRlH9SHTNBl/BMxT1jy/2GVNyfSGvmN0iOBm1VOYT10yeBroLuOxkVBg8JEsn
         tVwGm6EsKBfG/L/F64sVIqpQNw1DbBVJqHQ3FrLn5nJza4/cFWFCf1QG4hqjnC7pL96y
         GUsKwDHEa197ArCFK/UNyoy6X/5NqcHlW3tuI1J2trUzuPY6uM99qlou9OqWqxjI9XSl
         YmkA==
X-Gm-Message-State: AOAM533FAh4b1ZdnmbYwJZVF2kvE1xwDcIDoivcwRBXeAjrvo3dAswAf
        hnQVayx2m3g2+6sM3/Z6EmeUfUCM0QD0YYNw
X-Google-Smtp-Source: ABdhPJzFo1V2aQFgO8GTV3WKxfZ211m88OQti6EFoaJTA+t376UZ5jrVsYoD6WuvmD6XYTHOG3DoJw==
X-Received: by 2002:a17:902:8f8c:b029:e3:7e6c:36fa with SMTP id z12-20020a1709028f8cb02900e37e6c36famr7430132plo.77.1615455837746;
        Thu, 11 Mar 2021 01:43:57 -0800 (PST)
Received: from localhost ([122.179.55.249])
        by smtp.gmail.com with ESMTPSA id l15sm1800084pjq.9.2021.03.11.01.43.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Mar 2021 01:43:57 -0800 (PST)
Date:   Thu, 11 Mar 2021 15:13:49 +0530
From:   Shubhankar Kuranagatti <shubhankarvk@gmail.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, bkkarthik@pesu.pes.edu
Subject: [PATCH] net: core: bpf_sk_storage.c: Fix bare usage of unsigned
Message-ID: <20210311094349.5q76vsxuqk3riwyq@kewl-virtual-machine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changed bare usage of unsigned to unsigned int

Signed-off-by: Shubhankar Kuranagatti <shubhankarvk@gmail.com>
---
 net/core/bpf_sk_storage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index 4edd033e899c..d99753f88a70 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -723,7 +723,7 @@ EXPORT_SYMBOL_GPL(bpf_sk_storage_diag_put);
 struct bpf_iter_seq_sk_storage_map_info {
 	struct bpf_map *map;
 	unsigned int bucket_id;
-	unsigned skip_elems;
+	unsigned int skip_elems;
 };
 
 static struct bpf_local_storage_elem *
-- 
2.17.1

