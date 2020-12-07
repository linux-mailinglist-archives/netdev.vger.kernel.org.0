Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D512D1DA9
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 23:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgLGWqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 17:46:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727952AbgLGWqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 17:46:16 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA38C061793
        for <netdev@vger.kernel.org>; Mon,  7 Dec 2020 14:45:30 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id u26so10103693pgl.15
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 14:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=nYdw5TXfuZLxaOPIqx4DuddwU0RkwXwNxRYoSwn5lgs=;
        b=Lb51bmp6VjaOZ8qbPhkgz71L8SPcAKALtGgaCwRs6d4LnAQqQ9hHjCvxV55FTvjkNZ
         qA7vxExo9sq3GZxcSJQ4ROVAlbHwIu66UdrfT3mxHsyBwMsuC+5RstdSt8S/B1GTHm50
         vflOZmgh4RFEo/T5CUsiZ268dEBfxYF9HxyNkGmnXGvoOgAMDGyqWYziFJczMVKuSC3g
         YcxZUWqUs6zBW+xxvYAAhavuVtRlGi+dpOHnOK1vmFTeatq+ysMwRA3KC97EJWKXRn1k
         DWgfI9Y6KaENDwfJ2aL5hv1266DHtdhDhMSi/yivJMxAIsnZnGse8yqa/mIjhsVDRaIA
         P3EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=nYdw5TXfuZLxaOPIqx4DuddwU0RkwXwNxRYoSwn5lgs=;
        b=b5tV+IVWHVohVLEEbR0b9MpH3vYe35L3eMnfI0ViTERQUul+z5yJVcJaIcR2k5So7n
         P3jzw0B8/L0ZD7jcRZXaV2a2OYSJCWBmA8StLOy3OGTXcIALGnani5fG/mxwBmGACClJ
         pCUI3xpnCaO9a5vtm3LXV2BC9bzDGZdm0quRylxbmrlui+IAgX7npGJiekuLUuRFKFRS
         3J/brsNIZPQzut863bPUFwRuIGs9LD/G+LFUDNIUCbJDQtUnSStg4ILNy/4lwMR92wmi
         HIQIfjCAFvtUHSVTf49Mdpk489HN+ySv99KfQF40qf0W2ZBLZBmIEvKSy4yXr3GWI/W5
         R9oA==
X-Gm-Message-State: AOAM532h71S5zzDO3dQd/WV9n2uafaYSsue3pWa4XzH2h45Sn5D8+eLf
        LnylJhJHI2a8Di+Kk2xUHtgeSKQBiWJQRtc8yf4s1kfY6iLZPLKDQm3EuiHKyNWyDGrJE6WBpn6
        fMYgc4HJj+rbK4hoKbtdcmileicYcRUgYbW8cnWFrOdmBqS2rgXF5Vjlm3oanz4h/eLMjd//B
X-Google-Smtp-Source: ABdhPJxC1r8AmUE7FWkZvWfuQrdWm+9gT/kf4hsTnLtQMWr18wNlnfUwUHp2UOlrp5T5GKJTY+gUMvL9Ko3rih5d
Sender: "awogbemila via sendgmr" <awogbemila@awogbemila.sea.corp.google.com>
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a17:90b:1183:: with SMTP id
 gk3mr965657pjb.191.1607381129564; Mon, 07 Dec 2020 14:45:29 -0800 (PST)
Date:   Mon,  7 Dec 2020 14:45:22 -0800
Message-Id: <20201207224526.95773-1-awogbemila@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH net-next v10 0/4] GVE Raw Addressing
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     alexander.duyck@gmail.com, saeed@kernel.org,
        David Awogbemila <awogbemila@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>
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

Changes from v9:
  Patch 4: Use u64, not u32 for new tx stat counters.

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
 drivers/net/ethernet/google/gve/gve_tx.c      | 197 ++++++++--
 8 files changed, 574 insertions(+), 162 deletions(-)

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

-- 
2.29.2.576.ga3fc446d84-goog

