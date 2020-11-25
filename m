Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7AD42C46EC
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 18:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731578AbgKYRiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 12:38:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730653AbgKYRiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 12:38:51 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E41C0613D4
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 09:38:51 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id u37so580179ybi.15
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 09:38:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=cm21SZmCOEnGa1IUks72kMTUS/l8TuTgz+8KblDUD1c=;
        b=aHbBRz5J9Aj3G8t81UGKRAiHxp85FPEwToVFgCW1GgtiZvSrD9YY8t942tMzp62gUI
         DtfwW53yCrfgESsmc2VBfmcBZKLRh2ONZGgPDvZ5GKus2TlyKxzzpIh745codEExC2lh
         ij/wVk74X1PuKL783l9zwY9Lr7sHftZP/XJeqvGsl9inwzfAwaY6VCfRQFE4lTUixhCO
         VDljwJLQCLjo5ivW4vK/SVQDquTbGzXUyKH7XO0qLAqbSY0HNbwZT1FoDBL8Z7KORmQ1
         1gcw0oAv/zuWVtVZxTHK786KtviF6qm14rMonkBEPRFW7JdbPYxmk4skZkCUjlkgRjZ9
         11Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=cm21SZmCOEnGa1IUks72kMTUS/l8TuTgz+8KblDUD1c=;
        b=tHBOEHB9McizLbJxvu0/LYtHV2aBIee8+eQzAj7m2pKbQigcK/xVVDW7XP6mTrzq4I
         3UwBR9LeLMPpxR9jPRsqn0VPdSsX7IGlVgmPMIQmi8ZnJ3wovvrsUWztn+xx8LJtsZ8J
         KZsNSMn1UdFKB2A8Pn3J2CMdeONVKzJuRtpOgpqwSxZeukczGqv0UlcPaaYNoFOHFiOP
         W52W4r2lMc23RgPwUY2KnFnRujIm04bDZdMo6Jyb11QviFYEVMLcbrv/J4+fxxBmtLQS
         UBCAu2TypWkJxEsofhh98GaVMjL62mtltp8h2uGC3zu8b0VGzmtM0n7TnwyM+EyWFavW
         I/+Q==
X-Gm-Message-State: AOAM531Ens6qkZQgQPJOeSLGD5vo3QR11O/8Zxz3IOExEGiUxLOLqTk6
        AvA/TgXolHon1Yb5/6f+P7ElMbnkPcHq6ZnPdeZm5FpZo8KP2gpIFhTzt4JJ/b1DYOugZv29kEl
        XiNpI4YxrI+CYXU12vlM7NF0sDCW3b5NrG4tkelWSd/bLYGeclWpn+lmDJazgIoF+BRUYy2QO
X-Google-Smtp-Source: ABdhPJzv0Wa487CRRI8/pRtUCN5yStdkRbVbpY2Nr9sp0jpoSMkZd9zemy07ra5vf0QknybGia8YUexjvyFOK+WM
Sender: "awogbemila via sendgmr" <awogbemila@awogbemila.sea.corp.google.com>
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a25:2208:: with SMTP id
 i8mr7484293ybi.100.1606325930703; Wed, 25 Nov 2020 09:38:50 -0800 (PST)
Date:   Wed, 25 Nov 2020 09:38:42 -0800
Message-Id: <20201125173846.3033449-1-awogbemila@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH net-next v8 0/4] GVE Raw Addressing
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     alexander.duyck@gmail.com, saeed@kernel.org,
        David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patchset description:
This  patchset introduces "raw addressing" mode to the GVE driver.
Previously (in "queue_page_list" or "qpl" mode), the driver would
pre-allocate and dma_map buffers to be used on egress and ingress.
On egress, it would copy data from the skb provided to the
pre-allocated buffers - this was expensive.
In raw addressing mode, the driver can avoid this copy and simply
dma_map the skb's data so that the NIC can use it.
On ingress, the driver passes buffers up to the networking stack and
then frees and reallocates buffers when necessary instead of using
skb_copy_to_linear_data.
Patch 3 separates the page refcount tracking mechanism
into a function gve_rx_can_recycle_buffer which uses get_page - this will
be changed in a future patch to eliminate the use of get_page in tracking
page refcounts.

Changes from v7
Patch 1: Drop static inline functions in gve_adminq.c.
Patch 2: Simplify gve_rx_refill_buffers logic to use (fill_cnt - rx->cnt).
Patch 4: Use per-ring dma_mapping error stat.

Catherine Sullivan (3):
  gve: Add support for raw addressing device option
  gve: Add support for raw addressing to the rx path
  gve: Add support for raw addressing in the tx path

David Awogbemila (1):
  gve: Rx Buffer Recycling

 drivers/net/ethernet/google/gve/gve.h         |  39 +-
 drivers/net/ethernet/google/gve/gve_adminq.c  |  89 ++++-
 drivers/net/ethernet/google/gve/gve_adminq.h  |  15 +-
 drivers/net/ethernet/google/gve/gve_desc.h    |  19 +-
 drivers/net/ethernet/google/gve/gve_ethtool.c |   2 +
 drivers/net/ethernet/google/gve/gve_main.c    |  11 +-
 drivers/net/ethernet/google/gve/gve_rx.c      | 364 +++++++++++++-----
 drivers/net/ethernet/google/gve/gve_tx.c      | 207 ++++++++--
 8 files changed, 579 insertions(+), 167 deletions(-)

-- 
2.29.2.454.gaff20da3a2-goog

