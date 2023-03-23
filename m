Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4231D6C6BC1
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 16:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbjCWPAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 11:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbjCWPA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 11:00:28 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2058.outbound.protection.outlook.com [40.107.104.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08D325B9D;
        Thu, 23 Mar 2023 08:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PTe6iNPMex4LrTQ+kOJF4gCGAWtWlgwZiGx+1KxmgtE=;
 b=Pl97knR0tRGBkf4BDKqvO48FKz0y/Dc6CCgZCNKhH0REyEKqU69R5ReTqzf+hEqbr+2UTygTGp0RoPIRy6otfnyTXl0JBvDx8vFQ61BSjcisiQ3NpkDwwyKenCHmvYuFmVOtobPhBZrXis43J5vF3C+sYZixGUcY4r2ApgBrHvHCA9cZ48doL4F+cDjTDijdQAq5sDAow7RAeFmhxz/faTLwmqClOIOTJeDsPui+s5DlbiyJ+juVHgPevVdz1rvsHgCkF5Qe4rmXFinJlklUnIgUD1TWsH5qDWYy5kVUrGOEdC8QMF3ZIUVATRZCTO6EDiVuKW1Vpau1ikH09/tatA==
Received: from DB6PR07CA0081.eurprd07.prod.outlook.com (2603:10a6:6:2b::19) by
 AS8PR03MB6871.eurprd03.prod.outlook.com (2603:10a6:20b:29e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 15:00:20 +0000
Received: from DB8EUR05FT055.eop-eur05.prod.protection.outlook.com
 (2603:10a6:6:2b:cafe::bd) by DB6PR07CA0081.outlook.office365.com
 (2603:10a6:6:2b::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.16 via Frontend
 Transport; Thu, 23 Mar 2023 15:00:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.160.56.80)
 smtp.mailfrom=seco.com; dkim=pass (signature was verified)
 header.d=seco.com;dmarc=pass action=none header.from=seco.com;
Received-SPF: Pass (protection.outlook.com: domain of seco.com designates
 20.160.56.80 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.160.56.80; helo=inpost-eu.tmcas.trendmicro.com; pr=C
Received: from inpost-eu.tmcas.trendmicro.com (20.160.56.80) by
 DB8EUR05FT055.mail.protection.outlook.com (10.233.239.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.21 via Frontend Transport; Thu, 23 Mar 2023 15:00:19 +0000
Received: from outmta (unknown [192.168.82.135])
        by inpost-eu.tmcas.trendmicro.com (Trend Micro CAS) with ESMTP id A1D852008088E;
        Thu, 23 Mar 2023 15:00:19 +0000 (UTC)
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (unknown [104.47.14.52])
        by repre.tmcas.trendmicro.com (Trend Micro CAS) with ESMTPS id 4476D2008006F;
        Thu, 23 Mar 2023 14:58:22 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O5Ja4NNh4/zyR0+XdjC+nsTPqs00LablKxGz0M1FBDkY79ywTeeWf5Aaw8fJshp5q4igZUPC7AQL5PY2P3fSxRtELG/C28YRatJmfQs+L2Ur3tXJBgbqU0MD+Vr/GwXubjVKhqtQRzmSjmkymbY0hMMFbe4nsSZm7I4+Ph++Wyj1vjpWVY4OBG1x6UM19e7Glmoeu5WB5mV+UWMMjzM2CbuEeOuaLNCLffT8pPp26uvOzrKBYmaROyQrB00HiHsrQdtdryK4MEKJNBq+esOFreF0dMb8FKUKENcmseTG+zbWu9qWCXgzx1GV/0lP6JQng8NRuFkrDI62emNgehzDfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PTe6iNPMex4LrTQ+kOJF4gCGAWtWlgwZiGx+1KxmgtE=;
 b=LExzLBB9lAaM2sagF14N5s9vj+Edy6tmYBpYt5R9Pk6N7CxkY1AlHYTVUCj8yNNOK/FvflfCQu7d3w2KXU25zbb1/naT+QPonW3UJFP8Hj0+THlTwic4TlPUBKeT1x8yEtY+9Ou2WTuOweUxu9WgTb9iJ0l9gP2CN0gsC4EB9TIxCXVtf+VOvGiDC59t/92GWJclaf3i7gVRKRl7pA+/a62fLhvf1NzGksXMFPvm/r+Trwk6066JUbgGklHbbGH9Bc0sv9c4GuqkSHxhbGizXfJsNzwP/jpWUIzPn4Ao9y2zfIATIz+WalQ+zkNFdRvzh2y66U3rkDpUT9l3PZXlug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PTe6iNPMex4LrTQ+kOJF4gCGAWtWlgwZiGx+1KxmgtE=;
 b=Pl97knR0tRGBkf4BDKqvO48FKz0y/Dc6CCgZCNKhH0REyEKqU69R5ReTqzf+hEqbr+2UTygTGp0RoPIRy6otfnyTXl0JBvDx8vFQ61BSjcisiQ3NpkDwwyKenCHmvYuFmVOtobPhBZrXis43J5vF3C+sYZixGUcY4r2ApgBrHvHCA9cZ48doL4F+cDjTDijdQAq5sDAow7RAeFmhxz/faTLwmqClOIOTJeDsPui+s5DlbiyJ+juVHgPevVdz1rvsHgCkF5Qe4rmXFinJlklUnIgUD1TWsH5qDWYy5kVUrGOEdC8QMF3ZIUVATRZCTO6EDiVuKW1Vpau1ikH09/tatA==
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by DB9PR03MB8374.eurprd03.prod.outlook.com (2603:10a6:10:395::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 15:00:12 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::dbcf:1089:3242:614e]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::dbcf:1089:3242:614e%6]) with mapi id 15.20.6178.037; Thu, 23 Mar 2023
 15:00:12 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH] net: fman: Add myself as a reviewer
Date:   Thu, 23 Mar 2023 10:59:57 -0400
Message-Id: <20230323145957.2999211-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR19CA0042.namprd19.prod.outlook.com
 (2603:10b6:208:19b::19) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|DB9PR03MB8374:EE_|DB8EUR05FT055:EE_|AS8PR03MB6871:EE_
X-MS-Office365-Filtering-Correlation-Id: 60176034-80ea-4868-a37c-08db2baf5221
X-TrendMicro-CAS-OUT-LOOP-IDENTIFIER: 656f966764b7fb185830381c646b41a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: wKwFlOd4carv6KhzL7UEZUgbNWemOROMRJPY2yVpKYw5s2zc3PwpZbxsDjRck4MlMjqoD9x60sbp5cI7WeIl7OtE3pwIEKs/zCtOVQsP35hD75+S0NDn/DSwk9u+wdMXHuHMbc6YJDAoIB9yF9kFfBPvzr0YqamQbIcMzzYpmpTpsjZPHoSTJfvC9kIFIix4YFVPAb06KTMb5rvPzQqNqe8S0w8jtHoarV9guK2XcHfKVkJyhl1TIwm+e8inFkCyCdnXVeI8nadR25Eq3EEGLKfmg/FbQqBxERGkIG9iATbaZQogVzVsnGuOdycUjZxjQIQDkIzkavWTiKamZfWevZAdickX+1hO76915qYKut+89F9tBhwGQ88swfJs5ERR+vxGxrZnnjn7HwapYHPXm/zTOxwdtpHLVKMKrZ8NvRTkTGc5Sqx4GmLstxNdwGdKPNj7Y6KarGb7+ETcxRApzS4I//G8J36vDyVb5uwDDlL+FBYrd8ixComDXGyRNZ7r2seKOM501I0SfAo9zRs7vXURwd8K1P6HwU6iyz+m2Y0d9esgYUQAxmB2qB6foRjAPXK1nKo750cXZ5DNEziwUzvBtnhuf9sPXufno0UQmddmSub9FrFksjguMSD62AstzlUOmCmFz5pJXecmFcCxIUuY/kUP3E7bOIN8rbIBkxwHvXZXCVqkoWn+j8cFCKI47dzEsux729QgJnaTgom9jg==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(396003)(136003)(366004)(39850400004)(451199018)(36756003)(26005)(1076003)(6666004)(6512007)(6506007)(44832011)(6486002)(4744005)(107886003)(2906002)(86362001)(41300700001)(66946007)(66556008)(316002)(4326008)(66476007)(110136005)(54906003)(8676002)(2616005)(186003)(38350700002)(38100700002)(478600001)(52116002)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB8374
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB8EUR05FT055.eop-eur05.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 70c60dc7-4565-4baa-5d71-08db2baf4da8
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kCKOZxRL1Vwf/J4JJpZtEEZX0kdbe8zcDHBUBWJ5UTNPxV29nAZIm5h7aMOsZwlZtEMHeUN4Dt7AQvsbMQ1J7AJnkA0DOZMAKvVqZb7CrcAif8qI+YEKskjqox/mBfTh8wPIQUsebNQO5/2WATF7IQQDKMjOsk9aM1T9tcR0fzELXSFOuOVcY190NBAxObwiC51TZYCzSYUOkHhOv8vXYjwMcZWYNKHmVQDvQQlBBquhNa24h4F+7iRdqIZsdGq7xawzMUKgoV3+5eT+ExdIW/o2Nvk960Hiuj6q/6DP7IiktAnFFgULQMlHYMyWTSbV8P6aK/vbRQhp94tuZIGcMxGbmGV7V+gcK7NSx312PWtyOr+tBpSrzmgUUAgTVAj3FckjhTGZWIKNdqIOx1Hj5kYtuA2PqtCTCTwidfSzn/WP5PGMeKewsFYTtLoWgmpNl2V/iQ+evrc0tyuuNzECNEhYuOqtTbdJLcSomSr4pvHUKiT9pF5TniOktSqD+XBe2x+iCnGFnldb19Sz6N0hJw+1nLb81lEJUy+1NYIKWkyFpMGPNUWUhsbGd/5UW5dgktkJR0/UwMVNQqh3Djrv7NEV04ujuH7J7By5d3i3IZ0emOpHvT6885eSFwwY7Rp/+/HCL9UIhm8sV5nrT2NuZ218vvyY+3NHTfA0hcXXuPj2oLV7u3pg4nMs8ib4Hquz+vE5ghsFF0PGu5idBtLXBgEAHAkDmLoCuqoRgxBZiXs=
X-Forefront-Antispam-Report: CIP:20.160.56.80;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:inpost-eu.tmcas.trendmicro.com;PTR:inpost-eu.tmcas.trendmicro.com;CAT:NONE;SFS:(13230025)(39850400004)(376002)(346002)(136003)(396003)(451199018)(36840700001)(46966006)(40470700004)(356005)(40480700001)(2906002)(40460700003)(478600001)(6486002)(2616005)(336012)(186003)(86362001)(82310400005)(36756003)(316002)(110136005)(34020700004)(54906003)(4744005)(8676002)(36860700001)(4326008)(70586007)(70206006)(26005)(47076005)(107886003)(6666004)(8936002)(6512007)(6506007)(1076003)(7596003)(82740400003)(7636003)(5660300002)(44832011)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 15:00:19.9014
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60176034-80ea-4868-a37c-08db2baf5221
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bebe97c3-6438-442e-ade3-ff17aa50e733;Ip=[20.160.56.80];Helo=[inpost-eu.tmcas.trendmicro.com]
X-MS-Exchange-CrossTenant-AuthSource: DB8EUR05FT055.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB6871
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've read through or reworked a good portion of this driver. Add myself
as a reviewer.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9faef5784c03..c304714aff32 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8216,6 +8216,7 @@ F:	drivers/net/ethernet/freescale/dpaa
 
 FREESCALE QORIQ DPAA FMAN DRIVER
 M:	Madalin Bucur <madalin.bucur@nxp.com>
+R:	Sean Anderson <sean.anderson@seco.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/fsl-fman.txt
-- 
2.35.1.1320.gc452695387.dirty

