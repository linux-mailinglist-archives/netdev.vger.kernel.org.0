Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A78847671B
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 01:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbhLPArN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 19:47:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbhLPArM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 19:47:12 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 922D7C061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 16:47:12 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id n19-20020a056a0007d300b004acbc929796so14378613pfu.18
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 16:47:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Iz6iJoGt7wXxOudAxXKVHGp/SEoXhidy1H4dTjPHamE=;
        b=TLy1kKem/EAl5J/hl/5lqoebcTkwlk0YywEzTmn5L4akNBtTLDYPKmipDmOi4uYbPO
         ynxIBrfi1Kep0UyRmODIyMbQqMs7sIITTQXUD29GyjhCdM/YgGb0EW8LM8LgLccaqbq2
         o3OcRyNB2kdWnegRPCHphM5WbxzcPfp+xG05oe5UCgTLbppJGLaOB52r5BOin+WkdjiK
         fcTTUZ4Tshz5mYMNrsq/9I+TiPhhDx92/AkJoRQ0wYcr4BfHIQWkACkn997p3Ph5OS1O
         1DF4eOsNzCfx9TlZ4exX/Wj96X2S1220YujGv5P1MAC59W/jryBk/hPvnmCXmGhycr4x
         Cxmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Iz6iJoGt7wXxOudAxXKVHGp/SEoXhidy1H4dTjPHamE=;
        b=3U1hFMI0at8cy0fi1UGvAwCCVIJmn9aLLOWLZ/44IQEwpb2yI03RH6WcAo+8MC6FND
         HpNpxAFvf/C0fHIoWtso0Kd1bp4Zw+NNhJJjuzDsC1VuZSfI7RfS0icUT45iloDVWBX0
         pu5mAKmX7j3bLL4qS4cAodiJtzFHMbSnzWE6pzFaS0Asq1qs/WfONazLcVvAYgxgHGDL
         xWehuGIGxsyd2G0sn9hweCQ73Mv74ZYyLjEkO3BJfbiDZiEVy7KcdYgD+h2X+U1r2DDP
         ZKFr+fjg0YvxhNe0HGUiq5BmT1R76/Jmv3FMjaQ75uUDkd9wG28+7HxhR83bTtkGLuMk
         t9zw==
X-Gm-Message-State: AOAM531qQkZ9mzHMdfvE8Ttlgovm3jPKSXVumAbTXWDHCZxAm3jCjWOZ
        ly1pIZCatr7Yv5mz4haRgMdB3hg9wBBMyKViFz7oStCqx0rqHQGv0LGMmJWFJUDi8jA9BtzEpmX
        ZeSJ5dDgv59lb6nG8cfZEzFdJeQSAPEZUDVbyG3uXgz0acua+IIMSZ2u7YipmaNTfNug=
X-Google-Smtp-Source: ABdhPJzIisskEuvTZ6vlFd2JB/wh5dT9IFmL3STtUrn6bhsBCNNbnhHosnXuR1qqwuPeRGLRFGOW98+OsrVfXg==
X-Received: from jeroendb.sea.corp.google.com ([2620:15c:100:202:964d:9084:bbdd:97a9])
 (user=jeroendb job=sendgmr) by 2002:a63:230c:: with SMTP id
 j12mr9900766pgj.579.1639615631974; Wed, 15 Dec 2021 16:47:11 -0800 (PST)
Date:   Wed, 15 Dec 2021 16:46:47 -0800
In-Reply-To: <20211216004652.1021911-1-jeroendb@google.com>
Message-Id: <20211216004652.1021911-4-jeroendb@google.com>
Mime-Version: 1.0
References: <20211216004652.1021911-1-jeroendb@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH net-next 3/8] gve: Update gve_free_queue_page_list signature
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Catherine Sullivan <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Catherine Sullivan <csully@google.com>

The id field should be a u32 not a signed int.

Signed-off-by: Catherine Sullivan <csully@google.com>
---
 drivers/net/ethernet/google/gve/gve_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 348b4cfc4a12..086424518ecc 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -831,8 +831,7 @@ void gve_free_page(struct device *dev, struct page *page, dma_addr_t dma,
 		put_page(page);
 }
 
-static void gve_free_queue_page_list(struct gve_priv *priv,
-				     int id)
+static void gve_free_queue_page_list(struct gve_priv *priv, u32 id)
 {
 	struct gve_queue_page_list *qpl = &priv->qpls[id];
 	int i;
-- 
2.34.1.173.g76aa8bc2d0-goog

