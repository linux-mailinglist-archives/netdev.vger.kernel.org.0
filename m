Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8EB941185F
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 17:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241561AbhITPj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 11:39:27 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:60066 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237313AbhITPjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 11:39:25 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 18KFbXDV047343;
        Mon, 20 Sep 2021 10:37:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1632152253;
        bh=m8/oyTnbOL/hoQNXxgC/ec52PrS/GRlMDgPzmOaD8mg=;
        h=From:To:CC:Subject:Date;
        b=NJeYQd1srPBz066/+cvmDF9qcxhqHM9cCt6Vup4db+8ndZdj7k2RVzSbIOngOKea1
         bn46E+8Xp/wiHFVhXCpId4BE2nNiczq/p8Oqtxionhl1vB2yMuyIdrZ/JihUy8oe2G
         dSUEnqdww0RAu3lv6qJn6z7ePHMNAr+di04+W/+0=
Received: from DFLE105.ent.ti.com (dfle105.ent.ti.com [10.64.6.26])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 18KFbW2N012097
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 20 Sep 2021 10:37:32 -0500
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 20
 Sep 2021 10:37:32 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Mon, 20 Sep 2021 10:37:32 -0500
Received: from gsaswath-HP-ProBook-640-G5.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 18KFbPJi104098;
        Mon, 20 Sep 2021 10:37:26 -0500
From:   Aswath Govindraju <a-govindraju@ti.com>
CC:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Nishanth Menon <nm@ti.com>, Tero Kristo <kristo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: [PATCH v3 0/6] CAN: Add support for CAN in AM65,J721e and AM64
Date:   Mon, 20 Sep 2021 21:07:17 +0530
Message-ID: <20210920153724.20203-1-a-govindraju@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following series of patches add support for CAN in SoC's AM65, J721e
and AM64.


The following series is dependent on,
https://patchwork.kernel.org/project/netdevbpf/patch/20210920123344.2320-1-a-govindraju@ti.com/

changes since v2 -
- correct the dtbs_check errors. clock names order and interrupts
  property added in the dt bindings
- added support for main mcan instances on common processor board
  for j721e
- rebased the series on top of latest linux-next head

changes since v1 -
- changed the message ram configuration to use the maximum value
  in each field, for better performance.

Aswath Govindraju (3):
  arm64: dts: ti: am654-base-board/am65-iot2050-common: Disable mcan
    nodes
  arm64: dts: ti: k3-am64-main: Add support for MCAN
  arm64: dts: ti: k3-am642-evm/sk: Add support for main domain mcan
    nodes in EVM and disable them on SK

Faiz Abbas (3):
  arm64: dts: ti: k3-am65-mcu: Add Support for MCAN
  arm64: dts: ti: k3-j721e: Add support for MCAN nodes
  arm64: dts: ti: k3-j721e-common-proc-board: Add support for mcu and
    main mcan nodes

 arch/arm64/boot/dts/ti/k3-am64-main.dtsi      |  28 +++
 arch/arm64/boot/dts/ti/k3-am642-evm.dts       |  40 ++++
 arch/arm64/boot/dts/ti/k3-am642-sk.dts        |   8 +
 .../boot/dts/ti/k3-am65-iot2050-common.dtsi   |   8 +
 arch/arm64/boot/dts/ti/k3-am65-mcu.dtsi       |  30 +++
 .../arm64/boot/dts/ti/k3-am654-base-board.dts |   8 +
 .../dts/ti/k3-j721e-common-proc-board.dts     | 155 ++++++++++++++
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi     | 196 ++++++++++++++++++
 .../boot/dts/ti/k3-j721e-mcu-wakeup.dtsi      |  28 +++
 9 files changed, 501 insertions(+)

-- 
2.17.1

