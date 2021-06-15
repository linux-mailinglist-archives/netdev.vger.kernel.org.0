Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0312B3A838D
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 17:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbhFOPGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 11:06:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37950 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231401AbhFOPGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 11:06:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623769468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YfPOjpqs+xPPviaak2ogNv+B986oj5TZMO/NC3oJo44=;
        b=fduab+WxX+D8d0k6z/Mxc4/GxuftIzkKOareUkN4iWcpD1lJPbQWiK2Sn27XzZj39gbrkz
        41EcJTnTYKmP0KQj/6HfOhLYQeg6rtZIqgJBIGHwfeyDCTWU38tRXWFsJJcA6czJWl9bL2
        j55TZwPaPuUCEomKBSdFCALHj9nJm3M=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-pdlO72V7OpeoG5U3U8XeIQ-1; Tue, 15 Jun 2021 11:04:26 -0400
X-MC-Unique: pdlO72V7OpeoG5U3U8XeIQ-1
Received: by mail-ed1-f70.google.com with SMTP id df3-20020a05640230a3b029039179c0f290so20716694edb.13
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 08:04:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YfPOjpqs+xPPviaak2ogNv+B986oj5TZMO/NC3oJo44=;
        b=PraAz4ZOyJg3Z6131PGw3hH3axVo9dyANbPgKk6zF9eV3EDbjQ1Y27xEuAYFe5n2+9
         wrF9JaIOOHlmPGGkFXYFkFf0iCjHiO0lUusGllI9jPgJ9dccu08CHcZVJxfVCyDhBlHB
         sZWYGbGM643ndmc7uIefEDCNCwOIvDcqdvmp4H+QQTJdMncW48WShQlWZNbWgemfR/uM
         tqBE/HIfOuKoKcpdp1ypF8SmNUMaAtl+yXwUYVhhVsGOxlvSWKSKgOCmCs8ZGObLaBog
         6rAffM+nMqokFXo2eCMFwZaua9JKh3MOrH5VrLSxBA9/KnCEs42DnK/RXGqaVXM2JCoH
         jS3Q==
X-Gm-Message-State: AOAM531IHYxbpRPkx15RT7GU7G/3bq1F5p/ZbQ3A7HV/qch7I1qvndyw
        lnICBQumBbIndGmTMQkWv0n00mnI5MuwLmfKCl8FYO180UfxNZMGNNI0yz3ZoI/SJvFe1DaxXNS
        f/tkpd2Lw0bA8cDsE
X-Received: by 2002:a50:fc9a:: with SMTP id f26mr23484747edq.216.1623769465616;
        Tue, 15 Jun 2021 08:04:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyy8TVWB3Ab3G+Ed06XwW3QccJKn8HJhXMLG8fARccSuyWGMMDysWF3YtrcYvvSs+y6ZDLVcw==
X-Received: by 2002:a50:fc9a:: with SMTP id f26mr23484707edq.216.1623769465281;
        Tue, 15 Jun 2021 08:04:25 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id k21sm12184299edo.41.2021.06.15.08.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 08:04:23 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 21558180737; Tue, 15 Jun 2021 16:54:59 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [PATCH bpf-next v2 14/16] netsec: remove rcu_read_lock() around XDP program invocation
Date:   Tue, 15 Jun 2021 16:54:53 +0200
Message-Id: <20210615145455.564037-15-toke@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210615145455.564037-1-toke@redhat.com>
References: <20210615145455.564037-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The netsec driver has a rcu_read_lock()/rcu_read_unlock() pair around the
full RX loop, covering everything up to and including xdp_do_flush(). This
is actually the correct behaviour, but because it all happens in a single
NAPI poll cycle (and thus under local_bh_disable()), it is also technically
redundant.

With the addition of RCU annotations to the XDP_REDIRECT map types that
take bh execution into account, lockdep even understands this to be safe,
so there's really no reason to keep the rcu_read_lock() around anymore, so
let's just remove it.

Cc: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 drivers/net/ethernet/socionext/netsec.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index dfc85cc68173..e07b7c870046 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -958,7 +958,6 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 
 	xdp_init_buff(&xdp, PAGE_SIZE, &dring->xdp_rxq);
 
-	rcu_read_lock();
 	xdp_prog = READ_ONCE(priv->xdp_prog);
 	dma_dir = page_pool_get_dma_dir(dring->page_pool);
 
@@ -1019,6 +1018,10 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 				 pkt_len, false);
 
 		if (xdp_prog) {
+			/* This code is invoked within a single NAPI poll cycle
+			 * and thus under local_bh_disable(), which provides the
+			 * needed RCU protection.
+			 */
 			xdp_result = netsec_run_xdp(priv, xdp_prog, &xdp);
 			if (xdp_result != NETSEC_XDP_PASS) {
 				xdp_act |= xdp_result;
@@ -1069,8 +1072,6 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 	}
 	netsec_finalize_xdp_rx(priv, xdp_act, xdp_xmit);
 
-	rcu_read_unlock();
-
 	return done;
 }
 
-- 
2.31.1

