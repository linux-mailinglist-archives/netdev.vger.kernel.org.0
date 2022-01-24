Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC3049833B
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 16:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240611AbiAXPM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 10:12:58 -0500
Received: from mail-dm6nam12on2056.outbound.protection.outlook.com ([40.107.243.56]:17664
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240539AbiAXPM6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 10:12:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l1mNqDda51BqAhALjgC4Df3zcUXCHpDWKyaN9KzDltYVLt8NhT/wBKX6XyG6eevmQUC5YFhY1f0Th0jfXny7yg6QAF4s2xngih4upiev1kcwWHEiAqOQLPhvKa/aDg6SQC4sU1V8Z5uA6r92dCxOJjJYnOLMp+ILLJo9LE86CWkLKAllgfYAspS+8XZpTQqIzXs05rxcLLikCphGXAvBZDRCL6wUTJYKMSTMT4C3iS8+SYs1YLE6yypY6vrBzRZTJk7aE1QqYk0aTAS2ry1K92jWUY+o5/vK4jHf47meYGgpv8hqrZ1DiunikIilTA9QC5MGaS95Gc4MzeCNJvRfIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AaNq99djHBHtZi7wia74TjVtO087RhG6MPM8Qlli1f4=;
 b=CTsU0kIAKz/aZluWmgZWhsOSWGTEv6UFW8z+Cksd+dOOo8NcbsSX+tFqU9k3mnMrS7zMYQE4LzQbKWCTI/nXhFOMhGEc2pdAVwOc4C0x+LIL9v9W8qIeYfE892EU122U848DcoEvtvTS+0V1Sb8Fzp3s0TJBgpX5NQyD5uMl/PEpWNUPFWQs037LFXs+Fcap7C4pANDXX9SbI8FcEj7p02dFP9gyfRx682+0exc9CVE9m0iUmXdhePYUH4SfOSGgV3A+eODiEowvw4y9aaFbAW/Qv5glTaQA3KmclkuaJUdyqm5lGJRmftLdDCGDQYa3Y4e6KN2SwckuDAjV7i/rrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=fb.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AaNq99djHBHtZi7wia74TjVtO087RhG6MPM8Qlli1f4=;
 b=Nd1K1xeVvRYyzlhON5sN0AEw7ilI38/fwFUJA/4LnSrmfgYN+Swri+SVRsu1TIggp/1LB5zLMs1AJpFniOThy6GZl211Xe5NpPCFd24K+n5xJ6NUZXh+Z0zrxVhTajwHzhLZJXj/SwIygX+B4m5/GPSB6jPhBbZSnGymw0fV+kBOXG0rXQ/DY3BgVxnYaCT5yBP4XxpvtHeUoGiLeVm9XCgfXKdEu4oa9FANrBqQI8yp8yuKaeBJssrZUrqye6sf8R/U4nmXpeb6omZVoS88C1I20h1My8eo7nTxN1dfcYn+dnK0J9wPDLYocO4cEa75BWygVeOlr0MpwkUj59oH4A==
Received: from BN1PR14CA0003.namprd14.prod.outlook.com (2603:10b6:408:e3::8)
 by CY4PR12MB1653.namprd12.prod.outlook.com (2603:10b6:910:f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Mon, 24 Jan
 2022 15:12:56 +0000
Received: from BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e3:cafe::f5) by BN1PR14CA0003.outlook.office365.com
 (2603:10b6:408:e3::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7 via Frontend
 Transport; Mon, 24 Jan 2022 15:12:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT029.mail.protection.outlook.com (10.13.177.68) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Mon, 24 Jan 2022 15:12:55 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Mon, 24 Jan 2022 15:12:55 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Mon, 24 Jan 2022 07:12:54 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Mon, 24 Jan 2022 07:12:50 -0800
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>
CC:     Tariq Toukan <tariqt@nvidia.com>, Martin KaFai Lau <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH bpf v2 0/4] Bugfixes for syncookie BPF helpers
Date:   Mon, 24 Jan 2022 17:11:42 +0200
Message-ID: <20220124151146.376446-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db380f50-d35d-4310-3ab8-08d9df4bffed
X-MS-TrafficTypeDiagnostic: CY4PR12MB1653:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1653CE9C2C3A772414B844CDDC5E9@CY4PR12MB1653.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DpE3uyhSbsvYFyYBswCHda7dJEhCB9zatxVeu0LTkjD6cjDjBbxacs3R/ruRhJMsAlwmZssnQFepwvT7o5UgeBl1Cpj/ns7Rc2X2MMe/YFoniIljqndun5C7V6eDZqRk+GAWdKhmvNmMFG+w3D/AC2xJoVUI41xvmu8Z39zf6xarzaoUqsm/Kj3HJ321wpqnqU3BSSxft/G7JzEfz7NXl/+Jo7l7o8MlA1+GJ11Wx5CnIlRc+CEgAWbtdDL2IYISyBwYV17uMiIqV/5cLEQw74mNpf4g9a6KU/DHeVuRFOWHHzemzps6t3fTeuATBVxjNtxKka0YkuvFLBYwO2qKLrpTGahlyTdv2fqlIsxs8iKgojWr2Ppht6bSQy9B0CC7XY4VIbpgygkaecFLpiG1/JP4zA5LD96KWBkdk84QdG7I1F5CMmTQPy4tnjUZMc8vb7p4+op9rbJl8Dh9OoVY+N7CrkDCbrh2HF0OQ1ST7S5MlHUDEU5BXsDjWF+OglWEaJ9sA6f0TxHSM4gxS3zCvUuf1mZH5xZP1qZx/R2mJi6regQxlJAHujlD10axMx6LlTI1/GnJ93hc/mnjEUdHUpdsKjtXWtfXo3vLi11SvQ/ajmv8wrFYxCRLAP05ZctlRXAmYgCQwvwQ2BkBv8YKFLealQ4XMkydqRM3AZDcLE0DDX2UjRuKdhko4ZqVXQWs7F6L/ewgYTQQqLUrircdQnC219piIb+Hu6P0sEa4OxpT8e1jgZ0BhWWFS+IZD0n32TzVPIGwyuj+ybJgLG/DRjvv1WiLX6+h1zMY/AcOjtrt+A/23Fiu1fH3Bcyp0bFhbYzHXRtqqR2NWONMQB+/d5lb/pkflEU5lknUFgDkpgFtAxNHLLsitz6QGEDMUhdd
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700004)(966005)(5660300002)(81166007)(83380400001)(8676002)(6666004)(356005)(2906002)(7416002)(26005)(107886003)(86362001)(2616005)(36756003)(82310400004)(4326008)(4744005)(186003)(36860700001)(508600001)(336012)(8936002)(7696005)(40460700003)(70206006)(426003)(54906003)(1076003)(47076005)(70586007)(316002)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 15:12:55.7039
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db380f50-d35d-4310-3ab8-08d9df4bffed
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1653
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains generic bugfixes for the syncookie BPF helpers. It
used to be part of series [1], but has been separated to apply to the
bpf branch as fixes.

[1]: https://lore.kernel.org/bpf/20211020095815.GJ28644@breakpoint.cc/t/

Maxim Mikityanskiy (4):
  bpf: Use ipv6_only_sock in bpf_tcp_gen_syncookie
  bpf: Support dual-stack sockets in bpf_tcp_check_syncookie
  bpf: Use EOPNOTSUPP in bpf_tcp_check_syncookie
  bpf: Fix documentation of th_len in bpf_tcp_{gen,check}_syncookie

 include/uapi/linux/bpf.h       |  6 ++++--
 net/core/filter.c              | 21 +++++++++++++++------
 tools/include/uapi/linux/bpf.h |  6 ++++--
 3 files changed, 23 insertions(+), 10 deletions(-)

-- 
2.30.2

