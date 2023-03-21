Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0DE96C3035
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 12:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbjCULUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 07:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjCULUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 07:20:42 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8EA2F7AC;
        Tue, 21 Mar 2023 04:20:23 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32LBK3ql127836;
        Tue, 21 Mar 2023 06:20:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1679397603;
        bh=nBzsrK9F0f/kSP64wqEA7pCc1XDfaG2toYVJJNk9SuI=;
        h=From:To:CC:Subject:Date;
        b=uRgn9ZomS8XS+g4sI+2kHGYnwdniso1bP4nCcpIB3RrCx4rH2TOiIH3tTqM9M5FD6
         ty3F6dp+XjcL/qtuPNzogEFaBiWAegy9JHT94Aa+gtBRwRWK7lMw6PpMKQigO6uKuI
         hEVq8qv891a8FO9HhenYXwdk7OCCIhiqgiqzZT8E=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32LBK3PQ008204
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 21 Mar 2023 06:20:03 -0500
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Tue, 21
 Mar 2023 06:20:02 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Tue, 21 Mar 2023 06:20:02 -0500
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32LBJxVm088542;
        Tue, 21 Mar 2023 06:20:00 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <pabeni@redhat.com>, <rogerq@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net-next 0/4] Add CPSWxG SGMII support for J7200 and J721E
Date:   Tue, 21 Mar 2023 16:49:54 +0530
Message-ID: <20230321111958.2800005-1-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This series adds support to configure the CPSW Ethernet Switch in SGMII
mode, using the am65-cpsw-nuss driver. SGMII mode is supported by the
CPSWxG instances on TI's J7200 and J721E SoCs. Thus, SGMII mode is added
in the list of extra_modes for the appropriate compatibles corresponding
to the aforementioned SoCs.

Additionally, the method of setting the supported interface via struct
"phylink_config" is simplified by converting the IF/ELSE statements to
SWITCH statements.

Regards,
Siddharth.

Siddharth Vadapalli (4):
  net: ethernet: ti: am65-cpsw: Simplify setting supported interface
  net: ethernet: ti: am65-cpsw: Add support for SGMII mode
  net: ethernet: ti: am65-cpsw: Enable SGMII mode for J7200
  net: ethernet: ti: am65-cpsw: Enable SGMII mode for J721E

 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 42 +++++++++++++++++++-----
 1 file changed, 33 insertions(+), 9 deletions(-)

-- 
2.25.1

