Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3713014C9
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 11:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbhAWK53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 05:57:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbhAWK51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 05:57:27 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1DFCC06174A
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 02:56:45 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1611399403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=bCul3U+kJeOotRhOb9umYQTuhcTqAaHjbr4ZgUvSg7k=;
        b=yWMadHrh7FBV+ymveSiEpyKV1OAlD30sj29loRUYhBmegQducknXYkeYHfNyljcjgVW3hk
        7f61HAbmZ69pJDsAutpWjWoLH/ZJhJTVMBIcDxwHd4JqDVhYgFDDfkzhi/dTK7UgENxoEP
        QU8HcmbSdYZbi+mZ0FWWnwvYkbuo3KHoRdPkProimkwb/rRh8URVhRsajhXwMgUV883EGX
        11CC7txPD7Ln8o+lBgILOhlyPCh8oTOhGwTVC9o3bNoIrIxhBKG50mQ585zxk2quvB2m5M
        WF+kEirodDM6BeKZN2c1KWZ0xaDZT41gOAoENNZOEg7sWIJU9umcdTDVzimdfw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1611399403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=bCul3U+kJeOotRhOb9umYQTuhcTqAaHjbr4ZgUvSg7k=;
        b=J8g+RN6cLDe/twDNi/cY4FNaeW2zmtUPfQl40cPKHM4NjK5dArCVpU300FUkfQBvpahc8N
        GvZjWjvgh/ICXrCg==
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v3 net-next 0/1] net: dsa: hellcreek: Add TAPRIO offloading
Date:   Sat, 23 Jan 2021 11:56:32 +0100
Message-Id: <20210123105633.16753-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The switch has support for the 802.1Qbv Time Aware Shaper (TAS). Traffic
schedules may be configured individually on each front port. Each port has eight
egress queues. The traffic is mapped to a traffic class respectively via the PCP
field of a VLAN tagged frame.

Previous attempts:

 * https://lkml.kernel.org/netdev/20201121115703.23221-1-kurt@linutronix.de/
 * https://lkml.kernel.org/netdev/20210116124922.32356-1-kurt@linutronix.de/

Changes since v2:

 * Add comment about rescheduling period
 * Validate entry command
 * Coding style
 * Add rb tag

Changes since v1:

 * Use taprio data structure
 * Calculate base_time if in past
 * Validate input parameters
 * Minor things

Kurt Kanzenbach (1):
  net: dsa: hellcreek: Add TAPRIO offloading support

 drivers/net/dsa/hirschmann/hellcreek.c | 303 ++++++++++++++++++++++++-
 drivers/net/dsa/hirschmann/hellcreek.h |  17 +-
 2 files changed, 318 insertions(+), 2 deletions(-)

-- 
2.20.1

