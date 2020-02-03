Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1A61150904
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 16:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbgBCPER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 10:04:17 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:23844 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728367AbgBCPEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 10:04:16 -0500
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 013Equem017173;
        Mon, 3 Feb 2020 16:04:00 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=STMicroelectronics;
 bh=pniAfkE5zw0awvJdRpCx7RRsKAWjoiolBg7MxzSbGYE=;
 b=Apc7VNC3HH8CeCIhv/06DwZBQ3mhZEN1/Ms/4LIeYzq2aLIf+nA/3x9OI6V7wg/8OL8O
 ImA9V6YblbydiLbbUBoSQ0wWg1rfPY3Dit5PqszTwNAHRY1KSGmyCv9zyyhhoFzkgEL/
 hTf5VHGCz6MvDaluQwAbMG2NS/HJeHp8799ZBJbVL4/EUpKvC3xTFAXAnovGSxXPe+qd
 2NXW+7DxdKpGboZOrZv/UAgitoI2wf5V42R4FoFT40wlpG8uWSHVVc6UD5waIphfmW8V
 1t30LUV0vQXg64Wp7fds/UOOgvWwIqOzl4ecoHex5wVj2EvXzYoJ0w8TKXTTQg6MI+cA Ug== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2xvyp5ssm8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 16:04:00 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id CD9EE10002A;
        Mon,  3 Feb 2020 16:03:59 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag3node3.st.com [10.75.127.9])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 9C51C2B26E8;
        Mon,  3 Feb 2020 16:03:59 +0100 (CET)
Received: from localhost (10.75.127.50) by SFHDAG3NODE3.st.com (10.75.127.9)
 with Microsoft SMTP Server (TLS) id 15.0.1347.2; Mon, 3 Feb 2020 16:03:59
 +0100
From:   Benjamin Gaignard <benjamin.gaignard@st.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <sriram.dash@samsung.com>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@st.com>
Subject: [PATCH v2 0/2] Convert bosch,m_can to json-schema
Date:   Mon, 3 Feb 2020 16:03:51 +0100
Message-ID: <20200203150353.23903-1-benjamin.gaignard@st.com>
X-Mailer: git-send-email 2.15.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.50]
X-ClientProxiedBy: SFHDAG8NODE1.st.com (10.75.127.22) To SFHDAG3NODE3.st.com
 (10.75.127.9)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-03_04:2020-02-02,2020-02-03 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The goal of this series is to convert bosch,m_can bindings to json-schema.
First convert can-transceiver to yaml and then use it for bosch,m_can.yaml.

Benjamin Gaignard (2):
  dt-bindinsg: net: can: Convert can-transceiver to json-schema
  dt-bindings: net: can: Convert M_CAN to json-schema

 .../devicetree/bindings/net/can/bosch,m_can.yaml   | 146 +++++++++++++++++++++
 .../bindings/net/can/can-transceiver.txt           |  24 ----
 .../bindings/net/can/can-transceiver.yaml          |  23 ++++
 .../devicetree/bindings/net/can/m_can.txt          |  75 -----------
 4 files changed, 169 insertions(+), 99 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/can/can-transceiver.txt
 create mode 100644 Documentation/devicetree/bindings/net/can/can-transceiver.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/can/m_can.txt

-- 
2.15.0

