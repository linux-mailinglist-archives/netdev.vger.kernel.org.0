Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981FB21243C
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 15:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729157AbgGBNLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 09:11:41 -0400
Received: from mail-eopbgr150084.outbound.protection.outlook.com ([40.107.15.84]:26558
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729115AbgGBNLh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 09:11:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EY0Ev9RphluyOxnEO5b+aZCl8nKbj/9nkQTAf/he2OLBgc/qlek6TOcUIy638PUPm/o6SPF4F/NpQ71IKSv6gKjs0BN15a5jD6Xfp2mBoo4TD9mtNh6bTNFl+7DE6NTHjWhd7sk/We0fFyUzvqdIWE9SORXlIjWN9oV3kInoXjf3jymGpTSoXUQzyDBY8Igu/eCajdsxnJfu5wX8xPgoFvVAzsEy3srMSmD23sJG+5aJW/YjjhvaOPD4mmRsu/BIGRcoObfKnFP49/FtX/iosVYaNt6C+dsADTDu89suKrEhurWLfu4B3UnNIkBx3IrOBEwEjk6aFGo9hVacySmabg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yl1XTgjG4EdbiR1mwjMKs+kKtNFTCmK1raOKUce8PMs=;
 b=I6FNkj7UWtE1+SflFb1FrSfn46U6sbe7EoS6SAT4v8V3JQSv0ZwyCJtAzSVy+ihwpnyUxP6MahdZwe2x2UaFQi39kV+3fkXq+00V89oVDiIwvBZr9Qx4Njt4CQ38LVmmQaEVFFs4FkZMuUnbIAR6KwMCN04HHDrX6aFBK5F+NJPda+YjpSObC9r6tWaZUhxz2aRHqoEvNJZYdVbQ2x/FSb9/6HP176EdFwQtE4UIG9dxCfdeGiue4G5MhGwiG5VsLSCcjD+EzOeWynMQ0lRVP65U4TmhbZz3FPAyVWI6NLpqUAkeAU/2/TOEt0ySQAqlo46+Wn40dy5hyDdrR3WygQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yl1XTgjG4EdbiR1mwjMKs+kKtNFTCmK1raOKUce8PMs=;
 b=mPrWjShnYflA0PVdbtbF2lcJPs0YPxtVX13VoTulQ0eVClzdIGPilQ7GUyLtA0i925AiO3nObdlbitNqKPvuiW9WqD5ddWF5L2uEA9sLJtgTeX/JObR4DJgBjM3dnVaEvC1x1tUvFldpVe0IMjB8Agr4tOjAhQhwa56KqkzsOP4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR0502MB3834.eurprd05.prod.outlook.com (2603:10a6:7:83::17)
 by HE1PR0502MB3722.eurprd05.prod.outlook.com (2603:10a6:7:85::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.26; Thu, 2 Jul
 2020 13:11:31 +0000
Received: from HE1PR0502MB3834.eurprd05.prod.outlook.com
 ([fe80::7c6f:47a:35a4:ffa2]) by HE1PR0502MB3834.eurprd05.prod.outlook.com
 ([fe80::7c6f:47a:35a4:ffa2%5]) with mapi id 15.20.3153.021; Thu, 2 Jul 2020
 13:11:31 +0000
From:   Amit Cohen <amitc@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, o.rempel@pengutronix.de, andrew@lunn.ch,
        f.fainelli@gmail.com, jacob.e.keller@intel.com, mlxsw@mellanox.com,
        Amit Cohen <amitc@mellanox.com>
Subject: [PATCH ethtool v2 2/3] netlink: desc-ethtool.c: Add descriptions of extended state attributes
Date:   Thu,  2 Jul 2020 16:11:10 +0300
Message-Id: <20200702131111.23105-3-amitc@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200702131111.23105-1-amitc@mellanox.com>
References: <20200702131111.23105-1-amitc@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0117.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::22) To HE1PR0502MB3834.eurprd05.prod.outlook.com
 (2603:10a6:7:83::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-155.mtr.labs.mlnx (37.142.13.130) by AM0PR01CA0117.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20 via Frontend Transport; Thu, 2 Jul 2020 13:11:30 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ab9f34c1-4f02-4710-825f-08d81e897021
X-MS-TrafficTypeDiagnostic: HE1PR0502MB3722:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0502MB37227270F9FBE34615DC1D8DD76D0@HE1PR0502MB3722.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:184;
X-Forefront-PRVS: 0452022BE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kcvVhsKXhFtKBdp8qAvt4f1KY8tQNGKv11vEeveGEz+MbDjh1G+ybQX8Vx+DQ/dn1Et5g9bn4tb7yWaEVEinY3sDmqFLV6DRvOMheUYaguyNmkswOTZ3ySc+mL3V+G3j46uHrqyJInWzKw31oXv5vIFm4E/mOIDlxg6TH3/qv4KVqn5TwOysHZ9ifGqYOgm98EYBSKqZcSPH6nLCkEWZbUpaseG4jp23VfpkJND8fO9zpGs4tFL6kOGZWW2lkA1+OmsPONb/WJJi6CFrYOWvVS+dWDk3eO7/CEGxAAzInS4XbZlvJUUMkR24lCT62sHPT28Z3VgWiYSCL1e4wUq6Hw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0502MB3834.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(366004)(376002)(396003)(136003)(2616005)(4744005)(36756003)(478600001)(1076003)(6486002)(107886003)(6506007)(86362001)(6666004)(52116002)(26005)(956004)(4326008)(8936002)(6512007)(8676002)(186003)(316002)(6916009)(66556008)(5660300002)(66946007)(66476007)(16526019)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: imVL1t46RzDJvTcR1c6MXP01onlULO9lRXhCZH/YCvHQehQok1QTEi0wdMWmYOhpD7s7sAPeRGO2K+Gvn3w21uLgdy7Agtoud/KTGAPrA2eJWa/HSjW+4z3eMdJdRk2X5phctLeLUBiTZrt7q5WRkH0V2YVTxrN7SG1fy0UNHhkcoNnx2rKhBd62bHwXjTkVoL1yFLAYCb6w1PdVEZwa/bKLcITaXD4vCyyN1mDJB6ImzNaAzq276/6ZEn96cNiNCsE6VikGncP0O9pISY/Pb51EbVMkBiXsgdYoV1f62IQVYpKN7oFzMlMIrRJ6nr0LrIr98hEamIKK7OHx+y9RTIrQExYQJRLVCh4sLi/5eVHlp2hObtzFV3ImA5Kgu6l5M8J1Mt4WBU7WjQszpiklRbcKw+Ps0GwWD7fjVSzviTbhvdxylk4/zAbMxtnpsKTcyxd4nurRdnYQ1sac7HsyFpnyV2RB5AKn6Rsc3dxrLcSxZp9rjhU5MJfUGHhGvj2m
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab9f34c1-4f02-4710-825f-08d81e897021
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0502MB3834.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2020 13:11:31.6850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RlqvJST+g7RodnITM5EJ8YYwKun1gfAv6XVy+F4IitRyfoLzijYH018GUxlvQEH8vjIG1dHmZhCctjrx17HE1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0502MB3722
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ETHTOOL_A_LINKSTATE_EXT_STATE and ETHTOOL_A_LINKSTATE_EXT_SUBSTATE
format descriptions.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
---
 netlink/desc-ethtool.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/netlink/desc-ethtool.c b/netlink/desc-ethtool.c
index 98b898e..bce22e2 100644
--- a/netlink/desc-ethtool.c
+++ b/netlink/desc-ethtool.c
@@ -95,6 +95,8 @@ static const struct pretty_nla_desc __linkstate_desc[] = {
 	NLATTR_DESC_BOOL(ETHTOOL_A_LINKSTATE_LINK),
 	NLATTR_DESC_U32(ETHTOOL_A_LINKSTATE_SQI),
 	NLATTR_DESC_U32(ETHTOOL_A_LINKSTATE_SQI_MAX),
+	NLATTR_DESC_U8(ETHTOOL_A_LINKSTATE_EXT_STATE),
+	NLATTR_DESC_U8(ETHTOOL_A_LINKSTATE_EXT_SUBSTATE),
 };
 
 static const struct pretty_nla_desc __debug_desc[] = {
-- 
2.20.1

