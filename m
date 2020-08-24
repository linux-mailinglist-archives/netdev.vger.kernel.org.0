Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF0E24F367
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 09:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbgHXHzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 03:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgHXHze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 03:55:34 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53173C061573
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 00:55:34 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id d19so4166943pgl.10
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 00:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=TBme7T8KyGBEUTMbLCPcWsXimJniOz1OL21lqT6e7CE=;
        b=DfH/uFg8XKLZg6pjJ48lu2aj8JmfEcp68NiV779A/lQDioYBEeM8yiqvEcUvGiqtFy
         wBVw5iYHb5YhrBxhVjagZYa6d2ygAjZg3oN37QIWTDqh7kdKeYz1VJwQII7E7YJBGWZA
         EwSmL7tj4xGOZWYsiL8uaPyz8kNnHIpz5M5VcdQ2wd9HS3n6Ul2uOjX6soTHIdCJCCkH
         nIJAv/GpX8YdYYp5ZgZbAObQ4XPrq0XehmhseXgyiwYJaFBkwrUxA/BK3H7+1iHwuzv4
         L8LFB9HdDaFfP1K1w5vVqcf/mvg4d1DsxyQyHatL8X9V0z6Nl9tlY+Ad/9lwbV6fXnBm
         jrdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TBme7T8KyGBEUTMbLCPcWsXimJniOz1OL21lqT6e7CE=;
        b=B6AgqegnUxt8nVIqbwlPiaDV7MaCa3/6ib2gvedcaIVyPSSQhNIRGNb1sVCXnhVe3B
         kBVju+v++oeJWng61gZHpq5lBAy4zKjUeGbmFDa+3tUoRmbwf2bkEZShRBiEkqSW+uKV
         3B9v9UxhQn7yOoWLZogiJPMJcMTFXlwac2rzwfkEUOmG7hlPS2dqDzMJlwXV/istT5UP
         p7NlRSZjQA3tyzir4mfcPxf34o3fxCRJycDm7XduMjCCa2jIQZoiVCsSa6CwHZ/rAIVH
         WLGSs2JROb0HOqlMSvHFNDfpNhQQYMh3USMYbX7ohoq6CygV0xyXhZpM1WNh52Pju/oP
         WJxg==
X-Gm-Message-State: AOAM533DNa5xTqxRNB7jtAnM0YKl8Xw0K1PkOWH5P5XxDqnjge8DufQX
        nTL2b3tBh4qCQjhlCMFf0P4=
X-Google-Smtp-Source: ABdhPJz4fHbZr2KvI4J816nfyiNYeZLsynV8qaSFQWLeZ+GRr9Zem+bawc5Ym+yGfRnag0kYd/8HWw==
X-Received: by 2002:a63:770a:: with SMTP id s10mr2546620pgc.35.1598255733336;
        Mon, 24 Aug 2020 00:55:33 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id z25sm10441722pfn.159.2020.08.24.00.55.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Aug 2020 00:55:32 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com,
        netdev@vger.kernel.org, sgoutham@marvell.com
Cc:     Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [PATCH v7 net-next 0/3] Add PTP support for Octeontx2
Date:   Mon, 24 Aug 2020 13:25:14 +0530
Message-Id: <1598255717-32316-1-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

Hi,

This patchset adds PTP support for Octeontx2 platform.
PTP is an independent coprocessor block from which
CGX block fetches timestamp and prepends it to the
packet before sending to NIX block. Patches are as
follows:

Patch 1: Patch to enable/disable packet timstamping
         in CGX upon mailbox request. It also adjusts
         packet parser (NPC) for the 8 bytes timestamp
         appearing before the packet.

Patch 2: Patch adding PTP pci driver which configures
         the PTP block and hooks up to RVU AF driver.
         It also exposes a mailbox call to adjust PTP
         hardware clock.

Patch 3: Patch adding PTP clock driver for PF netdev.

Acked-by: Richard Cochran <richardcochran@gmail.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>

v7:
 As per Jesse Brandeburg comments:
 Simplified functions in patch 1
 Replaced magic numbers with macros
 Added Copyrights
 Added code comments wherever required
 Modified commit description of patch 2
v6:
 Resent after net-next is open
v5:
 As suggested by David separated the fix (adding rtnl lock/unlock)
 and submitted to net.
 https://www.spinics.net/lists/netdev/msg669617.html
v4:
 Added rtnl_lock/unlock in otx2_reset to protect against
 network stack ndo_open and close calls
 Added NULL check after ptp_clock_register in otx2_ptp.c
v3:
 Fixed sparse error in otx2_txrx.c
 Removed static inlines in otx2_txrx.c
v2:
 Fixed kernel build robot reported error by
 adding timecounter.h to otx2_common.h


Aleksey Makarov (2):
  octeontx2-af: Add support for Marvell PTP coprocessor
  octeontx2-pf: Add support for PTP clock

Zyta Szpak (1):
  octeontx2-af: Support to enable/disable HW timestamping

 drivers/net/ethernet/marvell/octeontx2/af/Makefile |   2 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |  29 +++
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |   4 +
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  21 ++
 drivers/net/ethernet/marvell/octeontx2/af/ptp.c    | 274 +++++++++++++++++++++
 drivers/net/ethernet/marvell/octeontx2/af/ptp.h    |  25 ++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  29 ++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   5 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  39 +++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  43 ++++
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  31 +++
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |   3 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |   7 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  19 ++
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |  28 +++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 168 ++++++++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.c  | 212 ++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.h  |  13 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  87 ++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |   1 +
 20 files changed, 1030 insertions(+), 10 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/ptp.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/ptp.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.h

-- 
2.7.4

