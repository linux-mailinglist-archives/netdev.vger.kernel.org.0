Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 966EA27E012
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 07:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgI3FRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 01:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgI3FRk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 01:17:40 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E6B8C061755;
        Tue, 29 Sep 2020 22:17:40 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id s31so356002pga.7;
        Tue, 29 Sep 2020 22:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZnhBSpvB3/nQLS/vGQDEpF/3T8Iv4KFvzWHc0eI0OQY=;
        b=KZ7v7KkOGfVhjPCvwHb67JzHK/6tszBCzc3LgQFBgi5TvGDv2y0j6xiHTGidravuJL
         KbtF1gnnV2JIVqyuBddkzsqpc95dlCN73klCiV2YvoEKUN3/Y92+PvgoZfwb45qsn8Wj
         UZAEfBGrGep+e0Cur9PE8kc0ju4mBryrB+gKKngJ5lxj5LbBhr5fyjmsHOW3nyuVOx7R
         XHJ7HYsS+fq/49FXh98g6qF89HKnISTh8DJrBuP7JgVNK3v243BNnlpJPL1akWvv2HCt
         mjhS9tjBal/Qtxx0dxNR6jvBEgqSmpO89hKzgINeCw1NT2EUQpCCKEy9Jkaxh6JCrhzv
         kqAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZnhBSpvB3/nQLS/vGQDEpF/3T8Iv4KFvzWHc0eI0OQY=;
        b=kfrHhF/uKKyMTgk/Du2PYNIedcAp3G4fqQ0MY8Ibt15Q4QojAI671ZEhqGvCTjdnSI
         2NCNxiEY3OCY7Bg27vMAB1K0+YV18XCxjBjv9AK8mUn859ihhNQONibLTp1Uy0xuY/bl
         JWkYkUbSoGu5VQADUuEvpUlp/0O0VgBQht5jq3jMxpp2bD3mnAc18zOQ/ObOUth/Bfwk
         7t0C7JCFa3IXDTQXrJJPnZJUvnCU4+U+xG4AjDwvktRS2u1U2nbptbr8W6MBcfv7a2uc
         2t34ewRK2MyCiHLNYCvkLsEiRDb7SSByijkXBft9Gah5cUDUnEBA7dLRRyfbKWjzYwA6
         sB7w==
X-Gm-Message-State: AOAM531DQL4yIi8kmYyUmSfEvpZz3sQ0gPVwDFPWhG/1hbfW53vzLKih
        kLR34KrNs66thKpJJxKeMX8=
X-Google-Smtp-Source: ABdhPJxO94xHOft5zzV+L+Cm/yDieJuAT8EYKrRQxwsGxbw45yVgWmc7FmEh/QrkzovQtjhpGTBkoQ==
X-Received: by 2002:a65:46c6:: with SMTP id n6mr818457pgr.328.1601443060046;
        Tue, 29 Sep 2020 22:17:40 -0700 (PDT)
Received: from localhost.localdomain ([49.207.218.220])
        by smtp.gmail.com with ESMTPSA id gm17sm633432pjb.46.2020.09.29.22.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 22:17:38 -0700 (PDT)
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
To:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com
Cc:     Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: [Linux-kernel-mentees][PATCH 0/2] reorder members of structures in virtio_net for optimization
Date:   Wed, 30 Sep 2020 10:47:20 +0530
Message-Id: <20200930051722.389587-1-anant.thazhemadam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The structures virtnet_info and receive_queue have byte holes in 
middle, and their members could do with some rearranging 
(order-of-declaration wise) in order to overcome this.

Rearranging the members helps in:
  * elimination the byte holes in the middle of the structures
  * reduce the size of the structure (virtnet_info)
  * have more members stored in one cache line (as opposed to 
    unnecessarily crossing the cacheline boundary and spanning
    different cachelines)

The analysis was performed using pahole.

These patches may be applied in any order.

Anant Thazhemadam (2):
  net: reorder members of virtnet_info for optimization
  net: reorder members of receive_queue in virtio_net for optimization

 drivers/net/virtio_net.c | 44 +++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

-- 
2.25.1
