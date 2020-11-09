Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3B32AC96C
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 00:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730920AbgKIXhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 18:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729454AbgKIXhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 18:37:04 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3088C0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 15:37:03 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id y62so7824922pfg.13
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 15:37:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=LYeQc80FI3s8UNC57WoA8ZaOS1EBvWBKkEOrjB3XDSc=;
        b=oPTOJkxgbrqYknv2ZFknLxawHGJ5ufS7ckI8TuUWr2hZP39g0cybTKJEVnnFghOzLZ
         oOBuzh2lPpO93oVWEbunISK3Mh71w5GKYPnSZhV23V0qdQfes1D9dAFWznyQ0lWb39Fy
         kJ8Fbz6EXztFeUyUOgWnXsxoWTSh9c3PksveTR+GSyxVNUa9OHqYKeHZadnDHyjUAvzp
         3RVhXFZGxmW4/87lYbalnuAFFgi7m3GBn3ky9VphKR3avSVrLVTfKblwpR5phIOKp3IR
         BPzO/BoEGJyZqrTmbVrxu8ZTa+RpHu67iduhGWae4yvQPXUPGfgQjEBS3+/IEJ6PDEcO
         eqqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=LYeQc80FI3s8UNC57WoA8ZaOS1EBvWBKkEOrjB3XDSc=;
        b=UgSa3nKfjeIsGDBMxFWsnzhhfsjgTLmDRT0G2hq0bJWLNEaJdOAoKOfxALcPWXrM65
         WUvbzVGtdPS3ozY88svsQlBMJImmkkezetSA9yQxDE2u00fp1lmg+Y3knAJcw/XIm+9Q
         7/HfvIqRSMz4BmeIvV8qzNYILICTqLhNNVRUlL9r8P+JlrNUlwoiCcejCGKe/CHs9JZY
         bbtPntnYxV1Pv5lb2z4tR63/x4fEZg9Re/hwGXzB4+mmad0kB3bW6YZgx/HIiw/e3iwS
         u4USMYunUX77WbVrIfNgEt61FyVJayN1lJXJboDH8RgrMW0JonMoqMChskgoVM879b7z
         NIkA==
X-Gm-Message-State: AOAM532zlLienoNdzh0Wh2kkDO1UcxWUhaZN5/lScU63PrQjpNtAkurU
        kR/hnrvcVJ57R2F27yGC0hspIs0wjkucY7rBkT/FX1WYHILRJO9RZYskKBMmnNpKVSIMbICB2bI
        /k8Les1bwJjO5hioeZyBh+wUpZ8zQJdsNfuuC4nGKnzpmLWI1bt0YmXQcfeph7+8WzQuP0h4d
X-Google-Smtp-Source: ABdhPJwdt2+VJHRn/r8jee4pH3Nnw4UwH3VTtURRus/j0YQpmjhGk0uM3Yna3b9u43rgPM2MphRNLHtXkvs1k/n9
Sender: "awogbemila via sendgmr" <awogbemila@awogbemila.sea.corp.google.com>
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a62:2a81:0:b029:18c:310f:74fe with SMTP
 id q123-20020a622a810000b029018c310f74femr3552823pfq.50.1604965023363; Mon,
 09 Nov 2020 15:37:03 -0800 (PST)
Date:   Mon,  9 Nov 2020 15:36:55 -0800
Message-Id: <20201109233659.1953461-1-awogbemila@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.222.g5d2a92d10f8-goog
Subject: [PATCH net-next v6 0/4] GVE Raw Addressing
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1: Use static inline for getting next option in describe_device
        to make loop more readable.
Patch 2: Remove redundant else in gve_num_rx_qpls,
        Fix skew in for loop in gve_prefill_rx_pages and separate
        raw_addressing and non-raw_addressing paths for clearly.
Patch 3: Handle pages with bad refcount:
        - in raw addressing mode, just warn and leak the page,
        - in qpl mode, schedule a reset.
Patch 4: Remove redundant else from gve_num_tx_qpls
        Protect dma_mapping_error stat from parallel access.
        Revert unnecessary change of signature for gve_dma_sync_for_device.

Catherine Sullivan (3):
  gve: Add support for raw addressing device option
  gve: Add support for raw addressing to the rx path
  gve: Add support for raw addressing in the tx path

David Awogbemila (1):
  gve: Rx Buffer Recycling

 drivers/net/ethernet/google/gve/gve.h        |  32 +-
 drivers/net/ethernet/google/gve/gve_adminq.c |  82 +++-
 drivers/net/ethernet/google/gve/gve_adminq.h |  15 +-
 drivers/net/ethernet/google/gve/gve_desc.h   |  18 +-
 drivers/net/ethernet/google/gve/gve_main.c   |  12 +-
 drivers/net/ethernet/google/gve/gve_rx.c     | 380 ++++++++++++++-----
 drivers/net/ethernet/google/gve/gve_tx.c     | 207 ++++++++--
 7 files changed, 588 insertions(+), 158 deletions(-)

-- 
2.29.2.222.g5d2a92d10f8-goog

