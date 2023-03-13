Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8455E6B757D
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 12:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbjCMLMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 07:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbjCMLMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 07:12:05 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C005DEFE;
        Mon, 13 Mar 2023 04:11:37 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32DBBUnG050656;
        Mon, 13 Mar 2023 06:11:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1678705890;
        bh=CNVstWwtC3lglBu8gd0yBT2cxjD94sA0qocjzHdzcJc=;
        h=From:To:CC:Subject:Date;
        b=VPC6H4wnPHml2m38rkMZjt0yBzWsZRAWmq86TX93X5/eI0N06JRkdcMymD9y7rTKZ
         zPKQzIyWyJK83tKle5w2FQ5s/5KsJ+L19XzXMj7y067iPXOrdxceTpXGIeAbeOkFYH
         q7QUT42uaf7XmEpIawAuhHuOzKqHM2S+nEaqtx8s=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32DBBU0S123991
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 13 Mar 2023 06:11:30 -0500
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 13
 Mar 2023 06:11:30 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 13 Mar 2023 06:11:30 -0500
Received: from lelv0854.itg.ti.com (lelv0854.itg.ti.com [10.181.64.140])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32DBBUGK016768;
        Mon, 13 Mar 2023 06:11:30 -0500
Received: from localhost (a0501179-pc.dhcp.ti.com [10.24.69.114])
        by lelv0854.itg.ti.com (8.14.7/8.14.7) with ESMTP id 32DBBTim032256;
        Mon, 13 Mar 2023 06:11:29 -0500
From:   MD Danish Anwar <danishanwar@ti.com>
To:     "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        MD Danish Anwar <danishanwar@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Nishanth Menon <nm@ti.com>
CC:     <linux-remoteproc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <srk@ti.com>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH v4 0/5] Introduce PRU platform consumer API
Date:   Mon, 13 Mar 2023 16:41:22 +0530
Message-ID: <20230313111127.1229187-1-danishanwar@ti.com>
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

Hi All,
The Programmable Real-Time Unit and Industrial Communication Subsystem (PRU-ICSS
or simply PRUSS) on various TI SoCs consists of dual 32-bit RISC cores
(Programmable Real-Time Units, or PRUs) for program execution.

There are 3 foundation components for TI PRUSS subsystem: the PRUSS platform
driver, the PRUSS INTC driver and the PRUSS remoteproc driver. All of them have
already been merged and can be found under:
1) drivers/soc/ti/pruss.c
   Documentation/devicetree/bindings/soc/ti/ti,pruss.yaml
2) drivers/irqchip/irq-pruss-intc.c
   Documentation/devicetree/bindings/interrupt-controller/ti,pruss-intc.yaml
3) drivers/remoteproc/pru_rproc.c
   Documentation/devicetree/bindings/remoteproc/ti,pru-consumer.yaml

The programmable nature of the PRUs provide flexibility to implement custom
peripheral interfaces, fast real-time responses, or specialized data handling.
Example of a PRU consumer drivers will be: 
  - Software UART over PRUSS
  - PRU-ICSS Ethernet EMAC

In order to make usage of common PRU resources and allow the consumer drivers 
to configure the PRU hardware for specific usage the PRU API is introduced.

This is the v4 of the old patch series[1]. This doesn't have any functional 
changes, the old series has been rebased on linux-next (tag: next-20230306).

Changes from v3 [1] to v4:
*) Added my SoB tags in all patches as earlier SoB tags were missing in few
patches.
*) Added Roger's RB tags in 3 patches.
*) Addressed Roger's comment in patch 4/5 of this series. Added check for 
   invalid GPI mode in pruss_cfg_gpimode() API.
*) Removed patch [4] from this series as that patch is no longer required.
*) Made pruss_cfg_read() and pruss_cfg_update() APIs internal to pruss.c by
   removing EXPORT_SYMBOL_GPL and making them static. Now these APIs are 
   internal to pruss.c and PRUSS CFG space is not exposed.
*) Moved APIs pruss_cfg_gpimode(), pruss_cfg_miirt_enable(), 
   pruss_cfg_xfr_enable(), pruss_cfg_get_gpmux(), pruss_cfg_set_gpmux() to
   pruss.c file as they are using APIs pruss_cfg_read / update. 
   Defined these APIs in pruss.h file as other drivers use these APIs to 
   perform respective operations.

Changes from v2 to v3:
*) No functional changes, the old series has been rebased on linux-next (tag:
next-20230306).

This series depends on another series which is already merged in the remoteproc
tree[2] and is part of v6.3-rc1. This series and the remoteproc series form the
PRUSS consumer API which can be used by consumer drivers to utilize the PRUs.

One example of the consumer driver is the PRU-ICSSG ethernet driver [3],which 
depends on this series and the remoteproc series[2].

[1] https://lore.kernel.org/all/20230306110934.2736465-1-danishanwar@ti.com/
[2] https://lore.kernel.org/all/20230106121046.886863-1-danishanwar@ti.com/#t
[3] https://lore.kernel.org/all/20230210114957.2667963-1-danishanwar@ti.com/
[4] https://lore.kernel.org/all/20230306110934.2736465-6-danishanwar@ti.com/

Thanks and Regards,
Md Danish Anwar

Andrew F. Davis (1):
  soc: ti: pruss: Add pruss_{request,release}_mem_region() API

Suman Anna (2):
  soc: ti: pruss: Add pruss_cfg_read()/update() API
  soc: ti: pruss: Add helper functions to set GPI mode, MII_RT_event and
    XFR

Tero Kristo (2):
  soc: ti: pruss: Add pruss_get()/put() API
  soc: ti: pruss: Add helper functions to get/set PRUSS_CFG_GPMUX

 drivers/soc/ti/pruss.c           | 278 +++++++++++++++++++++++++++++++
 include/linux/pruss_driver.h     |  28 +---
 include/linux/remoteproc/pruss.h | 179 ++++++++++++++++++++
 3 files changed, 463 insertions(+), 22 deletions(-)

-- 
2.25.1

