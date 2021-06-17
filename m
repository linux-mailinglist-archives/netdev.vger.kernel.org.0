Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 002B63AB7CC
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 17:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233468AbhFQPp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 11:45:29 -0400
Received: from mail-dm6nam12on2062.outbound.protection.outlook.com ([40.107.243.62]:23393
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229584AbhFQPpU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 11:45:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L/CvukUqYw+wW6rvwqG1Dny5xXHAuI6nAqfIs/A871ZkylzR01L8wUcbfAcLrMisxlXHVQ/Btdhr40cNb4ToJXw1KKeJF86Q+TFgf1h4eNPULeAaRyZYgw4+ppEG03cK6rSuu5gXQucq6yH6ziRf6PN4a+UdQtPnRnG/XiW9esaOlgLEIbPQo8Qs2wcV/0zbITNvq4i3hPb8c/eMFnDPstR/uoweMDkRz5SLk6pyB2YIlGrVCS7A+5LfXl73zNUG533iA8/eoCWNLCyGYzLb22m3NbdjPYLgHfHl7D6tGcUkgH+BpDPsQ+dQGdhP0onFLfIVO7x5ug/ACp04D9Eqtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wTGqTfIIVM9ukZZR8FajPrtV1pwBPuYi9RftBaxXuI0=;
 b=W/AxWn7WJF16wO6+fS1qItckSse7zcOUZjoflZyLEQgbw7G6Gh1WUUJyS4rq3xyLgxlS44YpwP4O8VYF4JDOOIwSAsPEtqonXX6AsGStJ6Di+GF15QDfa2TxXuJJ6n7sH9+Jm69hDL5oxiPUlBLuVAqrMn+8pdVJckhHSny20Q6kkia131rdi2UAWHYTc8UlkTJX6qJtNA0OB1TL39xL5qd6C8g2dc7MkOegv5DOgO/7FDB0VANU1nqLX5UQkjnhxAhyGRq4ez6Cx1vGPg+DKiv8AnAiif+wDq+ELAvr9hB7vCdyJjQENI5xIjts8XIcBAOe7FL2s2AdlMctjYuORg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wTGqTfIIVM9ukZZR8FajPrtV1pwBPuYi9RftBaxXuI0=;
 b=T/JDNM1niFjND10nWTV9eyxSVblaeIZCbVcd5RcgHObryf+K4YpM/Yx/nead7O30C6Y7BmRteTiX1n5skeEyjGa/EJ4kOEQTCVse64R/c65pomX3N5xRxHFt+s/JxPWxL6JgoL+ys82+S7kzmoEE9B4Qh9I1WGfvWobQjtKUEzRs6LBL+iMPLwwrnA9Hlz/tQs0wA+kYf6tjFiBwXs3ft1AvdEjUAgYAJiB+jyaWOOnFeOCWcNOe+X49nvCf4Wql0w6mxewsDSGSHluoxjruzHNAxEsSGzkk+HK2KEPIctPUODafpNSrGeOdacX0ly+pAEJ/nvnGHbD87cJcANhFYw==
Received: from MWHPR14CA0007.namprd14.prod.outlook.com (2603:10b6:300:ae::17)
 by BN6PR12MB1330.namprd12.prod.outlook.com (2603:10b6:404:1e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.25; Thu, 17 Jun
 2021 15:43:11 +0000
Received: from CO1NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ae:cafe::a6) by MWHPR14CA0007.outlook.office365.com
 (2603:10b6:300:ae::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend
 Transport; Thu, 17 Jun 2021 15:43:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT057.mail.protection.outlook.com (10.13.174.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4242.16 via Frontend Transport; Thu, 17 Jun 2021 15:43:11 +0000
Received: from dev-r-vrt-155.mtr.labs.mlnx (172.20.187.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 17 Jun 2021 15:43:09 +0000
From:   Amit Cohen <amcohen@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <mkubecek@suse.cz>,
        <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net] ethtool: strset: Fix reply_size value
Date:   Thu, 17 Jun 2021 18:42:52 +0300
Message-ID: <20210617154252.688724-1-amcohen@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 63edb737-3917-4ea3-07ad-08d931a69cc6
X-MS-TrafficTypeDiagnostic: BN6PR12MB1330:
X-Microsoft-Antispam-PRVS: <BN6PR12MB1330739855C9F1FF839C5DE7CB0E9@BN6PR12MB1330.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:639;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WhDLbjuFlYJkj7GUM0+0vtnVYJ7ux//CMafZpj2/WEQeC3AonqJmR7/BS8uT9qGSBJFT2CaO1ujd9bG5oZT80dSEwb3vWNP8+2PmwQr46W2GL+GeSaTRHsR28XvfiQPmUwcJkXiiKIbq3Ey4cgyiyZHDUx87sCHEP3F3JRqVFWRyuetyJkXLK5niSe9i/qvIxaxkNvbuhtQk8c1r+pG2NV6oqwRl46bEGHyxNYu78EkwHGoegH8Foekict6jM9QtVcVx/va+OM07tZ28p/v42qLOnQli8YmplGg8jhXw0tvyVoTUaQMkmJ09CVNs6Kx/WvreW7/erw7wzPWRWHNdJAsYsXtBjJUAgoxuk/xZc3ztLVDQo0KogT5d4KSgaSVb3rTQANkaPDW2UXZtTIjTaAKl3ur5+pLSUK+Qnc0tfpOyRlupfHwH2DvKIjuXk0jRLByUOmoLQ0LeOg4ogKtKw6htpxm5w1/niwSVBWmKnu6EpcMOwZXDTB+cZ1LjSP+Lpa3VgXKERKpcAQ1ZiDWYXVN+XQlWJe7BSIUacG/vLnPxkN7CnDe/mc3MnzovO4+o3zbOrrwYowjcrnVJoe1stcRM1Q9pxfYSOxHHeOvADwVIp97Ltov532izAK4NfuO/bCrOqSqu4LGYOJSAUTpDNYYyUd3JC8pGacMgE6VGHBY=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(396003)(39860400002)(36840700001)(46966006)(36756003)(16526019)(47076005)(54906003)(5660300002)(86362001)(6916009)(36906005)(83380400001)(82310400003)(107886003)(7636003)(356005)(316002)(186003)(336012)(1076003)(8676002)(426003)(2906002)(70586007)(70206006)(2616005)(478600001)(4326008)(26005)(6666004)(8936002)(36860700001)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2021 15:43:11.2572
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 63edb737-3917-4ea3-07ad-08d931a69cc6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1330
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

strset_reply_size() does not take into account the size required for the
'ETHTOOL_A_STRSET_STRINGSETS' nested attribute.
Since commit 4d1fb7cde0cc ("ethtool: add a stricter length check") this
results in the following warning in the kernel log:

ethnl cmd 1: calculated reply length 2236, but consumed 2240
WARNING: CPU: 2 PID: 30549 at net/ethtool/netlink.c:360 ethnl_default_doit+0x29f/0x310

Add the appropriate size to the calculation.

Fixes: 71921690f974 ("ethtool: provide string sets with STRSET_GET request")
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ethtool/strset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index b3029fff715d..86dcb6b099b3 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -365,7 +365,7 @@ static int strset_reply_size(const struct ethnl_req_info *req_base,
 		len += ret;
 	}
 
-	return len;
+	return nla_total_size(len);
 }
 
 /* fill one string into reply */
-- 
2.31.1

