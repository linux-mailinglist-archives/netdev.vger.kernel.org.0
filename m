Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46ECA392137
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 22:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234582AbhEZUCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 16:02:22 -0400
Received: from mail-bn7nam10on2041.outbound.protection.outlook.com ([40.107.92.41]:31969
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234459AbhEZUCU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 16:02:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lwQi60CL4R0h86KfagQ+XPU/4/bscgkhewBGC9/WNh4U5oZPyIUTwMcCLK+78qmLnTutubMlhMNXqbkXV54G55v1/gcULrLQWbGScCpc8RoN60+Qp43HTJBAQwNaLeJ4GFe0EUI+Bypurs9f/JHQ3608a0SSPBkfab1WdFD/PdwYZMlexJQsoAnKF/F3c1Z5dWr/21FH9Q40ug7SNUkI6NgABxDVtYV7qwj7goHTitdsgkbt8ZlApm6SYPLl6I83uFN4hlPQNCxfBEqNqXFAdGLV1wSqvwLpgxVFl0iu0X+nhf8nGRJUhXkGpsKoQous5nQbWplrUyAWVdiV2oRRFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aFqLWH6trbOC6/wVuarx2IfICO7c1JXHdzYR5/6ThdU=;
 b=bihP8QzQKRj7i9asItkRenLDhaudSWOjNmxLTy45uDzsycNxSt8JYIxUpFQo7eVh7o1Uj5VTrbln4JIGtbU8t0J0yDF7IxKkITdjuZPEi+sDBFg6OrHdVvl9xKLYXoG7tRumRQmDyW4UM0IHgMeueLc21WGFt7odVl5v9IzfUlOrEvjEpdCCKxg0s/7eDlUzZjR4IES4ZgYZ/6OoLbrbg6oJqSjDg65U2egmhP7iMPDZWYeSOoiPAiRt4UBAIg3Xseg87bFWDUAzsR1cfbryit4yZWA8sR26kLQoylSfbr4UkWNMqYS0USu7B7cOBeYEvUVrX3jLHE8guvcNBBBdmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aFqLWH6trbOC6/wVuarx2IfICO7c1JXHdzYR5/6ThdU=;
 b=kxkXHCOLDslcxBwh0Nwu7VapjYtTul8orPkE9bS3EwXkwB1a4Dc0SSnNI3ADsLJUrk8Grx1Jzt/GxgsmZu9h7U2lD1psB2D5gmHXC8BGm2ec6lcjfWv7+ozYfuS4thZ+7VQMA0GO0xhWTQXULvrIYmkVSbPhANXFW28xFcvGQcgjsSgUK+ex/1PzIYSmipSZdtaLmWXGD1JoMRpSuKs5jFOFh3HQ0UcuVz0KPAVUahzEHIND7+E1JgE3XdlUhnDx9rTX9sbcKjJdJdZRf8Cc7vVPwiqxb/gI1n1IYCC1U8Fp/GR2AOk4KUb79td7UUkWmuo4ALytUf58C5TcmAD48Q==
Received: from BN0PR04CA0142.namprd04.prod.outlook.com (2603:10b6:408:ed::27)
 by SJ0PR12MB5421.namprd12.prod.outlook.com (2603:10b6:a03:3bb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Wed, 26 May
 2021 20:00:47 +0000
Received: from BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ed:cafe::35) by BN0PR04CA0142.outlook.office365.com
 (2603:10b6:408:ed::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Wed, 26 May 2021 20:00:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT059.mail.protection.outlook.com (10.13.177.120) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 26 May 2021 20:00:46 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 20:00:45 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <saeedm@nvidia.com>, <roid@nvidia.com>,
        Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net] devlink: Correct VIRTUAL port to not have phys_port attributes
Date:   Wed, 26 May 2021 23:00:27 +0300
Message-ID: <20210526200027.14008-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d8f7972-7154-471a-c737-08d92080f3f6
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5421:
X-Microsoft-Antispam-PRVS: <SJ0PR12MB542139E80748188B7238BDF9DC249@SJ0PR12MB5421.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0p0GRrRX/M4dlMRczn39hqtjZbEmUtC42f1CXcNkim+0DLrR7UzUvumd0e8hwNHxdY0cV2BwqsBVL3K5KgB1qbrlnjdP7aqMV9REwg329oXcDDCG6NulNEcVYHDGoJypJPcimPlhuV/p1WHVe1sWT+cDpbWiK3Wo2n4fB5DFOZAEi4KGydM1ohVFEuTiz5peyn3pb7kaaLTKvA9nmSqT0tcxraZMjkukMu2qrfvfGzGQNU33Z1kMxdiu7W80wIdrl4NDZHHN4Q0wr952zjvsoJ941ENtdRJpQMz3hfJ41C57eeK/nbttvQrtauDDfVnOavk9r8jvH7pByEKpGHrXxMEVzYkKC+fU9f4e7YvV4SK/QGU54iORxEKehSO2WDpH8gaGHfcgd+bQftN3iWM4aM1PQ/X9wb6a4Wjnit9A/A4noHnAoeB5TvQTzHyuPZWvyNPRX+ytIUivKmBEqMnQU+r8qfqNcbXpnZk1KoR5lHM0iZG/jiT8IdxnLh0XktFZ+mrCVCSSlBQVhUduqZvcMrnzfQW0SU7Kb7SEzKmr/mq+tJVXf5HNUz7BYC45BggWd501kbQbThSZTMIjpaxyFrwqsiuzKVjkvL71A+FBznN42FE+cAKmlaU/xPDJtYfwodvcanM187yBVE+ewu3nNK+KjSp1dfurzUoZd5jdU/RW0yD7nd7v1MV/wSlHCq/WPdvQy1Pqyzw0TL7NRTOyILJhT2T79TizKz3vbJEgXClfxGBYc5LrJ7DFzaqyf8weslZvCR4X10xNIgF808pNLA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(346002)(136003)(36840700001)(46966006)(478600001)(336012)(426003)(36906005)(966005)(8936002)(356005)(4326008)(107886003)(186003)(6666004)(36860700001)(47076005)(316002)(2616005)(5660300002)(16526019)(54906003)(83380400001)(86362001)(70206006)(82310400003)(8676002)(110136005)(2906002)(1076003)(7636003)(36756003)(70586007)(26005)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 20:00:46.8715
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d8f7972-7154-471a-c737-08d92080f3f6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5421
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Physical port name, port number attributes do not belong to virtual port
flavour. When VF or SF virtual ports are registered they incorrectly
append "np0" string in the netdevice name of the VF/SF.

Before this fix, VF netdevice name were ens2f0np0v0, ens2f0np0v1 for VF
0 and 1 respectively.

After the fix, they are ens2f0v0, ens2f0v1.

With this fix, reading /sys/class/net/ens2f0v0/phys_port_name returns
-EOPNOTSUPP.

Also devlink port show example for 2 VFs on one PF to ensure that any
physical port attributes are not exposed.

$ devlink port show
pci/0000:06:00.0/65535: type eth netdev ens2f0np0 flavour physical port 0 splittable false
pci/0000:06:00.3/196608: type eth netdev ens2f0v0 flavour virtual splittable false
pci/0000:06:00.4/262144: type eth netdev ens2f0v1 flavour virtual splittable false

This change introduces a netdevice name change on systemd/udev
version 245 and higher which honors phys_port_name sysfs file for
generation of netdevice name.

This also aligns to phys_port_name usage which is limited to switchdev
ports as described in [1].

[1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/Documentation/networking/switchdev.rst

Fixes: acf1ee44ca5d ("devlink: Introduce devlink port flavour virtual")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 4eb969518ee0..051432ea4f69 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -705,7 +705,6 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 	case DEVLINK_PORT_FLAVOUR_PHYSICAL:
 	case DEVLINK_PORT_FLAVOUR_CPU:
 	case DEVLINK_PORT_FLAVOUR_DSA:
-	case DEVLINK_PORT_FLAVOUR_VIRTUAL:
 		if (nla_put_u32(msg, DEVLINK_ATTR_PORT_NUMBER,
 				attrs->phys.port_number))
 			return -EMSGSIZE;
@@ -8631,7 +8630,6 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 
 	switch (attrs->flavour) {
 	case DEVLINK_PORT_FLAVOUR_PHYSICAL:
-	case DEVLINK_PORT_FLAVOUR_VIRTUAL:
 		if (!attrs->split)
 			n = snprintf(name, len, "p%u", attrs->phys.port_number);
 		else
@@ -8679,6 +8677,8 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 		n = snprintf(name, len, "pf%usf%u", attrs->pci_sf.pf,
 			     attrs->pci_sf.sf);
 		break;
+	case DEVLINK_PORT_FLAVOUR_VIRTUAL:
+		return -EOPNOTSUPP;
 	}
 
 	if (n >= len)
-- 
2.26.2

