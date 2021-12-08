Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9C3A46CE0A
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 08:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240476AbhLHHHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 02:07:12 -0500
Received: from mail-dm6nam11on2054.outbound.protection.outlook.com ([40.107.223.54]:60097
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231351AbhLHHHM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 02:07:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aR4ANdXKcsDeJI4YGczMKhcNMlcjFcOonA7Q5RXw/oHyPSqKWbXJEiLSsT0mgNyHH6U/3hsZBmp2FYoGNv4BY+qlkVJb2ytQS2MWvtC8iIhhFneQs4NuZBFr5F6I/FYqDoakGg4QZuwDtFdyhglj8dbPavK0qMMxjGeJBsF5kU62kX2jp2td9c3XvJe+wotE7z1sIEUk8ld4TmlbXHGj1jnPPEmuMKHyw3gdimIyGL9TR0SegLZp2Lfkd/oDDp27o55xH8jVkD5XyyNpCX/EM2KdV57hVvI0xuOMwLM+56IwcIwKBXPAfx64EcNPQLgJHMpp6GLMI3OwvOJGtNCKGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7zQ+hyuvTF6x2pdOAcM2eMfrvDp79gr28tTJrN51BOA=;
 b=RJsJ99r+9VpJYF8ryeaPY+VUIUQCP/xg9i5XxSFBssIKQpxaNw6XB1RQ1TNFQO20MR1siBBnpMkspzYf/o2kiKFoL7+sX2+dCeO6JZMbvNfs1mZKTVBdgAzVEiU7ATskGZq6gIB62oVLSVzGAGwmI8O5luoRYV9gkwDgYi2hNeDbwJZ3VeOOEg7m4imFJ5M4KY3A2fsy7VTF6f8hhKtdMI5odfF9G8XbKLOi7MaBvaZ8ABvJRaHMmyyWnCy7zsPmf0uuLGch+ShKEd5QUhkqT6Bz99xKzUbQqY12fIBUsCe9zEtBDR8UFWyVexz1oc+0w3CZmNMpUexYA/66xhnNQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.12) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7zQ+hyuvTF6x2pdOAcM2eMfrvDp79gr28tTJrN51BOA=;
 b=ZHq7qC4c0xWXBmXbmqt5epgGdFL7ORN9j9iDPbDm3Zi0STxmLJyXH2L6WQaEVsxq5y6nplYYR+ZJLXoijr0RTkbzTz4sscXy3XDcio2S0IlzzJmOUGkmLN2cNNKF9L/FRceIBFloCbdJSy8FLCPta75ZQ/UKVGJvhJxZl7WH4XhVxvH8/MPTeIyYklEqDISd/CP3qcVrwbZFSrEqZ+iU+ILXOXh1JbDf032016u7EE/w7CBVQu/1o4qMlOaVhMNOkW5uzFsGXeomLQ63FYV6TIndlOVLldf2PqA0QS7q1IGbDcoWwB34mYama2SSVoBrseBRmpHWXBSa5E4lcs14oA==
Received: from DM6PR14CA0061.namprd14.prod.outlook.com (2603:10b6:5:18f::38)
 by DM6PR12MB3305.namprd12.prod.outlook.com (2603:10b6:5:189::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Wed, 8 Dec
 2021 07:03:39 +0000
Received: from DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:18f:cafe::66) by DM6PR14CA0061.outlook.office365.com
 (2603:10b6:5:18f::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.14 via Frontend
 Transport; Wed, 8 Dec 2021 07:03:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.12)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.12 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.12; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.12) by
 DM6NAM11FT064.mail.protection.outlook.com (10.13.172.234) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Wed, 8 Dec 2021 07:03:39 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 8 Dec
 2021 07:03:37 +0000
Received: from nps-server-23.mtl.labs.mlnx (172.20.187.5) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Tue, 7 Dec 2021 23:03:33 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <jiri@nvidia.com>, <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next v2 5/6] devlink: Clarifies max_macs generic devlink param
Date:   Wed, 8 Dec 2021 09:03:20 +0200
Message-ID: <20211208070320.13247-1-shayd@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed15df1a-a7c5-49cd-e24d-08d9ba18dcb7
X-MS-TrafficTypeDiagnostic: DM6PR12MB3305:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB33055F6481624F11CB54C7C5CF6F9@DM6PR12MB3305.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wPCVKafw0Mwxk63xcpa8jKRpymREnaP5yZMknZ/STegoWiOgnnjeQfnrUDgvcoHUgjO+NcCcU8qHHkRCEDfvRYzCeIeg3rC0xPT0/rASwMq6+62eTXUyAldmvDnNvAY/dJbfR1njuGWL1ZiKEp53XF6XRwwz0mBvoN/eoi6dA2y8+cAttQ3DLZfwNiuzutjxhWOu4ryfsAgk+dEa0CXAHlS4aAoyAYCnU7vNUiZLlmyX/2JvbnVvoJZyFCqO0LRt32U7fNkGB8944/y/1NW2sQ3z7mA3k5RyzetkldIuhccGNvVJYLPAI4Gr9I3BXt15TC60df85AoM4wUKf43Vha89nDLi6nStS3+NjX7uBsjDr8MgGqMnsmRIlL3wiqAFzl2adPJSO7kbHCon+XDKZtF1no56dBlrBrFnnHMAkSrn5Gdr8+DetGagpqMQbmf/9vwobvhVHTFEgC+zpq84fiq02lOaMcsH3DSFvyLeXQ6EKfew++lvmwuhyl8NxNMcUVTuMHeX08bXPYi+RsdFnTV0olOAPl+RdLYwhl0wUQ+xrxiiVcLItyLPsuXbmEIqfYgqZE4QLhuyRgbyRfjGCP3m63dpYcP8nDtYVJ1YkYqINfA3uTEoqiXpdpbc9UvHjQV3lL3BzvNjyTMJAYsuzDme+6PSUH5C4ci8T6ctwg3/cUBJgfXtUEqZNS9RrqZaOsSdUJWVrsRdOWw9hsBV9kCMpR91Zh2m4nHLMVaMV2LVY6wpOM2xAqfBKQALCrElf0+c14YFAx2SJXjQ77dvl49mtIYT4Jy9xQipu80Q7XPsvqYr9q+lZ1EheZ76DtHt44vFomTOmaODSBfa5ARZHPw==
X-Forefront-Antispam-Report: CIP:203.18.50.12;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(336012)(110136005)(54906003)(316002)(36860700001)(36756003)(107886003)(40460700001)(82310400004)(1076003)(8936002)(70206006)(70586007)(8676002)(6666004)(426003)(2616005)(86362001)(2906002)(5660300002)(4326008)(16526019)(186003)(7636003)(34070700002)(508600001)(47076005)(356005)(83380400001)(26005)(41533002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 07:03:39.0280
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed15df1a-a7c5-49cd-e24d-08d9ba18dcb7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.12];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3305
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The generic param max_macs documentation isn't clear.
Replace it with a more descriptive documentation

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 Documentation/networking/devlink/devlink-params.rst | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
index 0eddee6e66f3..2cbdce4e6a1f 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -118,8 +118,10 @@ own name.
        errors.
    * - ``max_macs``
      - u32
-     - Specifies the maximum number of MAC addresses per ethernet port of
-       this device.
+     - Typically macvlan, vlan net devices mac are also programmed in their
+       parent netdevice's Function rx filter. This parameter limit the
+       maximum number of unicast mac address filters to receive traffic from
+       per ethernet port of this device.
    * - ``region_snapshot_enable``
      - Boolean
      - Enable capture of ``devlink-region`` snapshots.
-- 
2.21.3

