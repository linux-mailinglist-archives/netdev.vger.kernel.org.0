Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 965E22F857C
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 20:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388483AbhAOTaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 14:30:39 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:38086 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729507AbhAOTai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 14:30:38 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 10FJT0Rn067814;
        Fri, 15 Jan 2021 13:29:00 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1610738940;
        bh=hhYK5dJAuYydgh5h5MfqOpugS5cO5it8t71+CYUq8qU=;
        h=From:To:CC:Subject:Date;
        b=NlDBEkCqW8m1IoFgKJrRtBYbidXfl4PcImAB1J/S3i3XASLMFg8qhj9k28QXQ8YFD
         YtTVF6bwona31kdWBEjS1/yFaJJbfxfbFkLi/CSEl6zQ94Kk4s4XWslVTT1fQgGAjJ
         jJJyQzcEb1vUEu0VM1nXqDHhvf8KKCaU4Gy3ZSlM=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 10FJT0A6025390
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 15 Jan 2021 13:29:00 -0600
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 15
 Jan 2021 13:28:59 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 15 Jan 2021 13:28:59 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 10FJSwbu057633;
        Fri, 15 Jan 2021 13:28:59 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        <devicetree@vger.kernel.org>
Subject: [net-next 0/6] net: ethernet: ti: am65-cpsw-nuss: introduce support for am64x cpsw3g
Date:   Fri, 15 Jan 2021 21:28:47 +0200
Message-ID: <20210115192853.5469-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

This series introduces basic support for recently introduced TI K3 AM642x SoC [1]
which contains 3 port (2 external ports) CPSW3g module. The CPSW3g integrated
in MAIN domain and can be configured in multi port or switch modes.
In this series only multi port mode is enabled. The initial version of switchdev
support was introduced by Vignesh Raghavendra [2] and work is in progress.

The overall functionality and DT bindings are similar to other K3 CPSWxg
versions, so DT binding changes are minimal and driver is mostly re-used for
TI K3 AM642x CPSW3g.

The main difference is that TI K3 AM642x SoC is not fully DMA coherent and
instead DMA coherency is supported per DMA channel.

Patches 1-2 - DT bindings update 
Patches 3-4 - Update driver to support changed DMA coherency model
Patches 5-6 - adds TI K3 AM642x SoC platform data and so enable CPSW3g 

[1] https://www.ti.com/lit/pdf/spruim2
[2] https://patchwork.ozlabs.org/project/netdev/cover/20201130082046.16292-1-vigneshr@ti.com/

Grygorii Strashko (2):
  dt-binding: ti: am65x-cpts: add assigned-clock and power-domains props
  dt-binding: net: ti: k3-am654-cpsw-nuss: update bindings for am64x cpsw3g

Peter Ujfalusi (2):
  net: ethernet: ti: am65-cpsw-nuss: Use DMA device for DMA API
  net: ethernet: ti: am65-cpsw-nuss: Support for transparent ASEL
    handling

Vignesh Raghavendra (2):
  net: ti: cpsw_ale: add driver data for AM64 CPSW3g
  net: ethernet: ti: am65-cpsw: add support for am64x cpsw3g

 .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   | 50 ++++++----
 .../bindings/net/ti,k3-am654-cpts.yaml        |  7 ++
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      | 96 +++++++++++--------
 drivers/net/ethernet/ti/am65-cpsw-nuss.h      |  2 +
 drivers/net/ethernet/ti/cpsw_ale.c            |  7 ++
 5 files changed, 101 insertions(+), 61 deletions(-)

-- 
2.17.1

