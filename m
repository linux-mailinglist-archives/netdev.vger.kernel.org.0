Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BAB1E06CB
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 16:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732094AbfJVOxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 10:53:51 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:54144 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726955AbfJVOxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 10:53:51 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 6F1F9A80070;
        Tue, 22 Oct 2019 14:53:49 +0000 (UTC)
Received: from cim-opti7060.uk.solarflarecom.com (10.17.20.154) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 22 Oct 2019 15:53:43 +0100
From:   Charles McLachlan <cmclachlan@solarflare.com>
Subject: [PATCH net-next 0/6] sfc: Add XDP support
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-net-drivers@solarflare.com>,
        <brouer@redhat.com>
Message-ID: <05b72fdb-165c-1350-787b-ca8c5261c459@solarflare.com>
Date:   Tue, 22 Oct 2019 15:53:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.154]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24994.003
X-TM-AS-Result: No-2.376700-8.000000-10
X-TMASE-MatchedRID: 2WESandNuK/SfkI8LIozOyAI8aJmq0jw4+QcMo54nTiMUViaYYbK3H8Q
        cMWiCE6P0Q2PKuAVSm4o80rRY/E6aoG/yDOSYBKbqJSK+HSPY+/pVMb1xnESMnAal2A1DQmsfnE
        Uvz4DqlRKNUgU7kTjgJehmDCMze07o8WMkQWv6iV95l0nVeyiuJ325o7vMWDt0C1sQRfQzEHEQd
        G7H66TyND1NE3SaFLXoRD1RY7WX6GMcdmHZq7TmYK0E78cym9aHYsLWRSXm+6l4LFSKJ+lMf1sU
        /VqJarCBFrzATh/Vkb4Dn3NuruJxqKL1B5tcIn8kERyuRHFgnhSMqc7UpUorBKRsPC6bTvOqrQx
        XydIwG+qgpxQSEwcOA==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-2.376700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24994.003
X-MDID: 1571756030-KkEn9YZovO0P
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Supply the XDP callbacks in netdevice ops that enable lower level processing
of XDP frames.

Charles McLachlan (6):
  sfc: support encapsulation of xdp_frames in efx_tx_buffer.
  sfc: perform XDP processing on received packets.
  sfc: Enable setting of xdp_prog.
  sfc: allocate channels for XDP tx queues.
  sfc: handle XDP_TX outcomes of XDP eBPF programs.
  sfc: add XDP counters to ethtool stats.

 drivers/net/ethernet/sfc/ef10.c       |  10 +-
 drivers/net/ethernet/sfc/efx.c        | 244 ++++++++++++++++++++++++--
 drivers/net/ethernet/sfc/efx.h        |   3 +
 drivers/net/ethernet/sfc/ethtool.c    |  25 +++
 drivers/net/ethernet/sfc/net_driver.h |  59 ++++++-
 drivers/net/ethernet/sfc/rx.c         | 140 ++++++++++++++-
 drivers/net/ethernet/sfc/tx.c         |  74 ++++++++
 7 files changed, 527 insertions(+), 28 deletions(-)

