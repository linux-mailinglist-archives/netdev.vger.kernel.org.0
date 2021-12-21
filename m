Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 290FB47C78C
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 20:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241824AbhLUTiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 14:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236649AbhLUTiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 14:38:00 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223AAC061574;
        Tue, 21 Dec 2021 11:38:00 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id z206so113956wmc.1;
        Tue, 21 Dec 2021 11:38:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ShKLo5JWRh5D46tXs9GqlD9C6PwhWN2ufezlMwCL27I=;
        b=hOXTwo82yY/1/1Bd2IWhwPL/cqSb355r5UmCjhC0ZdU3yLdvRs4yIl2/aMfjIw/4lb
         a079zcXNWJ+en59cvUUKvYDNyn3ufubecVHqqXCEAXYQJxEYDBQVZ+Bp4z9YG+SK5vF5
         pXk1QBueCwgq6trSxZRbvgb8BL0BU5K5B+bj1j4ZdOlF1Ksu3getq0/Wmk1mA7d6aIUp
         Xxf0YOzg7h0/OI6rpl3hZSgfD94rRH4izhbVoVdYWXFAiSrbsfivVEmSq4x62MWeN7z9
         9UWXBkNZ60aOgwJGwv8AkUDqX30mhNmMwjkG14y849GeP+LxEU36ZS0bReqJBXL6VkD8
         NzXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ShKLo5JWRh5D46tXs9GqlD9C6PwhWN2ufezlMwCL27I=;
        b=moPJlOoqLlEM88rxOJ0UGSbjIJ1hukXNjIG96zLNmUF9JU3P7toatRqIuvcSAYucZ/
         6ORxvkWYRJ7eRAnynCml+XnpAcHBofFgJA7VXqVYSiNwmeJg8mX6AhzohX5sqRL2BH4w
         hcahibcD0IpnjNXSS3UfG8AaMwBw9PC/A6ZLiQWSXTLlrAC2kussSyqMQrRWFQecpqfE
         ooLKT0ME7YlzbDxdzKJZGol5m216EdTJ0zlSynpc5VNhefcxDjIQF7TzkF5R9dsotqKC
         Pc4TwBwSYg5pQ4ujVCiQXl1dEssSV0YKtGm/aT6CSnGar+QgH37FFNeWXtSFItsN96uN
         iSqA==
X-Gm-Message-State: AOAM531B2PX8Oz1CFwojhtMzv/n65nBH3I+bCEDcVoB23zlggkxmKtWj
        lD+MU2zNQz/aNnjWttL7h8EIs47/Xi9neeXNEb+AXw==
X-Google-Smtp-Source: ABdhPJznW54ADf1fY/nKhFMUwp+LGAUlR1cME5ebxGBMZ9+cjQPqNN2sjQGctHPT2Xf82IhWgOVJ+w==
X-Received: by 2002:a05:600c:4e8d:: with SMTP id f13mr3993775wmq.7.1640115478612;
        Tue, 21 Dec 2021 11:37:58 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id k19sm3153292wmo.29.2021.12.21.11.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 11:37:58 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] netfilter: nft_set_pipapo_avx2: remove redundant pointer lt
Date:   Tue, 21 Dec 2021 19:37:57 +0000
Message-Id: <20211221193757.662152-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pointer lt is being assigned a value and then later
updated but that value is never read. The pointer is
redundant and can be removed.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 net/netfilter/nft_set_pipapo_avx2.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index 6f4116e72958..52e0d026d30a 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1048,11 +1048,9 @@ static int nft_pipapo_avx2_lookup_slow(unsigned long *map, unsigned long *fill,
 					struct nft_pipapo_field *f, int offset,
 					const u8 *pkt, bool first, bool last)
 {
-	unsigned long *lt = f->lt, bsize = f->bsize;
+	unsigned long bsize = f->bsize;
 	int i, ret = -1, b;
 
-	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
-
 	if (first)
 		memset(map, 0xff, bsize * sizeof(*map));
 
-- 
2.33.1

