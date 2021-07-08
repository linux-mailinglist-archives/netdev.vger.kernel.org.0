Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F362C3C1705
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 18:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhGHQ1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 12:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbhGHQ1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 12:27:37 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 487A8C06175F
        for <netdev@vger.kernel.org>; Thu,  8 Jul 2021 09:24:55 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id l7so7318707wrv.7
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 09:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K6n8sh6LGjBhE4XtolhUR5s1aOIcgEeUb5cKA4itJB4=;
        b=yy5YSNmt72HDFQKc9NCrpGh0eyZFexVc0dNwPpyVAM4yyRE2yBf/7FqcNelJIJ3vD6
         LL2gzco/awhqQIq6oLk5m3J4exXfYg1nYJOH9293RiwE0NTs+XraK3lqXIfGy2EAzu5N
         88B92D/KUl1EScfOSenCCHFc3RSMarzHx2nCGQ6uKy/zhRT3gZKCKb0KgRI64qCrjQ0F
         Rke8+aXJHAGcOTOWtZRVcIXvpPhLKCrt6906PGA0du90R4WtlKuqk3qw63LfkFEtzndA
         WuxIoe4l6sI9TIP32C/EeAP2oz2iZsqH2y/riPtHHKFTAUbZ8WYVkl9G8RT0sGZjKqbE
         q8UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K6n8sh6LGjBhE4XtolhUR5s1aOIcgEeUb5cKA4itJB4=;
        b=ASWHKBpACcbG2SiHBGrLpL4si2VD+PcTuIBDhkaMafnfi/ujXayNTbdZcN4fiyKYAA
         s0lxJRuqEBjRw/cu1vvNWYh5/VtGoqwMs8G4XBDTk8qJWE6/YUfYqYyJ1xqqP0m595Pk
         wWSROgqsfCeVu4/laZ+npeBHQJNPg+UAPl13dY01f2Zknlg7Mx0KlQ26/zgphuXpL4CM
         /pG2nufMfzNuWIdCvdH+VW9SwbcYsAzLTYZZbTp1b6/gCFMGkB8dygxGgMGre7lmNeEM
         0adbez3LFi4k2qFFoyCu6boGtNkcFHqJsIQTb0Tjqa3T/bkDBveJHdqi+3AEAGMFxfsa
         eIBA==
X-Gm-Message-State: AOAM53329A+GahrYr43sZYRYA7Q2jyxwXUifvlnhTywcAb47O+j4TiBo
        UR0/qRY3qjOyfDQbc9H/IIu8SxRvk06SY7sV
X-Google-Smtp-Source: ABdhPJwAFAHhRu6O8+PDLej2JYaDDmqd0mYSt6TES+zRkJq9cNsk/cVWUksge6P3qEYiIxnFtIgsRg==
X-Received: by 2002:a05:6000:1843:: with SMTP id c3mr36422947wri.301.1625761493705;
        Thu, 08 Jul 2021 09:24:53 -0700 (PDT)
Received: from localhost.localdomain (ppp-94-66-242-227.home.otenet.gr. [94.66.242.227])
        by smtp.gmail.com with ESMTPSA id m29sm9546071wms.13.2021.07.08.09.24.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 09:24:53 -0700 (PDT)
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     netdev@vger.kernel.org
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
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
Subject: [PATCH] skbuff: Fix a potential race while recycling page_pool packets
Date:   Thu,  8 Jul 2021 19:24:45 +0300
Message-Id: <20210708162449.98764-1-ilias.apalodimas@linaro.org>
X-Mailer: git-send-email 2.32.0.rc0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As Alexander points out, when we are trying to recycle a cloned/expanded
SKB we might trigger a race.  The recycling code relies on the
pp_recycle bit to trigger,  which we carry that over to cloned SKBs.
When that cloned SKB gets expanded,  we are creating 2 separate instances
accessing the page frags.  Since the skb_release_data() will first try to
recycle the frags,  there's a potential race between the original and
cloned SKB.

Fix this by explicitly making the cloned/expanded SKB not recyclable.
If the original SKB is freed first the pages are released.
If it is released after the clone/expended skb then it can still be
recycled.

Fixes: 6a5bcd84e886 ("page_pool: Allow drivers to hint on SKB recycling")
Reported-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
---
 net/core/skbuff.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 12aabcda6db2..0cb53c05ed76 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1718,6 +1718,13 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 	}
 	off = (data + nhead) - skb->head;
 
+	/* If it's a cloned skb we expand with frags attached we must prohibit
+	 * the recycling code from running, otherwise we might trigger a race
+	 * while trying to recycle the fragments from the original and cloned
+	 * skb
+	 */
+	if (skb_cloned(skb))
+		skb->pp_recycle = 0;
 	skb->head     = data;
 	skb->head_frag = 0;
 	skb->data    += off;
-- 
2.32.0.rc0

