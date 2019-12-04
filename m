Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2D9E1123F7
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 08:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbfLDH6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 02:58:21 -0500
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:18142 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725839AbfLDH6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 02:58:20 -0500
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB47m9OP027836;
        Wed, 4 Dec 2019 02:57:11 -0500
Received: from nam01-sn1-obe.outbound.protection.outlook.com (mail-sn1nam01lp2056.outbound.protection.outlook.com [104.47.32.56])
        by mx0b-00128a01.pphosted.com with ESMTP id 2wkk2c34r4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Dec 2019 02:57:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fwbZ3uqpEaviCo90MSQbWYrOWEk8cZ4LNySQozYkOv5Els8WLM8dyAALuTCO/+HxgTxQwWtO3FTHE5O29SEaLkZPm5fLyZa2uUghvPXJV1IL91l2/MScpkoGRsiU4qoRTMgMFUyNAILxK8uH0Nx4KcI6fzFC6m5/4jT3NZWMWXYzUC630miBjC51K/IT9Rf9ZXFcOJjc3zzhmaLvy4Po+5ZZ+QQyQZ1vm6KF//njGllc7M+HhI65eLs/fGA4cWu5oMPHhWKAfIFmebmMWfHv3JPp/VYt1CPyOUEvwlUzrhuilbPvttqdRlKFN6+fPt2mrK2oBiJflugSXOK+LkT/JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j59hsWMxnp5c05fsZEeV99EfNHBKKPjZ2PHjyL0MRK4=;
 b=BRBA+sEHoBOtMm6JBZE2IuApSxKdNMjInk9kaMSJc+FqNDfFzQqBWQ5X4XaC3M3MTg6hhl+rxNBC7FVL3Y5c3+HQksYzw58UARuCpHx2nXDS/0YlkVLT4g20EHJSt+lR7cBfq4AiF/24PFVjo6C80tbLWnHUAxPqD9jHqfEGl5M0a1IUjvO/p6phgBXz8FfcPu0t1Nmlt8+Fqtvh3i65BWqCRPEedYbNmsRYBjb4A3b46Vzoq8VGRJNTNA0swF+En7sZnbp2hC2rtllGwGM+c6vDmYoA4A9zUO+4YzNaEXYCARnvK+j8F7HzJRw5Cox1B3DbIhl6KYKYWEKiXC1DFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=davemloft.net smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j59hsWMxnp5c05fsZEeV99EfNHBKKPjZ2PHjyL0MRK4=;
 b=Z3ddIbw2uAqxIK3Ivrk3G2GS863VnePle5Zf2xLf521kACzt40MSbq8/UaUQucEzS3Pt7lui5dkC6jM+dlmFtF9adQaktMy+4BzApz/gOncpD3HSRLAEwupkieI91BTEvd9gRAUTC1Li9b1EZqsj+nDaMTLkP4zMD3wEuJY7WmI=
Received: from CY1PR03CA0011.namprd03.prod.outlook.com (2603:10b6:600::21) by
 DM5PR03MB3147.namprd03.prod.outlook.com (2603:10b6:4:46::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Wed, 4 Dec 2019 07:57:09 +0000
Received: from BL2NAM02FT017.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::209) by CY1PR03CA0011.outlook.office365.com
 (2603:10b6:600::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2516.12 via Frontend
 Transport; Wed, 4 Dec 2019 07:57:09 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 BL2NAM02FT017.mail.protection.outlook.com (10.152.77.174) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2474.17
 via Frontend Transport; Wed, 4 Dec 2019 07:57:06 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id xB47v5rM017916
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Tue, 3 Dec 2019 23:57:05 -0800
Received: from saturn.ad.analog.com (10.48.65.119) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Wed, 4 Dec 2019 02:57:04 -0500
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <frederic.danis@linux.intel.com>,
        <alexios.zavras@intel.com>, <eric.lapuyade@linux.intel.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH] NFC: NCI: use new `delay` structure for SPI transfer delays
Date:   Wed, 4 Dec 2019 09:58:09 +0200
Message-ID: <20191204075809.31612-1-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(396003)(136003)(376002)(346002)(199004)(189003)(2870700001)(8936002)(107886003)(478600001)(2616005)(2906002)(305945005)(4326008)(106002)(5660300002)(7636002)(54906003)(36756003)(110136005)(14444005)(70206006)(86362001)(316002)(356004)(48376002)(50466002)(336012)(50226002)(26005)(70586007)(246002)(44832011)(8676002)(426003)(7696005)(186003)(51416003)(1076003)(81973001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR03MB3147;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8bed0f90-ec6d-4423-c929-08d7788f8eee
X-MS-TrafficTypeDiagnostic: DM5PR03MB3147:
X-Microsoft-Antispam-PRVS: <DM5PR03MB3147D3A1EB3C8243CAC55B82F95D0@DM5PR03MB3147.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:632;
X-Forefront-PRVS: 0241D5F98C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Skh/pmwHWCG9iXRTfSe5MRrBown6ST8Pk1zzu3HOoCThxcvEXRqfPj8OMhCY0T886FWrdzaw8bqDE/4lIbY19QO6p8h5oLVezQ3a6aehKceffdCl414RuJahFvAYn5ZIMRQ4MlizDJ+ebkhhu58eHd90Y708r/tVg9UEuJJV/sskihOfBYbEgD+ICenRGCHWaD1u0Vok4sI2/5Io8nD6G1Sx9JYecMslWGpmP5A7Pi9uJL8mv4bW86Q1v7yUqx7FSrNBsT9sxZweK8UiNTKNw/x36Mj8RrYipNgrhKv723X7NnhrNadrjizPsLwIYF2yTXZVYNMjy46kL1EiMzYOZwKknb3RUNh8GppOvBUj+wd038uGECMAywR2JvBwuqhDxwfeamIJrjMx93yr0qxEwc/KYdiCtskLUGIfZwvMduBeCMN6EB6pXFzEE5vddLARHV6rq4Et5xmypWnLogVB80DMY1JQqPAWkOcotiyXsg/pPbTPSqHTD++bui1n3Soi
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2019 07:57:06.9334
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bed0f90-ec6d-4423-c929-08d7788f8eee
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR03MB3147
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-04_01:2019-12-04,2019-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 impostorscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912040057
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a recent change to the SPI subsystem [1], a new `delay` struct was added
to replace the `delay_usecs`. This change replaces the current `delay_secs`
with `delay` for this driver.

The `spi_transfer_delay_exec()` function [in the SPI framework] makes sure
that both `delay_usecs` & `delay` are used (in this order to preserve
backwards compatibility).

[1] commit bebcfd272df6485 ("spi: introduce `delay` field for
`spi_transfer` + spi_transfer_delay_exec()")

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 net/nfc/nci/spi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/nfc/nci/spi.c b/net/nfc/nci/spi.c
index 9dd8a1096916..7d8e10e27c20 100644
--- a/net/nfc/nci/spi.c
+++ b/net/nfc/nci/spi.c
@@ -44,7 +44,8 @@ static int __nci_spi_send(struct nci_spi *nspi, struct sk_buff *skb,
 		t.len = 0;
 	}
 	t.cs_change = cs_change;
-	t.delay_usecs = nspi->xfer_udelay;
+	t.delay.value = nspi->xfer_udelay;
+	t.delay.unit = SPI_DELAY_UNIT_USECS;
 	t.speed_hz = nspi->xfer_speed_hz;
 
 	spi_message_init(&m);
@@ -216,7 +217,8 @@ static struct sk_buff *__nci_spi_read(struct nci_spi *nspi)
 	rx.rx_buf = skb_put(skb, rx_len);
 	rx.len = rx_len;
 	rx.cs_change = 0;
-	rx.delay_usecs = nspi->xfer_udelay;
+	rx.delay.value = nspi->xfer_udelay;
+	rx.delay.unit = SPI_DELAY_UNIT_USECS;
 	rx.speed_hz = nspi->xfer_speed_hz;
 	spi_message_add_tail(&rx, &m);
 
-- 
2.20.1

