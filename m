Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6BA19D895
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 16:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391008AbgDCOFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 10:05:02 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:17922 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726087AbgDCOFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 10:05:01 -0400
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 033E3GDh031005;
        Fri, 3 Apr 2020 16:04:33 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=STMicroelectronics;
 bh=IAdgYFczRmmOZp/Tws5TnQ5Ax5bQ+dFO8+OYiw2NIxk=;
 b=Exw1Tb9WfdaUqIVSQmXZ5/KiVFHlfpc/7dUnWbSIjwGWCLnBj/GWHTtNrzz/Ual8FuFf
 7lCfk9Lkpdkxig8ZnT1fxliPr9Wi+5XXpVYtfchj8Wv0NSfXvpSph3Zu9oJzi52NwRb/
 QDiN8tBAaEen9cIvJOwhhBDyYrb80aMayUXsplJLA/o1fQLm7kwxZvOeL2i20/2SMaeB
 GCMRRy8Vtg5Q3J8f340YeVq9wRk+ydSdrfo+b+eAsfXtIwVq1v6g3a4/VUxrwrtklPf6
 4ulCgsW8Hvql2ZjfemlO7BKYITptRNTbYOST+hGOtkBm1c3mBuz+FDb5cl8xuCYryjln ew== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 302y54bpmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Apr 2020 16:04:33 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id DFA79100034;
        Fri,  3 Apr 2020 16:04:28 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag5node3.st.com [10.75.127.15])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id C17E92B3A7E;
        Fri,  3 Apr 2020 16:04:28 +0200 (CEST)
Received: from localhost (10.75.127.46) by SFHDAG5NODE3.st.com (10.75.127.15)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 3 Apr 2020 16:04:27
 +0200
From:   Christophe Roullier <christophe.roullier@st.com>
To:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <mripard@kernel.org>,
        <martin.blumenstingl@googlemail.com>,
        <alexandru.ardelean@analog.com>, <narmstrong@baylibre.com>,
        <mcoquelin.stm32@gmail.com>, <alexandre.torgue@st.com>
CC:     <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <christophe.roullier@st.com>, <linux-kernel@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH V2 0/2] Convert stm32 dwmac to DT schema
Date:   Fri, 3 Apr 2020 16:04:13 +0200
Message-ID: <20200403140415.29641-1-christophe.roullier@st.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.46]
X-ClientProxiedBy: SFHDAG4NODE2.st.com (10.75.127.11) To SFHDAG5NODE3.st.com
 (10.75.127.15)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-03_11:2020-04-03,2020-04-03 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert stm32 dwmac to DT schema

v1->v2: Remarks from Rob

Christophe Roullier (2):
  dt-bindings: net: dwmac: increase 'maxItems' for 'clocks',
    'clock-names' properties
  dt-bindings: net: dwmac: Convert stm32 dwmac to DT schema

 .../devicetree/bindings/net/snps,dwmac.yaml   |   8 +-
 .../devicetree/bindings/net/stm32-dwmac.txt   |  44 -----
 .../devicetree/bindings/net/stm32-dwmac.yaml  | 150 ++++++++++++++++++
 3 files changed, 157 insertions(+), 45 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/stm32-dwmac.txt
 create mode 100644 Documentation/devicetree/bindings/net/stm32-dwmac.yaml

-- 
2.17.1

