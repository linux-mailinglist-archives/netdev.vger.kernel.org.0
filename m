Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3D525B4CFE
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 11:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiIKJ1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 05:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiIKJ1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 05:27:16 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934C9248C9
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 02:27:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A7Sb+gBwixzEEXFvjfmdm6NNngl9OMcC64zgSeXOLiS9/HNzW71zgbgt1gSJZHLYCUwnLrSGysZWjSxcpft6ksWGLVVtTyO/5cTtdWZA34W1dkGjzzV7+cT9F3K/vj6oJ/1bZp7v1DNxUig5OX2aN+q3wVE7RGqgMLuOYu9ItPAiPNrflleHzYozIPpNgY9gA+PDpRGCq8Ttpsx64y4ZBx+JFQoh+6vYKcYdAMxt6lVMLcSs3aDP/tiPGFJW0Kx0rxCj8NXEkgbzLs5RX/XYMtGoErZie35Y26yqk+bbTAxjCqjiQizXvhuXOPNT737vH7F3Fv/aP9yr0DF4hw4kPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Xns9eOU6pLDcJHTtnpNqXg4fN5uK4Lk+DKTvnm0Ikg=;
 b=bE+Gz8yLPMZ7Z4wa/+IVYRNO+RU6XzTwfUVPsbsA/XLm1daflJw+Fv6rcLPTU1rMvLaaiqthKQprZ0Vc/62+o9kUE9SHrafqiWZLvTkv8QalfQLs6ExGsPCSnBJOtjn6nDJ9pNWd/tYjq601aJJFpHci85cu8n6/f67vLlIAuej+205oxrdGdTRSAX6P0dmrdvTnaJGlIc1FpJwCxpAYd/x2upIPLwxUv+MRYiOb/KemEsANN4m3LhVcQKRGiQAkujHlEmz7p1cSEcyInxxqXnDHM4BDCE0wPVFEgTppotJbnsMe4u/60EBG9q44hTa1k72SlcpWVqWYEzO++XHsIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Xns9eOU6pLDcJHTtnpNqXg4fN5uK4Lk+DKTvnm0Ikg=;
 b=LDCXCBctiQ83aB7uWbwFM943/JSil+1QiWVXqAB2pZVrMvuwprW7YHtpGXgWuP3XU8bRVDbHzpoIb58k2a2LY1Q5bYHPmCjbTic0WqXrYSSPMtYsDooD5/EaWuOjUhYR/c6ByZco90Lu06fzv8FdKPXr0zTyxyWTi83mWZ6SSIMKGW1Vg+3WNMAtLEw/szrE/OQHDk2mAnvbIk6/t0Nlpde5JjzyFQZVU5yjep7DKIZKH60LGp5xD8K+s2qq/VWp/hCqnSI5xyvpA6nYtqoBPPtFYljWCcDWm8uEf42zGL9A6AEcfupJPvGR9DqgW0f3oqduRiquu5uW59zb22GMJw==
Received: from MW2PR16CA0062.namprd16.prod.outlook.com (2603:10b6:907:1::39)
 by CH0PR12MB5385.namprd12.prod.outlook.com (2603:10b6:610:d4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Sun, 11 Sep
 2022 09:27:13 +0000
Received: from CO1NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:1:cafe::8) by MW2PR16CA0062.outlook.office365.com
 (2603:10b6:907:1::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22 via Frontend
 Transport; Sun, 11 Sep 2022 09:27:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT047.mail.protection.outlook.com (10.13.174.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5612.13 via Frontend Transport; Sun, 11 Sep 2022 09:27:12 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Sun, 11 Sep
 2022 09:27:12 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Sun, 11 Sep
 2022 02:27:11 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.29 via Frontend Transport; Sun, 11 Sep
 2022 02:27:09 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <dsahern@kernel.org>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <raeds@nvidia.com>, <tariqt@nvidia.com>,
        "Emeel Hakim" <ehakim@nvidia.com>
Subject: [PATCH main v5 2/2] macsec: add user manual description for extended packet number feature
Date:   Sun, 11 Sep 2022 12:26:56 +0300
Message-ID: <20220911092656.13986-2-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20220911092656.13986-1-ehakim@nvidia.com>
References: <20220911092656.13986-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT047:EE_|CH0PR12MB5385:EE_
X-MS-Office365-Filtering-Correlation-Id: 6aae8803-049e-4279-c4b3-08da93d7cf29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AjX+12GfqR8mAhsu5H6OpMACpHmkVEncvpqOkMI5ayOuzUNHLHYvainYcROSKhDyJEsuGxKcQ0XIxb8tpJr/V0U0aUK3FZ1AwUFJx8uP6OiSrljh1aCgfd7+iuV6A64pHlKg7OpogCaA4DG4HRXQw70lRVQpkfuZ928U3wMM6qMgeM6xIpSMy5/p0kJaRCd53fO8Ee4sdwA//a9l/CTYUY1SU4qXH2klQz7vBVQj8KtegTUdO+176W4frjZxWjvSauNwY0vLaSbIvJc91W3u2AcnnybA07lqcV9Y6L2XJXJj9rAg6UT9Mvi3qZEaTQ0qIWH5oaNQjuvsveqo+i3yFc3a+g5jwzudXbGxNhm7Y2nykShC+l5mOFUrdrTsnCVPjkQGZWbcZ3r4QFBLxT0aAIwhmvpQtvWtU+2kmU6KKPWyLUfRIRpikzqts6htMzcqrU5b1WJ23xjORyoqnDGupERPMBZ0lSz2ZmPnb1Gsjftuqjdj9z73JDKwgmMkhKmKfQlrAmC2Y9Picr83sPPE3S2zt4bllwa9+j9+srSg4tTwY0+LCC96G5+RXYaavHFK4aLhzLlADJDqJrBELSBY7bg5vtbAO0on6c56FPKtEbSi3UciRHfdKUWCU9tmJhwMnMXEtvB+aJQbXkZEknwCOxTwQ8ys8j0c5wCamQ16D0tL0JrC/MQxUi5tY97c/f2Le2TQzKwFDS3iy5gtEl5e92nB1PrEymkcn3dh18liNv7n5g+OuyzGy5ljYau63A0fXo8E/tQo3BFxuAPVOxGR6tQ1yqwXX5KYw0/T2llbbSg=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(396003)(39860400002)(136003)(36840700001)(46966006)(40470700004)(40480700001)(86362001)(40460700003)(36860700001)(81166007)(82740400003)(82310400005)(356005)(70586007)(70206006)(4326008)(8936002)(6666004)(107886003)(5660300002)(41300700001)(110136005)(8676002)(1076003)(478600001)(316002)(54906003)(47076005)(426003)(2616005)(186003)(83380400001)(26005)(2906002)(7696005)(336012)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2022 09:27:12.8125
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6aae8803-049e-4279-c4b3-08da93d7cf29
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5385
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

V3->V4:
- Updated documentation.

V4->V5:

 man/man8/ip-macsec.8 | 57 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 2 deletions(-)

diff --git a/man/man8/ip-macsec.8 b/man/man8/ip-macsec.8
index bb816157..1a144853 100644
--- a/man/man8/ip-macsec.8
+++ b/man/man8/ip-macsec.8
@@ -10,7 +10,7 @@ ip-macsec \- MACsec device configuration
 |
 .BI sci " <u64>"
 ] [
-.BR cipher " { " default " | " gcm-aes-128 " | " gcm-aes-256 " } ] ["
+.BR cipher " { " default " | " gcm-aes-128 " | " gcm-aes-256 " | " gcm-aes-xpn-128 " | " gcm-aes-xpn-256 " } ] ["
 .BI icvlen " ICVLEN"
 ] [
 .BR encrypt " { " on " | " off " } ] ["
@@ -63,7 +63,13 @@ ip-macsec \- MACsec device configuration
 
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
@@ -75,6 +81,8 @@ ip-macsec \- MACsec device configuration
 }
 .br
 .IR PORT " := { " 1..2^16-1 " } "
+.br
+.IR SALT " := 96-bit hex string "
 
 
 .SH DESCRIPTION
@@ -116,6 +124,29 @@ type.
 .nf
 # ip link add link eth0 macsec0 type macsec port 11 encrypt on offload mac
 
+.SH EXTENDED PACKET NUMBER EXAMPLES
+.PP
+.SS Create a MACsec device on link eth0 with enabled extended packet number (offload is disabled by default)
+.nf
+# ip link add link eth0 macsec0 type macsec port 11 encrypt on cipher gcm-aes-xpn-128
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
@@ -125,6 +156,28 @@ that reconfigures the keys. It is wrong to just configure the keys statically an
 indefinitely. The suggested and standardized way for key management is 802.1X-2010, which is implemented
 by wpa_supplicant.
 
+.SH EXTENDED PACKET NUMBER NOTES
+Passing cipher
+.B gcm-aes-xpn-128
+or
+.B gcm-aes-xpn-256
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
+keyword and ssci using the
+.B 'ssci'
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

