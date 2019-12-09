Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECB03116C18
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 12:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727604AbfLILOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 06:14:47 -0500
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:34744 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726297AbfLILOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 06:14:47 -0500
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB9B5kPV030486;
        Mon, 9 Dec 2019 03:14:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=VnwB/nFp/DV7+pG8EwgrPnveeZH4dvR0FtT9KyTTYHg=;
 b=Vq8gFNodb5ccE+qyONBUIVPcWYq5pVb2X/ZXRAITyGURXsqAHqMrf+9qwX4BdKplUgGM
 QB5z1PT0Ilt30iHd4CZb1KN/ErJpodydmNUmfWr3dzrnGZQudLASK94/yjzwloaYttFa
 rY2vnGaAnbxt4zhUaUjVUXQDSXmnwgLkNbRjPPg9N7xYagBzotVEsVHemxjDLqNpNiw8
 y9KhiOrI62Zdvs/5pHe0Ot2QnHGJqbUpMJU1T66YGzykuNH1YVeKf0JoIfwfvFqNowox
 fzClxqUBg4fttTC/RCwDVZo4r897vvIipqptIiyEcnkelznahCUFBrb6okdMqf/t7PnQ Wg== 
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2055.outbound.protection.outlook.com [104.47.38.55])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2wr9dfdbxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Dec 2019 03:14:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RWO4RXezxc1sgj3cEuMnxUS+/oFywKNfpxa0vro03TNwh34ohsj+bZxi/gCeDFYhjVo9qn5qoDEN9JrteegwSS3ixjKGIfeisXb84haCtuDWJ5rEtVVDmlCE7z6WzXy9A6IWPFXOQc4aGUjkaihmQ7SAdMd0hzgtmVG05Tl0ef6NiEud9a636K/ayNqHL7eS6S6xANQpuAJP/mBMaTlSaWa4vCbJ70LOE2dA/+dKp7gnLwuTWdQ7XwLoT3GO+RZXA6U/BPzTohS220KuxGlsyTnJuedcVUH4B0lz7xabAXqfCH9mfSEULz+stOV3BMR5BLOyA8oHfVbd4CiZrxcUiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VnwB/nFp/DV7+pG8EwgrPnveeZH4dvR0FtT9KyTTYHg=;
 b=hMkgibB/hOQim59P1hSc327nmz5b17GAOFw71iq3E2FMAbZEW6Y051HHLVWuEffhI8YMi/HwdiEjwWYaAUbAWyVyDTor9/Iep41UPtRtN2QkkRqJoWdavJ8u6cqhJchlgvMGQwa4rurWblK626UjdjEw6TTrJ2xFmSr7hGjwhXTVmDz8y0ZKzh8HhVQ3fvdoXO+DvkZxcwcugucHmL9vs0yhQqM/aGKxL05KwlVAfmhltsUa92uFhlNlzgR0K4L7j49ETaT2uk1uZBbF8yni4W4PpAJ0/zZ58Uf136lRgDgO50Q/MWo7qk1pj1s9jvL/UQpAqXfasyCdGmYe/LEp2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 158.140.1.28) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VnwB/nFp/DV7+pG8EwgrPnveeZH4dvR0FtT9KyTTYHg=;
 b=VObVaZDultglJI0oNhez8gLskSlej6WLP6Yq/aYLeZYKnYNOr5EQYFttnd48CbXhNdT3rIlv8DPlyIqEhm2is8nFU97t5mlSKdQ7dUbowOaC3YY4Z1hdgqC4YqCut8fLkYkwpaWOJVXkWLvRh5BDfICjjSiA6mKMNuyxzMhHjM0=
Received: from SN4PR0701CA0046.namprd07.prod.outlook.com
 (2603:10b6:803:2d::33) by BYAPR07MB5797.namprd07.prod.outlook.com
 (2603:10b6:a03:130::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2516.16; Mon, 9 Dec
 2019 11:14:06 +0000
Received: from MW2NAM12FT057.eop-nam12.prod.protection.outlook.com
 (2a01:111:f400:fe5a::200) by SN4PR0701CA0046.outlook.office365.com
 (2603:10b6:803:2d::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2516.13 via Frontend
 Transport; Mon, 9 Dec 2019 11:14:06 +0000
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 158.140.1.28 as permitted sender) receiver=protection.outlook.com;
 client-ip=158.140.1.28; helo=sjmaillnx2.cadence.com;
Received: from sjmaillnx2.cadence.com (158.140.1.28) by
 MW2NAM12FT057.mail.protection.outlook.com (10.13.181.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.18 via Frontend Transport; Mon, 9 Dec 2019 11:14:06 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx2.cadence.com (8.14.4/8.14.4) with ESMTP id xB9BE0Qo023067
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 9 Dec 2019 03:14:01 -0800
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Mon, 9 Dec 2019 12:13:59 +0100
Received: from lvlabd.cadence.com (10.165.128.103) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 9 Dec 2019 12:13:59 +0100
Received: from lvlabd.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlabd.cadence.com (8.14.4/8.14.4) with ESMTP id xB9BDsOi023923;
        Mon, 9 Dec 2019 11:13:54 GMT
From:   Milind Parab <mparab@cadence.com>
To:     <nicolas.nerre@microchip.com>, <andrew@lunn.ch>,
        <antoine.tenart@bootlin.com>, <f.fainelli@gmail.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <dkangude@cadence.com>, <a.fatoum@pengutronix.de>,
        <brad.mouring@ni.com>, <rmk+kernel@armlinux.org.uk>,
        <pthombar@cadence.com>, Milind Parab <mparab@cadence.com>
Subject: [PATCH 0/3] net: macb: fix for fixed link, support for c45 mdio and 10G
Date:   Mon, 9 Dec 2019 11:13:53 +0000
Message-ID: <1575890033-23846-1-git-send-email-mparab@cadence.com>
X-Mailer: git-send-email 2.2.2
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39860400002)(396003)(376002)(36092001)(189003)(199004)(186003)(356004)(8676002)(8936002)(4326008)(7416002)(26005)(7696005)(110136005)(54906003)(86362001)(70586007)(70206006)(76130400001)(107886003)(26826003)(36756003)(316002)(336012)(7126003)(2616005)(478600001)(2906002)(7636002)(305945005)(426003)(246002)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR07MB5797;H:sjmaillnx2.cadence.com;FPR:;SPF:Pass;LANG:en;PTR:corp.Cadence.COM;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 198d7453-0ebf-4352-6b3c-08d77c98e7d6
X-MS-TrafficTypeDiagnostic: BYAPR07MB5797:
X-Microsoft-Antispam-PRVS: <BYAPR07MB57974C3B35D68193CF83656CD3580@BYAPR07MB5797.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 02462830BE
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: efT19Z+qibcdHVZCF5oe1kka8mj8XzB9LXjlfo+ugWfnyNY9g/WczZ9+7/jTVOj6Vs8s0HqEBXlFsLx2nASlyBu5dyJZ9xeTXCbow6/+tKfViC6GM8HdxnARCGuigU1XJBAtDwQSTE1XiC/YqEQxOjv8fz+g5bLcsaSNm8fdEB1rs1E0bNpyGO4GOoGOX2JJpthpQNrrQtj3SDtb9PXs2kyNU6rs644pySVDGmSUBzxZbCUmd8hzA5ybSB0jTAqB+QpCwDKbiEdsEYO/LHToQBzhj0L2Fe7yj6Kx5H3f+qmbnu+Xo8Udqxxctmkk3ZoMpXu5x3BAd/GstSdQbD8OYXw4hJaD+qgrAUjB+osbsKpMQ5yrHAMPr9nsWRF0vqYUUKUl/3KUIudBVTTed6r+7LmFZlFCY8tUva1PMnDCX1i6KPcrHuNL2CeJLYmH6ulCsPwxTgALPGoxyoMZn37l2KdNi+5lDIVv2SCCnvicJ5kCbF1iuoR+LdIQ0Y89gCjC
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2019 11:14:06.2096
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 198d7453-0ebf-4352-6b3c-08d77c98e7d6
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx2.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR07MB5797
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-09_02:2019-12-09,2019-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 mlxscore=0
 malwarescore=0 suspectscore=0 phishscore=0 impostorscore=0 spamscore=0
 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1011 mlxlogscore=601
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912090095
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series applies to Cadence Ethernet MAC Controller. 
The first patch in this series is related to the patch that converts the
driver to phylink interface in net-next "net: macb: convert to phylink". 
Next patch is for adding support for C45 interface and the final patch
adds 10G MAC support. 

The patch sequences are detailed as below

1. 0001-net-macb-fix-for-fixed-link-mode
This patch fix the issue with fixed-link mode in macb phylink interface.
In fixed-link we don't need to parse phandle because it's better handled
by phylink_of_phy_connect() 

2. 0002-net-macb-add-support-for-C45-MDIO-read-write
This patch is to support C45 interface to PHY. This upgrade is downward compatible.
All versions of the MAC (old and new) using the GPL driver support both Clause 22 and
Clause 45 operation. Whether the access is in Clause 22 or Clause 45 format depends 
on the data pattern written to the PHY management register.

3. 0003-net-macb-add-support-for-high-speed-interface
This patch add support for 10G fixed mode.

Thanks,
Milind Parab

Milind Parab (3):
  net: macb: fix for fixed-link mode
  net: macb: add support for C45 MDIO read/write
  net: macb: add support for high speed interface

 drivers/net/ethernet/cadence/macb.h      |  65 ++++++-
 drivers/net/ethernet/cadence/macb_main.c | 220 +++++++++++++++++++----
 2 files changed, 243 insertions(+), 42 deletions(-)

-- 
2.17.1

