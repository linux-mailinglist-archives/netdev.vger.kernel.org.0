Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047FF27F0B4
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 19:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731337AbgI3RtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 13:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726992AbgI3Rs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 13:48:59 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A50CC061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 10:48:58 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id o20so1650710pfp.11
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 10:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=2+jr7anQSGM1Vpj925NUsc8SzcyVKFX/9RxXihlZg60=;
        b=Bwy4qJNaQDw2JaCFJ7kyzCCEItZkdJA8guk5EENusCcArvzwU08EFtr7JAtAI9+qhJ
         kYNn3TOmyfKrNXbq7W+PAKF3Hcr6bpash6jLniJFENVXlWU7glGzNYRLlwv4xpW/6y4o
         dD0aG3haKfZ8YDH22MmNewATNyRju5P49uZu9PH3bxPqSvy3ombieNnuFM8OZnG4JY6C
         QBNAN/sXNbTXsbYwIav7udvaROXdYwy5gTeKBD3WRyuA1NWGrYUDhWraHoV0yc3X+sAo
         V7/J7MZvnjLQ5OwH/HeJvWohd09LQvEBuEr84HS5OsaKGRoJogO0g16q5Z/pht7sK8rt
         5xRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2+jr7anQSGM1Vpj925NUsc8SzcyVKFX/9RxXihlZg60=;
        b=r+CMggRltOJ8WntZdVfsvMCdF65XTzQ1SK196GitTbnP1OqV8XIH0UC83rIIwM97TZ
         kVGMu+FNMqBUoNAI2zBZ6g79O4j8Uw9upZzfP+NPCalkM56pwUZawY5fkpLLtQ2OAGHG
         3QWpG7YStveO66irRBTduME0qZHcfNSAMdz8NijOlgFIJIGSVgK5hF57nClxF73SUO+J
         Uesgyqa8ANkykV/yUtpB4rcs/3RgQams2LshfTYmlByGhNgyKRbN+0fix6UWTxklji9Q
         Qmz604hPODR1EIeXITzLUEds1BKcNNe/kaE1mVR1d9+bnXufF2DrWdRHg06zNEhAmqxN
         egrw==
X-Gm-Message-State: AOAM533tQyqWrugov9RLfUbCzBSLOWUV9oUF3EFRevYIuRvhRCTL6AaF
        CkVdY1G/S0ZNlsoSH1nWIqBxHwEfzIypnA==
X-Google-Smtp-Source: ABdhPJwaOSKtk8wgasDkm4mOFbXP21SN2VKLptfg7DgbDacfZruJScHf9fZ5kgHM+sKw9pOnCmmb1w==
X-Received: by 2002:a63:3448:: with SMTP id b69mr3070149pga.269.1601488137579;
        Wed, 30 Sep 2020 10:48:57 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id l13sm2993974pgq.33.2020.09.30.10.48.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Sep 2020 10:48:57 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 0/2] ionic watchdog training
Date:   Wed, 30 Sep 2020 10:48:26 -0700
Message-Id: <20200930174828.39657-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Our link watchdog displayed a couple of unfriendly behaviors in some recent
stress testing.  These patches change the startup and stop timing in order
to be sure that expected structures are ready to be used by the watchdog.

Shannon Nelson (2):
  ionic: stop watchdog timer earlier on remove
  ionic: prevent early watchdog check

v2: rebased to fold in recent changes

 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c |  5 +++--
 drivers/net/ethernet/pensando/ionic/ionic_dev.c     | 10 ++++------
 drivers/net/ethernet/pensando/ionic/ionic_dev.h     |  1 -
 3 files changed, 7 insertions(+), 9 deletions(-)

-- 
2.17.1

