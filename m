Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD47516B3F
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 09:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383555AbiEBHba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 03:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354685AbiEBHb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 03:31:28 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5075B186D2;
        Mon,  2 May 2022 00:27:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nc8Kd2BRsXgVCrAeTGFmBoQGGR0yDbrXJbKo7aVJXWA175vbxJFRFBGIU1bLH+7mFNgTNg1Bgls27sN+Prft8l1OP0cTjQty0JJfHOaJI/9DTzLFjsZlyufbemTGSCzK2BNpjmCC/C40MWpKw5EyxWyaEm7Yiqpe3lzpDkqst0s2nFHMepU18MAtrlt0rpvVQ5Zb3DjFbW0EBlA0FpKTH5YScPt0t19Nk954BlMlKCKVv00lQ6MULSnyRpknpRsH7OWi3muugLuPm3PfDOqy3BT9FeY1w4xWRkiLhWcZKg/LeTyeg7oZKKVVihYC9AE72R1S+rp3fkY8E61vj5P5Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PJ60S8E4WpeUTKcOkDc4fDZAfrS32L2n15ddPy1Lypo=;
 b=hCnWrRO4Dh7DRzfiAO4ZaKGO/cfVPwgdnfU3BqsuZ8wIKsyqmLVPy9lfVnEdm6L21YSfZY9MQIjP8ooJ7z2CLtGMmRaFjYj37gtYNddW54NWSqkIV4Ze9pv++X2Oj+lBOEUbWFv02+e+/BdPmUeTmfHsOFG5x4V0rAtqD2V5i73VkZ5YpscTLwMbTimUWgVjFsHrCSWzyd6jql2+oPcuvGpIy7MSBi+XFK0BwGrF9GFZOSzclqqLwgQspZGNHAjKxqDQfWNYfve6/sZehWTOlhcfn9OsCctK7howj+jV0jldtMFRUSt+/g9u0b5KcMcCfsIrFwZN0ev6VwRLvPgABw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PJ60S8E4WpeUTKcOkDc4fDZAfrS32L2n15ddPy1Lypo=;
 b=cFZv3JzVntA43ZJBDXFZweLq/NVFu3FbztuyW7ymF4Jd8ccjAUdWuLwu8cPVUA6de8ll2iqF2ONDHjeSUCFu7sTPhO7Q3pjtHWD1DSafOGozBmXViVZ7DdQME1URLrR44sKa3wzKrPUjYh5Fs/V7l2xgpL8RnHF23RV7XOWEatU=
Received: from BN1PR14CA0005.namprd14.prod.outlook.com (2603:10b6:408:e3::10)
 by DM6PR02MB7034.namprd02.prod.outlook.com (2603:10b6:5:257::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Mon, 2 May
 2022 07:27:55 +0000
Received: from BN1NAM02FT058.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:e3:cafe::96) by BN1PR14CA0005.outlook.office365.com
 (2603:10b6:408:e3::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14 via Frontend
 Transport; Mon, 2 May 2022 07:27:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT058.mail.protection.outlook.com (10.13.2.166) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5206.12 via Frontend Transport; Mon, 2 May 2022 07:27:54 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 2 May 2022 00:27:53 -0700
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Mon, 2 May 2022 00:27:53 -0700
Envelope-to: git@xilinx.com,
 davem@davemloft.net,
 kuba@kernel.org,
 andrew@lunn.ch,
 pabeni@redhat.com,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.6] (port=56283 helo=xhdvnc106.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1nlQTJ-000DbR-8q; Mon, 02 May 2022 00:27:53 -0700
Received: by xhdvnc106.xilinx.com (Postfix, from userid 13245)
        id 7F54E60FFA; Mon,  2 May 2022 12:57:52 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <michal.simek@xilinx.com>, <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <git@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH net v3 0/2] emaclite: improve error handling and minor cleanup
Date:   Mon, 2 May 2022 12:57:48 +0530
Message-ID: <1651476470-23904-1-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.1.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c277bfd8-8ea2-4fcd-27b4-08da2c0d4637
X-MS-TrafficTypeDiagnostic: DM6PR02MB7034:EE_
X-Microsoft-Antispam-PRVS: <DM6PR02MB70341F68ABC4F4174124BD21C7C19@DM6PR02MB7034.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ti3eSz5zPoqFqxilaliF0V3Gtz4qojtjiyhqXvnBDtSiZ4qrRT8BqbSPpXJPfPVv4xMmDgIoTBYmiAb848e5fhSmPeFmd8YmKH/u2g35+e9kk0AelSn7/Vrxmer7Ju9PF7qyywYfh0vv208PdeTBY/s4I1pi6fJ4RWrNYjSEmNker5qxBp7R8gUn07wKua7AtIJg+k0axRgKftcobvj08E/H+JnQEnLp9TsNXEk0+PQTPIPOC/snx6Lg2dfHipVrUQMmwpDhrLd2rvNczEXsZIlQB8eKksWVeHz3egBwBHJyr8xNCdyF0MXRri0D2lICpNAw85yQ0Jp8cBWsOErmoZxHV6Dl6LWhOZ7qHucKotmpzmDLOpDDt/yjoFfR1N11MWDu4e8IDFLg0g/V2+v+hlajVubvzTpoW/UpwmsA+dq0Aw0WdEO7Ey96Prq9oZFyE9DRAYoVXD7NMur5uYYhhJWBCQfGFN8psosYv2eYo0WtTAYQVyuJEU0lyrkTk12887wIjMdCXr4ldLSixrKbZ5+jaa/j/Z8s2t2qNX9uEyzq7bgaEJC2y7mzjTuBnfToZ6Z+uItLJNaY44gp21TWTrN4Scbh6kSy5Mbld+fCqDQRp+77jGq0nVFrf+4qfks3BZ3dNynsoygWc4wy2CCdpnLN3gZ5xhpUWhNoRCF5ICle/+slTn0n63Y/RmZqbTh5X7XqxLZhY1g3PCu3JPQekw==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(6266002)(8676002)(336012)(36860700001)(186003)(426003)(4326008)(70206006)(70586007)(8936002)(47076005)(26005)(82310400005)(107886003)(5660300002)(40460700003)(4744005)(7636003)(2906002)(356005)(83380400001)(110136005)(6666004)(36756003)(42186006)(508600001)(54906003)(316002)(2616005)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 07:27:54.9157
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c277bfd8-8ea2-4fcd-27b4-08da2c0d4637
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: BN1NAM02FT058.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB7034
X-Spam-Status: No, score=1.1 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset does error handling for of_address_to_resource() and also
removes "Don't advertise 1000BASE-T" and auto negotiation.

Changes for v3:
- Resolve git apply conflicts for 2/2 patch.

Changes for v2:
- Added Andrew's reviewed by tag in 1/2 patch.
- Move ret to down to align with reverse xmas tree style in 2/2 patch.
- Also add fixes tag in 2/2 patch.
- Specify tree name in subject prefix.



Shravya Kumbham (2):
  net: emaclite: Don't advertise 1000BASE-T and do auto negotiation
  net: emaclite: Add error handling for of_address_to_resource()

 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 30 +++++++++++----------------
 1 file changed, 12 insertions(+), 18 deletions(-)

-- 
2.7.4

