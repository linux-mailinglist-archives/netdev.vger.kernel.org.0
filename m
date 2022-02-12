Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31B204B3618
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 16:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbiBLPx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 10:53:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbiBLPx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 10:53:28 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B7DB9
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 07:53:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1644681204; x=1676217204;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TFZ3I34kWH8PTDEslI1lWiQzhMZ1ypVTz7JPieb6+rQ=;
  b=aDMgGFLR0EVzQlBxW4gNQreRAxcF7GzGNqwvvHP/J7ZYL1Ju+EvTwx/Y
   aN3wvSjQ7y+X85Z7GaV72i6Ps3lbd6lmEz1APEP3Ax+8qLWaQ1wiYJHec
   MBSRV+/0IufL2zgOB4QV++LIbtWDY2xEf8zv1am0qMTmfLnSEnFkfWpKp
   OVUxKzb3K0n7JZfvtKXJvmCYdnRqSC0sU/Ng1gvdaMAimwlXSMqEgKVvO
   U0AB2PJNY68ClyKwQC1oilqtPYSBxTZ316Dhxhd5LqBsmheHcwY8jXmF3
   eCL2g01RMxrkZHCicDg8ltvfg2VnOjFf+7O45vx2OxCTSv/+zE1gRn+hi
   g==;
IronPort-SDR: PVnjkcx5Pm3VgAZhI0g1csBVWnXCJi2ANVoAMafh1W1CT7AhCepfDizyUoufMEoEgV6KwncCuR
 AaWM1Tvee67vy6MF083ZLi+FjmpfRVXVE/7a59MkszE/hhA7YeqzSyM0+Irl/k3bzG95iD1+CK
 F2q2Hua9HIl9AhZjYh/j1DcZg4ndXPZFs37UeCqtBtLrP8+jIdxEWDBwDwfPyr/QbaaN/8CnUe
 Z6/oPw/aa48WwiMTOBL+u9AZrdSI11ViXzb+c0h/3CA/v6Ru8wLNCIKV51O5a6Kz1oYfNTL6G/
 EUmdfhAQGptBRka/vDRJMyeM
X-IronPort-AV: E=Sophos;i="5.88,363,1635231600"; 
   d="scan'208";a="85510908"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Feb 2022 08:53:23 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sat, 12 Feb 2022 08:53:23 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sat, 12 Feb 2022 08:53:20 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>, <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next V1 0/5] net: lan743x: PCI11010 / PCI11414 devices Enhancements
Date:   Sat, 12 Feb 2022 21:23:10 +0530
Message-ID: <20220212155315.340359-1-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support of the Ethernet function of the PCI11010 / PCI11414 devices to the LAN743x driver.
The PCI1xxxx family of devices consists of a PCIe switch with a variety of embedded PCI endpoints on its downstream ports.
The PCI11010 / PCI11414 devices include an Ethernet 10/100/1000/2500 function as one of those embedded endpoints.

Raju Lakkaraju (5):
  net: lan743x: Add PCI11010 / PCI11414 device IDs
  net: lan743x: Add support for 4 Tx queues
  net: lan743x: Increase MSI(x) vectors to 16 and Int de-assertion
    timers to 10
  net: lan743x: Add support for SGMII interface
  net: lan743x: Add support for Clause-45 MDIO PHY management

 drivers/net/ethernet/microchip/lan743x_main.c | 274 ++++++++++++++++--
 drivers/net/ethernet/microchip/lan743x_main.h |  62 +++-
 drivers/net/ethernet/microchip/lan743x_ptp.c  |   8 +-
 3 files changed, 305 insertions(+), 39 deletions(-)

-- 
2.25.1

