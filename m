Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF76438B7C
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 20:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbhJXSpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 14:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbhJXSpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 14:45:13 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1447C061745
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 11:42:52 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id u5-20020a63d3450000b029023a5f6e6f9bso5027553pgi.21
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 11:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=++4vZTCT5YRYA5Dk3o3V+5dXYQrwJlpRjVYHJXYVf34=;
        b=AJuc+XWPNVwQA0c8ahuXG7upCO30RxKVOSGTwqSrF1Jcq5phuJi/B3FZ94GT4Efnnq
         us2Yhuu23X7/q1cTP+iIcyh4deZdDveFINiULxYBl0o+2TTVI5gcSPWacuWFVR6BzE48
         JK4lg0zxGpm/Zm3HMPzKJUIzXjaW8SiFWhRwxAliMGXWEEpCUV97OdcCoBCykfSkgjKQ
         78T1Rn9Xr/F3QQeELqoxlhYkP3r/0LH46gmo/i9kWaaQ0jmfYa74M7M9GCrxc0ZKme7K
         0C/nhff/JbUCbEOkaM8VKT0NVTcIhApKbLtyE3YXegHiMv4ODYoNDhQ5CFrZTlT8p+oc
         EVNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=++4vZTCT5YRYA5Dk3o3V+5dXYQrwJlpRjVYHJXYVf34=;
        b=VEBsNeUIqHDmZEtTHMZbS1zWhcKbgtvfna68ykXpCTbkSZ9BMsspoANtGaxH9n/q3M
         oznBELOITr8G3mDm6nqJSjBUMn6V2MJ6pfUDizJ80jWYjTxuiyzNAhRoQcOO8T+AVRuC
         L33ZA6fJjIw6L1kIFnVqtrrtno9ghfiPO6avqDAjvfzkdyhKvWFG1d+Aw3saTQTWLOkn
         i3YQB3C3oDIfmNSl0WIZEAKBgVCfxjufJMENk2yOEN3/m39IKkNoa2w0/tt3YYT8sZEn
         jnIvl7iXZ2UovmMotl/exUNgz+1w4W+m4HYTeOipPc5DBhUSE/u5ZSY0yPKHbagnfz4E
         d/5Q==
X-Gm-Message-State: AOAM532wLnqQMnGevkFHzYniMnxt2FVnjXTd0LgsjMTXiAutFdweNi/N
        ne4PogZ2KrE0ee7ue4awr+M8rLVKHqW57gdHhc9XX1qGWbzfTUx9eu/iaysxXooyHYhRDGnYVgr
        fndt01NtC9rABzfVZ09AN9Jbedc9CfXVt6oZxPw8RJvf8NiGjHaT6QCl3r8FvuwkUN94=
X-Google-Smtp-Source: ABdhPJyMyvKJhOFcpAcUdf68HWAaBa9JgU42z93TOuVInbsCVEZxHct6/8zKaykvjsGLjhAj58OyPEZaGNAWQg==
X-Received: from jeroendb.sea.corp.google.com ([2620:15c:100:202:e3d1:fd04:4781:9855])
 (user=jeroendb job=sendgmr) by 2002:a05:6a00:1592:b0:44d:db91:ff84 with SMTP
 id u18-20020a056a00159200b0044ddb91ff84mr13678125pfk.45.1635100972200; Sun,
 24 Oct 2021 11:42:52 -0700 (PDT)
Date:   Sun, 24 Oct 2021 11:42:35 -0700
Message-Id: <20211024184238.409589-1-jeroendb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH net-next 0/3] gve: Add jumbo-frame support for GQ
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Jeroen de Borst <jeroendb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset introduces jumbo-frame support for the GQ queue format.
The device already supports jumbo-frames on TX. This introduces
multi-descriptor RX packets using a packet continuation bit.

A widely deployed driver has a bug with causes it to fail to load
when a MTU greater than 2048 bytes is configured. A jumbo-frame device
option is introduced to pass a jumbo-frame MTU only to drivers that
support it.

David Awogbemila (2):
  gve: Add RX context.
  gve: Implement packet continuation for RX.

Shailend Chand (1):
  gve: Add a jumbo-frame device option.

 drivers/net/ethernet/google/gve/gve.h         |  21 +-
 drivers/net/ethernet/google/gve/gve_adminq.c  |  59 ++-
 drivers/net/ethernet/google/gve/gve_adminq.h  |  14 +
 drivers/net/ethernet/google/gve/gve_desc.h    |  13 +-
 drivers/net/ethernet/google/gve/gve_ethtool.c |   4 +
 drivers/net/ethernet/google/gve/gve_main.c    |   8 -
 drivers/net/ethernet/google/gve/gve_rx.c      | 347 +++++++++++++-----
 drivers/net/ethernet/google/gve/gve_rx_dqo.c  |  68 ++--
 drivers/net/ethernet/google/gve/gve_utils.c   |  33 +-
 drivers/net/ethernet/google/gve/gve_utils.h   |   2 +-
 10 files changed, 403 insertions(+), 166 deletions(-)

-- 
2.33.0.1079.g6e70778dc9-goog

