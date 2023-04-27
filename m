Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFB1E6F0031
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 06:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242817AbjD0EfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 00:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242703AbjD0EfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 00:35:05 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 311B93583
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 21:34:40 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1a9253d4551so62594215ad.0
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 21:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1682570079; x=1685162079;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jy52NvX0OBhGC88NMda1NrOK88NbR9S0vRvwBKXzpTg=;
        b=hWtQxXkdi0hyHmZTW8vTrUr4HIJ5tIYi8z1ts+5UdtA9f96et30f5RyGxlp5/jeOjz
         VrwiolC7A0ozBByEgT/ALdIp1cpLU0KwiWVqCKXZCg1YULHh8vC1TQ5/K5CLdVgzHrK3
         ERhdHw/77lAleDwosbnHzofh/Dx/ryA22h7EIdKMSdREPrIdN7C7uA6Zap28HzxJuTx2
         qPxt8hRWBEqK041JwtQeivJqHUoelUoq8JJdyl+Iz0AegGCP68SOaUDdV72mxWkuDwij
         I/KuLVBmuridH7QgpiO+INBabf7USC37bjpcgoNhHeSOSOR9guDzTuY9sPjs3iM3LGgE
         IR0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682570079; x=1685162079;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jy52NvX0OBhGC88NMda1NrOK88NbR9S0vRvwBKXzpTg=;
        b=PjWqSD4CZdt8vnBOr5z+A5I1rTdmDa5I6ulnc9uCnPGzEI5zRZLDW65Tsg8AFpYq8Q
         IHI/uvcNbyLT1EYVGZv6O7Rd4qr3x8GGDbyP/MRtjiGyAM+fqbo+vvRac0j282M2E23W
         wJyv0CXL1jtX1w2Gpn6TjgfZVRZINckXQ1ORtQ7GSLeh2xib0k3d3NrIGZpbqOT6TFQZ
         IF9BG1NxUk9t526iHDbe3tV6cFjckDfywE7Qg1XLHKTdyYmE596QHGJhXEL6qJCHfiVf
         JbMYlLbUK86fjigxcR8slPy4MfDnWoSWrVmU5UM1+Z80f7HpWAH2LphMoruPiYjd2GYi
         REiw==
X-Gm-Message-State: AC+VfDyGtwn4+ZyqDmSvIHrzemlJGpF5kphA1GIzwBKD7q0Hu79wcdLu
        0BO37WtMJjnJWwwP6wuF66gang==
X-Google-Smtp-Source: ACHHUZ4YH5/zqouBwSa2FO1jqQCKQHbtgI1tKYGnKwu9uWgP0iPOowo4zzHuLhWNVHXhzBcyD/pezg==
X-Received: by 2002:a17:903:27c3:b0:1a2:3108:5cc9 with SMTP id km3-20020a17090327c300b001a231085cc9mr161224plb.40.1682570079693;
        Wed, 26 Apr 2023 21:34:39 -0700 (PDT)
Received: from n137-048-144.byted.org ([121.30.179.80])
        by smtp.gmail.com with ESMTPSA id jb14-20020a170903258e00b001a6370bb33csm10741147plb.41.2023.04.26.21.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 21:34:39 -0700 (PDT)
From:   Wenliang Wang <wangwenliang.1995@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Wenliang Wang <wangwenliang.1995@bytedance.com>
Subject: [PATCH] virtio_net: suppress cpu stall when free_unused_bufs
Date:   Thu, 27 Apr 2023 12:34:33 +0800
Message-Id: <20230427043433.2594960-1-wangwenliang.1995@bytedance.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For multi-queue and large rx-ring-size use case, the following error
occurred when free_unused_bufs:
rcu: INFO: rcu_sched self-detected stall on CPU.

Signed-off-by: Wenliang Wang <wangwenliang.1995@bytedance.com>
---
 drivers/net/virtio_net.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index ea1bd4bb326d..21d8382fd2c7 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3565,6 +3565,7 @@ static void free_unused_bufs(struct virtnet_info *vi)
 		struct virtqueue *vq = vi->rq[i].vq;
 		while ((buf = virtqueue_detach_unused_buf(vq)) != NULL)
 			virtnet_rq_free_unused_buf(vq, buf);
+		schedule();
 	}
 }
 
-- 
2.20.1

