Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A233F4D35DA
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236244AbiCIRBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 12:01:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbiCIRAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 12:00:53 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2046.outbound.protection.outlook.com [40.107.236.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2001FA
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 08:47:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=is7p1JK0PVT2IlZQf7i3aynvMMuLr0ieEXLM5EViQKUS0golh1Pt4c7Cn2X1OZXdYsY8+y9+MU6MuTwXqLzqcGNv3S1C13wQ3OgaQ5LOsDQnyiDLDyN3LZbN1CsCf1X0QFo3soxAPoM52FtF4Dno32ehVahVd+qfTpfrvzjBY96NzRxn4P6sXvEpH1Unm8LYcpuyAvsgpOs/OJBE9Hmo3Zyd/Xo5CkSzMFr+xASyM11aSALUdlhTxsTabVdre38A7kRYMCkimfhl8pcHo4M/05neLDqzJnIW0Ghg5vXBcdoY+OlhTWrqFqv6P0gllj+fruqMdkeEoSvPUbi8o8oRiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=15zw6FKxWDzHQs6r5flPc0K16RGFf3l53zcvMji9Eck=;
 b=fZms6BTSkzfyTuum1tch0l6ryJrUP7pd3++yIGwlHOP8FAE8JwPnswDNFpevvEarveiGClLU3ecfv74rLVkPznrZMWIFOh/DsbtgDwM5koGY0uXZzukEAGNca0kVHLxlYiqqHCo1NW14iaMF4ezZhHtARZIbi0fmxgtM18GaERiSPiCfrUYdg2tAQifBGBsjuFiKNgHEJQGewejUiLkM+y3FhIA0qP9+e8Hfe35U+dZtxwmq78oo9nFhlNkEtUR8Z3rMY2n2b7dQv6YkKwOoJ+PVA1nHSCZjILVF0CMUTGlsK/KOhS3ggS5kGE1wIHUYtm4xAGztapUKkLFMDV5y4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=15zw6FKxWDzHQs6r5flPc0K16RGFf3l53zcvMji9Eck=;
 b=qz6Nu6pyr8ABmVRMo0WXxR0t5bBrCivAMqj7Hpmms6UGjkFh78ithhsfjrwbEoIYyJGgRGernredCxQuVFSaw/R6zw9yAzyQU6ip9H6sX5BZPcgpbPD1L0TK7PaoFLQFiphbvDnJu0n6OYEH77vdZJ4vc+67elKG+qjy4ThBg2FinA5GH1p9S97hYQQth/SarQssKj+JDJo480yUfu02VegNFGmmGEFizrBOUmeW7ldXoxkJjoaIH3n6fvMs+0gH8IIOYWTYdCEujv0Y0AyilI59qWVkXMx9vUQQ0xhPcf3ODNisdwC7XryPr2qTXd6abUEWgJfNfxcnw1Vai6sT8A==
Received: from DM5PR07CA0105.namprd07.prod.outlook.com (2603:10b6:4:ae::34) by
 CY4PR12MB1237.namprd12.prod.outlook.com (2603:10b6:903:3e::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.19; Wed, 9 Mar 2022 16:46:19 +0000
Received: from DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::a7) by DM5PR07CA0105.outlook.office365.com
 (2603:10b6:4:ae::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Wed, 9 Mar 2022 16:46:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT017.mail.protection.outlook.com (10.13.172.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5038.14 via Frontend Transport; Wed, 9 Mar 2022 16:46:18 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 9 Mar
 2022 16:46:17 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 9 Mar 2022
 08:46:16 -0800
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Wed, 9 Mar
 2022 08:46:13 -0800
From:   Eli Cohen <elic@nvidia.com>
To:     <dsahern@kernel.org>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <jasowang@redhat.com>,
        <si-wei.liu@oracle.com>
CC:     <mst@redhat.com>, <lulu@redhat.com>, <parav@nvidia.com>,
        Eli Cohen <elic@nvidia.com>
Subject: [PATCH v5 0/4] vdpa tool enhancements
Date:   Wed, 9 Mar 2022 18:46:05 +0200
Message-ID: <20220309164609.7233-1-elic@nvidia.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7aeba55-104b-49f3-ee63-08da01ec558f
X-MS-TrafficTypeDiagnostic: CY4PR12MB1237:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB12376E45DD5E6C4A3EFD1DD7AB0A9@CY4PR12MB1237.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SN7+i35o1KBR6TQBSmr7s4DY+F4LHi0HhyrepfbNl3UnJIpYzyH3M8uizoeZdZS3RTm5FLrbKLXgOM9eyz5Bt/TZEGS7/+ivKusu+59wXA1gNOiQ1gv4+8liSWqy6+RVZS5QQGQEqxSNaCMWp91ZR7lbpNkx2qQYPGLsMZo1OHQoOZGiQxoVpmmme04PZnhhbF53ZEwHgs9nBierpdlwvHuqNEMMVNgDgH1tSSaCNi09rcOLNttFRI4DuIxwFut4CXNPsjjNgOzg7cPaYSLdVMJbz35aiBz0BAduBIp/gWuiC1tSJP6MA6p4nRjuxwFEERIQ1xO2Qe75GCn6j/gEFlum3lEwODQJc07SLExPa5unv6TjGaiGO4D/woWxPxs0nGcKSsrmb0N31PL5albPCvasU9R5P/mEY1xyEZLDNtJU3eghCY8ucIiSzDiUi+qbIaKECzikmr/PxWygXa6g76CXZ44WO1O/e6uoH8iVaEQSH7SFnIiQM/ANm3wRYuCSaeA69MC5MWeIAhFvc3p5D0nDoveAprziZdtWwiM7kIUi7aXmHTb/4fdMu7ZoEnCwcFuE/8m/jvaGvtQWJ+9M4Yu7uATE6RLiqySPEX1iJZ1ioqH3T6jOOGGHQXwh2jG4A2vWemteSoJGdNbLLGjzjeHitYDEPSx91N3MTWbl6cq+fSyv/pEBNqfGpslwi5U2oi5sNDaQl3x5LWm88bZzYw==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(81166007)(4326008)(47076005)(8676002)(356005)(7696005)(70206006)(70586007)(40460700003)(426003)(36860700001)(82310400004)(508600001)(336012)(6666004)(2906002)(8936002)(36756003)(110136005)(54906003)(5660300002)(1076003)(107886003)(4744005)(83380400001)(2616005)(186003)(26005)(86362001)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 16:46:18.4502
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b7aeba55-104b-49f3-ee63-08da01ec558f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1237
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

this is a resend of v3 which omitted you and netdev from the recepient
list. I added a few "acked-by" and called it v4.

The following four patch series enhances vdpa to show negotiated
features for a vdpa device, max features for a management device and
allows to configure max number of virtqueue pairs.

Jason, Si-Wei
I removed your acked-by and reviewed-by from patch 3 because of the
minor change. Please resend your ack/rb if you're ok with the change.

v4->v5:
1. Minor fix in patch 3/4.
2. Resend the patches with David included in the to list.

Eli Cohen (4):
  vdpa: Remove unsupported command line option
  vdpa: Allow for printing negotiated features of a device
  vdpa: Support for configuring max VQ pairs for a device
  vdpa: Support reading device features

 vdpa/include/uapi/linux/vdpa.h |   4 +
 vdpa/vdpa.c                    | 151 +++++++++++++++++++++++++++++++--
 2 files changed, 148 insertions(+), 7 deletions(-)

-- 
2.35.1

