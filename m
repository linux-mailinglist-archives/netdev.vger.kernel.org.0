Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C98792B884D
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 00:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgKRXUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 18:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbgKRXUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 18:20:21 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB8AC0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 15:20:19 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id 190so2224010pfz.16
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 15:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=qj54RYxS1LDR5LDEWLLq0xsm0onee3dh1D4RLNdtcwI=;
        b=b0Qr0KSn22EoYbbfhYLn+ZPl48c49u6z0uY1G6Gnv4tNL23QfdZH7VU0ED7HstXRNp
         kwTQ1ODV6Df6Ur8cucqUKf+6mIBDv85IgjeR9kbhDwq7OovlwZ+T8fuNEgf23gNKExQS
         VvAxjzriWbhB12vSCMU0+dW5hLGzIYuTXWhqwWT1MUAppqFHHYNUn1qPbR6EQ3gDwh/0
         l7Ersqmc7sVTlmMaCNZ/cYnw7WIvsDnKmfCJWR7oO1cOfxfizgUHOmBho+uiLd/8PRU3
         vHOSZTioYeKUeebiMWUv5HWTQV8SZqT/S2hNyzEhKopfaUy2ZaZiS+0YeU42U+X8C/Ow
         s4oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=qj54RYxS1LDR5LDEWLLq0xsm0onee3dh1D4RLNdtcwI=;
        b=VnwAXbJxnKfkvX62sKlxYlCtqQsSMEdx14Y3My0W6tUecxCG+GHwziSzQIHjimyqK7
         NEPJgNHYVlLTgG2OX9XcguQp6Jf/fxZW6x2KvHI8V0hA8Kq7/2i/C7ue+suBNPpKcJmE
         lcxyYZAhM2vToWL2bokXlD1t+Gz5rY7kMpIIczgZosSCbJcozJRLYPB6fyR8/TVia47U
         BPfUFnN8JPeiBKX+eKGYZfaOJP46bozgcx7imAKa9lWDnjrROjt4pxUeIKao01z1wZkg
         Q36Vd0v58EDLqw5wYn4iO+6clbhzUhtShVPn/tgueU0n3h8VvMHmj8Q2PjyF0uJ9r/Dk
         e+Jg==
X-Gm-Message-State: AOAM533XgUSaZlaLooyZgRNVX49/DJ8Vhqx8jCR1x5PeaatXn6lc9eI3
        30LXVT43wLYMBTOxL2T+DyCgwEVOmXUzTXTaScDwC6HDYfhW8qu4743pAgZtRzgWhlxNrgtprbB
        JSjBho4bGgHTHPckxkZw2ArQBNBSJijI5sr83EsKV59AmGwoudFiGtUmICCelx0lWacgrnQfv
X-Google-Smtp-Source: ABdhPJyjodaMTN7AyR8muV+EcxM5eZnD5KEFwvrL8FrIiygei0FFw+in/tW6N0Pkyvpe2yXWmSjqvkQEmV6Iov8c
Sender: "awogbemila via sendgmr" <awogbemila@awogbemila.sea.corp.google.com>
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a62:fc46:0:b029:18b:8eae:86e9 with SMTP
 id e67-20020a62fc460000b029018b8eae86e9mr6639300pfh.43.1605741618793; Wed, 18
 Nov 2020 15:20:18 -0800 (PST)
Date:   Wed, 18 Nov 2020 15:20:10 -0800
Message-Id: <20201118232014.2910642-1-awogbemila@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
Subject: [PATCH net-next v7 0/4] GVE Raw Addressing
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1: Use u8 instead of bool for raw_addressing bit in gve_priv structure.
        Simplify pointer arithmetic: use (option + 1) in gve_get_next_option.
        Separate option parsing switch statement into individual function.
Patch 2: Use u8 instead of bool for raw_addressing bit in gve_gve_rx_data_queue structure.
        Correct typo in gve_desc.h comment (s/than/then/).
        Change gve_rx_data_slot from struct to union.
        Remove dma_mapping_error path change in gve_alloc_page - it should
        probably be a bug fix.
        Use & to obtain page address from data_ring->addr.
        Move declarations of local variables i and slots to if statement where they
        are used within gve_rx_unfill_pages.
        Simplify alloc_err path by using "while(i--)", eliminating need for extra "int j"
        variable in gve_prefill_rx_pages.
        Apply byteswap to constant in gve_rx_flip_buff.
        Remove gve_rx_raw_addressing as it does not do much more than gve_rx_add_frags.
        Remove stats update from elseif block, no need to optimize for infrequent case of
        work_done = 0.
Patch 3: Use u8 instead of bool for can_flip in gve_rx_slot_page_info.
        Move comment in gve_rx_flip_buff to earlier, more relevant patch.
        Fix comment wrap in gve_rx_can_flip_buffers.
        Use ternary statement for gve_rx_can_flip_buffers.
        Correct comment in gve_rx_qpl.
Patch 4: Use u8 instead of bool in gve_tx_ring structure.
        Get rid of unnecessary local variable "dma" in gve_dma_sync_for_device.

Catherine Sullivan (3):
  gve: Add support for raw addressing device option
  gve: Add support for raw addressing to the rx path
  gve: Add support for raw addressing in the tx path

David Awogbemila (1):
  gve: Rx Buffer Recycling

 drivers/net/ethernet/google/gve/gve.h        |  38 +-
 drivers/net/ethernet/google/gve/gve_adminq.c |  90 ++++-
 drivers/net/ethernet/google/gve/gve_adminq.h |  15 +-
 drivers/net/ethernet/google/gve/gve_desc.h   |  19 +-
 drivers/net/ethernet/google/gve/gve_main.c   |  11 +-
 drivers/net/ethernet/google/gve/gve_rx.c     | 403 ++++++++++++++-----
 drivers/net/ethernet/google/gve/gve_tx.c     | 211 ++++++++--
 7 files changed, 620 insertions(+), 167 deletions(-)

-- 
2.29.2.299.gdc1121823c-goog

