Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA933F1559
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 10:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237127AbhHSInZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 04:43:25 -0400
Received: from mail-dm6nam08on2056.outbound.protection.outlook.com ([40.107.102.56]:57697
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229869AbhHSInU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 04:43:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xp+8kvXSbDz1rFQkSoK9ZrSNBMVuC6KqgaoAOGg5atf1bOhsO9QhqQnd85A+PVESLJCBvDMfkqSFMhbf+fVzRFqQOzFYmVzuZTq5zJYAbJ+HfuZ09q+lFVGQCvx+7eE/hRfnodqfZLpbcpIB5D/dLg9TOJJAiyMDZj2FC+rQG8jD43jRYzFnFJ8cR5YskENEeX4aah2efw/IjAZox6bIohp7hClKSCfO4GxhK23swKe/oiuRfKXEwREZH0XQSqF8VKIWHdegOj9PgVI3nAslhbIs9HBhmcAnWUJAs7APs2dW+b/qsVBVov1VqOQAewArI5mXR5en1ggWHsD8eZ/1BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sRDnv16PJev7PxNDrk2mKEKcd2VQ4n7MSrXbsaC+5Ys=;
 b=dGIvlonN6QIB7NZAKtFFLnQobInYCayuh0/flXecyImH1jQlCZQvgaOQEWve0/krApEHbxiWFp0ExGVFMqRrzRy9JM5vDjLVs4QW+8AbGfv4yXYXmPx7I3FosRDAf07nd9YZqyahlyzGOWzLaSi088RISF6+aGcMj1FXERU2+sjLtQW+uvv1fr8eJTnOpQSPo5yqXGxWx9XFa4QU6yC2UQvvfVVgbA1a9tFgkkyraV6ibaq4uGDiJxW0RkgwHzgyEmR0+xohH9H/VzzJ6v5Th32ygbOepFhkTehUSF9vDd44EwB3UAVOozuzStsqiJRDacN7sbs+flZfAoI82Tt+Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=lwn.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sRDnv16PJev7PxNDrk2mKEKcd2VQ4n7MSrXbsaC+5Ys=;
 b=Uy6syuPjX+aW6CKmF2Ufd9PhkkAMDGjCuolyeVERSsI/a63bWsv2b5W7ZD9NQOwKsv45lU/C9MTRuEVs+vRLNBsE8eBxQExyIw2zqkEgBkZw4s0BWVYWd+wu6j/1swFF6wY5UsF6BSzMe3AkiJAD5a5iNSoYSzCorpLM5iWU0WcsBUQJxzf3r/VxzUrtWvuzyg7W6RUfd/v+BsEnVCDEYIB6BIMGYWbBiYh24PHP4t1dSeUojenCbuKwW8EWL7bB+kYWr4UfX0dd+ABUY3C3Abt44DC2Z65gTdeaWJaGfinZvegQTyXw6boIjXoS2gUvthchqMY2DaXyPZE3jevz8A==
Received: from DM5PR06CA0068.namprd06.prod.outlook.com (2603:10b6:3:37::30) by
 BN6PR1201MB2546.namprd12.prod.outlook.com (2603:10b6:404:b0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.19; Thu, 19 Aug
 2021 08:42:43 +0000
Received: from DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:37:cafe::de) by DM5PR06CA0068.outlook.office365.com
 (2603:10b6:3:37::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Thu, 19 Aug 2021 08:42:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; lwn.net; dkim=none (message not signed)
 header.d=none;lwn.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT021.mail.protection.outlook.com (10.13.173.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Thu, 19 Aug 2021 08:42:42 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 19 Aug
 2021 08:42:42 +0000
Received: from d3.nvidia.com (172.20.187.5) by mail.nvidia.com (172.20.187.10)
 with Microsoft SMTP Server id 15.0.1497.2 via Frontend Transport; Thu, 19 Aug
 2021 08:42:41 +0000
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     David Ahern <dsahern@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
Subject: [PATCH net-next] doc: Document unexpected tcp_l3mdev_accept=1 behavior
Date:   Thu, 19 Aug 2021 17:38:54 +0900
Message-ID: <20210819083854.156996-1-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 42ff079a-d112-4382-2dc6-08d962ed4f65
X-MS-TrafficTypeDiagnostic: BN6PR1201MB2546:
X-Microsoft-Antispam-PRVS: <BN6PR1201MB2546C35C76989DF4A11763A9B0C09@BN6PR1201MB2546.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JuApuU7H8bunIrgUzb+6w5q/rBvaC/9/TCs3I7qobSIibW4DrOM55XHONntGbSEV+ZD50qNJVkbxLUBvEysX72kCem0MFvlK7WFuD0bRe7+rmLzWgP/4AdDAH5g18aB7KVjM+j8v6+7U+dOsY5khL5oEz1FhkfggnrgJfayXEFpSUAYFQGNZOLlAFJYebw92FWRZX1b60z414eMCz6a1q8t9TZ8U2f2BPPV9uuLmH5J5iiy6pxt0VS6dQYjEcKxnJBPUwB4WQIU+lJtVBRcgZrI6Ugiy6/NsvuPGKHLVl2x3ezwZ8FOmQekqVTXep/KzPY4mvtwFBj0xyaOzqq7cujAihqwTwb110k+tMc1nTjjgiUMm3xGG/QW6I2976LCwyS03QESaYXR/ta/uEyHQCTjWnJ16aFMo6dOqFXEYqaj9nr2SVkfCRz2b37ufoX90jCQklQKhFphI95il/+TSDpIOAVBI8pO9UGv/OC5cHXKjf2iRgtUx47vYQmzoCFlftYK8kviBzXfGa08h41s+NBYwcnQShY33QVc+3ffAOEPW1VwOD6fAd/bFFxxPVRS7ZUQsdJOjtsEM8K6wKsogxRpUa7bh8yi4FkiCAx9CfzcZLR9+ziyqjFRXmzEpdVKIJKOqh8Koo8vKzAHI2eskXME412BoRqKLShi1T4CHUIL6nnQWjexdHswBxWtsrfYZ1lphvC5RyTwfHDfCW7Cmig==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(376002)(39860400002)(46966006)(36840700001)(2906002)(6916009)(26005)(186003)(8936002)(6666004)(2616005)(86362001)(5660300002)(478600001)(47076005)(426003)(7696005)(82310400003)(54906003)(70206006)(70586007)(336012)(316002)(83380400001)(1076003)(36756003)(82740400003)(7636003)(356005)(4326008)(36860700001)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 08:42:42.7368
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 42ff079a-d112-4382-2dc6-08d962ed4f65
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB2546
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As suggested by David, document a somewhat unexpected behavior that results
from net.ipv4.tcp_l3mdev_accept=1. This behavior was encountered while
debugging FRR, a VRF-aware application, on a system which used
net.ipv4.tcp_l3mdev_accept=1 and where TCP connections for BGP with MD5
keys were failing to establish.

Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 Documentation/networking/vrf.rst | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/networking/vrf.rst b/Documentation/networking/vrf.rst
index 0dde145043bc..0a9a6f968cb9 100644
--- a/Documentation/networking/vrf.rst
+++ b/Documentation/networking/vrf.rst
@@ -144,6 +144,19 @@ default VRF are only handled by a socket not bound to any VRF::
 netfilter rules on the VRF device can be used to limit access to services
 running in the default VRF context as well.
 
+Using VRF-aware applications (applications which simultaneously create sockets
+outside and inside VRFs) in conjunction with ``net.ipv4.tcp_l3mdev_accept=1``
+is possible but may lead to problems in some situations. With that sysctl
+value, it is unspecified which listening socket will be selected to handle
+connections for VRF traffic; ie. either a socket bound to the VRF or an unbound
+socket may be used to accept new connections from a VRF. This somewhat
+unexpected behavior can lead to problems if sockets are configured with extra
+options (ex. TCP MD5 keys) with the expectation that VRF traffic will
+exclusively be handled by sockets bound to VRFs, as would be the case with
+``net.ipv4.tcp_l3mdev_accept=0``. Finally and as a reminder, regardless of
+which listening socket is selected, established sockets will be created in the
+VRF based on the ingress interface, as documented earlier.
+
 --------------------------------------------------------------------------------
 
 Using iproute2 for VRFs
-- 
2.32.0

