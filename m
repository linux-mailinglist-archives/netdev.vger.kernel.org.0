Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E903F9D62
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 19:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236762AbhH0RP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 13:15:56 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:55974
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234095AbhH0RPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 13:15:55 -0400
Received: from HP-EliteBook-840-G7.. (36-229-239-33.dynamic-ip.hinet.net [36.229.239.33])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 53EA43F365;
        Fri, 27 Aug 2021 17:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1630084504;
        bh=fw+JpHitxvUyKelv4NHJFKDV+k6YIUABn/njeLUjaJw=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=cUbcwXKl8n+9qZbXIeT/Lz8JxauKhlqwBpZ3FxznT64Fr778Wf5n3BCCCJy4nwEmc
         07PL3diMS2/g3JMebdMc+iwgQx5gRxWD2YFNZoboYwjb2iCO8BMyADi9xGndAP+JmS
         8EVGVw1e98I5C/Qp5RI7pT43cgZtd20+aCheZoZfYakMmAu4+r9rkOcbYOjezzo0W9
         nb43n8y9E04TC4d9TRYzuvoKXuFz3OGnlXwOtloCPzwvnCNowen8+6LJE/cUvzzfTF
         he85rVShBypRO7o4bqOsEyTLejmVrkIqjbt9ZUmBeO4+rylU3LoU7HGvTW4beA3f0j
         zGEWbY3nJrBuA==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com, bhelgaas@google.com
Cc:     davem@davemloft.net, kuba@kernel.org, anthony.wong@canonical.com,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [RFC] [PATCH net-next v4 0/2] r8169: Implement dynamic ASPM mechanism for recent 1.0/2.5Gbps Realtek NICs
Date:   Sat, 28 Aug 2021 01:14:50 +0800
Message-Id: <20210827171452.217123-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of the series is to get comments and reviews so we can merge
and test the series in downstream kernel.

The latest Realtek vendor driver and its Windows driver implements a
feature called "dynamic ASPM" which can improve performance on it's
ethernet NICs.

Heiner Kallweit pointed out the potential root cause can be that the
buffer is to small for its ASPM exit latency.

So bring the dynamic ASPM to r8169 so we can have both nice performance
and powersaving at the same time.

For the slow/fast alternating traffic pattern, we'll need some real
world test to know if we need to lower the dynamic ASPM interval.

v3:
https://lore.kernel.org/netdev/20210819054542.608745-1-kai.heng.feng@canonical.com/

v2:
https://lore.kernel.org/netdev/20210812155341.817031-1-kai.heng.feng@canonical.com/

v1:
https://lore.kernel.org/netdev/20210803152823.515849-1-kai.heng.feng@canonical.com/

Kai-Heng Feng (2):
  PCI/ASPM: Introduce a new helper to report ASPM capability
  r8169: Implement dynamic ASPM mechanism

 drivers/net/ethernet/realtek/r8169_main.c | 77 ++++++++++++++++++++---
 drivers/pci/pcie/aspm.c                   | 11 ++++
 include/linux/pci.h                       |  2 +
 3 files changed, 82 insertions(+), 8 deletions(-)

-- 
2.32.0

