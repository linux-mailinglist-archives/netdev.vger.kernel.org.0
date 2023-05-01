Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96ECC6F3AAD
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 00:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbjEAWrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 18:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232985AbjEAWq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 18:46:57 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A60D269E;
        Mon,  1 May 2023 15:46:56 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 341MkO1l097648;
        Mon, 1 May 2023 17:46:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1682981184;
        bh=qY/0qRa3aQKgIxqooRRhbfOQoOpi41u3zZ7KiGXu1jM=;
        h=From:To:CC:Subject:Date;
        b=F4nZcsuezxIq6Jzp33lDZ8d9M7XU2cPhoS5lyEXOpQZl4LBTHdVUIEbAlnRJTqhSl
         gtYqavDzY2G638UryUjIag4pPsz0cHL8XsI3xa7BqUmVRwu/CjJiEXFd57DgvuX1Xr
         AiYNi4FrFDpKT1ZwieVZF5unyqlK6x7auY2n/OcI=
Received: from DLEE106.ent.ti.com (dlee106.ent.ti.com [157.170.170.36])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 341MkOdX066896
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 1 May 2023 17:46:24 -0500
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Mon, 1
 May 2023 17:46:24 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Mon, 1 May 2023 17:46:24 -0500
Received: from a0498204.dal.design.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 341MkOhd002097;
        Mon, 1 May 2023 17:46:24 -0500
From:   Judith Mendez <jm@ti.com>
To:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Schuyler Patton <spatton@ti.com>, Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v4 0/4] Enable multiple MCAN on AM62x
Date:   Mon, 1 May 2023 17:46:20 -0500
Message-ID: <20230501224624.13866-1-jm@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On AM62x there is one MCAN in MAIN domain and two in MCU domain.
The MCANs in MCU domain were not enabled since there is no
hardware interrupt routed to A53 GIC interrupt controller.
Therefore A53 Linux cannot be interrupted by MCU MCANs.

This solution instantiates a hrtimer with 1 ms polling interval
for MCAN device when there is no hardware interrupt and there is
poll-interval property in DTB MCAN node. The hrtimer generates a
recurring software interrupt which allows to call the isr. The isr
will check if there is pending transaction by reading a register
and proceed normally if there is.

On AM62x, this series enables two MCU MCAN which will use the hrtimer
implementation. MCANs with hardware interrupt routed to A53 Linux
will continue to use the hardware interrupt as expected.

Timer polling method was tested on both classic CAN and CAN-FD
at 125 KBPS, 250 KBPS, 1 MBPS and 2.5 MBPS with 4 MBPS bitrate
switching.

Letency and CPU load benchmarks were tested on 3x MCAN on AM62x.
1 MBPS timer polling interval is the better timer polling interval
since it has comparable latency to hardware interrupt with the worse
case being 1ms + CAN frame propagation time and CPU load is not
substantial. Latency can be improved further with less than 1 ms
polling intervals, howerver it is at the cost of CPU usage since CPU
load increases at 0.5 ms.

Note that in terms of power, enabling MCU MCANs with timer-polling
implementation might have negative impact since we will have to wake
up every 1 ms whether there are CAN packets pending in the RX FIFO or
not. This might prevent the CPU from entering into deeper idle states
for extended periods of time.

This patch series depends on 'Enable CAN PHY transceiver driver':
Link: https://lore.kernel.org/lkml/775ec9ce-7668-429c-a977-6c8995968d6e@app.fastmail.com/T/

v2:
Link: https://lore.kernel.org/linux-can/20230424195402.516-1-jm@ti.com/T/#t

V1:
Link: https://lore.kernel.org/linux-can/19d8ae7f-7b74-a869-a818-93b74d106709@ti.com/T/#t

RFC:
Link: https://lore.kernel.org/linux-can/52a37e51-4143-9017-42ee-8d17c67028e3@ti.com/T/#t

Changes since v3:
- Wrong patch sent, resend correct patch series

Changes since v2:
- Change binding patch first
- Update binding poll-interval description
- Add oneOf to select either interrupts/interrupt-names or poll-interval
- Sort list of includes
- Create a define for 1 ms polling interval
- Change plarform_get_irq to optional to not print error msg
- Fix indentations, lengths of code lines, and added other style changes

Changes since v1:
- Add poll-interval property to bindings and MCAN DTB node
- Add functionality to check for 'poll-interval' property in MCAN node 
- Bindings: add an example using poll-interval
- Add 'polling' flag in driver to check if device is using polling method
- Check for both timer polling and hardware interrupt case, default to
hardware interrupt method
- Change ns_to_ktime() to ms_to_ktime()

Judith Mendez (4):
  dt-bindings: net: can: Add poll-interval for MCAN
  can: m_can: Add hrtimer to generate software interrupt
  arm64: dts: ti: Add AM62x MCAN MAIN domain transceiver overlay
  arm64: dts: ti: Enable MCU MCANs for AM62x

 .../bindings/net/can/bosch,m_can.yaml         | 36 +++++++++++-
 arch/arm64/boot/dts/ti/Makefile               |  2 +
 arch/arm64/boot/dts/ti/k3-am62-mcu.dtsi       | 24 ++++++++
 .../boot/dts/ti/k3-am625-sk-mcan-main.dtso    | 35 ++++++++++++
 .../boot/dts/ti/k3-am625-sk-mcan-mcu.dtso     | 57 +++++++++++++++++++
 drivers/net/can/m_can/m_can.c                 | 29 +++++++++-
 drivers/net/can/m_can/m_can.h                 |  4 ++
 drivers/net/can/m_can/m_can_platform.c        | 32 ++++++++++-
 8 files changed, 212 insertions(+), 7 deletions(-)
 create mode 100644 arch/arm64/boot/dts/ti/k3-am625-sk-mcan-main.dtso
 create mode 100644 arch/arm64/boot/dts/ti/k3-am625-sk-mcan-mcu.dtso


base-commit: 92e815cf07ed24ee1c51b122f24ffcf2964b4b13
-- 
2.17.1

