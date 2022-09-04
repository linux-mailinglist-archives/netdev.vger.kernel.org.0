Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92A575AC34F
	for <lists+netdev@lfdr.de>; Sun,  4 Sep 2022 09:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233408AbiIDHsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 03:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233476AbiIDHsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 03:48:10 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2071.outbound.protection.outlook.com [40.107.96.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B9747B88
        for <netdev@vger.kernel.org>; Sun,  4 Sep 2022 00:48:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C4l7X6mzK3dlLCL10TUPYtPtC3uCf+xx7uf6LBm2/5D/b4Jg+l1Iu5xvhc7/UEhZr7dJxr8QzsXnQ/9KnuimUDeCDYernoLn91VzxgrUsG7X/UpIGRgMvMqMtgtq7Ot3IL6TaliXvw8brzLvr7vITx7SIOynKn51Y1V+FE5a/0yLVtUkw1WS8jHHE+d8CHCYoKppp/2mxT637/S5g7kTsharonr4VwvrqF2QPzvpvyxew++rzG0f5yy5S4dmgpS19g6mnlgDm37QPpnaMiCtzKyAUGW0mJSYFCxxZWtWIYiqjBaTIuEWfw+Qs6ZdiKE7wjsawk7XuvtEUZaclz0w7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gkd3LTmLYSfjQMuvvcnTumxzpmo+BGps75chov4GjgQ=;
 b=Hr/y4wz6JmBGCo3GlIN4IPoqk43DeG0aVXlWgT0+ieclcXi6zetuCcpYugPB02+uI1QAZaN7U0dxxIxrROennS/QHsov4sS1Dbjn3nMwvG3G4Argp+u7fEhwqlY0JUV1sa4NSjHPnGXgG7rtnpIHJG/YjdlBJTo0vl5HMoHaFegjRhcyBD8HzbBrGgLZkL6IictWmTPc5KGmi57WbF+C/zG0AP0QfdTU9hlIpcu6B2TJ6omGMTPCSoGY5bXsdcKlt2TNFizFLjvbRXLCe2b1lfpcbJfzrt5MgyJdhNe1nFkOC38x/2R2gTGzNk0wEOR0ZRGpW3rsyvMSRkZ7DJYiZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gkd3LTmLYSfjQMuvvcnTumxzpmo+BGps75chov4GjgQ=;
 b=lHxmTFwSrcGwDgW91iyTm1oDUCs2dgrczF+eZJ4uQ1ezctK6JnQyBABm8QHo/r9WYrgChOjVI/2QLFtnkhFMxFY8L8Ii+G3MPVmS9gUtE43RfWrlqco+lbQamR6HHCvSwFpcNI+zDOzebapeVSoljs8hzOcOoBgjjDJayAUTDJ5DnVNmCJBVmfAN9oqZDUe6i7G8o0CGE2g8sRPQ0LgXCyn4XEY76WvGqKObhpezKYZ72PwZORNK7mUYZNb+jzhezBgsTNVH9vJiBNGz58VboSSeoToOUdr93YDmgh3EXpe0yGGsM5S5KD7h04vE//ovFqji/O9AUtsXKF3x0iNWGQ==
Received: from MW4P221CA0026.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::31)
 by LV2PR12MB5727.namprd12.prod.outlook.com (2603:10b6:408:17d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.16; Sun, 4 Sep
 2022 07:48:05 +0000
Received: from CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8b:cafe::58) by MW4P221CA0026.outlook.office365.com
 (2603:10b6:303:8b::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12 via Frontend
 Transport; Sun, 4 Sep 2022 07:48:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT007.mail.protection.outlook.com (10.13.174.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5588.10 via Frontend Transport; Sun, 4 Sep 2022 07:48:05 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Sun, 4 Sep
 2022 07:48:04 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Sun, 4 Sep 2022
 00:48:04 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.29 via Frontend Transport; Sun, 4 Sep
 2022 00:48:02 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <dsahern@kernel.org>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <raeds@nvidia.com>, <tariqt@nvidia.com>,
        "Emeel Hakim" <ehakim@nvidia.com>
Subject: [PATCH main v3 2/2] macsec: add user manual description for extended packet number feature
Date:   Sun, 4 Sep 2022 10:47:29 +0300
Message-ID: <20220904074729.4804-2-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20220904074729.4804-1-ehakim@nvidia.com>
References: <20220904074729.4804-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e53972d-482c-4723-d22f-08da8e49cd2c
X-MS-TrafficTypeDiagnostic: LV2PR12MB5727:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +9CkKKZ/0cBQB+f/Z4Y/Ji2Pg8c5WjyPoYkzxOzgKt2PQKuOJTjGGDesk9l75G839TBIuskmY6D4/h3GaTPv/EkZ14bbXfuVhaQeMZl4soVGDWDce6asyHJZtn/UOwgRcpPKZhllQkmSjYysxZYMC5F3zKO7ww7DGaxgkpyUxfre9HN0SKWRkD+aEW7gO0XV94cAMvjs8R+w/k6a4faEo6dlEAar3Z7zegY6SnChBVfaQwgzyRS3mmCMqhTHmdx4hQDx88QkIbZn7wZId78icgQZj6PSxKJQ5Kk3iw7TAz1tRO8uQLU2HIh9Tzg40jUhhCyiFOrljQ0b7stad9zUq/t6Ajhmro3sOBpneE002qpB6UGTXALlUOq37ottzNcc6TOtGh4XhVdWVriCU22B8NP0C0I7mvIznsRH9dU70wJMqxxso4P4K2cY8te+YmxcfhwtD/vn6nr4zXjuss8TolboFq0W5aM/lW5JcP9/iQBQUpg4azgseuHiryDRoksHz4dYNZmbGC9mG5uEpreoE+H65qAfJNUtEREkflHwi6YUuPhWSzWIPvQ0ZlJ5Rf2YjNoFTrIsz7MH08ukmAdOULq0cTHnHxXwRxHxY4+9uk8OyaPn6QIeU9ZTt7W9Q20aO8+BjYitbPF60251Y0Bn5Vs6AszeteveSmSm0GUcG5QtL/JWQbuy1j6ZjS2ABgfIxiG+2ocrxgatZ3W0I+SN1MjOEuT8spwbiT66VylEsF8r1t+5Cn+G6rd5x4imebcvxz423qS/TcsInE4l5h1eE0Sv6Zqit1pGnhzuTVoxpzY=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(136003)(376002)(346002)(36840700001)(46966006)(40470700004)(356005)(81166007)(8676002)(36860700001)(40460700003)(4326008)(83380400001)(82310400005)(70206006)(110136005)(316002)(70586007)(54906003)(40480700001)(5660300002)(2616005)(8936002)(82740400003)(26005)(2906002)(426003)(1076003)(47076005)(186003)(336012)(6666004)(7696005)(478600001)(41300700001)(86362001)(107886003)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2022 07:48:05.1276
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e53972d-482c-4723-d22f-08da8e49cd2c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5727
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the user manual describing how to use extended packet number (XPN)
feature for macsec. As part of configuring XPN, providing ssci and salt is
required hence update user manual on  how to provide the above as part of
the ip macsec command.

Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
V1->V2: 
- Updated documentation.

V2->V3:

 man/man8/ip-macsec.8 | 52 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 51 insertions(+), 1 deletion(-)

diff --git a/man/man8/ip-macsec.8 b/man/man8/ip-macsec.8
index bb816157..991a775a 100644
--- a/man/man8/ip-macsec.8
+++ b/man/man8/ip-macsec.8
@@ -19,6 +19,7 @@ ip-macsec \- MACsec device configuration
 .BR scb " { " on " | " off " } ] ["
 .BR protect " { " on " | " off " } ] ["
 .BR replay " { " on " | " off " } ] ["
+.BR xpn " { " on " | " off " } ] ["
 .BI window " WINDOW"
 ] [
 .BR validate " { " strict " | " check " | " disabled " } ] ["
@@ -63,7 +64,13 @@ ip-macsec \- MACsec device configuration
 
 .IR OPTS " := [ "
 .BR pn " { "
-.IR 1..2^32-1 " } ] ["
+.IR 1..2^32-1 " } |"
+.BR xpn " { "
+.IR 1..2^64-1 " } ] ["
+.B salt
+.IR SALT " ] ["
+.B ssci
+.IR <u32> " ] ["
 .BR on " | " off " ]"
 .br
 .IR SCI " := { "
@@ -75,6 +82,8 @@ ip-macsec \- MACsec device configuration
 }
 .br
 .IR PORT " := { " 1..2^16-1 " } "
+.br
+.IR SALT " := 96-bit hex string "
 
 
 .SH DESCRIPTION
@@ -116,6 +125,29 @@ type.
 .nf
 # ip link add link eth0 macsec0 type macsec port 11 encrypt on offload mac
 
+.SH EXTENDED PACKET NUMBER EXAMPLES
+.PP
+.SS Create a MACsec device on link eth0 with enabled extended packet number (offload is disabled by default)
+.nf
+# ip link add link eth0 macsec0 type macsec port 11 encrypt on xpn on
+.PP
+.SS Configure a secure association on that device
+.nf
+# ip macsec add macsec0 tx sa 0 xpn 1024 on salt 838383838383838383838383 ssci 123 key 01 81818181818181818181818181818181
+.PP
+.SS Configure a receive channel
+.nf
+# ip macsec add macsec0 rx port 11 address c6:19:52:8f:e6:a0
+.PP
+.SS Configure a receive association
+.nf
+# ip macsec add macsec0 rx port 11 address c6:19:52:8f:e6:a0 sa 0 xpn 1 on salt 838383838383838383838383 ssci 123 key 00 82828282828282828282828282828282
+.PP
+.SS Display MACsec configuration
+.nf
+# ip macsec show
+.PP
+
 .SH NOTES
 This tool can be used to configure the 802.1AE keys of the interface. Note that 802.1AE uses GCM-AES
 with a initialization vector (IV) derived from the packet number. The same key must not be used
@@ -125,6 +157,24 @@ that reconfigures the keys. It is wrong to just configure the keys statically an
 indefinitely. The suggested and standardized way for key management is 802.1X-2010, which is implemented
 by wpa_supplicant.
 
+.SH EXTENDED PACKET NUMBER NOTES
+Passing flag
+.B xpn
+to
+.B ip link add
+command using the
+.I macsec
+type requires using the keyword
+.B 'xpn'
+instead of
+.B 'pn'
+in addition to providing a salt using the
+.B 'salt'
+keyword when using the
+.B ip macsec
+command.
+
+
 .SH SEE ALSO
 .br
 .BR ip-link (8)
-- 
2.21.3

