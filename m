Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0C9F4C0779
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 02:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbiBWB6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 20:58:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiBWB6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 20:58:08 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A4B3A1B6
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 17:57:41 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id z2so8668738plg.8
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 17:57:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=PpYBcpTh24QCUZl2bM4US/ajh5Qff1AWsWjKDxsjPa4=;
        b=rp4uOhbqlH7ZydeIB5w/19IRCqdVydj3gxJdOinf0RxuGZwDoKnCS4n6+/OWAZTRR/
         Px7dW9Lk06JnWXDBZVqLexNG55RmC8tQFiJckbGkzR64Oi5akzazSkhesG2Hdfjqdtmg
         s7D0hHct8JYU0DE2r8wBCSAYRk4D5PaMHuIiLcLQ4AxFCENir5PTc1enDX8xmv1OOU+p
         TveOr0eeH6VmgYhxdjEAEMYjx8e5O2emNDbadCfant9eJzjMYaLSwm+E7Ifi30HNnL3b
         weDNG3CpVP70251OS3uP7we3P5whByvRAtfcMZtL0BMaVljHshUOFY6OL4NxeSIiInT5
         wgiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PpYBcpTh24QCUZl2bM4US/ajh5Qff1AWsWjKDxsjPa4=;
        b=hmvyknBRpNsOgSAzQIFHnmHybe3zs3S8743RisJ/7NninYlahEy238Nn/kV/+N3M00
         VKnZ+HxB+++jiGqVMjs9HOR+QKMSYrU56lknph3vWhu8oIyZNhPkfburnEhoHDeeBrJf
         DHEM7MABLL6UZlTJ17WkgtfI3DNBj3ZQIYTRg7nJKSDxFy+m0ASZd8b2JMYR+DssfzjR
         TFkWD5/xPXAyEfVjXUMMn/ye6FbwfJB6TeE66yq3E5M6YeOKCG2IxdvhbE09fK9/pLdJ
         /2Jw8oh259uguH6ZyATsCC5umhDW3KPqK5K8mm1hREP+XfwykACaZ5RFG0gw8a8rpcjk
         53EQ==
X-Gm-Message-State: AOAM5329eSCIFvRQUxJmzDLdebHDlKoPX0kcGG1BZsNQTSZFgLjYD8yv
        PwgZistJHwYPnWtKeTbGiQrD1q+XYfu7sg==
X-Google-Smtp-Source: ABdhPJyjBOAL9iTY4HVTLctFX2r/Z4jlyw9l15WZC+Yg91sV6R9uf4QZ1JNPbWHTvWQlOca3ALcrHQ==
X-Received: by 2002:a17:902:b189:b0:14d:6f87:7c25 with SMTP id s9-20020a170902b18900b0014d6f877c25mr26075290plr.31.1645581460861;
        Tue, 22 Feb 2022 17:57:40 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id f17sm1268756pfd.49.2022.02.22.17.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 17:57:40 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next] ionic: use vmalloc include
Date:   Tue, 22 Feb 2022 17:57:31 -0800
Message-Id: <20220223015731.22025-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ever-vigilant Linux kernel test robot reminded us that
we need to use the correct include files to be sure that
all the build variations will work correctly.  Adding the
vmalloc.h include takes care of declaring our use of vzalloc()
and vfree().

drivers/net/ethernet/pensando/ionic/ionic_lif.c:396:17: error: implicit
declaration of function 'vfree'; did you mean 'kvfree'?

drivers/net/ethernet/pensando/ionic/ionic_lif.c:531:21: warning:
assignment to 'struct ionic_desc_info *' from 'int' makes pointer from
integer without a cast

Fixes: 116dce0ff047 ("ionic: Use vzalloc for large per-queue related buffers")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index d19d977e5ee6..f3568901eb91 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -12,6 +12,7 @@
 #include <linux/pci.h>
 #include <linux/cpumask.h>
 #include <linux/crash_dump.h>
+#include <linux/vmalloc.h>
 
 #include "ionic.h"
 #include "ionic_bus.h"
-- 
2.17.1

