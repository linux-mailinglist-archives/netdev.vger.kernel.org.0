Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41651155537
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 11:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgBGKDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 05:03:25 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:13614 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726619AbgBGKDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 05:03:24 -0500
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 017A2B3F026967;
        Fri, 7 Feb 2020 11:03:08 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=STMicroelectronics;
 bh=NjTOiaa4cUlxqR69w7Qj6+ESOFEB3cboe5eQuOT7x5Y=;
 b=L/pwsQ1f70g/0lFaYNHvPp0EOFyeEifAVBAqIqrX3X2mb8sXhSCHlvJYSHpqo5sq1DCG
 BnUGaOFHpZHwa+RpGL457Asxa6frRHPBcX+2K2fu2pgWQcHmjTc/nK/QJVvgVDMHWudC
 cBBWEzsE03yAi5ArODaFTyiUcFQdsAJpYNVIySZQI8QC/zuEbMx1obBUaztLB2bfxx0m
 YrG6PvwslG/tIzJn0Xp1p/4GU4JQ2Q+Diy2c5ISVkjNWPbW43yvvm5odiOevo+7gR3tg
 XFfvTjxlJsgn3IYmG+T6A36Cy2/EcT5P3ycNrdqWv4dAH4GpAEqZoOcU/UTszYXeGXwL 6g== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2xyhkbrc0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Feb 2020 11:03:08 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id DFC8710002A;
        Fri,  7 Feb 2020 11:03:07 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag3node3.st.com [10.75.127.9])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id C7AF42A96FC;
        Fri,  7 Feb 2020 11:03:07 +0100 (CET)
Received: from localhost (10.75.127.48) by SFHDAG3NODE3.st.com (10.75.127.9)
 with Microsoft SMTP Server (TLS) id 15.0.1347.2; Fri, 7 Feb 2020 11:03:07
 +0100
From:   Benjamin Gaignard <benjamin.gaignard@st.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <sriram.dash@samsung.com>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@st.com>
Subject: [PATCH v4 0/2] Convert bosch,m_can to json-schema
Date:   Fri, 7 Feb 2020 11:03:04 +0100
Message-ID: <20200207100306.20997-1-benjamin.gaignard@st.com>
X-Mailer: git-send-email 2.15.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.48]
X-ClientProxiedBy: SFHDAG4NODE3.st.com (10.75.127.12) To SFHDAG3NODE3.st.com
 (10.75.127.9)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-07_01:2020-02-07,2020-02-06 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The goal of this series is to convert bosch,m_can bindings to json-schema.
First convert can-transceiver to yaml and then use it for bosch,m_can.yaml.

version 4:
- remove useless ref to can-transceiver.yaml

version 3:
- only declare max-bitrate property in can-transceiver.yaml
- move can-transceive node into bosch,m_can.yaml bindings

Benjamin Gaignard (2):
  dt-bindinsg: net: can: Convert can-transceiver to json-schema
  dt-bindings: net: can: Convert M_CAN to json-schema

 .../devicetree/bindings/net/can/bosch,m_can.yaml   | 144 +++++++++++++++++++++
 .../bindings/net/can/can-transceiver.txt           |  24 ----
 .../bindings/net/can/can-transceiver.yaml          |  18 +++
 .../devicetree/bindings/net/can/m_can.txt          |  75 -----------
 4 files changed, 162 insertions(+), 99 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/can/can-transceiver.txt
 create mode 100644 Documentation/devicetree/bindings/net/can/can-transceiver.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/can/m_can.txt

-- 
2.15.0

