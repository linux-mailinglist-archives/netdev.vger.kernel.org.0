Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC3D53CB2EA
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 09:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235490AbhGPHFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 03:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234986AbhGPHFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 03:05:33 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD69C061760
        for <netdev@vger.kernel.org>; Fri, 16 Jul 2021 00:02:37 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id w14so11590303edc.8
        for <netdev@vger.kernel.org>; Fri, 16 Jul 2021 00:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ob+65EC7EGHk7ZpDwd2fjysmCAANNiwOFYwvnrx8W6A=;
        b=WpUScbBh4ND6IRyPfMqPuzTj7+TZmXY/9OtflZD5oeF8YGH3wY0LBc1zTchljv7HGt
         eC7oICPrBirfEObqC7S/yhLtt/3NhAParkUbv73w1a3xCeetjLS29n23WFgEmGEe7gWa
         YHCPMQm5N9sCs3f5xRximY96BxorpuvQwxQIBlaIKiChPpNTFq9m8NOnrd0/epKliPKS
         F3yiKzIwdNKJS46YvfwjJSJBFJaQftvIpOy6n5s+GZi3ySSVXMFnCcIQfjDNtvxKzvUp
         SSUk/pcUKNtg3hnq/1b6TSbtc/N3nkoNuttw9RcRFhag8cbpFb/Hq1H6t02Tia2uLTG+
         6vDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ob+65EC7EGHk7ZpDwd2fjysmCAANNiwOFYwvnrx8W6A=;
        b=LeFy4txxrSibzK+RdR8hsPzb45pqFTUxsS4T/YuaiGN99JuaCf7CCPsMR2GfkY6fXC
         vYtxN8dhp6J1kEPr56/cybV2Xj0A8yk5Fkotrlke3jfHP92xxLVRoHafnDwQPEdehHcg
         SQlNfEb7JIqmy4czUBtBayYAhqjiaQfSEnXz9zX8jlMNZXTc664P6QKWAXaO6FIa1/sz
         4Au/m1ipQSi8TC/9GC3EMewXVOcxVHDJ6H2fbZHIY3bqQjIr/cTSF9ZYbop70eiWWC+G
         hjP3oDR1NNHGilKaIK21FjQEYFvqbpr7Fs5jbdTUe2AfBUkeYMv8+YvuFUw8bben4ieY
         +/6w==
X-Gm-Message-State: AOAM531OfCCLbs6pv+znsFlIaMaVy/XSN8KOAe7qfp72RyuNiRHkyIby
        i94lcpzTF6nekv17sMqOrIkjtWtJyoYwqg==
X-Google-Smtp-Source: ABdhPJyzW0B43oVFsiUQcTsX/rB6papLgwlPeuY72zWdC+yBJkwa9qN2rwwIZF+dgutQh7+CAJuLGA==
X-Received: by 2002:a05:6402:d2:: with SMTP id i18mr12528374edu.17.1626418956198;
        Fri, 16 Jul 2021 00:02:36 -0700 (PDT)
Received: from localhost.localdomain (ppp-94-66-243-35.home.otenet.gr. [94.66.243.35])
        by smtp.gmail.com with ESMTPSA id cq22sm3313698edb.77.2021.07.16.00.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jul 2021 00:02:35 -0700 (PDT)
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     netdev@vger.kernel.org
Cc:     linyunsheng@huawei.com,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Matteo Croce <mcroce@microsoft.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1 v3] skbuff: Fix a potential race while recycling page_pool packets
Date:   Fri, 16 Jul 2021 10:02:18 +0300
Message-Id: <20210716070222.106422-1-ilias.apalodimas@linaro.org>
X-Mailer: git-send-email 2.32.0.rc0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As Alexander points out, when we are trying to recycle a cloned/expanded
SKB we might trigger a race.  The recycling code relies on the
pp_recycle bit to trigger,  which we carry over to cloned SKBs.
If that cloned SKB gets expanded or if we get references to the frags,
call skb_release_data() and overwrite skb->head, we are creating separate
instances accessing the same page frags.  Since the skb_release_data()
will first try to recycle the frags,  there's a potential race between
the original and cloned SKB, since both will have the pp_recycle bit set.

Fix this by explicitly those SKBs not recyclable.
The atomic_sub_return effectively limits us to a single release case,
and when we are calling skb_release_data we are also releasing the
option to perform the recycling, or releasing the pages from the page pool.

Fixes: 6a5bcd84e886 ("page_pool: Allow drivers to hint on SKB recycling")
Reported-by: Alexander Duyck <alexanderduyck@fb.com>
Suggested-by: Alexander Duyck <alexanderduyck@fb.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
---
Changes since v1:
- Set the recycle bit to 0 during skb_release_data instead of the
  individual fucntions triggering the issue, in order to catch all
  cases
Changes since v2:
- Add a comment explaining why we need to reset the recycling bit
 net/core/skbuff.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 12aabcda6db2..8ec5c1136692 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -663,7 +663,7 @@ static void skb_release_data(struct sk_buff *skb)
 	if (skb->cloned &&
 	    atomic_sub_return(skb->nohdr ? (1 << SKB_DATAREF_SHIFT) + 1 : 1,
 			      &shinfo->dataref))
-		return;
+		goto exit;
 
 	skb_zcopy_clear(skb, true);
 
@@ -674,6 +674,17 @@ static void skb_release_data(struct sk_buff *skb)
 		kfree_skb_list(shinfo->frag_list);
 
 	skb_free_head(skb);
+exit:
+	/* When we clone an SKB we copy the reycling bit. The pp_recycle
+	 * bit is only set on the head though, so in order to avoid races
+	 * while trying to recycle fragments on __skb_frag_unref() we need
+	 * to make one SKB responsible for triggering the recycle path.
+	 * So disable the recycling bit if an SKB is cloned and we have
+	 * additional references to to the fragmented part of the SKB.
+	 * Eventually the last SKB will have the recycling bit set and it's
+	 * dataref set to 0, which will trigger the recycling
+	 */
+	skb->pp_recycle = 0;
 }
 
 /*
-- 
2.32.0.rc0

