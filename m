Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D64E6570476
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 15:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbiGKNjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 09:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbiGKNjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 09:39:10 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE94841D02
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 06:39:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cvEXLqwlXXdBU6K7Hgqc/aLm28R1nhTgVYdvZH25XkVbDSxxQ1VzLvjxaPW5XCYSOrWgL8MQnlU9AWhC1IIPSU/SjNLKZsYf75t6wJc3yJd75ofpOhrEv/Yw4ok5NelcSgn8dGuH1pnYNRW8HHfO9diSG/RBIU9mJT+8+sVlWMcHSU1OPZSB0/ue4h0rOKx+3ZSywnehTYU6G405EDD98gnXGgBMN2T8MPk3CrU8zvOnIoVf355XXa1+ty5eBs5dqnhSlUihQzWYdnZQZo1qshWTyVIHBhjYv+junHLMWMyfmW42T84Fktw7pdF6QhWXHfhokBiMGDCCTzoONvC6lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QSt3s4qG6kF1UFapma74HtcyQ2K9K1m/r0uJsfocKng=;
 b=OFXr/3vCgikBCl10QPqf8y6zfQe4dL5Sv14nKMe5Ka6YyZUMMGCnGK9YZPBpcYz4Ur9ZOshKXGIxNEULQnTjwaglMX3ynlzIeD7H/1JqqJ22ZYvrqrTEZrAF20iJWfkgx9mv1u6eDG2OPeHusOnPRceSYz0/GZJGmZzHf4xHnPY9fp5Qj8RB7oCvxAvHRYeO8gvju+Pd2fkfdo6GyP486ZQ8d1f43BE3l8wGWHGKKUPYVj22QWm9xPqSCytc7r3bEAVq+NSboJZg4t0oZwA3tgQSqKh1pIvFG6l93msn/JYcehDG68VwBcO43JS36vmBI+FiN7lMcmu0p4ZyLueM4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QSt3s4qG6kF1UFapma74HtcyQ2K9K1m/r0uJsfocKng=;
 b=slpmeiZn+npm0Y2Gxf3ScIvt+uCnMGEtrtDWUTAjR9Fs/scxIdtKv6jflKPsVVNQ88e2AhS0NbwxOxo8uujtYY4/Ag1WSpXqi+DKIppCwnIax+GYpmcOykjzqxC4Cgw8so9cJvdWYBYl5zyjXslYPVdBjZ80LKRvH8kS4mLvjPu7UxIRPlUy+1khX+gn6zBesTxIh9Bw8mL/N2N+a7dhdRGyr27YPcseW4LcB4aQxj/RWH+aA8d6IMcwhqY/V/kzvvu9jjHv1SRZgcVsKEkCO2Tr4n14S1C2e4lWrIQKzqHMOotbiss+iXo4adj7n2R0OER26pxk5erMJjHASRPFaw==
Received: from DM6PR06CA0061.namprd06.prod.outlook.com (2603:10b6:5:54::38) by
 MWHPR1201MB2525.namprd12.prod.outlook.com (2603:10b6:300:e0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Mon, 11 Jul
 2022 13:39:06 +0000
Received: from DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:54:cafe::f4) by DM6PR06CA0061.outlook.office365.com
 (2603:10b6:5:54::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.17 via Frontend
 Transport; Mon, 11 Jul 2022 13:39:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT041.mail.protection.outlook.com (10.13.172.98) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5417.15 via Frontend Transport; Mon, 11 Jul 2022 13:39:06 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Mon, 11 Jul 2022 13:39:05 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Mon, 11 Jul 2022 06:39:05 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.182)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Mon, 11 Jul
 2022 06:39:03 -0700
From:   <ehakim@nvidia.com>
To:     <dsahern@kernel.org>, <netdev@vger.kernel.org>
CC:     <raeds@nvidia.com>, <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH v1 3/3] macsec: add user manual description for extended packet number feature
Date:   Mon, 11 Jul 2022 16:38:53 +0300
Message-ID: <20220711133853.19418-3-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20220711133853.19418-1-ehakim@nvidia.com>
References: <20220711133853.19418-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4020405c-6a25-4cf0-9ee4-08da6342ba23
X-MS-TrafficTypeDiagnostic: MWHPR1201MB2525:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6vc/1Fvj0sAXiWlF7mqF6ZDDXge57BykncJNMxIwNEc687RnYpgVW1WGOku9iIlF0DFQ06kXy6krdQ2jJgILwUqLfCxxew2OKTT/A6/R1qBZaba1b7GWzi5moaLOaD7u5oqvSNh7STKGXo3FlGmBggfeRjJIEdDMUmpA5LZfs2GYpY9JZgpw2oMydUbEeqynSJGvl7DdiDjLXwDJbMlWyF2oe3yym+gNkKoeIfUU6WBAACjhKfTW3dn2R0OrRCREsCGSmNhQx3DdLAnXDZ/4T7E5TFUuNFTv5OYBYvBCY7slKqKvhsIrSVa1xaABCUL48RApiZj0HEAJXk6SedstNymns0m1Y8pIs0ZjVDekbEIrjlFJfKpo8S9Bj7m8gqO21qcbbZwb0Yd8oF+xjd1iABU4cu9sPlrPJHStjN4VMMjF/KVwXacZmPOUx3iirY3FYj1ev1Sr1q3TE51wSIlG0diE9WdMEnTvIR1ayMzQeyAq3Irlx6eajry2fng8vVuHmlOiu6Zkn7c/ILrBxhCHqRrLeqY8nF3+rmNZvrA/MTa2UDrOGn4z34v11+H/siiVjY7zPOlI5Sl9EkF7aMYBpJpdWTziE7F3C2QubANXHnugstbWFBtEWSxPDpmeJB1263fOp9IvuQux9ox3NtLeoc1hXC0mZ6YOPEIhYn8sQJbTSSMy9ghQ5AKMMFSKUer3aOgyyOYCwoKr2wmVTtyaF/+LCMNitFCd/ByS0iHHXc6IdWNmJMHAbmVuUwspuXtJZHTRSJMOXs/iQrBsjyJIeUxFuZIcmWcX4Huph9qSbtd2dS1FAds0OyUDam504B5BbAibmzfxftStgAjW2nfez0mdhdPMQwk8TbB0XdzZ2n4=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(376002)(136003)(396003)(46966006)(40470700004)(36840700001)(4326008)(70206006)(70586007)(2616005)(110136005)(54906003)(8676002)(41300700001)(83380400001)(40480700001)(6666004)(82310400005)(40460700003)(478600001)(5660300002)(2876002)(8936002)(2906002)(336012)(36860700001)(356005)(82740400003)(86362001)(36756003)(47076005)(107886003)(81166007)(426003)(316002)(1076003)(7696005)(26005)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 13:39:06.6984
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4020405c-6a25-4cf0-9ee4-08da6342ba23
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB2525
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emeel Hakim <ehakim@nvidia.com>

Update the user manual describing how to use extended packet number (XPN)
feature for macsec. As part of configuring XPN, providing ssci and salt is
required hence update user manual on  how to provide the above as part of
the ip macsec command.

Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
 man/man8/ip-macsec.8 | 52 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/man/man8/ip-macsec.8 b/man/man8/ip-macsec.8
index bb816157..67bb2c23 100644
--- a/man/man8/ip-macsec.8
+++ b/man/man8/ip-macsec.8
@@ -24,6 +24,8 @@ ip-macsec \- MACsec device configuration
 .BR validate " { " strict " | " check " | " disabled " } ] ["
 .BI encodingsa " SA"
 ] [
+.BI flag " FLAG"
+] [
 .BR offload " { " off " | " phy " | " mac " }"
 ]
 
@@ -64,8 +66,17 @@ ip-macsec \- MACsec device configuration
 .IR OPTS " := [ "
 .BR pn " { "
 .IR 1..2^32-1 " } ] ["
+.BR xpn " { "
+.IR 1..2^64-1 " } ] ["
+.B salt
+.IR <u94> " ] ["
+.B ssci
+.IR <u32> " ] ["
 .BR on " | " off " ]"
 .br
+.IR FLAG " := "
+.BR xpn "
+.br
 .IR SCI " := { "
 .B sci
 .IR <u64> " | "
@@ -116,6 +127,29 @@ type.
 .nf
 # ip link add link eth0 macsec0 type macsec port 11 encrypt on offload mac
 
+.SH EXTENDED PACKET NUMBER EXAMPLES
+.PP
+.SS Create a MACsec device on link eth0 with enabled extended packet number (offload is disabled by default)
+.nf
+# ip link add link eth0 macsec0 type macsec port 11 encrypt on flag xpn
+.PP
+.SS Configure a secure association on that device
+.nf
+# ip macsec add macsec0 tx sa 0 xpn 1024 salt 838383838383838383838383 on key 01 81818181818181818181818181818181
+.PP
+.SS Configure a receive channel
+.nf
+# ip macsec add macsec0 rx port 1234 address c6:19:52:8f:e6:a0
+.PP
+.SS Configure a receive association
+.nf
+# ip macsec add macsec0 rx port 1234 address c6:19:52:8f:e6:a0 sa 0 xpn 1 salt 838383838383838383838383 on key 00 82828282828282828282828282828282
+.PP
+.SS Display MACsec configuration
+.nf
+# ip macsec show
+.PP
+
 .SH NOTES
 This tool can be used to configure the 802.1AE keys of the interface. Note that 802.1AE uses GCM-AES
 with a initialization vector (IV) derived from the packet number. The same key must not be used
@@ -125,6 +159,24 @@ that reconfigures the keys. It is wrong to just configure the keys statically an
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
2.26.3

