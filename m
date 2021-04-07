Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD67A3570BE
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 17:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353742AbhDGPrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 11:47:06 -0400
Received: from mail-dm6nam12on2048.outbound.protection.outlook.com ([40.107.243.48]:4448
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344222AbhDGPrF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 11:47:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GjvR2OuDTroCt1LVA916xnMS+R64xHVPnLJzDrXHAIsCVDdfA9AVC447gidoZOybNK2WNg4WWwNk3zvBceBVjbp2vLNq0HtCZdVaSnnoeGZH8YimdEt/E3M77B1/gvThiA6wUZ0Ysm9d7t6qVcD/nb4dTzwioDDmjzVMLnEx5zs9aRCp0i7dU06CZkDsTjhVsGcABuTvt5Sn6mD8fzh03jsaortECb7fsb2E9EnqvHwlc9uJ1BQtMh0LwIx2l7Acz4ncZbTvVgOsWPDlYfzUjepkSUIabfx+nRifjUVgnUS+haJUsYrFRSp9flSp0hi4F/SvXjXfZAgLMt7hCSnohQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ACRQK2gYxHLbjmIYExUIx4XlrLc4cQDRAbDe9Eh8EQ=;
 b=bLcfZp9Uno/614AkIsBuwFZT25E1WFOVv/eWTiJEVA7APj/kl8jTFVHI5WmWXeFv1ZGxFT+OAbPF5FyY/e3vD3Kex2QFzHrH7naN9BRDLdJCHKnHdTBVZNiIrJoEeExb84IUIh3xV9kMeb2L8cMv/MZatDJksvQK+UyDnzl1uF9V+VXWw48jPRW4HKrOCh8UZ2Bxq8/p+hDcr3uUKd5WMGigRTQouAd2PiRYSfRjhurjeXOi6/tD2BHNyRVl98S2dW5Lua6T7QaA2yPp3wFgRTsFe42xRDMBIdw94pfTSAMtY5qudvHOnNHmuY5zJsc4jGj40FcGNzER5feGGeEnsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ACRQK2gYxHLbjmIYExUIx4XlrLc4cQDRAbDe9Eh8EQ=;
 b=bgFf1LSdWTzZpWZuNGlDSsKpRdC7FoejRw2luY14jILbmNI5pySt6LNfnJ/tsmiz23TUBBPCZjtVGrJQMELMQ1Jf3m2WddZzGcG0PZN1AzGmnol2YUJi9B1EGZ3+ykqF3oBkneaRNdS8BxsbRl3lWIAB7NnNRRfTSE/2eWvGi8o+6+cUvE++WvwNgMQ8Nf+NzBipiuJZxSFYjNTuSaQzA6xLB3hGvvU76w0xXtK7fdnrUL8iPZmcY6ibUto9pAvy0uM8UIAD8wL0+KasjAKv1hDgMh0dzdp+zNNyTZ/IspY5S2z11JF8LPmkXfOugzrQRLhPNLVbqwhTgBgwWkLOCg==
Received: from DM3PR03CA0016.namprd03.prod.outlook.com (2603:10b6:0:50::26) by
 BY5PR12MB4052.namprd12.prod.outlook.com (2603:10b6:a03:209::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.27; Wed, 7 Apr 2021 15:46:54 +0000
Received: from DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:50:cafe::1b) by DM3PR03CA0016.outlook.office365.com
 (2603:10b6:0:50::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend
 Transport; Wed, 7 Apr 2021 15:46:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT042.mail.protection.outlook.com (10.13.173.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Wed, 7 Apr 2021 15:46:53 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 7 Apr
 2021 15:46:53 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 7 Apr
 2021 15:46:53 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 7 Apr 2021 15:46:50 +0000
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <memxor@gmail.com>, <xiyou.wangcong@gmail.com>,
        <davem@davemloft.net>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
        <kuba@kernel.org>, <toke@redhat.com>, <marcelo.leitner@gmail.com>,
        <dcaratti@redhat.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next 0/2] Additional tests for action API
Date:   Wed, 7 Apr 2021 18:46:41 +0300
Message-ID: <20210407154643.1690050-1-vladbu@nvidia.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02292ae0-a3b8-4f3f-c5a4-08d8f9dc5e25
X-MS-TrafficTypeDiagnostic: BY5PR12MB4052:
X-Microsoft-Antispam-PRVS: <BY5PR12MB4052DF084E5E0B74ADCCEF7CA0759@BY5PR12MB4052.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hPSAxcCDW21f1NYR4jTALCw3gmQ9GkPKoJupqpduoMMhvesE1h8BSB4206h87aaaVinMh6BTc0w2ko8kCpbJp+kY3fqwsFGbHFw27h0sKdxR4CPZAKBEQds06AkjtEPr4ux/sreW11d5feeVH9XfwU1uSxvJAxlIZnG7gPss5ybRSiC53t5TeryVhQ1FM0VVh1biZ9o2SqD5S9uGgXy0elXgQ/mVBhVDoPH9p50Xu0YQ/N4zEbR3Z9pKUmHvBULInueXieE0GTG5MGlBBERLHZwsWwTBeQJzSJP55nYuHrghVvRZBPJU1qGFZTpq8svoOpAffwD5ws4M477pQ6h8KzlwVokH1CVTwzbEBMghivJ9P/8CbwlMSCfPe9AScV64UP4kKs4OMoG2ew7Hfrq2wwlhDDFLZO1SDtkY2wTzsejqIKrypUht3RXk/iguGocf2/5HYZxWif/Z3tBp8qT+swP6bsJJCbWgmJxtPB/ezUK/qI7eTFXLIw5F1bqmIB77bgqpNCqQ/GtOMszenf+AS1daWN2Nh/BgZGVH2vO9aOfMgL5LJoFIw1lL9pNE6Y+tDbZfuhIoNdPwY4PKtEWZ7Rrfog3dp577y4iK+bTlcpCjI8qkJblkUzJBW7O/FFbxtUViVjhvNyCtZflV2IHnLNqMHomN2p6Q9EkI5gROXu0=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(136003)(396003)(46966006)(36840700001)(7416002)(47076005)(36906005)(2616005)(6916009)(4744005)(70586007)(186003)(316002)(82310400003)(107886003)(8676002)(2906002)(356005)(36756003)(83380400001)(54906003)(36860700001)(1076003)(4326008)(7696005)(7636003)(478600001)(86362001)(82740400003)(426003)(6666004)(5660300002)(70206006)(336012)(26005)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 15:46:53.9550
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02292ae0-a3b8-4f3f-c5a4-08d8f9dc5e25
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4052
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add two new tests for action create/change code.

Vlad Buslov (2):
  tc-testing: add simple action test to verify batch add cleanup
  tc-testing: add simple action test to verify batch change cleanup

 .../tc-testing/tc-tests/actions/simple.json   | 59 +++++++++++++++++++
 1 file changed, 59 insertions(+)

-- 
2.29.2

