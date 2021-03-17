Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5A833F04A
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 13:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbhCQM0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 08:26:03 -0400
Received: from mail-eopbgr700071.outbound.protection.outlook.com ([40.107.70.71]:9760
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229766AbhCQMZf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 08:25:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YHGSN3bGRhVlITWIsyiSKU3q+Mk+xNg9svIRz5W50uuVX4B3EmeOMImLQfMTpiLGttHjBy5Cc5ZfocSyS0O83ve09/A1aks8f6tRCZkwfR2+mXstosMDKglHQunqP8OcqFAWhadZo+h6armCozKHXzSHhg86kpbEQWVQ9KJ8qrwHyWnZBWhjJ4dWAkHY5XEVBpS1rsZMaihtEUkF2mfNnWPOrClmJRXJ1RnMnfslxwEkV94GHTbfDD3MFiDthao/3haSi6gb+eGuFW3KZR9gOYNxaP1+jOvEdK2WXPW0TkihE7OAD13/MCSRWsUaDEsUrcrYsqQI8IW+YE9LB5qz9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iwa3doEH5gWeGfpQ82+tohXmRN2Csb/Ug/N0ynzaU5Y=;
 b=MUJIuaCVkJRPC8BbDa44TAFUbBuw/G1Er1PcmHNzgHAi2cp4XdpHq1qbSH/mYySNMjdbWXkiw+bw1DQL4W6skdgo5TDHyFAo4J3inXTLLkz7QoVes5xZ+Qu8Gg+WaBjzSbuNmU3Vw78grJ5aFmT20aKqT22nDCGGgLqAbqCjJ1gEaM/lRdzQxIFqY3zD0IO/bsvEeb4uyLTKdFSiETPNVZxvFRxk1FaVYhjWz4xx0h3FBj81y5nM9CVaZOiTe/vdlV4vyGfWN4bjhwy5yVt+nAtIMeax1RiFpMW5pT7YUzkN5198c6R1Kee1WQKbk2tFxYLafQeItsxFPKubhDhteQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iwa3doEH5gWeGfpQ82+tohXmRN2Csb/Ug/N0ynzaU5Y=;
 b=Rj5pQVZz5goWr5XOgxRBtW/lXn0Zo447fxAWvs29Oyy6ztlyMRCK34TZKZi0i4EvHyaaQWHSP1HydNMqq91jgdosxIP78sPlsaD3ezWIaWRd1Hq+4IUw9oCeHMwRJdhemiSlBRcjuR6FWf9K1ijK6W1NltCew1YhvTMC9TregCkSWK2nfFRCocr+gllkH+Fw7V1Ic/auNykAeVz+wemXhwdtY8h8XJQxoAhqeycYNAo526mdixLRDKzR95+aOAZ0SmNqCmw4h7Kn254MPXDbFVrmj1evhHo3ZDOz2kBDpId4sHXJ++8T+VWfZEvsnkldfYfScWtg0+kb6/AFkzEBjQ==
Received: from MWHPR19CA0054.namprd19.prod.outlook.com (2603:10b6:300:94::16)
 by CH2PR12MB3655.namprd12.prod.outlook.com (2603:10b6:610:25::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Wed, 17 Mar
 2021 12:25:33 +0000
Received: from CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:94:cafe::5e) by MWHPR19CA0054.outlook.office365.com
 (2603:10b6:300:94::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Wed, 17 Mar 2021 12:25:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT037.mail.protection.outlook.com (10.13.174.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Wed, 17 Mar 2021 12:25:32 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 17 Mar
 2021 12:25:29 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Petr Machata <petrm@nvidia.com>, Tim Rice <trice@posteo.net>
Subject: [PATCH iproute2] ip: Fix batch processing
Date:   Wed, 17 Mar 2021 13:24:14 +0100
Message-ID: <3963278ba3956499a8f1506a112a10547946d75f.1615983771.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1603fcf-176b-4648-7020-08d8e93fc26d
X-MS-TrafficTypeDiagnostic: CH2PR12MB3655:
X-Microsoft-Antispam-PRVS: <CH2PR12MB365586239B929E66C6473789D66A9@CH2PR12MB3655.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EzYF2mFoJvGfTlwj22/uc9XqD27Ekm95Ee/3o7bpidEXVPGdEijy+N9avsY4XTBsdupJQUGYKB/M4RgwTp7zqhfqIIpCf5vHQl7ihOKv99RehfAsBjax/kzAOsdlEDfW4leamdiP1DyoxGgb9w0adqvrK9peDAAlyIfoDL6r6mYj5CWvCdpAlXtwhL53KC4hnHe9Gb0+v44QaSOVE+0Bn0hXUnBQ50VeXtIxb5VM2/fndHp5GeUkhxSf7OYvPmxkaTEBgvVH8yUTHKHRA6B4aJxNnQe2JfWc3T6/lQqe9MNrRnXDsfuE4QRHrJYE3HnFr98I1yk3FUSO9SjzewkD/9BH+kptapdpsZZ4hs5mytjZlSxmerD+XQWbtswr5Zw+fzoa5g9vVKuLn4kCC/q06ynLG17Q4413ga9rVlLv1Oq3CYCRJQyaAgeJoBamAapCJHqlgSfY5T8ltLp7Bctw5w9rKyb9fEF+82aEdz7FWtg/2udJRBQe3iP4rxvm+Zah29auwJpnOWXDXHqtuh4hJrq/xl84eGOqyYP/fssNAR7A02LfdbPK3HB1b6HFYfbN7CcuiuZ/oPwQUtjg5TiqJAK0Fl5sJ2ANkQReCvsM89g7z4he0PAna81QF+Qgz1chh7VfMqjOAHk72dWRLVh5DwIlP7UwDV4DB8HNrOSMCUjl6ef07mfMappoqwfe/3dp
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(346002)(376002)(46966006)(36840700001)(356005)(336012)(36906005)(26005)(36756003)(2616005)(7636003)(83380400001)(2906002)(316002)(86362001)(70586007)(70206006)(34020700004)(82310400003)(110136005)(478600001)(5660300002)(4744005)(16526019)(426003)(47076005)(6666004)(8676002)(54906003)(82740400003)(4326008)(8936002)(36860700001)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 12:25:32.6439
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1603fcf-176b-4648-7020-08d8e93fc26d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3655
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the comment cited below, batch mode neglects to set the global
variable batch_mode to a non-zero value. Netns and VRF commands use this
variable, and break in batch mode. Fix by setting the value again.

Fixes: 1d9a81b8c9f3 ("Unify batch processing across tools")
Reported-by: Tim Rice <trice@posteo.net>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 ip/ip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/ip/ip.c b/ip/ip.c
index 40d2998ae60b..2d7d0d327734 100644
--- a/ip/ip.c
+++ b/ip/ip.c
@@ -155,6 +155,7 @@ static int batch(const char *name)
 		return EXIT_FAILURE;
 	}
 
+	batch_mode = 1;
 	ret = do_batch(name, force, ip_batch_cmd, &orig_family);
 
 	rtnl_close(&rth);
-- 
2.26.2

