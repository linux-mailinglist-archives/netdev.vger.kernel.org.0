Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9F706620E4
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 10:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236711AbjAIJD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 04:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237031AbjAIJDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 04:03:24 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2082.outbound.protection.outlook.com [40.107.237.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A9015805
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 00:56:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=flU4J794LpLnZ7uvFBvPEszTa1uKKiqxEiWqrq9RHt40R5ZBcRUxkwUlJ8NSrqZ2zMscUEla8XWOP0TgP2y3k7scKhm9WJ/cPzYef41kWRxWyxQmyNizDC8JSulAunt6AkEKgX3OGCbzazkMhvmdA4UoKC7cO5dFU1yKr885K2k7irO0DmHT6y+Yf4fekoQ2NGPNGSZze/zPoU51FtpxkOaY5qwOOO3p8/5P7YVW2Gcz19/FOvaPRFdRw1Cu7+O2JOMlTFGp5DScUW5wQLvYXD1HNwTi1++IGFYOzoHlgie1aekjlQlgrD+gciUwuHntle15qrMek9CjM+ask3A9XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zUElR+6DnuiBq9JuVQFi+ckjbDkxreN57LQYW/j8oUI=;
 b=aCP7o1J+63+jHJ44cNgHqjWUHZgXAjiB6qgkMaA89lWpoA4hoKk2SOyCtqetzz8zicUDaazgmAUqw21uW5oNHto47P5KEBzXxdNQo+v2a9n6FdtKpxZB6tfhy6ozgresQUQ6JSACKx7/EMI775dtko9vXzqF0ybw+OfNx38Bxo3GgB3m5waPQn15eIYz6+cjLbUHFbJcfB41tkI4PtvHKoXTiafjSUxLCC5pt9PUata0BYuOxnQ0wiT+G1ZuarlF36mWeDUOZTdlVg8NzgZMZSJf07hkKNqWS9ZAifZ+pGdksR6npmjr9yAuDqvjVeEj3c/Tdkx22lRG7aPBjr2BHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zUElR+6DnuiBq9JuVQFi+ckjbDkxreN57LQYW/j8oUI=;
 b=bphbVIF50fU1pQbUe6L0z3dEWgao6tjWWG4uo0OUYNvpU3eEYlAd5q+k7LLTTdLI1pKMdI/C0J7LZa/9c/ocXUeeNTSVM0R2hi4ZG+9tI/A/mIIaF44aIEC0FrYElfPkaOPiq3T9iRdR97Qq6RfQ6e4fjJkRMEJ291HDPthDez3IusBbJkCaeJts3TXp+Y+7PGHxIAnt0eXcNYpY0TyCrXBiN0T+j3Ed58SXWBTisITkJsefI6vZQLwyaWeQRZ8+fqkKQFVvK6RGcHCEFiH47UzrgKJfK/Mlja6kpkrxMg04ak3YxaMOPSVa5a54T64jqHzrEb1d36tJzGJ2zW9H3A==
Received: from BL0PR01CA0030.prod.exchangelabs.com (2603:10b6:208:71::43) by
 DM6PR12MB4172.namprd12.prod.outlook.com (2603:10b6:5:212::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Mon, 9 Jan 2023 08:56:32 +0000
Received: from BL02EPF00010208.namprd05.prod.outlook.com
 (2603:10b6:208:71:cafe::4e) by BL0PR01CA0030.outlook.office365.com
 (2603:10b6:208:71::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18 via Frontend
 Transport; Mon, 9 Jan 2023 08:56:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF00010208.mail.protection.outlook.com (10.167.241.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.15 via Frontend Transport; Mon, 9 Jan 2023 08:56:32 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 9 Jan 2023
 00:56:21 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 9 Jan 2023
 00:56:21 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Mon, 9 Jan
 2023 00:56:18 -0800
From:   <ehakim@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <raeds@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <sd@queasysnail.net>,
        <atenart@kernel.org>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v7 0/2] Add support to offload macsec using netlink update
Date:   Mon, 9 Jan 2023 10:55:55 +0200
Message-ID: <20230109085557.10633-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00010208:EE_|DM6PR12MB4172:EE_
X-MS-Office365-Filtering-Correlation-Id: 02d49f6f-1495-4fd4-ec29-08daf21f67c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O4HizcTK2NTzfFiClC/Oa989OfuZ9uwQCggre9Y+bAmMCn/aOXhyBAyCxJyCwcZdz5SejMipmOLnRY45HoNJX3tpN33zeBd+eHIORl9SfKQkL/v/8IUb36FwDNnNwNcC2//5gVW4EUT+Bz2bV9EsXGc0tHcvoBZlrYuxX1sY6Eg94KyLwSmJ43I13XFB7+zEQF5gAl4hWQCJbvtNr6TuwNgq8bhQ0/EhGALRepxCiCLvsPsj8TwRKTkE6QpgjJJeXakbjBv07LERYPyvHfq06rbc4qS4hH3WVHLjyVqNxBtsRReti7nJvJZ6XZLszNExJrjG4GYJhiifQxT+RcNAVHUeBb9eOTizjl+hVt2v5tKox8wpx6mpc2aNR6pOtzC9WKgitE8H3ZTZrfxf50Hs6T7ubWASLk3VXe/tCyh4ICZC/vcwo+cI3sGT57VL4a2AKjFXjCtsV1eryTwA1oHIzcrrgbVsZAQeVv43TmaRn6WFk3FOnJ1kN6J/noNr3d1X23FDGvvRwfShLQTex4zqvlRnU0FmtyT8GLC0g4eDnec/aa2rUbIV67HUttP3FeukPjJpMArkC/9bEzCPKiwalJBBzqXzEhUur7os7Wt98BTx0DSfjXE5/mc21WZQX7PdF1PCO/znG2CiY2nI022HvdQgENVPZvSHzdRYAtadK4Igx9lV4l9qcS+KoAC7Og0YDd7PcnXH58NNiogkA82efw==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(396003)(376002)(39860400002)(451199015)(40470700004)(46966006)(36840700001)(40480700001)(36756003)(86362001)(40460700003)(7696005)(316002)(6916009)(54906003)(5660300002)(478600001)(4744005)(2876002)(6666004)(2906002)(4326008)(8676002)(70586007)(70206006)(41300700001)(15650500001)(8936002)(36860700001)(107886003)(82740400003)(7636003)(356005)(1076003)(2616005)(336012)(26005)(186003)(83380400001)(82310400005)(426003)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 08:56:32.3197
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02d49f6f-1495-4fd4-ec29-08daf21f67c9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF00010208.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4172
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
update routine, command example:
ip link set link eth2 macsec0 type macsec offload mac

The above is done using the IFLA_MACSEC_OFFLOAD attribute hence
the second patch of dumping this attribute as part of the macsec
dump.

Emeel Hakim (2):
  macsec: add support for IFLA_MACSEC_OFFLOAD in macsec_changelink
  macsec: dump IFLA_MACSEC_OFFLOAD attribute as part of macsec dump

 drivers/net/macsec.c | 122 +++++++++++++++++++++++--------------------
 1 file changed, 65 insertions(+), 57 deletions(-)

-- 
2.21.3

