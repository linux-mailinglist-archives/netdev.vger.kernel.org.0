Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1C3B620DA0
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 11:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233967AbiKHKsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 05:48:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233930AbiKHKsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 05:48:12 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2082.outbound.protection.outlook.com [40.107.243.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F94A4199A
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 02:48:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JpnAzEyFoRJBD7Gj3nykaniUESTsJbDn2uIzFXPDDe6BPgSD+zw3tC+jLxx9ibc/uGnEdiMnNJUa2BfpZl6dqdKUqE4Sh/gKUE6WO5jvw6+wb7VrFWbdJf+O3QUaV51JaDSuBlupVlNc9Kd0ajW+FbCvvTMqNwaln617flw5jiWLY769EMaUjny7iNiVQp5Ie9UKfbqC7k3CIl4jbN0OFE2SneNDKHrcq+Tnstuf66s0OGLU7lyxitd7jWoTKNzjXqtZeIE/SEQ2FdAsul2rLfqucnytKsOvZTLsLjUogvwVv313IECqq46djfh2qBa1nnebmh6conuiq1nYovO9Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ai2oauCroFY3HI0rg2Y//XDMlglyEEmP2GfZg1UJh5s=;
 b=NaKXuiyH5z5+8pCamF7IdBX99oAf9Xl8Bmn1djLmAEItt1Z2zfM+lJ01/vey5bNB2lYer8OVks2ItLDWo/Kf+FY/JaQPVzcPA3TNw1iAdGcltcIrn9T42akNgivivOrUWxKmdF3j2fLFO/5wBjAyGl7xHej59kW3rSpKTi725q05HdhxXQyuFpTr7SCz5aGZcmaxlo58JcwTpKBM/puvV4Vk9PZBd3wI2kBLHslMvdf7hy9wsgprLJgwZ96vPBnZE5IDgvIoQUV9TdpLPAMOicEkPY3uhF3zSUFxvS3THvFvaN53gu+ng7X0tQmo0Bf7AGl66aiyzHSlcIadgCsUIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ai2oauCroFY3HI0rg2Y//XDMlglyEEmP2GfZg1UJh5s=;
 b=IuMyU952YfUyi0KeaB/eD/3HiQsILevxacsSVQGbnYn9xuak7n4AD2rMEG83i7dYJU6QmeioTHLMX3JudcELHc3Eb+Psea9cHf1cTlBBD+NU/gbsgL5x/Alnax1gywJQzGuzfS/sD8VmyHsj2k24fF3Os/7RkxeYbOzF4MycBQgWU/P38mema87RFI2FRRhgjaHgkOCTWdQsVu1grOnUNOuOQCsiWnzGO1vQoeJKTwQ6XEO7SIz1ErMzsenrkVBpJxXWbUvG396eCJ3TQAvkWuShtyJLN7ar6N9s90wp8DdciprBm6AncZJjLZ3KXnCeRZwAGxsfGlVlusHjQg/Bpw==
Received: from BN1PR12CA0008.namprd12.prod.outlook.com (2603:10b6:408:e1::13)
 by CH2PR12MB4103.namprd12.prod.outlook.com (2603:10b6:610:7e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Tue, 8 Nov
 2022 10:48:09 +0000
Received: from BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e1:cafe::f6) by BN1PR12CA0008.outlook.office365.com
 (2603:10b6:408:e1::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27 via Frontend
 Transport; Tue, 8 Nov 2022 10:48:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT020.mail.protection.outlook.com (10.13.176.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20 via Frontend Transport; Tue, 8 Nov 2022 10:48:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 8 Nov 2022
 02:47:52 -0800
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Tue, 8 Nov 2022 02:47:49 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>, <netdev@vger.kernel.org>
CC:     Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        <bridge@lists.linux-foundation.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Hans J . Schultz" <netdev@kapio-technology.com>,
        <mlxsw@nvidia.com>
Subject: [PATCH net-next 04/15] devlink: Add packet traps for 802.1X operation
Date:   Tue, 8 Nov 2022 11:47:10 +0100
Message-ID: <ec42c7bf37d9a5e05096c409dd96c1c582747b24.1667902754.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1667902754.git.petrm@nvidia.com>
References: <cover.1667902754.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT020:EE_|CH2PR12MB4103:EE_
X-MS-Office365-Filtering-Correlation-Id: f46be232-4c0c-4290-8b33-08dac176b9d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vXmUTprNv2JTTBxJOdvXsBcrXt+419CAS4D/MIEIOmZYaY7Jk740nmEQmS/2W/fGUfY6QxOXqgXRbVhpi4Xpm2rbWdR0ip8iTDVNCF07FcRuypJ0FtQ/83Eh4eucLwPrOZpCj05Fx4pC+pXbJ7cOiD4+uLmLBxYM0iw/SYYOzOD/MpTeGmJOmhUITKLulw59ycy72/P9vCjqITsjy1EPlOQ4KoPgNMLvxjzYm5CH6NxmCoCGd4mzffl0Aes9n+bYuhsqXgGFNID+V8kE5vj+y4+ylagqrqEfsbbpt6PQF13lul8br8L2lM/f2thn/P5qd4a2ZfVeXe6tKlCGXo8VCb9/cFvC1JSGglMKnvT7vHbsgPYE0Cj9wEPvpT7rm+95OcfmCPP51Wk2Kkpm+veu9UmuWRPMeBECE1EiWFzyxT3AOUbeo4CTm8cM8g7MODm1ZFwBomGa91KtLkR4xV5Lf8BlnBfkOn39vz3YEIKDUYeiLP4GLiaXSwvyMKEyx43ULBrb2/oWgcgw2XM2/IGtpJcWLJQScYn8Nov8wpH2s1pY0MqwymBfpDpVb9Eh0brL4N5VHd+PRNjkM5t1ba8uhl0Oq883mi8SaB0cWRZLDlADH9XmFgS2ZKMbxkbqy0gNq3AsmGHWF8U6+UtKCakmICHgLkn/BYTe7E0E5tPTCWHbpmCP6DxTgLdKGLfw8IIaZXaa7szDJRzBYzUBs0s58yAF3+Crtmhi49R4gBfYj35T8hvSFxaG8FnZrUhJD8XBD1eYIvvQuqUiT7fh4RC8dQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(346002)(376002)(451199015)(46966006)(40470700004)(36840700001)(426003)(186003)(47076005)(16526019)(6666004)(26005)(336012)(36860700001)(107886003)(2616005)(83380400001)(7696005)(40480700001)(2906002)(40460700003)(82310400005)(316002)(478600001)(54906003)(70586007)(41300700001)(8936002)(5660300002)(70206006)(8676002)(4326008)(110136005)(86362001)(36756003)(356005)(82740400003)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 10:48:09.2527
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f46be232-4c0c-4290-8b33-08dac176b9d7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4103
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add packet traps for 802.1X operation. The "eapol" control trap is used
to trap EAPOL packets and is required for the correct operation of the
control plane. The "locked_port" drop trap can be enabled to gain
visibility into packets that were dropped by the device due to the
locked bridge port check.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
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
index fa6e936af1a5..611a23a3deb2 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -894,6 +894,8 @@ enum devlink_trap_generic_id {
 	DEVLINK_TRAP_GENERIC_ID_ESP_PARSING,
 	DEVLINK_TRAP_GENERIC_ID_BLACKHOLE_NEXTHOP,
 	DEVLINK_TRAP_GENERIC_ID_DMAC_FILTER,
+	DEVLINK_TRAP_GENERIC_ID_EAPOL,
+	DEVLINK_TRAP_GENERIC_ID_LOCKED_PORT,
 
 	/* Add new generic trap IDs above */
 	__DEVLINK_TRAP_GENERIC_ID_MAX,
@@ -930,6 +932,7 @@ enum devlink_trap_group_generic_id {
 	DEVLINK_TRAP_GROUP_GENERIC_ID_ACL_SAMPLE,
 	DEVLINK_TRAP_GROUP_GENERIC_ID_ACL_TRAP,
 	DEVLINK_TRAP_GROUP_GENERIC_ID_PARSER_ERROR_DROPS,
+	DEVLINK_TRAP_GROUP_GENERIC_ID_EAPOL,
 
 	/* Add new generic trap group IDs above */
 	__DEVLINK_TRAP_GROUP_GENERIC_ID_MAX,
@@ -1121,6 +1124,10 @@ enum devlink_trap_group_generic_id {
 	"blackhole_nexthop"
 #define DEVLINK_TRAP_GENERIC_NAME_DMAC_FILTER \
 	"dmac_filter"
+#define DEVLINK_TRAP_GENERIC_NAME_EAPOL \
+	"eapol"
+#define DEVLINK_TRAP_GENERIC_NAME_LOCKED_PORT \
+	"locked_port"
 
 #define DEVLINK_TRAP_GROUP_GENERIC_NAME_L2_DROPS \
 	"l2_drops"
@@ -1174,6 +1181,8 @@ enum devlink_trap_group_generic_id {
 	"acl_trap"
 #define DEVLINK_TRAP_GROUP_GENERIC_NAME_PARSER_ERROR_DROPS \
 	"parser_error_drops"
+#define DEVLINK_TRAP_GROUP_GENERIC_NAME_EAPOL \
+	"eapol"
 
 #define DEVLINK_TRAP_GENERIC(_type, _init_action, _id, _group_id,	      \
 			     _metadata_cap)				      \
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 40fcdded57e6..1c2cb6fc29c3 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -11731,6 +11731,8 @@ static const struct devlink_trap devlink_trap_generic[] = {
 	DEVLINK_TRAP(ESP_PARSING, DROP),
 	DEVLINK_TRAP(BLACKHOLE_NEXTHOP, DROP),
 	DEVLINK_TRAP(DMAC_FILTER, DROP),
+	DEVLINK_TRAP(EAPOL, CONTROL),
+	DEVLINK_TRAP(LOCKED_PORT, DROP),
 };
 
 #define DEVLINK_TRAP_GROUP(_id)						      \
@@ -11766,6 +11768,7 @@ static const struct devlink_trap_group devlink_trap_group_generic[] = {
 	DEVLINK_TRAP_GROUP(ACL_SAMPLE),
 	DEVLINK_TRAP_GROUP(ACL_TRAP),
 	DEVLINK_TRAP_GROUP(PARSER_ERROR_DROPS),
+	DEVLINK_TRAP_GROUP(EAPOL),
 };
 
 static int devlink_trap_generic_verify(const struct devlink_trap *trap)
-- 
2.35.3

