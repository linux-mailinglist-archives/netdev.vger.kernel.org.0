Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E40182CC4FF
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 19:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387795AbgLBSY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 13:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgLBSY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 13:24:58 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F519C0613D4
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 10:24:18 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id q14so1490528pgq.9
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 10:24:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=omo1GTd+G9VMfPrYjDcrR0xsZwv8ge2aYhBIc0nvnLs=;
        b=X1xu8dV5vbW6a7rBSY5E/M49NbqLa1tW9Rgn6TxFXDh1NGooG1mDlkYNvqp5Uk0DiT
         7yDT6F83CTWcpMd1CySirt/wmgqRrVAwZa1BVemmt8tbHpFakMlnkyjwMZxwpaz7MdWr
         908ZXI8x+DIiyWtejrSt5WK7rSjkROoydw463FnCZe/srtPNa+yzIBqkqeKhOXyPsKm3
         3ARy6c1bFKYRvmoMs+B1PUv0NdgSzEpEqchxLk0AdUmrDszDvEvqTANigtx5T2de2eFF
         EHoMUPvTJxdLFo8S2yp8BibvGY3lq9ygxDV1znkIPHzteyJodUEPqBXnxvzL9aEqZUrj
         rrcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=omo1GTd+G9VMfPrYjDcrR0xsZwv8ge2aYhBIc0nvnLs=;
        b=VqEJEOVE9TfLaO+1C9yCPeJnhDLuXn+p+DW9VQ26az/N5ZzgXzdm/jBfAoW0srapfe
         Anod1wM1igQMivSY34bohfTv7XLnDSVrm06J7yHOZkBgtZSvM1YeoHyNs752SqAe1Ps4
         BDxvoEOMMgIxk8A5WcbziiktHUmXjPMyLExEr4Catx8dSybSY+fKlnMiycAzRsJyQezk
         ZMi9b3tcb4KELW5paK2gKya0+2BSSPSRFt7gfKAOYGw7cwk0uUwGUkxhalF/7lK1fmBn
         e7bhJV3iiZnudUk3DvMEOf6F0UUHQLSCns6BsmxIpAfRCD10GbcLNRxlfsl6tKwOHFx1
         TEgQ==
X-Gm-Message-State: AOAM533x9eA5ZZ61AiwQl0zLVBXKrrhddlCOmL+nUPf2XFtMjVmI/QT4
        XayIWahkk8rr4CruAmqglq6w/Fx71ErpGcHg4UBfeGcLD/7yEx9RlecanwXoQOz6Xs8a1jnFkwu
        1o9d52+pplvWMvdLoe3cUpNt56ruEl7jBIluQ94il4f5l7Fon0z/TCMFAzFgiRiYLOGk5Yca9
X-Google-Smtp-Source: ABdhPJx6uRGLlwkZeyDadbLHiUZH3Xt8ZvLMMnTWpTp/YX5fjj/o4A04WInuNsnQ4yZ17vjlyl6TBdE93LNjLD56
Sender: "awogbemila via sendgmr" <awogbemila@awogbemila.sea.corp.google.com>
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a65:558a:: with SMTP id
 j10mr1021866pgs.370.1606933457511; Wed, 02 Dec 2020 10:24:17 -0800 (PST)
Date:   Wed,  2 Dec 2020 10:24:09 -0800
Message-Id: <20201202182413.232510-1-awogbemila@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH net-next v9 0/4] GVE Raw Addressing
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     alexander.duyck@gmail.com, saeed@kernel.org,
        eric.dumazet@gmail.com, David Awogbemila <awogbemila@google.com>
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

Changes from v8:
Patch 4: Free skbs that are not sent in gve_tx().

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
 drivers/net/ethernet/google/gve/gve_tx.c      | 202 ++++++++--
 8 files changed, 577 insertions(+), 164 deletions(-)

-- 
2.29.2.576.ga3fc446d84-goog

