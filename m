Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45BEF691EA0
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 12:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbjBJLui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 06:50:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbjBJLuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 06:50:37 -0500
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C8D1E9EC;
        Fri, 10 Feb 2023 03:50:33 -0800 (PST)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 31ABo0OC050399;
        Fri, 10 Feb 2023 05:50:00 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1676029800;
        bh=T/cjSwmu9bcn7lPUk5d/HKN2jJ6Gpt3KPUuakRV6kRE=;
        h=From:To:CC:Subject:Date;
        b=no7eO7C9fbB+Dl6RxR6IH3JdcNlQAwPFnDw3dUp67AqTP+JpK7huw8cg1ud5P5Enz
         8SyJjvD9mgvtg/+Mw/U/ZEwIN4JD5KzWsoE7qRZAL046VaCExImSr6RP++Por774Uw
         QUkHsSNCOnVSrJEUgGby/b1kA5QWHqvDpeDJTmFA=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 31ABo0MQ121766
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 10 Feb 2023 05:50:00 -0600
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Fri, 10
 Feb 2023 05:50:00 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Fri, 10 Feb 2023 05:50:00 -0600
Received: from lelv0854.itg.ti.com (lelv0854.itg.ti.com [10.181.64.140])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 31ABo0Ld002539;
        Fri, 10 Feb 2023 05:50:00 -0600
Received: from localhost (a0501179-pc.dhcp.ti.com [10.24.69.114])
        by lelv0854.itg.ti.com (8.14.7/8.14.7) with ESMTP id 31ABnxWm016847;
        Fri, 10 Feb 2023 05:49:59 -0600
From:   MD Danish Anwar <danishanwar@ti.com>
To:     "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        MD Danish Anwar <danishanwar@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, <andrew@lunn.ch>
CC:     <nm@ti.com>, <ssantosh@kernel.org>, <srk@ti.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v5 0/2] Introduce ICSSG based ethernet Driver
Date:   Fri, 10 Feb 2023 17:19:55 +0530
Message-ID: <20230210114957.2667963-1-danishanwar@ti.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Programmable Real-time Unit and Industrial Communication Subsystem
Gigabit (PRU_ICSSG) is a low-latency microcontroller subsystem in the TI
SoCs. This subsystem is provided for the use cases like the implementation
of custom peripheral interfaces, offloading of tasks from the other
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

The two series remoteproc[2] and soc[3] have been posted separately to 
their respective trees.

This is the v5 of the patch series [v1]. This version of the patchset 
addresses the comments made on [v4] of the series. 

Changes from v4 to v5 :
*) Re-arranged properties section in ti,icssg-prueth.yaml file.
*) Added requirement for minimum one ethernet port.
*) Fixed some minor formatting errors as asked by Krzysztof.
*) Dropped SGMII mode from enum mii_mode as SGMII mode is not currently
   supported by the driver.
*) Added switch-case block to handle different phy modes by ICSSG driver.

Changes from v3 to v4 :
*) Addressed Krzysztof's comments and fixed dt_binding_check errors in 
   patch 1/2.
*) Added interrupt-extended property in ethernet-ports properties section.
*) Fixed comments in file icssg_switch_map.h according to the Linux coding
   style in patch 2/2. Added Documentation of structures in patch 2/2.

Changes from v2 to v3 :
*) Addressed Rob and Krzysztof's comments on patch 1 of this series.
   Fixed indentation. Removed description and pinctrl section from 
   ti,icssg-prueth.yaml file.
*) Addressed Krzysztof, Paolo, Randy, Andrew and Christophe's comments on 
   patch 2 of this seires.
*) Fixed blanklines in Kconfig and Makefile. Changed structures to const 
   as suggested by Krzysztof.
*) Fixed while loop logic in emac_tx_complete_packets() API as suggested 
   by Paolo. Previously in the loop's last iteration 'budget' was 0 and 
   napi_consume_skb would wrongly assume the caller is not in NAPI context
   Now, budget won't be zero in last iteration of loop. 
*) Removed inline functions addr_to_da1() and addr_to_da0() as asked by 
   Andrew.
*) Added dev_err_probe() instead of dev_err() as suggested by Christophe.
*) In ti,icssg-prueth.yaml file, in the patternProperties section of 
   ethernet-ports, kept the port name as "port" instead of "ethernet-port" 
   as all other drivers were using "port". Will change it if is compulsory 
   to use "ethernet-port".

[1] https://lore.kernel.org/all/20220406094358.7895-1-p-mohan@ti.com/
[2] https://patchwork.kernel.org/project/linux-remoteproc/cover/20220418104118.12878-1-p-mohan@ti.com/
[3] https://patchwork.kernel.org/project/linux-remoteproc/cover/20220418123004.9332-1-p-mohan@ti.com/

[v1] https://lore.kernel.org/all/20220506052433.28087-1-p-mohan@ti.com/
[v2] https://lore.kernel.org/all/20220531095108.21757-1-p-mohan@ti.com/
[v3] https://lore.kernel.org/all/20221223110930.1337536-1-danishanwar@ti.com/
[v4] https://lore.kernel.org/all/20230206060708.3574472-1-danishanwar@ti.com/

Thanks and Regards,
Md Danish Anwar

Puranjay Mohan (1):
  dt-bindings: net: Add ICSSG Ethernet

Roger Quadros (1):
  net: ti: icssg-prueth: Add ICSSG ethernet driver

 .../bindings/net/ti,icssg-prueth.yaml         |  184 ++
 drivers/net/ethernet/ti/Kconfig               |   13 +
 drivers/net/ethernet/ti/Makefile              |    2 +
 drivers/net/ethernet/ti/icssg_classifier.c    |  369 ++++
 drivers/net/ethernet/ti/icssg_config.c        |  449 ++++
 drivers/net/ethernet/ti/icssg_config.h        |  200 ++
 drivers/net/ethernet/ti/icssg_ethtool.c       |  326 +++
 drivers/net/ethernet/ti/icssg_mii_cfg.c       |  104 +
 drivers/net/ethernet/ti/icssg_mii_rt.h        |  150 ++
 drivers/net/ethernet/ti/icssg_prueth.c        | 1863 +++++++++++++++++
 drivers/net/ethernet/ti/icssg_prueth.h        |  246 +++
 drivers/net/ethernet/ti/icssg_switch_map.h    |  234 +++
 include/linux/remoteproc/pruss.h              |    1 +
 13 files changed, 4141 insertions(+)
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

