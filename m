Return-Path: <netdev+bounces-5510-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58C8D711F4E
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 07:46:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A44428165F
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 05:46:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32B6523D0;
	Fri, 26 May 2023 05:46:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A5F23AD
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 05:46:40 +0000 (UTC)
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5D218D;
	Thu, 25 May 2023 22:46:38 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-64d2f99c8c3so451505b3a.0;
        Thu, 25 May 2023 22:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685079998; x=1687671998;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=e5YxXu7+kAm16FYH0MM9J1g3Z4tXK64P/Yef0oEkw/I=;
        b=qUlQ8WHgMYaTUXyuLclzG5jl4IGHhzf8aaf6PDLaN5rgzB5eNdGCj32w/4dLzU8kMv
         2ChzWrBpmLTJE69zw4V5Njx0sHdYTnRqpCL6sdDsRoYtIjfXv4hJ6gIfgsyj36DDD8HJ
         DmassvZ0KvRsMYd9aSzBczk20prYxDmj0k014QHezqoeArDVDdCstj3FZa//ke5uIS1+
         XLkgy7ENSRoxqQkx9/oGHANG1Fy/kr4uQtPqbWlvwxLmm+0u2xK98Wsv90QJnVR7W5fY
         5HnBaDmB7Rifu5lSJdrCgoKUwPGK+fbanzM0J/1vOl5JwrjFi7K7Mzu/VcndTToJO3s3
         JXlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685079998; x=1687671998;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e5YxXu7+kAm16FYH0MM9J1g3Z4tXK64P/Yef0oEkw/I=;
        b=QDofYx5+qr5qI8IgDvSiJ1srs9F+ufZVie3z5YP6R4r6oN000XIpfecN5i+fSqg4nv
         T6qV9TN+xleE7/PoMwYjY7Es6FVsHRBLj70pleIbPmv1pglsa1ZIht+z0QkCsYlspfWt
         DnG8cMAE6pbXSFdiMAda8hrXx4DJiid17QJZbsaAARCuoQqPJt7NYeCW41jx0EekweAu
         ixX0JRZtwCXJdbISUtKnshpJHNYztioeBke0CXMtA7p65d4KesB+qaSNl8NSGRbU9Eij
         aIqYj+GfwAHB4n82afzGR3+dfCOnP+ptvCEBOSxJQpxxDod7RIidBaIByYixFoC5zjWc
         SkmQ==
X-Gm-Message-State: AC+VfDyHSaY+nZoUKlpPmHbSUdfHtmwbm/YzjNB53YNS+l1TcvS+ivXI
	LvyUQjiC1oRRk2oliUX6WSC1d5wjszk=
X-Google-Smtp-Source: ACHHUZ6rs6rJosyEPbVnZODyB6BU4l/3BiexMAim7sYthg1sjCSUBFQJgdexR9mr9iRDz9L8ysRpkQ==
X-Received: by 2002:a05:6a20:2584:b0:10f:3d02:863 with SMTP id k4-20020a056a20258400b0010f3d020863mr1035895pzd.9.1685079998416;
        Thu, 25 May 2023 22:46:38 -0700 (PDT)
Received: from localhost.localdomain ([104.149.188.130])
        by smtp.gmail.com with ESMTPSA id b23-20020a6567d7000000b0050a0227a4bcsm1836485pgs.57.2023.05.25.22.46.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 22:46:37 -0700 (PDT)
From: Liang Chen <liangchen.linux@gmail.com>
To: jasowang@redhat.com,
	mst@redhat.com
Cc: virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xuanzhuo@linux.alibaba.com,
	kuba@kernel.org,
	edumazet@google.com,
	davem@davemloft.net,
	pabeni@redhat.com,
	alexander.duyck@gmail.com,
	Liang Chen <liangchen.linux@gmail.com>
Subject: [PATCH net-next 1/5] virtio_net: Fix an unsafe reference to the page chain
Date: Fri, 26 May 2023 13:46:17 +0800
Message-Id: <20230526054621.18371-1-liangchen.linux@gmail.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

"private" of buffer page is currently used for big mode to chain pages.
But in mergeable mode, that offset of page could mean something else,
e.g. when page_pool page is used instead. So excluding mergeable mode to
avoid such a problem.

Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
---
 drivers/net/virtio_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 5a7f7a76b920..c5dca0d92e64 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -497,7 +497,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 			return NULL;
 
 		page = (struct page *)page->private;
-		if (page)
+		if (!vi->mergeable_rx_bufs && page)
 			give_pages(rq, page);
 		goto ok;
 	}
-- 
2.31.1


