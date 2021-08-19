Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4407F3F12E2
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 07:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhHSFqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 01:46:47 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:39414
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229782AbhHSFqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 01:46:45 -0400
Received: from localhost.localdomain (1-171-223-154.dynamic-ip.hinet.net [1.171.223.154])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 2A1CC40C9D;
        Thu, 19 Aug 2021 05:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629351963;
        bh=0pXSE70avKi/FGQtwaSF/acPtLoT4scgcAlPCGtsPV4=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=bdpGUtCqXdPZmmxFMHMDeEnQhIotVwPu4MT0oIeggRkIuK6NaBf6jzmJV9JbNjwj/
         vw9LuhTG6ZBNplnAF0vtJQ3S5bjz7oIvkGNpmEQhwLEXK9rzsQ4sA3lCWfM6as9iIn
         p4eoIyNobB3V9BbHK2jaDFFcQp9YiXfRWui2DPlXk4rAk+A8HeauUFnxH3w3hvqjcg
         ujMIsr5ObNB2my9CsU0e4T2huF8jgPhHtkq1cYgbfXUOydQllivnFndrqJpyJ+G4EC
         Y71ULt4fBYP7THVvwzf9CbENTjIReTvWBqx54DZKhazZEpCsu0VWxda/fkUCFbGeFE
         sGCwwPAvqfi3w==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com, bhelgaas@google.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH net-next v3 0/3] r8169: Implement dynamic ASPM mechanism for recent 1.0/2.5Gbps Realtek NICs
Date:   Thu, 19 Aug 2021 13:45:39 +0800
Message-Id: <20210819054542.608745-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The latest Realtek vendor driver and its Windows driver implements a
feature called "dynamic ASPM" which can improve performance on it's
ethernet NICs.

Heiner Kallweit pointed out the potential root cause can be that the
buffer is to small for its ASPM exit latency.

So bring the dynamic ASPM to r8169 so we can have both nice performance
and powersaving at the same time.

v2:
https://lore.kernel.org/netdev/20210812155341.817031-1-kai.heng.feng@canonical.com/

v1:
https://lore.kernel.org/netdev/20210803152823.515849-1-kai.heng.feng@canonical.com/

Kai-Heng Feng (3):
  r8169: Implement dynamic ASPM mechanism
  PCI/ASPM: Introduce a new helper to report ASPM support status
  r8169: Enable ASPM for selected NICs

 drivers/net/ethernet/realtek/r8169_main.c | 69 ++++++++++++++++++++---
 drivers/pci/pcie/aspm.c                   | 11 ++++
 include/linux/pci.h                       |  2 +
 3 files changed, 74 insertions(+), 8 deletions(-)

-- 
2.32.0

