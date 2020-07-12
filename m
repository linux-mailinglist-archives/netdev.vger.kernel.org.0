Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E626C21C7FD
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 10:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728485AbgGLIEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 04:04:46 -0400
Received: from mail-vi1eur05on2078.outbound.protection.outlook.com ([40.107.21.78]:7664
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725974AbgGLIEn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jul 2020 04:04:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QOeZKAdsttH3Ptjh4C6unW5fuiLiNzYgSzslajqFYvG89ulsKL0Uh7MobIVgGjmcYAi+pHowJCq656OWQ2BeFkFRF1gvP3Z7ETYtPBu96UofMHu9WkMt/oofRS8oUSBZMtorS5x7GtB2TH5bOCZ+zCZrlnONrT6v6FtFgybCIEPSHT98E4L7zP6ToNvmta1R4kSrdQVU1XDK8b8lsQt08Iurcip/mNesz9/SpF/rLqBmqKSDGFXuI85RLEAnZiqa/OSdEd/iyCSvdKijKgl0OUrLi44cTPyp250TYji6X9Ok9ylbhBnVwLpAP2o4Tb7I9m8QBUc8sseDZKEZ18UbMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zt3uu4qbl0w3tjEYOmFHf0p0NaCYNQR8m+poguJ800w=;
 b=KXNj0PXQirY6LnxXDyaRTfp5yMEIGh7/8lo0Ou5G1guaIbvsmJpXEz8FsFjtLKQEd4oUD9B/0np4sFEgMCzhRRyH4Hv4np2RFDCvky1MZ7Lb5+pnv9kwYEF3JLFe0HVWCX1zBWXg8gXR6cZOxpwpbCOb5GVclo4BqeGjCdrsgX3dYgvzCZLJMJlDbXAdgnY1RkVU+jGqb0GobxzCsP9o43+EpoZDNn8IyjQxYZ/hwZPP3vS4gUqWy+7GPbtHgoApRPkhCVg+KcE74r8o9zsv9EAzdkv2fJLCL/dVK1+GlR4VYCIZIuESKsXwdrU0BPChwTn7cJWbxhq9+P0KbLJw2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zt3uu4qbl0w3tjEYOmFHf0p0NaCYNQR8m+poguJ800w=;
 b=Y+zeew5wo8Cvp5LGqLNwXIuMvpRhuKFBPoySDEoapL5z694+Opg4ZTcGttZHxJ44yiyDIrf8OEb9PUNXzXalK5noRhJG40XsDX10T5IHtRM8bOh1NAdmHUWmOtTaxXO0ymkDsUzBF7Hb9fwyOUHNUqtJX6euMJJZb+6eRnyLLXs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB5634.eurprd05.prod.outlook.com (2603:10a6:208:118::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Sun, 12 Jul
 2020 08:04:32 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::ccb:c612:f276:a182]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::ccb:c612:f276:a182%6]) with mapi id 15.20.3174.025; Sun, 12 Jul 2020
 08:04:32 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, mlxsw@mellanox.com,
        Danielle Ratson <danieller@mellanox.com>
Subject: [PATCH iproute2-next 3/3] devlink: Expose port split ability
Date:   Sun, 12 Jul 2020 11:04:13 +0300
Message-Id: <20200712080413.15435-4-danieller@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200712080413.15435-1-danieller@mellanox.com>
References: <20200712080413.15435-1-danieller@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0902CA0018.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::28) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-155.mtr.labs.mlnx (37.142.13.130) by AM4PR0902CA0018.eurprd09.prod.outlook.com (2603:10a6:200:9b::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Sun, 12 Jul 2020 08:04:31 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ad0a9056-875d-4891-330c-08d8263a3571
X-MS-TrafficTypeDiagnostic: AM0PR05MB5634:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB563485B7547EE4E77ABCFEC9D5630@AM0PR05MB5634.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vVuuL9sjYC8j9rUgmttR3OUbNCg9j7H7KANbjLodaXf24gh79NV7HfTrIVelAV2G5DszQA7uy4JvLEDLZmTMQgVIEtCGs/lUffId3FEMQpfUn5Z8kJek3vyIztQBakRNd6IL7XgkKX6Qc2NaCKaaQuJw0Y5Hp+X2i0z9DOFDhfnwMnciAMjWN3jHsQTF7ZKGB0bNj0mYTjKqgh+2jRHbiCg6cp34QHpVEemvnapCC6e8Ga0TUuv3NkhXnMze/zOi7pyZgIdR26Ht0TPbjDxLxD2unsUqDe9kJbfQK+wMSmGnZajxSLPj3k+fSmJT6ghZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39850400004)(136003)(376002)(346002)(366004)(396003)(107886003)(5660300002)(6666004)(316002)(1076003)(66946007)(186003)(52116002)(66556008)(16526019)(6506007)(66476007)(26005)(8676002)(6512007)(8936002)(4326008)(86362001)(956004)(2616005)(2906002)(36756003)(478600001)(6916009)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: fZPSHM5UzatssDrM9ZAoxmUBDLnKMVOm40whHyH0BBoqQOcXptWjQjYuvPKwvv4DPv5b5ZvVTieMQ3ySKLPoEDn3QEmmFmhG6iWUer0tlVN8DbXciRKAuUImQU7TsZn/oFTL5tQLG64pL4qlR93NzXMF+mJRw7zt/gjh+5HWvI5M0F2dq2nIiL3k8pz7vXiAAAgvb/SYXCV61R0IOFW8NheNxMxHTF1n0BKPWVCSMmsDLh9ZfLh1p1Qd9GoNRf2iFygItB8/kxvxNNHnwzsnvgwo+IIiIumYstnby/fZ6mNa83cxCv20gJ4E3XU7Ij5dmJ0nhP4JePuFJP5Jst0lg44UCmJXDCZRDc+RZMTieNjEmW3y/m4u03Pe9NtoUP03LV8y052iPTyDYrHpA3Bix1jZrJ45WJ0Bp37K940zu4igprtYBuqBVg0ZJdiUbgKUql7hFWweNZ8gwTaajr37w2hF8XwLlUvHcg2EYT2etaU=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad0a9056-875d-4891-330c-08d8263a3571
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB5010.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2020 08:04:32.1373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: duZAmnH+vp9HCkgi1Q31Wyuou5ROqY0nmxBC09reN7CrI7th6uJwWbTwxV/IU0+Ydj+a1+/g1Vc6kp+wJ9qyNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5634
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
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 4aeb9f34..bc39d507 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -3398,6 +3398,9 @@ static void pr_out_port(struct dl *dl, struct nlattr **tb)
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

