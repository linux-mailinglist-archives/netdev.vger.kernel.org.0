Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51875276585
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 03:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgIXBBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 21:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbgIXBBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 21:01:08 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 143AFC0613CE
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 18:01:08 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id g8so747460pfq.15
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 18:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=FZgefeu+XisV7G0jpVZoAmf+bLfqeEtvUSLoeaggrwE=;
        b=YdGxP+esNvd4n40WoZPnOpfCIWHFtKJAvMsKI//8RkzhQM6fUx6DRt7G+lT1/7uDLL
         XtE6xL8+rFpl8ZlQ8sKA/BrPr5iD3RWRAgeeUDcsooAhtTYuCaQHu7kB8uxUxPgrT3NU
         04Ghyz72WMnSAkIzYaUy1Q/CddSK8eowYdvwi+jLg3/qI26OKCjC4K+ENtlsPEJmMaqT
         A6LjZi/JGbbBkSzZ6uwWvHz1+HkSuNSBUM2aK5LRtqasPJSM5mNqWHgJOqagfy7NgsNB
         HrVS4E4Dd6bcAsa249JMUH5ZPem1ljmcgrenIitVL9vxOAm1rIq+J0q8/ZCTmlEny3H/
         TCrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=FZgefeu+XisV7G0jpVZoAmf+bLfqeEtvUSLoeaggrwE=;
        b=AfCSGvdrjSF1qhgN6Rezy6UUsjJlPEcsagAB8KEHwT1YQxcO6UpID1rK0xAaKR5sG2
         Qj0RCwIvwUAk//UqTIEwt310t0JdYAGtW3O3TH0CDMR5qBhWFCt5nQ82w33LpDBLbXs3
         0lpe+uJkfX7hBnHUD+dQHO3evcW8Xo4Aw6pFWhFAFqXeOFJVI/ITu2lfnnM1H2jSeThz
         pN61hKpiBrowid9ABY2G/m78ry3wuSPq36ZngdWPvYI0YxPpr3HUlpEkYhp3XKI8ZEKP
         B7h3PwXNTxuCR/1jM2K3CGAe68ZiHUXsQYStU7quT27HrGIUXs/uTs3iBGCN+nEnb3wl
         5G/A==
X-Gm-Message-State: AOAM530nVQ4RUMFlJkbQ9cz7w6LZ7BJc13DdFMuKu+t0fWP6/zG22XmV
        HMDf4Hva2Tx4Jxkz4oNrSDeg4bRk1iJSDmRgEMWD7E+ZCShi3SALvqFUonbDgvIRuIP8zRxOMGG
        NqmEs6zQfbeeCDXTCkhsht8rDLhpUtPxZJJ+mrOd5PuDGmYR32A2GB0tGr3+o6in6fZZFEwKD
X-Google-Smtp-Source: ABdhPJxpfMB1IaVHAUxoPr8EHAzrOJ+ANjrV22rShBFopWQkp3pue0PT/Xy50VlY1j8tdcwHvA23KEND73/LFmMm
Sender: "awogbemila via sendgmr" <awogbemila@awogbemila.sea.corp.google.com>
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:aa7:8a54:0:b029:142:2501:34f6 with SMTP
 id n20-20020aa78a540000b0290142250134f6mr2115014pfa.79.1600909267178; Wed, 23
 Sep 2020 18:01:07 -0700 (PDT)
Date:   Wed, 23 Sep 2020 18:01:00 -0700
Message-Id: <20200924010104.3196839-1-awogbemila@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH net-next v3 0/4] GVE Raw Addressing.
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes from v2:
Patch 1: Get end of struct more simply: descriptor + 1, no need to cast void pointers.
Patch 2: Separate page recycling to its own commit (patch 3 in v3).
Patch 4 (patch 3 in v2): Fix alignment of gve_dma_sync_for_device params.

Catherine Sullivan (3):
  gve: Add support for raw addressing device option
  gve: Add support for raw addressing to the rx path
  gve: Add support for raw addressing in the tx path

David Awogbemila (1):
  gve: Rx Buffer Recycling

 drivers/net/ethernet/google/gve/gve.h        |  40 ++-
 drivers/net/ethernet/google/gve/gve_adminq.c |  64 +++-
 drivers/net/ethernet/google/gve/gve_adminq.h |  15 +-
 drivers/net/ethernet/google/gve/gve_desc.h   |  18 +-
 drivers/net/ethernet/google/gve/gve_main.c   |  12 +-
 drivers/net/ethernet/google/gve/gve_rx.c     | 350 ++++++++++++++-----
 drivers/net/ethernet/google/gve/gve_tx.c     | 205 +++++++++--
 7 files changed, 554 insertions(+), 150 deletions(-)

-- 
2.28.0.681.g6f77f65b4e-goog

