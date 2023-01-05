Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09DC065E64D
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 08:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbjAEH5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 02:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjAEH5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 02:57:51 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2088.outbound.protection.outlook.com [40.107.244.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF2752776
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 23:57:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BpXLN7NYtVEq9cbnSSwohup9B9t6FTgi0v8hzkCkg2khA5PghGS0LYPN4f9zDM5tHIl59ykAnw2Slv+JdH59x1+dQAvAkN0t/8nlcumL6hD+s9n67wElf0izHpre4rmf3NbxXGHV8ft6jsY8VsC3OC4+FXdK510ovDDnen/ogAixRWj0Lqazskl9ilFyVEpkNtsfm5YV42N7Q641iurCF1lidWHrbN6PcBK4SPdHKRoGfVxlRCQ59eSCrQ2ua7K+IXbPCIsoPDeIXNlQttxtu2uUyVtpBPh1dbAfTrh8NVcPUTLRi1lSGDyygZlULPux8JZb2COtNbW/hoKakM1f8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=68t5NsV4p6KwyYpZdzovIb9BYzqQtqSd8KhSr1wLA8I=;
 b=dAnEQo5jiVDw0vqqAZJeOmsKTiN015pJCuXzX5jGUinHElC68yIgD3Gy99TbAQXRcDeWQgh1cZhf0KKYh9SCOGmA7tr7wpK5h0addJPV6FKXKjpSoMcsGolKlBDiug0u5XoAshnDf84kAu8Uf0C9DlKdSXVbaK/nqjT2e/yyUc4NZp4pbBJjQj8MbboIKUVC0NrpM2Id21OQndjktJ1zNCovYukdYBrYcVRaWY+EBn8K4qde++OGPJ1tzQgm5b65mTAzIJpS7a/9r66GtQUEcT10Wec16dhnF0HO9N7NVQZTxqLmElE+lTY96K0Zl7xwd1ZYebkEdHUvw+gmUM77qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=68t5NsV4p6KwyYpZdzovIb9BYzqQtqSd8KhSr1wLA8I=;
 b=iFM4sbexOyjxyLVOIAvTAhZYYrLGj6BPgmZ7vM4wX/EB+U6XJXJSKnr4cKRqNvle+O0+nVvdmw4TkqyF/s2RDaAM/1+UCW8q6G2kbdcizB4dSMBl4TV62t2Y01ChuTCpMRvIDaGlhuoyw+wDrZIFXVZaDbot53+q3hS8x62v+EtpOV40iLhYx+C+w6+5pfQJtrLQE+MVpKczvb+bT4exyUA6OsMN6Dvpl1p77xfoXZSEXm703tShwj5QM8LnT83gPHULIIuO7sk5WB2DWy+GkgJwXg6/9XAeJhdXp6GPJdBqH80POw4+MAIGm7UN/gy1WGz2TETHde09A8DNbTd0Sg==
Received: from BN9PR03CA0235.namprd03.prod.outlook.com (2603:10b6:408:f8::30)
 by SJ0PR12MB6943.namprd12.prod.outlook.com (2603:10b6:a03:44b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 07:57:48 +0000
Received: from BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f8:cafe::44) by BN9PR03CA0235.outlook.office365.com
 (2603:10b6:408:f8::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.14 via Frontend
 Transport; Thu, 5 Jan 2023 07:57:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT034.mail.protection.outlook.com (10.13.176.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.14 via Frontend Transport; Thu, 5 Jan 2023 07:57:47 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 4 Jan 2023
 23:57:39 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 4 Jan 2023 23:57:39 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.182)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Wed, 4 Jan
 2023 23:57:37 -0800
From:   <ehakim@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <raeds@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <sd@queasysnail.net>,
        <atenart@kernel.org>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v6 0/2] Add support to offload macsec using netlink update
Date:   Thu, 5 Jan 2023 09:57:19 +0200
Message-ID: <20230105075721.17603-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT034:EE_|SJ0PR12MB6943:EE_
X-MS-Office365-Filtering-Correlation-Id: d1d53f5c-be65-4b58-ec45-08daeef28969
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5m26Cekkz9GHP5W09OQv8w4C5TnDzTKjArWqoVoTw0syNj6WDTwiDSJKDuonzIQv0uUQ0Pipv5+L7CVYv7h7F0mklgJguWMVoVX7zWAzZWC58aNSbycRMT9vQEshIMjWDOeIbTXBmElAyNwqjcVFyx29sL2C9YSmtZ7GM628dpb3FMrT7IuHJvnH1Dt0d/ys5t5Sfm1UBZwKEs4vsTU3fTbMF/u07kgxShnrI/sfhDrhXX26dPrkKsrNIw1/k5DInU7IbYf76YSUHu6NZ0Z+V7OId8AqH5fTm+Ca9S8QXwWbZfYbrG+C/1mBMZATjsXe3tqsRxvDn61bfzKn0CaTl5vWJMoajsgsFyfjRsOCNxiMkjicCVcgWjvhyxOyC5Q8AwSzD7VBBDq5hJJch0yytXZyx3akqRPRzSbPHVyA6VQAwg9T++JBgPGlzVlibm+vCufH5bynv9BNNE3s/c+gw4YYqm26vOvEFauLNXfhAInXZF6Y2VGVCWHW0Kd7mZeRbuzXquZhlLGxy5O5tBNFR4XAx0dc7yuyx6xVIP280LSOaaA8heRAMVgcJj5U/wUE5cdO+shwPtP1QSizReZ6eAa1yJ3UsgM6kXYQlEcwQDaS2jDYTeply8X1u206OS5kHQf8p9jr/hYBMhuTVUSv7IOrod2UeKjDnUqUjp/PoX7J9dX6ZYfRuZG7XAOMU88tnGuCT0iONeOoZddLZJgxGg==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(39860400002)(136003)(396003)(451199015)(46966006)(36840700001)(40470700004)(186003)(26005)(2616005)(83380400001)(336012)(47076005)(86362001)(426003)(40460700003)(82310400005)(36756003)(36860700001)(356005)(7636003)(40480700001)(1076003)(82740400003)(316002)(54906003)(2906002)(6916009)(15650500001)(4326008)(4744005)(8936002)(41300700001)(8676002)(70586007)(5660300002)(107886003)(70206006)(6666004)(478600001)(2876002)(7696005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 07:57:47.9232
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d1d53f5c-be65-4b58-ec45-08daeef28969
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6943
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emeel Hakim <ehakim@nvidia.com>

This series adds support for offloading macsec as part of the netlink
update routine , command example:
ip link set link eth2 macsec0 type macsec offload mac

The above is done using the IFLA_MACSEC_OFFLOAD attribute hence
the second patch of dumping this attribute as part of the macsec
dump.

Emeel Hakim (2):
  macsec: add support for IFLA_MACSEC_OFFLOAD in macsec_changelink
  macsec: dump IFLA_MACSEC_OFFLOAD attribute as part of macsec dump

 drivers/net/macsec.c | 127 ++++++++++++++++++++++---------------------
 1 file changed, 66 insertions(+), 61 deletions(-)

-- 
2.21.3

