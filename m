Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66C56633ACF
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 12:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbiKVLMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 06:12:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbiKVLMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 06:12:12 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D339E2F64F;
        Tue, 22 Nov 2022 03:12:09 -0800 (PST)
X-UUID: e48cd87da41b4c7a85063be4f3c56350-20221122
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=4QNzSdvQ3Vol+vIsemSRu1OecRAsVQwKPhb3CjZyW3I=;
        b=Wjj3x9k9H9br8RznpAAgIsN0mM5D2Qpb3R1YxinrH6pK3NE0HgTL92sFFXvTS/Jw4e845s7Mu8xp6u5Y+Yx7SKXrYNjpK/tdgaIe6IyLnC2mnjt4uSvSjM8iFpePcpvWYa9NnbfLIfPZHBY1v+w8XyYCyLlGUzxauRG6wflUbxQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.12,REQID:772d0a80-79c2-45d7-91f5-ccc5403c409f,IP:0,U
        RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-5
X-CID-META: VersionHash:62cd327,CLOUDID:422e7f2f-2938-482e-aafd-98d66723b8a9,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: e48cd87da41b4c7a85063be4f3c56350-20221122
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
        (envelope-from <yanchao.yang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 219710448; Tue, 22 Nov 2022 19:12:01 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Tue, 22 Nov 2022 19:12:00 +0800
Received: from mcddlt001.gcn.mediatek.inc (10.19.240.15) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Tue, 22 Nov 2022 19:11:58 +0800
From:   Yanchao Yang <yanchao.yang@mediatek.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev ML <netdev@vger.kernel.org>,
        kernel ML <linux-kernel@vger.kernel.org>
CC:     MTK ML <linux-mediatek@lists.infradead.org>,
        Liang Lu <liang.lu@mediatek.com>,
        Haijun Liu <haijun.liu@mediatek.com>,
        Hua Yang <hua.yang@mediatek.com>,
        Ting Wang <ting.wang@mediatek.com>,
        Felix Chen <felix.chen@mediatek.com>,
        Mingliang Xu <mingliang.xu@mediatek.com>,
        Min Dong <min.dong@mediatek.com>,
        Aiden Wang <aiden.wang@mediatek.com>,
        Guohao Zhang <guohao.zhang@mediatek.com>,
        Chris Feng <chris.feng@mediatek.com>,
        Yanchao Yang <yanchao.yang@mediatek.com>,
        Lambert Wang <lambert.wang@mediatek.com>,
        Mingchuang Qiao <mingchuang.qiao@mediatek.com>,
        Xiayu Zhang <xiayu.zhang@mediatek.com>,
        Haozhe Chang <haozhe.chang@mediatek.com>,
        MediaTek Corporation <linuxwwan@mediatek.com>
Subject: [PATCH net-next v1 00/13] net: wwan: tmi: PCIe driver for MediaTek M.2 modem
Date:   Tue, 22 Nov 2022 19:11:39 +0800
Message-ID: <20221122111152.160377-1-yanchao.yang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: MediaTek Corporation <linuxwwan@mediatek.com>

TMI(T-series Modem Interface) is the PCIe host device driver for MediaTek's
modem. The driver uses the WWAN framework infrastructure to create the
following control ports and network interfaces for data transactions.
* /dev/wwan0at0 - Interface that supports AT commands.
* /dev/wwan0mbim0 - Interface conforming to the MBIM protocol.
* wwan0-X - Primary network interface for IP traffic.

The main blocks in the TMI driver are:
* HW layer - Abstracts the hardware bus operations for the device, and
   provides generic interfaces for the transaction layer to get the device's
   information and control the device's behavior. It includes:

   * PCIe - Implements probe, removal and interrupt handling.
   * MHCCIF (Modem Host Cross-Core Interface) - Provides interrupt channels
     for bidirectional event notification such as handshake, exception,
     power management and port enumeration.
   * RGU (Reset General Unit) - Receives reset notification from device.

* Transaction layer - Implements data transactions for the control plane
   and the data plane. It includes:

   * DPMAIF (Data Plane Modem AP Interface) - Controls the hardware that
     provides uplink and downlink queues for the data path. The data exchange
     takes place using circular buffers to share data buffer addresses and
     metadata to describe the packets.
   * CLDMA (Cross Layer DMA) - Manages the hardware used by the port layer
     to send control messages to the device using MediaTek's CCCI (Cross-Core
     Communication Interface) protocol.
   * TX Services - Dispatch packets from the port layer to the device.
   * RX Services - Dispatch packets to the port layer when receiving packets
     from the device.

* Port layer - Provides control plane and data plane interfaces to userspace.
   It includes:

   * Control Plane - Provides device node interfaces for controlling data
     transactions.
   * Data Plane - Provides network link interfaces wwanX (0, 1, 2...) for IP
     data transactions.

* Core logic - Contains the core logic to keep the device working.
   It includes:

   * FSM (Finite State Machine) - Monitors the state of the device, and
     notifies each module when the state changes.
   * PM (Power Management) - Reduces power consumption by putting the device
     into low power state.
   * Exception - Monitors exception events and tries to recover the device.

The compilation of the TMI driver is enabled by the CONFIG_MTK_TMI config
option which depends on CONFIG_WWAN.

List of contributors:
Min Dong <min.dong@mediatek.com>
Ting Wang <ting.wang@mediatek.com>
Hua Yang <hua.yang@mediatek.com>
Mingliang Xu <mingliang.xu@mediatek.com>
Felix Chen <felix.chen@mediatek.com>
Aiden Wang <aiden.wang@mediatek.com>
Guohao Zhang <guohao.zhang@mediatek.com>
Chris Feng <chris.feng@mediatek.com>
Michael Cai <michael.cai@mediatek.com>
Lambert Wang <lambert.wang@mediatek.com>
Mingchuang Qiao <mingchuang.qiao@mediatek.com>
Xiayu Zhang <xiayu.zhang@mediatek.com>
Haozhe Chang <haozhe.chang@mediatek.com>

MediaTek Corporation (13):
  net: wwan: tmi: Add PCIe core
  net: wwan: tmi: Add buffer management
  net: wwan: tmi: Add control plane transaction layer
  net: wwan: tmi: Add control DMA interface
  net: wwan: tmi: Add control port
  net: wwan: tmi: Add FSM thread
  net: wwan: tmi: Add AT & MBIM WWAN ports
  net: wwan: tmi: Introduce data plane hardware interface
  net: wwan: tmi: Add data plane transaction layer
  net: wwan: tmi: Introduce WWAN interface
  net: wwan: tmi: Add exception handling service
  net: wwan: tmi: Add power management support
  net: wwan: tmi: Add maintainers and documentation

 .../networking/device_drivers/wwan/index.rst  |    1 +
 .../networking/device_drivers/wwan/tmi.rst    |   48 +
 MAINTAINERS                                   |   11 +
 drivers/net/wwan/Kconfig                      |   11 +
 drivers/net/wwan/Makefile                     |    1 +
 drivers/net/wwan/mediatek/Makefile            |   25 +
 drivers/net/wwan/mediatek/mtk_bm.c            |  369 ++
 drivers/net/wwan/mediatek/mtk_bm.h            |   79 +
 drivers/net/wwan/mediatek/mtk_cldma.c         |  354 ++
 drivers/net/wwan/mediatek/mtk_cldma.h         |  162 +
 drivers/net/wwan/mediatek/mtk_common.h        |   30 +
 drivers/net/wwan/mediatek/mtk_ctrl_plane.c    |  508 ++
 drivers/net/wwan/mediatek/mtk_ctrl_plane.h    |  118 +
 drivers/net/wwan/mediatek/mtk_data_plane.h    |  124 +
 drivers/net/wwan/mediatek/mtk_dev.c           |  103 +
 drivers/net/wwan/mediatek/mtk_dev.h           |  713 +++
 drivers/net/wwan/mediatek/mtk_dpmaif.c        | 4237 +++++++++++++++++
 drivers/net/wwan/mediatek/mtk_dpmaif_drv.h    |  277 ++
 drivers/net/wwan/mediatek/mtk_ethtool.c       |  179 +
 drivers/net/wwan/mediatek/mtk_except.c        |  176 +
 drivers/net/wwan/mediatek/mtk_fsm.c           | 1321 +++++
 drivers/net/wwan/mediatek/mtk_fsm.h           |  178 +
 drivers/net/wwan/mediatek/mtk_pm.c            | 1004 ++++
 drivers/net/wwan/mediatek/mtk_port.c          | 1349 ++++++
 drivers/net/wwan/mediatek/mtk_port.h          |  305 ++
 drivers/net/wwan/mediatek/mtk_port_io.c       |  767 +++
 drivers/net/wwan/mediatek/mtk_port_io.h       |   86 +
 drivers/net/wwan/mediatek/mtk_wwan.c          |  665 +++
 .../wwan/mediatek/pcie/mtk_cldma_drv_t800.c   | 1049 ++++
 .../wwan/mediatek/pcie/mtk_cldma_drv_t800.h   |   24 +
 .../wwan/mediatek/pcie/mtk_dpmaif_drv_t800.c  | 2115 ++++++++
 .../wwan/mediatek/pcie/mtk_dpmaif_reg_t800.h  |  368 ++
 drivers/net/wwan/mediatek/pcie/mtk_pci.c      | 1356 ++++++
 drivers/net/wwan/mediatek/pcie/mtk_pci.h      |  150 +
 drivers/net/wwan/mediatek/pcie/mtk_reg.h      |   84 +
 35 files changed, 18347 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/wwan/tmi.rst
 create mode 100644 drivers/net/wwan/mediatek/Makefile
 create mode 100644 drivers/net/wwan/mediatek/mtk_bm.c
 create mode 100644 drivers/net/wwan/mediatek/mtk_bm.h
 create mode 100644 drivers/net/wwan/mediatek/mtk_cldma.c
 create mode 100644 drivers/net/wwan/mediatek/mtk_cldma.h
 create mode 100644 drivers/net/wwan/mediatek/mtk_common.h
 create mode 100644 drivers/net/wwan/mediatek/mtk_ctrl_plane.c
 create mode 100644 drivers/net/wwan/mediatek/mtk_ctrl_plane.h
 create mode 100644 drivers/net/wwan/mediatek/mtk_data_plane.h
 create mode 100644 drivers/net/wwan/mediatek/mtk_dev.c
 create mode 100644 drivers/net/wwan/mediatek/mtk_dev.h
 create mode 100644 drivers/net/wwan/mediatek/mtk_dpmaif.c
 create mode 100644 drivers/net/wwan/mediatek/mtk_dpmaif_drv.h
 create mode 100644 drivers/net/wwan/mediatek/mtk_ethtool.c
 create mode 100644 drivers/net/wwan/mediatek/mtk_except.c
 create mode 100644 drivers/net/wwan/mediatek/mtk_fsm.c
 create mode 100644 drivers/net/wwan/mediatek/mtk_fsm.h
 create mode 100644 drivers/net/wwan/mediatek/mtk_pm.c
 create mode 100644 drivers/net/wwan/mediatek/mtk_port.c
 create mode 100644 drivers/net/wwan/mediatek/mtk_port.h
 create mode 100644 drivers/net/wwan/mediatek/mtk_port_io.c
 create mode 100644 drivers/net/wwan/mediatek/mtk_port_io.h
 create mode 100644 drivers/net/wwan/mediatek/mtk_wwan.c
 create mode 100644 drivers/net/wwan/mediatek/pcie/mtk_cldma_drv_t800.c
 create mode 100644 drivers/net/wwan/mediatek/pcie/mtk_cldma_drv_t800.h
 create mode 100644 drivers/net/wwan/mediatek/pcie/mtk_dpmaif_drv_t800.c
 create mode 100644 drivers/net/wwan/mediatek/pcie/mtk_dpmaif_reg_t800.h
 create mode 100644 drivers/net/wwan/mediatek/pcie/mtk_pci.c
 create mode 100644 drivers/net/wwan/mediatek/pcie/mtk_pci.h
 create mode 100644 drivers/net/wwan/mediatek/pcie/mtk_reg.h

-- 
2.32.0

