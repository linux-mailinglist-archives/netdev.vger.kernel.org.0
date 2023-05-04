Return-Path: <netdev+bounces-233-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D12FB6F62EE
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 04:27:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 135AA1C21082
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 02:27:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 848C4EA4;
	Thu,  4 May 2023 02:27:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7321D7E
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 02:27:50 +0000 (UTC)
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61BC1B4
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 19:27:48 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-63b67a26069so32778b3a.0
        for <netdev@vger.kernel.org>; Wed, 03 May 2023 19:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1683167268; x=1685759268;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u+BgJuHtqJ6xHJQzKeFgk31WipZJ6dbt5GNbeuwFI6E=;
        b=SlMNXjdGsbfr6N9kkbZZeyQ43lxVvkoMsCd0YWIFya3W1IZe5rU7VOgbO3UVhc43eH
         g06ZGzXgN0/NNLgGmKCYkuKabXwfcBLb6i7HCPR7VLv9wm/uuuEi8bVqUBEhieYeRciB
         eaF7AVNvwHQCmhNhS72C+iUrCgVz3YOvhh3ZUTufEkG8kpdc6uu7+q7utraGNVEMZ6UO
         baw0GRKFuihvmQ51q1SoimeqotVxGOtqNlIKg/L2j0Q5AkI/wflyQ5Zo39dwKYwYDmD8
         j/l8qg936kNf89L9H4QGXmxUJZoRGpMuyQCLF1T+LbFmIxd38cdREerkfVUJr3uU8OYI
         yHfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683167268; x=1685759268;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u+BgJuHtqJ6xHJQzKeFgk31WipZJ6dbt5GNbeuwFI6E=;
        b=IjezDSvU8B1GJj1Td9PcqZWEZZKbxgri2XZZI6NajWU1q5/x5IY5GOX9cfBuabq6K+
         TBZyyXvxW+NBhJMBqogaKo94XUAKAFWXGCmMAlvTCM7a4ytPbM0zFOH+9ZfruN+0xq6g
         vX3QxkU4OhKiNTVKrHFdMjZnWPaMnk34xxXKp4WcM2e/ZwVv/BsWUYxIlmfWbgdQzIFy
         2+18OGNsKPvHDdhhngdD1bY+29Yd0SIcJUxuT3QNtxQgzAMwBPKtTmG4wnqsM63ZAdNE
         kY740ygSHrOpDA95gbnx6PePQ47D9WyfzzACVKMOoetoADYRYHDo/17W0mc2tb4D0g6r
         OrTg==
X-Gm-Message-State: AC+VfDxkBSI9usacUKjov61Sd50ACFoUuR3AmCemt3skAWd3hbfbXQr6
	4Zz+srhwMaDbtUHFlQuYQG04uw==
X-Google-Smtp-Source: ACHHUZ66w6gN6afzXEUhNGIYJlXlkcmFTjIO96e8ArI9LnEnVDhNQ8YF+0PLg9M1pCuReLWyEeRgIQ==
X-Received: by 2002:a05:6a00:2d0b:b0:641:a6d:46b0 with SMTP id fa11-20020a056a002d0b00b006410a6d46b0mr849513pfb.22.1683167268316;
        Wed, 03 May 2023 19:27:48 -0700 (PDT)
Received: from localhost.localdomain ([2408:8207:2421:6760:ecda:417a:920f:8647])
        by smtp.gmail.com with ESMTPSA id c16-20020a62e810000000b00643355ff6a6sm1911751pfi.99.2023.05.03.19.27.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 May 2023 19:27:47 -0700 (PDT)
From: Wenliang Wang <wangwenliang.1995@bytedance.com>
To: mst@redhat.com,
	jasowang@redhat.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	zhengqi.arch@bytedance.com,
	willemdebruijn.kernel@gmail.com
Cc: virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xuanzhuo@linux.alibaba.com,
	Wenliang Wang <wangwenliang.1995@bytedance.com>
Subject: [PATCH v4] virtio_net: suppress cpu stall when free_unused_bufs
Date: Thu,  4 May 2023 10:27:06 +0800
Message-Id: <1683167226-7012-1-git-send-email-wangwenliang.1995@bytedance.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

For multi-queue and large ring-size use case, the following error
occurred when free_unused_bufs:
rcu: INFO: rcu_sched self-detected stall on CPU.

Fixes: 986a4f4d452d ("virtio_net: multiqueue support")
Signed-off-by: Wenliang Wang <wangwenliang.1995@bytedance.com>
---
v2:
-add need_resched check.
-apply same logic to sq.
v3:
-use cond_resched instead.
v4:
-add fixes tag
---
 drivers/net/virtio_net.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 8d8038538fc4..a12ae26db0e2 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3560,12 +3560,14 @@ static void free_unused_bufs(struct virtnet_info *vi)
 		struct virtqueue *vq = vi->sq[i].vq;
 		while ((buf = virtqueue_detach_unused_buf(vq)) != NULL)
 			virtnet_sq_free_unused_buf(vq, buf);
+		cond_resched();
 	}
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
 		struct virtqueue *vq = vi->rq[i].vq;
 		while ((buf = virtqueue_detach_unused_buf(vq)) != NULL)
 			virtnet_rq_free_unused_buf(vq, buf);
+		cond_resched();
 	}
 }
 
-- 
2.20.1


