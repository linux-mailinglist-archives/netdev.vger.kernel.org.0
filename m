Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 836494ABEDF
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 14:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447886AbiBGNCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 08:02:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447279AbiBGM4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 07:56:22 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2060.outbound.protection.outlook.com [40.107.93.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 528B4C043188
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 04:56:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DKxvvufyHvZ0WPtWw8YqnZd1/1lcMd6qS95AH7rLVzsEafYwwPJW/B6qYO3nVSE/SkHShBfIrQ3KZy+6ZpVMjeY+qvO/C3gBH6SG+HnWVVbT/VLraEZru0RvcahNNa2KKIaiMYn3EwsjZ4aPDOSyF09hRPoBNJv6ed2eFkAlkFczWSy4+SWQcSrMvQ5khXzY+Lgf1LXA3aVAoVruhx8jnjvrlgAiCsa5RbHybp79Ht7sFInfhbJCgddUFvz6VXKYZO4fERhRBDiPgzVcLufFv5pA+vDrWOEUqW4UAgZzNo59GNk7JU3q+9/1nTAb6XuofG8VfMRD+oJ65Nk/IpuymA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cs3BKRYtJrvPD+AOS1IZwZWAgd0SO1sGjPgTG6j2N4I=;
 b=Ze9tPwEBzpjtfxblbfvMlGEMc+7Y3UqTr2mxoLlUTNONqrEuaNVKhJFjgmkD3xJW8PrKUZLpoEhlEdfkxI2yTaOXHUnJ2P1xL1kGrswpeDMyiyx++jVUO0xNccuMHF13JMA5TGPX+GOeMXG2aAdlltWxgFX5nay0jM4p8fWBy8QZHLjlbWOk/zG4grYmIl91hwAHjTDMeaBnY0yWCwlhllW68AHW3dS0KG3a7YQQoW4trW+fuCup5Z/tO4YnQVdcfhJvPEbnH+dp+WbhpMJ3E+tVt0nf9IXkUoeIEUqY7ZwSnGCaoQaz7HyWsrZMgdncdmg7CP2qBLRyZgx+/03Z2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cs3BKRYtJrvPD+AOS1IZwZWAgd0SO1sGjPgTG6j2N4I=;
 b=rkhbeepB22zD/VxDFEW2pTxZbo5FTX/QYVARLfsOT8jpPtQIF+LUg3mUHE69+h2Axoj4uywTRNrwCpnB6diLUg/G2nWqVEYNdTlMRJFvpVRpIv9mpkKMtqzmAWlBhTFSPRHrei1ZTf0lT7DJMJLTfe+7mYbaOHTaZmvcH7GKWzJ0BrD4DL0Kfq0A4J/zQ51DgnBZgr2uE/PaZP3/cFkf4c8pYBTZOCEAJfNMkNjm0bOzA9FlpNSgCTg/qeZ/LDBOaORb/Gz+kt0XqjeGPr8bFfGKNxguxNq4lJ8cA63ffGuYF//TcR+rjxC8P1ZAX/RGAp4UIOhhePxSZIdXdSGLrA==
Received: from MWHPR19CA0008.namprd19.prod.outlook.com (2603:10b6:300:d4::18)
 by BN6PR12MB1268.namprd12.prod.outlook.com (2603:10b6:404:1a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Mon, 7 Feb
 2022 12:56:19 +0000
Received: from CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:d4:cafe::b0) by MWHPR19CA0008.outlook.office365.com
 (2603:10b6:300:d4::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18 via Frontend
 Transport; Mon, 7 Feb 2022 12:56:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT044.mail.protection.outlook.com (10.13.175.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Mon, 7 Feb 2022 12:56:18 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 7 Feb
 2022 12:56:18 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 7 Feb 2022
 04:56:17 -0800
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Mon, 7 Feb
 2022 04:56:15 -0800
From:   Eli Cohen <elic@nvidia.com>
To:     <stephen@networkplumber.org>, <netdev@vger.kernel.org>
CC:     <jasowang@redhat.com>, <si-wei.liu@oracle.com>,
        Eli Cohen <elic@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>
Subject: [PATCH 1/3] vdpa: Remove unsupported command line option
Date:   Mon, 7 Feb 2022 14:55:35 +0200
Message-ID: <20220207125537.174619-2-elic@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220207125537.174619-1-elic@nvidia.com>
References: <20220207125537.174619-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 399805f5-7070-41d2-68d4-08d9ea393bda
X-MS-TrafficTypeDiagnostic: BN6PR12MB1268:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB12682B5696A8FB7A2E035523AB2C9@BN6PR12MB1268.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:510;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hZXTpCpKxj3q9bDrqRBVjebcT3TeNocyp5K+3gpEu0wXndqrRhjQUtfxoh+KNFH3Vqn/8Hhh2Vhqh83cxV9lg21eHJ1iJ19uzcI6XQCt1XaL/liDFPIVPVrfI+03n/sWv/NZ/NEYGiwuufiIQIebPyIFYZpLm6NnxEjMeX7r4EVs3umW5ufUp7Tya7eHc9sQHfyy2sFWs5wD/LpPQjA+goO3RWoFlF3rNIgIBZVYr7SOCe3GnxJ0598V+1M2X4HXwSr936sz3zMUX+CxKMuCZf2cMnc1W8XlvoowgZnQORDRS8hrg4XyjjoSTK4sfGaMV+J/WD+2+iEN1CrZtcxnuc+i5eLPtx0EephVSWn0vyCv/vvbep9Ef5sYTCFF2Wgl+VNMb51uXhc9xGXWUdTk6iRRJwt6H841QxlVuMQakC3/cmMZf+L/EHvCG2rbfPv8XamXbRo8AjIQlsusZYBaMCtRXSAzs+hUNvpXivh67o76cWJqvNEsaRtiXTprYHVg05kfiN/ikeKZQEaWJ7Wb++tou9rmZ1vfZlCuU4FVSxX3JqtfeEgFtq1zcUOOnNfpaClemTGO+lgjIcz3OcGIXnvNduhGVXulmpND+cgVrw68qrDCGR9oj+wHUEe/ZAf4M04xtGcsxCaa4JlWl0eYg+m2TfFbcvJbiTgaR7pkn/JXg9q1qOhrzPvtup0Jb4kb/WJF4rcFg/wDNY3gHyhQoA==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(4326008)(1076003)(426003)(336012)(186003)(2616005)(36860700001)(107886003)(5660300002)(26005)(81166007)(356005)(47076005)(83380400001)(86362001)(70586007)(70206006)(8936002)(8676002)(40460700003)(6666004)(2906002)(7696005)(4744005)(82310400004)(508600001)(316002)(36756003)(54906003)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 12:56:18.6590
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 399805f5-7070-41d2-68d4-08d9ea393bda
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1268
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"-v[erbose]" option is not supported.
Remove it.

Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Eli Cohen <elic@nvidia.com>
---
 vdpa/vdpa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
index f048e470c929..4ccb564872a0 100644
--- a/vdpa/vdpa.c
+++ b/vdpa/vdpa.c
@@ -711,7 +711,7 @@ static void help(void)
 	fprintf(stderr,
 		"Usage: vdpa [ OPTIONS ] OBJECT { COMMAND | help }\n"
 		"where  OBJECT := { mgmtdev | dev }\n"
-		"       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] | -v[erbose] }\n");
+		"       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] }\n");
 }
 
 static int vdpa_cmd(struct vdpa *vdpa, int argc, char **argv)
-- 
2.34.1

