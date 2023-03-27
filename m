Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 253E06CAA0C
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 18:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbjC0QMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 12:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232731AbjC0QMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 12:12:37 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04hn2226.outbound.protection.outlook.com [52.100.161.226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A1D269D
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 09:12:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YVEWOFjEvlICFZOP3gPFDuXiklcYelxwDLwU5gTH743ZKvOS9PQ7OkqLmlIE/zJgolkh9BooaLA4S94m6YBZuS0eJ5eqESfnq3Nlw6mUk0aFVVeuYeLcgO899jf0NbZUYTbnzgDBWlSq1Qv1f4lE7qvG6Of4JVKaDn9vh5Xatx4NG92D7XK+fOvFRur/Krm6Qc46KwqRVPYcmUhsqarvuE76r8OJWa7/1IwbWlnHgCctfTVZ3o5l6TaoyGho8Umwmc07+21D/nqa1zCXs6qP2Gn8ZvYOLDF+/YJSAFs1RWZiPay6n8ETkLFl3axZcFr65e/PDPvTjnkn1S2Gqf7Xuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DF01rYsJJEiIOeQDirDBWGubYE66FOcsepALeWMazM8=;
 b=UfTABkj0z855wbtYCgfhtr5fn1CYBq6+0+7nvU8MYL0ucrcM09+pVfONouDUBaDLaixqByVmNyX/YjDCLdzVlv/dgLKqbeJMe9HgBDi7Y34SjhqhqVjpeJH7RHK4J8RpVWzT1gvAeBEDEJgZxHWtPVdg10Zg6MMXlV3N3owYIOyU3l9Jjg1llLEo404W87iYopCDwaoha3V7p8RfCRhWzZSK7xXA1cWl3h++0zw/IStA2ihUgING4j6qEF93vp3it8mLkRfpJgSVAt8vRtJWJiqJccdoAQDPkRVJKz7qYqiy3z18B1SJ+HwVVBIBx/wVa4v4rU1mp+E17ytKTGI4bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DF01rYsJJEiIOeQDirDBWGubYE66FOcsepALeWMazM8=;
 b=tw7W1LqVvFij1TxCUxlWqmcpsBTerIZOZz+jX/USBZbnaGvleED/Luop4L5jwApFgKxP9SW4HhtFal7tkDeswu7VsFmi8w72W6uHgcBGdyMfWjGeQc6+F9FJWHzQLtnaHkMYOZBWEdPJL7ozXXRvb5NSK9qz6Us4VFgYeVXA6pT3HAp630hWcL+FTCAHh5RF1nbU72JFV6KSXuyqVTJ2Ly/3VLpIzZy+/OMQw3uURlyY3HUhaqK5hK81+fVZVo2ApFNMjb3ADRIxAcw8MBDgh2htfm9j04BAjTO/myCK7Ih78R6KrLVXGY84PsWKMwQIs/U+O9I05+tJmvv07voWXQ==
Received: from MW4PR03CA0345.namprd03.prod.outlook.com (2603:10b6:303:dc::20)
 by DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Mon, 27 Mar
 2023 16:12:33 +0000
Received: from CO1NAM11FT074.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dc:cafe::d1) by MW4PR03CA0345.outlook.office365.com
 (2603:10b6:303:dc::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.42 via Frontend
 Transport; Mon, 27 Mar 2023 16:12:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT074.mail.protection.outlook.com (10.13.174.254) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.21 via Frontend Transport; Mon, 27 Mar 2023 16:12:32 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 27 Mar 2023
 09:12:24 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Mon, 27 Mar 2023 09:12:22 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next 2/2] man: man8: Add man page coverage for "ip address add ... proto"
Date:   Mon, 27 Mar 2023 18:12:06 +0200
Message-ID: <ee5dd4b00f8e2a08e820eb79a0f5db885f97124a.1679933269.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1679933269.git.petrm@nvidia.com>
References: <cover.1679933269.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT074:EE_|DM6PR12MB4202:EE_
X-MS-Office365-Filtering-Correlation-Id: 53dd7b57-0efc-43e7-bf55-08db2ede126a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: euDYyaTZsVwMvvp1UyZC0/4fiMtZsCzwBR8Ti8KKzUMMhnBRATELIZyzYR4d6ILaoKT9MoZfTbGWyKbOF51BivL+8oAjeNt4x32nwnAAAX4AOvXkFw1AU96jwl/UvwNx0C5xPvr8XogXy7YrOwkB+vaMwHFN/R+jpnI7HVVfTtc+XzVImaBVcP7haWUFYAvnfwPc782xIt4YpjMo8ddT9hoIiarfKF93tzOixmMLAnnB+Dm5XXD10p9uR/FDEyVzO2/vZTiTxXh2PdzTTEqA3LgF9YMOwF3abaY5xCCVUx8uQo830g+5KITYEo7D4ENp3sFv0HM07IqRUW79++Mm7aCQmgODpsRZBkZez6wl/FHOcGO3250YPdokud5hI78+FTI+tgBTM2O7pU+bV11UzkhxdmUX4Xe8ZzbVA/XpUPtO1qVStUTqQ2n9oA7BJ71ekaKmR74YK4jxv/lhF77l/U55w99xHqZSQLMx7XWfvXFMP1X6QU9mVBr5CEYDrv1ARo35bh23MXXpw3IauSeNyn55Hp5XUMV6yQ15CxtEAfp7eTGQyjSsN1j6u9PEr6OgHMEKF9XLa2kGPms9H3YpUhU3FOjqIBr4PT/rOAyquCzG1Lz4iOVIYHY3zD5LCVDxoUXLC9trGool0EVnJ78abPrDJLzy46i+zlCwfSfb1fET/ODZz6vEiLqkIALNjbvz4ICfoLvHRgybjhLcyxivZUqTcB4Tb8o8Fajp4rY554sf7e0+j0e/kTRBjfs0/ubJJyKIMYj9zpg7jnovqegCjsMW/Kx6Nnaia+RgxzAfaTP85kGhzaYck5HqOupNieuL
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(136003)(39860400002)(346002)(5400799015)(451199021)(36840700001)(46966006)(40470700004)(186003)(26005)(16526019)(7696005)(316002)(8676002)(4326008)(70586007)(70206006)(110136005)(41300700001)(478600001)(107886003)(6666004)(2616005)(5660300002)(8936002)(2906002)(66574015)(47076005)(426003)(83380400001)(336012)(7636003)(40460700003)(36860700001)(34020700004)(82740400003)(36756003)(86362001)(40480700001)(82310400005)(356005)(12100799027);DIR:OUT;SFP:1501;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 16:12:32.8410
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 53dd7b57-0efc-43e7-bf55-08db2ede126a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT074.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4202
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 man/man8/ip-address.8.in | 49 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 47 insertions(+), 2 deletions(-)

diff --git a/man/man8/ip-address.8.in b/man/man8/ip-address.8.in
index 1846252df92f..abdd6a2030a0 100644
--- a/man/man8/ip-address.8.in
+++ b/man/man8/ip-address.8.in
@@ -50,7 +50,9 @@ ip-address \- protocol address management
 .B vrf
 .IR NAME " ] [ "
 .BR up " ] ["
-.BR nomaster " ] ]"
+.BR nomaster " ]"
+.B proto
+.IR ADDRPROTO " ] ]"
 
 .ti -8
 .BR "ip address" " { " showdump " | " restore " }"
@@ -66,13 +68,19 @@ ip-address \- protocol address management
 .B  label
 .IR LABEL " ] [ "
 .B  scope
-.IR SCOPE-ID " ]"
+.IR SCOPE-ID " ] [ "
+.B proto
+.IR ADDRPROTO " ]"
 
 .ti -8
 .IR SCOPE-ID " := "
 .RB "[ " host " | " link " | " global " | "
 .IR NUMBER " ]"
 
+.ti -8
+.IR ADDRPROTO " := [ "
+.IR NAME " | " NUMBER " ]"
+
 .ti -8
 .IR FLAG-LIST " := [ "  FLAG-LIST " ] " FLAG
 
@@ -288,6 +296,36 @@ flag when adding a multicast address enables similar functionality for
 Openvswitch VXLAN interfaces as well as other tunneling mechanisms that need to
 receive multicast traffic.
 
+.TP
+.BI proto " ADDRPROTO"
+the protocol identifier of this route.
+.I ADDRPROTO
+may be a number or a string from the file
+.BR "/etc/iproute2/rt_addrprotos" .
+If the protocol ID is not given,
+
+.B ip assumes protocol 0. Several protocol
+values have a fixed interpretation. Namely:
+
+.in +8
+.B kernel_lo
+- The ::1 address that kernel installs on a loopback netdevice has this
+  protocol value
+.sp
+
+.B kernel_ra
+- IPv6 addresses installed in response to router advertisement messages
+.sp
+
+.B kernel_ll
+- Link-local addresses have this protocol value
+.sp
+.in -8
+
+.sp
+The rest of the values are not reserved and the administrator is free
+to assign (or not to assign) protocol tags.
+
 .SS ip address delete - delete protocol address
 .B Arguments:
 coincide with the arguments of
@@ -400,6 +438,13 @@ inverse of
 This is an alias for
 .BR temporary " or " secondary .
 
+.TP
+.BI proto " ADDRPROTO"
+Only show addresses with a given protocol, or those for which the kernel
+response did not include protocol. See the corresponding argument to
+.B ip addr add
+for details about address protocols.
+
 .SS ip address flush - flush protocol addresses
 This command flushes the protocol addresses selected by some criteria.
 
-- 
2.39.0

