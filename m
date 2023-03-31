Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B2E6D1EF2
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 13:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbjCaL34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 07:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjCaL3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 07:29:55 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B82E1D847;
        Fri, 31 Mar 2023 04:29:54 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32VBThDr036476;
        Fri, 31 Mar 2023 06:29:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1680262183;
        bh=AWxRcTapgEXEsS1tZkD66ZRxOvSctPgIGCDYmV2iX+E=;
        h=From:To:CC:Subject:Date;
        b=ZnMwgTTLzf7YRCSGa1/y7zw5qudotrAv/oio7R/6BCCbJHjSNajh6Ookp1qu75DaX
         m8UAXXTOg8+gkBIU5BvTK5Qdpd4gD3JtupQoA6aOUc/anjuUUnYb4+syzik2SCJyph
         jZT9StZxPJ1EKNb+HOx5o5i0ft6qIlmOOYO6zVsc=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32VBThdB122292
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 31 Mar 2023 06:29:43 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Fri, 31
 Mar 2023 06:29:43 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Fri, 31 Mar 2023 06:29:43 -0500
Received: from fllv0122.itg.ti.com (fllv0122.itg.ti.com [10.247.120.72])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32VBThFG118290;
        Fri, 31 Mar 2023 06:29:43 -0500
Received: from localhost (a0501179-pc.dhcp.ti.com [10.24.69.114])
        by fllv0122.itg.ti.com (8.14.7/8.14.7) with ESMTP id 32VBTfbN014969;
        Fri, 31 Mar 2023 06:29:42 -0500
From:   MD Danish Anwar <danishanwar@ti.com>
To:     "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
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
Subject: [PATCH v6 0/4] Introduce PRU platform consumer API
Date:   Fri, 31 Mar 2023 16:59:37 +0530
Message-ID: <20230331112941.823410-1-danishanwar@ti.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
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

This is the v6 of the old patch series [1].

Changes from v5 [1] to v6:
*) Added Reviewed by tags of Roger and Tony to the patches.
*) Added Acked by tag of Mathieu to patch 2 of this series.
*) Added NULL check for @mux in pruss_cfg_get_gpmux() API.
*) Added comment to the pruss_get() function documentation mentioning it is
expected the caller will have done a pru_rproc_get() on @rproc.
*) Fixed compilation warning "warning: ‘pruss_cfg_update’ defined but not used"
in patch 3 by squashing patch 3 [7] and patch 5 [8] of previous revision
together. Squashed patch 5 instead of patch 4 with patch 3 because patch 5 uses
both read() and update() APIs where as patch 4 only uses update() API.
Previously pruss_cfg_read()/update() APIs were intoroduced in patch 3
and used in patch 4 and 5. Now these APIs are introduced as well as used in 
patch 3.

Changes from v4 [2] to v5:
*) Addressed Roger's comment to change function argument in API 
pruss_cfg_xfr_enable(). Instead of asking user to calcualte mask, now user
will just provide the pru_type and mask will be calcualted inside the API.
*) Moved enum pru_type from pru_rproc.c to include/linux/remoteproc/pruss.h
in patch 4 / 5.
*) Moved enum pruss_gpi_mode from patch 3/5 to patch 4/5 to introduce this
enum in same patch as the API using it.
*) Moved enum pruss_gp_mux_sel from patch 3/5 to patch 5/5 to introduce this
enum in same patch as the API using it.
*) Created new headefile drivers/soc/ti/pruss.h, private to PRUSS as asked by
Roger. Moved all private definitions and pruss_cfg_read () / update ()
APIs to this newly added headerfile.
*) Renamed include/linux/pruss_driver.h to include/linux/pruss_internal.h as
suggested by Andrew and Roger.

Changes from v3 [3] to v4:
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
tree [5] and is part of v6.3-rc1. This series and the remoteproc series form 
the PRUSS consumer API which can be used by consumer drivers to utilize the 
PRUs.

One example of the consumer driver is the PRU-ICSSG ethernet driver [6],which 
depends on this series and the remoteproc series [5].

[1] https://lore.kernel.org/all/20230323062451.2925996-1-danishanwar@ti.com/
[2] https://lore.kernel.org/all/20230313111127.1229187-1-danishanwar@ti.com/
[3] https://lore.kernel.org/all/20230306110934.2736465-1-danishanwar@ti.com/
[4] https://lore.kernel.org/all/20230306110934.2736465-6-danishanwar@ti.com/
[5] https://lore.kernel.org/all/20230106121046.886863-1-danishanwar@ti.com/#t
[6] https://lore.kernel.org/all/20230210114957.2667963-1-danishanwar@ti.com/
[7] https://lore.kernel.org/all/20230323062451.2925996-4-danishanwar@ti.com/
[8] https://lore.kernel.org/all/20230323062451.2925996-6-danishanwar@ti.com/

Thanks and Regards,
Md Danish Anwar

Andrew F. Davis (1):
  soc: ti: pruss: Add pruss_{request,release}_mem_region() API

Suman Anna (2):
  soc: ti: pruss: Add pruss_cfg_read()/update(),
    pruss_cfg_get_gpmux()/set_gpmux() APIs
  soc: ti: pruss: Add helper functions to set GPI mode, MII_RT_event and
    XFR

Tero Kristo (1):
  soc: ti: pruss: Add pruss_get()/put() API

 drivers/remoteproc/pru_rproc.c                |  17 +-
 drivers/soc/ti/pruss.c                        | 260 +++++++++++++++++-
 drivers/soc/ti/pruss.h                        | 112 ++++++++
 .../{pruss_driver.h => pruss_internal.h}      |  34 +--
 include/linux/remoteproc/pruss.h              | 141 ++++++++++
 5 files changed, 522 insertions(+), 42 deletions(-)
 create mode 100644 drivers/soc/ti/pruss.h
 rename include/linux/{pruss_driver.h => pruss_internal.h} (58%)

-- 
2.25.1

