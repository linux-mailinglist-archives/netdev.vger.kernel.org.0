Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9A8415550E
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 10:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgBGJvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 04:51:40 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:17318 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726642AbgBGJvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 04:51:40 -0500
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0179nHNB028269;
        Fri, 7 Feb 2020 10:51:23 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=STMicroelectronics;
 bh=dHZ2FJ2DFL4RXGjV3EA6uxkJ+2ASzyuNblcjD5tUGrQ=;
 b=Cz9YJh+3Gb3RzMgPRo5yvoRnBG113OmZknn++zuV7TEjEB9f3DYCv4I+bbOZ4RqC1dor
 cZ2HgYZ37OqhcNwgfkh5Lb5KLEsOgynDCN2IG/M/EFIoNwFzG6D5Ct96qrbrN8OMW7Tm
 6H+62+JqauWEefIMBaWTrd2zxBWnSUSh8Nkcm8TUsDBKJ7lTInr7KO77vPhmX3UJEqOB
 y9un2DKQKwrxSD4YgptHtV0k0SHhUyVqUCbW1WUHbwmR+TGe4nzOBofDHJK8cBiuYFU6
 fO34N5VkrOikvjn+Zc3lnRCqIdCK0qz+2PNz9sludGAYH+LtP2bibqLNdGsBEllApCwj KA== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2xyhku9upv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Feb 2020 10:51:23 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 9D570100038;
        Fri,  7 Feb 2020 10:51:17 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag3node3.st.com [10.75.127.9])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 8221C221629;
        Fri,  7 Feb 2020 10:51:17 +0100 (CET)
Received: from localhost (10.75.127.51) by SFHDAG3NODE3.st.com (10.75.127.9)
 with Microsoft SMTP Server (TLS) id 15.0.1347.2; Fri, 7 Feb 2020 10:51:17
 +0100
From:   Benjamin Gaignard <benjamin.gaignard@st.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <sriram.dash@samsung.com>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@st.com>
Subject: [PATCH v3 0/2] Convert bosch,m_can to json-schema
Date:   Fri, 7 Feb 2020 10:51:11 +0100
Message-ID: <20200207095113.14489-1-benjamin.gaignard@st.com>
X-Mailer: git-send-email 2.15.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.51]
X-ClientProxiedBy: SFHDAG1NODE2.st.com (10.75.127.2) To SFHDAG3NODE3.st.com
 (10.75.127.9)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-07_01:2020-02-07,2020-02-06 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The goal of this series is to convert bosch,m_can bindings to json-schema.
First convert can-transceiver to yaml and then use it for bosch,m_can.yaml.

version 3:
- only declare max-bitrate property in can-transceiver.yaml
- move can-transceive node into bosch,m_can.yaml bindings

Benjamin Gaignard (2):
  dt-bindinsg: net: can: Convert can-transceiver to json-schema
  dt-bindings: net: can: Convert M_CAN to json-schema

 .../devicetree/bindings/net/can/bosch,m_can.yaml   | 147 +++++++++++++++++++++
 .../bindings/net/can/can-transceiver.txt           |  24 ----
 .../bindings/net/can/can-transceiver.yaml          |  18 +++
 .../devicetree/bindings/net/can/m_can.txt          |  75 -----------
 4 files changed, 165 insertions(+), 99 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/can/can-transceiver.txt
 create mode 100644 Documentation/devicetree/bindings/net/can/can-transceiver.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/can/m_can.txt

-- 
2.15.0

