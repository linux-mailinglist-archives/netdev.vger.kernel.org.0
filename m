Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEE2B60C970
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 12:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbiJYKIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 06:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232170AbiJYKHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 06:07:43 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2083.outbound.protection.outlook.com [40.107.237.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4585105365
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 03:01:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JKEpU2SdRmmGbLvxw2Xg33pni2VGBq6DY0Hjkfgcb038yOQ7pBuSmZ1ZCjakjNn7ggVKPb3u/kBUciuHhUL91t4n90hrwGIjQIEhYNeSe//sgJI6gIPRuX5Gph40U2ZFIVnKFid4Sd6SkQpwBdmYe4S9VUjs0DgMXqfkYWWRLgKVLfsYx/KnuanUiXxkNFj8Tu1tD82QtywOxR0DmAhzIYlFgI3BHDpNjqS/WdLMCzxCow/+XRQcfvKMtmuG2KTMMT96j/0ezSaZKxD9uumhmKrcUsCE9r4RAKcDCnDEp1p3lrPDPkaC06G+lPv6Nt8bEY9xhWe8s/Jkml5ITJOiRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OGfuLh4Ljvp3anWv3cPQDqm3VxfHLE4ggDkGKSJbLeE=;
 b=levoTMwmhhA3ln40A3BpA1OWTeXteRNvRVgQGI7qR4ikS7ifMUg68ShoTI9ioQxcrI5J3ndUMxYvcTXuKxbvB9a4oyvTHDjmPPcSARnJ+K3YILjEY1/cjsfhtQfjxXbQLbOgNyzr2y6lRZsr4t0fU8DP4j7ximXvDOxgQJ9frSUdw5WzuNg8GCPBCvm0ZHUQ8c9oYAQTd1nTGnJweyEFwY4D0LXR3MyElpJNihFYMXHYlIIpglj+QA6+M94vus8Q+dvv9ZhU2n73iLOSbNgNHGNRFnXp3P8oa/yevU/zXGhxAbv0H+4bHzWgdzUSTTUdTLJQzT/RHt5Ng+Md17i7SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OGfuLh4Ljvp3anWv3cPQDqm3VxfHLE4ggDkGKSJbLeE=;
 b=BV+tLJbE+6cGBPDDWI6oi7Wk+MKVCKjrznXbgY6zH4SLBIxwgJaoRYmeHZyziQQSsC8z0PpAVrYwipEawYn87vCMbDHk0uUATsGpfAUggDrTwU3s0xI260aeFoTwzqdGyXfRLnL+A1Prqox+vwKFXc1hudRSMJLQyKtNDw29WEJ12m7EhVFkjLwo1QR8DlN3iAF7dNS8fFy+Z/sSICMPxK8Zs4WMlX50GfwmXaWueLuBX7+ClajxxNXpUScuDjuw6YLdqBl1jDV7vBapt5rHbikJ2X93lOAQuWm3surQJp1c485GwFaBsbdUGYTyDMolJhRU2jXJVdLCaHTtceiepQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BL0PR12MB4929.namprd12.prod.outlook.com (2603:10b6:208:1c4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Tue, 25 Oct
 2022 10:01:22 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 10:01:22 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jiri@nvidia.com, petrm@nvidia.com,
        ivecera@redhat.com, roopa@nvidia.com, razor@blackwall.org,
        netdev@kapio-technology.com, vladimir.oltean@nxp.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 05/16] devlink: Add packet traps for 802.1X operation
Date:   Tue, 25 Oct 2022 13:00:13 +0300
Message-Id: <20221025100024.1287157-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221025100024.1287157-1-idosch@nvidia.com>
References: <20221025100024.1287157-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P191CA0005.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:800:1ba::12) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|BL0PR12MB4929:EE_
X-MS-Office365-Filtering-Correlation-Id: 298357cd-13af-4f8f-573e-08dab66fdeb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DH8T0NhJsbU2fceOPgfmDBXgtlQoZYK0q3+Mxxizc/jEE0UCVy+UIYFWU/V6YU/Y2iX8jnxgtP0Lb/noEC4EA7H1YoHuc77Y4RKbmDLJGsbxj4JVN0IXWUrNNMwrMZQ6s8aQGiV00obBR+AEyeAn94Zv0Ou7br5dsWNbOTs8ughiyVPHJpRXdzr7GtWEVkEqI03xGax3ClL13CAZCWW5s6v7T9l5kbsho5E7r54fnhBgqe/3IUCqlCbpUV9c7LmgY/eObAtiJf/TUy4rWueFEls+gn0qrBjy3rZmF/SzX2ZGTbyhvZ/68xsmNx9oQnfFH24cS+pJklpRIz9WqDUeqzihycyXw0wbnQp1SF+Co+FFyk6GQQDeLduCQZ1lCUySiaaiuf3A08S1ABxc24sweQoORNz7abKx/oNv2T07LLVUTKk8EYkZ+nXbQ3ghfVS6k5pkFd2Day+WVS1J2ps1TSwnxrmFuHwnTLixrIs++flqIu1HmVgYmSU2r+3YArFXjabAGRXJww3g2NeXqdWqoX36bPBz63BJJsTS/gs/qR9/B0pzsc7+qmOKQ11w/mvPrvEb1LvacJb8kuUBo+xl3L4ZH9MCNnGwawVTt1p6gqPvqCm8PN8mrS2/PlNYWVJoMuBKwYPXiD1lZpkkMpTf23+FMRaSrZVQZc3BHEa7gHRB3hTMES8+nRtRv+7dHBCgKhROGaQuq9VoI65M3edYpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(86362001)(36756003)(38100700002)(2906002)(5660300002)(8936002)(7416002)(83380400001)(1076003)(107886003)(6666004)(26005)(6512007)(2616005)(186003)(6506007)(478600001)(8676002)(66476007)(41300700001)(66946007)(66556008)(316002)(6486002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?95+X+UoQCqXrw/lq0vHkheiGTSGU0Krjv/xmxG8uX8Ggw4CSrE9kFlAeq5cz?=
 =?us-ascii?Q?cYbDBD85bYp7TENnX8LsaL4IVD/gHRW9Sct1Pa9TKNYEEyKpgeblsjYjcgAW?=
 =?us-ascii?Q?E8Rqh+AuKTPa58zHBi2ciuLe+E8W6BOV5Po3rQ2GJhbO/gEr4psPjfiuqQBb?=
 =?us-ascii?Q?uky+noZXBLZFXFYDa0SnFFl1jomDlOfeJ4C89a8ThEcWihqy4JpMPPr7vxjU?=
 =?us-ascii?Q?LreX+Joewc9IFd9+r6oz51QAxrOt1vwI7+4cAsD1MGQHq0Zx6hb9JUqya+h2?=
 =?us-ascii?Q?bbH1Arremz51Uprat9cH252WrCC1+paBG4dFFnDjT+IT6lp0yolNWe7P5uKg?=
 =?us-ascii?Q?ToD8P4kChe3Y4Y8n5K/ltsd0I12+FxVeGm2BD0c71Z2otI0yongFMPHLIY6x?=
 =?us-ascii?Q?vj3BIidYAZ6Z08loMGvO6gac9XTlkyN9BCDZNXiO2EL7kfvFYvlbF398vtDh?=
 =?us-ascii?Q?X1USAuEY5J5BoKcFyamMxmTBek31rt8Hup/VFTntrVrFTgc8d+B4dkCc8OsR?=
 =?us-ascii?Q?FkdEfLJWfurcUkRrvoeYzD0Qw63iGuhXx+syxqw199r74uKNvGhRymIigMCq?=
 =?us-ascii?Q?2Mxn4Un2L5BsBcLHoXFYnW1W/cXkTv+KBPCn29+aadA/Cu1TY/wByMp1hgz8?=
 =?us-ascii?Q?HyTpZo2R5v0Pd56c/dKCWuiGXMXvNdoQa8IGZuVLDMRLoNJfbtdw7v1baQrR?=
 =?us-ascii?Q?wuPS8hdPUJt+cz93hxhiBYfT0USXK4gnH07Sjr1IUxW9QUW9k2LWP5446Uq2?=
 =?us-ascii?Q?avDn78M6fJZj68GlJvDgdh95+DF9mxIK3gZGyjQM3IOKUpQ2kCM6uUPRQzAL?=
 =?us-ascii?Q?xRJkHx12aRKXMek7JW6fd6f/9df0ZW3imnGg4VBk29WjjUKAIN0dHAn7zDDR?=
 =?us-ascii?Q?2oPL+zeeyD8U5CXY4WRDHmdg7drJ6zI4pyc5dCRZwpJHyXRW37S4wvP5V7yz?=
 =?us-ascii?Q?R8cS1eQnhiRfua74gVLDhZb/BDMqNHizKAoIWqiaXylfI9SLrZ+8KD0EUEfq?=
 =?us-ascii?Q?ygqIo8b92M0JkKpHH+oK4suLFuiJtPGwE4Tzx1jLYvVmzCRgfQA4bG6hURHY?=
 =?us-ascii?Q?pN/u0eoy4x9xGpiYo3AKM3rxQ3WBgfOBziJe8HhzEUIONiRFjUm96qAjH4DL?=
 =?us-ascii?Q?6DYeVnrtFiMiHXPdNdLiu61TCL2VH+P1z1vRO3pNJyQHeG5WI/OqbFNT0cYt?=
 =?us-ascii?Q?SEpmR7VfcKlZw8RAfi7ucOaT0JGfsTRYjuKUlqvLbTEqIszaZVndgYgkS4ty?=
 =?us-ascii?Q?kSi0AUKc3mwm5IP60jqJjDX1f4uwZCAR05ul6fjjQy+FDsSyavPG1gUIfzY7?=
 =?us-ascii?Q?+rfW0x7Bp4ZIztipfkFORcc7SksWfNlWOIZbCA5wJ+XrotxXGZpEgoAJMurx?=
 =?us-ascii?Q?Bjh0YloltodWfct3xaUr8gGzY2JWoBG9p+8+sr53zkQZFNjIr9SVIRuzJK9x?=
 =?us-ascii?Q?sOcZLd69/wZizuD+Dy59slkIV1e/EJDMeLpj+xlfrCHAmvgTl+CxaQ4EOkvC?=
 =?us-ascii?Q?FLyHufQF/hhMPz14Hd9sfkDhyqZTqFwPXD9h3zKPrvyW6r7PsIudtCqlUhYu?=
 =?us-ascii?Q?1S+ULWRSBdmWNwOdF45cRJwro4wA/KjgqFf/7VV1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 298357cd-13af-4f8f-573e-08dab66fdeb7
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 10:01:22.1581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AQAk8FhHhTHUydSs2OdekQY2ap08y51M8rKAjxWPzeB+YXO8z1teFLc7WDE0nD/uUDieUBCHhc4iXSANSWBN+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4929
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add packet traps for 802.1X operation. The "eapol" control trap is used
to trap EAPOL packets and is required for the correct operation of the
control plane. The "locked_port" drop trap can be enabled to gain
visibility into packets that were dropped by the device due to the
locked bridge port check.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 Documentation/networking/devlink/devlink-trap.rst | 13 +++++++++++++
 include/net/devlink.h                             |  9 +++++++++
 net/core/devlink.c                                |  3 +++
 3 files changed, 25 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-trap.rst b/Documentation/networking/devlink/devlink-trap.rst
index 90d1381b88de..2c14dfe69b3a 100644
--- a/Documentation/networking/devlink/devlink-trap.rst
+++ b/Documentation/networking/devlink/devlink-trap.rst
@@ -485,6 +485,16 @@ be added to the following table:
      - Traps incoming packets that the device decided to drop because
        the destination MAC is not configured in the MAC table and
        the interface is not in promiscuous mode
+   * - ``eapol``
+     - ``control``
+     - Traps "Extensible Authentication Protocol over LAN" (EAPOL) packets
+       specified in IEEE 802.1X
+   * - ``locked_port``
+     - ``drop``
+     - Traps packets that the device decided to drop because they failed the
+       locked bridge port check. That is, packets that were received via a
+       locked port and whose {SMAC, VID} does not correspond to an FDB entry
+       pointing to the port
 
 Driver-specific Packet Traps
 ============================
@@ -589,6 +599,9 @@ narrow. The description of these groups must be added to the following table:
    * - ``parser_error_drops``
      - Contains packet traps for packets that were marked by the device during
        parsing as erroneous
+   * - ``eapol``
+     - Contains packet traps for "Extensible Authentication Protocol over LAN"
+       (EAPOL) packets specified in IEEE 802.1X
 
 Packet Trap Policers
 ====================
diff --git a/include/net/devlink.h b/include/net/devlink.h
index ba6b8b094943..afd9999a9b2a 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -885,6 +885,8 @@ enum devlink_trap_generic_id {
 	DEVLINK_TRAP_GENERIC_ID_ESP_PARSING,
 	DEVLINK_TRAP_GENERIC_ID_BLACKHOLE_NEXTHOP,
 	DEVLINK_TRAP_GENERIC_ID_DMAC_FILTER,
+	DEVLINK_TRAP_GENERIC_ID_EAPOL,
+	DEVLINK_TRAP_GENERIC_ID_LOCKED_PORT,
 
 	/* Add new generic trap IDs above */
 	__DEVLINK_TRAP_GENERIC_ID_MAX,
@@ -921,6 +923,7 @@ enum devlink_trap_group_generic_id {
 	DEVLINK_TRAP_GROUP_GENERIC_ID_ACL_SAMPLE,
 	DEVLINK_TRAP_GROUP_GENERIC_ID_ACL_TRAP,
 	DEVLINK_TRAP_GROUP_GENERIC_ID_PARSER_ERROR_DROPS,
+	DEVLINK_TRAP_GROUP_GENERIC_ID_EAPOL,
 
 	/* Add new generic trap group IDs above */
 	__DEVLINK_TRAP_GROUP_GENERIC_ID_MAX,
@@ -1112,6 +1115,10 @@ enum devlink_trap_group_generic_id {
 	"blackhole_nexthop"
 #define DEVLINK_TRAP_GENERIC_NAME_DMAC_FILTER \
 	"dmac_filter"
+#define DEVLINK_TRAP_GENERIC_NAME_EAPOL \
+	"eapol"
+#define DEVLINK_TRAP_GENERIC_NAME_LOCKED_PORT \
+	"locked_port"
 
 #define DEVLINK_TRAP_GROUP_GENERIC_NAME_L2_DROPS \
 	"l2_drops"
@@ -1165,6 +1172,8 @@ enum devlink_trap_group_generic_id {
 	"acl_trap"
 #define DEVLINK_TRAP_GROUP_GENERIC_NAME_PARSER_ERROR_DROPS \
 	"parser_error_drops"
+#define DEVLINK_TRAP_GROUP_GENERIC_NAME_EAPOL \
+	"eapol"
 
 #define DEVLINK_TRAP_GENERIC(_type, _init_action, _id, _group_id,	      \
 			     _metadata_cap)				      \
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 89baa7c0938b..dc54182f2e57 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -11624,6 +11624,8 @@ static const struct devlink_trap devlink_trap_generic[] = {
 	DEVLINK_TRAP(ESP_PARSING, DROP),
 	DEVLINK_TRAP(BLACKHOLE_NEXTHOP, DROP),
 	DEVLINK_TRAP(DMAC_FILTER, DROP),
+	DEVLINK_TRAP(EAPOL, CONTROL),
+	DEVLINK_TRAP(LOCKED_PORT, DROP),
 };
 
 #define DEVLINK_TRAP_GROUP(_id)						      \
@@ -11659,6 +11661,7 @@ static const struct devlink_trap_group devlink_trap_group_generic[] = {
 	DEVLINK_TRAP_GROUP(ACL_SAMPLE),
 	DEVLINK_TRAP_GROUP(ACL_TRAP),
 	DEVLINK_TRAP_GROUP(PARSER_ERROR_DROPS),
+	DEVLINK_TRAP_GROUP(EAPOL),
 };
 
 static int devlink_trap_generic_verify(const struct devlink_trap *trap)
-- 
2.37.3

