Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5F64238C1
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 09:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237437AbhJFHX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 03:23:56 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:60888 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbhJFHXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 03:23:55 -0400
X-Greylist: delayed 5265 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Oct 2021 03:23:55 EDT
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 1965rpiU033140;
        Wed, 6 Oct 2021 00:53:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1633499631;
        bh=tfVY0tCk13Gm9LvbM/Nt6WS2pYI/2NBjcAkyeRss47k=;
        h=From:To:CC:Subject:Date;
        b=lmofctU12ck3ysEsXzf8eOtoiwzGLzPdxvDwwTzLkXAj6BuprYf4Xr8F0RRQkW2t1
         TMMnFe0pKk16glDuKW33J0JtDPecc2h5F6TJZJ3WW0vwN94uP2DG4HPjIK3mrrffpf
         QeVRh9TcShhDoqD+q1RUkiWhSP4SmCgSKpKGdWrQ=
Received: from DFLE105.ent.ti.com (dfle105.ent.ti.com [10.64.6.26])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 1965rpGN025917
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 6 Oct 2021 00:53:51 -0500
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Wed, 6
 Oct 2021 00:53:51 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Wed, 6 Oct 2021 00:53:51 -0500
Received: from gsaswath-HP-ProBook-640-G5.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 1965rjkC070213;
        Wed, 6 Oct 2021 00:53:46 -0500
From:   Aswath Govindraju <a-govindraju@ti.com>
CC:     Marc Kleine-Budde <mkl@pengutronix.de>,
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
Subject: [PATCH v4 0/6] CAN: Add support for CAN in AM65,J721e and AM64
Date:   Wed, 6 Oct 2021 11:23:37 +0530
Message-ID: <20211006055344.22662-1-a-govindraju@ti.com>
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

changes since v3 -
- Rebased the series on top of ti-k3-dts-next branch

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

