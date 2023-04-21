Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06B636EACD2
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbjDUO0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbjDUO0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:26:15 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2058.outbound.protection.outlook.com [40.107.244.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC631258F
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 07:26:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PoULT+wTMxdrHWgoJAIMsB/2kQIDgx/9vK34nyETxz5ZWZdbn1j89tsKOENu+i8HQzTPKUCVubQ61RhQN3o871wRpnPCBn3N4rv25enDo4ndq+d67Ca6S8HeRU1m65wNyMxh/mKLnPCr8lWCZbxxMTPdALTjf3PmubqCRkSw32jYhxoBA/mroEJzTfLrldzFcfKhdOLiFFASLhJmnJUh6MxM4dE6e3MOsU3BcsTZxdUEVX5gc6qh9dRiHJR31KvJFcDUM7bzKB3Q3T53R5dsv0NEXq4eKktOfwePXN98J/hYnep7y1tRRiMyxUFvZyU3mzces3CU/Zq3v+gcmWqcGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SpRR1F80+UyMZSx4gAoOULrf2SjLvKQBRyAOdXAGhRc=;
 b=CqL/slt+xNldYESbXgvBGA7Pv3Hn9nF8qBlfz1u9/+Bq9UpWXMjjpgPpyMLiwuMwkibq9lK2Q0Q6J/++DE38zd+SwVPNxJx28MD0I1JipilCu3qPoMi3PIYuLcJ8XHx55ORXN4IvmI59N9Ixvt/aPBqjdIuVitTuhOGPgfuh1MVZ3WAMiK6n3NNzK4QOwygRPlfim9bY5Yoe/Ae/IkCAOMOBK8RAJqkr4oUHwKz7U95wKS2KYVzf/WJaR53dfTe2q7jrFDb2pTqkbTG3xLzco2ZWnl3/SLmE1yVfNIqlR0ocizJTejB0MrwIbGmYZz+ZOR4citSkuOnvOhhbcKJ/fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SpRR1F80+UyMZSx4gAoOULrf2SjLvKQBRyAOdXAGhRc=;
 b=Fewso1SWixWEfXkez7or+yMBrv2H03a4SZZfbbuR7tgzzcK9MaQD9sgnxOe0EaXTEhaFrujqQRNx0LibN6AuSMDSDsRxJlQ7ADA9mpOb9o1U+Fzeg37mww3OseJJnfxIARodCYnkl5JtS3Oi1A9enF85szqC8CZ6eQYIxpnmPzLEFytDKqHKoyW7RjX1raFiREJERd/vq+jjLKa405p4Fo6WxV10A/diLzdR72x22lNrtbfAystZwaFleL1WRJ152bABfpRwyPVitSuExu1+ulvhVcwSmFC+U4j3Tb3RAPbCT9WvndU7AEvqoYXTfd9VFR71zAS5pAYX7v+CqjE3AQ==
Received: from MW4PR03CA0122.namprd03.prod.outlook.com (2603:10b6:303:8c::7)
 by DM6PR12MB4122.namprd12.prod.outlook.com (2603:10b6:5:214::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 14:26:03 +0000
Received: from CO1NAM11FT103.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8c:cafe::95) by MW4PR03CA0122.outlook.office365.com
 (2603:10b6:303:8c::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.27 via Frontend
 Transport; Fri, 21 Apr 2023 14:26:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1NAM11FT103.mail.protection.outlook.com (10.13.174.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.26 via Frontend Transport; Fri, 21 Apr 2023 14:26:03 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 21 Apr 2023
 07:25:52 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Fri, 21 Apr 2023 07:25:51 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Fri, 21 Apr 2023 07:25:49 -0700
From:   Dima Chumak <dchumak@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        Dima Chumak <dchumak@nvidia.com>
Subject: [PATCH iproute2-next V2 3/3] devlink: Support setting port function ipsec_packet cap
Date:   Fri, 21 Apr 2023 17:25:06 +0300
Message-ID: <20230421142506.1063114-4-dchumak@nvidia.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230421142506.1063114-1-dchumak@nvidia.com>
References: <20230421142506.1063114-1-dchumak@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT103:EE_|DM6PR12MB4122:EE_
X-MS-Office365-Filtering-Correlation-Id: ef5f400e-fe32-4b61-b0bf-08db4274564b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AFszkfQ6mMy07aloa1jFAibMsl8OBIZXNyoQ5Xf0QBfh7ZcJkCpqY+F4KOhs+ap/4juBR4mDmVFvh2uNCkN9rkadal/KEPtgoXleA8EDXE/d3Nobr9ClDMDDnrxfBLGcTex/oQSh9KD0hu1RDum9sz9vC9J/WPcJgak2PV8KUh3E1Mo8Dua8pY0YhSXpckTIylCaeCgxkFkeJ9vzYXnZjgiHYsQRcrTgavWKPvRv4sEJaEU2f1xOA4F70Isaw2A/9M2QxHKHGpXOO8MMZ5MfEkbMqygifPgiQonZt7YjlqIK4zINFisNcVtzdjPLPaE5E3Ic3ZU5YsV9fhj047wLN/eSamzd8ne1o0OqQ+A2oDkFl5Ob+/uhMRPy7HdjdhMDIdkHoJEZP34X65IWpGP2Cmb8EvPmOOwqmlqulDlI8lJ6QCwVmqIOrRgmGy60hP6ag9TYHqvtmNe8evwo5KHnVTLqFbTndhj6TyfgUOe69SMgQnjbTi/NRPWN00tNUX6seGlYF7H7l+fEysRnkMdTBoK5eLpDJvGz2kJ7Vj7hLfQcK18bLYhChB9BAJlMFMApmnlwtjYsmYi6toDnJlVgk+LeQtOJVUOZyByLjeRoY24RXwcLukkl8HT1MRlJ5aQiDi0TVDywMMRBAcw/lq3XTCwsCw78DohfRO+1JnaMwlBXIr9+0Nx7BpZksgglwmsFv+/CbP0RTE8GQG9rKEAEnrvwpyqNAYERT1gmn3eZ4y319gTJTEyoujgMPdKvVmoC6DmyKrjfZoU2bJxEJNxaNKa11HkNjaifgxPNjGI77lA=
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(39860400002)(136003)(451199021)(36840700001)(40470700004)(46966006)(2906002)(82310400005)(86362001)(36756003)(40480700001)(36860700001)(7696005)(34020700004)(6666004)(186003)(336012)(426003)(47076005)(83380400001)(2616005)(26005)(107886003)(1076003)(478600001)(70206006)(40460700003)(4326008)(70586007)(41300700001)(110136005)(7636003)(356005)(82740400003)(54906003)(316002)(8676002)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 14:26:03.3560
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef5f400e-fe32-4b61-b0bf-08db4274564b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT103.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4122
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support port function commands to enable / disable IPsec packet
offloads, this is used to control the port IPsec device capabilities.

When IPsec packet capability is disabled for a function of the port
(default), function cannot offload IPsec operation. When enabled, IPsec
operation can be offloaded by the function of the port.

Enabling IPsec packet offloads lets the kernel to delegate
encrypt/decrypt operations, as well as encapsulation and SA/policy and
state to the device hardware.

Example of a PCI VF port which supports IPsec packet offloads:

$ devlink port show pci/0000:06:00.0/1
    pci/0000:06:00.0/1: type eth netdev enp6s0pf0vf0 flavour pcivf pfnum 0 vfnum 0
	function:
	hw_addr 00:00:00:00:00:00 roce enable ipsec_crypto disable ipsec_packet disable

$ devlink port function set pci/0000:06:00.0/1 ipsec_packet enable

$ devlink port show pci/0000:06:00.0/1
    pci/0000:06:00.0/1: type eth netdev enp6s0pf0vf0 flavour pcivf pfnum 0 vfnum 0
	function:
	hw_addr 00:00:00:00:00:00 roce enable ipsec_crypto disable ipsec_packet enable

Signed-off-by: Dima Chumak <dchumak@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c       | 20 ++++++++++++++++++--
 man/man8/devlink-port.8 | 13 +++++++++++++
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 90ee4d1b7b6f..a422ffe58f3b 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -2270,6 +2270,18 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			if (ipsec_crypto)
 				opts->port_fn_caps.value |= DEVLINK_PORT_FN_CAP_IPSEC_CRYPTO;
 			o_found |= DL_OPT_PORT_FN_CAPS;
+		} else if (dl_argv_match(dl, "ipsec_packet") &&
+			   (o_all & DL_OPT_PORT_FN_CAPS)) {
+			bool ipsec_packet;
+
+			dl_arg_inc(dl);
+			err = dl_argv_bool(dl, &ipsec_packet);
+			if (err)
+				return err;
+			opts->port_fn_caps.selector |= DEVLINK_PORT_FN_CAP_IPSEC_PACKET;
+			if (ipsec_packet)
+				opts->port_fn_caps.value |= DEVLINK_PORT_FN_CAP_IPSEC_PACKET;
+			o_found |= DL_OPT_PORT_FN_CAPS;
 		} else {
 			pr_err("Unknown option \"%s\"\n", dl_argv(dl));
 			return -EINVAL;
@@ -4548,7 +4560,7 @@ static void cmd_port_help(void)
 	pr_err("       devlink port unsplit DEV/PORT_INDEX\n");
 	pr_err("       devlink port function set DEV/PORT_INDEX [ hw_addr ADDR ] [ state { active | inactive } ]\n");
 	pr_err("                      [ roce { enable | disable } ] [ migratable { enable | disable } ]\n");
-	pr_err("                      [ ipsec_crypto { enable | disable } ]\n");
+	pr_err("                      [ ipsec_crypto { enable | disable } ] [ ipsec_packet { enable | disable } ]\n");
 	pr_err("       devlink port function rate { help | show | add | del | set }\n");
 	pr_err("       devlink port param set DEV/PORT_INDEX name PARAMETER value VALUE cmode { permanent | driverinit | runtime }\n");
 	pr_err("       devlink port param show [DEV/PORT_INDEX name PARAMETER]\n");
@@ -4678,6 +4690,10 @@ static void pr_out_port_function(struct dl *dl, struct nlattr **tb_port)
 			print_string(PRINT_ANY, "ipsec_crypto", " ipsec_crypto %s",
 				     port_fn_caps->value & DEVLINK_PORT_FN_CAP_IPSEC_CRYPTO ?
 				     "enable" : "disable");
+		if (port_fn_caps->selector & DEVLINK_PORT_FN_CAP_IPSEC_PACKET)
+			print_string(PRINT_ANY, "ipsec_packet", " ipsec_packet %s",
+				     port_fn_caps->value & DEVLINK_PORT_FN_CAP_IPSEC_PACKET ?
+				     "enable" : "disable");
 	}
 
 	if (!dl->json_output)
@@ -4874,7 +4890,7 @@ static void cmd_port_function_help(void)
 {
 	pr_err("Usage: devlink port function set DEV/PORT_INDEX [ hw_addr ADDR ] [ state STATE ]\n");
 	pr_err("                      [ roce { enable | disable } ] [ migratable { enable | disable } ]\n");
-	pr_err("                      [ ipsec_crypto { enable | disable } ]\n");
+	pr_err("                      [ ipsec_crypto { enable | disable } ] [ ipsec_packet { enable | disable } ]\n");
 	pr_err("       devlink port function rate { help | show | add | del | set }\n");
 }
 
diff --git a/man/man8/devlink-port.8 b/man/man8/devlink-port.8
index 534d2cbe8fa9..70d8837eabc0 100644
--- a/man/man8/devlink-port.8
+++ b/man/man8/devlink-port.8
@@ -80,6 +80,9 @@ devlink-port \- devlink port configuration
 .RI "[ "
 .BR ipsec_crypto " { " enable " | " disable " }"
 .RI "]"
+.RI "[ "
+.BR ipsec_packet " { " enable " | " disable " }"
+.RI "]"
 
 .ti -8
 .BR "devlink port function rate "
@@ -230,6 +233,11 @@ Set the migratable capability of the function.
 Set the IPsec crypto offload capability of the function. Controls XFRM state
 crypto operation (Encrypt/Decrypt) offload.
 
+.TP
+.BR ipsec_packet " { " enable " | " disable  " } "
+Set the IPsec packet offload capability of the function. Controls XFRM state
+and policy offload (Encrypt/Decrypt operation and IPsec encapsulation).
+
 .ti -8
 .SS devlink port del - delete a devlink port
 .PP
@@ -364,6 +372,11 @@ devlink port function set pci/0000:01:00.0/1 ipsec_crypto enable
 This will enable the IPsec crypto offload functionality of the function.
 .RE
 .PP
+devlink port function set pci/0000:01:00.0/1 ipsec_packet enable
+.RS 4
+This will enable the IPsec packet offload functionality of the function.
+.RE
+.PP
 devlink port function set pci/0000:01:00.0/1 hw_addr 00:00:00:11:22:33 state active
 .RS 4
 Configure hardware address and also active the function. When a function is
-- 
2.40.0

