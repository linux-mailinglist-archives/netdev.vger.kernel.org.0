Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84162109AC1
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 10:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbfKZJJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 04:09:42 -0500
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:53424 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726346AbfKZJJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 04:09:42 -0500
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAQ96kO3021734;
        Tue, 26 Nov 2019 01:09:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=rBou2wi4ojhVW3Lrlp+TySRTfyIGyvroFQ/PyNXFhEI=;
 b=chcKbqK8kK07COuvlvP3yhcto7cVresRKdOhlfrFTPrINM7g8SiNz6jlyfKxYQEeJR7e
 vfCF41OkK1BuI4Y5n+R0W3xJNwNeLUmDqKysWQ7S6e9XaE99XvofhCyKZ/l0mOGPdo44
 yT2iTT/a2OveTf/QLdKJ7o/F3e+6/uUO7ya3OiQcu1K0tWZSVro0ZhsxMHwFkPJJ5kun
 1d77BD2DFJIZ8FmWgB4TZK8bg1FwuTtP/6s/DAi4OxTbBcXppZ7rWZDNocWZ3BEjGGGx
 yr1RVdbeYCHSt4WHImSkYbTrOqlvi/GofW+0lYMIv4JfP7lE3+eAciCkNGZ2jjo+RAgt ZQ== 
Received: from nam03-co1-obe.outbound.protection.outlook.com (mail-co1nam03lp2051.outbound.protection.outlook.com [104.47.40.51])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2wf26y2y24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Nov 2019 01:09:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XPmLffaRmuYnnQk6M0nVbXWqe6LZ7bOTNvi0Hg4SYRIt/7GyuCCcJShbJNEEPnKIdncqpnkV6gRQZtCb8bD6Kce8f6axbgAD9h2nuJhnw6sU3OD9hJkwhhfKHicDR0+R8AsCLMhwGCvGldwKEJbrhA3+h8oRcfHGMmU6g0CET3RuG3mbIHTX6b89Kmdj15mqEXtyVtVqgEBhmUH+0Ghsf9WD76zcLhsGM56xrysLricyhI/ng76AdfI4/LYJIJhH9zY2ReK+1Tiy0W1GmHoCsn82T+as8nW8tJG1LYf8j5Vgy0cpIpDBJ4ITjcvA7oJntK9PjtrpqV/9h0O/wPyadQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rBou2wi4ojhVW3Lrlp+TySRTfyIGyvroFQ/PyNXFhEI=;
 b=PcEekGsM1rrPzxgMaOqG20y+0V8X2bxh5r/ZH1z1uHOMRvIK63XkC0zEzyKU+jnAmFxFM7+wcDfFUA5mWTzGzAFKQx0gvaiaRko6X54n08xcy0xIucgf9XOlAZtLpRwpnw4sw8moyiqjC1hWnz5ejgf8tkwGaVEU+bjU7MlOIdsPJILjT1CcWpPssp3zlSKS7UGJjZQm77cEc11P1HgSmRawRpaY32ptYOghrrkMWaLjyKnL7NuzwaTomsvCU58KtvxL40NKDBJvyJHyuHsTMVeJVCTrYcuwlxDFUJoHAlYBQtocikX/YC1tUngKg6elCPRiNX1EhqxRFTTMohmIrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 199.43.4.28) smtp.rcpttodomain=gmail.com smtp.mailfrom=cadence.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rBou2wi4ojhVW3Lrlp+TySRTfyIGyvroFQ/PyNXFhEI=;
 b=OXQ4eqCKC2POTfabQI5s61i/G4mNxLY9oxYkSFJTXHZrgG0y/lqq4W87DZOwdicQPbmOjHMWvEhxBqUiO33LcjA3LNwrdk8BJwD12KHvA2BEYpOGvr7xnIMfPCr0S9r94kl6JjA4DPhFLHSbou82Ytl9orzg8NdjQVv1b88Q17s=
Received: from CO2PR07CA0076.namprd07.prod.outlook.com (2603:10b6:100::44) by
 MWHPR07MB2912.namprd07.prod.outlook.com (2603:10b6:300:22::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Tue, 26 Nov 2019 09:09:26 +0000
Received: from BN8NAM12FT036.eop-nam12.prod.protection.outlook.com
 (2a01:111:f400:fe5b::200) by CO2PR07CA0076.outlook.office365.com
 (2603:10b6:100::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2474.17 via Frontend
 Transport; Tue, 26 Nov 2019 09:09:26 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 199.43.4.28 as permitted sender)
Received: from rmmaillnx1.cadence.com (199.43.4.28) by
 BN8NAM12FT036.mail.protection.outlook.com (10.13.182.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.18 via Frontend Transport; Tue, 26 Nov 2019 09:09:26 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by rmmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id xAQ99LJ0029441
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Tue, 26 Nov 2019 04:09:23 -0500
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Tue, 26 Nov 2019 10:09:21 +0100
Received: from lvlabd.cadence.com (10.165.128.103) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 26 Nov 2019 10:09:20 +0100
Received: from lvlabd.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlabd.cadence.com (8.14.4/8.14.4) with ESMTP id xAQ99F3i102738;
        Tue, 26 Nov 2019 09:09:18 GMT
From:   Milind Parab <mparab@cadence.com>
To:     <andrew@lunn.ch>, <antoine.tenart@bootlin.com>
CC:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <dkangude@cadence.com>, <pthombar@cadence.com>,
        Milind Parab <mparab@cadence.com>
Subject: [PATCH 0/3] net: macb: cover letter
Date:   Tue, 26 Nov 2019 09:09:14 +0000
Message-ID: <1574759354-102696-1-git-send-email-mparab@cadence.com>
X-Mailer: git-send-email 2.2.2
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:199.43.4.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(396003)(39860400002)(346002)(189003)(199004)(36092001)(53416004)(7126003)(426003)(86362001)(2616005)(76130400001)(70586007)(70206006)(51416003)(7696005)(6666004)(356004)(305945005)(4326008)(2906002)(186003)(336012)(107886003)(26005)(8676002)(81166006)(8936002)(81156014)(50226002)(50466002)(16586007)(48376002)(316002)(36756003)(110136005)(54906003)(478600001)(26826003)(5660300002)(4744005)(47776003)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR07MB2912;H:rmmaillnx1.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:InfoDomainNonexistent;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea8ec441-1526-4a31-0b47-08d772505638
X-MS-TrafficTypeDiagnostic: MWHPR07MB2912:
X-Microsoft-Antispam-PRVS: <MWHPR07MB2912C72AF8FA96F1C1A1E186D3450@MWHPR07MB2912.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0233768B38
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2PPLBDak51/gU5187v5ZA+tY9mLYvs9JxeBXzPUrD6GUOMYVDnJVDM55+hwN0ILCaiEIxvI8YSL5FAlNhjHsJDEDaWoFZsB4R7y8Qs2WtgAuQG3DG1chFI8bCOH4cejx2SaY+0KS2Umyh4NX9jWOnb87BPBiCqIJXchBJFqlFROXncdV1gyBwe97Dgr58BQ71eV55gMMK+BUP522BSdR2XiJC254XJetdjRW6cx8zZ765XJJ6AA0gssyfenR3lwCO4SJwCL8nSCyR+UO1ZJDaSda3gt/q+18wunn49z52NQDpqIqQT9g9kfvFlEJtlVljDHLPig+zJ4HHFl5DYMFG2vF0PgW1ypiv+J32xW6hQ3pjLEKrGi2WCD45H5t411pf7n4st8ifDAWgsIdaai9OTKJ3rEig5klb5EPk25BDFOJz8mrGkexEdk54nKgyAY4//ducjhlAmfKxhl07GdUcw==
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2019 09:09:26.5407
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea8ec441-1526-4a31-0b47-08d772505638
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[199.43.4.28];Helo=[rmmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR07MB2912
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-26_01:2019-11-26,2019-11-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 clxscore=1015
 malwarescore=0 priorityscore=1501 bulkscore=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=657 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911260082
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patch set contains following patches
for Cadence 10G ethernet controller driver.

1. 0001-net-macb-fix-for-fixed-link-mode
   This patch fix the issue with fixed link mode in macb.
2. 0002-net-macb-add-support-for-C45-MDIO-read-write
   This patch is to support C45 PHY.
3. 0003-net-macb-add-support-for-high-speed-interface
   This patch add support for 10G fixed mode.

Thanks,
Milind Parab

Milind Parab (3):
  net: macb: fix for fixed-link mode
  net: macb: add support for C45 MDIO read/write
  net: macb: add support for high speed interface

 drivers/net/ethernet/cadence/macb.h      |  65 ++++++-
 drivers/net/ethernet/cadence/macb_main.c | 215 +++++++++++++++++++----
 2 files changed, 239 insertions(+), 41 deletions(-)

-- 
2.17.1

