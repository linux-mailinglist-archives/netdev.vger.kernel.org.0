Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE3A42D42F
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 09:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbhJNH4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 03:56:35 -0400
Received: from mail-mw2nam12on2072.outbound.protection.outlook.com ([40.107.244.72]:37761
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229967AbhJNH4f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 03:56:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ab79bDKLwnXKFjgfOkgiQmotzZWF52vUKlMpGIJVF2L4TE/2xAr5kKPrD6KEbcS7Hz9/3hcfxANYez6f/4VVjqmQonqIznzpxlPBKY/yamzmcrzkP4fJyGvP5ZEo11nxlnKwPAEEFNd+4knb+XBzifqZuMTbcHsf+o5QUtXibGDa0QAklJF8PoBfKVz3/G7siNx4bY1EdlKXeBmQHwcMCDV+18WFWeTAC6eoyzAWsLH1vpjB8xPxdVsY0E6R+NbuQwjbPjU561wugAoF3ACieskIV4E1P4PhPJDdU8BuWrJaHfD/xCMZpz/PUIC+3SOJvL1Xr42U1Raxg5NFaUyJYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LaNzOsusetp+z1abO+MYMRY+/47k7INwryqM3E4J7rw=;
 b=Q1u+xM82/dXiahuFUP6YTNaf1hlTZ1AC6vezM/vEO3xDOXwofHXg02rcaQi1V2sB0aCYPsU051R/ktnSv9ZHAFfBpd3sIoSquBAdz4kqZyOtsZ36eakryXpzcJFyRnnwhnQ00kQvCCns+CWg8ZZkePjaEfMOC86yuSwklYr1CD+iCy4di3/ko75m7L6ZHGoeYtmEyNl9upvpkVim/eEwEgrPG2qePyMsZ2jzxd88E+0RcbrewJDcWYOFhgzeeeE4m/wkV1NFpzuSV1MypK64XwA+Y7Tj1WC9ImJ1K+sqXR2WJ9sn2VAl+vpWOEAN/hk9xqYV3xZkxWjFUN77JlqQ2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LaNzOsusetp+z1abO+MYMRY+/47k7INwryqM3E4J7rw=;
 b=qhw2RG6eWcFF+IjRsqGgzgEwYogvCxMrMTcr3ihK0yuLXhVIxAfxvPkMQjRnSyj1eagfYKwvkwU7SfOSBCLwHNsVDJATNB9DX92A8+3OVSVepxytKoHmDQ0GpRDzElag3ojOTztHWD/+Oqbb6ogQFWhjSeLqaNH5J2Le8s5BuAUzwVgFV+ZA2IZ2Cz4LaIWyyPbQ/9yylwBhDHVpUY93HwvyjCbdcYD810Sq2+ko1c0rrCEQ+lW3dTdi3nI1Ua4u5I/XYFVXKgI8Rg6Eh7WkPXhqJ+amaZudcCCVR18HDZ/bdD1JwH0vXlyzAzDEK/Eu9aLoMO0Ri61y+3cZIQ7gtg==
Received: from DM6PR04CA0021.namprd04.prod.outlook.com (2603:10b6:5:334::26)
 by BN8PR12MB3492.namprd12.prod.outlook.com (2603:10b6:408:67::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25; Thu, 14 Oct
 2021 07:54:28 +0000
Received: from DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:334:cafe::a4) by DM6PR04CA0021.outlook.office365.com
 (2603:10b6:5:334::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend
 Transport; Thu, 14 Oct 2021 07:54:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT039.mail.protection.outlook.com (10.13.172.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Thu, 14 Oct 2021 07:54:28 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 14 Oct
 2021 07:54:26 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 14 Oct 2021 00:54:24 -0700
From:   Mark Zhang <markzhang@nvidia.com>
To:     <jgg@nvidia.com>, <dledford@redhat.com>, <dsahern@gmail.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aharonl@nvidia.com>, <netao@nvidia.com>, <leonro@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>
Subject: [PATCH iproute2-next v1 0/3] Optional counter statistics support
Date:   Thu, 14 Oct 2021 10:53:55 +0300
Message-ID: <20211014075358.239708-1-markzhang@nvidia.com>
X-Mailer: git-send-email 2.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d60e787-6025-43fd-fa8e-08d98ee7d953
X-MS-TrafficTypeDiagnostic: BN8PR12MB3492:
X-Microsoft-Antispam-PRVS: <BN8PR12MB34927B29E169689158D48E48C7B89@BN8PR12MB3492.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bhImpkWtoEd4PuIjTRXD7sEJppoO6vd1QiIc1oNug6IbXQQB2uFmo2Vp/DfXxE9FTBTvDK1duxbRgODx6lEFgj/bCC8ee30jgEoxRLD9uYFkSt7QERUG26HEOi5Ix7JMmWTPoqUy2ryFBg7kyAODU4YcElmLbNw9QsRY9y/q8+vUccv5lPnRmyfFhdat7S5DKpzWbvrdYEvHP1S3Uv+Slr4z2eQaXRjjpDPEllWehIqDRm4S85qr2w0rrKyIPnIzvsJiA2Mio7QzcEpxtPLd6br/Q/wH+AA1gzBPpyzWZacRlUqL2rniW88g57BzpbS90cncCgNW6qgHberoGenNYcqIT92yG5U1Jt/3UAGDTjEUGvvCgAaDv1VMwPnbH+ENKcsElevl+VWWUhMOOJKRFjZNQciR3v2JyQIIyBH3JqT9bSxbRlo8kts1KFfXndlC13dsxWBfo8QN98wUWebcPcA2FV0SHXntq8qpjMVNLtR1IX4AuuWunK06OC2czK1Tyui2dPidrDv23CclUiwBL+9vk8kyRMiBQecSkvyw+zVLW7esbFQioYWk+s6i1B7kpGK+GS2Yo9+QdU1x6HpQkVd0IQ/8L16JehdUH4FxISlVQHEBSuX7sej3NRZ0m/3Gk58podJ05Ec5x4hwlu90J3iYK/f4eeeHO0p4YQhE6mS//dkifXEUmPTPjWsloDUnv1ca7Uu2IYSpwzPEvdfbuML7stS4zBSJTgPfuC9d1FSqQvWLlC1l7tBonpmdms+oBY0Gjc5mBMzScF78Qe5H/xQfijwbEvwygdekpfMcjHJQbiPpbQrcDGyoFAHN+/8vQR1Rhlk9MO4ncNYNI7hxib7/bwWVwyKF60Koyb7nJ5k=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(7636003)(86362001)(426003)(2906002)(36860700001)(966005)(316002)(356005)(82310400003)(1076003)(4326008)(186003)(8936002)(6666004)(336012)(8676002)(508600001)(26005)(107886003)(5660300002)(7696005)(47076005)(54906003)(70206006)(110136005)(70586007)(36756003)(4744005)(83380400001)(2616005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 07:54:28.3155
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d60e787-6025-43fd-fa8e-08d98ee7d953
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3492
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change Log:
v1:
 * Add a new nldev command to get the counter status;
 * Some cosmetic changes.
v0: https://lore.kernel.org/all/20210922093038.141905-1-markzhang@nvidia.com/

----------------------------------------------------------------------
Hi,

This is supplementary part of kernel series [1], which provides an
extension to the rdma statistics tool that allows to set or list
optional counters dynamically, using netlink.

Thanks

[1] https://www.spinics.net/lists/linux-rdma/msg106283.html

Neta Ostrovsky (3):
  rdma: Update uapi headers
  rdma: Add stat "mode" support
  rdma: Add optional-counters set/unset support

 man/man8/rdma-statistic.8             |  55 +++++
 rdma/include/uapi/rdma/rdma_netlink.h |   5 +
 rdma/stat.c                           | 341 ++++++++++++++++++++++++++
 3 files changed, 401 insertions(+)

-- 
2.26.2

