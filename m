Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA11494A29
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 09:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237909AbiATI6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 03:58:30 -0500
Received: from mail-mw2nam10on2074.outbound.protection.outlook.com ([40.107.94.74]:64928
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235280AbiATI61 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 03:58:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ime30YNqiByuTkhablhpvWczoiqEut1Vzoy1YXikkdagLHng6ycCkh8Xgh7ioBbejs+3Srfs3FCdin1wfeoFifTJ8SiEkUsxvlpymScUoIgMiLo/YD7T9b/h6wSIkyHhrsB0mC6KFo9TBh/PvHR5DnLf1tEt8kPXnO6Q+4TfIck1BCcSP6XW5faj4OQt/GBMIQmNrEr87BRQSmaP08ntDvKtCwiQeXvlCy7RQJmWceVANfusN2WVwR0H6Ehppp+m2GVO6TgrXXACtg2O0VMfdR/T7Ksaa7TQyO8o/hHDkU8gjDc/a7f8KcBRtpVHcPewWrhD2nwsr76Y8cQaegALmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y4hy1mUrd3KoCP8dnVX2t8bL3Csst6EmhzKsgebLHIM=;
 b=JdmiPpdUA6UPtnnItfm1uAVynZbpI+5TC5Nn1mjqRnIpjHHg7A8DsAPYEd9WyoVJGX3HybMfy2okq4He+OIJl2GADddqHXYj0Tl3PerVrPeVD/a6bQpxY3qdGwaMLyoiZ2AQ4LsqAjZyJMKEyRATkB4jGU3eaQdmm3Sy8yoWUq8Q+2ItlodvB+Oh+vehsosgRIcdzOu0cN1gvSLZnD/vIFMEXeWQeM1dFcGIVXwc3kzllrYUHUTijYH8T7ugwqu7iY577HXV6AQ4yhoVScVuDERFDyr2ZTNwpMDU9MxN6LM2t7zo51i/t7bSNqkvDAmE8ZDs1YvV5cbTXz+EZNejGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y4hy1mUrd3KoCP8dnVX2t8bL3Csst6EmhzKsgebLHIM=;
 b=CMBIYJ2/kTgGenWBRNPSv0FNFf3YMjHOemoJlsSn0EVi+beGIjhvlj/TlhusYkcRNG3Qz8hq2EnT++qO4lZwVAA4SXenbTpA5gRqJdK+3bjZ8oHTsDL6rVVPVbRb0PJuEwTIH7sQSncaleBgQOuPE38AEXiXBYMkdV5aJhz0hDulxxBxYPL8J1NclzNkEbVHaNq24/qbeYbSTIYAXB7S61GMOpUV1rcLo7gRidSG4+1Tdxymx3gRwQZRatrYvDF5pV+jJsY8X8WKxmJ0R3hzE4/yPJjBSboy3u8QA4Vp+7SBRZH6C4fD1maZWVJt70meVG1akj1LurznVoHNt28XnA==
Received: from BN6PR1401CA0017.namprd14.prod.outlook.com
 (2603:10b6:405:4b::27) by DM6PR12MB3770.namprd12.prod.outlook.com
 (2603:10b6:5:1c4::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Thu, 20 Jan
 2022 08:58:24 +0000
Received: from BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4b:cafe::99) by BN6PR1401CA0017.outlook.office365.com
 (2603:10b6:405:4b::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8 via Frontend
 Transport; Thu, 20 Jan 2022 08:58:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT062.mail.protection.outlook.com (10.13.177.34) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Thu, 20 Jan 2022 08:58:23 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 20 Jan
 2022 08:58:23 +0000
Received: from yaviefel.vdiclient.nvidia.com (10.127.8.13) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Thu, 20 Jan 2022 00:58:21 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Petr Machata <petrm@nvidia.com>,
        "Maksym Yaremchuk" <maksymy@nvidia.com>
Subject: [PATCH iproute2 v2] dcb: app: Add missing "dcb app show dev X default-prio"
Date:   Thu, 20 Jan 2022 09:57:54 +0100
Message-ID: <f83e5480816bb050ff9005409ae2ae64b44d52de.1642668290.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.127.8.13]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe3fdef8-c49e-41ae-ddd3-08d9dbf3040b
X-MS-TrafficTypeDiagnostic: DM6PR12MB3770:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB37700107E4DD5FE053242042D65A9@DM6PR12MB3770.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6BC/y8Mf33K5Qg9UmV6PHRV+53y011QsCx7ZDKZYGP63h7pWBBtQJSm3/2aslqIwizYzKVG/U0lLIu+yvrKsfJredv756BwP9sVhrtj2fm+0qPn20XPRnkixHLPAHRi8K9JrhcSXueyToRzWUKoATbZc65iTlbyErl9RphtEvcnjyHRJx8IL55kgABI16x3iv5SVAj2vXv/MNRRenaXfVMb1odfanm0ffovpkn+PYTfdmA6WozeUzaWiU+vYXvAsdVQXwTvi0nWox8R8oqpDEHpfBH5ZXhwllP9cIgnrbO5veQeBBihqEvzXIq89iCoH0Rr+U9eZET3skerULOO38KdkqJcyO0neVB2wleen2jCUvCR+82NGis1++PXpLFDGvnQYE5WIIrgkJ9bdZ2R5hXLopPZSc9DJxH+aNnj9VtkVClD/KsdovZ2ZTlFDkZpxhr5gYbAkKOpLljMfvXYgXqKg2MG3GLkYztJMQQG/ErWcRqyu6VJbSWLuH9eRliyY1fM2Gh6lU6rIi+jhmI3QsCx0saMLuddiloWwVJlvk61UOBwkttpGFAcZrryXctyiCuLWZZNWMZprv7VcSwSYErwj//kXVbts+0sTqcNGPvAfsyVywGDjlA+7flGI+xGcUZ5uYmCPTJ30UKVE9CI9mtVT1pQ4K1EuTMi8xI6tqyq2rwL8VAtAquW76BLRV8oYWYOUCWUYtzz95iTJkro77loNNkVgwzS/BX0SUoQkN94b7pzvvgV4qeVj7BL9xanoLsjX7dCV+jj1jKhy9y2Ztgf5PWTAthFE4mdpgXdlv88=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(40470700002)(36840700001)(426003)(2906002)(16526019)(508600001)(356005)(54906003)(47076005)(5660300002)(8936002)(6666004)(81166007)(186003)(36756003)(4326008)(316002)(336012)(70586007)(82310400004)(70206006)(2616005)(8676002)(36860700001)(7696005)(4744005)(6916009)(107886003)(40460700001)(86362001)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2022 08:58:23.9339
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fe3fdef8-c49e-41ae-ddd3-08d9dbf3040b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3770
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All the actual code exists, but we neglect to recognize "default-prio" as a
CLI key for selection of what to show.

Reported-by: Maksym Yaremchuk <maksymy@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 dcb/dcb_app.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
index 28f40614..dad34554 100644
--- a/dcb/dcb_app.c
+++ b/dcb/dcb_app.c
@@ -654,6 +654,8 @@ static int dcb_cmd_app_show(struct dcb *dcb, const char *dev, int argc, char **a
 			dcb_app_print_dgram_port_prio(&tab);
 		} else if (matches(*argv, "port-prio") == 0) {
 			dcb_app_print_port_prio(&tab);
+		} else if (matches(*argv, "default-prio") == 0) {
+			dcb_app_print_default_prio(&tab);
 		} else {
 			fprintf(stderr, "What is \"%s\"?\n", *argv);
 			dcb_app_help_show_flush();
-- 
2.31.1

