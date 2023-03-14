Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98FBB6B95D4
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 14:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbjCNNS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 09:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCNNSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 09:18:12 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8ADA9DD3;
        Tue, 14 Mar 2023 06:14:59 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id d13so5308394pjh.0;
        Tue, 14 Mar 2023 06:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678799684;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=d0gqt2xwBEWN7KFuDaD6z1O6+7EY4w/LU3lD9GJPLEo=;
        b=aMYmE1hEuwdLlI/2zCCA0x2SToSWpaRHorskMf9UnZVyss+H4rEyTCBqz8QFZcFQ1q
         /DDII02KRQISN8kCXiRkP1AMyj349zf9M7TO7MKM9GjG+uz2HMgBfYMtKw9S7W9g1Pjv
         kvL/iNstrbXG7Fk6Kj+lq5xtn9SuOzo7IYWmJqu2AMmF9KwGG/uwQ8mNAg/G2k518e1V
         pepXmPFsfGv500KeMt+5nvQmjXFkj0mo7tfnV1aHL/oUKtwwzKcqSNu8k7OGv9fYSFx6
         SdqebQP7SCF455a2WyaK969NXm9g9q6zCViK63fVqr7gdTxjAL2DYnB2+uwzsV0OJfZ4
         NPqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678799684;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d0gqt2xwBEWN7KFuDaD6z1O6+7EY4w/LU3lD9GJPLEo=;
        b=h73YjexNfy8HJt2JXP2B3YGXw0JndY8q+rkmNuQpuQQZBubnHZT07Glrrk233p6ICE
         ibok4YCEPH9kC01Mxe3yHW5NWEPtmWDbUoFV5G6pwBHxm0hfe6rHwuTp7j+AzHCtLmMZ
         r4t8VGWJygGfTrRlOuOc4JLx6oMn/AuQ/3cEZvdTfJ7W5UZKFNDerMsQ4MvIkxd6PNOF
         Gq4AC5KGcGV8EENMQsJcLv3MbQveqKf6rQ8w89rm1NODx4QUPbRogHZSl6kyf1Polpd4
         HxW4yIvjmWQxiso8hiGOMNUCgKMD0MnL6v/UWRttErvyxkn2KamOS3ulKya7mbZug0vi
         e0Ww==
X-Gm-Message-State: AO0yUKWzOkmcoWc7azVanBHyIBQWzeaDbo3velhk0sFD6e7F64Tw3BcD
        5SANrXJKmGBxfcTqWWvQzHM=
X-Google-Smtp-Source: AK7set8zgMeknF6IwyMTFFnLPHBq+bdrvghaoUEyleC6B9ETERn/V9lTbUJITI8Tad0ShsR9nEm9fw==
X-Received: by 2002:a17:903:2290:b0:19e:25b4:7740 with SMTP id b16-20020a170903229000b0019e25b47740mr47027414plh.28.1678799684655;
        Tue, 14 Mar 2023 06:14:44 -0700 (PDT)
Received: from KERNELXING-MB0.tencent.com ([103.7.29.31])
        by smtp.gmail.com with ESMTPSA id g15-20020a17090a7d0f00b0023d36aa85fesm1465843pjl.40.2023.03.14.06.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 06:14:44 -0700 (PDT)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        stephen@networkplumber.org, simon.horman@corigine.com,
        sinquersw@gmail.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kerneljasonxing@gmail.com,
        Jason Xing <kernelxing@tencent.com>
Subject: [PATCH v3 net-next 0/2] add some detailed data when reading softnet_stat
Date:   Tue, 14 Mar 2023 21:14:25 +0800
Message-Id: <20230314131427.85135-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Xing <kernelxing@tencent.com>

Adding more detailed display of softnet_data when cating
/proc/net/softnet_stat, which could help users understand more about
which can be the bottlneck and then tune.

Based on what we've dicussed in the previous mails, we could implement it
in different ways, like put those display into separate sysfs file or add
some tracepoints. Still I chose to touch the legacy file to print more
useful data without changing some old data, say, length of backlog queues
and time_squeeze.

After this, we wouldn't alter the behavior some user-space tools get used
to meanwhile we could show more data.

Jason Xing (2):
  net-sysfs: display two backlog queue len separately
  net: introduce budget_squeeze to help us tune rx behavior

 include/linux/netdevice.h |  1 +
 net/core/dev.c            | 12 ++++++++----
 net/core/net-procfs.c     | 25 ++++++++++++++++++++-----
 3 files changed, 29 insertions(+), 9 deletions(-)

-- 
2.37.3

