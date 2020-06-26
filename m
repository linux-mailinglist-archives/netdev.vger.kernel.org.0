Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25CE20B7FB
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 20:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgFZSRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 14:17:25 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:53208 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgFZSRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 14:17:22 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 05QIHBPD006447;
        Fri, 26 Jun 2020 13:17:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1593195431;
        bh=lT8XdTWCW5WowpSaiKVh9sxbAgiTlm+/tGMLH5F0svM=;
        h=From:To:CC:Subject:Date;
        b=SsA05MuHZ3KKsgm4/W0yYPEIfODLtCv303VbLm/usb6/29hwW15xJ40/RpBkRHVsK
         8x/9R8l6+Agbc6+KNZDCodnUlsfH2UFCkMeL4F33woz1zAtWKjtIG/lsUY41iytG+3
         vp0B2gr6/qeh+C1lQgebvcPD9zyLr+7Eu3q7APP8=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05QIHBXN004067;
        Fri, 26 Jun 2020 13:17:11 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 26
 Jun 2020 13:17:10 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 26 Jun 2020 13:17:10 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05QIH9xa111521;
        Fri, 26 Jun 2020 13:17:10 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 0/6] net: ethernet: ti: am65-cpsw: update and enable sr2.0 soc
Date:   Fri, 26 Jun 2020 21:17:03 +0300
Message-ID: <20200626181709.22635-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

This series contains set of improvements for TI AM654x/J721E CPSW2G driver and
adds support for TI AM654x SR2.0 SoC.

Patch 1: adds vlans restoration after "if down/up"
Patches 2-5: improvments
Patch 6: adds support for TI AM654x SR2.0 SoC which allows to disable errata i2027 W/A.
By default, errata i2027 W/A (TX csum offload disabled) is enabled on AM654x SoC
for backward compatibility, unless SR2.0 SoC is identified using SOC BUS framework.

Grygorii Strashko (6):
  net: ethernet: ti: am65-cpsw-nuss: restore vlan configuration while
    down/up
  net: ethernet: ti: am65-cpsw: move to pf_p0_rx_ptype_rrobin init in
    probe
  net: ethernet: ti: am65-cpsw-nuss: fix ports mac sl initialization
  net: ethernet: ti: am65-cpsw-ethtool: skip hw cfg when change
    p0-rx-ptype-rrobin
  net: ethernet: ti: am65-cpsw-ethtool: configured critical setting only
    when no running netdevs
  net: ethernet: ti: am65-cpsw-nuss: enable am65x sr2.0 support

 drivers/net/ethernet/ti/am65-cpsw-ethtool.c |  6 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c    | 77 +++++++++++++++++----
 drivers/net/ethernet/ti/am65-cpsw-nuss.h    |  2 +-
 3 files changed, 69 insertions(+), 16 deletions(-)

-- 
2.17.1

