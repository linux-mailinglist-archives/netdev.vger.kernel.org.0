Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 421F4654F73
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 12:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236111AbiLWLKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 06:10:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiLWLKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 06:10:00 -0500
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2F62708;
        Fri, 23 Dec 2022 03:09:58 -0800 (PST)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 2BNB9XGD044123;
        Fri, 23 Dec 2022 05:09:33 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1671793773;
        bh=ubDG4WCRNYleiVwKG/9I8i06Y0Ga/hIKm87LALUcyqo=;
        h=From:To:CC:Subject:Date;
        b=A2we3eKJM1A4avcx47GykmudA6gb9Y1aWJ6Vg+HIIo+sSjbHQHTgOkN0QjdnzbrUc
         Tz3fVJaFcnjhpQlJYlolVUFJ9Y87E1PmNqdey8HlaK/7pdXXABBDI87jUbqFkYJHs9
         ugIZ2P/3Tg43jw15ugGqdd/xrD18YkvCcpdnSkxM=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 2BNB9XHU115576
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 23 Dec 2022 05:09:33 -0600
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Fri, 23
 Dec 2022 05:09:32 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Fri, 23 Dec 2022 05:09:32 -0600
Received: from lelv0854.itg.ti.com (lelv0854.itg.ti.com [10.181.64.140])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 2BNB9WfC058705;
        Fri, 23 Dec 2022 05:09:32 -0600
Received: from localhost (a0501179-pc.dhcp.ti.com [10.24.69.114])
        by lelv0854.itg.ti.com (8.14.7/8.14.7) with ESMTP id 2BNB9VOu001006;
        Fri, 23 Dec 2022 05:09:32 -0600
From:   MD Danish Anwar <danishanwar@ti.com>
To:     "Andrew F. Davis" <afd@ti.com>, Tero Kristo <t-kristo@ti.com>,
        Suman Anna <s-anna@ti.com>, Roger Quadros <rogerq@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        MD Danish Anwar <danishanwar@ti.com>,
        "Vignesh Raghavendra" <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, <andrew@lunn.ch>
CC:     <nm@ti.com>, <ssantosh@kernel.org>, <srk@ti.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v3 0/2] Introduce ICSSG based ethernet Driver
Date:   Fri, 23 Dec 2022 16:39:28 +0530
Message-ID: <20221223110930.1337536-1-danishanwar@ti.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Programmable Real-time Unit and Industrial Communication Subsystem
Gigabit (PRU_ICSSG) is a low-latency microcontroller subsystem in the TI
SoCs. This subsystem is provided for the use cases like the implementation of
custom peripheral interfaces, offloading of tasks from the other
processor cores of the SoC, etc.

The subsystem includes many accelerators for data processing like
multiplier and multiplier-accumulator. It also has peripherals like
UART, MII/RGMII, MDIO, etc. Every ICSSG core includes two 32-bit
load/store RISC CPU cores called PRUs.

The above features allow it to be used for implementing custom firmware
based peripherals like ethernet.

This series adds the YAML documentation and the driver with basic EMAC
support for TI AM654 Silicon Rev 2 SoC with the PRU_ICSSG Sub-system.
running dual-EMAC firmware.
This currently supports basic EMAC with 1Gbps and 100Mbps link. 10M and
half-duplex modes are not yet supported because they require the support
of an IEP, which will be added later.
Advanced features like switch-dev and timestamping will be added later.

This series depends on two patch series that are not yet merged, one in
the remoteproc tree and another in the soc tree. the first one is titled
Introduce PRU remoteproc consumer API and the second one is titled
Introduce PRU platform consumer API.
Both of these are required for this driver.

To explain this dependency and to get reviews, I had earlier posted all
three of these as an RFC[1], this can be seen for understanding the
dependencies.

The two series remoteproc[2] and soc[3] have been posted seperately to 
their respective trees.

This is the v3 of the patch series [v1]. This version of the patchset 
addresses the comments made on [v2] of the series. 

Changes from v1 to v2 :

*) Addressed Rob and Krzysztof's comments on patch 1 of this series.
   Fixed indentation. Removed description and pinctrl section from 
   ti,icssg-prueth.yaml file.
*) Addressed Krzysztof, Paolo, Randy, Andrew and Christophe's comments on 
   patch 2 of this seires.
*) Fixed blanklines in Kconfig and Makefile. Changed structures to const 
   as suggested by Krzysztof.
*) Fixed while loop logic in emac_tx_complete_packets() API as suggested 
   by Paolo. Previously in the loop's last iteration 'budget' was 0 and 
   napi_consume_skb would wrongly assume the caller is not in NAPI context. 
   Now, budget won't be zero in last iteration of loop. 
*) Removed inline functions addr_to_da1() and addr_to_da0() as asked by 
   Andrew.
*) Added dev_err_probe() instead of dev_err() as suggested by Christophe.
*) In ti,icssg-prueth.yaml file, in the patternProperties section of 
   ethernet-ports, kept the port name as "port" instead of "ethernet-port" 
   as all other drivers were using "port". Will change it if is compulsory 
   to use "ethernet-port".
 
It is a good idea to mention this in the change history. It is then
clear you have considered it, but decided against it.

[1] https://lore.kernel.org/all/20220406094358.7895-1-p-mohan@ti.com/
[2] https://patchwork.kernel.org/project/linux-remoteproc/cover/20220418104118.12878-1-p-mohan@ti.com/
[3] https://patchwork.kernel.org/project/linux-remoteproc/cover/20220418123004.9332-1-p-mohan@ti.com/

[v1] https://lore.kernel.org/all/20220506052433.28087-1-p-mohan@ti.com/
[v2] https://lore.kernel.org/all/20220531095108.21757-1-p-mohan@ti.com/

Thanks and Regards,
Md Danish Anwar

Puranjay Mohan (1):
  dt-bindings: net: Add ICSSG Ethernet Driver bindings

Roger Quadros (1):
  net: ti: icssg-prueth: Add ICSSG ethernet driver

 .../bindings/net/ti,icssg-prueth.yaml         |  174 ++
 drivers/net/ethernet/ti/Kconfig               |   13 +
 drivers/net/ethernet/ti/Makefile              |    2 +
 drivers/net/ethernet/ti/icssg_classifier.c    |  368 ++++
 drivers/net/ethernet/ti/icssg_config.c        |  440 ++++
 drivers/net/ethernet/ti/icssg_config.h        |  200 ++
 drivers/net/ethernet/ti/icssg_ethtool.c       |  320 +++
 drivers/net/ethernet/ti/icssg_mii_cfg.c       |  104 +
 drivers/net/ethernet/ti/icssg_mii_rt.h        |  151 ++
 drivers/net/ethernet/ti/icssg_prueth.c        | 1882 +++++++++++++++++
 drivers/net/ethernet/ti/icssg_prueth.h        |  246 +++
 drivers/net/ethernet/ti/icssg_switch_map.h    |  183 ++
 include/linux/pruss.h                         |    1 +
 13 files changed, 4084 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
 create mode 100644 drivers/net/ethernet/ti/icssg_classifier.c
 create mode 100644 drivers/net/ethernet/ti/icssg_config.c
 create mode 100644 drivers/net/ethernet/ti/icssg_config.h
 create mode 100644 drivers/net/ethernet/ti/icssg_ethtool.c
 create mode 100644 drivers/net/ethernet/ti/icssg_mii_cfg.c
 create mode 100644 drivers/net/ethernet/ti/icssg_mii_rt.h
 create mode 100644 drivers/net/ethernet/ti/icssg_prueth.c
 create mode 100644 drivers/net/ethernet/ti/icssg_prueth.h
 create mode 100644 drivers/net/ethernet/ti/icssg_switch_map.h

-- 
2.25.1

