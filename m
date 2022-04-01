Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2CE4EEA8B
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 11:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344642AbiDAJio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 05:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232259AbiDAJio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 05:38:44 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E19F70076;
        Fri,  1 Apr 2022 02:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1648805815; x=1680341815;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7IcK1ewceqJbfJh1/6ckW5d6xLhG1vLKCZUrKmmrJkc=;
  b=O8AGwhiwnCpokK11H27iH/VnUVmAzW5rrFZ3rVvv0+FYs91N16fUIoea
   L5bDlVuiVxGjm7fORgOINI4ybx5XquJoTmwYeklfVcZ2iXkQ1IhTGyd9P
   AKH2Fmdv3iB1xQeAXK+iHg7CvLzoxMywlofBLKHTtOKiTAmOV199P1dpf
   4ls9ZVxdh/fj958IjvZZt3MTfD5K9YDBUQxlQp+7UvA0vwFiNAZNdENHx
   /JYnpeI+yjmraYAv39pUrgfuUNPK2doIkB9AWB6p5TiCjK1TWGr6FlYc2
   RQOVBFatVrLTtyqlyxXF1oXIOOvgPaDCdCu2C/WmpiqJVJ6JmZI1t40n7
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,226,1643698800"; 
   d="scan'208";a="158510679"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Apr 2022 02:36:54 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 1 Apr 2022 02:36:53 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 1 Apr 2022 02:36:51 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <richardcochran@gmail.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC PATCH net-next 0/2] ethtool: Extend to set PHY latencies
Date:   Fri, 1 Apr 2022 11:39:07 +0200
Message-ID: <20220401093909.3341836-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because there will always be a strugged to configure correct latencies, then
don't allow the kernel or the DT to have these values but allow the userspace
to configure them.
Therefore extend ethtool to allow to configure the latencies both per speed
and direction.

Horatiu Vultur (2):
  ethtool: Extend to allow to set PHY latencies
  net: phy: micrel: Implement set/get_tunable

 drivers/net/phy/micrel.c     | 93 ++++++++++++++++++++++++++++++++++++
 include/uapi/linux/ethtool.h |  6 +++
 net/ethtool/common.c         |  6 +++
 net/ethtool/ioctl.c          | 10 ++++
 4 files changed, 115 insertions(+)

-- 
2.33.0

