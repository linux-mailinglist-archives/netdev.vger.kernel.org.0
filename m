Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74B4C62E5E
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 04:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbfGICx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 22:53:58 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40902 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727374AbfGICx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 22:53:57 -0400
Received: by mail-qt1-f193.google.com with SMTP id a15so20158860qtn.7
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 19:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8GmiXzF82rWe3rVgDV3IwECdMFjohlJ0lXCXU1Un0PA=;
        b=VNNSOQzO3kdVs0VWf9g2G2ecjYdzh/HBI/zz7wqdQ6uJ6+zeKiZVSTZ5qxfHaexknG
         TOq8w5XLgBAOf2r3Rq473dtdbRVCQ1IxKB55f+6+0xhYfhKo9jqfIDN/raKuIsfXJ3VP
         KKXElhZQwJ/X0F+vAAZj3DPq6XxtfLsxA+vMy2RzS9fD2eqPn3wxAFjUl10woGQ3YXrN
         DQQH5R9gggxNxhZi0nHqECm3HX5YDSYAQh8H0E5OxnOdQQEiNgJD4mS7/5I8/Hw3sLWw
         PuPwNT6SDGemtBoWfPuGRrOf7WICeSU8uDeB2exEysxVpfiPOVjtGLic8U+H7S0vURCp
         78Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8GmiXzF82rWe3rVgDV3IwECdMFjohlJ0lXCXU1Un0PA=;
        b=GkBG8UqIlJIWUUWHEDPhYiYFz5+hijfo6J6x6GwEr/AfcYlO9NHyxxPTLLV/6TkLIV
         1eJz1gpg83MS86UpzXi56fC8xThdxPTE/xzlx5x1oXA15CTFbcMuKovqgDwNctZCEWpC
         I84+IiKMLE+222UIwhNG9zLe+wWM9gT+GpcZNjlGyz85FShMxj0noDrmDAlCSMHaoZWs
         Fb0Ko85FqPufT0FP4zchsQgtxWGrnSE84QL429QMJ4cWfjMQMgy96kLb2ovVWsbKpu6L
         aJruFEpq4X06Kxf9PQHox1QNRLWozfV13GhiBa5a5r0xirJr0zX7n9thIXEW67rfbYxW
         LjLw==
X-Gm-Message-State: APjAAAVHNLpni1jN0UN4vxbB1CagbzMTQp577szRP8RR32WeyXPAuJtL
        cQt+ynCz3VUU9iMhZjybaIshcA==
X-Google-Smtp-Source: APXvYqxARhHHvgp4+FQ1twbeg+EWoNi1rzIiXlGeWltMV5rgxBTubavsnn170OGnXv+NnTJueKYVAA==
X-Received: by 2002:ac8:53d4:: with SMTP id c20mr16189653qtq.121.1562640836688;
        Mon, 08 Jul 2019 19:53:56 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g13sm8148837qkm.17.2019.07.08.19.53.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 19:53:56 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 09/11] nfp: tls: avoid one of the ifdefs for TLS
Date:   Mon,  8 Jul 2019 19:53:16 -0700
Message-Id: <20190709025318.5534-10-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190709025318.5534-1-jakub.kicinski@netronome.com>
References: <20190709025318.5534-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the #ifdef CONFIG_TLS_DEVICE a little so we can eliminate
the other one.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 9a4421df9be9..54dd98b2d645 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -822,11 +822,11 @@ static void nfp_net_tx_csum(struct nfp_net_dp *dp,
 	u64_stats_update_end(&r_vec->tx_sync);
 }
 
-#ifdef CONFIG_TLS_DEVICE
 static struct sk_buff *
 nfp_net_tls_tx(struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
 	       struct sk_buff *skb, u64 *tls_handle, int *nr_frags)
 {
+#ifdef CONFIG_TLS_DEVICE
 	struct nfp_net_tls_offload_ctx *ntls;
 	struct sk_buff *nskb;
 	bool resync_pending;
@@ -889,9 +889,9 @@ nfp_net_tls_tx(struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
 
 	memcpy(tls_handle, ntls->fw_handle, sizeof(ntls->fw_handle));
 	ntls->next_seq += datalen;
+#endif
 	return skb;
 }
-#endif
 
 static void nfp_net_tx_xmit_more_flush(struct nfp_net_tx_ring *tx_ring)
 {
@@ -985,13 +985,11 @@ static int nfp_net_tx(struct sk_buff *skb, struct net_device *netdev)
 		return NETDEV_TX_BUSY;
 	}
 
-#ifdef CONFIG_TLS_DEVICE
 	skb = nfp_net_tls_tx(dp, r_vec, skb, &tls_handle, &nr_frags);
 	if (unlikely(!skb)) {
 		nfp_net_tx_xmit_more_flush(tx_ring);
 		return NETDEV_TX_OK;
 	}
-#endif
 
 	md_bytes = nfp_net_prep_tx_meta(skb, tls_handle);
 	if (unlikely(md_bytes < 0))
-- 
2.21.0

