Return-Path: <netdev+bounces-6596-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B8177170EA
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 00:48:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 50F8E1C20DA2
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 22:48:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A51A531EFF;
	Tue, 30 May 2023 22:48:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951A6A927
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 22:48:49 +0000 (UTC)
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C5B93;
	Tue, 30 May 2023 15:48:47 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
	by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 34UMmL4G040747;
	Tue, 30 May 2023 17:48:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1685486901;
	bh=/rcFi88fFTflJh3lvZ6kawNLHnOf/3ME9U3laQEXsQM=;
	h=From:To:CC:Subject:Date;
	b=HqNW2uxy+ROUss3qO86+xe2+0cOtbhsVdgStraVz67ht+BnkYOLQEp4TqMaCn3Jcr
	 abgjAm85/HzEWeG/w6hJWpLJahfbRYbloavKqQVUgWKTKKArTYckDmocJyQc06MUL4
	 FEn+74jteqFGb9yv3/f76thnKe5BBWCEsDHojHes=
Received: from DFLE100.ent.ti.com (dfle100.ent.ti.com [10.64.6.21])
	by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 34UMmLVP028852
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 30 May 2023 17:48:21 -0500
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Tue, 30
 May 2023 17:48:20 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Tue, 30 May 2023 17:48:20 -0500
Received: from uda0498204.dhcp.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
	by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 34UMmKxV112899;
	Tue, 30 May 2023 17:48:20 -0500
From: Judith Mendez <jm@ti.com>
To: Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        <linux-can@vger.kernel.org>
CC: Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde
	<mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Schuyler Patton <spatton@ti.com>,
        Tero Kristo
	<kristo@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski
	<krzysztof.kozlowski+dt@linaro.org>,
        <devicetree@vger.kernel.org>,
        Oliver
 Hartkopp <socketcan@hartkopp.net>,
        Simon Horman <simon.horman@corigine.com>,
        Conor Dooley <conor+dt@linaro.org>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH v8 0/2] Enable multiple MCAN on AM62x
Date: Tue, 30 May 2023 17:48:18 -0500
Message-ID: <20230530224820.303619-1-jm@ti.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On AM62x there are two MCANs in MCU domain. The MCANs in MCU domain
were not enabled since there is no hardware interrupt routed to A53
GIC interrupt controller. Therefore A53 Linux cannot be interrupted
by MCU MCANs.

This solution instantiates a hrtimer with 1 ms polling interval
for MCAN device when there is no hardware interrupt property in
DTB MCAN node. The hrtimer generates a recurring software interrupt
which allows to call the isr. The isr will check if there is pending
transaction by reading a register and proceed normally if there is.
MCANs with hardware interrupt routed to A53 Linux will continue to
use the hardware interrupt as expected.

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

v7:
Link: https://lore.kernel.org/linux-can/20230523023749.4526-1-jm@ti.com/T/#t

v6:
Link: https://lore.kernel.org/linux-can/20230518193613.15185-1-jm@ti.com/T/#t

v5:
Link: https://lore.kernel.org/linux-can/20230510202952.27111-1-jm@ti.com/T/#t

v4:
Link: https://lore.kernel.org/linux-can/c3395692-7dbf-19b2-bd3f-31ba86fa4ac9@linaro.org/T/#t

v2:
Link: https://lore.kernel.org/linux-can/20230424195402.516-1-jm@ti.com/T/#t

V1:
Link: https://lore.kernel.org/linux-can/19d8ae7f-7b74-a869-a818-93b74d106709@ti.com/T/#t

RFC:
Link: https://lore.kernel.org/linux-can/52a37e51-4143-9017-42ee-8d17c67028e3@ti.com/T/#t

v7:
- Cancel hrtimer after interrupts in m_can_stop
- Move assignment of hrtimer_callback to m_can_class_register()
- Initialize irq = 0 if polling mode is used

v6:
- Clean up m_can_platform.c after removing poll-interval

v6:
- Move hrtimer stop/start function calls to m_can_open and m_can_close to
support power suspend/resume

v5:
- Remove poll-interval in bindings
- Change dev_dbg to dev_info if hardware int exists and polling
is enabled

v4:
- Wrong patches sent

v3:
- Update binding poll-interval description
- Add oneOf to select either interrupts/798d276b39e984345d52b933a900a71fa0815928
v2:
- Add poll-interval property to bindings and MCAN DTB node
- Add functionality to check for 'poll-interval' property in MCAN node 
- Bindings: add an example using poll-interval
- Add 'polling' flag in driver to check if device is using polling method
- Check for timer polling and hardware interrupt cases, default to
hardware interrupt method
- Change ns_to_ktime() to ms_to_ktime()

Judith Mendez (2):
  dt-bindings: net: can: Remove interrupt properties for MCAN
  can: m_can: Add hrtimer to generate software interrupt

 .../bindings/net/can/bosch,m_can.yaml         | 20 +++++++++--
 drivers/net/can/m_can/m_can.c                 | 34 +++++++++++++++++--
 drivers/net/can/m_can/m_can.h                 |  3 ++
 drivers/net/can/m_can/m_can_platform.c        | 24 +++++++++++--
 4 files changed, 74 insertions(+), 7 deletions(-)


base-commit: 798d276b39e984345d52b933a900a71fa0815928
-- 
2.34.1


