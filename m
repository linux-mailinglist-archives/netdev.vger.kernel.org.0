Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A94E33C1F58
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 08:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhGIGcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 02:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbhGIGcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 02:32:32 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB7FC0613E5
        for <netdev@vger.kernel.org>; Thu,  8 Jul 2021 23:29:49 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id w13so5602092wmc.3
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 23:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DRY3VnuG4gt8PiNy3Dy2u07H83mINghJPh114/ywsmE=;
        b=LI1IHMKNWDRfPUWL1KvoHyjnYq1nGzxGQVHASD1zv0oN2h44sw5Bni6kc8yypoy12i
         +L6UuTdqLa0jCR8Qdv74MniiSHcsel1TDiFoN/SFMsQHSZtt6M8O9MAzG219dM0ayw7N
         RemunQ0P7AzFDft7vPOO1WMIv4GnoRMhYeNPDrAGbT2JfgiL0bZsTB/0FUbRSAWwLW7y
         N9KN9udc6qUq+PdH35UqNT5U7PFCbC+T7YcyvfSVPdNAVaKGq0Yu4TwW8xhWsT8Y6TyQ
         +fv5yzgaDAoVM7HwJWoH6ETXH668PhMQm2Gp/yG+Rsd3mICVqS1X48yus7ugxppL3JMX
         oEyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DRY3VnuG4gt8PiNy3Dy2u07H83mINghJPh114/ywsmE=;
        b=bd2gwGumxHCGq6yBnxWSwI04DE0mWs+CUS5KYxizqMtHRbXNqNUMNj99i+7Ubsxgq2
         lAdxLlU2m2ba0pCu7JibyLF1fsNiJVib9JwWU7kgyQJVhyK3fD8o9gN1+ePTsLhQb3E5
         7J0ZtUtWEbQyNvSCEZjsGJjZj/Oa2ifUvFfBxCY92WXcQy//LvAQgaIYN24LYrSrhQnd
         agPOiJ1Emt5vDgCqi1wXAtjg0OI3kaIL6Biq/gumLSE1YuhLx9B3N0maqgeXX9dDyX2Z
         IKuhSsSgM7zTWxOCpxLW//9TiAEzPtzd3t086KpGRg1X6P2VV2ScYKsl9aVcndzbUvqS
         WhZQ==
X-Gm-Message-State: AOAM531S0EeCAUFVhUyc16EGuSqy3whtBUb0ld1KWcVOKmaWXzds0517
        6FOcJSvneB+0Y2iQJwJ6nIGHXrJgTsvjpDWv
X-Google-Smtp-Source: ABdhPJwPSL+3/QNQGALmsjsDBfEPIvrnmq1TyuuFaOa2b0Pc1Y/x6luuUoLARvv0t0g3KXhiMSAQDA==
X-Received: by 2002:a1c:9808:: with SMTP id a8mr36471404wme.54.1625812187750;
        Thu, 08 Jul 2021 23:29:47 -0700 (PDT)
Received: from localhost.localdomain (ppp-94-66-242-227.home.otenet.gr. [94.66.242.227])
        by smtp.gmail.com with ESMTPSA id m6sm5183342wrw.9.2021.07.08.23.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 23:29:47 -0700 (PDT)
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     netdev@vger.kernel.org
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Matteo Croce <mcroce@microsoft.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1 v2] skbuff: Fix a potential race while recycling page_pool packets
Date:   Fri,  9 Jul 2021 09:29:39 +0300
Message-Id: <20210709062943.101532-1-ilias.apalodimas@linaro.org>
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
call skbb_release_data() and overwrite skb->head, we are creating separate
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
Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
---
Changes since v1:
- Set the recycle bit to 0 during skb_release_data instead of the 
  individual fucntions triggering the issue, in order to catch all 
  cases
 net/core/skbuff.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 12aabcda6db2..f91f09a824be 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -663,7 +663,7 @@ static void skb_release_data(struct sk_buff *skb)
 	if (skb->cloned &&
 	    atomic_sub_return(skb->nohdr ? (1 << SKB_DATAREF_SHIFT) + 1 : 1,
 			      &shinfo->dataref))
-		return;
+		goto exit;
 
 	skb_zcopy_clear(skb, true);
 
@@ -674,6 +674,8 @@ static void skb_release_data(struct sk_buff *skb)
 		kfree_skb_list(shinfo->frag_list);
 
 	skb_free_head(skb);
+exit:
+	skb->pp_recycle = 0;
 }
 
 /*
-- 
2.32.0.rc0

