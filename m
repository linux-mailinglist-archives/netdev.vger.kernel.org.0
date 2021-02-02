Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3EF930B80D
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 07:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbhBBGxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 01:53:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232142AbhBBGww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 01:52:52 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D28DC0613D6
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 22:52:12 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id a8so26386308lfi.8
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 22:52:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BGpaEg0j3hIwyT8YaseDu5lYmdNhnyii6Jj6H/mUeXo=;
        b=rJJpb6Gr/wnUyH7/l9E0f1w3TZ0gsreY+z4vzVPMoCcH6TLss83WLIOSh+/BCzTH3d
         xo8YpOS2P6R/dmJSUmxBcrzoge0ZqcGxT539X4x+Okq2wJAICq4cEDTjm6SEme1EcKYB
         gAVLXcW+OVun4xJE0GnJXfsHWuFmMPgEz7P3GQVx1awJlfFqQ6QPG1n9JZUtd3h9aLMj
         jTvCjer7Mar7bdKm3ydrYhpuQ6vHbAHM+K+vU1OHM0/8gGqTGfrzgGNZ0I0UVOgwJH6k
         UhIHuvKKEXqyBNinGr2BovDxMfch5UMbpe9H7XCkUwP/5H0Seg2/2hiPIUs67SVAPYlZ
         h7jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BGpaEg0j3hIwyT8YaseDu5lYmdNhnyii6Jj6H/mUeXo=;
        b=Ib8bUri4Dy4UIiq9vqPqlWFbcJxFpVWxHDVOATRiaao3EnDw4lE0OhSWA7OsRqprv7
         1oaSCoRkt+C8z30AstiN3LIryZM5vIjGK8dvwn0vqi6bU34Z/YU3pFieWN5LkFQnTSq0
         cuWhpGKCMt0BHpeiJgxbFLUjYuP/4CXhakurq3i7mHt/jmB/2Wq79FnoxWkSpDKP7E1m
         RWyFKBMSF5TRTOM6TpuCnm3sx9/i05n8H9julO1LtRXBq2BGSoyYpzBHHvDWFQcKC/sw
         l67ffYKOS8/Ppy5jt8tGkjOXmgFQ/7Mvoe0CmGJ+E5ML7CjLUqGQgi4YZhvG3fY3iZ0+
         +7qQ==
X-Gm-Message-State: AOAM533encV6Y0cGE4G8/A8imPK5yDCM7xxa2gqlyXlb30R7ftzrQaeB
        kG2zZBYlf8U71u4LsSoVqBNdLQ==
X-Google-Smtp-Source: ABdhPJzxDgIH6xvZssFqhJ70L5O3+M32RAUmTRU4ws850VIr8Sv9UHUrcU5Bw7nSxoypq0DL4+/Z+w==
X-Received: by 2002:a05:6512:ad3:: with SMTP id n19mr10506229lfu.328.1612248730949;
        Mon, 01 Feb 2021 22:52:10 -0800 (PST)
Received: from mimer.emblasoft.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id b26sm2535171lff.162.2021.02.01.22.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 22:52:10 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     laforge@gnumonks.org, kuba@kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org
Cc:     Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH net-next 3/7] gtp: include role in link info
Date:   Tue,  2 Feb 2021 07:51:55 +0100
Message-Id: <20210202065159.227049-4-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202065159.227049-1-jonas@norrbonn.se>
References: <20210202065159.227049-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Querying link info for the GTP interface doesn't reveal in which "role" the
device is set to operate.  Include this information in the info query
result.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
Acked-by: Harald Welte <laforge@gnumonks.org>
---
 drivers/net/gtp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 5a048f050a9c..5682d3ba7aa5 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -728,7 +728,8 @@ static int gtp_validate(struct nlattr *tb[], struct nlattr *data[],
 
 static size_t gtp_get_size(const struct net_device *dev)
 {
-	return nla_total_size(sizeof(__u32));	/* IFLA_GTP_PDP_HASHSIZE */
+	return nla_total_size(sizeof(__u32)) + /* IFLA_GTP_PDP_HASHSIZE */
+		nla_total_size(sizeof(__u32)); /* IFLA_GTP_ROLE */
 }
 
 static int gtp_fill_info(struct sk_buff *skb, const struct net_device *dev)
@@ -737,6 +738,8 @@ static int gtp_fill_info(struct sk_buff *skb, const struct net_device *dev)
 
 	if (nla_put_u32(skb, IFLA_GTP_PDP_HASHSIZE, gtp->hash_size))
 		goto nla_put_failure;
+	if (nla_put_u32(skb, IFLA_GTP_ROLE, gtp->role))
+		goto nla_put_failure;
 
 	return 0;
 
-- 
2.27.0

