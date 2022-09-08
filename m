Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 580C65B1AA4
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 12:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiIHKx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 06:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbiIHKxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 06:53:54 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB26F774C
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 03:53:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g9lGDEQXoBsuUSfuF/CJHED6uk2/5mxlDQjIUOCJMz2sJf2e15au7sZupIgyYcrr0w+769bKzrajaTNsqOfPzOlJGWm/CEXUxSAc/gkopcckP8kAMTWRkvdClLJSM6PmRF2N85NsFun/1X07vlk9mclEdvAXQk/HxnpzSYCJuDlC4i7KHlM+N1UeybZOOqKyikEIy1WNKxoTmZEyyhZBSsB/37IiozAxWOHFJBkTTk/asG7s0AHipiItolvjvBk8iCtVR1WM2DZfE2CKkW91sjH4ZEcAobHPLKEH1JWwE7tv5jw1MgJqNdE0lomOExwcdeuJr3rgk52PFK674cwj2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5xxkGFobN3xjCQk+3reBuc2mKwCTYbee0N0HWRTMH3g=;
 b=GmYon1Hs/uhkqy79+4COpyccrUF8d22QxNMGerUkP8O2Psvf6WTRqFtNpOvxCJk0VFGvWznYBtkVHB/enLFTLnD99bpgmjTQrB58S/lYP/ffKyAK86Kw96Ov+9ayn9GgoAowBLKqf/e6AZFyTvBEjDnaZ+GIirKaS9ko3nnSfIxXZqn2C3+/jMxX2wK/puuAddh48gsAirRbKjmwW7BBKwr1h8T9HaMhfGOWrQpGXT7k5pBjCh4aZoHymCMRhStqQXEQm7vm3T89X88cA7Z/JdIvYcaQRd5nGTCkKtbOgsj82fGHsZT6lBviHlc0pz9YbHDqi5hzoMkZp9jZdQnHXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5xxkGFobN3xjCQk+3reBuc2mKwCTYbee0N0HWRTMH3g=;
 b=WZadhWVCZbxLip8UAaEOU0jMavsL2PlsE58ERuWIwg70BPpIJQceniI7UwsaTK0Fh0xzcq14qsTQz6M4Si97bqCOkC+Y5adjURbNOq1TluqyovF3N75BiyqKoCOga+nLVSQ0fhfvOZXn2h6Nvyfb98ZdGFGaUi0kOSX3NSm3dOP5QjXecbuHPWbdfsVSLhkKZdSpFu09GvM1e8BMFWMSTxovsnlDNNbQSEL/OpNrVsjK8TGs3WW1sb9xE7DT2p6Cr/qFnYKXNF1eaeVBSmGXvprc8DGa+/6io0FQFnR+IH7SgDD1ji95L/cN9s1bnnPW2Xrfmday5Sa+MfCEau75xw==
Received: from BN0PR08CA0010.namprd08.prod.outlook.com (2603:10b6:408:142::11)
 by SA1PR12MB7296.namprd12.prod.outlook.com (2603:10b6:806:2ba::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.11; Thu, 8 Sep
 2022 10:53:50 +0000
Received: from BN8NAM11FT102.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:142:cafe::2a) by BN0PR08CA0010.outlook.office365.com
 (2603:10b6:408:142::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14 via Frontend
 Transport; Thu, 8 Sep 2022 10:53:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT102.mail.protection.outlook.com (10.13.177.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5612.13 via Frontend Transport; Thu, 8 Sep 2022 10:53:50 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Thu, 8 Sep
 2022 10:53:49 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 8 Sep 2022
 03:53:48 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.29 via Frontend Transport; Thu, 8 Sep
 2022 03:53:47 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <dsahern@kernel.org>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <raeds@nvidia.com>, <tariqt@nvidia.com>,
        "Emeel Hakim" <ehakim@nvidia.com>
Subject: [PATCH main v4 2/2] macsec: add user manual description for extended packet number feature
Date:   Thu, 8 Sep 2022 13:53:38 +0300
Message-ID: <20220908105338.30589-2-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20220908105338.30589-1-ehakim@nvidia.com>
References: <20220908105338.30589-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT102:EE_|SA1PR12MB7296:EE_
X-MS-Office365-Filtering-Correlation-Id: de332858-ebf0-47cb-dbc3-08da918869c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZvkFLq9Jk4W/THUWjH17+trPNdX+wfYAHvNvu71d9ECvE56oxEO+66QJDqCdtKma0IX9pBwGKKsoL0RcaGpFmCeK3flONEPtQsGkNPKWhLpLmvfWx6vyPnV4PM3sLeqNIo5Uk6ZiA+pC+HcTh/hpgg1ZJxd0vCo9BFhWX7k9hdvqfjxCqUX3Ozgpi7x8pfLHVoPsFJGQqcpyR4j3iLGI/B/v8Om6jQ7aEFlGooFfUzpHcO1s4aaD+S13VDgWro1VbKZRvkw2MruqABAWSB/9SWzJyCSZS9t+AvAIlET6vdozFzdNZdIkk0KyjsRhWtLvAjlpQo+WSxo0KcnaWRfbSVLZvyDz3mZvguUg1/1jOxL0dgnBUJrRO5c9Emw4jsTw5xDfISvpZywoofIebT2gRXekKhkUJybds0FchdbTGvOWa6OD827wO3Fgu4VwqALDIXZbeb5s5lJcTupmVrluBhBAmz8Rq07XGv3cFcvAHMUFCLDUp/BMiPkrC7iI8YoUZgNbDEE5t6F762FKc5+rrF2R0tvCj+/p8/u+TVEC9xpWkICKyfnjp6wh16ZLYm5tE8DywHShjKikZ756OI51qtcCLOV3bT2tV9ge+Knalx/i8lf8sq2kQBk5G7DIcq4gp59vmexM/wv+7km8b3Na589Lszx+PIw5t72+MzfX7G2Lc2BlH63hka1ueaxZnmtBh4AgMG+COIJO+//DYpqRxUotHFGS/koxCu8YYF7BkVa5fh/W/WnulaSR+sp+2Wa2wzz6breizIM7cSj8eukdqVj/cGr9xwjguJrj6gz4LOA=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(346002)(396003)(136003)(46966006)(40470700004)(36840700001)(107886003)(336012)(6666004)(186003)(2616005)(82310400005)(1076003)(478600001)(426003)(40480700001)(26005)(47076005)(41300700001)(7696005)(86362001)(81166007)(40460700003)(356005)(82740400003)(83380400001)(316002)(5660300002)(54906003)(36860700001)(8936002)(8676002)(2906002)(110136005)(36756003)(70206006)(4326008)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 10:53:50.1135
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de332858-ebf0-47cb-dbc3-08da918869c8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT102.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7296
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

V3->V4:
- Updated documentation.

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

