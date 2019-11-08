Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A31BF4D42
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 14:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729164AbfKHNeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 08:34:23 -0500
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:42688 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727431AbfKHNeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 08:34:22 -0500
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA8DY2Ek020618;
        Fri, 8 Nov 2019 05:34:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=sH8GahJdAlNq0AWGOBm6yysVkAnTlgB71aPt0ZG4lQ0=;
 b=VtbCiPyl24WhJBSGEkqTtBuzfT4Q1bE3YpwQZ/vujn7KAy3HIZRWqT9IxJUle68/EhfG
 Rst8OkcmPjHspD4c90o9GIM8YtBKAev683sitxtRD/saUZJ//VnuyrSfLgAUrp/1hjj8
 gZ7fCzUs8RLf/LupEmpReLIiza2twsdsNRpZUrqtKkR6yXTgBvnOorbABquD2rjUtfiu
 jaKCGZdij6QKSYsnNOS5rhaNuQhMxjLiMznhEta4f3TSnjEBUq0cyhFLJ5pcb64yFrML
 P1q/jx9BXVKwjWi4BFTT4MlXI1v4bexrNorXbIni5Nxk3CNLnzsEsSyRLlUBpvvbHIYA 5Q== 
Received: from nam03-co1-obe.outbound.protection.outlook.com (mail-co1nam03lp2052.outbound.protection.outlook.com [104.47.40.52])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2w41txhcje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Nov 2019 05:34:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lpVZHVmKIX1ZuQ+uHoKHomJwSMx3rI38CmNCJE2f5w2yh+sHvSG7weeyWDAC1ZjG5FUajO0+hRk0I9390iJSd9Hc70GfoYEz3L9Aa34tA5+fS7J/j6GOulvShl4A+10rLWgp2nspFfyF3TLHUTwZR4X5OPg5RlTHtjy12qBcs1k1qgrC5onrJkDtKtmLh8H5vrBJxfgRX8gxl5E6PuBDvlklurssg9Y/uuyfDgvkNwRQreQffYVfqPVWRklIVtlZ39Kkr1C0VXrV1xq3IDBBO6Sco72KF4L+dtM1xPFO2FvTYiQJkD6ojDqLEGXRjsEvjM/FeLpUXFkzzskGovwE1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sH8GahJdAlNq0AWGOBm6yysVkAnTlgB71aPt0ZG4lQ0=;
 b=SiugDiaz6OPdSAFgMSlp6DED4eeqOlIt6N2S8bmbEpsgu+cRhBajMolN2TuS5dIGVpXW4bft3VJbuo0TCrKPzGSkgmVCautquIKjZYr43Wx7WrjwnGfH1d8zmSXPW2KhdLs9d3+VP8+Cj779Jj3bHyH47UudAuJ5zYJz2Hr1vax0JhLCjix0xEoLzkD+p9ZV8g27I3ySt9DyT00ixR2eUYCrLBPFnIFIyu8UOqhiaOvTQf/wyuRE8+RT7Mn2GKffMKvyK7OaSQjEC0U5q6uemys+WaYh/SmJVPRr5cwVLpCoQcJllziAMzfdB0RM1LduuHKbn2WVfvk0zdEzVQuAQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 64.207.220.243) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sH8GahJdAlNq0AWGOBm6yysVkAnTlgB71aPt0ZG4lQ0=;
 b=CMj5groSp5FUD0f6XNR6G2Ogy8cvaMze87XzgakOUYmwyRub1D9B5hUclUANcYeyN1NXl1ulYqvMyscnQXyz8fWi5WEcSxFny0GCZ5/jt4Mo2zyfgSvT9Gx5x/a7LRKv6T3fRYTHEm10gkS0c+7Ktp/i58N/oN/hZ8bzU1otneg=
Received: from CH2PR07CA0031.namprd07.prod.outlook.com (2603:10b6:610:20::44)
 by CH2PR07MB7320.namprd07.prod.outlook.com (2603:10b6:610:a7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2430.22; Fri, 8 Nov
 2019 13:34:04 +0000
Received: from DM3NAM05FT048.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e51::201) by CH2PR07CA0031.outlook.office365.com
 (2603:10b6:610:20::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2430.22 via Frontend
 Transport; Fri, 8 Nov 2019 13:34:03 +0000
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 64.207.220.243 as permitted sender) receiver=protection.outlook.com;
 client-ip=64.207.220.243; helo=wcmailrelayl01.cadence.com;
Received: from wcmailrelayl01.cadence.com (64.207.220.243) by
 DM3NAM05FT048.mail.protection.outlook.com (10.152.98.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.15 via Frontend Transport; Fri, 8 Nov 2019 13:34:02 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by wcmailrelayl01.cadence.com (8.14.7/8.14.4) with ESMTP id xA8DXs1R133720
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=OK);
        Fri, 8 Nov 2019 05:33:56 -0800
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Fri, 8 Nov 2019 14:33:54 +0100
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 8 Nov 2019 14:33:54 +0100
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id xA8DXmpw015962;
        Fri, 8 Nov 2019 13:33:52 GMT
From:   Milind Parab <mparab@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <netdev@vger.kernel.org>, <hkallweit1@gmail.com>,
        <linux-kernel@vger.kernel.org>, <piotrs@cadence.com>,
        <dkangude@cadence.com>, <ewanm@cadence.com>, <arthurm@cadence.com>,
        <stevenh@cadence.com>, Milind Parab <mparab@cadence.com>
Subject: [PATCH 0/4] net: macb: cover letter 
Date:   Fri, 8 Nov 2019 13:33:47 +0000
Message-ID: <1573220027-15842-1-git-send-email-mparab@cadence.com>
X-Mailer: git-send-email 2.2.2
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:64.207.220.243;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(396003)(136003)(39860400002)(199004)(36092001)(189003)(110136005)(26005)(5660300002)(8676002)(50466002)(478600001)(7126003)(4744005)(70586007)(186003)(53416004)(81166006)(2616005)(81156014)(126002)(70206006)(47776003)(476003)(305945005)(16586007)(356004)(54906003)(50226002)(48376002)(2201001)(4743002)(8936002)(426003)(486006)(106002)(2906002)(86362001)(7696005)(51416003)(6666004)(36906005)(316002)(336012)(36756003)(107886003)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR07MB7320;H:wcmailrelayl01.cadence.com;FPR:;SPF:Pass;LANG:en;PTR:ErrorRetry;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73712cc3-2541-4647-e93d-08d7645051b2
X-MS-TrafficTypeDiagnostic: CH2PR07MB7320:
X-Microsoft-Antispam-PRVS: <CH2PR07MB7320C2F55BB9D4B9E05DDD1FD37B0@CH2PR07MB7320.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 0215D7173F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xm7XYaHvkWS9h/GAvNAkmbn/+Vybg3mdU6FgOz5a86iXM6oUmh2RRNmkPaPs3byv8S2iof1DxO7LWeisvyv9u/T655iM3yUeTTgYeVPUv6umLuITHXnJ/L2NQUouGQjkA89kG34DwMHKDbkpksYfFVSqu25Ey+jpMuW/ACOCihBR83GGkddQKjz1vp4/u6WFDsKqBrwo5vUyMwwh9UU+qS2JtTfE1tnDD9m60IyFZ6cPol3uJtU7v8Wnzp8F+llS5DbxAFIjo5rOUll0Wzf3EmBwNvIbpgeOabDtrxo5Ol12TJXbvZezwdb4gs5o7w8JHVM0GCwAWgd48FL08efX/9eDbE/qgjKAPfyuB5x0oQ5h+nPyhWPeReskTWBM1wLmnWnk98MmbjXTroji38IctI9+tQRwZf6fSJrjBbaut7vU6GXgIBfBJXuHDkVsV4tBoMbJtbnww+BEjrzTN0snRw==
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2019 13:34:02.5844
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 73712cc3-2541-4647-e93d-08d7645051b2
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[64.207.220.243];Helo=[wcmailrelayl01.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR07MB7320
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_04:2019-11-08,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 clxscore=1011
 phishscore=0 suspectscore=0 mlxlogscore=695 bulkscore=0 lowpriorityscore=0
 spamscore=0 impostorscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080135
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patch set contains following patches
for Cadence 10G ethernet controller driver.

1. 0001-net-macb-add-phylink-support.patch
   Replace phylib API's with phylink API's.
2. 0002-net-macb-add-support-for-sgmii-MAC-PHY-interface.patch
   This patch add support for SGMII mode.
3. 0003-net-macb-add-support-for-c45-PHY.patch
   This patch is to support C45 PHY.
4. 0004-net-macb-add-support-for-high-speed-interface
   This patch add support for 10G fixed mode.

Thanks,
Milind Parab

Milind Parab (4):
  net: macb: add phylink support
  net: macb: add support for sgmii MAC-PHY interface
  net: macb: add support for c45 PHY
  net: macb: add support for high speed interface

 drivers/net/ethernet/cadence/Kconfig     |    2 +-
 drivers/net/ethernet/cadence/macb.h      |  100 +++++-
 drivers/net/ethernet/cadence/macb_main.c |  521 +++++++++++++++++++++---------
 3 files changed, 449 insertions(+), 174 deletions(-)

