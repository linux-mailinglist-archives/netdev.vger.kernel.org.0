Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9E9233488
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 16:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729547AbgG3OeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 10:34:08 -0400
Received: from mail-eopbgr30051.outbound.protection.outlook.com ([40.107.3.51]:36286
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726275AbgG3OeH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 10:34:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g5KZZPlStvdEqmuyRzTQwCCN5QigTEzjivGKiqsDT3hXvXneZe8RFRMCS8KIWw+ueZZCiNhhDvExOF14V1eZNU0r2qB9kgymq2jN/ubWTMkTxXvDGL/UhwfaPO/2o3F7RWDHWa1Mv04TPMpYeG3ALZNfgb06DNCvKbrUqtUCzI1/j68puM1Xww3PoqQl7kuHQryHOhCs8MRvtpcQNss19Y+OW4dFrYo2sfr/DjvUYDaWyB7q4NhRsNoG13h7H4gTRv+dKwmF+JvH//ll+gVGXfExJtsudBieJGkp1RmAK9JoCDGSBktidGS1xVJpAs4i/FLqIBCDJ33VhG0aUuZhKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0JwTes1Ct+z7zLyOCdv7RA+SexpBbK5lRgcHBo1gWaE=;
 b=XKuNUtd/XteQ+P8Fc8iKqZN8if2a8lrgI8VQf9v4KF/+R/3HRw1EBbuwbS4BOTdYLdwtrx9WbvxZbZdNiDbcpcviFTwQIfe7VO7zUrUneTSpg6w5tMLRsYmzZbHUSUYSYb9GgwA9f7WqZnr+Be8hC7Ocq94DCMbsiyLURKZjtXZ5/XiUokTW/SUYuXGzvYe/aBjUWTRkI2lqO44yg8ppR0/9YRTjiE+TZTVJqOAoMY9RtorIQPUwd0pbGiurEsVxXdRSNDuhvRyzt3CmGv5tS42j6RwKv55BMqq/D1dxTdjQDCaHzBJBKF6kZIbgwf1ZObti9OXfIvLPXSsedXLoEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0JwTes1Ct+z7zLyOCdv7RA+SexpBbK5lRgcHBo1gWaE=;
 b=tEUnAvjt+idc51Ey32hEyPkJBhFdMtWHVfEeyoaMgrmb3b/glzvnrnXQRAz4kmpe++lzRDuXQ45TJeHuLTQsgiGWcDQTardXgXTBBl5vrFpiUChF05x9cP5oHyTsSedWl0pd57TR+MkaT+uneLYSHpkNMIfJYM/U6NpW/pJ20x4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB4419.eurprd05.prod.outlook.com (2603:10a6:208:5a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Thu, 30 Jul
 2020 14:33:59 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::6926:f23d:f184:4a8c]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::6926:f23d:f184:4a8c%7]) with mapi id 15.20.3239.019; Thu, 30 Jul 2020
 14:33:59 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, mlxsw@mellanox.com,
        Danielle Ratson <danieller@mellanox.com>
Subject: [PATCH iproute2-next v2 2/2] devlink: Expose port split ability
Date:   Thu, 30 Jul 2020 17:33:18 +0300
Message-Id: <20200730143318.1203-3-danieller@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200730143318.1203-1-danieller@mellanox.com>
References: <20200730143318.1203-1-danieller@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0136.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::41) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-155.mtr.labs.mlnx (94.188.199.2) by AM0PR01CA0136.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.18 via Frontend Transport; Thu, 30 Jul 2020 14:33:58 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [94.188.199.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 66514fbf-089f-49ea-1075-08d83495990b
X-MS-TrafficTypeDiagnostic: AM0PR05MB4419:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB4419C3249C611A218ADEC15DD5710@AM0PR05MB4419.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KNX07YS3Gp1Q4Yh67fI55Gd0kfuq9V62mWEc958oSVZoPbBIIiByuY2oN1l39w8JIsCpsKiefUd2Vg32bEteTI6Tkz/9yaMyNzwcbp7q2r/luACRPZLS1vEQJ44qPH9GLesk/pBG3AcrJebiWHT4l6m2AQIe7Mi7RXYDtKS5oeS4mFq9LQbr64tV4crH0JPmj0ywhajGMNZRhwJXkWhlVPzs5uLioIxkQKRlyZaYlLzJ3lYvIfl/8u/viO6CBMlQZHeH7eq3lneFSM35136Qt+xjZ2SGWDIze9sD0QAv/URaJ4ot0tg27VXocG3e6W6E
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(366004)(136003)(346002)(39860400002)(2906002)(52116002)(2616005)(5660300002)(1076003)(956004)(16526019)(186003)(4326008)(26005)(6916009)(66476007)(66556008)(6506007)(66946007)(107886003)(6486002)(6666004)(478600001)(8936002)(86362001)(8676002)(6512007)(316002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FYR1OgKBux8S/5JvumYVj3tRoHBXZ4IME22D7ID6wbCfQIKtI5jpnoAX4nNYe2ddenRSHN+570hU/yrrGg1qkz/BSWoDWUIsSGcKNHdOVt52BQ15S8aR/deRWAs6+G3OfgnW4sRiPUU+2dN8wOZyAovlGxFZVPW5QJnCQvoZkU5qgSUrY6n+h3sp9dakdrFa3kkX+8Yk9IbxBk/lJXwJi8K0Rs8iSQvJmEp5OqOjoSGPmO1tu7CDdWHv1kzZktVNBZW1QENkOhqHb4qOL9BIL58Mu0lAInRNMUCu45LU9iAAX2fQNtGEzmvMrziou5eBgPVitlkNkl7uVue429IuKv3T8iN/YXlV0RAss7CZUmMoAwHa0pYp+LS+xs2BWlemLs3aVoY5F60TUdTUaYT11krikQTbBV/RPeXAJmm92BwgKmx4N6CWJZpZK3t/M+i968N253k+ion46cynZixOwaLjkbtzFB23cUlUA8DHSa6cb32MCP1ASTS7B6WP89EmjRfu6m00sdsKlBAWR4a9OhCis/e+g0yO4OSekf0Fe8FDK70uGLcFLDwNGS0//Hg/n4x5T4k28ENbLXYLEUd9ka4a+V2lOqJCh2JQTm3M2FfCi+ZDaQNggiy3VgSHe4Ajlok3vUBfW0SdlGAvkBNHiQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66514fbf-089f-49ea-1075-08d83495990b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB5010.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2020 14:33:59.8124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 94AZULn5VhWwnrJYPBpP5Q+bLzyZkb+/ls/+SUro9AlXbqVzKqXZpUQgiHFArmpKl75bV30S50BhTde8QrzzuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4419
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new attribute that indicates the port split ability to devlink port.

Expose the attribute to user space as RO value, for example:

$devlink port show swp1
pci/0000:03:00.0/61: type eth netdev swp1 flavour physical port 1
splittable false lanes 1

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
---
 devlink/devlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 39bc1119..a22e931e 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -582,6 +582,7 @@ static const enum mnl_attr_data_type devlink_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_PORT_NETDEV_NAME] = MNL_TYPE_NUL_STRING,
 	[DEVLINK_ATTR_PORT_IBDEV_NAME] = MNL_TYPE_NUL_STRING,
 	[DEVLINK_ATTR_PORT_LANES] = MNL_TYPE_U32,
+	[DEVLINK_ATTR_PORT_SPLITTABLE] = MNL_TYPE_U8,
 	[DEVLINK_ATTR_SB_INDEX] = MNL_TYPE_U32,
 	[DEVLINK_ATTR_SB_SIZE] = MNL_TYPE_U32,
 	[DEVLINK_ATTR_SB_INGRESS_POOL_COUNT] = MNL_TYPE_U16,
@@ -3424,6 +3425,9 @@ static void pr_out_port(struct dl *dl, struct nlattr **tb)
 	if (tb[DEVLINK_ATTR_PORT_SPLIT_GROUP])
 		print_uint(PRINT_ANY, "split_group", " split_group %u",
 			   mnl_attr_get_u32(tb[DEVLINK_ATTR_PORT_SPLIT_GROUP]));
+	if (tb[DEVLINK_ATTR_PORT_SPLITTABLE])
+		print_bool(PRINT_ANY, "splittable", " splittable %s",
+			   mnl_attr_get_u8(tb[DEVLINK_ATTR_PORT_SPLITTABLE]));
 	if (tb[DEVLINK_ATTR_PORT_LANES])
 		print_uint(PRINT_ANY, "lanes", " lanes %u",
 			   mnl_attr_get_u32(tb[DEVLINK_ATTR_PORT_LANES]));
-- 
2.20.1

