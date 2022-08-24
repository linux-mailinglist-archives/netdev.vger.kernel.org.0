Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4135E59F614
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 11:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235697AbiHXJS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 05:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235897AbiHXJSZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 05:18:25 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2047.outbound.protection.outlook.com [40.107.94.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9846280003
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 02:18:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gXpgi0INtfy6VpZpmf7luDFN3oZSTcL9RELTcQC1KsIM4f1g/LpUJBfg2BDMYQT1vMPwqUURTCXJjGTkOgyvSKWhdSyGoo4Dabwzsd9Hoe0uhqUv7JzZ26OmJXzPP9vrPUs4wiu/YfyOdvdEnwgXyMSw8KvOJ56+LdGqj/HmHxv1GcC4eaNIS5ZSz2LzY7q/qKv1rGa6r7fyXroBduupZgO6XoHmvhTXHzBYoV7MKv+7OpC2EP75+6VQZgMXOu40izNEWNEYwsm2eGN1ETGpQctdOKjnR4/oc3Ers/eEidTxxmMLFMtLqQWryWXP0UbeIWv2nA7WYIPtmpWismCYKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=200DpO8DyYR1D8hLMK54xjTWdVA4VfBAZxeJGiqDUkk=;
 b=fK7M+8zH3VEnZhtcQ9qS3Ppyu6xtCz5twoefyniC6MjksLpVezwN+IitqYgynuiWK7JDnLtobUJp59wgNP4UhxEwZ3+GkAUoGU2ZWfy8Tcb9uTSFIr699Lb8zwaRGpMev/rWveP5M6mVDLdFDD7q9Wac4dq2ilovuzECQX9tFvrMY74oLLNYLV0LvAMQvpMVScd9p0tOhKYWqlnqSugFAVeiCUiTlp+2+txduwiOjgX8z8o07FIzcZ5yHpQLq+KqSTrObGDiI7Ox/uF9qMjsBtSeYN0jE84NLlUFKJ+0OSRnTlVMNyCyWO8hFRE0Ezp7TxEJuIOydu8Y+CBFTLOysQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=200DpO8DyYR1D8hLMK54xjTWdVA4VfBAZxeJGiqDUkk=;
 b=dvdXYEKXaakQjcSuTKaKpiY27UIgBTMEoVUG8NvKQjhkOC81UGSnafrMTewFywCh5NbZkTCjJ/+rN04cVFYIxxyQVeUc3o5KNJebPj3OsfFYH2DjlGhtNP6/vbqwlMHsvdOutTk7PzS6JUhEEf12NSzqV2Wvj7UTP71ThXfX5UHuG/wilA62Fi7Pbrq5BbdiQ4GDMIab2XmGGv/B4OFFGoRxGRaQW7xAxsCOAAhPgdS6njfdqMMR7/aY+JSnx8Mpod5U01SSWN70gWmW/Ad3b9IABVsaBVqtBXHbxQPFBsumehgGyPSezkVZaPHI8EV3S4rz0lCX2B/s7bbIhYEJ1g==
Received: from MW4PR04CA0298.namprd04.prod.outlook.com (2603:10b6:303:89::33)
 by MN0PR12MB6126.namprd12.prod.outlook.com (2603:10b6:208:3c6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Wed, 24 Aug
 2022 09:18:23 +0000
Received: from CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::47) by MW4PR04CA0298.outlook.office365.com
 (2603:10b6:303:89::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21 via Frontend
 Transport; Wed, 24 Aug 2022 09:18:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT028.mail.protection.outlook.com (10.13.175.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5566.15 via Frontend Transport; Wed, 24 Aug 2022 09:18:22 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Wed, 24 Aug
 2022 09:18:21 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 24 Aug
 2022 02:18:21 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.29 via Frontend Transport; Wed, 24 Aug
 2022 02:18:19 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <dsahern@kernel.org>, <sd@queasysnail.net>
CC:     <tariqt@nvidia.com>, <raeds@nvidia.com>, <netdev@vger.kernel.org>,
        "Emeel Hakim" <ehakim@nvidia.com>
Subject: [PATCH main v2 2/2] macsec: add user manual description for extended packet number feature
Date:   Wed, 24 Aug 2022 12:17:53 +0300
Message-ID: <20220824091752.25414-2-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20220824091752.25414-1-ehakim@nvidia.com>
References: <20220824091752.25414-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6727c41-7039-4d2b-257a-08da85b1978b
X-MS-TrafficTypeDiagnostic: MN0PR12MB6126:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /URXhaa4reCVUvO7evrAQUJs30RY60lceFc747m/UbtkQvD37dIjpo6WgyiF0xckYDdChW0yRtQEeqkAGUlbyaI68xJ7S3RzEtaaMGXpnNUjvzUzT1N3LSASZyViMse5Hn3EYS2fQ6zs/nRcff8L6b1/EzAGHXXZRHV8JOzMA9NfsLKNxC8EFFhYmEv2jmZmi6EXrnhL99yOjnAQoPkMpUOZdDZlUQDm2gFDC74ibuWniXY3wbybG8ZEndrhE2TN1qxMDgITYoJoMWiLiJ9Pa4u8WF4/QY4uiVEk7rDUD9k/ukX+cOymkqDrOMZcFXL4VaFhuwdW6xskR82iWIjjR7buigASGKwmntL1cRa8paiPuFxIuWq2egqVuMb96H79f/HL9obWX25hlfwFAQLLivPs7/iJ7Nunln4Bo/nXiGOlpJB5g3NKaPqgGQvergDMfWunTmqoQbjq25inyIc8TmT+9uuumgsjZ41Xq2+36Ot8ivBlVPftABMnFA5iQPekn/YNqrSq2Y1n6MmH7i1wHT7SKIlZosN3vN89Dk+5HBujJ/J48yIziAREXhmYBBJQzsBCNRDViCi3gto1gLqrmgbnaz2rOpWgYao8k8o4s1K5wTo+a0HdfupfWjzVOimmRUseC2WW/KrauDHiHYsTTo7JvEqY7Yfx5S5MEjnc/T8q7s4uMNPPUAGSKzohV6rsvTXdEpq4oZFO6U2qZOR57ylddKpjPUbcoGI3TuPZz4Da4fisQwwSnD+XnrCMY1RuxRNNeToCSAV8hEPVqYQzh6omfq61cSmuXU2EZzoK+ag=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(136003)(396003)(346002)(46966006)(36840700001)(40470700004)(36860700001)(316002)(5660300002)(356005)(26005)(81166007)(82310400005)(478600001)(82740400003)(4326008)(8676002)(186003)(336012)(8936002)(1076003)(70206006)(70586007)(83380400001)(40460700003)(107886003)(6666004)(47076005)(426003)(36756003)(7696005)(54906003)(86362001)(2616005)(110136005)(40480700001)(2906002)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 09:18:22.3437
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f6727c41-7039-4d2b-257a-08da85b1978b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6126
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

Update the user manual describing how to use extended packet number (XPN)
feature for macsec. As part of configuring XPN, providing ssci and salt is
required hence update user manual on  how to provide the above as part of
the ip macsec command.

Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
V1->V2: 
- Updated documentation.

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

