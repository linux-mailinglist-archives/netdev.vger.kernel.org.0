Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9686D6655BF
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 09:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbjAKILj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 03:11:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbjAKILh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 03:11:37 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3334E10CD
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 00:11:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XuqIA/1C/Pewj3rVA4Uk16L6FOcwSo/34/51V0ayVyW94K7nz+/LuRXagqvtHBaAT+k+wh/hDakqJUtvecdemvGqbTcLOjyVzntTaS/MT4PLsB3u++DrAofSZwIaIc0hFLBTIYSqwpU3Yzi9HKtcfTKm0qOt3GchVg2tw+bPrAxP58NsSMaig3X60847qFPK6RjzJ/UXWWms2jfPsuVHiQQpyZdz9HzkG45Ig2zh5FOweNV473J0UgjNNHcsq3UIGp0RdICOijlPfCFgB1VSC1orYYFzoDImcAim3Pf1c6T7oYV7EiVrUN3BxkJ4fz/Va851dBpYe9xrCov4qho0pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZtX415FX8zuUQF7GSuSDYUlXkT9UJEn4mg/ufByPJWU=;
 b=kgveLZ7Xq6D7mN5Ylu+O0iWTinHE2Us/gz/XHhcYu2wUn2PSLEQ7uPSRhcPXlhfBeZEsTFJfEGThllfWBHSAp8svAqNOe4mpi0YbwpSSklsdiRoE8TwEZd2iCgb0ZW3d9WU86IVmZVRB/r7AJDuIzNYE7kTatJe0mDsoz71n9H5tydq70oELstVwjLWodlhDLIptk/m0oZDtoTd1kVFc9qGAcHJGTxpHph1AOP+TCNhjOYqPUbXL8PgC+KKRRDYknM0yTTvzUpah1jdGMNgayOw45vubSKkKKFqu5kABqqCbkEbNuGDiOhe+VJ1qtX2jseUpEhbaOAgYYyIEj3LoZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZtX415FX8zuUQF7GSuSDYUlXkT9UJEn4mg/ufByPJWU=;
 b=UBqtaPep04a06yMxqMNQLvRYHbDgV2exNs2f/x+A4LfwDoj6Z9CIedmvNYMSzOy6y20qgtbCWVqBs8d9fdZX3L4/HO0Xn07FW1a2DFQPThiBruuuid9pEz7B+MIrGJcdTr8VFuw9D/wmSyfR+yqZ8k3rEYnISV6pLIcX7nxrzdyC+iyc3oT34Jec3zww+EKkKy4lVl4N10NMn5iKVXn7D5aPf7CZIVbRpoaty5ongHnVYtNKskphoQ+S/P7tPAndD8VvPuAY2douJu42V69b0oMndwLCnVB9ZNsXat06VTDgq+7dM5wDEiT7G1/E0Wm+sUXbnc0SqhWKQCFWLkl7Zg==
Received: from MW4PR04CA0377.namprd04.prod.outlook.com (2603:10b6:303:81::22)
 by BL1PR12MB5349.namprd12.prod.outlook.com (2603:10b6:208:31f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 11 Jan
 2023 08:11:34 +0000
Received: from CO1NAM11FT082.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:81:cafe::14) by MW4PR04CA0377.outlook.office365.com
 (2603:10b6:303:81::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18 via Frontend
 Transport; Wed, 11 Jan 2023 08:11:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT082.mail.protection.outlook.com (10.13.175.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18 via Frontend Transport; Wed, 11 Jan 2023 08:11:34 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 11 Jan
 2023 00:11:26 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 11 Jan
 2023 00:11:26 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Wed, 11 Jan
 2023 00:11:23 -0800
From:   <ehakim@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <raeds@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <sd@queasysnail.net>,
        <atenart@kernel.org>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v8 0/2] Add support to offload macsec using netlink update
Date:   Wed, 11 Jan 2023 10:11:10 +0200
Message-ID: <20230111081112.21067-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT082:EE_|BL1PR12MB5349:EE_
X-MS-Office365-Filtering-Correlation-Id: 17a76723-c0f7-4223-20d5-08daf3ab74a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XE44IV1+5+rD+PskOnHfWbl9VvX6ljGW4KhM110Hgjo9zJxRAdy0qtbDyj6FdMQB7i1EDh+tUwOyZ++h3sosoGJUcegI0WZTxFdoXw/5x+d1x6Tcv6YdnFy+OlH5v0FNFKf9PScK/vz2ekJrBRxYnx9p1RT7m3Qt6tfAQk+cM+bpLkW336HxxlCvkZ+roNxKvpl5y3MKhiH2HKjEETK3Ah/j7H6vzrdPA4SZAVfk1lT6T8bxH7dpK6uzDF5NJ1uepC5mfwTax3CoDtKBUXNbxOT5MYtqAy3WwKiPGkIHTo0Y+aJOxh1Uiy0jjiklSzw2BspFo6gk6Fmc1zv/7ycTKNw7go80kEGfPEhT0ydHTqeABOefHctQPIt//rZXTmMhVi/xh++FaT8+ubaDj6xAO2ZNgb4Of6kmKBpMUqEQ+PvzYucEYidFVkdHdGlPvXBhl/CBGp/3G6bSz9FFs5izMY9ZkiirMFldnNBSpfGom8jdOSPX7rwi6G7PKc1+EXukWagvvdXAmapzYWdxcaSOunDIlp1bFjBMCrVnws212Z5NJshdIEYvgU8AnslIMUl2V/YUWrI8wW4nbtB/eh4RRL14WH2ki6JOZYDbqKW3ZbeI6dKbdyAjppTznFoGYA1JTA3Pmc7fqeemFAQMv9jp8U2Ztfqcb2KiooI1HE4ytUsMDTaH7RalGlR9h2y0j+BJk7rLJc7errou/hGD7XluIg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(396003)(376002)(451199015)(46966006)(40470700004)(36840700001)(107886003)(6666004)(8936002)(70206006)(41300700001)(4326008)(6916009)(8676002)(70586007)(316002)(15650500001)(54906003)(2616005)(82310400005)(1076003)(36756003)(2876002)(40460700003)(2906002)(5660300002)(4744005)(40480700001)(7696005)(86362001)(478600001)(26005)(186003)(7636003)(82740400003)(356005)(83380400001)(36860700001)(336012)(426003)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 08:11:34.7082
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 17a76723-c0f7-4223-20d5-08daf3ab74a1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT082.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5349
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
update routine, command example:
ip link set link eth2 macsec0 type macsec offload mac

The above is done using the IFLA_MACSEC_OFFLOAD attribute hence
the second patch of dumping this attribute as part of the macsec
dump.

Emeel Hakim (2):
  macsec: add support for IFLA_MACSEC_OFFLOAD in macsec_changelink
  macsec: dump IFLA_MACSEC_OFFLOAD attribute as part of macsec dump

 drivers/net/macsec.c | 127 ++++++++++++++++++++++++-------------------
 1 file changed, 70 insertions(+), 57 deletions(-)

-- 
2.21.3

