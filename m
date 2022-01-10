Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68B3E489323
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 09:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240048AbiAJIQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 03:16:43 -0500
Received: from mail-bn1nam07on2045.outbound.protection.outlook.com ([40.107.212.45]:7181
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239958AbiAJIQg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 03:16:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oQsSgvx2j5b2c3KixsJpZc/G8++uV/1J5zy40XUlCRKO3auEwT29q3rtakBmAFvLOxtbgcFssPR5M5ljo3YIdS2hPXFTIrCJMH/O8cnVG9el55NA8ovWB8DXY/ZO0/YDDROzQYDeFsfO9e5KjzePBBZqmXhFWo/HOYTjd7k/V6nf0xV+8F910EV2YGktcshIKmGeBrpYPd8pSVQ4FLzn2kDAczqyP7PggWkdValh8c2Q07KeAJtlBrTD61O246fz6bChe0LiAJWxhuDe+vRDyVEbFTLzBEjQDR5MMEoXozWlwFilELPbX2W005qYx7g7MM+xv+N5/0ZacYdIA8eEPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FObZ6NqHcl/C9v0gv4MlEwzmAErrzUg3HrrEnag1Pkc=;
 b=BIVnAnZSU7JGKzddXXVNFL5lRFCY/HV4zSDLPYnInA0sYYYp7w2IfaUQeDxbKx6GmtKOD8tZnnqS1nXonwnejTLYIa4JYvn49MLlFQfwlgKHjzYUSlnIy9+dXXNtLR7fD9PlOCDQ/UBdgR3a3A0tTKS/xrbTPKs+sdTL6JtOtQbicDSMq7CsIpq3amV9TjyGYL/BWls6EU82RS42Y3PvF91W8U48QF9PSU/8T2O8qFngLjbluZoyjlNrp8lRQsCpH4Qn++JwNvh3+8fshIlhLBeifPC5zM4mGDPssx62K8bhD5QB25FnEbNefSY0GHHbXHHOcOe2aJyO9D4pfp05OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FObZ6NqHcl/C9v0gv4MlEwzmAErrzUg3HrrEnag1Pkc=;
 b=PoTwSsi+L9vQcKO1LJkUYdMI+vKoGS4n4P2Bd4J8Hct518VP5FtvWd9/0sniCnIg1l5Jiu7vawpW6q7gCG2z6a0CP2xEaeBoAByNmJEqUD6F968j9wzMOGuRtB9glqW1Dej2NFs7deHlbSPeRa+dt4EXVsn1RvIGQTCEVEtr+lKpnqxanTUvkKtvdhg+bv8tzdMx/Uc+B+RsFfDkNoXoXbVJbiYQ6llaWmpUOiDjhJGvvvc8qyrlN+IGZ1x8nTpN1nifg9Q10Hjz+JrkiZScsT+QqiBxxhlryp7or7DxkQ91QrUSybVoZOvDldqwERnJ7spyxVw2tS7RGx4XdLt27Q==
Received: from BN9P223CA0010.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::15)
 by DM6PR12MB4465.namprd12.prod.outlook.com (2603:10b6:5:28f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Mon, 10 Jan
 2022 08:16:34 +0000
Received: from BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10b:cafe::e7) by BN9P223CA0010.outlook.office365.com
 (2603:10b6:408:10b::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11 via Frontend
 Transport; Mon, 10 Jan 2022 08:16:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT005.mail.protection.outlook.com (10.13.176.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4867.9 via Frontend Transport; Mon, 10 Jan 2022 08:16:34 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 10 Jan
 2022 08:16:33 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 10 Jan
 2022 08:16:33 +0000
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (172.20.187.10)
 with Microsoft SMTP Server id 15.0.1497.18 via Frontend Transport; Mon, 10
 Jan 2022 08:16:30 +0000
From:   Moshe Tal <moshet@nvidia.com>
To:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Jussi Maki <joamaki@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Tal <moshet@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>
Subject: [PATCH RESEND net] bonding: Fix extraction of ports from the packet headers
Date:   Mon, 10 Jan 2022 10:15:37 +0200
Message-ID: <20220110081537.82477-1-moshet@nvidia.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6545fcf-bd40-476e-97e7-08d9d4118405
X-MS-TrafficTypeDiagnostic: DM6PR12MB4465:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4465BAF10C2D2F058CE46F08A0509@DM6PR12MB4465.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dhPIsLpazb7ubLkIfaz/GGpw6mCyGHUR1zyXd1ojbgwsNWfiHPhGdgTcDSbcLRKXj7FYKAtdBJH+Akvl5REfzMkrGi5He4jJNmHqKUCaZTd0M0CPEuPu9dybuhnfbSHyvI3s/+28bhZE8Nhe+FBbK3PF4ng9CL8imEwTerfcoASb7snXWSrRDQ4/LQJ/aQlg+/d6TIuGoEfFi1KuE8TL70HEr2mFpep/boA72DWPFSwLhxWQoBXVICEW83/kuSkinlEFdm11av+haZARYiqmVBzNZIXlbTvbQTYpJ0/PwkHxxG+AdJknlvcAevpiVL9/kHExi1FADpNKGKGcmOsZr54aKICA7Un58cd5y5zgEStXSIDEaJL6FNZxkMJsnq562kL6QeGu7/fOxiSIrF/jeAKzdQ+MKNAOJ51wrmOEOJfkrBhBfUqMpF+7EQ/lYAZ8Ee6jRAND8K2EqqyUY64AgaRUUwHnuYJQ6dyr9KFDicai5vl+heP5avWBIrbReO4/IrIq2zT3wV82c3UDMzI1jcbfTitxS7DMjj6Sikgt2UrceaG/zhEbpa2YBScg4xL7nBYrXS59/CvnUNLQV3m9aVP8A9Nh+o4LjtXTfFvUM+ehWFCtAPqKKzK5lQQQxSwmDpmr2wN01zQNebsrHb2YK1hbq93E6ORMmmrlKHxPMe4yRQtaS5WCwQuuvvdFQfjEdRceQ4Tt1775VZDaQzB55H6XU2rt1K/i6V1UbgS6mdupdQ52wQATkmabKRfUTKCSmo/Dn53I+dJzU8jL8LaYxrhrl0pR9hkRABTQOT0ZFb0=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(40470700002)(36840700001)(26005)(107886003)(356005)(2616005)(81166007)(40460700001)(316002)(36860700001)(426003)(82310400004)(83380400001)(36756003)(186003)(47076005)(70206006)(508600001)(336012)(70586007)(8676002)(1076003)(8936002)(54906003)(2906002)(7696005)(4326008)(5660300002)(110136005)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2022 08:16:34.2408
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b6545fcf-bd40-476e-97e7-08d9d4118405
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4465
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wrong hash sends single stream to multiple output interfaces.

The nhoff parameter is relative to skb->head, so convert it to be
relative to skb->data for using in skb_flow_get_ports().

Fixes: a815bde56b15 ("net, bonding: Refactor bond_xmit_hash for use with xdp_buff")
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Moshe Tal <moshet@nvidia.com>
---
 drivers/net/bonding/bond_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 07fc603c2fa7..3189bd14c664 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3745,7 +3745,8 @@ static bool bond_flow_ip(struct sk_buff *skb, struct flow_keys *fk, const void *
 	}
 
 	if (l34 && *ip_proto >= 0)
-		fk->ports.ports = __skb_flow_get_ports(skb, *nhoff, *ip_proto, data, hlen);
+		/* nhoff is relative to skb->head instead of the usual skb->data */
+		fk->ports.ports = skb_flow_get_ports(skb, *nhoff - skb_headroom(skb), *ip_proto);
 
 	return true;
 }
-- 
2.26.2

