Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6EF9B8A8F
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 07:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390510AbfITFjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 01:39:04 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:55520 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2391495AbfITFjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 01:39:03 -0400
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8K5aNoE011702;
        Fri, 20 Sep 2019 07:38:45 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=STMicroelectronics;
 bh=2+X7n8kYh+eyI478R9QoZl24SqMf0i4AANekeGpV2V0=;
 b=ySI1gz8EsDId0kzQY4W84DAFuq9V69QawSnxRh7fEx4kGIWW4Azmc8XZC9s9UiwQhRst
 DxZ4FJM21Az8yZ89nwklS4vWWrjewf30GZZ8YT893+zZCovqcurAuW6UzVD+7OpQrv4H
 LqTYbVBrfHPpnomVy5TCanJh7xxf//Mj0h3n7QUH8iwkg896kZTpaYTe/H27JBtIGKbd
 sXcm7ByrUoy2UFpFkkXaJ1NhWP5LFMCMwI7XUpLJzBcpYd4n8uEpregIrnZJatHii2OA
 5jUSMfk0lzz12y0FW38zcl4SLOAytkUYGiEXD5Upna3u+ZZUoElBbZHiZQaHqYnEQTLQ sA== 
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
        by mx08-00178001.pphosted.com with ESMTP id 2v3vcbrpu1-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Fri, 20 Sep 2019 07:38:45 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 0791C50;
        Fri, 20 Sep 2019 05:38:35 +0000 (GMT)
Received: from Webmail-eu.st.com (Safex1hubcas21.st.com [10.75.90.44])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id C31752209C6;
        Fri, 20 Sep 2019 07:38:34 +0200 (CEST)
Received: from SAFEX1HUBCAS24.st.com (10.75.90.95) by SAFEX1HUBCAS21.st.com
 (10.75.90.44) with Microsoft SMTP Server (TLS) id 14.3.439.0; Fri, 20 Sep
 2019 07:38:34 +0200
Received: from localhost (10.201.22.222) by webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.439.0; Fri, 20 Sep 2019 07:38:34
 +0200
From:   Christophe Roullier <christophe.roullier@st.com>
To:     <robh@kernel.org>, <davem@davemloft.net>, <joabreu@synopsys.com>,
        <mark.rutland@arm.com>, <mcoquelin.stm32@gmail.com>,
        <alexandre.torgue@st.com>, <peppe.cavallaro@st.com>
CC:     <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <christophe.roullier@st.com>, <andrew@lunn.ch>
Subject: [PATCH  0/5] net: ethernet: stmmac: some fixes and optimization
Date:   Fri, 20 Sep 2019 07:38:12 +0200
Message-ID: <20190920053817.13754-1-christophe.roullier@st.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.201.22.222]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-20_01:2019-09-19,2019-09-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some improvements (manage syscfg as optional clock, update slew rate of
ETH_MDIO pin, Enable gating of the MAC TX clock during TX low-power mode)
Fix warning build message when W=1

Christophe Roullier (5):
  net: ethernet: stmmac: Add support for syscfg clock
  net: ethernet: stmmac: fix warning when w=1 option is used during
    build
  ARM: dts: stm32: remove syscfg clock on stm32mp157c ethernet
  ARM: dts: stm32: adjust slew rate for Ethernet
  ARM: dts: stm32: Enable gating of the MAC TX clock during TX low-power
    mode on stm32mp157c

 arch/arm/boot/dts/stm32mp157-pinctrl.dtsi     |  9 +++-
 arch/arm/boot/dts/stm32mp157c.dtsi            |  7 ++--
 .../net/ethernet/stmicro/stmmac/dwmac-stm32.c | 42 ++++++++++++-------
 3 files changed, 38 insertions(+), 20 deletions(-)

-- 
2.17.1

