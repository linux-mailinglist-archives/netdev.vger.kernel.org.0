Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 686D857B80E
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 16:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235617AbiGTOHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 10:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiGTOHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 10:07:32 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033104F644;
        Wed, 20 Jul 2022 07:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1658326052; x=1689862052;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=P5/XvRAo2ZpF0zvgkiHxtYBgWu4mOPmVqIQinK4TgqY=;
  b=TDxlV+kEP9Z19YTscN71uG6R+a2vhZi1/SMy8NZTakxi7PTnLQTB7bJs
   P7ikWWd0kDPdZPOIv2wWyZXEYDgiWjPyKuXhJachSm9m4eQ652xQrGqF1
   qnj4izpwyxWbzA22K4ZyZuFFZSqn/iKKYPAGi/lZrhxQpimZwyLy7gi2h
   E=;
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 20 Jul 2022 07:07:31 -0700
X-QCInternal: smtphost
Received: from unknown (HELO nasanex01a.na.qualcomm.com) ([10.52.223.231])
  by ironmsg05-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 07:07:31 -0700
Received: from zijuhu-gv.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 20 Jul 2022 07:07:28 -0700
From:   Zijun Hu <quic_zijuhu@quicinc.com>
To:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <luiz.von.dentz@intel.com>, <swyterzone@gmail.com>,
        <quic_zijuhu@quicinc.com>
CC:     <linux-kernel@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 0/3] Bluetooth: Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING 
Date:   Wed, 20 Jul 2022 22:07:22 +0800
Message-ID: <1658326045-9931-1-git-send-email-quic_zijuhu@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series remove quirk HCI_QUIRK_BROKEN_ERR_DATA_REPORTING
for bluetooth, in order to check if HCI commands
HCI_Read|Write_Default_Erroneous_Data_Reporting work fine, it make BT core
driver addtionally check feature bit "Erroneous Data Reporting" instead of
the quirk set by BT device driver.

Zijun Hu (3):
  Bluetooth: hci_sync: Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING
  Bluetooth: btusb: Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING for QCA
  Bluetooth: btusb: Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING for fake
    CSR

 drivers/bluetooth/btusb.c   |  2 --
 include/net/bluetooth/hci.h | 12 +-----------
 net/bluetooth/hci_sync.c    |  7 ++-----
 3 files changed, 3 insertions(+), 18 deletions(-)

-- 
2.7.4
