Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA843DD39C
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 12:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233204AbhHBK1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 06:27:16 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:37741 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231357AbhHBK1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 06:27:15 -0400
X-IronPort-AV: E=Sophos;i="5.84,288,1620658800"; 
   d="scan'208";a="89524086"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 02 Aug 2021 19:27:03 +0900
Received: from localhost.localdomain (unknown [10.226.92.138])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 9B97D40083D9;
        Mon,  2 Aug 2021 19:26:57 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH net-next v2 0/8] Add Gigabit Ethernet driver support
Date:   Mon,  2 Aug 2021 11:26:46 +0100
Message-Id: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DMAC and EMAC blocks of Gigabit Ethernet IP found on RZ/G2L SoC are
similar to the R-Car Ethernet AVB IP. 

The Gigabit Ethernet IP consists of Ethernet controller (E-MAC), Internal
TCP/IP Offload Engine (TOE)  and Dedicated Direct memory access controller
(DMAC).

With a few changes in the driver we can support both IPs.

Currently a runtime decision based on the chip type is used to distinguish
the HW differences between the SoC families.

This patch series is in preparation for supporting the RZ/G2L SoC by
replacing driver data chip type with struct ravb_hw_info by moving chip
type to it and also adding gstrings_stats, gstrings_size, net_hw_features,
net_features, num_gstat_queue, num_tx_desc, stats_len, skb_sz variables to
it. This patch also adds the feature bit for {RX, TX} clock internal
delays and TX Drop counters HW features found on R-Car Gen3 to struct
ravb_hw_info.

This patch series is based on net-next.

v1->v2:
 * Replaced driver data chip type with struct ravb_hw_info
 * Added gstrings_stats, gstrings_size, net_hw_features, net_features,
   num_gstat_queue, num_tx_desc, stats_len, skb_sz to struct ravb_hw_info
 * Added internal_delay and tx_drop_cntrs hw feature bit to struct ravb_hw_info

RFC->V1
  * Incorporated feedback from Andrew, Sergei, Geert and Prabhakar
  * https://patchwork.kernel.org/project/linux-renesas-soc/list/?series=515525

Biju Das (8):
  ravb: Add struct ravb_hw_info to driver data
  ravb: Add skb_sz to struct ravb_hw_info
  ravb: Add num_gstat_queue to struct ravb_hw_info
  ravb: Add stats_len to struct ravb_hw_info
  ravb: Add gstrings_stats and gstrings_size to struct ravb_hw_info
  ravb: Add net_features and net_hw_features to struct ravb_hw_info
  ravb: Add internal delay hw feature to struct ravb_hw_info
  ravb: Add tx_drop_cntrs to struct ravb_hw_info

 drivers/net/ethernet/renesas/ravb.h      | 18 +++++
 drivers/net/ethernet/renesas/ravb_main.c | 91 ++++++++++++++++--------
 2 files changed, 80 insertions(+), 29 deletions(-)

-- 
2.17.1

